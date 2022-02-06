Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767354AAF09
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 12:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiBFLwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 06:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiBFLmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 06:42:23 -0500
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15A7DC06173B
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 03:42:23 -0800 (PST)
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id CD4D9CB6A666222446C5;
        Sun,  6 Feb 2022 19:26:07 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Sun, 6 Feb 2022 19:26:07 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Sun, 6 Feb 2022 19:26:07 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVt2M10gS1ZNOiB4ODY6IHJlZmluZSBrdm1fdmNwdV9p?=
 =?gb2312?Q?s=5Fpreempted?=
Thread-Topic: [PATCH][v3] KVM: x86: refine kvm_vcpu_is_preempted
Thread-Index: AQHYC2RN7LhcUJPWaU64b/F31U+tS6x/7JgAgAAgBwCABnST8A==
Date:   Sun, 6 Feb 2022 11:26:07 +0000
Message-ID: <3ca3f4b132f14d079de706310ee393cf@baidu.com>
References: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
 <20220202145414.GD20638@worktop.programming.kicks-ass.net>
 <Yfq19FSnASMfd0BH@google.com>
In-Reply-To: <Yfq19FSnASMfd0BH@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.117.122]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2022-02-06 19:26:07:734
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

PiBPbiBXZWQsIEZlYiAwMiwgMjAyMiwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gT24gTW9u
LCBKYW4gMTcsIDIwMjIgYXQgMDE6Mzc6MjJQTSArMDgwMCwgTGkgUm9uZ1Fpbmcgd3JvdGU6DQo+
ID4gPiBBZnRlciBzdXBwb3J0IHBhcmF2aXJ0dWFsaXplZCBUTEIgc2hvb3Rkb3ducywgc3RlYWxf
dGltZS5wcmVlbXB0ZWQNCj4gPiA+IGluY2x1ZGVzIG5vdCBvbmx5IEtWTV9WQ1BVX1BSRUVNUFRF
RCwgYnV0IGFsc28gS1ZNX1ZDUFVfRkxVU0hfVExCDQo+ID4gPg0KPiA+ID4gYW5kIGt2bV92Y3B1
X2lzX3ByZWVtcHRlZCBzaG91bGQgdGVzdCBvbmx5IHdpdGggS1ZNX1ZDUFVfUFJFRU1QVEVEDQo+
ID4NCj4gPiBUaGlzIHN0aWxsIGZhaWxzIHRvIGFjdHVhbGx5IGV4cGxhaW4gd2hhdCB0aGUgcHJv
YmxlbSBpcywgd2h5IGRpZCB5b3UNCj4gPiB3cml0ZSB0aGlzIHBhdGNoPw0KPiANCj4gWWEsIGRl
ZmluaXRlbHkgaXMgbGFja2luZyBkZXRhaWxzLiAgSSB0aGluayB0aGlzIGNhcHR1cmVzIGV2ZXJ5
dGhpbmcuLi4NCj4gDQo+ICAgVHdlYWsgdGhlIGFzc2VtYmx5IGNvZGUgZm9yIGRldGVjdGluZyBL
Vk1fVkNQVV9QUkVFTVBURUQgdG8gZnV0dXJlDQo+IHByb29mDQo+ICAgaXQgYWdhaW5zdCBuZXcg
ZmVhdHVyZXMsIGNvZGUgcmVmYWN0b3JpbmdzLCBhbmQgdGhlb3JldGljYWwgY29tcGlsZXINCj4g
ICBiZWhhdmlvci4NCj4gDQo+ICAgRXhwbGljaXRseSB0ZXN0IG9ubHkgdGhlIEtWTV9WQ1BVX1BS
RUVNUFRFRCBmbGFnOyBzdGVhbF90aW1lLnByZWVtcHRlZA0KPiAgIGhhcyBhbHJlYWR5IGJlZW4g
b3ZlcmxvYWRlZCBvbmNlIGZvciBLVk1fVkNQVV9GTFVTSF9UTEIsIGFuZCBjaGVja2luZw0KPiB0
aGUNCj4gICBlbnRpcmUgYnl0ZSBmb3IgYSBub24temVybyB2YWx1ZSBjb3VsZCB5aWVsZCBhIGZh
bHNlIHBvc2l0aXZlLiAgVGhpcw0KPiAgIGN1cnJlbnRseSBpc24ndCBwcm9ibGVtYXRpYyBhcyBQ
UkVFTVBURUQgYW5kIEZMVVNIX1RMQiBhcmUgbXV0dWFsbHkNCj4gICBleGNsdXNpdmUsIGJ1dCB0
aGF0IG1heSBub3QgaG9sZCB0cnVlIGZvciBmdXR1cmUgZmxhZ3MuDQo+IA0KPiAgIFVzZSBBTkQg
aW5zdGVhZCBvZiBURVNUIGZvciBxdWVyeWluZyBQUkVFTVBURUQgdG8gY2xlYXIgUkFYWzYzOjhd
IGJlZm9yZQ0KPiAgIHJldHVybmluZyB0byBhdm9pZCBhIHBvdGVudGlhbCBmYWxzZSBwb3N0aXZl
IGluIHRoZSBjYWxsZXIgZHVlIHRvIGxlYXZpbmcNCj4gICB0aGUgYWRkcmVzcyAobm9uLXplcm8g
dmFsdWUpIGluIHRoZSB1cHBlciBiaXRzLiAgQ29tcGlsZXJzIGFyZSB0ZWNobmljYWxseQ0KPiAg
IGFsbG93ZWQgdG8gdXNlIG1vcmUgdGhhbiBhIGJ5dGUgZm9yIHN0b3JpbmcgX0Jvb2wsIGFuZCBp
dCB3b3VsZCBiZSBhbGwgdG9vDQo+ICAgZWFzeSBmb3Igc29tZW9uZSB0byByZWZhY3RvciB0aGUg
cmV0dXJuIHR5cGUgdG8gc29tZXRoaW5nIGxhcmdlci4NCj4gDQo+ICAgS2VlcCB0aGUgU0VUY2Mg
KGJ1dCBjaGFuZ2UgaXQgdG8gc2V0bnogZm9yIHNhbml0eSdzIHNha2UpIGFzIHRoZSBmYWN0IHRo
YXQNCj4gICBLVk1fVkNQVV9QUkVFTVBURUQgaGFwcGVucyB0byBiZSBiaXQgMCwgaS5lLiB0aGUg
QU5EIHdpbGwgeWllbGQgMC8xIGFzDQo+ICAgbmVlZGVkIGZvciBfQm9vbCwgaXMgcHVyZSBjb2lu
Y2lkZW5jZS4NCj4gY3B1X2lzX3ByZWVtcHRlZDsiDQoNCg0KU2VhbjoNCg0KQ291bGQgeW91IHJl
c3VibWl0IHRoaXMgcGF0Y2gsIHRoYW5rcw0KDQotTGkgDQo=
