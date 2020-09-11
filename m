Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F256F26637F
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIKQSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:18:00 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:59807 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgIKQRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 12:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599841068; x=1631377068;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=jojQMQdjivPmHtUkXjBK3yH06Ho2uoYNPaYolOiGpmA=;
  b=RRsJg6VZ6KpKN7hLq43z7iNg44E0l7KwVp7P3jmfgLIVG+Xw8ij0vDb5
   yi3vx1VtjtS+tlM8cS7KAkNxPI/2ppzzx7Tu425+zWKWRzbICLVizQ5El
   lIId7OxX8DWnxiPqcITcbFID7/5Ur631gI6KzS2UlzN9fSpvPgNDE/MjA
   U=;
X-IronPort-AV: E=Sophos;i="5.76,416,1592870400"; 
   d="scan'208";a="54864313"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Sep 2020 16:17:45 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id AA9C92218FA;
        Fri, 11 Sep 2020 16:17:44 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 16:17:34 +0000
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-18-andraprs@amazon.com>
 <20200907090126.GD1101646@kroah.com>
 <44a8a921-1fb4-87ab-b8f2-c168c615dbbd@amazon.com>
 <20200907140803.GA3719869@kroah.com>
 <b8a1e66c-7674-7354-599e-159efd260ba9@amazon.com>
 <310abd0d-60e7-a52c-fcae-cf98ac474e32@amazon.com>
 <20200911151213.GB3821769@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b4e00a55-403d-b85c-abfe-3af0aeebe793@amazon.com>
Date:   Fri, 11 Sep 2020 19:17:24 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911151213.GB3821769@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D41UWB004.ant.amazon.com (10.43.161.135) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxMS8wOS8yMDIwIDE4OjEyLCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gRnJpLCBTZXAgMTEs
IDIwMjAgYXQgMDU6NTY6MTBQTSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToK
Pj4KPj4gT24gMDcvMDkvMjAyMCAxODoxMywgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToK
Pj4+Cj4+PiBPbiAwNy8wOS8yMDIwIDE3OjA4LCBHcmVnIEtIIHdyb3RlOgo+Pj4+IE9uIE1vbiwg
U2VwIDA3LCAyMDIwIGF0IDA0OjQzOjExUE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEg
d3JvdGU6Cj4+Pj4+IE9uIDA3LzA5LzIwMjAgMTI6MDEsIEdyZWcgS0ggd3JvdGU6Cj4+Pj4+PiBP
biBGcmksIFNlcCAwNCwgMjAyMCBhdCAwODozNzoxN1BNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYg
d3JvdGU6Cj4+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0Bh
bWF6b24uY29tPgo+Pj4+Pj4+IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6
b24uY29tPgo+Pj4+Pj4+IC0tLQo+Pj4+Pj4+IENoYW5nZWxvZwo+Pj4+Pj4+Cj4+Pj4+Pj4gdjcg
LT4gdjgKPj4+Pj4+Pgo+Pj4+Pj4+ICogQWRkIGluZm8gYWJvdXQgdGhlIHByaW1hcnkgLyBwYXJl
bnQgVk0gQ0lEIHZhbHVlLgo+Pj4+Pj4+ICogVXBkYXRlIHJlZmVyZW5jZSBsaW5rIGZvciBodWdl
IHBhZ2VzLgo+Pj4+Pj4+ICogQWRkIHJlZmVyZW5jZSBsaW5rIGZvciB0aGUgeDg2IGJvb3QgcHJv
dG9jb2wuCj4+Pj4+Pj4gKiBBZGQgbGljZW5zZSBtZW50aW9uIGFuZCB1cGRhdGUgZG9jIHRpdGxl
IC8gY2hhcHRlciBmb3JtYXR0aW5nLgo+Pj4+Pj4+Cj4+Pj4+Pj4gdjYgLT4gdjcKPj4+Pj4+Pgo+
Pj4+Pj4+ICogTm8gY2hhbmdlcy4KPj4+Pj4+Pgo+Pj4+Pj4+IHY1IC0+IHY2Cj4+Pj4+Pj4KPj4+
Pj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4+Pj4KPj4+Pj4+PiB2NCAtPiB2NQo+Pj4+Pj4+Cj4+Pj4+
Pj4gKiBObyBjaGFuZ2VzLgo+Pj4+Pj4+Cj4+Pj4+Pj4gdjMgLT4gdjQKPj4+Pj4+Pgo+Pj4+Pj4+
ICogVXBkYXRlIGRvYyB0eXBlIGZyb20gLnR4dCB0byAucnN0Lgo+Pj4+Pj4+ICogVXBkYXRlIGRv
Y3VtZW50YXRpb24gYmFzZWQgb24gdGhlIGNoYW5nZXMgZnJvbSB2NC4KPj4+Pj4+Pgo+Pj4+Pj4+
IHYyIC0+IHYzCj4+Pj4+Pj4KPj4+Pj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4+Pj4KPj4+Pj4+PiB2
MSAtPiB2Mgo+Pj4+Pj4+Cj4+Pj4+Pj4gKiBOZXcgaW4gdjIuCj4+Pj4+Pj4gLS0tCj4+Pj4+Pj4g
ICAgIERvY3VtZW50YXRpb24vbml0cm9fZW5jbGF2ZXMvbmVfb3ZlcnZpZXcucnN0IHwgOTUKPj4+
Pj4+PiArKysrKysrKysrKysrKysrKysrKwo+Pj4+Pj4+ICAgICAxIGZpbGUgY2hhbmdlZCwgOTUg
aW5zZXJ0aW9ucygrKQo+Pj4+Pj4+ICAgICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlv
bi9uaXRyb19lbmNsYXZlcy9uZV9vdmVydmlldy5yc3QKPj4+Pj4+IEEgd2hvbGUgbmV3IHN1YmRp
ciwgZm9yIGEgc2luZ2xlIGRyaXZlciwgYW5kIG5vdCB0aWVkIGludG8gdGhlIGtlcm5lbAo+Pj4+
Pj4gZG9jdW1lbnRhdGlvbiBidWlsZCBwcm9jZXNzIGF0IGFsbD8gIE5vdCBnb29kIDooCj4+Pj4+
Pgo+Pj4+PiBXb3VsZCB0aGUgInZpcnQiIGRpcmVjdG9yeSBiZSBhIGJldHRlciBvcHRpb24gZm9y
IHRoaXMgZG9jIGZpbGU/Cj4+Pj4gWWVzLgo+Pj4gQWxyaWdodCwgSSdsbCB1cGRhdGUgdGhlIGRv
YyBmaWxlIGxvY2F0aW9uLCB0aGUgaW5kZXggZmlsZSBhbmQgdGhlCj4+PiBNQUlOVEFJTkVSUyBl
bnRyeSB0byByZWZsZWN0IHRoZSBuZXcgZG9jIGZpbGUgbG9jYXRpb24uCj4+Pgo+PiBJIHNlbnQg
b3V0IGEgbmV3IHJldmlzaW9uIHRoYXQgaW5jbHVkZXMgdGhlIHVwZGF0ZXMgYmFzZWQgb24geW91
ciBmZWVkYmFjay4KPj4gVGhhbmtzIGZvciByZXZpZXcuCj4+Cj4+IFRvIGJlIGF3YXJlIG9mIHRo
aXMgYmVmb3JlaGFuZCwgd2hhdCB3b3VsZCBiZSB0aGUgZnVydGhlciBuZWNlc3Nhcnkgc3RlcHMK
Pj4gKGUuZy4gbGludXgtbmV4dCBicmFuY2gsIGFkZGl0aW9uYWwgcmV2aWV3IGFuZCAvIG9yIHNh
bml0eSBjaGVja3MpIHRvCj4+IGNvbnNpZGVyIGZvciB0YXJnZXRpbmcgdGhlIG5leHQgbWVyZ2Ug
d2luZG93Pwo+IElmIGFsbCBsb29rcyBnb29kLCBJIGNhbiBqdXN0IHN1Y2sgaXQgaW50byBteSBj
aGFyLW1pc2MgYnJhbmNoIHRvIGdldCBpdAo+IGludG8gNS4xMC1yYzEuICBJJ2xsIGxvb2sgYXQg
dGhlIHNlcmllcyBuZXh0IHdlZWssIHRoYW5rcy4KPgoKT2ssIGxldCdzIGRvIHRoaXMgd2F5IHRo
ZW4sIHRoYW5rcyBmb3IgaW5mby4KCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIg
KFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQs
IFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lz
dGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

