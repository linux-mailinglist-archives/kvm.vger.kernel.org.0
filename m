Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3E369034
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 12:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhDWKTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 06:19:41 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30170 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhDWKTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 06:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619173144; x=1650709144;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=Fn/AQONFYscppT8pP5SXNjlW4Yl+3nKcn9equ7Kn0rk=;
  b=u7y5yGVP6dTEj5bLEyTqYg6kBjbmQchUbS7xjwaes77Erlm5TfaZNeHa
   4tIL14irvCP/W0QyDwd0nCvb46LpMG3eDnVbv070D0oq8hiMMDDGBIgCZ
   X6jHqQskyTiCf2zDfbOUsquf9qTXQpldXIWczbuaSeWSWYfuTryvndQcJ
   c=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="121026001"
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 23 Apr 2021 10:18:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 76977A1D0A;
        Fri, 23 Apr 2021 10:18:52 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 10:18:49 +0000
Received: from [10.95.82.45] (10.43.162.239) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 10:18:36 +0000
Message-ID: <67ff6513-5275-a94d-ae63-f2fc47769dfc@amazon.com>
Date:   Fri, 23 Apr 2021 12:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0)
 Gecko/20100101 Thunderbird/89.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Evgeny Iakovlev <eyakovl@amazon.de>, Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
 <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
 <ded8db53-0e58-654a-fff2-de536bcbc961@amazon.com>
 <45888d26-89d2-dba6-41cb-de2d58cd5345@redhat.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <45888d26-89d2-dba6-41cb-de2d58cd5345@redhat.com>
X-Originating-IP: [10.43.162.239]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wNC4yMSAxMjoxNSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBDQVVUSU9OOiBUaGlz
IGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5v
dCAKPiBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZp
cm0gdGhlIHNlbmRlciBhbmQgCj4ga25vdyB0aGVjb250ZW50IGlzIHNhZmUuCj4gCj4gCj4gCj4g
T24gMjMvMDQvMjEgMTE6NTgsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Pj4gSW4gdGhlb3J5IHVz
ZXJzcGFjZSBkb2Vzbid0IGtub3cgaG93IEtWTSB3aXNoZXMgdG8gaW1wbGVtZW50IHRoZQo+Pj4g
aHlwZXJjYWxsIHBhZ2UsIGVzcGVjaWFsbHkgaWYgWGVuIGh5cGVyY2FsbHMgYXJlIGVuYWJsZWQg
YXMgd2VsbC4KPj4KPj4gSSdtIG5vdCBzdXJlIEkgYWdyZWUgd2l0aCB0aGF0IHNlbnRpbWVudCA6
KS4gVXNlciBzcGFjZSBpcyB0aGUgb25lIHRoYXQKPj4gc2V0cyB0aGUgeGVuIGNvbXBhdCBtb2Rl
LiBBbGwgd2UgbmVlZCB0byBkbyBpcyBkZWNsYXJlIHRoZSBPUmluZyBhcyBwYXJ0Cj4+IG9mIHRo
ZSBLVk0gQUJJLiBXaGljaCB3ZSBlZmZlY3RpdmVseSBhcmUgZG9pbmcgYWxyZWFkeSwgYmVjYXVz
ZSBpdCdzCj4+IHBhcnQgb2YgdGhlIEFCSSB0byB0aGUgZ3Vlc3QsIG5vPwo+IAo+IEdvb2QgcG9p
bnQuwqAgQnV0IGl0IG1heSBjaGFuZ2UgaW4gdGhlIGZ1dHVyZSBiYXNlZCBvbiBLVk1fRU5BQkxF
X0NBUCBvcgo+IHdoYXRldmVyLCBhbmQgZHVwbGljYXRpbmcgY29kZSBiZXR3ZWVuIHVzZXJzcGFj
ZSBhbmQga2VybmVsIGlzIHVnbHkuwqAgV2UKPiBhbHJlYWR5IGhhdmUgdG9vIG1hbnkgdW53cml0
dGVuIGNvbnZlbnRpb25zIGFyb3VuZCBDUFVJRCwgTVNScywgZ2V0L3NldAo+IHN0YXRlIGlvY3Rs
cywgZXRjLgoKWWVzLCBJIGFncmVlLiBTbyB3ZSBjYW4ganVzdCBkZWNsYXJlIHRoYXQgdGhlcmUg
d29uJ3QgYmUgYW55IGNoYW5nZXMgdG8gCnRoZSBoY2FsbCBwYWdlIGluLWtlcm5lbCBoYW5kbGlu
ZyBjb2RlIGdvaW5nIGZvcndhcmQsIG5vPyA6KQoKSWYgeW91IHdhbnQgdG8gc3VwcG9ydCBhIG5l
dyBDQVAsIHN1cHBvcnQgYW4gYWN0dWFsIG92ZXJsYXkgcGFnZSBmaXJzdCAtIAphbmQgdGh1cyBh
Y3R1YWxseSByZXNwZWN0IHRoZSBUTEZTLgoKPiBUaGF0IHNhaWQsIHRoaXMgZGVmaW5pdGVseSB0
aWx0cyB0aGUgYmFsYW5jZSBhZ2FpbnN0IGFkZGluZyBhbiBpb2N0bCB0bwo+IHdyaXRlIHRoZSBo
eXBlcmNhbGwgcGFnZSBjb250ZW50cy7CoCBVc2Vyc3BhY2UgY2FuIGVpdGhlciB1c2UgdGhlCj4g
S1ZNX1NFVF9NU1Igb3IgYXNzZW1ibGUgaXQgb24gaXRzIG93biwgYW5kIG9uZSBvZiB0aGUgdHdv
IHNob3VsZCBiZSBva2F5LgoKU291bmRzIGdyZWF0LiBBbmQgaW4gdGhlIGZ1dHVyZSBpZiB3ZSBu
ZWVkIHRvIG1vdmUgdGhlIFhlbiBvZmZzZXQsIHdlIApzaG91bGQgcmF0aGVyIG1ha2UgdGhlIFhl
biBvZmZzZXR0aW5nIGEgcGFyYW1ldGVyIGZyb20gdXNlciBzcGFjZS4KCgpBbGV4CgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdl
aXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAx
NDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

