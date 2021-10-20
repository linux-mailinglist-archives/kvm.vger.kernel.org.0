Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8565C4343EC
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 05:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhJTDit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 23:38:49 -0400
Received: from mx22.baidu.com ([220.181.50.185]:35014 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhJTDis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 23:38:48 -0400
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 6FC60B36E7AEADDC5996;
        Wed, 20 Oct 2021 11:36:26 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 20 Oct 2021 11:36:26 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Wed, 20 Oct 2021 11:36:26 +0800
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
Thread-Index: AQHXxI34DWGf3tlYw06xK547fXtZjqvZZTmAgAABlACAAdXDEA==
Date:   Wed, 20 Oct 2021 03:36:26 +0000
Message-ID: <1b9c965dfbac457e8407f00e930f6449@baidu.com>
References: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
 <87y26pwk96.fsf@vitty.brq.redhat.com>
 <876df534-a280-dc26-6a70-a1464bacad5f@redhat.com>
In-Reply-To: <876df534-a280-dc26-6a70-a1464bacad5f@redhat.com>
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

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhb2xvIEJvbnppbmkg
PHBib256aW5pQHJlZGhhdC5jb20+DQo+IOWPkemAgeaXtumXtDogMjAyMeW5tDEw5pyIMTnml6Ug
MTU6MjkNCj4g5pS25Lu25Lq6OiBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29t
PjsgTGksUm9uZ3FpbmcNCj4gPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiDmioTpgIE6IHNlYW5q
Y0Bnb29nbGUuY29tOyB3YW5wZW5nbGlAdGVuY2VudC5jb207IGptYXR0c29uQGdvb2dsZS5jb207
DQo+IGpvcm9AOGJ5dGVzLm9yZzsgdGdseEBsaW51dHJvbml4LmRlOyBtaW5nb0ByZWRoYXQuY29t
OyBicEBhbGllbjguZGU7DQo+IHg4NkBrZXJuZWwub3JnOyBocGFAenl0b3IuY29tOyBrdm1Admdl
ci5rZXJuZWwub3JnDQo+IOS4u+mimDogUmU6IFtQQVRDSF0gS1ZNOiBDbGVhciBwdiBlb2kgcGVu
ZGluZyBiaXQgb25seSB3aGVuIGl0IGlzIHNldA0KPiANCj4gT24gMTkvMTAvMjEgMDk6MjMsIFZp
dGFseSBLdXpuZXRzb3Ygd3JvdGU6DQo+ID4+DQo+ID4+IC1zdGF0aWMgdm9pZCBwdl9lb2lfY2xy
X3BlbmRpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+PiArc3RhdGljIHZvaWQgcHZfZW9p
X2Nscl9wZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBwZW5kaW5nKQ0KPiA+IE5p
dHBpY2sgKGFuZCBwcm9iYWJseSBhIG1hdHRlciBvZiBwZXJzb25hbCB0YXN0ZSk6DQo+ID4gcHZf
ZW9pX2Nscl9wZW5kaW5nKCkgaGFzIG9ubHkgb25lIHVzZXIgYW5kIHRoZSBjaGFuZ2UgZG9lc24n
dCBtYWtlIGl0cw0KPiA+IGludGVyZmFjZSBtdWNoIG5pY2VyLCBJJ2Qgc3VnZ2VzdCB3ZSBqdXN0
IGlubGluZSBpbiBpbnN0ZWFkLiAod2UgY2FuDQo+ID4gcHJvYmFibHkgZG8gdGhlIHNhbWUgdG8N
Cj4gPiBwdl9lb2lfZ2V0X3BlbmRpbmcoKS9wdl9lb2lfc2V0X3BlbmRpbmcoKSB0b28pLg0KPiAN
Cj4gQWx0ZXJuYXRpdmVseSwgbWVyZ2UgcHZfZW9pX2dldF9wZW5kaW5nIGFuZCBwdl9lb2lfY2xy
X3BlbmRpbmcgaW50byBhIHNpbmdsZQ0KPiBmdW5jdGlvbiBwdl9lb2lfdGVzdF9hbmRfY2xlYXJf
cGVuZGluZywgd2hpY2ggcmV0dXJucyB0aGUgdmFsdWUgb2YgdGhlDQo+IHBlbmRpbmcgYml0Lg0K
PiANCj4gU28gdGhlIGNhbGxlciBjYW4gZG8gZXNzZW50aWFsbHk6DQo+IA0KPiAtCXBlbmRpbmcg
PSBwdl9lb2lfZ2V0X3BlbmRpbmcodmNwdSk7DQo+IC0JcHZfZW9pX2Nscl9wZW5kaW5nKHZjcHUp
Ow0KPiAtCWlmIChwZW5kaW5nKQ0KPiArCWlmIChwdl9lb2lfdGVzdF9hbmRfY2xlYXJfcGVuZGlu
Zyh2Y3B1KSkNCj4gICAgICAgICAgICAgICAgICByZXR1cm47DQo+IA0KPiANCg0KSXQgaXMgYmV0
dGVyIHRvIGltcGxlbWVudCBwdl9lb2lfdGVzdF9hbmRfY2xlYXJfcGVuZGluZygpLCBhbmQgaXQg
Y2FuIGZpeCB0aGUgcmFjZSB0aGF0IFZpdGFseSBzdWdnZXN0ZWQNCg0KQW5kIEkgd2lsbCB3cml0
ZSBhIG5ldyBmdW5jdGlvbiBrdm1fdGVzdF9hbmRfY2xlYXJfYml0X2d1ZXN0X2NhY2hlZCwgdG8g
YmUgY2FsbGVkIGluIHB2X2VvaV90ZXN0X2FuZF9jbGVhcl9wZW5kaW5nDQoNCkJvb2wga3ZtX3Rl
c3RfYW5kX2NsZWFyX2JpdF9ndWVzdF9jYWNoZWTvvIhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHXvvIwg
IHN0cnVjdCBnZm5fdG9faHZhX2NhY2hlICogZ2hj77yMIGxvbmcgbnLvvIkNCg0KLUxpIA0KDQo+
IFBhb2xvDQoNCg==
