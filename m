Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1326F7C472
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 16:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfGaOLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 10:11:09 -0400
Received: from mail-eopbgr140109.outbound.protection.outlook.com ([40.107.14.109]:64965
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729139AbfGaOLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 10:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+j8dKQy5xXHnHyDnXMOar1dAjCK1ZBMAIsPqIdGuOPbhqXujMcFneKvOQG+Yc+Q9lIsOrCP8dnMefKO0cfWquNBQc9e1s9PSiw29SzT4mlKuHH+gEJNUtG8t9SJ48DzFoC2iK0PQ6TI1KvSvAmp5IWFiAiP34TrCehCNamqje6fYrjlYwEQ2mFqCRxcGerr0zmWhUs2A1qXt0FtXing+vnfxG1fvheGhoiorq2pE2B4FMpZZ8gKp5SxrxopOvt+/XqiOvsjXprdDqPAOjGhAmjPBa9k63v5lgF2oze6XLcEZuoBEj6B+fkPSF9Qsa89ajuHH8g+mnG+9jkqAGJcmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo40vWdpwd1ITty2b7oC2ZfG8NLgVJn/pvkSmdLq1e8=;
 b=eu2DA0B23nO+iJyggeKcNmPzo6CX1iJ4oH4FZvaeq79eKta7oxb0OSd3hXmcwaN6YTAPFEBR4jb0WO/n6ezPUNgSb3JzyZNShnGneopJSYD8BWXwVrdqKn9riSCwHL8a1Jun2s49xNoiYxp9d/yrT3QXHxKgHnqTAbZRIAZxfN6WYM0+XR6zHWWTUL43fM9+L2QwiJD68r0nAukNJul37/VO/AitusFbu5HMEL7skT1OhE3GtIFX06XW2kK8SoEWvBZcp5fQ3XB3BhlFxdH2Mz7fIhv/cYISGHUzSZzV5Sp3XL1GPnHQEbVPkReLPSxWASYaWReeJFoPEqRtH5+YWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=virtuozzo.com;dmarc=pass action=none
 header.from=virtuozzo.com;dkim=pass header.d=virtuozzo.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo40vWdpwd1ITty2b7oC2ZfG8NLgVJn/pvkSmdLq1e8=;
 b=Wo+HR9R9mG9fyvSLMFQ9LfJkBo96zAHhWTaDzUaGJX8j4tw7eX6qG29sKnmGwrJIo6GkUFNpQuFrZCen3SmM0zmP0jwF0m9mZD37d6vFHt93nFS50JRzINheoBcboCbOeci+M6b9eAMLJ3+DJu03DPYzHhJyiOOtvQ/NgAjahTs=
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com (20.179.28.141) by
 VI1PR08MB2925.eurprd08.prod.outlook.com (10.170.239.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 14:11:02 +0000
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7]) by VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7%6]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 14:11:02 +0000
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "berto@igalia.com" <berto@igalia.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
Thread-Topic: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl
 call
Thread-Index: AQHVRvAnLLtzNA+T0EeBbI/1wGIp+qbjic2AgADKawCAAIB3AP//1EyAgAAEO4CAABh3gA==
Date:   Wed, 31 Jul 2019 14:11:02 +0000
Message-ID: <a38ae11d-4dee-d50b-7719-e65c5564a985@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <14b60c5b-6ed4-0f4d-17a8-6ec861115c1e@redhat.com>
 <30f40221-d2d2-780b-3375-910e9f755edd@de.ibm.com>
 <08958a7e-1952-caf7-ab45-2fd503db418c@virtuozzo.com>
 <bdbee2e0-62a7-8906-8076-408922511146@de.ibm.com>
 <f9346216-a4e9-4882-4a36-33580529b75e@de.ibm.com>
In-Reply-To: <f9346216-a4e9-4882-4a36-33580529b75e@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0043.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::32) To VI1PR08MB4399.eurprd08.prod.outlook.com
 (2603:10a6:803:102::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=andrey.shinkevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fd1d277-4db4-4b14-e509-08d715c0eb19
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB2925;
x-ms-traffictypediagnostic: VI1PR08MB2925:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR08MB292590FD99539B899048E0E0F4DF0@VI1PR08MB2925.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39850400004)(396003)(366004)(346002)(199004)(189003)(44832011)(36756003)(26005)(31686004)(316002)(2906002)(486006)(186003)(25786009)(446003)(8936002)(7416002)(6486002)(6506007)(53546011)(4326008)(386003)(11346002)(102836004)(476003)(107886003)(2616005)(6246003)(229853002)(3846002)(6116002)(52116002)(8676002)(76176011)(5660300002)(256004)(31696002)(66066001)(81156014)(110136005)(54906003)(81166006)(14454004)(478600001)(2501003)(68736007)(7736002)(6436002)(305945005)(966005)(71190400001)(71200400001)(64756008)(66446008)(86362001)(66476007)(66556008)(6306002)(2201001)(99286004)(66946007)(6512007)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2925;H:VI1PR08MB4399.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CzonHWE646gyXRK0cBojUmMP4tn0sdhd1DH3KIBRPEvOv2YVR2podEu/uhVXVIdyd8HAn3eWnhmuOlPr37vhXlAONeRvfWDMkQmw6GQyDentaFDkvb4H6HbiGLLhhUXwTT+HdNlvMqLl9eG7KgDWRQeUynY6Wf/O+qIOJ9jI6rx3Bz2tNBHV8qUqOjnyO0jKzJzWsHrHL9P9gIY96oKTsoq/bf5adRanm6zsk1YhmC53X9WcfGcP98FVdelhFqEJGeFc1aqRcQZH0J6/wxckdu6V44o5cnWKq5w1xKrcyU6oQPVHOgLBGax2T7pyC4W0S0HrMiHOovjZah0F4fwTLq833cWy/WS+khS0bFPs+cUA5ysJZLTtiAaAo8ZUjJC3Qd1ypMcHhswqy0aIjbmIMEm9fVthCyuk0W2H1HBL7v8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5473CA31068FF24A8CD187F03348F22F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd1d277-4db4-4b14-e509-08d715c0eb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 14:11:02.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: andrey.shinkevich@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2925
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDMxLzA3LzIwMTkgMTU6NDMsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToNCj4g
DQo+IA0KPiBPbiAzMS4wNy4xOSAxNDoyOCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOg0K
Pj4NCj4+DQo+PiBPbiAzMS4wNy4xOSAxNDowNCwgQW5kcmV5IFNoaW5rZXZpY2ggd3JvdGU6DQo+
Pj4gT24gMzEvMDcvMjAxOSAxMDoyNCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOg0KPj4+
Pg0KPj4+Pg0KPj4+PiBPbiAzMC4wNy4xOSAyMToyMCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4+
Pj4+IE9uIDMwLzA3LzE5IDE4OjAxLCBBbmRyZXkgU2hpbmtldmljaCB3cm90ZToNCj4+Pj4+PiBO
b3QgdGhlIHdob2xlIHN0cnVjdHVyZSBpcyBpbml0aWFsaXplZCBiZWZvcmUgcGFzc2luZyBpdCB0
byB0aGUgS1ZNLg0KPj4+Pj4+IFJlZHVjZSB0aGUgbnVtYmVyIG9mIFZhbGdyaW5kIHJlcG9ydHMu
DQo+Pj4+Pj4NCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXkgU2hpbmtldmljaCA8YW5kcmV5
LnNoaW5rZXZpY2hAdmlydHVvenpvLmNvbT4NCj4+Pj4+DQo+Pj4+PiBDaHJpc3RpYW4sIGlzIHRo
aXMgdGhlIHJpZ2h0IGZpeD8gIEl0J3Mgbm90IGV4cGVuc2l2ZSBzbyBpdCB3b3VsZG4ndCBiZQ0K
Pj4+Pj4gYW4gaXNzdWUsIGp1c3QgY2hlY2tpbmcgaWYgdGhlcmUncyBhbnkgYmV0dGVyIGFsdGVy
bmF0aXZlLg0KPj4+Pg0KPj4+PiBJIHRoaW5rIGFsbCBvZiB0aGVzZSB2YXJpYW50cyBhcmUgdmFs
aWQgd2l0aCBwcm9zIGFuZCBjb25zDQo+Pj4+IDEuIHRlYWNoIHZhbGdyaW5kIGFib3V0IHRoaXM6
DQo+Pj4+IEFkZCB0byBjb3JlZ3JpbmQvbV9zeXN3cmFwL3N5c3dyYXAtbGludXguYyAoYW5kIHRo
ZSByZWxldmFudCBoZWFkZXIgZmlsZXMpDQo+Pj4+IGtub3dsZWRnZSBhYm91dCB3aGljaCBwYXJ0
cyBhcmUgYWN0dWFsbHkgdG91Y2hlZC4NCj4+Pj4gMi4gdXNlIGRlc2lnbmF0ZWQgaW5pdGlhbGl6
ZXJzDQo+Pj4+IDMuIHVzZSBtZW1zZXQNCj4+Pj4gMy4gdXNlIGEgdmFsZ3JpbmQgY2FsbGJhY2sg
VkdfVVNFUlJFUV9fTUFLRV9NRU1fREVGSU5FRCB0byB0ZWxsIHRoYXQgdGhpcyBtZW1vcnkgaXMg
ZGVmaW5lZA0KPj4+Pg0KPj4+DQo+Pj4gVGhhbmsgeW91IGFsbCB2ZXJ5IG11Y2ggZm9yIHRha2lu
ZyBwYXJ0IGluIHRoZSBkaXNjdXNzaW9uLg0KPj4+IEFsc28sIG9uZSBtYXkgdXNlIHRoZSBWYWxn
cmluZCB0ZWNobm9sb2d5IHRvIHN1cHByZXNzIHRoZSB1bndhbnRlZA0KPj4+IHJlcG9ydHMgYnkg
YWRkaW5nIHRoZSBWYWxncmluZCBzcGVjaWZpYyBmb3JtYXQgZmlsZSB2YWxncmluZC5zdXBwIHRv
IHRoZQ0KPj4+IFFFTVUgcHJvamVjdC4gVGhlIGZpbGUgY29udGVudCBpcyBleHRlbmRhYmxlIGZv
ciBmdXR1cmUgbmVlZHMuDQo+Pj4gQWxsIHRoZSBjYXNlcyB3ZSBsaWtlIHRvIHN1cHByZXNzIHdp
bGwgYmUgcmVjb3VudGVkIGluIHRoYXQgZmlsZS4NCj4+PiBBIGNhc2UgbG9va3MgbGlrZSB0aGUg
c3RhY2sgZnJhZ21lbnRzLiBGb3IgaW5zdGFuY2UsIGZyb20gUUVNVSBibG9jazoNCj4+Pg0KPj4+
IHsNCj4+PiAgICAgIGh3L2Jsb2NrL2hkLWdlb21ldHJ5LmMNCj4+PiAgICAgIE1lbWNoZWNrOkNv
bmQNCj4+PiAgICAgIGZ1bjpndWVzc19kaXNrX2xjaHMNCj4+PiAgICAgIGZ1bjpoZF9nZW9tZXRy
eV9ndWVzcw0KPj4+ICAgICAgZnVuOmJsa2NvbmZfZ2VvbWV0cnkNCj4+PiAgICAgIC4uLg0KPj4+
ICAgICAgZnVuOmRldmljZV9zZXRfcmVhbGl6ZWQNCj4+PiAgICAgIGZ1bjpwcm9wZXJ0eV9zZXRf
Ym9vbA0KPj4+ICAgICAgZnVuOm9iamVjdF9wcm9wZXJ0eV9zZXQNCj4+PiAgICAgIGZ1bjpvYmpl
Y3RfcHJvcGVydHlfc2V0X3FvYmplY3QNCj4+PiAgICAgIGZ1bjpvYmplY3RfcHJvcGVydHlfc2V0
X2Jvb2wNCj4+PiB9DQo+Pj4NCj4+PiBUaGUgbnVtYmVyIG9mIHN1cHByZXNzZWQgY2FzZXMgYXJl
IHJlcG9ydGVkIGJ5IHRoZSBWYWxncmluZCB3aXRoIGV2ZXJ5DQo+Pj4gcnVuOiAiRVJST1IgU1VN
TUFSWTogNSBlcnJvcnMgZnJvbSAzIGNvbnRleHRzIChzdXBwcmVzc2VkOiAwIGZyb20gMCkiDQo+
Pj4NCj4+PiBBbmRyZXkNCj4+DQo+PiBZZXMsIGluZGVlZCB0aGF0IHdvdWxkIGJlIGFub3RoZXIg
dmFyaWFudC4gSG93IHBlcmZvcm1hbmNlIGNyaXRpY2FsIGFyZQ0KPj4gdGhlIGZpeGVkIGxvY2F0
aW9ucz8gVGhhdCBtaWdodCBoYXZlIGFuIGltcGFjdCBvbiB3aGF0IGlzIHRoZSBiZXN0IHNvbHV0
aW9uLg0KPj4gIEZyb20gYSBjbGVhbmxpbmVzcyBhcHByb2FjaCBkb2luZyAxIChhZGRpbmcgdGhl
IGlvY3RsIGRlZmluaXRpb24gdG8gdmFsZ3JpbmQpDQo+PiBpcyBjZXJ0YWlubHkgdGhlIG1vc3Qg
YmVhdXRpZnVsIHdheS4gSSBkaWQgdGhhdCBpbiB0aGUgcGFzdCwgbG9vayBmb3IgZXhhbXBsZSBh
dA0KPj4NCj4+IGh0dHBzOi8vc291cmNld2FyZS5vcmcvZ2l0Lz9wPXZhbGdyaW5kLmdpdDthPWNv
bW1pdGRpZmY7aD1jMmJhZWU5YjdiZjA0MzcwMmMxMzBkZTA3NzFhNGRmNDM5ZmNmNDAzDQo+PiBv
cg0KPj4gaHR0cHM6Ly9zb3VyY2V3YXJlLm9yZy9naXQvP3A9dmFsZ3JpbmQuZ2l0O2E9Y29tbWl0
ZGlmZjtoPTAwYTMxZGQzZDFlNzEwMWIzMzFjMmM4M2ZjYTZjNjY2YmEzNWQ5MTANCj4+DQo+PiBm
b3IgZXhhbXBsZXMuDQo+Pg0KPj4NCj4+Pg0KPj4+Pj4NCj4+Pj4+IFBhb2xvDQo+Pj4+Pg0KPj4+
Pj4+IC0tLQ0KPj4+Pj4+ICAgIHRhcmdldC9pMzg2L2t2bS5jIHwgMyArKysNCj4+Pj4+PiAgICAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+Pj4+Pj4NCj4+Pj4+PiBkaWZmIC0tZ2l0
IGEvdGFyZ2V0L2kzODYva3ZtLmMgYi90YXJnZXQvaTM4Ni9rdm0uYw0KPj4+Pj4+IGluZGV4IGRi
YmIxMzcuLmVkNTdlMzEgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEvdGFyZ2V0L2kzODYva3ZtLmMNCj4+
Pj4+PiArKysgYi90YXJnZXQvaTM4Ni9rdm0uYw0KPj4+Pj4+IEBAIC0xOTAsNiArMTkwLDcgQEAg
c3RhdGljIGludCBrdm1fZ2V0X3RzYyhDUFVTdGF0ZSAqY3MpDQo+Pj4+Pj4gICAgICAgICAgICBy
ZXR1cm4gMDsNCj4+Pj4+PiAgICAgICAgfQ0KPj4+Pj4+ICAgIA0KPj4+Pj4+ICsgICAgbWVtc2V0
KCZtc3JfZGF0YSwgMCwgc2l6ZW9mKG1zcl9kYXRhKSk7DQo+Pj4+Pj4gICAgICAgIG1zcl9kYXRh
LmluZm8ubm1zcnMgPSAxOw0KPj4+Pj4+ICAgICAgICBtc3JfZGF0YS5lbnRyaWVzWzBdLmluZGV4
ID0gTVNSX0lBMzJfVFNDOw0KPj4+Pj4+ICAgICAgICBlbnYtPnRzY192YWxpZCA9ICFydW5zdGF0
ZV9pc19ydW5uaW5nKCk7DQo+Pj4+Pj4gQEAgLTE3MDYsNiArMTcwNyw3IEBAIGludCBrdm1fYXJj
aF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzKQ0KPj4+Pj4+ICAgIA0KPj4+Pj4+ICAgICAgICBpZiAo
aGFzX3hzYXZlKSB7DQo+Pj4+Pj4gICAgICAgICAgICBlbnYtPnhzYXZlX2J1ZiA9IHFlbXVfbWVt
YWxpZ24oNDA5Niwgc2l6ZW9mKHN0cnVjdCBrdm1feHNhdmUpKTsNCj4+Pj4+PiArICAgICAgICBt
ZW1zZXQoZW52LT54c2F2ZV9idWYsIDAsIHNpemVvZihzdHJ1Y3Qga3ZtX3hzYXZlKSk7DQo+IA0K
PiBUaGlzIGlzIG1lbXNldHRpbmcgNGs/DQo+IFlldCBhbm90aGVyIHZhcmlhbnQgd291bGQgYmUg
dG8gdXNlIHRoZSBSVU5OSU5HX09OX1ZBTEdSSU5EIG1hY3JvIGZyb20NCj4gdmFsZ3JpbmQvdmFs
Z3JpbmQuaCB0byBvbmx5IG1lbXNldCBmb3IgdmFsZ3JpbmQuIEJ1dCBqdXN0IHVzaW5nIE1BS0Vf
TUVNX0RFRklORUQNCj4gZnJvbSBtZW1jaGVjay5oIGlzIHNpbXBsZXIuDQo+IA0KDQpTbywgb24g
dGhpcyBhc3N1bXB0aW9uLCB0aGUgY29kZSB3b3VsZCBsb29rIGxpa2UNCg0KI2lmZGVmIENPTkZJ
R19WQUxHUklORF9IDQojaW5jbHVkZSA8dmFsZ3JpbmQvbWVtY2hlY2suaD4NCiNlbmRpZg0KDQoj
aWZkZWYgQ09ORklHX1ZBTEdSSU5EX0gNCiAgICAgVkFMR1JJTkRfTUFLRV9NRU1fREVGSU5FRCgm
bXNyX2RhdGEsIHNpemVvZihtc3JfZGF0YSkpOw0KI2VuZGlmDQoNCmV0Yy4NCg0KQW5kcmV5DQot
LSANCldpdGggdGhlIGJlc3QgcmVnYXJkcywNCkFuZHJleSBTaGlua2V2aWNoDQo=
