Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC364192A09
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 14:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCYNgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 09:36:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:39168 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgCYNgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 09:36:12 -0400
IronPort-SDR: atE73rwK3j0ljv55dak7BBJ5piu0DLA7akgDSAu5q3AlGbtCkUQTvXVlt+oZEAae9s+VRonaoU
 KqGmX16bjhdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 06:36:09 -0700
IronPort-SDR: QRf3lID0hwB81zfyOIOAUHeMox6B/5y/+lqL16IMmskucAAE5ZvZxzmwzqWZ/GuY6/2qS2a3Qv
 GWfFQBX0DEWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="282137631"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2020 06:36:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 06:36:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Mar 2020 06:36:07 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Mar 2020 06:36:07 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.43]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 21:36:04 +0800
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
Subject: RE: [PATCH v1 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Thread-Topic: [PATCH v1 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Thread-Index: AQHWAEW7LEF9U5OYaU6Z5+49z1fjtahXjMmAgAHFm8A=
Date:   Wed, 25 Mar 2020 13:36:03 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A202340@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-20-git-send-email-yi.l.liu@intel.com>
 <20200324182623.GD127076@xz-x1>
In-Reply-To: <20200324182623.GD127076@xz-x1>
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
TWFyY2ggMjUsIDIwMjAgMjoyNiBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMTkvMjJdIGludGVsX2lvbW11OiBwcm9jZXNz
IFBBU0lELWJhc2VkIGlvdGxiIGludmFsaWRhdGlvbg0KPiANCj4gT24gU3VuLCBNYXIgMjIsIDIw
MjAgYXQgMDU6MzY6MTZBTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBh
ZGRzIHRoZSBiYXNpYyBQQVNJRC1iYXNlZCBpb3RsYiAocGlvdGxiKSBpbnZhbGlkYXRpb24NCj4g
PiBzdXBwb3J0LiBwaW90bGIgaXMgdXNlZCBkdXJpbmcgd2Fsa2luZyBJbnRlbCBWVC1kIDFzdCBs
ZXZlbCBwYWdlDQo+ID4gdGFibGUuIFRoaXMgcGF0Y2ggb25seSBhZGRzIHRoZSBiYXNpYyBwcm9j
ZXNzaW5nLiBEZXRhaWxlZCBoYW5kbGluZw0KPiA+IHdpbGwgYmUgYWRkZWQgaW4gbmV4dCBwYXRj
aC4NCj4gPg0KPiA+IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBD
YzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogUGV0
ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiA+IENjOiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4
LmludGVsLmNvbT4NCj4gPiBDYzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4N
Cj4gPiBDYzogUmljaGFyZCBIZW5kZXJzb24gPHJ0aEB0d2lkZGxlLm5ldD4NCj4gPiBDYzogRWR1
YXJkbyBIYWJrb3N0IDxlaGFia29zdEByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExp
dSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGh3L2kzODYvaW50ZWxf
aW9tbXUuYyAgICAgICAgICB8IDU3DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiA+ICBody9pMzg2L2ludGVsX2lvbW11X2ludGVybmFsLmggfCAxMyArKysr
KysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNzAgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYyBiL2h3L2kzODYvaW50ZWxfaW9tbXUu
YyBpbmRleA0KPiA+IGIwMDc3MTUuLmI5YWMwN2QgMTAwNjQ0DQo+ID4gLS0tIGEvaHcvaTM4Ni9p
bnRlbF9pb21tdS5jDQo+ID4gKysrIGIvaHcvaTM4Ni9pbnRlbF9pb21tdS5jDQo+ID4gQEAgLTMx
MzQsNiArMzEzNCw1OSBAQCBzdGF0aWMgYm9vbCB2dGRfcHJvY2Vzc19wYXNpZF9kZXNjKEludGVs
SU9NTVVTdGF0ZQ0KPiAqcywNCj4gPiAgICAgIHJldHVybiAocmV0ID09IDApID8gdHJ1ZSA6IGZh
bHNlOyAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHZ0ZF9waW90bGJfcGFzaWRfaW52YWxpZGF0
ZShJbnRlbElPTU1VU3RhdGUgKnMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB1aW50MTZfdCBkb21haW5faWQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB1aW50MzJfdCBwYXNpZCkgeyB9DQo+ID4gKw0KPiA+ICtzdGF0
aWMgdm9pZCB2dGRfcGlvdGxiX3BhZ2VfaW52YWxpZGF0ZShJbnRlbElPTU1VU3RhdGUgKnMsIHVp
bnQxNl90IGRvbWFpbl9pZCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1aW50
MzJfdCBwYXNpZCwgaHdhZGRyIGFkZHIsIHVpbnQ4X3QgYW0sDQo+ID4gK2Jvb2wgaWgpIHsgfQ0K
PiA+ICsNCj4gPiArc3RhdGljIGJvb2wgdnRkX3Byb2Nlc3NfcGlvdGxiX2Rlc2MoSW50ZWxJT01N
VVN0YXRlICpzLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBWVERJ
bnZEZXNjICppbnZfZGVzYykgew0KPiA+ICsgICAgdWludDE2X3QgZG9tYWluX2lkOw0KPiA+ICsg
ICAgdWludDMyX3QgcGFzaWQ7DQo+ID4gKyAgICB1aW50OF90IGFtOw0KPiA+ICsgICAgaHdhZGRy
IGFkZHI7DQo+ID4gKw0KPiA+ICsgICAgaWYgKChpbnZfZGVzYy0+dmFsWzBdICYgVlREX0lOVl9E
RVNDX1BJT1RMQl9SU1ZEX1ZBTDApIHx8DQo+ID4gKyAgICAgICAgKGludl9kZXNjLT52YWxbMV0g
JiBWVERfSU5WX0RFU0NfUElPVExCX1JTVkRfVkFMMSkpIHsNCj4gPiArICAgICAgICBlcnJvcl9y
ZXBvcnRfb25jZSgibm9uLXplcm8tZmllbGQtaW4tcGlvdGxiX2ludl9kZXNjIGhpOiAweCUiIFBS
SXg2NA0KPiA+ICsgICAgICAgICAgICAgICAgICAiIGxvOiAweCUiIFBSSXg2NCwgaW52X2Rlc2Mt
PnZhbFsxXSwgaW52X2Rlc2MtPnZhbFswXSk7DQo+ID4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0K
PiA+ICsgICAgfQ0KPiA+ICsNCj4gPiArICAgIGRvbWFpbl9pZCA9IFZURF9JTlZfREVTQ19QSU9U
TEJfRElEKGludl9kZXNjLT52YWxbMF0pOw0KPiA+ICsgICAgcGFzaWQgPSBWVERfSU5WX0RFU0Nf
UElPVExCX1BBU0lEKGludl9kZXNjLT52YWxbMF0pOw0KPiA+ICsgICAgc3dpdGNoIChpbnZfZGVz
Yy0+dmFsWzBdICYgVlREX0lOVl9ERVNDX0lPVExCX0cpIHsNCj4gPiArICAgIGNhc2UgVlREX0lO
Vl9ERVNDX1BJT1RMQl9BTExfSU5fUEFTSUQ6DQo+ID4gKyAgICAgICAgdnRkX3Bpb3RsYl9wYXNp
ZF9pbnZhbGlkYXRlKHMsIGRvbWFpbl9pZCwgcGFzaWQpOw0KPiA+ICsgICAgICAgIGJyZWFrOw0K
PiA+ICsNCj4gPiArICAgIGNhc2UgVlREX0lOVl9ERVNDX1BJT1RMQl9QU0lfSU5fUEFTSUQ6DQo+
ID4gKyAgICAgICAgYW0gPSBWVERfSU5WX0RFU0NfUElPVExCX0FNKGludl9kZXNjLT52YWxbMV0p
Ow0KPiA+ICsgICAgICAgIGFkZHIgPSAoaHdhZGRyKSBWVERfSU5WX0RFU0NfUElPVExCX0FERFIo
aW52X2Rlc2MtPnZhbFsxXSk7DQo+ID4gKyAgICAgICAgaWYgKGFtID4gVlREX01BTVYpIHsNCj4g
DQo+IEkgc2F3IHRoaXMgb2Ygc3BlYyAxMC40LjIsIE1BTVY6DQo+IA0KPiAgICAgICAgIEluZGVw
ZW5kZW50IG9mIHZhbHVlIHJlcG9ydGVkIGluIHRoaXMgZmllbGQsIGltcGxlbWVudGF0aW9ucw0K
PiAgICAgICAgIHN1cHBvcnRpbmcgU01UUyBtdXN0IHN1cHBvcnQgYWRkcmVzcy1zZWxlY3RpdmUg
UEFTSUQtYmFzZWQNCj4gICAgICAgICBJT1RMQiBpbnZhbGlkYXRpb25zIChwX2lvdGxiX2ludl9k
c2MpIHdpdGggYW55IGRlZmluZWQgYWRkcmVzcw0KPiAgICAgICAgIG1hc2suDQo+IA0KPiBEb2Vz
IGl0IG1lYW4gd2Ugc2hvdWxkIGV2ZW4gc3VwcG9ydCBsYXJnZXIgQU0/DQo+IA0KPiBCZXNpZGVz
IHRoYXQsIHRoZSBwYXRjaCBsb29rcyBnb29kIHRvIG1lLg0KDQpJIGRvbid0IHRoaW5rIHNvLiBU
aGlzIGZpZWxkIGlzIGZvciBzZWNvbmQtbGV2ZWwgdGFibGUgaW4gc2NhbGFibGUgbW9kZQ0KYW5k
IHRoZSB0cmFuc2xhdGlvbiB0YWJsZSBpbiBsZWdhY3kgbW9kZS4gRm9yIGZpcnN0LWxldmVsIHRh
YmxlLCBpdCBhbHdheXMNCnN1cHBvcnRzIHBhZ2Ugc2VsZWN0aXZlIGludmFsaWRhdGlvbiBhbmQg
YWxsIHRoZSBzdXBwb3J0ZWQgbWFza3MNCnJlZ2FyZGxlc3Mgb2YgdGhlIFBTSSBzdXBwb3J0IGJp
dCBhbmQgdGhlIE1BTVYgZmllbGQgaW4gdGhlIENBUF9SRUcuDQoNClJlZ2FyZHMsDQpZaSBMaXUN
Cg0K
