Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A62A48D1C6
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 06:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiAMFIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 00:08:53 -0500
Received: from mx24.baidu.com ([111.206.215.185]:35832 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbiAMFIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 00:08:52 -0500
Received: from BJHW-Mail-Ex12.internal.baidu.com (unknown [10.127.64.35])
        by Forcepoint Email with ESMTPS id D0CF2F038D8C2C6EE0B5;
        Thu, 13 Jan 2022 12:52:40 +0800 (CST)
Received: from bjkjy-mail-ex25.internal.baidu.com (172.31.50.41) by
 BJHW-Mail-Ex12.internal.baidu.com (10.127.64.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 13 Jan 2022 12:52:40 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 bjkjy-mail-ex25.internal.baidu.com (172.31.50.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.17; Thu, 13 Jan 2022 12:52:40 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Thu, 13 Jan 2022 12:52:40 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Wang,Guangju" <wangguangju@baidu.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IFg4Njogc2V0IHZjcHUgcHJlZW1wdGVkIG9u?=
 =?gb2312?Q?ly_if_it_is_preempted?=
Thread-Topic: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Thread-Index: AQHYB7WMg7j2vnvXFkKy6dq5PabOWqxfHr2AgABDQICAAPSkQA==
Date:   Thu, 13 Jan 2022 04:52:40 +0000
Message-ID: <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
In-Reply-To: <20220112213129.GO16608@worktop.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex12_2022-01-13 12:52:40:847
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogUGV0ZXIgWmlqbHN0cmEgPHBldGVy
ekBpbmZyYWRlYWQub3JnPg0KPiC3osvNyrG85DogMjAyMsTqMdTCMTPI1SA1OjMxDQo+IMrVvP7I
yzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ILOty806IExpLFJv
bmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47IHBib256aW5pQHJlZGhhdC5jb207DQo+IHZr
dXpuZXRzQHJlZGhhdC5jb207IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsgam1hdHRzb25AZ29vZ2xl
LmNvbTsNCj4gdGdseEBsaW51dHJvbml4LmRlOyBicEBhbGllbjguZGU7IHg4NkBrZXJuZWwub3Jn
OyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBqb3JvQDhieXRlcy5vcmcNCj4g1vfM4jogUmU6IFtQ
QVRDSF0gS1ZNOiBYODY6IHNldCB2Y3B1IHByZWVtcHRlZCBvbmx5IGlmIGl0IGlzIHByZWVtcHRl
ZA0KPiANCj4gT24gV2VkLCBKYW4gMTIsIDIwMjIgYXQgMDU6MzA6NDdQTSArMDAwMCwgU2VhbiBD
aHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBPbiBXZWQsIEphbiAxMiwgMjAyMiwgUGV0ZXIgWmlq
bHN0cmEgd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEphbiAxMiwgMjAyMiBhdCAwODowMjowMVBNICsw
ODAwLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiA+ID4gdmNwdSBjYW4gc2NoZWR1bGUgb3V0IHdo
ZW4gcnVuIGhhbHQgaW5zdHJ1Y3Rpb24sIGFuZCBzZXQgaXRzZWxmIHRvDQo+ID4gPiA+IElOVEVS
UlVQVElCTEUgYW5kIHN3aXRjaCB0byBpZGxlIHRocmVhZCwgdmNwdSBzaG91bGQgbm90IGJlIHNl
dA0KPiA+ID4gPiBwcmVlbXB0ZWQgZm9yIHRoaXMgY29uZGl0aW9uDQo+ID4gPg0KPiA+ID4gVWho
bW0sIHdoeSBub3Q/IFdobyBzYXlzIHRoZSB2Y3B1IHdpbGwgcnVuIHRoZSBtb21lbnQgaXQgYmVj
b21lcw0KPiA+ID4gcnVubmFibGUgYWdhaW4/IEFub3RoZXIgdGFzayBjb3VsZCBiZSB3b2tlbiB1
cCBtZWFud2hpbGUgb2NjdXB5aW5nDQo+ID4gPiB0aGUgcmVhbCBjcHUuDQo+ID4NCj4gPiBIcm0s
IGJ1dCB3aGVuIGVtdWxhdGluZyBITFQsIGUuZy4gZm9yIGFuIGlkbGluZyB2Q1BVLCBLVk0gd2ls
bA0KPiA+IHZvbHVudGFyaWx5IHNjaGVkdWxlIG91dCB0aGUgdkNQVSBhbmQgbWFyayBpdCBhcyBw
cmVlbXB0ZWQgZnJvbSB0aGUNCj4gPiBndWVzdCdzIHBlcnNwZWN0aXZlLiAgVGhlIHZhc3QgbWFq
b3JpdHksIHByb2JhYmx5IGFsbCwgdXNhZ2Ugb2YNCj4gPiBzdGVhbF90aW1lLnByZWVtcHRlZCBl
eHBlY3RzIGl0IHRvIHRydWx5IG1lYW4gInByZWVtcHRlZCIgYXMgb3Bwb3NlZCB0bw0KPiAibm90
IHJ1bm5pbmciLg0KPiANCj4gTm8sIHRoZSBvcmlnaW5hbCB1c2UtY2FzZSB3YXMgbG9ja2luZyBh
bmQgdGhhdCByZWFsbHkgY2FyZXMgYWJvdXQgcnVubmluZy4NCj4gDQo+IElmIHRoZSB2Q1BVIGlz
bid0IHJ1bm5pbmcsIHdlIG11c3Qgbm90IGJ1c3ktd2FpdCBmb3IgaXQgZXRjLi4NCj4gDQo+IFNp
bWlsYXIgdG8gdGhlIHNjaGVkdWxlciB1c2Ugb2YgaXQsIGlmIHRoZSB2Q1BVIGlzbid0IHJ1bm5p
bmcsIHdlIHNob3VsZCBub3QNCj4gY29uc2lkZXIgaXQgc28uIEdldHRpbmcgdGhlIHZDUFUgdGFz
ayBzY2hlZHVsZWQgYmFjayBvbiB0aGUgQ1BVIGNhbiB0YWtlIGEgJ2xvbmcnDQo+IHRpbWUuDQo+
IA0KPiBJZiB5b3UgaGF2ZSBwaW5uZWQgdkNQVSB0aHJlYWRzIGFuZCBubyBvdmVyY29tbWl0LCB3
ZSBoYXZlIG90aGVyIGtub2JzIHRvDQo+IGluZGljYXRlIHRoaXMgSSB0aGluay4NCg0KDQpJcyBp
dCBwb3NzaWJsZSBpZiBndWVzdCBoYXMgS1ZNX0hJTlRTX1JFQUxUSU1FIGZlYXR1cmUsIGJ1dCBp
dHMgSExUIGluc3RydWN0aW9uIGlzIGVtdWxhdGVkIGJ5IEtWTT8NCklmIGl0IGlzIHBvc3NpYmxl
LCB0aGlzIGNvbmRpdGlvbiBoYXMgYmVlbiBwZXJmb3JtYW5jZSBkZWdyYWRhdGlvbiwgc2luY2Ug
dmNwdV9pc19wcmVlbXB0ZWQgaXMgbm90IF9fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkLCB3aWxsIHJl
dHVybiBmYWxzZS4NCg0KU2ltaWxhciwgZ3Vlc3QgaGFzIG5vcHZzcGluLCBidXQgSExUIGluc3Ry
dWN0aW9uIGlzIGVtdWxhdGVkOyAgDQoNClNob3VsZCB3ZSBhZGp1c3QgdGhlIHNldHRpbmcgb2Yg
cHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgYXMgYmVsb3cNCkFuZCBJIHNlZSB0aGUgcGVy
Zm9ybWFuY2UgYm9vc3Qgd2hlbiBndWVzdCBoYXMgbm9wdnNwaW4sIGJ1dCBITFQgaW5zdHJ1Y3Rp
b24gaXMgZW11bGF0ZWQgd2l0aCBiZWxvdyBjaGFuZ2UNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2tlcm5lbC9rdm0uYyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KaW5kZXggNTlhYmJkYS4uYjA2
MWQxNyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KKysrIGIvYXJjaC94ODYv
a2VybmVsL2t2bS5jDQpAQCAtMTA0OCw2ICsxMDQ4LDExIEBAIHZvaWQgX19pbml0IGt2bV9zcGlu
bG9ja19pbml0KHZvaWQpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0KICAgICAgICB9DQoNCisg
ICAgICAgaWYgKGt2bV9wYXJhX2hhc19mZWF0dXJlKEtWTV9GRUFUVVJFX1NURUFMX1RJTUUpKSB7
DQorICAgICAgICAgICAgICAgcHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgPQ0KKyAgICAg
ICAgICAgICAgICAgICAgICAgUFZfQ0FMTEVFX1NBVkUoX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQp
Ow0KKyAgICAgICB9DQorDQogICAgICAgIC8qDQogICAgICAgICAqIERpc2FibGUgUFYgc3Bpbmxv
Y2tzIGFuZCB1c2UgbmF0aXZlIHFzcGlubG9jayB3aGVuIGRlZGljYXRlZCBwQ1BVcw0KICAgICAg
ICAgKiBhcmUgYXZhaWxhYmxlLg0KQEAgLTEwNzYsMTAgKzEwODEsNiBAQCB2b2lkIF9faW5pdCBr
dm1fc3BpbmxvY2tfaW5pdCh2b2lkKQ0KICAgICAgICBwdl9vcHMubG9jay53YWl0ID0ga3ZtX3dh
aXQ7DQogICAgICAgIHB2X29wcy5sb2NrLmtpY2sgPSBrdm1fa2lja19jcHU7DQoNCi0gICAgICAg
aWYgKGt2bV9wYXJhX2hhc19mZWF0dXJlKEtWTV9GRUFUVVJFX1NURUFMX1RJTUUpKSB7DQotICAg
ICAgICAgICAgICAgcHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgPQ0KLSAgICAgICAgICAg
ICAgICAgICAgICAgUFZfQ0FMTEVFX1NBVkUoX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQpOw0KLSAg
ICAgICB9DQogICAgICAgIC8qDQogICAgICAgICAqIFdoZW4gUFYgc3BpbmxvY2sgaXMgZW5hYmxl
ZCB3aGljaCBpcyBwcmVmZXJyZWQgb3Zlcg0KICAgICAgICAgKiB2aXJ0X3NwaW5fbG9jaygpLCB2
aXJ0X3NwaW5fbG9ja19rZXkncyB2YWx1ZSBpcyBtZWFuaW5nbGVzcy4NCg0KDQotTGkNCg==
