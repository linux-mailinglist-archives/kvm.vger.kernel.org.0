Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F7014711A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 19:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAWSsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 13:48:11 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:56698 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWSsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 13:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579805290; x=1611341290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=aGyMHMvNcGi/II+bGlUDERqvVBaR273u7AY0SBFF/VQ=;
  b=L9B4T5ggSbqu9BtK3ufJUR0w4HSXCmdZfrUTCEZ/N94+CuiDrj0dXS5T
   PyMWZvEsdKGbUMHMe7PTK6AaqUbw68H4ZXcxvr9OCkATCei37K3XpLwO8
   B/N78j437n030u7nToP1quL+Uyd4UxWDbkIwNSVHLAWTVkKUmju6jtkmo
   A=;
IronPort-SDR: 8r06ztd6kBnWVMkT2hT4i6gVgYV7yOUm7m3JaHc5MptIQ9DkeZ20FyhkJhi1RPoGWNXoAmDq6L
 PLlU/im0OgPg==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="14431406"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Jan 2020 18:48:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id E9BC1A2B94;
        Thu, 23 Jan 2020 18:48:00 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 18:48:00 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 18:48:00 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Thu, 23 Jan 2020 18:48:00 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mgorman@techsingularity.net" <mgorman@techsingularity.net>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "yang.zhang.wz@gmail.com" <yang.zhang.wz@gmail.com>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "david@redhat.com" <david@redhat.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        "riel@surriel.com" <riel@surriel.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "wei.w.wang@intel.com" <wei.w.wang@intel.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "Paterson-Jones, Roland" <rolandp@amazon.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "hare@suse.com" <hare@suse.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Singh, Balbir" <sblbir@amazon.com>
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
Thread-Topic: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
Thread-Index: AQHV0da0X9uvNEaCQEmRlS74Ewghgqf4cBmAgAAH64CAABuOgIAABAUk
Date:   Thu, 23 Jan 2020 18:47:59 +0000
Message-ID: <E7B6C412-76D1-47B2-BE62-F29A63A0C8D5@amazon.de>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
         <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
         <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
         <ad73c0c8-3a9c-8ffd-9a31-7e9a5cd5f246@amazon.com>,<3e24a8ad7afe7c2f6ec8ffe7260a3e31bbe41651.camel@linux.intel.com>
In-Reply-To: <3e24a8ad7afe7c2f6ec8ffe7260a3e31bbe41651.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4+IEFtIDIzLjAxLjIwMjAgdW0gMTk6MzQgc2NocmllYiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5oLmR1eWNrQGxpbnV4LmludGVsLmNvbT46DQo+PiANCj4+IO+7v09uIFRodSwgMjAy
MC0wMS0yMyBhdCAxNzo1NCArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6DQo+Pj4gT24gMjMu
MDEuMjAgMTc6MjYsIEFsZXhhbmRlciBEdXljayB3cm90ZToNCj4+PiBPbiBUaHUsIDIwMjAtMDEt
MjMgYXQgMTE6MjAgKzAxMDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KPj4+PiBIaSBBbGV4LA0K
Pj4+Pj4gT24gMjIuMDEuMjAgMTg6NDMsIEFsZXhhbmRlciBEdXljayB3cm90ZToNCj4+IFsuLi5d
DQo+Pj4+PiBUaGUgb3ZlcmFsbCBndWVzdCBzaXplIGlzIGtlcHQgZmFpcmx5IHNtYWxsIHRvIG9u
bHkgYSBmZXcgR0Igd2hpbGUgdGhlIHRlc3QNCj4+Pj4+IGlzIHJ1bm5pbmcuIElmIHRoZSBob3N0
IG1lbW9yeSB3ZXJlIG92ZXJzdWJzY3JpYmVkIHRoaXMgcGF0Y2ggc2V0IHNob3VsZA0KPj4+Pj4g
cmVzdWx0IGluIGEgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgYXMgc3dhcHBpbmcgbWVtb3J5IGlu
IHRoZSBob3N0IGNhbiBiZQ0KPj4+Pj4gYXZvaWRlZC4NCj4+Pj4gSSByZWFsbHkgbGlrZSB0aGUg
YXBwcm9hY2ggb3ZlcmFsbC4gVm9sdW50YXJpbHkgcHJvcGFnYXRpbmcgZnJlZSBtZW1vcnkNCj4+
Pj4gZnJvbSBhIGd1ZXN0IHRvIHRoZSBob3N0IGhhcyBiZWVuIGEgc29yZSBwb2ludCBldmVyIHNp
bmNlIEtWTSB3YXMNCj4+Pj4gYXJvdW5kLiBUaGlzIHNvbHV0aW9uIGxvb2tzIGxpa2UgYSB2ZXJ5
IGVsZWdhbnQgd2F5IHRvIGRvIHNvLg0KPj4+PiBUaGUgYmlnIHBpZWNlIEknbSBtaXNzaW5nIGlz
IHRoZSBwYWdlIGNhY2hlLiBMaW51eCB3aWxsIGJ5IGRlZmF1bHQgdHJ5DQo+Pj4+IHRvIGtlZXAg
dGhlIGZyZWUgbGlzdCBhcyBzbWFsbCBhcyBpdCBjYW4gaW4gZmF2b3Igb2YgcGFnZSBjYWNoZSwg
c28gbW9zdA0KPj4+PiBvZiB0aGUgYmVuZWZpdCBvZiB0aGlzIHBhdGNoIHNldCB3aWxsIGJlIHZv
aWQgaW4gcmVhbCB3b3JsZCBzY2VuYXJpb3MuDQo+Pj4gQWdyZWVkLiBUaGlzIGlzIGEgdGhlIG5l
eHQgcGllY2Ugb2YgdGhpcyBJIHBsYW4gdG8gd29yayBvbiBvbmNlIHRoaXMgaXMNCj4+PiBhY2Nl
cHRlZC4gRm9yIG5vdyB0aGUgcXVpY2sgYW5kIGRpcnR5IGFwcHJvYWNoIGlzIHRvIGVzc2VudGlh
bGx5IG1ha2UgdXNlDQo+Pj4gb2YgdGhlIC9wcm9jL3N5cy92bS9kcm9wX2NhY2hlcyBpbnRlcmZh
Y2UgaW4gdGhlIGd1ZXN0IGJ5IGVpdGhlciBwdXR0aW5nDQo+Pj4gaXQgaW4gYSBjcm9uam9iIHNv
bWV3aGVyZSBvciB0byBoYXZlIGl0IGFmdGVyIG1lbW9yeSBpbnRlbnNpdmUgd29ya2xvYWRzLg0K
Pj4+PiBUcmFkaXRpb25hbGx5LCB0aGlzIHdhcyBzb2x2ZWQgYnkgY3JlYXRpbmcgcHJlc3N1cmUg
ZnJvbSB0aGUgaG9zdA0KPj4+PiB0aHJvdWdoIHZpcnRpby1iYWxsb29uOiBFeGFjdGx5IHRoZSBw
aWVjZSB0aGF0IHRoaXMgcGF0Y2ggc2V0IGdldHMgYXdheQ0KPj4+PiB3aXRoLiBJIG5ldmVyIGxp
a2VkICJiYWxsb29uaW5nIiwgYmVjYXVzZSB0aGUgaG9zdCBoYXMgdmVyeSBsaW1pdGVkDQo+Pj4+
IHZpc2liaWxpdHkgaW50byB0aGUgYWN0dWFsIG1lbW9yeSB1dGlsaXR5IG9mIGl0cyBndWVzdHMu
IFNvIGxlYXZpbmcgdGhlDQo+Pj4+IGRlY2lzaW9uIG9uIGhvdyBtdWNoIG1lbW9yeSBpcyBhY3R1
YWxseSBuZWVkZWQgYXQgYSBnaXZlbiBwb2ludCBpbiB0aW1lDQo+Pj4+IHNob3VsZCBpZGVhbGx5
IHN0YXkgd2l0aCB0aGUgZ3Vlc3QuDQo+Pj4+IFdoYXQgd291bGQga2VlcCB1cyBmcm9tIGFwcGx5
aW5nIHRoZSBwYWdlIGhpbnRpbmcgYXBwcm9hY2ggdG8gaW5hY3RpdmUsDQo+Pj4+IGNsZWFuIHBh
Z2UgY2FjaGUgcGFnZXM/IFdpdGggd3JpdGViYWNrIGluIHBsYWNlIGFzIHdlbGwsIHdlIHdvdWxk
IHNsb3dseQ0KPj4+PiBwcm9wYWdhdGUgcGFnZXMgZnJvbQ0KPj4+PiAgIGRpcnR5IC0+IGNsZWFu
IC0+IGNsZWFuLCBpbmFjdGl2ZSAtPiBmcmVlIC0+IGhvc3Qgb3duZWQNCj4+Pj4gd2hpY2ggZ2l2
ZXMgYSBndWVzdCBhIG5hdHVyYWwgcGF0aCB0byBnaXZlIHVwICJub3QgaW1wb3J0YW50IiBtZW1v
cnkuDQo+Pj4gSSBjb25zaWRlcmVkIHNvbWV0aGluZyBzaW1pbGFyLiBCYXNpY2FsbHkgb25lIHRo
b3VnaHQgSSBoYWQgd2FzIHRvDQo+Pj4gZXNzZW50aWFsbHkgbG9vayBhdCBwdXR0aW5nIHRvZ2V0
aGVyIHNvbWUgc29ydCBvZiBlcG9jaC4gV2hlbiB0aGUgaG9zdCBpcw0KPj4+IHVuZGVyIG1lbW9y
eSBwcmVzc3VyZSBpdCB3b3VsZCBuZWVkIHRvIHNvbWVob3cgbm90aWZ5IHRoZSBndWVzdCBhbmQg
dGhlbg0KPj4+IHRoZSBndWVzdCB3b3VsZCBzdGFydCBtb3ZpbmcgdGhlIGVwb2NoIGZvcndhcmQg
c28gdGhhdCB3ZSBzdGFydCBldmljdGluZw0KPj4+IHBhZ2VzIG91dCBvZiB0aGUgcGFnZSBjYWNo
ZSB3aGVuIHRoZSBob3N0IGlzIHVuZGVyIG1lbW9yeSBwcmVzc3VyZS4NCj4+IEkgdGhpbmsgd2Ug
d2FudCB0byBjb25zaWRlciBhbiBpbnRlcmZhY2UgaW4gd2hpY2ggdGhlIGhvc3QgYWN0aXZlbHkg
YXNrcw0KPj4gZ3Vlc3RzIHRvIHB1cmdlIHBhZ2VzIHRvIGJlIG9uIHRoZSBzYW1lIGxpbmUgYXMg
c3dhcHBpbmc6IFRoZSBsYXN0IGxpbmUNCj4+IG9mIGRlZmVuc2UuDQo+IA0KPiBJIHN1cHBvc2Uu
IFRoZSBvbmx5IHJlYXNvbiBJIHdhcyB0aGlua2luZyB0aGF0IHdlIG1heSB3YW50IHRvIGxvb2sg
YXQNCj4gZG9pbmcgc29tZXRoaW5nIGxpa2UgdGhhdCB3YXMgdG8gYXZvaWQgcHV0dGluZyBwcmVz
c3VyZSBvbiB0aGUgZ3Vlc3Qgd2hlbg0KPiB0aGUgaG9zdCBkb2Vzbid0IG5lZWQgdXMgdG8uDQo+
IA0KPj4gSW4gdGhlIG5vcm1hbCBtb2RlIG9mIG9wZXJhdGlvbiwgeW91IHN0aWxsIHdhbnQgdG8g
c2hyaW5rIGRvd24NCj4+IHZvbHVudGFyaWx5LCBzbyB0aGF0IGV2ZXJ5b25lIGNvb3BlcmF0aXZl
bHkgdHJpZXMgdG8gbWFrZSBmcmVlIGZvciBuZXcNCj4+IGd1ZXN0cyB5b3UgY291bGQgcG90ZW50
aWFsbHkgcnVuIG9uIHRoZSBzYW1lIGhvc3QuDQo+PiBJZiB5b3Ugc3RhcnQgdG8gYXBwbHkgcHJl
c3N1cmUgdG8gZ3Vlc3RzIHRvIGZpbmQgb3V0IG9mIHRoZXkgbWlnaHQgaGF2ZQ0KPj4gc29tZSBw
YWdlcyB0byBzcGFyZSwgd2UncmUgYWxtb3N0IGJhY2sgdG8gdGhlIG9sZCBzdHlsZSBiYWxsb29u
aW5nIGFwcHJvYWNoLg0KPiANCj4gVGhhdHMgdHJ1ZS4gSW4gYWRkaXRpb24gd2UgYXZvaWQgcG9z
c2libGUgaXNzdWVzIHdpdGggdXMgdHJ5aW5nIHRvIGZsdXNoDQo+IG91dCBhIGJ1bmNoIG9mIG1l
bW9yeSBmcm9tIG11bHRpcGxlIGd1ZXN0cyBhcyBvbmNlIHNpbmNlIHRoZXkgd291bGQgYmUNCj4g
cHJvYWN0aXZlbHkgZnJlZWluZyB0aGUgbWVtb3J5Lg0KPiANCj4gSSdtIHRoaW5raW5nIHRoZSBp
bmFjdGl2ZSBzdGF0ZSBjb3VsZCBiZSBzb21ldGhpbmcgc2ltaWxhciB0byBNQURWX0ZSRUUgaW4N
Cj4gdGVybXMgb2YgYmVoYXZpb3IuICBJZiBpdCBzaXRzIGluIHRoZSBxdWV1ZSBmb3IgbG9uZyBl
bm91Z2ggd2UgZGVjaWRlDQo+IG5vYm9keSBpcyB1c2luZyBpdCBhbnltb3JlIHNvIGl0IGlzIGZy
ZWVkLCBidXQgaWYgaXQgaXMgYWNjZXNzZWQgaXQgaXMNCj4gY2hlYXAgZm9yIHVzIHRvIGp1c3Qg
cHV0IGl0IGJhY2sgd2l0aG91dCBtdWNoIGluIHRoZSB3YXkgb2Ygb3ZlcmhlYWQuDQoNCkkgdGhp
bmsgdGhlIG1haW4gZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBNQURWX0ZSRUUgYW5kIHdoYXQgd2Ug
d2FudCBpcyB0aGF0IHdlIGFsc28gd2FudCB0byBwdWxsIHRoZSBwYWdlIGludG8gYWN0aXZlIHN0
YXRlIG9uIHJlYWQuDQoNCkJ1dCBzdXJlLCB0aGF0J3MgYSBwb3NzaWJsZSBpbnRlcmZhY2UuIFdo
YXQgSSdkIGxpa2UgdG8gbWFrZSBzdXJlIG9mIGlzIHRoYXQgd2UgY2FuIGhhdmUgZGlmZmVyZW50
IGhvc3QgcG9saWNpZXM6IGRpc2NhcmQgdGhlIHBhZ2Ugc3RyYWlnaHQgYXdheSwga2VlcCBpdCBm
b3IgYSBmaXhlZCBhbW91bnQgb2YgdGltZSBvciBkaXNjYXJkIGl0IGxhemlseSBvbiBwcmVzc3Vy
ZS4gQXMgbG9uZyBhcyB0aGUgZ3Vlc3QgZ2l2ZXMgdGhlIGhvc3QgaXRzIGNsZWFuIHBhZ2VzIHZv
bHVudGFyaWx5LCBJJ20gaGFwcHkuDQoNCkJ0dywgaGF2ZSB5b3UgYWxyZWFkeSBnaXZlbiB0aG91
Z2h0IHRvIHRoZSBmYXVsdGluZyBpbnRlcmZhY2Ugd2hlbiBhIHBhZ2Ugd2FzIGV2aWN0ZWQ/IFRo
YXQncyB3aGVyZSBpdCBnZXRzIGVzcGVjaWFsbHkgdHJpY2t5LiBXaXRoIGEgc2ltcGxlICJkaXNj
YXJkIHRoZSBwYWdlIHN0cmFpZ2h0IGF3YXkiIHN0eWxlIGludGVyZmFjZSwgd2Ugd291bGQgbm90
IGhhdmUgdG8gZmF1bHQuDQoNCj4gDQo+PiBCdHcsIGhhdmUgeW91IGV2ZXIgbG9va2VkIGF0IENN
TTIgWzFdPyBXaXRoIHRoYXQsIHRoZSBob3N0IGNhbg0KPj4gZXNzZW50aWFsbHkganVzdCAic3Rl
YWwiIHBhZ2VzIGZyb20gdGhlIGd1ZXN0IHdoZW4gaXQgbmVlZHMgYW55LCB3aXRob3V0DQo+PiB0
aGUgbmVlZCB0byBleGVjdXRlIHRoZSBndWVzdCBtZWFud2hpbGUuIFRoYXQgbWVhbnMgaW5zaWRl
IHRoZSBob3N0DQo+PiBzd2FwcGluZyBwYXRoLCBDTU0yIGNhbiBqdXN0IGV2aWN0IGd1ZXN0IHBh
Z2UgY2FjaGUgcGFnZXMgYXMgZWFzaWx5IGFzDQo+PiB3ZSBldmljdCBob3N0IHBhZ2UgY2FjaGUg
cGFnZXMuIFRvIG1lLCB0aGF0J3MgZXZlbiBtb3JlIGF0dHJhY3RpdmUgaW4NCj4+IHRoZSBzd2Fw
IC8gZW1lcmdlbmN5IGNhc2UgdGhhbiBhbiBpbnRlcmZhY2Ugd2hpY2ggcmVxdWlyZXMgdGhlIGd1
ZXN0IHRvDQo+PiBwcm9hY3RpdmVseSBleGVjdXRlIHdoaWxlIHdlIGFyZSBpbiBhIGxvdyBtZW0g
c2l0dWF0aW9uLg0KPiANCj4gPHNuaXA+DQo+IA0KPj4gWzFdIGh0dHBzOi8vd3d3Lmtlcm5lbC5v
cmcvZG9jL29scy8yMDA2L29sczIwMDZ2Mi1wYWdlcy0zMjEtMzM2LnBkZg0KPiANCj4gSSBoYWRu
J3QgcmVhZCB0aHJvdWdoIHRoaXMgYmVmb3JlLiBJZiBub3RoaW5nIGVsc2UgdGhlIHZlcmJpYWdl
IGlzIHVzZWZ1bA0KPiBzaW5jZSB3aGF0IHdlIGFyZSBkaXNjdXNzaW5nIGlzIGVzc2VudGlhbGx5
IGhvdyB0byBkZWFsIHdpdGggdGhlDQo+ICJ2b2xhdGlsZSIgcGFnZXMgd2l0aGluIHRoZSBzeXN0
ZW0sIHRoZSAidW51c2VkIiBwYWdlcyBhcmUgdGhlIG9uZXMgd2UNCj4gaGF2ZSByZXBvcnRlZCB0
byB0aGUgaG9zdCB3aXRoIHRoZSBwYWdlIHJlcG9ydGluZywgYW5kIHRoZSAic3RhYmxlIiBwYWdl
cw0KPiBhcmUgdGhvc2UgcGFnZXMgdGhhdCBoYXZlIGJlZW4gZmF1bHRlZCBiYWNrIGludG8gdGhl
IGd1ZXN0IHdoZW4gaXQNCj4gYWNjZXNzZWQgdGhlbS4NCj4gDQo+IEkgY2FuIHNlZSB0aGVyZSB3
b3VsZCBiZSBzb21lIGFkdmFudGFnZXMgdG8gQ01NMiwgaG93ZXZlciBpdCBzZWVtcyBsaWtlIGl0
DQo+IGlzIGFkZGluZyBhIHNpZ25pZmljYW50IGFtb3VudCBvZiBzdGF0ZSB0byBwYWdlcyBzaW5j
ZSBpdCBoYXMgdG8gc3VwcG9ydCBhDQo+IGZhaXJseSBzaWduaWZpY2FudCBudW1iZXIgb2Ygc3Rh
dGVzIGFuZCB0aGVuIHRoZXJlIGlzIHRoZSBhZGRlZCBjb21wbGV4aXR5DQo+IGZvciBhbGwgdGhl
IHRyYW5zaXRpb25zIGluIGFuZCBvdXQgb2Ygc3RhYmxlIGZyb20gdGhlIHZhcmlvdXMgc3RhdGVz
DQo+IGRlcGVuZGluZyBvbiBob3cgdGhpbmdzIGFyZSBiZWluZyBjaGFuZ2VkLg0KPiANCj4gRG8g
eW91IGhhcHBlbiB0byBrbm93IGlmIGFueW9uZSBoYXMgZG9uZSBhbnkgcmVzZWFyY2ggaW50byBo
b3cgbXVjaA0KPiBvdmVyaGVhZCBpcyBhZGRlZCB3aXRoIENNTTIgZW5hYmxlZD8gSSdkIGJlIGN1
cmlvdXMgc2luY2UgaXQgc2VlbXMgbGlrZQ0KPiB0aGUgcGFwZXIgbWVudGlvbnMgaGF2aW5nIHRv
IHRyYWNrIGEgc2lnbmZpY2FudCBudW1iZXIgb2Ygc3RhdGUNCj4gdHJhbnNpdGlvbnMgZm9yIHRo
ZSBtZW1vcnkgdGhyb3VnaG91dCB0aGUga2VybmVsLg0KDQpMZXQgbWUgYWRkIENocmlzdGlhbiBC
b3JudHJhZWdlciB0byB0aGUgdGhyZWFkLiBIZSBjYW4gZGVmaW5pdGVseSBoZWxwIG9uIHRoYXQg
c2lkZS4gSSBhc2tlZCBoaW0gZWFybGllciB0b2RheSBhbmQgaGUgY29uZmlybWVkIHRoYXQgY21t
MiBpcyBpbiBhY3RpdmUgdXNlIG9uIHMzOTAuDQoNCkFsZXgNCg0KCgoKQW1hem9uIERldmVsb3Bt
ZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2No
YWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0
cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNp
dHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

