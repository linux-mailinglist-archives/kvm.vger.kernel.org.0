Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C41B7EA4
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgDXTME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 15:12:04 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:14434 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgDXTME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 15:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587755523; x=1619291523;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ME/YXWe0ohXf40iDcxvNpUgqsZPRQIUDU3FFaqqgyEc=;
  b=qQ2jLmyfivvE0DnHOHP/CpCbmEKSwJZt5tGn5I0Cjf2bxGBUK+mRJepv
   0HO4F4SVMmX7KS2VTlh3pcPB9vlGnTDhtodzTSnLcNbclqLvpA+uIMyu1
   5A6dQHb5OoI2qWCkeQdjNpN7vA4Aq38/h4Zjq8Hpe0UGXEww2OrtJYhWx
   A=;
IronPort-SDR: 8t5VKU22qfZq/K8ec7FbEcqvcoOtRgqXXRqlMsiBnvQC6RTnSO67fzcjGuS9IXr6yCJDmBYiif
 zA+ynmQ7x0EA==
X-IronPort-AV: E=Sophos;i="5.73,313,1583193600"; 
   d="scan'208";a="39336647"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Apr 2020 19:12:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 121A5240FFF;
        Fri, 24 Apr 2020 19:12:00 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 19:11:59 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.27) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 19:11:55 +0000
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
Date:   Fri, 24 Apr 2020 21:11:52 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D07UWB003.ant.amazon.com (10.43.161.66) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI0LjA0LjIwIDE4OjI3LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IAo+IE9uIDI0LzA0LzIw
IDE0OjU2LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gWWVzLCB0aGF0IHBhcnQgaXMgbm90IGRv
Y3VtZW50ZWQgaW4gdGhlIHBhdGNoIHNldCwgY29ycmVjdC4gSSB3b3VsZAo+PiBwZXJzb25hbGx5
IGp1c3QgbWFrZSBhbiBleGFtcGxlIHVzZXIgc3BhY2UgYmluYXJ5IHRoZSBkb2N1bWVudGF0aW9u
IGZvcgo+PiBub3cuIExhdGVyIHdlIHdpbGwgcHVibGlzaCBhIHByb3BlciBkZXZpY2Ugc3BlY2lm
aWNhdGlvbiBvdXRzaWRlIG9mIHRoZQo+PiBMaW51eCBlY29zeXN0ZW0gd2hpY2ggd2lsbCBkZXNj
cmliZSB0aGUgcmVnaXN0ZXIgbGF5b3V0IGFuZCBpbWFnZQo+PiBsb2FkaW5nIHNlbWFudGljcyBp
biB2ZXJiYXRpbSwgc28gdGhhdCBvdGhlciBPU3MgY2FuIGltcGxlbWVudCB0aGUKPj4gZHJpdmVy
IHRvby4KPiAKPiBCdXQgdGhpcyBpcyBub3QgcGFydCBvZiB0aGUgZGV2aWNlIHNwZWNpZmljYXRp
b24sIGl0J3MgcGFydCBvZiB0aGUgY2hpbGQKPiBlbmNsYXZlIHZpZXcuICBBbmQgaW4gbXkgb3Bp
bmlvbiwgdW5kZXJzdGFuZGluZyB0aGUgd2F5IHRoZSBjaGlsZAo+IGVuY2xhdmUgaXMgcHJvZ3Jh
bW1lZCBpcyB2ZXJ5IGltcG9ydGFudCB0byB1bmRlcnN0YW5kIGlmIExpbnV4IHNob3VsZCBhdAo+
IGFsbCBzdXBwb3J0IHRoaXMgbmV3IGRldmljZS4KCk9oLCBhYnNvbHV0ZWx5LiBBbGwgb2YgdGhl
ICJob3cgZG8gSSBsb2FkIGFuIGVuY2xhdmUgaW1hZ2UsIHJ1biBpdCBhbmQgCmludGVyYWN0IHdp
dGggaXQiIGJpdHMgbmVlZCB0byBiZSBleHBsYWluZWQuCgpXaGF0IEkgd2FzIHNheWluZyBhYm92
ZSBpcyB0aGF0IG1heWJlIGNvZGUgaXMgZWFzaWVyIHRvIHRyYW5zZmVyIHRoYXQgCnRoYW4gYSAu
dHh0IGZpbGUgdGhhdCBnZXRzIGxvc3Qgc29tZXdoZXJlIGluIHRoZSBEb2N1bWVudGF0aW9uIGRp
cmVjdG9yeSA6KS4KCkknbSBtb3JlIHRoYW4gaGFwcHkgdG8gaGVhciBvZiBvdGhlciBzdWdnZXN0
aW9ucyB0aG91Z2guCgo+IAo+PiBUbyBhbnN3ZXIgdGhlIHF1ZXN0aW9uIHRob3VnaCwgdGhlIHRh
cmdldCBmaWxlIGlzIGluIGEgbmV3bHkgaW52ZW50ZWQKPj4gZmlsZSBmb3JtYXQgY2FsbGVkICJF
SUYiIGFuZCBpdCBuZWVkcyB0byBiZSBsb2FkZWQgYXQgb2Zmc2V0IDB4ODAwMDAwIG9mCj4+IHRo
ZSBhZGRyZXNzIHNwYWNlIGRvbmF0ZWQgdG8gdGhlIGVuY2xhdmUuCj4gCj4gV2hhdCBpcyB0aGlz
IEVJRj8KCkl0J3MganVzdCBhIHZlcnkgZHVtYiBjb250YWluZXIgZm9ybWF0IHRoYXQgaGFzIGEg
dHJpdmlhbCBoZWFkZXIsIGEgCnNlY3Rpb24gd2l0aCB0aGUgYnpJbWFnZSBhbmQgb25lIHRvIG1h
bnkgc2VjdGlvbnMgb2YgaW5pdHJhbWZzLgoKQXMgbWVudGlvbmVkIGVhcmxpZXIgaW4gdGhpcyB0
aHJlYWQsIGl0IHJlYWxseSBpcyBqdXN0ICIta2VybmVsIiBhbmQgCiItaW5pdHJkIiwgcGFja2Vk
IGludG8gYSBzaW5nbGUgYmluYXJ5IGZvciB0cmFuc21pc3Npb24gdG8gdGhlIGhvc3QuCgo+IAo+
ICogYSBuZXcgTGludXgga2VybmVsIGZvcm1hdD8gIElmIHNvLCBhcmUgdGhlcmUgcGF0Y2hlcyBp
biBmbGlnaHQgdG8KPiBjb21waWxlIExpbnV4IGluIHRoaXMgbmV3IGZvcm1hdCAoYW5kIEkgd291
bGQgYmUgc3VycHJpc2VkIGlmIHRoZXkgd2VyZQo+IGFjY2VwdGVkLCBzaW5jZSB3ZSBhbHJlYWR5
IGhhdmUgUFZIIGFzIGEgc3RhbmRhcmQgd2F5IHRvIGJvb3QKPiB1bmNvbXByZXNzZWQgTGludXgg
a2VybmVscyk/Cj4gCj4gKiBhIHVzZXJzcGFjZSBiaW5hcnkgKHRoZSBDUEwzIHRoYXQgQW5kcmEg
d2FzIHJlZmVycmluZyB0byk/ICBJbiB0aGF0Cj4gY2FzZSB3aGF0IGlzIHRoZSByYXRpb25hbGUg
dG8gcHJlZmVyIGl0IG92ZXIgYSBzdGF0aWNhbGx5IGxpbmtlZCBFTEYgYmluYXJ5Pwo+IAo+ICog
c29tZXRoaW5nIGNvbXBsZXRlbHkgZGlmZmVyZW50IGxpa2UgV2ViQXNzZW1ibHk/Cj4gCj4gQWdh
aW4sIEkgY2Fubm90IHByb3ZpZGUgYSBzZW5zaWJsZSByZXZpZXcgd2l0aG91dCBleHBsYWluaW5n
IGhvdyB0byB1c2UKPiBhbGwgdGhpcy4gIEkgdW5kZXJzdGFuZCB0aGF0IEFtYXpvbiBuZWVkcyB0
byBkbyBwYXJ0IG9mIHRoZSBkZXNpZ24KPiBiZWhpbmQgY2xvc2VkIGRvb3JzLCBidXQgdGhpcyBz
ZWVtcyB0byBoYXZlIHRoZSByZXN1bHRlZCBpbiBpc3N1ZXMgdGhhdAo+IHJlbWluZHMgbWUgb2Yg
SW50ZWwncyBTR1ggbWlzYWR2ZW50dXJlcy4gSWYgQW1hem9uIGhhcyBkZXNpZ25lZCBORSBpbiBh
Cj4gd2F5IHRoYXQgaXMgaW5jb21wYXRpYmxlIHdpdGggb3BlbiBzdGFuZGFyZHMsIGl0J3MgdXAg
dG8gQW1hem9uIHRvIGZpeAoKT2gsIGlmIHRoZXJlJ3MgYW55dGhpbmcgdGhhdCBjb25mbGljdHMg
d2l0aCBvcGVuIHN0YW5kYXJkcyBoZXJlLCBJIHdvdWxkIApsb3ZlIHRvIGhlYXIgaXQgaW1tZWRp
YXRlbHkuIEkgZG8gbm90IGJlbGlldmUgaW4gc2VjdXJpdHkgYnkgb2JzY3VyaXR5ICA6KS4KCgpB
bGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIu
IDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIs
IEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJn
IHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoK
Cg==

