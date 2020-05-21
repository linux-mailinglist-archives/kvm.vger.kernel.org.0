Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859621DC6BE
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 07:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgEUF54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 01:57:56 -0400
Received: from mail-eopbgr1310070.outbound.protection.outlook.com ([40.107.131.70]:11440
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726869AbgEUF5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 01:57:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyRyeaQH+NSrNqZFjECHNd69s7ltflQW/H3rjIbjZFwq9tJ7EgSCoKQhnnbbIbEWMiixdPJyQas1oYkc455nvp0UqlgJCQ4CO41R9I4DdYH7VrO0FlYXW5MerWEa8uzSG2xEECg6YUf1/THcwmq+b26Du0yUCHLcLVg9v2g/rZnD2hoi2tI90T1J/Vh5do4UOJfUOyDJPyhQPJVaERvX1QPjq/yOEzHfEeemBHMdVpzfHPU7QJWf7WNw+BRY2QHTpepSUUNiSmVl4Y+4rCcrwqpaQf857hRizep2smHU6PvXE7xFYQRsT7Iw+6qHnpxdJCc7p+jiub6lwl/XFfjExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zKc6D+OtGRV1jtx43O1KVZP6EL0f/3uvVP4n8uZC50=;
 b=Gy/oIsYCVf4Ppmp5aT0R34fCmCsMoGzUs+tl+oXcmmR8RmnDpFMLLa6D2pheVZ3hqFcmldiswADaWexfM5ocR5KZdxmF0XhxaWW5VKyOiXkuMTba926AkfFLmxxIAGKOiE5uiXc9dv9osnr3zTxFQsGCfe1NDErPdSYt2h+irTe4DVTP+GBZ2qr06a7fSSeQS59ZNnmOE9rQmM1aUkNymPEWkjTaBRgXZmkLIV8GAMbacqhHZi8tKpXmnAzNDvKwEtyv3NzCns4dznBNHT9VP2jYy161yOvZeoBkYB9HZ2mCj7m1d7CxH8WaB3w36d1MXqiJA1DcORO1aFvZSwQVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oppoglobal.onmicrosoft.com; s=selector1-oppoglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zKc6D+OtGRV1jtx43O1KVZP6EL0f/3uvVP4n8uZC50=;
 b=Rbp++ErRhn/sPpvVYXvUK3KiJHlDZR4qS90V7G5kpKvglr0vVvA7d6f3UNJbZi1y8w0fDYtzjb81g+RjBlL88Q4x2yDgYgYZtA3odlrCZtUo8e14+4EEGALggIPqaYLTJcm/k7aLpExu3PYrFxk8a0hoyIo0P5PR1pRk1mNvb0s=
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com (2603:1096:203:d3::12)
 by HKAPR02MB4403.apcprd02.prod.outlook.com (2603:1096:203:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 05:57:49 +0000
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::80ca:c698:988e:a999]) by HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::80ca:c698:988e:a999%5]) with mapi id 15.20.3021.020; Thu, 21 May 2020
 05:57:49 +0000
From:   =?gb2312?B?xe26xihSaWNoYXJkKQ==?= <richard.peng@oppo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v3] kvm/x86 : Remove redundant function implement
Thread-Topic: [PATCH v3] kvm/x86 : Remove redundant function implement
Thread-Index: AdYvNGncuTv2pa/PRZeWvNnr93KTAw==
Date:   Thu, 21 May 2020 05:57:49 +0000
Message-ID: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oppo.com;
x-originating-ip: [58.255.79.102]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b49bb71-8b06-4612-6052-08d7fd4be4ac
x-ms-traffictypediagnostic: HKAPR02MB4403:
x-microsoft-antispam-prvs: <HKAPR02MB440328797D61BB3BD7D2B0CCE0B70@HKAPR02MB4403.apcprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:119;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IQyWPh9tKCanaO5483V3q4Eyoijqxyy44KSPS7LiaIddnjBR7oAs39IQPP561tQR7i7PK8pQVP6Sp0W/Had1LeS6IIjIKfaMv/3ohfT2/rJCR9RJ5OFiE/0xsPIlkokRS2sGxMq4FHYJ857HBi4N6pBvc/1GtTZTUP9mU2BSlDDD6vVvf5p62OvAs1bMvLQga5s9qa38npZirqsIIjv4GVOJsjwkJzfWPyd6o0AHjfOY1INkC2q8iri52sRbbIlTB33ZzKnkrnbTB7EvgRKCt3N4oLhQMPARe2YJJ+4H+rxbDfh933lJwCffq4m1c3xIDrGgBqjll+ie9udq6eT2VxKl2QwScmvhP1T/C3W7eOwSz60NPEvIEUihrE49fzGX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR02MB4291.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(4326008)(85182001)(86362001)(8676002)(5660300002)(8936002)(66446008)(64756008)(9686003)(55016002)(6916009)(71200400001)(66476007)(186003)(6506007)(478600001)(33656002)(52536014)(66946007)(76116006)(54906003)(66556008)(316002)(26005)(7696005)(2906002)(11606004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pFto/N3jMm9e9mxV+w54/p7PEit6mnK6d6HswKMdneQzr6QohH3h23fxOMn/3puelH1qgdLy42KR/jY2fGG+7AahSwia9i4J63ef68HECMrR4NS4ck5GGhelOOzMmhI1y0Z3Iw3svFW6YonXuBByVbwyXrTPfPNC/xgakLEvcUf5QnScGmUlrjpzbgOr88hKHI2lbHh1IMu7z6IhVSV+09a4aCC4z936iQS1vDgoNMDctQzQ0dVn8WPcnLzGoOb99yjtzK8IhWATeBW+OH1QVVyxbAv+0qCbIx9PjWgaJ+piRna4ZJGnOEd/JK3Sb6KpmjMPjQsmVobHZ6tKCZXC7B1M2YmnFXVhotem1/mDJE1PpR9dNyUWoTlR5dngCgyJ+DPptPolZed+77fsOvHoY5TfpThY6lnBtJNMrOs4KmXyjDb/7VE+JqxcCoMWpy85drnHp4if8W4cdEjJy4H6+CYRO2JzXVZ/Pf/pS9Bq1EE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b49bb71-8b06-4612-6052-08d7fd4be4ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 05:57:49.4960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jeWj00RCj804FikMJx1Fwq9fnBGy9qElZiiwHgJF19dIl2IWEezXd1xF/sKVYHeANCsNIc/dK5hPgAQLwy1Zng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HKAPR02MB4403
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cGljX2luX2tlcm5lbCgpLGlvYXBpY19pbl9rZXJuZWwoKSBhbmQgaXJxY2hpcF9rZXJuZWwoKSBo
YXZlIHRoZQ0Kc2FtZSBpbXBsZW1lbnRhdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogUGVuZyBIYW8g
PHJpY2hhcmQucGVuZ0BvcHBvLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9pb2FwaWMuaCAgfCAg
OCArKy0tLS0tLQ0KIGFyY2gveDg2L2t2bS9pcnEuaCAgICAgfCAxNCArKysrLS0tLS0tLS0tLQ0K
IGFyY2gveDg2L2t2bS9sYXBpYy5jICAgfCAgMSArDQogYXJjaC94ODYva3ZtL21tdS9tbXUuYyB8
ICAxICsNCiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgIHwgIDEgKw0KIDUgZmlsZXMgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS9pb2FwaWMuaCBiL2FyY2gveDg2L2t2bS9pb2FwaWMuaA0KaW5kZXggMmZiMmUzYy4uN2Ez
YzUzYiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9pb2FwaWMuaA0KKysrIGIvYXJjaC94ODYv
a3ZtL2lvYXBpYy5oDQpAQCAtNSw3ICs1LDcgQEANCiAjaW5jbHVkZSA8bGludXgva3ZtX2hvc3Qu
aD4NCg0KICNpbmNsdWRlIDxrdm0vaW9kZXYuaD4NCi0NCisjaW5jbHVkZSAiaXJxLmgiDQogc3Ry
dWN0IGt2bTsNCiBzdHJ1Y3Qga3ZtX3ZjcHU7DQoNCkBAIC0xMDgsMTEgKzEwOCw3IEBAIGRvIHtc
DQoNCiBzdGF0aWMgaW5saW5lIGludCBpb2FwaWNfaW5fa2VybmVsKHN0cnVjdCBrdm0gKmt2bSkN
CiB7DQotaW50IG1vZGUgPSBrdm0tPmFyY2guaXJxY2hpcF9tb2RlOw0KLQ0KLS8qIE1hdGNoZXMg
c21wX3dtYigpIHdoZW4gc2V0dGluZyBpcnFjaGlwX21vZGUgKi8NCi1zbXBfcm1iKCk7DQotcmV0
dXJuIG1vZGUgPT0gS1ZNX0lSUUNISVBfS0VSTkVMOw0KK3JldHVybiBpcnFjaGlwX2tlcm5lbChr
dm0pOw0KIH0NCg0KIHZvaWQga3ZtX3J0Y19lb2lfdHJhY2tpbmdfcmVzdG9yZV9vbmUoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vaXJxLmggYi9hcmNo
L3g4Ni9rdm0vaXJxLmgNCmluZGV4IGYxNzNhYjYuLmUxMzNjMWEgMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni9rdm0vaXJxLmgNCisrKyBiL2FyY2gveDg2L2t2bS9pcnEuaA0KQEAgLTE2LDcgKzE2LDYg
QEANCiAjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4NCg0KICNpbmNsdWRlIDxrdm0vaW9kZXYu
aD4NCi0jaW5jbHVkZSAiaW9hcGljLmgiDQogI2luY2x1ZGUgImxhcGljLmgiDQoNCiAjZGVmaW5l
IFBJQ19OVU1fUElOUyAxNg0KQEAgLTY2LDE1ICs2NSw2IEBAIHZvaWQga3ZtX3BpY19kZXN0cm95
KHN0cnVjdCBrdm0gKmt2bSk7DQogaW50IGt2bV9waWNfcmVhZF9pcnEoc3RydWN0IGt2bSAqa3Zt
KTsNCiB2b2lkIGt2bV9waWNfdXBkYXRlX2lycShzdHJ1Y3Qga3ZtX3BpYyAqcyk7DQoNCi1zdGF0
aWMgaW5saW5lIGludCBwaWNfaW5fa2VybmVsKHN0cnVjdCBrdm0gKmt2bSkNCi17DQotaW50IG1v
ZGUgPSBrdm0tPmFyY2guaXJxY2hpcF9tb2RlOw0KLQ0KLS8qIE1hdGNoZXMgc21wX3dtYigpIHdo
ZW4gc2V0dGluZyBpcnFjaGlwX21vZGUgKi8NCi1zbXBfcm1iKCk7DQotcmV0dXJuIG1vZGUgPT0g
S1ZNX0lSUUNISVBfS0VSTkVMOw0KLX0NCi0NCiBzdGF0aWMgaW5saW5lIGludCBpcnFjaGlwX3Nw
bGl0KHN0cnVjdCBrdm0gKmt2bSkNCiB7DQogaW50IG1vZGUgPSBrdm0tPmFyY2guaXJxY2hpcF9t
b2RlOw0KQEAgLTkzLDYgKzgzLDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IGlycWNoaXBfa2VybmVs
KHN0cnVjdCBrdm0gKmt2bSkNCiByZXR1cm4gbW9kZSA9PSBLVk1fSVJRQ0hJUF9LRVJORUw7DQog
fQ0KDQorc3RhdGljIGlubGluZSBpbnQgcGljX2luX2tlcm5lbChzdHJ1Y3Qga3ZtICprdm0pDQor
ew0KK3JldHVybiBpcnFjaGlwX2tlcm5lbChrdm0pOw0KK30NCiBzdGF0aWMgaW5saW5lIGludCBp
cnFjaGlwX2luX2tlcm5lbChzdHJ1Y3Qga3ZtICprdm0pDQogew0KIGludCBtb2RlID0ga3ZtLT5h
cmNoLmlycWNoaXBfbW9kZTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2Fy
Y2gveDg2L2t2bS9sYXBpYy5jDQppbmRleCA5YWYyNWM5Li5kZTRkMDQ2IDEwMDY0NA0KLS0tIGEv
YXJjaC94ODYva3ZtL2xhcGljLmMNCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQpAQCAtMzYs
NiArMzYsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9qdW1wX2xhYmVsLmg+DQogI2luY2x1ZGUgImt2
bV9jYWNoZV9yZWdzLmgiDQogI2luY2x1ZGUgImlycS5oIg0KKyNpbmNsdWRlICJpb2FwaWMuaCIN
CiAjaW5jbHVkZSAidHJhY2UuaCINCiAjaW5jbHVkZSAieDg2LmgiDQogI2luY2x1ZGUgImNwdWlk
LmgiDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9t
bXUvbW11LmMNCmluZGV4IDgwNzE5NTIuLjYxMzNmNjkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9r
dm0vbW11L21tdS5jDQorKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQpAQCAtMTYsNiArMTYs
NyBAQA0KICAqLw0KDQogI2luY2x1ZGUgImlycS5oIg0KKyNpbmNsdWRlICJpb2FwaWMuaCINCiAj
aW5jbHVkZSAibW11LmgiDQogI2luY2x1ZGUgIng4Ni5oIg0KICNpbmNsdWRlICJrdm1fY2FjaGVf
cmVncy5oIg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94
ODYuYw0KaW5kZXggZDc4NmM3ZC4uYzhiNjJhYyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS94
ODYuYw0KKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQpAQCAtMTgsNiArMTgsNyBAQA0KDQogI2lu
Y2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+DQogI2luY2x1ZGUgImlycS5oIg0KKyNpbmNsdWRlICJp
b2FwaWMuaCINCiAjaW5jbHVkZSAibW11LmgiDQogI2luY2x1ZGUgImk4MjU0LmgiDQogI2luY2x1
ZGUgInRzcy5oIg0KLS0NCjIuNy40DQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
DQpPUFBPDQoNCrG+tefX09PKvP68sMbkuL28/rqs09BPUFBPuavLvrXEsaPD3NDFz6KjrL32z97T
2tPKvP7WuMP3tcTK1bz+yMvKudPDo6iw/LqsuPbIy7ywyLrX6aOpoaO9+9a5yM66zsjL1NrOtL6t
ytrIqLXEx+m/9s/C0tTIzrrO0M7Kvcq508Oho8jnufvE+rTtytXBy7G+08q8/qOsx+vBory00tS1
59fT08q8/s2o1qq3orz+yMuyosm+s/2xvtPKvP68sMbkuL28/qGjDQoNClRoaXMgZS1tYWlsIGFu
ZCBpdHMgYXR0YWNobWVudHMgY29udGFpbiBjb25maWRlbnRpYWwgaW5mb3JtYXRpb24gZnJvbSBP
UFBPLCB3aGljaCBpcyBpbnRlbmRlZCBvbmx5IGZvciB0aGUgcGVyc29uIG9yIGVudGl0eSB3aG9z
ZSBhZGRyZXNzIGlzIGxpc3RlZCBhYm92ZS4gQW55IHVzZSBvZiB0aGUgaW5mb3JtYXRpb24gY29u
dGFpbmVkIGhlcmVpbiBpbiBhbnkgd2F5IChpbmNsdWRpbmcsIGJ1dCBub3QgbGltaXRlZCB0bywg
dG90YWwgb3IgcGFydGlhbCBkaXNjbG9zdXJlLCByZXByb2R1Y3Rpb24sIG9yIGRpc3NlbWluYXRp
b24pIGJ5IHBlcnNvbnMgb3RoZXIgdGhhbiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpIGlzIHBy
b2hpYml0ZWQuIElmIHlvdSByZWNlaXZlIHRoaXMgZS1tYWlsIGluIGVycm9yLCBwbGVhc2Ugbm90
aWZ5IHRoZSBzZW5kZXIgYnkgcGhvbmUgb3IgZW1haWwgaW1tZWRpYXRlbHkgYW5kIGRlbGV0ZSBp
dCENCg==
