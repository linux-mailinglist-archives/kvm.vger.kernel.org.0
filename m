Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D9A15B742
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 03:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgBMCov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 21:44:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:62751 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgBMCov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 21:44:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 18:44:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="257028350"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga004.fm.intel.com with ESMTP; 12 Feb 2020 18:44:50 -0800
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:44:50 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Feb 2020 18:44:49 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.222]) with mapi id 14.03.0439.000;
 Thu, 13 Feb 2020 10:44:47 +0800
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
Subject: RE: [RFC v3 13/25] intel_iommu: modify x-scalable-mode to be string
 option
Thread-Topic: [RFC v3 13/25] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Index: AQHV1p1OaPbyEoP2OUqqqdiprp3R66gV87yAgAFI6dCAAAyTAIABOICQ
Date:   Thu, 13 Feb 2020 02:44:47 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BBC3E@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-14-git-send-email-yi.l.liu@intel.com>
 <20200211194331.GK984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA573@SHSMSX104.ccr.corp.intel.com>
 <20200212160544.GC1083891@xz-x1>
In-Reply-To: <20200212160544.GC1083891@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGFjNDMyMmQtZWQxZS00MjU2LWE3MTgtYmQ3MTQyMTZiYzNmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS2FXMGZRVkoxUVdoOG9IbjVUc2pMR1RcLzZvXC9nSmR2M2V5UFR3c0ZmTE9pT3RPWFlVV1BlY1B3TGVHRUhVZURrIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBG
ZWJydWFyeSAxMywgMjAyMCAxMjowNiBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDEzLzI1XSBpbnRlbF9pb21tdTogbW9kaWZ5
IHgtc2NhbGFibGUtbW9kZSB0byBiZSBzdHJpbmcNCj4gb3B0aW9uDQo+IA0KPiBPbiBXZWQsIEZl
YiAxMiwgMjAyMCBhdCAwNzoyODoyNEFNICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiBG
cm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXks
IEZlYnJ1YXJ5IDEyLCAyMDIwIDM6NDQgQU0NCj4gPiA+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1
QGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDEzLzI1XSBpbnRlbF9pb21t
dTogbW9kaWZ5IHgtc2NhbGFibGUtbW9kZSB0bw0KPiA+ID4gYmUgc3RyaW5nIG9wdGlvbg0KPiA+
ID4NCj4gPiA+IE9uIFdlZCwgSmFuIDI5LCAyMDIwIGF0IDA0OjE2OjQ0QU0gLTA4MDAsIExpdSwg
WWkgTCB3cm90ZToNCj4gPiA+ID4gRnJvbTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4gPiA+ID4NCj4gPiA+ID4gSW50ZWwgVlQtZCAzLjAgaW50cm9kdWNlcyBzY2FsYWJsZSBtb2Rl
LCBhbmQgaXQgaGFzIGEgYnVuY2ggb2YNCj4gPiA+ID4gY2FwYWJpbGl0aWVzIHJlbGF0ZWQgdG8g
c2NhbGFibGUgbW9kZSB0cmFuc2xhdGlvbiwgdGh1cyB0aGVyZSBhcmUNCj4gPiA+ID4gbXVsdGlw
bGUNCj4gPiA+IGNvbWJpbmF0aW9ucy4NCj4gPiA+ID4gV2hpbGUgdGhpcyB2SU9NTVUgaW1wbGVt
ZW50YXRpb24gd2FudHMgc2ltcGxpZnkgaXQgZm9yIHVzZXIgYnkNCj4gPiA+ID4gcHJvdmlkaW5n
IHR5cGljYWwgY29tYmluYXRpb25zLiBVc2VyIGNvdWxkIGNvbmZpZyBpdCBieQ0KPiA+ID4gPiAi
eC1zY2FsYWJsZS1tb2RlIiBvcHRpb24uIFRoZSB1c2FnZSBpcyBhcyBiZWxvdzoNCj4gPiA+ID4N
Cj4gPiA+ID4gIi1kZXZpY2UgaW50ZWwtaW9tbXUseC1zY2FsYWJsZS1tb2RlPVsibGVnYWN5Inwi
bW9kZXJuIl0iDQo+ID4gPg0KPiA+ID4gTWF5YmUgYWxzbyAib2ZmIiB3aGVuIHNvbWVvbmUgd2Fu
dHMgdG8gZXhwbGljaXRseSBkaXNhYmxlIGl0Pw0KPiA+DQo+ID4gZW1tbSwgSSAgdGhpbmsgeC1z
Y2FsYWJsZS1tb2RlIHNob3VsZCBiZSBkaXNhYmxlZCBieSBkZWZhdWx0LiBJdCBpcw0KPiA+IGVu
YWJsZWQgb25seSB3aGVuICJsZWdhY3kiIG9yICJtb2Rlcm4iIGlzIGNvbmZpZ3VyZWQuIEknbSBm
aW5lIHRvIGFkZA0KPiA+ICJvZmYiIGFzIGFuIGV4cGxpY2l0IHdheSB0byB0dXJuIGl0IG9mZiBp
ZiB5b3UgdGhpbmsgaXQgaXMgbmVjZXNzYXJ5Lg0KPiA+IDotKQ0KPiANCj4gSXQncyBub3QgbmVj
ZXNzYXJ5LiAgSXQnbGwgYmUgbmVjZXNzYXJ5IHdoZW4gd2UgcmVtb3ZlICJ4LSIgYW5kIGNoYW5n
ZSB0aGUNCj4gZGVmYXVsdCB2YWx1ZS4gIEhvd2V2ZXIgaXQnbGwgYWx3YXlzIGJlIGdvb2QgdG8g
cHJvdmlkZSBhbGwgb3B0aW9ucyBleHBsaWNpdGx5IGluIHRoZQ0KPiBwYXJhbWV0ZXIgc3RhcnRp
bmcgZnJvbSB3aGVuIHdlIGRlc2lnbiBpdCwgaW1oby4gIEl0J3Mgc3RpbGwgZXhwZXJpbWVudGFs
LCBzby4uLg0KPiBZb3VyIGNhbGwuIDopDQoNCkdvdCBpdC4gTGV0IG1lIGFkZCBpdCBpbiBuZXh0
IHZlcnNpb24uIPCfmIoNCg0KUmVnYXJkcywNCllpIExpdQ0K
