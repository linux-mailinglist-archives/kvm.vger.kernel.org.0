Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F731B9F8D
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 11:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgD0JQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 05:16:27 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63468 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgD0JQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 05:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587978986; x=1619514986;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=lwBfPp01QpnUdn4rYMapglbVIlsaGzSUpEy+Zy9cY3k=;
  b=o0UZ98qOEyc8bPfkrwGwX8ldQqiNQLUxXn+c6sdKUmxLHEQAYgbq+zvf
   EwHx5mImxsaVyKc5W3cEp43DlNVkTCvoS72zjRVyxCiUS/OIsK94NGRd8
   a2GMw9/d77VbGBPQGHkdRqsDFam0Pjes/W4qWhGqaug8oRU7Mx+WFO1fi
   E=;
IronPort-SDR: WFlepa61gd2l1oxSOfHy+HsK7AoscM0YiRAnpi6uJe4uEZ8akQABPCHaoQQlG8sY8i00hgEXby
 eYoyymr3f3xQ==
X-IronPort-AV: E=Sophos;i="5.73,323,1583193600"; 
   d="scan'208";a="27524015"
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 27 Apr 2020 09:16:12 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id A6EFCA17CD;
        Mon, 27 Apr 2020 09:16:11 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 09:16:11 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.253) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 09:16:03 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <1c3f76ac-abf2-e5aa-1e70-55c6995b5901@amazon.com>
Date:   Mon, 27 Apr 2020 12:15:53 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNS8wNC8yMDIwIDE5OjA1LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IENBVVRJT046IFRo
aXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8g
bm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBjYW4gY29uZmly
bSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuCj4KPgo+Cj4gT24gMjQv
MDQvMjAgMjE6MTEsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBXaGF0IEkgd2FzIHNheWluZyBh
Ym92ZSBpcyB0aGF0IG1heWJlIGNvZGUgaXMgZWFzaWVyIHRvIHRyYW5zZmVyIHRoYXQKPj4gdGhh
biBhIC50eHQgZmlsZSB0aGF0IGdldHMgbG9zdCBzb21ld2hlcmUgaW4gdGhlIERvY3VtZW50YXRp
b24gZGlyZWN0b3J5Cj4+IDopLgo+IHdoeW5vdGJvdGguanBnIDpECgo6KSBBbHJpZ2h0LCBJIGFk
ZGVkIGl0IHRvIHRoZSBsaXN0LCBpbiBhZGRpdGlvbiB0byB0aGUgc2FtcGxlIHdlJ3ZlIGJlZW4g
CnRhbGtpbmcgYmVmb3JlLCB3aXRoIHRoZSBiYXNpYyBmbG93IG9mIHRoZSBpb2N0bCBpbnRlcmZh
Y2UgdXNhZ2UuCgo+Cj4+Pj4gVG8gYW5zd2VyIHRoZSBxdWVzdGlvbiB0aG91Z2gsIHRoZSB0YXJn
ZXQgZmlsZSBpcyBpbiBhIG5ld2x5IGludmVudGVkCj4+Pj4gZmlsZSBmb3JtYXQgY2FsbGVkICJF
SUYiIGFuZCBpdCBuZWVkcyB0byBiZSBsb2FkZWQgYXQgb2Zmc2V0IDB4ODAwMDAwIG9mCj4+Pj4g
dGhlIGFkZHJlc3Mgc3BhY2UgZG9uYXRlZCB0byB0aGUgZW5jbGF2ZS4KPj4+IFdoYXQgaXMgdGhp
cyBFSUY/Cj4+IEl0J3MganVzdCBhIHZlcnkgZHVtYiBjb250YWluZXIgZm9ybWF0IHRoYXQgaGFz
IGEgdHJpdmlhbCBoZWFkZXIsIGEKPj4gc2VjdGlvbiB3aXRoIHRoZSBiekltYWdlIGFuZCBvbmUg
dG8gbWFueSBzZWN0aW9ucyBvZiBpbml0cmFtZnMuCj4+Cj4+IEFzIG1lbnRpb25lZCBlYXJsaWVy
IGluIHRoaXMgdGhyZWFkLCBpdCByZWFsbHkgaXMganVzdCAiLWtlcm5lbCIgYW5kCj4+ICItaW5p
dHJkIiwgcGFja2VkIGludG8gYSBzaW5nbGUgYmluYXJ5IGZvciB0cmFuc21pc3Npb24gdG8gdGhl
IGhvc3QuCj4gT2theSwgZ290IGl0LiAgU28sIGNvcnJlY3QgbWUgaWYgdGhpcyBpcyB3cm9uZywg
dGhlIGluZm9ybWF0aW9uIHRoYXQgaXMKPiBuZWVkZWQgdG8gYm9vdCB0aGUgZW5jbGF2ZSBpczoK
Pgo+ICogdGhlIGtlcm5lbCwgaW4gYnpJbWFnZSBmb3JtYXQKPgo+ICogdGhlIGluaXRyZAo+Cj4g
KiBhIGNvbnNlY3V0aXZlIGFtb3VudCBvZiBtZW1vcnksIHRvIGJlIG1hcHBlZCB3aXRoCj4gS1ZN
X1NFVF9VU0VSX01FTU9SWV9SRUdJT04KClllcywgdGhlIGtlcm5lbCBiekltYWdlLCB0aGUga2Vy
bmVsIGNvbW1hbmQgbGluZSwgdGhlIHJhbWRpc2socykgYXJlIApwYXJ0IG9mIHRoZSBFbmNsYXZl
IEltYWdlIEZvcm1hdCAoRUlGKTsgcGx1cyBhbiBFSUYgaGVhZGVyIGluY2x1ZGluZyAKbWV0YWRh
dGEgc3VjaCBhcyBtYWdpYyBudW1iZXIsIGVpZiB2ZXJzaW9uLCBpbWFnZSBzaXplIGFuZCBDUkMu
Cgo+Cj4gT2ZmIGxpc3QsIEFsZXggYW5kIEkgZGlzY3Vzc2VkIGhhdmluZyBhIHN0cnVjdCB0aGF0
IHBvaW50cyB0byBrZXJuZWwgYW5kCj4gaW5pdHJkIG9mZiBlbmNsYXZlIG1lbW9yeSwgYW5kIGhh
dmUgdGhlIGRyaXZlciBidWlsZCBFSUYgYXQgdGhlCj4gYXBwcm9wcmlhdGUgcG9pbnQgaW4gZW5j
bGF2ZSBtZW1vcnkgKHRoZSA4IE1pQiBvZnNldCB0aGF0IHlvdSBtZW50aW9uZWQpLgo+Cj4gVGhp
cyBob3dldmVyIGhhcyB0d28gZGlzYWR2YW50YWdlczoKPgo+IDEpIGhhdmluZyB0aGUga2VybmVs
IGFuZCBpbml0cmQgbG9hZGVkIGJ5IHRoZSBwYXJlbnQgVk0gaW4gZW5jbGF2ZQo+IG1lbW9yeSBo
YXMgdGhlIGFkdmFudGFnZSB0aGF0IHlvdSBzYXZlIG1lbW9yeSBvdXRzaWRlIHRoZSBlbmNsYXZl
IG1lbW9yeQo+IGZvciBzb21ldGhpbmcgdGhhdCBpcyBvbmx5IG5lZWRlZCBpbnNpZGUgdGhlIGVu
Y2xhdmUKCkhlcmUgeW91IHdhbnRlZCB0byBzYXkgZGlzYWR2YW50YWdlPyA6KSBXcnQgc2F2aW5n
IG1lbW9yeSwgaXQncyBhYm91dCAKYWRkaXRpb25hbCBtZW1vcnkgZnJvbSB0aGUgcGFyZW50IC8g
cHJpbWFyeSBWTSBuZWVkZWQgZm9yIGhhbmRsaW5nIHRoZSAKZW5jbGF2ZSBpbWFnZSBzZWN0aW9u
cyAoc3VjaCBhcyB0aGUga2VybmVsLCByYW1kaXNrKSBhbmQgc2V0dGluZyB0aGUgRUlGIAphdCBh
IGNlcnRhaW4gb2Zmc2V0IGluIGVuY2xhdmUgbWVtb3J5PwoKPgo+IDIpIGl0IGlzIGxlc3MgZXh0
ZW5zaWJsZSAod2hhdCBpZiB5b3Ugd2FudCB0byB1c2UgUFZIIGluIHRoZSBmdXR1cmUgZm9yCj4g
ZXhhbXBsZSkgYW5kIHB1dHMgaW4gdGhlIGRyaXZlciBwb2xpY3kgdGhhdCBzaG91bGQgYmUgaW4g
dXNlcnNwYWNlLgo+Cj4KPiBTbyB3aHkgbm90IGp1c3Qgc3RhcnQgcnVubmluZyB0aGUgZW5jbGF2
ZSBhdCAweGZmZmZmZmYwIGluIHJlYWwgbW9kZT8KPiBZZXMgZXZlcnlib2R5IGhhdGVzIGl0LCBi
dXQgdGhhdCdzIHdoYXQgT1NlcyBhcmUgd3JpdHRlbiBhZ2FpbnN0LiAgSW4KPiB0aGUgc2ltcGxl
c3QgZXhhbXBsZSwgdGhlIHBhcmVudCBlbmNsYXZlIGNhbiBsb2FkIGJ6SW1hZ2UgYW5kIGluaXRy
ZCBhdAo+IDB4MTAwMDAgYW5kIHBsYWNlIGZpcm13YXJlIHRhYmxlcyAoTVBUYWJsZSBhbmQgRE1J
KSBzb21ld2hlcmUgYXQKPiAweGYwMDAwOyB0aGUgZmlybXdhcmUgd291bGQganVzdCBiZSBhIGZl
dyBtb3ZzIHRvIHNlZ21lbnQgcmVnaXN0ZXJzCj4gZm9sbG93ZWQgYnkgYSBsb25nIGptcC4KPgo+
IElmIHlvdSB3YW50IHRvIGtlZXAgRUlGLCB3ZSBtZWFzdXJlZCBpbiBRRU1VIHRoYXQgdGhlcmUg
aXMgbm8gbWVhc3VyYWJsZQo+IGRpZmZlcmVuY2UgYmV0d2VlbiBsb2FkaW5nIHRoZSBrZXJuZWwg
aW4gdGhlIGhvc3QgYW5kIGRvaW5nIGl0IGluIHRoZQo+IGd1ZXN0LCBzbyBBbWF6b24gY291bGQg
cHJvdmlkZSBhbiBFSUYgbG9hZGVyIHN0dWIgYXQgMHhmZmZmZmZmMCBmb3IKPiBiYWNrd2FyZHMg
Y29tcGF0aWJpbGl0eS4KClRoYW5rcyBmb3IgaW5mby4KCkFuZHJhCgo+Cj4+PiBBZ2FpbiwgSSBj
YW5ub3QgcHJvdmlkZSBhIHNlbnNpYmxlIHJldmlldyB3aXRob3V0IGV4cGxhaW5pbmcgaG93IHRv
IHVzZQo+Pj4gYWxsIHRoaXMuICBJIHVuZGVyc3RhbmQgdGhhdCBBbWF6b24gbmVlZHMgdG8gZG8g
cGFydCBvZiB0aGUgZGVzaWduCj4+PiBiZWhpbmQgY2xvc2VkIGRvb3JzLCBidXQgdGhpcyBzZWVt
cyB0byBoYXZlIHRoZSByZXN1bHRlZCBpbiBpc3N1ZXMgdGhhdAo+Pj4gcmVtaW5kcyBtZSBvZiBJ
bnRlbCdzIFNHWCBtaXNhZHZlbnR1cmVzLiBJZiBBbWF6b24gaGFzIGRlc2lnbmVkIE5FIGluIGEK
Pj4+IHdheSB0aGF0IGlzIGluY29tcGF0aWJsZSB3aXRoIG9wZW4gc3RhbmRhcmRzLCBpdCdzIHVw
IHRvIEFtYXpvbiB0byBmaXgKPj4gT2gsIGlmIHRoZXJlJ3MgYW55dGhpbmcgdGhhdCBjb25mbGlj
dHMgd2l0aCBvcGVuIHN0YW5kYXJkcyBoZXJlLCBJIHdvdWxkCj4+IGxvdmUgdG8gaGVhciBpdCBp
bW1lZGlhdGVseS4gSSBkbyBub3QgYmVsaWV2ZSBpbiBzZWN1cml0eSBieSBvYnNjdXJpdHkgIDop
Lgo+IFRoYXQncyBncmVhdCB0byBoZWFyIQo+Cj4gUGFvbG8KPgoKCgoKQW1hem9uIERldmVsb3Bt
ZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExh
emFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9t
YW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIx
LzIwMDUuCg==

