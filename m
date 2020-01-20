Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C255E14311C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 18:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgATRx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 12:53:29 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32973 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 12:53:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579542809; x=1611078809;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=kLR56pBeoIQIBwhJEVejIEs3Zg5AXV/xpQO01Xxpq9U=;
  b=TM0Uw1uiTvtEBSwvPx88ULvbQowT1nKxjBk7ak8WPD6+zIkjWAtrHB//
   8uyZ0qOrbRG8iKTYcuEwE4XsHNUbxTzsxxwmoAC4TArcJ/PFoxJfsKRge
   4WlBxeXJEff4dhVkW14zx/2v6rEou8l6meNELiCAgRWVgqe1f6WnBdywO
   8=;
IronPort-SDR: etF+2bH1TcpFfv0q4gTrPc7NHaeM1CeeJicDZhaO4/Fsp3nCOT5fJrCcVZkpp1OQZPFjwrPjgk
 72sy4I21Qs9w==
X-IronPort-AV: E=Sophos;i="5.70,342,1574121600"; 
   d="scan'208";a="19823839"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 20 Jan 2020 17:53:17 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id A5582A22FE;
        Mon, 20 Jan 2020 17:53:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 Jan 2020 17:53:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.205) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 Jan 2020 17:53:12 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Paolo Bonzini <pbonzini@redhat.com>, <milanpa@amazon.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
Date:   Mon, 20 Jan 2020 18:53:10 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.205]
X-ClientProxiedBy: EX13D18UWC002.ant.amazon.com (10.43.162.88) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wMS4yMCAwMDozOCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAxNS8wMS8yMCAx
NTo1OSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+IE9uIDE1LjAxLjIwIDE1OjQzLCBtaWxhbnBh
QGFtYXpvbi5jb20gd3JvdGU6Cj4+Pj4+IExldCdzIGV4cG9zZSBuZXcgaW50ZXJmYWNlIHRvIHVz
ZXJzcGFjZSBmb3IgZ2FyaGVyaW5nIHRoZXNlCj4+Pj4+IHN0YXRpc3RpY3Mgd2l0aCBvbmUgaW9j
dGwuCj4+Pj4+Cj4+Pj4+IFVzZXJzcGFjZSBhcHBsaWNhdGlvbiBjYW4gcmVhZCBjb3VudGVyIGRl
c2NyaXB0aW9uIG9uY2UgdXNpbmcKPj4+Pj4gS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19TVEFU
IGFuZCBwZXJpb2RpY2FsbHkgaW52b2tlIHRoZQo+Pj4+PiBLVk1fR0VUX0RFQlVHRlNfVkFMVUVT
IHRvIGdldCB2YWx1ZSB1cGRhdGUuCj4+Pj4KPj4+PiBUaGlzIGlzIGFuIGludGVyZmFjZSB0aGF0
IHJlcXVpcmVzIGEgbG90IG9mIGxvZ2ljIGFuZCBidWZmZXJzIGZyb20KPj4+PiB1c2VyIHNwYWNl
IHRvIHJldHJpZXZlIGluZGl2aWR1YWwsIGV4cGxpY2l0IGNvdW50ZXJzLiBXaGF0IGlmIEkganVz
dAo+Pj4+IHdhbnRlZCB0byBtb25pdG9yIHRoZSBudW1iZXIgb2YgZXhpdHMgb24gZXZlcnkgdXNl
ciBzcGFjZSBleGl0Pwo+Pj4KPj4+IEluIGNhc2Ugd2Ugd2FudCB0byBjb3ZlciBzdWNoIGxhdGVu
Y3kgc2Vuc2l0aXZlIHVzZSBjYXNlcyBzb2x1dGlvbiBiKSwKPj4+IHdpdGggbW1hcCdlZCBzdHJ1
Y3RzIHlvdSBzdWdnZXN0ZWQsIHdvdWxkIGJlIGEgd2F5IHRvIGdvLCBJTU8uCj4+Pgo+Pj4+IEFs
c28sIHdlJ3JlIHN1ZGRlbmx5IG1ha2luZyB0aGUgZGVidWdmcyBuYW1lcyBhIGZ1bGwgQUJJLCBi
ZWNhdXNlCj4+Pj4gdGhyb3VnaCB0aGlzIGludGVyZmFjZSB3ZSBvbmx5IGlkZW50aWZ5IHRoZSBp
bmRpdmlkdWFsIHN0YXRzIHRocm91Z2gKPj4+PiB0aGVpciBuYW1lcy4gVGhhdCBtZWFucyB3ZSBj
YW4gbm90IHJlbW92ZSBzdGF0cyBvciBjaGFuZ2UgdGhlaXIKPj4+PiBuYW1lcywgYmVjYXVzZSBw
ZW9wbGUgbWF5IHJlbHkgb24gdGhlbSwgbm8/IFRoaW5pbmcgYWJvdXQgdGhpcyBhZ2FpbiwKPj4+
PiBtYXliZSB0aGV5IGFscmVhZHkgYXJlIGFuIEFCSSBiZWNhdXNlIHBlb3BsZSByZWx5IG9uIHRo
ZW0gaW4gZGVidWdmcwo+Pj4+IHRob3VnaD8KPiAKPiBJbiB0aGVvcnkgbm90LCBpbiBwcmFjdGlj
ZSBJIGhhdmUgdHJlYXRlZCB0aGVtIGFzIGEga2luZCBvZiAic29mdCIgQUJJOgo+IGlmIHRoZSBt
ZWFuaW5nIGNoYW5nZXMgeW91IHNob3VsZCByZW5hbWUgdGhlbSwgYW5kIHJlbW92aW5nIHRoZW0g
aXMKPiBmaW5lLCBidXQgeW91IHNob3VsZG4ndCBmb3IgZXhhbXBsZSBjaGFuZ2UgdGhlIHVuaXQg
b2YgbWVhc3VyZSAod2hpY2ggaXMKPiBub3QgaGFyZCBzaW5jZSB0aGV5IGFyZSBhbGwgY291bnRl
cnMgOikgYnV0IHBlcmhhcHMgeW91IGNvdWxkIGhhdmUKPiBuYW5vc2Vjb25kcyB2cyBUU0MgY3lj
bGVzIGluIHRoZSBmdXR1cmUgZm9yIHNvbWUgY291bnRlcnMpLgo+IAo+Pj4+IEkgc2VlIHR3byBh
bHRlcm5hdGl2ZXMgdG8gdGhpcyBhcHByb2FjaCBoZXJlOgo+Pj4+Cj4+Pj4gYSkgT05FX1JFRwo+
Pj4+Cj4+Pj4gV2UgY2FuIGp1c3QgYWRkIGEgbmV3IERFQlVHIGFyY2ggaW4gT05FX1JFRyBhbmQg
ZXhwb3NlIE9ORV9SRUcgcGVyIFZNCj4+Pj4gYXMgd2VsbCAoaWYgd2UgcmVhbGx5IGhhdmUgdG8/
KS4gVGhhdCBnaXZlcyB1cyBleHBsaWNpdCBpZGVudGlmaWVycwo+Pj4+IGZvciBlYWNoIHN0YXQg
d2l0aCBhbiBleHBsaWNpdCBwYXRoIHRvIGludHJvZHVjZSBuZXcgb25lcyB3aXRoIHZlcnkKPj4+
PiB1bmlxdWUgaWRlbnRpZmllcnMuCj4gT05FX1JFRyB3b3VsZCBmb3JjZSB1cyB0byBkZWZpbmUg
Y29uc3RhbnRzIGZvciBlYWNoIGNvdW50ZXIsIGFuZCB3b3VsZAo+IG1ha2UgaXQgaGFyZCB0byBy
ZXRpcmUgdGhlbS4gIEkgZG9uJ3QgbGlrZSB0aGlzLgoKV2h5IGRvZXMgaXQgbWFrZSBpdCBoYXJk
IHRvIHJldGlyZSB0aGVtPyBXZSB3b3VsZCBqdXN0IHJldHVybiAtRUlOVkFMIG9uIApyZXRyaWV2
YWwsIGxpa2Ugd2UgZG8gZm9yIGFueSBvdGhlciBub24tc3VwcG9ydGVkIE9ORV9SRUcuCgpJdCdz
IHRoZSBzYW1lIGFzIGEgZmlsZSBub3QgZXhpc3RpbmcgaW4gZGVidWdmcy9zdGF0ZnMuIE9yIGFu
IGVudHJ5IGluIAp0aGUgYXJyYXkgb2YgdGhpcyBwYXRjaCB0byBkaXNhcHBlYXIuCgo+IAo+Pj4+
IGIpIHBhcnQgb2YgdGhlIG1tYXAnZWQgdmNwdSBzdHJ1Y3QKPiAKPiBTYW1lIGhlcmUuICBFdmVu
IGlmIHdlIHNheSB0aGUgc2VtYW50aWNzIG9mIHRoZSBzdHJ1Y3Qgd291bGQgYmUgZXhwb3NlZAo+
IHRvIHVzZXJzcGFjZSB2aWEgS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19TVEFULCBzb21lb25l
IG1pZ2h0IGVuZCB1cAo+IGdldHRpbmcgdGhpcyB3cm9uZyBhbmQgZXhwZWN0aW5nIGEgcGFydGlj
dWxhciBsYXlvdXQuICBNaWxhbidzIHByb3Bvc2VkCj4gQVBJIGhhcyB0aGUgYmlnIGFkdmFudGFn
ZSBvZiBiZWluZyBoYXJkIHRvIGdldCB3cm9uZyBmb3IgdXNlcnNwYWNlLiAgQW5kCj4gcHVzaGlu
ZyB0aGUgYWdncmVnYXRpb24gdG8gdXNlcnNwYWNlIGlzIG5vdCBhIGh1Z2UgY2hvcmUsIGJ1dCBp
dCdzIHN0aWxsCj4gYSBjaG9yZS4KPiAKPiBTbyB1bmxlc3Mgc29tZW9uZSBoYXMgYSB1c2VjYXNl
IGZvciBsYXRlbmN5LXNlbnNpdGl2ZSBtb25pdG9yaW5nIEknZAo+IHByZWZlciB0byBrZWVwIGl0
IHNpbXBsZSAodXN1YWxseSB0aGVzZSBraW5kIG9mIHN0YXRzIGNhbiBldmVuIG1ha2UKPiBzZW5z
ZSBpZiB5b3UgZ2F0aGVyIHRoZW0gb3ZlciByZWxhdGl2ZWx5IGxhcmdlIHBlcmlvZCBvZiB0aW1l
LCBiZWNhdXNlCj4gdGhlbiB5b3UnbGwgcHJvYmFibHkgdXNlIHNvbWV0aGluZyBlbHNlIGxpa2Ug
dHJhY2Vwb2ludHMgdG8gYWN0dWFsbHkKPiBwaW5wb2ludCB3aGF0J3MgZ29pbmcgb24pLgoKSSB0
ZW5kIHRvIGFncmVlLiBGZXRjaGluZyB0aGVtIHZpYSBhbiBleHBsaWNpdCBjYWxsIGludG8gdGhl
IGtlcm5lbCBpcyAKZGVmaW5pdGVseSB0aGUgc2FmZXIgcm91dGUuCgo+IAo+Pj4+IDIpIHZjcHUg
Y291bnRlcnMKPj4+Pgo+Pj4+IE1vc3Qgb2YgdGhlIGNvdW50ZXJzIGNvdW50IG9uIHZjcHUgZ3Jh
bnVsYXJpdHksIGJ1dCBkZWJ1Z2ZzIG9ubHkKPj4+PiBnaXZlcyB1cyBhIGZ1bGwgVk0gdmlldy4g
V2hhdGV2ZXIgd2UgZG8gdG8gaW1wcm92ZSB0aGUgc2l0dWF0aW9uLCB3ZQo+Pj4+IHNob3VsZCBk
ZWZpbml0ZWx5IHRyeSB0byBidWlsZCBzb21ldGhpbmcgdGhhdCBhbGxvd3MgdXMgdG8gZ2V0IHRo
ZQo+Pj4+IGNvdW50ZXJzIHBlciB2Y3B1IChhcyB3ZWxsKS4KPj4+Pgo+Pj4+IFRoZSBtYWluIHB1
cnBvc2Ugb2YgdGhlc2UgY291bnRlcnMgaXMgbW9uaXRvcmluZy4gSXQgY2FuIGJlIHF1aXRlCj4+
Pj4gaW1wb3J0YW50IHRvIGtub3cgdGhhdCBvbmx5IGEgc2luZ2xlIHZDUFUgaXMgZ29pbmcgd2ls
ZCwgY29tcGFyZWQgdG8KPj4+PiBhbGwgb2YgdGhlbSBmb3IgZXhhbXBsZS4KPj4+Cj4+PiBJIGFn
cmVlLCBleHBvc2luZyBwZXIgdmNwdSBjb3VudGVycyBjYW4gYmUgdXNlZnVsLiBJIGd1ZXNzIGl0
IGRpZG4ndAo+Pj4gbWFrZSBtdWNoIHNlbnNlIGV4cG9zaW5nIHRoZW0gdGhyb3VnaCBkZWJ1Z2Zz
IHNvIGFnZ3JlZ2F0aW9uIHdhcyBkb25lCj4+PiBpbiBrZXJuZWwuIEhvd2V2ZXIgaWYgd2UgY2hv
c2UgdG8gZ28gd2l0aCBhcHByb2FjaCAxLWIpIG1tYXAgY291bnRlcnMKPj4+IHN0cnVjdCBpbiB1
c2Vyc3BhY2UsIHdlIGNvdWxkIGRvIHRoaXMuCj4+Cj4+IFRoZSByZWFzb24gSSBkaXNsaWtlIHRo
ZSBkZWJ1Z2ZzL3N0YXRmcyBhcHByb2FjaCBpcyB0aGF0IGl0IGdlbmVyYXRlcyBhCj4+IGNvbXBs
ZXRlbHkgc2VwYXJhdGUgcGVybWlzc2lvbiBhbmQgYWNjZXNzIHBhdGhzIHRvIHRoZSBzdGF0cy4g
VGhhdCdzCj4+IGdyZWF0IGZvciBmdWxsIHN5c3RlbSBtb25pdG9yaW5nLCBidXQgcmVhbGx5IGJh
ZCB3aGVuIHlvdSBoYXZlIG11bHRpcGxlCj4+IGluZGl2aWR1YWwgdGVuYW50cyBvbiBhIHNpbmds
ZSBob3N0Lgo+IAo+IEkgYWdyZWUsIGFueXRoaW5nIGluIHN5c2ZzIGlzIGNvbXBsZW1lbnRhcnkg
dG8gdm1mZC92Y3B1ZmQgYWNjZXNzLgoKQ29vbCA6KS4KClNvIHdlIG9ubHkgbmVlZCB0byBhZ3Jl
ZSBvbiBPTkVfUkVHIHZzLiB0aGlzIHBhdGNoIG1vc3RseT8KCgpBbGV4CgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

