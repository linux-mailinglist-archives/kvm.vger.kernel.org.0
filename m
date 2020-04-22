Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2011B4767
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgDVOfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 10:35:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:54866 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgDVOfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 10:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587566144; x=1619102144;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=VyvTAFNY/PJIZIzdT/RK7DKK5sVJPpUbovBzORaA9b8=;
  b=pVaaOgeKOFmsL3WFr0E7ZUgFfOhXDpTKoou7ANhng/alZWHTtC2kpr4j
   0TTFkL72eixXC5vE1a4t0GlTyOmsXMPsNSgqPgrvh+cXTm+VNU/52keVD
   zgjghrAORs1hUKgyMEEinmZaQLbPcegTnjmmk1+uUViA0n/56Ibzrtpa6
   o=;
IronPort-SDR: oFf+XMB52+Nnq5FTYuJ0l5VruB5O5i2cc113aDzkRwYh2ixClq+z8wZGnnq9JKuLB2/h7tuTHF
 RKkey7pEQQ8A==
X-IronPort-AV: E=Sophos;i="5.72,414,1580774400"; 
   d="scan'208";a="28207546"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Apr 2020 14:35:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 638A3A1B6D;
        Wed, 22 Apr 2020 14:35:30 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 14:35:29 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.92) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 14:35:21 +0000
Subject: Re: [PATCH v1 13/15] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Randy Dunlap <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-14-andraprs@amazon.com>
 <0b169445-a0c6-8eef-86b8-71a09021e143@infradead.org>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <65322574-8bdf-51c7-04e0-54c344f8014b@amazon.com>
Date:   Wed, 22 Apr 2020 17:35:12 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0b169445-a0c6-8eef-86b8-71a09021e143@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.92]
X-ClientProxiedBy: EX13D42UWA004.ant.amazon.com (10.43.160.18) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMS8wNC8yMDIwIDIxOjUwLCBSYW5keSBEdW5sYXAgd3JvdGU6Cj4gSGktLQo+Cj4gT24g
NC8yMS8yMCAxMTo0MSBBTSwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiBTaWduZWQtb2ZmLWJ5
OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+IC0tLQo+PiAgIGRyaXZl
cnMvdmlydC9LY29uZmlnICAgICAgICB8ICAyICsrCj4+ICAgZHJpdmVycy92aXJ0L2FtYXpvbi9L
Y29uZmlnIHwgMjggKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+PiAgIDIgZmlsZXMgY2hh
bmdlZCwgMzAgaW5zZXJ0aW9ucygrKQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3Zp
cnQvYW1hem9uL0tjb25maWcKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9LY29uZmln
IGIvZHJpdmVycy92aXJ0L0tjb25maWcKPj4gaW5kZXggMzYzYWYyZWFmMmJhLi4wNmJiNWNmYTE5
MWQgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvdmlydC9LY29uZmlnCj4+ICsrKyBiL2RyaXZlcnMv
dmlydC9LY29uZmlnCj4+IEBAIC0zMiw0ICszMiw2IEBAIGNvbmZpZyBGU0xfSFZfTUFOQUdFUgo+
PiAgICAgICAgICAgICBwYXJ0aXRpb24gc2h1dHMgZG93bi4KPj4KPj4gICBzb3VyY2UgImRyaXZl
cnMvdmlydC92Ym94Z3Vlc3QvS2NvbmZpZyIKPj4gKwo+PiArc291cmNlICJkcml2ZXJzL3ZpcnQv
YW1hem9uL0tjb25maWciCj4+ICAgZW5kaWYKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9h
bWF6b24vS2NvbmZpZyBiL2RyaXZlcnMvdmlydC9hbWF6b24vS2NvbmZpZwo+PiBuZXcgZmlsZSBt
b2RlIDEwMDY0NAo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjU3ZmQwYWE1ODgwMwo+PiAtLS0gL2Rl
di9udWxsCj4+ICsrKyBiL2RyaXZlcnMvdmlydC9hbWF6b24vS2NvbmZpZwo+PiBAQCAtMCwwICsx
LDI4IEBACj4+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4+ICsjCj4+ICsj
IENvcHlyaWdodCAyMDIwIEFtYXpvbi5jb20sIEluYy4gb3IgaXRzIGFmZmlsaWF0ZXMuIEFsbCBS
aWdodHMgUmVzZXJ2ZWQuCj4+ICsjCj4+ICsjIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJl
OyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0Cj4+ICsjIHVuZGVyIHRo
ZSB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2Us
Cj4+ICsjIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5k
YXRpb24uCj4+ICsjCj4+ICsjIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9w
ZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAo+PiArIyBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7
IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgo+PiArIyBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuIFNlZSB0aGUKPj4gKyMgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KPj4gKyMKPj4gKyMgWW91
IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExp
Y2Vuc2UKPj4gKyMgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgc2VlIDxodHRwOi8v
d3d3LmdudS5vcmcvbGljZW5zZXMvPi4KPj4gKwo+PiArIyBBbWF6b24gTml0cm8gRW5jbGF2ZXMg
KE5FKSBzdXBwb3J0Lgo+PiArIyBOaXRybyBpcyBhIGh5cGVydmlzb3IgdGhhdCBoYXMgYmVlbiBk
ZXZlbG9wZWQgYnkgQW1hem9uLgo+PiArCj4+ICtjb25maWcgTklUUk9fRU5DTEFWRVMKPj4gKyAg
ICAgdHJpc3RhdGUgIk5pdHJvIEVuY2xhdmVzIFN1cHBvcnQiCj4+ICsgICAgIGRlcGVuZHMgb24g
SE9UUExVR19DUFUKPj4gKyAgICAgLS0taGVscC0tLQo+IEZvciB2MjoKPiBXZSBhcmUgbW92aW5n
IGF3YXkgZnJvbSB0aGUgdXNlIG9mICItLS1oZWxwLS0tIiB0byBqdXN0ICJoZWxwIi4KCkhpIFJh
bmR5LAoKQWNrLCB0aGFuayB5b3UsIEkgdXBkYXRlZCBpbiB2Mi4KClRoYW5rcywKQW5kcmEKCj4K
Pj4gKyAgICAgICBUaGlzIGRyaXZlciBjb25zaXN0cyBvZiBzdXBwb3J0IGZvciBlbmNsYXZlIGxp
ZmV0aW1lIG1hbmFnZW1lbnQKPj4gKyAgICAgICBmb3IgTml0cm8gRW5jbGF2ZXMgKE5FKS4KPj4g
Kwo+PiArICAgICAgIFRvIGNvbXBpbGUgdGhpcyBkcml2ZXIgYXMgYSBtb2R1bGUsIGNob29zZSBN
IGhlcmUuCj4+ICsgICAgICAgVGhlIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBuaXRyb19lbmNsYXZl
cy4KPj4KPiB0aGFua3MuCj4gLS0KPiB+UmFuZHkKPgoKCgoKQW1hem9uIERldmVsb3BtZW50IENl
bnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0
cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4g
UmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUu
Cg==

