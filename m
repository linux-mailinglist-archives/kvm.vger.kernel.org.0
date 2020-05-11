Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169D1CD6DD
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgEKKuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 06:50:12 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5354 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgEKKuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 06:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589194210; x=1620730210;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=4Rs67otuHSyZgWCuCm/tZfvOeyzNXjzdxJiMJID6UVA=;
  b=tTg8uY6Jh89M/oztm/NaYhawllF8D4iQAaKh2soCuIajS2TpWIEvAx3E
   mMG/pBU49trXTj1jvCEl8b+UgkDJvyq61TH/cbBio9QqEssD6200LKWHN
   knUwR0uzevv4LnyLOvAIhE/JxZjWzQPcTx1phsEXUMtNPpnfxObE5eKxH
   I=;
IronPort-SDR: yi9TmisoyeY6FqZAi/aBjzUKyEas8kTR5TbH2noyurxJXxhzWeSaesGp48qnXnoB7bjG6Mw4z1
 1JFDPXOODOyw==
X-IronPort-AV: E=Sophos;i="5.73,379,1583193600"; 
   d="scan'208";a="29779422"
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 11 May 2020 10:49:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id B17C9A21BA;
        Mon, 11 May 2020 10:49:55 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 11 May 2020 10:49:55 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 11 May 2020 10:49:47 +0000
To:     "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "van der Linden, Frank" <fllinden@amazon.com>,
        "Smith, Stewart" <trawets@amazon.com>,
        "Pohlack, Martin" <mpohlack@amazon.de>,
        "Wilson, Matt" <msw@amazon.com>, "Dannowski, Uwe" <uwed@amazon.de>,
        "Doebel, Bjoern" <doebel@amazon.de>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com> <20200507174438.GB1216@bug>
 <620bf5ae-eade-37da-670d-a8704d9b4397@amazon.com> <20200509192125.GA1597@bug>
 <1b00857202884c2a27d0e381d6de312201d17868.camel@amazon.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <ac1026ba-6d29-2e28-e889-84ce2ab7e6ff@amazon.com>
Date:   Mon, 11 May 2020 13:49:37 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1b00857202884c2a27d0e381d6de312201d17868.camel@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D40UWA001.ant.amazon.com (10.43.160.53) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxMC8wNS8yMDIwIDE0OjAyLCBIZXJyZW5zY2htaWR0LCBCZW5qYW1pbiB3cm90ZToKPiBP
biBTYXQsIDIwMjAtMDUtMDkgYXQgMjE6MjEgKzAyMDAsIFBhdmVsIE1hY2hlayB3cm90ZToKPj4g
T24gRnJpIDIwMjAtMDUtMDggMTA6MDA6MjcsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6
Cj4+Pgo+Pj4gT24gMDcvMDUvMjAyMCAyMDo0NCwgUGF2ZWwgTWFjaGVrIHdyb3RlOgo+Pj4+IEhp
IQo+Pj4+Cj4+Pj4+PiBpdCB1c2VzIGl0cyBvd24gbWVtb3J5IGFuZCBDUFVzICsgaXRzIHZpcnRp
by12c29jayBlbXVsYXRlZCBkZXZpY2UgZm9yCj4+Pj4+PiBjb21tdW5pY2F0aW9uIHdpdGggdGhl
IHByaW1hcnkgVk0uCj4+Pj4+Pgo+Pj4+Pj4gVGhlIG1lbW9yeSBhbmQgQ1BVcyBhcmUgY2FydmVk
IG91dCBvZiB0aGUgcHJpbWFyeSBWTSwgdGhleSBhcmUgZGVkaWNhdGVkCj4+Pj4+PiBmb3IgdGhl
IGVuY2xhdmUuIFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZW5zdXJl
cyBtZW1vcnkKPj4+Pj4+IGFuZCBDUFUgaXNvbGF0aW9uIGJldHdlZW4gdGhlIHByaW1hcnkgVk0g
YW5kIHRoZSBlbmNsYXZlIFZNLgo+Pj4+Pj4KPj4+Pj4+IFRoZXNlIHR3byBjb21wb25lbnRzIG5l
ZWQgdG8gcmVmbGVjdCB0aGUgc2FtZSBzdGF0ZSBlLmcuIHdoZW4gdGhlCj4+Pj4+PiBlbmNsYXZl
IGFic3RyYWN0aW9uIHByb2Nlc3MgKDEpIGlzIHRlcm1pbmF0ZWQsIHRoZSBlbmNsYXZlIFZNICgy
KSBpcwo+Pj4+Pj4gdGVybWluYXRlZCBhcyB3ZWxsLgo+Pj4+Pj4KPj4+Pj4+IFdpdGggcmVnYXJk
IHRvIHRoZSBjb21tdW5pY2F0aW9uIGNoYW5uZWwsIHRoZSBwcmltYXJ5IFZNIGhhcyBpdHMgb3du
Cj4+Pj4+PiBlbXVsYXRlZCB2aXJ0aW8tdnNvY2sgUENJIGRldmljZS4gVGhlIGVuY2xhdmUgVk0g
aGFzIGl0cyBvd24gZW11bGF0ZWQKPj4+Pj4+IHZpcnRpby12c29jayBkZXZpY2UgYXMgd2VsbC4g
VGhpcyBjaGFubmVsIGlzIHVzZWQsIGZvciBleGFtcGxlLCB0byBmZXRjaAo+Pj4+Pj4gZGF0YSBp
biB0aGUgZW5jbGF2ZSBhbmQgdGhlbiBwcm9jZXNzIGl0LiBBbiBhcHBsaWNhdGlvbiB0aGF0IHNl
dHMgdXAgdGhlCj4+Pj4+PiB2c29jayBzb2NrZXQgYW5kIGNvbm5lY3RzIG9yIGxpc3RlbnMsIGRl
cGVuZGluZyBvbiB0aGUgdXNlIGNhc2UsIGlzIHRoZW4KPj4+Pj4+IGRldmVsb3BlZCB0byB1c2Ug
dGhpcyBjaGFubmVsOyB0aGlzIGhhcHBlbnMgb24gYm90aCBlbmRzIC0gcHJpbWFyeSBWTQo+Pj4+
Pj4gYW5kIGVuY2xhdmUgVk0uCj4+Pj4+Pgo+Pj4+Pj4gTGV0IG1lIGtub3cgaWYgZnVydGhlciBj
bGFyaWZpY2F0aW9ucyBhcmUgbmVlZGVkLgo+Pj4+PiBUaGFua3MsIHRoaXMgaXMgYWxsIHVzZWZ1
bC4gIEhvd2V2ZXIgY2FuIHlvdSBwbGVhc2UgY2xhcmlmeSB0aGUKPj4+Pj4gbG93LWxldmVsIGRl
dGFpbHMgaGVyZT8KPj4+PiBJcyB0aGUgdmlydHVhbCBtYWNoaW5lIG1hbmFnZXIgb3Blbi1zb3Vy
Y2U/IElmIHNvLCBJIGd1ZXNzIHBvaW50ZXIgZm9yIHNvdXJjZXMKPj4+PiB3b3VsZCBiZSB1c2Vm
dWwuCj4+PiBIaSBQYXZlbCwKPj4+Cj4+PiBUaGFua3MgZm9yIHJlYWNoaW5nIG91dC4KPj4+Cj4+
PiBUaGUgVk1NIHRoYXQgaXMgdXNlZCBmb3IgdGhlIHByaW1hcnkgLyBwYXJlbnQgVk0gaXMgbm90
IG9wZW4gc291cmNlLgo+PiBEbyB3ZSB3YW50IHRvIG1lcmdlIGNvZGUgdGhhdCBvcGVuc291cmNl
IGNvbW11bml0eSBjYW4gbm90IHRlc3Q/Cj4gSGVoZS4uIHRoaXMgaXNuJ3QgcXVpdGUgdGhlIHN0
b3J5IFBhdmVsIDopCj4KPiBXZSBtZXJnZSBzdXBwb3J0IGZvciBwcm9wcmlldGFyeSBoeXBlcnZp
c29ycywgdGhpcyBpcyBubyBkaWZmZXJlbnQuIFlvdQo+IGNhbiB0ZXN0IGl0LCB3ZWxsIGF0IGxl
YXN0IHlvdSdsbCBiZSBhYmxlIHRvIC4uLiB3aGVuIEFXUyBkZXBsb3lzIHRoZQo+IGZ1bmN0aW9u
YWxpdHkuIFlvdSBkb24ndCBuZWVkIHRoZSBoeXBlcnZpc29yIGl0c2VsZiB0byBiZSBvcGVuIHNv
dXJjZS4KPgo+IEluIGZhY3QsIGluIHRoaXMgY2FzZSwgaXQncyBub3QgZXZlbiBsb3cgbGV2ZWwg
aW52YXNpdmUgYXJjaCBjb2RlIGxpa2UKPiBzb21lIG9mIHRoZSBhYm92ZSBjYW4gYmUuIEl0J3Mg
YSBkcml2ZXIgZm9yIGEgUENJIGRldmljZSA6LSkgR3JhbnRlZCBhCj4gdmlydHVhbCBvbmUuIFdl
IG1lcmdlIGRyaXZlcnMgZm9yIFBDSSBkZXZpY2VzIHJvdXRpbmVseSB3aXRob3V0IHRoZSBSVEwK
PiBvciBmaXJtd2FyZSBvZiB0aG9zZSBkZXZpY2VzIGJlaW5nIG9wZW4gc291cmNlLgo+Cj4gU28g
eWVzLCB3ZSBwcm9iYWJseSB3YW50IHRoaXMgaWYgaXQncyBnb2luZyB0byBiZSBhIHVzZWZ1bCBm
ZWF0dXJlcyB0bwo+IHVzZXJzIHdoZW4gcnVubmluZyBvbiBBV1MgRUMyLiAoRGlzY2xhaW1lcjog
SSB3b3JrIGZvciBBV1MgdGhlc2UgZGF5cykuCgpJbmRlZWQsIGl0IHdpbGwgYXZhaWxhYmxlIGZv
ciBjaGVja2luZyBvdXQgaG93IGl0IHdvcmtzLgoKVGhlIGRpc2N1c3Npb25zIGFyZSBvbmdvaW5n
IGhlcmUgb24gdGhlIExLTUwgLSB1bmRlcnN0YW5kaW5nIHRoZSAKY29udGV4dCwgY2xhcmlmeWlu
ZyBpdGVtcywgc2hhcmluZyBmZWVkYmFjayBhbmQgY29taW5nIHdpdGggY29kZWJhc2UgCnVwZGF0
ZXMgYW5kIGJhc2ljIGV4YW1wbGUgZmxvdyBvZiB0aGUgaW9jdGwgaW50ZXJmYWNlIHVzYWdlLiBU
aGlzIGFsbCAKaGVscHMgd2l0aCB0aGUgcGF0aCB0b3dhcmRzIG1lcmdpbmcuCgpUaGFua3MsIEJl
biwgZm9yIHRoZSBmb2xsb3ctdXAuCgpBbmRyYQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRl
ciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVl
dCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVn
aXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

