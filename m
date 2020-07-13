Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5B821E385
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 01:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGMXLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 19:11:31 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:19992
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgGMXLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 19:11:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LG5IOCZkeIYAMaLLFFKgT8hinLJ7k46hiVjFg+Nlk/n+6dahWV0fuLRxFejisQdQNuUKr1FQuubuwPAj3fZ4+x+C1uysXHdBzp6F/ZIsp2MzSJuGcOYm2lu3GEyB6jzWBdJRK26ZRvZjEJyi6d7f8+mUzQ8xQD+xkTIq4eSc1g7T2YPYynXwcF1b7JTsFmkuzlcgHSieFVnkDoaHrVkqYgwXQQ/4+9n0nnGEMY+JTuHy1TqvEYo4J57ddTqHZy/AblAAFdMr2fiIjif9qfu2xw3medcyDAZJMRrLxSYgSTqMhew95qcVosR6wzuDfosxxFsJCqCH1mLcHwyyXG15nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+3L37TTAuzUeMtoL0iPMiWs/WQZNmdg/E8lfADjsWA=;
 b=lRZZTwizOu3oGCb39bkOIb5MLf0Kd/++z1YBZ0wjrYybgTC0N70DaVJso2lTn9pRk/pE+3DuFUI1CUic3zEvMVVFr8r4vNjyu/O003tcgG97MFXGF0YXldMlN3ftKIl/h9aqum2SuF8g1Kh+JK9EgT9g9tjEp6LWydG4Xc4RqcQjqAtz6iCJnvrfD4UnZT855p2YbSq0hQdVRM+7OPPAcj/YI6hdjHoofY2yhjPfvWwnaiZjcRvsPU5bi2h6OrVU/1e6EIyaurfwFBF6nlNeAKMKP59DjGUsq9wEc9IxfDRG+MV2OEvi1E6wS4fAkUn6bMA4k5B+2b1qKsbWwxdvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+3L37TTAuzUeMtoL0iPMiWs/WQZNmdg/E8lfADjsWA=;
 b=pXkq9y3XNZPR49bNa08ZSHeIZrtHlFHzGmqxeO3Edhqb8x4Dn+IRXIzkv4Bbl+FtkwwqVBd03ShYlIA+SwkZPcD92hut0jYC2wof9SofmOoP8i1GipgFlXau6lSPlOnUfDK1DQwvUsp6SuoVXisU/SEsYCEbtIlJOEXSJXmDlkE=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5512.namprd05.prod.outlook.com (2603:10b6:a03:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9; Mon, 13 Jul
 2020 23:11:26 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.009; Mon, 13 Jul 2020
 23:11:26 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Topic: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Index: AQHWWM/s9eQwCvJDT0a4UjvbTfvUQ6kGIrqAgAABgoA=
Date:   Mon, 13 Jul 2020 23:11:26 +0000
Message-ID: <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
In-Reply-To: <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:c93b:d519:464b:6d2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4b2bb0e-9697-4967-4202-08d8278211b8
x-ms-traffictypediagnostic: BYAPR05MB5512:
x-microsoft-antispam-prvs: <BYAPR05MB5512F6285696DB79E47ADD78D0600@BYAPR05MB5512.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJF7A7UtIqrV2HpMOk62PsRQ2z3YvULX/q7oFT1+a8uWPb8C8fXmwY8que4RKLDy84bTlxuip5w/BarnC6AXnNhLUFU08lzBpAOhV7Mx9Ci6xqrzjbM3lmBP1LbeCKrc0uSqJcE3VaeBDQ43tn7LgY7vq0jzBkQ95I9c/EEz8IGyN9yI+MSqICoryYg+2RIcnq2w4S7cLLtVRllQmG/2JaH6WZoXzkt/k0SxkyOKGVLF7wa6FMWojEdedPERaWxjLNjumZLWlndeoGaWtrJvbRlAFERgBPVKBpaRi1WN4z+kBOHc55fA/VBmGlYqPDJ6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(478600001)(33656002)(76116006)(6486002)(5660300002)(316002)(54906003)(6506007)(8676002)(4326008)(53546011)(71200400001)(19627235002)(8936002)(2906002)(6916009)(36756003)(2616005)(186003)(66946007)(66476007)(6512007)(64756008)(66446008)(66556008)(83380400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: OjQXRRT2tByioqw26DXynuxKekvRuFbNvbzFWG68xiZcuAhtVqkthuNiih36JoK9pGHA795L0PBPHv6Co12BBaelFaKPcO26WtewnEu1kWaRazMEMd9qmgsfmQuaxDjJRSP34gc0YB5n/kPQX3whOIUd3anEPiQsORQrqpMQeyAIegO5GPBh5p5eNVs+BZXyNHAFoBMBRqx9Qbc6DiMvb4efq5sx667yQRD5C9KBRJG00RDTWndem9pPqyUBzKLCzHgHxse84wnsW75L1gq/Mzh3hnlQDd5Z72W2XNak5h9WS79Fa4QW+LguPss5Jrd88NDLVjrcRqmgKnrdacBluNjiWbPpByKCd8jKOem6O4Rd4SIXPE564Hme7y91buxVAaIMgXhFO2yWH+QJ61slMp3JRfMMCv9o43SOOX2tEj2H2fATIPyAfdo+Gus6x9Em1CDoePwNvLBXe+cXsQZ5srPcgYhaO+oo6PEj+wKFdxExQoq70aNK0RiqssKcW2AR97d1xSShAJBFoOl/htPMfR8mcsgVBku6E5n54BAOcKo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB95A979D3453C47A5D63A7B9AEC89A7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b2bb0e-9697-4967-4202-08d8278211b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 23:11:26.8415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Kf0o1iPnOMOlyb0QQbm8ihmjtAKX/qHU/B2JJ1ZNkK6jGahwV1n3Dy+6Km5A1LvoIsqbnf/DBPM4pO65teQCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMTMsIDIwMjAsIGF0IDQ6MDYgUE0sIEtyaXNoIFNhZGh1a2hhbiA8a3Jpc2guc2Fk
aHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IE9uIDcvMTIvMjAgOTozOSBQTSwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+IFRoZSBsb3cgQ1IzIGJpdHMgYXJlIHJlc2VydmVkIGJ1dCBu
b3QgTUJaIGFjY29yZGluZyB0byB0aGEgQVBNLiBUaGUNCj4+IHRlc3RzIHNob3VsZCB0aGVyZWZv
cmUgbm90IGNoZWNrIHRoYXQgdGhleSBjYXVzZSBmYWlsZWQgVk0tZW50cnkuIFRlc3RzDQo+PiBv
biBiYXJlLW1ldGFsIHNob3cgdGhleSBkbyBub3QuDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IE5h
ZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+DQo+PiAtLS0NCj4+ICB4ODYvc3ZtLmggICAgICAg
fCAgNCArLS0tDQo+PiAgeDg2L3N2bV90ZXN0cy5jIHwgMjYgKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25z
KC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS94ODYvc3ZtLmggYi94ODYvc3ZtLmgNCj4+IGluZGV4
IGY4ZTc0MjkuLjE1ZTBmMTggMTAwNjQ0DQo+PiAtLS0gYS94ODYvc3ZtLmgNCj4+ICsrKyBiL3g4
Ni9zdm0uaA0KPj4gQEAgLTMyNSw5ICszMjUsNyBAQCBzdHJ1Y3QgX19hdHRyaWJ1dGVfXyAoKF9f
cGFja2VkX18pKSB2bWNiIHsNCj4+ICAjZGVmaW5lIFNWTV9DUjBfU0VMRUNUSVZFX01BU0sgKFg4
Nl9DUjBfVFMgfCBYODZfQ1IwX01QKQ0KPj4gICAgI2RlZmluZQlTVk1fQ1IwX1JFU0VSVkVEX01B
U0sJCQkweGZmZmZmZmZmMDAwMDAwMDBVDQo+PiAtI2RlZmluZQlTVk1fQ1IzX0xFR0FDWV9SRVNF
UlZFRF9NQVNLCQkweGZlN1UNCj4+IC0jZGVmaW5lCVNWTV9DUjNfTEVHQUNZX1BBRV9SRVNFUlZF
RF9NQVNLCTB4N1UNCj4+IC0jZGVmaW5lCVNWTV9DUjNfTE9OR19SRVNFUlZFRF9NQVNLCQkweGZm
ZjAwMDAwMDAwMDBmZTdVDQo+PiArI2RlZmluZQlTVk1fQ1IzX0xPTkdfUkVTRVJWRURfTUFTSwkJ
MHhmZmYwMDAwMDAwMDAwMDAwVQ0KPj4gICNkZWZpbmUJU1ZNX0NSNF9MRUdBQ1lfUkVTRVJWRURf
TUFTSwkJMHhmZjg4ZjAwMFUNCj4+ICAjZGVmaW5lCVNWTV9DUjRfUkVTRVJWRURfTUFTSwkJCTB4
ZmZmZmZmZmZmZjg4ZjAwMFUNCj4+ICAjZGVmaW5lCVNWTV9EUjZfUkVTRVJWRURfTUFTSwkJCTB4
ZmZmZmZmZmZmZmZmMWZmMFUNCj4+IGRpZmYgLS1naXQgYS94ODYvc3ZtX3Rlc3RzLmMgYi94ODYv
c3ZtX3Rlc3RzLmMNCj4+IGluZGV4IDNiMGQwMTkuLjE5MDhjN2MgMTAwNjQ0DQo+PiAtLS0gYS94
ODYvc3ZtX3Rlc3RzLmMNCj4+ICsrKyBiL3g4Ni9zdm1fdGVzdHMuYw0KPj4gQEAgLTIwMDcsMzgg
KzIwMDcsMTQgQEAgc3RhdGljIHZvaWQgdGVzdF9jcjModm9pZCkNCj4+ICB7DQo+PiAgCS8qDQo+
PiAgCSAqIENSMyBNQlogYml0cyBiYXNlZCBvbiBkaWZmZXJlbnQgbW9kZXM6DQo+PiAtCSAqICAg
WzI6MF0JCSAgICAtIGxlZ2FjeSBQQUUNCj4+IC0JICogICBbMjowXSwgWzExOjVdCSAgICAtIGxl
Z2FjeSBub24tUEFFDQo+PiAtCSAqICAgWzI6MF0sIFsxMTo1XSwgWzYzOjUyXSAtIGxvbmcgbW9k
ZQ0KPj4gKwkgKiAgIFs2Mzo1Ml0gLSBsb25nIG1vZGUNCj4+ICAJICovDQo+PiAgCXU2NCBjcjNf
c2F2ZWQgPSB2bWNiLT5zYXZlLmNyMzsNCj4+IC0JdTY0IGNyNF9zYXZlZCA9IHZtY2ItPnNhdmUu
Y3I0Ow0KPj4gLQl1NjQgY3I0ID0gY3I0X3NhdmVkOw0KPj4gLQl1NjQgZWZlcl9zYXZlZCA9IHZt
Y2ItPnNhdmUuZWZlcjsNCj4+IC0JdTY0IGVmZXIgPSBlZmVyX3NhdmVkOw0KPj4gIC0JZWZlciAm
PSB+RUZFUl9MTUU7DQo+PiAtCXZtY2ItPnNhdmUuZWZlciA9IGVmZXI7DQo+PiAtCWNyNCB8PSBY
ODZfQ1I0X1BBRTsNCj4+IC0Jdm1jYi0+c2F2ZS5jcjQgPSBjcjQ7DQo+PiAtCVNWTV9URVNUX0NS
X1JFU0VSVkVEX0JJVFMoMCwgMiwgMSwgMywgY3IzX3NhdmVkLA0KPj4gLQkgICAgU1ZNX0NSM19M
RUdBQ1lfUEFFX1JFU0VSVkVEX01BU0spOw0KPj4gLQ0KPj4gLQljcjQgPSBjcjRfc2F2ZWQgJiB+
WDg2X0NSNF9QQUU7DQo+PiAtCXZtY2ItPnNhdmUuY3I0ID0gY3I0Ow0KPj4gLQlTVk1fVEVTVF9D
Ul9SRVNFUlZFRF9CSVRTKDAsIDExLCAxLCAzLCBjcjNfc2F2ZWQsDQo+PiAtCSAgICBTVk1fQ1Iz
X0xFR0FDWV9SRVNFUlZFRF9NQVNLKTsNCj4+IC0NCj4+IC0JY3I0IHw9IFg4Nl9DUjRfUEFFOw0K
Pj4gLQl2bWNiLT5zYXZlLmNyNCA9IGNyNDsNCj4+IC0JZWZlciB8PSBFRkVSX0xNRTsNCj4+IC0J
dm1jYi0+c2F2ZS5lZmVyID0gZWZlcjsNCj4+ICAJU1ZNX1RFU1RfQ1JfUkVTRVJWRURfQklUUygw
LCA2MywgMSwgMywgY3IzX3NhdmVkLA0KPj4gIAkgICAgU1ZNX0NSM19MT05HX1JFU0VSVkVEX01B
U0spOw0KPj4gIC0Jdm1jYi0+c2F2ZS5jcjQgPSBjcjRfc2F2ZWQ7DQo+PiAgCXZtY2ItPnNhdmUu
Y3IzID0gY3IzX3NhdmVkOw0KPj4gLQl2bWNiLT5zYXZlLmVmZXIgPSBlZmVyX3NhdmVkOw0KPj4g
IH0NCj4+ICAgIHN0YXRpYyB2b2lkIHRlc3RfY3I0KHZvaWQpDQo+IA0KPiBBUE0gc2F5cywNCj4g
DQo+ICAgICAiUmVzZXJ2ZWQgQml0cy4gUmVzZXJ2ZWQgZmllbGRzIHNob3VsZCBiZSBjbGVhcmVk
IHRvIDAgYnkgc29mdHdhcmUgd2hlbiB3cml0aW5nIENSMy4iDQo+IA0KPiBJZiBwcm9jZXNzb3Ig
YWxsb3dzIHRoZXNlIGJpdHMgdG8gYmUgbGVmdCBub24temVybywgInNob3VsZCBiZSBjbGVhcmVk
IHRvIDAiIG1lYW5zIGl0J3Mgbm90IG1hbmRhdG9yeSB0aGVuLiBJIGFtIHdvbmRlcmluZyB3aGF0
IHRoaXMgInNob3VsZCBiZSIgYWN0dWFsbHkgbWVhbnMgOi0pICENCg0KSSByZWFsbHkgdGVzdGVk
IGl0LCBzbyBJIGd1ZXNzIHdlIOKAnHNob3VsZOKAnSBub3QgYXJndWUgYWJvdXQgaXQuIDstKQ0K
DQpBbnlob3csIGFjY29yZGluZyB0byBBUE0gRmlndXJlIDUtMTYgKOKAnENvbnRyb2wgUmVnaXN0
ZXIgMyAoQ1IzKS1Mb25nIE1vZGXigJ0pLA0KYml0cyA1Mjo2MyBhcmUg4oCccmVzZXJ2ZWQsIE1C
WuKAnSBhbmQgb3RoZXJzIGFyZSBqdXN0IG1hcmtlZCBhcyDigJxSZXNlcnZlZOKAnS4gU28NCml0
IHNlZW1zIHRoZXkgYXJlIG5vdCB0aGUgc2FtZS4NCg0K
