Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075411B9FC4
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgD0JWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 05:22:33 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:59724 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgD0JWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 05:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587979352; x=1619515352;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bgwzpt19OuODNBJcn8F+x3kZVJPkydMzu9EUD6e3kdE=;
  b=afCqQyst2M2LwKCX3ap4PDou2GdIinXvsGx6EXXfNo0yMqmBTQidvoq4
   lxGr61DJYL/oshpMkseSF1D+3Wa8S5rQoLo/dQ6UUM0YZN0am1c3HqrQW
   s1Nv8GX6uoNA9O2j9cOmheim0rsO6SQIX0cZgwSQnuPwnWjt6mwMUPU8/
   A=;
IronPort-SDR: BtXDW1FpqT77ino564PGnzwVtz6kMt16WLKzrIN/wVhPvf75ookRHU6NL2Mb6DlFXFmDh6Eg0Z
 dHfad5zsXIXg==
X-IronPort-AV: E=Sophos;i="5.73,323,1583193600"; 
   d="scan'208";a="31308681"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 27 Apr 2020 09:22:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 505A7A2675;
        Mon, 27 Apr 2020 09:22:29 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 09:22:28 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.203) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 09:22:21 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
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
Message-ID: <fe8940ff-9deb-1b2b-8f30-2ecfe26ce27b@amazon.com>
Date:   Mon, 27 Apr 2020 12:22:15 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13P01UWA004.ant.amazon.com (10.43.160.127) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNS8wNC8yMDIwIDE5OjA1LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+Cj4gT24gMjQvMDQv
MjAgMjE6MTEsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBXaGF0IEkgd2FzIHNheWluZyBhYm92
ZSBpcyB0aGF0IG1heWJlIGNvZGUgaXMgZWFzaWVyIHRvIHRyYW5zZmVyIHRoYXQKPj4gdGhhbiBh
IC50eHQgZmlsZSB0aGF0IGdldHMgbG9zdCBzb21ld2hlcmUgaW4gdGhlIERvY3VtZW50YXRpb24g
ZGlyZWN0b3J5Cj4+IDopLgo+IHdoeW5vdGJvdGguanBnIDpECgo6KSBBbHJpZ2h0LCBJIGFkZGVk
IGl0IHRvIHRoZSBsaXN0LCBpbiBhZGRpdGlvbiB0byB0aGUgc2FtcGxlIHdlJ3ZlIGJlZW4gCnRh
bGtpbmcgYmVmb3JlLCB3aXRoIHRoZSBiYXNpYyBmbG93IG9mIHRoZSBpb2N0bCBpbnRlcmZhY2Ug
dXNhZ2UuCgo+Cj4+Pj4gVG8gYW5zd2VyIHRoZSBxdWVzdGlvbiB0aG91Z2gsIHRoZSB0YXJnZXQg
ZmlsZSBpcyBpbiBhIG5ld2x5IGludmVudGVkCj4+Pj4gZmlsZSBmb3JtYXQgY2FsbGVkICJFSUYi
IGFuZCBpdCBuZWVkcyB0byBiZSBsb2FkZWQgYXQgb2Zmc2V0IDB4ODAwMDAwIG9mCj4+Pj4gdGhl
IGFkZHJlc3Mgc3BhY2UgZG9uYXRlZCB0byB0aGUgZW5jbGF2ZS4KPj4+IFdoYXQgaXMgdGhpcyBF
SUY/Cj4+IEl0J3MganVzdCBhIHZlcnkgZHVtYiBjb250YWluZXIgZm9ybWF0IHRoYXQgaGFzIGEg
dHJpdmlhbCBoZWFkZXIsIGEKPj4gc2VjdGlvbiB3aXRoIHRoZSBiekltYWdlIGFuZCBvbmUgdG8g
bWFueSBzZWN0aW9ucyBvZiBpbml0cmFtZnMuCj4+Cj4+IEFzIG1lbnRpb25lZCBlYXJsaWVyIGlu
IHRoaXMgdGhyZWFkLCBpdCByZWFsbHkgaXMganVzdCAiLWtlcm5lbCIgYW5kCj4+ICItaW5pdHJk
IiwgcGFja2VkIGludG8gYSBzaW5nbGUgYmluYXJ5IGZvciB0cmFuc21pc3Npb24gdG8gdGhlIGhv
c3QuCj4gT2theSwgZ290IGl0LiAgU28sIGNvcnJlY3QgbWUgaWYgdGhpcyBpcyB3cm9uZywgdGhl
IGluZm9ybWF0aW9uIHRoYXQgaXMKPiBuZWVkZWQgdG8gYm9vdCB0aGUgZW5jbGF2ZSBpczoKPgo+
ICogdGhlIGtlcm5lbCwgaW4gYnpJbWFnZSBmb3JtYXQKPgo+ICogdGhlIGluaXRyZAo+Cj4gKiBh
IGNvbnNlY3V0aXZlIGFtb3VudCBvZiBtZW1vcnksIHRvIGJlIG1hcHBlZCB3aXRoCj4gS1ZNX1NF
VF9VU0VSX01FTU9SWV9SRUdJT04KClllcywgdGhlIGtlcm5lbCBiekltYWdlLCB0aGUga2VybmVs
IGNvbW1hbmQgbGluZSwgdGhlIHJhbWRpc2socykgYXJlIApwYXJ0IG9mIHRoZSBFbmNsYXZlIElt
YWdlIEZvcm1hdCAoRUlGKTsgcGx1cyBhbiBFSUYgaGVhZGVyIGluY2x1ZGluZyAKbWV0YWRhdGEg
c3VjaCBhcyBtYWdpYyBudW1iZXIsIGVpZiB2ZXJzaW9uLCBpbWFnZSBzaXplIGFuZCBDUkMuCgo+
Cj4gT2ZmIGxpc3QsIEFsZXggYW5kIEkgZGlzY3Vzc2VkIGhhdmluZyBhIHN0cnVjdCB0aGF0IHBv
aW50cyB0byBrZXJuZWwgYW5kCj4gaW5pdHJkIG9mZiBlbmNsYXZlIG1lbW9yeSwgYW5kIGhhdmUg
dGhlIGRyaXZlciBidWlsZCBFSUYgYXQgdGhlCj4gYXBwcm9wcmlhdGUgcG9pbnQgaW4gZW5jbGF2
ZSBtZW1vcnkgKHRoZSA4IE1pQiBvZnNldCB0aGF0IHlvdSBtZW50aW9uZWQpLgo+Cj4gVGhpcyBo
b3dldmVyIGhhcyB0d28gZGlzYWR2YW50YWdlczoKPgo+IDEpIGhhdmluZyB0aGUga2VybmVsIGFu
ZCBpbml0cmQgbG9hZGVkIGJ5IHRoZSBwYXJlbnQgVk0gaW4gZW5jbGF2ZQo+IG1lbW9yeSBoYXMg
dGhlIGFkdmFudGFnZSB0aGF0IHlvdSBzYXZlIG1lbW9yeSBvdXRzaWRlIHRoZSBlbmNsYXZlIG1l
bW9yeQo+IGZvciBzb21ldGhpbmcgdGhhdCBpcyBvbmx5IG5lZWRlZCBpbnNpZGUgdGhlIGVuY2xh
dmUKCkhlcmUgeW91IHdhbnRlZCB0byBzYXkgZGlzYWR2YW50YWdlPyA6KVdydCBzYXZpbmcgbWVt
b3J5LCBpdCdzIGFib3V0IAphZGRpdGlvbmFsIG1lbW9yeSBmcm9tIHRoZSBwYXJlbnQgLyBwcmlt
YXJ5IFZNIG5lZWRlZCBmb3IgaGFuZGxpbmcgdGhlIAplbmNsYXZlIGltYWdlIHNlY3Rpb25zIChz
dWNoIGFzIHRoZSBrZXJuZWwsIHJhbWRpc2spIGFuZCBzZXR0aW5nIHRoZSBFSUYgCmF0IGEgY2Vy
dGFpbiBvZmZzZXQgaW4gZW5jbGF2ZSBtZW1vcnk/Cgo+Cj4gMikgaXQgaXMgbGVzcyBleHRlbnNp
YmxlICh3aGF0IGlmIHlvdSB3YW50IHRvIHVzZSBQVkggaW4gdGhlIGZ1dHVyZSBmb3IKPiBleGFt
cGxlKSBhbmQgcHV0cyBpbiB0aGUgZHJpdmVyIHBvbGljeSB0aGF0IHNob3VsZCBiZSBpbiB1c2Vy
c3BhY2UuCj4KPgo+IFNvIHdoeSBub3QganVzdCBzdGFydCBydW5uaW5nIHRoZSBlbmNsYXZlIGF0
IDB4ZmZmZmZmZjAgaW4gcmVhbCBtb2RlPwo+IFllcyBldmVyeWJvZHkgaGF0ZXMgaXQsIGJ1dCB0
aGF0J3Mgd2hhdCBPU2VzIGFyZSB3cml0dGVuIGFnYWluc3QuICBJbgo+IHRoZSBzaW1wbGVzdCBl
eGFtcGxlLCB0aGUgcGFyZW50IGVuY2xhdmUgY2FuIGxvYWQgYnpJbWFnZSBhbmQgaW5pdHJkIGF0
Cj4gMHgxMDAwMCBhbmQgcGxhY2UgZmlybXdhcmUgdGFibGVzIChNUFRhYmxlIGFuZCBETUkpIHNv
bWV3aGVyZSBhdAo+IDB4ZjAwMDA7IHRoZSBmaXJtd2FyZSB3b3VsZCBqdXN0IGJlIGEgZmV3IG1v
dnMgdG8gc2VnbWVudCByZWdpc3RlcnMKPiBmb2xsb3dlZCBieSBhIGxvbmcgam1wLgo+Cj4gSWYg
eW91IHdhbnQgdG8ga2VlcCBFSUYsIHdlIG1lYXN1cmVkIGluIFFFTVUgdGhhdCB0aGVyZSBpcyBu
byBtZWFzdXJhYmxlCj4gZGlmZmVyZW5jZSBiZXR3ZWVuIGxvYWRpbmcgdGhlIGtlcm5lbCBpbiB0
aGUgaG9zdCBhbmQgZG9pbmcgaXQgaW4gdGhlCj4gZ3Vlc3QsIHNvIEFtYXpvbiBjb3VsZCBwcm92
aWRlIGFuIEVJRiBsb2FkZXIgc3R1YiBhdCAweGZmZmZmZmYwIGZvcgo+IGJhY2t3YXJkcyBjb21w
YXRpYmlsaXR5LgoKVGhhbmtzIGZvciBpbmZvLgoKQW5kcmEKCj4KPj4+IEFnYWluLCBJIGNhbm5v
dCBwcm92aWRlIGEgc2Vuc2libGUgcmV2aWV3IHdpdGhvdXQgZXhwbGFpbmluZyBob3cgdG8gdXNl
Cj4+PiBhbGwgdGhpcy4gIEkgdW5kZXJzdGFuZCB0aGF0IEFtYXpvbiBuZWVkcyB0byBkbyBwYXJ0
IG9mIHRoZSBkZXNpZ24KPj4+IGJlaGluZCBjbG9zZWQgZG9vcnMsIGJ1dCB0aGlzIHNlZW1zIHRv
IGhhdmUgdGhlIHJlc3VsdGVkIGluIGlzc3VlcyB0aGF0Cj4+PiByZW1pbmRzIG1lIG9mIEludGVs
J3MgU0dYIG1pc2FkdmVudHVyZXMuIElmIEFtYXpvbiBoYXMgZGVzaWduZWQgTkUgaW4gYQo+Pj4g
d2F5IHRoYXQgaXMgaW5jb21wYXRpYmxlIHdpdGggb3BlbiBzdGFuZGFyZHMsIGl0J3MgdXAgdG8g
QW1hem9uIHRvIGZpeAo+PiBPaCwgaWYgdGhlcmUncyBhbnl0aGluZyB0aGF0IGNvbmZsaWN0cyB3
aXRoIG9wZW4gc3RhbmRhcmRzIGhlcmUsIEkgd291bGQKPj4gbG92ZSB0byBoZWFyIGl0IGltbWVk
aWF0ZWx5LiBJIGRvIG5vdCBiZWxpZXZlIGluIHNlY3VyaXR5IGJ5IG9ic2N1cml0eSAgOikuCj4g
VGhhdCdzIGdyZWF0IHRvIGhlYXIhCj4KPiBQYW9sbwo+CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

