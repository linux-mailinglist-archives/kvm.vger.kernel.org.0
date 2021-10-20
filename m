Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F378B4343F7
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 05:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhJTDqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 23:46:16 -0400
Received: from mx24.baidu.com ([111.206.215.185]:43088 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229635AbhJTDqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 23:46:15 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 4B7AB55964DAFEB04D2E;
        Wed, 20 Oct 2021 11:43:59 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 20 Oct 2021 11:43:59 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Wed, 20 Oct 2021 11:43:59 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IENsZWFyIHB2IGVvaSBwZW5kaW5nIGJpdCBv?=
 =?gb2312?Q?nly_when_it_is_set?=
Thread-Topic: [PATCH] KVM: Clear pv eoi pending bit only when it is set
Thread-Index: AQHXxI34DWGf3tlYw06xK547fXtZjqvZZTmAgAHZApA=
Date:   Wed, 20 Oct 2021 03:43:58 +0000
Message-ID: <d2d3fca1cca7438e97a0641fdd6befac@baidu.com>
References: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
 <87y26pwk96.fsf@vitty.brq.redhat.com>
In-Reply-To: <87y26pwk96.fsf@vitty.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.4]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2021-10-20 11:43:59:179
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogVml0YWx5IEt1em5ldHNvdiA8dmt1
em5ldHNAcmVkaGF0LmNvbT4NCj4gt6LLzcqxvOQ6IDIwMjHE6jEw1MIxOcjVIDE1OjI0DQo+IMrV
vP7IyzogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiCzrcvNOiBMaSxSb25n
cWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+OyBwYm9uemluaUByZWRoYXQuY29tOw0KPiBzZWFu
amNAZ29vZ2xlLmNvbTsgd2FucGVuZ2xpQHRlbmNlbnQuY29tOyBqbWF0dHNvbkBnb29nbGUuY29t
Ow0KPiBqb3JvQDhieXRlcy5vcmc7IHRnbHhAbGludXRyb25peC5kZTsgbWluZ29AcmVkaGF0LmNv
bTsgYnBAYWxpZW44LmRlOw0KPiB4ODZAa2VybmVsLm9yZzsgaHBhQHp5dG9yLmNvbTsga3ZtQHZn
ZXIua2VybmVsLm9yZw0KPiDW98ziOiBSZTogW1BBVENIXSBLVk06IENsZWFyIHB2IGVvaSBwZW5k
aW5nIGJpdCBvbmx5IHdoZW4gaXQgaXMgc2V0DQo+IA0KPiBMaSBSb25nUWluZyA8bGlyb25ncWlu
Z0BiYWlkdS5jb20+IHdyaXRlczoNCj4gDQo+ID4gY2xlYXIgcHYgZW9pIHBlbmRpbmcgYml0IG9u
bHkgd2hlbiBpdCBpcyBzZXQsIHRvIGF2b2lkIGNhbGxpbmcNCj4gPiBwdl9lb2lfcHV0X3VzZXIo
KQ0KPiA+DQo+ID4gYW5kIHRoaXMgY2FuIHNwZWVkIHB2X2VvaV9jbHJfcGVuZGluZyBhYm91dCAz
MDAgbnNlYyBvbiBBTUQgRVBZQyBtb3N0DQo+ID4gb2YgdGhlIHRpbWUNCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4g
PiAgYXJjaC94ODYva3ZtL2xhcGljLmMgfCAgICA3ICsrKystLS0NCj4gPiAgMSBmaWxlcyBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL2xhcGljLmMgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBpbmRleA0KPiA+
IDc2ZmIwMDkuLmM0MzRmNzAgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMN
Cj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiA+IEBAIC02OTQsOSArNjk0LDkgQEAg
c3RhdGljIHZvaWQgcHZfZW9pX3NldF9wZW5kaW5nKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSkN
Cj4gPiAgCV9fc2V0X2JpdChLVk1fQVBJQ19QVl9FT0lfUEVORElORywgJnZjcHUtPmFyY2guYXBp
Y19hdHRlbnRpb24pOyAgfQ0KPiA+DQo+ID4gLXN0YXRpYyB2b2lkIHB2X2VvaV9jbHJfcGVuZGlu
ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gK3N0YXRpYyB2b2lkIHB2X2VvaV9jbHJfcGVu
ZGluZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJvb2wgcGVuZGluZykNCj4gDQo+IE5pdHBpY2sg
KGFuZCBwcm9iYWJseSBhIG1hdHRlciBvZiBwZXJzb25hbCB0YXN0ZSk6IHB2X2VvaV9jbHJfcGVu
ZGluZygpIGhhcyBvbmx5DQo+IG9uZSB1c2VyIGFuZCB0aGUgY2hhbmdlIGRvZXNuJ3QgbWFrZSBp
dHMgaW50ZXJmYWNlIG11Y2ggbmljZXIsIEknZCBzdWdnZXN0IHdlDQo+IGp1c3QgaW5saW5lIGlu
IGluc3RlYWQuICh3ZSBjYW4gcHJvYmFibHkgZG8gdGhlIHNhbWUgdG8NCj4gcHZfZW9pX2dldF9w
ZW5kaW5nKCkvcHZfZW9pX3NldF9wZW5kaW5nKCkgdG9vKS4NCj4gDQo+ID4gIHsNCj4gPiAtCWlm
IChwdl9lb2lfcHV0X3VzZXIodmNwdSwgS1ZNX1BWX0VPSV9ESVNBQkxFRCkgPCAwKSB7DQo+ID4g
KwlpZiAocGVuZGluZyAmJiBwdl9lb2lfcHV0X3VzZXIodmNwdSwgS1ZNX1BWX0VPSV9ESVNBQkxF
RCkgPCAwKSB7DQo+ID4gIAkJcHJpbnRrKEtFUk5fV0FSTklORyAiQ2FuJ3QgY2xlYXIgRU9JIE1T
UiB2YWx1ZTogMHglbGx4XG4iLA0KPiA+ICAJCQkgICAodW5zaWduZWQgbG9uZyBsb25nKXZjcHUt
PmFyY2gucHZfZW9pLm1zcl92YWwpOw0KPiA+ICAJCXJldHVybjsNCj4gPiBAQCAtMjY5Myw3ICsy
NjkzLDggQEAgc3RhdGljIHZvaWQgYXBpY19zeW5jX3B2X2VvaV9mcm9tX2d1ZXN0KHN0cnVjdA0K
PiBrdm1fdmNwdSAqdmNwdSwNCj4gPiAgCSAqIFdoaWxlIHRoaXMgbWlnaHQgbm90IGJlIGlkZWFs
IGZyb20gcGVyZm9ybWFuY2UgcG9pbnQgb2YgdmlldywNCj4gPiAgCSAqIHRoaXMgbWFrZXMgc3Vy
ZSBwdiBlb2kgaXMgb25seSBlbmFibGVkIHdoZW4gd2Uga25vdyBpdCdzIHNhZmUuDQo+ID4gIAkg
Ki8NCj4gPiAtCXB2X2VvaV9jbHJfcGVuZGluZyh2Y3B1KTsNCj4gPiArCXB2X2VvaV9jbHJfcGVu
ZGluZyh2Y3B1LCBwZW5kaW5nKTsNCj4gPiArDQo+ID4gIAlpZiAocGVuZGluZykNCj4gPiAgCQly
ZXR1cm47DQo+ID4gIAl2ZWN0b3IgPSBhcGljX3NldF9lb2koYXBpYyk7DQo+IA0KPiBDb3VsZCB5
b3UgcHJvYmFibHkgZWxhYm9yYXRlIGEgYml0IChwcm9iYWJseSBieSBlbmhhbmNpbmcgdGhlIGNv
bW1lbnQgYWJvdmUNCj4gcHZfZW9pX2Nscl9wZW5kaW5nKCkpIHdoeSB0aGUgcmFjZSB3ZSBoYXZl
IGhlcmUgKGV2ZW4gYmVmb3JlIHRoZQ0KPiBwYXRjaCkgZG9lc24ndCBtYXR0ZXI/IEFzIGZhciBh
cyBJIHVuZGVyc3RhbmQgaXQsIHRoZSBndWVzdCBjYW4gY2hhbmdlIFBWIEVPSQ0KPiBzdGF0dXMg
ZnJvbSBhIGRpZmZlcmVudCBDUFUgKGl0IHNob3VsZG4ndCBkbyBpdCBidXQgaXQgc3RpbGwgY2Fu
KSBhdCBhbnkgdGltZTogZS5nLg0KPiBiZXR3ZWVuIHB2X2VvaV9nZXRfcGVuZGluZygpIGFuZCBw
dl9lb2lfY2xyX3BlbmRpbmcoKSBidXQgYWxzbyByaWdodCBhZnRlciB3ZQ0KPiBkbyBwdl9lb2lf
Y2xyX3BlbmRpbmcoKSBzbyB0aGUgcGF0Y2ggZG9lc24ndCByZWFsbHkgY2hhbmdlIG11Y2ggaW4g
dGhpcyByZWdhcmQuDQo+IA0KDQpJcyBpdCByZWFzb25hYmxlIHRoYXQgdGhlIGd1ZXN0IGNoYW5n
ZSBQViBFT0kgc3RhdHVzIGZyb20gYSBkaWZmZXJlbnQgQ1BVPyAgSSB0aGluayB0aGlzIGNhbiBs
ZWFkIHRvIGd1ZXN0IGVycm9yIG9yIHN0dWNrDQoNCkFuZCBuZXcgZnVuY3Rpb24gcHZfZW9pX3Rl
c3RfYW5kX2NsZWFyX3BlbmRpbmcgYW5kIGt2bV90ZXN0X2FuZF9jbGVhcl9iaXRfZ3Vlc3RfY2Fj
aGVkIHNob3VsZCBiZSBhYmxlIHRvIGZpeCB0aGUgcmFjZQ0KDQpJIHdpbGwgc2VuZCBWMg0KDQpU
aGFua3MNCg0KLUxpDQoNCg0KDQo+IC0tDQo+IFZpdGFseQ0KDQo=
