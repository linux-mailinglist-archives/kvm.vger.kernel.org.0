Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5872665FC
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgIKRT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:19:29 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:28123 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgIKO6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 10:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599836302; x=1631372302;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Zo2DwoqnHvBuH56xIWns6eaxEfl/ZPGVsEI+Qq68jw0=;
  b=Flkd2/CG+0SfTbwDHRRTUWIArXHtEQ5q6UDymdJhml3rrP3zpgQpFJ1q
   zamRdDIenlUBOjX6cTDJ1J0gDSKkKSc3RTMBexZpWbgjZ7NYQh6JoSHKW
   6TCih1Zis1jm2MrgJT2QoA3b5bEYvTIxsz8tf2+RJhT+5EgoW3G+pcsgy
   k=;
X-IronPort-AV: E=Sophos;i="5.76,415,1592870400"; 
   d="scan'208";a="75441519"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Sep 2020 14:56:34 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 1CD94282592;
        Fri, 11 Sep 2020 14:56:30 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.244) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 14:56:22 +0000
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
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
Message-ID: <310abd0d-60e7-a52c-fcae-cf98ac474e32@amazon.com>
Date:   Fri, 11 Sep 2020 17:56:10 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <b8a1e66c-7674-7354-599e-159efd260ba9@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.244]
X-ClientProxiedBy: EX13D42UWA001.ant.amazon.com (10.43.160.153) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDE4OjEzLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Cj4K
PiBPbiAwNy8wOS8yMDIwIDE3OjA4LCBHcmVnIEtIIHdyb3RlOgo+PiBPbiBNb24sIFNlcCAwNywg
MjAyMCBhdCAwNDo0MzoxMVBNICswMzAwLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+
Pj4KPj4+IE9uIDA3LzA5LzIwMjAgMTI6MDEsIEdyZWcgS0ggd3JvdGU6Cj4+Pj4gT24gRnJpLCBT
ZXAgMDQsIDIwMjAgYXQgMDg6Mzc6MTdQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+
Cj4+Pj4+IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+Pj4+
PiAtLS0KPj4+Pj4gQ2hhbmdlbG9nCj4+Pj4+Cj4+Pj4+IHY3IC0+IHY4Cj4+Pj4+Cj4+Pj4+ICog
QWRkIGluZm8gYWJvdXQgdGhlIHByaW1hcnkgLyBwYXJlbnQgVk0gQ0lEIHZhbHVlLgo+Pj4+PiAq
IFVwZGF0ZSByZWZlcmVuY2UgbGluayBmb3IgaHVnZSBwYWdlcy4KPj4+Pj4gKiBBZGQgcmVmZXJl
bmNlIGxpbmsgZm9yIHRoZSB4ODYgYm9vdCBwcm90b2NvbC4KPj4+Pj4gKiBBZGQgbGljZW5zZSBt
ZW50aW9uIGFuZCB1cGRhdGUgZG9jIHRpdGxlIC8gY2hhcHRlciBmb3JtYXR0aW5nLgo+Pj4+Pgo+
Pj4+PiB2NiAtPiB2Nwo+Pj4+Pgo+Pj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4+Cj4+Pj4+IHY1IC0+
IHY2Cj4+Pj4+Cj4+Pj4+ICogTm8gY2hhbmdlcy4KPj4+Pj4KPj4+Pj4gdjQgLT4gdjUKPj4+Pj4K
Pj4+Pj4gKiBObyBjaGFuZ2VzLgo+Pj4+Pgo+Pj4+PiB2MyAtPiB2NAo+Pj4+Pgo+Pj4+PiAqIFVw
ZGF0ZSBkb2MgdHlwZSBmcm9tIC50eHQgdG8gLnJzdC4KPj4+Pj4gKiBVcGRhdGUgZG9jdW1lbnRh
dGlvbiBiYXNlZCBvbiB0aGUgY2hhbmdlcyBmcm9tIHY0Lgo+Pj4+Pgo+Pj4+PiB2MiAtPiB2Mwo+
Pj4+Pgo+Pj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4+Cj4+Pj4+IHYxIC0+IHYyCj4+Pj4+Cj4+Pj4+
ICogTmV3IGluIHYyLgo+Pj4+PiAtLS0KPj4+Pj4gwqDCoCBEb2N1bWVudGF0aW9uL25pdHJvX2Vu
Y2xhdmVzL25lX292ZXJ2aWV3LnJzdCB8IDk1IAo+Pj4+PiArKysrKysrKysrKysrKysrKysrKwo+
Pj4+PiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCspCj4+Pj4+IMKgwqAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vbml0cm9fZW5jbGF2ZXMvbmVfb3ZlcnZpZXcu
cnN0Cj4+Pj4gQSB3aG9sZSBuZXcgc3ViZGlyLCBmb3IgYSBzaW5nbGUgZHJpdmVyLCBhbmQgbm90
IHRpZWQgaW50byB0aGUga2VybmVsCj4+Pj4gZG9jdW1lbnRhdGlvbiBidWlsZCBwcm9jZXNzIGF0
IGFsbD/CoCBOb3QgZ29vZCA6KAo+Pj4+Cj4+PiBXb3VsZCB0aGUgInZpcnQiIGRpcmVjdG9yeSBi
ZSBhIGJldHRlciBvcHRpb24gZm9yIHRoaXMgZG9jIGZpbGU/Cj4+IFllcy4KPgo+IEFscmlnaHQs
IEknbGwgdXBkYXRlIHRoZSBkb2MgZmlsZSBsb2NhdGlvbiwgdGhlIGluZGV4IGZpbGUgYW5kIHRo
ZSAKPiBNQUlOVEFJTkVSUyBlbnRyeSB0byByZWZsZWN0IHRoZSBuZXcgZG9jIGZpbGUgbG9jYXRp
b24uCj4KCkkgc2VudCBvdXQgYSBuZXcgcmV2aXNpb24gdGhhdCBpbmNsdWRlcyB0aGUgdXBkYXRl
cyBiYXNlZCBvbiB5b3VyIApmZWVkYmFjay4gVGhhbmtzIGZvciByZXZpZXcuCgpUbyBiZSBhd2Fy
ZSBvZiB0aGlzIGJlZm9yZWhhbmQsIHdoYXQgd291bGQgYmUgdGhlIGZ1cnRoZXIgbmVjZXNzYXJ5
IApzdGVwcyAoZS5nLiBsaW51eC1uZXh0IGJyYW5jaCwgYWRkaXRpb25hbCByZXZpZXcgYW5kIC8g
b3Igc2FuaXR5IGNoZWNrcykgCnRvIGNvbnNpZGVyIGZvciB0YXJnZXRpbmcgdGhlIG5leHQgbWVy
Z2Ugd2luZG93PwoKVGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChS
b21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBV
QkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3Rl
cmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

