pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // Set the total shares and annual distribution
    uint total_shares = 1000; // initial grant 1000 shares

    uint start_time = now; // permanently store the time this contract was initialized
    //uint public fakenow = now;

    // Set the `unlock_time` to be 365 days from now
    uint unlock_time = now + 365 days;

    uint distributed_shares = 0; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
        distributed_shares = 0;
    }
    /*
    function fastforward() public {
        fakenow += 366 days;
    }
    */
    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");

        require(unlock_time < now && distributed_shares < total_shares, "All shares are distributed");
        // require(unlock_time < fakenow && distributed_shares < total_shares, "All shares are distributed");


        distributed_shares = (now - start_time) / (365 * 24 * 60 * 60) * (total_shares / 4);
        // distributed_shares = (fakenow - start_time) / (365 * 24 * 60 * 60) * (total_shares / 4);
        
        unlock_time = now + 365 days;
        // unlock_time = fakenow + 365 days;

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares >= total_shares) {
            distributed_shares = total_shares;
            active = false;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
