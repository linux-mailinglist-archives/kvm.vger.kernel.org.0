Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0531822C1A7
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 11:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgGXJHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 05:07:08 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58792 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgGXJHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 05:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595581628; x=1627117628;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SnHgqmiQUD4XshdDPA+vnPl3dgw2yQNc9wCsnE+VAf0=;
  b=j+17cP8AGT90ExAxvGkNuyK4HqG9Tmi5OTRaCattYy2oBBBNFVKGIYy/
   H972vccdo92C1nUEJYV4VbLKJbmGh6+ErXtMa8CreguM/SsOUY0RZwshl
   Pxez29QkuaZBvTEEqv77O9sV+RHh+a1b8SkMnDa7G0cfEzeUXYcxus58H
   c=;
IronPort-SDR: EzGzwhrHpPbzQ5IUq1hbrdziEcySU+OaSAxPVXZ7H4KjDsw4D50sBlS15zxzN8tlboHtDoMmMy
 vgX1kGT5Jgew==
X-IronPort-AV: E=Sophos;i="5.75,390,1589241600"; 
   d="scan'208";a="43839128"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Jul 2020 09:07:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 1DD96A2A97;
        Fri, 24 Jul 2020 09:07:04 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Jul 2020 09:07:03 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.109) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Jul 2020 09:06:53 +0000
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
To:     Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, Alexander Graf <graf@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
 <20200722095759.GA2817347@kroah.com>
 <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
 <20200723105409.GC1949236@kroah.com>
 <dd99213b-3caf-4fc0-1bf5-314297e3d450@amazon.com>
 <a085bf17-8f83-5946-0f79-97230616b4b3@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <993ba3eb-bf79-6512-2c0e-f959298b8601@amazon.com>
Date:   Fri, 24 Jul 2020 12:06:24 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a085bf17-8f83-5946-0f79-97230616b4b3@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D42UWA002.ant.amazon.com (10.43.160.16) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC8wNy8yMDIwIDAyOjA0LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPgo+Cj4gT24gMjMu
MDcuMjAgMjA6MjEsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDIz
LzA3LzIwMjAgMTM6NTQsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBUaHUsIEp1bCAyMywgMjAyMCBh
dCAxMjoyMzo1NlBNICswMzAwLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Pj4+Cj4+
Pj4gT24gMjIvMDcvMjAyMCAxMjo1NywgR3JlZyBLSCB3cm90ZToKPj4+Pj4gT24gV2VkLCBKdWwg
MjIsIDIwMjAgYXQgMTE6Mjc6MjlBTSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSAKPj4+
Pj4gd3JvdGU6Cj4+Pj4+Pj4+ICsjaWZuZGVmIF9VQVBJX0xJTlVYX05JVFJPX0VOQ0xBVkVTX0hf
Cj4+Pj4+Pj4+ICsjZGVmaW5lIF9VQVBJX0xJTlVYX05JVFJPX0VOQ0xBVkVTX0hfCj4+Pj4+Pj4+
ICsKPj4+Pj4+Pj4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgo+Pj4+Pj4+PiArCj4+Pj4+Pj4+
ICsvKiBOaXRybyBFbmNsYXZlcyAoTkUpIEtlcm5lbCBEcml2ZXIgSW50ZXJmYWNlICovCj4+Pj4+
Pj4+ICsKPj4+Pj4+Pj4gKyNkZWZpbmUgTkVfQVBJX1ZFUlNJT04gKDEpCj4+Pj4+Pj4gV2h5IGRv
IHlvdSBuZWVkIHRoaXMgdmVyc2lvbj/CoCBJdCBzaG91bGRuJ3QgYmUgbmVlZGVkLCByaWdodD8K
Pj4+Pj4+IFRoZSB2ZXJzaW9uIGlzIHVzZWQgYXMgYSB3YXkgZm9yIHRoZSB1c2VyIHNwYWNlIHRv
b2xpbmcgdG8gc3luYyAKPj4+Pj4+IG9uIHRoZQo+Pj4+Pj4gZmVhdHVyZXMgc2V0IHByb3ZpZGVk
IGJ5IHRoZSBkcml2ZXIgZS5nLiBpbiBjYXNlIGFuIG9sZGVyIHZlcnNpb24gCj4+Pj4+PiBvZiB0
aGUKPj4+Pj4+IGRyaXZlciBpcyBhdmFpbGFibGUgb24gdGhlIHN5c3RlbSBhbmQgdGhlIHVzZXIg
c3BhY2UgdG9vbGluZyAKPj4+Pj4+IGV4cGVjdHMgYSBzZXQKPj4+Pj4+IG9mIGZlYXR1cmVzIHRo
YXQgaXMgbm90IGluY2x1ZGVkIGluIHRoYXQgZHJpdmVyIHZlcnNpb24uCj4+Pj4+IFRoYXQgaXMg
Z3VhcmFudGVlZCB0byBnZXQgb3V0IG9mIHN5bmMgaW5zdGFudGx5IHdpdGggZGlmZmVyZW50IGRp
c3Rybwo+Pj4+PiBrZXJuZWxzIGJhY2twb3J0aW5nIHJhbmRvbSB0aGluZ3MsIGNvbWJpbmVkIHdp
dGggc3RhYmxlIGtlcm5lbCBwYXRjaAo+Pj4+PiB1cGRhdGVzIGFuZCB0aGUgbGlrZS4KPj4+Pj4K
Pj4+Pj4gSnVzdCB1c2UgdGhlIG5vcm1hbCBhcGkgaW50ZXJmYWNlcyBpbnN0ZWFkLCBkb24ndCB0
cnkgdG8gInZlcnNpb24iCj4+Pj4+IGFueXRoaW5nLCBpdCB3aWxsIG5vdCB3b3JrLCB0cnVzdCB1
cyA6KQo+Pj4+Pgo+Pj4+PiBJZiBhbiBpb2N0bCByZXR1cm5zIC1FTk9UVFkgdGhlbiBoZXksIGl0
J3Mgbm90IHByZXNlbnQgYW5kIHlvdXIKPj4+Pj4gdXNlcnNwYWNlIGNvZGUgY2FuIGhhbmRsZSBp
dCB0aGF0IHdheS4KPj4+PiBDb3JyZWN0LCB0aGVyZSBjb3VsZCBiZSBhIHZhcmlldHkgb2Yga2Vy
bmVsIHZlcnNpb25zIGFuZCB1c2VyIHNwYWNlIAo+Pj4+IHRvb2xpbmcKPj4+PiBlaXRoZXIgaW4g
dGhlIG9yaWdpbmFsIGZvcm0sIGN1c3RvbWl6ZWQgb3Igd3JpdHRlbiBmcm9tIHNjcmF0Y2guIAo+
Pj4+IEFuZCBFTk9UVFkKPj4+PiBzaWduYWxzIGFuIGlvY3RsIG5vdCBhdmFpbGFibGUgb3IgZS5n
LiBFSU5WQUwgKG9yIGN1c3RvbSBlcnJvcikgaWYgdGhlCj4+Pj4gcGFyYW1ldGVyIGZpZWxkIHZh
bHVlIGlzIG5vdCB2YWxpZCB3aXRoaW4gYSBjZXJ0YWluIHZlcnNpb24uIFdlIAo+Pj4+IGhhdmUg
dGhlc2UKPj4+PiBpbiBwbGFjZSwgdGhhdCdzIGdvb2QuIDopCj4+Pj4KPj4+PiBIb3dldmVyLCBJ
IHdhcyB0aGlua2luZywgZm9yIGV4YW1wbGUsIG9mIGFuIGlvY3RsIGZsb3cgdXNhZ2Ugd2hlcmUg
Cj4+Pj4gYSBjZXJ0YWluCj4+Pj4gb3JkZXIgbmVlZHMgdG8gYmUgZm9sbG93ZWQgZS5nLiBjcmVh
dGUgYSBWTSwgYWRkIHJlc291cmNlcyB0byBhIFZNLCAKPj4+PiBzdGFydCBhCj4+Pj4gVk0uCj4+
Pj4KPj4+PiBMZXQncyBzYXksIGZvciBhbiB1c2UgY2FzZSB3cnQgbmV3IGZlYXR1cmVzLCBpb2N0
bCBBIChjcmVhdGUgYSBWTSkgCj4+Pj4gc3VjY2VlZHMsCj4+Pj4gaW9jdGwgQiAoYWRkIG1lbW9y
eSB0byB0aGUgVk0pIHN1Y2NlZWRzLCBpb2N0bCBDIChhZGQgQ1BVIHRvIHRoZSBWTSkKPj4+PiBz
dWNjZWVkcyBhbmQgaW9jdGwgRCAoYWRkIGFueSBvdGhlciB0eXBlIG9mIHJlc291cmNlIGJlZm9y
ZSAKPj4+PiBzdGFydGluZyB0aGUgVk0pCj4+Pj4gZmFpbHMgYmVjYXVzZSBpdCBpcyBub3Qgc3Vw
cG9ydGVkLgo+Pj4+Cj4+Pj4gV291bGQgbm90IG5lZWQgdG8gY2FsbCBpb2N0bCBBIHRvIEMgYW5k
IGdvIHRocm91Z2ggdGhlaXIgdW5kZXJuZWF0aCAKPj4+PiBsb2dpYyB0bwo+Pj4+IHJlYWxpemUg
aW9jdGwgRCBzdXBwb3J0IGlzIG5vdCB0aGVyZSBhbmQgcm9sbGJhY2sgYWxsIHRoZSBjaGFuZ2Vz
IAo+Pj4+IGRvbmUgdGlsbAo+Pj4+IHRoZW4gd2l0aGluIGlvY3RsIEEgdG8gQyBsb2dpYy4gT2Yg
Y291cnNlLCB0aGVyZSBjb3VsZCBiZSBpb2N0bCBBIAo+Pj4+IGZvbGxvd2VkCj4+Pj4gYnkgaW9j
dGwgRCwgYW5kIHdvdWxkIG5lZWQgdG8gcm9sbGJhY2sgaW9jdGwgQSBjaGFuZ2VzLCBidXQgSSAK
Pj4+PiBzaGFyZWQgYSBtb3JlCj4+Pj4gbGVuZ3RoeSBjYWxsIGNoYWluIHRoYXQgY2FuIGJlIGFu
IG9wdGlvbiBhcyB3ZWxsLgo+Pj4gSSB0aGluayB5b3UgYXJlIG92ZXJ0aGlua2luZyB0aGlzLgo+
Pj4KPj4+IElmIHlvdXIgaW50ZXJmYWNlIGlzIHRoaXMgY29tcGxleCwgeW91IGhhdmUgbXVjaCBs
YXJnZXIgaXNzdWVzIGFzIHlvdQo+Pj4gQUxXQVlTIGhhdmUgdG8gYmUgYWJsZSB0byBoYW5kbGUg
ZXJyb3IgY29uZGl0aW9ucyBwcm9wZXJseSwgZXZlbiBpZiB0aGUKPj4+IEFQSSBpcyAic3VwcG9y
dGVkIi4KPj4KPj4gVHJ1ZSwgdGhlIGVycm9yIHBhdGhzIG5lZWQgdG8gaGFuZGxlZCBjb3JyZWN0
bHkgb24gdGhlIGtlcm5lbCBkcml2ZXIgCj4+IGFuZCBvbiB0aGUgdXNlciBzcGFjZSBsb2dpYyBz
aWRlLCBpbmRlcGVuZGVudCBvZiBzdXBwb3J0ZWQgZmVhdHVyZXMgCj4+IG9yIG5vdC4gQ2Fubm90
IGFzc3VtZSB0aGF0IGFsbCBpb2N0bCBjYWxsZXJzIGFyZSBiZWhhdmluZyBjb3JyZWN0bHkgCj4+
IG9yIHRoZXJlIGFyZSBubyBlcnJvcnMgaW4gdGhlIHN5c3RlbS4KPj4KPj4gV2hhdCBJIHdhbnRl
ZCB0byBjb3ZlciB3aXRoIHRoYXQgZXhhbXBsZSBpcyBtb3JlIHRvd2FyZHMgdGhlIHVzZXIgCj4+
IHNwYWNlIGxvZ2ljIHVzaW5nIG5ldyBmZWF0dXJlcywgZWl0aGVyIGVhcmx5IGV4aXRpbmcgYmVm
b3JlIGV2ZW4gCj4+IHRyeWluZyB0aGUgaW9jdGwgY2FsbCBmbG93IHBhdGggb3IgZ29pbmcgdGhy
b3VnaCBwYXJ0IG9mIHRoZSBmbG93IAo+PiB0aWxsIGdldHRpbmcgdGhlIGVycm9yIGUuZy4gRU5P
VFRZIGZvciBvbmUgb2YgdGhlIGlvY3RsIGNhbGxzLgo+Cj4gSWYgd2UgbmVlZCBhbiBBUEkgdG8g
cXVlcnkgZm9yIG5ldyBmZWF0dXJlcywgd2UgY2FuIGFkZCBpdCBvbmNlIHdlIGFkZCAKPiBuZXcg
ZmVhdHVyZXMsIG5vPyBUaGUgYWJzZW5jZSBvZiB0aGUgcXVlcnkgQVBJIHdpbGwgaW5kaWNhdGUg
dGhhdCBubyAKPiBhZGRpdGlvbmFsIGZlYXR1cmVzIGFyZSBhdmFpbGFibGUuCj4KPiBTbyB5ZXMs
IHNvcnJ5LCBvdmVyc2lnaHQgb24gbXkgc2lkZSA6KC4gSSBhZ3JlZSB3aXRoIEdyZWc6IHRoZXJl
IAo+IHJlYWxseSBpcyBubyBuZWVkIGZvciBhIHZlcnNpb24gcXVlcnkgQVBJIGFzIG9mIHRvZGF5
LgoKTm8gcHJvYmxlbS4gSSBjYW4gcmVtb3ZlIHRoZSB2ZXJzaW9uaW5nIGxvZ2ljIGZvciBub3cs
IGFsdGhvdWdoIEkgdGhpbmsgCml0IHdvdWxkIGhhdmUgYmVlbiBmaW5lIHRvIGhhdmUgaXQgZnJv
bSB0aGUgYmVnaW5uaW5nIGlmIHdlIHdhbnQgdG8gbW92ZSAKZnVydGhlciB3aXRoIGEgdmVyc2lv
biBxdWVyeSBBUEkgaW4gdGhlIGVuZC4KClRoZSBvdmVyYWxsIGRpc2N1c3Npb24gaGVyZSB3YXMg
bW9yZSB0b3dhcmRzIGhhdmluZyB0aGUgdmVyc2lvbmluZyBsb2dpYyAKb3Igbm90IGF0IGFsbCwg
ZWl0aGVyIHdpdGhpbiB0aGUgY3VycmVudCBjb2RlIGJhc2Ugb3Igd2hpbGUgZ2V0dGluZyB0byAK
bmV3IGZlYXR1cmVzLgoKPgo+Pgo+Pj4KPj4+IFBlcmhhcHMgeW91ciBBUEkgaXMgc2hvd2luZyB0
byBiZSB0b28gY29tcGxleD8KPj4+Cj4+PiBBbHNvLCB3aGVyZSBpcyB0aGUgdXNlcnNwYWNlIGNv
ZGUgZm9yIGFsbCBvZiB0aGlzP8KgIERpZCBJIG1pc3MgYSAKPj4+IGxpbmsgdG8KPj4+IGl0IGlu
IHRoZSBwYXRjaGVzIHNvbWV3aGVyZT8KPj4KPj4gTm9wZSwgeW91IGRpZG4ndCBtaXNzIGFueSBy
ZWZlcmVuY2VzIHRvIGl0LiBUaGUgY29kZWJhc2UgZm9yIHRoZSB1c2VyIAo+PiBzcGFjZSBjb2Rl
IGlzIG5vdCBwdWJsaWNseSBhdmFpbGFibGUgZm9yIG5vdywgYnV0IGl0IHdpbGwgYmUgCj4+IGF2
YWlsYWJsZSBvbiBHaXRIdWIgb25jZSB0aGUgd2hvbGUgcHJvamVjdCBpcyBHQS4gQW5kIEknbGwg
aW5jbHVkZSAKPj4gdGhlIHJlZnMsIG9uY2UgYXZhaWxhYmxlLCBpbiB0aGUgTkUga2VybmVsIGRy
aXZlciBkb2N1bWVudGF0aW9uLgo+Cj4gUGF0Y2ggMTYvMTggY29udGFpbnMgYW4gZXhhbXBsZSB1
c2VyIHNwYWNlIHRvIGRyaXZlIHRoZSBpb2N0bCBpbnRlcmZhY2UuCgpZdXAsIGFuZCB0aGUgZmxv
dyBtZW50aW9uZWQgaW4gdGhlIHByZXZpb3VzIG1haWwgaXMgaW5jbHVkZWQgaW4gdGhlIAppb2N0
bCB1c2FnZSBzYW1wbGUuCgpUaGFua3MsCkFuZHJhCgo+Cj4gVGhlIGNvZGUgYmFzZSBBbmRyYSBp
cyByZWZlcnJpbmcgdG8gYWJvdmUgaXMgZ29pbmcgdG8gYmUgYSBtb3JlIAo+IGNvbXBsZXRlIGZy
YW1ld29yayB0byBkcml2ZSBOaXRybyBFbmNsYXZlcyB0aGF0IGFsc28gY29uc3VtZXMgdGhpcyAK
PiBrZXJuZWwgQVBJLgo+Cj4KPiBBbGV4CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChS
b21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBV
QkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3Rl
cmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

