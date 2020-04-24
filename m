Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5B31B715F
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXJ7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 05:59:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:1221 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgDXJ7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 05:59:55 -0400
IronPort-SDR: +3tZVSRdmVozjLbRPgYL2B+olEFHIU5cVbrvVgo/hEWMP61+SfuTxdsZcir23sJUSkqdMkDFQm
 4yl32lTUlRMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 02:59:54 -0700
IronPort-SDR: zbCgPVgd6bUFfC1ZQQc3Z4DnD7gAW1COIEKsXOJYrAr7wJZbdYJvT1RMnwAcX3TRp7WinS86hP
 3rqRCWGRZkCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="292590197"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga008.jf.intel.com with ESMTP; 24 Apr 2020 02:59:53 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 02:59:28 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Fri, 24 Apr 2020 17:59:27 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
        Uwe Dannowski <uwed@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>
Subject: RE: [PATCH v1 00/15] Add support for Nitro Enclaves
Thread-Topic: [PATCH v1 00/15] Add support for Nitro Enclaves
Thread-Index: AQHWGAygRGZTuzjMtk+n6BailK3c0KiDlneAgAKW/gCAAd3gMA==
Date:   Fri, 24 Apr 2020 09:59:25 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D89F71D@SHSMSX104.ccr.corp.intel.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
In-Reply-To: <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
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

PiBGcm9tOiBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hDQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAy
MywgMjAyMCA5OjIwIFBNDQo+IA0KPiBPbiAyMi8wNC8yMDIwIDAwOjQ2LCBQYW9sbyBCb256aW5p
IHdyb3RlOg0KPiA+IE9uIDIxLzA0LzIwIDIwOjQxLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6DQo+
ID4+IEFuIGVuY2xhdmUgY29tbXVuaWNhdGVzIHdpdGggdGhlIHByaW1hcnkgVk0gdmlhIGEgbG9j
YWwgY29tbXVuaWNhdGlvbg0KPiBjaGFubmVsLA0KPiA+PiB1c2luZyB2aXJ0aW8tdnNvY2sgWzJd
LiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgYSBkaXNrIG9yIGEgbmV0d29yayBkZXZpY2UNCj4g
Pj4gYXR0YWNoZWQuDQo+ID4gSXMgaXQgcG9zc2libGUgdG8gaGF2ZSBhIHNhbXBsZSBvZiB0aGlz
IGluIHRoZSBzYW1wbGVzLyBkaXJlY3Rvcnk/DQo+IA0KPiBJIGNhbiBhZGQgaW4gdjIgYSBzYW1w
bGUgZmlsZSBpbmNsdWRpbmcgdGhlIGJhc2ljIGZsb3cgb2YgaG93IHRvIHVzZSB0aGUNCj4gaW9j
dGwgaW50ZXJmYWNlIHRvIGNyZWF0ZSAvIHRlcm1pbmF0ZSBhbiBlbmNsYXZlLg0KPiANCj4gVGhl
biB3ZSBjYW4gdXBkYXRlIC8gYnVpbGQgb24gdG9wIGl0IGJhc2VkIG9uIHRoZSBvbmdvaW5nIGRp
c2N1c3Npb25zIG9uDQo+IHRoZSBwYXRjaCBzZXJpZXMgYW5kIHRoZSByZWNlaXZlZCBmZWVkYmFj
ay4NCj4gDQo+ID4NCj4gPiBJIGFtIGludGVyZXN0ZWQgZXNwZWNpYWxseSBpbjoNCj4gPg0KPiA+
IC0gdGhlIGluaXRpYWwgQ1BVIHN0YXRlOiBDUEwwIHZzLiBDUEwzLCBpbml0aWFsIHByb2dyYW0g
Y291bnRlciwgZXRjLg0KPiA+DQo+ID4gLSB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsOyBkb2Vz
IHRoZSBlbmNsYXZlIHNlZSB0aGUgdXN1YWwgbG9jYWwgQVBJQw0KPiA+IGFuZCBJT0FQSUMgaW50
ZXJmYWNlcyBpbiBvcmRlciB0byBnZXQgaW50ZXJydXB0cyBmcm9tIHZpcnRpby12c29jaywgYW5k
DQo+ID4gd2hlcmUgaXMgdGhlIHZpcnRpby12c29jayBkZXZpY2UgKHZpcnRpby1tbWlvIEkgc3Vw
cG9zZSkgcGxhY2VkIGluIG1lbW9yeT8NCj4gPg0KPiA+IC0gd2hhdCB0aGUgZW5jbGF2ZSBpcyBh
bGxvd2VkIHRvIGRvOiBjYW4gaXQgY2hhbmdlIHByaXZpbGVnZSBsZXZlbHMsDQo+ID4gd2hhdCBo
YXBwZW5zIGlmIHRoZSBlbmNsYXZlIHBlcmZvcm1zIGFuIGFjY2VzcyB0byBub25leGlzdGVudCBt
ZW1vcnksDQo+IGV0Yy4NCj4gPg0KPiA+IC0gd2hldGhlciB0aGVyZSBhcmUgc3BlY2lhbCBoeXBl
cmNhbGwgaW50ZXJmYWNlcyBmb3IgdGhlIGVuY2xhdmUNCj4gDQo+IEFuIGVuY2xhdmUgaXMgYSBW
TSwgcnVubmluZyBvbiB0aGUgc2FtZSBob3N0IGFzIHRoZSBwcmltYXJ5IFZNLCB0aGF0DQo+IGxh
dW5jaGVkIHRoZSBlbmNsYXZlLiBUaGV5IGFyZSBzaWJsaW5ncy4NCj4gDQo+IEhlcmUgd2UgbmVl
ZCB0byB0aGluayBvZiB0d28gY29tcG9uZW50czoNCj4gDQo+IDEuIEFuIGVuY2xhdmUgYWJzdHJh
Y3Rpb24gcHJvY2VzcyAtIGEgcHJvY2VzcyBydW5uaW5nIGluIHRoZSBwcmltYXJ5IFZNDQo+IGd1
ZXN0LCB0aGF0IHVzZXMgdGhlIHByb3ZpZGVkIGlvY3RsIGludGVyZmFjZSBvZiB0aGUgTml0cm8g
RW5jbGF2ZXMNCj4ga2VybmVsIGRyaXZlciB0byBzcGF3biBhbiBlbmNsYXZlIFZNICh0aGF0J3Mg
MiBiZWxvdykuDQo+IA0KPiBIb3cgZG9lcyBhbGwgZ2V0cyB0byBhbiBlbmNsYXZlIFZNIHJ1bm5p
bmcgb24gdGhlIGhvc3Q/DQo+IA0KPiBUaGVyZSBpcyBhIE5pdHJvIEVuY2xhdmVzIGVtdWxhdGVk
IFBDSSBkZXZpY2UgZXhwb3NlZCB0byB0aGUgcHJpbWFyeSBWTS4NCj4gVGhlIGRyaXZlciBmb3Ig
dGhpcyBuZXcgUENJIGRldmljZSBpcyBpbmNsdWRlZCBpbiB0aGUgY3VycmVudCBwYXRjaCBzZXJp
ZXMuDQo+IA0KPiBUaGUgaW9jdGwgbG9naWMgaXMgbWFwcGVkIHRvIFBDSSBkZXZpY2UgY29tbWFu
ZHMgZS5nLiB0aGUNCj4gTkVfRU5DTEFWRV9TVEFSVCBpb2N0bCBtYXBzIHRvIGFuIGVuY2xhdmUg
c3RhcnQgUENJIGNvbW1hbmQgb3IgdGhlDQo+IEtWTV9TRVRfVVNFUl9NRU1PUllfUkVHSU9OIG1h
cHMgdG8gYW4gYWRkIG1lbW9yeSBQQ0kgY29tbWFuZC4NCj4gVGhlIFBDSQ0KPiBkZXZpY2UgY29t
bWFuZHMgYXJlIHRoZW4gdHJhbnNsYXRlZCBpbnRvIGFjdGlvbnMgdGFrZW4gb24gdGhlIGh5cGVy
dmlzb3INCj4gc2lkZTsgdGhhdCdzIHRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhl
IGhvc3Qgd2hlcmUgdGhlIHByaW1hcnkNCj4gVk0gaXMgcnVubmluZy4NCj4gDQo+IDIuIFRoZSBl
bmNsYXZlIGl0c2VsZiAtIGEgVk0gcnVubmluZyBvbiB0aGUgc2FtZSBob3N0IGFzIHRoZSBwcmlt
YXJ5IFZNDQo+IHRoYXQgc3Bhd25lZCBpdC4NCj4gDQo+IFRoZSBlbmNsYXZlIFZNIGhhcyBubyBw
ZXJzaXN0ZW50IHN0b3JhZ2Ugb3IgbmV0d29yayBpbnRlcmZhY2UgYXR0YWNoZWQsDQo+IGl0IHVz
ZXMgaXRzIG93biBtZW1vcnkgYW5kIENQVXMgKyBpdHMgdmlydGlvLXZzb2NrIGVtdWxhdGVkIGRl
dmljZSBmb3INCj4gY29tbXVuaWNhdGlvbiB3aXRoIHRoZSBwcmltYXJ5IFZNLg0KDQpzb3VuZHMg
bGlrZSBhIGZpcmVjcmFja2VyIFZNPw0KDQo+IA0KPiBUaGUgbWVtb3J5IGFuZCBDUFVzIGFyZSBj
YXJ2ZWQgb3V0IG9mIHRoZSBwcmltYXJ5IFZNLCB0aGV5IGFyZSBkZWRpY2F0ZWQNCj4gZm9yIHRo
ZSBlbmNsYXZlLiBUaGUgTml0cm8gaHlwZXJ2aXNvciBydW5uaW5nIG9uIHRoZSBob3N0IGVuc3Vy
ZXMgbWVtb3J5DQo+IGFuZCBDUFUgaXNvbGF0aW9uIGJldHdlZW4gdGhlIHByaW1hcnkgVk0gYW5k
IHRoZSBlbmNsYXZlIFZNLg0KDQpJbiBsYXN0IHBhcmFncmFwaCwgeW91IHNhaWQgdGhhdCB0aGUg
ZW5jbGF2ZSBWTSB1c2VzIGl0cyBvd24gbWVtb3J5IGFuZA0KQ1BVcy4gVGhlbiBoZXJlLCB5b3Ug
c2FpZCB0aGUgbWVtb3J5L0NQVXMgYXJlIGNhcnZlZCBvdXQgYW5kIGRlZGljYXRlZA0KZnJvbSB0
aGUgcHJpbWFyeSBWTS4gQ2FuIHlvdSBlbGFib3JhdGUgd2hpY2ggb25lIGlzIGFjY3VyYXRlPyBv
ciBhIG1peGVkDQptb2RlbD8NCg0KPiANCj4gDQo+IFRoZXNlIHR3byBjb21wb25lbnRzIG5lZWQg
dG8gcmVmbGVjdCB0aGUgc2FtZSBzdGF0ZSBlLmcuIHdoZW4gdGhlDQo+IGVuY2xhdmUgYWJzdHJh
Y3Rpb24gcHJvY2VzcyAoMSkgaXMgdGVybWluYXRlZCwgdGhlIGVuY2xhdmUgVk0gKDIpIGlzDQo+
IHRlcm1pbmF0ZWQgYXMgd2VsbC4NCj4gDQo+IFdpdGggcmVnYXJkIHRvIHRoZSBjb21tdW5pY2F0
aW9uIGNoYW5uZWwsIHRoZSBwcmltYXJ5IFZNIGhhcyBpdHMgb3duDQo+IGVtdWxhdGVkIHZpcnRp
by12c29jayBQQ0kgZGV2aWNlLiBUaGUgZW5jbGF2ZSBWTSBoYXMgaXRzIG93biBlbXVsYXRlZA0K
PiB2aXJ0aW8tdnNvY2sgZGV2aWNlIGFzIHdlbGwuIFRoaXMgY2hhbm5lbCBpcyB1c2VkLCBmb3Ig
ZXhhbXBsZSwgdG8gZmV0Y2gNCj4gZGF0YSBpbiB0aGUgZW5jbGF2ZSBhbmQgdGhlbiBwcm9jZXNz
IGl0LiBBbiBhcHBsaWNhdGlvbiB0aGF0IHNldHMgdXAgdGhlDQo+IHZzb2NrIHNvY2tldCBhbmQg
Y29ubmVjdHMgb3IgbGlzdGVucywgZGVwZW5kaW5nIG9uIHRoZSB1c2UgY2FzZSwgaXMgdGhlbg0K
PiBkZXZlbG9wZWQgdG8gdXNlIHRoaXMgY2hhbm5lbDsgdGhpcyBoYXBwZW5zIG9uIGJvdGggZW5k
cyAtIHByaW1hcnkgVk0NCj4gYW5kIGVuY2xhdmUgVk0uDQoNCkhvdyBkb2VzIHRoZSBhcHBsaWNh
dGlvbiBpbiB0aGUgcHJpbWFyeSBWTSBhc3NpZ24gdGFzayB0byBiZSBleGVjdXRlZA0KaW4gdGhl
IGVuY2xhdmUgVk0/IEkgZGlkbid0IHNlZSBzdWNoIGNvbW1hbmQgaW4gdGhpcyBzZXJpZXMsIHNv
IHN1cHBvc2UNCml0IGlzIGFsc28gY29tbXVuaWNhdGVkIHRocm91Z2ggdmlydGlvLXZzb2NrPyAN
Cg0KPiANCj4gTGV0IG1lIGtub3cgaWYgZnVydGhlciBjbGFyaWZpY2F0aW9ucyBhcmUgbmVlZGVk
Lg0KPiANCj4gPg0KPiA+PiBUaGUgcHJvcG9zZWQgc29sdXRpb24gaXMgZm9sbG93aW5nIHRoZSBL
Vk0gbW9kZWwgYW5kIHVzZXMgdGhlIEtWTSBBUEkNCj4gdG8gYmUgYWJsZQ0KPiA+PiB0byBjcmVh
dGUgYW5kIHNldCByZXNvdXJjZXMgZm9yIGVuY2xhdmVzLiBBbiBhZGRpdGlvbmFsIGlvY3RsIGNv
bW1hbmQsDQo+IGJlc2lkZXMNCj4gPj4gdGhlIG9uZXMgcHJvdmlkZWQgYnkgS1ZNLCBpcyB1c2Vk
IHRvIHN0YXJ0IGFuIGVuY2xhdmUgYW5kIHNldHVwIHRoZQ0KPiBhZGRyZXNzaW5nDQo+ID4+IGZv
ciB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsIGFuZCBhbiBlbmNsYXZlIHVuaXF1ZSBpZC4NCj4g
PiBSZXVzaW5nIHNvbWUgS1ZNIGlvY3RscyBpcyBkZWZpbml0ZWx5IGEgZ29vZCBpZGVhLCBidXQg
SSB3b3VsZG4ndCByZWFsbHkNCj4gPiBzYXkgaXQncyB0aGUgS1ZNIEFQSSBzaW5jZSB0aGUgVkNQ
VSBmaWxlIGRlc2NyaXB0b3IgaXMgYmFzaWNhbGx5IG5vbg0KPiA+IGZ1bmN0aW9uYWwgKHdpdGhv
dXQgS1ZNX1JVTiBhbmQgbW1hcCBpdCdzIG5vdCByZWFsbHkgdGhlIEtWTSBBUEkpLg0KPiANCj4g
SXQgdXNlcyBwYXJ0IG9mIHRoZSBLVk0gQVBJIG9yIGEgc2V0IG9mIEtWTSBpb2N0bHMgdG8gbW9k
ZWwgdGhlIHdheSBhIFZNDQo+IGlzIGNyZWF0ZWQgLyB0ZXJtaW5hdGVkLiBUaGF0J3MgdHJ1ZSwg
S1ZNX1JVTiBhbmQgbW1hcC1pbmcgdGhlIHZjcHUgZmQNCj4gYXJlIG5vdCBpbmNsdWRlZC4NCj4g
DQo+IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrIHJlZ2FyZGluZyB0aGUgcmV1c2Ugb2YgS1ZNIGlv
Y3Rscy4NCj4gDQo+IEFuZHJhDQo+IA0KDQpUaGFua3MNCktldmluDQo=
