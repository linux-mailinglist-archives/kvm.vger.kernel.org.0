Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6F24C788
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 00:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgHTWEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 18:04:16 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:1983 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHTWEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 18:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597961055; x=1629497055;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pw24Zr42cZmLKRsD+2aFYQavUtybjHRIEYdQYd41bB0=;
  b=HoiFzrfUefLQbChK5uh/OrBvHhVA460iRsklum7x0DdKMvlUbXSH1iu2
   rB68RLMFwayazwDBFy5QQJs9pEeSNVmt/KHC/mZp9e0is7NC56GzOPA8/
   C9ZsmvTCPsOco7lXLvo8JkoZNegsi25WgfPEDmTSxCA9WLIMZ0WIJtjD9
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,334,1592870400"; 
   d="scan'208";a="48915141"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 Aug 2020 22:04:14 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 2CA9BA2014;
        Thu, 20 Aug 2020 22:04:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 22:04:12 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 22:04:11 +0000
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Aaron Lewis <aaronlewis@google.com>
CC:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com>
 <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
 <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com>
Date:   Fri, 21 Aug 2020 00:04:09 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D19UWA001.ant.amazon.com (10.43.160.169) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4wOC4yMCAwMjoxOCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gT24gV2VkLCBBdWcg
MTksIDIwMjAgYXQgODoyNiBBTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90
ZToKPj4KPj4KPj4KPj4gT24gMTguMDguMjAgMjM6MTUsIEFhcm9uIExld2lzIHdyb3RlOgo+Pj4K
Pj4+IFNETSB2b2x1bWUgMzogMjQuNi45ICJNU1ItQml0bWFwIEFkZHJlc3MiIGFuZCBBUE0gdm9s
dW1lIDI6IDE1LjExICJNUwo+Pj4gaW50ZXJjZXB0cyIgZGVzY3JpYmUgTVNSIHBlcm1pc3Npb24g
Yml0bWFwcy4gIFBlcm1pc3Npb24gYml0bWFwcyBhcmUKPj4+IHVzZWQgdG8gY29udHJvbCB3aGV0
aGVyIGFuIGV4ZWN1dGlvbiBvZiByZG1zciBvciB3cm1zciB3aWxsIGNhdXNlIGEKPj4+IHZtIGV4
aXQuICBGb3IgdXNlcnNwYWNlIHRyYWNrZWQgTVNScyBpdCBpcyByZXF1aXJlZCB0aGV5IGNhdXNl
IGEgdm0KPj4+IGV4aXQsIHNvIHRoZSBob3N0IGlzIGFibGUgdG8gZm9yd2FyZCB0aGUgTVNSIHRv
IHVzZXJzcGFjZS4gIFRoaXMgY2hhbmdlCj4+PiBhZGRzIHZteC9zdm0gc3VwcG9ydCB0byBlbnN1
cmUgdGhlIHBlcm1pc3Npb24gYml0bWFwIGlzIHByb3Blcmx5IHNldCB0bwo+Pj4gY2F1c2UgYSB2
bV9leGl0IHRvIHRoZSBob3N0IHdoZW4gcmRtc3Igb3Igd3Jtc3IgaXMgdXNlZCBieSBvbmUgb2Yg
dGhlCj4+PiB1c2Vyc3BhY2UgdHJhY2tlZCBNU1JzLiAgQWxzbywgdG8gYXZvaWQgcmVwZWF0ZWRs
eSBzZXR0aW5nIHRoZW0sCj4+PiBrdm1fbWFrZV9yZXF1ZXN0KCkgaXMgdXNlZCB0byBjb2FsZXNj
ZSB0aGVzZSBpbnRvIGEgc2luZ2xlIGNhbGwuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogQWFyb24g
TGV3aXMgPGFhcm9ubGV3aXNAZ29vZ2xlLmNvbT4KPj4+IFJldmlld2VkLWJ5OiBPbGl2ZXIgVXB0
b24gPG91cHRvbkBnb29nbGUuY29tPgo+Pgo+PiBUaGlzIGlzIGluY29tcGxldGUsIGFzIGl0IGRv
ZXNuJ3QgY292ZXIgYWxsIG9mIHRoZSB4MmFwaWMgcmVnaXN0ZXJzLgo+PiBUaGVyZSBhcmUgYWxz
byBhIGZldyBNU1JzIHRoYXQgSUlSQyBhcmUgaGFuZGxlZCBkaWZmZXJlbnRseSBmcm9tIHRoaXMK
Pj4gbG9naWMsIHN1Y2ggYXMgRUZFUi4KPj4KPj4gSSdtIHJlYWxseSBjdXJpb3VzIGlmIHRoaXMg
aXMgd29ydGggdGhlIGVmZm9ydD8gSSB3b3VsZCBiZSBpbmNsaW5lZCB0bwo+PiBzYXkgdGhhdCBN
U1JzIHRoYXQgS1ZNIGhhcyBkaXJlY3QgYWNjZXNzIGZvciBuZWVkIHNwZWNpYWwgaGFuZGxpbmcg
b25lCj4+IHdheSBvciBhbm90aGVyLgo+Pgo+IAo+IENhbiB5b3UgcGxlYXNlIGVsYWJvcmF0ZSBv
biB0aGlzPyAgSXQgd2FzIG15IHVuZGVyc3RhbmRpbmcgdGhhdCB0aGUKPiBwZXJtaXNzaW9uIGJp
dG1hcCBjb3ZlcnMgdGhlIHgyYXBpYyByZWdpc3RlcnMuICBBbHNvLCBJ4oCZbSBub3Qgc3VyZSBo
b3cKClNvIHgyYXBpYyBNU1IgcGFzc3Rocm91Z2ggaXMgY29uZmlndXJlZCBzcGVjaWFsbHk6Cgog
Cmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRz
L2xpbnV4LmdpdC90cmVlL2FyY2gveDg2L2t2bS92bXgvdm14LmMjbjM3OTYKCmFuZCBJIHRoaW5r
IG5vdCBoYW5kbGVkIGJ5IHRoaXMgcGF0Y2g/Cgo+IEVGRVIgaXMgaGFuZGxlZCBkaWZmZXJlbnRs
eSwgYnV0IEkgc2VlIHRoZXJlIGlzIGEgc2VwYXJhdGUKPiBjb252ZXJzYXRpb24gb24gdGhhdC4K
CkVGRVIgaXMgYSByZWFsbHkgc3BlY2lhbCBiZWFzdCBpbiBWVC4KCj4gVGhpcyBlZmZvcnQgZG9l
cyBzZWVtIHdvcnRod2hpbGUgYXMgaXQgZW5zdXJlcyB1c2Vyc3BhY2UgaXMgYWJsZSB0bwo+IG1h
bmFnZSB0aGUgTVNScyBpdCBpcyByZXF1ZXN0aW5nLCBhbmQgd2lsbCByZW1haW4gdGhhdCB3YXkg
aW4gdGhlCj4gZnV0dXJlLgoKSSBjb3VsZG4ndCBzZWUgd2h5IGFueSBvZiB0aGUgcGFzc3Rocm91
Z2ggTVNScyBhcmUgcmVsZXZhbnQgdG8gdXNlciAKc3BhY2UsIGJ1dCBJIHRlbmQgdG8gYWdyZWUg
dGhhdCBpdCBtYWtlcyBldmVyeXRoaW5nIG1vcmUgY29uc2lzdGVudC4KCgpBbGV4CgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdl
aXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAx
NDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

