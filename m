Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEAD2B9AC4
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgKSSim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 13:38:42 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:51623 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbgKSSil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 13:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1605811120; x=1637347120;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=82Rk73IpbZeskBh4MpmRnlAzQdRj3TbKP1cGbKkpEmg=;
  b=UgXQk7s5AGwlRZruodHG+ctdFILs4qLDTtPuWU4ts1SAQdlsyOE2XPCq
   fPdyXzys8XQiG8OtsXR7MYP48hmqXcgs6PQ8cuKdMcA4lH/CEbii6aToV
   pL0xZT/HmrCkHfGpMK34a3yp1eoC0//wEW8J0lHn+DJHIkXjFJB3YX354
   U=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="95837366"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Nov 2020 18:37:10 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id CDC9AA1794;
        Thu, 19 Nov 2020 18:36:59 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 18:36:58 +0000
Received: from freeip.amazon.com (10.43.161.237) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 18:36:51 +0000
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     Mike Rapoport <rppt@kernel.org>
CC:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
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
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
 <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
 <20201119173800.GD8537@kernel.org>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
Date:   Thu, 19 Nov 2020 19:36:49 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:84.0)
 Gecko/20100101 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20201119173800.GD8537@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D46UWC004.ant.amazon.com (10.43.162.173) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOS4xMS4yMCAxODozOCwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiAKPiBPbiBUaHUsIE5v
diAxOSwgMjAyMCBhdCAwMTo1MToxOFBNICswMTAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4K
Pj4KPj4gT24gMTkuMTEuMjAgMTM6MDIsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToKPj4+
Cj4+PiBPbiAxNi4xMS4yMCAxNjozNCwgQ2F0YW5naXUsIEFkcmlhbiBDb3N0aW4gd3JvdGU6Cj4+
Pj4gLSBCYWNrZ3JvdW5kCj4+Pj4KPj4+PiBUaGUgVk0gR2VuZXJhdGlvbiBJRCBpcyBhIGZlYXR1
cmUgZGVmaW5lZCBieSBNaWNyb3NvZnQgKHBhcGVyOgo+Pj4+IGh0dHA6Ly9nby5taWNyb3NvZnQu
Y29tL2Z3bGluay8/TGlua0lkPTI2MDcwOSkgYW5kIHN1cHBvcnRlZCBieQo+Pj4+IG11bHRpcGxl
IGh5cGVydmlzb3IgdmVuZG9ycy4KPj4+Pgo+Pj4+IFRoZSBmZWF0dXJlIGlzIHJlcXVpcmVkIGlu
IHZpcnR1YWxpemVkIGVudmlyb25tZW50cyBieSBhcHBzIHRoYXQgd29yawo+Pj4+IHdpdGggbG9j
YWwgY29waWVzL2NhY2hlcyBvZiB3b3JsZC11bmlxdWUgZGF0YSBzdWNoIGFzIHJhbmRvbSB2YWx1
ZXMsCj4+Pj4gdXVpZHMsIG1vbm90b25pY2FsbHkgaW5jcmVhc2luZyBjb3VudGVycywgZXRjLgo+
Pj4+IFN1Y2ggYXBwcyBjYW4gYmUgbmVnYXRpdmVseSBhZmZlY3RlZCBieSBWTSBzbmFwc2hvdHRp
bmcgd2hlbiB0aGUgVk0KPj4+PiBpcyBlaXRoZXIgY2xvbmVkIG9yIHJldHVybmVkIHRvIGFuIGVh
cmxpZXIgcG9pbnQgaW4gdGltZS4KPj4+Pgo+Pj4+IFRoZSBWTSBHZW5lcmF0aW9uIElEIGlzIGEg
c2ltcGxlIGNvbmNlcHQgbWVhbnQgdG8gYWxsZXZpYXRlIHRoZSBpc3N1ZQo+Pj4+IGJ5IHByb3Zp
ZGluZyBhIHVuaXF1ZSBJRCB0aGF0IGNoYW5nZXMgZWFjaCB0aW1lIHRoZSBWTSBpcyByZXN0b3Jl
ZAo+Pj4+IGZyb20gYSBzbmFwc2hvdC4gVGhlIGh3IHByb3ZpZGVkIFVVSUQgdmFsdWUgY2FuIGJl
IHVzZWQgdG8KPj4+PiBkaWZmZXJlbnRpYXRlIGJldHdlZW4gVk1zIG9yIGRpZmZlcmVudCBnZW5l
cmF0aW9ucyBvZiB0aGUgc2FtZSBWTS4KPj4+Pgo+Pj4+IC0gUHJvYmxlbQo+Pj4+Cj4+Pj4gVGhl
IFZNIEdlbmVyYXRpb24gSUQgaXMgZXhwb3NlZCB0aHJvdWdoIGFuIEFDUEkgZGV2aWNlIGJ5IG11
bHRpcGxlCj4+Pj4gaHlwZXJ2aXNvciB2ZW5kb3JzIGJ1dCBuZWl0aGVyIHRoZSB2ZW5kb3JzIG9y
IHVwc3RyZWFtIExpbnV4IGhhdmUgbm8KPj4+PiBkZWZhdWx0IGRyaXZlciBmb3IgaXQgbGVhdmlu
ZyB1c2VycyB0byBmZW5kIGZvciB0aGVtc2VsdmVzLgo+Pj4KPj4+IEkgc2VlIHRoYXQgdGhlIHFl
bXUgaW1wbGVtZW50YXRpb24gaXMgc3RpbGwgdW5kZXIgZGlzY3Vzc2lvbi4gV2hhdCBpcwo+Pgo+
PiBVaCwgdGhlIEFDUEkgVm1nZW5pZCBkZXZpY2UgZW11bGF0aW9uIGlzIGluIFFFTVUgc2luY2Ug
Mi45LjAgOikuCj4+Cj4+PiB0aGUgc3RhdHVzIG9mIHRoZSBvdGhlciBleGlzdGluZyBpbXBsZW1l
bnRhdGlvbnMuIERvIHRoZXkgYWxyZWFkeSBleGlzdD8KPj4+IEluIG90aGVyIHdvcmRzIGlzIEFD
UEkgYSBnaXZlbj8KPj4+IEkgdGhpbmsgdGhlIG1ham9yaXR5IG9mIHRoaXMgZHJpdmVyIGNvdWxk
IGJlIHVzZWQgd2l0aCBqdXN0IGEgZGlmZmVyZW50Cj4+PiBiYWNrZW5kIGZvciBwbGF0Zm9ybXMg
d2l0aG91dCBBQ1BJIHNvIGluIGFueSBjYXNlIHdlIGNvdWxkIGZhY3RvciBvdXQKPj4+IHRoZSBi
YWNrZW5kIChhY3BpLCB2aXJ0aW8sIHdoYXRldmVyKSBidXQgaWYgd2UgYXJlIG9wZW4gd2UgY291
bGQgbWF5YmUKPj4+IHN0YXJ0IHdpdGggc29tZXRoaW5nIGVsc2UuCj4+Cj4+IEkgYWdyZWUgMTAw
JS4gSSBkb24ndCB0aGluayB3ZSByZWFsbHkgbmVlZCBhIG5ldyBmcmFtZXdvcmsgaW4gdGhlIGtl
cm5lbCBmb3IKPj4gdGhhdC4gV2UgY2FuIGp1c3QgaGF2ZSBmb3IgZXhhbXBsZSBhbiBzMzkweCBz
cGVjaWZpYyBkcml2ZXIgdGhhdCBhbHNvCj4+IHByb3ZpZGVzIHRoZSBzYW1lIG5vdGlmaWNhdGlv
biBtZWNoYW5pc20gdGhyb3VnaCBhIGRldmljZSBub2RlIHRoYXQgaXMgYWxzbwo+PiBuYW1lZCAi
L2Rldi92bWdlbmlkIiwgbm8/Cj4+Cj4+IE9yIGFsdGVybmF0aXZlbHkgd2UgY2FuIHNwbGl0IHRo
ZSBnZW5lcmljIHBhcnQgb2YgdGhpcyBkcml2ZXIgYXMgc29vbiBhcyBhCj4+IHNlY29uZCBvbmUg
Y29tZXMgYWxvbmcgYW5kIHRoZW4gaGF2ZSBib3RoIGRyaXZlciBpbmNsdWRlIHRoYXQgZ2VuZXJp
YyBsb2dpYy4KPj4KPj4gVGhlIG9ubHkgcGllY2Ugd2hlcmUgSSdtIHVuc3VyZSBpcyBob3cgdGhp
cyB3aWxsIGludGVyYWN0IHdpdGggQ1JJVS4KPiAKPiBUbyBDL1IgYXBwbGljYXRpb25zIHRoYXQg
dXNlIC9kZXYvdm1nZW5pZCBDUklVIG5lZWQgdG8gYmUgYXdhcmUgb2YgaXQuCj4gQ2hlY2twb2lu
dGluZyBhbmQgcmVzdG9yaW5nIHdpdGhpbmcgdGhlIHNhbWUgIlZNIGdlbmVyYXRpb24iIHNob3Vs
ZG4ndCBiZQo+IGEgcHJvYmxlbSwgYnV0IElNSE8sIG1ha2luZyByZXN0b3JlIHdvcmsgYWZ0ZXIg
Z2VuaWQgYnVtcCBjb3VsZCBiZQo+IGNoYWxsZW5naW5nLgo+IAo+IEFsZXgsIHdoYXQgc2NlbmFy
aW8gaW52b2x2aW5nIENSSVUgZGlkIHlvdSBoYXZlIGluIG1pbmQ/CgpZb3UgY2FuIGluIHRoZW9y
eSBydW4gaW50byB0aGUgc2FtZSBzaXR1YXRpb24gd2l0aCBjb250YWluZXJzIHRoYXQgdGhpcyAK
cGF0Y2ggaXMgc29sdmluZyBmb3IgdmlydHVhbCBtYWNoaW5lcy4gWW91IGNvdWxkIGZvciBleGFt
cGxlIGRvIGEgCnNuYXBzaG90IG9mIGEgcHJld2FybWVkIEphdmEgcnVudGltZSB3aXRoIENSSVUg
dG8gZ2V0IGZ1bGwgSklUIHNwZWVkcyAKc3RhcnRpbmcgZnJvbSB0aGUgZmlyc3QgcmVxdWVzdC4K
ClRoYXQgaG93ZXZlciBtZWFucyB5b3UgcnVuIGludG8gdGhlIHByb2JsZW0gb2YgcHJlZGljdGFi
bGUgcmFuZG9tbmVzcyBhZ2Fpbi4KCj4gCj4+IENhbiBjb250YWluZXJzIGVtdWxhdGUgaW9jdGxz
IGFuZCBkZXZpY2Ugbm9kZXM/Cj4gCj4gQ29udGFpbmVycyBkbyBub3QgZW11bGF0ZSBpb2N0bHMg
YnV0IHRoZXkgY2FuIGhhdmUgL2Rldi92bWdlbmlkIGluc2lkZQo+IHRoZSBjb250YWluZXIsIHNv
IGFwcGxpY2F0aW9ucyBjYW4gdXNlIGl0IHRoZSBzYW1lIHdheSBhcyBvdXRzaWRlIHRoZQo+IGNv
bnRhaW5lci4KCkhtLiBJIHN1cHBvc2Ugd2UgY291bGQgYWRkIGEgQ0FQX0FETUlOIGlvY3RsIGlu
dGVyZmFjZSB0byAvZGV2L3ZtZ2VuaWQgCih3aGVuIGNvbnRhaW5lciBwZW9wbGUgZ2V0IHRvIHRo
ZSBwb2ludCBvZiBuZWVkaW5nIGl0KSB0aGF0IHNldHMgdGhlIApnZW5lcmF0aW9uIHRvICJhdCBs
ZWFzdCBYIi4gVGhhdCB3YXkgb24gcmVzdG9yZSwgeW91IGNvdWxkIGp1c3QgY2FsbCAKdGhhdCB3
aXRoICJnZW5lcmF0aW9uIGF0IHNuYXBzaG90IisxLgoKVGhhdCBhbHNvIG1lYW5zIHdlIG5lZWQg
dG8gaGF2ZSB0aGlzIGludGVyZmFjZSBhdmFpbGFibGUgd2l0aG91dCB2aXJ0dWFsIAptYWNoaW5l
cyB0aGVuIHRob3VnaCwgcmlnaHQ/CgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVy
IEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhy
dW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBB
bXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGlu
ClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

