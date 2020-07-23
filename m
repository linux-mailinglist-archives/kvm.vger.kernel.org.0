Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73D22ABB7
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 11:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgGWJYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 05:24:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:58340 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgGWJYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 05:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595496264; x=1627032264;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=1tGH2qetce90/6FA+/iXztID8HBjMok4ZhMRdNQxxyE=;
  b=muUkG+WUKXOxKQtDb/XE2jrC9B4Unji064k6XXJaX0qupq8e0YmB1GmS
   OpL8J40BSJsR10KnCSrRDLSNACy/VFHYJjWBe1WGAz+9uTKmHyq3pg7tW
   7k/YI6ouWHUjgPiJNjEx2/b69I+Bm4zMLDgbiEWZMx9gj0Ji+ne0XBOpu
   Y=;
IronPort-SDR: UQriON/eq5zU/rwJccEd9SzPe8MrP3FGlOcj4UUpxhoTqwAr5B0vrHnxnTZCsEJ+amZ0yQH/Z+
 42Bz5mZXBKkw==
X-IronPort-AV: E=Sophos;i="5.75,386,1589241600"; 
   d="scan'208";a="60974662"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jul 2020 09:24:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 562FF1A0AD3;
        Thu, 23 Jul 2020 09:24:16 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 09:24:15 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.73) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 09:24:06 +0000
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, Alexander Graf <graf@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
 <20200722095759.GA2817347@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
Date:   Thu, 23 Jul 2020 12:23:56 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722095759.GA2817347@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D29UWA004.ant.amazon.com (10.43.160.33) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNy8yMDIwIDEyOjU3LCBHcmVnIEtIIHdyb3RlOgo+IE9uIFdlZCwgSnVsIDIyLCAy
MDIwIGF0IDExOjI3OjI5QU0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Pj4gKyNpZm5kZWYgX1VBUElfTElOVVhfTklUUk9fRU5DTEFWRVNfSF8KPj4+PiArI2RlZmluZSBf
VUFQSV9MSU5VWF9OSVRST19FTkNMQVZFU19IXwo+Pj4+ICsKPj4+PiArI2luY2x1ZGUgPGxpbnV4
L3R5cGVzLmg+Cj4+Pj4gKwo+Pj4+ICsvKiBOaXRybyBFbmNsYXZlcyAoTkUpIEtlcm5lbCBEcml2
ZXIgSW50ZXJmYWNlICovCj4+Pj4gKwo+Pj4+ICsjZGVmaW5lIE5FX0FQSV9WRVJTSU9OICgxKQo+
Pj4gV2h5IGRvIHlvdSBuZWVkIHRoaXMgdmVyc2lvbj8gIEl0IHNob3VsZG4ndCBiZSBuZWVkZWQs
IHJpZ2h0Pwo+PiBUaGUgdmVyc2lvbiBpcyB1c2VkIGFzIGEgd2F5IGZvciB0aGUgdXNlciBzcGFj
ZSB0b29saW5nIHRvIHN5bmMgb24gdGhlCj4+IGZlYXR1cmVzIHNldCBwcm92aWRlZCBieSB0aGUg
ZHJpdmVyIGUuZy4gaW4gY2FzZSBhbiBvbGRlciB2ZXJzaW9uIG9mIHRoZQo+PiBkcml2ZXIgaXMg
YXZhaWxhYmxlIG9uIHRoZSBzeXN0ZW0gYW5kIHRoZSB1c2VyIHNwYWNlIHRvb2xpbmcgZXhwZWN0
cyBhIHNldAo+PiBvZiBmZWF0dXJlcyB0aGF0IGlzIG5vdCBpbmNsdWRlZCBpbiB0aGF0IGRyaXZl
ciB2ZXJzaW9uLgo+IFRoYXQgaXMgZ3VhcmFudGVlZCB0byBnZXQgb3V0IG9mIHN5bmMgaW5zdGFu
dGx5IHdpdGggZGlmZmVyZW50IGRpc3Rybwo+IGtlcm5lbHMgYmFja3BvcnRpbmcgcmFuZG9tIHRo
aW5ncywgY29tYmluZWQgd2l0aCBzdGFibGUga2VybmVsIHBhdGNoCj4gdXBkYXRlcyBhbmQgdGhl
IGxpa2UuCj4KPiBKdXN0IHVzZSB0aGUgbm9ybWFsIGFwaSBpbnRlcmZhY2VzIGluc3RlYWQsIGRv
bid0IHRyeSB0byAidmVyc2lvbiIKPiBhbnl0aGluZywgaXQgd2lsbCBub3Qgd29yaywgdHJ1c3Qg
dXMgOikKPgo+IElmIGFuIGlvY3RsIHJldHVybnMgLUVOT1RUWSB0aGVuIGhleSwgaXQncyBub3Qg
cHJlc2VudCBhbmQgeW91cgo+IHVzZXJzcGFjZSBjb2RlIGNhbiBoYW5kbGUgaXQgdGhhdCB3YXku
CgpDb3JyZWN0LCB0aGVyZSBjb3VsZCBiZSBhIHZhcmlldHkgb2Yga2VybmVsIHZlcnNpb25zIGFu
ZCB1c2VyIHNwYWNlIAp0b29saW5nIGVpdGhlciBpbiB0aGUgb3JpZ2luYWwgZm9ybSwgY3VzdG9t
aXplZCBvciB3cml0dGVuIGZyb20gc2NyYXRjaC4gCkFuZCBFTk9UVFkgc2lnbmFscyBhbiBpb2N0
bCBub3QgYXZhaWxhYmxlIG9yIGUuZy4gRUlOVkFMIChvciBjdXN0b20gCmVycm9yKSBpZiB0aGUg
cGFyYW1ldGVyIGZpZWxkIHZhbHVlIGlzIG5vdCB2YWxpZCB3aXRoaW4gYSBjZXJ0YWluIAp2ZXJz
aW9uLiBXZSBoYXZlIHRoZXNlIGluIHBsYWNlLCB0aGF0J3MgZ29vZC4gOikKCkhvd2V2ZXIsIEkg
d2FzIHRoaW5raW5nLCBmb3IgZXhhbXBsZSwgb2YgYW4gaW9jdGwgZmxvdyB1c2FnZSB3aGVyZSBh
IApjZXJ0YWluIG9yZGVyIG5lZWRzIHRvIGJlIGZvbGxvd2VkIGUuZy4gY3JlYXRlIGEgVk0sIGFk
ZCByZXNvdXJjZXMgdG8gYSAKVk0sIHN0YXJ0IGEgVk0uCgpMZXQncyBzYXksIGZvciBhbiB1c2Ug
Y2FzZSB3cnQgbmV3IGZlYXR1cmVzLCBpb2N0bCBBIChjcmVhdGUgYSBWTSkgCnN1Y2NlZWRzLCBp
b2N0bCBCIChhZGQgbWVtb3J5IHRvIHRoZSBWTSkgc3VjY2VlZHMsIGlvY3RsIEMgKGFkZCBDUFUg
dG8gCnRoZSBWTSkgc3VjY2VlZHMgYW5kIGlvY3RsIEQgKGFkZCBhbnkgb3RoZXIgdHlwZSBvZiBy
ZXNvdXJjZSBiZWZvcmUgCnN0YXJ0aW5nIHRoZSBWTSkgZmFpbHMgYmVjYXVzZSBpdCBpcyBub3Qg
c3VwcG9ydGVkLgoKV291bGQgbm90IG5lZWQgdG8gY2FsbCBpb2N0bCBBIHRvIEMgYW5kIGdvIHRo
cm91Z2ggdGhlaXIgdW5kZXJuZWF0aCAKbG9naWMgdG8gcmVhbGl6ZSBpb2N0bCBEIHN1cHBvcnQg
aXMgbm90IHRoZXJlIGFuZCByb2xsYmFjayBhbGwgdGhlIApjaGFuZ2VzIGRvbmUgdGlsbCB0aGVu
IHdpdGhpbiBpb2N0bCBBIHRvIEMgbG9naWMuIE9mIGNvdXJzZSwgdGhlcmUgY291bGQgCmJlIGlv
Y3RsIEEgZm9sbG93ZWQgYnkgaW9jdGwgRCwgYW5kIHdvdWxkIG5lZWQgdG8gcm9sbGJhY2sgaW9j
dGwgQSAKY2hhbmdlcywgYnV0IEkgc2hhcmVkIGEgbW9yZSBsZW5ndGh5IGNhbGwgY2hhaW4gdGhh
dCBjYW4gYmUgYW4gb3B0aW9uIGFzIAp3ZWxsLgoKVGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBT
Zi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1
LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIy
LzI2MjEvMjAwNS4K

