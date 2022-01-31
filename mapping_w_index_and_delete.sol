// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

contract mappedWithUnorderedIndexAndDelete {

  struct EntityStruct {
    uint entityData;
    //can add more data
    uint listPointer; //0
  }

  mapping(address => EntityStruct) public entityStructs;
  address[] public entityList;

  function isEntity(address entityAddress) public view returns(bool isIndeed) {
    if(entityList.length == 0) return false;
    return (entityList[entityStructs[entityAddress].listPointer] == entityAddress);
  }

  function getEntityCount() public view returns(uint entityCount) {
    return entityList.length;
  }

  function newEntity(address entityAddress, uint entityData) public returns(bool success) {
    //check if entity already exists  
    if(isEntity(entityAddress)) revert();
    //set entity data to input
    entityStructs[entityAddress].entityData = entityData;
    //add to array
    entityList.push(entityAddress);
    //set pointer to length of array -1
    entityStructs[entityAddress].listPointer = entityList.length - 1;
    return true;
  }

  //functionality to update entity
  function updateEntity(address entityAddress, uint entityData) public returns(bool success) {
    //use of require instead of if statement  
    require(!isEntity(entityAddress));
    //replace data with new data
    entityStructs[entityAddress].entityData = entityData;
    return true;
  }
  
  //[ADDRESS1, ADDRESS4, ADDRESS3]

  function deleteEntity(address entityAddress) public returns(bool success) {
    if(!isEntity(entityAddress)) revert();
    uint rowToDelete = entityStructs[entityAddress].listPointer; // = 1
    address keyToMove   = entityList[entityList.length-1]; //save address4
    entityList[rowToDelete] = keyToMove;
    entityStructs[keyToMove].listPointer = rowToDelete; //= 2
    entityList.pop();
    delete entityStructs[entityAddress];
    return true;
  }

}