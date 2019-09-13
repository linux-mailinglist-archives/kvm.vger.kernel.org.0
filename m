Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1495B2287
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 16:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbfIMOuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 10:50:12 -0400
Received: from mail-eopbgr730052.outbound.protection.outlook.com ([40.107.73.52]:9879
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388704AbfIMOuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 10:50:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXtzYHn+0Nh9BiVU7G2IeNP0M5MTSzk4IcTOn6MJPi3Q94Nsc9m8HC7ppRGhXSqo5SVPa2VdCZRfK3rUBUs7LBNK93LirMjZ+RA3w1Wq6bQEfdzyCHMLKwrkcBh93IKpPpL/iE3RX5plD/nGDbVakSQZMrUzk5kcrYOu8jnUfnHlTpwpfiMJlgZzqTwBc5n/l7QizgZRQiYMBJjlj5DbNNYmBG3ihEXKm+yXwSYrmb8ce7qSJPONp51wfq+09QJYRcdngSgqhqjrBTdJYXLG5eeFSevs3fsZzJDnfVczSOsHiCWHLo6h4OXa+Gy4c8MXnKFn3RdVGApQWvD02nA6MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VkyWBtX7MnH2st5R335Av9Zj6aTIKgP5lS3MtJfzbE=;
 b=U395e7OXNzCcE8n05o7lOXRcur8Ci1i5Hm0H8ICBwi4d2GfnwFz+odMkSiwbW1vpcXiR3jAvpEeIp5tV/VEFbPlPOJx+pToVM9Qlk22+YXWYvpXnIrr8QTFHBVrsyycn3GQCb3Z/z+QQNwtTrAKJfkPFmWN7VpzEHayIkA7jW4SEGNbO2STdk6RlU1MDkcISPd4fhh2JEZxwbAqxaYgkH5yvLbyJXgjxipOf+0YgZiL9OMdK/THyw8OaIb9nQgWSrE8eF5LiFJSJqzmFFAs1loUGrSTRfj5Qj1CkhLh5Oo7k4uVhvNS9485zz9VH999g2gKlQ4bke6IVc1GNMVtV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VkyWBtX7MnH2st5R335Av9Zj6aTIKgP5lS3MtJfzbE=;
 b=LuPTzpoII2u3APNZrr9wFSfywWdq42lEEW7TMdt5IKEtocdC0to148ANwsyHbwEqJ8Pw/5ILrnF4qdg5y32BD/4Y1jI7wyW1edbQdvlO/4eGVdoFAUo/OrteimfSOBEC9EBCnxRcArCd3nQk3Ya4o63qeUUVxchZlcb76yLmuFU=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3625.namprd12.prod.outlook.com (20.178.199.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Fri, 13 Sep 2019 14:50:07 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 14:50:07 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Alexander Graf <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
Thread-Topic: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
Thread-Index: AQHVU4YGnOwcrgTvnU6R6KE2IzCt16cCTo6AgAtVMYCAASPZgIAbFmaA
Date:   Fri, 13 Sep 2019 14:50:06 +0000
Message-ID: <d0babea8-1f40-3f12-9b96-b5515dc6636f@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
 <ac9fa8d4-2c25-52a5-3938-3ce373b3c3e0@amazon.com>
 <8320fecb-de61-1a01-b90d-a45f224de287@amd.com>
 <a72ac8cc-d0df-9a3f-dff2-0e85e944fb74@amazon.com>
In-Reply-To: <a72ac8cc-d0df-9a3f-dff2-0e85e944fb74@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN4PR0501CA0098.namprd05.prod.outlook.com
 (2603:10b6:803:42::15) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b32c11c7-d27f-445f-f2ad-08d73859aab1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3625;
x-ms-traffictypediagnostic: DM6PR12MB3625:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3625293F5BDAF460FEBE135EF3B30@DM6PR12MB3625.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(58126008)(66946007)(110136005)(66446008)(66476007)(5660300002)(54906003)(316002)(478600001)(64756008)(66556008)(6512007)(6306002)(229853002)(53936002)(486006)(14444005)(305945005)(65806001)(65956001)(66066001)(6436002)(86362001)(99286004)(2201001)(36756003)(31696002)(14454004)(102836004)(71190400001)(71200400001)(386003)(6506007)(53546011)(4326008)(186003)(26005)(2501003)(3846002)(2906002)(6116002)(52116002)(76176011)(6486002)(31686004)(8676002)(11346002)(256004)(476003)(2616005)(7736002)(446003)(6246003)(25786009)(8936002)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3625;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b7K+K7eL6ETHklTbE21UOyYBZp6sVaKRPtReEVIl/S/NEvtWmqCEEm74LEXjOCpydOtV1utg9u59b0ZJOwEX5iZ//j8DidCwjOsG3qYbXp+IwwCsz4C7LasTFBy0NRTbGODuhTzc2qwElw2MzZARUniTFL8OyUxvHa7nV6sVvQKpgTuunTNI95d6L3Wmy/Esqb75vQCsWLkawuYgr5PpRuY0F8DFukr3JWIj8CW62waN8eE6fz4z11eQjqNkZDu5xFzF1A3yusnCeXRRAtQiRoo+IUS+Zx6BN4ngN5HQHqvRorBAnJRYm+bFjT8Xlk29b6bzyc0eG41XVEh8SQmZf0Tmn2tme2STCqO/0A4N0lH0YCOPNdw3ZtUSBtZZa0uUmrLvt6y2m1eFVsrnM72ViqP4cNIFmI29AxQJVF2VuM4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67A1E2C8BB1B4148A683917F94D064E8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32c11c7-d27f-445f-f2ad-08d73859aab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 14:50:06.8585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EhdNZoK9NFgWaoIFj+9hEmCLT0nxanbpBvbv7c0R6j6G30+OuxilPvB4aycvPQHsCnyT/rbBJPKbDx0kcPPuIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3625
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8yNy8xOSA0OjEwIEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4gDQo+
IE9uIDI2LjA4LjE5IDIyOjQ2LCBTdXRoaWt1bHBhbml0LCBTdXJhdmVlIHdyb3RlOg0KPj4gQWxl
eCwNCj4+DQo+PiBPbiA4LzE5LzIwMTkgNTo0MiBBTSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6DQo+
Pj4NCj4+Pg0KPj4+IE9uwqAxNS4wOC4xOcKgMTg6MjUswqBTdXRoaWt1bHBhbml0LMKgU3VyYXZl
ZcKgd3JvdGU6DQo+Pj4+IEFDS8Kgbm90aWZpZXJzwqBkb24ndMKgd29ya8Kgd2l0aMKgQU1EwqBT
Vk3CoHcvwqBBVklDwqB3aGVuwqB0aGXCoFBJVMKgaW50ZXJydXB0DQo+Pj4+IGlzwqBkZWxpdmVy
ZWTCoGFzwqBlZGdlLXRyaWdnZXJlZMKgZml4ZWTCoGludGVycnVwdMKgc2luY2XCoEFNRMKgcHJv
Y2Vzc29ycw0KPj4+PiBjYW5ub3TCoGV4aXTCoG9uwqBFT0nCoGZvcsKgdGhlc2XCoGludGVycnVw
dHMuDQo+Pj4+DQo+Pj4+IEFkZMKgY29kZcKgdG/CoGNoZWNrwqBMQVBJQ8KgcGVuZGluZ8KgRU9J
wqBiZWZvcmXCoGluamVjdGluZ8KgYW55wqBwZW5kaW5nwqBQSVQNCj4+Pj4gaW50ZXJydXB0wqBv
bsKgQU1EwqBTVk3CoHdoZW7CoEFWSUPCoGlzwqBhY3RpdmF0ZWQuDQo+Pj4+DQo+Pj4+IFNpZ25l
ZC1vZmYtYnk6wqBTdXJhdmVlwqBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRA
YW1kLmNvbT4NCj4+Pj4gLS0tDQo+Pj4+IMKgwqDCoGFyY2gveDg2L2t2bS9pODI1NC5jwqB8wqAz
McKgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPj4+PiDCoMKgwqAxwqBmaWxlwqBj
aGFuZ2VkLMKgMjXCoGluc2VydGlvbnMoKykswqA2wqBkZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4g
ZGlmZsKgLS1naXTCoGEvYXJjaC94ODYva3ZtL2k4MjU0LmPCoGIvYXJjaC94ODYva3ZtL2k4MjU0
LmMNCj4+Pj4gaW5kZXjCoDRhNmRjNTQuLjMxYzRhOWLCoDEwMDY0NA0KPj4+PiAtLS3CoGEvYXJj
aC94ODYva3ZtL2k4MjU0LmMNCj4+Pj4gKysrwqBiL2FyY2gveDg2L2t2bS9pODI1NC5jDQo+Pj4+
IEBAwqAtMzQsMTDCoCszNCwxMsKgQEANCj4+Pj4gwqDCoMKgI2luY2x1ZGXCoDxsaW51eC9rdm1f
aG9zdC5oPg0KPj4+PiDCoMKgwqAjaW5jbHVkZcKgPGxpbnV4L3NsYWIuaD4NCj4+Pj4gKyNpbmNs
dWRlwqA8YXNtL3ZpcnRleHQuaD4NCj4+Pj4gwqDCoMKgI2luY2x1ZGXCoCJpb2FwaWMuaCINCj4+
Pj4gwqDCoMKgI2luY2x1ZGXCoCJpcnEuaCINCj4+Pj4gwqDCoMKgI2luY2x1ZGXCoCJpODI1NC5o
Ig0KPj4+PiArI2luY2x1ZGXCoCJsYXBpYy5oIg0KPj4+PiDCoMKgwqAjaW5jbHVkZcKgIng4Ni5o
Ig0KPj4+PiDCoMKgwqAjaWZuZGVmwqBDT05GSUdfWDg2XzY0DQo+Pj4+IEBAwqAtMjM2LDbCoCsy
MzgsMTLCoEBAwqBzdGF0aWPCoHZvaWTCoGRlc3Ryb3lfcGl0X3RpbWVyKHN0cnVjdMKga3ZtX3Bp
dMKgKnBpdCkNCj4+Pj4gwqDCoMKgwqDCoMKgwqBrdGhyZWFkX2ZsdXNoX3dvcmsoJnBpdC0+ZXhw
aXJlZCk7DQo+Pj4+IMKgwqDCoH0NCj4+Pj4gK3N0YXRpY8KgaW5saW5lwqB2b2lkwqBrdm1fcGl0
X3Jlc2V0X3JlaW5qZWN0KHN0cnVjdMKga3ZtX3BpdMKgKnBpdCkNCj4+Pj4gK3sNCj4+Pj4gK8Kg
wqDCoMKgYXRvbWljX3NldCgmcGl0LT5waXRfc3RhdGUucGVuZGluZyzCoDApOw0KPj4+PiArwqDC
oMKgwqBhdG9taWNfc2V0KCZwaXQtPnBpdF9zdGF0ZS5pcnFfYWNrLMKgMSk7DQo+Pj4+ICt9DQo+
Pj4+ICsNCj4+Pj4gwqDCoMKgc3RhdGljwqB2b2lkwqBwaXRfZG9fd29yayhzdHJ1Y3TCoGt0aHJl
YWRfd29ya8KgKndvcmspDQo+Pj4+IMKgwqDCoHsNCj4+Pj4gwqDCoMKgwqDCoMKgwqBzdHJ1Y3TC
oGt2bV9waXTCoCpwaXTCoD3CoGNvbnRhaW5lcl9vZih3b3JrLMKgc3RydWN0wqBrdm1fcGl0LMKg
ZXhwaXJlZCk7IA0KPj4+Pg0KPj4+PiBAQMKgLTI0NCw2wqArMjUyLDIzwqBAQMKgc3RhdGljwqB2
b2lkwqBwaXRfZG9fd29yayhzdHJ1Y3TCoGt0aHJlYWRfd29ya8KgKndvcmspDQo+Pj4+IMKgwqDC
oMKgwqDCoMKgaW50wqBpOw0KPj4+PiDCoMKgwqDCoMKgwqDCoHN0cnVjdMKga3ZtX2twaXRfc3Rh
dGXCoCpwc8KgPcKgJnBpdC0+cGl0X3N0YXRlOw0KPj4+PiArwqDCoMKgwqAvKg0KPj4+PiArwqDC
oMKgwqDCoCrCoFNpbmNlLMKgQU1EwqBTVk3CoEFWSUPCoGFjY2VsZXJhdGVzwqB3cml0ZcKgYWNj
ZXNzwqB0b8KgQVBJQ8KgRU9JDQo+Pj4+ICvCoMKgwqDCoMKgKsKgcmVnaXN0ZXLCoGZvcsKgZWRn
ZS10cmlnZ2VywqBpbnRlcnJ1cHRzLsKgUElUwqB3aWxswqBub3TCoGJlwqBhYmxlDQo+Pj4+ICvC
oMKgwqDCoMKgKsKgdG/CoHJlY2VpdmXCoHRoZcKgSVJRwqBBQ0vCoG5vdGlmaWVywqBhbmTCoHdp
bGzCoGFsd2F5c8KgYmXCoHplcm8uDQo+Pj4+ICvCoMKgwqDCoMKgKsKgVGhlcmVmb3JlLMKgd2XC
oGNoZWNrwqBpZsKgYW55wqBMQVBJQ8KgRU9JwqBwZW5kaW5nwqBmb3LCoHZlY3RvcsKgMA0KPj4+
PiArwqDCoMKgwqDCoCrCoGFuZMKgcmVzZXTCoGlycV9hY2vCoGlmwqBub8KgcGVuZGluZy4NCj4+
Pj4gK8KgwqDCoMKgwqAqLw0KPj4+PiArwqDCoMKgwqBpZsKgKGNwdV9oYXNfc3ZtKE5VTEwpwqAm
JsKga3ZtLT5hcmNoLmFwaWN2X3N0YXRlwqA9PcKgQVBJQ1ZfQUNUSVZBVEVEKcKgeyANCj4+Pj4N
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqBpbnTCoGVvacKgPcKgMDsNCj4+Pj4gKw0KPj4+PiArwqDC
oMKgwqDCoMKgwqDCoGt2bV9mb3JfZWFjaF92Y3B1KGkswqB2Y3B1LMKga3ZtKQ0KPj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWbCoChrdm1fYXBpY19wZW5kaW5nX2VvaSh2Y3B1LMKgMCkp
DQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVvaSsrOw0KPj4+PiArwqDC
oMKgwqDCoMKgwqDCoGlmwqAoIWVvaSkNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2
bV9waXRfcmVzZXRfcmVpbmplY3QocGl0KTsNCj4+Pg0KPj4+IEluwqB3aGljaMKgY2FzZcKgd291
bGTCoGVvacKgYmXCoCE9wqAwwqB3aGVuwqBBUElDLVbCoGlzwqBhY3RpdmU/DQo+Pg0KPj4gVGhh
dCB3b3VsZCBiZSB0aGUgY2FzZSB3aGVuIGd1ZXN0IGhhcyBub3QgcHJvY2Vzc2VkIGFuZC9vciBz
dGlsbCANCj4+IHByb2Nlc3NpbmcgdGhlIGludGVycnVwdC4NCj4+IE9uY2UgdGhlIGd1ZXN0IHdy
aXRlcyB0byBBUElDIEVPSSByZWdpc3RlciBmb3IgZWRnZS10cmlnZ2VyZWQgDQo+PiBpbnRlcnJ1
cHQgZm9yIHZlY3RvciAwLA0KPj4gYW5kIHRoZSBBVklDIGhhcmR3YXJlIGFjY2VsZXJhdGVkIHRo
ZSBhY2Nlc3MgYnkgY2xlYXJpbmcgdGhlIGhpZ2hlc3QgDQo+PiBwcmlvcml0eSBJU1IgYml0LA0K
Pj4gdGhlbiB0aGUgZW9pIHNob3VsZCBiZSB6ZXJvLg0KPiANCj4gVGhpbmtpbmcgYWJvdXQgdGhp
cyBhIGJpdCBtb3JlLCB5b3UncmUgYmFzaWNhbGx5IHNheWluZyB0aGUgaXJxIGFjayANCj4gbm90
aWZpZXIgbmV2ZXIgdHJpZ2dlcnMgYmVjYXVzZSB3ZSBkb24ndCBzZWUgdGhlIEVPSSByZWdpc3Rl
ciB3cml0ZSwgYnV0IA0KPiB3ZSBjYW4gZGV0ZXJtaW5lIHRoZSBzdGF0ZSBhc3luY2hyb25vdXNs
eS4NCg0KWWVzLCB3ZSBzaG91bGQgYmUgYWJsZSB0byBkZXRlcm1pbmUgdGhpcyBpbiBsYXp5IGZh
c2hpb24gb25seSB3aGVuIHdlIA0KbmVlZCB0byBpbmplY3QgbmV3IGludGVycnVwdHMuDQoNCj4g
VGhlIGlycWZkIGNvZGUgYWxzbyB1c2VzIHRoZSBhY2sgbm90aWZpZXIgZm9yIGxldmVsIGlycSBy
ZWluamVjdGlvbi4gDQo+IFdpbGwgdGhhdCBicmVhayBhcyB3ZWxsPw0KDQpJSVVDLCBpbiBjYXNl
IG9mIGlycWZkLCB0aGUgbm90aWZpZXIgaXMgb25seSB1c2VkIGZvciB0aGUgY2FzZSBvZiANCnJl
c2FtcGxpbmcgaXJxZmRzLCB3aGljaCBhcmUgc3BlY2lhbCB2YXJpZXR5IG9mIGlycWZkcyB1c2Vk
IHRvIGVtdWxhdGUgDQpsZXZlbCB0cmlnZ2VyZWQgaW50ZXJydXB0cyAoc2VlIGluY2x1ZGUvbGlu
dXgva3ZtX2lycWZkLmgpLiBUaGUgQVZJQyANCndvcmthcm91bmQgaXMgb25seSBuZWVkZWQgZm9y
IGhhbmRsaW5nIEVPSSBmb3IgZWRnZS10cmlnZ2VyIGludGVycnVwdHMuDQoNCj4gV291bGRuJ3Qg
aXQgbWFrZSBtb3JlIHNlbnNlIHRvIHRyeSB0byBlaXRoZXIgbWFpbnRhaW4gdGhlIGFjayBub3Rp
ZmllciANCj4gQVBJIG9yIHJlbW92ZSBpdCBjb21wbGV0ZWx5IGlmIHdlIGNhbid0IGZpbmQgYSB3
YXkgdG8gbWFrZSBpdCB3b3JrIHdpdGggDQo+IEFQSUMtVj8NCg0KTXkgdW5kZXJzdGFuZGluZyBp
cyB0aGF0IHRoZSBhY2sgbm90aWZpZXIgaXMgbmVlZGVkIGZvciBLVk0gdG8gc3VwcG9ydCANCktW
TV9SRUlOSkVDVF9DT05UUk9MIGlvY3RsIChtZW50aW9uZWQgaGVyZSANCihodHRwczovL2xrbWwu
b3JnL2xrbWwvMjAxOS8yLzYvMTMzKS4NCg0KPiBTbyB3aGF0IGlmIHdlIGRldGVjdCB0aGF0IGFu
IElSUSB2ZWN0b3Igd2UncmUgaW5qZWN0aW5nIGZvciBoYXMgYW4gaXJxIA0KPiBub3RpZmllcj8g
SWYgaXQgZG9lcywgd2Ugc2V0IHVwIC8gc3RhcnQ6DQo+IA0KPiAgwqAgKiBhbiBocnRpbWVyIHRo
YXQgcG9sbHMgZm9yIEVPSSBvbiB0aGF0IHZlY3Rvcg0KPiAgwqAgKiBhIGZsYWcgc28gdGhhdCBl
dmVyeSB2Y3B1IG9uIGV4aXQgY2hlY2tzIGZvciBFT0kgb24gdGhhdCB2ZWN0b3INCj4gIMKgICog
YSBkaXJlY3QgY2FsbCBmcm9tIHBpdF9kb193b3JrIHRvIGNoZWNrIG9uIGl0IGFzIHdlbGwNCj4g
DQo+IEVhY2ggb2YgdGhlbSB3b3VsZCBnbyB0aHJvdWdoIGEgc2luZ2xlIGNvZGUgcGF0aCB0aGF0
IHRoZW4gY2FsbHMgdGhlIA0KPiBhY2tfbm90aWZpZXIuDQo+IA0KPiBUaGF0IHdheSB3ZSBzaG91
bGQgYmUgYWJsZSB0byBqdXN0IG1haW50YWluIHRoZSBvbGQgQVBJIGFuZCBub3QgZ2V0IGludG8g
DQo+IHVucGxlYXNhbnQgc3VycHJpc2VzIHRoYXQgb25seSBtYW5pZmVzdCBvbiBhIHRpbnkgZmFj
dGlvbiBvZiBzeXN0ZW1zLCANCj4gcmlnaHQ/DQoNCkxldCBtZSBzZW5kIG91dCB2MyB0aGF0IHdp
bGwgY29uc29saWRhdGUgdGhpcyBpbnRvIGEgc2luZ2xlIGNvZGUgcGF0aC4NCg0KU3VyYXZlZQ0K
