Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601652D137B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgLGOXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:23:19 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:26710 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgLGOXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 09:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1607350997; x=1638886997;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0GRNZuNBzVueL1AQRPaaXEe0rCQ6tBu9bslLO0qaJ+M=;
  b=Qn/RwALdT6BgIlsqUHGAghZM3EF+qnGjXWswKg4GXgqduihhFtXJ2VKQ
   iq5zdIxgrpwrWptzIwUlnWxOB9FV1k17uOGIYP8WmJjv6j/Q+zHYR7/JX
   8/acIYAD27C1SwB1Vbp7bUOhyU0iS7AJ8vR54xrIDaca3+zBc2jigWfeu
   g=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67708703"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 07 Dec 2020 14:22:29 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 491F1A1E8E;
        Mon,  7 Dec 2020 14:22:18 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 14:22:18 +0000
Received: from freeip.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 14:22:11 +0000
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     Jann Horn <jannh@google.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>
CC:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Willy Tarreau <w@1wt.eu>,
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
        Mike Rapoport <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <CAG48ez2VAu6oARGVZ+muDK9_6_38KVUTJf7utz5Nn=AsmN17nA@mail.gmail.com>
 <CAG48ez13ZAAOVmA89PRKRqr9UezV2_bj8Q6_6sSPzcqfzbsuQQ@mail.gmail.com>
 <e4acbcdb-7ee4-5dfb-ffbf-19eb49cef9c6@amazon.com>
 <CAG48ez2akv0pGSt084sNHtESbjJNXpx=Ko86JEsyZM24+5zLqw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <113122dd-1600-4948-1faa-72ddf46c0439@amazon.de>
Date:   Mon, 7 Dec 2020 15:22:06 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez2akv0pGSt084sNHtESbjJNXpx=Ko86JEsyZM24+5zLqw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D32UWB002.ant.amazon.com (10.43.161.139) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy4xMS4yMCAyMToyMCwgSmFubiBIb3JuIHdyb3RlOgo+IAo+IE9uIEZyaSwgTm92IDI3
LCAyMDIwIGF0IDg6MDQgUE0gQ2F0YW5naXUsIEFkcmlhbiBDb3N0aW4KPiA8YWNhdGFuQGFtYXpv
bi5jb20+IHdyb3RlOgo+PiBPbiAyNy8xMS8yMDIwIDIwOjIyLCBKYW5uIEhvcm4gd3JvdGU6Cj4+
PiBPbiBGcmksIE5vdiAyMCwgMjAyMCBhdCAxMToyOSBQTSBKYW5uIEhvcm4gPGphbm5oQGdvb2ds
ZS5jb20+IHdyb3RlOgo+Pj4+IE9uIE1vbiwgTm92IDE2LCAyMDIwIGF0IDQ6MzUgUE0gQ2F0YW5n
aXUsIEFkcmlhbiBDb3N0aW4KPj4+PiA8YWNhdGFuQGFtYXpvbi5jb20+IHdyb3RlOgo+Pj4+PiBU
aGlzIHBhdGNoIGlzIGEgZHJpdmVyIHRoYXQgZXhwb3NlcyBhIG1vbm90b25pYyBpbmNyZW1lbnRh
bCBWaXJ0dWFsCj4+Pj4+IE1hY2hpbmUgR2VuZXJhdGlvbiB1MzIgY291bnRlciB2aWEgYSBjaGFy
LWRldiBGUyBpbnRlcmZhY2UgdGhhdAo+Pj4+PiBwcm92aWRlcyBzeW5jIGFuZCBhc3luYyBWbUdl
biBjb3VudGVyIHVwZGF0ZXMgbm90aWZpY2F0aW9ucy4gSXQgYWxzbwo+Pj4+PiBwcm92aWRlcyBW
bUdlbiBjb3VudGVyIHJldHJpZXZhbCBhbmQgY29uZmlybWF0aW9uIG1lY2hhbmlzbXMuCj4+Pj4+
Cj4+Pj4+IFRoZSBodyBwcm92aWRlZCBVVUlEIGlzIG5vdCBleHBvc2VkIHRvIHVzZXJzcGFjZSwg
aXQgaXMgaW50ZXJuYWxseQo+Pj4+PiB1c2VkIGJ5IHRoZSBkcml2ZXIgdG8ga2VlcCBhY2NvdW50
aW5nIGZvciB0aGUgZXhwb3NlZCBWbUdlbiBjb3VudGVyLgo+Pj4+PiBUaGUgY291bnRlciBzdGFy
dHMgZnJvbSB6ZXJvIHdoZW4gdGhlIGRyaXZlciBpcyBpbml0aWFsaXplZCBhbmQKPj4+Pj4gbW9u
b3RvbmljYWxseSBpbmNyZW1lbnRzIGV2ZXJ5IHRpbWUgdGhlIGh3IFVVSUQgY2hhbmdlcyAodGhl
IFZNCj4+Pj4+IGdlbmVyYXRpb24gY2hhbmdlcykuCj4+Pj4+Cj4+Pj4+IE9uIGVhY2ggaHcgVVVJ
RCBjaGFuZ2UsIHRoZSBuZXcgaHlwZXJ2aXNvci1wcm92aWRlZCBVVUlEIGlzIGFsc28gZmVkCj4+
Pj4+IHRvIHRoZSBrZXJuZWwgUk5HLgo+Pj4+IEFzIGZvciB2MToKPj4+Pgo+Pj4+IElzIHRoZXJl
IGEgcmVhc29uYWJsZSB1c2VjYXNlIGZvciB0aGUgImNvbmZpcm1hdGlvbiIgbWVjaGFuaXNtPyBJ
dAo+Pj4+IGRvZXNuJ3Qgc2VlbSB2ZXJ5IHVzZWZ1bCB0byBtZS4KPj4KPj4gSSB0aGluayBpdCBh
ZGRzIHZhbHVlIGluIGNvbXBsZXggc2NlbmFyaW9zIHdpdGggbXVsdGlwbGUgdXNlcnMgb2YgdGhl
Cj4+IG1lY2hhbmlzbSwgcG90ZW50aWFsbHkgYXQgdmFyeWluZyBsYXllcnMgb2YgdGhlIHN0YWNr
LCBkaWZmZXJlbnQKPj4gcHJvY2Vzc2VzIGFuZC9vciBydW50aW1lIGxpYnJhcmllcy4KPj4KPj4g
VGhlIGRyaXZlciBvZmZlcnMgYSBuYXR1cmFsIHBsYWNlIHRvIGhhbmRsZSBtaW5pbWFsIG9yY2hl
c3RyYXRpb24KPj4gc3VwcG9ydCBhbmQgb2ZmZXIgdmlzaWJpbGl0eSBpbiBzeXN0ZW0td2lkZSBz
dGF0dXMuCj4+Cj4+IEEgaGlnaC1sZXZlbCBzZXJ2aWNlIHRoYXQgdHJ1c3RzIGFsbCBzeXN0ZW0g
Y29tcG9uZW50cyB0byBwcm9wZXJseSB1c2UKPj4gdGhlIGNvbmZpcm1hdGlvbiBtZWNoYW5pc20g
Y2FuIGFjdHVhbGx5IGJsb2NrIGFuZCB3YWl0IHBhdGllbnRseSBmb3IgdGhlCj4+IHN5c3RlbSB0
byBhZGp1c3QgdG8gdGhlIG5ldyB3b3JsZC4gRXZlbiBpZiBpdCBkb2Vzbid0IHRydXN0IGFsbAo+
PiBjb21wb25lbnRzIGl0IGNhbiBzdGlsbCBkbyBhIGJlc3QtZWZmb3J0LCB0aW1lb3V0IGJsb2Nr
Lgo+IAo+IFdoYXQgY29uY3JldGUgYWN0aW9uIHdvdWxkIHRoYXQgaGlnaC1sZXZlbCBzZXJ2aWNl
IGJlIGFibGUgdG8gdGFrZQo+IGFmdGVyIHdhaXRpbmcgZm9yIHN1Y2ggYW4gZXZlbnQ/CgpGb3Ig
dXMsIGl0IHdvdWxkIG9ubHkgYWxsb3cgaW5jb21pbmcgcmVxdWVzdHMgdG8gdGhlIHRhcmdldCBj
b250YWluZXIgCmFmdGVyIHRoZSBjb250YWluZXIgaGFzIHN1Y2Nlc3NmdWxseSBhZGp1c3RlZC4K
CllvdSBjYW4gdGhpbmsgb2Ygb3RoZXIgbW9kZWxzIHRvby4gWW91ciBjb250YWluZXIgb3JjaGVz
dHJhdGlvbiBlbmdpbmUgCmNvdWxkIHByZXZlbnQgbmV0d29yayB0cmFmZmljIHRvIHJlYWNoIHRo
ZSBjb250YWluZXIgYXBwbGljYXRpb25zIHVudGlsIAp0aGUgZnVsbCBjb250YWluZXIgaXMgYWRq
dXN0ZWQgZm9yIGV4YW1wbGUuCgo+IE15IG1vZGVsIG9mIHRoZSB2bWdlbmlkIG1lY2hhbmlzbSBp
cyB0aGF0IFJOR3MgYW5kIGNyeXB0b2dyYXBoaWMKPiBsaWJyYXJpZXMgdGhhdCB1c2UgaXQgbmVl
ZCB0byBiZSBmdW5kYW1lbnRhbGx5IHdyaXR0ZW4gc3VjaCB0aGF0IGl0IGlzCj4gZ3VhcmFudGVl
ZCB0aGF0IGEgVk0gZm9yayBjYW4gbm90IGNhdXNlIHRoZSBzYW1lIHJhbmRvbSBudW1iZXIgLwo+
IGNvdW50ZXIgLyAuLi4gdG8gYmUgcmV1c2VkIGZvciB0d28gZGlmZmVyZW50IGNyeXB0b2dyYXBo
aWMgb3BlcmF0aW9ucwo+IGluIGEgd2F5IHZpc2libGUgdG8gYW4gYXR0YWNrZXIuIFRoaXMgbWVh
bnMgdGhhdCBlLmcuIFRMUyBsaWJyYXJpZXMKPiBuZWVkIHRvLCBiZXR3ZWVuIGFjY2VwdGluZyB1
bmVuY3J5cHRlZCBpbnB1dCBhbmQgc2VuZGluZyBvdXQgZW5jcnlwdGVkCj4gZGF0YSwgY2hlY2sg
d2hldGhlciB0aGUgdm1nZW5pZCBjaGFuZ2VkIHNpbmNlIHRoZSBjb25uZWN0aW9uIHdhcyBzZXQK
PiB1cCwgYW5kIGlmIGEgdm1nZW5pZCBjaGFuZ2Ugb2NjdXJyZWQsIGtpbGwgdGhlIGNvbm5lY3Rp
b24uCj4gCj4gQ2FuIHlvdSBnaXZlIGEgY29uY3JldGUgZXhhbXBsZSBvZiBhIHVzZWNhc2Ugd2hl
cmUgdGhlIHZtZ2VuaWQKPiBtZWNoYW5pc20gaXMgdXNlZCBzZWN1cmVseSBhbmQgdGhlIGNvbmZp
cm1hdGlvbiBtZWNoYW5pc20gaXMgbmVjZXNzYXJ5Cj4gYXMgcGFydCBvZiB0aGF0PwoKVGhlIG1h
aW4gY3J1eCBoZXJlIGlzIHRoYXQgd2UgaGF2ZSAyIGZ1bmRhbWVudGFsIGFwcHJvYWNoZXM6Cgox
KSBUcmFuc2FjdGlvbmFsCgpGb3IgYW4gUk5HLCB0aGUgbmF0dXJhbCBwbGFjZSB0byBhZGp1c3Qg
eW91cnNlbGYgdG8gYSByZXN1bWVkIHNuYXBzaG90IAppcyBpbiB0aGUgcmFuZG9tIG51bWJlciBy
ZXRyaWV2YWwuIFlvdSBqdXN0IGNoZWNrIGlmIHlvdXIgZ2VuZXJhdGlvbiBpcyAKc3RpbGwgaWRl
bnRpY2FsIHdoZW4geW91IGZldGNoIHRoZSBuZXh0IHJhbmRvbSBudW1iZXIuCgpJZGVhbGx5LCB5
b3UgYWxzbyBkbyB0aGUgc2FtZSBmb3IgYW55dGhpbmcgY29uc3VtaW5nIHN1Y2ggYSByYW5kb20g
Cm51bWJlci4gU28gcmFuZG9tIG51bWJlciByZXRyaWV2YWwgd291bGQgbm8gbG9uZ2VyIGp1c3Qg
cmV0dXJuICggbnVtYmVyIAopLCBidXQgaW5zdGVhZCAoIG51bWJlciwgZ2VuZXJhdGlvbiApLiBU
aGF0IHdheSB5b3UgY291bGQgY2hlY2sgYXQgZXZlcnkgCmNvbnN1bWVyIHNpZGUgb2YgdGhlIHJh
bmRvbSBudW1iZXIgdGhhdCBpdCdzIGFjdHVhbGx5IHN0aWxsIHJhbmRvbS4gVGhhdCAKd291bGQg
bmVlZCB0byBjYXNjYWRlIGRvd24uCgpTbyBldmVyeSBrZXkgeW91IGRlcml2ZSBmcm9tIGEgcmFu
ZG9tIG51bWJlciwgZXZlcnkgdXVpZCB5b3UgZ2VuZXJhdGUsIAp0aGV5IGFsbCB3b3VsZCBuZWVk
IHRvIHN0b3JlIHRoZSBnZW5lcmF0aW9uIGFzIHdlbGwgYW5kIGNvbXBhcmUgaWYgdGhlIApjdXJy
ZW50IGdlbmVyYXRpb24gaXMgc3RpbGwgdGhlIHNhbWUgYXMgd2hlbiB0aGV5IHdlcmUgZ2VuZXJh
dGVkLiBUaGF0IAptZWFucyB5b3UgbmVlZCB0byBjb252ZXJ0IGV2ZXJ5IGRhdGEgYWNjZXNzIG1l
dGhvZCB0byBhIGZ1bmN0aW9uIGNhbGwgCnRoYXQgY2hlY2tzIGlmIHRoZSB2YWx1ZSBpcyBzdGls
bCBjb25zdW1hYmxlIGFuZCBpZiBub3QsIGFibGUgdG8gCnJlZ2VuZXJhdGUgaXQuIFRoZSBzYW1l
IGFwcGxpZXMgZm9yIGdsb2JhbCB2YWx1ZXMsIHN1Y2ggYXMgYSBzeXN0ZW0gCmdsb2JhbCBVVUlE
IHRoYXQgaXMgc2hhcmVkIGFtb25nIG11bHRpcGxlIHByb2Nlc3Nlcy4KCklmIHlvdSBzbG93bHkg
bW92ZSBhd2F5IGZyb20gc3VwZXIgaW50ZWdyYXRlZCBlbnZpcm9ubWVudHMgbGlrZSBhIFRMUyAK
bGlicmFyeSBhbmQgc3RhcnQgdGhpbmtpbmcgb2Ygc2FtYmEgc3lzdGVtIFVVSURzIG9yIFNTSCBo
b3N0IGtleXMsIAp5b3UnbGwgcXVpY2tseSBzZWUgaG93IHRoYXQgYXBwcm9hY2ggcmVhY2hlcyBp
dHMgbGltaXRzLgoKCjIpIEV2ZW50IGJhc2VkCgpMZXQncyB0YWtlIGEgbG9vayBhdCB0aGUgY29t
cGxpY2F0ZWQgdGhpbmdzIHRvIGltcGxlbWVudCB3aXRoIHRoZSAKdHJhbnNhY3Rpb25hbCBhcHBy
b2FjaDogc2FtYmEgc3lzdGVtIFVVSURzLCBTU0ggaG9zdCBrZXlzLCBnbG9iYWwgCnZhcmlhYmxl
cyBpbiBhIHJhbmRvbSBKYXZhIGFwcGxpY2F0aW9uIHRoYXQgZ2V0IGluaXRpYWxpemVkIG9uIAph
cHBsaWNhdGlvbiBzdGFydC4KCkFsbCBvZiB0aGVzZSBhcmUgdmVyeSBlYXN5IHRvIHJlc29sdmUg
dGhyb3VnaCBhbiBldmVudCBiYXNlZCBtZWNoYW5pc20uIApCYXNlZCBvbiB0aGUgIm5ldyBnZW5l
cmF0aW9uIiBldmVudCwgeW91IGNhbiBqdXN0IGdlbmVyYXRlIGEgbmV3IFVVSUQuIApPciBhIG5l
dyBob3N0IGtleS4gQWxsIHlvdSB3b3VsZCBuZWVkIHRvIGtub3cgZm9yIHRoaXMgdG8gYmUgbm9u
LXJhY3kgaXMgCnRoYXQgYmVmb3JlIHlvdSBhY3R1YWxseSB1c2UgdGhlIHRhcmdldCBzZXJ2aWNl
cywgeW91IGtub3cgdGhleSBhcmUgCnNlbGYtYWRqdXN0ZWQuIEluIG1vc3QgY29udGFpbmVyIHdv
cmtsb2FkcywgdGhhdCBjYW4gYmUgYWNoaWV2ZWQgYnkgbm90IApsZXR0aW5nIG5ldHdvcmsgdHJh
ZmZpYyBnbyBpbiBiZWZvcmUgdGhlIGV2ZW50IGlzIGZ1bGx5IHByb2Nlc3NlZC4KCgpXaGF0IHRo
aXMgcGF0Y2ggc2V0IGRvZXMgaXMgcHJvdmlkZSBib3RoOiBXZSBhbGxvdyB0aGUgdHJhbnNhY3Rp
b25hbCAKYXBwcm9hY2ggdGhyb3VnaCBtbWFwKCkgb2YgYSBzaGFyZWQgcGFnZSB0byBiZSBpbXBs
ZW1lbnRlZCBmb3Igc3RhY2tzIAp3aGVyZSB0aGF0J3MgZWFzaWVzdC4gWW91IGNhbiB1c2UgdGhh
dCB3aGVuIHlvdXIgbG9naWMgaXMgcmVhbGlzdGljYWxseSAKY29udmVydGFibGUgdG8gdHJhbnNh
Y3Rpb25hbC4gV2UgYWxzbyBhbGxvdyBmb3IgYW4gYXN5bmNocm9ub3VzIGV2ZW50LCAKd2hpY2gg
Y2FuIGJlIHVzZWQgaW4gZW52aXJvbm1lbnRzIHdoZXJlIHRoZSB0cmFuc2FjdGlvbmFsIGFwcHJv
YWNoIGlzIApoYXJkIGJlY2F1c2Ugb2YgZGVzaWduIGNvbnN0cmFpbnRzIChsYW5ndWFnZSwgQVBJ
LCBzeXN0ZW0sIGV0Yy4pLgoKQ29tYmluaW5nIHRoZSB0d28sIHlvdSBnZXQgdGhlIGJlc3Qgb2Yg
Ym90aCB3b3JsZHMgSU1ITy4KCj4gCj4+Pj4gSG93IGRvIHlvdSBlbnZpc2lvbiBpbnRlZ3JhdGlu
ZyB0aGlzIHdpdGggbGlicmFyaWVzIHRoYXQgaGF2ZSB0byB3b3JrCj4+Pj4gaW4gcmVzdHJpY3Rp
dmUgc2VjY29tcCBzYW5kYm94ZXM/IElmIHRoaXMgd2FzIGluIHRoZSB2RFNPLCB0aGF0IHdvdWxk
Cj4+Pj4gYmUgbXVjaCBlYXNpZXIuCj4+Cj4+IFNpbmNlIHRoaXMgbWVjaGFuaXNtIHRhcmdldHMg
YWxsIG9mIHVzZXJzcGFjZSBzdGFjaywgdGhlIHVzZWNhc2UgZ3JlYXRseQo+PiB2YXJ5LiBJIGRv
dWJ0IHdlIGNhbiBoYXZlIGEgc2luZ2xlIHNpbHZlciBidWxsZXQgaW50ZXJmYWNlLgo+Pgo+PiBG
b3IgZXhhbXBsZSwgdGhlIG1tYXAgaW50ZXJmYWNlIHRhcmdldHMgdXNlciBzcGFjZSBSTkdzLCB3
aGVyZSBhcyBmYXN0Cj4+IGFuZCBhcyByYWNlIGZyZWUgYXMgcG9zc2libGUgaXMga2V5LiBCdXQg
dGhlcmUgYWxzbyBoaWdoZXIgbGV2ZWwKPj4gYXBwbGljYXRpb25zIHRoYXQgZG9uJ3QgbWFuYWdl
IHRoZWlyIG93biBtZW1vcnkgb3IgZG9uJ3QgaGF2ZSBhY2Nlc3MgdG8KPj4gbG93LWxldmVsIHBy
aW1pdGl2ZXMgc28gdGhleSBjYW4ndCB1c2UgdGhlIG1tYXAgb3IgZXZlbiB2RFNPIGludGVyZmFj
ZXMuCj4+IFRoYXQncyB3aGF0IHRoZSByZXN0IG9mIHRoZSBsb2dpYyBpcyB0aGVyZSBmb3IsIHRo
ZSByZWFkK3BvbGwgaW50ZXJmYWNlCj4+IGFuZCBhbGwgb2YgdGhlIG9yY2hlc3RyYXRpb24gbG9n
aWMuCj4gCj4gQXJlIHlvdSBzYXlpbmcgdGhhdCwgYmVjYXVzZSBwZW9wbGUgbWlnaHQgbm90IHdh
bnQgdG8gd3JpdGUgcHJvcGVyCj4gYmluZGluZ3MgZm9yIHRoaXMgaW50ZXJmYWNlIHdoaWxlIGFs
c28gYmVpbmcgdW53aWxsaW5nIHRvIHRha2UgdGhlCj4gcGVyZm9ybWFuY2UgaGl0IG9mIGNhbGxp
bmcgcmVhZCgpIGluIGV2ZXJ5IHBsYWNlIHdoZXJlIHRoZXkgd291bGQgaGF2ZQo+IHRvIGRvIHNv
IHRvIGJlIGZ1bGx5IGNvcnJlY3QsIHlvdSB3YW50IHRvIGJ1aWxkIGEgImJlc3QtZWZmb3J0Igo+
IG1lY2hhbmlzbSB0aGF0IGlzIGRlbGliZXJhdGVseSBkZXNpZ25lZCB0byBhbGxvdyBzb21lIGNy
eXB0b2dyYXBoaWMKPiBzdGF0ZSByZXVzZSBpbiBhIGxpbWl0ZWQgdGltZSB3aW5kb3c/CgpJIHNl
cmlvdXNseSBob3BlIHRoYXQgZm9yIGNyeXB0bywgd2Ugd2lsbCBhbHdheXMoPykgYmUgYWJsZSB0
byB1c2UgdGhlIAp0cmFuc2FjdGlvbmFsIGFwcHJvYWNoLiBBbmQgdGhlcmUgd2UgZG9uJ3QgZXZl
biBoYXZlIHRvIHJlc29ydCB0byByZWFkKCkgCi0geW91IGNhbiBqdXN0IG1tYXAoKSB0aGUgZ2Vu
ZXJhdGlvbiBJRC4KCldoYXQgdGhlIGV2ZW50IGJhc2VkIG1lY2hhbmlzbSBpcyB0aGVyZSBmb3Ig
YXJlIHRoZSBvdGhlciBjYXNlcyB0aGF0IGFyZSAKbm90IGVhc2lseSBjb252ZXJ0ZWQgdG8gc3Vj
aCBhbiBhcHByb2FjaC4gQXMgbGlicmFyeSBvd25lciwgeW91IGFsd2F5cyAKaGF2ZSB0aGUgY2hv
aWNlLgoKVGhhdCBzYWlkLCBJIGRvbid0IHRoaW5rIHRoZSAiYmVzdC1lZmZvcnQiIG1lY2hhbmlz
bSBpcyBhcyBiYWQgYXMgeW91IApkZXNjcmliZSBpdCBhYm92ZS4gSWYgeW91J3JlIHRoaW5raW5n
IG9mIGEgbm9ybWFsIFZNIGltYWdlLCBpbWFnaW5lIApzeXN0ZW1kIHdvdWxkIGltcGxlbWVudCB2
bWdlbmlkIHN1cHBvcnQuIEl0IGNvdWxkIGluc3RhbGwgYSBxdWljayBCUEYgCnByb2dyYW0gdGhh
dCBqdXN0IGJsb2NrcyBhbGwgbmV0d29yayB0cmFmZmljIGFsdG9nZXRoZXIgZnJvbSB0aGUgVk0g
CnVudGlsIGl0cyBnZW5pZCBpcyBmdWxseSBzeW5jaHJvbml6ZWQgYWNyb3NzIGFsbCBwcm9jZXNz
ZXMuIElkZWFsbHksIGl0IAp3b3VsZCBldmVuIGJlIGFibGUgdG8ga2lsbCB1bmNvb3BlcmF0aXZl
IHByb2Nlc3NlcyBldmVudHVhbGx5LCBzbyB0aGF0IAp5b3VyIHJlc3VtZWQgVk0gaXMgcmVhY2hh
YmxlIGFmdGVyIGEgdGltZW91dC4KCj4+IExpa2UgeW91IGNvcnJlY3RseSBwb2ludCBvdXQsIHRo
ZXJlIGFyZSBhbHNvIHNjZW5hcmlvcyBsaWtlIHRpZ2h0Cj4+IHNlY2NvbXAgamFpbHMgd2hlcmUg
ZXZlbiB0aGUgRlMgaW50ZXJmYWNlcyBpcyBpbmFjY2Vzc2libGUuIEZvciBjYXNlcwo+PiBsaWtl
IHRoaXMgYW5kIG90aGVycywgSSBiZWxpZXZlIHdlIHdpbGwgaGF2ZSB0byB3b3JrIGluY3JlbWVu
dGFsbHkgdG8KPj4gYnVpbGQgdXAgdGhlIGludGVyZmFjZSBkaXZlcnNpdHkgdG8gY2F0ZXIgdG8g
YWxsIHRoZSB1c2VyIHNjZW5hcmlvcwo+PiBkaXZlcnNpdHkuCj4gCj4gSXQgd291bGQgYmUgbXVj
aCBuaWNlciBpZiB3ZSBjb3VsZCBoYXZlIG9uZSBzaW1wbGUgaW50ZXJmYWNlIHRoYXQgbGV0cwo+
IGV2ZXJ5b25lIGNvcnJlY3RseSBkbyB3aGF0IHRoZXkgbmVlZCB0bywgdGhvdWdoLi4uCgpJIHdh
bnQgYSBwb255IHRvbyA6KS4gV2UgbmVlZCB0byBkbyB3aGF0J3MgYmVzdCBmb3Igb3VyIHVzZXJz
IGhlcmUuIEkgYW0gCm5vdCBjb252aW5jZWQgb25seSBvZmZlcmluZyBhIHRyYW5zYWN0aW9uIGJh
c2VkIGludGVyZmFjZSBpcyBnb2luZyB0byAKZmluZCB0aGUgYWRvcHRpb24gd2UncmUgaG9waW5n
IGZvci4gVGhhdCBtZWFucywgd2UnbGwgZW5kIHVwIGxlc3Mgc2VjdXJlIAp0aGFuIHdlIHdhbnQg
dG8sIG5vdCBtb3JlLgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55
IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hy
aXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmlj
aHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6
IERFIDI4OSAyMzcgODc5CgoK

