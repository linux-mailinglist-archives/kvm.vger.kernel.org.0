Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1E146C21
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAWO6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:58:38 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:59238 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgAWO6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579791513; x=1611327513;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nq+svuIGXSd+vhw1tWAVmiIPTckoDnh/eQCKSn1EKk4=;
  b=hKPcKPUBPHpAcRrIU1Z4xuqh7iC06bxhpim5/PFSn8w9Nu+zs+X/L3Xu
   DMRlOzT+7C1tw1gbEOeV73IY9iXHFsdW1buQVqhnUmv2I9mup8X+uZWbG
   KooldmZmWZuTjPiXBmUUflRJ1ma5U6Ki5qXPfp5aCPziyiil0qXUryMB8
   s=;
IronPort-SDR: VnZGdi+8iu8KpfjSAYG9NG4kA/RQAn1ld8wzetfSsSaPe+RYzLBFK10xnr0zqXPCLqBe463Mhg
 PlGb9fTJmfzg==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="13786162"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Jan 2020 14:58:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 588FAA1237;
        Thu, 23 Jan 2020 14:58:31 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:58:30 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.29) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:58:29 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Paolo Bonzini <pbonzini@redhat.com>, <milanpa@amazon.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
 <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
 <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <25821210-50c4-93f4-2daf-5b572f0bcf31@amazon.de>
Date:   Thu, 23 Jan 2020 15:58:27 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.29]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wMS4yMCAxNTo1MCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAyMy8wMS8yMCAx
NTo0NSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+IEkgdGhpbmsgd2UncmUgaW4gYWdyZWVtZW50
IHRoZW4sIGp1c3QgbGVhbmluZyBvbnRvIHRoZSBvdGhlciBzaWRlIG9mIHRoZQo+PiBzYW1lIGZl
bmNlLiBNeSB0YWtlIGlzIHRoYXQgaWYgSSBkb24ndCBrbm93IHdoZXRoZXIgYSBzdHJpbmcgaXMK
Pj4gbmVjZXNzYXJ5LCBJJ2QgcmF0aGVyIG5vdCBoYXZlIGEgc3RyaW5nIDopLgo+IAo+IEFuZCBm
b3IgbWUgaXQncyBpZiBJIGRvbid0IGtub3cgd2hldGhlciBhICNkZWZpbmUgaXMgbmVjZXNzYXJ5
LCBJJ2QKPiByYXRoZXIgbm90IGhhdmUgYSAjZGVmaW5lLiAgU28geWVhaCB3ZSBhZ3JlZSBvbiBl
dmVyeXRoaW5nIGV4Y2VwdCB0aGUKPiB1c2Vyc3BhY2UgQVBJICh3aGljaCBpcyBubyBzbWFsbCB0
aGluZywgYnV0IGl0J3MgYSBzdGFydCkuCj4gCj4+IEkgZ3Vlc3MgYXMgbG9uZyBhcyB3ZSBkbyBn
ZXQgc3RhdCBpbmZvcm1hdGlvbiBvdXQgcGVyLXZtIGFzIHdlbGwgYXMKPj4gcGVyLXZjcHUgdGhy
b3VnaCB2bWZkIGFuZCB2Y3B1ZmQsIEknbSBoYXBweSBvdmVyYWxsLgo+Pgo+PiBTbyBob3cgc3Ry
b25nbHkgZG8geW91IGZlZWwgYWJvdXQgdGhlIHN0cmluZyBiYXNlZCBhcHByb2FjaD8KPiAKPiBJ
IGxpa2UgaXQsIG9mIGNvdXJzZS4KPiAKPj4gUFM6IFlvdSBjb3VsZCBidHcgZWFzaWx5IGFkZCBh
ICJnaXZlIG1lIHRoZSBzdHJpbmcgZm9yIGEgT05FX1JFRyBpZCIKPj4gaW50ZXJmYWNlIGluIEtW
TSB0byB0cmFuc2xhdGUgZnJvbSAweDEwMDQyIHRvICJpbnNuX2VtdWxhdGlvbl9mYWlsIiA6KS4K
PiAKPiBUaGF0IGNvdWxkIGFjdHVhbGx5IGJlIHNvbWV3aGF0IHVzZWZ1bCBmb3IgVkNQVSByZWdp
c3RlcnMgYXMgd2VsbCAoZ2l2ZQo+IG1lIHRoZSBzdHJpbmcgYW5kIHR5cGUsIGFuZCBhIGxpc3Qg
b2YgdmFsaWQgT05FX1JFRyBpZHMpLiAgSWYgdGhhdCB3YXMKCllvdSBkb24ndCBuZWVkIHRoZSB0
eXBlIGV4cGxpY2l0bHksIGl0J3MgcGFydCBvZiB0aGUgT05FX1JFRyBpZGVudGlmaWVyIDopLgoK
PiB0aGUgY2FzZSwgb2YgY291cnNlIGl0IHdvdWxkIGJlIGZpbmUgZm9yIG1lIHRvIHVzZSBPTkVf
UkVHIG9uIGEgVk0uICBUaGUKPiBwYXJ0IHdoaWNoIEkgZG9uJ3QgbGlrZSBpcyBoYXZpbmcgdG8g
bWFrZSBhbGwgT05FX1JFRyBwYXJ0IG9mIHRoZQo+IHVzZXJzcGFjZSBBQkkvQVBJLgoKV2UgZG9u
J3QgaGF2ZSBhbGwgb2YgT05FX1JFRyBhcyBwYXJ0IG9mIHRoZSB1c2VyIHNwYWNlIEFCSSB0b2Rh
eS4gT24gCkJvb2szUyBQUEMgeW91IGNhbiBub3QgYWNjZXNzIEJvb2tFIE9ORV9SRUcgdmFyaWFi
bGVzIGZvciBvYnZpb3VzIApyZWFzb25zLiBOZWl0aGVyIGNhbiB5b3UgYWNjZXNzIEFSTSBPTkVf
UkVHcy4gTm90IGltcGxlbWVudGluZyBhIE9ORV9SRUcgCmlzIHBlcmZlY3RseSBvay4KCkJ1dCBJ
IGxpa2UgdGhlIGlkZWEgb2YgYSBPTkVfUkVHIHF1ZXJ5IGludGVyZmFjZSB0aGF0IGdpdmVzIHlv
dSB0aGUgbGlzdCAKb2YgYXZhaWxhYmxlIHJlZ2lzdGVycyBhbmQgYSBzdHJpbmcgcmVwcmVzZW50
YXRpb24gb2YgdGhlbS4gSXQgd291bGQgCm1ha2UgcHJvZ3JhbW1pbmcga3ZtIGZyb20gUHl0aG9u
IHNvIGVhc3khCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21i
SApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3Rp
YW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBD
aGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUg
Mjg5IDIzNyA4NzkKCgo=

