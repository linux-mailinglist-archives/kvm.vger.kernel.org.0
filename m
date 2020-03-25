Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB1192987
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 14:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCYNWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 09:22:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:52122 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgCYNWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 09:22:42 -0400
IronPort-SDR: dkA4E3+o6nHo2PHjRofSyLau3YkB66ZyHv45tot7yzNYF+I1jrzSWj5QPMtz4y1wGJzp5o9bk1
 KMrEzUGr72fw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 06:22:41 -0700
IronPort-SDR: V6eoHgS9mGrIbVaIZk6VgCBS018JKv91W09hu6Td3hnLLMwCeF5uYzbRxWwfHjcHYGsa88RWKV
 cVyeMCkYCnCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="326223822"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 25 Mar 2020 06:22:40 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 06:22:40 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Mar 2020 06:22:39 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Mar 2020 06:22:39 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.232]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 21:22:34 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: RE: [PATCH v1 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Topic: [PATCH v1 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Index: AQHWAEW8/T619bILS0iQ30uH62aieKhXkGUAgAG/ypA=
Date:   Wed, 25 Mar 2020 13:22:34 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2022DD@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-23-git-send-email-yi.l.liu@intel.com>
 <20200324183918.GG127076@xz-x1>
In-Reply-To: <20200324183918.GG127076@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
TWFyY2ggMjUsIDIwMjAgMjozOSBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMjIvMjJdIGludGVsX2lvbW11OiBtb2RpZnkg
eC1zY2FsYWJsZS1tb2RlIHRvIGJlIHN0cmluZw0KPiBvcHRpb24NCj4gDQo+IE9uIFN1biwgTWFy
IDIyLCAyMDIwIGF0IDA1OjM2OjE5QU0gLTA3MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+IEludGVs
IFZULWQgMy4wIGludHJvZHVjZXMgc2NhbGFibGUgbW9kZSwgYW5kIGl0IGhhcyBhIGJ1bmNoIG9m
DQo+ID4gY2FwYWJpbGl0aWVzIHJlbGF0ZWQgdG8gc2NhbGFibGUgbW9kZSB0cmFuc2xhdGlvbiwg
dGh1cyB0aGVyZSBhcmUgbXVsdGlwbGUNCj4gY29tYmluYXRpb25zLg0KPiA+IFdoaWxlIHRoaXMg
dklPTU1VIGltcGxlbWVudGF0aW9uIHdhbnRzIHNpbXBsaWZ5IGl0IGZvciB1c2VyIGJ5DQo+ID4g
cHJvdmlkaW5nIHR5cGljYWwgY29tYmluYXRpb25zLiBVc2VyIGNvdWxkIGNvbmZpZyBpdCBieQ0K
PiA+ICJ4LXNjYWxhYmxlLW1vZGUiIG9wdGlvbi4gVGhlIHVzYWdlIGlzIGFzIGJlbG93Og0KPiA+
DQo+ID4gIi1kZXZpY2UgaW50ZWwtaW9tbXUseC1zY2FsYWJsZS1tb2RlPVsibGVnYWN5InwibW9k
ZXJuInwib2ZmIl0iDQo+ID4NCj4gPiAgLSAibGVnYWN5IjogZ2l2ZXMgc3VwcG9ydCBmb3IgU0wg
cGFnZSB0YWJsZQ0KPiA+ICAtICJtb2Rlcm4iOiBnaXZlcyBzdXBwb3J0IGZvciBGTCBwYWdlIHRh
YmxlLCBwYXNpZCwgdmlydHVhbCBjb21tYW5kDQo+ID4gIC0gIm9mZiI6IG5vIHNjYWxhYmxlIG1v
ZGUgc3VwcG9ydA0KPiA+ICAtICBpZiBub3QgY29uZmlndXJlZCwgbWVhbnMgbm8gc2NhbGFibGUg
bW9kZSBzdXBwb3J0LCBpZiBub3QgcHJvcGVyDQo+ID4gICAgIGNvbmZpZ3VyZWQsIHdpbGwgdGhy
b3cgZXJyb3INCj4gPg0KPiA+IE5vdGU6IHRoaXMgcGF0Y2ggaXMgc3VwcG9zZWQgdG8gYmUgbWVy
Z2VkIHdoZW4gIHRoZSB3aG9sZSB2U1ZBIHBhdGNoDQo+ID4gc2VyaWVzIHdlcmUgbWVyZ2VkLg0K
PiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBK
YWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBY
dSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+ID4gQ2M6IFlpIFN1biA8eWkueS5zdW5AbGludXguaW50
ZWwuY29tPg0KPiA+IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiA+
IENjOiBSaWNoYXJkIEhlbmRlcnNvbiA8cnRoQHR3aWRkbGUubmV0Pg0KPiA+IENjOiBFZHVhcmRv
IEhhYmtvc3QgPGVoYWJrb3N0QHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBTdW4gPHlpLnku
c3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgaHcvaTM4Ni9pbnRlbF9pb21tdS5j
ICAgICAgICAgIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiAgaHcvaTM4
Ni9pbnRlbF9pb21tdV9pbnRlcm5hbC5oIHwgIDQgKysrKw0KPiA+IGluY2x1ZGUvaHcvaTM4Ni9p
bnRlbF9pb21tdS5oICB8ICAyICsrDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMzMgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9ody9pMzg2L2ludGVs
X2lvbW11LmMgYi9ody9pMzg2L2ludGVsX2lvbW11LmMgaW5kZXgNCj4gPiA3MmNkNzM5Li5lYTFm
NWM0IDEwMDY0NA0KPiA+IC0tLSBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYw0KPiA+ICsrKyBiL2h3
L2kzODYvaW50ZWxfaW9tbXUuYw0KPiA+IEBAIC00MTcxLDcgKzQxNzEsNyBAQCBzdGF0aWMgUHJv
cGVydHkgdnRkX3Byb3BlcnRpZXNbXSA9IHsNCj4gPiAgICAgIERFRklORV9QUk9QX1VJTlQ4KCJh
dy1iaXRzIiwgSW50ZWxJT01NVVN0YXRlLCBhd19iaXRzLA0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgVlREX0hPU1RfQUREUkVTU19XSURUSCksDQo+ID4gICAgICBERUZJTkVfUFJPUF9CT09M
KCJjYWNoaW5nLW1vZGUiLCBJbnRlbElPTU1VU3RhdGUsIGNhY2hpbmdfbW9kZSwNCj4gRkFMU0Up
LA0KPiA+IC0gICAgREVGSU5FX1BST1BfQk9PTCgieC1zY2FsYWJsZS1tb2RlIiwgSW50ZWxJT01N
VVN0YXRlLCBzY2FsYWJsZV9tb2RlLA0KPiBGQUxTRSksDQo+ID4gKyAgICBERUZJTkVfUFJPUF9T
VFJJTkcoIngtc2NhbGFibGUtbW9kZSIsIEludGVsSU9NTVVTdGF0ZSwNCj4gPiArIHNjYWxhYmxl
X21vZGVfc3RyKSwNCj4gPiAgICAgIERFRklORV9QUk9QX0JPT0woImRtYS1kcmFpbiIsIEludGVs
SU9NTVVTdGF0ZSwgZG1hX2RyYWluLCB0cnVlKSwNCj4gPiAgICAgIERFRklORV9QUk9QX0VORF9P
Rl9MSVNUKCksDQo+ID4gIH07DQo+ID4gQEAgLTQ4MDIsOCArNDgwMiwxMiBAQCBzdGF0aWMgdm9p
ZCB2dGRfaW5pdChJbnRlbElPTU1VU3RhdGUgKnMpDQo+ID4gICAgICB9DQo+ID4NCj4gPiAgICAg
IC8qIFRPRE86IHJlYWQgY2FwL2VjYXAgZnJvbSBob3N0IHRvIGRlY2lkZSB3aGljaCBjYXAgdG8g
YmUgZXhwb3NlZC4gKi8NCj4gPiAtICAgIGlmIChzLT5zY2FsYWJsZV9tb2RlKSB7DQo+ID4gKyAg
ICBpZiAocy0+c2NhbGFibGVfbW9kZSAmJiAhcy0+c2NhbGFibGVfbW9kZXJuKSB7DQo+ID4gICAg
ICAgICAgcy0+ZWNhcCB8PSBWVERfRUNBUF9TTVRTIHwgVlREX0VDQVBfU1JTIHwgVlREX0VDQVBf
U0xUUzsNCj4gPiArICAgIH0gZWxzZSBpZiAocy0+c2NhbGFibGVfbW9kZSAmJiBzLT5zY2FsYWJs
ZV9tb2Rlcm4pIHsNCj4gPiArICAgICAgICBzLT5lY2FwIHw9IFZURF9FQ0FQX1NNVFMgfCBWVERf
RUNBUF9TUlMgfCBWVERfRUNBUF9QQVNJRA0KPiA+ICsgICAgICAgICAgICAgICAgICAgfCBWVERf
RUNBUF9GTFRTIHwgVlREX0VDQVBfUFNTIHwgVlREX0VDQVBfVkNTOw0KPiA+ICsgICAgICAgIHMt
PnZjY2FwIHw9IFZURF9WQ0NBUF9QQVM7DQo+ID4gICAgICB9DQo+ID4NCj4gPiAgICAgIHZ0ZF9y
ZXNldF9jYWNoZXMocyk7DQo+ID4gQEAgLTQ5MzUsNiArNDkzOSwyNyBAQCBzdGF0aWMgYm9vbCB2
dGRfZGVjaWRlX2NvbmZpZyhJbnRlbElPTU1VU3RhdGUgKnMsDQo+IEVycm9yICoqZXJycCkNCj4g
PiAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ID4gICAgICB9DQo+ID4NCj4gPiArICAgIGlmIChz
LT5zY2FsYWJsZV9tb2RlX3N0ciAmJg0KPiA+ICsgICAgICAgIChzdHJjbXAocy0+c2NhbGFibGVf
bW9kZV9zdHIsICJtb2Rlcm4iKSAmJg0KPiA+ICsgICAgICAgICBzdHJjbXAocy0+c2NhbGFibGVf
bW9kZV9zdHIsICJsZWdhY3kiKSkpIHsNCj4gDQo+IFRoZSAnb2ZmJyBjaGVjayBpcyBtaXNzaW5n
Pw0KDQpPb3BzLCB5ZXMsIG15IGJhZC4gd2lsbCBhZGQgaXQuDQoNClJlZ2FyZHMsDQpZaSBMaXUN
Cg==
