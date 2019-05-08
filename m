Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655E417EE0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfEHRIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:08:50 -0400
Received: from mail-eopbgr680050.outbound.protection.outlook.com ([40.107.68.50]:43310
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728533AbfEHRIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRc7c7bd+GcgAzXiJMvwdmCUjCV8vPrHIOjtJLuAVDo=;
 b=yxS7efzjBGGjejEywvNdSVcDRQ8hCFSDgOIUETRpRjJDdU7dV2NbgKd+Uj5jvLxPwvxS7s8pAwaEXtHl5sm0FqNaQxFKQVwUEHSF4R5j6OHCrD2ScKxAmtI7gJNO1SukNXNvUQr2lnClX3FjW8CZJTsrRsqYoxfC09CxWWRlSDU=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3900.namprd12.prod.outlook.com (10.255.174.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.15; Wed, 8 May 2019 17:08:44 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c96d:c1dd:fd7a:ffd6]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c96d:c1dd:fd7a:ffd6%4]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 17:08:44 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
CC:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/kvm/pmu: Set AMD's virt PMU version to 1
Thread-Topic: [PATCH] x86/kvm/pmu: Set AMD's virt PMU version to 1
Thread-Index: AQHVBb/mS9VAzcalzkCSb/KPnXiDFKZhdd6A
Date:   Wed, 8 May 2019 17:08:44 +0000
Message-ID: <aba3fd5b-e1ba-df66-2414-3f1109b68bbb@amd.com>
References: <20190508170248.15271-1-bp@alien8.de>
In-Reply-To: <20190508170248.15271-1-bp@alien8.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:805:8e::25) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a60e92c-1bb3-4bbc-96fb-08d6d3d7d38a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3900;
x-ms-traffictypediagnostic: DM6PR12MB3900:
x-microsoft-antispam-prvs: <DM6PR12MB3900743CE413AEF99AE7B21EEC320@DM6PR12MB3900.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(110136005)(4326008)(386003)(66574012)(6246003)(54906003)(31696002)(76176011)(86362001)(6506007)(14454004)(53546011)(71190400001)(71200400001)(5660300002)(2616005)(3846002)(486006)(6116002)(7416002)(476003)(11346002)(478600001)(446003)(36756003)(72206003)(8676002)(66946007)(81156014)(66556008)(26005)(81166006)(53936002)(66476007)(66446008)(64756008)(2906002)(316002)(256004)(14444005)(31686004)(6512007)(66066001)(6436002)(7736002)(25786009)(52116002)(102836004)(229853002)(6486002)(99286004)(68736007)(73956011)(186003)(305945005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3900;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UPV4OFbRJY34pjL9TZqgLBmyGP5anJnQrtSHIk8z96v6fKOyGD34Rq1ADAADeN1OfUpMKSPHBZH/SFSTw14ksnUkgCUMyWRVja789YLNYmJ7M7OKlwo9TvBblov/caT7AVdDRwUdJt3GqmEOKXhe5pyp2zYbmXV92jsXqxnDQz71y8YcYKD3YNqRwrIsdTwA9UTCqrR1WuA8/tEIPGeBKKTiH5y4WopyIEW48UhRoOlfKQiLPvc4AQ/KVedNrbW0D2wddrcQgDvLfmpmtQSMyRjdZz9/f97gp8ttFPaACFUISul44xt9j/pakf50e0384aARbpFRP12O/5iU8y/PrvJxnKNU4e3HJ8kEA5sWQDldzZccQKlU8O/mxLfS9pDzMrQSpBQubTFrvTck7EvzxFSUunQjDbYXeUKnNHX7yQM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64EC247CC08F0A49A4C351A1F4E3E622@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a60e92c-1bb3-4bbc-96fb-08d6d3d7d38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 17:08:44.3460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3900
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS84LzE5IDEyOjAyIFBNLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6DQo+IEZyb206IEJvcmlz
bGF2IFBldGtvdiA8YnBAc3VzZS5kZT4NCj4gDQo+IEFmdGVyIGNvbW1pdDoNCj4gDQo+ICAgNjcy
ZmY2Y2ZmODBjICgiS1ZNOiB4ODY6IFJhaXNlICNHUCB3aGVuIGd1ZXN0IHZDUFUgZG8gbm90IHN1
cHBvcnQgUE1VIikNCg0KWW91IHNob3VsZCBhZGQgdGhpcyBjb21taXQgYXMgYSBmaXhlcyB0YWcu
IFNpbmNlIHRoYXQgY29tbWl0IHdlbnQgaW50byA1LjENCml0IHdvdWxkIGJlIHdvcnRoIHRoaXMg
Zml4IGdvaW5nIGludG8gdGhlIDUuMSBzdGFibGUgdHJlZS4NCg0KVGhhbmtzLA0KVG9tDQoNCj4g
DQo+IG15IEFNRCBndWVzdHMgc3RhcnRlZCAjR1BpbmcgbGlrZSB0aGlzOg0KPiANCj4gICBnZW5l
cmFsIHByb3RlY3Rpb24gZmF1bHQ6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUA0KPiAgIENQVTogMSBQ
SUQ6IDQzNTUgQ29tbTogYmFzaCBOb3QgdGFpbnRlZCA1LjEuMC1yYzYrICMzDQo+ICAgSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS4x
Mi4wLTEgMDQvMDEvMjAxNA0KPiAgIFJJUDogMDAxMDp4ODZfcGVyZl9ldmVudF91cGRhdGUrMHgz
Yi8weGEwDQo+IA0KPiB3aXRoIENvZGU6IHBvaW50aW5nIHRvIFJEUE1DLiBJdCBpcyBSRFBNQyBi
ZWNhdXNlIHRoZSBndWVzdCBoYXMgdGhlDQo+IGhhcmR3YXJlIHdhdGNoZG9nIENPTkZJR19IQVJE
TE9DS1VQX0RFVEVDVE9SX1BFUkYgZW5hYmxlZCB3aGljaCB1c2VzDQo+IHBlcmYuIEluc3RydW1l
bnRpbmcga3ZtX3BtdV9yZHBtYygpIHNvbWUsIHNob3dlZCB0aGF0IGl0IGZhaWxzIGR1ZSB0bzoN
Cj4gDQo+ICAgaWYgKCFwbXUtPnZlcnNpb24pDQo+ICAgICAgICAgcmV0dXJuIDE7DQo+IA0KPiB3
aGljaCB0aGUgYWJvdmUgY29tbWl0IGFkZGVkLiBTaW5jZSBBTUQncyBQTVUgbGVhdmVzIHRoZSB2
ZXJzaW9uIGF0IDAsDQo+IHRoYXQgY2F1c2VzIHRoZSAjR1AgaW5qZWN0aW9uIGludG8gdGhlIGd1
ZXN0Lg0KPiANCj4gU2V0IHBtdS0+dmVyc2lvbiBhcmJpdHJhcmlseSB0byAxIGFuZCBtb3ZlIGl0
IGFib3ZlIHRoZSBub24tYXBwbGljYWJsZQ0KPiBzdHJ1Y3Qga3ZtX3BtdSBtZW1iZXJzLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQm9yaXNsYXYgUGV0a292IDxicEBzdXNlLmRlPg0KPiBDYzogIkgu
IFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4NCj4gQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0By
ZWRoYXQuY29tPg0KPiBDYzogSmFuYWthcmFqYW4gTmF0YXJhamFuIDxKYW5ha2FyYWphbi5OYXRh
cmFqYW5AYW1kLmNvbT4NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IExpcmFuIEFs
b24gPGxpcmFuLmFsb25Ab3JhY2xlLmNvbT4NCj4gQ2M6IE1paGFpIENhcmFiYXMgPG1paGFpLmNh
cmFiYXNAb3JhY2xlLmNvbT4NCj4gQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5j
b20+DQo+IENjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+IENjOiAi
UmFkaW0gS3LEjW3DocWZIiA8cmtyY21hckByZWRoYXQuY29tPg0KPiBDYzogVGhvbWFzIEdsZWl4
bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQo+IENjOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5k
YWNreUBhbWQuY29tPg0KPiBDYzogeDg2QGtlcm5lbC5vcmcNCj4gLS0tDQo+ICBhcmNoL3g4Ni9r
dm0vcG11X2FtZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3BtdV9hbWQuYyBi
L2FyY2gveDg2L2t2bS9wbXVfYW1kLmMNCj4gaW5kZXggMTQ5NWE3MzViMzhlLi41MGZhOTQ1MGZj
ZjEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9wbXVfYW1kLmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL3BtdV9hbWQuYw0KPiBAQCAtMjY5LDEwICsyNjksMTAgQEAgc3RhdGljIHZvaWQgYW1k
X3BtdV9yZWZyZXNoKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gDQo+ICAgICAgICAgcG11LT5j
b3VudGVyX2JpdG1hc2tbS1ZNX1BNQ19HUF0gPSAoKHU2NCkxIDw8IDQ4KSAtIDE7DQo+ICAgICAg
ICAgcG11LT5yZXNlcnZlZF9iaXRzID0gMHhmZmZmZmZmZjAwMjAwMDAwdWxsOw0KPiArICAgICAg
IHBtdS0+dmVyc2lvbiA9IDE7DQo+ICAgICAgICAgLyogbm90IGFwcGxpY2FibGUgdG8gQU1EOyBi
dXQgY2xlYW4gdGhlbSB0byBwcmV2ZW50IGFueSBmYWxsIG91dCAqLw0KPiAgICAgICAgIHBtdS0+
Y291bnRlcl9iaXRtYXNrW0tWTV9QTUNfRklYRURdID0gMDsNCj4gICAgICAgICBwbXUtPm5yX2Fy
Y2hfZml4ZWRfY291bnRlcnMgPSAwOw0KPiAtICAgICAgIHBtdS0+dmVyc2lvbiA9IDA7DQo+ICAg
ICAgICAgcG11LT5nbG9iYWxfc3RhdHVzID0gMDsNCj4gIH0NCj4gDQo+IC0tDQo+IDIuMjEuMA0K
PiANCg==
