Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63C11BFB59
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgD3N70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:59:26 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:55590 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgD3N7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 09:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588255164; x=1619791164;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=DRh1x2n81OczNTTRQAJJlAM7ugTuGaMZPhGlmvFnHbw=;
  b=c07CBkLtiIU2OfE3LScMjZ3eI6jhuez7Tz25qRy6HHHZXph7t7WI1HZ/
   AEOqbdw4ygaM1+CvbvGiPSlwGP+m1yPmUtuXJlLLF9XIOw8JS0R6EvMDD
   HrhOOfWvPydSQz5qO+zgrFVRTL+2cF/aOlkH8gO0MOfDnP2f0mIksHX1D
   w=;
IronPort-SDR: /FFZ+ApaAE/IKWimclexhRpcmPXvkaZDR8Vq5fFEV86qB1lpyOf3+bFv904y7YWE7F0jcfFqQL
 JOF35abba7cA==
X-IronPort-AV: E=Sophos;i="5.73,336,1583193600"; 
   d="scan'208";a="32126486"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 30 Apr 2020 13:59:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 3F69AC5C2E;
        Thu, 30 Apr 2020 13:59:22 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 13:59:21 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 13:59:14 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
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
 <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
 <ad01ef35-9ee5-cf94-640c-4c26184946fa@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <60262862-8e82-608e-544d-8794ac36010e@amazon.com>
Date:   Thu, 30 Apr 2020 16:59:03 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ad01ef35-9ee5-cf94-640c-4c26184946fa@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOS8wNC8yMDIwIDE2OjIwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDI4LzA0LzIw
IDE3OjA3LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4+IFNvIHdoeSBub3QganVzdCBzdGFydCBy
dW5uaW5nIHRoZSBlbmNsYXZlIGF0IDB4ZmZmZmZmZjAgaW4gcmVhbCBtb2RlPwo+Pj4gWWVzIGV2
ZXJ5Ym9keSBoYXRlcyBpdCwgYnV0IHRoYXQncyB3aGF0IE9TZXMgYXJlIHdyaXR0ZW4gYWdhaW5z
dC4gIEluCj4+PiB0aGUgc2ltcGxlc3QgZXhhbXBsZSwgdGhlIHBhcmVudCBlbmNsYXZlIGNhbiBs
b2FkIGJ6SW1hZ2UgYW5kIGluaXRyZCBhdAo+Pj4gMHgxMDAwMCBhbmQgcGxhY2UgZmlybXdhcmUg
dGFibGVzIChNUFRhYmxlIGFuZCBETUkpIHNvbWV3aGVyZSBhdAo+Pj4gMHhmMDAwMDsgdGhlIGZp
cm13YXJlIHdvdWxkIGp1c3QgYmUgYSBmZXcgbW92cyB0byBzZWdtZW50IHJlZ2lzdGVycwo+Pj4g
Zm9sbG93ZWQgYnkgYSBsb25nIGptcC4KPj4gVGhlcmUgaXMgYSBiaXQgb2YgaW5pdGlhbCBhdHRl
c3RhdGlvbiBmbG93IGluIHRoZSBlbmNsYXZlLCBzbyB0aGF0Cj4+IHlvdSBjYW4gYmUgc3VyZSB0
aGF0IHRoZSBjb2RlIHRoYXQgaXMgcnVubmluZyBpcyBhY3R1YWxseSB3aGF0IHlvdSB3YW50ZWQg
dG8KPj4gcnVuLgo+IENhbiB5b3UgZXhwbGFpbiB0aGlzLCBzaW5jZSBpdCdzIG5vdCBkb2N1bWVu
dGVkPwoKSGFzaCB2YWx1ZXMgYXJlIGNvbXB1dGVkIGZvciB0aGUgZW50aXJlIGVuY2xhdmUgaW1h
Z2UgKEVJRiksIHRoZSBrZXJuZWwgCmFuZCByYW1kaXNrKHMpLiBUaGF0J3MgdXNlZCwgZm9yIGV4
YW1wbGUsIHRvIGNoZWNrdGhhdCB0aGUgZW5jbGF2ZSBpbWFnZSAKdGhhdCBpcyBsb2FkZWQgaW4g
dGhlIGVuY2xhdmUgVk0gaXMgdGhlIG9uZSB0aGF0IHdhcyBpbnRlbmRlZCB0byBiZSBydW4uCgpU
aGVzZSBjcnlwdG8gbWVhc3VyZW1lbnRzIGFyZSBpbmNsdWRlZCBpbiBhIHNpZ25lZCBhdHRlc3Rh
dGlvbiBkb2N1bWVudCAKZ2VuZXJhdGVkIGJ5IHRoZSBOaXRybyBIeXBlcnZpc29yIGFuZCBmdXJ0
aGVyIHVzZWQgdG8gcHJvdmUgdGhlIGlkZW50aXR5IApvZiB0aGUgZW5jbGF2ZS4gS01TIGlzIGFu
IGV4YW1wbGUgb2Ygc2VydmljZSB0aGF0IE5FIGlzIGludGVncmF0ZWQgd2l0aCAKYW5kIHRoYXQg
Y2hlY2tzIHRoZSBhdHRlc3RhdGlvbiBkb2MuCgo+Cj4+ICDCoCB2bSA9IG5lX2NyZWF0ZSh2Y3B1
cyA9IDQpCj4+ICDCoCBuZV9zZXRfbWVtb3J5KHZtLCBodmEsIGxlbikKPj4gIMKgIG5lX2xvYWRf
aW1hZ2Uodm0sIGFkZHIsIGxlbikKPj4gIMKgIG5lX3N0YXJ0KHZtKQo+Pgo+PiBUaGF0IHdheSB3
ZSB3b3VsZCBnZXQgdGhlIEVJRiBsb2FkaW5nIGludG8ga2VybmVsIHNwYWNlLiAiTE9BRF9JTUFH
RSIKPj4gd291bGQgb25seSBiZSBhdmFpbGFibGUgaW4gdGhlIHRpbWUgd2luZG93IGJldHdlZW4g
c2V0X21lbW9yeSBhbmQgc3RhcnQuCj4+IEl0IGJhc2ljYWxseSBpbXBsZW1lbnRzIGEgbWVtY3B5
KCksIGJ1dCBpdCB3b3VsZCBjb21wbGV0ZWx5IGhpZGUgdGhlCj4+IGhpZGRlbiBzZW1hbnRpY3Mg
b2Ygd2hlcmUgYW4gRUlGIGhhcyB0byBnbywgc28gZnV0dXJlIGRldmljZSB2ZXJzaW9ucwo+PiAo
b3IgZXZlbiBvdGhlciBlbmNsYXZlIGltcGxlbWVudGVycykgY291bGQgY2hhbmdlIHRoZSBsb2dp
Yy4KPj4KPj4gSSB0aGluayBpdCBhbHNvIG1ha2VzIHNlbnNlIHRvIGp1c3QgYWxsb2NhdGUgdGhv
c2UgNCBpb2N0bHMgZnJvbQo+PiBzY3JhdGNoLiBQYW9sbywgd291bGQgeW91IHN0aWxsIHdhbnQg
dG8gImRvbmF0ZSIgS1ZNIGlvY3RsIHNwYWNlIGluIHRoYXQKPj4gY2FzZT8KPiBTdXJlLCB0aGF0
J3Mgbm90IGEgcHJvYmxlbS4KCk9rLCB0aGFua3MgZm9yIGNvbmZpcm1hdGlvbi4gSSd2ZSB1cGRh
dGVkIHRoZSBpb2N0bCBudW1iZXIgZG9jdW1lbnRhdGlvbiAKdG8gcmVmbGVjdCB0aGUgaW9jdGwg
c3BhY2UgdXBkYXRlLCB0YWtpbmcgaW50byBhY2NvdW50IHRoZSBwcmV2aW91cyAKZGlzY3Vzc2lv
bjsgYW5kbm93LCBnaXZlbiBhbHNvIHRoZSBwcm9wb3NhbCBhYm92ZSBmcm9tIEFsZXgsIHRoZSAK
ZGlzY3Vzc2lvbnMgd2UgY3VycmVudGx5IGhhdmUgYW5kIGNvbnNpZGVyaW5nIGZ1cnRoZXIgZWFz
eSBleHRlbnNpYmlsaXR5IApvZiB0aGUgdXNlciBzcGFjZSBpbnRlcmZhY2UuCgpUaGFua3MsCkFu
ZHJhCgo+PiBPdmVyYWxsLCB0aGUgYWJvdmUgc2hvdWxkIGFkZHJlc3MgbW9zdCBvZiB0aGUgY29u
Y2VybnMgeW91IHJhaXNlZCBpbgo+PiB0aGlzIG1haWwsIHJpZ2h0PyBJdCBzdGlsbCByZXF1aXJl
cyBjb3B5aW5nLCBidXQgYXQgbGVhc3Qgd2UgZG9uJ3QgaGF2ZQo+PiB0byBrZWVwIHRoZSBjb3B5
IGluIGtlcm5lbCBzcGFjZS4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEp
IFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZs
b29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4g
Um9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

