Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A036E1BAD7F
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD0TFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 15:05:51 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36895 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgD0TFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 15:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588014349; x=1619550349;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=aWkQdtoQefHlML79VU1lrfeYCpe1M2t2HIan/e8oegs=;
  b=RbTALElHZdi7sn5gDoqILNRESmeBUVNQ6oMzYGYWP91sC5V5doVFwUHr
   61A4ignI+827xwZ/1Im0v30PJdCN/xqqZSbImAf9cVjtL+OBC05BmSTaF
   J3BGWyM8Ux/962qIttsaghefEVqnl9RX/IWS3LdCN9Pds9CmXJmyxZZ/O
   U=;
IronPort-SDR: bkk/EKD7o214ITOrcn59w8ATEXbSUirIp8EyU14oSBYwjqCCL4FoCPNpDsQevnf1l9tgn/qJG8
 GJ+AMh85UglA==
X-IronPort-AV: E=Sophos;i="5.73,325,1583193600"; 
   d="scan'208";a="27788572"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 27 Apr 2020 19:05:35 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 38033A24D4;
        Mon, 27 Apr 2020 19:05:34 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 19:05:33 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.8) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 19:05:26 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D89F71D@SHSMSX104.ccr.corp.intel.com>
 <b5b14703-1c8c-0a34-f08b-9032a0d97b1d@amazon.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8CA449@SHSMSX104.ccr.corp.intel.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <d741da75-13ac-307a-0d8b-3e9a83c5e16a@amazon.com>
Date:   Mon, 27 Apr 2020 22:05:20 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8CA449@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D01UWA002.ant.amazon.com (10.43.160.74) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNC8yMDIwIDExOjE2LCBUaWFuLCBLZXZpbiB3cm90ZToKPj4gRnJvbTogUGFyYXNj
aGl2LCBBbmRyYS1JcmluYSA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gU2VudDogRnJpZGF5LCBB
cHJpbCAyNCwgMjAyMCA5OjU5IFBNCj4+Cj4+Cj4+IE9uIDI0LzA0LzIwMjAgMTI6NTksIFRpYW4s
IEtldmluIHdyb3RlOgo+Pj4+IEZyb206IFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEKPj4+PiBTZW50
OiBUaHVyc2RheSwgQXByaWwgMjMsIDIwMjAgOToyMCBQTQo+Pj4+Cj4+Pj4gT24gMjIvMDQvMjAy
MCAwMDo0NiwgUGFvbG8gQm9uemluaSB3cm90ZToKPj4+Pj4gT24gMjEvMDQvMjAgMjA6NDEsIEFu
ZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4+Pj4+IEFuIGVuY2xhdmUgY29tbXVuaWNhdGVzIHdpdGgg
dGhlIHByaW1hcnkgVk0gdmlhIGEgbG9jYWwKPj4gY29tbXVuaWNhdGlvbgo+Pj4+IGNoYW5uZWws
Cj4+Pj4+PiB1c2luZyB2aXJ0aW8tdnNvY2sgWzJdLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUg
YSBkaXNrIG9yIGEgbmV0d29yawo+PiBkZXZpY2UKPj4+Pj4+IGF0dGFjaGVkLgo+Pj4+PiBJcyBp
dCBwb3NzaWJsZSB0byBoYXZlIGEgc2FtcGxlIG9mIHRoaXMgaW4gdGhlIHNhbXBsZXMvIGRpcmVj
dG9yeT8KPj4+PiBJIGNhbiBhZGQgaW4gdjIgYSBzYW1wbGUgZmlsZSBpbmNsdWRpbmcgdGhlIGJh
c2ljIGZsb3cgb2YgaG93IHRvIHVzZSB0aGUKPj4+PiBpb2N0bCBpbnRlcmZhY2UgdG8gY3JlYXRl
IC8gdGVybWluYXRlIGFuIGVuY2xhdmUuCj4+Pj4KPj4+PiBUaGVuIHdlIGNhbiB1cGRhdGUgLyBi
dWlsZCBvbiB0b3AgaXQgYmFzZWQgb24gdGhlIG9uZ29pbmcgZGlzY3Vzc2lvbnMgb24KPj4+PiB0
aGUgcGF0Y2ggc2VyaWVzIGFuZCB0aGUgcmVjZWl2ZWQgZmVlZGJhY2suCj4+Pj4KPj4+Pj4gSSBh
bSBpbnRlcmVzdGVkIGVzcGVjaWFsbHkgaW46Cj4+Pj4+Cj4+Pj4+IC0gdGhlIGluaXRpYWwgQ1BV
IHN0YXRlOiBDUEwwIHZzLiBDUEwzLCBpbml0aWFsIHByb2dyYW0gY291bnRlciwgZXRjLgo+Pj4+
Pgo+Pj4+PiAtIHRoZSBjb21tdW5pY2F0aW9uIGNoYW5uZWw7IGRvZXMgdGhlIGVuY2xhdmUgc2Vl
IHRoZSB1c3VhbCBsb2NhbCBBUElDCj4+Pj4+IGFuZCBJT0FQSUMgaW50ZXJmYWNlcyBpbiBvcmRl
ciB0byBnZXQgaW50ZXJydXB0cyBmcm9tIHZpcnRpby12c29jaywgYW5kCj4+Pj4+IHdoZXJlIGlz
IHRoZSB2aXJ0aW8tdnNvY2sgZGV2aWNlICh2aXJ0aW8tbW1pbyBJIHN1cHBvc2UpIHBsYWNlZCBp
bgo+PiBtZW1vcnk/Cj4+Pj4+IC0gd2hhdCB0aGUgZW5jbGF2ZSBpcyBhbGxvd2VkIHRvIGRvOiBj
YW4gaXQgY2hhbmdlIHByaXZpbGVnZSBsZXZlbHMsCj4+Pj4+IHdoYXQgaGFwcGVucyBpZiB0aGUg
ZW5jbGF2ZSBwZXJmb3JtcyBhbiBhY2Nlc3MgdG8gbm9uZXhpc3RlbnQgbWVtb3J5LAo+Pj4+IGV0
Yy4KPj4+Pj4gLSB3aGV0aGVyIHRoZXJlIGFyZSBzcGVjaWFsIGh5cGVyY2FsbCBpbnRlcmZhY2Vz
IGZvciB0aGUgZW5jbGF2ZQo+Pj4+IEFuIGVuY2xhdmUgaXMgYSBWTSwgcnVubmluZyBvbiB0aGUg
c2FtZSBob3N0IGFzIHRoZSBwcmltYXJ5IFZNLCB0aGF0Cj4+Pj4gbGF1bmNoZWQgdGhlIGVuY2xh
dmUuIFRoZXkgYXJlIHNpYmxpbmdzLgo+Pj4+Cj4+Pj4gSGVyZSB3ZSBuZWVkIHRvIHRoaW5rIG9m
IHR3byBjb21wb25lbnRzOgo+Pj4+Cj4+Pj4gMS4gQW4gZW5jbGF2ZSBhYnN0cmFjdGlvbiBwcm9j
ZXNzIC0gYSBwcm9jZXNzIHJ1bm5pbmcgaW4gdGhlIHByaW1hcnkgVk0KPj4+PiBndWVzdCwgdGhh
dCB1c2VzIHRoZSBwcm92aWRlZCBpb2N0bCBpbnRlcmZhY2Ugb2YgdGhlIE5pdHJvIEVuY2xhdmVz
Cj4+Pj4ga2VybmVsIGRyaXZlciB0byBzcGF3biBhbiBlbmNsYXZlIFZNICh0aGF0J3MgMiBiZWxv
dykuCj4+Pj4KPj4+PiBIb3cgZG9lcyBhbGwgZ2V0cyB0byBhbiBlbmNsYXZlIFZNIHJ1bm5pbmcg
b24gdGhlIGhvc3Q/Cj4+Pj4KPj4+PiBUaGVyZSBpcyBhIE5pdHJvIEVuY2xhdmVzIGVtdWxhdGVk
IFBDSSBkZXZpY2UgZXhwb3NlZCB0byB0aGUgcHJpbWFyeSBWTS4KPj4+PiBUaGUgZHJpdmVyIGZv
ciB0aGlzIG5ldyBQQ0kgZGV2aWNlIGlzIGluY2x1ZGVkIGluIHRoZSBjdXJyZW50IHBhdGNoIHNl
cmllcy4KPj4+Pgo+Pj4+IFRoZSBpb2N0bCBsb2dpYyBpcyBtYXBwZWQgdG8gUENJIGRldmljZSBj
b21tYW5kcyBlLmcuIHRoZQo+Pj4+IE5FX0VOQ0xBVkVfU1RBUlQgaW9jdGwgbWFwcyB0byBhbiBl
bmNsYXZlIHN0YXJ0IFBDSSBjb21tYW5kIG9yIHRoZQo+Pj4+IEtWTV9TRVRfVVNFUl9NRU1PUllf
UkVHSU9OIG1hcHMgdG8gYW4gYWRkIG1lbW9yeSBQQ0kKPj4gY29tbWFuZC4KPj4+PiBUaGUgUENJ
Cj4+Pj4gZGV2aWNlIGNvbW1hbmRzIGFyZSB0aGVuIHRyYW5zbGF0ZWQgaW50byBhY3Rpb25zIHRh
a2VuIG9uIHRoZSBoeXBlcnZpc29yCj4+Pj4gc2lkZTsgdGhhdCdzIHRoZSBOaXRybyBoeXBlcnZp
c29yIHJ1bm5pbmcgb24gdGhlIGhvc3Qgd2hlcmUgdGhlIHByaW1hcnkKPj4+PiBWTSBpcyBydW5u
aW5nLgo+Pj4+Cj4+Pj4gMi4gVGhlIGVuY2xhdmUgaXRzZWxmIC0gYSBWTSBydW5uaW5nIG9uIHRo
ZSBzYW1lIGhvc3QgYXMgdGhlIHByaW1hcnkgVk0KPj4+PiB0aGF0IHNwYXduZWQgaXQuCj4+Pj4K
Pj4+PiBUaGUgZW5jbGF2ZSBWTSBoYXMgbm8gcGVyc2lzdGVudCBzdG9yYWdlIG9yIG5ldHdvcmsg
aW50ZXJmYWNlIGF0dGFjaGVkLAo+Pj4+IGl0IHVzZXMgaXRzIG93biBtZW1vcnkgYW5kIENQVXMg
KyBpdHMgdmlydGlvLXZzb2NrIGVtdWxhdGVkIGRldmljZSBmb3IKPj4+PiBjb21tdW5pY2F0aW9u
IHdpdGggdGhlIHByaW1hcnkgVk0uCj4+PiBzb3VuZHMgbGlrZSBhIGZpcmVjcmFja2VyIFZNPwo+
PiBJdCdzIGEgVk0gY3JhZnRlZCBmb3IgZW5jbGF2ZSBuZWVkcy4KPj4KPj4+PiBUaGUgbWVtb3J5
IGFuZCBDUFVzIGFyZSBjYXJ2ZWQgb3V0IG9mIHRoZSBwcmltYXJ5IFZNLCB0aGV5IGFyZQo+PiBk
ZWRpY2F0ZWQKPj4+PiBmb3IgdGhlIGVuY2xhdmUuIFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5p
bmcgb24gdGhlIGhvc3QgZW5zdXJlcyBtZW1vcnkKPj4+PiBhbmQgQ1BVIGlzb2xhdGlvbiBiZXR3
ZWVuIHRoZSBwcmltYXJ5IFZNIGFuZCB0aGUgZW5jbGF2ZSBWTS4KPj4+IEluIGxhc3QgcGFyYWdy
YXBoLCB5b3Ugc2FpZCB0aGF0IHRoZSBlbmNsYXZlIFZNIHVzZXMgaXRzIG93biBtZW1vcnkgYW5k
Cj4+PiBDUFVzLiBUaGVuIGhlcmUsIHlvdSBzYWlkIHRoZSBtZW1vcnkvQ1BVcyBhcmUgY2FydmVk
IG91dCBhbmQgZGVkaWNhdGVkCj4+PiBmcm9tIHRoZSBwcmltYXJ5IFZNLiBDYW4geW91IGVsYWJv
cmF0ZSB3aGljaCBvbmUgaXMgYWNjdXJhdGU/IG9yIGEgbWl4ZWQKPj4+IG1vZGVsPwo+PiBNZW1v
cnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0gYW5kIGFyZSBkZWRp
Y2F0ZWQgZm9yCj4+IHRoZSBlbmNsYXZlIFZNLiBJIG1lbnRpb25lZCBhYm92ZSBhcyAiaXRzIG93
biIgaW4gdGhlIHNlbnNlIHRoYXQgdGhlCj4+IHByaW1hcnkgVk0gZG9lc24ndCB1c2UgdGhlc2Ug
Y2FydmVkIG91dCByZXNvdXJjZXMgd2hpbGUgdGhlIGVuY2xhdmUgaXMKPj4gcnVubmluZywgYXMg
dGhleSBhcmUgZGVkaWNhdGVkIHRvIHRoZSBlbmNsYXZlLgo+Pgo+PiBIb3BlIHRoYXQgbm93IGl0
J3MgbW9yZSBjbGVhci4KPiB5ZXMsIGl0J3MgY2xlYXJlci4KCkdvb2QsIGdsYWQgdG8gaGVhciB0
aGF0LgoKPgo+Pj4+IFRoZXNlIHR3byBjb21wb25lbnRzIG5lZWQgdG8gcmVmbGVjdCB0aGUgc2Ft
ZSBzdGF0ZSBlLmcuIHdoZW4gdGhlCj4+Pj4gZW5jbGF2ZSBhYnN0cmFjdGlvbiBwcm9jZXNzICgx
KSBpcyB0ZXJtaW5hdGVkLCB0aGUgZW5jbGF2ZSBWTSAoMikgaXMKPj4+PiB0ZXJtaW5hdGVkIGFz
IHdlbGwuCj4+Pj4KPj4+PiBXaXRoIHJlZ2FyZCB0byB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVs
LCB0aGUgcHJpbWFyeSBWTSBoYXMgaXRzIG93bgo+Pj4+IGVtdWxhdGVkIHZpcnRpby12c29jayBQ
Q0kgZGV2aWNlLiBUaGUgZW5jbGF2ZSBWTSBoYXMgaXRzIG93biBlbXVsYXRlZAo+Pj4+IHZpcnRp
by12c29jayBkZXZpY2UgYXMgd2VsbC4gVGhpcyBjaGFubmVsIGlzIHVzZWQsIGZvciBleGFtcGxl
LCB0byBmZXRjaAo+Pj4+IGRhdGEgaW4gdGhlIGVuY2xhdmUgYW5kIHRoZW4gcHJvY2VzcyBpdC4g
QW4gYXBwbGljYXRpb24gdGhhdCBzZXRzIHVwIHRoZQo+Pj4+IHZzb2NrIHNvY2tldCBhbmQgY29u
bmVjdHMgb3IgbGlzdGVucywgZGVwZW5kaW5nIG9uIHRoZSB1c2UgY2FzZSwgaXMgdGhlbgo+Pj4+
IGRldmVsb3BlZCB0byB1c2UgdGhpcyBjaGFubmVsOyB0aGlzIGhhcHBlbnMgb24gYm90aCBlbmRz
IC0gcHJpbWFyeSBWTQo+Pj4+IGFuZCBlbmNsYXZlIFZNLgo+Pj4gSG93IGRvZXMgdGhlIGFwcGxp
Y2F0aW9uIGluIHRoZSBwcmltYXJ5IFZNIGFzc2lnbiB0YXNrIHRvIGJlIGV4ZWN1dGVkCj4+PiBp
biB0aGUgZW5jbGF2ZSBWTT8gSSBkaWRuJ3Qgc2VlIHN1Y2ggY29tbWFuZCBpbiB0aGlzIHNlcmll
cywgc28gc3VwcG9zZQo+Pj4gaXQgaXMgYWxzbyBjb21tdW5pY2F0ZWQgdGhyb3VnaCB2aXJ0aW8t
dnNvY2s/Cj4+IFRoZSBhcHBsaWNhdGlvbiB0aGF0IHJ1bnMgaW4gdGhlIGVuY2xhdmUgbmVlZHMg
dG8gYmUgcGFja2FnZWQgaW4gYW4KPj4gZW5jbGF2ZSBpbWFnZSB0b2dldGhlciB3aXRoIHRoZSBP
UyAoIGUuZy4ga2VybmVsLCByYW1kaXNrLCBpbml0ICkgdGhhdAo+PiB3aWxsIHJ1biBpbiB0aGUg
ZW5jbGF2ZSBWTS4KPj4KPj4gVGhlbiB0aGUgZW5jbGF2ZSBpbWFnZSBpcyBsb2FkZWQgaW4gbWVt
b3J5LiBBZnRlciBib290aW5nIGlzIGZpbmlzaGVkLAo+PiB0aGUgYXBwbGljYXRpb24gc3RhcnRz
LiBOb3csIGRlcGVuZGluZyBvbiB0aGUgYXBwIGltcGxlbWVudGF0aW9uIGFuZCB1c2UKPj4gY2Fz
ZSwgb25lIGV4YW1wbGUgY2FuIGJlIHRoYXQgdGhlIGFwcCBpbiB0aGUgZW5jbGF2ZSB3YWl0cyBm
b3IgZGF0YSB0bwo+PiBiZSBmZXRjaGVkIGluIHZpYSB0aGUgdnNvY2sgY2hhbm5lbC4KPj4KPiBP
SywgSSB0aG91Z2h0IHRoZSBjb2RlL2RhdGEgd2FzIGR5bmFtaWNhbGx5IGluamVjdGVkIGZyb20g
dGhlIHByaW1hcnkKPiBWTSBhbmQgdGhlbiBydW4gaW4gdGhlIGVuY2xhdmUuIEZyb20geW91ciBk
ZXNjcmlwdGlvbiBpdCBzb3VuZHMgbGlrZQo+IGEgc2VydmljaW5nIG1vZGVsIHRoYXQgYW4gYXV0
by1ydW5uaW5nIGFwcGxpY2F0aW9uIHdhaXQgZm9yIGFuZCByZXNwb25kCj4gc2VydmljZSByZXF1
ZXN0IGZyb20gdGhlIGFwcGxpY2F0aW9uIGluIHRoZSBwcmltYXJ5IFZNLgoKVGhhdCB3YXMgYW4g
ZXhhbXBsZSB3aXRoIGEgcG9zc2libGUgdXNlIGNhc2U7IGluIHRoYXQgb25lIGV4YW1wbGUsIGRh
dGEgCmNhbiBiZSBkeW5hbWljYWxseSBpbmplY3RlZCBlLmcuIGZldGNoIGluIHRoZSBlbmNsYXZl
IFZNIGEgYnVuY2ggZGF0YSwgCmdldCBiYWNrIHRoZSByZXN1bHRzIGFmdGVyIHByb2Nlc3Npbmcs
IHRoZW4gZmV0Y2ggaW4gYW5vdGhlciBzZXQgb2YgZGF0YSAKYW5kIHNvIG9uLgoKVGhlIGFyY2hp
dGVjdHVyZSBvZiB0aGUgc29sdXRpb24gZGVwZW5kcyBvbiBob3cgdGhlIHRhc2tzIGFyZSBzcGxp
dCAKYmV0d2VlbiB0aGUgcHJpbWFyeSBWTSBhbmQgdGhlIGVuY2xhdmUgVk0gYW5kIHdoYXQgaXMg
c2VudCB2aWEgdGhlIHZzb2NrIApjaGFubmVsLiBUaGUgcHJpbWFyeSBWTSwgdGhlIGVuY2xhdmUg
Vk0gYW5kIHRoZSBjb21tdW5pY2F0aW9uIGJldHdlZW4gCnRoZW0gaXMgcGFydCBvZiB0aGUgZm91
bmRhdGlvbmFsIHRlY2hub2xvZ3kgd2UgcHJvdmlkZS4gV2hhdCdzIHJ1bm5pbmcgCmluc2lkZSBl
YWNoIG9mIHRoZW0gY2FuIHZhcnkgYmFzZWQgb24gdGhlIGN1c3RvbWVyIHVzZSBjYXNlIGFuZCB1
cGRhdGVzIAp0byBmaXQgdGhpcyBpbmZyYXN0cnVjdHVyZSBvZiBzZXZlcmFsIHRhc2tzIG5vdyBi
ZWluZyBzcGxpdCBhbmQgcnVubmluZyAKcGFydCBvZiB0aGVtIGluIHRoZSBlbmNsYXZlIFZNLgoK
VGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIu
TC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAy
LCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFu
aWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

