Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2C7193618
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCZCmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 22:42:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:9931 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbgCZCmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 22:42:35 -0400
IronPort-SDR: UwGQ2gI6uzRUBSSrgodB9Ht1bMpHbAL1hJqsgKgKJxqfjF820gSQPYsspdUUsBtMW/ia8H1h6s
 zI5DifMajqVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 19:42:34 -0700
IronPort-SDR: EH2QIrFI6L3Ssesw9N5jV6GuYhRPy0sqgl7jyDBuy6Mtlcn9lGHZUSxKROhSWOUmbnmNnDloTj
 NvUjzsy6iI1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="240550653"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2020 19:42:34 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 19:42:34 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Mar 2020 19:42:33 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Mar 2020 19:42:33 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.144]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 10:42:29 +0800
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
Subject: RE: [PATCH v1 17/22] intel_iommu: do not pass down pasid bind for
 PASID #0
Thread-Topic: [PATCH v1 17/22] intel_iommu: do not pass down pasid bind for
 PASID #0
Thread-Index: AQHWAEW2o830y533sUCksKmHK8WrT6hXiSsAgAGL4GD//9PKgIABRuXA
Date:   Thu, 26 Mar 2020 02:42:29 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A202EE2@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-18-git-send-email-yi.l.liu@intel.com>
 <20200324181326.GB127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A201FC7@SHSMSX104.ccr.corp.intel.com>
 <20200325151205.GD354390@xz-x1>
In-Reply-To: <20200325151205.GD354390@xz-x1>
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
TWFyY2ggMjUsIDIwMjAgMTE6MTIgUE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwu
Y29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDE3LzIyXSBpbnRlbF9pb21tdTogZG8gbm90
IHBhc3MgZG93biBwYXNpZCBiaW5kIGZvciBQQVNJRA0KPiAjMA0KPiANCj4gT24gV2VkLCBNYXIg
MjUsIDIwMjAgYXQgMTA6NDI6MjVBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+ID4gRnJv
bTogUGV0ZXIgWHUgPCBwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwg
TWFyY2ggMjUsIDIwMjAgMjoxMyBBTQ0KPiA+ID4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50
ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAxNy8yMl0gaW50ZWxfaW9tbXU6
IGRvIG5vdCBwYXNzIGRvd24gcGFzaWQNCj4gPiA+IGJpbmQgZm9yIFBBU0lEDQo+ID4gPiAjMA0K
PiA+ID4NCj4gPiA+IE9uIFN1biwgTWFyIDIyLCAyMDIwIGF0IDA1OjM2OjE0QU0gLTA3MDAsIExp
dSBZaSBMIHdyb3RlOg0KPiA+ID4gPiBSSURfUEFTSUQgZmllbGQgd2FzIGludHJvZHVjZWQgaW4g
VlQtZCAzLjAgc3BlYywgaXQgaXMgdXNlZCBmb3INCj4gPiA+ID4gRE1BIHJlcXVlc3RzIHcvbyBQ
QVNJRCBpbiBzY2FsYWJsZSBtb2RlIFZULWQuIEl0IGlzIGFsc28ga25vd24gYXMgSU9WQS4NCj4g
PiA+ID4gQW5kIGluIFZULWQgMy4xIHNwZWMsIHRoZXJlIGlzIGRlZmluaXRpb24gb24gaXQ6DQo+
ID4gPiA+DQo+ID4gPiA+ICJJbXBsZW1lbnRhdGlvbnMgbm90IHN1cHBvcnRpbmcgUklEX1BBU0lE
IGNhcGFiaWxpdHkgKEVDQVBfUkVHLlJQUw0KPiA+ID4gPiBpcyAwYiksIHVzZSBhIFBBU0lEIHZh
bHVlIG9mIDAgdG8gcGVyZm9ybSBhZGRyZXNzIHRyYW5zbGF0aW9uIGZvcg0KPiA+ID4gPiByZXF1
ZXN0cyB3aXRob3V0IFBBU0lELiINCj4gPiA+ID4NCj4gPiA+ID4gVGhpcyBwYXRjaCBhZGRzIGEg
Y2hlY2sgYWdhaW5zdCB0aGUgUEFTSURzIHdoaWNoIGFyZSBnb2luZyB0byBiZQ0KPiA+ID4gPiBi
b3VuZCB0byBkZXZpY2UuIEZvciBQQVNJRCAjMCwgaXQgaXMgbm90IG5lY2Vzc2FyeSB0byBwYXNz
IGRvd24NCj4gPiA+ID4gcGFzaWQgYmluZCByZXF1ZXN0IGZvciBpdCBzaW5jZSBQQVNJRCAjMCBp
cyB1c2VkIGFzIFJJRF9QQVNJRCBmb3INCj4gPiA+ID4gRE1BIHJlcXVlc3RzIHdpdGhvdXQgcGFz
aWQuIEZ1cnRoZXIgcmVhc29uIGlzIGN1cnJlbnQgSW50ZWwgdklPTU1VDQo+ID4gPiA+IHN1cHBv
cnRzIGdJT1ZBIGJ5IHNoYWRvd2luZyBndWVzdCAybmQgbGV2ZWwgcGFnZSB0YWJsZS4gSG93ZXZl
ciwNCj4gPiA+ID4gaW4gZnV0dXJlLCBpZiBndWVzdCBJT01NVSBkcml2ZXIgdXNlcyAxc3QgbGV2
ZWwgcGFnZSB0YWJsZSB0bw0KPiA+ID4gPiBzdG9yZSBJT1ZBIG1hcHBpbmdzLCB0aGVuIGd1ZXN0
IElPVkEgc3VwcG9ydCB3aWxsIGFsc28gYmUgZG9uZSB2aWENCj4gPiA+ID4gbmVzdGVkIHRyYW5z
bGF0aW9uLiBXaGVuIGdJT1ZBIGlzIG92ZXIgRkxQVCwgdGhlbiB2SU9NTVUgc2hvdWxkDQo+ID4g
PiA+IHBhc3MgZG93biB0aGUgcGFzaWQgYmluZCByZXF1ZXN0IGZvciBQQVNJRCAjMCB0byBob3N0
LCBob3N0IG5lZWRzDQo+ID4gPiA+IHRvIGJpbmQgdGhlIGd1ZXN0IElPVkEgcGFnZSB0YWJsZSB0
byBhIHByb3BlciBQQVNJRC4gZS5nIFBBU0lEDQo+ID4gPiA+IHZhbHVlIGluIFJJRF9QQVNJRCBm
aWVsZCBmb3IgUEYvVkYgaWYgRUNBUF9SRUcuUlBTIGlzIGNsZWFyIG9yDQo+ID4gPiA+IGRlZmF1
bHQgUEFTSUQgZm9yIEFESSAoQXNzaWduYWJsZSBEZXZpY2UgSW50ZXJmYWNlIGluIFNjYWxhYmxl
IElPViBzb2x1dGlvbikuDQo+ID4gPiA+DQo+ID4gPiA+IElPVkEgb3ZlciBGTFBUIHN1cHBvcnQg
b24gSW50ZWwgVlQtZDoNCj4gPiA+ID4gaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTkvOS8yMy8y
OTcNCj4gPiA+ID4NCj4gPiA+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29t
Pg0KPiA+ID4gPiBDYzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4N
Cj4gPiA+ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ2M6IFlp
IFN1biA8eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+ID4gPiBDYzogUGFvbG8gQm9uemlu
aSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ2M6IFJpY2hhcmQgSGVuZGVyc29uIDxy
dGhAdHdpZGRsZS5uZXQ+DQo+ID4gPiA+IENjOiBFZHVhcmRvIEhhYmtvc3QgPGVoYWJrb3N0QHJl
ZGhhdC5jb20+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgaHcvaTM4Ni9pbnRlbF9pb21tdS5jIHwgMTAg
KysrKysrKysrKw0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4g
PiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2h3L2kzODYvaW50ZWxfaW9tbXUuYyBiL2h3L2kz
ODYvaW50ZWxfaW9tbXUuYyBpbmRleA0KPiA+ID4gPiAxZTBjY2RlLi5iMDA3NzE1IDEwMDY0NA0K
PiA+ID4gPiAtLS0gYS9ody9pMzg2L2ludGVsX2lvbW11LmMNCj4gPiA+ID4gKysrIGIvaHcvaTM4
Ni9pbnRlbF9pb21tdS5jDQo+ID4gPiA+IEBAIC0xODg2LDYgKzE4ODYsMTYgQEAgc3RhdGljIGlu
dA0KPiA+ID4gPiB2dGRfYmluZF9ndWVzdF9wYXNpZChJbnRlbElPTU1VU3RhdGUgKnMsDQo+ID4g
PiBWVERCdXMgKnZ0ZF9idXMsDQo+ID4gPiA+ICAgICAgc3RydWN0IGlvbW11X2dwYXNpZF9iaW5k
X2RhdGEgKmdfYmluZF9kYXRhOw0KPiA+ID4gPiAgICAgIGludCByZXQgPSAtMTsNCj4gPiA+ID4N
Cj4gPiA+ID4gKyAgICBpZiAocGFzaWQgPCBWVERfTUlOX0hQQVNJRCkgew0KPiA+ID4gPiArICAg
ICAgICAvKg0KPiA+ID4gPiArICAgICAgICAgKiBJZiBwYXNpZCA8IFZURF9IUEFTSURfTUlOLCB0
aGlzIHBhc2lkIGlzIG5vdCBhbGxvY2F0ZWQNCj4gPiA+DQo+ID4gPiBzL1ZURF9IUEFTSURfTUlO
L1ZURF9NSU5fSFBBU0lELy4NCj4gPg0KPiA+IEdvdCBpdC4NCj4gPg0KPiA+ID4NCj4gPiA+ID4g
KyAgICAgICAgICogZnJvbSBob3N0LiBObyBuZWVkIHRvIHBhc3MgZG93biB0aGUgY2hhbmdlcyBv
biBpdCB0byBob3N0Lg0KPiA+ID4gPiArICAgICAgICAgKiBUT0RPOiB3aGVuIElPVkEgb3ZlciBG
TFBUIGlzIHJlYWR5LCB0aGlzIHN3aXRjaCBzaG91bGQgYmUNCj4gPiA+ID4gKyAgICAgICAgICog
cmVmaW5lZC4NCj4gPiA+DQo+ID4gPiBXaGF0IHdpbGwgaGFwcGVuIGlmIHdpdGhvdXQgdGhpcyBw
YXRjaD8gIElzIGl0IGEgbXVzdD8NCj4gPg0KPiA+IEJlZm9yZSBnSU9WQSBpcyBzdXBwb3J0ZWQg
YnkgbmVzdGVkIHRyYW5zbGF0aW9uLCBpdCBpcyBhIG11c3QuIFRoaXMNCj4gPiByZXF1aXJlcyBJ
T1ZBIG92ZXIgMXN0IGxldmVsIHBhZ2UgdGFibGUgaXMgcmVhZHkgaW4gZ3Vlc3Qga2VybmVsLCBh
bHNvDQo+ID4gcmVxdWlyZXMgdGhlIFFFTVUvVkZJTyBzdXBwb3J0cyB0byBiaW5kIHRoZSBndWVz
dCBJT1ZBIHBhZ2UgdGFibGUgdG8gaG9zdC4NCj4gPiBDdXJyZW50bHksIGd1ZXN0IGtlcm5lbCBz
aWRlIGlzIHJlYWR5LiBIb3dldmVyLCBRRU1VIGFuZCBWRklPIHNpZGUgaXMNCj4gPiBub3QuDQo+
IA0KPiBPSzoNCj4gDQo+IFJldmlld2VkLWJ5OiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+
DQoNCnRoYW5rcywNCg0KUmVnYXJkcywNCllpIExpdQ0K
