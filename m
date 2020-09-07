Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC47825FCC2
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgIGPNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 11:13:41 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:63706 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbgIGPNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 11:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599491595; x=1631027595;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=DC0ZNEU9f0Rg2pENLvMoKZMfD9fYypIqtII9gGZVRko=;
  b=WUTaNVGRluV8iKGDV13f9TzsVMasmsRfJCo5h/TDpN381GmFNtY9GKn6
   79MpkOHGA1k5pIX8FelA4LcDjVecECESr6N9L/V4FgL3jUXPXlvVvoRfW
   3mmRTfl6o+K1gnPlAGHaThBCPAikHsw+zB6rv7wFG75GGs36eW3KJdzss
   s=;
X-IronPort-AV: E=Sophos;i="5.76,402,1592870400"; 
   d="scan'208";a="52498776"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Sep 2020 15:05:43 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 37867A242C;
        Mon,  7 Sep 2020 15:05:40 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.34) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 15:05:32 +0000
Subject: Re: [PATCH v8 15/18] nitro_enclaves: Add Makefile for the Nitro
 Enclaves driver
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
 <20200904173718.64857-16-andraprs@amazon.com>
 <20200907090011.GC1101646@kroah.com>
 <f5c0f79c-f581-fab5-9a3b-97380ef7fc2a@amazon.com>
 <20200907140841.GB3719869@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <e3891965-758b-7caf-0699-d182f4951cc4@amazon.com>
Date:   Mon, 7 Sep 2020 18:05:23 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907140841.GB3719869@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDE3OjA4LCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gTW9uLCBTZXAgMDcs
IDIwMjAgYXQgMDQ6MzU6MjNQTSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToK
Pj4KPj4gT24gMDcvMDkvMjAyMCAxMjowMCwgR3JlZyBLSCB3cm90ZToKPj4+Cj4+PiBPbiBGcmks
IFNlcCAwNCwgMjAyMCBhdCAwODozNzoxNVBNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6
Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29t
Pgo+Pj4+IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+Pj4+
IC0tLQo+Pj4+IENoYW5nZWxvZwo+Pj4+Cj4+Pj4gdjcgLT4gdjgKPj4+Pgo+Pj4+ICogTm8gY2hh
bmdlcy4KPj4+Pgo+Pj4+IHY2IC0+IHY3Cj4+Pj4KPj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4KPj4+
PiB2NSAtPiB2Ngo+Pj4+Cj4+Pj4gKiBObyBjaGFuZ2VzLgo+Pj4+Cj4+Pj4gdjQgLT4gdjUKPj4+
Pgo+Pj4+ICogTm8gY2hhbmdlcy4KPj4+Pgo+Pj4+IHYzIC0+IHY0Cj4+Pj4KPj4+PiAqIE5vIGNo
YW5nZXMuCj4+Pj4KPj4+PiB2MiAtPiB2Mwo+Pj4+Cj4+Pj4gKiBSZW1vdmUgdGhlIEdQTCBhZGRp
dGlvbmFsIHdvcmRpbmcgYXMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXIgaXMKPj4+PiAgICAgYWxy
ZWFkeSBpbiBwbGFjZS4KPj4+Pgo+Pj4+IHYxIC0+IHYyCj4+Pj4KPj4+PiAqIFVwZGF0ZSBwYXRo
IHRvIE1ha2VmaWxlIHRvIG1hdGNoIHRoZSBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMKPj4+
PiAgICAgZGlyZWN0b3J5Lgo+Pj4+IC0tLQo+Pj4+ICAgIGRyaXZlcnMvdmlydC9NYWtlZmlsZSAg
ICAgICAgICAgICAgICB8ICAyICsrCj4+Pj4gICAgZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVz
L01ha2VmaWxlIHwgMTEgKysrKysrKysrKysKPj4+PiAgICAyIGZpbGVzIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKykKPj4+PiAgICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy92aXJ0L25pdHJv
X2VuY2xhdmVzL01ha2VmaWxlCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L01h
a2VmaWxlIGIvZHJpdmVycy92aXJ0L01ha2VmaWxlCj4+Pj4gaW5kZXggZmQzMzEyNDdjMjdhLi5m
Mjg0MjVjZTRiMzkgMTAwNjQ0Cj4+Pj4gLS0tIGEvZHJpdmVycy92aXJ0L01ha2VmaWxlCj4+Pj4g
KysrIGIvZHJpdmVycy92aXJ0L01ha2VmaWxlCj4+Pj4gQEAgLTUsMyArNSw1IEBACj4+Pj4KPj4+
PiAgICBvYmotJChDT05GSUdfRlNMX0hWX01BTkFHRVIpICs9IGZzbF9oeXBlcnZpc29yLm8KPj4+
PiAgICBvYmoteSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKz0gdmJveGd1ZXN0Lwo+
Pj4+ICsKPj4+PiArb2JqLSQoQ09ORklHX05JVFJPX0VOQ0xBVkVTKSArPSBuaXRyb19lbmNsYXZl
cy8KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL01ha2VmaWxl
IGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL01ha2VmaWxlCj4+Pj4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKPj4+PiBpbmRleCAwMDAwMDAwMDAwMDAuLmU5ZjRmY2QxNTkxZQo+Pj4+IC0tLSAv
ZGV2L251bGwKPj4+PiArKysgYi9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvTWFrZWZpbGUK
Pj4+PiBAQCAtMCwwICsxLDExIEBACj4+Pj4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjAKPj4+PiArIwo+Pj4+ICsjIENvcHlyaWdodCAyMDIwIEFtYXpvbi5jb20sIEluYy4gb3Ig
aXRzIGFmZmlsaWF0ZXMuIEFsbCBSaWdodHMgUmVzZXJ2ZWQuCj4+Pj4gKwo+Pj4+ICsjIEVuY2xh
dmUgbGlmZXRpbWUgbWFuYWdlbWVudCBzdXBwb3J0IGZvciBOaXRybyBFbmNsYXZlcyAoTkUpLgo+
Pj4+ICsKPj4+PiArb2JqLSQoQ09ORklHX05JVFJPX0VOQ0xBVkVTKSArPSBuaXRyb19lbmNsYXZl
cy5vCj4+Pj4gKwo+Pj4+ICtuaXRyb19lbmNsYXZlcy15IDo9IG5lX3BjaV9kZXYubyBuZV9taXNj
X2Rldi5vCj4+Pj4gKwo+Pj4+ICtjY2ZsYWdzLXkgKz0gLVdhbGwKPj4+IFRoYXQgZmxhZyBpcyBf
cmVhbGx5XyByaXNreSBvdmVyIHRpbWUsIGFyZSB5b3UgX1NVUkVfIHRoYXQgYWxsIG5ldwo+Pj4g
dmVyc2lvbnMgb2YgY2xhbmcgYW5kIGdjYyB3aWxsIG5ldmVyIHByb2R1Y2UgYW55IHdhcm5pbmdz
PyAgUGVvcGxlIHdvcmsKPj4+IHRvIGZpeCB1cCBidWlsZCB3YXJuaW5ncyBxdWl0ZSBxdWlja2x5
IGZvciBuZXcgY29tcGlsZXJzLCB5b3Ugc2hvdWxkbid0Cj4+PiBwcmV2ZW50IHRoZSBjb2RlIGZy
b20gYmVpbmcgYnVpbHQgYXQgYWxsIGp1c3QgZm9yIHRoYXQsIHJpZ2h0Pwo+Pj4KPj4gVGhhdCB3
b3VsZCBhbHNvIG5lZWQgV2Vycm9yLCB0byBoYXZlIHdhcm5pbmdzIHRyZWF0ZWQgYXMgZXJyb3Jz
IGFuZCBwcmV2ZW50Cj4+IGJ1aWxkaW5nIHRoZSBjb2RlYmFzZS4gSWYgaXQncyBhYm91dCBzb21l
dGhpbmcgbW9yZSwganVzdCBsZXQgbWUga25vdy4KPiBObywgeW91IGFyZSByaWdodCwgV2Vycm9y
IHdvdWxkIGJlIG5lZWRlZCBoZXJlIHRvby4KPgo+IFc9MSBnaXZlcyB5b3UgLVdhbGwgaWYgeW91
IHJlYWxseSB3YW50IHRoYXQsIG5vIG5lZWQgdG8gYWRkIGl0IGJ5IGhhbmQuCgpHb29kLCB3ZSBh
cmUgb24gdGhlIHNvbWUgcGFnZSB0aGVuLiA6KSBUaGFua3MgZm9yIHRoZSBoZWFkcy11cCB3aXRo
IApyZWdhcmQgdG8gdGhlIFc9MSBvcHRpb24uCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

