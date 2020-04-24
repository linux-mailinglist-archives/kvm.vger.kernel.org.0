Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBE11B77B6
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgDXN7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:59:54 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55480 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXN7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587736792; x=1619272792;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=V9f2UKrJFgIeyh3Jf7ZhXEIAuvO4H34kWtsE/7e8exI=;
  b=e8YysWT9G+5nHoZr/hN205QaKKW49G5hb4CHVv1LsjcnG+sVtHbcQ69/
   omZnVX/RdY8zAMyK95g3quzOPoa5O241N8lahnarNv9X3oA0L9AQkxUHI
   LuqV4tpBQJSWx9T6gJHiSN6E0XlNeyY+ydZQWNB+nzuowk6gwZ5mb3l+O
   Y=;
IronPort-SDR: d5IK7qlppelPL/5yvB0+Rq6MPR0rt+7QgIdECISZgZh2UDbJprnGPO88jAfUZOM0s0sS8f9hOO
 vn9cVL+XvJ5w==
X-IronPort-AV: E=Sophos;i="5.73,311,1583193600"; 
   d="scan'208";a="28578692"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 24 Apr 2020 13:59:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id CAC8BA20F5;
        Fri, 24 Apr 2020 13:59:37 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 13:59:37 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 13:59:29 +0000
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b5b14703-1c8c-0a34-f08b-9032a0d97b1d@amazon.com>
Date:   Fri, 24 Apr 2020 16:59:19 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D89F71D@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D41UWB003.ant.amazon.com (10.43.161.243) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC8wNC8yMDIwIDEyOjU5LCBUaWFuLCBLZXZpbiB3cm90ZToKPgo+PiBGcm9tOiBQYXJh
c2NoaXYsIEFuZHJhLUlyaW5hCj4+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAyMywgMjAyMCA5OjIw
IFBNCj4+Cj4+IE9uIDIyLzA0LzIwMjAgMDA6NDYsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4+PiBP
biAyMS8wNC8yMCAyMDo0MSwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+Pj4+IEFuIGVuY2xhdmUg
Y29tbXVuaWNhdGVzIHdpdGggdGhlIHByaW1hcnkgVk0gdmlhIGEgbG9jYWwgY29tbXVuaWNhdGlv
bgo+PiBjaGFubmVsLAo+Pj4+IHVzaW5nIHZpcnRpby12c29jayBbMl0uIEFuIGVuY2xhdmUgZG9l
cyBub3QgaGF2ZSBhIGRpc2sgb3IgYSBuZXR3b3JrIGRldmljZQo+Pj4+IGF0dGFjaGVkLgo+Pj4g
SXMgaXQgcG9zc2libGUgdG8gaGF2ZSBhIHNhbXBsZSBvZiB0aGlzIGluIHRoZSBzYW1wbGVzLyBk
aXJlY3Rvcnk/Cj4+IEkgY2FuIGFkZCBpbiB2MiBhIHNhbXBsZSBmaWxlIGluY2x1ZGluZyB0aGUg
YmFzaWMgZmxvdyBvZiBob3cgdG8gdXNlIHRoZQo+PiBpb2N0bCBpbnRlcmZhY2UgdG8gY3JlYXRl
IC8gdGVybWluYXRlIGFuIGVuY2xhdmUuCj4+Cj4+IFRoZW4gd2UgY2FuIHVwZGF0ZSAvIGJ1aWxk
IG9uIHRvcCBpdCBiYXNlZCBvbiB0aGUgb25nb2luZyBkaXNjdXNzaW9ucyBvbgo+PiB0aGUgcGF0
Y2ggc2VyaWVzIGFuZCB0aGUgcmVjZWl2ZWQgZmVlZGJhY2suCj4+Cj4+PiBJIGFtIGludGVyZXN0
ZWQgZXNwZWNpYWxseSBpbjoKPj4+Cj4+PiAtIHRoZSBpbml0aWFsIENQVSBzdGF0ZTogQ1BMMCB2
cy4gQ1BMMywgaW5pdGlhbCBwcm9ncmFtIGNvdW50ZXIsIGV0Yy4KPj4+Cj4+PiAtIHRoZSBjb21t
dW5pY2F0aW9uIGNoYW5uZWw7IGRvZXMgdGhlIGVuY2xhdmUgc2VlIHRoZSB1c3VhbCBsb2NhbCBB
UElDCj4+PiBhbmQgSU9BUElDIGludGVyZmFjZXMgaW4gb3JkZXIgdG8gZ2V0IGludGVycnVwdHMg
ZnJvbSB2aXJ0aW8tdnNvY2ssIGFuZAo+Pj4gd2hlcmUgaXMgdGhlIHZpcnRpby12c29jayBkZXZp
Y2UgKHZpcnRpby1tbWlvIEkgc3VwcG9zZSkgcGxhY2VkIGluIG1lbW9yeT8KPj4+Cj4+PiAtIHdo
YXQgdGhlIGVuY2xhdmUgaXMgYWxsb3dlZCB0byBkbzogY2FuIGl0IGNoYW5nZSBwcml2aWxlZ2Ug
bGV2ZWxzLAo+Pj4gd2hhdCBoYXBwZW5zIGlmIHRoZSBlbmNsYXZlIHBlcmZvcm1zIGFuIGFjY2Vz
cyB0byBub25leGlzdGVudCBtZW1vcnksCj4+IGV0Yy4KPj4+IC0gd2hldGhlciB0aGVyZSBhcmUg
c3BlY2lhbCBoeXBlcmNhbGwgaW50ZXJmYWNlcyBmb3IgdGhlIGVuY2xhdmUKPj4gQW4gZW5jbGF2
ZSBpcyBhIFZNLCBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMgdGhlIHByaW1hcnkgVk0sIHRo
YXQKPj4gbGF1bmNoZWQgdGhlIGVuY2xhdmUuIFRoZXkgYXJlIHNpYmxpbmdzLgo+Pgo+PiBIZXJl
IHdlIG5lZWQgdG8gdGhpbmsgb2YgdHdvIGNvbXBvbmVudHM6Cj4+Cj4+IDEuIEFuIGVuY2xhdmUg
YWJzdHJhY3Rpb24gcHJvY2VzcyAtIGEgcHJvY2VzcyBydW5uaW5nIGluIHRoZSBwcmltYXJ5IFZN
Cj4+IGd1ZXN0LCB0aGF0IHVzZXMgdGhlIHByb3ZpZGVkIGlvY3RsIGludGVyZmFjZSBvZiB0aGUg
Tml0cm8gRW5jbGF2ZXMKPj4ga2VybmVsIGRyaXZlciB0byBzcGF3biBhbiBlbmNsYXZlIFZNICh0
aGF0J3MgMiBiZWxvdykuCj4+Cj4+IEhvdyBkb2VzIGFsbCBnZXRzIHRvIGFuIGVuY2xhdmUgVk0g
cnVubmluZyBvbiB0aGUgaG9zdD8KPj4KPj4gVGhlcmUgaXMgYSBOaXRybyBFbmNsYXZlcyBlbXVs
YXRlZCBQQ0kgZGV2aWNlIGV4cG9zZWQgdG8gdGhlIHByaW1hcnkgVk0uCj4+IFRoZSBkcml2ZXIg
Zm9yIHRoaXMgbmV3IFBDSSBkZXZpY2UgaXMgaW5jbHVkZWQgaW4gdGhlIGN1cnJlbnQgcGF0Y2gg
c2VyaWVzLgo+Pgo+PiBUaGUgaW9jdGwgbG9naWMgaXMgbWFwcGVkIHRvIFBDSSBkZXZpY2UgY29t
bWFuZHMgZS5nLiB0aGUKPj4gTkVfRU5DTEFWRV9TVEFSVCBpb2N0bCBtYXBzIHRvIGFuIGVuY2xh
dmUgc3RhcnQgUENJIGNvbW1hbmQgb3IgdGhlCj4+IEtWTV9TRVRfVVNFUl9NRU1PUllfUkVHSU9O
IG1hcHMgdG8gYW4gYWRkIG1lbW9yeSBQQ0kgY29tbWFuZC4KPj4gVGhlIFBDSQo+PiBkZXZpY2Ug
Y29tbWFuZHMgYXJlIHRoZW4gdHJhbnNsYXRlZCBpbnRvIGFjdGlvbnMgdGFrZW4gb24gdGhlIGh5
cGVydmlzb3IKPj4gc2lkZTsgdGhhdCdzIHRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24g
dGhlIGhvc3Qgd2hlcmUgdGhlIHByaW1hcnkKPj4gVk0gaXMgcnVubmluZy4KPj4KPj4gMi4gVGhl
IGVuY2xhdmUgaXRzZWxmIC0gYSBWTSBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMgdGhlIHBy
aW1hcnkgVk0KPj4gdGhhdCBzcGF3bmVkIGl0Lgo+Pgo+PiBUaGUgZW5jbGF2ZSBWTSBoYXMgbm8g
cGVyc2lzdGVudCBzdG9yYWdlIG9yIG5ldHdvcmsgaW50ZXJmYWNlIGF0dGFjaGVkLAo+PiBpdCB1
c2VzIGl0cyBvd24gbWVtb3J5IGFuZCBDUFVzICsgaXRzIHZpcnRpby12c29jayBlbXVsYXRlZCBk
ZXZpY2UgZm9yCj4+IGNvbW11bmljYXRpb24gd2l0aCB0aGUgcHJpbWFyeSBWTS4KPiBzb3VuZHMg
bGlrZSBhIGZpcmVjcmFja2VyIFZNPwoKSXQncyBhIFZNIGNyYWZ0ZWQgZm9yIGVuY2xhdmUgbmVl
ZHMuCgo+Cj4+IFRoZSBtZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1h
cnkgVk0sIHRoZXkgYXJlIGRlZGljYXRlZAo+PiBmb3IgdGhlIGVuY2xhdmUuIFRoZSBOaXRybyBo
eXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZW5zdXJlcyBtZW1vcnkKPj4gYW5kIENQVSBp
c29sYXRpb24gYmV0d2VlbiB0aGUgcHJpbWFyeSBWTSBhbmQgdGhlIGVuY2xhdmUgVk0uCj4gSW4g
bGFzdCBwYXJhZ3JhcGgsIHlvdSBzYWlkIHRoYXQgdGhlIGVuY2xhdmUgVk0gdXNlcyBpdHMgb3du
IG1lbW9yeSBhbmQKPiBDUFVzLiBUaGVuIGhlcmUsIHlvdSBzYWlkIHRoZSBtZW1vcnkvQ1BVcyBh
cmUgY2FydmVkIG91dCBhbmQgZGVkaWNhdGVkCj4gZnJvbSB0aGUgcHJpbWFyeSBWTS4gQ2FuIHlv
dSBlbGFib3JhdGUgd2hpY2ggb25lIGlzIGFjY3VyYXRlPyBvciBhIG1peGVkCj4gbW9kZWw/CgpN
ZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0gYW5kIGFyZSBk
ZWRpY2F0ZWQgZm9yIAp0aGUgZW5jbGF2ZSBWTS4gSSBtZW50aW9uZWQgYWJvdmUgYXMgIml0cyBv
d24iIGluIHRoZSBzZW5zZSB0aGF0IHRoZSAKcHJpbWFyeSBWTSBkb2Vzbid0IHVzZSB0aGVzZSBj
YXJ2ZWQgb3V0IHJlc291cmNlcyB3aGlsZSB0aGUgZW5jbGF2ZSBpcyAKcnVubmluZywgYXMgdGhl
eSBhcmUgZGVkaWNhdGVkIHRvIHRoZSBlbmNsYXZlLgoKSG9wZSB0aGF0IG5vdyBpdCdzIG1vcmUg
Y2xlYXIuCgo+Cj4+Cj4+IFRoZXNlIHR3byBjb21wb25lbnRzIG5lZWQgdG8gcmVmbGVjdCB0aGUg
c2FtZSBzdGF0ZSBlLmcuIHdoZW4gdGhlCj4+IGVuY2xhdmUgYWJzdHJhY3Rpb24gcHJvY2VzcyAo
MSkgaXMgdGVybWluYXRlZCwgdGhlIGVuY2xhdmUgVk0gKDIpIGlzCj4+IHRlcm1pbmF0ZWQgYXMg
d2VsbC4KPj4KPj4gV2l0aCByZWdhcmQgdG8gdGhlIGNvbW11bmljYXRpb24gY2hhbm5lbCwgdGhl
IHByaW1hcnkgVk0gaGFzIGl0cyBvd24KPj4gZW11bGF0ZWQgdmlydGlvLXZzb2NrIFBDSSBkZXZp
Y2UuIFRoZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkCj4+IHZpcnRpby12c29jayBk
ZXZpY2UgYXMgd2VsbC4gVGhpcyBjaGFubmVsIGlzIHVzZWQsIGZvciBleGFtcGxlLCB0byBmZXRj
aAo+PiBkYXRhIGluIHRoZSBlbmNsYXZlIGFuZCB0aGVuIHByb2Nlc3MgaXQuIEFuIGFwcGxpY2F0
aW9uIHRoYXQgc2V0cyB1cCB0aGUKPj4gdnNvY2sgc29ja2V0IGFuZCBjb25uZWN0cyBvciBsaXN0
ZW5zLCBkZXBlbmRpbmcgb24gdGhlIHVzZSBjYXNlLCBpcyB0aGVuCj4+IGRldmVsb3BlZCB0byB1
c2UgdGhpcyBjaGFubmVsOyB0aGlzIGhhcHBlbnMgb24gYm90aCBlbmRzIC0gcHJpbWFyeSBWTQo+
PiBhbmQgZW5jbGF2ZSBWTS4KPiBIb3cgZG9lcyB0aGUgYXBwbGljYXRpb24gaW4gdGhlIHByaW1h
cnkgVk0gYXNzaWduIHRhc2sgdG8gYmUgZXhlY3V0ZWQKPiBpbiB0aGUgZW5jbGF2ZSBWTT8gSSBk
aWRuJ3Qgc2VlIHN1Y2ggY29tbWFuZCBpbiB0aGlzIHNlcmllcywgc28gc3VwcG9zZQo+IGl0IGlz
IGFsc28gY29tbXVuaWNhdGVkIHRocm91Z2ggdmlydGlvLXZzb2NrPwoKVGhlIGFwcGxpY2F0aW9u
IHRoYXQgcnVucyBpbiB0aGUgZW5jbGF2ZSBuZWVkcyB0byBiZSBwYWNrYWdlZCBpbiBhbiAKZW5j
bGF2ZSBpbWFnZSB0b2dldGhlciB3aXRoIHRoZSBPUyAoIGUuZy4ga2VybmVsLCByYW1kaXNrLCBp
bml0ICkgdGhhdCAKd2lsbCBydW4gaW4gdGhlIGVuY2xhdmUgVk0uCgpUaGVuIHRoZSBlbmNsYXZl
IGltYWdlIGlzIGxvYWRlZCBpbiBtZW1vcnkuIEFmdGVyIGJvb3RpbmcgaXMgZmluaXNoZWQsIAp0
aGUgYXBwbGljYXRpb24gc3RhcnRzLiBOb3csIGRlcGVuZGluZyBvbiB0aGUgYXBwIGltcGxlbWVu
dGF0aW9uIGFuZCB1c2UgCmNhc2UsIG9uZSBleGFtcGxlIGNhbiBiZSB0aGF0IHRoZSBhcHAgaW4g
dGhlIGVuY2xhdmUgd2FpdHMgZm9yIGRhdGEgdG8gCmJlIGZldGNoZWQgaW4gdmlhIHRoZSB2c29j
ayBjaGFubmVsLgoKVGhhbmtzLApBbmRyYQoKPgo+PiBMZXQgbWUga25vdyBpZiBmdXJ0aGVyIGNs
YXJpZmljYXRpb25zIGFyZSBuZWVkZWQuCj4+Cj4+Pj4gVGhlIHByb3Bvc2VkIHNvbHV0aW9uIGlz
IGZvbGxvd2luZyB0aGUgS1ZNIG1vZGVsIGFuZCB1c2VzIHRoZSBLVk0gQVBJCj4+IHRvIGJlIGFi
bGUKPj4+PiB0byBjcmVhdGUgYW5kIHNldCByZXNvdXJjZXMgZm9yIGVuY2xhdmVzLiBBbiBhZGRp
dGlvbmFsIGlvY3RsIGNvbW1hbmQsCj4+IGJlc2lkZXMKPj4+PiB0aGUgb25lcyBwcm92aWRlZCBi
eSBLVk0sIGlzIHVzZWQgdG8gc3RhcnQgYW4gZW5jbGF2ZSBhbmQgc2V0dXAgdGhlCj4+IGFkZHJl
c3NpbmcKPj4+PiBmb3IgdGhlIGNvbW11bmljYXRpb24gY2hhbm5lbCBhbmQgYW4gZW5jbGF2ZSB1
bmlxdWUgaWQuCj4+PiBSZXVzaW5nIHNvbWUgS1ZNIGlvY3RscyBpcyBkZWZpbml0ZWx5IGEgZ29v
ZCBpZGVhLCBidXQgSSB3b3VsZG4ndCByZWFsbHkKPj4+IHNheSBpdCdzIHRoZSBLVk0gQVBJIHNp
bmNlIHRoZSBWQ1BVIGZpbGUgZGVzY3JpcHRvciBpcyBiYXNpY2FsbHkgbm9uCj4+PiBmdW5jdGlv
bmFsICh3aXRob3V0IEtWTV9SVU4gYW5kIG1tYXAgaXQncyBub3QgcmVhbGx5IHRoZSBLVk0gQVBJ
KS4KPj4gSXQgdXNlcyBwYXJ0IG9mIHRoZSBLVk0gQVBJIG9yIGEgc2V0IG9mIEtWTSBpb2N0bHMg
dG8gbW9kZWwgdGhlIHdheSBhIFZNCj4+IGlzIGNyZWF0ZWQgLyB0ZXJtaW5hdGVkLiBUaGF0J3Mg
dHJ1ZSwgS1ZNX1JVTiBhbmQgbW1hcC1pbmcgdGhlIHZjcHUgZmQKPj4gYXJlIG5vdCBpbmNsdWRl
ZC4KPj4KPj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2sgcmVnYXJkaW5nIHRoZSByZXVzZSBvZiBL
Vk0gaW9jdGxzLgo+Pgo+PiBBbmRyYQo+Pgo+IFRoYW5rcwo+IEtldmluCgoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBT
Zi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1
LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIy
LzI2MjEvMjAwNS4K

