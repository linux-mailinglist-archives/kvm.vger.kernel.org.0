Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF01CF306
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 13:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgELLDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 07:03:04 -0400
Received: from mail-eopbgr1300059.outbound.protection.outlook.com ([40.107.130.59]:9521
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbgELLDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 07:03:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlHoNdVWnv0Fa0r3A0utGCyROaMrURTIeuBJYNjvPNpXj30YbqpQj5JHNMIAsQEeOL7aDQ+yqRIAeGej3f7U08scFIbRuRNyZm17iYom2JWyNYg1QyVSEc8u0tFwmgidOFW6RXxsfN823ufYE0tABiIj4et2rq5JXCRZjGdUe/aTHZT58lo3a9Xk/B9qMFjdUwJPjz90lV+GeGYDmftWK9bw5/rm9FONo/Kl0XwlhbqIMrLOptisuNOR/+FEc40AAf+jAoGoIkOKMhX97lwD09k1SDpi4khXw45OHEJ/FKuychh3TwE+SjoXMaPcp+IDz8bv/ld005zEgvbLP/WvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+mNRqUwfmUoId8N83J4eXXZQmVldvgJiRRQpdxSnTs=;
 b=XOsdcOjYeSKthB9EC+5pKpyjw+UrynggpSzrwD3ViRPXHAfGYBseQs40KWDyh7aaDESqiYK5O7zQsbIbf55KWl5DI0y5qDMonX9PjZaugQ/LuoRbnmiR9uVYN88h34Giidw1PQKDGVwJ2z2xeA31q44wYE9rLPUdg2l4BgkIFjSuxTIz7uS+lA6kz6fX5iJJbJt12BD8amUap8dRWdLK9KwDdw3kKMdyXr4fple5zoyN4gqte2B6a/u1wFp2ZPBbwU6lb5uN6LiY6qbuLT9XKWiV1kA3Y4uQjOUuL0hI4F9pB7tHwy8CLYYr5YxDnWfDXRVlZj7lcdpj8p26dejqNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oppoglobal.onmicrosoft.com; s=selector1-oppoglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+mNRqUwfmUoId8N83J4eXXZQmVldvgJiRRQpdxSnTs=;
 b=HTGPSVnRK4ltqTDGsckdueir87UBT1WVSBkgl9Qj+VF1SqUZGksoZDrw5XYowFaO2FW0auz/t6yHzixR97D/HExb8voBZF6kghfrgpv3grAynzpoJORZEZuc901tIh208OMNX8JsruMPPhXSHcFfyI6eBbuasdSLeZeZK9eZI2k=
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com (2603:1096:203:d3::12)
 by HKAPR02MB4308.apcprd02.prod.outlook.com (2603:1096:203:dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Tue, 12 May
 2020 11:02:58 +0000
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::80ca:c698:988e:a999]) by HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::80ca:c698:988e:a999%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 11:02:57 +0000
From:   =?gb2312?B?xe26xihSaWNoYXJkKQ==?= <richard.peng@oppo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v2] kvm/x86 : Remove redundant function implement
Thread-Topic: [PATCH v2] kvm/x86 : Remove redundant function implement
Thread-Index: AdYoTDpIz7AFtnDsRCiyAgzxuRMr2g==
Date:   Tue, 12 May 2020 11:02:56 +0000
Message-ID: <HKAPR02MB4291B0991BF57A5CCB1C7437E0BE0@HKAPR02MB4291.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oppo.com;
x-originating-ip: [58.255.79.102]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b97a50f-9945-4101-81ed-08d7f6640703
x-ms-traffictypediagnostic: HKAPR02MB4308:
x-microsoft-antispam-prvs: <HKAPR02MB4308CA3DE6683B45FA521EB4E0BE0@HKAPR02MB4308.apcprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:119;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s1SLYJ7Twdo29kTyMCq+iIh4GSg7xZpjk13pu6gAte1fK5ZQd/CcZ+NLJfIlUNH+/qUzaJNhIW9PrAi5zNDof/cSzmQ99/+b3sIXNO4rCZoeBzzXu27r81K8BH1Tm5uVUZm8lUdTeMkgMS1BVbBBYZ9SnLTHUDYG0LjcSExEOEeOykL/OQjokKYHirC9XdD6r1s2ZZZeIshmjNLVmSfLXnU8Fie1T/H9l4b5LznqmlCZFZ6C+VjI/Vh/EYZ/tfj05GgGoBC6MAPgiP8dTee0Jlr92H8odxB0mbSnzT/6xnYrMoZe8ygtMPf6GuvXDIZOD0fpxgYDW+z7pIUDtoM2ej+lJFIDmN7U9YvYPvoU9PIgCki0YQ1aE1algEmldd1B7h2xKm1SBVpGVIFzhrESKK8gGiw5+TtBuok7v/g/NCLqlwRfm5+OBTQH48H6T+x5JbmFu8Lkn68mXlpQdR10BKz/SfOvcY5o6lJwb5QjueLKQVdOOhQAE5KmdSw8yBJutZuvBGupbqRHsdBenphGnq7djODH8JefmCVC8eHjfezsgbgsb1QQyX5fRG9IyfEM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR02MB4291.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(33430700001)(33440700001)(6506007)(55016002)(9686003)(52536014)(186003)(4326008)(508600001)(316002)(26005)(33656002)(7696005)(71200400001)(66946007)(86362001)(8676002)(85182001)(6916009)(64756008)(2906002)(66556008)(66476007)(8936002)(66446008)(54906003)(5660300002)(76116006)(11606004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mVZ3ZLT+4R/tgCIaJrWWZtg4NU7TzRIPqylR66VmoYv+i0Y1N0wXTlwt3wdnmTaqiJ33x8xsUkpi/meFgF7TMVOHRmSnld+gLWKmKZT2P14xesroJm2HJ03dyBRzMtaIFk0QR5iD8KY/u2daFXmxYXe72NUUVJs6ZyN4dwYTS6Nawi4UHplEdw+TOz/iiBZxoHjzNQDenAYQ68OshLjLaMpXHHlPxO6R99nNLbcrdElwCaFUQDPGK+wvlauC9t2XR7qVlXboA7rLOdtK6+lJRrGMblwHno2mhSN1ZCXhQhKgYZwUgVbKpCcx/kmEEYJHIKCpo5kN+2hqi+Vp+zECtw7qUH5t3zeP2IBrqw5+Rc/JAi7LCGV+9QyPar4Aq6hmCooUQBZka1zQ+hBGN9fYR/ftJI30HO5Ilp3IQI+tAUSxTElW/jcWCVoXsJze7lfQoF+Jlr8PAHyOC2VqpGUN9kNi+pvnXLKDeysT9y6HVeY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b97a50f-9945-4101-81ed-08d7f6640703
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 11:02:56.7084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mlCwaxHDitAxkgUAFMsGxzUqrUvLtaM52pR6k9Bmt7wAKU44StF2TjtbaVj7x+XPoVf4/RJBwebUqXUKam7xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HKAPR02MB4308
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cGljX2luX2tlcm5lbCgpLGlvYXBpY19pbl9rZXJuZWwoKSBhbmQgaXJxY2hpcF9rZXJuZWwoKSBo
YXZlIHRoZQ0Kc2FtZSBpbXBsZW1lbnRhdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogUGVuZyBIYW8g
PHJpY2hhcmQucGVuZ0BvcHBvLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9pb2FwaWMuaCB8ICA4
ICsrLS0tLS0tDQogYXJjaC94ODYva3ZtL2lycS5oICAgIHwgMTMgKysrKy0tLS0tLS0tLQ0KIDIg
ZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2t2bS9pb2FwaWMuaCBiL2FyY2gveDg2L2t2bS9pb2FwaWMuaA0KaW5k
ZXggMmZiMmUzYy4uN2EzYzUzYiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9pb2FwaWMuaA0K
KysrIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5oDQpAQCAtNSw3ICs1LDcgQEANCiAjaW5jbHVkZSA8
bGludXgva3ZtX2hvc3QuaD4NCg0KICNpbmNsdWRlIDxrdm0vaW9kZXYuaD4NCi0NCisjaW5jbHVk
ZSAiaXJxLmgiDQogc3RydWN0IGt2bTsNCiBzdHJ1Y3Qga3ZtX3ZjcHU7DQoNCkBAIC0xMDgsMTEg
KzEwOCw3IEBAIGRvIHtcDQoNCiBzdGF0aWMgaW5saW5lIGludCBpb2FwaWNfaW5fa2VybmVsKHN0
cnVjdCBrdm0gKmt2bSkNCiB7DQotaW50IG1vZGUgPSBrdm0tPmFyY2guaXJxY2hpcF9tb2RlOw0K
LQ0KLS8qIE1hdGNoZXMgc21wX3dtYigpIHdoZW4gc2V0dGluZyBpcnFjaGlwX21vZGUgKi8NCi1z
bXBfcm1iKCk7DQotcmV0dXJuIG1vZGUgPT0gS1ZNX0lSUUNISVBfS0VSTkVMOw0KK3JldHVybiBp
cnFjaGlwX2tlcm5lbChrdm0pOw0KIH0NCg0KIHZvaWQga3ZtX3J0Y19lb2lfdHJhY2tpbmdfcmVz
dG9yZV9vbmUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vaXJxLmggYi9hcmNoL3g4Ni9rdm0vaXJxLmgNCmluZGV4IGYxNzNhYjYuLmMwYWQ3MzEgMTAw
NjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vaXJxLmgNCisrKyBiL2FyY2gveDg2L2t2bS9pcnEuaA0K
QEAgLTY2LDE1ICs2Niw2IEBAIHZvaWQga3ZtX3BpY19kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSk7
DQogaW50IGt2bV9waWNfcmVhZF9pcnEoc3RydWN0IGt2bSAqa3ZtKTsNCiB2b2lkIGt2bV9waWNf
dXBkYXRlX2lycShzdHJ1Y3Qga3ZtX3BpYyAqcyk7DQoNCi1zdGF0aWMgaW5saW5lIGludCBwaWNf
aW5fa2VybmVsKHN0cnVjdCBrdm0gKmt2bSkNCi17DQotaW50IG1vZGUgPSBrdm0tPmFyY2guaXJx
Y2hpcF9tb2RlOw0KLQ0KLS8qIE1hdGNoZXMgc21wX3dtYigpIHdoZW4gc2V0dGluZyBpcnFjaGlw
X21vZGUgKi8NCi1zbXBfcm1iKCk7DQotcmV0dXJuIG1vZGUgPT0gS1ZNX0lSUUNISVBfS0VSTkVM
Ow0KLX0NCi0NCiBzdGF0aWMgaW5saW5lIGludCBpcnFjaGlwX3NwbGl0KHN0cnVjdCBrdm0gKmt2
bSkNCiB7DQogaW50IG1vZGUgPSBrdm0tPmFyY2guaXJxY2hpcF9tb2RlOw0KQEAgLTkzLDYgKzg0
LDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IGlycWNoaXBfa2VybmVsKHN0cnVjdCBrdm0gKmt2bSkN
CiByZXR1cm4gbW9kZSA9PSBLVk1fSVJRQ0hJUF9LRVJORUw7DQogfQ0KDQorc3RhdGljIGlubGlu
ZSBpbnQgcGljX2luX2tlcm5lbChzdHJ1Y3Qga3ZtICprdm0pDQorew0KK3JldHVybiBpcnFjaGlw
X2tlcm5lbChrdm0pOw0KK30NCiBzdGF0aWMgaW5saW5lIGludCBpcnFjaGlwX2luX2tlcm5lbChz
dHJ1Y3Qga3ZtICprdm0pDQogew0KIGludCBtb2RlID0ga3ZtLT5hcmNoLmlycWNoaXBfbW9kZTsN
Ci0tDQoyLjcuNA0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KT1BQTw0KDQqx
vrXn19PTyrz+vLDG5Li9vP66rNPQT1BQT7mry761xLGjw9zQxc+io6y99s/e09rTyrz+1rjD97XE
ytW8/sjLyrnTw6OosPy6rLj2yMu8sMi61+mjqaGjvfvWucjOus7Iy9TazrS+rcrayKi1xMfpv/bP
wtLUyM66ztDOyr3KudPDoaPI57n7xPq07crVwcuxvtPKvP6jrMfrwaK8tNLUtefX09PKvP7NqNaq
t6K8/sjLsqLJvrP9sb7Tyrz+vLDG5Li9vP6how0KDQpUaGlzIGUtbWFpbCBhbmQgaXRzIGF0dGFj
aG1lbnRzIGNvbnRhaW4gY29uZmlkZW50aWFsIGluZm9ybWF0aW9uIGZyb20gT1BQTywgd2hpY2gg
aXMgaW50ZW5kZWQgb25seSBmb3IgdGhlIHBlcnNvbiBvciBlbnRpdHkgd2hvc2UgYWRkcmVzcyBp
cyBsaXN0ZWQgYWJvdmUuIEFueSB1c2Ugb2YgdGhlIGluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJl
aW4gaW4gYW55IHdheSAoaW5jbHVkaW5nLCBidXQgbm90IGxpbWl0ZWQgdG8sIHRvdGFsIG9yIHBh
cnRpYWwgZGlzY2xvc3VyZSwgcmVwcm9kdWN0aW9uLCBvciBkaXNzZW1pbmF0aW9uKSBieSBwZXJz
b25zIG90aGVyIHRoYW4gdGhlIGludGVuZGVkIHJlY2lwaWVudChzKSBpcyBwcm9oaWJpdGVkLiBJ
ZiB5b3UgcmVjZWl2ZSB0aGlzIGUtbWFpbCBpbiBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2Vu
ZGVyIGJ5IHBob25lIG9yIGVtYWlsIGltbWVkaWF0ZWx5IGFuZCBkZWxldGUgaXQhDQo=
