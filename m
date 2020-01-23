Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC614680B
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 13:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAWMca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 07:32:30 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65435 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAWMc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 07:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579782749; x=1611318749;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zbv5Zue7z8NnHDQtWrh6+1k3Ib34YhMvbUVQtQ3SZfY=;
  b=G6S4juGj3TJynGTv77CzuiMZ13E2Tr2pOIFtNULPx7fii9D3odn/dNzw
   nPvOJthtHReB+X6raupxcwtOb7IJ86ayzkT2uSxyw9MfZrPYcQDLAs7Dv
   m/6JiaqLodgDqfpV2auAe/3Z8dZ3iSYnWN6wseyrxgeovCk8sddZ8S1B6
   0=;
IronPort-SDR: jKOp/oNCOFQ5ubVUqMZ++zqNMP6UQlUah3EOjtdc2x2KIj6JO0sVIW1TkeW2GpQ6vQYa1xt4tG
 MtAmp61+aoGw==
X-IronPort-AV: E=Sophos;i="5.70,353,1574121600"; 
   d="scan'208";a="21945785"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jan 2020 12:32:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id AD697A2812;
        Thu, 23 Jan 2020 12:32:17 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 12:32:17 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.18) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 12:32:15 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Paolo Bonzini <pbonzini@redhat.com>, <milanpa@amazon.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
Date:   Thu, 23 Jan 2020 13:32:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.18]
X-ClientProxiedBy: EX13D35UWC004.ant.amazon.com (10.43.162.180) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wMS4yMCAxMzowOCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAyMS8wMS8yMCAx
NjozOCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4+IE9ORV9SRUcgd291bGQgZm9yY2UgdXMg
dG8gZGVmaW5lIGNvbnN0YW50cyBmb3IgZWFjaCBjb3VudGVyLCBhbmQgd291bGQKPj4+Pj4gbWFr
ZSBpdCBoYXJkIHRvIHJldGlyZSB0aGVtLsKgIEkgZG9uJ3QgbGlrZSB0aGlzLgo+Pj4+Cj4+Pj4g
V2h5IGRvZXMgaXQgbWFrZSBpdCBoYXJkIHRvIHJldGlyZSB0aGVtPyBXZSB3b3VsZCBqdXN0IHJl
dHVybiAtRUlOVkFMCj4+Pj4gb24gcmV0cmlldmFsLCBsaWtlIHdlIGRvIGZvciBhbnkgb3RoZXIg
bm9uLXN1cHBvcnRlZCBPTkVfUkVHLgo+Pj4+Cj4+Pj4gSXQncyB0aGUgc2FtZSBhcyBhIGZpbGUg
bm90IGV4aXN0aW5nIGluIGRlYnVnZnMvc3RhdGZzLiBPciBhbiBlbnRyeQo+Pj4+IGluIHRoZSBh
cnJheSBvZiB0aGlzIHBhdGNoIHRvIGRpc2FwcGVhci4KPiAKPiBUaGUgZGV2aWwgaXMgaW4gdGhl
IGRldGFpbHMuICBGb3IgZXhhbXBsZSwgd291bGQgeW91IHJldGlyZSB1YXBpLwo+IGNvbnN0YW50
cyBhbmQgY2F1c2UgcHJvZ3JhbXMgdG8gZmFpbCBjb21waWxhdGlvbj8gIE9yIGRvIHlvdSBrZWVw
IHRoZQo+IG9ic29sZXRlIGNvbnN0YW50cyBmb3JldmVyPyAgQWxzbywgZml4aW5nIHRoZSBtYXBw
aW5nIGZyb20gT05FX1JFRwo+IG51bWJlciB0byBzdGF0IHdvdWxkIG1lYW4gYSBzd2l0Y2ggc3Rh
dGVtZW50IChvciBsb29wIG9mIHNvbWUga2luZC0tLWEKPiBzd2l0Y2ggc3RhdGVtZW50IGlzIGJh
c2ljYWxseSBhbiB1bnJvbGxlZCBiaW5hcnkgc2VhcmNoKSB0byBhY2Nlc3MgdGhlCj4gc3RhdHMu
ICBJbnN0ZWFkIHJldHVybmluZyB0aGUgaWQgaW4gS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19T
VEFUIHdvdWxkCj4gc2ltcGxpZnkgcmV0dXJuaW5nIHRoZSBzdGF0cyB0byBhIHNpbXBsZSBjb3B5
X3RvX3VzZXIuCgpJZiB5b3UgbG9vayBhdCB0aGUgd2F5IFJJU0MtViBpbXBsZW1lbnRlZCBPTkVf
UkVHLCBJIHRoaW5rIHdlIGNhbiBhZ3JlZSAKdGhhdCBpdCdzIHBvc3NpYmxlIHdpdGggY29uc3Rh
bnQgaWRlbnRpZmllcnMgYXMgd2VsbCA6KS4gVGhlIG9ubHkgCmRvd25zaWRlIGlzIG9mIGNvdXJz
ZSB0aGF0IHlvdSBtYXkgcG90ZW50aWFsbHkgZW5kIHVwIHdpdGggYW4gaWRlbnRpZmllciAKYXJy
YXkgdG8gbWFwIGZyb20gIk9ORV9SRUcgaWQiIHRvICJvZmZzZXQgaW4gdmNwdS92bSBzdHJ1Y3Qi
LiBJIGZhaWwgdG8gCnNlZSBob3cgdGhhdCdzIHdvcnNlIHRoYW4gdGhlIHN0cnVjdCBrdm1fc3Rh
dHNfZGVidWdmc19pdGVtW10gd2UgaGF2ZSB0b2RheS4KCj4gT2YgY291cnNlLCBzb21lIG9mIHRo
ZSBjb21wbGV4aXR5IHdvdWxkIGJlIHB1bnRlZCB0byB1c2Vyc3BhY2UuICBCdXQKPiB1c2Vyc3Bh
Y2UgaXMgbXVjaCBjbG9zZXIgdG8gdGhlIGh1bWFucyB0aGF0IHVsdGltYXRlbHkgbG9vayBhdCB0
aGUKPiBzdGF0cywgc28gdGhlIHF1ZXN0aW9uIGlzOiBkb2VzIHVzZXJzcGFjZSByZWFsbHkgY2Fy
ZSBhYm91dCBrbm93aW5nCj4gd2hpY2ggc3RhdCBpcyB3aGljaCwgb3IgZG8gdGhleSBqdXN0IGNh
cmUgYWJvdXQgaGF2aW5nIGEgbmFtZSB0aGF0IHdpbGwKPiB1bHRpbWF0ZWx5IGJlIGNvbnN1bWVk
IGJ5IGh1bWFucyBkb3duIHRoZSBwaXBlPyAgSWYgdGhlIGxhdHRlciAod2hpY2ggaXMKPiBhbHNv
IG15IGd1dCBmZWVsaW5nKSwgdGhhdCBpcyBhbHNvIGEgcG9pbnQgYWdhaW5zdCBPTkVfUkVHLgo+
IAo+PiBJdCdzIG5vdCBhIHByb2JsZW0gb2YgZXhwb3NpbmcgdGhlIHR5cGUgaW5mb3JtYXRpb24g
LSB3ZSBoYXZlIHRoYXQgdG9kYXkKPj4gYnkgaW1wbGljaXRseSBzYXlpbmcgImV2ZXJ5IGNvdW50
ZXIgaXMgNjRiaXQiLgo+Pgo+PiBUaGUgdGhpbmcgSSdtIHdvcnJpZWQgYWJvdXQgaXMgdGhhdCB3
ZSBrZWVwIGludmVudGluZyB0aGVzZSBzcGVjaWFsCj4+IHB1cnBvc2UgaW50ZXJmYWNlcyB0aGF0
IHJlYWxseSBkbyBub3RoaW5nIGJ1dCB0cmFuc2ZlciBudW1iZXJzIGluIG9uZQo+PiB3YXkgb3Ig
YW5vdGhlci4gT05FX1JFRydzIHB1cnBvc2Ugd2FzIHRvIHVuaWZ5IHRoZW0uIERlYnVnIGNvdW50
ZXJzCj4+IHJlYWxseSBhcmUgdGhlIHNhbWUgc3RvcnkuCj4gCj4gU2VlIGFib3ZlOiBJIGFtIG5v
dCBzdXJlIHRoZXkgYXJlIHRoZSBzYW1lIHN0b3J5IGJlY2F1c2UgdGhlaXIgY29uc3VtZXJzCj4g
bWlnaHQgYmUgdmVyeSBkaWZmZXJlbnQgZnJvbSByZWdpc3RlcnMuICBSZWdpc3RlcnMgYXJlIGdl
bmVyYWxseQo+IGNvbnN1bWVkIGJ5IHByb2dyYW1zICh0byBtaWdyYXRlIFZNcywgZm9yIGV4YW1w
bGUpIGFuZCBvbmx5IG9jY2FzaW9uYWxseQo+IGJ5IGh1bWFucywgd2hpbGUgc3RhdHMgYXJlIG1l
YW50IHRvIGJlIGNvbnN1bWVkIGJ5IGh1bWFucy4gIFdlIG1heQo+IGRpc2FncmVlIG9uIHdoZXRo
ZXIgdGhpcyBqdXN0aWZpZXMgYSBjb21wbGV0ZWx5IGRpZmZlcmVudCBBUEkuLi4KCkkgZG9uJ3Qg
ZnVsbHkgYWdyZWUgb24gdGhlICJodW1hbiIgcGFydCBoZXJlLiBBdCB0aGUgZW5kIG9mIHRoZSBk
YXksIHlvdSAKd2FudCBzdGF0cyBiZWNhdXNlIHlvdSB3YW50IHRvIGFjdCBvbiBzdGF0cy4gSWRl
YWxseSwgeW91IHdhbnQgdG8gZG8gCnRoYXQgZnVsbHkgYXV0b21hdGljYWxseS4gTGV0IG1lIGdp
dmUgeW91IGEgZmV3IGV4YW1wbGVzOgoKMSkgaW5zbl9lbXVsYXRpb25fZmFpbCB0cmlnZ2VycwoK
WW91IG1heSB3YW50IHRvIGZlZWQgYWxsIHRoZSBmYWlsdXJlcyBpbnRvIGEgZGF0YWJhc2UgdG8g
Y2hlY2sgd2hldGhlciAKdGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIGluIHRoZSBlbXVsYXRvci4K
CjIpIChyZW1vdGVfKXRsYl9mbHVzaCBiZXlvbmQgY2VydGFpbiB0aHJlc2hvbGQKCklmIHlvdSBz
ZWUgdGhhdCB5b3UncmUgY29uc3RhbnRseSBmbHVzaGluZyByZW1vdGUgVExCcywgdGhlcmUncyBh
IGdvb2QgCmNoYW5jZSB0aGF0IHlvdSBmb3VuZCBhIHdvcmtsb2FkIHRoYXQgbWF5IG5lZWQgdHVu
aW5nIGluIEtWTS4gWW91IHdhbnQgCnRvIGdhdGhlciB0aG9zZSBzdGF0cyBhY3Jvc3MgeW91ciBm
dWxsIGZsZWV0IG9mIGhvc3RzLCBzbyB0aGF0IGZvciB0aGUgCmZldyBvY2Nhc2lvbnMgd2hlbiB5
b3UgaGl0IGl0LCB5b3UgY2FuIHdvcmsgd2l0aCB0aGUgYWN0dWFsIFZNIG93bmVycyB0byAKcG90
ZW50aWFsbHkgaW1wcm92ZSB0aGVpciBwZXJmb3JtYW5jZQoKMykgZXhpdHMgYmV5b25kIGNlcnRh
aW4gdGhyZXNob2xkCgpZb3Uga25vdyByb3VnaGx5IGhvdyBtYW55IGV4aXRzIHlvdXIgZmxlZXQg
d291bGQgdXN1YWxseSBzZWUsIHNvIHlvdSBjYW4gCmNvbmZpZ3VyZSBhbiB1cHBlciB0aHJlc2hv
bGQgb24gdGhhdC4gV2hlbiB5b3Ugbm93IGhhdmUgYW4gYXV0b21hdGVkIHdheSAKdG8gbm90aWZ5
IHlvdSB3aGVuIHRoZSB0aHJlc2hvbGQgaXMgZXhjZWVkZWQsIHlvdSBjYW4gY2hlY2sgd2hhdCB0
aGF0IApwYXJ0aWN1bGFyIGd1ZXN0IGRpZCB0byByYWlzZSBzbyBtYW55IGV4aXRzLgoKCi4uLiBh
bmQgSSdtIHN1cmUgdGhlcmUncyByb29tIGZvciBhIGxvdCBtb3JlIHBvdGVudGlhbCBzdGF0cyB0
aGF0IGNvdWxkIApiZSB1c2VmdWwgdG8gZ2F0aGVyIHRvIGRldGVybWluZSB0aGUgaGVhbHRoIG9m
IGEgS1ZNIGVudmlyb25tZW50LCBzdWNoIAphcyBhICJ2Y3B1IHN0ZWFsIHRpbWUiIG9uZSBvciBh
ICJtYXhpbXVtIHRpbWUgYmV0d2VlbiB0d28gVk1FTlRFUlMgd2hpbGUgCnRoZSBndWVzdCB3YXMg
aW4gcnVubmluZyBzdGF0ZSIuCgpBbGwgb2YgdGhlc2Ugc2hvdWxkIGV2ZW50dWFsbHkgZmVlZCBp
bnRvIHNvbWV0aGluZyBiaWdnZXIgdGhhdCBjb2xsZWN0cyAKdGhlIG51bWJlcnMgYWNyb3NzIHlv
dXIgZnVsbCBWTSBmbGVldCwgc28gdGhhdCBhIGh1bWFuIGNhbiB0YWtlIGFjdGlvbnMgCmJhc2Vk
IG9uIHRoZW0uIEhvd2V2ZXIsIHRoYXQgbWVhbnMgdGhlIHZhbHVlcyBhcmUgbm8gbG9uZ2VyIGRp
cmVjdGx5IAppbXBhY3RpbmcgYSBodW1hbiwgdGhleSBuZWVkIHRvIGZlZWQgaW50byBtYWNoaW5l
cy4gQW5kIGZvciB0aGF0LCBleGFjdCwgCmNvbnN0YW50IGlkZW50aWZpZXJzIG1ha2UgbXVjaCBt
b3JlIHNlbnNlIDopCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkg
R21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNo
dCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDog
REUgMjg5IDIzNyA4NzkKCgo=

