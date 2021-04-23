Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE3B368F4A
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhDWJY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:24:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:38107 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhDWJY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 05:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619169862; x=1650705862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MmetagU797mHfH+rqMJ7bdU2UjwXQjjYyjhXUU6aeSM=;
  b=jvKDcDXfY5JGPHahebd/r4LACHuHVTBrWuSIV6UKvHi1PhoeNEzqu4pO
   xgUwd7SydOjQCwY/4Pk4o9FHzBsdiLptdS+vHZg5E1tzioSsIRH9pQxvu
   EJzrMhkKBDhumrzfz2lv+qwPKpywzdbWWZceOjFfOC0cDXBvvQTgl0RyO
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="121015296"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 23 Apr 2021 09:24:14 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 0478A240A64;
        Fri, 23 Apr 2021 09:24:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 09:24:09 +0000
Received: from [10.95.82.45] (10.43.160.119) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 09:24:05 +0000
Message-ID: <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
Date:   Fri, 23 Apr 2021 11:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:88.0)
 Gecko/20100101 Thunderbird/88.0
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Content-Language: en-US
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC:     Evgeny Iakovlev <eyakovl@amazon.de>, Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210423090333.21910-1-sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20210423090333.21910-1-sidcha@amazon.de>
X-Originating-IP: [10.43.160.119]
X-ClientProxiedBy: EX13D17UWB001.ant.amazon.com (10.43.161.252) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wNC4yMSAxMTowMywgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IEh5
cGVyY2FsbCBjb2RlIHBhZ2UgaXMgc3BlY2lmaWVkIGluIHRoZSBIeXBlci1WIFRMRlMgdG8gYmUg
YW4gb3ZlcmxheQo+IHBhZ2UsIGllLiwgZ3Vlc3QgY2hvb3NlcyBhIEdQQSBhbmQgdGhlIGhvc3Qg
X3BsYWNlc18gYSBwYWdlIGF0IHRoYXQKPiBsb2NhdGlvbiwgbWFraW5nIGl0IHZpc2libGUgdG8g
dGhlIGd1ZXN0IGFuZCB0aGUgZXhpc3RpbmcgcGFnZSBiZWNvbWVzCj4gaW5hY2Nlc3NpYmxlLiBT
aW1pbGFybHkgd2hlbiBkaXNhYmxlZCwgdGhlIGhvc3Qgc2hvdWxkIF9yZW1vdmVfIHRoZQo+IG92
ZXJsYXkgYW5kIHRoZSBvbGQgcGFnZSBzaG91bGQgYmVjb21lIHZpc2libGUgdG8gdGhlIGd1ZXN0
Lgo+IAo+IEN1cnJlbnRseSBLVk0gZGlyZWN0bHkgcGF0Y2hlcyB0aGUgaHlwZXJjYWxsIGNvZGUg
aW50byB0aGUgZ3Vlc3QgY2hvc2VuCj4gR1BBLiBTaW5jZSB0aGUgZ3Vlc3Qgc2VsZG9tIG1vdmVz
IHRoZSBoeXBlcmNhbGwgY29kZSBwYWdlIGFyb3VuZCwgaXQKPiBkb2Vzbid0IHNlZSBhbnkgcHJv
YmxlbXMgZXZlbiB0aG91Z2ggd2UgYXJlIGNvcnJ1cHRpbmcgdGhlIGV4aXRpbmcgZGF0YQo+IGlu
IHRoYXQgR1BBLgo+IAo+IFZTTSBBUEkgaW50cm9kdWNlcyBtb3JlIGNvbXBsZXggb3ZlcmxheSB3
b3JrZmxvd3MgZHVyaW5nIFZUTCBzd2l0Y2hlcwo+IHdoZXJlIHRoZSBndWVzdCBzdGFydHMgdG8g
ZXhwZWN0IHRoYXQgdGhlIGV4aXN0aW5nIHBhZ2UgaXMgaW50YWN0LiBUaGlzCj4gbWVhbnMgd2Ug
bmVlZCBhIG1vcmUgZ2VuZXJpYyBhcHByb2FjaCB0byBoYW5kbGluZyBvdmVybGF5IHBhZ2VzOiBh
ZGQgYQo+IG5ldyBleGl0IHJlYXNvbiBLVk1fRVhJVF9IWVBFUlZfT1ZFUkxBWSB0aGF0IGV4aXRz
IHRvIHVzZXJzcGFjZSB3aXRoIHRoZQo+IGV4cGVjdGF0aW9uIHRoYXQgYSBwYWdlIGdldHMgb3Zl
cmxhaWQgdGhlcmUuCgpJIGNhbiBzZWUgaG93IHRoYXQgbWF5IGdldCBpbnRlcmVzdGluZyBmb3Ig
b3RoZXIgb3ZlcmxheSBwYWdlcyBsYXRlciwgCmJ1dCB0aGlzIG9uZSBpbiBwYXJ0aWN1bGFyIGlz
IGp1c3QgYW4gTVNSIHdyaXRlLCBubz8gSXMgdGhlcmUgYW55IHJlYXNvbiAKd2UgY2FuJ3QganVz
dCB1c2UgdGhlIHVzZXIgc3BhY2UgTVNSIGhhbmRsaW5nIGxvZ2ljIGluc3RlYWQ/CgpXaGF0J3Mg
bWlzc2luZyB0aGVuIGlzIGEgd2F5IHRvIHB1bGwgdGhlIGhjYWxsIHBhZ2UgY29udGVudHMgZnJv
bSBLVk0uIApCdXQgZXZlbiB0aGVyZSBJJ20gbm90IGNvbnZpbmNlZCB0aGF0IEtWTSBzaG91bGQg
YmUgdGhlIHJlZmVyZW5jZSBwb2ludCAKZm9yIGl0cyBjb250ZW50cy4gSXNuJ3QgdXNlciBzcGFj
ZSBpbiBhbiBhcyBnb29kIHBvc2l0aW9uIHRvIGFzc2VtYmxlIGl0PwoKPiAKPiBJbiB0aGUgaW50
ZXJlc3Qgb2YgbWFpbnRhaW5nIHVzZXJzcGFjZSBleHBvc2VkIGJlaGF2aW91ciwgYWRkIGEgbmV3
IEtWTQo+IGNhcGFiaWxpdHkgdG8gYWxsb3cgdGhlIFZNTXMgdG8gZW5hYmxlIHRoaXMgaWYgdGhl
eSBjYW4gaGFuZGxlIHRoZQo+IGh5cGVyY2FsbCBwYWdlIGluIHVzZXJzcGFjZS4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNoYUBhbWF6b24uZGU+Cj4g
Cj4gQ1I6IGh0dHBzOi8vY29kZS5hbWF6b24uY29tL3Jldmlld3MvQ1ItNDkwMTEzNzkKClBsZWFz
ZSByZW1vdmUgdGhpcyBsaW5lIGZyb20gdXBzdHJlYW0gc3VibWlzc2lvbnMgOikuCgo+IC0tLQo+
ICAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICA0ICsrKysKPiAgIGFyY2gveDg2
L2t2bS9oeXBlcnYuYyAgICAgICAgICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrLS0tCj4g
ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwgIDUgKysrKysKPiAgIGluY2x1ZGUv
dWFwaS9saW51eC9rdm0uaCAgICAgICAgfCAxMCArKysrKysrKysrCgpZb3UncmUgbW9kaWZ5aW5n
IC8gYWRkaW5nIGEgdXNlciBzcGFjZSBBUEkuIFBsZWFzZSBtYWtlIHN1cmUgdG8gdXBkYXRlIAp0
aGUgZG9jdW1lbnRhdGlvbiBpbiBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3Qgd2hlbiB5
b3UgZG8gdGhhdC4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlz
dGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

