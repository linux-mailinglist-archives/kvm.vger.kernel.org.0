Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB32E15B73C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 03:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgBMCkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 21:40:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:14497 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729394AbgBMCkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 21:40:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 18:40:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233976128"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 18:40:48 -0800
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:40:47 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:40:47 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.222]) with mapi id 14.03.0439.000;
 Thu, 13 Feb 2020 10:40:45 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        "Eduardo Habkost" <ehabkost@redhat.com>
Subject: RE: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Thread-Topic: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Thread-Index: AQHV1p1OZ3QtxF5MCUauWTZBa4G1JagWGOQAgAJEBHA=
Date:   Thu, 13 Feb 2020 02:40:45 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BBBF4@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
 <20200211215630.GN984290@xz-x1>
In-Reply-To: <20200211215630.GN984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzUxYTFjZGUtOTJkNy00YTRjLWJmYjYtMzI3OWJmZDNlYTNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRm9aQ05WbnNpbVNubTdqOGRLd2h1WkhFaTdaaWsrNFZMZEl0REpoSERUbTF2ZE1TZVdPY1NiVTVCMDZjdWJKNyJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
RmVicnVhcnkgMTIsIDIwMjAgNTo1NyBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDE0LzI1XSBpbnRlbF9pb21tdTogYWRkIHZp
cnR1YWwgY29tbWFuZCBjYXBhYmlsaXR5IHN1cHBvcnQNCj4gDQo+IE9uIFdlZCwgSmFuIDI5LCAy
MDIwIGF0IDA0OjE2OjQ1QU0gLTA4MDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiArLyoNCj4gPiAr
ICogVGhlIGJhc2ljIGlkZWEgaXMgdG8gbGV0IGh5cGVydmlzb3IgdG8gc2V0IGEgcmFuZ2UgZm9y
IGF2YWlsYWJsZQ0KPiA+ICsgKiBQQVNJRHMgZm9yIFZNcy4gT25lIG9mIHRoZSByZWFzb25zIGlz
IFBBU0lEICMwIGlzIHJlc2VydmVkIGJ5DQo+ID4gKyAqIFJJRF9QQVNJRCB1c2FnZS4gV2UgaGF2
ZSBubyBpZGVhIGhvdyBtYW55IHJlc2VydmVkIFBBU0lEcyBpbiBmdXR1cmUsDQo+ID4gKyAqIHNv
IGhlcmUganVzdCBhbiBldmFsdWF0ZWQgdmFsdWUuIEhvbmVzdGx5LCBzZXQgaXQgYXMgIjEiIGlz
IGVub3VnaA0KPiA+ICsgKiBhdCBjdXJyZW50IHN0YWdlLg0KPiA+ICsgKi8NCj4gPiArI2RlZmlu
ZSBWVERfTUlOX0hQQVNJRCAgICAgICAgICAgICAgMQ0KPiA+ICsjZGVmaW5lIFZURF9NQVhfSFBB
U0lEICAgICAgICAgICAgICAweEZGRkZGDQo+IA0KPiBPbmUgbW9yZSBxdWVzdGlvbjogSSBzZWUg
dGhhdCBQQVNJRCBpcyBkZWZpbmVkIGFzIDIwYml0cyBsb25nLiAgSXQncw0KPiBmaW5lLiAgSG93
ZXZlciBJIHN0YXJ0IHRvIGdldCBjb25mdXNlZCBvbiBob3cgdGhlIFNjYWxhYmxlIE1vZGUgUEFT
SUQNCj4gRGlyZWN0b3J5IGNvdWxkIHNlcnZpY2UgdGhhdCBtdWNoIG9mIFBBU0lEIGVudHJpZXMu
DQo+IA0KPiBJJ20gbG9va2luZyBhdCBzcGVjIDMuNC4zLCBGaWd1cmUgMy04Lg0KPiANCj4gRmly
c3RseSwgd2Ugb25seSBoYXZlIHR3byBsZXZlbHMgZm9yIGEgUEFTSUQgdGFibGUuICBUaGUgY29u
dGV4dCBlbnRyeQ0KPiBvZiBhIGRldmljZSBzdG9yZXMgYSBwb2ludGVyIHRvIHRoZSAiU2NhbGFi
bGUgTW9kZSBQQVNJRCBEaXJlY3RvcnkiDQo+IHBhZ2UuIEkgc2VlIHRoYXQgdGhlcmUncmUgMl4x
NCBlbnRyaWVzIGluICJTY2FsYWJsZSBNb2RlIFBBU0lEDQo+IERpcmVjdG9yeSIgcGFnZSwgZWFj
aCBpcyBhICJTY2FsYWJsZSBNb2RlIFBBU0lEIFRhYmxlIi4NCj4gSG93ZXZlci4uLiBob3cgZG8g
d2UgZml0IGluIHRoZSA0SyBwYWdlIGlmIGVhY2ggZW50cnkgaXMgYSBwb2ludGVyIG9mDQo+IHg4
Nl82NCAoOCBieXRlcykgd2hpbGUgdGhlcmUncmUgMl4xNCBlbnRyaWVzPyAgQSBzaW1wbGUgbWF0
aCBnaXZlcyBtZQ0KPiA0Sy84ID0gNTEyLCB3aGljaCBtZWFucyB0aGUgIlNjYWxhYmxlIE1vZGUg
UEFTSUQgRGlyZWN0b3J5IiBwYWdlIGNhbg0KPiBvbmx5IGhhdmUgNTEyIGVudHJpZXMsIHRoZW4g
aG93IHRoZSAyXjE0IGNvbWUgZnJvbT8gIEhtbT8/DQoNCkkgY2hlY2tlZCB3aXRoIEtldmluLiBU
aGUgc3BlYyBkb2Vzbid0IHNheSB0aGUgZGlyIHRhYmxlIGlzIDRLLiBJdCBzYXlzIDRLDQpvbmx5
IGZvciBwYXNpZCB0YWJsZS4gQWxzbywgaWYgeW91IGxvb2sgYXQgOS40LCBzY2FsYWJlLW1vZGUg
Y29udGV4dCBlbnRyeQ0KaW5jbHVkZXMgYSBQRFRTIGZpZWxkIHRvIHNwZWNpZnkgdGhlIGFjdHVh
bCBzaXplIG9mIHRoZSBkaXJlY3RvcnkgdGFibGUuDQoNCj4gQXBhcnQgb2YgdGhpczogYWxzbyBJ
IGp1c3Qgbm90aWNlZCAod2hlbiByZWFkaW5nIHRoZSBsYXR0ZXIgcGFydCBvZg0KPiB0aGUgc2Vy
aWVzKSB0aGF0IHRoZSB0aW1lIHRoYXQgYSBwYXNpZCB0YWJsZSB3YWxrIGNhbiBjb25zdW1lIHdp
bGwNCj4gZGVwZW5kIG9uIHRoaXMgdmFsdWUgdG9vLiAgSSdkIHN1Z2dlc3QgdG8gbWFrZSB0aGlz
IGFzIHNtYWxsIGFzIHdlDQo+IGNhbiwgYXMgbG9uZyBhcyBpdCBzYXRpc2ZpZXMgdGhlIHVzYWdl
LiAgV2UgY2FuIGV2ZW4gYnVtcCBpdCBpbiB0aGUNCj4gZnV0dXJlLg0KDQpJIHNlZS4gVGhpcyBs
b29rcyB0byBiZSBhbiBvcHRpbWl6YXRpb24uIHJpZ2h0PyBJbnN0ZWFkIG9mIG1vZGlmeSB0aGUN
CnZhbHVlIG9mIHRoaXMgbWFjcm8sICBJIHRoaW5rIHdlIGNhbiBkbyB0aGlzIG9wdGltaXphdGlv
biBieSB0cmFja2luZw0KdGhlIGFsbG9jYXRlZCBQQVNJRHMgaW4gUUVNVS4gVGh1cywgdGhlIHBh
c2lkIHRhYmxlIHdhbGsgIHdvdWxkIGJlIG1vcmUNCmVmZmljaWVudCBhbmQgYWxzbyBubyBkZXBl
bmRlbmN5IG9uIHRoZSBWVERfTUFYX0hQQVNJRC4gRG9lcyBpdCBtYWtlDQpzZW5zZSB0byB5b3U/
IDotKQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
