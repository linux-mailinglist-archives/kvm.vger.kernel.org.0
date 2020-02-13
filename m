Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277F615B746
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 03:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgBMCqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 21:46:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:48365 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgBMCqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 21:46:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 18:46:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="380962571"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 12 Feb 2020 18:46:36 -0800
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:46:35 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:46:35 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.126]) with mapi id 14.03.0439.000;
 Thu, 13 Feb 2020 10:46:33 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: RE: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Thread-Topic: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Thread-Index: AQHV1p1ISlCEZJtKwkqCei/mecuDIagDpFsAgADzWWCAES39gIABZmlAgAAbggCAATpJsA==
Date:   Thu, 13 Feb 2020 02:46:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BBC65@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
 <20200131040644.GG15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
 <20200211165843.GG984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
 <20200212155958.GB1083891@xz-x1>
In-Reply-To: <20200212155958.GB1083891@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTE4YzZhOTMtNjg0Yi00ZGU2LWE4NzAtNWMzMWE4MTQ0YjhjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSjlxaThVSGt4dmp0N0RzOXM2TzEzOGgwdWJUSVpDTmRtQmQ1aXlCRFI3QXRCRzhvdFZcL2ZFcmFqY2NiZWc0eHUifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBG
ZWJydWFyeSAxMywgMjAyMCAxMjowMCBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDAzLzI1XSBody9pb21tdTogaW50cm9kdWNl
IElPTU1VQ29udGV4dA0KPiANCj4gT24gV2VkLCBGZWIgMTIsIDIwMjAgYXQgMDc6MTU6MTNBTSAr
MDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gV2hpbGUgY29uc2lk
ZXJpbmcgeW91ciBzdWdnZXN0aW9uIG9uIGRyb3BwaW5nIG9uZSBvZiB0aGUgdHdvIGFic3RyYWN0
DQo+ID4gbGF5ZXJzLiBJIGNhbWUgdXAgYSBuZXcgcHJvcG9zYWwgYXMgYmVsb3c6DQo+ID4NCj4g
PiBXZSBtYXkgZHJvcCB0aGUgSU9NTVVDb250ZXh0IGluIHRoaXMgc2VyaWVzLCBhbmQgcmVuYW1l
DQo+ID4gRHVhbFN0YWdlSU9NTVVPYmplY3QgdG8gSG9zdElPTU1VQ29udGV4dCwgd2hpY2ggaXMg
cGVyLXZmaW8tY29udGFpbmVyLg0KPiA+IEFkZCBhbiBpbnRlcmZhY2UgaW4gUENJIGxheWVyKGUu
Zy4gYW4gY2FsbGJhY2sgaW4gIFBDSURldmljZSkgdG8gbGV0IHZJT01NVSBnZXQNCj4gSG9zdElP
TU1VQ29udGV4dC4NCj4gPiBJIHRoaW5rIHRoaXMgY291bGQgY292ZXIgdGhlIHJlcXVpcmVtZW50
IG9mIHByb3ZpZGluZyBleHBsaWNpdCBtZXRob2QNCj4gPiBmb3IgdklPTU1VIHRvIGNhbGwgaW50
byBWRklPIGFuZCB0aGVuIHByb2dyYW0gaG9zdCBJT01NVS4NCj4gPg0KPiA+IFdoaWxlIGZvciB0
aGUgcmVxdWlyZW1lbnQgb2YgVkZJTyB0byB2SU9NTVUgY2FsbGluZ3MgKGUuZy4gUFJRKSwgSQ0K
PiA+IHRoaW5rIGl0IGNvdWxkIGJlIGRvbmUgdmlhIFBDSSBsYXllciBieSBhZGRpbmcgYW4gb3Bl
cmF0aW9uIGluIFBDSUlPTU1VT3BzLg0KPiBUaG91Z2h0cz8NCj4gDQo+IEhtbSBzb3VuZHMgZ29v
ZC4gOikNCj4gDQo+IFRoZSB0aGluZyBpcyBmb3IgdGhlIGNhbGxzIHRvIHRoZSBvdGhlciBkaXJl
Y3Rpb24gKGUuZy4gVkZJTyBpbmplY3RpbmcgZmF1bHRzIHRvDQo+IHZJT01NVSksIHRoYXQncyBu
ZWl0aGVyIHBlci1jb250YWluZXIgbm9yIHBlci1kZXZpY2UsIGJ1dCBwZXItdklPTU1VLg0KPiBQ
Q0lJT01NVU9wcyBzdWl0ZXMgZm9yIHRoYXQgam9iIEknZCBzYXksIHdoaWNoIGlzIHBlci12SU9N
TVUuDQo+IA0KPiBMZXQncyBzZWUgaG93IGl0IGdvZXMuDQoNClRoYW5rcywgbGV0IG1lIGdldCBh
IG5ldyB2ZXJzaW9uIGJ5IGVuZC1vZiB0aGlzIHdlZWsuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
