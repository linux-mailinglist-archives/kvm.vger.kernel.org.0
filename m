Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156A213C662
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAOOn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:43:28 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8614 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgAOOn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 09:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579099406; x=1610635406;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ow6i7pr0OmWI5XvBosIJ0hBqrB+Rpe9XbUucP72j674=;
  b=RUNjAl76VsED8YmapQJEiNElE6gjYhi21vb9l4lo1DLhiCpZQF3RB3FO
   ZAmqv9ST5yYmxbahENQN8WMEgbhQWRasacjbPxJ1wFGJGuqC9pzyM3wyD
   sBV5OL3BtqeNY1DLH2UG8J5XPQooLkWBWqB9+xjR7p8OGW2l2aCrkvB1f
   s=;
IronPort-SDR: /0bo6P8ivdZIpQ21vwl3uxM4uIkZMINr9AKpVDLszOTO5YHdqJA8EZijAkfXdtla/8RM1lPb01
 vfYRmJ5RwtgQ==
X-IronPort-AV: E=Sophos;i="5.70,322,1574121600"; 
   d="scan'208";a="11658715"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Jan 2020 14:43:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id BBF232830EE;
        Wed, 15 Jan 2020 14:43:23 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:43:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 14:43:22 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.28.84.89) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 15 Jan 2020 14:43:21 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
From:   <milanpa@amazon.com>
Message-ID: <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
Date:   Wed, 15 Jan 2020 15:43:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8xNS8yMCAzOjA0IFBNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPgo+Cj4gT24gMTUuMDEu
MjAgMTQ6NDMsIE1pbGFuIFBhbmR1cm92IHdyb3RlOgo+PiBLVk0gZXhwb3NlcyBkZWJ1ZyBjb3Vu
dGVycyB0aHJvdWdoIGluZGl2aWR1YWwgZGVidWdmcyBmaWxlcy4KPj4gTW9uaXRvcmluZyB0aGVz
ZSBjb3VudGVycyByZXF1aXJlcyBkZWJ1Z2ZzIHRvIGJlIGVuYWJsZWQvYWNjZXNzaWJsZSBmb3IK
Pj4gdGhlIGFwcGxpY2F0aW9uLCB3aGljaCBtaWdodCBub3QgYmUgYWx3YXlzIHRoZSBjYXNlLgo+
PiBBZGRpdGlvbmFsbHksIHBlcmlvZGljIG1vbml0b3JpbmcgbXVsdGlwbGUgZGVidWdmcyBmaWxl
cyBmcm9tCj4+IHVzZXJzcGFjZSByZXF1aXJlcyBtdWx0aXBsZSBmaWxlIG9wZW4vcmVhZC9jbG9z
ZSArIGF0b2kgY29udmVyc2lvbgo+PiBvcGVyYXRpb25zLCB3aGljaCBpcyBub3QgdmVyeSBlZmZp
Y2llbnQuCj4+Cj4+IExldCdzIGV4cG9zZSBuZXcgaW50ZXJmYWNlIHRvIHVzZXJzcGFjZSBmb3Ig
Z2FyaGVyaW5nIHRoZXNlCj4+IHN0YXRpc3RpY3Mgd2l0aCBvbmUgaW9jdGwuCj4+Cj4+IFR3byBu
ZXcgaW9jdGwgbWV0aG9kcyBhcmUgYWRkZWQ6Cj4+IMKgIC0gS1ZNX0dFVF9TVVBQT1JURURfREVC
VUdGU19TVEFUIDogUmV0dXJucyBsaXN0IG9mIGF2YWlsYWJsZSBjb3VudGVyCj4+IMKgIG5hbWVz
LiBOYW1lcyBjb3JyZXNwb25kIHRvIHRoZSBkZWJ1Z2ZzIGZpbGUgbmFtZXMKPj4gwqAgLSBLVk1f
R0VUX0RFQlVHRlNfVkFMVUVTIDogUmV0dXJucyBsaXN0IG9mIHU2NCB2YWx1ZXMgZWFjaAo+PiDC
oCBjb3JyZXNwb25kaW5nIHRvIGEgdmFsdWUgZGVzY3JpYmVkIGluIEtWTV9HRVRfU1VQUE9SVEVE
X0RFQlVHRlNfU1RBVC4KPj4KPj4gVXNlcnNwYWNlIGFwcGxpY2F0aW9uIGNhbiByZWFkIGNvdW50
ZXIgZGVzY3JpcHRpb24gb25jZSB1c2luZwo+PiBLVk1fR0VUX1NVUFBPUlRFRF9ERUJVR0ZTX1NU
QVQgYW5kIHBlcmlvZGljYWxseSBpbnZva2UgdGhlCj4+IEtWTV9HRVRfREVCVUdGU19WQUxVRVMg
dG8gZ2V0IHZhbHVlIHVwZGF0ZS4KPj4KPj4gU2lnbmVkLW9mZi1ieTogTWlsYW4gUGFuZHVyb3Yg
PG1pbGFucGFAYW1hem9uLmRlPgo+Cj4gVGhhbmtzIGEgbG90ISBJIHJlYWxseSBsb3ZlIHRoZSBp
ZGVhIHRvIGdldCBzdGF0cyBkaXJlY3RseSBmcm9tIHRoZSAKPiBrdm0gdm0gZmQgb3duZXIuIFRo
aXMgaXMgc28gbXVjaCBiZXR0ZXIgdGhhbiBwb2tpbmcgYXQgZmlsZXMgZnJvbSBhIAo+IHJhbmRv
bSB1bnJlbGF0ZWQgZGVidWcgb3Igc3RhdCBmaWxlIHN5c3RlbS4KPgo+IEkgaGF2ZSBhIGZldyBj
b21tZW50cyBvdmVyYWxsIHRob3VnaDoKPgo+Cj4gMSkKPgo+IFRoaXMgaXMgYW4gaW50ZXJmYWNl
IHRoYXQgcmVxdWlyZXMgYSBsb3Qgb2YgbG9naWMgYW5kIGJ1ZmZlcnMgZnJvbSAKPiB1c2VyIHNw
YWNlIHRvIHJldHJpZXZlIGluZGl2aWR1YWwsIGV4cGxpY2l0IGNvdW50ZXJzLiBXaGF0IGlmIEkg
anVzdCAKPiB3YW50ZWQgdG8gbW9uaXRvciB0aGUgbnVtYmVyIG9mIGV4aXRzIG9uIGV2ZXJ5IHVz
ZXIgc3BhY2UgZXhpdD8KCkluIGNhc2Ugd2Ugd2FudCB0byBjb3ZlciBzdWNoIGxhdGVuY3kgc2Vu
c2l0aXZlIHVzZSBjYXNlcyBzb2x1dGlvbiBiKSwgCndpdGggbW1hcCdlZCBzdHJ1Y3RzIHlvdSBz
dWdnZXN0ZWQsIHdvdWxkIGJlIGEgd2F5IHRvIGdvLCBJTU8uCgo+Cj4gQWxzbywgd2UncmUgc3Vk
ZGVubHkgbWFraW5nIHRoZSBkZWJ1Z2ZzIG5hbWVzIGEgZnVsbCBBQkksIGJlY2F1c2UgCj4gdGhy
b3VnaCB0aGlzIGludGVyZmFjZSB3ZSBvbmx5IGlkZW50aWZ5IHRoZSBpbmRpdmlkdWFsIHN0YXRz
IHRocm91Z2ggCj4gdGhlaXIgbmFtZXMuIFRoYXQgbWVhbnMgd2UgY2FuIG5vdCByZW1vdmUgc3Rh
dHMgb3IgY2hhbmdlIHRoZWlyIG5hbWVzLCAKPiBiZWNhdXNlIHBlb3BsZSBtYXkgcmVseSBvbiB0
aGVtLCBubz8gVGhpbmluZyBhYm91dCB0aGlzIGFnYWluLCBtYXliZSAKPiB0aGV5IGFscmVhZHkg
YXJlIGFuIEFCSSBiZWNhdXNlIHBlb3BsZSByZWx5IG9uIHRoZW0gaW4gZGVidWdmcyB0aG91Z2g/
Cj4KPiBJIHNlZSB0d28gYWx0ZXJuYXRpdmVzIHRvIHRoaXMgYXBwcm9hY2ggaGVyZToKPgo+IGEp
IE9ORV9SRUcKPgo+IFdlIGNhbiBqdXN0IGFkZCBhIG5ldyBERUJVRyBhcmNoIGluIE9ORV9SRUcg
YW5kIGV4cG9zZSBPTkVfUkVHIHBlciBWTSAKPiBhcyB3ZWxsIChpZiB3ZSByZWFsbHkgaGF2ZSB0
bz8pLiBUaGF0IGdpdmVzIHVzIGV4cGxpY2l0IGlkZW50aWZpZXJzIAo+IGZvciBlYWNoIHN0YXQg
d2l0aCBhbiBleHBsaWNpdCBwYXRoIHRvIGludHJvZHVjZSBuZXcgb25lcyB3aXRoIHZlcnkgCj4g
dW5pcXVlIGlkZW50aWZpZXJzLgo+Cj4gVGhhdCB3b3VsZCBnaXZlIHVzIGEgdmVyeSBlYXNpbHkg
c3RydWN0dXJlZCBhcHByb2FjaCB0byByZXRyaWV2ZSAKPiBpbmRpdmlkdWFsIGNvdW50ZXJzLgo+
Cj4gYikgcGFydCBvZiB0aGUgbW1hcCdlZCB2Y3B1IHN0cnVjdAo+Cj4gV2UgY291bGQgc2ltcGx5
IG1vdmUgdGhlIGNvdW50ZXJzIGludG8gdGhlIHNoYXJlZCBzdHJ1Y3QgdGhhdCB3ZSAKPiBleHBv
c2UgdG8gdXNlciBzcGFjZSB2aWEgbW1hcC4gSUlSQyB3ZSBvbmx5IGhhdmUgdGhhdCBwZXItdmNw
dSwgYnV0IAo+IHRoZW4gYWdhaW4gbW9zdCBjb3VudGVycyBhcmUgcGVyLXZjcHUgYW55d2F5LCBz
byB3ZSB3b3VsZCBwdXNoIHRoZSAKPiBhZ2dyZWdhdGlvbiB0byB1c2VyIHNwYWNlLgo+Cj4gRm9y
IHBlci12bSBvbmVzLCBtYXliZSB3ZSBjYW4ganVzdCBhZGQgYW5vdGhlciBtbWFwJ2VkIHNoYXJl
ZCBwYWdlIGZvciAKPiB0aGUgdm0gZmQ/Cj4KPgo+IDIpIHZjcHUgY291bnRlcnMKPgo+IE1vc3Qg
b2YgdGhlIGNvdW50ZXJzIGNvdW50IG9uIHZjcHUgZ3JhbnVsYXJpdHksIGJ1dCBkZWJ1Z2ZzIG9u
bHkgZ2l2ZXMgCj4gdXMgYSBmdWxsIFZNIHZpZXcuIFdoYXRldmVyIHdlIGRvIHRvIGltcHJvdmUg
dGhlIHNpdHVhdGlvbiwgd2Ugc2hvdWxkIAo+IGRlZmluaXRlbHkgdHJ5IHRvIGJ1aWxkIHNvbWV0
aGluZyB0aGF0IGFsbG93cyB1cyB0byBnZXQgdGhlIGNvdW50ZXJzIAo+IHBlciB2Y3B1IChhcyB3
ZWxsKS4KPgo+IFRoZSBtYWluIHB1cnBvc2Ugb2YgdGhlc2UgY291bnRlcnMgaXMgbW9uaXRvcmlu
Zy4gSXQgY2FuIGJlIHF1aXRlIAo+IGltcG9ydGFudCB0byBrbm93IHRoYXQgb25seSBhIHNpbmds
ZSB2Q1BVIGlzIGdvaW5nIHdpbGQsIGNvbXBhcmVkIHRvIAo+IGFsbCBvZiB0aGVtIGZvciBleGFt
cGxlLgoKSSBhZ3JlZSwgZXhwb3NpbmcgcGVyIHZjcHUgY291bnRlcnMgY2FuIGJlIHVzZWZ1bC4g
SSBndWVzcyBpdCBkaWRuJ3QgCm1ha2UgbXVjaCBzZW5zZSBleHBvc2luZyB0aGVtIHRocm91Z2gg
ZGVidWdmcyBzbyBhZ2dyZWdhdGlvbiB3YXMgZG9uZSBpbiAKa2VybmVsLiBIb3dldmVyIGlmIHdl
IGNob3NlIHRvIGdvIHdpdGggYXBwcm9hY2ggMS1iKSBtbWFwIGNvdW50ZXJzIApzdHJ1Y3QgaW4g
dXNlcnNwYWNlLCB3ZSBjb3VsZCBkbyB0aGlzLgoKCkJlc3QsCk1pbGFuCgo+Cj4KPiBUaGFua3Ms
Cj4KPiBBbGV4CgoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

