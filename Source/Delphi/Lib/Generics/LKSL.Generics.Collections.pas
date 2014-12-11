{
  LaKraven Studios Standard Library [LKSL]
  Copyright (c) 2014, LaKraven Studios Ltd, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/LKSL

  License:
    - You may use this library as you see fit, including use within commercial applications.
    - You may modify this library to suit your needs, without the requirement of distributing
      modified versions.
    - You may redistribute this library (in part or whole) individually, or as part of any
      other works.
    - You must NOT charge a fee for the distribution of this library (compiled or in its
      source form). It MUST be distributed freely.
    - This license and the surrounding comment block MUST remain in place on all copies and
      modified versions of this source code.
    - Modified versions of this source MUST be clearly marked, including the name of the
      person(s) and/or organization(s) responsible for the changes, and a SEPARATE "changelog"
      detailing all additions/deletions/modifications made.

  Disclaimer:
    - Your use of this source constitutes your understanding and acceptance of this
      disclaimer.
    - LaKraven Studios Ltd and its employees (including but not limited to directors,
      programmers and clerical staff) cannot be held liable for your use of this source
      code. This includes any losses and/or damages resulting from your use of this source
      code, be they physical, financial, or psychological.
    - There is no warranty or guarantee (implicit or otherwise) provided with this source
      code. It is provided on an "AS-IS" basis.

  Donations:
    - While not mandatory, contributions are always appreciated. They help keep the coffee
      flowing during the long hours invested in this and all other Open Source projects we
      produce.
    - Donations can be made via PayPal to PayPal [at] LaKraven (dot) Com
                                          ^  Garbled to prevent spam!  ^
}
unit LKSL.Generics.Collections;

interface

{$I LKSL.inc}

{
  About this unit:
    - This unit provides useful enhancements for Generics types used in the LKSL.
}

uses
  {$IFDEF LKSL_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF LKSL_USE_EXPLICIT_UNIT_NAMES}
  Generics.Defaults,
  Generics.Collections,
  LKSL.Common.Types;

type
  { Forward Declaration }
  TLKArray<T> = class;
  TLKDictionary<TKey, TValue> = class;
  TLKList<T> = class;
  TLKObjectList<T: class> = class;
  TLKCenteredList<T> = class;

  { Enum Types }
  TLKListDirection = (ldLeft, ldRight);

  { Exception Types }
  ELKGenericCollectionsException = class(ELKException);
    ELKGenericCollectionsLimitException = class(ELKGenericCollectionsException);
    ELKGenericCollectionsRangeException = class(ELKGenericCollectionsException);

  {
    TLKArray<T>
      - Provides a Thread-Safe Lock (TCriticalSection)
      - A very simple "Managed Array" for items of the nominated type.
      - Items are UNSORTED
      - The Array expands by 1 each time a new item is added
      - The Array collapses by 1 each time an item is removed
      - If referencing the "ArrayRaw" property, don't forget to call "Lock" and "Unlock" manually!
  }
  TLKArray<T> = class(TLKPersistent)
  type
    TLKArrayType = Array of T;
  private
    FArray: TLKArrayType;
    FLock: TCriticalSection;

    // Getters
    function GetItem(const AIndex: Integer): T;

    // Setters
    procedure SetItem(const AIndex: Integer; const AItem: T);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Lock; inline;
    procedure Unlock; inline;

    function Add(const AItem: T): Integer;
    procedure Clear; inline;
    procedure Delete(const AIndex: Integer); virtual;

    property ArrayRaw: TLKArrayType read FArray;
    property Items[const AIndex: Integer]: T read GetItem write SetItem;
  end;

  {
    TLKDictionary<TKey, TValue>
      - Provides a Thread-Safe Lock (TCriticalSection)
  }
  TLKDictionary<TKey, TValue> = class(TDictionary<TKey, TValue>)
  private
    FLock: TCriticalSection;
  public
    constructor Create(ACapacity: Integer = 0); reintroduce; overload;
    constructor Create(const AComparer: IEqualityComparer<TKey>); reintroduce; overload;
    constructor Create(ACapacity: Integer; const AComparer: IEqualityComparer<TKey>); reintroduce; overload;
    constructor Create(const Collection: TEnumerable<TPair<TKey,TValue>>); reintroduce; overload;
    constructor Create(const Collection: TEnumerable<TPair<TKey,TValue>>; const AComparer: IEqualityComparer<TKey>); reintroduce; overload;
    destructor Destroy; override;

    procedure Lock; inline;
    procedure Unlock; inline;
  end;

  {
    TLKList<T>
      - Provides a Thread-Safe Lock (TCriticalSection)
  }
  TLKList<T> = class(TList<T>)
  private
    FLock: TCriticalSection;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Lock; inline;
    procedure Unlock; inline;
  end;

  {
    TLKObjectList<T: class>
      - Provides a Thread-Safe Lock (TCriticalSection)
  }
  TLKObjectList<T: class> = class(TObjectList<T>)
  private
    FLock: TCriticalSection;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Lock; inline;
    procedure Unlock; inline;
  end;

  {
    TLKCenteredList
      - A special Generic List object which allows the use of both positive and NEGATIVE indices!
      - Essentially, we're cheating: using two Arrays (and a singular instance to represent index 0)
        - Any LEFT (negative) assignment goes on the end of the LEFT Array, any RIGHT (positive)
          assignment goes on the end of the RIGHT Array.
        - In a sense, this means you have a combined Queue AND Stack acting like a singular Array.
  }
  TLKCenteredList<T> = class(TPersistent)
  private
    type
      TArrayOfT = Array of T;
  private
    // Counts
    FCountLeft: Integer;
    FCountRight: Integer;
    // Locks
    FLockCenter: TCriticalSection;
    FLockLeft: TCriticalSection;
    FLockRight: TCriticalSection;
    // Arrays (and Center)
    FArrayLeft: TArrayOfT;
    FArrayRight: TArrayOfT;
    FCenter: T;
    // Capacity
    FCapacityMultiplier: Single;
    FCapacityThreshold: Integer;
    // Necessary Other Stuff
    FCenterAssigned: Boolean;

    // Capacity Checks
    procedure CheckCapacityLeft;
    procedure CheckCapacityRight;
    // Deletes
    procedure DeleteCenter;
    procedure DeleteLeft(const AIndex: Integer);
    procedure DeleteRight(const AIndex: Integer);
    // Capacity Getters
    function GetCapacity: Integer; // GetCapacityLeft + GetCapacityRight + 1
    function GetCapacityLeft: Integer; // Size of FArrayLeft
    function GetCapacityRight: Integer; // Size of FArrayRight
    function GetCapacityMultiplier: Single;
    function GetCapacityThreshold: Integer;
    // Count Getters
    function GetCount: Integer; // GetCountLeft + GetCountRight + FCenterAssigned
    function GetCountLeft: Integer; // Number of Items in FArrayLeft
    function GetCountRight: Integer; // Number of Items in FArrayRight
    // Item Getters
    function GetItemByIndex(const AIndex: Integer): T;
    function GetItemCenter: T;
    function GetItemLeft(const AIndex: Integer): T;
    function GetItemRight(const AIndex: Integer): T;
    // Range Getters
    function GetRangeLow: Integer;
    function GetRangeHigh: Integer;
    // General
    function TryCenterAvailable(const AItem: T): Boolean;

    // Capacity Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single);
    procedure SetCapacityThreshold(const AThreshold: Integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function Add(const AItem: T; const ADirection: TLKListDirection = ldRight): Integer; overload; virtual;
    procedure Add(const AItems: TArrayOfT; const ADirection: TLKListDirection = ldRight); overload; virtual;
    function AddLeft(const AItem: T): Integer; virtual;
    function AddRight(const AItem: T): Integer; virtual;

    procedure Compact;

    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure Delete(const AIndices: Array of Integer); overload; virtual;
    procedure DeleteRange(const ALow, AHigh: Integer); virtual;

    procedure Lock; inline;
    procedure LockCenter; inline;
    procedure LockLeft; inline;
    procedure LockRight; inline;

    procedure Unlock; inline;
    procedure UnlockCenter; inline;
    procedure UnlockLeft; inline;
    procedure UnlockRight; inline;

    // Capacity Properties
    property Capacity: Integer read GetCapacity;
    property CapacityLeft: Integer read GetCapacityLeft;
    property CapacityRight: Integer read GetCapacityRight;
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
    // Count Properties
    property Count: Integer read GetCount;
    property CountLeft: Integer read GetCountLeft;
    property CountRight: Integer read GetCountRight;
    // Item Properties
    property Items[const AIndex: Integer]: T read GetItemByIndex; default;
    // Range Properties
    property Low: Integer read GetRangeLow;
    property High: Integer read GetRangeHigh;
  end;

implementation

{ TLKArray<T> }

function TLKArray<T>.Add(const AItem: T): Integer;
begin
  Result := Length(FArray);
  SetLength(FArray, Result + 1);
  FArray[Result] := AItem;
end;

procedure TLKArray<T>.Clear;
begin
  SetLength(FArray, 0);
end;

constructor TLKArray<T>.Create;
begin
  inherited;
  FLock := TCriticalSection.Create;
end;

procedure TLKArray<T>.Delete(const AIndex: Integer);
var
  I: Integer;
begin
  Lock;
  try
    for I := AIndex to Length(FArray) - 2 do
      FArray[I] := FArray[I + 1];

    SetLength(FArray, Length(FArray) - 1);
  finally
    Unlock;
  end;
end;

destructor TLKArray<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TLKArray<T>.GetItem(const AIndex: Integer): T;
begin
  Lock;
  try
    Result := FArray[AIndex];
  finally
    Unlock;
  end;
end;

procedure TLKArray<T>.Lock;
begin
  FLock.Acquire;
end;

procedure TLKArray<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  Lock;
  try
    FArray[AIndex] := AItem;
  finally
    Unlock;
  end;
end;

procedure TLKArray<T>.Unlock;
begin
  FLock.Release;
end;

{ TLKDictionary<TKey, TValue> }

constructor TLKDictionary<TKey, TValue>.Create(const AComparer: IEqualityComparer<TKey>);
begin
  FLock := TCriticalSection.Create;
  inherited Create(AComparer);
end;

constructor TLKDictionary<TKey, TValue>.Create(ACapacity: Integer);
begin
  FLock := TCriticalSection.Create;
  inherited Create(ACapacity);
end;

constructor TLKDictionary<TKey, TValue>.Create(ACapacity: Integer; const AComparer: IEqualityComparer<TKey>);
begin
  FLock := TCriticalSection.Create;
  inherited Create(ACapacity, AComparer);
end;

constructor TLKDictionary<TKey, TValue>.Create(const Collection: TEnumerable<TPair<TKey, TValue>>; const AComparer: IEqualityComparer<TKey>);
begin
  FLock := TCriticalSection.Create;
  inherited Create(Collection, AComparer);
end;

constructor TLKDictionary<TKey, TValue>.Create(const Collection: TEnumerable<TPair<TKey, TValue>>);
begin
  FLock := TCriticalSection.Create;
  inherited Create(Collection);
end;

destructor TLKDictionary<TKey, TValue>.Destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TLKDictionary<TKey, TValue>.Lock;
begin
  FLock.Acquire;
end;

procedure TLKDictionary<TKey, TValue>.Unlock;
begin
  FLock.Release;
end;

{ TLKList<T> }

constructor TLKList<T>.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
end;

destructor TLKList<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TLKList<T>.Lock;
begin
  FLock.Acquire;
end;

procedure TLKList<T>.Unlock;
begin
  FLock.Release;
end;

{ TLKObjectList<T> }

constructor TLKObjectList<T>.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
end;

destructor TLKObjectList<T>.Destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TLKObjectList<T>.Lock;
begin
  FLock.Acquire;
end;

procedure TLKObjectList<T>.Unlock;
begin
  FLock.Release;
end;

{ TLKCenteredList<T> }

function TLKCenteredList<T>.Add(const AItem: T; const ADirection: TLKListDirection): Integer;
begin
  case ADirection of
    ldLeft: Result := AddLeft(AItem);
    ldRight: Result := AddRight(Aitem);
  end;
end;

procedure TLKCenteredList<T>.Add(const AItems: TArrayOfT; const ADirection: TLKListDirection);
var
  I: Integer;
begin
  for I := System.Low(AItems) to System.High(AItems) do
    Add(AItems[I], ADirection);
end;

function TLKCenteredList<T>.AddLeft(const AItem: T): Integer;
begin
  if (TryCenterAvailable(AItem)) then
    Result := 0
  else
  begin
    LockLeft;
    try
      Result := FCountLeft;
      FArrayLeft[Result] := AItem;
      Inc(FCountLeft);
      CheckCapacityLeft;
    finally
      UnlockLeft;
    end;
  end;
end;

function TLKCenteredList<T>.AddRight(const AItem: T): Integer;
begin
  if (TryCenterAvailable(AItem)) then
    Result := 0
  else
  begin
    LockRight;
    try
      Result := FCountRight;
      FArrayRight[Result] := AItem;
      Inc(FCountRight);
      CheckCapacityRight;
    finally
      UnlockRight;
    end;
  end;
end;

procedure TLKCenteredList<T>.CheckCapacityLeft;
begin
  LockLeft;
  try
    if ((Length(FArrayLeft) - FCountLeft) < FCapacityThreshold) then
      SetLength(FArrayLeft, Round(Length(FArrayLeft) * FCapacityMultiplier));
  finally
    UnlockLeft;
  end;
end;

procedure TLKCenteredList<T>.CheckCapacityRight;
begin
  LockRight;
  try
    if ((Length(FArrayRight) - FCountRight) < FCapacityThreshold) then
      SetLength(FArrayRight, Round(Length(FArrayRight) * FCapacityMultiplier));
  finally
    UnlockRight;
  end;
end;

procedure TLKCenteredList<T>.Compact;
begin
  Lock;
  try
    SetLength(FArrayLeft, (Length(FArrayLeft) - FCountLeft) + FCapacityThreshold + 1);
    SetLength(FArrayRight, (Length(FArrayRight) - FCountRight) + FCapacityThreshold + 1);
  finally
    Unlock;
  end;
end;

constructor TLKCenteredList<T>.Create;
begin
  inherited Create;
  FCenterAssigned := False;
  FCountLeft := 0;
  FCountRight := 0;
  FLockLeft := TCriticalSection.Create;
  FLockRight := TCriticalSection.Create;
  FLockCenter := TCriticalSection.Create;
  // We default the Capacity of the Left and Right Arrays to 10 each.
  // This equates to 21 default Capacity (including Center)
  SetLength(FArrayLeft, 10);
  SetLength(FArrayRight, 10);
  FCapacityThreshold := 5;
  FCapacityMultiplier := 1.5;
end;

procedure TLKCenteredList<T>.Delete(const AIndex: Integer);
begin
  if AIndex = 0 then
    DeleteCenter
  else if AIndex < 0 then
    DeleteLeft((-AIndex) - 1) // Invert AIndex to provide a positive index
  else
    DeleteRight(AIndex - 1);
end;

procedure TLKCenteredList<T>.Delete(const AIndices: array of Integer);
var
  I: Integer;
begin
  Lock;
  try
    for I := System.Low(AIndices) to System.High(AIndices) do
      Delete(AIndices[I]);
  finally
    Unlock;
  end;
end;

procedure TLKCenteredList<T>.DeleteCenter;
var
  I: Integer;
begin
  LockCenter;
  LockRight;
  try
    if not (FCenterAssigned) then
      raise ELKGenericCollectionsRangeException.Create('Index Out of Bounds: 0')
    else begin
      if FCountRight > 0 then
      begin
        FCenter := FArrayRight[0];
        for I := 1 to System.High(FArrayRight) do
          FArrayRight[I - 1] := FArrayright[I];
        Dec(FCountRight);
      end else
        FCenterAssigned := False;
    end;
  finally
    UnlockCenter;
    UnlockRight;
  end;
end;

procedure TLKCenteredList<T>.DeleteLeft(const AIndex: Integer);
var
  I: Integer;
begin
  LockLeft;
  try
    if AIndex < FCountLeft then
    begin
      for I := AIndex to FCountLeft - 1 do
        FArrayLeft[I] := FArrayLeft[I + 1];
      Dec(FCountLeft);
    end else
      raise ELKGenericCollectionsRangeException.CreateFmt('Index Out of Bounds: %d', [-(AIndex + 1)]);
  finally
    UnlockLeft;
  end;
end;

procedure TLKCenteredList<T>.DeleteRange(const ALow, AHigh: Integer);
var
  I: Integer;
begin
  Lock;
  try
    for I := ALow to AHigh do
      Delete(I);
  finally
    Unlock;
  end;
end;

procedure TLKCenteredList<T>.DeleteRight(const AIndex: Integer);
var
  I: Integer;
begin
  LockRight;
  try
    if AIndex < FCountRight then
    begin
      for I := AIndex to FCountRight - 1 do
        FArrayRight[I] := FArrayRight[I + 1];
      Dec(FCountRight);
    end else
      raise ELKGenericCollectionsRangeException.CreateFmt('Index Out of Bounds: %d', [AIndex + 1]);
  finally
    UnlockRight;
  end;
end;

destructor TLKCenteredList<T>.Destroy;
begin
  FLockLeft.Free;
  FLockRight.Free;
  FLockCenter.Free;
  inherited;
end;

function TLKCenteredList<T>.GetCapacity: Integer;
begin
  Result := Length(FArrayLeft) + Length(FArrayRight) + 1;
end;

function TLKCenteredList<T>.GetCapacityLeft: Integer;
begin
  LockLeft;
  try
    Result := Length(FArrayLeft);
  finally
    UnlockLeft;
  end;
end;

function TLKCenteredList<T>.GetCapacityMultiplier: Single;
begin
  Lock;
  try
    Result := FCapacityMultiplier;
  finally
    Unlock;
  end;
end;

function TLKCenteredList<T>.GetCapacityRight: Integer;
begin
  LockRight;
  try
    Result := Length(FArrayRight);
  finally
    UnlockRight;
  end;
end;

function TLKCenteredList<T>.GetCapacityThreshold: Integer;
begin
  Lock;
  try
    Result := FCapacityThreshold;
  finally
    Unlock;
  end;
end;

function TLKCenteredList<T>.GetCount: Integer;
const
  // Ordinarily, if Center isn't assigned, then the Count will be 0 anyway!
  // There is the possibility of exceptions to this general rule, however!
  CENTER_ADDITION: Array[Boolean] of Integer = (0, 1);
begin
  Lock;
  try
    Result := GetCountLeft + GetCountRight + CENTER_ADDITION[FCenterAssigned];
  finally
    Unlock;
  end;
end;

function TLKCenteredList<T>.GetCountLeft: Integer;
begin
  LockLeft;
  try
    Result := FCountLeft;
  finally
    UnlockLeft;
  end;
end;

function TLKCenteredList<T>.GetCountRight: Integer;
begin
  LockRight;
  try
    Result := FCountRight;
  finally
    UnlockRight;
  end;
end;

function TLKCenteredList<T>.GetItemByIndex(const AIndex: Integer): T;
begin
  if AIndex = 0 then
    Result := GetItemCenter
  else if AIndex < 0 then
    Result := GetItemLeft((-AIndex) - 1)
  else
    Result := GetItemRight(AIndex - 1);
end;

function TLKCenteredList<T>.GetItemCenter: T;
begin
  LockCenter;
  try
    if FCenterAssigned then
      Result := FCenter
    else
      raise ELKGenericCollectionsRangeException.Create('Index Out of Bounds: 0');
  finally
    UnlockCenter;
  end;
end;

function TLKCenteredList<T>.GetItemLeft(const AIndex: Integer): T;
begin
  LockLeft;
  try
    if AIndex < FCountLeft then
      Result := FArrayLeft[AIndex]
    else
      raise ELKGenericCollectionsRangeException.CreateFmt('Index Out of Bounds: %d', [-(AIndex + 1)]);
  finally
    UnlockLeft;
  end;
end;

function TLKCenteredList<T>.GetItemRight(const AIndex: Integer): T;
begin
  LockRight;
  try
    if AIndex < FCountRight then
      Result := FArrayRight[AIndex]
    else
      raise ELKGenericCollectionsRangeException.CreateFmt('Index Out of Bounds: %d', [AIndex]);
  finally
    UnlockRight;
  end;
end;

function TLKCenteredList<T>.GetRangeHigh: Integer;
begin
  LockRight;
  try
    Result := FCountRight;
  finally
    UnlockRight;
  end;
end;

function TLKCenteredList<T>.GetRangeLow: Integer;
begin
  LockLeft;
  try
    Result := -FCountLeft;
  finally
    UnlockLeft;
  end;
end;

procedure TLKCenteredList<T>.Lock;
begin
  LockCenter;
  LockLeft;
  LockRight;
end;

procedure TLKCenteredList<T>.LockCenter;
begin
  FLockCenter.Acquire;
end;

procedure TLKCenteredList<T>.LockLeft;
begin
  FLockLeft.Acquire;
end;

procedure TLKCenteredList<T>.LockRight;
begin
  FLockRight.Acquire;
end;

procedure TLKCenteredList<T>.SetCapacityMultiplier(const AMultiplier: Single);
begin
  // Sanity Check on Multiplier
  if AMultiplier < 1.10 then
    raise ELKGenericCollectionsLimitException.Create('Minimum Capacity Multiplier is 1.10')
  else if AMultiplier > 3.00 then
    raise ELKGenericCollectionsLimitException.Create('Maximum Capacity Multiplier is 3.00');
  // If we got this far, we're ready to change our Multiplier
  Lock;
  try
    FCapacityMultiplier := AMultiplier;
  finally
    Unlock;
  end;
end;

procedure TLKCenteredList<T>.SetCapacityThreshold(const AThreshold: Integer);
begin
  // Sanity Check on Threshold
  if AThreshold < 5 then
    raise ELKGenericCollectionsLimitException.Create('Minimum Capacity Threshold is 5');
  // If we got this far, we're ready to change our Threshold
  Lock;
  try
    FCapacityThreshold := AThreshold;
    CheckCapacityLeft; // Adjust the Left Array Capacity if necessary
    CheckCapacityRight; // Adjust the Right Array Capacity if necessary
  finally
    Unlock;
  end;
end;

function TLKCenteredList<T>.TryCenterAvailable(const AItem: T): Boolean;
begin
  Result := False;
  LockCenter;
  try
    if not (FCenterAssigned) then
    begin
      Result := True;
      FCenter := AItem;
      FCenterAssigned := True;
    end;
  finally
    UnlockCenter;
  end;
end;

procedure TLKCenteredList<T>.Unlock;
begin
  UnlockCenter;
  UnlockLeft;
  UnlockRight;
end;

procedure TLKCenteredList<T>.UnlockCenter;
begin
  FLockCenter.Release;
end;

procedure TLKCenteredList<T>.UnlockLeft;
begin
  FLockLeft.Release;
end;

procedure TLKCenteredList<T>.UnlockRight;
begin
  FLockRight.Release;
end;

end.
