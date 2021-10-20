Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF07B4349EA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhJTLSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:18:14 -0400
Received: from mx22.baidu.com ([220.181.50.185]:41128 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229864AbhJTLSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 07:18:13 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 302AC272F5C1A60FEAE1;
        Wed, 20 Oct 2021 19:15:52 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 20 Oct 2021 19:15:51 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Wed, 20 Oct 2021 19:15:51 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogQ2xlYXIgcHYgZW9pIHBlbmRpbmcgYml0?=
 =?utf-8?Q?_only_when_it_is_set?=
Thread-Topic: [PATCH] KVM: Clear pv eoi pending bit only when it is set
Thread-Index: AQHXxI34DWGf3tlYw06xK547fXtZjqvZZTmAgAABlACAAdXDEIAAgECw
Date:   Wed, 20 Oct 2021 11:15:51 +0000
Message-ID: <a01726cd1d2f4014a801524de961a135@baidu.com>
References: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
 <87y26pwk96.fsf@vitty.brq.redhat.com>
 <876df534-a280-dc26-6a70-a1464bacad5f@redhat.com> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.4]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+DQo+ID4gT24gMTkvMTAvMjEgMDk6MjMsIFZpdGFseSBLdXpuZXRzb3Ygd3JvdGU6DQo+ID4g
Pj4NCj4gPiA+PiAtc3RhdGljIHZvaWQgcHZfZW9pX2Nscl9wZW5kaW5nKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gPiA+PiArc3RhdGljIHZvaWQgcHZfZW9pX2Nscl9wZW5kaW5nKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgYm9vbA0KPiA+ID4+ICtwZW5kaW5nKQ0KPiA+ID4gTml0cGljayAoYW5k
IHByb2JhYmx5IGEgbWF0dGVyIG9mIHBlcnNvbmFsIHRhc3RlKToNCj4gPiA+IHB2X2VvaV9jbHJf
cGVuZGluZygpIGhhcyBvbmx5IG9uZSB1c2VyIGFuZCB0aGUgY2hhbmdlIGRvZXNuJ3QgbWFrZQ0K
PiA+ID4gaXRzIGludGVyZmFjZSBtdWNoIG5pY2VyLCBJJ2Qgc3VnZ2VzdCB3ZSBqdXN0IGlubGlu
ZSBpbiBpbnN0ZWFkLiAod2UNCj4gPiA+IGNhbiBwcm9iYWJseSBkbyB0aGUgc2FtZSB0bw0KPiA+
ID4gcHZfZW9pX2dldF9wZW5kaW5nKCkvcHZfZW9pX3NldF9wZW5kaW5nKCkgdG9vKS4NCj4gPg0K
PiA+IEFsdGVybmF0aXZlbHksIG1lcmdlIHB2X2VvaV9nZXRfcGVuZGluZyBhbmQgcHZfZW9pX2Ns
cl9wZW5kaW5nIGludG8gYQ0KPiA+IHNpbmdsZSBmdW5jdGlvbiBwdl9lb2lfdGVzdF9hbmRfY2xl
YXJfcGVuZGluZywgd2hpY2ggcmV0dXJucyB0aGUgdmFsdWUNCj4gPiBvZiB0aGUgcGVuZGluZyBi
aXQuDQo+ID4NCj4gPiBTbyB0aGUgY2FsbGVyIGNhbiBkbyBlc3NlbnRpYWxseToNCj4gPg0KPiA+
IC0JcGVuZGluZyA9IHB2X2VvaV9nZXRfcGVuZGluZyh2Y3B1KTsNCj4gPiAtCXB2X2VvaV9jbHJf
cGVuZGluZyh2Y3B1KTsNCj4gPiAtCWlmIChwZW5kaW5nKQ0KPiA+ICsJaWYgKHB2X2VvaV90ZXN0
X2FuZF9jbGVhcl9wZW5kaW5nKHZjcHUpKQ0KPiA+ICAgICAgICAgICAgICAgICAgcmV0dXJuOw0K
PiA+DQo+ID4NCj4gDQo+IEl0IGlzIGJldHRlciB0byBpbXBsZW1lbnQgcHZfZW9pX3Rlc3RfYW5k
X2NsZWFyX3BlbmRpbmcoKSwgYW5kIGl0IGNhbiBmaXggdGhlDQo+IHJhY2UgdGhhdCBWaXRhbHkg
c3VnZ2VzdGVkDQo+IA0KPiBBbmQgSSB3aWxsIHdyaXRlIGEgbmV3IGZ1bmN0aW9uIGt2bV90ZXN0
X2FuZF9jbGVhcl9iaXRfZ3Vlc3RfY2FjaGVkLCB0byBiZQ0KPiBjYWxsZWQgaW4gcHZfZW9pX3Rl
c3RfYW5kX2NsZWFyX3BlbmRpbmcNCj4gDQo+IEJvb2wga3ZtX3Rlc3RfYW5kX2NsZWFyX2JpdF9n
dWVzdF9jYWNoZWTvvIhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHXvvIwgIHN0cnVjdA0KPiBnZm5fdG9f
aHZhX2NhY2hlICogZ2hj77yMIGxvbmcgbnLvvIkNCj4gDQoNCmdmbl90b19odmFfY2FjaGUgaGFz
IGh2YSh1c2VyIHNwYWNlIGFkZHJlc3MpLCBidXQgbm8gaHBhLCBhbmQgdGVzdF9hbmRfY2xlYXIo
KSBjYW4gbm90IGJlIHVzZWQgdG8gdXNlciBzcGFjZSBhZGRyZXNzLiBTbyBrdm1fdGVzdF9hbmRf
Y2xlYXJfYml0X2d1ZXN0X2NhY2hlZCBzZWVtcyBub3Qgd29yaw0KDQotTGkNCg0KPiAtTGkNCj4g
DQo+ID4gUGFvbG8NCg0K
