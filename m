Return-Path: <kvm+bounces-4923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2442F819F67
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4211E1C23173
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 12:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BCD25560;
	Wed, 20 Dec 2023 12:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HyfwzRyQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6377725545;
	Wed, 20 Dec 2023 12:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqRjZQ+xtmcsCooBq9xkIxQhQOtRQYzVdeYwkzG7quH/6DQ6dVxR3c0W1uszT8tTrwsH7ya+PMytFTYrkrxO2jnEpmZyFNAUZMGwmF5TLlJEzy6pSQGAc8LiGbkA8U1TdBBn/f7kXlksj2MK5t+IKzS2DqoYVNwUAx9AvwWy0SbCL4WdVN6HpTZsn4V56EB0nPdJnSRiYBABNV2lmLIdpTXIVmGSMwpT8/DXGGgjS0Jfz5iPU/mkPv/iC5SzKweSa198/64gGHDeWfhg/cD27oCcVady4bwW8S10EZOlFX6SPFBTQI5XkQi1lQ0gxfMiTJXh59XbUZbPSPlQGX6dhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nbddyPnZXJru3VzEK8Uo0vzKY+VXukfwbF53RfKdaY=;
 b=XKFXrzLsP/k4I3XLaLcRgqP+GjH7ha9xoPojtUpdC+OIQhHaNK7HqMcaGDlAPAVB9zkVcFkmYitwxItyRFJRfUp5NJN7lF3JQJmuij/It6yB3779ZsUNE6TJzzCFXdvfHG7GV6nPUsl+J840TFLKkHlBqijz+nIdOrctUJgOpJKV7SMAwrMg4Dlbhr+0X4WXb92MHHNVIYMOxfTWcSZ3jzZVW+Xq0nE/ScmhBJuYIa/FstJ8Qnknk+65HJ/Wm3d+EI0aJBu/71TbWw1gYzvv6uD1UQD68Ksnc3FSz57CaVoSlXz285krkp0jRr7008zOONaQor5snhE8in46vLtw8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nbddyPnZXJru3VzEK8Uo0vzKY+VXukfwbF53RfKdaY=;
 b=HyfwzRyQJLxaIncOPywTBGi9dqcyz276ZVmEFPw93TztmIH5AHfnI7NhTwD/DyjQ/Va/x/0lyv8vtzU97vi6eepw9V0cK23XMAEBjD67IzLj5wKrR0WaHg2G/btNGeO0Dlt7ATYPNJqY+BWH/+zBRfoReAJOmabBgmWyNHSf+kzdrjtVyGR9fSaGsiEpYWUyF/3/GKcaLj4QrvEPAtKERc1Xbpc3H8iYVw6MAjgTS1MLLoWDSGS7JvHSibfS9FAFLDCEvDavTbY093evYKQCmP6xHnquXIOWepoSxdMcJSSntWjnDAMsoiOOmfUX4cQiZkV2zgPcGeRnw6UUnyGtmg==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM6PR12MB4420.namprd12.prod.outlook.com (2603:10b6:5:2a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 12:57:19 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.016; Wed, 20 Dec 2023
 12:57:19 +0000
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
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Topic: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Index: AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJR8gA==
Date: Wed, 20 Dec 2023 12:57:19 +0000
Message-ID: <5e55c4e1bb1d8dff4943431bab090d541749e9a5.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-3-dtatulea@nvidia.com>
	 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
	 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
In-Reply-To:
 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM6PR12MB4420:EE_
x-ms-office365-filtering-correlation-id: 579781f9-4ef4-40fa-f3f3-08dc015b331d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 uK38thw8AtstewkbrOH4+l5jsOPMObbdAKWCt3tlAEvzfmIzIPDX6G18FFr4TBWuJwGE6DyFtPJl3TndSVa01G4g27es7vkrwGaeG9/UKfeaGIWOGkP30ulV9SRQBnx0Vo6soQ2Y8tf/jvuGbMncqwW1y55C4UbLd5gIB3pE2FXOvtOxMMSuM50vHgxX1neHMkNtEe0pcUThfWIY/V2Q+OkF42sCrswXgp66p2DG1q1MhC8jTX8rK5SEXKbEQY4YqeIjRbvjThBImL4aUXrEmMdKWOtpSdJkxLQv7NqyDZo+H7LspQhVfCpzszoyt81SMS/Fe28ZSHAR5DbAiZGsG1vRickZbB584vjDQbPSYnEQbxTMmn7lUnOod+1JZTKCTYYNYGL9KuAd4JENr+U5613eZIn4Ui7MuAU+9bjtlUZ7RGK2qGuG8nEIMEqXqwMgz7MbUN5g9VzJlXrIZxs/vkx6CsxvoibjyrQaCcfJj2dvIYwYlJ36Hw1r8nAnEeRN7tPcDPb6iqbkNAIS4HEMB9McYkRW4aqOe/denCtlcDV2NECp7f+OOu+il8Tb2/rjcccveZKz5xxKqSKeUpwFYk5uRcJV6plfc1nb9I98o7JUAIliYEGaexcRSEscq1nB
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(346002)(376002)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38070700009)(4744005)(4326008)(91956017)(83380400001)(53546011)(5660300002)(64756008)(6512007)(6506007)(6916009)(66476007)(8936002)(54906003)(66556008)(66946007)(76116006)(8676002)(6486002)(66446008)(2616005)(478600001)(316002)(122000001)(38100700002)(36756003)(71200400001)(2906002)(4001150100001)(86362001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkN3ejkwbEVJK1RLZ2l4OXlNN0FhMndRNEdvclBucFY4YzkzYURQMU5JYzQw?=
 =?utf-8?B?SG5yYlJKWUVDUlhxclVPOHN0bkZJNmNUZm51NUlObG5vQy9mdmtzUGRFakRn?=
 =?utf-8?B?UmNobGN1T3VwbjJEcmRKTVJVUkFGNk1CM3pvM2hTcHRkYVVUMncvN0FnQyt5?=
 =?utf-8?B?MDE5b0ladjRRK2kyRlZyZm1xNW1JRzRZU2pqNHozeFpKTmJrVEc1NFZORm16?=
 =?utf-8?B?bE1mYkNtN2UxK2JBWVIxaUtpdm55dzBlQ2I4UU9ENWhZa0ZjYnkwd0t0dEN1?=
 =?utf-8?B?OS96YkFxSjkrd2VZM1czQ3E0bGk5S3R2ZGVtcnJMME9sRXAxWFdiaUdnZDVs?=
 =?utf-8?B?aG1USURVdDV2Z0lEMHVjbnliSHA5Vit2ME81d3N2ditzeGZOSEpudkVjMzJl?=
 =?utf-8?B?dUJ3L3VzQ3J3R1MzSThQcndGa2hvNUphT2RUVVVzYmhIQTFzQmtwcW9KMnRi?=
 =?utf-8?B?NUwreXhkUjcyTFhFNGgyNDlwd3paL1BOMW4vWXovcDFKc3J0ZEdFWmMwUkRM?=
 =?utf-8?B?SjFjY3BlTDBMWEszcCtvSUZJdkV1ZllBNnFwL2l2aFNSa09tb0VaV0xYSVgr?=
 =?utf-8?B?Q2RYQzhPWXYrR25QaTFIZG9xNTlXRDZhV3VJMW9ucnhRSVkxMmlnREQrV29k?=
 =?utf-8?B?TTl0VGFCeGR0S043YkVUbFp3L25iZmJNbVM1UmI0ZVNOZlA0N2d5L20vOUQx?=
 =?utf-8?B?bmxYbGNzWUwwOTB1NHN2Wks3STNZMEg2VW00TCtJdkpiMUR0SFo1bEhQb24v?=
 =?utf-8?B?dW5OdG9oWlpiMFhXcEJpMXRsbkdsV0FzeXhMall6K1RxOGZwN0paeTZTaWV5?=
 =?utf-8?B?QnZDazdwZXZMLyt2ZGU2RmRzaTU4WmUwSEtyZHRDNEo4N1crQ1AzUDIrOWM4?=
 =?utf-8?B?RGZLY0RNelp6eS9EdWhEOXJkRktIUGNiTUJEd2JqengrWS9wT1A2bG1yd05z?=
 =?utf-8?B?MEloV0k3dnBQRjdtcG1YOERvbWxXSVgzNEhxRHVwOTYyR09wWEh5a21iV2JO?=
 =?utf-8?B?QklwS1dGYnZkRlVQN1FEMkVZMHdiYzlDQm1LOEx4RUJVQzdQTXh2bHdPWURU?=
 =?utf-8?B?SkNqREM0ZWxaWlQwd3o0bmVoQnYvT0lPUFRTYlFVeXdjcUFROWczVlExd1Za?=
 =?utf-8?B?R2pVYkFoeDhPZmdWSkNua2JsbGhjUVN2aDk5V0Zpa1VpbGRYREdFYUN3bkNP?=
 =?utf-8?B?dUk5bWJ4Nzk2MG9NVTdmY3A2L3hScCt5NGFuQ0pIUnBpOTJCN2FKT2taWUdO?=
 =?utf-8?B?Sjd3OGxtQk5MckhLbElSN05sQ3lsalh1UERLWFZva0F3czNSUG9HSHhJVkhT?=
 =?utf-8?B?bnk3NVNXaXpMTGdhSUd0cExycXl5Wm9Vd0kySWhvdThINXVkclZtbkQ3cE5t?=
 =?utf-8?B?ZmhSVUFXUzFQek5JcDJEL3lSdkpJN3NpakVoVFAzYkF1YWRiNEZzcW1xKzFk?=
 =?utf-8?B?aWVLMm9PMkg2M2ROQVBCeXBWUk05MXVPd1o1L21wVWRHazQ5U0lLRGpwUnBW?=
 =?utf-8?B?a2x0ZDlrS3JQQmNtR2JuTWYzazltN2hwZHQ3ZlREcjZ4TXVybk5sdmlxQWxQ?=
 =?utf-8?B?K0R3WHA3SXlqOXYvczZqWHlzT2V1YlpkWnkxczZEdUl2djAxZDhGVytrSkI1?=
 =?utf-8?B?RkF4WUptMUF5RlZrYkRUTDF3WmN4cTNvdi95Z1dFbjREWm1NRkpZcnJrejk5?=
 =?utf-8?B?cW1ZNDJ3SXByYTBaWWhQUFdNVStwMjZXYm1LM3BIbmdldTJEZHZUdVlvZi9u?=
 =?utf-8?B?UkZBbmZFSzNOelUycDlpeXJ1UXlLMkNkSCs4emdLRXhjcC81NDROZjQ3bm5M?=
 =?utf-8?B?dG5UTU1COW5tVkM2NFhmeWx2d2ZQUVZXUmhaWWVXR3E3aHRZenJrako0Nld6?=
 =?utf-8?B?YSt4RmRSZDY2VW41RVo0Um9DS3NvQ3J1alhJM3lMOVNER1cwNDBwc3R2WmN2?=
 =?utf-8?B?N3Rld3lCTDMrN0tjMnpPUG84d3dYeGJRQ0c5dkUxa3lDTUFUc3RlNnFJRjEw?=
 =?utf-8?B?STloajJNNy9XRUpDT2Y5L1RHN0NLNHlaNG54aHp6QmswK21oVUVLUnl3VmhJ?=
 =?utf-8?B?M0ZheC8yWUgxN0RLU09iN2dLUE8zRzJFeHRRUkJyUkUzSzlzS2hMWFZGdFg1?=
 =?utf-8?B?YnBpcTFnZmZSbGE2SmR3S1AwMUZWa1JTckNRcmQrNngxWDJuRmVhcUowRDQ4?=
 =?utf-8?Q?ZErsumKcHm+jPTwhiEFGjrPDTV4NiQtJDtBP50YQRs1a?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAE73233ED137C4084C6A2CF6195458B@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 579781f9-4ef4-40fa-f3f3-08dc015b331d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2023 12:57:19.0530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJaJu/Y3SvBl73cRWFloum+svNDSh52ld4AuRFUT1b5d/E54sKvcSneHCD5NvecE1vCAN80oPcJD5CR9YwgNBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4420

T24gV2VkLCAyMDIzLTEyLTIwIGF0IDEyOjA1ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiBP
biBXZWQsIERlYyAyMCwgMjAyMyBhdCAxMTo0NuKAr0FNIEphc29uIFdhbmcgPGphc293YW5nQHJl
ZGhhdC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFdlZCwgRGVjIDIwLCAyMDIzIGF0IDI6MDni
gK9BTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPiAN
Cj4gPiA+IFRoZSB2aXJ0aW8gc3BlYyBkb2Vzbid0IGFsbG93IGNoYW5naW5nIHZpcnRxdWV1ZSBh
ZGRyZXNzZXMgYWZ0ZXINCj4gPiA+IERSSVZFUl9PSy4gU29tZSBkZXZpY2VzIGRvIHN1cHBvcnQg
dGhpcyBvcGVyYXRpb24gd2hlbiB0aGUgZGV2aWNlIGlzDQo+ID4gPiBzdXNwZW5kZWQuIFRoZSBW
SE9TVF9CQUNLRU5EX0ZfQ0hBTkdFQUJMRV9WUV9BRERSX0lOX1NVU1BFTkQgZmxhZw0KPiA+ID4g
YWR2ZXJ0aXNlcyB0aGlzIHN1cHBvcnQgYXMgYSBiYWNrZW5kIGZlYXR1cmVzLg0KPiA+IA0KPiA+
IFRoZXJlJ3MgYW4gb25nb2luZyBlZmZvcnQgaW4gdmlydGlvIHNwZWMgdG8gaW50cm9kdWNlIHRo
ZSBzdXNwZW5kIHN0YXRlLg0KPiA+IA0KPiA+IFNvIEkgd29uZGVyIGlmIGl0J3MgYmV0dGVyIHRv
IGp1c3QgYWxsb3cgc3VjaCBiZWhhdmlvdXI/DQo+IA0KPiBBY3R1YWxseSBJIG1lYW4sIGFsbG93
IGRyaXZlcnMgdG8gbW9kaWZ5IHRoZSBwYXJhbWV0ZXJzIGR1cmluZyBzdXNwZW5kDQo+IHdpdGhv
dXQgYSBuZXcgZmVhdHVyZS4NCj4gDQpGaW5lIGJ5IG1lLiBMZXNzIGNvZGUgaXMgYmV0dGVyIHRo
YW4gbW9yZSBjb2RlLiBUaGUgdjIgb2YgdGhpcyBzZXJpZXMgd291bGQgYmUNCnN1ZmZpY2llbnQg
dGhlbi4NCg0KVGhhbmtzDQo=

