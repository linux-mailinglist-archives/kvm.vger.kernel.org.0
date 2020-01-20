Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D521431DC
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 19:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgATS5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 13:57:51 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:26509 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgATS5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 13:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579546670; x=1611082670;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=3sMDWN5G6D/QuQBJ0VgfeTIvmE0X+lMVeKLu7CBD/Rg=;
  b=UrRoaABDrYhGBtvNjOVqaC9pjDo2TdtKokHr/Dw5/CDHJg/s7A8SMUHx
   0p1Jodg74neoBfywOcrXhqqyhBRIUNNI3C2r5LgRTfOXhWSufcB62A3zY
   7MP2qsmWUu5CaPFRGJ1L2jDXDKblNIxkul2ynngC6fg6H1YwS+syBvawk
   Y=;
IronPort-SDR: QfGyADq3OjaZ7nKN52ZPQkHLow2/ycAQBbOf6wKPdXHbPPoEv0Q1WYkdTyYPq2M7BclNe3Zf3N
 tPGYLLltKrBg==
X-IronPort-AV: E=Sophos;i="5.70,343,1574121600"; 
   d="scan'208";a="21207713"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Jan 2020 18:57:35 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 69A5AA2B23;
        Mon, 20 Jan 2020 18:57:34 +0000 (UTC)
Received: from EX13D27EUB002.ant.amazon.com (10.43.166.103) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 20 Jan 2020 18:57:34 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D27EUB002.ant.amazon.com (10.43.166.103) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 Jan 2020 18:57:33 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.28.84.89) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 20 Jan 2020 18:57:31 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
From:   <milanpa@amazon.com>
Message-ID: <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
Date:   Mon, 20 Jan 2020 19:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8yMC8yMCA2OjUzIFBNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPgo+Cj4gT24gMTguMDEu
MjAgMDA6MzgsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4+IE9uIDE1LzAxLzIwIDE1OjU5LCBBbGV4
YW5kZXIgR3JhZiB3cm90ZToKPj4+IE9uIDE1LjAxLjIwIDE1OjQzLCBtaWxhbnBhQGFtYXpvbi5j
b20gd3JvdGU6Cj4+Pj4+PiBMZXQncyBleHBvc2UgbmV3IGludGVyZmFjZSB0byB1c2Vyc3BhY2Ug
Zm9yIGdhcmhlcmluZyB0aGVzZQo+Pj4+Pj4gc3RhdGlzdGljcyB3aXRoIG9uZSBpb2N0bC4KPj4+
Pj4+Cj4+Pj4+PiBVc2Vyc3BhY2UgYXBwbGljYXRpb24gY2FuIHJlYWQgY291bnRlciBkZXNjcmlw
dGlvbiBvbmNlIHVzaW5nCj4+Pj4+PiBLVk1fR0VUX1NVUFBPUlRFRF9ERUJVR0ZTX1NUQVQgYW5k
IHBlcmlvZGljYWxseSBpbnZva2UgdGhlCj4+Pj4+PiBLVk1fR0VUX0RFQlVHRlNfVkFMVUVTIHRv
IGdldCB2YWx1ZSB1cGRhdGUuCj4+Pj4+Cj4+Pj4+IFRoaXMgaXMgYW4gaW50ZXJmYWNlIHRoYXQg
cmVxdWlyZXMgYSBsb3Qgb2YgbG9naWMgYW5kIGJ1ZmZlcnMgZnJvbQo+Pj4+PiB1c2VyIHNwYWNl
IHRvIHJldHJpZXZlIGluZGl2aWR1YWwsIGV4cGxpY2l0IGNvdW50ZXJzLiBXaGF0IGlmIEkganVz
dAo+Pj4+PiB3YW50ZWQgdG8gbW9uaXRvciB0aGUgbnVtYmVyIG9mIGV4aXRzIG9uIGV2ZXJ5IHVz
ZXIgc3BhY2UgZXhpdD8KPj4+Pgo+Pj4+IEluIGNhc2Ugd2Ugd2FudCB0byBjb3ZlciBzdWNoIGxh
dGVuY3kgc2Vuc2l0aXZlIHVzZSBjYXNlcyBzb2x1dGlvbiBiKSwKPj4+PiB3aXRoIG1tYXAnZWQg
c3RydWN0cyB5b3Ugc3VnZ2VzdGVkLCB3b3VsZCBiZSBhIHdheSB0byBnbywgSU1PLgo+Pj4+Cj4+
Pj4+IEFsc28sIHdlJ3JlIHN1ZGRlbmx5IG1ha2luZyB0aGUgZGVidWdmcyBuYW1lcyBhIGZ1bGwg
QUJJLCBiZWNhdXNlCj4+Pj4+IHRocm91Z2ggdGhpcyBpbnRlcmZhY2Ugd2Ugb25seSBpZGVudGlm
eSB0aGUgaW5kaXZpZHVhbCBzdGF0cyB0aHJvdWdoCj4+Pj4+IHRoZWlyIG5hbWVzLiBUaGF0IG1l
YW5zIHdlIGNhbiBub3QgcmVtb3ZlIHN0YXRzIG9yIGNoYW5nZSB0aGVpcgo+Pj4+PiBuYW1lcywg
YmVjYXVzZSBwZW9wbGUgbWF5IHJlbHkgb24gdGhlbSwgbm8/IFRoaW5pbmcgYWJvdXQgdGhpcyBh
Z2FpbiwKPj4+Pj4gbWF5YmUgdGhleSBhbHJlYWR5IGFyZSBhbiBBQkkgYmVjYXVzZSBwZW9wbGUg
cmVseSBvbiB0aGVtIGluIGRlYnVnZnMKPj4+Pj4gdGhvdWdoPwo+Pgo+PiBJbiB0aGVvcnkgbm90
LCBpbiBwcmFjdGljZSBJIGhhdmUgdHJlYXRlZCB0aGVtIGFzIGEga2luZCBvZiAic29mdCIgQUJJ
Ogo+PiBpZiB0aGUgbWVhbmluZyBjaGFuZ2VzIHlvdSBzaG91bGQgcmVuYW1lIHRoZW0sIGFuZCBy
ZW1vdmluZyB0aGVtIGlzCj4+IGZpbmUsIGJ1dCB5b3Ugc2hvdWxkbid0IGZvciBleGFtcGxlIGNo
YW5nZSB0aGUgdW5pdCBvZiBtZWFzdXJlICh3aGljaCBpcwo+PiBub3QgaGFyZCBzaW5jZSB0aGV5
IGFyZSBhbGwgY291bnRlcnMgOikgYnV0IHBlcmhhcHMgeW91IGNvdWxkIGhhdmUKPj4gbmFub3Nl
Y29uZHMgdnMgVFNDIGN5Y2xlcyBpbiB0aGUgZnV0dXJlIGZvciBzb21lIGNvdW50ZXJzKS4KPj4K
Pj4+Pj4gSSBzZWUgdHdvIGFsdGVybmF0aXZlcyB0byB0aGlzIGFwcHJvYWNoIGhlcmU6Cj4+Pj4+
Cj4+Pj4+IGEpIE9ORV9SRUcKPj4+Pj4KPj4+Pj4gV2UgY2FuIGp1c3QgYWRkIGEgbmV3IERFQlVH
IGFyY2ggaW4gT05FX1JFRyBhbmQgZXhwb3NlIE9ORV9SRUcgcGVyIFZNCj4+Pj4+IGFzIHdlbGwg
KGlmIHdlIHJlYWxseSBoYXZlIHRvPykuIFRoYXQgZ2l2ZXMgdXMgZXhwbGljaXQgaWRlbnRpZmll
cnMKPj4+Pj4gZm9yIGVhY2ggc3RhdCB3aXRoIGFuIGV4cGxpY2l0IHBhdGggdG8gaW50cm9kdWNl
IG5ldyBvbmVzIHdpdGggdmVyeQo+Pj4+PiB1bmlxdWUgaWRlbnRpZmllcnMuCj4+IE9ORV9SRUcg
d291bGQgZm9yY2UgdXMgdG8gZGVmaW5lIGNvbnN0YW50cyBmb3IgZWFjaCBjb3VudGVyLCBhbmQg
d291bGQKPj4gbWFrZSBpdCBoYXJkIHRvIHJldGlyZSB0aGVtLsKgIEkgZG9uJ3QgbGlrZSB0aGlz
Lgo+Cj4gV2h5IGRvZXMgaXQgbWFrZSBpdCBoYXJkIHRvIHJldGlyZSB0aGVtPyBXZSB3b3VsZCBq
dXN0IHJldHVybiAtRUlOVkFMIAo+IG9uIHJldHJpZXZhbCwgbGlrZSB3ZSBkbyBmb3IgYW55IG90
aGVyIG5vbi1zdXBwb3J0ZWQgT05FX1JFRy4KPgo+IEl0J3MgdGhlIHNhbWUgYXMgYSBmaWxlIG5v
dCBleGlzdGluZyBpbiBkZWJ1Z2ZzL3N0YXRmcy4gT3IgYW4gZW50cnkgaW4gCj4gdGhlIGFycmF5
IG9mIHRoaXMgcGF0Y2ggdG8gZGlzYXBwZWFyLgo+Cj4+Cj4+Pj4+IGIpIHBhcnQgb2YgdGhlIG1t
YXAnZWQgdmNwdSBzdHJ1Y3QKPj4KPj4gU2FtZSBoZXJlLsKgIEV2ZW4gaWYgd2Ugc2F5IHRoZSBz
ZW1hbnRpY3Mgb2YgdGhlIHN0cnVjdCB3b3VsZCBiZSBleHBvc2VkCj4+IHRvIHVzZXJzcGFjZSB2
aWEgS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19TVEFULCBzb21lb25lIG1pZ2h0IGVuZCB1cAo+
PiBnZXR0aW5nIHRoaXMgd3JvbmcgYW5kIGV4cGVjdGluZyBhIHBhcnRpY3VsYXIgbGF5b3V0LsKg
IE1pbGFuJ3MgcHJvcG9zZWQKPj4gQVBJIGhhcyB0aGUgYmlnIGFkdmFudGFnZSBvZiBiZWluZyBo
YXJkIHRvIGdldCB3cm9uZyBmb3IgdXNlcnNwYWNlLsKgIEFuZAo+PiBwdXNoaW5nIHRoZSBhZ2dy
ZWdhdGlvbiB0byB1c2Vyc3BhY2UgaXMgbm90IGEgaHVnZSBjaG9yZSwgYnV0IGl0J3Mgc3RpbGwK
Pj4gYSBjaG9yZS4KPj4KPj4gU28gdW5sZXNzIHNvbWVvbmUgaGFzIGEgdXNlY2FzZSBmb3IgbGF0
ZW5jeS1zZW5zaXRpdmUgbW9uaXRvcmluZyBJJ2QKPj4gcHJlZmVyIHRvIGtlZXAgaXQgc2ltcGxl
ICh1c3VhbGx5IHRoZXNlIGtpbmQgb2Ygc3RhdHMgY2FuIGV2ZW4gbWFrZQo+PiBzZW5zZSBpZiB5
b3UgZ2F0aGVyIHRoZW0gb3ZlciByZWxhdGl2ZWx5IGxhcmdlIHBlcmlvZCBvZiB0aW1lLCBiZWNh
dXNlCj4+IHRoZW4geW91J2xsIHByb2JhYmx5IHVzZSBzb21ldGhpbmcgZWxzZSBsaWtlIHRyYWNl
cG9pbnRzIHRvIGFjdHVhbGx5Cj4+IHBpbnBvaW50IHdoYXQncyBnb2luZyBvbikuCj4KPiBJIHRl
bmQgdG8gYWdyZWUuIEZldGNoaW5nIHRoZW0gdmlhIGFuIGV4cGxpY2l0IGNhbGwgaW50byB0aGUg
a2VybmVsIGlzIAo+IGRlZmluaXRlbHkgdGhlIHNhZmVyIHJvdXRlLgo+Cj4+Cj4+Pj4+IDIpIHZj
cHUgY291bnRlcnMKPj4+Pj4KPj4+Pj4gTW9zdCBvZiB0aGUgY291bnRlcnMgY291bnQgb24gdmNw
dSBncmFudWxhcml0eSwgYnV0IGRlYnVnZnMgb25seQo+Pj4+PiBnaXZlcyB1cyBhIGZ1bGwgVk0g
dmlldy4gV2hhdGV2ZXIgd2UgZG8gdG8gaW1wcm92ZSB0aGUgc2l0dWF0aW9uLCB3ZQo+Pj4+PiBz
aG91bGQgZGVmaW5pdGVseSB0cnkgdG8gYnVpbGQgc29tZXRoaW5nIHRoYXQgYWxsb3dzIHVzIHRv
IGdldCB0aGUKPj4+Pj4gY291bnRlcnMgcGVyIHZjcHUgKGFzIHdlbGwpLgo+Pj4+Pgo+Pj4+PiBU
aGUgbWFpbiBwdXJwb3NlIG9mIHRoZXNlIGNvdW50ZXJzIGlzIG1vbml0b3JpbmcuIEl0IGNhbiBi
ZSBxdWl0ZQo+Pj4+PiBpbXBvcnRhbnQgdG8ga25vdyB0aGF0IG9ubHkgYSBzaW5nbGUgdkNQVSBp
cyBnb2luZyB3aWxkLCBjb21wYXJlZCB0bwo+Pj4+PiBhbGwgb2YgdGhlbSBmb3IgZXhhbXBsZS4K
Pj4+Pgo+Pj4+IEkgYWdyZWUsIGV4cG9zaW5nIHBlciB2Y3B1IGNvdW50ZXJzIGNhbiBiZSB1c2Vm
dWwuIEkgZ3Vlc3MgaXQgZGlkbid0Cj4+Pj4gbWFrZSBtdWNoIHNlbnNlIGV4cG9zaW5nIHRoZW0g
dGhyb3VnaCBkZWJ1Z2ZzIHNvIGFnZ3JlZ2F0aW9uIHdhcyBkb25lCj4+Pj4gaW4ga2VybmVsLiBI
b3dldmVyIGlmIHdlIGNob3NlIHRvIGdvIHdpdGggYXBwcm9hY2ggMS1iKSBtbWFwIGNvdW50ZXJz
Cj4+Pj4gc3RydWN0IGluIHVzZXJzcGFjZSwgd2UgY291bGQgZG8gdGhpcy4KPj4+Cj4+PiBUaGUg
cmVhc29uIEkgZGlzbGlrZSB0aGUgZGVidWdmcy9zdGF0ZnMgYXBwcm9hY2ggaXMgdGhhdCBpdCBn
ZW5lcmF0ZXMgYQo+Pj4gY29tcGxldGVseSBzZXBhcmF0ZSBwZXJtaXNzaW9uIGFuZCBhY2Nlc3Mg
cGF0aHMgdG8gdGhlIHN0YXRzLiBUaGF0J3MKPj4+IGdyZWF0IGZvciBmdWxsIHN5c3RlbSBtb25p
dG9yaW5nLCBidXQgcmVhbGx5IGJhZCB3aGVuIHlvdSBoYXZlIG11bHRpcGxlCj4+PiBpbmRpdmlk
dWFsIHRlbmFudHMgb24gYSBzaW5nbGUgaG9zdC4KPj4KPj4gSSBhZ3JlZSwgYW55dGhpbmcgaW4g
c3lzZnMgaXMgY29tcGxlbWVudGFyeSB0byB2bWZkL3ZjcHVmZCBhY2Nlc3MuCj4KPiBDb29sIDop
Lgo+Cj4gU28gd2Ugb25seSBuZWVkIHRvIGFncmVlIG9uIE9ORV9SRUcgdnMuIHRoaXMgcGF0Y2gg
bW9zdGx5PwoKV2hhdCBhYm91dCBleHRlbmRpbmcgS1ZNX0dFVF9TVVBQT1JURURfREVCVUdGU19T
VEFUIHdpdGggc29tZSBhZGRpdGlvbmFsIAppbmZvcm1hdGlvbiBsaWtlIHRoZSBkYXRhIHR5cGUg
YW5kIHVuaXQ/IE9ORV9SRUcgZXhwb3NlcyBhZGRpdGlvbmFsIApzZW1hbnRpY3MgYWJvdXQgZGF0
YS4KCj4KPiBBbGV4CgoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK

