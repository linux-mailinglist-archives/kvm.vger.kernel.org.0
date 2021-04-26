Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4B36BB52
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 23:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhDZVmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 17:42:47 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30664 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhDZVmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 17:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619473326; x=1651009326;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=6wMQi3hPTyU7uHO5mf4w6uBJMxt+7jX0NytKW7NA7sc=;
  b=QjZAmwK+gSUaJqXiGDN3pC6Wk3whL8hyMJZ/AAe2T5aidw6jshC4L0+/
   W+TsZ7KU/naUkYLXi+TTtYqpMeAfMqnPRZq9Wn4zOyafmfDSmRCLQzxj8
   INSF3yVI3gRY6Y+Up8Us5A2DCifNDs1ZgRE7AHlpyk64ykubN4SSXi12Z
   I=;
X-IronPort-AV: E=Sophos;i="5.82,252,1613433600"; 
   d="scan'208";a="121715627"
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 26 Apr 2021 21:41:58 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 561FFA225F;
        Mon, 26 Apr 2021 21:41:56 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.102) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 26 Apr 2021 21:41:50 +0000
Date:   Mon, 26 Apr 2021 23:41:46 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Alexander Graf <graf@amazon.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210426213637.GA29911@u366d62d47e3651.ant.amazon.com>
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
 <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
 <ded8db53-0e58-654a-fff2-de536bcbc961@amazon.com>
 <45888d26-89d2-dba6-41cb-de2d58cd5345@redhat.com>
 <67ff6513-5275-a94d-ae63-f2fc47769dfc@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <67ff6513-5275-a94d-ae63-f2fc47769dfc@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCBBcHIgMjMsIDIwMjEgYXQgMTI6MTg6MzFQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYg
d3JvdGU6Cj4gT24gMjMuMDQuMjEgMTI6MTUsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gPiBPbiAy
My8wNC8yMSAxMTo1OCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4gPiA+ID4gSW4gdGhlb3J5IHVz
ZXJzcGFjZSBkb2Vzbid0IGtub3cgaG93IEtWTSB3aXNoZXMgdG8gaW1wbGVtZW50IHRoZQo+ID4g
PiA+IGh5cGVyY2FsbCBwYWdlLCBlc3BlY2lhbGx5IGlmIFhlbiBoeXBlcmNhbGxzIGFyZSBlbmFi
bGVkIGFzIHdlbGwuCj4gPiA+IAo+ID4gPiBJJ20gbm90IHN1cmUgSSBhZ3JlZSB3aXRoIHRoYXQg
c2VudGltZW50IDopLiBVc2VyIHNwYWNlIGlzIHRoZSBvbmUgdGhhdAo+ID4gPiBzZXRzIHRoZSB4
ZW4gY29tcGF0IG1vZGUuIEFsbCB3ZSBuZWVkIHRvIGRvIGlzIGRlY2xhcmUgdGhlIE9SaW5nIGFz
IHBhcnQKPiA+ID4gb2YgdGhlIEtWTSBBQkkuIFdoaWNoIHdlIGVmZmVjdGl2ZWx5IGFyZSBkb2lu
ZyBhbHJlYWR5LCBiZWNhdXNlIGl0J3MKPiA+ID4gcGFydCBvZiB0aGUgQUJJIHRvIHRoZSBndWVz
dCwgbm8/Cj4gPiAKPiA+IEdvb2QgcG9pbnQuwqAgQnV0IGl0IG1heSBjaGFuZ2UgaW4gdGhlIGZ1
dHVyZSBiYXNlZCBvbiBLVk1fRU5BQkxFX0NBUCBvcgo+ID4gd2hhdGV2ZXIsIGFuZCBkdXBsaWNh
dGluZyBjb2RlIGJldHdlZW4gdXNlcnNwYWNlIGFuZCBrZXJuZWwgaXMgdWdseS7CoCBXZQo+ID4g
YWxyZWFkeSBoYXZlIHRvbyBtYW55IHVud3JpdHRlbiBjb252ZW50aW9ucyBhcm91bmQgQ1BVSUQs
IE1TUnMsIGdldC9zZXQKPiA+IHN0YXRlIGlvY3RscywgZXRjLgo+IAo+IFllcywgSSBhZ3JlZS4g
U28gd2UgY2FuIGp1c3QgZGVjbGFyZSB0aGF0IHRoZXJlIHdvbid0IGJlIGFueSBjaGFuZ2VzIHRv
IHRoZQo+IGhjYWxsIHBhZ2UgaW4ta2VybmVsIGhhbmRsaW5nIGNvZGUgZ29pbmcgZm9yd2FyZCwg
bm8/IDopCj4gCj4gSWYgeW91IHdhbnQgdG8gc3VwcG9ydCBhIG5ldyBDQVAsIHN1cHBvcnQgYW4g
YWN0dWFsIG92ZXJsYXkgcGFnZSBmaXJzdCAtIGFuZAo+IHRodXMgYWN0dWFsbHkgcmVzcGVjdCB0
aGUgVExGUy4KPiAKPiA+IFRoYXQgc2FpZCwgdGhpcyBkZWZpbml0ZWx5IHRpbHRzIHRoZSBiYWxh
bmNlIGFnYWluc3QgYWRkaW5nIGFuIGlvY3RsIHRvCj4gPiB3cml0ZSB0aGUgaHlwZXJjYWxsIHBh
Z2UgY29udGVudHMuwqAgVXNlcnNwYWNlIGNhbiBlaXRoZXIgdXNlIHRoZQo+ID4gS1ZNX1NFVF9N
U1Igb3IgYXNzZW1ibGUgaXQgb24gaXRzIG93biwgYW5kIG9uZSBvZiB0aGUgdHdvIHNob3VsZCBi
ZSBva2F5Lgo+IAo+IFNvdW5kcyBncmVhdC4gQW5kIGluIHRoZSBmdXR1cmUgaWYgd2UgbmVlZCB0
byBtb3ZlIHRoZSBYZW4gb2Zmc2V0LCB3ZSBzaG91bGQKPiByYXRoZXIgbWFrZSB0aGUgWGVuIG9m
ZnNldHRpbmcgYSBwYXJhbWV0ZXIgZnJvbSB1c2VyIHNwYWNlLgoKT2theSwgYXNzZW1ibGluZyB0
aGUgaHlwZXJjYWxsIHBhZ2UgY29udGVudHMgaW4gdXNlciBzcGFjZSBpcyBwb3NzaWJsZQpidXQg
ZG9lc24ndCBoZWxwIHVzIG11Y2g6CiAgMS4gSXQgaXMgYmVzdCB0byBrZWVwIHRoZSBpbnN0cnVj
dGlvbiBwYXRjaGluZyBhdCBvbmUgcGxhY2U7IHRoZQogICAgIGtlcm5lbCBpcyBhbHJlYWR5IGRv
aW5nIGl0ICh3aGljaCB3ZSBjYW5ub3QgcmVtb3ZlKS4KICAyLiBJdCBpcyBub3QgcG9zc2libGUg
dG8gYXNzZW1ibGUgYWxsIG92ZXJsYXkgcGFnZXMgaW4gdXNlciBzcGFjZS4gRm9yCiAgICAgaW5z
dGFuY2UsIHdlIGNhbm5vdCBhc3NlbWJsZSB0aGUgVlAgYXNzaXN0IHBhZ2UuIFRoZSBoeXBlcmNh
bGwgY29kZQogICAgIHBhZ2UgaXMgcmVhbGx5IGEgc3BlY2lhbCBjYXNlLgoKU28gSSdkIHNpZGUg
d2l0aCB0aGUgS1ZNX1NFVF9NU1IgYXBwcm9hY2ggYW5kIGhhdmUgYSBjb252ZW50aW9uIHRoYXQg
YWxsCm92ZXJsYXkgcGFnZSByZXF1ZXN0cyB3b3VsZCBiZSB0cmFwcGVkIHRvIHVzZXIgc3BhY2Ug
Zmlyc3QgLSB3aGVyZSB0aGUKcGFnZSBnZXQgb3ZlcmxhaWQgLSBhbmQgdGhlbiB1c2VyIHNwYWNl
IGZvcndhcmRzIHRoZSBNU1Igd3JpdGUgdG8ga2VybmVsCnNvIGl0IGNhbiBkbyBhIGt2bV92Y3B1
X3dyaXRlX2d1ZXN0KCkgaWYgbmVlZGVkLiBJTU8sIHRoaXMgYWxsb3dzIGJlc3QKZmxleGliaWxp
dHkuCgp+IFNpZC4KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

