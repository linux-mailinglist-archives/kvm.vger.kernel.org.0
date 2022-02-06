Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDD54AAF0F
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 12:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbiBFLwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 06:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiBFLkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 06:40:24 -0500
X-Greylist: delayed 1010 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 03:40:23 PST
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C200C06173B
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 03:40:23 -0800 (PST)
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 54065AB95EE2E8C165A9;
        Sun,  6 Feb 2022 19:23:24 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Sun, 6 Feb 2022 19:23:24 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Sun, 6 Feb 2022 19:23:24 +0800
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
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IFg4Njogc2V0IHZjcHUgcHJlZW1wdGVkIG9u?=
 =?gb2312?Q?ly_if_it_is_preempted?=
Thread-Topic: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Thread-Index: AQHYB7WMg7j2vnvXFkKy6dq5PabOWqxfHr2AgABDQICAJyN4QA==
Date:   Sun, 6 Feb 2022 11:23:23 +0000
Message-ID: <f01888124ade425fb88c8f7e3a5c0f6f@baidu.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
In-Reply-To: <20220112213129.GO16608@worktop.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.117.122]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
ZSBoYXZlIG90aGVyIGtub2JzIHRvDQo+IGluZGljYXRlIHRoaXMgSSB0aWhuay4NCg0KDQpJZiB2
Y3B1IGlzIGlkbGUsIGFuZCBiZSBtYXJrZWQgYXMgcHJlZW1wdGVkLCBpcyBpdCByaWdodCBpbiBr
dm1fc21wX3NlbmRfY2FsbF9mdW5jX2lwaT8NCg0Kc3RhdGljIHZvaWQga3ZtX3NtcF9zZW5kX2Nh
bGxfZnVuY19pcGkoY29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2spDQp7DQogICAgaW50IGNwdTsN
Cg0KICAgIG5hdGl2ZV9zZW5kX2NhbGxfZnVuY19pcGkobWFzayk7DQoNCiAgICAvKiBNYWtlIHN1
cmUgb3RoZXIgdkNQVXMgZ2V0IGEgY2hhbmNlIHRvIHJ1biBpZiB0aGV5IG5lZWQgdG8uICovDQog
ICAgZm9yX2VhY2hfY3B1KGNwdSwgbWFzaykgew0KICAgICAgICBpZiAodmNwdV9pc19wcmVlbXB0
ZWQoY3B1KSkgew0KICAgICAgICAgICAga3ZtX2h5cGVyY2FsbDEoS1ZNX0hDX1NDSEVEX1lJRUxE
LCBwZXJfY3B1KHg4Nl9jcHVfdG9fYXBpY2lkLCBjcHUpKTsNCiAgICAgICAgICAgIGJyZWFrOw0K
ICAgICAgICB9DQogICAgfQ0KfQ0KDQoNCi1MaSANCg==
