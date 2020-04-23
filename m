Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAC21B5C5A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgDWNUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:20:08 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13469 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgDWNUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 09:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587648007; x=1619184007;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ozfKvw6mOaujxK+s76z9iF1pqL4KXLNOSEQT+R+GhJc=;
  b=k1v1uEaqyWsh9rhWqrlwm0/9Px2mcWIygVDbAx2b/RY4BhMhp/bPhXO9
   kGe41Y20X0SNJrnUojM5U8zssuOBx28cg3n5InxDdq0QhhYegfxY4955X
   G9BA47tlulk3KfrZLMKrd1rbaOrrXlHMp90CF7+1PcUKNBag94jbRgRcm
   E=;
IronPort-SDR: xg5f1mpI4ahD/RPTcm8jL0R1aHFMYgtxDPc9RnGDOzb4KP9AcqrhCR93EQ0hpxT52m+2lCObKg
 gPGYyQaSE2dw==
X-IronPort-AV: E=Sophos;i="5.73,307,1583193600"; 
   d="scan'208";a="27045456"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Apr 2020 13:19:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 5E2B1A229A;
        Thu, 23 Apr 2020 13:19:54 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 13:19:53 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.148) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 13:19:46 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
Date:   Thu, 23 Apr 2020 16:19:36 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.148]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNC8yMDIwIDAwOjQ2LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIxLzA0LzIw
IDIwOjQxLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+IEFuIGVuY2xhdmUgY29tbXVuaWNhdGVz
IHdpdGggdGhlIHByaW1hcnkgVk0gdmlhIGEgbG9jYWwgY29tbXVuaWNhdGlvbiBjaGFubmVsLAo+
PiB1c2luZyB2aXJ0aW8tdnNvY2sgWzJdLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgYSBkaXNr
IG9yIGEgbmV0d29yayBkZXZpY2UKPj4gYXR0YWNoZWQuCj4gSXMgaXQgcG9zc2libGUgdG8gaGF2
ZSBhIHNhbXBsZSBvZiB0aGlzIGluIHRoZSBzYW1wbGVzLyBkaXJlY3Rvcnk/CgpJIGNhbiBhZGQg
aW4gdjIgYSBzYW1wbGUgZmlsZSBpbmNsdWRpbmcgdGhlIGJhc2ljIGZsb3cgb2YgaG93IHRvIHVz
ZSB0aGUgCmlvY3RsIGludGVyZmFjZSB0byBjcmVhdGUgLyB0ZXJtaW5hdGUgYW4gZW5jbGF2ZS4K
ClRoZW4gd2UgY2FuIHVwZGF0ZSAvIGJ1aWxkIG9uIHRvcCBpdCBiYXNlZCBvbiB0aGUgb25nb2lu
ZyBkaXNjdXNzaW9ucyBvbiAKdGhlIHBhdGNoIHNlcmllcyBhbmQgdGhlIHJlY2VpdmVkIGZlZWRi
YWNrLgoKPgo+IEkgYW0gaW50ZXJlc3RlZCBlc3BlY2lhbGx5IGluOgo+Cj4gLSB0aGUgaW5pdGlh
bCBDUFUgc3RhdGU6IENQTDAgdnMuIENQTDMsIGluaXRpYWwgcHJvZ3JhbSBjb3VudGVyLCBldGMu
Cj4KPiAtIHRoZSBjb21tdW5pY2F0aW9uIGNoYW5uZWw7IGRvZXMgdGhlIGVuY2xhdmUgc2VlIHRo
ZSB1c3VhbCBsb2NhbCBBUElDCj4gYW5kIElPQVBJQyBpbnRlcmZhY2VzIGluIG9yZGVyIHRvIGdl
dCBpbnRlcnJ1cHRzIGZyb20gdmlydGlvLXZzb2NrLCBhbmQKPiB3aGVyZSBpcyB0aGUgdmlydGlv
LXZzb2NrIGRldmljZSAodmlydGlvLW1taW8gSSBzdXBwb3NlKSBwbGFjZWQgaW4gbWVtb3J5Pwo+
Cj4gLSB3aGF0IHRoZSBlbmNsYXZlIGlzIGFsbG93ZWQgdG8gZG86IGNhbiBpdCBjaGFuZ2UgcHJp
dmlsZWdlIGxldmVscywKPiB3aGF0IGhhcHBlbnMgaWYgdGhlIGVuY2xhdmUgcGVyZm9ybXMgYW4g
YWNjZXNzIHRvIG5vbmV4aXN0ZW50IG1lbW9yeSwgZXRjLgo+Cj4gLSB3aGV0aGVyIHRoZXJlIGFy
ZSBzcGVjaWFsIGh5cGVyY2FsbCBpbnRlcmZhY2VzIGZvciB0aGUgZW5jbGF2ZQoKQW4gZW5jbGF2
ZSBpcyBhIFZNLCBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMgdGhlIHByaW1hcnkgVk0sIHRo
YXQgCmxhdW5jaGVkIHRoZSBlbmNsYXZlLiBUaGV5IGFyZSBzaWJsaW5ncy4KCkhlcmUgd2UgbmVl
ZCB0byB0aGluayBvZiB0d28gY29tcG9uZW50czoKCjEuIEFuIGVuY2xhdmUgYWJzdHJhY3Rpb24g
cHJvY2VzcyAtIGEgcHJvY2VzcyBydW5uaW5nIGluIHRoZSBwcmltYXJ5IFZNIApndWVzdCwgdGhh
dCB1c2VzIHRoZSBwcm92aWRlZCBpb2N0bCBpbnRlcmZhY2Ugb2YgdGhlIE5pdHJvIEVuY2xhdmVz
IAprZXJuZWwgZHJpdmVyIHRvIHNwYXduIGFuIGVuY2xhdmUgVk0gKHRoYXQncyAyIGJlbG93KS4K
CkhvdyBkb2VzIGFsbCBnZXRzIHRvIGFuIGVuY2xhdmUgVk0gcnVubmluZyBvbiB0aGUgaG9zdD8K
ClRoZXJlIGlzIGEgTml0cm8gRW5jbGF2ZXMgZW11bGF0ZWQgUENJIGRldmljZSBleHBvc2VkIHRv
IHRoZSBwcmltYXJ5IFZNLiAKVGhlIGRyaXZlciBmb3IgdGhpcyBuZXcgUENJIGRldmljZSBpcyBp
bmNsdWRlZCBpbiB0aGUgY3VycmVudCBwYXRjaCBzZXJpZXMuCgpUaGUgaW9jdGwgbG9naWMgaXMg
bWFwcGVkIHRvIFBDSSBkZXZpY2UgY29tbWFuZHMgZS5nLiB0aGUgCk5FX0VOQ0xBVkVfU1RBUlQg
aW9jdGwgbWFwcyB0byBhbiBlbmNsYXZlIHN0YXJ0IFBDSSBjb21tYW5kIG9yIHRoZSAKS1ZNX1NF
VF9VU0VSX01FTU9SWV9SRUdJT04gbWFwcyB0byBhbiBhZGQgbWVtb3J5IFBDSSBjb21tYW5kLiBU
aGUgUENJIApkZXZpY2UgY29tbWFuZHMgYXJlIHRoZW4gdHJhbnNsYXRlZCBpbnRvIGFjdGlvbnMg
dGFrZW4gb24gdGhlIGh5cGVydmlzb3IgCnNpZGU7IHRoYXQncyB0aGUgTml0cm8gaHlwZXJ2aXNv
ciBydW5uaW5nIG9uIHRoZSBob3N0IHdoZXJlIHRoZSBwcmltYXJ5IApWTSBpcyBydW5uaW5nLgoK
Mi4gVGhlIGVuY2xhdmUgaXRzZWxmIC0gYSBWTSBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMg
dGhlIHByaW1hcnkgVk0gCnRoYXQgc3Bhd25lZCBpdC4KClRoZSBlbmNsYXZlIFZNIGhhcyBubyBw
ZXJzaXN0ZW50IHN0b3JhZ2Ugb3IgbmV0d29yayBpbnRlcmZhY2UgYXR0YWNoZWQsIAppdCB1c2Vz
IGl0cyBvd24gbWVtb3J5IGFuZCBDUFVzICsgaXRzIHZpcnRpby12c29jayBlbXVsYXRlZCBkZXZp
Y2UgZm9yIApjb21tdW5pY2F0aW9uIHdpdGggdGhlIHByaW1hcnkgVk0uCgpUaGUgbWVtb3J5IGFu
ZCBDUFVzIGFyZSBjYXJ2ZWQgb3V0IG9mIHRoZSBwcmltYXJ5IFZNLCB0aGV5IGFyZSBkZWRpY2F0
ZWQgCmZvciB0aGUgZW5jbGF2ZS4gVGhlIE5pdHJvIGh5cGVydmlzb3IgcnVubmluZyBvbiB0aGUg
aG9zdCBlbnN1cmVzIG1lbW9yeSAKYW5kIENQVSBpc29sYXRpb24gYmV0d2VlbiB0aGUgcHJpbWFy
eSBWTSBhbmQgdGhlIGVuY2xhdmUgVk0uCgoKVGhlc2UgdHdvIGNvbXBvbmVudHMgbmVlZCB0byBy
ZWZsZWN0IHRoZSBzYW1lIHN0YXRlIGUuZy4gd2hlbiB0aGUgCmVuY2xhdmUgYWJzdHJhY3Rpb24g
cHJvY2VzcyAoMSkgaXMgdGVybWluYXRlZCwgdGhlIGVuY2xhdmUgVk0gKDIpIGlzIAp0ZXJtaW5h
dGVkIGFzIHdlbGwuCgpXaXRoIHJlZ2FyZCB0byB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsLCB0
aGUgcHJpbWFyeSBWTSBoYXMgaXRzIG93biAKZW11bGF0ZWQgdmlydGlvLXZzb2NrIFBDSSBkZXZp
Y2UuIFRoZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkIAp2aXJ0aW8tdnNvY2sgZGV2
aWNlIGFzIHdlbGwuIFRoaXMgY2hhbm5lbCBpcyB1c2VkLCBmb3IgZXhhbXBsZSwgdG8gZmV0Y2gg
CmRhdGEgaW4gdGhlIGVuY2xhdmUgYW5kIHRoZW4gcHJvY2VzcyBpdC4gQW4gYXBwbGljYXRpb24g
dGhhdCBzZXRzIHVwIHRoZSAKdnNvY2sgc29ja2V0IGFuZCBjb25uZWN0cyBvciBsaXN0ZW5zLCBk
ZXBlbmRpbmcgb24gdGhlIHVzZSBjYXNlLCBpcyB0aGVuIApkZXZlbG9wZWQgdG8gdXNlIHRoaXMg
Y2hhbm5lbDsgdGhpcyBoYXBwZW5zIG9uIGJvdGggZW5kcyAtIHByaW1hcnkgVk0gCmFuZCBlbmNs
YXZlIFZNLgoKTGV0IG1lIGtub3cgaWYgZnVydGhlciBjbGFyaWZpY2F0aW9ucyBhcmUgbmVlZGVk
LgoKPgo+PiBUaGUgcHJvcG9zZWQgc29sdXRpb24gaXMgZm9sbG93aW5nIHRoZSBLVk0gbW9kZWwg
YW5kIHVzZXMgdGhlIEtWTSBBUEkgdG8gYmUgYWJsZQo+PiB0byBjcmVhdGUgYW5kIHNldCByZXNv
dXJjZXMgZm9yIGVuY2xhdmVzLiBBbiBhZGRpdGlvbmFsIGlvY3RsIGNvbW1hbmQsIGJlc2lkZXMK
Pj4gdGhlIG9uZXMgcHJvdmlkZWQgYnkgS1ZNLCBpcyB1c2VkIHRvIHN0YXJ0IGFuIGVuY2xhdmUg
YW5kIHNldHVwIHRoZSBhZGRyZXNzaW5nCj4+IGZvciB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVs
IGFuZCBhbiBlbmNsYXZlIHVuaXF1ZSBpZC4KPiBSZXVzaW5nIHNvbWUgS1ZNIGlvY3RscyBpcyBk
ZWZpbml0ZWx5IGEgZ29vZCBpZGVhLCBidXQgSSB3b3VsZG4ndCByZWFsbHkKPiBzYXkgaXQncyB0
aGUgS1ZNIEFQSSBzaW5jZSB0aGUgVkNQVSBmaWxlIGRlc2NyaXB0b3IgaXMgYmFzaWNhbGx5IG5v
bgo+IGZ1bmN0aW9uYWwgKHdpdGhvdXQgS1ZNX1JVTiBhbmQgbW1hcCBpdCdzIG5vdCByZWFsbHkg
dGhlIEtWTSBBUEkpLgoKSXQgdXNlcyBwYXJ0IG9mIHRoZSBLVk0gQVBJIG9yIGEgc2V0IG9mIEtW
TSBpb2N0bHMgdG8gbW9kZWwgdGhlIHdheSBhIFZNIAppcyBjcmVhdGVkIC8gdGVybWluYXRlZC4g
VGhhdCdzIHRydWUsIEtWTV9SVU4gYW5kIG1tYXAtaW5nIHRoZSB2Y3B1IGZkIAphcmUgbm90IGlu
Y2x1ZGVkLgoKVGhhbmtzIGZvciB0aGUgZmVlZGJhY2sgcmVnYXJkaW5nIHRoZSByZXVzZSBvZiBL
Vk0gaW9jdGxzLgoKQW5kcmEKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEp
IFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZs
b29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4g
Um9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

