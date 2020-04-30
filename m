Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FFD1BF81D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD3MTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 08:19:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:55579 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgD3MTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 08:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588249154; x=1619785154;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FqHwryvgLS2NgWVBuzeKX/BTcH4tM09RlPs9SNV3JzI=;
  b=Wmw/kJfL6C6SLs3jUxhQi5KjdKCKVtUcNE0WRV5yiBqm4OHbRKo04CN/
   MgabzmYYM3uIG1oVqKDtG8DZ0LYOZNl6WsSsTMpwxCwAqF+MOnlRtp+8W
   NfPGcBzYIRdBgujvUdZsF7TQJTf7LMmT349+Fs8RWwFke7r803ZJNuorP
   0=;
IronPort-SDR: RA0AyilcDdCw1tnYARhcVG8Id/5ch/NAkIl7UeiRy32XFKG0h6SL0Saz13LGDdM6cMzjQ0wqon
 AYXRGP1WWADA==
X-IronPort-AV: E=Sophos;i="5.73,334,1583193600"; 
   d="scan'208";a="40433150"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 30 Apr 2020 12:19:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 74BA9A1DFE;
        Thu, 30 Apr 2020 12:19:10 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 12:19:07 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.90) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 12:19:03 +0000
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
 <d4091c63-6df6-8980-72c6-282cc553527e@amazon.com>
 <bed6e250-9de5-d719-623b-b72db78ebcb9@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <131ae410-58a5-63c9-14b5-0fe39ab69278@amazon.com>
Date:   Thu, 30 Apr 2020 14:19:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bed6e250-9de5-d719-623b-b72db78ebcb9@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D29UWC001.ant.amazon.com (10.43.162.143) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMC4wNC4yMCAxMzo1OCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAzMC8wNC8y
MCAxMzo0NywgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pgo+Pj4gU28gdGhlIGlzc3VlIHdvdWxk
IGJlIHRoYXQgYSBmaXJtd2FyZSBpbWFnZSBwcm92aWRlZCBieSB0aGUgcGFyZW50IGNvdWxkCj4+
PiBiZSB0YW1wZXJlZCB3aXRoIGJ5IHNvbWV0aGluZyBtYWxpY2lvdXMgcnVubmluZyBpbiB0aGUg
cGFyZW50IGVuY2xhdmU/Cj4+Cj4+IFlvdSBoYXZlIHRvIGhhdmUgYSByb290IG9mIHRydXN0IHNv
bWV3aGVyZS4gVGhhdCByb290IHRoZW4gY2hlY2tzIGFuZAo+PiBhdHRlc3RzIGV2ZXJ5dGhpbmcg
aXQgcnVucy4gV2hhdCBleGFjdGx5IHdvdWxkIHlvdSBhdHRlc3QgZm9yIHdpdGggYQo+PiBmbGF0
IGFkZHJlc3Mgc3BhY2UgbW9kZWw/Cj4+Cj4+IFNvIHRoZSBpc3N1ZSBpcyB0aGF0IHRoZSBlbmNs
YXZlIGNvZGUgY2FuIG5vdCB0cnVzdCBpdHMgb3duIGludGVncml0eSBpZgo+PiBpdCBkb2Vzbid0
IGhhdmUgYW55dGhpbmcgYXQgYSBoaWdoZXIgbGV2ZWwgYXR0ZXN0aW5nIGl0LiBUaGUgd2F5IHRo
aXMgaXMKPj4gdXN1YWxseSBzb2x2ZWQgb24gYmFyZSBtZXRhbCBzeXN0ZW1zIGlzIHRoYXQgeW91
IHRydXN0IHlvdXIgQ1BVIHdoaWNoCj4+IHRoZW4gY2hlY2tzIHRoZSBmaXJtd2FyZSBpbnRlZ3Jp
dHkgKEJvb3QgR3VhcmQpLiBXaGVyZSB3b3VsZCB5b3UgcHV0Cj4+IHRoYXQgY2hlY2sgaW4gYSBW
TSBtb2RlbD8KPiAKPiBJbiB0aGUgZW5jbGF2ZSBkZXZpY2UgZHJpdmVyLCBJIHdvdWxkIGp1c3Qg
bGltaXQgdGhlIGF0dGVzdGF0aW9uIHRvIHRoZQo+IGZpcm13YXJlIGltYWdlCj4gCj4gU28geWVh
aCBpdCB3b3VsZG4ndCBiZSBhIG1vZGUgd2hlcmUgbmVfbG9hZF9pbWFnZSBpcyBub3QgaW52b2tl
ZCBhbmQKPiB0aGUgZW5jbGF2ZSBzdGFydHMgaW4gcmVhbCBtb2RlIGF0IDB4ZmZmZmZmMC4gIFlv
dSB3b3VsZCBzdGlsbCBuZWVkCj4gImxvYWQgaW1hZ2UiIGZ1bmN0aW9uYWxpdHkuCj4gCj4+IEhv
dyBjbG9zZSB3b3VsZCBpdCBiZSB0byBhIG5vcm1hbCBWTSB0aGVuPyBBbmQKPj4gaWYgaXQncyBu
b3QsIHdoYXQncyB0aGUgcG9pbnQgb2Ygc3RpY2tpbmcgdG8gc3VjaCB0ZXJyaWJsZSBsZWdhY3kg
Ym9vdAo+PiBwYXRocz8KPiAKPiBUaGUgcG9pbnQgaXMgdGhhdCB0aGVyZSdzIGFscmVhZHkgdHdv
IHBsYXVzaWJsZSBsb2FkZXJzIGZvciB0aGUga2VybmVsCj4gKGJ6SW1hZ2UgYW5kIEVMRiksIHNv
IEknZCBsaWtlIHRvIGRlY291cGxlIHRoZSBsb2FkZXIgYW5kIHRoZSBpbWFnZS4KClRoZSBsb2Fk
ZXIgaXMgaW1wbGVtZW50ZWQgYnkgdGhlIGVuY2xhdmUgZGV2aWNlLiBJZiBpdCB3aXNoZXMgdG8g
c3VwcG9ydCAKYnpJbWFnZSBhbmQgRUxGIGl0IGRvZXMgdGhhdC4gVG9kYXksIGl0IG9ubHkgZG9l
cyBiekltYWdlIHRob3VnaCBJSVJDIDopLgoKU28geWVzLCB0aGV5IGFyZSBkZWNvdXBsZWQ/IEFy
ZSB5b3Ugc2F5aW5nIHlvdSB3b3VsZCBsaWtlIHRvIGJ1aWxkIHlvdXIgCm93biBjb2RlIGluIGFu
eSB3YXkgeW91IGxpa2U/IFdlbGwsIHRoYXQgbWVhbnMgd2UgZWl0aGVyIG5lZWQgdG8gYWRkIApz
dXBwb3J0IGZvciBhbm90aGVyIGxvYWRlciBpbiB0aGUgZW5jbGF2ZSBkZXZpY2Ugb3IgeW91ciB3
b3JrbG9hZHMganVzdCAKZmFrZXMgYSBiekltYWdlIGhlYWRlciBhbmQgZ2V0cyBsb2FkZWQgcmVn
YXJkbGVzcyA6KS4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlz
dGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

