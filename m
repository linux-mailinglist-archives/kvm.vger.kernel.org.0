Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641A748D6F4
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 12:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiAMLzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 06:55:10 -0500
Received: from mx24.baidu.com ([111.206.215.185]:53028 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231260AbiAMLzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 06:55:09 -0500
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 0CCF0D9A4B3A5DA2587D;
        Thu, 13 Jan 2022 19:55:07 +0800 (CST)
Received: from BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 13 Jan 2022 19:55:06 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 13 Jan 2022 19:55:06 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Thu, 13 Jan 2022 19:55:05 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Wang,Guangju" <wangguangju@baidu.com>
Subject: =?gb2312?B?tPC4tDogtPC4tDogW1BBVENIXSBLVk06IFg4Njogc2V0IHZjcHUgcHJlZW1w?=
 =?gb2312?Q?ted_only_if_it_is_preempted?=
Thread-Topic: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IFg4Njogc2V0IHZjcHUgcHJlZW1wdGVkIG9u?=
 =?gb2312?Q?ly_if_it_is_preempted?=
Thread-Index: AQHYB7WMg7j2vnvXFkKy6dq5PabOWqxfHr2AgABDQICAAPSkQP//1RuAgACeusA=
Date:   Thu, 13 Jan 2022 11:55:05 +0000
Message-ID: <7cdab5cd7fe044b9a34184f1ffab76be@baidu.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
 <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
 <Yd/x7SfI7rNG1erQ@hirez.programming.kicks-ass.net>
In-Reply-To: <Yd/x7SfI7rNG1erQ@hirez.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogUGV0ZXIgWmlqbHN0cmEgPHBldGVy
ekBpbmZyYWRlYWQub3JnPg0KPiC3osvNyrG85DogMjAyMsTqMdTCMTPI1SAxNzozNA0KPiDK1bz+
yMs6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gs63LzTogU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+OyBwYm9uemluaUByZWRoYXQuY29tOw0KPiB2
a3V6bmV0c0ByZWRoYXQuY29tOyB3YW5wZW5nbGlAdGVuY2VudC5jb207IGptYXR0c29uQGdvb2ds
ZS5jb207DQo+IHRnbHhAbGludXRyb25peC5kZTsgYnBAYWxpZW44LmRlOyB4ODZAa2VybmVsLm9y
Zzsga3ZtQHZnZXIua2VybmVsLm9yZzsNCj4gam9yb0A4Ynl0ZXMub3JnOyBXYW5nLEd1YW5nanUg
PHdhbmdndWFuZ2p1QGJhaWR1LmNvbT4NCj4g1vfM4jogUmU6ILTwuLQ6IFtQQVRDSF0gS1ZNOiBY
ODY6IHNldCB2Y3B1IHByZWVtcHRlZCBvbmx5IGlmIGl0IGlzIHByZWVtcHRlZA0KPiANCj4gT24g
VGh1LCBKYW4gMTMsIDIwMjIgYXQgMDQ6NTI6NDBBTSArMDAwMCwgTGksUm9uZ3Fpbmcgd3JvdGU6
DQo+IA0KPiA+ID4gPiA+IE9uIFdlZCwgSmFuIDEyLCAyMDIyIGF0IDA4OjAyOjAxUE0gKzA4MDAs
IExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+ID4gPiA+ID4gdmNwdSBjYW4gc2NoZWR1bGUgb3V0IHdo
ZW4gcnVuIGhhbHQgaW5zdHJ1Y3Rpb24sIGFuZCBzZXQNCj4gPiA+ID4gPiA+IGl0c2VsZiB0byBJ
TlRFUlJVUFRJQkxFIGFuZCBzd2l0Y2ggdG8gaWRsZSB0aHJlYWQsIHZjcHUgc2hvdWxkDQo+ID4g
PiA+ID4gPiBub3QgYmUgc2V0IHByZWVtcHRlZCBmb3IgdGhpcyBjb25kaXRpb24NCj4gDQo+ID4g
SXMgaXQgcG9zc2libGUgaWYgZ3Vlc3QgaGFzIEtWTV9ISU5UU19SRUFMVElNRSBmZWF0dXJlLCBi
dXQgaXRzIEhMVA0KPiBpbnN0cnVjdGlvbiBpcyBlbXVsYXRlZCBieSBLVk0/DQo+ID4gSWYgaXQg
aXMgcG9zc2libGUsIHRoaXMgY29uZGl0aW9uIGhhcyBiZWVuIHBlcmZvcm1hbmNlIGRlZ3JhZGF0
aW9uLCBzaW5jZQ0KPiB2Y3B1X2lzX3ByZWVtcHRlZCBpcyBub3QgX19rdm1fdmNwdV9pc19wcmVl
bXB0ZWQsIHdpbGwgcmV0dXJuIGZhbHNlLg0KPiA+DQo+ID4gU2ltaWxhciwgZ3Vlc3QgaGFzIG5v
cHZzcGluLCBidXQgSExUIGluc3RydWN0aW9uIGlzIGVtdWxhdGVkOw0KPiA+DQo+ID4gU2hvdWxk
IHdlIGFkanVzdCB0aGUgc2V0dGluZyBvZiBwdl9vcHMubG9jay52Y3B1X2lzX3ByZWVtcHRlZCBh
cyBiZWxvdw0KPiA+IEFuZCBJIHNlZSB0aGUgcGVyZm9ybWFuY2UgYm9vc3Qgd2hlbiBndWVzdCBo
YXMgbm9wdnNwaW4sIGJ1dCBITFQNCj4gPiBpbnN0cnVjdGlvbiBpcyBlbXVsYXRlZCB3aXRoIGJl
bG93IGNoYW5nZQ0KPiANCj4gSSdtIGEgbGl0dGxlIGNvbmZ1c2VkOyB0aGUgaW5pdGlhbCBwYXRj
aCBleHBsaWNpdGx5IGF2b2lkZWQgc2V0dGluZyBwcmVlbXB0ZWQgb24gSExULA0KPiB3aGlsZSB0
aGUgYmVsb3cgY2F1c2VzIGl0IHRvIGJlIHNldCBtb3JlLg0KPiANCj4gVGhhdCBzYWlkOyBJIGRv
bid0IG9iamVjdCB0byB0aGlzLCBidXQgSSdtIG5vdCBjb252aW5jZWQgaXQncyByaWdodCBlaXRo
ZXIuIElmIHlvdSBoYXZlDQo+IEhJTlRTX1JFQUxUSU1FIChob3JyaWJsZSBuYW1pbmcgYXNpZGUp
IHRoaXMgbWVhbnMgeW91IGhhdmUgcGlubmVkIHZDUFUgYW5kDQo+IG5vIG92ZXJjb21taXQsIGlu
IHdoaWNoIGNhc2Ugc2V0dGluZyBwcmVlbXB0ZWQgbWFrZXMgbm8gc2Vuc2UuDQo+IA0KPiAqY29u
ZnVzZWQqDQo+IA0KDQpTb3JyeQ0KDQpJIGZpcnN0IG5vdGljZSB0aGF0IGt2bV92Y3B1X2lzX3By
ZWVtcHRlZCgpIGFsd2F5cyByZXR1cm4gdHJ1ZSBmcm9tIGNvZGUgcmV2aWV3LCBldmVuIGlmIHZj
cHUgaXMgaWRsZSwgdGhpbmsgaXQgaXMgdW5yZWFzb25hYmxlLCBzbyBoYXZlIGZpcnN0IHBhdGNo
Lg0KDQpBZnRlciBzZWUgZmVlZGJhY2ssIGRvIHNvbWUgdGVzdHMsIGZpbmQgdGhlIGZpcnN0IHBh
dGNoIHdpbGwgY2F1c2UgdW5peGJlbmNoIHBpcGUgcGVyZm9ybWFuY2UgZGVncmFkaW5nIGluIG9u
ZSBjb3B5IG1vZGUsIHdoaWNoIHByb3ZlIHdoYXQgeW91ciBzYWlkLCBrdm1fdmNwdV9pc19wcmVl
bXB0ZWQgcmV0dXJuIHRydWUgbmVhcmx5IGFsd2F5cywgd2hpY2ggbWFrZXMgdW5peGJlbmNoIHR3
byB0aHJlYWQgcnVubmluZyBpbiBzYW1lIG9uZSB2Y3B1IHNvbWV0aW1lLCBzbyBsZXNzIHdha2V1
cCwgbGVzcyByZXNjaGVkdWxpbmcgaXBpDQoNClNlZSBrdm1fdmNwdV9pc19wcmVlbXB0ZWQoKSB3
b3JrcyBvbmx5IGlmIGd1ZXN0IGhhcyBub3Qgbm9wdnNwaW4ga2VybmVsIGNtZGxpbmUgYW5kIGhh
cyBub3QgS1ZNX0hJTlRTX1JFQUxUSU1FIGZlYXR1cmUgaW4ga3ZtX3NwaW5sb2NrX2luaXQsIHNv
IHRoZXJlIGlzIG5ldyBwYXRjaA0KDQpUaGFua3MNCg0KLUxJDQoNCg0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMgYi9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMgaW5kZXgNCj4g
PiA1OWFiYmRhLi5iMDYxZDE3IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9rdm0u
Yw0KPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiA+IEBAIC0xMDQ4LDYgKzEwNDgs
MTEgQEAgdm9pZCBfX2luaXQga3ZtX3NwaW5sb2NrX2luaXQodm9pZCkNCj4gPiAgICAgICAgICAg
ICAgICAgcmV0dXJuOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gKyAgICAgICBpZiAoa3ZtX3Bh
cmFfaGFzX2ZlYXR1cmUoS1ZNX0ZFQVRVUkVfU1RFQUxfVElNRSkpIHsNCj4gPiArICAgICAgICAg
ICAgICAgcHZfb3BzLmxvY2sudmNwdV9pc19wcmVlbXB0ZWQgPQ0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgIFBWX0NBTExFRV9TQVZFKF9fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkKTsNCj4gPiAr
ICAgICAgIH0NCj4gPiArDQo+ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogRGlzYWJsZSBQ
ViBzcGlubG9ja3MgYW5kIHVzZSBuYXRpdmUgcXNwaW5sb2NrIHdoZW4gZGVkaWNhdGVkDQo+IHBD
UFVzDQo+ID4gICAgICAgICAgKiBhcmUgYXZhaWxhYmxlLg0KPiA+IEBAIC0xMDc2LDEwICsxMDgx
LDYgQEAgdm9pZCBfX2luaXQga3ZtX3NwaW5sb2NrX2luaXQodm9pZCkNCj4gPiAgICAgICAgIHB2
X29wcy5sb2NrLndhaXQgPSBrdm1fd2FpdDsNCj4gPiAgICAgICAgIHB2X29wcy5sb2NrLmtpY2sg
PSBrdm1fa2lja19jcHU7DQo+ID4NCj4gPiAtICAgICAgIGlmIChrdm1fcGFyYV9oYXNfZmVhdHVy
ZShLVk1fRkVBVFVSRV9TVEVBTF9USU1FKSkgew0KPiA+IC0gICAgICAgICAgICAgICBwdl9vcHMu
bG9jay52Y3B1X2lzX3ByZWVtcHRlZCA9DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgUFZf
Q0FMTEVFX1NBVkUoX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQpOw0KPiA+IC0gICAgICAgfQ0KPiA+
ICAgICAgICAgLyoNCj4gPiAgICAgICAgICAqIFdoZW4gUFYgc3BpbmxvY2sgaXMgZW5hYmxlZCB3
aGljaCBpcyBwcmVmZXJyZWQgb3Zlcg0KPiA+ICAgICAgICAgICogdmlydF9zcGluX2xvY2soKSwg
dmlydF9zcGluX2xvY2tfa2V5J3MgdmFsdWUgaXMgbWVhbmluZ2xlc3MuDQo+ID4NCj4gPg0KPiA+
IC1MaQ0K
