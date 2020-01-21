Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4796B1440A3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUPi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:38:56 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:12517 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUPiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 10:38:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579621134; x=1611157134;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KhetKoL7t83cYaJujS4U8kDfL3V0+2T/31JNVn7C0uc=;
  b=boBoDH3mjRKb1EPUwnD1IewQEY6fLbxHBMyCZqtIksSx01FUlFXtVTF5
   iWX2u7KBKp15cHVTV19cDWF4erSf+myjk62u8xokhPLY9tMOm6Rt56wMs
   GcYWWOZrjaEz9YBQGdj8b37jPHcB35ekaf535cIMinZlWSAHAIcWuHF1z
   w=;
IronPort-SDR: /WtWim8FRlLKvg4fs765mjpyMYEcXl1iq8FoJdDvHTk1wzhkchDLXK3xPGcRZxF5oNsMo1HSax
 XeZZl+8kW4sQ==
X-IronPort-AV: E=Sophos;i="5.70,346,1574121600"; 
   d="scan'208";a="20139982"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Jan 2020 15:38:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id EEE4AA209E;
        Tue, 21 Jan 2020 15:38:34 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 Jan 2020 15:38:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.7) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 Jan 2020 15:38:32 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     <milanpa@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
Date:   Tue, 21 Jan 2020 16:38:29 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.7]
X-ClientProxiedBy: EX13D37UWA003.ant.amazon.com (10.43.160.25) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4wMS4yMCAxOTo1NywgbWlsYW5wYUBhbWF6b24uY29tIHdyb3RlOgo+IE9uIDEvMjAv
MjAgNjo1MyBQTSwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDE4LjAxLjIwIDAw
OjM4LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+Pj4gT24gMTUvMDEvMjAgMTU6NTksIEFsZXhhbmRl
ciBHcmFmIHdyb3RlOgo+Pj4+IE9uIDE1LjAxLjIwIDE1OjQzLCBtaWxhbnBhQGFtYXpvbi5jb20g
d3JvdGU6Cj4+Pj4+Pj4gTGV0J3MgZXhwb3NlIG5ldyBpbnRlcmZhY2UgdG8gdXNlcnNwYWNlIGZv
ciBnYXJoZXJpbmcgdGhlc2UKPj4+Pj4+PiBzdGF0aXN0aWNzIHdpdGggb25lIGlvY3RsLgo+Pj4+
Pj4+Cj4+Pj4+Pj4gVXNlcnNwYWNlIGFwcGxpY2F0aW9uIGNhbiByZWFkIGNvdW50ZXIgZGVzY3Jp
cHRpb24gb25jZSB1c2luZwo+Pj4+Pj4+IEtWTV9HRVRfU1VQUE9SVEVEX0RFQlVHRlNfU1RBVCBh
bmQgcGVyaW9kaWNhbGx5IGludm9rZSB0aGUKPj4+Pj4+PiBLVk1fR0VUX0RFQlVHRlNfVkFMVUVT
IHRvIGdldCB2YWx1ZSB1cGRhdGUuCj4+Pj4+Pgo+Pj4+Pj4gVGhpcyBpcyBhbiBpbnRlcmZhY2Ug
dGhhdCByZXF1aXJlcyBhIGxvdCBvZiBsb2dpYyBhbmQgYnVmZmVycyBmcm9tCj4+Pj4+PiB1c2Vy
IHNwYWNlIHRvIHJldHJpZXZlIGluZGl2aWR1YWwsIGV4cGxpY2l0IGNvdW50ZXJzLiBXaGF0IGlm
IEkganVzdAo+Pj4+Pj4gd2FudGVkIHRvIG1vbml0b3IgdGhlIG51bWJlciBvZiBleGl0cyBvbiBl
dmVyeSB1c2VyIHNwYWNlIGV4aXQ/Cj4+Pj4+Cj4+Pj4+IEluIGNhc2Ugd2Ugd2FudCB0byBjb3Zl
ciBzdWNoIGxhdGVuY3kgc2Vuc2l0aXZlIHVzZSBjYXNlcyBzb2x1dGlvbiBiKSwKPj4+Pj4gd2l0
aCBtbWFwJ2VkIHN0cnVjdHMgeW91IHN1Z2dlc3RlZCwgd291bGQgYmUgYSB3YXkgdG8gZ28sIElN
Ty4KPj4+Pj4KPj4+Pj4+IEFsc28sIHdlJ3JlIHN1ZGRlbmx5IG1ha2luZyB0aGUgZGVidWdmcyBu
YW1lcyBhIGZ1bGwgQUJJLCBiZWNhdXNlCj4+Pj4+PiB0aHJvdWdoIHRoaXMgaW50ZXJmYWNlIHdl
IG9ubHkgaWRlbnRpZnkgdGhlIGluZGl2aWR1YWwgc3RhdHMgdGhyb3VnaAo+Pj4+Pj4gdGhlaXIg
bmFtZXMuIFRoYXQgbWVhbnMgd2UgY2FuIG5vdCByZW1vdmUgc3RhdHMgb3IgY2hhbmdlIHRoZWly
Cj4+Pj4+PiBuYW1lcywgYmVjYXVzZSBwZW9wbGUgbWF5IHJlbHkgb24gdGhlbSwgbm8/IFRoaW5p
bmcgYWJvdXQgdGhpcyBhZ2FpbiwKPj4+Pj4+IG1heWJlIHRoZXkgYWxyZWFkeSBhcmUgYW4gQUJJ
IGJlY2F1c2UgcGVvcGxlIHJlbHkgb24gdGhlbSBpbiBkZWJ1Z2ZzCj4+Pj4+PiB0aG91Z2g/Cj4+
Pgo+Pj4gSW4gdGhlb3J5IG5vdCwgaW4gcHJhY3RpY2UgSSBoYXZlIHRyZWF0ZWQgdGhlbSBhcyBh
IGtpbmQgb2YgInNvZnQiIEFCSToKPj4+IGlmIHRoZSBtZWFuaW5nIGNoYW5nZXMgeW91IHNob3Vs
ZCByZW5hbWUgdGhlbSwgYW5kIHJlbW92aW5nIHRoZW0gaXMKPj4+IGZpbmUsIGJ1dCB5b3Ugc2hv
dWxkbid0IGZvciBleGFtcGxlIGNoYW5nZSB0aGUgdW5pdCBvZiBtZWFzdXJlICh3aGljaCBpcwo+
Pj4gbm90IGhhcmQgc2luY2UgdGhleSBhcmUgYWxsIGNvdW50ZXJzIDopIGJ1dCBwZXJoYXBzIHlv
dSBjb3VsZCBoYXZlCj4+PiBuYW5vc2Vjb25kcyB2cyBUU0MgY3ljbGVzIGluIHRoZSBmdXR1cmUg
Zm9yIHNvbWUgY291bnRlcnMpLgo+Pj4KPj4+Pj4+IEkgc2VlIHR3byBhbHRlcm5hdGl2ZXMgdG8g
dGhpcyBhcHByb2FjaCBoZXJlOgo+Pj4+Pj4KPj4+Pj4+IGEpIE9ORV9SRUcKPj4+Pj4+Cj4+Pj4+
PiBXZSBjYW4ganVzdCBhZGQgYSBuZXcgREVCVUcgYXJjaCBpbiBPTkVfUkVHIGFuZCBleHBvc2Ug
T05FX1JFRyBwZXIgVk0KPj4+Pj4+IGFzIHdlbGwgKGlmIHdlIHJlYWxseSBoYXZlIHRvPykuIFRo
YXQgZ2l2ZXMgdXMgZXhwbGljaXQgaWRlbnRpZmllcnMKPj4+Pj4+IGZvciBlYWNoIHN0YXQgd2l0
aCBhbiBleHBsaWNpdCBwYXRoIHRvIGludHJvZHVjZSBuZXcgb25lcyB3aXRoIHZlcnkKPj4+Pj4+
IHVuaXF1ZSBpZGVudGlmaWVycy4KPj4+IE9ORV9SRUcgd291bGQgZm9yY2UgdXMgdG8gZGVmaW5l
IGNvbnN0YW50cyBmb3IgZWFjaCBjb3VudGVyLCBhbmQgd291bGQKPj4+IG1ha2UgaXQgaGFyZCB0
byByZXRpcmUgdGhlbS7CoCBJIGRvbid0IGxpa2UgdGhpcy4KPj4KPj4gV2h5IGRvZXMgaXQgbWFr
ZSBpdCBoYXJkIHRvIHJldGlyZSB0aGVtPyBXZSB3b3VsZCBqdXN0IHJldHVybiAtRUlOVkFMIAo+
PiBvbiByZXRyaWV2YWwsIGxpa2Ugd2UgZG8gZm9yIGFueSBvdGhlciBub24tc3VwcG9ydGVkIE9O
RV9SRUcuCj4+Cj4+IEl0J3MgdGhlIHNhbWUgYXMgYSBmaWxlIG5vdCBleGlzdGluZyBpbiBkZWJ1
Z2ZzL3N0YXRmcy4gT3IgYW4gZW50cnkgaW4gCj4+IHRoZSBhcnJheSBvZiB0aGlzIHBhdGNoIHRv
IGRpc2FwcGVhci4KPj4KPj4+Cj4+Pj4+PiBiKSBwYXJ0IG9mIHRoZSBtbWFwJ2VkIHZjcHUgc3Ry
dWN0Cj4+Pgo+Pj4gU2FtZSBoZXJlLsKgIEV2ZW4gaWYgd2Ugc2F5IHRoZSBzZW1hbnRpY3Mgb2Yg
dGhlIHN0cnVjdCB3b3VsZCBiZSBleHBvc2VkCj4+PiB0byB1c2Vyc3BhY2UgdmlhIEtWTV9HRVRf
U1VQUE9SVEVEX0RFQlVHRlNfU1RBVCwgc29tZW9uZSBtaWdodCBlbmQgdXAKPj4+IGdldHRpbmcg
dGhpcyB3cm9uZyBhbmQgZXhwZWN0aW5nIGEgcGFydGljdWxhciBsYXlvdXQuwqAgTWlsYW4ncyBw
cm9wb3NlZAo+Pj4gQVBJIGhhcyB0aGUgYmlnIGFkdmFudGFnZSBvZiBiZWluZyBoYXJkIHRvIGdl
dCB3cm9uZyBmb3IgdXNlcnNwYWNlLsKgIEFuZAo+Pj4gcHVzaGluZyB0aGUgYWdncmVnYXRpb24g
dG8gdXNlcnNwYWNlIGlzIG5vdCBhIGh1Z2UgY2hvcmUsIGJ1dCBpdCdzIHN0aWxsCj4+PiBhIGNo
b3JlLgo+Pj4KPj4+IFNvIHVubGVzcyBzb21lb25lIGhhcyBhIHVzZWNhc2UgZm9yIGxhdGVuY3kt
c2Vuc2l0aXZlIG1vbml0b3JpbmcgSSdkCj4+PiBwcmVmZXIgdG8ga2VlcCBpdCBzaW1wbGUgKHVz
dWFsbHkgdGhlc2Uga2luZCBvZiBzdGF0cyBjYW4gZXZlbiBtYWtlCj4+PiBzZW5zZSBpZiB5b3Ug
Z2F0aGVyIHRoZW0gb3ZlciByZWxhdGl2ZWx5IGxhcmdlIHBlcmlvZCBvZiB0aW1lLCBiZWNhdXNl
Cj4+PiB0aGVuIHlvdSdsbCBwcm9iYWJseSB1c2Ugc29tZXRoaW5nIGVsc2UgbGlrZSB0cmFjZXBv
aW50cyB0byBhY3R1YWxseQo+Pj4gcGlucG9pbnQgd2hhdCdzIGdvaW5nIG9uKS4KPj4KPj4gSSB0
ZW5kIHRvIGFncmVlLiBGZXRjaGluZyB0aGVtIHZpYSBhbiBleHBsaWNpdCBjYWxsIGludG8gdGhl
IGtlcm5lbCBpcyAKPj4gZGVmaW5pdGVseSB0aGUgc2FmZXIgcm91dGUuCj4+Cj4+Pgo+Pj4+Pj4g
MikgdmNwdSBjb3VudGVycwo+Pj4+Pj4KPj4+Pj4+IE1vc3Qgb2YgdGhlIGNvdW50ZXJzIGNvdW50
IG9uIHZjcHUgZ3JhbnVsYXJpdHksIGJ1dCBkZWJ1Z2ZzIG9ubHkKPj4+Pj4+IGdpdmVzIHVzIGEg
ZnVsbCBWTSB2aWV3LiBXaGF0ZXZlciB3ZSBkbyB0byBpbXByb3ZlIHRoZSBzaXR1YXRpb24sIHdl
Cj4+Pj4+PiBzaG91bGQgZGVmaW5pdGVseSB0cnkgdG8gYnVpbGQgc29tZXRoaW5nIHRoYXQgYWxs
b3dzIHVzIHRvIGdldCB0aGUKPj4+Pj4+IGNvdW50ZXJzIHBlciB2Y3B1IChhcyB3ZWxsKS4KPj4+
Pj4+Cj4+Pj4+PiBUaGUgbWFpbiBwdXJwb3NlIG9mIHRoZXNlIGNvdW50ZXJzIGlzIG1vbml0b3Jp
bmcuIEl0IGNhbiBiZSBxdWl0ZQo+Pj4+Pj4gaW1wb3J0YW50IHRvIGtub3cgdGhhdCBvbmx5IGEg
c2luZ2xlIHZDUFUgaXMgZ29pbmcgd2lsZCwgY29tcGFyZWQgdG8KPj4+Pj4+IGFsbCBvZiB0aGVt
IGZvciBleGFtcGxlLgo+Pj4+Pgo+Pj4+PiBJIGFncmVlLCBleHBvc2luZyBwZXIgdmNwdSBjb3Vu
dGVycyBjYW4gYmUgdXNlZnVsLiBJIGd1ZXNzIGl0IGRpZG4ndAo+Pj4+PiBtYWtlIG11Y2ggc2Vu
c2UgZXhwb3NpbmcgdGhlbSB0aHJvdWdoIGRlYnVnZnMgc28gYWdncmVnYXRpb24gd2FzIGRvbmUK
Pj4+Pj4gaW4ga2VybmVsLiBIb3dldmVyIGlmIHdlIGNob3NlIHRvIGdvIHdpdGggYXBwcm9hY2gg
MS1iKSBtbWFwIGNvdW50ZXJzCj4+Pj4+IHN0cnVjdCBpbiB1c2Vyc3BhY2UsIHdlIGNvdWxkIGRv
IHRoaXMuCj4+Pj4KPj4+PiBUaGUgcmVhc29uIEkgZGlzbGlrZSB0aGUgZGVidWdmcy9zdGF0ZnMg
YXBwcm9hY2ggaXMgdGhhdCBpdCBnZW5lcmF0ZXMgYQo+Pj4+IGNvbXBsZXRlbHkgc2VwYXJhdGUg
cGVybWlzc2lvbiBhbmQgYWNjZXNzIHBhdGhzIHRvIHRoZSBzdGF0cy4gVGhhdCdzCj4+Pj4gZ3Jl
YXQgZm9yIGZ1bGwgc3lzdGVtIG1vbml0b3JpbmcsIGJ1dCByZWFsbHkgYmFkIHdoZW4geW91IGhh
dmUgbXVsdGlwbGUKPj4+PiBpbmRpdmlkdWFsIHRlbmFudHMgb24gYSBzaW5nbGUgaG9zdC4KPj4+
Cj4+PiBJIGFncmVlLCBhbnl0aGluZyBpbiBzeXNmcyBpcyBjb21wbGVtZW50YXJ5IHRvIHZtZmQv
dmNwdWZkIGFjY2Vzcy4KPj4KPj4gQ29vbCA6KS4KPj4KPj4gU28gd2Ugb25seSBuZWVkIHRvIGFn
cmVlIG9uIE9ORV9SRUcgdnMuIHRoaXMgcGF0Y2ggbW9zdGx5Pwo+IAo+IFdoYXQgYWJvdXQgZXh0
ZW5kaW5nIEtWTV9HRVRfU1VQUE9SVEVEX0RFQlVHRlNfU1RBVCB3aXRoIHNvbWUgYWRkaXRpb25h
bCAKPiBpbmZvcm1hdGlvbiBsaWtlIHRoZSBkYXRhIHR5cGUgYW5kIHVuaXQ/IE9ORV9SRUcgZXhw
b3NlcyBhZGRpdGlvbmFsIAo+IHNlbWFudGljcyBhYm91dCBkYXRhLgoKSXQncyBub3QgYSBwcm9i
bGVtIG9mIGV4cG9zaW5nIHRoZSB0eXBlIGluZm9ybWF0aW9uIC0gd2UgaGF2ZSB0aGF0IHRvZGF5
IApieSBpbXBsaWNpdGx5IHNheWluZyAiZXZlcnkgY291bnRlciBpcyA2NGJpdCIuCgpUaGUgdGhp
bmcgSSdtIHdvcnJpZWQgYWJvdXQgaXMgdGhhdCB3ZSBrZWVwIGludmVudGluZyB0aGVzZSBzcGVj
aWFsIApwdXJwb3NlIGludGVyZmFjZXMgdGhhdCByZWFsbHkgZG8gbm90aGluZyBidXQgdHJhbnNm
ZXIgbnVtYmVycyBpbiBvbmUgCndheSBvciBhbm90aGVyLiBPTkVfUkVHJ3MgcHVycG9zZSB3YXMg
dG8gdW5pZnkgdGhlbS4gRGVidWcgY291bnRlcnMgCnJlYWxseSBhcmUgdGhlIHNhbWUgc3Rvcnku
CgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5z
dHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVn
ZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5i
dXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3
OQoKCg==

