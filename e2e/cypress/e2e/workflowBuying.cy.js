describe('DemoBlaze purchase workflow.', () => {
    // Workflow defined by Andrés Rosero
    // email: andres.rosero@outlook.com
    // contact: +593 99 235 692

    let testData;
    beforeEach(() => {
        cy.fixture('data.json').then((data) => {
            testData = data;
        });
    });

    it('Add two products into the cart and complete the purchase', () => {
        // Visiting the main page
        cy.visit(testData.testWebPageMain);
        cy.document().its('readyState').should('eq', 'complete')
        cy.log(testData.step1);
        cy.screenshot(testData.step1);

        // First product
        cy.contains('a', testData.productName1).click();
        cy.contains('a', testData.messageAddToCart).click();
        cy.on('window:alert', (message) => {
            expect(message).to.contain(testData.messageProductAdded)
        })
        cy.go('back');
        cy.go('back');
        cy.log(testData.step2);
        cy.screenshot(testData.step2);

        // Second product
        cy.contains('a', testData.productName2).click();
        cy.contains('a', testData.messageAddToCart).click();
        cy.on('window:alert', (message) => {
            expect(message).to.contain(testData.messageProductAdded)
        })
        cy.go('back');
        cy.go('back');
        cy.log(testData.step3);
        cy.screenshot(testData.step3);

        // Check the cart
        cy.visit(testData.testWebPageMain + testData.testWebPageCart);
        cy.document().its('readyState').should('eq', 'complete')

        cy.get('#tbodyid tr').should('have.length.at.least', 2);
        cy.log(testData.step4);
        cy.screenshot(testData.step4);

        // Adding the form information
        cy.contains('Place Order').click();
        cy.get('#name').type(testData.name);
        cy.get('#country').type(testData.country);
        cy.get('#city').type(testData.city);
        cy.get('#card').type(testData.card);
        cy.get('#month').type(testData.month);
        cy.get('#year').type(testData.year);
        cy.log(testData.step5);
        cy.screenshot(testData.step5);

        cy.contains('Purchase').click();

        // Verification of the final end process message.
        cy.contains(testData.messagePurchaseReady).should('be.visible');
        cy.log(testData.step6);
        cy.screenshot(testData.step6);
    });
});