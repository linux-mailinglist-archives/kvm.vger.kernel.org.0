Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45B1BF715
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD3LrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:47:24 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:49561 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgD3LrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 07:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588247244; x=1619783244;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Kuj1qenl77tWtVFDi2i82yFw2BFMgW8O9vcfQDZVnIo=;
  b=OWGSFRw6TR2uT0T3T/RTNFmpgw2T3yReNFdqSy4Vdj16XwuNoXXuZy1k
   jwUbuwmCerPGsHR/FEEGe4wdqUvNsGTqJs8ir2esbzdKg+Y0xQEEQou57
   JP2qjU3/5YK2eLQzUTBHzVgnAkDJY/gRC9s/kw2YtWlbuTBvB5CTWWDNd
   M=;
IronPort-SDR: /hJ8fJ3qWHwmtayJxhstjxtmWUrDzcxdjlEtgg3asP8CGGbbp9dTgqtjK8ZJhBXlTZAg7KFv3v
 3/r60mPpAG9A==
X-IronPort-AV: E=Sophos;i="5.73,334,1583193600"; 
   d="scan'208";a="40428135"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 30 Apr 2020 11:47:22 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 1A40E141641;
        Thu, 30 Apr 2020 11:47:20 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 11:47:19 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 11:47:15 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
 <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
 <0c919928-00ed-beda-e984-35f7b6ca42fb@redhat.com>
 <702b2eaa-e425-204e-e19d-649282bfe170@amazon.com>
 <d13f3c5c-33f5-375b-8582-fe37402777cb@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d4091c63-6df6-8980-72c6-282cc553527e@amazon.com>
Date:   Thu, 30 Apr 2020 13:47:13 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d13f3c5c-33f5-375b-8582-fe37402777cb@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D20UWA002.ant.amazon.com (10.43.160.176) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMC4wNC4yMCAxMzozOCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAzMC8wNC8y
MCAxMzoyMSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+PiBBbHNvLCB3b3VsZCB5b3UgY29uc2lk
ZXIgYSBtb2RlIHdoZXJlIG5lX2xvYWRfaW1hZ2UgaXMgbm90IGludm9rZWQgYW5kCj4+PiB0aGUg
ZW5jbGF2ZSBzdGFydHMgaW4gcmVhbCBtb2RlIGF0IDB4ZmZmZmZmMD8KPj4KPj4gQ29uc2lkZXIs
IHN1cmUuIEJ1dCBJIGRvbid0IHF1aXRlIHNlZSBhbnkgYmlnIGJlbmVmaXQganVzdCB5ZXQuIFRo
ZQo+PiBjdXJyZW50IGFic3RyYWN0aW9uIGxldmVsIGZvciB0aGUgYm9vdGVkIHBheWxvYWRzIGlz
IG11Y2ggaGlnaGVyLiBUaGF0Cj4+IGFsbG93cyB1cyB0byBzaW1wbGlmeSB0aGUgZGV2aWNlIG1v
ZGVsIGRyYW1hdGljYWxseTogVGhlcmUgaXMgbm8gbmVlZCB0bwo+PiBjcmVhdGUgYSB2aXJ0dWFs
IGZsYXNoIHJlZ2lvbiBmb3IgZXhhbXBsZS4KPiAKPiBJdCBkb2Vzbid0IGhhdmUgdG8gYmUgZmxh
c2gsIGl0IGNhbiBiZSBqdXN0IFJPTS4KPiAKPj4gSW4gYWRkaXRpb24sIGJ5IG1vdmluZyBmaXJt
d2FyZSBpbnRvIHRoZSB0cnVzdGVkIGJhc2UsIGZpcm13YXJlIGNhbgo+PiBleGVjdXRlIHZhbGlk
YXRpb24gb2YgdGhlIHRhcmdldCBpbWFnZS4gSWYgeW91IG1ha2UgaXQgYWxsIGZsYXQsIGhvdyBk
bwo+PiB5b3UgdmVyaWZ5IHdoZXRoZXIgd2hhdCB5b3UncmUgYm9vdGluZyBpcyB3aGF0IHlvdSB0
aGluayB5b3UncmUgYm9vdGluZz8KPiAKPiBTbyB0aGUgaXNzdWUgd291bGQgYmUgdGhhdCBhIGZp
cm13YXJlIGltYWdlIHByb3ZpZGVkIGJ5IHRoZSBwYXJlbnQgY291bGQKPiBiZSB0YW1wZXJlZCB3
aXRoIGJ5IHNvbWV0aGluZyBtYWxpY2lvdXMgcnVubmluZyBpbiB0aGUgcGFyZW50IGVuY2xhdmU/
CgpZb3UgaGF2ZSB0byBoYXZlIGEgcm9vdCBvZiB0cnVzdCBzb21ld2hlcmUuIFRoYXQgcm9vdCB0
aGVuIGNoZWNrcyBhbmQgCmF0dGVzdHMgZXZlcnl0aGluZyBpdCBydW5zLiBXaGF0IGV4YWN0bHkg
d291bGQgeW91IGF0dGVzdCBmb3Igd2l0aCBhIApmbGF0IGFkZHJlc3Mgc3BhY2UgbW9kZWw/CgpT
byB0aGUgaXNzdWUgaXMgdGhhdCB0aGUgZW5jbGF2ZSBjb2RlIGNhbiBub3QgdHJ1c3QgaXRzIG93
biBpbnRlZ3JpdHkgaWYgCml0IGRvZXNuJ3QgaGF2ZSBhbnl0aGluZyBhdCBhIGhpZ2hlciBsZXZl
bCBhdHRlc3RpbmcgaXQuIFRoZSB3YXkgdGhpcyBpcyAKdXN1YWxseSBzb2x2ZWQgb24gYmFyZSBt
ZXRhbCBzeXN0ZW1zIGlzIHRoYXQgeW91IHRydXN0IHlvdXIgQ1BVIHdoaWNoIAp0aGVuIGNoZWNr
cyB0aGUgZmlybXdhcmUgaW50ZWdyaXR5IChCb290IEd1YXJkKS4gV2hlcmUgd291bGQgeW91IHB1
dCAKdGhhdCBjaGVjayBpbiBhIFZNIG1vZGVsPyBIb3cgY2xvc2Ugd291bGQgaXQgYmUgdG8gYSBu
b3JtYWwgVk0gdGhlbj8gQW5kIAppZiBpdCdzIG5vdCwgd2hhdCdzIHRoZSBwb2ludCBvZiBzdGlj
a2luZyB0byBzdWNoIHRlcnJpYmxlIGxlZ2FjeSBib290IApwYXRocz8KCgpBbGV4CgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdl
aXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAx
NDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

