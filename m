Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2E2D1179
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgLGNMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:12:19 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:34014 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLGNMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 08:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1607346737; x=1638882737;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=50ZcZdTAoY0vWU/rWTI4tqVz+2mOhlWZv4ICxKd6nSc=;
  b=sOq0KZ2PORcfLcDrddk08oJZ1Ozzu8ZVwzfC4E/EQqhQb0NmhXrsWQX9
   3bjgjdoDL8vZdifU+YMwaopdSK/jYThVBNCIal8NdzXWeSEyfBw6PUD1F
   f/Up2eeW7Snl0TC7AzSg4WWA0DrNO7w97YF9S9CReXydMYakrRF+wNs5U
   g=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67963857"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Dec 2020 13:11:17 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id CB2F8A2227;
        Mon,  7 Dec 2020 13:11:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:11:14 +0000
Received: from freeip.amazon.com (10.43.161.102) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:11:06 +0000
Subject: Re: [PATCH v3] drivers/virt: vmgenid: add vm generation id driver
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
CC:     Mike Rapoport <rppt@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
 <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
 <20201119173800.GD8537@kernel.org>
 <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
 <106f56ca-49bc-7cad-480f-4b26656e90ce@gmail.com>
 <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <145eaa0b-a118-1d80-7f2c-d73f0d3f1db0@amazon.de>
Date:   Mon, 7 Dec 2020 14:11:04 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D40UWC004.ant.amazon.com (10.43.162.175) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy4xMS4yMCAxOToyNiwgQ2F0YW5naXUsIEFkcmlhbiBDb3N0aW4gd3JvdGU6Cj4gLSBC
YWNrZ3JvdW5kCj4gCj4gVGhlIFZNIEdlbmVyYXRpb24gSUQgaXMgYSBmZWF0dXJlIGRlZmluZWQg
YnkgTWljcm9zb2Z0IChwYXBlcjoKPiBodHRwOi8vZ28ubWljcm9zb2Z0LmNvbS9md2xpbmsvP0xp
bmtJZD0yNjA3MDkpIGFuZCBzdXBwb3J0ZWQgYnkKPiBtdWx0aXBsZSBoeXBlcnZpc29yIHZlbmRv
cnMuCj4gCj4gVGhlIGZlYXR1cmUgaXMgcmVxdWlyZWQgaW4gdmlydHVhbGl6ZWQgZW52aXJvbm1l
bnRzIGJ5IGFwcHMgdGhhdCB3b3JrCj4gd2l0aCBsb2NhbCBjb3BpZXMvY2FjaGVzIG9mIHdvcmxk
LXVuaXF1ZSBkYXRhIHN1Y2ggYXMgcmFuZG9tIHZhbHVlcywKPiB1dWlkcywgbW9ub3RvbmljYWxs
eSBpbmNyZWFzaW5nIGNvdW50ZXJzLCBldGMuCj4gU3VjaCBhcHBzIGNhbiBiZSBuZWdhdGl2ZWx5
IGFmZmVjdGVkIGJ5IFZNIHNuYXBzaG90dGluZyB3aGVuIHRoZSBWTQo+IGlzIGVpdGhlciBjbG9u
ZWQgb3IgcmV0dXJuZWQgdG8gYW4gZWFybGllciBwb2ludCBpbiB0aW1lLgo+IAo+IFRoZSBWTSBH
ZW5lcmF0aW9uIElEIGlzIGEgc2ltcGxlIGNvbmNlcHQgbWVhbnQgdG8gYWxsZXZpYXRlIHRoZSBp
c3N1ZQo+IGJ5IHByb3ZpZGluZyBhIHVuaXF1ZSBJRCB0aGF0IGNoYW5nZXMgZWFjaCB0aW1lIHRo
ZSBWTSBpcyByZXN0b3JlZAo+IGZyb20gYSBzbmFwc2hvdC4gVGhlIGh3IHByb3ZpZGVkIFVVSUQg
dmFsdWUgY2FuIGJlIHVzZWQgdG8KPiBkaWZmZXJlbnRpYXRlIGJldHdlZW4gVk1zIG9yIGRpZmZl
cmVudCBnZW5lcmF0aW9ucyBvZiB0aGUgc2FtZSBWTS4KPiAKPiAtIFByb2JsZW0KPiAKPiBUaGUg
Vk0gR2VuZXJhdGlvbiBJRCBpcyBleHBvc2VkIHRocm91Z2ggYW4gQUNQSSBkZXZpY2UgYnkgbXVs
dGlwbGUKPiBoeXBlcnZpc29yIHZlbmRvcnMgYnV0IG5laXRoZXIgdGhlIHZlbmRvcnMgb3IgdXBz
dHJlYW0gTGludXggaGF2ZSBubwo+IGRlZmF1bHQgZHJpdmVyIGZvciBpdCBsZWF2aW5nIHVzZXJz
IHRvIGZlbmQgZm9yIHRoZW1zZWx2ZXMuCj4gCj4gRnVydGhlcm1vcmUsIHNpbXBseSBmaW5kaW5n
IG91dCBhYm91dCBhIFZNIGdlbmVyYXRpb24gY2hhbmdlIGlzIG9ubHkKPiB0aGUgc3RhcnRpbmcg
cG9pbnQgb2YgYSBwcm9jZXNzIHRvIHJlbmV3IGludGVybmFsIHN0YXRlcyBvZiBwb3NzaWJseQo+
IG11bHRpcGxlIGFwcGxpY2F0aW9ucyBhY3Jvc3MgdGhlIHN5c3RlbS4gVGhpcyBwcm9jZXNzIGNv
dWxkIGJlbmVmaXQKPiBmcm9tIGEgZHJpdmVyIHRoYXQgcHJvdmlkZXMgYW4gaW50ZXJmYWNlIHRo
cm91Z2ggd2hpY2ggb3JjaGVzdHJhdGlvbgo+IGNhbiBiZSBlYXNpbHkgZG9uZS4KPiAKPiAtIFNv
bHV0aW9uCj4gCj4gVGhpcyBwYXRjaCBpcyBhIGRyaXZlciB0aGF0IGV4cG9zZXMgYSBtb25vdG9u
aWMgaW5jcmVtZW50YWwgVmlydHVhbAo+IE1hY2hpbmUgR2VuZXJhdGlvbiB1MzIgY291bnRlciB2
aWEgYSBjaGFyLWRldiBGUyBpbnRlcmZhY2UuIFRoZSBGUwo+IGludGVyZmFjZSBwcm92aWRlcyBz
eW5jIGFuZCBhc3luYyBWbUdlbiBjb3VudGVyIHVwZGF0ZXMgbm90aWZpY2F0aW9ucy4KPiBJdCBh
bHNvIHByb3ZpZGVzIFZtR2VuIGNvdW50ZXIgcmV0cmlldmFsIGFuZCBjb25maXJtYXRpb24gbWVj
aGFuaXNtcy4KPiAKPiBUaGUgZ2VuZXJhdGlvbiBjb3VudGVyIGFuZCB0aGUgaW50ZXJmYWNlIHRo
cm91Z2ggd2hpY2ggaXQgaXMgZXhwb3NlZAo+IGFyZSBhdmFpbGFibGUgZXZlbiB3aGVuIHRoZXJl
IGlzIG5vIGFjcGkgZGV2aWNlIHByZXNlbnQuCj4gCj4gV2hlbiB0aGUgZGV2aWNlIGlzIHByZXNl
bnQsIHRoZSBodyBwcm92aWRlZCBVVUlEIGlzIG5vdCBleHBvc2VkIHRvCj4gdXNlcnNwYWNlLCBp
dCBpcyBpbnRlcm5hbGx5IHVzZWQgYnkgdGhlIGRyaXZlciB0byBrZWVwIGFjY291bnRpbmcgZm9y
Cj4gdGhlIGV4cG9zZWQgVm1HZW4gY291bnRlci4gVGhlIGNvdW50ZXIgc3RhcnRzIGZyb20gemVy
byB3aGVuIHRoZQo+IGRyaXZlciBpcyBpbml0aWFsaXplZCBhbmQgbW9ub3RvbmljYWxseSBpbmNy
ZW1lbnRzIGV2ZXJ5IHRpbWUgdGhlIGh3Cj4gVVVJRCBjaGFuZ2VzICh0aGUgVk0gZ2VuZXJhdGlv
biBjaGFuZ2VzKS4KPiBPbiBlYWNoIGh3IFVVSUQgY2hhbmdlLCB0aGUgbmV3IGh5cGVydmlzb3It
cHJvdmlkZWQgVVVJRCBpcyBhbHNvIGZlZAo+IHRvIHRoZSBrZXJuZWwgUk5HLgo+IAo+IElmIHRo
ZXJlIGlzIG5vIGFjcGkgdm1nZW5pZCBkZXZpY2UgcHJlc2VudCwgdGhlIGdlbmVyYXRpb24gY2hh
bmdlcyBhcmUKPiBub3QgZHJpdmVuIGJ5IGh3IHZtZ2VuaWQgZXZlbnRzIGJ1dCBjYW4gYmUgZHJp
dmVuIGJ5IHNvZnR3YXJlIHRocm91Z2gKPiBhIGRlZGljYXRlZCBkcml2ZXIgaW9jdGwuCj4gCj4g
VGhpcyBwYXRjaCBidWlsZHMgb24gdG9wIG9mIE9yIElkZ2FyIDxvcmlkZ2FyQGdtYWlsLmNvbT4n
cyBwcm9wb3NhbAo+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE4LzMvMS80OTgKPiAKPiAtIEZ1
dHVyZSBpbXByb3ZlbWVudHMKPiAKPiBJZGVhbGx5IHdlIHdvdWxkIHdhbnQgdGhlIGRyaXZlciB0
byByZWdpc3RlciBpdHNlbGYgYmFzZWQgb24gZGV2aWNlcycKPiBfQ0lEIGFuZCBub3QgX0hJRCwg
YnV0IHVuZm9ydHVuYXRlbHkgSSBjb3VsZG4ndCBmaW5kIGEgd2F5IHRvIGRvIHRoYXQuCj4gVGhl
IHByb2JsZW0gaXMgdGhhdCBBQ1BJIGRldmljZSBtYXRjaGluZyBpcyBkb25lIGJ5Cj4gJ19fYWNw
aV9tYXRjaF9kZXZpY2UoKScgd2hpY2ggZXhjbHVzaXZlbHkgbG9va3MgYXQKPiAnYWNwaV9oYXJk
d2FyZV9pZCAqaHdpZCcuCj4gCj4gVGhlcmUgaXMgYSBwYXRoIGZvciBwbGF0Zm9ybSBkZXZpY2Vz
IHRvIG1hdGNoIG9uIF9DSUQgd2hlbiBfSElEIGlzCj4gJ1BSUDAwMDEnIC0gYnV0IHRoaXMgaXMg
bm90IHRoZSBjYXNlIGZvciB0aGUgUWVtdSB2bWdlbmlkIGRldmljZS4KPiAKPiBHdWlkYW5jZSBh
bmQgaGVscCBoZXJlIHdvdWxkIGJlIGdyZWF0bHkgYXBwcmVjaWF0ZWQuCj4gCj4gU2lnbmVkLW9m
Zi1ieTogQWRyaWFuIENhdGFuZ2l1IDxhY2F0YW5AYW1hem9uLmNvbT4KPiAKPiAtLS0KPiAKPiB2
MSAtPiB2MjoKPiAKPiAgwqAgLSBleHBvc2UgdG8gdXNlcnNwYWNlIGEgbW9ub3RvbmljYWxseSBp
bmNyZWFzaW5nIHUzMiBWbSBHZW4gQ291bnRlcgo+ICDCoMKgwqAgaW5zdGVhZCBvZiB0aGUgaHcg
Vm1HZW4gVVVJRAo+ICDCoCAtIHNpbmNlIHRoZSBody9oeXBlcnZpc29yLXByb3ZpZGVkIDEyOC1i
aXQgVVVJRCBpcyBub3QgcHVibGljCj4gIMKgwqDCoCBhbnltb3JlLCBhZGQgaXQgdG8gdGhlIGtl
cm5lbCBSTkcgYXMgZGV2aWNlIHJhbmRvbW5lc3MKPiAgwqAgLSBpbnNlcnQgZHJpdmVyIHBhZ2Ug
Y29udGFpbmluZyBWbSBHZW4gQ291bnRlciBpbiB0aGUgdXNlciB2bWEgaW4KPiAgwqDCoMKgIHRo
ZSBkcml2ZXIncyBtbWFwIGhhbmRsZXIgaW5zdGVhZCBvZiB1c2luZyBhIGZhdWx0IGhhbmRsZXIK
PiAgwqAgLSB0dXJuIGRyaXZlciBpbnRvIGEgbWlzYyBkZXZpY2UgZHJpdmVyIHRvIGF1dG8tY3Jl
YXRlIC9kZXYvdm1nZW5pZAo+ICDCoCAtIGNoYW5nZSBpb2N0bCBhcmcgdG8gYXZvaWQgbGVha2lu
ZyBrZXJuZWwgc3RydWN0cyB0byB1c2Vyc3BhY2UKPiAgwqAgLSB1cGRhdGUgZG9jdW1lbnRhdGlv
bgo+ICDCoCAtIHZhcmlvdXMgbml0cwo+ICDCoCAtIHJlYmFzZSBvbiB0b3Agb2YgbGludXMgbGF0
ZXN0Cj4gCj4gdjIgLT4gdjM6Cj4gCj4gIMKgIC0gc2VwYXJhdGUgdGhlIGNvcmUgZHJpdmVyIGxv
Z2ljIGFuZCBpbnRlcmZhY2UsIGZyb20gdGhlIEFDUEkgZGV2aWNlLgo+ICDCoMKgwqAgVGhlIEFD
UEkgdm1nZW5pZCBkZXZpY2UgaXMgbm93IG9uZSBwb3NzaWJsZSBiYWNrZW5kLgo+ICDCoCAtIGZp
eCBpc3N1ZSB3aGVuIHRpbWVvdXQ9MCBpbiBWTUdFTklEX1dBSVRfV0FUQ0hFUlMKPiAgwqAgLSBh
ZGQgbG9ja2luZyB0byBhdm9pZCByYWNlcyBiZXR3ZWVuIGZzIG9wcyBoYW5kbGVycyBhbmQgaHcg
aXJxCj4gIMKgwqDCoCBkcml2ZW4gZ2VuZXJhdGlvbiB1cGRhdGVzCj4gIMKgIC0gY2hhbmdlIFZN
R0VOSURfV0FJVF9XQVRDSEVSUyBpb2N0bCBzbyBpZiB0aGUgY3VycmVudCBjYWxsZXIgaXMKPiAg
wqDCoMKgIG91dGRhdGVkIG9yIGEgZ2VuZXJhdGlvbiBjaGFuZ2UgaGFwcGVucyB3aGlsZSB3YWl0
aW5nICh0aHVzIG1ha2luZwo+ICDCoMKgwqAgY3VycmVudCBjYWxsZXIgb3V0ZGF0ZWQpLCB0aGUg
aW9jdGwgcmV0dXJucyAtRUlOVFIgdG8gc2lnbmFsIHRoZQo+ICDCoMKgwqAgdXNlciB0byBoYW5k
bGUgZXZlbnQgYW5kIHJldHJ5LiBGaXhlcyBibG9ja2luZyBvbiBvbmVzZWxmLgo+ICDCoCAtIGFk
ZCBWTUdFTklEX0ZPUkNFX0dFTl9VUERBVEUgaW9jdGwgY29uZGl0aW9uZWQgYnkKPiAgwqDCoMKg
IENBUF9DSEVDS1BPSU5UX1JFU1RPUkUgY2FwYWJpbGl0eSwgdGhyb3VnaCB3aGljaCBzb2Z0d2Fy
ZSBjYW4gZm9yY2UKPiAgwqDCoMKgIGdlbmVyYXRpb24gYnVtcC4KPiAtLS0KPiAgwqBEb2N1bWVu
dGF0aW9uL3ZpcnQvdm1nZW5pZC5yc3QgfCAyNDAgKysrKysrKysrKysrKysrKysrKysrKysKPiAg
wqBkcml2ZXJzL3ZpcnQvS2NvbmZpZ8KgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxNyArKwo+ICDC
oGRyaXZlcnMvdmlydC9NYWtlZmlsZcKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAxICsKPiAgwqBk
cml2ZXJzL3ZpcnQvdm1nZW5pZC5jwqDCoMKgwqDCoMKgwqDCoCB8IDQzNQo+ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIMKgaW5jbHVkZS91YXBpL2xpbnV4L3Zt
Z2VuaWQuaMKgwqAgfMKgIDE0ICsrCj4gIMKgNSBmaWxlcyBjaGFuZ2VkLCA3MDcgaW5zZXJ0aW9u
cygrKQo+ICDCoGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL3ZpcnQvdm1nZW5pZC5y
c3QKPiAgwqBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy92aXJ0L3ZtZ2VuaWQuYwo+ICDCoGNy
ZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL3VhcGkvbGludXgvdm1nZW5pZC5oCj4gCgpbLi4uXQoK
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L0tjb25maWcgYi9kcml2ZXJzL3ZpcnQvS2NvbmZp
Zwo+IGluZGV4IDgwYzVmOWMxLi41ZDVmMzdiIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdmlydC9L
Y29uZmlnCj4gKysrIGIvZHJpdmVycy92aXJ0L0tjb25maWcKPiBAQCAtMTMsNiArMTMsMjMgQEAg
bWVudWNvbmZpZyBWSVJUX0RSSVZFUlMKPiAgIAo+ICDCoGlmIFZJUlRfRFJJVkVSUwo+ICAgCj4g
K2NvbmZpZyBWTUdFTklECj4gK8KgwqDCoCB0cmlzdGF0ZSAiVmlydHVhbCBNYWNoaW5lIEdlbmVy
YXRpb24gSUQgZHJpdmVyIgo+ICvCoMKgwqAgZGVwZW5kcyBvbiBBQ1BJCgpJIHRoaW5rIHlvdSB3
YW50IHRvIHNwbGl0IHRoZSBLQ29uZmlnIGJpdCBpbnRvIHR3byBub3cuIE9uZSBmb3IgZ2VuZXJp
YyAKL2Rldi92bWdlbmlkIHN1cHBvcnQgYW5kIGFub3RoZXIgb25lIGZvciBBQ1BJX1ZNR0VOSUQg
dG8gYXV0b21hdGljYWxseSAKYnVtcCByZXZpc2lvbnMgd2hlbiB0aGUgaHlwZXJ2aXNvciBpbmRp
Y2F0ZXMgaXQuCgpJbiBmYWN0LCB5b3UgY2FuIHByb2JhYmx5IG1ha2UgdGhpcyB0d28gc2VwYXJh
dGUgcGF0Y2hlcyB3aXRoIHR3byAKc2VwYXJhdGUgZmlsZXMgKHJlYWQ6IGtlcm5lbCBtb2R1bGVz
KSBldmVuLiBUaGUgZ2VuZXJpYyBjb2RlIGNhbiBqdXN0IApleHBvcnQgc3ltYm9scyB0byBidW1w
IHRoZSBzeXN0ZW0gZ2VuaWQuCgpJJ20gYWxzbyBub3QgZnVsbHkgY29udmluY2VkIHRoYXQgY2Fs
bGluZyB0aGUgZ2VuZXJpYyBtZWNoYW5pc20gCiJ2bWdlbmlkIiBpcyBzdGlsbCBhY2N1cmF0ZSBh
dCB0aGlzIHBvaW50LiBDYW4geW91IHRoaW5rIG9mIGEgYmV0dGVyIApuYW1lPyAiU3lzdGVtIEdl
bmVyYXRpb24gSUQiLCBzbyAic3lzZ2VuaWQiIG1heWJlPwoKPiArwqDCoMKgIGRlZmF1bHQgTgo+
ICvCoMKgwqAgaGVscAo+ICvCoMKgwqAgwqAgVGhpcyBpcyBhIFZpcnR1YWwgTWFjaGluZSBHZW5l
cmF0aW9uIElEIGRyaXZlciB3aGljaCBwcm92aWRlcwo+ICvCoMKgwqAgwqAgYSB2aXJ0dWFsIG1h
Y2hpbmUgZ2VuZXJhdGlvbiBjb3VudGVyLiBUaGUgZHJpdmVyIGV4cG9zZXMgRlMgb3BzCj4gK8Kg
wqDCoCDCoCBvbiAvZGV2L3ZtZ2VuaWQgdGhyb3VnaCB3aGljaCBpdCBjYW4gcHJvdmlkZSBpbmZv
cm1hdGlvbiBhbmQKPiArwqDCoMKgIMKgIG5vdGlmaWNhdGlvbnMgb24gVk0gZ2VuZXJhdGlvbiBj
aGFuZ2VzIHRoYXQgaGFwcGVuIG9uIHNuYXBzaG90cwo+ICvCoMKgwqAgwqAgb3IgY2xvbmluZy4K
PiArwqDCoMKgIMKgIFRoaXMgZW5hYmxlcyBhcHBsaWNhdGlvbnMgYW5kIGxpYnJhcmllcyB0aGF0
IHN0b3JlIG9yIGNhY2hlCj4gK8KgwqDCoCDCoCBzZW5zaXRpdmUgaW5mb3JtYXRpb24sIHRvIGtu
b3cgdGhhdCB0aGV5IG5lZWQgdG8gcmVnZW5lcmF0ZSBpdAo+ICvCoMKgwqAgwqAgYWZ0ZXIgcHJv
Y2VzcyBtZW1vcnkgaGFzIGJlZW4gZXhwb3NlZCB0byBwb3RlbnRpYWwgY29weWluZy4KPiArCj4g
K8KgwqDCoCDCoCBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBo
ZXJlOiB0aGUKPiArwqDCoMKgIMKgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCB2bWdlbmlkLgo+ICsK
PiAgwqBjb25maWcgRlNMX0hWX01BTkFHRVIKPiAgwqDCoMKgwqAgdHJpc3RhdGUgIkZyZWVzY2Fs
ZSBoeXBlcnZpc29yIG1hbmFnZW1lbnQgZHJpdmVyIgo+ICDCoMKgwqDCoCBkZXBlbmRzIG9uIEZT
TF9TT0MKClsuLi5dCgo+ICvCoMKgwqAgY2FzZSBWTUdFTklEX0ZPUkNFX0dFTl9VUERBVEU6Cj4g
K8KgwqDCoCDCoMKgwqAgaWYgKCFjaGVja3BvaW50X3Jlc3RvcmVfbnNfY2FwYWJsZShjdXJyZW50
X3VzZXJfbnMoKSkpCj4gK8KgwqDCoCDCoMKgwqAgwqDCoMKgIHJldHVybiAtRUFDQ0VTOwo+ICvC
oMKgwqAgwqDCoMKgIHZtZ2VuaWRfYnVtcF9nZW5lcmF0aW9uKCk7CgpJIHRoaW5rIHRoaXMgaXMg
cmFjeSBhbmQgbmVlZHMgdG8gYmUgc2xpZ2h0bHkgZGlmZmVyZW50LiBJbWFnaW5lIHRoZSAKZm9s
bG93aW5nOgoKICAgLSBjb250YWluZXIgaXMgcnVubmluZyB3aXRoIGdlbmlkIDUKICAgLSBJIHRh
a2UgYSBzbmFwc2hvdCBvZiB0aGUgY29udGFpbmVyCiAgIC0gVGFyZ2V0IHN5c3RlbSBoYXMgZ2Vu
aWQgNAogICAtIEkgcmVzdW1lIHRoZSBjb250YWluZXIKICAgLSBJIGNhbGwgdGhlIGdlbmlkIHVw
ZGF0ZSAoZ2VuaWQgPSA1KQoKVGhlbiB0aGUgY29udGFpbmVyIHN0aWxsIHNlZXMgZ2VuaWQgNSwg
c28gKm1heWJlKiBpdCB3b24ndCBhZGFwdCB0byB0aGUgCm5ldyBlbnZpcm9ubWVudC4gVGhpcyB3
aWxsIGRlcGVuZCBvbiB3aGV0aGVyIHRoZSBjb250YWluZXIgZ2V0cyBlbm91Z2ggCnRpbWUgdG8g
YWRqdXN0IHRvIGdlbmlkPTQgYmVmb3JlIHdlIGJ1bXAgaXQgdG8gNS4KCkhvdyBhYm91dCB3ZSBw
YXNzIGEgImJ1bXAsIGJ1dCBub3QgdG8gdGhpcyB2YWx1ZSIgYXJndW1lbnQgdG8gdGhlIGlvY3Rs
PyAKVGhlbiBpdCB3b3VsZCBsb29rIGxpa2UgdGhpczoKCiAgIC0gY29udGFpbmVyIGlzIHJ1bm5p
bmcgd2l0aCBnZW5pZCA1CiAgIC0gSSB0YWtlIGEgc25hcHNob3Qgb2YgdGhlIGNvbnRhaW5lciBh
bmQgaXRzIGdlbmlkICg1KQogICAtIFRhcmdldCBzeXN0ZW0gaGFzIGdlbmlkIDQKICAgLSBJIHJl
c3VtZSB0aGUgY29udGFpbmVyCiAgIC0gSSBjYWxsIHRoZSBnZW5pZCB1cGRhdGUgd2l0aCBhdm9p
ZD01IChzbyB3ZSBidW1wIGdlbmlkIHRvIDYpCgpOb3cgYWxsIHByb2Nlc3NlcyBpbiB0aGUgc3lz
dGVtIHdpbGwgYWRhcHQgdG8gZ2VuaWQ9NiwgaW5jbHVkaW5nIHRoZSAKcmVzdW1lZCBjb250YWlu
ZXIuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1
c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2No
bGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90
dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIz
NyA4NzkKCgo=

