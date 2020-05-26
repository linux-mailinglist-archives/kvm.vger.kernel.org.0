Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455E11E232E
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgEZNll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 09:41:41 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:37438 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388968AbgEZNlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 09:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590500480; x=1622036480;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5UAlWa04lGteMMFU4hcRhlsT1EfQUs4xPKXarcSjHjs=;
  b=UwlsIPe7THJf0sStqfIjGMjobRP2Se9LfBf5goZhNcP81VXYXP5qKJ0M
   7nOzLOxLFFtKaewmH/06llWrRa1MMREwKFNPkd7gMyQJTNhTwG++3OxHS
   WFJxJgda13IB2u3C2VaG65ChuZY4rGYA2i3SeZm+f8H+3ZaTEBNSs28fn
   E=;
IronPort-SDR: ogWCptk4AFvCoYrVpjxypAwt5YHRFXkZnnMXv9QLthSYqlTppNVmwAQTer0PfMRPU5giYGi3+/
 7XJOty8bsp3Q==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="45994430"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 May 2020 13:41:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id E3CD7A21DF;
        Tue, 26 May 2020 13:41:14 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 13:41:14 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.253) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 13:41:05 +0000
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.de>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7361cea4-7e2e-3ee6-b47e-b2a8ba22c860@amazon.com>
Date:   Tue, 26 May 2020 16:40:54 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526123300.GA2798@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D06UWC004.ant.amazon.com (10.43.162.97) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNS8yMDIwIDE1OjMzLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgTWF5IDI2LCAy
MDIwIGF0IDAxOjQyOjQxUE0gKzAyMDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Pgo+PiBPbiAy
Ni4wNS4yMCAwODo1MSwgR3JlZyBLSCB3cm90ZToKPj4+IE9uIFR1ZSwgTWF5IDI2LCAyMDIwIGF0
IDAxOjEzOjIzQU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4+PiArI2RlZmluZSBO
RSAibml0cm9fZW5jbGF2ZXM6ICIKPj4+IEFnYWluLCBubyBuZWVkIGZvciB0aGlzLgo+Pj4KPj4+
PiArI2RlZmluZSBORV9ERVZfTkFNRSAibml0cm9fZW5jbGF2ZXMiCj4+PiBLQlVJTERfTU9ETkFN
RT8KPj4+Cj4+Pj4gKyNkZWZpbmUgTkVfSU1BR0VfTE9BRF9PRkZTRVQgKDggKiAxMDI0VUwgKiAx
MDI0VUwpCj4+Pj4gKwo+Pj4+ICtzdGF0aWMgY2hhciAqbmVfY3B1czsKPj4+PiArbW9kdWxlX3Bh
cmFtKG5lX2NwdXMsIGNoYXJwLCAwNjQ0KTsKPj4+PiArTU9EVUxFX1BBUk1fREVTQyhuZV9jcHVz
LCAiPGNwdS1saXN0PiAtIENQVSBwb29sIHVzZWQgZm9yIE5pdHJvIEVuY2xhdmVzIik7Cj4+PiBB
Z2FpbiwgcGxlYXNlIGRvIG5vdCBkbyB0aGlzLgo+PiBJIGFjdHVhbGx5IGFza2VkIGhlciB0byBw
dXQgdGhpcyBvbmUgaW4gc3BlY2lmaWNhbGx5Lgo+Pgo+PiBUaGUgY29uY2VwdCBvZiB0aGlzIHBh
cmFtZXRlciBpcyB2ZXJ5IHNpbWlsYXIgdG8gaXNvbGNwdXM9IGFuZCBtYXhjcHVzPSBpbgo+PiB0
aGF0IGl0IHRha2VzIENQVXMgYXdheSBmcm9tIExpbnV4IGFuZCBpbnN0ZWFkIGRvbmF0ZXMgdGhl
bSB0byB0aGUKPj4gdW5kZXJseWluZyBoeXBlcnZpc29yLCBzbyB0aGF0IGl0IGNhbiBzcGF3biBl
bmNsYXZlcyB1c2luZyB0aGVtLgo+Pgo+PiAgRnJvbSBhbiBhZG1pbidzIHBvaW50IG9mIHZpZXcs
IHRoaXMgaXMgYSBzZXR0aW5nIEkgd291bGQgbGlrZSB0byBrZWVwCj4+IHBlcnNpc3RlZCBhY3Jv
c3MgcmVib290cy4gSG93IHdvdWxkIHRoaXMgd29yayB3aXRoIHN5c2ZzPwo+IEhvdyBhYm91dCBq
dXN0IGFzIHRoZSAiaW5pdGlhbCIgaW9jdGwgY29tbWFuZCB0byBzZXQgdGhpbmdzIHVwPyAgRG9u
J3QKPiBncmFiIGFueSBjcHUgcG9vbHMgdW50aWwgYXNrZWQgdG8uICBPdGhlcndpc2UsIHdoYXQg
aGFwcGVucyB3aGVuIHlvdQo+IGxvYWQgdGhpcyBtb2R1bGUgb24gYSBzeXN0ZW0gdGhhdCBjYW4n
dCBzdXBwb3J0IGl0Pwo+Cj4gbW9kdWxlIHBhcmFtZXRlcnMgYXJlIGEgbWFqb3IgcGFpbiwgeW91
IGtub3cgdGhpcyA6KQo+Cj4+IFNvIHllcywgbGV0J3MgZ2l2ZSBldmVyeW9uZSBpbiBDQyB0aGUg
Y2hhbmdlIHRvIHJldmlldyB2MyBwcm9wZXJseSBmaXJzdAo+PiBiZWZvcmUgdjQgZ29lcyBvdXQu
Cj4+Cj4+PiBBbmQgZ2V0IHRoZW0gdG8gc2lnbiBvZmYgb24gaXQgdG9vLCBzaG93aW5nIHRoZXkg
YWdyZWUgd2l0aCB0aGUgZGVzaWduCj4+PiBkZWNpc2lvbnMgaGVyZSA6KQo+PiBJIHdvdWxkIGV4
cGVjdCBhIFJldmlld2VkLWJ5IHRhZyBhcyBhIHJlc3VsdCBmcm9tIHRoZSBhYm92ZSB3b3VsZCBz
YXRpc2Z5Cj4+IHRoaXM/IDopCj4gVGhhdCB3b3VsZCBiZSBtb3N0IGFwcHJlY2lhdGVkLgoKV2l0
aCByZWdhcmRpbmcgdG8gcmV2aWV3aW5nLCB5ZXMsIHRoZSBwYXRjaCBzZXJpZXMgd2VudCB0aHJv
dWdoIHNldmVyYWwgCnJvdW5kcyBiZWZvcmUgc3VibWl0dGluZyBpdCB1cHN0cmVhbS4KCkkgcG9z
dGVkIHYzIHNob3J0bHkgYWZ0ZXIgdjIgdG8gaGF2ZSBtb3JlIHZpc2liaWxpdHkgaW50byB0aGUg
Y2hhbmdlbG9nIApmb3IgZWFjaCBwYXRjaCBpbiBhZGRpdGlvbiB0byB0aGUgY292ZXIgbGV0dGVy
IGNoYW5nZWxvZy4gQnV0IG5vIG1ham9yIApkZXNpZ24gY2hhbmdlcyBpbiB0aGVyZS4gOikKClRo
YW5rIHlvdS4KCkFuZHJhCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBT
LlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9v
ciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJv
bWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

