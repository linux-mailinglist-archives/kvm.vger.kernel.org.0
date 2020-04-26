Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296381B8DD1
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 10:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgDZIQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 04:16:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:39730 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgDZIQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 04:16:43 -0400
IronPort-SDR: xo30K5K0wQOXB/mRZ/2mPdiuU2SZ5AHQlx9w9+Jb/KiyacVxNzw8uL0meVpaINdAwIxCJ2CfOj
 WM2ejij2IKkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 01:16:40 -0700
IronPort-SDR: p83U9ssj9aunuZVuO6OE4t01tYTlkHejusiWlm1uzuHlRZ/fX+YrEyITDKN138gU4DKRBnAkJP
 r9TSk9FRYXRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,319,1583222400"; 
   d="scan'208";a="458464812"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga006.fm.intel.com with ESMTP; 26 Apr 2020 01:16:40 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 26 Apr 2020 01:16:40 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 26 Apr 2020 01:16:39 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Sun, 26 Apr 2020 16:16:37 +0800
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
Thread-Index: AQHWGAygRGZTuzjMtk+n6BailK3c0KiDlneAgAKW/gCAAd3gMP//v46AgANJXHA=
Date:   Sun, 26 Apr 2020 08:16:36 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8CA449@SHSMSX104.ccr.corp.intel.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D89F71D@SHSMSX104.ccr.corp.intel.com>
 <b5b14703-1c8c-0a34-f08b-9032a0d97b1d@amazon.com>
In-Reply-To: <b5b14703-1c8c-0a34-f08b-9032a0d97b1d@amazon.com>
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

PiBGcm9tOiBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIDxhbmRyYXByc0BhbWF6b24uY29tPg0KPiBT
ZW50OiBGcmlkYXksIEFwcmlsIDI0LCAyMDIwIDk6NTkgUE0NCj4gDQo+IA0KPiBPbiAyNC8wNC8y
MDIwIDEyOjU5LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBQYXJhc2NoaXYs
IEFuZHJhLUlyaW5hDQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAyMywgMjAyMCA5OjIwIFBN
DQo+ID4+DQo+ID4+IE9uIDIyLzA0LzIwMjAgMDA6NDYsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+
ID4+PiBPbiAyMS8wNC8yMCAyMDo0MSwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOg0KPiA+Pj4+IEFu
IGVuY2xhdmUgY29tbXVuaWNhdGVzIHdpdGggdGhlIHByaW1hcnkgVk0gdmlhIGEgbG9jYWwNCj4g
Y29tbXVuaWNhdGlvbg0KPiA+PiBjaGFubmVsLA0KPiA+Pj4+IHVzaW5nIHZpcnRpby12c29jayBb
Ml0uIEFuIGVuY2xhdmUgZG9lcyBub3QgaGF2ZSBhIGRpc2sgb3IgYSBuZXR3b3JrDQo+IGRldmlj
ZQ0KPiA+Pj4+IGF0dGFjaGVkLg0KPiA+Pj4gSXMgaXQgcG9zc2libGUgdG8gaGF2ZSBhIHNhbXBs
ZSBvZiB0aGlzIGluIHRoZSBzYW1wbGVzLyBkaXJlY3Rvcnk/DQo+ID4+IEkgY2FuIGFkZCBpbiB2
MiBhIHNhbXBsZSBmaWxlIGluY2x1ZGluZyB0aGUgYmFzaWMgZmxvdyBvZiBob3cgdG8gdXNlIHRo
ZQ0KPiA+PiBpb2N0bCBpbnRlcmZhY2UgdG8gY3JlYXRlIC8gdGVybWluYXRlIGFuIGVuY2xhdmUu
DQo+ID4+DQo+ID4+IFRoZW4gd2UgY2FuIHVwZGF0ZSAvIGJ1aWxkIG9uIHRvcCBpdCBiYXNlZCBv
biB0aGUgb25nb2luZyBkaXNjdXNzaW9ucyBvbg0KPiA+PiB0aGUgcGF0Y2ggc2VyaWVzIGFuZCB0
aGUgcmVjZWl2ZWQgZmVlZGJhY2suDQo+ID4+DQo+ID4+PiBJIGFtIGludGVyZXN0ZWQgZXNwZWNp
YWxseSBpbjoNCj4gPj4+DQo+ID4+PiAtIHRoZSBpbml0aWFsIENQVSBzdGF0ZTogQ1BMMCB2cy4g
Q1BMMywgaW5pdGlhbCBwcm9ncmFtIGNvdW50ZXIsIGV0Yy4NCj4gPj4+DQo+ID4+PiAtIHRoZSBj
b21tdW5pY2F0aW9uIGNoYW5uZWw7IGRvZXMgdGhlIGVuY2xhdmUgc2VlIHRoZSB1c3VhbCBsb2Nh
bCBBUElDDQo+ID4+PiBhbmQgSU9BUElDIGludGVyZmFjZXMgaW4gb3JkZXIgdG8gZ2V0IGludGVy
cnVwdHMgZnJvbSB2aXJ0aW8tdnNvY2ssIGFuZA0KPiA+Pj4gd2hlcmUgaXMgdGhlIHZpcnRpby12
c29jayBkZXZpY2UgKHZpcnRpby1tbWlvIEkgc3VwcG9zZSkgcGxhY2VkIGluDQo+IG1lbW9yeT8N
Cj4gPj4+DQo+ID4+PiAtIHdoYXQgdGhlIGVuY2xhdmUgaXMgYWxsb3dlZCB0byBkbzogY2FuIGl0
IGNoYW5nZSBwcml2aWxlZ2UgbGV2ZWxzLA0KPiA+Pj4gd2hhdCBoYXBwZW5zIGlmIHRoZSBlbmNs
YXZlIHBlcmZvcm1zIGFuIGFjY2VzcyB0byBub25leGlzdGVudCBtZW1vcnksDQo+ID4+IGV0Yy4N
Cj4gPj4+IC0gd2hldGhlciB0aGVyZSBhcmUgc3BlY2lhbCBoeXBlcmNhbGwgaW50ZXJmYWNlcyBm
b3IgdGhlIGVuY2xhdmUNCj4gPj4gQW4gZW5jbGF2ZSBpcyBhIFZNLCBydW5uaW5nIG9uIHRoZSBz
YW1lIGhvc3QgYXMgdGhlIHByaW1hcnkgVk0sIHRoYXQNCj4gPj4gbGF1bmNoZWQgdGhlIGVuY2xh
dmUuIFRoZXkgYXJlIHNpYmxpbmdzLg0KPiA+Pg0KPiA+PiBIZXJlIHdlIG5lZWQgdG8gdGhpbmsg
b2YgdHdvIGNvbXBvbmVudHM6DQo+ID4+DQo+ID4+IDEuIEFuIGVuY2xhdmUgYWJzdHJhY3Rpb24g
cHJvY2VzcyAtIGEgcHJvY2VzcyBydW5uaW5nIGluIHRoZSBwcmltYXJ5IFZNDQo+ID4+IGd1ZXN0
LCB0aGF0IHVzZXMgdGhlIHByb3ZpZGVkIGlvY3RsIGludGVyZmFjZSBvZiB0aGUgTml0cm8gRW5j
bGF2ZXMNCj4gPj4ga2VybmVsIGRyaXZlciB0byBzcGF3biBhbiBlbmNsYXZlIFZNICh0aGF0J3Mg
MiBiZWxvdykuDQo+ID4+DQo+ID4+IEhvdyBkb2VzIGFsbCBnZXRzIHRvIGFuIGVuY2xhdmUgVk0g
cnVubmluZyBvbiB0aGUgaG9zdD8NCj4gPj4NCj4gPj4gVGhlcmUgaXMgYSBOaXRybyBFbmNsYXZl
cyBlbXVsYXRlZCBQQ0kgZGV2aWNlIGV4cG9zZWQgdG8gdGhlIHByaW1hcnkgVk0uDQo+ID4+IFRo
ZSBkcml2ZXIgZm9yIHRoaXMgbmV3IFBDSSBkZXZpY2UgaXMgaW5jbHVkZWQgaW4gdGhlIGN1cnJl
bnQgcGF0Y2ggc2VyaWVzLg0KPiA+Pg0KPiA+PiBUaGUgaW9jdGwgbG9naWMgaXMgbWFwcGVkIHRv
IFBDSSBkZXZpY2UgY29tbWFuZHMgZS5nLiB0aGUNCj4gPj4gTkVfRU5DTEFWRV9TVEFSVCBpb2N0
bCBtYXBzIHRvIGFuIGVuY2xhdmUgc3RhcnQgUENJIGNvbW1hbmQgb3IgdGhlDQo+ID4+IEtWTV9T
RVRfVVNFUl9NRU1PUllfUkVHSU9OIG1hcHMgdG8gYW4gYWRkIG1lbW9yeSBQQ0kNCj4gY29tbWFu
ZC4NCj4gPj4gVGhlIFBDSQ0KPiA+PiBkZXZpY2UgY29tbWFuZHMgYXJlIHRoZW4gdHJhbnNsYXRl
ZCBpbnRvIGFjdGlvbnMgdGFrZW4gb24gdGhlIGh5cGVydmlzb3INCj4gPj4gc2lkZTsgdGhhdCdz
IHRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3Qgd2hlcmUgdGhlIHByaW1h
cnkNCj4gPj4gVk0gaXMgcnVubmluZy4NCj4gPj4NCj4gPj4gMi4gVGhlIGVuY2xhdmUgaXRzZWxm
IC0gYSBWTSBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMgdGhlIHByaW1hcnkgVk0NCj4gPj4g
dGhhdCBzcGF3bmVkIGl0Lg0KPiA+Pg0KPiA+PiBUaGUgZW5jbGF2ZSBWTSBoYXMgbm8gcGVyc2lz
dGVudCBzdG9yYWdlIG9yIG5ldHdvcmsgaW50ZXJmYWNlIGF0dGFjaGVkLA0KPiA+PiBpdCB1c2Vz
IGl0cyBvd24gbWVtb3J5IGFuZCBDUFVzICsgaXRzIHZpcnRpby12c29jayBlbXVsYXRlZCBkZXZp
Y2UgZm9yDQo+ID4+IGNvbW11bmljYXRpb24gd2l0aCB0aGUgcHJpbWFyeSBWTS4NCj4gPiBzb3Vu
ZHMgbGlrZSBhIGZpcmVjcmFja2VyIFZNPw0KPiANCj4gSXQncyBhIFZNIGNyYWZ0ZWQgZm9yIGVu
Y2xhdmUgbmVlZHMuDQo+IA0KPiA+DQo+ID4+IFRoZSBtZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZl
ZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0sIHRoZXkgYXJlDQo+IGRlZGljYXRlZA0KPiA+PiBmb3Ig
dGhlIGVuY2xhdmUuIFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZW5z
dXJlcyBtZW1vcnkNCj4gPj4gYW5kIENQVSBpc29sYXRpb24gYmV0d2VlbiB0aGUgcHJpbWFyeSBW
TSBhbmQgdGhlIGVuY2xhdmUgVk0uDQo+ID4gSW4gbGFzdCBwYXJhZ3JhcGgsIHlvdSBzYWlkIHRo
YXQgdGhlIGVuY2xhdmUgVk0gdXNlcyBpdHMgb3duIG1lbW9yeSBhbmQNCj4gPiBDUFVzLiBUaGVu
IGhlcmUsIHlvdSBzYWlkIHRoZSBtZW1vcnkvQ1BVcyBhcmUgY2FydmVkIG91dCBhbmQgZGVkaWNh
dGVkDQo+ID4gZnJvbSB0aGUgcHJpbWFyeSBWTS4gQ2FuIHlvdSBlbGFib3JhdGUgd2hpY2ggb25l
IGlzIGFjY3VyYXRlPyBvciBhIG1peGVkDQo+ID4gbW9kZWw/DQo+IA0KPiBNZW1vcnkgYW5kIENQ
VXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0gYW5kIGFyZSBkZWRpY2F0ZWQgZm9y
DQo+IHRoZSBlbmNsYXZlIFZNLiBJIG1lbnRpb25lZCBhYm92ZSBhcyAiaXRzIG93biIgaW4gdGhl
IHNlbnNlIHRoYXQgdGhlDQo+IHByaW1hcnkgVk0gZG9lc24ndCB1c2UgdGhlc2UgY2FydmVkIG91
dCByZXNvdXJjZXMgd2hpbGUgdGhlIGVuY2xhdmUgaXMNCj4gcnVubmluZywgYXMgdGhleSBhcmUg
ZGVkaWNhdGVkIHRvIHRoZSBlbmNsYXZlLg0KPiANCj4gSG9wZSB0aGF0IG5vdyBpdCdzIG1vcmUg
Y2xlYXIuDQoNCnllcywgaXQncyBjbGVhcmVyLg0KDQo+IA0KPiA+DQo+ID4+DQo+ID4+IFRoZXNl
IHR3byBjb21wb25lbnRzIG5lZWQgdG8gcmVmbGVjdCB0aGUgc2FtZSBzdGF0ZSBlLmcuIHdoZW4g
dGhlDQo+ID4+IGVuY2xhdmUgYWJzdHJhY3Rpb24gcHJvY2VzcyAoMSkgaXMgdGVybWluYXRlZCwg
dGhlIGVuY2xhdmUgVk0gKDIpIGlzDQo+ID4+IHRlcm1pbmF0ZWQgYXMgd2VsbC4NCj4gPj4NCj4g
Pj4gV2l0aCByZWdhcmQgdG8gdGhlIGNvbW11bmljYXRpb24gY2hhbm5lbCwgdGhlIHByaW1hcnkg
Vk0gaGFzIGl0cyBvd24NCj4gPj4gZW11bGF0ZWQgdmlydGlvLXZzb2NrIFBDSSBkZXZpY2UuIFRo
ZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkDQo+ID4+IHZpcnRpby12c29jayBkZXZp
Y2UgYXMgd2VsbC4gVGhpcyBjaGFubmVsIGlzIHVzZWQsIGZvciBleGFtcGxlLCB0byBmZXRjaA0K
PiA+PiBkYXRhIGluIHRoZSBlbmNsYXZlIGFuZCB0aGVuIHByb2Nlc3MgaXQuIEFuIGFwcGxpY2F0
aW9uIHRoYXQgc2V0cyB1cCB0aGUNCj4gPj4gdnNvY2sgc29ja2V0IGFuZCBjb25uZWN0cyBvciBs
aXN0ZW5zLCBkZXBlbmRpbmcgb24gdGhlIHVzZSBjYXNlLCBpcyB0aGVuDQo+ID4+IGRldmVsb3Bl
ZCB0byB1c2UgdGhpcyBjaGFubmVsOyB0aGlzIGhhcHBlbnMgb24gYm90aCBlbmRzIC0gcHJpbWFy
eSBWTQ0KPiA+PiBhbmQgZW5jbGF2ZSBWTS4NCj4gPiBIb3cgZG9lcyB0aGUgYXBwbGljYXRpb24g
aW4gdGhlIHByaW1hcnkgVk0gYXNzaWduIHRhc2sgdG8gYmUgZXhlY3V0ZWQNCj4gPiBpbiB0aGUg
ZW5jbGF2ZSBWTT8gSSBkaWRuJ3Qgc2VlIHN1Y2ggY29tbWFuZCBpbiB0aGlzIHNlcmllcywgc28g
c3VwcG9zZQ0KPiA+IGl0IGlzIGFsc28gY29tbXVuaWNhdGVkIHRocm91Z2ggdmlydGlvLXZzb2Nr
Pw0KPiANCj4gVGhlIGFwcGxpY2F0aW9uIHRoYXQgcnVucyBpbiB0aGUgZW5jbGF2ZSBuZWVkcyB0
byBiZSBwYWNrYWdlZCBpbiBhbg0KPiBlbmNsYXZlIGltYWdlIHRvZ2V0aGVyIHdpdGggdGhlIE9T
ICggZS5nLiBrZXJuZWwsIHJhbWRpc2ssIGluaXQgKSB0aGF0DQo+IHdpbGwgcnVuIGluIHRoZSBl
bmNsYXZlIFZNLg0KPiANCj4gVGhlbiB0aGUgZW5jbGF2ZSBpbWFnZSBpcyBsb2FkZWQgaW4gbWVt
b3J5LiBBZnRlciBib290aW5nIGlzIGZpbmlzaGVkLA0KPiB0aGUgYXBwbGljYXRpb24gc3RhcnRz
LiBOb3csIGRlcGVuZGluZyBvbiB0aGUgYXBwIGltcGxlbWVudGF0aW9uIGFuZCB1c2UNCj4gY2Fz
ZSwgb25lIGV4YW1wbGUgY2FuIGJlIHRoYXQgdGhlIGFwcCBpbiB0aGUgZW5jbGF2ZSB3YWl0cyBm
b3IgZGF0YSB0bw0KPiBiZSBmZXRjaGVkIGluIHZpYSB0aGUgdnNvY2sgY2hhbm5lbC4NCj4gDQoN
Ck9LLCBJIHRob3VnaHQgdGhlIGNvZGUvZGF0YSB3YXMgZHluYW1pY2FsbHkgaW5qZWN0ZWQgZnJv
bSB0aGUgcHJpbWFyeQ0KVk0gYW5kIHRoZW4gcnVuIGluIHRoZSBlbmNsYXZlLiBGcm9tIHlvdXIg
ZGVzY3JpcHRpb24gaXQgc291bmRzIGxpa2UNCmEgc2VydmljaW5nIG1vZGVsIHRoYXQgYW4gYXV0
by1ydW5uaW5nIGFwcGxpY2F0aW9uIHdhaXQgZm9yIGFuZCByZXNwb25kDQpzZXJ2aWNlIHJlcXVl
c3QgZnJvbSB0aGUgYXBwbGljYXRpb24gaW4gdGhlIHByaW1hcnkgVk0uDQoNClRoYW5rcw0KS2V2
aW4NCg==
