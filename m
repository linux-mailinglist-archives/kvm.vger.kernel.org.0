Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E581B7142
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 11:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDXJyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 05:54:45 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:49000 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDXJyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 05:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587722084; x=1619258084;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qVuZE7OJN2t88CjqZJ9zf+6czW58eoIHznZXj+QvLrY=;
  b=D0b2GNW8MxsFiYyaq4dYGLDCPCJma9Qqme1ewySRDdhdHFCea0vV/XMv
   UlBNMXisNRgAGdrbhjdCS469JllFu4ehhBBAwNcW95Q3VV+E4ynD/bL3+
   /jyXS7rRanS+UTJromNlbeeCyiCd+0nj5VYpvyH4PisoH3ds64RSHsXsE
   I=;
IronPort-SDR: JWGstll9TZ69BBNXYi3D/4rW1l3wB6WXwVzswXlLPkHeeBbt/yw6IRHtOq4WqJNjo2k0UFQ/6u
 I3M1oycfBDRQ==
X-IronPort-AV: E=Sophos;i="5.73,311,1583193600"; 
   d="scan'208";a="30900065"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Apr 2020 09:54:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id C9C88A03AD;
        Fri, 24 Apr 2020 09:54:40 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 09:54:40 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 09:54:32 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>
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
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2aa9c865-61c1-fc73-c85d-6627738d2d24@huawei.com>
 <7ac3f702-9c5f-5021-ebe3-42f1c93afbdf@amazon.com>
Message-ID: <f701e084-7d2d-35dd-31ec-adc7d2a9e893@amazon.com>
Date:   Fri, 24 Apr 2020 12:54:23 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7ac3f702-9c5f-5021-ebe3-42f1c93afbdf@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.52]
X-ClientProxiedBy: EX13D07UWA001.ant.amazon.com (10.43.160.145) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC8wNC8yMDIwIDExOjE5LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Cj4K
PiBPbiAyNC8wNC8yMDIwIDA2OjA0LCBMb25ncGVuZyAoTWlrZSwgQ2xvdWQgSW5mcmFzdHJ1Y3R1
cmUgU2VydmljZSAKPiBQcm9kdWN0IERlcHQuKSB3cm90ZToKPj4gT24gMjAyMC80LzIzIDIxOjE5
LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Pj4KPj4+IE9uIDIyLzA0LzIwMjAgMDA6
NDYsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4+Pj4gT24gMjEvMDQvMjAgMjA6NDEsIEFuZHJhIFBh
cmFzY2hpdiB3cm90ZToKPj4+Pj4gQW4gZW5jbGF2ZSBjb21tdW5pY2F0ZXMgd2l0aCB0aGUgcHJp
bWFyeSBWTSB2aWEgYSBsb2NhbCAKPj4+Pj4gY29tbXVuaWNhdGlvbiBjaGFubmVsLAo+Pj4+PiB1
c2luZyB2aXJ0aW8tdnNvY2sgWzJdLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgYSBkaXNrIG9y
IGEgCj4+Pj4+IG5ldHdvcmsgZGV2aWNlCj4+Pj4+IGF0dGFjaGVkLgo+Pj4+IElzIGl0IHBvc3Np
YmxlIHRvIGhhdmUgYSBzYW1wbGUgb2YgdGhpcyBpbiB0aGUgc2FtcGxlcy8gZGlyZWN0b3J5Pwo+
Pj4gSSBjYW4gYWRkIGluIHYyIGEgc2FtcGxlIGZpbGUgaW5jbHVkaW5nIHRoZSBiYXNpYyBmbG93
IG9mIGhvdyB0byB1c2UgCj4+PiB0aGUgaW9jdGwKPj4+IGludGVyZmFjZSB0byBjcmVhdGUgLyB0
ZXJtaW5hdGUgYW4gZW5jbGF2ZS4KPj4+Cj4+PiBUaGVuIHdlIGNhbiB1cGRhdGUgLyBidWlsZCBv
biB0b3AgaXQgYmFzZWQgb24gdGhlIG9uZ29pbmcgCj4+PiBkaXNjdXNzaW9ucyBvbiB0aGUKPj4+
IHBhdGNoIHNlcmllcyBhbmQgdGhlIHJlY2VpdmVkIGZlZWRiYWNrLgo+Pj4KPj4+PiBJIGFtIGlu
dGVyZXN0ZWQgZXNwZWNpYWxseSBpbjoKPj4+Pgo+Pj4+IC0gdGhlIGluaXRpYWwgQ1BVIHN0YXRl
OiBDUEwwIHZzLiBDUEwzLCBpbml0aWFsIHByb2dyYW0gY291bnRlciwgZXRjLgo+Pj4+Cj4+Pj4g
LSB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsOyBkb2VzIHRoZSBlbmNsYXZlIHNlZSB0aGUgdXN1
YWwgbG9jYWwgQVBJQwo+Pj4+IGFuZCBJT0FQSUMgaW50ZXJmYWNlcyBpbiBvcmRlciB0byBnZXQg
aW50ZXJydXB0cyBmcm9tIHZpcnRpby12c29jaywgCj4+Pj4gYW5kCj4+Pj4gd2hlcmUgaXMgdGhl
IHZpcnRpby12c29jayBkZXZpY2UgKHZpcnRpby1tbWlvIEkgc3VwcG9zZSkgcGxhY2VkIGluIAo+
Pj4+IG1lbW9yeT8KPj4+Pgo+Pj4+IC0gd2hhdCB0aGUgZW5jbGF2ZSBpcyBhbGxvd2VkIHRvIGRv
OiBjYW4gaXQgY2hhbmdlIHByaXZpbGVnZSBsZXZlbHMsCj4+Pj4gd2hhdCBoYXBwZW5zIGlmIHRo
ZSBlbmNsYXZlIHBlcmZvcm1zIGFuIGFjY2VzcyB0byBub25leGlzdGVudCAKPj4+PiBtZW1vcnks
IGV0Yy4KPj4+Pgo+Pj4+IC0gd2hldGhlciB0aGVyZSBhcmUgc3BlY2lhbCBoeXBlcmNhbGwgaW50
ZXJmYWNlcyBmb3IgdGhlIGVuY2xhdmUKPj4+IEFuIGVuY2xhdmUgaXMgYSBWTSwgcnVubmluZyBv
biB0aGUgc2FtZSBob3N0IGFzIHRoZSBwcmltYXJ5IFZNLCB0aGF0IAo+Pj4gbGF1bmNoZWQKPj4+
IHRoZSBlbmNsYXZlLiBUaGV5IGFyZSBzaWJsaW5ncy4KPj4+Cj4+PiBIZXJlIHdlIG5lZWQgdG8g
dGhpbmsgb2YgdHdvIGNvbXBvbmVudHM6Cj4+Pgo+Pj4gMS4gQW4gZW5jbGF2ZSBhYnN0cmFjdGlv
biBwcm9jZXNzIC0gYSBwcm9jZXNzIHJ1bm5pbmcgaW4gdGhlIHByaW1hcnkgCj4+PiBWTSBndWVz
dCwKPj4+IHRoYXQgdXNlcyB0aGUgcHJvdmlkZWQgaW9jdGwgaW50ZXJmYWNlIG9mIHRoZSBOaXRy
byBFbmNsYXZlcyBrZXJuZWwgCj4+PiBkcml2ZXIgdG8KPj4+IHNwYXduIGFuIGVuY2xhdmUgVk0g
KHRoYXQncyAyIGJlbG93KS4KPj4+Cj4+PiBIb3cgZG9lcyBhbGwgZ2V0cyB0byBhbiBlbmNsYXZl
IFZNIHJ1bm5pbmcgb24gdGhlIGhvc3Q/Cj4+Pgo+Pj4gVGhlcmUgaXMgYSBOaXRybyBFbmNsYXZl
cyBlbXVsYXRlZCBQQ0kgZGV2aWNlIGV4cG9zZWQgdG8gdGhlIHByaW1hcnkgCj4+PiBWTS4gVGhl
Cj4+PiBkcml2ZXIgZm9yIHRoaXMgbmV3IFBDSSBkZXZpY2UgaXMgaW5jbHVkZWQgaW4gdGhlIGN1
cnJlbnQgcGF0Y2ggc2VyaWVzLgo+Pj4KPj4gSGkgUGFyYXNjaGl2LAo+Pgo+PiBUaGUgbmV3IFBD
SSBkZXZpY2UgaXMgZW11bGF0ZWQgaW4gUUVNVSA/IElmIHNvLCBpcyB0aGVyZSBhbnkgcGxhbiB0
byAKPj4gc2VuZCB0aGUKPj4gUUVNVSBjb2RlID8KPgo+IEhpLAo+Cj4gTm9wZSwgbm90IHRoYXQg
SSBrbm93IG9mIHNvIGZhci4KCkFuZCBqdXN0IHRvIGJlIGEgYml0IG1vcmUgY2xlYXIsIHRoZSBy
ZXBseSBhYm92ZSB0YWtlcyBpbnRvIApjb25zaWRlcmF0aW9uIHRoYXQgaXQncyBub3QgZW11bGF0
ZWQgaW4gUUVNVS4KCgpUaGFua3MsCkFuZHJhCgo+Cj4+Cj4+PiBUaGUgaW9jdGwgbG9naWMgaXMg
bWFwcGVkIHRvIFBDSSBkZXZpY2UgY29tbWFuZHMgZS5nLiB0aGUgCj4+PiBORV9FTkNMQVZFX1NU
QVJUIGlvY3RsCj4+PiBtYXBzIHRvIGFuIGVuY2xhdmUgc3RhcnQgUENJIGNvbW1hbmQgb3IgdGhl
IAo+Pj4gS1ZNX1NFVF9VU0VSX01FTU9SWV9SRUdJT04gbWFwcyB0bwo+Pj4gYW4gYWRkIG1lbW9y
eSBQQ0kgY29tbWFuZC4gVGhlIFBDSSBkZXZpY2UgY29tbWFuZHMgYXJlIHRoZW4gCj4+PiB0cmFu
c2xhdGVkIGludG8KPj4+IGFjdGlvbnMgdGFrZW4gb24gdGhlIGh5cGVydmlzb3Igc2lkZTsgdGhh
dCdzIHRoZSBOaXRybyBoeXBlcnZpc29yIAo+Pj4gcnVubmluZyBvbiB0aGUKPj4+IGhvc3Qgd2hl
cmUgdGhlIHByaW1hcnkgVk0gaXMgcnVubmluZy4KPj4+Cj4+PiAyLiBUaGUgZW5jbGF2ZSBpdHNl
bGYgLSBhIFZNIHJ1bm5pbmcgb24gdGhlIHNhbWUgaG9zdCBhcyB0aGUgcHJpbWFyeSAKPj4+IFZN
IHRoYXQKPj4+IHNwYXduZWQgaXQuCj4+Pgo+Pj4gVGhlIGVuY2xhdmUgVk0gaGFzIG5vIHBlcnNp
c3RlbnQgc3RvcmFnZSBvciBuZXR3b3JrIGludGVyZmFjZSAKPj4+IGF0dGFjaGVkLCBpdCB1c2Vz
Cj4+PiBpdHMgb3duIG1lbW9yeSBhbmQgQ1BVcyArIGl0cyB2aXJ0aW8tdnNvY2sgZW11bGF0ZWQg
ZGV2aWNlIGZvciAKPj4+IGNvbW11bmljYXRpb24KPj4+IHdpdGggdGhlIHByaW1hcnkgVk0uCj4+
Pgo+Pj4gVGhlIG1lbW9yeSBhbmQgQ1BVcyBhcmUgY2FydmVkIG91dCBvZiB0aGUgcHJpbWFyeSBW
TSwgdGhleSBhcmUgCj4+PiBkZWRpY2F0ZWQgZm9yIHRoZQo+Pj4gZW5jbGF2ZS4gVGhlIE5pdHJv
IGh5cGVydmlzb3IgcnVubmluZyBvbiB0aGUgaG9zdCBlbnN1cmVzIG1lbW9yeSBhbmQgCj4+PiBD
UFUKPj4+IGlzb2xhdGlvbiBiZXR3ZWVuIHRoZSBwcmltYXJ5IFZNIGFuZCB0aGUgZW5jbGF2ZSBW
TS4KPj4+Cj4+Pgo+Pj4gVGhlc2UgdHdvIGNvbXBvbmVudHMgbmVlZCB0byByZWZsZWN0IHRoZSBz
YW1lIHN0YXRlIGUuZy4gd2hlbiB0aGUgCj4+PiBlbmNsYXZlCj4+PiBhYnN0cmFjdGlvbiBwcm9j
ZXNzICgxKSBpcyB0ZXJtaW5hdGVkLCB0aGUgZW5jbGF2ZSBWTSAoMikgaXMgCj4+PiB0ZXJtaW5h
dGVkIGFzIHdlbGwuCj4+Pgo+Pj4gV2l0aCByZWdhcmQgdG8gdGhlIGNvbW11bmljYXRpb24gY2hh
bm5lbCwgdGhlIHByaW1hcnkgVk0gaGFzIGl0cyBvd24gCj4+PiBlbXVsYXRlZAo+Pj4gdmlydGlv
LXZzb2NrIFBDSSBkZXZpY2UuIFRoZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkIAo+
Pj4gdmlydGlvLXZzb2NrIGRldmljZQo+Pj4gYXMgd2VsbC4gVGhpcyBjaGFubmVsIGlzIHVzZWQs
IGZvciBleGFtcGxlLCB0byBmZXRjaCBkYXRhIGluIHRoZSAKPj4+IGVuY2xhdmUgYW5kCj4+PiB0
aGVuIHByb2Nlc3MgaXQuIEFuIGFwcGxpY2F0aW9uIHRoYXQgc2V0cyB1cCB0aGUgdnNvY2sgc29j
a2V0IGFuZCAKPj4+IGNvbm5lY3RzIG9yCj4+PiBsaXN0ZW5zLCBkZXBlbmRpbmcgb24gdGhlIHVz
ZSBjYXNlLCBpcyB0aGVuIGRldmVsb3BlZCB0byB1c2UgdGhpcyAKPj4+IGNoYW5uZWw7IHRoaXMK
Pj4+IGhhcHBlbnMgb24gYm90aCBlbmRzIC0gcHJpbWFyeSBWTSBhbmQgZW5jbGF2ZSBWTS4KPj4+
Cj4+PiBMZXQgbWUga25vdyBpZiBmdXJ0aGVyIGNsYXJpZmljYXRpb25zIGFyZSBuZWVkZWQuCj4+
Pgo+Pj4+PiBUaGUgcHJvcG9zZWQgc29sdXRpb24gaXMgZm9sbG93aW5nIHRoZSBLVk0gbW9kZWwg
YW5kIHVzZXMgdGhlIEtWTSAKPj4+Pj4gQVBJIHRvIGJlIGFibGUKPj4+Pj4gdG8gY3JlYXRlIGFu
ZCBzZXQgcmVzb3VyY2VzIGZvciBlbmNsYXZlcy4gQW4gYWRkaXRpb25hbCBpb2N0bCAKPj4+Pj4g
Y29tbWFuZCwgYmVzaWRlcwo+Pj4+PiB0aGUgb25lcyBwcm92aWRlZCBieSBLVk0sIGlzIHVzZWQg
dG8gc3RhcnQgYW4gZW5jbGF2ZSBhbmQgc2V0dXAgCj4+Pj4+IHRoZSBhZGRyZXNzaW5nCj4+Pj4+
IGZvciB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsIGFuZCBhbiBlbmNsYXZlIHVuaXF1ZSBpZC4K
Pj4+PiBSZXVzaW5nIHNvbWUgS1ZNIGlvY3RscyBpcyBkZWZpbml0ZWx5IGEgZ29vZCBpZGVhLCBi
dXQgSSB3b3VsZG4ndCAKPj4+PiByZWFsbHkKPj4+PiBzYXkgaXQncyB0aGUgS1ZNIEFQSSBzaW5j
ZSB0aGUgVkNQVSBmaWxlIGRlc2NyaXB0b3IgaXMgYmFzaWNhbGx5IG5vbgo+Pj4+IGZ1bmN0aW9u
YWwgKHdpdGhvdXQgS1ZNX1JVTiBhbmQgbW1hcCBpdCdzIG5vdCByZWFsbHkgdGhlIEtWTSBBUEkp
Lgo+Pj4gSXQgdXNlcyBwYXJ0IG9mIHRoZSBLVk0gQVBJIG9yIGEgc2V0IG9mIEtWTSBpb2N0bHMg
dG8gbW9kZWwgdGhlIHdheSAKPj4+IGEgVk0gaXMKPj4+IGNyZWF0ZWQgLyB0ZXJtaW5hdGVkLiBU
aGF0J3MgdHJ1ZSwgS1ZNX1JVTiBhbmQgbW1hcC1pbmcgdGhlIHZjcHUgZmQgCj4+PiBhcmUgbm90
Cj4+PiBpbmNsdWRlZC4KPj4+Cj4+PiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjayByZWdhcmRpbmcg
dGhlIHJldXNlIG9mIEtWTSBpb2N0bHMuCj4+Pgo+Pj4gQW5kcmEKPj4+Cj4+Pgo+Pj4KPj4+Cj4+
PiBBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBv
ZmZpY2U6IDI3QSAKPj4+IFNmLiBMYXphcgo+Pj4gU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNp
LCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiAKPj4+IFJlZ2lzdGVyZWQgaW4KPj4+IFJv
bWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4KPgoKCgoKQW1hem9uIERl
dmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0Eg
U2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0
NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoy
Mi8yNjIxLzIwMDUuCg==

