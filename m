Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467D213C6CA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAOO7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:59:49 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28254 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOO7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 09:59:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579100387; x=1610636387;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Xylm1HenDeVfZQbL+8DTgipOgIDQH45ccAQmTF2tZjQ=;
  b=bCZufaPGKja8oAECTwST3W6XdIsE1DqR8Lh6rhcj8g9KpeXzEOBCO42q
   5cdq8LSdioxT0IPosumzAV/wbR0HeiLx+lzx8gFVUO2aLzkIIY099oOBH
   59RfvFD3M8L6thxnqNgaIw69DjHsrrZ1/JeOl5+WTENHy2Q2dTLLnQm3T
   s=;
IronPort-SDR: MiaDFVnvgDHbb/64asmrhwCbMEBI5F8DYpJ0FcS3F6Kh8D+FOhf7611W7vOlAAtMRkNO+eQTa8
 fc3QZ//FIOkQ==
X-IronPort-AV: E=Sophos;i="5.70,322,1574121600"; 
   d="scan'208";a="10486984"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 15 Jan 2020 14:59:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 4623AA3490;
        Wed, 15 Jan 2020 14:59:34 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:59:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.18) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:59:32 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     <milanpa@amazon.com>, Milan Pandurov <milanpa@amazon.de>,
        <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
Date:   Wed, 15 Jan 2020 15:59:30 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.18]
X-ClientProxiedBy: EX13D20UWA002.ant.amazon.com (10.43.160.176) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNS4wMS4yMCAxNTo0MywgbWlsYW5wYUBhbWF6b24uY29tIHdyb3RlOgo+IE9uIDEvMTUv
MjAgMzowNCBQTSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDE1LjAxLjIwIDE0
OjQzLCBNaWxhbiBQYW5kdXJvdiB3cm90ZToKPj4+IEtWTSBleHBvc2VzIGRlYnVnIGNvdW50ZXJz
IHRocm91Z2ggaW5kaXZpZHVhbCBkZWJ1Z2ZzIGZpbGVzLgo+Pj4gTW9uaXRvcmluZyB0aGVzZSBj
b3VudGVycyByZXF1aXJlcyBkZWJ1Z2ZzIHRvIGJlIGVuYWJsZWQvYWNjZXNzaWJsZSBmb3IKPj4+
IHRoZSBhcHBsaWNhdGlvbiwgd2hpY2ggbWlnaHQgbm90IGJlIGFsd2F5cyB0aGUgY2FzZS4KPj4+
IEFkZGl0aW9uYWxseSwgcGVyaW9kaWMgbW9uaXRvcmluZyBtdWx0aXBsZSBkZWJ1Z2ZzIGZpbGVz
IGZyb20KPj4+IHVzZXJzcGFjZSByZXF1aXJlcyBtdWx0aXBsZSBmaWxlIG9wZW4vcmVhZC9jbG9z
ZSArIGF0b2kgY29udmVyc2lvbgo+Pj4gb3BlcmF0aW9ucywgd2hpY2ggaXMgbm90IHZlcnkgZWZm
aWNpZW50Lgo+Pj4KPj4+IExldCdzIGV4cG9zZSBuZXcgaW50ZXJmYWNlIHRvIHVzZXJzcGFjZSBm
b3IgZ2FyaGVyaW5nIHRoZXNlCj4+PiBzdGF0aXN0aWNzIHdpdGggb25lIGlvY3RsLgo+Pj4KPj4+
IFR3byBuZXcgaW9jdGwgbWV0aG9kcyBhcmUgYWRkZWQ6Cj4+PiDCoCAtIEtWTV9HRVRfU1VQUE9S
VEVEX0RFQlVHRlNfU1RBVCA6IFJldHVybnMgbGlzdCBvZiBhdmFpbGFibGUgY291bnRlcgo+Pj4g
wqAgbmFtZXMuIE5hbWVzIGNvcnJlc3BvbmQgdG8gdGhlIGRlYnVnZnMgZmlsZSBuYW1lcwo+Pj4g
wqAgLSBLVk1fR0VUX0RFQlVHRlNfVkFMVUVTIDogUmV0dXJucyBsaXN0IG9mIHU2NCB2YWx1ZXMg
ZWFjaAo+Pj4gwqAgY29ycmVzcG9uZGluZyB0byBhIHZhbHVlIGRlc2NyaWJlZCBpbiBLVk1fR0VU
X1NVUFBPUlRFRF9ERUJVR0ZTX1NUQVQuCj4+Pgo+Pj4gVXNlcnNwYWNlIGFwcGxpY2F0aW9uIGNh
biByZWFkIGNvdW50ZXIgZGVzY3JpcHRpb24gb25jZSB1c2luZwo+Pj4gS1ZNX0dFVF9TVVBQT1JU
RURfREVCVUdGU19TVEFUIGFuZCBwZXJpb2RpY2FsbHkgaW52b2tlIHRoZQo+Pj4gS1ZNX0dFVF9E
RUJVR0ZTX1ZBTFVFUyB0byBnZXQgdmFsdWUgdXBkYXRlLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6
IE1pbGFuIFBhbmR1cm92IDxtaWxhbnBhQGFtYXpvbi5kZT4KPj4KPj4gVGhhbmtzIGEgbG90ISBJ
IHJlYWxseSBsb3ZlIHRoZSBpZGVhIHRvIGdldCBzdGF0cyBkaXJlY3RseSBmcm9tIHRoZSAKPj4g
a3ZtIHZtIGZkIG93bmVyLiBUaGlzIGlzIHNvIG11Y2ggYmV0dGVyIHRoYW4gcG9raW5nIGF0IGZp
bGVzIGZyb20gYSAKPj4gcmFuZG9tIHVucmVsYXRlZCBkZWJ1ZyBvciBzdGF0IGZpbGUgc3lzdGVt
Lgo+Pgo+PiBJIGhhdmUgYSBmZXcgY29tbWVudHMgb3ZlcmFsbCB0aG91Z2g6Cj4+Cj4+Cj4+IDEp
Cj4+Cj4+IFRoaXMgaXMgYW4gaW50ZXJmYWNlIHRoYXQgcmVxdWlyZXMgYSBsb3Qgb2YgbG9naWMg
YW5kIGJ1ZmZlcnMgZnJvbSAKPj4gdXNlciBzcGFjZSB0byByZXRyaWV2ZSBpbmRpdmlkdWFsLCBl
eHBsaWNpdCBjb3VudGVycy4gV2hhdCBpZiBJIGp1c3QgCj4+IHdhbnRlZCB0byBtb25pdG9yIHRo
ZSBudW1iZXIgb2YgZXhpdHMgb24gZXZlcnkgdXNlciBzcGFjZSBleGl0Pwo+IAo+IEluIGNhc2Ug
d2Ugd2FudCB0byBjb3ZlciBzdWNoIGxhdGVuY3kgc2Vuc2l0aXZlIHVzZSBjYXNlcyBzb2x1dGlv
biBiKSwgCj4gd2l0aCBtbWFwJ2VkIHN0cnVjdHMgeW91IHN1Z2dlc3RlZCwgd291bGQgYmUgYSB3
YXkgdG8gZ28sIElNTy4KPiAKPj4KPj4gQWxzbywgd2UncmUgc3VkZGVubHkgbWFraW5nIHRoZSBk
ZWJ1Z2ZzIG5hbWVzIGEgZnVsbCBBQkksIGJlY2F1c2UgCj4+IHRocm91Z2ggdGhpcyBpbnRlcmZh
Y2Ugd2Ugb25seSBpZGVudGlmeSB0aGUgaW5kaXZpZHVhbCBzdGF0cyB0aHJvdWdoIAo+PiB0aGVp
ciBuYW1lcy4gVGhhdCBtZWFucyB3ZSBjYW4gbm90IHJlbW92ZSBzdGF0cyBvciBjaGFuZ2UgdGhl
aXIgbmFtZXMsIAo+PiBiZWNhdXNlIHBlb3BsZSBtYXkgcmVseSBvbiB0aGVtLCBubz8gVGhpbmlu
ZyBhYm91dCB0aGlzIGFnYWluLCBtYXliZSAKPj4gdGhleSBhbHJlYWR5IGFyZSBhbiBBQkkgYmVj
YXVzZSBwZW9wbGUgcmVseSBvbiB0aGVtIGluIGRlYnVnZnMgdGhvdWdoPwo+Pgo+PiBJIHNlZSB0
d28gYWx0ZXJuYXRpdmVzIHRvIHRoaXMgYXBwcm9hY2ggaGVyZToKPj4KPj4gYSkgT05FX1JFRwo+
Pgo+PiBXZSBjYW4ganVzdCBhZGQgYSBuZXcgREVCVUcgYXJjaCBpbiBPTkVfUkVHIGFuZCBleHBv
c2UgT05FX1JFRyBwZXIgVk0gCj4+IGFzIHdlbGwgKGlmIHdlIHJlYWxseSBoYXZlIHRvPykuIFRo
YXQgZ2l2ZXMgdXMgZXhwbGljaXQgaWRlbnRpZmllcnMgCj4+IGZvciBlYWNoIHN0YXQgd2l0aCBh
biBleHBsaWNpdCBwYXRoIHRvIGludHJvZHVjZSBuZXcgb25lcyB3aXRoIHZlcnkgCj4+IHVuaXF1
ZSBpZGVudGlmaWVycy4KPj4KPj4gVGhhdCB3b3VsZCBnaXZlIHVzIGEgdmVyeSBlYXNpbHkgc3Ry
dWN0dXJlZCBhcHByb2FjaCB0byByZXRyaWV2ZSAKPj4gaW5kaXZpZHVhbCBjb3VudGVycy4KPj4K
Pj4gYikgcGFydCBvZiB0aGUgbW1hcCdlZCB2Y3B1IHN0cnVjdAo+Pgo+PiBXZSBjb3VsZCBzaW1w
bHkgbW92ZSB0aGUgY291bnRlcnMgaW50byB0aGUgc2hhcmVkIHN0cnVjdCB0aGF0IHdlIAo+PiBl
eHBvc2UgdG8gdXNlciBzcGFjZSB2aWEgbW1hcC4gSUlSQyB3ZSBvbmx5IGhhdmUgdGhhdCBwZXIt
dmNwdSwgYnV0IAo+PiB0aGVuIGFnYWluIG1vc3QgY291bnRlcnMgYXJlIHBlci12Y3B1IGFueXdh
eSwgc28gd2Ugd291bGQgcHVzaCB0aGUgCj4+IGFnZ3JlZ2F0aW9uIHRvIHVzZXIgc3BhY2UuCj4+
Cj4+IEZvciBwZXItdm0gb25lcywgbWF5YmUgd2UgY2FuIGp1c3QgYWRkIGFub3RoZXIgbW1hcCdl
ZCBzaGFyZWQgcGFnZSBmb3IgCj4+IHRoZSB2bSBmZD8KPj4KPj4KPj4gMikgdmNwdSBjb3VudGVy
cwo+Pgo+PiBNb3N0IG9mIHRoZSBjb3VudGVycyBjb3VudCBvbiB2Y3B1IGdyYW51bGFyaXR5LCBi
dXQgZGVidWdmcyBvbmx5IGdpdmVzIAo+PiB1cyBhIGZ1bGwgVk0gdmlldy4gV2hhdGV2ZXIgd2Ug
ZG8gdG8gaW1wcm92ZSB0aGUgc2l0dWF0aW9uLCB3ZSBzaG91bGQgCj4+IGRlZmluaXRlbHkgdHJ5
IHRvIGJ1aWxkIHNvbWV0aGluZyB0aGF0IGFsbG93cyB1cyB0byBnZXQgdGhlIGNvdW50ZXJzIAo+
PiBwZXIgdmNwdSAoYXMgd2VsbCkuCj4+Cj4+IFRoZSBtYWluIHB1cnBvc2Ugb2YgdGhlc2UgY291
bnRlcnMgaXMgbW9uaXRvcmluZy4gSXQgY2FuIGJlIHF1aXRlIAo+PiBpbXBvcnRhbnQgdG8ga25v
dyB0aGF0IG9ubHkgYSBzaW5nbGUgdkNQVSBpcyBnb2luZyB3aWxkLCBjb21wYXJlZCB0byAKPj4g
YWxsIG9mIHRoZW0gZm9yIGV4YW1wbGUuCj4gCj4gSSBhZ3JlZSwgZXhwb3NpbmcgcGVyIHZjcHUg
Y291bnRlcnMgY2FuIGJlIHVzZWZ1bC4gSSBndWVzcyBpdCBkaWRuJ3QgCj4gbWFrZSBtdWNoIHNl
bnNlIGV4cG9zaW5nIHRoZW0gdGhyb3VnaCBkZWJ1Z2ZzIHNvIGFnZ3JlZ2F0aW9uIHdhcyBkb25l
IGluIAo+IGtlcm5lbC4gSG93ZXZlciBpZiB3ZSBjaG9zZSB0byBnbyB3aXRoIGFwcHJvYWNoIDEt
YikgbW1hcCBjb3VudGVycyAKPiBzdHJ1Y3QgaW4gdXNlcnNwYWNlLCB3ZSBjb3VsZCBkbyB0aGlz
LgoKV2UgY291bGQgZG8gaXQgaW4gYW55IGFwcHJvYWNoLCBldmVuIHdpdGggc3RhdGZzIGlmIHdl
IGRvIGRpcmVjdG9yaWVzIApwZXIgdmNwdSA6KS4KClRoZSByZWFzb24gSSBkaXNsaWtlIHRoZSBk
ZWJ1Z2ZzL3N0YXRmcyBhcHByb2FjaCBpcyB0aGF0IGl0IGdlbmVyYXRlcyBhIApjb21wbGV0ZWx5
IHNlcGFyYXRlIHBlcm1pc3Npb24gYW5kIGFjY2VzcyBwYXRocyB0byB0aGUgc3RhdHMuIFRoYXQn
cyAKZ3JlYXQgZm9yIGZ1bGwgc3lzdGVtIG1vbml0b3JpbmcsIGJ1dCByZWFsbHkgYmFkIHdoZW4g
eW91IGhhdmUgbXVsdGlwbGUgCmluZGl2aWR1YWwgdGVuYW50cyBvbiBhIHNpbmdsZSBob3N0LgoK
CkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0
ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdl
ciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1
cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5
CgoK

