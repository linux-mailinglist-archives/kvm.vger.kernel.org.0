Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947131B5CB2
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgDWNiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:38:02 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1574 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgDWNiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 09:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587649081; x=1619185081;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Y9aGPqiE8AiYife+DAC5h+JeHH6fdk3CeaCQveLN/js=;
  b=UENVnwl63HGqpxE/ZElZMFPIAaKbnagT/VcS9mIJvIwMV821RL2o7mca
   FOx9W5zVzsj0tfxSWBnXHi6QTeEPukq2qrEUjyZsRCe2xRHvUiVvI6xWz
   qqpQOpLEgNmckBRsMjIs2oFiEs0s1o0qxSs0pU7xnwdNSRqXdODut8hjF
   k=;
IronPort-SDR: dg1Dvc6haaaaoERbJscndWiV8LRsI90q9W6nyLxB/N1O5k4C/3T8JFoHHtWnlOYbRGdMbZ4FOd
 voC3/QZkOO+A==
X-IronPort-AV: E=Sophos;i="5.73,307,1583193600"; 
   d="scan'208";a="40445730"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Apr 2020 13:37:59 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 2648CA2193;
        Thu, 23 Apr 2020 13:37:58 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 13:37:57 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 13:37:49 +0000
Subject: Re: [PATCH v1 02/15] nitro_enclaves: Define the PCI device interface
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b4c58884-987a-0be0-8fa1-9aa8efa3e874@amazon.com>
Date:   Thu, 23 Apr 2020 16:37:44 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bfbb7242-b818-337d-4cff-fc48b7bb1cc0@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D16UWC001.ant.amazon.com (10.43.162.117) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNC8yMDIwIDAwOjIyLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIxLzA0LzIw
IDIwOjQxLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+IFRoZSBOaXRybyBFbmNsYXZlcyAoTkUp
IGRyaXZlciBjb21tdW5pY2F0ZXMgd2l0aCBhIG5ldyBQQ0kgZGV2aWNlLCB0aGF0Cj4+IGlzIGV4
cG9zZWQgdG8gYSB2aXJ0dWFsIG1hY2hpbmUgKFZNKSBhbmQgaGFuZGxlcyBjb21tYW5kcyBtZWFu
dCBmb3IKPj4gaGFuZGxpbmcgZW5jbGF2ZXMgbGlmZXRpbWUgZS5nLiBjcmVhdGlvbiwgdGVybWlu
YXRpb24sIHNldHRpbmcgbWVtb3J5Cj4+IHJlZ2lvbnMuIFRoZSBjb21tdW5pY2F0aW9uIHdpdGgg
dGhlIFBDSSBkZXZpY2UgaXMgaGFuZGxlZCB1c2luZyBhIE1NSU8KPj4gc3BhY2UgYW5kIE1TSS1Y
IGludGVycnVwdHMuCj4+Cj4+IFRoaXMgZGV2aWNlIGNvbW11bmljYXRlcyB3aXRoIHRoZSBoeXBl
cnZpc29yIG9uIHRoZSBob3N0LCB3aGVyZSB0aGUgVk0KPj4gdGhhdCBzcGF3bmVkIHRoZSBlbmNs
YXZlIGl0c2VsZiBydW4sIGUuZy4gdG8gbGF1bmNoIGEgVk0gdGhhdCBpcyB1c2VkCj4+IGZvciB0
aGUgZW5jbGF2ZS4KPj4KPj4gRGVmaW5lIHRoZSBNTUlPIHNwYWNlIG9mIHRoZSBQQ0kgZGV2aWNl
LCB0aGUgY29tbWFuZHMgdGhhdCBhcmUKPj4gcHJvdmlkZWQgYnkgdGhpcyBkZXZpY2UuIEFkZCBh
biBpbnRlcm5hbCBkYXRhIHN0cnVjdHVyZSB1c2VkIGFzIHByaXZhdGUKPj4gZGF0YSBmb3IgdGhl
IFBDSSBkZXZpY2UgZHJpdmVyIGFuZCB0aGUgZnVuY3Rpb25zIGZvciB0aGUgUENJIGRldmljZSBp
bml0Cj4+IC8gdW5pbml0IGFuZCBjb21tYW5kIHJlcXVlc3RzIGhhbmRsaW5nLgo+Pgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbGV4YW5kcnUtQ2F0YWxpbiBWYXNpbGUgPGxleG52QGFtYXpvbi5jb20+Cj4+
IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBDaW9ib3RhcnUgPGFsY2lvYUBhbWF6b24uY29tPgo+
PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+
IC0tLQo+PiAgIC4uLi92aXJ0L2FtYXpvbi9uaXRyb19lbmNsYXZlcy9uZV9wY2lfZGV2LmggICB8
IDI2NiArKysrKysrKysrKysrKysrKysKPj4gICAxIGZpbGUgY2hhbmdlZCwgMjY2IGluc2VydGlv
bnMoKykKPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy92aXJ0L2FtYXpvbi9uaXRyb19l
bmNsYXZlcy9uZV9wY2lfZGV2LmgKPiBDYW4gdGhpcyBiZSBwbGFjZWQganVzdCBpbiBkcml2ZXJz
L3ZpcnQvbml0cm9fZW5jbGF2ZXMsIG9yCj4gZHJpdmVycy92aXJ0L2VuY2xhdmUvbml0cm8/ICBJ
dCdzIG5vdCB1bmxpa2VseSB0aGF0IHRoaXMgZGV2aWNlIGJlCj4gaW1wbGVtZW50ZWQgb3V0c2lk
ZSBFQzIgc29vbmVyIG9yIGxhdGVyLCBhbmQgdGhlcmUncyBub3RoaW5nCj4gQW1hem9uLXNwZWNp
ZmljIGFzIGZhciBhcyBJIGNhbiBzZWUgZnJvbSB0aGUgVUFQSS4KCkkgY2FuIHVwZGF0ZSB0aGUg
cGF0aCB0byBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMuCgpUaGUgUENJIGRldmljZSBpbiB0
aGUgcGF0Y2ggc2VyaWVzIGlzIHJlZ2lzdGVyZWQgdW5kZXIgQW1hem9uIFBDSSBWZW5kb3IgCklE
IGFuZCBpdCBoYXMgdGhpcyBQQ0kgRGV2aWNlIElEIC0gMHhlNGMxLgoKVGhhbmtzLApBbmRyYQoK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQg
b2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

