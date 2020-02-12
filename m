Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E6815A195
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgBLHQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:16:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:33782 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbgBLHQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 02:16:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 23:16:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="222199210"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 23:16:54 -0800
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:16:50 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:16:50 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.196]) with mapi id 14.03.0439.000;
 Wed, 12 Feb 2020 15:16:49 +0800
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
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v3 09/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Thread-Topic: [RFC v3 09/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Thread-Index: AQHV1p1Mt3kiEH7Q3k+UxS2Zmy1meqgV6dIAgAFRiXA=
Date:   Wed, 12 Feb 2020 07:16:48 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BA503@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-10-git-send-email-yi.l.liu@intel.com>
 <20200211190802.GH984290@xz-x1>
In-Reply-To: <20200211190802.GH984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGM3YzNjMzQtMDlmOS00ZDU1LWFhOTctOGQwZGFlODI2MjVjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOUlCV01FeHQzNDFrY2Vkd0cxdExJSVZ4TnNGVWltVG10VEhtYzBrM2RpTXR5XC9vSVROT1E5YWZcL0MzS2tpaWhaIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
RmVicnVhcnkgMTIsIDIwMjAgMzowOCBBTQ0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MyAwOS8yNV0g
dmZpbzogY2hlY2sgVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VIHN1cHBvcnQNCj4gDQo+IE9uIFdl
ZCwgSmFuIDI5LCAyMDIwIGF0IDA0OjE2OjQwQU0gLTA4MDAsIExpdSwgWWkgTCB3cm90ZToNCj4g
PiBGcm9tOiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+DQo+ID4gVkZJTyBuZWVk
cyB0byBjaGVjayBWRklPX1RZUEUxX05FU1RJTkdfSU9NTVUgc3VwcG9ydCB3aXRoIEtlcm5lbA0K
PiA+IGJlZm9yZSBmdXJ0aGVyIHVzaW5nIGl0Lg0KPiA+IGUuZy4gcmVxdWlyZXMgdG8gY2hlY2sg
SU9NTVUgVUFQSSB2ZXJzaW9uLg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0KPiA+IENjOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwu
Y29tPg0KPiA+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogWWkgU3VuIDx5aS55LnN1bkBs
aW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IERhdmlkIEdpYnNvbiA8ZGF2aWRAZ2lic29uLmRyb3Bi
ZWFyLmlkLmF1Pg0KPiA+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRo
YXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgU3VuIDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gIGh3L3ZmaW8vY29tbW9uLmMgfCAxNCArKysrKysrKysrKystLQ0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9ody92ZmlvL2NvbW1vbi5jIGIvaHcvdmZpby9jb21tb24uYyBpbmRleA0K
PiA+IDBjYzdmZjUuLmE1ZTcwYjEgMTAwNjQ0DQo+ID4gLS0tIGEvaHcvdmZpby9jb21tb24uYw0K
PiA+ICsrKyBiL2h3L3ZmaW8vY29tbW9uLmMNCj4gPiBAQCAtMTE1NywxMiArMTE1NywyMSBAQCBz
dGF0aWMgdm9pZA0KPiA+IHZmaW9fcHV0X2FkZHJlc3Nfc3BhY2UoVkZJT0FkZHJlc3NTcGFjZSAq
c3BhY2UpICBzdGF0aWMgaW50DQo+IHZmaW9fZ2V0X2lvbW11X3R5cGUoVkZJT0NvbnRhaW5lciAq
Y29udGFpbmVyLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRXJyb3IgKipl
cnJwKSAgew0KPiA+IC0gICAgaW50IGlvbW11X3R5cGVzW10gPSB7IFZGSU9fVFlQRTF2Ml9JT01N
VSwgVkZJT19UWVBFMV9JT01NVSwNCj4gPiArICAgIGludCBpb21tdV90eXBlc1tdID0geyBWRklP
X1RZUEUxX05FU1RJTkdfSU9NTVUsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgVkZJ
T19UWVBFMXYyX0lPTU1VLCBWRklPX1RZUEUxX0lPTU1VLA0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFZGSU9fU1BBUFJfVENFX3YyX0lPTU1VLCBWRklPX1NQQVBSX1RDRV9JT01NVSB9
Ow0KPiA+IC0gICAgaW50IGk7DQo+ID4gKyAgICBpbnQgaSwgdmVyc2lvbjsNCj4gPg0KPiA+ICAg
ICAgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoaW9tbXVfdHlwZXMpOyBpKyspIHsNCj4gPiAg
ICAgICAgICBpZiAoaW9jdGwoY29udGFpbmVyLT5mZCwgVkZJT19DSEVDS19FWFRFTlNJT04sDQo+
ID4gaW9tbXVfdHlwZXNbaV0pKSB7DQo+ID4gKyAgICAgICAgICAgIGlmIChpb21tdV90eXBlc1tp
XSA9PSBWRklPX1RZUEUxX05FU1RJTkdfSU9NTVUpIHsNCj4gPiArICAgICAgICAgICAgICAgIHZl
cnNpb24gPSBpb2N0bChjb250YWluZXItPmZkLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFZGSU9fTkVTVElOR19HRVRfSU9NTVVfVUFQSV9WRVJTSU9OKTsNCj4gPiArICAg
ICAgICAgICAgICAgIGlmICh2ZXJzaW9uIDwgSU9NTVVfVUFQSV9WRVJTSU9OKSB7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgcHJpbnRmKCJJT01NVSBVQVBJIGluY29tcGF0aWJsZSBmb3IgbmVz
dGluZ1xuIik7DQo+IA0KPiBUaGVyZSBzaG91bGQgaGF2ZSBiZXR0ZXIgYWx0ZXJuYXRpdmVzIHRo
YW4gcHJpbnRmKCkuLi4gTWF5YmUgd2Fybl9yZXBvcnQoKT8NCg0KR290IGl0LiB0aGFua3MuIPCf
mIoNCg0KUmVnYXJkcywNCllpIExpdQ0K
