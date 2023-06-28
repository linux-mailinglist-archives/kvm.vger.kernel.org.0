Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BC6741736
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjF1Ran (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:30:43 -0400
Received: from mail-centralusazon11012006.outbound.protection.outlook.com ([52.101.63.6]:3515
        "EHLO DM4PR02CU001.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230417AbjF1Rah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:30:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYQg/emcE7X+XIYr2H3Vz/YdYSy6CWbcM6PAXJ7U5WtS2gFwhNrAnSMHFgqLQWdO6ujai89zKqAEDXdrZwLkzq9EjSElD2zaskSmon/oYUDdnZl1vrK9RPiKaSvKCDJef/XSOmwG7g5yaIExulWKjmj0WXGj1ACeMmuV3UrRkdilbxjRIQmpDKtg3/jYVExDAe2XTyfgznhhm7ODPNDx08awVKU5cQd6hsPV0yUE1QLNMhEFJqdPlJhx2kBmxUQIVOiEipfqJchoA5nO0T9rTUN57FKsEmkcKAFms69Vub4YX4unGK4umnlHhPgSpeeTFZLUgjtvdfa5tWMOowpapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WiH2eU8StJTNqxbk9KjsPEaaYfZxGGX9G0uS10dJZw4=;
 b=lws6wt3gVw1KiwPzZ0UNAy9OkydOEcp20OQhUD/6NsRiQ7D0EUwnw2YIdNNe0nvkCUZtg79vMLL/1KfLAWpuBcEIE+90VjG2nKFCwn6Fe+vwDMDTndp8zqtUbNvgYNuQFmX+P6CNCO2tbRykC6kPjApmiutcFqF4WI0thqt2A70Ja2/MiToCfVrKMB2qz8vGlDcPVE9OrhT0jpRS5ZII6LblfcdFhM2WtjpwAtEAxmVoVaHapmm8JGugWyna+madmYnDv6SU1qk8sIC4arJE0zNTZ1JWSIsGLRMmmkQiP+h7uHOcDfWZ1NZkhCLgteq9Pbeeb0VMe7yj34yDUsN0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiH2eU8StJTNqxbk9KjsPEaaYfZxGGX9G0uS10dJZw4=;
 b=PZffNJCGyyJh8DFr6QyFrx4TfdzR1Q+26623qZ6EshZFPhSmD8SFQPMP6pz2jYEVELXVvgSbTPqLRRJEpmdHqN9nx9JYHHiKA9sZPXKEo4o8VMTNO8KstamKTDrAtyp3fdzqGjN+FWGPSKLpI+YwQwuHIqqZEaHHAKdQ0TGCBYc=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by CH3PR05MB10028.namprd05.prod.outlook.com (2603:10b6:610:12a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 17:30:33 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 17:30:33 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Thread-Topic: [PATCH] .debug ignore - to squash with efi:keep efi
Thread-Index: AQHZqVWDf5w4tNQCEUqmflxCd5u7p6+f37YAgAAA/wCAAJkOAA==
Date:   Wed, 28 Jun 2023 17:30:33 +0000
Message-ID: <848CBDF7-51AB-4277-9217-B43B566CF60A@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628-646da878865323f64fc52452@orel>
 <20230628-b2233c7a1459191cc7b0c9c0@orel>
In-Reply-To: <20230628-b2233c7a1459191cc7b0c9c0@orel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|CH3PR05MB10028:EE_
x-ms-office365-filtering-correlation-id: 49b95881-769a-45e2-8636-08db77fd6096
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIJks8M2cofQPiwe6VvhNUd99+792rJz4x4xTXdsHTLPuCEBafSz8WMDA1QpEjAz2loNRmgRIllH3BYjLf7ON8EBq1aqt+zL6VPqYak7kndLvO3JI+An9PHpQcyo8Z7Cc7VLGMovFIzMrci08m9Ba52vHAH2dB1ES5wovc9W400/+1cNDIc4t8edBKjsf9pAO5tp8C5cEqCSqbyFxv++FAPrdFy3KAJzZn4luk+MyX6FsxVh86oEYp6Ukhx0AUCPf1tDD+gyeE8QLk8D/eCgl9DJs8+dFv3XxCjCR8CitpzsjD3H3FRExIKiDC04HzYEad4ZJfhhawTUhcGVNgZAj7OK0bKKR6WWwWhZQScEMHC9mAap36nfK3MGcYOODPa2fycIb/OzNiEYOeRLT/OixN+hIoxCYxcjboerWVrQKYr0ptpuc8IvPVnGL2EzCeQUtGjCgdyIRRIQ2z15ObYI6DQYzTveeuLkpUPeQSYhSNGp2nVUYIdAAqw+2CiTIsumuInylnXRkZCGDF/W4BT4zE68MT+RDRyom6SkeibYammUQeDBzCtv+vzaVVqPDRvYuABYciEJJW4T+ESXZwHVPjV3c3uRGhrbg18zfkxqLBiSOoT/dVAm7pdSS5ktOlzuf84SR3RiHyEAubqZCq97elR3XBENXghhTTsmfrzo834tfb74THcPYrKIaW3vkUzzUXrhEIbbBRHqUY4TgP27iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(5660300002)(66946007)(76116006)(66556008)(64756008)(66446008)(4326008)(66476007)(6916009)(33656002)(478600001)(36756003)(316002)(8936002)(8676002)(4744005)(2906002)(54906003)(38070700005)(41300700001)(6486002)(71200400001)(186003)(86362001)(26005)(6506007)(6512007)(53546011)(122000001)(2616005)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1cyMXJZditiTS9kODdESnlFVmhjeHdnYTZENW0wK3VlanAzdENyL0Q4ZE8v?=
 =?utf-8?B?NHRYTHJLeWJkTE4yOWVPVE1peVcxcjQvVHFsRU4zTHFpY1RJbTdyakpmajNh?=
 =?utf-8?B?ZDh5Lzc0dS9QSlgvcVBBWkUwa0F4YzRYTWZoMlM2NGxOWEJlTXFybmJ4VmYr?=
 =?utf-8?B?RUhSNTkwK2w0cmpEL2lLNWI4TURIRHZIbVorZTZ5REhuTDBmVHgyS2R0ZXBh?=
 =?utf-8?B?dTBmMFgySEUxaTJZOGQ3bTU1RmRsZDErV3B2KzlJS0xqQVF4SUw4UmwvZWht?=
 =?utf-8?B?bmxVc3VqeFUwZUJHVWNaTEp4Q0U2V3dqYXZCaThLUnJoamcyVWpOZjd2ZTQv?=
 =?utf-8?B?c3B1ZkdzV2NQUnB3YUtQVkswQW1TcDhZUHR1cG5TUWQzT3pJSm41RHNkazlK?=
 =?utf-8?B?Nlh4NXhMa3B1YXYzbXZIQlVaK2xKZzNUTUczSTgyRWtkSlBFdjI2YmRDV3d4?=
 =?utf-8?B?V1VSUGNsVExURDNoZmpiRElzM3pRQ3o0QjE4Ui81aG4rUHhOSVI5S1VpNjNh?=
 =?utf-8?B?YXAyNE5sQ2E1eGlMTFlaMGp1bHNGdmE3YUNQbzMvMVFzWVg5Yi94S0VtWDh6?=
 =?utf-8?B?SHA4WFJZbHhzNWtPa3lDZGl4cGdFVE9KY2VNWDhaRFJKVTBaWXlTNkl1Nnp5?=
 =?utf-8?B?R3AvWHcrUXkxMURXSVlYeEdwY2JPVEI5eU5DTVBFSTB4N01PbXFDTm84TDVy?=
 =?utf-8?B?N3pkaFo5TzdxSHIyRFpSM1hzZ3VzNEp3VkNtVWt6YzZFTG1Fay9WUGZtV3d1?=
 =?utf-8?B?Z2V1S09mQzhocUt4OW9kVnk0QTkyT0FQb1BCMG9MQjFBTjRMNE0yUjhBUTdF?=
 =?utf-8?B?MnZackpMQXA3eDRvQnh3N0JHVkhsdDdDWDhRaVlhZGtCcEtWa3pGc1dSQnFF?=
 =?utf-8?B?Y1JwRGpiNWVoZnh5czlhS0xjZnM1clRtUTlWTHlucjUyRjR6bDNtT2pVck85?=
 =?utf-8?B?RFAvL05XUFI5N2sxRE1ySUNFYmFZRUFVRGN0MkorOVl0M2VZV040a1I4bCtx?=
 =?utf-8?B?VVY2U3B4MDVLWDZkV3ZqbnZ2QjJYT3ZkZklXOUNsRDNKdEsvQlRNby9wbUg3?=
 =?utf-8?B?WnY4cHJWeDB5SDFxWkUvVnBFNmdrc0pJNWRHUXZvOFdQRlgwYzU5SUVvNHJ6?=
 =?utf-8?B?d09KdlFWNmlDaWl4U092QVV6Vmc3ZGNpVXFYM2NFYVV1V3RFUy9mYmp3WU1n?=
 =?utf-8?B?YkhEdUhWbW1RWWhRUEV2NlhYcnNXZWFreHpjNXo1R3A5L0NDeVl1R3BZTXNK?=
 =?utf-8?B?cEIyRmN5M1JGRm50MW5ydzJFUW9SZVBuZ01XS05YZ3FGRmwyOU93OVNBMnJy?=
 =?utf-8?B?NVgvamhwSllvT0ZpMXM1ejU5RldjYlIvcFgyTHUvZTBXT09TTFg1ZTRhbElV?=
 =?utf-8?B?QnBHSjlZS2ZBdTB1K0tXZWttQ0J1a3l3SjArN3kzQlgwNG8wZWhUV2JFN1hW?=
 =?utf-8?B?Ylg3TXJyTWhxaUxQMEkyeVJ1U3UyU1Y5Uk9RUmxBQUgzbzFwWjBrWmRhSkl3?=
 =?utf-8?B?eHZUb2trNWwyWTlqTW1yTmFiKy9mMGJPWFJOaWE3V3dFL3ZTK2dnQ0FsMmxl?=
 =?utf-8?B?MzFnQWo0dElueXBlZjBaUkI4VUE4dXhWM3QydXIrYjlEelZsOXJBRFVwd0RU?=
 =?utf-8?B?cWRJNEdlNkIvTEdJWnRwSm1iWGJOTDVMU3o2VjFCbllmYVBYMTBoUzJJWkIz?=
 =?utf-8?B?UHRUTXVXOUlQY1M5UkJJRWlpZGZoZzJwaFZjMmpsN3d0ZEVBcWU4c0dsMDUv?=
 =?utf-8?B?cU1mcUR3emFvVVh0TXFjTU9VL01MZkMrOVNJR3U0K3RHdkNVaHJmNGFKRHdO?=
 =?utf-8?B?cTQ3QlhNRzlyVHhUcXBiNHNhcnZhVVlXUVduOGh6b2UvUG9NeHMrR2RMQS9s?=
 =?utf-8?B?M21mcWVScnFNcldQeWdpQTBGd0pIblFZSVphNCswQ05OcGNEWkpseXRmNlRo?=
 =?utf-8?B?Q01ObnE2Y3EwUW1lb2JmQ1d3d2NGMFM5SUFncUs3V2lCTGtQRFFsaERUUTR5?=
 =?utf-8?B?V2lsNkFqdkNnaVFadUtIcGorSVhBL0F1WFZBWUNid2o3ZXBiVEI2WTVsRGZL?=
 =?utf-8?B?VG1XKysvNzVuR3p6S3g2Zkd5QTY0ajNCNGlVa2ZXVFlkb0Fza0FCUHgyRmla?=
 =?utf-8?Q?7X3pLXmEccdY3vae+RT9bKBCI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <709857BC442DF94892C0F5CD686D6E2F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b95881-769a-45e2-8636-08db77fd6096
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 17:30:33.3466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2bIiVuUxLee7At0EcH8LNrD6YHVYMJixWzTouQaJFJpnFaq9bndBiNUat1Qptud/XrHTQwS974NPJPHOu5vU5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR05MB10028
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDI4LCAyMDIzLCBhdCAxOjIyIEFNLCBBbmRyZXcgSm9uZXMgPGFuZHJldy5q
b25lc0BsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gISEgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9u
IFdlZCwgSnVuIDI4LCAyMDIzIGF0IDEwOjE5OjAzQU0gKzAyMDAsIEFuZHJldyBKb25lcyB3cm90
ZToNCj4+IE9uIFdlZCwgSnVuIDI4LCAyMDIzIGF0IDEyOjEzOjQ4QU0gKzAwMDAsIE5hZGF2IEFt
aXQgd3JvdGU6DQo+Pj4gRnJvbTogTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4+IA0K
Pj4gTWlzc2luZyBzLW8tYi4NCj4+IA0KPj4+IA0KPj4+IC0tLQ0KPj4+IC5naXRpZ25vcmUgfCAx
ICsNCj4+PiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4+PiANCj4+PiBkaWZmIC0t
Z2l0IGEvLmdpdGlnbm9yZSBiLy5naXRpZ25vcmUNCj4+PiBpbmRleCAyOWYzNTJjLi4yMTY4ZTAx
IDEwMDY0NA0KPj4+IC0tLSBhLy5naXRpZ25vcmUNCj4+PiArKysgYi8uZ2l0aWdub3JlDQo+Pj4g
QEAgLTcsNiArNyw3IEBAIHRhZ3MNCj4+PiAqLmZsYXQNCj4+PiAqLmVmaQ0KPj4+ICouZWxmDQo+
Pj4gKyouZGVidWcNCj4+PiAqLnBhdGNoDQo+Pj4gLnBjDQo+Pj4gcGF0Y2hlcw0KPj4+IC0tDQo+
Pj4gMi4zNC4xDQo+Pj4gDQo+PiANCj4+IFRoZSBwYXRjaCB0aHJlYWRpbmcgaXMgYnVzdGVkLiBF
dmVyeXRoaW5nIGluIHRoZSB0aHJlYWQsIGluY2x1ZGluZyB0aGUNCj4+IGNvdmVyIGxldHRlciwg
aXMgaW4gcmVwbHkgdG8gdGhpcyBwYXRjaC4NCj4+IA0KPiANCj4gT0ssIEkgc2VlIHRoZSAuZ2l0
aWdub3JlIGh1bmsgaW4gcGF0Y2ggMSwgd2hpY2ggaXMgZ29vZCwgc2luY2UgaXQNCj4gY2VydGFp
bmx5IGRvZXNuJ3QgbmVlZCBpdHMgb3duIHBhdGNoLiBJJ2xsIGp1c3QgaWdub3JlIHRoaXMgInBh
dGNo4oCdLg0KDQpFbWJhcnJhc3NpbmfigKYgV2lsbCBzZW5kIHY0Lg0KDQoNCg==
