Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411181B760B
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgDXM4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:56:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57655 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXM4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587732990; x=1619268990;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Qxs340PmWks0jEFvLJMGJ0nyjbkPlu3QiKctkXepPFw=;
  b=OJa2sIlGxmtkThzIncp3kMDmMsAKk3H4TxNFGZgNLbAXBAW612RRwUj1
   IB1z+HU3fpFAjtdgDFkxCNbC6JbWJlo73UAvNytj0PwFISHWcdD8DBAWO
   WmkYxfKfRe0AGynMutmptFDB8A0SGM1j/39sNaBP8l7/QdPmDJfmCf7+g
   o=;
IronPort-SDR: vzkncK8W/65CGyV5dJhGf2u8FM2PJ2JCuZnuKDt5if66jXR9mAdFkmQnDdXpl1vtLWI5H+gKRv
 IN15VSCPke0w==
X-IronPort-AV: E=Sophos;i="5.73,311,1583193600"; 
   d="scan'208";a="40677794"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Apr 2020 12:56:29 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id EAA2FA23AA;
        Fri, 24 Apr 2020 12:56:27 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 12:56:27 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 12:56:23 +0000
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
Date:   Fri, 24 Apr 2020 14:56:21 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D40UWA003.ant.amazon.com (10.43.160.29) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIzLjA0LjIwIDIzOjE4LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IAo+IAo+IE9uIDIzLzA0
LzIwIDIyOjU2LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4+Cj4+PiBDUEwzIGlzIGhvdyB0aGUg
dXNlciBhcHBsaWNhdGlvbiBydW4sIGJ1dCBkb2VzIHRoZSBlbmNsYXZlJ3MgTGludXggYm9vdAo+
Pj4gcHJvY2VzcyBzdGFydCBpbiByZWFsIG1vZGUgYXQgdGhlIHJlc2V0IHZlY3RvciAoMHhmZmZm
ZmZmMCksIGluIDE2LWJpdAo+Pj4gcHJvdGVjdGVkIG1vZGUgYXQgdGhlIExpbnV4IGJ6SW1hZ2Ug
ZW50cnkgcG9pbnQsIG9yIGF0IHRoZSBFTEYgZW50cnkKPj4+IHBvaW50Pwo+Pgo+PiBUaGVyZSBp
cyBubyAiZW50cnkgcG9pbnQiIHBlciBzZS4gWW91IHByZXBvcHVsYXRlIGF0IHRhcmdldCBieklt
YWdlIGludG8KPj4gdGhlIGVuY2xhdmUgbWVtb3J5IG9uIGJvb3Qgd2hpY2ggdGhlbiBmb2xsb3dz
IHRoZSBzdGFuZGFyZCBib290Cj4+IHByb3RvY29sLiBFdmVyeXRoaW5nCj4gCj4gVGhlcmUncyBz
dGlsbCBhICJ3aGVyZSIgbWlzc2luZyBpbiB0aGF0IHNlbnRlbmNlLiA6KSAgSSBhc3N1bWUgeW91
IHB1dAo+IGl0IGF0IDB4MTAwMDAgKGFuZCBzbyB0aGUgZW50cnkgcG9pbnQgYXQgMHgxMDIwMCk/
ICBUaGF0IHNob3VsZCBiZQo+IGRvY3VtZW50ZWQgYmVjYXVzZSB0aGF0IGlzIGFic29sdXRlbHkg
bm90IHdoYXQgdGhlIEtWTSBBUEkgbG9va3MgbGlrZS4KClllcywgdGhhdCBwYXJ0IGlzIG5vdCBk
b2N1bWVudGVkIGluIHRoZSBwYXRjaCBzZXQsIGNvcnJlY3QuIEkgd291bGQgCnBlcnNvbmFsbHkg
anVzdCBtYWtlIGFuIGV4YW1wbGUgdXNlciBzcGFjZSBiaW5hcnkgdGhlIGRvY3VtZW50YXRpb24g
Zm9yIApub3cuIExhdGVyIHdlIHdpbGwgcHVibGlzaCBhIHByb3BlciBkZXZpY2Ugc3BlY2lmaWNh
dGlvbiBvdXRzaWRlIG9mIHRoZSAKTGludXggZWNvc3lzdGVtIHdoaWNoIHdpbGwgZGVzY3JpYmUg
dGhlIHJlZ2lzdGVyIGxheW91dCBhbmQgaW1hZ2UgCmxvYWRpbmcgc2VtYW50aWNzIGluIHZlcmJh
dGltLCBzbyB0aGF0IG90aGVyIE9TcyBjYW4gaW1wbGVtZW50IHRoZSAKZHJpdmVyIHRvby4KClRv
IGFuc3dlciB0aGUgcXVlc3Rpb24gdGhvdWdoLCB0aGUgdGFyZ2V0IGZpbGUgaXMgaW4gYSBuZXds
eSBpbnZlbnRlZCAKZmlsZSBmb3JtYXQgY2FsbGVkICJFSUYiIGFuZCBpdCBuZWVkcyB0byBiZSBs
b2FkZWQgYXQgb2Zmc2V0IDB4ODAwMDAwIG9mIAp0aGUgYWRkcmVzcyBzcGFjZSBkb25hdGVkIHRv
IHRoZSBlbmNsYXZlLgoKPiAKPj4gYmVmb3JlIHRoYXQgKGVuY2xhdmUgZmlybXdhcmUsIGV0Yy4p
IGlzIHByb3ZpZGVkIGJ5Cj4+IHRoZSBlbmNsYXZlIGVudmlyb25tZW50Lgo+Pgo+PiBUaGluayBv
ZiBpdCBsaWtlIGEgbWVjaGFuaXNtIHRvIGxhdW5jaCBhIHNlY29uZCBRRU1VIGluc3RhbmNlIG9u
IHRoZQo+PiBob3N0LCBidXQgYWxsIHlvdSBjYW4gYWN0dWFsbHkgY29udHJvbCBhcmUgdGhlIC1z
bXAsIC1tLCAta2VybmVsIGFuZAo+PiAtaW5pdHJkIHBhcmFtZXRlcnMuCj4gCj4gQXJlIHRoZXJl
IHJlcXVpcmVtZW50cyBvbiBob3cgdG8gcG9wdWxhdGUgdGhlIG1lbW9yeSB0byBlbnN1cmUgdGhh
dCB0aGUKPiBob3N0IGZpcm13YXJlIGRvZXNuJ3QgY3Jhc2ggYW5kIGJ1cm4/ICBFLmcuIHNvbWUg
ZnJlZSBtZW1vcnkgcmlnaHQgYmVsb3cKPiA0R2lCIChmb3IgdGhlIGZpcm13YXJlLCB0aGUgTEFQ
SUMvSU9BUElDIG9yIGFueSBvdGhlciBzcGVjaWFsIE1NSU8KPiBkZXZpY2VzIHlvdSBoYXZlLCBQ
Q0kgQkFScywgYW5kIHRoZSBsaWtlKT8KCk5vLCB0aGUgdGFyZ2V0IG1lbW9yeSBsYXlvdXQgaXMg
Y3VycmVudGx5IGRpc2Nvbm5lY3RlZCBmcm9tIHRoZSBtZW1vcnkgCmxheW91dCBkZWZpbmVkIHRo
cm91Z2ggdGhlIEtWTV9TRVRfVVNFUl9NRU1PUllfUkVHSU9OIGlvY3RsLiBXaGlsZSB3ZSBkbyAK
Y2hlY2sgdGhhdCBndWVzdF9waHlzX2FkZHIgaXMgY29udGlndW91cywgdGhlIHVuZGVybHlpbmcg
ZGV2aWNlIEFQSSBkb2VzIApub3QgaGF2ZSBhbnkgbm90aW9uIG9mIGEgImd1ZXN0IGFkZHJlc3Mi
IC0gYWxsIGl0IGdldHMgaXMgYSAKc2NhdHRlci1nYXRoZXIgc2xpY2VkIGJ1Y2tldCBvZiBtZW1v
cnkuCgo+PiBUaGUgb25seSBJL08gY2hhbm5lbCB5b3UgaGF2ZSBiZXR3ZWVuIHlvdXIgVk0gYW5k
Cj4+IHRoYXQgbmV3IFZNIGlzIGEgdnNvY2sgY2hhbm5lbCB3aGljaCBpcyBjb25maWd1cmVkIGJ5
IHRoZSBob3N0IG9uIHlvdXIKPj4gYmVoYWxmLgo+IAo+IElzIHRoaXMgdmlydGlvLW1taW8gb3Ig
dmlydGlvLXBjaSwgYW5kIHdoYXQgb3RoZXIgZW11bGF0ZWQgZGV2aWNlcyBhcmUKPiB0aGVyZSBh
bmQgaG93IGRvIHlvdSBkaXNjb3ZlciB0aGVtPyAgQXJlIHRoZXJlIGFueSBJU0EgZGV2aWNlcwo+
IChSVEMvUElDL1BJVCksIGFuZCBhcmUgdGhlcmUgU01CSU9TL1JTRFAvTVAgdGFibGVzIGluIHRo
ZSBGIHNlZ21lbnQ/CgpJdCBpcyB2aXJ0aW8tbW1pbyBmb3IgdGhlIGVuY2xhdmUgYW5kIHZpcnRp
by1wY2kgZm9yIHRoZSBwYXJlbnQuIFRoZSAKZW5jbGF2ZSBpcyBhIG1pY3Jvdm0uCgpGb3IgbW9y
ZSBkZXRhaWxzIG9uIHRoZSBlbmNsYXZlIGRldmljZSB0b3BvbG9neSwgd2UnbGwgaGF2ZSB0byB3
YWl0IGZvciAKdGhlIHB1YmxpYyBkb2N1bWVudGF0aW9uIHRoYXQgZGVzY3JpYmVzIHRoZSBlbmNs
YXZlIHZpZXcgb2YgdGhlIHdvcmxkIAp0aG91Z2guIEkgZG9uJ3QgdGhpbmsgdGhhdCBvbmUncyBw
dWJsaWMgcXVpdGUgeWV0LiBUaGlzIHBhdGNoIHNldCBpcyAKYWJvdXQgdGhlIHBhcmVudCdzIHZp
ZXcuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1
c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2No
bGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90
dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIz
NyA4NzkKCgo=

