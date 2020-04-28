Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E85F1BC244
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgD1PHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:07:48 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:3910 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgD1PHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588086467; x=1619622467;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=te8o9Lj1+ijfjNPgqMBT7qXZPWfUQ2zkU3aGea8cF2U=;
  b=CTuRapyDOZpMoYSJYG0RgwHQAtlFCH8IU9eeteQzGu9ra5zlxQ22uwoS
   A4/c0onLUyu0yNJW2fGnypDas+0SsjNlbkT6PhRw6Us9rGVsT99BQcJMh
   BT5snRXa8RYhYIMI2BEsJz8t4SnNl/XceuLcPCqZIJCAR/zwJfXpJWyV2
   0=;
IronPort-SDR: sTMdFzGT/Qju37TJKZt0gijyvJi9c4GvdgYHIGdSCUHqYMzTUZ+BaFoNhXw06JvL9TUW7M2Y8d
 Ifdgr1OoJaYQ==
X-IronPort-AV: E=Sophos;i="5.73,328,1583193600"; 
   d="scan'208";a="41395309"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Apr 2020 15:07:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id C3B9AA219C;
        Tue, 28 Apr 2020 15:07:42 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 15:07:40 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.200) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 15:07:36 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
Date:   Tue, 28 Apr 2020 17:07:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNS4wNC4yMCAxODowNSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBDQVVUSU9OOiBUaGlz
IGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5v
dCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0g
dGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLgo+IAo+IAo+IAo+IE9uIDI0
LzA0LzIwIDIxOjExLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gV2hhdCBJIHdhcyBzYXlpbmcg
YWJvdmUgaXMgdGhhdCBtYXliZSBjb2RlIGlzIGVhc2llciB0byB0cmFuc2ZlciB0aGF0Cj4+IHRo
YW4gYSAudHh0IGZpbGUgdGhhdCBnZXRzIGxvc3Qgc29tZXdoZXJlIGluIHRoZSBEb2N1bWVudGF0
aW9uIGRpcmVjdG9yeQo+PiA6KS4KPiAKPiB3aHlub3Rib3RoLmpwZyA6RAoKVWgsIHN1cmU/IDop
CgpMZXQncyBmaXJzdCBoYW1tZXIgb3V0IHdoYXQgd2UgcmVhbGx5IHdhbnQgZm9yIHRoZSBVQUJJ
IHRob3VnaC4gVGhlbiB3ZSAKY2FuIGRvY3VtZW50IGl0LgoKPj4+PiBUbyBhbnN3ZXIgdGhlIHF1
ZXN0aW9uIHRob3VnaCwgdGhlIHRhcmdldCBmaWxlIGlzIGluIGEgbmV3bHkgaW52ZW50ZWQKPj4+
PiBmaWxlIGZvcm1hdCBjYWxsZWQgIkVJRiIgYW5kIGl0IG5lZWRzIHRvIGJlIGxvYWRlZCBhdCBv
ZmZzZXQgMHg4MDAwMDAgb2YKPj4+PiB0aGUgYWRkcmVzcyBzcGFjZSBkb25hdGVkIHRvIHRoZSBl
bmNsYXZlLgo+Pj4KPj4+IFdoYXQgaXMgdGhpcyBFSUY/Cj4+Cj4+IEl0J3MganVzdCBhIHZlcnkg
ZHVtYiBjb250YWluZXIgZm9ybWF0IHRoYXQgaGFzIGEgdHJpdmlhbCBoZWFkZXIsIGEKPj4gc2Vj
dGlvbiB3aXRoIHRoZSBiekltYWdlIGFuZCBvbmUgdG8gbWFueSBzZWN0aW9ucyBvZiBpbml0cmFt
ZnMuCj4+Cj4+IEFzIG1lbnRpb25lZCBlYXJsaWVyIGluIHRoaXMgdGhyZWFkLCBpdCByZWFsbHkg
aXMganVzdCAiLWtlcm5lbCIgYW5kCj4+ICItaW5pdHJkIiwgcGFja2VkIGludG8gYSBzaW5nbGUg
YmluYXJ5IGZvciB0cmFuc21pc3Npb24gdG8gdGhlIGhvc3QuCj4gCj4gT2theSwgZ290IGl0LiAg
U28sIGNvcnJlY3QgbWUgaWYgdGhpcyBpcyB3cm9uZywgdGhlIGluZm9ybWF0aW9uIHRoYXQgaXMK
PiBuZWVkZWQgdG8gYm9vdCB0aGUgZW5jbGF2ZSBpczoKPiAKPiAqIHRoZSBrZXJuZWwsIGluIGJ6
SW1hZ2UgZm9ybWF0Cj4gCj4gKiB0aGUgaW5pdHJkCgpJdCdzIGEgc2luZ2xlIEVJRiBmaWxlIGZv
ciBhIGdvb2QgcmVhc29uLiBUaGVyZSBhcmUgY2hlY2tzdW1zIGluIHRoZXJlIAphbmQgcG90ZW50
aWFsbHkgc2lnbmF0dXJlcyB0b28sIHNvIHRoYXQgeW91IGNhbiB0aGUgZW5jbGF2ZSBjYW4gYXR0
ZXN0IAppdHNlbGYuIEZvciB0aGUgc2FrZSBvZiB0aGUgdXNlciBzcGFjZSBBUEksIHRoZSBlbmNs
YXZlIGltYWdlIHJlYWxseSAKc2hvdWxkIGp1c3QgYmUgY29uc2lkZXJlZCBhIGJsb2IuCgo+IAo+
ICogYSBjb25zZWN1dGl2ZSBhbW91bnQgb2YgbWVtb3J5LCB0byBiZSBtYXBwZWQgd2l0aAo+IEtW
TV9TRVRfVVNFUl9NRU1PUllfUkVHSU9OCj4gCj4gT2ZmIGxpc3QsIEFsZXggYW5kIEkgZGlzY3Vz
c2VkIGhhdmluZyBhIHN0cnVjdCB0aGF0IHBvaW50cyB0byBrZXJuZWwgYW5kCj4gaW5pdHJkIG9m
ZiBlbmNsYXZlIG1lbW9yeSwgYW5kIGhhdmUgdGhlIGRyaXZlciBidWlsZCBFSUYgYXQgdGhlCj4g
YXBwcm9wcmlhdGUgcG9pbnQgaW4gZW5jbGF2ZSBtZW1vcnkgKHRoZSA4IE1pQiBvZnNldCB0aGF0
IHlvdSBtZW50aW9uZWQpLgo+IAo+IFRoaXMgaG93ZXZlciBoYXMgdHdvIGRpc2FkdmFudGFnZXM6
Cj4gCj4gMSkgaGF2aW5nIHRoZSBrZXJuZWwgYW5kIGluaXRyZCBsb2FkZWQgYnkgdGhlIHBhcmVu
dCBWTSBpbiBlbmNsYXZlCj4gbWVtb3J5IGhhcyB0aGUgYWR2YW50YWdlIHRoYXQgeW91IHNhdmUg
bWVtb3J5IG91dHNpZGUgdGhlIGVuY2xhdmUgbWVtb3J5Cj4gZm9yIHNvbWV0aGluZyB0aGF0IGlz
IG9ubHkgbmVlZGVkIGluc2lkZSB0aGUgZW5jbGF2ZQo+IAo+IDIpIGl0IGlzIGxlc3MgZXh0ZW5z
aWJsZSAod2hhdCBpZiB5b3Ugd2FudCB0byB1c2UgUFZIIGluIHRoZSBmdXR1cmUgZm9yCj4gZXhh
bXBsZSkgYW5kIHB1dHMgaW4gdGhlIGRyaXZlciBwb2xpY3kgdGhhdCBzaG91bGQgYmUgaW4gdXNl
cnNwYWNlLgo+IAo+IAo+IFNvIHdoeSBub3QganVzdCBzdGFydCBydW5uaW5nIHRoZSBlbmNsYXZl
IGF0IDB4ZmZmZmZmZjAgaW4gcmVhbCBtb2RlPwo+IFllcyBldmVyeWJvZHkgaGF0ZXMgaXQsIGJ1
dCB0aGF0J3Mgd2hhdCBPU2VzIGFyZSB3cml0dGVuIGFnYWluc3QuICBJbgo+IHRoZSBzaW1wbGVz
dCBleGFtcGxlLCB0aGUgcGFyZW50IGVuY2xhdmUgY2FuIGxvYWQgYnpJbWFnZSBhbmQgaW5pdHJk
IGF0Cj4gMHgxMDAwMCBhbmQgcGxhY2UgZmlybXdhcmUgdGFibGVzIChNUFRhYmxlIGFuZCBETUkp
IHNvbWV3aGVyZSBhdAo+IDB4ZjAwMDA7IHRoZSBmaXJtd2FyZSB3b3VsZCBqdXN0IGJlIGEgZmV3
IG1vdnMgdG8gc2VnbWVudCByZWdpc3RlcnMKPiBmb2xsb3dlZCBieSBhIGxvbmcgam1wLgoKVGhl
cmUgaXMgYSBiaXQgb2YgaW5pdGlhbCBhdHRlc3RhdGlvbiBmbG93IGluIHRoZSBlbmNsYXZlLCBz
byB0aGF0IHlvdSAKY2FuIGJlIHN1cmUgdGhhdCB0aGUgY29kZSB0aGF0IGlzIHJ1bm5pbmcgaXMg
YWN0dWFsbHkgd2hhdCB5b3Ugd2FudGVkIHRvIApydW4uCgpJIHdvdWxkIGFsc28gaW4gZ2VuZXJh
bCBwcmVmZXIgdG8gZGlzY29ubmVjdCB0aGUgbm90aW9uIG9mICJlbmNsYXZlIAptZW1vcnkiIGFz
IG11Y2ggYXMgcG9zc2libGUgZnJvbSBhIG1lbW9yeSBsb2NhdGlvbiB2aWV3LiBVc2VyIHNwYWNl
IApzaG91bGRuJ3QgYmUgaW4gdGhlIGJ1c2luZXNzIG9mIGtub3dpbmcgbG9jYXRpb24gb2YgaXRz
IGRvbmF0ZWQgbWVtb3J5IAplbmRlZCB1cCBhdCB3aGljaCBlbmNsYXZlIG1lbW9yeSBwb3NpdGlv
bi4gQnkgZGlzY29ubmVjdGluZyB0aGUgdmlldyBvZiAKdGhlIG1lbW9yeSB3b3JsZCwgd2UgY2Fu
IGRvIHNvbWUgbW9yZSBvcHRpbWl6YXRpb25zLCBzdWNoIGFzIGNvbXBhY3QgCm1lbW9yeSByYW5n
ZXMgbW9yZSBlZmZpY2llbnRseSBpbiBrZXJuZWwgc3BhY2UuCgo+IElmIHlvdSB3YW50IHRvIGtl
ZXAgRUlGLCB3ZSBtZWFzdXJlZCBpbiBRRU1VIHRoYXQgdGhlcmUgaXMgbm8gbWVhc3VyYWJsZQo+
IGRpZmZlcmVuY2UgYmV0d2VlbiBsb2FkaW5nIHRoZSBrZXJuZWwgaW4gdGhlIGhvc3QgYW5kIGRv
aW5nIGl0IGluIHRoZQo+IGd1ZXN0LCBzbyBBbWF6b24gY291bGQgcHJvdmlkZSBhbiBFSUYgbG9h
ZGVyIHN0dWIgYXQgMHhmZmZmZmZmMCBmb3IKPiBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eS4KCkl0
J3Mgbm90IGFib3V0IHBlcmZvcm1hbmNlIDopLgoKU28gdGhlIG90aGVyIHRoaW5nIHdlIGRpc2N1
c3NlZCB3YXMgd2hldGhlciB0aGUgS1ZNIEFQSSByZWFsbHkgdHVybmVkIApvdXQgdG8gYmUgYSBn
b29kIGZpdCBoZXJlLiBBZnRlciBhbGwsIHRvZGF5IHdlIG1lcmVseSBjYWxsOgoKICAgKiBDUkVB
VEVfVk0KICAgKiBTRVRfTUVNT1JZX1JBTkdFCiAgICogQ1JFQVRFX1ZDUFUKICAgKiBTVEFSVF9F
TkNMQVZFCgp3aGVyZSB3ZSBldmVuIGJ1dGNoZXIgdXAgQ1JFQVRFX1ZDUFUgaW50byBhIG1lYW5p
bmdsZXNzIGJsb2Igb2Ygb3ZlcmhlYWQgCmZvciBubyBnb29kIHJlYXNvbi4KCldoeSBkb24ndCB3
ZSBidWlsZCBzb21ldGhpbmcgbGlrZSB0aGUgZm9sbG93aW5nIGluc3RlYWQ/CgogICB2bSA9IG5l
X2NyZWF0ZSh2Y3B1cyA9IDQpCiAgIG5lX3NldF9tZW1vcnkodm0sIGh2YSwgbGVuKQogICBuZV9s
b2FkX2ltYWdlKHZtLCBhZGRyLCBsZW4pCiAgIG5lX3N0YXJ0KHZtKQoKVGhhdCB3YXkgd2Ugd291
bGQgZ2V0IHRoZSBFSUYgbG9hZGluZyBpbnRvIGtlcm5lbCBzcGFjZS4gIkxPQURfSU1BR0UiIAp3
b3VsZCBvbmx5IGJlIGF2YWlsYWJsZSBpbiB0aGUgdGltZSB3aW5kb3cgYmV0d2VlbiBzZXRfbWVt
b3J5IGFuZCBzdGFydC4gCkl0IGJhc2ljYWxseSBpbXBsZW1lbnRzIGEgbWVtY3B5KCksIGJ1dCBp
dCB3b3VsZCBjb21wbGV0ZWx5IGhpZGUgdGhlIApoaWRkZW4gc2VtYW50aWNzIG9mIHdoZXJlIGFu
IEVJRiBoYXMgdG8gZ28sIHNvIGZ1dHVyZSBkZXZpY2UgdmVyc2lvbnMgCihvciBldmVuIG90aGVy
IGVuY2xhdmUgaW1wbGVtZW50ZXJzKSBjb3VsZCBjaGFuZ2UgdGhlIGxvZ2ljLgoKSSB0aGluayBp
dCBhbHNvIG1ha2VzIHNlbnNlIHRvIGp1c3QgYWxsb2NhdGUgdGhvc2UgNCBpb2N0bHMgZnJvbSAK
c2NyYXRjaC4gUGFvbG8sIHdvdWxkIHlvdSBzdGlsbCB3YW50IHRvICJkb25hdGUiIEtWTSBpb2N0
bCBzcGFjZSBpbiB0aGF0IApjYXNlPwoKT3ZlcmFsbCwgdGhlIGFib3ZlIHNob3VsZCBhZGRyZXNz
IG1vc3Qgb2YgdGhlIGNvbmNlcm5zIHlvdSByYWlzZWQgaW4gCnRoaXMgbWFpbCwgcmlnaHQ/IEl0
IHN0aWxsIHJlcXVpcmVzIGNvcHlpbmcsIGJ1dCBhdCBsZWFzdCB3ZSBkb24ndCBoYXZlIAp0byBr
ZWVwIHRoZSBjb3B5IGluIGtlcm5lbCBzcGFjZS4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVu
dCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFl
ZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJh
Z2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6
OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

