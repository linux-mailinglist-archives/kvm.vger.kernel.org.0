Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4686F15A1AB
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgBLHUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:20:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:44938 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbgBLHUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 02:20:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 23:20:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="380684249"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 11 Feb 2020 23:20:36 -0800
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:20:35 -0800
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:20:35 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.138]) with mapi id 14.03.0439.000;
 Wed, 12 Feb 2020 15:20:33 +0800
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
Subject: RE: [RFC v3 12/25] vfio/common: add pasid_alloc/free support
Thread-Topic: [RFC v3 12/25] vfio/common: add pasid_alloc/free support
Thread-Index: AQHV1p1NgtZeYDDnF06t+4YOnoc836gV8IOAgAFL3nA=
Date:   Wed, 12 Feb 2020 07:20:33 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BA534@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-13-git-send-email-yi.l.liu@intel.com>
 <20200211193159.GJ984290@xz-x1>
In-Reply-To: <20200211193159.GJ984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTEyMWY1MzUtMDAwYS00M2MzLWE2ODctMDMyOTZmNTllNDgxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSDl3TVFkeFBneTNhSlBqUFFcL3NyNUF6TGdLSkNIYVV2M1hMd01Kbm1LZzdHMFdvUTQ2eVloNjlaVGhlMXFrb1IifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
RmVicnVhcnkgMTIsIDIwMjAgMzozMiBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDEyLzI1XSB2ZmlvL2NvbW1vbjogYWRkIHBh
c2lkX2FsbG9jL2ZyZWUgc3VwcG9ydA0KPiANCj4gT24gV2VkLCBKYW4gMjksIDIwMjAgYXQgMDQ6
MTY6NDNBTSAtMDgwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEZyb206IExpdSBZaSBMIDx5aS5s
LmxpdUBpbnRlbC5jb20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFkZHMgVkZJTyBwYXNpZCBhbGxv
Yy9mcmVlIHN1cHBvcnQgdG8gYWxsb3cgaG9zdCBpbnRlcmNlcHQNCj4gPiBpbiBQQVNJRCBhbGxv
Y2F0aW9uIGZvciBWTSBieSBhZGRpbmcgVkZJTyBpbXBsZW1lbnRhdGlvbiBvZg0KPiA+IER1YWxT
dGFnZUlPTU1VT3BzLnBhc2lkX2FsbG9jL2ZyZWUgY2FsbGJhY2tzLg0KPiA+DQo+ID4gQ2M6IEtl
dmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBKYWNvYiBQYW4gPGphY29i
Lmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhh
dC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBD
YzogWWkgU3VuIDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IERhdmlkIEdpYnNv
biA8ZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1Pg0KPiA+IENjOiBBbGV4IFdpbGxpYW1zb24g
PGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBM
IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGh3L3ZmaW8vY29tbW9uLmMgfCA0
Mg0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9ody92
ZmlvL2NvbW1vbi5jIGIvaHcvdmZpby9jb21tb24uYyBpbmRleA0KPiA+IGEwNzgyNGIuLjAxNGY0
ZTcgMTAwNjQ0DQo+ID4gLS0tIGEvaHcvdmZpby9jb21tb24uYw0KPiA+ICsrKyBiL2h3L3ZmaW8v
Y29tbW9uLmMNCj4gPiBAQCAtMTE3OSw3ICsxMTc5LDQ5IEBAIHN0YXRpYyBpbnQgdmZpb19nZXRf
aW9tbXVfdHlwZShWRklPQ29udGFpbmVyDQo+ICpjb250YWluZXIsDQo+ID4gICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgdmZpb19kc19pb21tdV9wYXNp
ZF9hbGxvYyhEdWFsU3RhZ2VJT01NVU9iamVjdCAqZHNpX29iaiwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgIHVpbnQzMl90IG1pbiwgdWludDMyX3QgbWF4LCB1aW50MzJfdCAqcGFzaWQp
DQo+ID4gK3sNCj4gPiArICAgIFZGSU9Db250YWluZXIgKmNvbnRhaW5lciA9IGNvbnRhaW5lcl9v
Zihkc2lfb2JqLCBWRklPQ29udGFpbmVyLCBkc2lfb2JqKTsNCj4gPiArICAgIHN0cnVjdCB2Zmlv
X2lvbW11X3R5cGUxX3Bhc2lkX3JlcXVlc3QgcmVxOw0KPiA+ICsgICAgdW5zaWduZWQgbG9uZyBh
cmdzejsNCj4gPiArDQo+ID4gKyAgICBhcmdzeiA9IHNpemVvZihyZXEpOw0KPiA+ICsgICAgcmVx
LmFyZ3N6ID0gYXJnc3o7DQo+ID4gKyAgICByZXEuZmxhZ3MgPSBWRklPX0lPTU1VX1BBU0lEX0FM
TE9DOw0KPiA+ICsgICAgcmVxLmFsbG9jX3Bhc2lkLm1pbiA9IG1pbjsNCj4gPiArICAgIHJlcS5h
bGxvY19wYXNpZC5tYXggPSBtYXg7DQo+ID4gKw0KPiA+ICsgICAgaWYgKGlvY3RsKGNvbnRhaW5l
ci0+ZmQsIFZGSU9fSU9NTVVfUEFTSURfUkVRVUVTVCwgJnJlcSkpIHsNCj4gPiArICAgICAgICBl
cnJvcl9yZXBvcnQoIiVzOiAlZCwgYWxsb2MgZmFpbGVkIiwgX19mdW5jX18sIC1lcnJubyk7DQo+
ID4gKyAgICAgICAgcmV0dXJuIC1lcnJubzsNCj4gDQo+IE5vdGUgdGhhdCBlcnJubyBpcyBwcm9u
ZSB0byBjaGFuZ2UgYnkgb3RoZXIgc3lzY2FsbHMuICBCZXR0ZXIgY2FjaGUgaXQgcmlnaHQgYWZ0
ZXINCj4gdGhlIGlvY3RsLg0KPiANCj4gPiArICAgIH0NCj4gPiArICAgICpwYXNpZCA9IHJlcS5h
bGxvY19wYXNpZC5yZXN1bHQ7DQo+ID4gKyAgICByZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4g
PiArc3RhdGljIGludCB2ZmlvX2RzX2lvbW11X3Bhc2lkX2ZyZWUoRHVhbFN0YWdlSU9NTVVPYmpl
Y3QgKmRzaV9vYmosDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1
aW50MzJfdCBwYXNpZCkgew0KPiA+ICsgICAgVkZJT0NvbnRhaW5lciAqY29udGFpbmVyID0gY29u
dGFpbmVyX29mKGRzaV9vYmosIFZGSU9Db250YWluZXIsIGRzaV9vYmopOw0KPiA+ICsgICAgc3Ry
dWN0IHZmaW9faW9tbXVfdHlwZTFfcGFzaWRfcmVxdWVzdCByZXE7DQo+ID4gKyAgICB1bnNpZ25l
ZCBsb25nIGFyZ3N6Ow0KPiA+ICsNCj4gPiArICAgIGFyZ3N6ID0gc2l6ZW9mKHJlcSk7DQo+ID4g
KyAgICByZXEuYXJnc3ogPSBhcmdzejsNCj4gPiArICAgIHJlcS5mbGFncyA9IFZGSU9fSU9NTVVf
UEFTSURfRlJFRTsNCj4gPiArICAgIHJlcS5mcmVlX3Bhc2lkID0gcGFzaWQ7DQo+ID4gKw0KPiA+
ICsgICAgaWYgKGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZGSU9fSU9NTVVfUEFTSURfUkVRVUVTVCwg
JnJlcSkpIHsNCj4gPiArICAgICAgICBlcnJvcl9yZXBvcnQoIiVzOiAlZCwgZnJlZSBmYWlsZWQi
LCBfX2Z1bmNfXywgLWVycm5vKTsNCj4gPiArICAgICAgICByZXR1cm4gLWVycm5vOw0KPiANCj4g
U2FtZSBoZXJlLg0KDQpHb3QgdGhlIHR3byBjb21tZW50cy4gVGhhbmtzLA0KDQpSZWdhcmRzLA0K
WWkgTGl1DQoNCg==
