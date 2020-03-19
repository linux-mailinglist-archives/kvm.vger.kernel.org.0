Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3194018ACC8
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgCSGca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:32:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:58758 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgCSGc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:32:29 -0400
IronPort-SDR: WRT2l8f2km0FJ2c4U3P+8FWKB6PkHqELlSXkgkY6geTcMSQcEj5BjJdZeFKHZ4ALV8yBMVitUr
 /0Pu2d5NfYBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:32:28 -0700
IronPort-SDR: yuLWXQ20POQiaxpvj7gRtb757nMFGoTsMxk0Gx/43z3Ps+R3wBac0acsr7KL++97uqWHyjK1gu
 PVxmbO56RSTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="279989133"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 18 Mar 2020 23:32:28 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 23:32:28 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Mar 2020 23:32:27 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Mar 2020 23:32:27 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.50]) with mapi id 14.03.0439.000;
 Thu, 19 Mar 2020 14:32:25 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH v3 0/7] vfio/pci: SR-IOV support
Thread-Topic: [PATCH v3 0/7] vfio/pci: SR-IOV support
Thread-Index: AQHV9/A6HGVyF5dk00ispia0mQepRahPe52A
Date:   Thu, 19 Mar 2020 06:32:25 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7DAFD5@SHSMSX104.ccr.corp.intel.com>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
In-Reply-To: <158396044753.5601.14804870681174789709.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgTWFyY2ggMTIsIDIwMjAgNTo1OCBBTQ0KPiANCj4gT25seSBtaW5vciB0
d2Vha3Mgc2luY2UgdjIsIEdFVCBhbmQgU0VUIG9uIFZGSU9fREVWSUNFX0ZFQVRVUkUgYXJlDQo+
IGVuZm9yY2VkIG11dHVhbGx5IGV4Y2x1c2l2ZSBleGNlcHQgd2l0aCB0aGUgUFJPQkUgb3B0aW9u
IGFzIHN1Z2dlc3RlZA0KPiBieSBDb25uaWUsIHRoZSBtb2RpbmZvIHRleHQgaGFzIGJlZW4gZXhw
YW5kZWQgZm9yIHRoZSBvcHQtaW4gdG8gZW5hYmxlDQo+IFNSLUlPViBzdXBwb3J0IGluIHRoZSB2
ZmlvLXBjaSBkcml2ZXIgcGVyIGRpc2N1c3Npb24gd2l0aCBLZXZpbi4NCj4gDQo+IEkgaGF2ZSBu
b3QgaW5jb3Jwb3JhdGVkIHJ1bnRpbWUgd2FybmluZ3MgYXR0ZW1wdGluZyB0byBkZXRlY3QgbWlz
dXNlDQo+IG9mIFNSLUlPViBvciBpbXBvc2VkIGEgc2Vzc2lvbiBsaWZldGltZSBvZiBhIFZGIHRv
a2VuLCBib3RoIG9mIHdoaWNoDQo+IHdlcmUgc2lnbmlmaWNhbnQgcG9ydGlvbnMgb2YgdGhlIGRp
c2N1c3Npb24gb2YgdGhlIHYyIHNlcmllcy4gIEJvdGggb2YNCj4gdGhlc2UgYWxzbyBzZWVtIHRv
IGltcG9zZSBhIHVzYWdlIG1vZGVsIG9yIG1ha2UgYXNzdW1wdGlvbnMgYWJvdXQgVkYNCj4gcmVz
b3VyY2UgdXNhZ2Ugb3IgY29uZmlndXJhdGlvbiByZXF1aXJlbWVudHMgdGhhdCBkb24ndCBzZWVt
IG5lY2Vzc2FyeQ0KPiBleGNlcHQgZm9yIHRoZSBzYWtlIG9mIGdlbmVyYXRpbmcgYSB3YXJuaW5n
IG9yIHJlcXVpcmluZyBhbiBvdGhlcndpc2UNCj4gdW5uZWNlc3NhcnkgYW5kIGltcGxpY2l0IHRv
a2VuIHJlaW5pdGlhbGl6YXRpb24uICBJZiB0aGVyZSBhcmUgbmV3DQo+IHRob3VnaHRzIGFyb3Vu
ZCB0aGVzZSBvciBvdGhlciBkaXNjdXNzaW9uIHBvaW50cywgcGxlYXNlIHJhaXNlIHRoZW0uDQo+
IA0KPiBTZXJpZXMgb3ZlcnZpZXcgKHNhbWUgYXMgcHJvdmlkZWQgd2l0aCB2MSk6DQo+IA0KPiBU
aGUgc3lub3BzaXMgb2YgdGhpcyBzZXJpZXMgaXMgdGhhdCB3ZSBoYXZlIGFuIG9uZ29pbmcgZGVz
aXJlIHRvIGRyaXZlDQo+IFBDSWUgU1ItSU9WIFBGcyBmcm9tIHVzZXJzcGFjZSB3aXRoIFZGSU8u
ICBUaGVyZSdzIGFuIGltbWVkaWF0ZSBuZWVkDQo+IGZvciB0aGlzIHdpdGggRFBESyBkcml2ZXJz
IGFuZCBwb3RlbnRpYWxseSBpbnRlcmVzdGluZyBmdXR1cmUgdXNlDQo+IGNhc2VzIGluIHZpcnR1
YWxpemF0aW9uLiAgV2UndmUgYmVlbiByZWx1Y3RhbnQgdG8gYWRkIHRoaXMgc3VwcG9ydA0KPiBw
cmV2aW91c2x5IGR1ZSB0byB0aGUgZGVwZW5kZW5jeSBhbmQgdHJ1c3QgcmVsYXRpb25zaGlwIGJl
dHdlZW4gdGhlDQo+IFZGIGRldmljZSBhbmQgUEYgZHJpdmVyLiAgTWluaW1hbGx5IHRoZSBQRiBk
cml2ZXIgY2FuIGluZHVjZSBhIGRlbmlhbA0KPiBvZiBzZXJ2aWNlIHRvIHRoZSBWRiwgYnV0IGRl
cGVuZGluZyBvbiB0aGUgc3BlY2lmaWMgaW1wbGVtZW50YXRpb24sDQo+IHRoZSBQRiBkcml2ZXIg
bWlnaHQgYWxzbyBiZSByZXNwb25zaWJsZSBmb3IgbW92aW5nIGRhdGEgYmV0d2VlbiBWRnMNCj4g
b3IgaGF2ZSBkaXJlY3QgYWNjZXNzIHRvIHRoZSBzdGF0ZSBvZiB0aGUgVkYsIGluY2x1ZGluZyBk
YXRhIG9yIHN0YXRlDQo+IG90aGVyd2lzZSBwcml2YXRlIHRvIHRoZSBWRiBvciBWRiBkcml2ZXIu
DQo+IA0KPiBUbyBoZWxwIHJlc29sdmUgdGhlc2UgY29uY2VybnMsIHdlIGludHJvZHVjZSBhIFZG
IHRva2VuIGludG8gdGhlIFZGSU8NCj4gUENJIEFCSSwgd2hpY2ggYWN0cyBhcyBhIHNoYXJlZCBz
ZWNyZXQga2V5IGJldHdlZW4gZHJpdmVycy4gIFRoZQ0KPiB1c2Vyc3BhY2UgUEYgZHJpdmVyIGlz
IHJlcXVpcmVkIHRvIHNldCB0aGUgVkYgdG9rZW4gdG8gYSBrbm93biB2YWx1ZQ0KPiBhbmQgdXNl
cnNwYWNlIFZGIGRyaXZlcnMgYXJlIHJlcXVpcmVkIHRvIHByb3ZpZGUgdGhlIHRva2VuIHRvIGFj
Y2Vzcw0KPiB0aGUgVkYgZGV2aWNlLiAgSWYgYSBQRiBkcml2ZXIgaXMgcmVzdGFydGVkIHdpdGgg
VkYgZHJpdmVycyBpbiB1c2UsIGl0DQo+IG11c3QgYWxzbyBwcm92aWRlIHRoZSBjdXJyZW50IHRv
a2VuIGluIG9yZGVyIHRvIHByZXZlbnQgYSByb2d1ZQ0KPiB1bnRydXN0ZWQgUEYgZHJpdmVyIGZy
b20gcmVwbGFjaW5nIGEga25vd24gZHJpdmVyLiAgVGhlIGRlZ3JlZSB0bw0KPiB3aGljaCB0aGlz
IG5ldyB0b2tlbiBpcyBjb25zaWRlcmVkIHNlY3JldCBpcyBsZWZ0IHRvIHRoZSB1c2Vyc3BhY2UN
Cj4gZHJpdmVycywgdGhlIGtlcm5lbCBpbnRlbnRpb25hbGx5IHByb3ZpZGVzIG5vIG1lYW5zIHRv
IHJldHJpZXZlIHRoZQ0KPiBjdXJyZW50IHRva2VuLg0KPiANCj4gTm90ZSB0aGF0IHRoZSBhYm92
ZSB0b2tlbiBpcyBvbmx5IHJlcXVpcmVkIGZvciB0aGlzIG5ldyBtb2RlbCB3aGVyZQ0KPiBib3Ro
IHRoZSBQRiBhbmQgVkYgZGV2aWNlcyBhcmUgdXNhYmxlIHRocm91Z2ggdmZpby1wY2kuICBFeGlz
dGluZw0KPiBtb2RlbHMgb2YgVkZJTyBkcml2ZXJzIHdoZXJlIHRoZSBQRiBpcyB1c2VkIHdpdGhv
dXQgU1ItSU9WIGVuYWJsZWQNCj4gb3IgdGhlIFZGIGlzIGJvdW5kIHRvIGEgdXNlcnNwYWNlIGRy
aXZlciB3aXRoIGFuIGluLWtlcm5lbCwgaG9zdCBQRg0KPiBkcml2ZXIgYXJlIHVuYWZmZWN0ZWQu
DQo+IA0KPiBUaGUgbGF0dGVyIGNvbmZpZ3VyYXRpb24gYWJvdmUgYWxzbyBoaWdobGlnaHRzIGEg
bmV3IGludmVydGVkIHNjZW5hcmlvDQo+IHRoYXQgaXMgbm93IHBvc3NpYmxlLCBhIHVzZXJzcGFj
ZSBQRiBkcml2ZXIgd2l0aCBpbi1rZXJuZWwgVkYgZHJpdmVycy4NCj4gSSBiZWxpZXZlIHRoaXMg
aXMgYSBzY2VuYXJpbyB0aGF0IHNob3VsZCBiZSBhbGxvd2VkLCBidXQgc2hvdWxkIG5vdCBiZQ0K
PiBlbmFibGVkIGJ5IGRlZmF1bHQuICBUaGlzIHNlcmllcyBpbmNsdWRlcyBjb2RlIHRvIHNldCBh
IGRlZmF1bHQNCj4gZHJpdmVyX292ZXJyaWRlIGZvciBWRnMgc291cmNlZCBmcm9tIGEgdmZpby1w
Y2kgdXNlciBvd25lZCBQRiwgc3VjaA0KPiB0aGF0IHRoZSBWRnMgYXJlIGFsc28gYm91bmQgdG8g
dmZpby1wY2kuICBUaGlzIG1vZGVsIGlzIGNvbXBhdGlibGUNCj4gd2l0aCB0b29scyBsaWtlIGRy
aXZlcmN0bCBhbmQgYWxsb3dzIHRoZSBzeXN0ZW0gYWRtaW5pc3RyYXRvciB0bw0KPiBkZWNpZGUg
aWYgb3RoZXIgYmluZGluZ3Mgc2hvdWxkIGJlIGVuYWJsZWQuICBUaGUgVkYgdG9rZW4gaW50ZXJm
YWNlDQo+IGFib3ZlIGV4aXN0cyBvbmx5IGJldHdlZW4gdmZpby1wY2kgUEYgYW5kIFZGIGRyaXZl
cnMsIG9uY2UgYSBWRiBpcw0KPiBib3VuZCB0byBhbm90aGVyIGRyaXZlciwgdGhlIGFkbWluaXN0
cmF0b3IgaGFzIGVmZmVjdGl2ZWx5IHByb25vdW5jZWQNCj4gdGhlIGRldmljZSBhcyB0cnVzdGVk
LiAgVGhlIHZmaW8tcGNpIGRyaXZlciB3aWxsIG5vdGUgYWx0ZXJuYXRlDQo+IGJpbmRpbmcgaW4g
ZG1lc2cgZm9yIGxvZ2dpbmcgYW5kIGRlYnVnZ2luZyBwdXJwb3Nlcy4NCj4gDQo+IFBsZWFzZSBy
ZXZpZXcsIGNvbW1lbnQsIGFuZCB0ZXN0LiAgVGhlIGV4YW1wbGUgUUVNVSBpbXBsZW1lbnRhdGlv
bg0KPiBwcm92aWRlZCB3aXRoIHRoZSBSRkMgaXMgc3RpbGwgY3VycmVudCBmb3IgdGhpcyB2ZXJz
aW9uLiAgVGhhbmtzLA0KPiANCj4gQWxleA0KDQpUaGUgd2hvbGUgc2VyaWVzIGxvb2tzIGdvb2Qg
dG8gbWU6DQoJUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0K
DQphbmQgY29uZmlybSBvbmUgdW5kZXJzdGFuZGluZyBoZXJlLCBzaW5jZSBpdCBpcyBub3QgZGlz
Y3Vzc2VkIGFueXdoZXJlLiBGb3INClZNIGxpdmUgbWlncmF0aW9uIHdpdGggYXNzaWduZWQgVkYg
ZGV2aWNlLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRvIG1pZ3JhdGUgdGhlDQpWRiB0b2tlbiBpdHNl
bGYgYW5kIGFjdHVhbGx5IHdlIGRvbid0IGFsbG93IHVzZXJzcGFjZSB0byByZXRyaWV2ZSBpdC4g
SW5zdGVhZCwNClFlbXUganVzdCBmb2xsb3dzIHdoYXRldmVyIHRva2VuIHJlcXVpcmVtZW50IG9u
IHRoZSBkZXN0IHRvIG9wZW4gdGhlIG5ldw0KVkY6IGNvdWxkIGJlIHNhbWUgb3IgZGlmZmVyZW50
IHRva2VuIGFzL2Zyb20gc3JjLCBvciBldmVuIG5vIHRva2VuIGlmIFBGDQpkcml2ZXIgcnVucyBp
biBrZXJuZWwgb24gZGVzdC4gSSBzdXBwb3NlIGVpdGhlciBjb21iaW5hdGlvbiBjb3VsZCB3b3Jr
LCBjb3JyZWN0Pw0KDQpUaGFua3MNCktldmluDQoNCj4gDQo+IFJGQzoNCj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGttbC8xNTgwODUzMzc1ODIuOTQ0NS4xNzY4MjI2NjQzNzU4MzUwNTUwMi5z
dGcNCj4gaXRAZ2ltbGkuaG9tZS8NCj4gdjE6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xr
bWwvMTU4MTQ1NDcyNjA0LjE2ODI3LjE1NzUxMzc1NTQwMTAyMjk4MTMwLnN0DQo+IGdpdEBnaW1s
aS5ob21lLw0KPiB2MjoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8xNTgyMTM3MTY5
NTkuMTcwOTAuODM5OTQyNzAxNzQwMzUwNzExNC5zdGcNCj4gaXRAZ2ltbGkuaG9tZS8NCj4gDQo+
IC0tLQ0KPiANCj4gQWxleCBXaWxsaWFtc29uICg3KToNCj4gICAgICAgdmZpbzogSW5jbHVkZSBv
cHRpb25hbCBkZXZpY2UgbWF0Y2ggaW4gdmZpb19kZXZpY2Vfb3BzIGNhbGxiYWNrcw0KPiAgICAg
ICB2ZmlvL3BjaTogSW1wbGVtZW50IG1hdGNoIG9wcw0KPiAgICAgICB2ZmlvL3BjaTogSW50cm9k
dWNlIFZGIHRva2VuDQo+ICAgICAgIHZmaW86IEludHJvZHVjZSBWRklPX0RFVklDRV9GRUFUVVJF
IGlvY3RsIGFuZCBmaXJzdCB1c2VyDQo+ICAgICAgIHZmaW8vcGNpOiBBZGQgc3Jpb3ZfY29uZmln
dXJlIHN1cHBvcnQNCj4gICAgICAgdmZpby9wY2k6IFJlbW92ZSBkZXZfZm10IGRlZmluaXRpb24N
Cj4gICAgICAgdmZpby9wY2k6IENsZWFudXAgLnByb2JlKCkgZXhpdCBwYXRocw0KPiANCj4gDQo+
ICBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpLmMgICAgICAgICB8ICAzOTANCj4gKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lf
cHJpdmF0ZS5oIHwgICAxMCArDQo+ICBkcml2ZXJzL3ZmaW8vdmZpby5jICAgICAgICAgICAgICAg
ICB8ICAgMjAgKy0NCj4gIGluY2x1ZGUvbGludXgvdmZpby5oICAgICAgICAgICAgICAgIHwgICAg
NA0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaCAgICAgICAgICAgfCAgIDM3ICsrKw0KPiAg
NSBmaWxlcyBjaGFuZ2VkLCA0MzMgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pDQoNCg==
