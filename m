Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902933D1D4D
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 07:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhGVEmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 00:42:14 -0400
Received: from mx20.baidu.com ([111.202.115.85]:47998 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhGVEmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 00:42:14 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id A0C6C105E38F84508211;
        Thu, 22 Jul 2021 13:22:43 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 22 Jul 2021 13:22:43 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Thu, 22 Jul 2021 13:22:43 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     =?utf-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@nextfour.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUgc3RhdHVz?=
 =?utf-8?Q?_when_halt_polling?=
Thread-Topic: [PATCH] KVM: Consider SMT idle status when halt polling
Thread-Index: AQHXfrA0bqZtloIq0E2JewUw/QgE86tOcMnA
Date:   Thu, 22 Jul 2021 05:22:43 +0000
Message-ID: <83070b50abe04172b10745584d6b30cb@baidu.com>
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <a05553b3-7475-c1b8-0282-81ab8b1185c6@nextfour.com>
In-Reply-To: <a05553b3-7475-c1b8-0282-81ab8b1185c6@nextfour.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.194.42]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NjaGVkLmggYi9pbmNsdWRlL2xpbnV4L3Nj
aGVkLmggaW5kZXgNCj4gPiBlYzhkMDdkLi5jMzMzMjE4IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1
ZGUvbGludXgvc2NoZWQuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvc2NoZWQuaA0KPiA+IEBA
IC0zNCw2ICszNCw3IEBADQo+ID4gICAjaW5jbHVkZSA8bGludXgvcnNlcS5oPg0KPiA+ICAgI2lu
Y2x1ZGUgPGxpbnV4L3NlcWxvY2suaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9rY3Nhbi5oPg0K
PiA+ICsjaW5jbHVkZSA8bGludXgvdG9wb2xvZ3kuaD4NCj4gPiAgICNpbmNsdWRlIDxhc20va21h
cF9zaXplLmg+DQo+ID4NCj4gPiAgIC8qIHRhc2tfc3RydWN0IG1lbWJlciBwcmVkZWNsYXJhdGlv
bnMgKHNvcnRlZCBhbHBoYWJldGljYWxseSk6ICovIEBADQo+ID4gLTIxOTEsNiArMjE5MiwyMiBA
QCBpbnQgc2NoZWRfdHJhY2VfcnFfbnJfcnVubmluZyhzdHJ1Y3QgcnEgKnJxKTsNCj4gPg0KPiA+
ICAgY29uc3Qgc3RydWN0IGNwdW1hc2sgKnNjaGVkX3RyYWNlX3JkX3NwYW4oc3RydWN0IHJvb3Rf
ZG9tYWluICpyZCk7DQo+ID4NCj4gPiArc3RhdGljIGlubGluZSBib29sIGlzX2NvcmVfaWRsZShp
bnQgY3B1KSB7ICNpZmRlZiBDT05GSUdfU0NIRURfU01UDQo+ID4gKwlpbnQgc2libGluZzsNCj4g
PiArDQo+ID4gKwlmb3JfZWFjaF9jcHUoc2libGluZywgY3B1X3NtdF9tYXNrKGNwdSkpIHsNCj4g
PiArCQlpZiAoY3B1ID09IHNpYmxpbmcpDQo+ID4gKwkJCWNvbnRpbnVlOw0KPiA+ICsNCj4gPiAr
CQlpZiAoIWlkbGVfY3B1KGNwdSkpDQo+ID4gKwkJCXJldHVybiBmYWxzZTsNCj4gDQo+IGlmICgh
aWRsZV9jcHUoc2libGluZykpwqAgaW5zdGVhZCwgbm93IGl0IHJldHVybnMgYWx3YXlzIGZhbHNl
Lg0KPiANCg0KR29vZCBDYXRjaC4gdGhpcyBpcyBoaXN0b3J5IGJ1Zy4NCg0KRG8geW91IGxpa2Ug
dG8gc3VibWl0IGJ5IHlvdXJzZWxmLCBvciBJIHN1Ym1pdCBvbiBiZWhhbGYgeW91DQoNClRoYW5r
cw0KDQotTGkNCg==
