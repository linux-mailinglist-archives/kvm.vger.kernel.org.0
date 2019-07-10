Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E147364618
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGJMSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:18:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:61755 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJMSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:18:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:18:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="159750015"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 05:18:03 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:18:03 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:18:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.55]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 20:18:01 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 07/18] hw/pci: add pci_device_bind/unbind_gpasid
Thread-Topic: [RFC v1 07/18] hw/pci: add pci_device_bind/unbind_gpasid
Thread-Index: AQHVM+ylJSuaOlaygUCdWu9uaMDG5abBdTOAgAJVvKA=
Date:   Wed, 10 Jul 2019 12:18:00 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A70A@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-8-git-send-email-yi.l.liu@intel.com>
 <1dbeec81-8fa6-4e5c-fc62-4a999387bd12@redhat.com>
In-Reply-To: <1dbeec81-8fa6-4e5c-fc62-4a999387bd12@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTMxZDUxNjYtOTAzNi00MWU3LTliMTMtMDBjNjdkYjQ4ZWZkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMEVkbzd6XC9pWUE5SVlrbzdpWXFXd0JsSCtyaDlEK3N3UjVMajdQQ0lNeUdTV1dNUUQ1Rm1cL1BERjBzdFRSNmU4In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQu
Y29tXQ0KPiBTZW50OiBUdWVzZGF5LCBKdWx5IDksIDIwMTkgNDozOCBQTQ0KPiBUbzogTGl1LCBZ
aSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+OyBxZW11LWRldmVsQG5vbmdudS5vcmc7IG1zdEByZWRo
YXQuY29tOw0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MSAwNy8xOF0gaHcvcGNpOiBhZGQgcGNpX2Rl
dmljZV9iaW5kL3VuYmluZF9ncGFzaWQNCj4gDQo+IEhpIExpdSwNCj4gDQo+IE9uIDcvNS8xOSAx
OjAxIFBNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIGFkZHMgdHdvIGNhbGxiYWNr
cyBwY2lfZGV2aWNlX2JpbmQvdW5iaW5kX2dwYXNpZCgpIHRvDQo+ID4gUENJUEFTSURPcHMuIFRo
ZXNlIHR3byBjYWxsYmFja3MgYXJlIHVzZWQgdG8gcHJvcGFnYXRlIGd1ZXN0IHBhc2lkDQo+ID4g
YmluZC91bmJpbmQgdG8gaG9zdC4gVGhlIGltcGxlbWVudGF0aW9ucyBvZiB0aGUgY2FsbGJhY2tz
IHdvdWxkIGJlDQo+ID4gZGV2aWNlIHBhc3N0aHJ1IG1vZHVsZXMgbGlrZSB2ZmlvLg0KPiA+DQo+
ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBKYWNvYiBQ
YW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBYdSA8cGV0
ZXJ4QHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4NCj4gPiBDYzogWWkgU3VuIDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IERh
dmlkIEdpYnNvbiA8ZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1Pg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGh3L3BjaS9w
Y2kuYyAgICAgICAgIHwgMzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGlu
Y2x1ZGUvaHcvcGNpL3BjaS5oIHwgIDkgKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwg
MzkgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2h3L3BjaS9wY2kuYyBiL2h3
L3BjaS9wY2kuYyBpbmRleCA3MTBmOWU5Li4yMjI5MjI5IDEwMDY0NA0KPiA+IC0tLSBhL2h3L3Bj
aS9wY2kuYw0KPiA+ICsrKyBiL2h3L3BjaS9wY2kuYw0KPiA+IEBAIC0yNjc2LDYgKzI2NzYsMzYg
QEAgaW50IHBjaV9kZXZpY2VfcmVxdWVzdF9wYXNpZF9mcmVlKFBDSUJ1cyAqYnVzLA0KPiBpbnQz
Ml90IGRldmZuLA0KPiA+ICAgICAgcmV0dXJuIC0xOw0KPiA+ICB9DQo+ID4NCj4gPiArdm9pZCBw
Y2lfZGV2aWNlX2JpbmRfZ3Bhc2lkKFBDSUJ1cyAqYnVzLCBpbnQzMl90IGRldmZuLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBncGFzaWRfYmluZF9kYXRhICpn
X2JpbmRfZGF0YSkNCj4gc3RydWN0IGdwYXNpZF9iaW5kX2RhdGEgaXMgZGVmaW5lZCBpbiBsaW51
eCBoZWFkZXJzIHNvIEkgdGhpbmsgeW91IHdvdWxkDQo+IG5lZWQ6ICNpZmRlZiBfX2xpbnV4X18N
Cg0KT29wcywgdGhhbmtzIGZvciB0aGUgcmVtaW5kLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
