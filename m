Return-Path: <kvm+bounces-5138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DEE81C906
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 12:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE874282530
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 11:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E221179A4;
	Fri, 22 Dec 2023 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FAOAoT1+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922C917983;
	Fri, 22 Dec 2023 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRRYCVI6XiH1oSBep6rFYUe+HGca2MH/G6aE4Ll8ldoAnB3zo5uNzVMPKCjftVGBqvymq5DyfuW12Y8nP879fGPqaaJXrOSpZK8duJFLMwHoFz5jZzkxXISts0utl/S9O+c2fT8P/LafusPbfWQ790nf7S83mtFZB7CIucjoMm8rTifbkePJ+9OCUBPUxc41c7csxoukO9i+xpZW/znZgz9makLbZ0GFPSd8u5RicuEpYagG60ls7MVQbyYFlMLB3p7yulU7V67z3cW5OAdYWUQM4sOxt+boIXlNn3HNKIs+TZcpqvSQsNOhh4eov1nOUwVtQBT23AaVNxlGzk+K9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6Ohtt12Nma3Kfxb3W7WKGxBb8zSoeX30XYTY3n++9Q=;
 b=ZSMc0noMp4azYBSihH+/xL56RrvU1p54A7f3iZoCoMnubhLfORnrBrPsGalbkjevbZicVuyAMVZIC/AdpOZffQZC5ieOWlT1WPKU1x98incBpsgLAH4yZz/vqVJn4UJrqY+Qwv8Qwb2hyuk78e1ai0Y2267o0FRkcOMGnRLKn9p9Z0418nBEiyK7zYkwpM4swJhIkduZ18K9kNqJS/f9W7Uqe2TJum/gLKwfTst1VlPAz+6CQWxAruYtZ9XGNFoLjNDiFVpfj8HhBpFKyJ7FIIS49OXO2VAVSVCjJU20EXSlMURGyoMs368xL3NCcETc/hlopsj+wRwkBDTjAbkDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6Ohtt12Nma3Kfxb3W7WKGxBb8zSoeX30XYTY3n++9Q=;
 b=FAOAoT1+akg2nMan7ZsQ2Epkyz3KC0NQfajKwtarGY/OZOeQJxK1BoaX2hf/tCCfR5JxYOXPs9pVI0K/9KuWwe8eeFsLOsIk5SfbGN/7OXLMi7kAw7IVW9Nd9fraB74CUyU20porDp/NL5yISyOIbdGhArfb8X9l+SizbN+YgXSBqDM3mYuPz4j2rxtlZ0sVUUsxtTHfXQCFEZxw2uJrMrJ1XiLGbMdj0Iv4et988JOvTSBtONtMvd4YnFC/++Pi/F+8pkLySPbyGzaO3sSwpibBpXKHEbIYAOsJBiy5BeiGEE1JaF4XcWur6/oWBQ2Rd6+yv8CuSz5E8X5N5kLApQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM6PR12MB4331.namprd12.prod.outlook.com (2603:10b6:5:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Fri, 22 Dec
 2023 11:22:41 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.019; Fri, 22 Dec 2023
 11:22:41 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "jasowang@redhat.com" <jasowang@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v4 06/15] vdpa: Track device suspended state
Thread-Topic: [PATCH vhost v4 06/15] vdpa: Track device suspended state
Thread-Index: AQHaMqaJZWbyVmSIr0+0TyiJd4XKALCxiQqAgACZTwCAAwqxgA==
Date: Fri, 22 Dec 2023 11:22:40 +0000
Message-ID: <f54a1037b515d15b24193d96d574b775eb743099.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-7-dtatulea@nvidia.com>
	 <CACGkMEs_kf2y9Khr==zY3RRHffaPRwS51XK33Lgv1eeanQdRpg@mail.gmail.com>
	 <65064744954829b844d8a7b23bb09792cb6c2760.camel@nvidia.com>
In-Reply-To: <65064744954829b844d8a7b23bb09792cb6c2760.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM6PR12MB4331:EE_
x-ms-office365-filtering-correlation-id: a101178e-1064-4848-52c2-08dc02e04f92
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 jpVAkL1/44NkstkuJyrMVo+hhbmqWpk9gGvRGVRF/ZeBnVJyZwA9LkE3hTl3ivK7ksxrlgA2HpaPhAuyz8gqYPJanNixEehJVq1NWl55joAX6/E1XVLdVm1rH4BzNL0yljPs6LOpro6/R4hEok9H4P1RBbNgPLqB71N9SCnD8OXlw4m8j3swbMRo8yD6JRz+zyR5rDTwXbjC2rGxmiMstcCDK0RsSJ29W0cGtWomNphP6iT90rAM1XiqNldE4YR/iV8hPXQZdQKczxglXax/Y3Ltkl1W42lA3SbslnGeARdOaOSOv0iDCqSAzhtYgftYcc18mm5pDvr9uXKh4m9po+uByFZ2jBf3nBA69Jf5BCv3KS7MvCtt1bIdW4qBR8rIbB17GQAWSzCgeSc+xtgDBDQn9KjnQZBidmxfWsdGhd/+8eZFzNNm1BsAdYA50ryGbRGMfWbMUNkWv+JD3VY7LfOcUjmCNpDZUODI5vdZTDejk+kOFoR2yZu6gYlqdf13ztfBnAUt9SZW6dAEaRaklSOKH2OXVngQZu9xxOkXB0eYgUkZrbJ5QH/25OY9yZtf2Q+SgMkcRzE57Gw14K3iprrUZkXyp+a+/ho91zk5rwOpAfA/EIWiaU7D+jcTF1Yz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(38070700009)(36756003)(86362001)(5660300002)(53546011)(6512007)(8936002)(4326008)(8676002)(6506007)(71200400001)(2906002)(15650500001)(2616005)(4001150100001)(6916009)(66574015)(316002)(54906003)(64756008)(83380400001)(91956017)(66946007)(76116006)(66446008)(66476007)(66556008)(478600001)(38100700002)(6486002)(122000001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NitPdytPOGc1RjZOQi9ycm9mczRna3k5cXVNUTdHYmYzNmhUTlpodi9qSFl2?=
 =?utf-8?B?ZExGNlEwTm12ZUhqOFFERTdiaGtPeDRWallzQ3JweFZ1a3JsbnlpWFlRdEFD?=
 =?utf-8?B?eGwwYm1uYkEzQkI5YUhpMElMOElaRjhDTHF3ZEs5U3I0aU5rakFJbGk4R3A3?=
 =?utf-8?B?TkhMRUVUTGxpS2I1cDJpRWdCcjYxYkFDb0hya0NFbEkxMWIrSkZBZFlEdVNJ?=
 =?utf-8?B?RmpBalE5UFRmVHQrd1BMK2NvcS9oY1E2LzJKL0s2NExnNjdDbXpEUDA4a2Fp?=
 =?utf-8?B?TXVTUnFMbkpNOFZrOHFBODFBYnNWbFBpNENUNUs3S1Y3b0kwZDVPUG1KTThG?=
 =?utf-8?B?WFViVHBHN0hCR1VCNGQvQUMrc1pwUmk4K0VJMGt0L1F4VGF0Sy9TVkw5UnRP?=
 =?utf-8?B?RHhFZDhuR0pvOTJPM1pTY3VLSzhZMTVIbEM3Y082amhvNmQwUFVNS0RweE1r?=
 =?utf-8?B?RkgwczRxcGFoVml2c3lqRlh6L2J5OTI2MkYyaFp6MUJQbm9aVlJ5RERxTU04?=
 =?utf-8?B?dUVKTjRQa3FSNXV6THoxNEMydEZxNjNmalM2R2pIaUdjdUhlQkhKTVYxNWp3?=
 =?utf-8?B?MlZ6Z1d2S2pOYldEb0xxa1hmd3hKcXoyTURBM0JINWNiTDAzazZDYWV6NVZL?=
 =?utf-8?B?WS90dHgyaitCV29xcHpsRmxRc3dwejNHTUFHZ1dDMUoxK1k5elIvUmRQSzBI?=
 =?utf-8?B?aUl6b2g5ZkY2NmY5Y3VOUDJmYWRLWS82TCt6TjZVQ002NnpTdWI4VzhpRHBz?=
 =?utf-8?B?TDhtZkJkNUtNek8rNGJBeU1FR01GWENBNVNyN21kMTRPZGxIZDNUcXZsM1BU?=
 =?utf-8?B?Wk8vS2Q2NnpVL2VlN1NieHB0TllYV2s4M1Bqam9LaElyTS9USlRlaTZ2bmZz?=
 =?utf-8?B?bUdSdm10eWlaUmVId2F2bHdhWUowT2RtcFh0dzdwNlBlUlQ3TWJuOVU2N3ox?=
 =?utf-8?B?N2hvOUp4aER6V0R6TEV4eHVGWWtCZml1QlNBSUxTbllxNTBMSi9vbUhjbWpG?=
 =?utf-8?B?ZWtnQlphd2daNTMzY1I5VzJvM290akRwU1YrRUJremJ2L2N0QVZTVjNEdFVP?=
 =?utf-8?B?Tk1KRU85MEVSSit4dldsRmhJZkpBRUdZcUM5QmNjUHk1cGlJZ200bmkxU25k?=
 =?utf-8?B?TVpVRjMvbWhPV3E5Y2puam0wWjRvVjUzVFNWc05CMlRVUklJVGcvbGxVb0tR?=
 =?utf-8?B?SkxXc0VFUnVnTjVzQThVZURZVmphclVvOTRqUkM2Q1FRTFVFZHg4ZHBRR2hG?=
 =?utf-8?B?a29ORkV3T0xqRVZ6b21RRFJqenloUzExT2F2cFd1NWR0NE1aRHc1ODNwaDd3?=
 =?utf-8?B?dnJqYmRWTGNkTyszekhlRzJ1WFBnb2NJdUgyRUVmSWhSNjlySzZsdkVUay8r?=
 =?utf-8?B?cTJKVHVieFNmMkNmcTlMb0t2R2ZUT0V5WWZhdU4wWm1Rdjlua0hHYkM0VFVo?=
 =?utf-8?B?NnFTVkdCWDFJV3pEdFFtK2tJem0xbnJ0Qm5vdUE5eEdqR2ZlbXdHVnc3VnIr?=
 =?utf-8?B?b3dlNng5cWpjTnY2V1BqTUwvUUxucjVlWUtjcDRKc2Z0L1hTZVJqUWtjQisz?=
 =?utf-8?B?akFaTGg0Q3B4TkZhY3JVbjdBaU5QZzNVYllIbDNPQ2hhcThsWE5nbzI4Z2I0?=
 =?utf-8?B?M3oyV1hoQUtjQ3BMUThIZk5FZE1KTVFrcHpDY3ZnelI1V3A2ZkxqT0w4SWRE?=
 =?utf-8?B?R1l6bGx4VnVheTVpUHpPL1R2bjNhYWJ1WERYKzVEK3lUUGljWE5Vb2dOckNY?=
 =?utf-8?B?TkFaa3p5MjdUVEtETTZCWjBselpWTzBFU1djang2MHJxd1p5TnVXSVJya2hB?=
 =?utf-8?B?dE9HZ01uY3UwVHlWeHM1aHU1NW9KUmVQWmJBN1BaVjNxdkVERDJRczBSdG5x?=
 =?utf-8?B?ZlNsTXRBckVBQnJyTTRVQndDRlhDNTdjbHA4U1FWTVVHbUwySXNEbkt2cXFB?=
 =?utf-8?B?Nm9vcCtud2ZEUlZRMG93MkJuTzZvMzhiZmszVzJZcUc2SHQ1L0RpdjhQYU9C?=
 =?utf-8?B?ZHdUeWdUdllWRW54dDBFVEQrVXhOOTZOVWxwRy9DNDdWTnpPZTdSTy9wTlNa?=
 =?utf-8?B?TjhoU21yTjg4akVSUGN4YVp0NHIwcnRmVk1hTEdiTXZFaHN5N3l2MjJXRTc1?=
 =?utf-8?B?YzBja2V3bitIY0Y3THdld1hrSDVGdnF5R2pBSzBUTS91Uy9oajVmSjZ6M3FZ?=
 =?utf-8?Q?rAFS3D6Ma5akqTtU7h0TQzztJdW82u9dZhVarVs8HcKk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE19DA291CDF94458DF753B82EBB3ECE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a101178e-1064-4848-52c2-08dc02e04f92
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2023 11:22:41.0217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K1I+bE72siK4mcZx3zvea4X/2wzEGt3Z7y2uBsxh2ciRnQ5mIoXT0Rr9d4PIBHufO5HuxxI2hTCblR86lmGphA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4331

T24gV2VkLCAyMDIzLTEyLTIwIGF0IDEzOjU1ICswMTAwLCBEcmFnb3MgVGF0dWxlYSB3cm90ZToN
Cj4gT24gV2VkLCAyMDIzLTEyLTIwIGF0IDExOjQ2ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0K
PiA+IE9uIFdlZCwgRGVjIDIwLCAyMDIzIGF0IDI6MDnigK9BTSBEcmFnb3MgVGF0dWxlYSA8ZHRh
dHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IFNldCB2ZHBhIGRldmljZSBz
dXNwZW5kZWQgc3RhdGUgb24gc3VjY2Vzc2Z1bCBzdXNwZW5kLiBDbGVhciBpdCBvbg0KPiA+ID4g
c3VjY2Vzc2Z1bCByZXN1bWUgYW5kIHJlc2V0Lg0KPiA+ID4gDQo+ID4gPiBUaGUgc3RhdGUgd2ls
bCBiZSBsb2NrZWQgYnkgdGhlIHZob3N0X3ZkcGEgbXV0ZXguIFRoZSBtdXRleCBpcyB0YWtlbg0K
PiA+ID4gZHVyaW5nIHN1c3BlbmQsIHJlc3VtZSBhbmQgcmVzZXQgaW4gdmhvc3RfdmRwYV91bmxv
Y2tlZF9pb2N0bC4gVGhlDQo+ID4gPiBleGNlcHRpb24gaXMgdmhvc3RfdmRwYV9vcGVuIHdoaWNo
IGRvZXMgYSBkZXZpY2UgcmVzZXQgYnV0IHRoYXQgc2hvdWxkDQo+ID4gPiBiZSBzYWZlIGJlY2F1
c2UgaXQgY2FuIG9ubHkgaGFwcGVuIGJlZm9yZSB0aGUgb3RoZXIgb3BzLg0KPiA+ID4gDQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4g
PiA+IFN1Z2dlc3RlZC1ieTogRXVnZW5pbyBQw6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+
ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL3Zob3N0L3ZkcGEuYyB8IDE3ICsrKysrKysrKysrKysr
Ky0tDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYyBiL2Ry
aXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gPiBpbmRleCBiNGU4ZGRmODY0ODUuLjAwYjRmYThlODlm
MiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gPiArKysgYi9k
cml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ID4gQEAgLTU5LDYgKzU5LDcgQEAgc3RydWN0IHZob3N0
X3ZkcGEgew0KPiA+ID4gICAgICAgICBpbnQgaW5fYmF0Y2g7DQo+ID4gPiAgICAgICAgIHN0cnVj
dCB2ZHBhX2lvdmFfcmFuZ2UgcmFuZ2U7DQo+ID4gPiAgICAgICAgIHUzMiBiYXRjaF9hc2lkOw0K
PiA+ID4gKyAgICAgICBib29sIHN1c3BlbmRlZDsNCj4gPiANCj4gPiBBbnkgcmVhc29uIHdoeSB3
ZSBkb24ndCBkbyBpdCBpbiB0aGUgY29yZSB2RFBBIGRldmljZSBidXQgaGVyZT8NCj4gPiANCj4g
Tm90IHJlYWxseS4gSSB3YW50ZWQgdG8gYmUgc2FmZSBhbmQgbm90IGV4cG9zZSBpdCBpbiBhIGhl
YWRlciBkdWUgdG8gbG9ja2luZy4NCj4gDQpBIGZldyBjbGVhcmVyIGFuc3dlcnMgZm9yIHdoeSB0
aGUgc3RhdGUgaXMgbm90IGFkZGVkIGluIHN0cnVjdCB2ZHBhX2RldmljZToNCi0gQWxsIHRoZSBz
dXNwZW5kIGluZnJhc3RydWN0dXJlIGlzIGN1cnJlbnRseSBvbmx5IGZvciB2aG9zdC4NCi0gSWYg
dGhlIHN0YXRlIHdvdWxkIGJlIG1vdmVkIHRvIHN0cnVjdCB2ZHBhX2RldmljZSB0aGVuIHRoZSBj
Zl9sb2NrIHdvdWxkIGhhdmUNCnRvIGJlIHVzZWQuIFRoaXMgYWRkcyBtb3JlIGNvbXBsZXhpdHkg
dG8gdGhlIGNvZGUuDQoNClRoYW5rcywNCkRyYWdvcw0K

