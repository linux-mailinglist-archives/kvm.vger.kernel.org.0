Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684211E0CA4
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390118AbgEYLPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 07:15:24 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:15585 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389897AbgEYLPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 07:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590405323; x=1621941323;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FQoNC3ACJjy2r4SC1nWNDrTuHvYpfnKuYAOFLdtZyPA=;
  b=Mwylmx8zmgVUkFjbSGVeiEzRNZsDbyks3Jt2CeP6JXasSbDq5P2ilATF
   7YY4ryBqZHa6D2t1La/63eNeIcX4iwHdqJrLXUKS1Jns4LR1IHnDz0bqY
   zf+XJeaV0gUUyPOVFBbUET+E/xuHixtdaI3r8hMedx0BlitPqUdHFzE9f
   M=;
IronPort-SDR: UwKIpxQKZVeNmqAwu7Uu5PkPbE2BydfyUbj/Qv3MvP4I3P8AGoeMb6gU1yE+jZe5C3wmR9bKdw
 2/l9406a7FUw==
X-IronPort-AV: E=Sophos;i="5.73,433,1583193600"; 
   d="scan'208";a="37449369"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 May 2020 11:15:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 821E5A1F05;
        Mon, 25 May 2020 11:15:20 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 11:15:20 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 11:15:11 +0000
Subject: Re: [PATCH v2 04/18] nitro_enclaves: Init PCI device driver
To:     Greg KH <greg@kroah.com>, Alexander Graf <graf@amazon.de>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-5-andraprs@amazon.com>
 <20200522070414.GB771317@kroah.com>
 <68b86d32-1255-f9ce-4366-12219ce07ba6@amazon.de>
 <20200524063210.GA1369260@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c86d5b9e-778f-9357-1519-64ef59b8cfcc@amazon.com>
Date:   Mon, 25 May 2020 14:15:02 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200524063210.GA1369260@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D42UWA001.ant.amazon.com (10.43.160.153) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC8wNS8yMDIwIDA5OjMyLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFNhdCwgTWF5IDIzLCAy
MDIwIGF0IDEwOjI1OjI1UE0gKzAyMDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBIZXkgR3Jl
ZywKPj4KPj4gT24gMjIuMDUuMjAgMDk6MDQsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBGcmksIE1h
eSAyMiwgMjAyMCBhdCAwOToyOTozMkFNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+
Pj4gKy8qKgo+Pj4+ICsgKiBuZV9zZXR1cF9tc2l4IC0gU2V0dXAgTVNJLVggdmVjdG9ycyBmb3Ig
dGhlIFBDSSBkZXZpY2UuCj4+Pj4gKyAqCj4+Pj4gKyAqIEBwZGV2OiBQQ0kgZGV2aWNlIHRvIHNl
dHVwIHRoZSBNU0ktWCBmb3IuCj4+Pj4gKyAqCj4+Pj4gKyAqIEByZXR1cm5zOiAwIG9uIHN1Y2Nl
c3MsIG5lZ2F0aXZlIHJldHVybiB2YWx1ZSBvbiBmYWlsdXJlLgo+Pj4+ICsgKi8KPj4+PiArc3Rh
dGljIGludCBuZV9zZXR1cF9tc2l4KHN0cnVjdCBwY2lfZGV2ICpwZGV2KQo+Pj4+ICt7Cj4+Pj4g
KyAgICAgc3RydWN0IG5lX3BjaV9kZXYgKm5lX3BjaV9kZXYgPSBOVUxMOwo+Pj4+ICsgICAgIGlu
dCBucl92ZWNzID0gMDsKPj4+PiArICAgICBpbnQgcmMgPSAtRUlOVkFMOwo+Pj4+ICsKPj4+PiAr
ICAgICBpZiAoV0FSTl9PTighcGRldikpCj4+Pj4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZB
TDsKPj4+IEhvdyBjYW4gdGhpcyBldmVyIGhhcHBlbj8gIElmIGl0IGNhbiBub3QsIGRvbid0IHRl
c3QgZm9yIGl0LiAgSWYgaXQgY2FuLAo+Pj4gZG9uJ3Qgd2FybiBmb3IgaXQgYXMgdGhhdCB3aWxs
IGNyYXNoIHN5c3RlbXMgdGhhdCBkbyBwYW5pYy1vbi13YXJuLCBqdXN0Cj4+PiB0ZXN0IGFuZCBy
ZXR1cm4gYW4gZXJyb3IuCj4+IEkgdGhpbmsgdGhlIHBvaW50IGhlcmUgaXMgdG8gY2F0Y2ggc2l0
dWF0aW9ucyB0aGF0IHNob3VsZCBuZXZlciBoYXBwZW4sIGJ1dAo+PiBrZWVwIGEgc2FuaXR5IGNo
ZWNrIGluIGluIGNhc2UgdGhleSBkbyBoYXBwZW4uIFRoaXMgd291bGQndmUgdXN1YWxseSBiZWVu
IGEKPj4gQlVHX09OLCBidXQgcGVvcGxlIHRlbmQgdG8gZGlzbGlrZSB0aG9zZSB0aGVzZSBkYXlz
IGJlY2F1c2UgdGhleSBjYW4gYnJpbmcKPj4gZG93biB5b3VyIHN5c3RlbSAuLi4KPiBTYW1lIGZv
ciBXQVJOX09OIHdoZW4geW91IHJ1biB3aXRoIHBhbmljLW9uLXdhcm4gZW5hYmxlZCA6KAo+Cj4+
IFNvIGluIHRoaXMgcGFydGljdWxhciBjYXNlIGhlcmUgSSBhZ3JlZSB0aGF0IGl0J3MgYSBiaXQg
c2lsbHkgdG8gY2hlY2sKPj4gd2hldGhlciBwZGV2IGlzICE9IE5VTEwuIEluIG90aGVyIGRldmlj
ZSBjb2RlIGludGVybmFsIEFQSXMgdGhvdWdoIGl0J3Mgbm90Cj4+IHF1aXRlIGFzIGNsZWFyIG9m
IGEgY3V0LiBJIGJ5IGZhciBwcmVmZXIgY29kZSB0aGF0IHRlbGxzIG1lIGl0J3MgYnJva2VuIG92
ZXIKPj4gcmV2ZXJzZSBlbmdpbmVlcmluZyBzdHJheSBwb2ludGVyIGFjY2Vzc2VzIC4uLgo+IEZv
ciBzdGF0aWMgY2FsbHMgd2hlcmUgeW91IGNvbnRyb2wgdGhlIGNhbGxlcnMsIGRvbid0IGRvIGNo
ZWNrcyBsaWtlCj4gdGhpcy4gIE90aGVyd2lzZSB0aGUga2VybmVsIHdvdWxkIGp1c3QgYmUgZnVs
bCBvZiB0aGVzZSBhbGwgb3ZlciB0aGUKPiBwbGFjZSBhbmQgdGhpbmdzIHdvdWxkIHNsb3cgZG93
bi4gIEl0J3MganVzdCBub3QgbmVlZGVkLgo+Cj4+Pj4gKyAgICAgbmVfcGNpX2RldiA9IHBjaV9n
ZXRfZHJ2ZGF0YShwZGV2KTsKPj4+PiArICAgICBpZiAoV0FSTl9PTighbmVfcGNpX2RldikpCj4+
Pj4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsKPj4+IFNhbWUgaGVyZSwgZG9uJ3QgdXNl
IFdBUk5fT04gaWYgYXQgYWxsIHBvc3NpYmxlLgo+Pj4KPj4+PiArCj4+Pj4gKyAgICAgbnJfdmVj
cyA9IHBjaV9tc2l4X3ZlY19jb3VudChwZGV2KTsKPj4+PiArICAgICBpZiAobnJfdmVjcyA8IDAp
IHsKPj4+PiArICAgICAgICAgICAgIHJjID0gbnJfdmVjczsKPj4+PiArCj4+Pj4gKyAgICAgICAg
ICAgICBkZXZfZXJyX3JhdGVsaW1pdGVkKCZwZGV2LT5kZXYsCj4+Pj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIE5FICJFcnJvciBpbiBnZXR0aW5nIHZlYyBjb3VudCBbcmM9JWRd
XG4iLAo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByYyk7Cj4+Pj4gKwo+
Pj4gV2h5IHJhdGVsaW1pdGVkLCBjYW4gdGhpcyBoYXBwZW4gb3ZlciBhbmQgb3ZlciBhbmQgb3Zl
cj8KPj4gSW4gdGhpcyBwYXJ0aWN1bGFyIGZ1bmN0aW9uLCBubywgc28gaGVyZSBpdCByZWFsbHkg
c2hvdWxkIGp1c3QgYmUgZGV2X2Vyci4KPj4gT3RoZXIgZnVuY3Rpb25zIGFyZSBpbXBsaWNpdGx5
IGNhbGxhYmxlIGZyb20gdXNlciBzcGFjZSB0aHJvdWdoIGFuIGlvY3RsLAo+PiB3aGljaCBtZWFu
cyB0aGV5IHJlYWxseSBuZWVkIHRvIHN0YXkgcmF0ZSBsaW1pdGVkLgo+IFRoaW5rIHRocm91Z2gg
dGhlc2UgYXMgdGhlIGRyaXZlciBzZWVtcyB0byBPTkxZIHVzZSB0aGVzZSByYXRlbGltaXRlZAo+
IGNhbGxzIHJpZ2h0IG5vdywgd2hpY2ggaXMgbm90IGNvcnJlY3QuCj4KPiBBbHNvLCBpZiBhIHVz
ZXIgY2FuIGNyZWF0ZSBhIHByaW50aywgdGhhdCBhbG1vc3QgYWx3YXlzIGlzIG5vdCBhIGdvb2QK
PiBpZGVhLiAgQnV0IHllcywgdGhvc2Ugc2hvdWxkIGJlIHJhdGVsaW1pdGVkLgoKSSB1cGRhdGVk
IHRoZSBzdGF0aWMgY2FsbHMgY2hlY2tzIGFuZCByZW1vdmVkIHRoZSBXQVJOX09Ocy4gQW5kIApy
YXRlbGltaXRlZCBpcyB1c2VkIG5vdyBvbmx5IGluIHRoZSBpb2N0bCBjYWxsIHBhdGhzLgoKVGhh
bmsgeW91IGJvdGguCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlh
KSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBm
bG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGlu
IFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

