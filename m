Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2961B6FA9
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 10:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDXIUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 04:20:00 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:21953 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgDXIT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 04:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587716398; x=1619252398;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=TXFnlEVEDU78EXiEMVImLIntv7UP4r00mvJOb5cx6Ks=;
  b=OdW7gT0LQjQ3JpDd8fnRM8dnt4HhMrHOgiRDM3jF4W1YkZkZPQD7875P
   57/s3z/PyQiY8alcPUCjwcIFbY6gv8N3UkC2Xp7rG1DvNbmSn9bojUyTj
   uEILSJ/Euv9KT37vdQ2ATZyzCsXx08RDCsqO2vDoBbxLTnshps24ZgEoq
   8=;
IronPort-SDR: NJ+R3Myr8HE7d3UMEF7a5axtFkVzwaYrSo66mji2JnlEffg558Cbgx402zlrmjj8YReWdZFfH/
 XGwW/kwFuzJQ==
X-IronPort-AV: E=Sophos;i="5.73,310,1583193600"; 
   d="scan'208";a="27432411"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 24 Apr 2020 08:19:43 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 5D9F3A18EB;
        Fri, 24 Apr 2020 08:19:42 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 08:19:41 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.203) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 08:19:32 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7ac3f702-9c5f-5021-ebe3-42f1c93afbdf@amazon.com>
Date:   Fri, 24 Apr 2020 11:19:21 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2aa9c865-61c1-fc73-c85d-6627738d2d24@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC8wNC8yMDIwIDA2OjA0LCBMb25ncGVuZyAoTWlrZSwgQ2xvdWQgSW5mcmFzdHJ1Y3R1
cmUgU2VydmljZSAKUHJvZHVjdCBEZXB0Likgd3JvdGU6Cj4gT24gMjAyMC80LzIzIDIxOjE5LCBQ
YXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Pgo+PiBPbiAyMi8wNC8yMDIwIDAwOjQ2LCBQ
YW9sbyBCb256aW5pIHdyb3RlOgo+Pj4gT24gMjEvMDQvMjAgMjA6NDEsIEFuZHJhIFBhcmFzY2hp
diB3cm90ZToKPj4+PiBBbiBlbmNsYXZlIGNvbW11bmljYXRlcyB3aXRoIHRoZSBwcmltYXJ5IFZN
IHZpYSBhIGxvY2FsIGNvbW11bmljYXRpb24gY2hhbm5lbCwKPj4+PiB1c2luZyB2aXJ0aW8tdnNv
Y2sgWzJdLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgYSBkaXNrIG9yIGEgbmV0d29yayBkZXZp
Y2UKPj4+PiBhdHRhY2hlZC4KPj4+IElzIGl0IHBvc3NpYmxlIHRvIGhhdmUgYSBzYW1wbGUgb2Yg
dGhpcyBpbiB0aGUgc2FtcGxlcy8gZGlyZWN0b3J5Pwo+PiBJIGNhbiBhZGQgaW4gdjIgYSBzYW1w
bGUgZmlsZSBpbmNsdWRpbmcgdGhlIGJhc2ljIGZsb3cgb2YgaG93IHRvIHVzZSB0aGUgaW9jdGwK
Pj4gaW50ZXJmYWNlIHRvIGNyZWF0ZSAvIHRlcm1pbmF0ZSBhbiBlbmNsYXZlLgo+Pgo+PiBUaGVu
IHdlIGNhbiB1cGRhdGUgLyBidWlsZCBvbiB0b3AgaXQgYmFzZWQgb24gdGhlIG9uZ29pbmcgZGlz
Y3Vzc2lvbnMgb24gdGhlCj4+IHBhdGNoIHNlcmllcyBhbmQgdGhlIHJlY2VpdmVkIGZlZWRiYWNr
Lgo+Pgo+Pj4gSSBhbSBpbnRlcmVzdGVkIGVzcGVjaWFsbHkgaW46Cj4+Pgo+Pj4gLSB0aGUgaW5p
dGlhbCBDUFUgc3RhdGU6IENQTDAgdnMuIENQTDMsIGluaXRpYWwgcHJvZ3JhbSBjb3VudGVyLCBl
dGMuCj4+Pgo+Pj4gLSB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsOyBkb2VzIHRoZSBlbmNsYXZl
IHNlZSB0aGUgdXN1YWwgbG9jYWwgQVBJQwo+Pj4gYW5kIElPQVBJQyBpbnRlcmZhY2VzIGluIG9y
ZGVyIHRvIGdldCBpbnRlcnJ1cHRzIGZyb20gdmlydGlvLXZzb2NrLCBhbmQKPj4+IHdoZXJlIGlz
IHRoZSB2aXJ0aW8tdnNvY2sgZGV2aWNlICh2aXJ0aW8tbW1pbyBJIHN1cHBvc2UpIHBsYWNlZCBp
biBtZW1vcnk/Cj4+Pgo+Pj4gLSB3aGF0IHRoZSBlbmNsYXZlIGlzIGFsbG93ZWQgdG8gZG86IGNh
biBpdCBjaGFuZ2UgcHJpdmlsZWdlIGxldmVscywKPj4+IHdoYXQgaGFwcGVucyBpZiB0aGUgZW5j
bGF2ZSBwZXJmb3JtcyBhbiBhY2Nlc3MgdG8gbm9uZXhpc3RlbnQgbWVtb3J5LCBldGMuCj4+Pgo+
Pj4gLSB3aGV0aGVyIHRoZXJlIGFyZSBzcGVjaWFsIGh5cGVyY2FsbCBpbnRlcmZhY2VzIGZvciB0
aGUgZW5jbGF2ZQo+PiBBbiBlbmNsYXZlIGlzIGEgVk0sIHJ1bm5pbmcgb24gdGhlIHNhbWUgaG9z
dCBhcyB0aGUgcHJpbWFyeSBWTSwgdGhhdCBsYXVuY2hlZAo+PiB0aGUgZW5jbGF2ZS4gVGhleSBh
cmUgc2libGluZ3MuCj4+Cj4+IEhlcmUgd2UgbmVlZCB0byB0aGluayBvZiB0d28gY29tcG9uZW50
czoKPj4KPj4gMS4gQW4gZW5jbGF2ZSBhYnN0cmFjdGlvbiBwcm9jZXNzIC0gYSBwcm9jZXNzIHJ1
bm5pbmcgaW4gdGhlIHByaW1hcnkgVk0gZ3Vlc3QsCj4+IHRoYXQgdXNlcyB0aGUgcHJvdmlkZWQg
aW9jdGwgaW50ZXJmYWNlIG9mIHRoZSBOaXRybyBFbmNsYXZlcyBrZXJuZWwgZHJpdmVyIHRvCj4+
IHNwYXduIGFuIGVuY2xhdmUgVk0gKHRoYXQncyAyIGJlbG93KS4KPj4KPj4gSG93IGRvZXMgYWxs
IGdldHMgdG8gYW4gZW5jbGF2ZSBWTSBydW5uaW5nIG9uIHRoZSBob3N0Pwo+Pgo+PiBUaGVyZSBp
cyBhIE5pdHJvIEVuY2xhdmVzIGVtdWxhdGVkIFBDSSBkZXZpY2UgZXhwb3NlZCB0byB0aGUgcHJp
bWFyeSBWTS4gVGhlCj4+IGRyaXZlciBmb3IgdGhpcyBuZXcgUENJIGRldmljZSBpcyBpbmNsdWRl
ZCBpbiB0aGUgY3VycmVudCBwYXRjaCBzZXJpZXMuCj4+Cj4gSGkgUGFyYXNjaGl2LAo+Cj4gVGhl
IG5ldyBQQ0kgZGV2aWNlIGlzIGVtdWxhdGVkIGluIFFFTVUgPyBJZiBzbywgaXMgdGhlcmUgYW55
IHBsYW4gdG8gc2VuZCB0aGUKPiBRRU1VIGNvZGUgPwoKSGksCgpOb3BlLCBub3QgdGhhdCBJIGtu
b3cgb2Ygc28gZmFyLgoKVGhhbmtzLApBbmRyYQoKPgo+PiBUaGUgaW9jdGwgbG9naWMgaXMgbWFw
cGVkIHRvIFBDSSBkZXZpY2UgY29tbWFuZHMgZS5nLiB0aGUgTkVfRU5DTEFWRV9TVEFSVCBpb2N0
bAo+PiBtYXBzIHRvIGFuIGVuY2xhdmUgc3RhcnQgUENJIGNvbW1hbmQgb3IgdGhlIEtWTV9TRVRf
VVNFUl9NRU1PUllfUkVHSU9OIG1hcHMgdG8KPj4gYW4gYWRkIG1lbW9yeSBQQ0kgY29tbWFuZC4g
VGhlIFBDSSBkZXZpY2UgY29tbWFuZHMgYXJlIHRoZW4gdHJhbnNsYXRlZCBpbnRvCj4+IGFjdGlv
bnMgdGFrZW4gb24gdGhlIGh5cGVydmlzb3Igc2lkZTsgdGhhdCdzIHRoZSBOaXRybyBoeXBlcnZp
c29yIHJ1bm5pbmcgb24gdGhlCj4+IGhvc3Qgd2hlcmUgdGhlIHByaW1hcnkgVk0gaXMgcnVubmlu
Zy4KPj4KPj4gMi4gVGhlIGVuY2xhdmUgaXRzZWxmIC0gYSBWTSBydW5uaW5nIG9uIHRoZSBzYW1l
IGhvc3QgYXMgdGhlIHByaW1hcnkgVk0gdGhhdAo+PiBzcGF3bmVkIGl0Lgo+Pgo+PiBUaGUgZW5j
bGF2ZSBWTSBoYXMgbm8gcGVyc2lzdGVudCBzdG9yYWdlIG9yIG5ldHdvcmsgaW50ZXJmYWNlIGF0
dGFjaGVkLCBpdCB1c2VzCj4+IGl0cyBvd24gbWVtb3J5IGFuZCBDUFVzICsgaXRzIHZpcnRpby12
c29jayBlbXVsYXRlZCBkZXZpY2UgZm9yIGNvbW11bmljYXRpb24KPj4gd2l0aCB0aGUgcHJpbWFy
eSBWTS4KPj4KPj4gVGhlIG1lbW9yeSBhbmQgQ1BVcyBhcmUgY2FydmVkIG91dCBvZiB0aGUgcHJp
bWFyeSBWTSwgdGhleSBhcmUgZGVkaWNhdGVkIGZvciB0aGUKPj4gZW5jbGF2ZS4gVGhlIE5pdHJv
IGh5cGVydmlzb3IgcnVubmluZyBvbiB0aGUgaG9zdCBlbnN1cmVzIG1lbW9yeSBhbmQgQ1BVCj4+
IGlzb2xhdGlvbiBiZXR3ZWVuIHRoZSBwcmltYXJ5IFZNIGFuZCB0aGUgZW5jbGF2ZSBWTS4KPj4K
Pj4KPj4gVGhlc2UgdHdvIGNvbXBvbmVudHMgbmVlZCB0byByZWZsZWN0IHRoZSBzYW1lIHN0YXRl
IGUuZy4gd2hlbiB0aGUgZW5jbGF2ZQo+PiBhYnN0cmFjdGlvbiBwcm9jZXNzICgxKSBpcyB0ZXJt
aW5hdGVkLCB0aGUgZW5jbGF2ZSBWTSAoMikgaXMgdGVybWluYXRlZCBhcyB3ZWxsLgo+Pgo+PiBX
aXRoIHJlZ2FyZCB0byB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsLCB0aGUgcHJpbWFyeSBWTSBo
YXMgaXRzIG93biBlbXVsYXRlZAo+PiB2aXJ0aW8tdnNvY2sgUENJIGRldmljZS4gVGhlIGVuY2xh
dmUgVk0gaGFzIGl0cyBvd24gZW11bGF0ZWQgdmlydGlvLXZzb2NrIGRldmljZQo+PiBhcyB3ZWxs
LiBUaGlzIGNoYW5uZWwgaXMgdXNlZCwgZm9yIGV4YW1wbGUsIHRvIGZldGNoIGRhdGEgaW4gdGhl
IGVuY2xhdmUgYW5kCj4+IHRoZW4gcHJvY2VzcyBpdC4gQW4gYXBwbGljYXRpb24gdGhhdCBzZXRz
IHVwIHRoZSB2c29jayBzb2NrZXQgYW5kIGNvbm5lY3RzIG9yCj4+IGxpc3RlbnMsIGRlcGVuZGlu
ZyBvbiB0aGUgdXNlIGNhc2UsIGlzIHRoZW4gZGV2ZWxvcGVkIHRvIHVzZSB0aGlzIGNoYW5uZWw7
IHRoaXMKPj4gaGFwcGVucyBvbiBib3RoIGVuZHMgLSBwcmltYXJ5IFZNIGFuZCBlbmNsYXZlIFZN
Lgo+Pgo+PiBMZXQgbWUga25vdyBpZiBmdXJ0aGVyIGNsYXJpZmljYXRpb25zIGFyZSBuZWVkZWQu
Cj4+Cj4+Pj4gVGhlIHByb3Bvc2VkIHNvbHV0aW9uIGlzIGZvbGxvd2luZyB0aGUgS1ZNIG1vZGVs
IGFuZCB1c2VzIHRoZSBLVk0gQVBJIHRvIGJlIGFibGUKPj4+PiB0byBjcmVhdGUgYW5kIHNldCBy
ZXNvdXJjZXMgZm9yIGVuY2xhdmVzLiBBbiBhZGRpdGlvbmFsIGlvY3RsIGNvbW1hbmQsIGJlc2lk
ZXMKPj4+PiB0aGUgb25lcyBwcm92aWRlZCBieSBLVk0sIGlzIHVzZWQgdG8gc3RhcnQgYW4gZW5j
bGF2ZSBhbmQgc2V0dXAgdGhlIGFkZHJlc3NpbmcKPj4+PiBmb3IgdGhlIGNvbW11bmljYXRpb24g
Y2hhbm5lbCBhbmQgYW4gZW5jbGF2ZSB1bmlxdWUgaWQuCj4+PiBSZXVzaW5nIHNvbWUgS1ZNIGlv
Y3RscyBpcyBkZWZpbml0ZWx5IGEgZ29vZCBpZGVhLCBidXQgSSB3b3VsZG4ndCByZWFsbHkKPj4+
IHNheSBpdCdzIHRoZSBLVk0gQVBJIHNpbmNlIHRoZSBWQ1BVIGZpbGUgZGVzY3JpcHRvciBpcyBi
YXNpY2FsbHkgbm9uCj4+PiBmdW5jdGlvbmFsICh3aXRob3V0IEtWTV9SVU4gYW5kIG1tYXAgaXQn
cyBub3QgcmVhbGx5IHRoZSBLVk0gQVBJKS4KPj4gSXQgdXNlcyBwYXJ0IG9mIHRoZSBLVk0gQVBJ
IG9yIGEgc2V0IG9mIEtWTSBpb2N0bHMgdG8gbW9kZWwgdGhlIHdheSBhIFZNIGlzCj4+IGNyZWF0
ZWQgLyB0ZXJtaW5hdGVkLiBUaGF0J3MgdHJ1ZSwgS1ZNX1JVTiBhbmQgbW1hcC1pbmcgdGhlIHZj
cHUgZmQgYXJlIG5vdAo+PiBpbmNsdWRlZC4KPj4KPj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2sg
cmVnYXJkaW5nIHRoZSByZXVzZSBvZiBLVk0gaW9jdGxzLgo+Pgo+PiBBbmRyYQo+Pgo+Pgo+Pgo+
Pgo+PiBBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJl
ZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIKPj4gU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJ
YXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluCj4+IFJvbWFuaWEuIFJl
Z2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBD
ZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBT
dHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEu
IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1
Lgo=

