Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58182146EB3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 17:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAWQzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 11:55:31 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57621 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgAWQzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 11:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579798530; x=1611334530;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mdM50JhuE89n4g3vElfEZYKWgxShNtcICnTpm8dSINE=;
  b=dRbH+Z4DF8DslCf7wJ9xLuyIdT9NcZaLfWgtNYu4+jwpqGQPYyOmrQWF
   sqfvhLRmrfN9Q9owtvIaK3lcBlTkfLY+2sB1RNxLP5sZJFibldiGtzr2j
   UnvV/vylrpeKZtNaIoRXTPldYwTiLHPboq/6XS8Bodyk/AFIn7JWeDxCQ
   Q=;
IronPort-SDR: SLCpVvXbRwcr5o+gS8iV+L24OSauaZCgRuuGr8zRYDFBu0tEQzPVcKxVA5vPKgnveYbs03Y/w4
 PGw12I1RLZRg==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="21995785"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jan 2020 16:55:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id F0230A2AE9;
        Thu, 23 Jan 2020 16:55:08 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 16:55:07 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.78) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 16:55:01 +0000
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <linux-kernel@vger.kernel.org>, <willy@infradead.org>,
        <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <mgorman@techsingularity.net>,
        <vbabka@suse.cz>
CC:     <yang.zhang.wz@gmail.com>, <nitesh@redhat.com>,
        <konrad.wilk@oracle.com>, <david@redhat.com>, <pagupta@redhat.com>,
        <riel@surriel.com>, <lcapitulino@redhat.com>,
        <dave.hansen@intel.com>, <wei.w.wang@intel.com>,
        <aarcange@redhat.com>, <pbonzini@redhat.com>,
        <dan.j.williams@intel.com>, <osalvador@suse.de>,
        "Paterson-Jones, Roland" <rolandp@amazon.com>,
        <hannes@cmpxchg.org>, <hare@suse.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
 <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <ad73c0c8-3a9c-8ffd-9a31-7e9a5cd5f246@amazon.com>
Date:   Thu, 23 Jan 2020 17:54:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.78]
X-ClientProxiedBy: EX13D28UWB004.ant.amazon.com (10.43.161.56) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wMS4yMCAxNzoyNiwgQWxleGFuZGVyIER1eWNrIHdyb3RlOgo+IE9uIFRodSwgMjAy
MC0wMS0yMyBhdCAxMToyMCArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+IEhpIEFsZXgs
Cj4+Cj4+IE9uIDIyLjAxLjIwIDE4OjQzLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6ClsuLi5dCj4+
PiBUaGUgb3ZlcmFsbCBndWVzdCBzaXplIGlzIGtlcHQgZmFpcmx5IHNtYWxsIHRvIG9ubHkgYSBm
ZXcgR0Igd2hpbGUgdGhlIHRlc3QKPj4+IGlzIHJ1bm5pbmcuIElmIHRoZSBob3N0IG1lbW9yeSB3
ZXJlIG92ZXJzdWJzY3JpYmVkIHRoaXMgcGF0Y2ggc2V0IHNob3VsZAo+Pj4gcmVzdWx0IGluIGEg
cGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgYXMgc3dhcHBpbmcgbWVtb3J5IGluIHRoZSBob3N0IGNh
biBiZQo+Pj4gYXZvaWRlZC4KPj4KPj4gSSByZWFsbHkgbGlrZSB0aGUgYXBwcm9hY2ggb3ZlcmFs
bC4gVm9sdW50YXJpbHkgcHJvcGFnYXRpbmcgZnJlZSBtZW1vcnkKPj4gZnJvbSBhIGd1ZXN0IHRv
IHRoZSBob3N0IGhhcyBiZWVuIGEgc29yZSBwb2ludCBldmVyIHNpbmNlIEtWTSB3YXMKPj4gYXJv
dW5kLiBUaGlzIHNvbHV0aW9uIGxvb2tzIGxpa2UgYSB2ZXJ5IGVsZWdhbnQgd2F5IHRvIGRvIHNv
Lgo+Pgo+PiBUaGUgYmlnIHBpZWNlIEknbSBtaXNzaW5nIGlzIHRoZSBwYWdlIGNhY2hlLiBMaW51
eCB3aWxsIGJ5IGRlZmF1bHQgdHJ5Cj4+IHRvIGtlZXAgdGhlIGZyZWUgbGlzdCBhcyBzbWFsbCBh
cyBpdCBjYW4gaW4gZmF2b3Igb2YgcGFnZSBjYWNoZSwgc28gbW9zdAo+PiBvZiB0aGUgYmVuZWZp
dCBvZiB0aGlzIHBhdGNoIHNldCB3aWxsIGJlIHZvaWQgaW4gcmVhbCB3b3JsZCBzY2VuYXJpb3Mu
Cj4gCj4gQWdyZWVkLiBUaGlzIGlzIGEgdGhlIG5leHQgcGllY2Ugb2YgdGhpcyBJIHBsYW4gdG8g
d29yayBvbiBvbmNlIHRoaXMgaXMKPiBhY2NlcHRlZC4gRm9yIG5vdyB0aGUgcXVpY2sgYW5kIGRp
cnR5IGFwcHJvYWNoIGlzIHRvIGVzc2VudGlhbGx5IG1ha2UgdXNlCj4gb2YgdGhlIC9wcm9jL3N5
cy92bS9kcm9wX2NhY2hlcyBpbnRlcmZhY2UgaW4gdGhlIGd1ZXN0IGJ5IGVpdGhlciBwdXR0aW5n
Cj4gaXQgaW4gYSBjcm9uam9iIHNvbWV3aGVyZSBvciB0byBoYXZlIGl0IGFmdGVyIG1lbW9yeSBp
bnRlbnNpdmUgd29ya2xvYWRzLgo+IAo+PiBUcmFkaXRpb25hbGx5LCB0aGlzIHdhcyBzb2x2ZWQg
YnkgY3JlYXRpbmcgcHJlc3N1cmUgZnJvbSB0aGUgaG9zdAo+PiB0aHJvdWdoIHZpcnRpby1iYWxs
b29uOiBFeGFjdGx5IHRoZSBwaWVjZSB0aGF0IHRoaXMgcGF0Y2ggc2V0IGdldHMgYXdheQo+PiB3
aXRoLiBJIG5ldmVyIGxpa2VkICJiYWxsb29uaW5nIiwgYmVjYXVzZSB0aGUgaG9zdCBoYXMgdmVy
eSBsaW1pdGVkCj4+IHZpc2liaWxpdHkgaW50byB0aGUgYWN0dWFsIG1lbW9yeSB1dGlsaXR5IG9m
IGl0cyBndWVzdHMuIFNvIGxlYXZpbmcgdGhlCj4+IGRlY2lzaW9uIG9uIGhvdyBtdWNoIG1lbW9y
eSBpcyBhY3R1YWxseSBuZWVkZWQgYXQgYSBnaXZlbiBwb2ludCBpbiB0aW1lCj4+IHNob3VsZCBp
ZGVhbGx5IHN0YXkgd2l0aCB0aGUgZ3Vlc3QuCj4+Cj4+IFdoYXQgd291bGQga2VlcCB1cyBmcm9t
IGFwcGx5aW5nIHRoZSBwYWdlIGhpbnRpbmcgYXBwcm9hY2ggdG8gaW5hY3RpdmUsCj4+IGNsZWFu
IHBhZ2UgY2FjaGUgcGFnZXM/IFdpdGggd3JpdGViYWNrIGluIHBsYWNlIGFzIHdlbGwsIHdlIHdv
dWxkIHNsb3dseQo+PiBwcm9wYWdhdGUgcGFnZXMgZnJvbQo+Pgo+PiAgICAgZGlydHkgLT4gY2xl
YW4gLT4gY2xlYW4sIGluYWN0aXZlIC0+IGZyZWUgLT4gaG9zdCBvd25lZAo+Pgo+PiB3aGljaCBn
aXZlcyBhIGd1ZXN0IGEgbmF0dXJhbCBwYXRoIHRvIGdpdmUgdXAgIm5vdCBpbXBvcnRhbnQiIG1l
bW9yeS4KPiAKPiBJIGNvbnNpZGVyZWQgc29tZXRoaW5nIHNpbWlsYXIuIEJhc2ljYWxseSBvbmUg
dGhvdWdodCBJIGhhZCB3YXMgdG8KPiBlc3NlbnRpYWxseSBsb29rIGF0IHB1dHRpbmcgdG9nZXRo
ZXIgc29tZSBzb3J0IG9mIGVwb2NoLiBXaGVuIHRoZSBob3N0IGlzCj4gdW5kZXIgbWVtb3J5IHBy
ZXNzdXJlIGl0IHdvdWxkIG5lZWQgdG8gc29tZWhvdyBub3RpZnkgdGhlIGd1ZXN0IGFuZCB0aGVu
Cj4gdGhlIGd1ZXN0IHdvdWxkIHN0YXJ0IG1vdmluZyB0aGUgZXBvY2ggZm9yd2FyZCBzbyB0aGF0
IHdlIHN0YXJ0IGV2aWN0aW5nCj4gcGFnZXMgb3V0IG9mIHRoZSBwYWdlIGNhY2hlIHdoZW4gdGhl
IGhvc3QgaXMgdW5kZXIgbWVtb3J5IHByZXNzdXJlLgoKSSB0aGluayB3ZSB3YW50IHRvIGNvbnNp
ZGVyIGFuIGludGVyZmFjZSBpbiB3aGljaCB0aGUgaG9zdCBhY3RpdmVseSBhc2tzIApndWVzdHMg
dG8gcHVyZ2UgcGFnZXMgdG8gYmUgb24gdGhlIHNhbWUgbGluZSBhcyBzd2FwcGluZzogVGhlIGxh
c3QgbGluZSAKb2YgZGVmZW5zZS4KCkluIHRoZSBub3JtYWwgbW9kZSBvZiBvcGVyYXRpb24sIHlv
dSBzdGlsbCB3YW50IHRvIHNocmluayBkb3duIAp2b2x1bnRhcmlseSwgc28gdGhhdCBldmVyeW9u
ZSBjb29wZXJhdGl2ZWx5IHRyaWVzIHRvIG1ha2UgZnJlZSBmb3IgbmV3IApndWVzdHMgeW91IGNv
dWxkIHBvdGVudGlhbGx5IHJ1biBvbiB0aGUgc2FtZSBob3N0LgoKSWYgeW91IHN0YXJ0IHRvIGFw
cGx5IHByZXNzdXJlIHRvIGd1ZXN0cyB0byBmaW5kIG91dCBvZiB0aGV5IG1pZ2h0IGhhdmUgCnNv
bWUgcGFnZXMgdG8gc3BhcmUsIHdlJ3JlIGFsbW9zdCBiYWNrIHRvIHRoZSBvbGQgc3R5bGUgYmFs
bG9vbmluZyBhcHByb2FjaC4KCkJ0dywgaGF2ZSB5b3UgZXZlciBsb29rZWQgYXQgQ01NMiBbMV0/
IFdpdGggdGhhdCwgdGhlIGhvc3QgY2FuIAplc3NlbnRpYWxseSBqdXN0ICJzdGVhbCIgcGFnZXMg
ZnJvbSB0aGUgZ3Vlc3Qgd2hlbiBpdCBuZWVkcyBhbnksIHdpdGhvdXQgCnRoZSBuZWVkIHRvIGV4
ZWN1dGUgdGhlIGd1ZXN0IG1lYW53aGlsZS4gVGhhdCBtZWFucyBpbnNpZGUgdGhlIGhvc3QgCnN3
YXBwaW5nIHBhdGgsIENNTTIgY2FuIGp1c3QgZXZpY3QgZ3Vlc3QgcGFnZSBjYWNoZSBwYWdlcyBh
cyBlYXNpbHkgYXMgCndlIGV2aWN0IGhvc3QgcGFnZSBjYWNoZSBwYWdlcy4gVG8gbWUsIHRoYXQn
cyBldmVuIG1vcmUgYXR0cmFjdGl2ZSBpbiAKdGhlIHN3YXAgLyBlbWVyZ2VuY3kgY2FzZSB0aGFu
IGFuIGludGVyZmFjZSB3aGljaCByZXF1aXJlcyB0aGUgZ3Vlc3QgdG8gCnByb2FjdGl2ZWx5IGV4
ZWN1dGUgd2hpbGUgd2UgYXJlIGluIGEgbG93IG1lbSBzaXR1YXRpb24uCgo+PiBUaGUgYmlnIHBy
b2JsZW0gSSBzZWUgaXMgdGhhdCB3aGF0IEkgcmVhbGx5IHdhbnQgZnJvbSBhIHVzZXIncyBwb2lu
dCBvZgo+PiB2aWV3IGlzIGEgdHVuZWFibGUgdGhhdCBzYXlzICJBdXRvbWF0aWNhbGx5IGZyZWUg
Y2xlYW4gcGFnZSBjYWNoZSBwYWdlcwo+PiB0aGF0IHdlcmUgbm90IGFjY2Vzc2VkIGluIHRoZSBs
YXN0IFggbWludXRlcyIuIE90aGVyd2lzZSB3ZSBtYXkgcnVuIGludG8KPj4gdGhlIHJpc2sgb2Yg
ZXZpY3Rpbmcgc29tZSB0aW1lcyBpbiB1c2UgcGFnZSBjYWNoZSBwYWdlcy4KPj4KPj4gSSBoYXZl
IGEgaGFyZCB0aW1lIGdyYXNwaW5nIHRoZSBtbSBjb2RlIHRvIHVuZGVyc3RhbmQgaG93IGhhcmQg
dGhhdAo+PiB3b3VsZCBiZSB0byBpbXBsZW1lbnQgdGhhdCB0aG91Z2ggOikuCj4+Cj4+Cj4+IEFs
ZXgKPiAKPiBZZWFoLCBJIGFtIG5vdCBleGFjdGx5IGFuIGV4cGVydCBvbiB0aGlzIGVpdGhlciBh
cyBJIGhhdmUgb25seSBiZWVuCj4gd29ya2luZyBpbnQgaGUgTU0gdHJlZSBmb3IgYWJvdXQgYSB5
ZWFyIG5vdy4KPiAKPiBJIGhhdmUgc3VibWl0dGVkIHRoaXMgYXMgYSB0b3BpYyBmb3IgTFNGL01N
IHN1bW1pdFsxXSBhbmQgSSBhbSBob3BpbmcgdG8KPiBnZXQgc29tZSBmZWVkYmFjayBvbiB0aGUg
YmVzdCB3YXkgdG8gYXBwbHkgcHJvYWN0aXZlIG1lbW9yeSBwcmVzc3VyZSBhcwo+IG9uZSBvZiB0
aGUgc3VidG9waWNzIGlmIGl0IGlzIHNlbGVjdGVkLgoKVGhhdCdzIGEgZ3JlYXQgaWRlYSEgSGFu
bmVzIGp1c3QgbWVudGlvbmVkIExTRi9NTSBhcyBhIGdvb2QgZm9ydW0gdG8gCmRpc2N1c3MgdGhp
cyBhdCBsYXN0IG5pZ2h0LCBJJ20gZ2xhZCB0byBzZWUgeW91IGFscmVhZHkgcGlja2VkIHVwIG9u
IGl0IDopLgoKCkFsZXgKClsxXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9vbHMvMjAwNi9v
bHMyMDA2djItcGFnZXMtMzIxLTMzNi5wZGYKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBH
ZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVu
ZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10
c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpV
c3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

