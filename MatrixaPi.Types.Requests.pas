﻿unit MatrixaPi.Types.Requests;

interface

uses
  System.JSON,
  System.JSON.Serializers,
  Citrus.Mandarin;

type

  TmtxSyncRequest = class(TInterfacedObject, IMandarinBuider)
  public type
{$SCOPEDENUMS ON}
    TPresence = (Fffline, Fnline, Unavailable);
{$SCOPEDENUMS OFF}
  private
    FMandarin: IMandarin;
  public
    constructor Create;
    function SetFilter(const AFilter: string): TmtxSyncRequest;
    function SetFullState(const AFullState: Boolean): TmtxSyncRequest;
    function SetPresence(const APresence: TPresence): TmtxSyncRequest;
    function SetSince(const ASince: string): TmtxSyncRequest;
    function SetTimeout(const ATimeout: Integer): TmtxSyncRequest;
    function Build: IMandarin;
  end;

  TmtxPublicRoomRequest = class(TInterfacedObject, IMandarinBuider)
  private
    FMandarin: IMandarin;
  public
    constructor Create;
    function Build: IMandarin;

    /// <summary>
    /// The server to fetch the public room lists from. Defaults to the local server.
    /// </summary>
    function SetServer(const AServer: string): TmtxPublicRoomRequest;
    /// <summary>
    /// Filter to apply to the results.
    /// </summary>
    /// <param name='AGenericSearchTerm'>An optional string to search for in the room
    /// metadata, e.g. name, topic, canonical alias, etc.</param> <param
    /// name='ARoomTypes'>An optional list of room types to search for. To include
    /// rooms without a room type, specify null within this list. When not specified,
    /// all applicable rooms (regardless of type) are returned.
    /// Added in v1.4</param>
    function SetFilter(const AGenericSearchTerm: string; ARoomTypes: TArray<string>): TmtxPublicRoomRequest;

    /// <summary>
    /// Whether or not to include all known networks/protocols from application
    /// services on the homeserver. Defaults to false.
    /// </summary>
    function IncludeAllNetworks(const AIncludeAllNetworks: Boolean): TmtxPublicRoomRequest;
    /// <summary>
    /// Limit the number of results returned.
    /// </summary>
    function SetLimit(const ALimit: Integer): TmtxPublicRoomRequest;
    /// <summary>
    /// A pagination token from a previous request, allowing clients to get the next (
    /// or previous) batch of rooms. The direction of pagination is specified solely by
    /// which token is supplied, rather than via an explicit flag.
    /// </summary>
    function SetSince(const ASince: string): TmtxPublicRoomRequest;
    /// <summary>
    /// The specific third party network/protocol to request from the homeserver. Can
    /// only be used if include_all_networks is false.
    /// </summary>
    function SetThirdPartyInstanceId(const AId: string): TmtxPublicRoomRequest;
  end;

implementation

uses
  System.SysUtils;

function TmtxSyncRequest.Build: IMandarin;
begin
  Result := FMandarin;
end;

constructor TmtxSyncRequest.Create;
begin
  inherited Create;
  FMandarin := TMandarin.Create();
end;

{ TmtxSyncRequest }

function TmtxSyncRequest.SetFilter(const AFilter: string): TmtxSyncRequest;
begin
  FMandarin.AddQueryParameter('filter', AFilter);
  Result := Self;
end;

function TmtxSyncRequest.SetFullState(const AFullState: Boolean): TmtxSyncRequest;
begin
  FMandarin.AddQueryParameter('full_state', AFullState.ToString(TUseBoolStrs.True));
  Result := Self;
end;

function TmtxSyncRequest.SetPresence(const APresence: TPresence): TmtxSyncRequest;
var
  CPresence: TArray<string>;
begin
  CPresence := ['offline', 'online', 'unavailable'];
  FMandarin.AddQueryParameter('set_presence', CPresence[Ord(APresence)]);
  Result := Self;
end;

function TmtxSyncRequest.SetSince(const ASince: string): TmtxSyncRequest;
begin
  FMandarin.AddQueryParameter('since', ASince);
  Result := Self;
end;

function TmtxSyncRequest.SetTimeout(const ATimeout: Integer): TmtxSyncRequest;
begin
  FMandarin.AddQueryParameter('timeout', ATimeout.ToString);
  Result := Self;
end;

{TmtxPublicRoomRequest}
function TmtxPublicRoomRequest.Build: IMandarin;
begin
  Result := FMandarin;
end;

constructor TmtxPublicRoomRequest.Create;
begin
  inherited Create;
  FMandarin := TMandarin.Create();
end;

function TmtxPublicRoomRequest.IncludeAllNetworks(const AIncludeAllNetworks: Boolean): TmtxPublicRoomRequest;
begin
  FMandarin.Body.AddJsonPair('include_all_networks', AIncludeAllNetworks.ToString(TUseBoolStrs.True));
  Result := Self;
end;

function TmtxPublicRoomRequest.SetFilter(const AGenericSearchTerm: string; ARoomTypes: TArray<string>)
  : TmtxPublicRoomRequest;
begin
  if not AGenericSearchTerm.IsEmpty then
    FMandarin.Body.AddJsonPair('generic_search_term', AGenericSearchTerm);
  if Assigned(ARoomTypes) then
    FMandarin.Body.AddJsonPair('room_types', '[' + string.Join(',', ARoomTypes) + ']');
  Result := Self;
end;

function TmtxPublicRoomRequest.SetLimit(const ALimit: Integer): TmtxPublicRoomRequest;
begin
  FMandarin.Body.AddJsonPair('limit', ALimit.ToString);
  Result := Self;
end;

function TmtxPublicRoomRequest.SetServer(const AServer: string): TmtxPublicRoomRequest;
begin
  FMandarin.AddQueryParameter('server', AServer);
  Result := Self;
end;

function TmtxPublicRoomRequest.SetSince(const ASince: string): TmtxPublicRoomRequest;
begin
  FMandarin.Body.AddJsonPair('since', ASince);
  Result := Self;
end;

function TmtxPublicRoomRequest.SetThirdPartyInstanceId(const AId: string): TmtxPublicRoomRequest;
begin
  FMandarin.Body.AddJsonPair('third_party_instance_id', AId);
  Result := Self;
end;

end.
