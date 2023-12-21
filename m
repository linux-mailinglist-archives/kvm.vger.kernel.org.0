Return-Path: <kvm+bounces-5064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B2181B547
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 12:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0821C288CCE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E9E6E594;
	Thu, 21 Dec 2023 11:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q60LB/fZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F016E2A1;
	Thu, 21 Dec 2023 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1aO4dzA6q9UljqwPNi3JCD3QmcZeVgiWQFPeoevSzMZVt8RmE0yJ+A3VD7oMMsCQIqtYK3WwWgtp/4+HLPbhoeM9wHN9ecpq3yMHQ1sIzlft2slHMHskintTS/DOIOYeVYTEtPQzm7V9E7ElTjOUCndkZwd03IOBi16plxrC2fgVnHpBkyd+Lqn02kQlOUpGQ/AoVmZEukPRm8QFWztPxCdJ9cfzpCGy00gbpcx/i2hRNM8MbEH1BwVEbQoQSetgMJ/603iQX0iiJ7jF7zZqJThjNMqYEM9np9H4BQyb9tbv1jmBDxcUUXYVXJf5FTPw6LUGlyHG3HgbI3wJMLlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9FyfLHG6JekhDHvr0oYyzHvmEfJR6D8YFcQ3QRC334=;
 b=dFErdZeQkEd9MvtYzTcVi1iKs+qtJc6l9rlnpmfDS/OJUQvsUK7a4Ks3dJcP2umJZccpuO0Ndx/yrdyS/AnbT0++ADMPoEYLUle94eVFTkhD+baVoXO+DhjVL0t9sGIf/dSCaNsR/YftjlKfAZr+MHqJxWPspNmw5oqAM+emy4xHB+CVaMSpsLMzWwROEgTGIndTny/QySiqEL0FGT1V0ElrtFK3XR2rVPggyPZnezUtcQZMh/UtUIhl4XPOoQ1jwSfhFVbFc6J35KvkmGFoGr9v1U9gMfIBBYGQMU3Ygai/sssJq35tScQEye7zAvZCyumgHmr24rzGCZ1YEg6IXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9FyfLHG6JekhDHvr0oYyzHvmEfJR6D8YFcQ3QRC334=;
 b=Q60LB/fZXhSfL5AGk+Iyxf9Ca5WvrQhk5krm94u1VAjQMitkGz5AjmAiW5VzTWOuXl5ZXTN7/6d7j60gkwQz32d0hTS+vHjGUmpV4gq46a62VIRcRJ/0emJUGWfk28opP5EDPkIgMWOzudwi4rGiwEx4j1hr/1pJQXJF5tuoq/SH2TBEoS0Wsel2EcBUGItWxEmKvBrlONIe7rYJUjyGObd6S+MRz6ejL4Y3HiQXEaIxxGMvPXbTw4TGXdmr19fCR1FU/GGnmycEpuity4ZP5w9mtqSnxLCh4+XALYY2wvmNkOsqwOFogidH6M4mMc20omU2xJChYbo1DVBvOZk/dQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by BY5PR12MB4965.namprd12.prod.outlook.com (2603:10b6:a03:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.20; Thu, 21 Dec
 2023 11:52:33 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 11:52:33 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "jasowang@redhat.com" <jasowang@redhat.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Gal Pressman <gal@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Topic: [PATCH vhost v4 02/15] vdpa: Add
 VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
Thread-Index:
 AQHaMqaBunnLiYiUz0i03/j7bu1zQ7CxiQYAgAAFTwCAAJ4xgIAA0diAgABf+YCAAES4AA==
Date: Thu, 21 Dec 2023 11:52:33 +0000
Message-ID: <70adc734331c1289dceb3bcdc991f3da7e4db2f0.camel@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
	 <20231219180858.120898-3-dtatulea@nvidia.com>
	 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com>
	 <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
	 <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
	 <CACGkMEuM7bXxsxHUs_SodiDQ2+akrLqqzWZBJSZEcnMASUkb+g@mail.gmail.com>
	 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
In-Reply-To:
 <CAJaqyWeBVVcTZEzZK=63Ymk85wnRFd+_wK56UfEHNXBH-qy1Zg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|BY5PR12MB4965:EE_
x-ms-office365-filtering-correlation-id: 552eca50-0719-4b21-6a72-08dc021b5180
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 qS/OLqTPNS8zdgLBbMnlfRMB47oyEbGrBmJ4zLh/cjMtmlhs/yqi/CrBeBzgTICp7XxRwuB0FFn4Xon5bO2ROsKJpi43IyUQ4fkeJxfFMhMI/i2JV6+Tp5v+BQKSzTortb0G54uP6K6pa2mKKtnxogiJpMPtevbOohnJlF/WZIRBi5YUQAwcDefVqfaA8ZqJckIBe3LQ0cmCJI0UUEBr9k03pKFAFWsdGMYjyuu7yRx/0fLWqlG4bkqEa8lsKa8IeAoaTzRTxBQiOyb4jXjDperx4B0oEHU9q8YLHKPBqL2Yq6xVG9SizVtphhs18d8qHlwitvHV4qN5OBDqlvieEEOQkyMgu7X4Qvde2xQzGBli/y5OQJkbrf9WKa7MxvgDraZwgNLCK6ubbCWIO5RZjYW2UxqmGgimvW1r7grfVaMNk8CKCBVk9YQJi5zPVOEhK5LNmlGY3HANrFFNNSJENjUwceXZ5f8i11XV7KqYUTX5I755GLiknWK+ebkkoXKSeOTSt0hB5R6AgJmoiMHem+OaVT8x2bgwT8tM+mbxVIoI9tdTjG5k3LtT9kLEuTklG/x0qaoe/L3TlUuh9CajeuDD3unEemuiNQIL9y26Ye6319w4762qR3fgPaOikSKG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(39860400002)(366004)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(478600001)(6486002)(71200400001)(6506007)(6512007)(36756003)(53546011)(66446008)(64756008)(66556008)(66476007)(91956017)(66946007)(76116006)(8676002)(83380400001)(8936002)(4326008)(2906002)(110136005)(5660300002)(54906003)(316002)(38100700002)(66899024)(4001150100001)(2616005)(122000001)(41300700001)(38070700009)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WFdJSEc0VUNNVXpQdHQybWZkYm90QmZDS3o1SDBoZVRtTmpNcDVRcS9CQWFC?=
 =?utf-8?B?Y0psQVcyWGNZbDQrWXp0UDVxUXpYcTFIZnh6d0ozemFQWmtnL01CQ1BTOVd1?=
 =?utf-8?B?S1RaVUo4M0E1V1dYbTFlNTFGeVdIellYeEVETzc2T05DU3V0THYyUld2cndI?=
 =?utf-8?B?ci9UUlNBSEJVMzNxeGpHdFVYVjZENHlXa1F6WEhaeGU4UVIwTm1WMnkwTWZG?=
 =?utf-8?B?d0UwL0RtOW1pR1FvZGpJeFkxNFFpTnNkWmdzbFF4dXZkUnV4VnRzQnVneU9G?=
 =?utf-8?B?cU5DT0JSaFBBbWdWWER6Z2o0YUhWNnh0RVFDYy9aeElIek13V1NHR21ueHBi?=
 =?utf-8?B?Y2E0NnpWOUxOeGxEZXBZbVVSMHhiWWxUbFNnVHZlWHNZNGNtUkFnUE0wRndq?=
 =?utf-8?B?dVA0MngvMDBMdSsyOG9KZHpKdVVSKzQxQ2l2K1dwRzNGMTgxZGhXT1RxWC9E?=
 =?utf-8?B?aTdaUlRpK0VrS3dPNGswQURvZWVHY0Y5aldFMUFkekZQMW5PTDNmYjNHTGU4?=
 =?utf-8?B?ajRaS1E5b21MaUJtZjNYck5CY1o5REpyS2VNQlk2ZU1YSG4vazVYVVpHdTZX?=
 =?utf-8?B?RnNOWnp0TkxZQTRuNU1zUGdCbE1IMXc1REhnODA0RG9VeVBHUGxoZmdLNGpz?=
 =?utf-8?B?K0s1TGhkU3lrUlpZdXhaeEw1RkpPNndVcU1iOVBGWUl1Z1U4YXllN3lzUVd4?=
 =?utf-8?B?aVYzVTYzYU5ENnJEbzd3MWJXOGVtL005WjJiMUVMSGlFMTNHT1FXRmwxVEZv?=
 =?utf-8?B?ZTQzSFZiclZrNWxBUzlPa0xUNGZFYU1UbW5rbzRMSkw5ejZtVTd0eTNNa0RL?=
 =?utf-8?B?OUlPK1RFb3JoSEF2Um14d1dHR2twb0xNU285c0FMVDdWOGdBYTVmeE9rNjNL?=
 =?utf-8?B?Z01SSjVsaXgxT0I2dUxMRk9JUEwrSWgrZG8zK2pxdC9jemRod3R4eUJUdFlO?=
 =?utf-8?B?L3hhVldSSk5WbExDdWhrL1R6UjZZanpMOHI5Skd5WDlZS2Z2UW0zbjIvaWxM?=
 =?utf-8?B?cmRPZ0VDTHpvbWkzaFErVDE5SDRvbkY2VlBjRmRVTVkxQ1drT2kvaFZRZ0py?=
 =?utf-8?B?dkV1bC9sczBmSHhZdk1ibzhWRHRFRWsrRTZROXJ2cGQ2S2p2MzlsVHUvVGFh?=
 =?utf-8?B?dEJQaHZZK3dOdlg1ZG1iMVcwK244cnBoTXpuNGxvWmFSNENhVlpmY2swakhF?=
 =?utf-8?B?QkIrWXBEN0JRU3g0bzlEU282aGg1R1lVLzlvVEpVaW9ieHIxNjhiNUt2UytN?=
 =?utf-8?B?UFcxWmh5TFJVN3hXcS9DUTExZGRpb1U4dys4K3dDUVZ5ME5remNkSnR1OWdN?=
 =?utf-8?B?UmFJL1R1SHBWOFZyZEZaMDcvRFVjYkN4QTd1VlplVitmWmR5UUdwQndNVm4x?=
 =?utf-8?B?NzYvc2VWU3NwQ0gyMTQ4QjJ1NnhwWHJxdjB6dnVZME9TSE5laStoUVNoZUtM?=
 =?utf-8?B?WXRMbnVtQjRidm4zRUsxcUhFZ0EzZDViMkdCak41VHpBVlU4Q3JOZEhLTGtC?=
 =?utf-8?B?Wi82Qk01cEQ2ZGpGWjhPemhJVkNsaEc5OEJhb1BNeTdPVjNsbkplb2U2a0dM?=
 =?utf-8?B?dXhnL3pnTWpBU29uSEN4U29ydzhMVFAvU2dxNkZ4V0lNNmZYYk9CbzZ5OEp2?=
 =?utf-8?B?djNxaVRsZUhKRnRERW10NGk1SzlZdzlsZHhxYTlvRVJwaWl1YU93VGtjS2Ir?=
 =?utf-8?B?dmMvckwwVVU2VTlEQ09DUTluaVVvVHduMUtwQjdpVXFoc3hDUzY1WGdUaHRE?=
 =?utf-8?B?OC9RWGlvNlRjZ004T0dWSkZxZkRNZ3M4V2w2L0RyREZ1aTZvTVM3NTVCdHZB?=
 =?utf-8?B?eEtZb1pSYk5JR1JxR1lhMVI0OXp5NjlOcVFOQ0JJYko1QWJZOG5OYmNQcnhR?=
 =?utf-8?B?Wmp4N2Q4Q2p0TXg5ZjhnTnZZYjZuMmdBa01LVmhLRmVKa0VkNFhucGdsUDl2?=
 =?utf-8?B?MEtzcEN0Q0xQOEJuNFdGMk0zbWxEMFM3RnpyeXBITEhQellqbGh2SXNRRFJs?=
 =?utf-8?B?UUZpeWdibWVSaTB4aFV1aklXNHY0RWg2V3Ztc00wa0xJeGEwMmJEdkdWTUtT?=
 =?utf-8?B?b1A2eVdYQVpxblk2NTdVSklJblJMWFhnVjRzd0RJcW5zZFZDZlhuVmxOeUd0?=
 =?utf-8?B?dzR5TnE0d3UwZ1IzeDNrbWhLei9IMmNuUmtBb21UeE93ZGt0SU5HcEJqKy9N?=
 =?utf-8?Q?4tCJFADaxl3gN0K0jGChQfelj1UQeXPYCEbSlbVzl7Tq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47C5FE835EA2EE4E802254CD3A2C07A0@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 552eca50-0719-4b21-6a72-08dc021b5180
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 11:52:33.4008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjMzZoWTDnhrrzPuFF+FfuKlaXve90bCqYFVqcOa6jF3ARAEQ7d1S2K3gGJOvcwt5WH9i0OLGXfSCQJxaUZPLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4965

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA4OjQ2ICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gVGh1LCBEZWMgMjEsIDIwMjMgYXQgMzowM+KAr0FNIEphc29uIFdhbmcgPGph
c293YW5nQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFdlZCwgRGVjIDIwLCAyMDIz
IGF0IDk6MzLigK9QTSBFdWdlbmlvIFBlcmV6IE1hcnRpbg0KPiA+IDxlcGVyZXptYUByZWRoYXQu
Y29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gV2VkLCBEZWMgMjAsIDIwMjMgYXQgNTowNuKA
r0FNIEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4g
PiA+ID4gT24gV2VkLCBEZWMgMjAsIDIwMjMgYXQgMTE6NDbigK9BTSBKYXNvbiBXYW5nIDxqYXNv
d2FuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBPbiBXZWQsIERl
YyAyMCwgMjAyMyBhdCAyOjA54oCvQU0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5j
b20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGUgdmlydGlvIHNwZWMgZG9l
c24ndCBhbGxvdyBjaGFuZ2luZyB2aXJ0cXVldWUgYWRkcmVzc2VzIGFmdGVyDQo+ID4gPiA+ID4g
PiBEUklWRVJfT0suIFNvbWUgZGV2aWNlcyBkbyBzdXBwb3J0IHRoaXMgb3BlcmF0aW9uIHdoZW4g
dGhlIGRldmljZSBpcw0KPiA+ID4gPiA+ID4gc3VzcGVuZGVkLiBUaGUgVkhPU1RfQkFDS0VORF9G
X0NIQU5HRUFCTEVfVlFfQUREUl9JTl9TVVNQRU5EIGZsYWcNCj4gPiA+ID4gPiA+IGFkdmVydGlz
ZXMgdGhpcyBzdXBwb3J0IGFzIGEgYmFja2VuZCBmZWF0dXJlcy4NCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiBUaGVyZSdzIGFuIG9uZ29pbmcgZWZmb3J0IGluIHZpcnRpbyBzcGVjIHRvIGludHJvZHVj
ZSB0aGUgc3VzcGVuZCBzdGF0ZS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTbyBJIHdvbmRlciBp
ZiBpdCdzIGJldHRlciB0byBqdXN0IGFsbG93IHN1Y2ggYmVoYXZpb3VyPw0KPiA+ID4gPiANCj4g
PiA+ID4gQWN0dWFsbHkgSSBtZWFuLCBhbGxvdyBkcml2ZXJzIHRvIG1vZGlmeSB0aGUgcGFyYW1l
dGVycyBkdXJpbmcgc3VzcGVuZA0KPiA+ID4gPiB3aXRob3V0IGEgbmV3IGZlYXR1cmUuDQo+ID4g
PiA+IA0KPiA+ID4gDQo+ID4gPiBUaGF0IHdvdWxkIGJlIGlkZWFsLCBidXQgaG93IGRvIHVzZXJs
YW5kIGNoZWNrcyBpZiBpdCBjYW4gc3VzcGVuZCArDQo+ID4gPiBjaGFuZ2UgcHJvcGVydGllcyAr
IHJlc3VtZT8NCj4gPiANCj4gPiBBcyBkaXNjdXNzZWQsIGl0IGxvb2tzIHRvIG1lIHRoZSBvbmx5
IGRldmljZSB0aGF0IHN1cHBvcnRzIHN1c3BlbmQgaXMNCj4gPiBzaW11bGF0b3IgYW5kIGl0IHN1
cHBvcnRzIGNoYW5nZSBwcm9wZXJ0aWVzLg0KPiA+IA0KPiA+IEUuZzoNCj4gPiANCj4gPiBzdGF0
aWMgaW50IHZkcGFzaW1fc2V0X3ZxX2FkZHJlc3Moc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhLCB1
MTYgaWR4LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1NjQgZGVzY19h
cmVhLCB1NjQgZHJpdmVyX2FyZWEsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHU2NCBkZXZpY2VfYXJlYSkNCj4gPiB7DQo+ID4gICAgICAgICBzdHJ1Y3QgdmRwYXNpbSAq
dmRwYXNpbSA9IHZkcGFfdG9fc2ltKHZkcGEpOw0KPiA+ICAgICAgICAgc3RydWN0IHZkcGFzaW1f
dmlydHF1ZXVlICp2cSA9ICZ2ZHBhc2ltLT52cXNbaWR4XTsNCj4gPiANCj4gPiAgICAgICAgIHZx
LT5kZXNjX2FkZHIgPSBkZXNjX2FyZWE7DQo+ID4gICAgICAgICB2cS0+ZHJpdmVyX2FkZHIgPSBk
cml2ZXJfYXJlYTsNCj4gPiAgICAgICAgIHZxLT5kZXZpY2VfYWRkciA9IGRldmljZV9hcmVhOw0K
PiA+IA0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gfQ0KPiA+IA0KPiANCj4gU28gaW4gdGhl
IGN1cnJlbnQga2VybmVsIG1hc3RlciBpdCBpcyB2YWxpZCB0byBzZXQgYSBkaWZmZXJlbnQgdnEN
Cj4gYWRkcmVzcyB3aGlsZSB0aGUgZGV2aWNlIGlzIHN1c3BlbmRlZCBpbiB2ZHBhX3NpbS4gQnV0
IGl0IGlzIG5vdCB2YWxpZA0KPiBpbiBtbHg1LCBhcyB0aGUgRlcgd2lsbCBub3QgYmUgdXBkYXRl
ZCBpbiByZXN1bWUgKERyYWdvcywgcGxlYXNlDQo+IGNvcnJlY3QgbWUgaWYgSSdtIHdyb25nKS4g
Qm90aCBvZiB0aGVtIHJldHVybiBzdWNjZXNzLg0KPiANCkluIHRoZSBjdXJyZW50IHN0YXRlLCB0
aGVyZSBpcyBubyByZXN1bWUuIEhXIFZpcnRxdWV1ZXMgd2lsbCBqdXN0IGdldCByZS1jcmVhdGVk
DQp3aXRoIHRoZSBuZXcgYWRkcmVzcy4gDQoNCj4gSG93IGNhbiB3ZSBrbm93IGluIHRoZSBkZXN0
aW5hdGlvbiBRRU1VIGlmIGl0IGlzIHZhbGlkIHRvIHN1c3BlbmQgJg0KPiBzZXQgYWRkcmVzcz8g
U2hvdWxkIHdlIGhhbmRsZSB0aGlzIGFzIGEgYnVnZml4IGFuZCBiYWNrcG9ydCB0aGUNCj4gY2hh
bmdlPw0KPiANCj4gPiA+IA0KPiA+ID4gVGhlIG9ubHkgd2F5IHRoYXQgY29tZXMgdG8gbXkgbWlu
ZCBpcyB0byBtYWtlIHN1cmUgYWxsIHBhcmVudHMgcmV0dXJuDQo+ID4gPiBlcnJvciBpZiB1c2Vy
bGFuZCB0cmllcyB0byBkbyBpdCwgYW5kIHRoZW4gZmFsbGJhY2sgaW4gdXNlcmxhbmQuDQo+ID4g
DQo+ID4gWWVzLg0KPiA+IA0KPiA+ID4gSSdtDQo+ID4gPiBvayB3aXRoIHRoYXQsIGJ1dCBJJ20g
bm90IHN1cmUgaWYgdGhlIGN1cnJlbnQgbWFzdGVyICYgcHJldmlvdXMga2VybmVsDQo+ID4gPiBo
YXMgYSBjb2hlcmVudCBiZWhhdmlvci4gRG8gdGhleSByZXR1cm4gZXJyb3I/IE9yIHJldHVybiBz
dWNjZXNzDQo+ID4gPiB3aXRob3V0IGNoYW5naW5nIGFkZHJlc3MgLyB2cSBzdGF0ZT8NCj4gPiAN
Cj4gPiBXZSBwcm9iYWJseSBkb24ndCBuZWVkIHRvIHdvcnJ5IHRvbyBtdWNoIGhlcmUsIGFzIGUu
ZyBzZXRfdnFfYWRkcmVzcw0KPiA+IGNvdWxkIGZhaWwgZXZlbiB3aXRob3V0IHN1c3BlbmQgKGp1
c3QgYXQgdUFQSSBsZXZlbCkuDQo+ID4gDQo+IA0KPiBJIGRvbid0IGdldCB0aGlzLCBzb3JyeS4g
SSByZXBocmFzZWQgbXkgcG9pbnQgd2l0aCBhbiBleGFtcGxlIGVhcmxpZXINCj4gaW4gdGhlIG1h
aWwuDQo+IA0KDQo=

