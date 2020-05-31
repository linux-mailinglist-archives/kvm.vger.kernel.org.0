Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE71E94F6
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 04:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgEaCJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 22:09:07 -0400
Received: from mx22.baidu.com ([220.181.50.185]:37062 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729026AbgEaCJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 22:09:06 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 3CB0518013BDAF5E62D4;
        Sun, 31 May 2020 10:08:53 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Sun, 31 May 2020 10:08:52 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Sun, 31 May 2020 10:08:46 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Y1XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Topic: [PATCH][v5] KVM: X86: support APERF/MPERF registers
Thread-Index: AQHWNjvN8r9nufprD0OWRxID181WWai/6tGAgAGIe0A=
Date:   Sun, 31 May 2020 02:08:46 +0000
Message-ID: <e7ccee7dc30e4d1e8dcb8a002d6a6ed2@baidu.com>
References: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
 <3f931ecf-7f1c-c178-d18c-46beadd1d313@intel.com>
In-Reply-To: <3f931ecf-7f1c-c178-d18c-46beadd1d313@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.233.95]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex15_2020-05-31 10:08:53:113
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex15_GRAY_Inside_WithoutAtta_2020-05-31
 10:08:53:082
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFhpYW95YW8gTGkgW21h
aWx0bzp4aWFveWFvLmxpQGludGVsLmNvbV0NCj4g5Y+R6YCB5pe26Ze0OiAyMDIw5bm0NeaciDMw
5pelIDE4OjQwDQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsg
eDg2QGtlcm5lbC5vcmc7IGhwYUB6eXRvci5jb207IGJwQGFsaWVuOC5kZTsNCj4gbWluZ29AcmVk
aGF0LmNvbTsgdGdseEBsaW51dHJvbml4LmRlOyBqbWF0dHNvbkBnb29nbGUuY29tOw0KPiB3YW5w
ZW5nbGlAdGVuY2VudC5jb207IHZrdXpuZXRzQHJlZGhhdC5jb207DQo+IHNlYW4uai5jaHJpc3Rv
cGhlcnNvbkBpbnRlbC5jb207IHBib256aW5pQHJlZGhhdC5jb207DQo+IHdlaS5odWFuZzJAYW1k
LmNvbQ0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdW3Y1XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N
UEVSRiByZWdpc3RlcnMNCj4gDQo+IE9uIDUvMzAvMjAyMCAxMjozNSBQTSwgTGkgUm9uZ1Fpbmcg
d3JvdGU6DQo+ID4gR3Vlc3Qga2VybmVsIHJlcG9ydHMgYSBmaXhlZCBjcHUgZnJlcXVlbmN5IGlu
IC9wcm9jL2NwdWluZm8sIHRoaXMgaXMNCj4gPiBjb25mdXNlZCB0byB1c2VyIHdoZW4gdHVyYm8g
aXMgZW5hYmxlLCBhbmQgYXBlcmYvbXBlcmYgY2FuIGJlIHVzZWQgdG8NCj4gPiBzaG93IGN1cnJl
bnQgY3B1IGZyZXF1ZW5jeSBhZnRlciA3ZDU5MDVkYzE0YQ0KPiA+ICIoeDg2IC8gQ1BVOiBBbHdh
eXMgc2hvdyBjdXJyZW50IENQVSBmcmVxdWVuY3kgaW4gL3Byb2MvY3B1aW5mbykiDQo+ID4gc28g
Z3Vlc3Qgc2hvdWxkIHN1cHBvcnQgYXBlcmYvbXBlcmYgY2FwYWJpbGl0eQ0KPiA+DQo+ID4gVGhp
cyBwYXRjaCBpbXBsZW1lbnRzIGFwZXJmL21wZXJmIGJ5IHRocmVlIG1vZGU6IG5vbmUsIHNvZnR3
YXJlDQo+ID4gZW11bGF0aW9uLCBhbmQgcGFzcy10aHJvdWdoDQo+ID4NCj4gPiBOb25lOiBkZWZh
dWx0IG1vZGUsIGd1ZXN0IGRvZXMgbm90IHN1cHBvcnQgYXBlcmYvbXBlcmYNCj4gPg0KPiA+IFNv
ZnR3YXJlIGVtdWxhdGlvbjogdGhlIHBlcmlvZCBvZiBhcGVyZi9tcGVyZiBpbiBndWVzdCBtb2Rl
IGFyZQ0KPiA+IGFjY3VtdWxhdGVkIGFzIGVtdWxhdGVkIHZhbHVlDQo+ID4NCj4gPiBQYXNzLXRo
b3VnaDogaXQgaXMgb25seSBzdWl0YWJsZSBmb3IgS1ZNX0hJTlRTX1JFQUxUSU1FLCBCZWNhdXNl
IHRoYXQNCj4gPiBoaW50IGd1YXJhbnRlZXMgd2UgaGF2ZSBhIDE6MSB2Q1BVOkNQVSBiaW5kaW5n
IGFuZCBndWFyYW50ZWVkIG5vDQo+ID4gb3Zlci1jb21taXQuDQo+ID4NCj4gPiBBbmQgYSBwZXIt
Vk0gY2FwYWJpbGl0eSBpcyBhZGRlZCB0byBjb25maWd1cmUgYXBlcmZtcGVyZiBtb2RlDQo+ID4N
Cj4gDQo+IFsuLi5dDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQuYyBi
L2FyY2gveDg2L2t2bS9jcHVpZC5jIGluZGV4DQo+ID4gY2Q3MDhiMGI0NjBhLi5jOTYwZGRhNDI1
MWIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gPiArKysgYi9hcmNo
L3g4Ni9rdm0vY3B1aWQuYw0KPiA+IEBAIC0xMjIsNiArMTIyLDE0IEBAIGludCBrdm1fdXBkYXRl
X2NwdWlkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiAgIAkJCQkJICAgTVNSX0lBMzJfTUlT
Q19FTkFCTEVfTVdBSVQpOw0KPiA+ICAgCX0NCj4gPg0KPiA+ICsJYmVzdCA9IGt2bV9maW5kX2Nw
dWlkX2VudHJ5KHZjcHUsIDYsIDApOw0KPiA+ICsJaWYgKGJlc3QpIHsNCj4gPiArCQlpZiAoZ3Vl
c3RfaGFzX2FwZXJmbXBlcmYodmNwdS0+a3ZtKSAmJg0KPiA+ICsJCQlib290X2NwdV9oYXMoWDg2
X0ZFQVRVUkVfQVBFUkZNUEVSRikpDQo+ID4gKwkJCWJlc3QtPmVjeCB8PSAxOw0KPiA+ICsJCWVs
c2UNCj4gPiArCQkJYmVzdC0+ZWN4ICY9IH4xOw0KPiA+ICsJfQ0KPiANCj4gSW4gbXkgdW5kZXJz
dGFuZGluZywgS1ZNIGFsbG93cyB1c2Vyc3BhY2UgdG8gc2V0IGEgQ1BVSUQgZmVhdHVyZSBiaXQg
Zm9yDQo+IGd1ZXN0IGV2ZW4gaWYgaGFyZHdhcmUgZG9lc24ndCBzdXBwb3J0IHRoZSBmZWF0dXJl
Lg0KPiANCj4gU28gd2hhdCBtYWtlcyBYODZfRkVBVFVSRV9BUEVSRk1QRVJGIGRpZmZlcmVudCBo
ZXJlPyBJcyB0aGVyZSBhbnkNCj4gY29uY2VybiBJIG1pc3M/DQo+IA0KPiAtWGlhb3lhbw0KDQpX
aGV0aGVyIHNvZnR3YXJlIGVtdWxhdGlvbiBmb3IgYXBlcmYvbXBlcmYgb3IgcGFzcy10aHJvdWdo
IGRlcGVuZHMgb24gaG9zdCBjcHUgYXBlcmYvbXBlcmYgZmVhdHVyZS4NCiANClNvZnR3YXJlIGVt
dWxhdGlvbjogdGhlIHBlcmlvZCBvZiBhcGVyZi9tcGVyZiBpbiBndWVzdCBtb2RlIGFyZSBhY2N1
bXVsYXRlZCBhcyBlbXVsYXRlZCB2YWx1ZQ0KDQotTGkNCg==
