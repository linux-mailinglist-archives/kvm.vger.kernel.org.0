Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8403615A1FC
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgBLH2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:28:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:64739 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgBLH2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 02:28:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 23:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="380685886"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 11 Feb 2020 23:28:31 -0800
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:28:31 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:28:25 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.158]) with mapi id 14.03.0439.000;
 Wed, 12 Feb 2020 15:28:24 +0800
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
Thread-Index: AQHV1p1OaPbyEoP2OUqqqdiprp3R66gV87yAgAFI6dA=
Date:   Wed, 12 Feb 2020 07:28:24 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BA573@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-14-git-send-email-yi.l.liu@intel.com>
 <20200211194331.GK984290@xz-x1>
In-Reply-To: <20200211194331.GK984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDUyZGRjOWEtYmVjMi00ODJlLTg3NzYtZjkxMmNhOTVkNmVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNTZKVkhKSWVLc0lXZjZmUzhCT2tpWU1WOTFYR1c3SWpPUnU4ZUJlUlVUbmtiRkl3ekdNcG5uZVFRVGRkMDBUWCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
RmVicnVhcnkgMTIsIDIwMjAgMzo0NCBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDEzLzI1XSBpbnRlbF9pb21tdTogbW9kaWZ5
IHgtc2NhbGFibGUtbW9kZSB0byBiZSBzdHJpbmcNCj4gb3B0aW9uDQo+IA0KPiBPbiBXZWQsIEph
biAyOSwgMjAyMCBhdCAwNDoxNjo0NEFNIC0wODAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gRnJv
bTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPg0KPiA+IEludGVsIFZULWQgMy4w
IGludHJvZHVjZXMgc2NhbGFibGUgbW9kZSwgYW5kIGl0IGhhcyBhIGJ1bmNoIG9mDQo+ID4gY2Fw
YWJpbGl0aWVzIHJlbGF0ZWQgdG8gc2NhbGFibGUgbW9kZSB0cmFuc2xhdGlvbiwgdGh1cyB0aGVy
ZSBhcmUgbXVsdGlwbGUNCj4gY29tYmluYXRpb25zLg0KPiA+IFdoaWxlIHRoaXMgdklPTU1VIGlt
cGxlbWVudGF0aW9uIHdhbnRzIHNpbXBsaWZ5IGl0IGZvciB1c2VyIGJ5DQo+ID4gcHJvdmlkaW5n
IHR5cGljYWwgY29tYmluYXRpb25zLiBVc2VyIGNvdWxkIGNvbmZpZyBpdCBieQ0KPiA+ICJ4LXNj
YWxhYmxlLW1vZGUiIG9wdGlvbi4gVGhlIHVzYWdlIGlzIGFzIGJlbG93Og0KPiA+DQo+ID4gIi1k
ZXZpY2UgaW50ZWwtaW9tbXUseC1zY2FsYWJsZS1tb2RlPVsibGVnYWN5InwibW9kZXJuIl0iDQo+
IA0KPiBNYXliZSBhbHNvICJvZmYiIHdoZW4gc29tZW9uZSB3YW50cyB0byBleHBsaWNpdGx5IGRp
c2FibGUgaXQ/DQoNCmVtbW0sIEkgIHRoaW5rIHgtc2NhbGFibGUtbW9kZSBzaG91bGQgYmUgZGlz
YWJsZWQgYnkgZGVmYXVsdC4gSXQgaXMgZW5hYmxlZA0Kb25seSB3aGVuICJsZWdhY3kiIG9yICJt
b2Rlcm4iIGlzIGNvbmZpZ3VyZWQuIEknbSBmaW5lIHRvIGFkZCAib2ZmIiBhcyBhbg0KZXhwbGlj
aXQgd2F5IHRvIHR1cm4gaXQgb2ZmIGlmIHlvdSB0aGluayBpdCBpcyBuZWNlc3NhcnkuIDotKQ0K
DQo+ID4NCj4gPiAgLSAibGVnYWN5IjogZ2l2ZXMgc3VwcG9ydCBmb3IgU0wgcGFnZSB0YWJsZQ0K
PiA+ICAtICJtb2Rlcm4iOiBnaXZlcyBzdXBwb3J0IGZvciBGTCBwYWdlIHRhYmxlLCBwYXNpZCwg
dmlydHVhbCBjb21tYW5kDQo+ID4gIC0gIGlmIG5vdCBjb25maWd1cmVkLCBtZWFucyBubyBzY2Fs
YWJsZSBtb2RlIHN1cHBvcnQsIGlmIG5vdCBwcm9wZXINCj4gPiAgICAgY29uZmlndXJlZCwgd2ls
bCB0aHJvdyBlcnJvcg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwu
Y29tPg0KPiA+IENjOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0K
PiA+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+ID4gQ2M6IFlpIFN1biA8eWku
eS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPg0KPiA+IENjOiBSaWNoYXJkIEhlbmRlcnNvbiA8cnRoQHR3aWRkbGUubmV0Pg0K
PiA+IENjOiBFZHVhcmRvIEhhYmtvc3QgPGVoYWJrb3N0QHJlZGhhdC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgaHcvaTM4
Ni9pbnRlbF9pb21tdS5jICAgICAgICAgIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysrKy0t
DQo+ID4gIGh3L2kzODYvaW50ZWxfaW9tbXVfaW50ZXJuYWwuaCB8ICAzICsrKw0KPiA+IGluY2x1
ZGUvaHcvaTM4Ni9pbnRlbF9pb21tdS5oICB8ICAyICsrDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwg
MzAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9o
dy9pMzg2L2ludGVsX2lvbW11LmMgYi9ody9pMzg2L2ludGVsX2lvbW11LmMgaW5kZXgNCj4gPiAx
YzFlYjdmLi4zM2JlNDBjIDEwMDY0NA0KPiA+IC0tLSBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYw0K
PiA+ICsrKyBiL2h3L2kzODYvaW50ZWxfaW9tbXUuYw0KPiA+IEBAIC0zMDc4LDcgKzMwNzgsNyBA
QCBzdGF0aWMgUHJvcGVydHkgdnRkX3Byb3BlcnRpZXNbXSA9IHsNCj4gPiAgICAgIERFRklORV9Q
Uk9QX1VJTlQ4KCJhdy1iaXRzIiwgSW50ZWxJT01NVVN0YXRlLCBhd19iaXRzLA0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgVlREX0hPU1RfQUREUkVTU19XSURUSCksDQo+ID4gICAgICBERUZJ
TkVfUFJPUF9CT09MKCJjYWNoaW5nLW1vZGUiLCBJbnRlbElPTU1VU3RhdGUsIGNhY2hpbmdfbW9k
ZSwNCj4gRkFMU0UpLA0KPiA+IC0gICAgREVGSU5FX1BST1BfQk9PTCgieC1zY2FsYWJsZS1tb2Rl
IiwgSW50ZWxJT01NVVN0YXRlLCBzY2FsYWJsZV9tb2RlLA0KPiBGQUxTRSksDQo+ID4gKyAgICBE
RUZJTkVfUFJPUF9TVFJJTkcoIngtc2NhbGFibGUtbW9kZSIsIEludGVsSU9NTVVTdGF0ZSwNCj4g
PiArIHNjYWxhYmxlX21vZGVfc3RyKSwNCj4gPiAgICAgIERFRklORV9QUk9QX0JPT0woImRtYS1k
cmFpbiIsIEludGVsSU9NTVVTdGF0ZSwgZG1hX2RyYWluLCB0cnVlKSwNCj4gPiAgICAgIERFRklO
RV9QUk9QX0VORF9PRl9MSVNUKCksDQo+ID4gIH07DQo+ID4gQEAgLTM3MDgsOCArMzcwOCwxMSBA
QCBzdGF0aWMgdm9pZCB2dGRfaW5pdChJbnRlbElPTU1VU3RhdGUgKnMpDQo+ID4gICAgICB9DQo+
ID4NCj4gPiAgICAgIC8qIFRPRE86IHJlYWQgY2FwL2VjYXAgZnJvbSBob3N0IHRvIGRlY2lkZSB3
aGljaCBjYXAgdG8gYmUgZXhwb3NlZC4gKi8NCj4gPiAtICAgIGlmIChzLT5zY2FsYWJsZV9tb2Rl
KSB7DQo+ID4gKyAgICBpZiAocy0+c2NhbGFibGVfbW9kZSAmJiAhcy0+c2NhbGFibGVfbW9kZXJu
KSB7DQo+ID4gICAgICAgICAgcy0+ZWNhcCB8PSBWVERfRUNBUF9TTVRTIHwgVlREX0VDQVBfU1JT
IHwgVlREX0VDQVBfU0xUUzsNCj4gPiArICAgIH0gZWxzZSBpZiAocy0+c2NhbGFibGVfbW9kZSAm
JiBzLT5zY2FsYWJsZV9tb2Rlcm4pIHsNCj4gPiArICAgICAgICBzLT5lY2FwIHw9IFZURF9FQ0FQ
X1NNVFMgfCBWVERfRUNBUF9TUlMgfCBWVERfRUNBUF9QQVNJRA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgfCBWVERfRUNBUF9GTFRTIHwgVlREX0VDQVBfUFNTOw0KPiANCj4gVGhpcyBwYXRjaCBt
aWdodCBiZSBnb29kIHRvIGJlIHRoZSBsYXN0IG9uZSBhZnRlciBhbGwgdGhlIGltcGxzIGFyZSBy
ZWFkeS4NCg0KT2gsIHllcy4gTGV0IG1lIHJlb3JkZXIgaXQgaW4gbmV4dCB2ZXJzaW9uLg0KDQo+
ID4gICAgICB9DQo+ID4NCj4gPiAgICAgIHZ0ZF9yZXNldF9jYWNoZXMocyk7DQo+ID4gQEAgLTM4
NDUsNiArMzg0OCwyNiBAQCBzdGF0aWMgYm9vbCB2dGRfZGVjaWRlX2NvbmZpZyhJbnRlbElPTU1V
U3RhdGUgKnMsDQo+IEVycm9yICoqZXJycCkNCj4gPiAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+
ID4gICAgICB9DQo+ID4NCj4gPiArICAgIGlmIChzLT5zY2FsYWJsZV9tb2RlX3N0ciAmJg0KPiA+
ICsgICAgICAgIChzdHJjbXAocy0+c2NhbGFibGVfbW9kZV9zdHIsICJtb2Rlcm4iKSAmJg0KPiA+
ICsgICAgICAgICBzdHJjbXAocy0+c2NhbGFibGVfbW9kZV9zdHIsICJsZWdhY3kiKSkpIHsNCj4g
PiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJJbnZhbGlkIHgtc2NhbGFibGUtbW9kZSBjb25m
aWciKTsNCj4gDQo+IE1heWJlICIuLi4sIFBsZWFzZSB1c2UgJ21vZGVybicsICdsZWdhY3knLCBv
ciAnb2ZmJy4iIHRvIHNob3cgb3B0aW9ucy4NCg0KR290IGl0Lg0KDQpUaGFua3MsDQpZaSBMaXUN
Cg==
