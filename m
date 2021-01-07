Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096462ECE7A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbhAGLPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:15:10 -0500
Received: from mail.wangsu.com ([123.103.51.227]:54794 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbhAGLPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:15:10 -0500
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2021 06:15:09 EST
Received: from DESKTOP-IVCA4LL (unknown [218.107.205.212])
        by app2 (Coremail) with SMTP id 4zNnewBXS8y06PZfdHgEAA--.5367S2;
        Thu, 07 Jan 2021 18:55:50 +0800 (CST)
Date:   Thu, 7 Jan 2021 18:55:49 +0800
From:   "Xinlong Lin" <linxl3@wangsu.com>
To:     "Sean Christopherson" <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>
Cc:     "Nitesh Narayan Lal" <nitesh@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, w90p710 <w90p710@gmail.com>,
        pbonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
References: <20210105192844.296277-1-nitesh@redhat.com>, 
        <874kjuidgp.fsf@vitty.brq.redhat.com>, 
        <X/XvWG18aBWocvvf@google.com>
X-Priority: 3
X-GUID: AC7D6AA7-9F08-4226-B628-E8232D89EDBB
X-Has-Attach: no
X-Mailer: Foxmail 7.2.18.95[cn]
Mime-Version: 1.0
Message-ID: <2021010718554863665911@wangsu.com>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
X-CM-TRANSID: 4zNnewBXS8y06PZfdHgEAA--.5367S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWr4DGr4kCw4xKFyUGw47CFg_yoW5GFW8pF
        W8CF1vkFs3Xa4xK392ywsFga1av3ykKwsxArs5GayIyw4jyw18Xr47GrZ0yFn5Zw4ruF1S
        vr1F9F9xCFWUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4xvF2IEb7IF0Fy264kE64k0F2
        4lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr4l4I8I
        3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxV
        WUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcI
        k0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
        JVW8JwCE64xvF2IEb7IF0Fy7YxBIdaVFxhVjvjDU0xZFpf9x07jdTmDUUUUU=
X-CM-SenderInfo: holq5zmt6zt0xjvxhudrp/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAyMS0wMS0wNyBhdMKgMDE6MTEsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj5PbiBX
ZWQsIEphbiAwNiwgMjAyMSwgVml0YWx5IEt1em5ldHNvdiB3cm90ZToKPj4gTml0ZXNoIE5hcmF5
YW4gTGFsIDxuaXRlc2hAcmVkaGF0LmNvbT4gd3JpdGVzOgo+PiA+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4gPiBpbmRleCAzZjdjMWZjN2Ez
Y2UuLjNlMTdjOWZmY2FkOCAxMDA2NDQKPj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMKPj4g
PiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4gPiBAQCAtOTAyMywxOCArOTAyMyw3IEBAIHN0
YXRpYyBpbnQgdmNwdV9lbnRlcl9ndWVzdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+ID7CoAo+
PiA+wqAga3ZtX3g4Nl9vcHMuaGFuZGxlX2V4aXRfaXJxb2ZmKHZjcHUpOwo+PiA+wqAKPj4gPiAt
CS8qCj4+ID4gLQkqIENvbnN1bWUgYW55IHBlbmRpbmcgaW50ZXJydXB0cywgaW5jbHVkaW5nIHRo
ZSBwb3NzaWJsZSBzb3VyY2Ugb2YKPj4gPiAtCSogVk0tRXhpdCBvbiBTVk0KPj4KPj4gSSBraW5k
IG9mIGxpa2VkIHRoaXMgcGFydCBvZiB0aGUgY29tbWVudCwgdGhlIG5ldyAob2xkKSBvbmUgaW4K
Pj4gc3ZtX2hhbmRsZV9leGl0X2lycW9mZigpIGRvZXNuJ3QgYWN0dWFsbHkgZXhwbGFpbiB3aGF0
J3MgZ29pbmcgb24uCj4+Cj4+ID4gYW5kIGFueSB0aWNrcyB0aGF0IG9jY3VyIGJldHdlZW4gVk0t
RXhpdCBhbmQgbm93Lgo+Pgo+PiBMb29raW5nIGJhY2ssIEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFu
ZCB3aHkgd2Ugd2FudGVkIHRvIGFjY291bnQgdGlja3MKPj4gYmV0d2VlbiB2bWV4aXQgYW5kIGV4
aXRpbmcgZ3Vlc3QgY29udGV4dCBhcyAnZ3Vlc3QnIGluIHRoZSBmaXJzdCBwbGFjZTsKPj4gdG8g
bXkgdW5kZXJzdGFuZ2luZyAnZ3Vlc3QgdGltZScgaXMgdGltZSBzcGVudCB3aXRoaW4gVk1YIG5v
bi1yb290Cj4+IG9wZXJhdGlvbiwgdGhlIHJlc3QgaXMgS1ZNIG92ZXJoZWFkIChzeXN0ZW0pLgo+
Cj5XaXRoIHRpY2stYmFzZWQgYWNjb3VudGluZywgaWYgdGhlIHRpY2sgSVJRIGlzIHJlY2VpdmVk
IGFmdGVyIFBGX1ZDUFUgaXMgY2xlYXJlZAo+dGhlbiB0aGF0IHRpY2sgd2lsbCBiZSBhY2NvdW50
ZWQgdG8gdGhlIGhvc3Qvc3lzdGVtLsKgIFRoZSBtb3RpdmF0aW9uIGZvciBvcGVuaW5nCj5hbiBJ
UlEgd2luZG93IGFmdGVyIFZNLUV4aXQgaXMgdG8gaGFuZGxlIHRoZSBjYXNlIHdoZXJlIHRoZSBn
dWVzdCBpcyBjb25zdGFudGx5Cj5leGl0aW5nIGZvciBhIGRpZmZlcmVudCByZWFzb24gX2p1c3Rf
IGJlZm9yZSB0aGUgdGljayBhcnJpdmVzLCBlLmcuIGlmIHRoZSBndWVzdAo+aGFzIGl0cyB0aWNr
IGNvbmZpZ3VyZWQgc3VjaCB0aGF0IHRoZSBndWVzdCBhbmQgaG9zdCB0aWNrcyBnZXQgc3luY2hy
b25pemVkCj5pbiBhIGJhZCB3YXkuCj4KPlRoaXMgaXMgYSBub24taXNzdWUgd2hlbiB1c2luZyBD
T05GSUdfVklSVF9DUFVfQUNDT1VOVElOR19HRU49eSwgYXQgbGVhc3Qgd2l0aCBhCj5zdGFibGUg
VFNDLCBhcyB0aGUgYWNjb3VudGluZyBoYXBwZW5zIGR1cmluZyBndWVzdF9leGl0X2lycW9mZigp
IGl0c2VsZi4KPkFjY291bnRpbmcgbWlnaHQgYmUgbGVzcy10aGFuLXN0ZWxsYXIgaWYgVFNDIGlz
IHVuc3RhYmxlLCBidXQgSSBkb24ndCB0aGluayBpdAo+d291bGQgYmUgYXMgYmluYXJ5IG9mIGEg
ZmFpbHVyZSBhcyB0aWNrLWJhc2VkIGFjY291bnRpbmcuIAoKSWYgSSBkb24ndCBzcGVjaWZ5ICJu
b2h6X2Z1bGwiIGluIGJvb3QgY29tbWFuZCBsaW5lIHdoZW4gdXNpbmcKQ09ORklHX1ZJUlRfQ1BV
X0FDQ09VTlRJTkdfR0VOPXksIFdpbGwgdGhlIHByb2JsZW0gc3RpbGwgZXhpc3Q/Cgo+Cj4+IEl0
IHNlZW1zIHRvIG1hdGNoIGhvdyB0aGUgYWNjb3VudGluZyBpcyBkb25lIG5vd2FkYXlzIGFmdGVy
IFRnbHgncwo+PiA4N2ZhN2YzZTk4YTEgKCJ4ODYva3ZtOiBNb3ZlIGNvbnRleHQgdHJhY2tpbmcg
d2hlcmUgaXQgYmVsb25ncyIpLgo+Pgo+PiA+IC0JKiBBbiBpbnN0cnVjdGlvbiBpcyByZXF1aXJl
ZCBhZnRlciBsb2NhbF9pcnFfZW5hYmxlKCkgdG8gZnVsbHkgdW5ibG9jawo+PiA+IC0JKiBpbnRl
cnJ1cHRzIG9uIHByb2Nlc3NvcnMgdGhhdCBpbXBsZW1lbnQgYW4gaW50ZXJydXB0IHNoYWRvdywg
dGhlCj4+ID4gLQkqIHN0YXQuZXhpdHMgaW5jcmVtZW50IHdpbGwgZG8gbmljZWx5Lgo+PiA+IC0J
Ki8KPj4gPiAtCWt2bV9iZWZvcmVfaW50ZXJydXB0KHZjcHUpOwo+PiA+IC0JbG9jYWxfaXJxX2Vu
YWJsZSgpOwo+PiA+wqAgKyt2Y3B1LT5zdGF0LmV4aXRzOwo+PiA+IC0JbG9jYWxfaXJxX2Rpc2Fi
bGUoKTsKPj4gPiAtCWt2bV9hZnRlcl9pbnRlcnJ1cHQodmNwdSk7Cj4+ID7CoAo+PiA+wqAgaWYg
KGxhcGljX2luX2tlcm5lbCh2Y3B1KSkgewo+PiA+wqAgczY0IGRlbHRhID0gdmNwdS0+YXJjaC5h
cGljLT5sYXBpY190aW1lci5hZHZhbmNlX2V4cGlyZV9kZWx0YTsKPj4KPj4gRldJVywKPj4KPj4g
UmV2aWV3ZWQtYnk6IFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+Cj4+Cj4+
IC0tCj4+IFZpdGFseQo+Pg==

