Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4601B78FC
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgDXPLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:11:17 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:18804 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgDXPLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587741076; x=1619277076;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8Jb7EVV32sM+of0rWYvrUyPXOj40Sl4zB6UzPqKZ4zU=;
  b=VeHDJD9D69UHUVh7xQoEZSZrGXinGOjP+xQGeFxL0QscL99A69gxKyRQ
   NCQ8XwbXfm5FxaBqrbPyqba1pi0TLrErPvhFIxQIADUMu+es7W+P5gJok
   G/MSpAolvfDmkND6n0yldhSZ0d7KTU8Pi8ASWDGGjKKhs1oEY1UqpSZId
   g=;
IronPort-SDR: jHprymWSpAyeRoaNoJvLQC3dXrc+OXCAOwBRM+Ies5jnMbh/9T6vqEH4uBAWO+aWu343tQmgtD
 INpY1h1e+0og==
X-IronPort-AV: E=Sophos;i="5.73,311,1583193600"; 
   d="scan'208";a="40701760"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Apr 2020 15:11:14 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 3951BA0732;
        Fri, 24 Apr 2020 15:11:13 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 15:11:12 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 15:11:05 +0000
Subject: Re: [PATCH v1 02/15] nitro_enclaves: Define the PCI device interface
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>
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
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-3-andraprs@amazon.com>
 <bfbb7242-b818-337d-4cff-fc48b7bb1cc0@redhat.com>
 <b4c58884-987a-0be0-8fa1-9aa8efa3e874@amazon.com>
Message-ID: <f936d026-65cd-2632-2ffa-041d1430fb28@amazon.com>
Date:   Fri, 24 Apr 2020 18:10:54 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b4c58884-987a-0be0-8fa1-9aa8efa3e874@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy8wNC8yMDIwIDE2OjM3LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Cj4K
PiBPbiAyMi8wNC8yMDIwIDAwOjIyLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+PiBPbiAyMS8wNC8y
MCAyMDo0MSwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+Pj4gVGhlIE5pdHJvIEVuY2xhdmVzIChO
RSkgZHJpdmVyIGNvbW11bmljYXRlcyB3aXRoIGEgbmV3IFBDSSBkZXZpY2UsIHRoYXQKPj4+IGlz
IGV4cG9zZWQgdG8gYSB2aXJ0dWFsIG1hY2hpbmUgKFZNKSBhbmQgaGFuZGxlcyBjb21tYW5kcyBt
ZWFudCBmb3IKPj4+IGhhbmRsaW5nIGVuY2xhdmVzIGxpZmV0aW1lIGUuZy4gY3JlYXRpb24sIHRl
cm1pbmF0aW9uLCBzZXR0aW5nIG1lbW9yeQo+Pj4gcmVnaW9ucy4gVGhlIGNvbW11bmljYXRpb24g
d2l0aCB0aGUgUENJIGRldmljZSBpcyBoYW5kbGVkIHVzaW5nIGEgTU1JTwo+Pj4gc3BhY2UgYW5k
IE1TSS1YIGludGVycnVwdHMuCj4+Pgo+Pj4gVGhpcyBkZXZpY2UgY29tbXVuaWNhdGVzIHdpdGgg
dGhlIGh5cGVydmlzb3Igb24gdGhlIGhvc3QsIHdoZXJlIHRoZSBWTQo+Pj4gdGhhdCBzcGF3bmVk
IHRoZSBlbmNsYXZlIGl0c2VsZiBydW4sIGUuZy4gdG8gbGF1bmNoIGEgVk0gdGhhdCBpcyB1c2Vk
Cj4+PiBmb3IgdGhlIGVuY2xhdmUuCj4+Pgo+Pj4gRGVmaW5lIHRoZSBNTUlPIHNwYWNlIG9mIHRo
ZSBQQ0kgZGV2aWNlLCB0aGUgY29tbWFuZHMgdGhhdCBhcmUKPj4+IHByb3ZpZGVkIGJ5IHRoaXMg
ZGV2aWNlLiBBZGQgYW4gaW50ZXJuYWwgZGF0YSBzdHJ1Y3R1cmUgdXNlZCBhcyBwcml2YXRlCj4+
PiBkYXRhIGZvciB0aGUgUENJIGRldmljZSBkcml2ZXIgYW5kIHRoZSBmdW5jdGlvbnMgZm9yIHRo
ZSBQQ0kgZGV2aWNlIAo+Pj4gaW5pdAo+Pj4gLyB1bmluaXQgYW5kIGNvbW1hbmQgcmVxdWVzdHMg
aGFuZGxpbmcuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1LUNhdGFsaW4gVmFzaWxl
IDxsZXhudkBhbWF6b24uY29tPgo+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IENpb2JvdGFy
dSA8YWxjaW9hQGFtYXpvbi5jb20+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYg
PGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+PiAtLS0KPj4+IMKgIC4uLi92aXJ0L2FtYXpvbi9uaXRy
b19lbmNsYXZlcy9uZV9wY2lfZGV2LmjCoMKgIHwgMjY2IAo+Pj4gKysrKysrKysrKysrKysrKysr
Cj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMjY2IGluc2VydGlvbnMoKykKPj4+IMKgIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL3ZpcnQvYW1hem9uL25pdHJvX2VuY2xhdmVzL25lX3BjaV9kZXYu
aAo+PiBDYW4gdGhpcyBiZSBwbGFjZWQganVzdCBpbiBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2
ZXMsIG9yCj4+IGRyaXZlcnMvdmlydC9lbmNsYXZlL25pdHJvP8KgIEl0J3Mgbm90IHVubGlrZWx5
IHRoYXQgdGhpcyBkZXZpY2UgYmUKPj4gaW1wbGVtZW50ZWQgb3V0c2lkZSBFQzIgc29vbmVyIG9y
IGxhdGVyLCBhbmQgdGhlcmUncyBub3RoaW5nCj4+IEFtYXpvbi1zcGVjaWZpYyBhcyBmYXIgYXMg
SSBjYW4gc2VlIGZyb20gdGhlIFVBUEkuCj4KPiBJIGNhbiB1cGRhdGUgdGhlIHBhdGggdG8gZHJp
dmVycy92aXJ0L25pdHJvX2VuY2xhdmVzLgo+Cj4gVGhlIFBDSSBkZXZpY2UgaW4gdGhlIHBhdGNo
IHNlcmllcyBpcyByZWdpc3RlcmVkIHVuZGVyIEFtYXpvbiBQQ0kgCj4gVmVuZG9yIElEIGFuZCBp
dCBoYXMgdGhpcyBQQ0kgRGV2aWNlIElEIC0gMHhlNGMxLgoKdjIgbm93IGluY2x1ZGVzIHRoZSB1
cGRhdGVkIHBhdGggLSBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMuCgpUaGFua3MsCkFuZHJh
CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJl
ZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNp
IENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJh
dGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

