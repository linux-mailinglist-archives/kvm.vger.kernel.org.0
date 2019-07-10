Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD26462E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGJMah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:30:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:12025 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfGJMah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:30:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:30:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="159752242"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 05:30:36 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:30:35 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:30:35 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.240]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 20:30:33 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 08/18] vfio/pci: add vfio bind/unbind_gpasid
 implementation
Thread-Topic: [RFC v1 08/18] vfio/pci: add vfio bind/unbind_gpasid
 implementation
Thread-Index: AQHVM+yokOEJHCCTkU2AdXu3Us1kbqbBdTWAgAJZMaA=
Date:   Wed, 10 Jul 2019 12:30:33 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A761@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-9-git-send-email-yi.l.liu@intel.com>
 <cac2a42e-c152-e715-451f-7a19ca3e19ca@redhat.com>
In-Reply-To: <cac2a42e-c152-e715-451f-7a19ca3e19ca@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjY3NDZjZDEtM2RmMy00NzZhLThjNmMtNDY1ODBjOGI5MTE2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSXNWTFdkXC9ySVJRcXVjanZRVjJWd1ZFZWdyT3ZIekJKYThMeDlkTEgxMEMxOE1XeUxHTWk2ak9CUU45STdYczgifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBdWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQ0KPiBTZW50
OiBUdWVzZGF5LCBKdWx5IDksIDIwMTkgNDozOCBQTQ0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MSAw
OC8xOF0gdmZpby9wY2k6IGFkZCB2ZmlvIGJpbmQvdW5iaW5kX2dwYXNpZCBpbXBsZW1lbnRhdGlv
bg0KPiANCj4gSGkgTGl1LA0KPiANCj4gT24gNy81LzE5IDE6MDEgUE0sIExpdSBZaSBMIHdyb3Rl
Og0KPiA+IFRoaXMgcGF0Y2ggYWRkcyB2ZmlvIGltcGxlbWVudGF0aW9uIFBDSVBBU0lET3BzLmJp
bmRfZ3Bhc2lkL3VuYmluZF9wYXNpZCgpLg0KPiA+IFRoZXNlIHR3byBmdW5jdGlvbnMgYXJlIHVz
ZWQgdG8gcHJvcGFnYXRlIGd1ZXN0IHBhc2lkIGJpbmQgYW5kIHVuYmluZA0KPiA+IHJlcXVlc3Rz
IHRvIGhvc3QgdmlhIHZmaW8gY29udGFpbmVyIGlvY3RsLg0KPiA+DQo+ID4gQ2M6IEtldmluIFRp
YW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBKYWNvYiBQYW4gPGphY29iLmp1bi5w
YW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+
DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogWWkg
U3VuIDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IERhdmlkIEdpYnNvbiA8ZGF2
aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGh3L3ZmaW8vcGNpLmMgfCA1NA0KPiA+
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiA+ICAxIGZpbGUgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2h3L3ZmaW8vcGNpLmMgYi9ody92ZmlvL3BjaS5jIGluZGV4IGFiMTg0YWQuLjg5MmI0NmMN
Cj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9ody92ZmlvL3BjaS5jDQo+ID4gKysrIGIvaHcvdmZpby9w
Y2kuYw0KPiA+IEBAIC0yNzQ0LDkgKzI3NDQsNjMgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9kZXZp
Y2VfcmVxdWVzdF9wYXNpZF9mcmVlKFBDSUJ1cw0KPiAqYnVzLA0KPiA+ICAgICAgcmV0dXJuIHJl
dDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHZmaW9fcGNpX2RldmljZV9iaW5kX2dw
YXNpZChQQ0lCdXMgKmJ1cywgaW50MzJfdCBkZXZmbiwNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCBncGFzaWRfYmluZF9kYXRhDQo+ID4gKypnX2JpbmRf
ZGF0YSkgew0KPiA+ICsgICAgUENJRGV2aWNlICpwZGV2ID0gYnVzLT5kZXZpY2VzW2RldmZuXTsN
Cj4gPiArICAgIFZGSU9QQ0lEZXZpY2UgKnZkZXYgPSBET19VUENBU1QoVkZJT1BDSURldmljZSwg
cGRldiwgcGRldik7DQo+ID4gKyAgICBWRklPQ29udGFpbmVyICpjb250YWluZXIgPSB2ZGV2LT52
YmFzZWRldi5ncm91cC0+Y29udGFpbmVyOw0KPiA+ICsgICAgc3RydWN0IHZmaW9faW9tbXVfdHlw
ZTFfYmluZCAqYmluZDsNCj4gPiArICAgIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX2JpbmRfZ3Vl
c3RfcGFzaWQgKmJpbmRfZ3Vlc3RfcGFzaWQ7DQo+ID4gKyAgICB1bnNpZ25lZCBsb25nIGFyZ3N6
Ow0KPiA+ICsNCj4gPiArICAgIGFyZ3N6ID0gc2l6ZW9mKCpiaW5kKSArIHNpemVvZigqYmluZF9n
dWVzdF9wYXNpZCk7DQo+ID4gKyAgICBiaW5kID0gZ19tYWxsb2MwKGFyZ3N6KTsNCj4gPiArICAg
IGJpbmQtPmFyZ3N6ID0gYXJnc3o7DQo+ID4gKyAgICBiaW5kLT5iaW5kX3R5cGUgPSBWRklPX0lP
TU1VX0JJTkRfR1VFU1RfUEFTSUQ7DQo+ID4gKyAgICBiaW5kX2d1ZXN0X3Bhc2lkID0gKHN0cnVj
dCB2ZmlvX2lvbW11X3R5cGUxX2JpbmRfZ3Vlc3RfcGFzaWQgKikgJmJpbmQtDQo+ID5kYXRhOw0K
PiA+ICsgICAgYmluZF9ndWVzdF9wYXNpZC0+YmluZF9kYXRhID0gKmdfYmluZF9kYXRhOw0KPiA+
ICsNCj4gPiArICAgIHJjdV9yZWFkX2xvY2soKTsNCj4gd2h5IGRvIHlvdSBuZWVkIHRoZSByY3Vf
cmVhZF9sb2NrPw0KPiA+ICsgICAgaWYgKGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZGSU9fSU9NTVVf
QklORCwgYmluZCkgIT0gMCkgew0KPiA+ICsgICAgICAgIGVycm9yX3JlcG9ydCgidmZpb19wY2lf
ZGV2aWNlX2JpbmRfZ3Bhc2lkOiINCj4gPiArICAgICAgICAgICAgICAgICAgICAgIiBiaW5kIGZh
aWxlZCwgY29udGFuaWVyOiAlcCIsIGNvbnRhaW5lcik7DQo+IGNvbnRhaW5lcg0KDQpuaWNlIGNh
dGNoLiA6LSkNCg0KPiA+ICsgICAgfQ0KPiA+ICsgICAgcmN1X3JlYWRfdW5sb2NrKCk7DQo+ID4g
KyAgICBnX2ZyZWUoYmluZCk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHZmaW9f
cGNpX2RldmljZV91bmJpbmRfZ3Bhc2lkKFBDSUJ1cyAqYnVzLCBpbnQzMl90IGRldmZuLA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGdwYXNpZF9iaW5k
X2RhdGENCj4gPiArKmdfYmluZF9kYXRhKSB7DQo+ID4gKyAgICBQQ0lEZXZpY2UgKnBkZXYgPSBi
dXMtPmRldmljZXNbZGV2Zm5dOw0KPiA+ICsgICAgVkZJT1BDSURldmljZSAqdmRldiA9IERPX1VQ
Q0FTVChWRklPUENJRGV2aWNlLCBwZGV2LCBwZGV2KTsNCj4gPiArICAgIFZGSU9Db250YWluZXIg
KmNvbnRhaW5lciA9IHZkZXYtPnZiYXNlZGV2Lmdyb3VwLT5jb250YWluZXI7DQo+ID4gKyAgICBz
dHJ1Y3QgdmZpb19pb21tdV90eXBlMV9iaW5kICpiaW5kOw0KPiA+ICsgICAgc3RydWN0IHZmaW9f
aW9tbXVfdHlwZTFfYmluZF9ndWVzdF9wYXNpZCAqYmluZF9ndWVzdF9wYXNpZDsNCj4gPiArICAg
IHVuc2lnbmVkIGxvbmcgYXJnc3o7DQo+ID4gKw0KPiA+ICsgICAgYXJnc3ogPSBzaXplb2YoKmJp
bmQpICsgc2l6ZW9mKCpiaW5kX2d1ZXN0X3Bhc2lkKTsNCj4gPiArICAgIGJpbmQgPSBnX21hbGxv
YzAoYXJnc3opOw0KPiA+ICsgICAgYmluZC0+YXJnc3ogPSBhcmdzejsNCj4gPiArICAgIGJpbmQt
PmJpbmRfdHlwZSA9IFZGSU9fSU9NTVVfQklORF9HVUVTVF9QQVNJRDsNCj4gPiArICAgIGJpbmRf
Z3Vlc3RfcGFzaWQgPSAoc3RydWN0IHZmaW9faW9tbXVfdHlwZTFfYmluZF9ndWVzdF9wYXNpZCAq
KSAmYmluZC0NCj4gPmRhdGE7DQo+ID4gKyAgICBiaW5kX2d1ZXN0X3Bhc2lkLT5iaW5kX2RhdGEg
PSAqZ19iaW5kX2RhdGE7DQo+ID4gKw0KPiA+ICsgICAgcmN1X3JlYWRfbG9jaygpOw0KPiA+ICsg
ICAgaWYgKGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZGSU9fSU9NTVVfVU5CSU5ELCBiaW5kKSAhPSAw
KSB7DQo+ID4gKyAgICAgICAgZXJyb3JfcmVwb3J0KCJ2ZmlvX3BjaV9kZXZpY2VfdW5iaW5kX2dw
YXNpZDoiDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICIgdW5iaW5kIGZhaWxlZCwgY29udGFu
aWVyOiAlcCIsIGNvbnRhaW5lcik7DQo+IGNvbnRhaW5lcg0KDQpvb3BzLCBUaGFua3MsDQoNCj4g
PiArICAgIH0NCj4gPiArICAgIHJjdV9yZWFkX3VubG9jaygpOw0KPiA+ICsgICAgZ19mcmVlKGJp
bmQpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgUENJUEFTSURPcHMgdmZpb19wY2lfcGFz
aWRfb3BzID0gew0KPiA+ICAgICAgLmFsbG9jX3Bhc2lkID0gdmZpb19wY2lfZGV2aWNlX3JlcXVl
c3RfcGFzaWRfYWxsb2MsDQo+ID4gICAgICAuZnJlZV9wYXNpZCA9IHZmaW9fcGNpX2RldmljZV9y
ZXF1ZXN0X3Bhc2lkX2ZyZWUsDQo+ID4gKyAgICAuYmluZF9ncGFzaWQgPSB2ZmlvX3BjaV9kZXZp
Y2VfYmluZF9ncGFzaWQsDQo+ID4gKyAgICAudW5iaW5kX2dwYXNpZCA9IHZmaW9fcGNpX2Rldmlj
ZV91bmJpbmRfZ3Bhc2lkLA0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIHZmaW9fcmVh
bGl6ZShQQ0lEZXZpY2UgKnBkZXYsIEVycm9yICoqZXJycCkNCj4gPg0KPiANCj4gVGhhbmtzDQo+
IA0KPiBFcmljDQoNCllpIExpdQ0K
