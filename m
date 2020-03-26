Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380E51937F9
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 06:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgCZFlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 01:41:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:60146 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgCZFlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 01:41:46 -0400
IronPort-SDR: F+25qOFvDES74ji3xlsroDs+feQ3O9defFTaPFghtICqIt87Mq5CsguR7TLJnBvIVWs5vfOrdb
 CIehJ6DTMGfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 22:41:45 -0700
IronPort-SDR: iBX8LdSXxxYfNAhRBQW5Grwe3X3dZOWUnXkRczinwgceZxGCvjMrfHUPZbfrRyo5v/rcX+nL27
 QtkNFBs79JhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="240580674"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2020 22:41:44 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 22:41:44 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 22:41:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.201]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 13:41:40 +0800
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
Subject: RE: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Thread-Topic: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Thread-Index: AQHWAEW3X+65yqyUwUiucJlWzaqkgqhXjwWAgAHAhkCAAREEgA==
Date:   Thu, 26 Mar 2020 05:41:39 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A203E63@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
 <20200324183423.GE127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2022C5@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2022C5@SHSMSX104.ccr.corp.intel.com>
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

PiBGcm9tOiBMaXUsIFlpIEwNCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyNSwgMjAyMCA5OjIy
IFBNDQo+IFRvOiAnUGV0ZXIgWHUnIDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gU3ViamVjdDogUkU6
IFtQQVRDSCB2MSAyMC8yMl0gaW50ZWxfaW9tbXU6IHByb3BhZ2F0ZSBQQVNJRC1iYXNlZCBpb3Rs
Yg0KPiBpbnZhbGlkYXRpb24gdG8gaG9zdA0KPiANCj4gPiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4
QHJlZGhhdC5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyNSwgMjAyMCAyOjM0IEFN
DQo+ID4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggdjEgMjAvMjJdIGludGVsX2lvbW11OiBwcm9wYWdhdGUgUEFTSUQtYmFzZWQgaW90
bGINCj4gPiBpbnZhbGlkYXRpb24gdG8gaG9zdA0KPiA+DQo+ID4gT24gU3VuLCBNYXIgMjIsIDIw
MjAgYXQgMDU6MzY6MTdBTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gPiBUaGlzIHBhdGNo
IHByb3BhZ2F0ZXMgUEFTSUQtYmFzZWQgaW90bGIgaW52YWxpZGF0aW9uIHRvIGhvc3QuDQo+ID4g
Pg0KPiA+ID4gSW50ZWwgVlQtZCAzLjAgc3VwcG9ydHMgbmVzdGVkIHRyYW5zbGF0aW9uIGluIFBB
U0lEIGdyYW51bGFyLg0KPiA+ID4gR3Vlc3QgU1ZBIHN1cHBvcnQgY291bGQgYmUgaW1wbGVtZW50
ZWQgYnkgY29uZmlndXJpbmcgbmVzdGVkDQo+ID4gPiB0cmFuc2xhdGlvbiBvbiBzcGVjaWZpYyBQ
QVNJRC4gVGhpcyBpcyBhbHNvIGtub3duIGFzIGR1YWwgc3RhZ2UgRE1BDQo+ID4gPiB0cmFuc2xh
dGlvbi4NCj4gPiA+DQo+ID4gPiBVbmRlciBzdWNoIGNvbmZpZ3VyYXRpb24sIGd1ZXN0IG93bnMg
dGhlIEdWQS0+R1BBIHRyYW5zbGF0aW9uIHdoaWNoDQo+ID4gPiBpcyBjb25maWd1cmVkIGFzIGZp
cnN0IGxldmVsIHBhZ2UgdGFibGUgaW4gaG9zdCBzaWRlIGZvciBhIHNwZWNpZmljDQo+ID4gPiBw
YXNpZCwgYW5kIGhvc3Qgb3ducyBHUEEtPkhQQSB0cmFuc2xhdGlvbi4gQXMgZ3Vlc3Qgb3ducyBm
aXJzdCBsZXZlbA0KPiA+ID4gdHJhbnNsYXRpb24gdGFibGUsIHBpb3RsYiBpbnZhbGlkYXRpb24g
c2hvdWxkIGJlIHByb3BhZ2F0ZWQgdG8gaG9zdA0KPiA+ID4gc2luY2UgaG9zdCBJT01NVSB3aWxs
IGNhY2hlIGZpcnN0IGxldmVsIHBhZ2UgdGFibGUgcmVsYXRlZCBtYXBwaW5ncw0KPiA+ID4gZHVy
aW5nIERNQSBhZGRyZXNzIHRyYW5zbGF0aW9uLg0KPiA+ID4NCj4gPiA+IFRoaXMgcGF0Y2ggdHJh
cHMgdGhlIGd1ZXN0IFBBU0lELWJhc2VkIGlvdGxiIGZsdXNoIGFuZCBwcm9wYWdhdGUgaXQNCj4g
PiA+IHRvIGhvc3QuDQo+ID4gPg0KPiA+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50
ZWwuY29tPg0KPiA+ID4gQ2M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5j
b20+DQo+ID4gPiBDYzogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiA+ID4gQ2M6IFlp
IFN1biA8eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+ID4gQ2M6IFBhb2xvIEJvbnppbmkg
PHBib256aW5pQHJlZGhhdC5jb20+DQo+ID4gPiBDYzogUmljaGFyZCBIZW5kZXJzb24gPHJ0aEB0
d2lkZGxlLm5ldD4NCj4gPiA+IENjOiBFZHVhcmRvIEhhYmtvc3QgPGVoYWJrb3N0QHJlZGhhdC5j
b20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiAgaHcvaTM4Ni9pbnRlbF9pb21tdS5jICAgICAgICAgIHwgMTM5DQo+
ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiA+ICBody9p
Mzg2L2ludGVsX2lvbW11X2ludGVybmFsLmggfCAgIDcgKysrDQo+ID4gPiAgMiBmaWxlcyBjaGFu
Z2VkLCAxNDYgaW5zZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9ody9pMzg2
L2ludGVsX2lvbW11LmMgYi9ody9pMzg2L2ludGVsX2lvbW11LmMgaW5kZXgNCj4gPiA+IGI5YWMw
N2QuLjEwZDMxNGQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9ody9pMzg2L2ludGVsX2lvbW11LmMNCj4g
PiA+ICsrKyBiL2h3L2kzODYvaW50ZWxfaW9tbXUuYw0KPiA+ID4gQEAgLTMxMzQsMTUgKzMxMzQs
MTU0IEBAIHN0YXRpYyBib29sDQo+ID4gdnRkX3Byb2Nlc3NfcGFzaWRfZGVzYyhJbnRlbElPTU1V
U3RhdGUgKnMsDQo+ID4gPiAgICAgIHJldHVybiAocmV0ID09IDApID8gdHJ1ZSA6IGZhbHNlOyAg
fQ0KPiA+ID4NCj4gPiA+ICsvKioNCj4gPiA+ICsgKiBDYWxsZXIgb2YgdGhpcyBmdW5jdGlvbiBz
aG91bGQgaG9sZCBpb21tdV9sb2NrLg0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0YXRpYyB2b2lkIHZ0
ZF9pbnZhbGlkYXRlX3Bpb3RsYihJbnRlbElPTU1VU3RhdGUgKnMsDQo+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFZUREJ1cyAqdnRkX2J1cywNCj4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IGRldmZuLA0KPiA+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBEdWFsSU9NTVVTdGFnZTFDYWNoZQ0KPiA+ID4gKypzdGFn
ZTFfY2FjaGUpIHsNCj4gPiA+ICsgICAgVlRESG9zdElPTU1VQ29udGV4dCAqdnRkX2Rldl9pY3g7
DQo+ID4gPiArICAgIEhvc3RJT01NVUNvbnRleHQgKmhvc3RfaWN4Ow0KPiA+ID4gKw0KPiA+ID4g
KyAgICB2dGRfZGV2X2ljeCA9IHZ0ZF9idXMtPmRldl9pY3hbZGV2Zm5dOw0KPiA+ID4gKyAgICBp
ZiAoIXZ0ZF9kZXZfaWN4KSB7DQo+ID4gPiArICAgICAgICBnb3RvIG91dDsNCj4gPiA+ICsgICAg
fQ0KPiA+ID4gKyAgICBob3N0X2ljeCA9IHZ0ZF9kZXZfaWN4LT5ob3N0X2ljeDsNCj4gPiA+ICsg
ICAgaWYgKCFob3N0X2ljeCkgew0KPiA+ID4gKyAgICAgICAgZ290byBvdXQ7DQo+ID4gPiArICAg
IH0NCj4gPiA+ICsgICAgaWYgKGhvc3RfaW9tbXVfY3R4X2ZsdXNoX3N0YWdlMV9jYWNoZShob3N0
X2ljeCwgc3RhZ2UxX2NhY2hlKSkgew0KPiA+ID4gKyAgICAgICAgZXJyb3JfcmVwb3J0KCJDYWNo
ZSBmbHVzaCBmYWlsZWQiKTsNCj4gPg0KPiA+IEkgdGhpbmsgdGhpcyBzaG91bGQgbm90IGVhc2ls
eSBiZSB0cmlnZ2VyZWQgYnkgdGhlIGd1ZXN0LCBidXQganVzdCBpbg0KPiA+IGNhc2UuLi4gTGV0
J3MgdXNlDQo+ID4gZXJyb3JfcmVwb3J0X29uY2UoKSB0byBiZSBzYWZlLg0KPiANCj4gQWdyZWVk
Lg0KPiANCj4gPiA+ICsgICAgfQ0KPiA+ID4gK291dDoNCj4gPiA+ICsgICAgcmV0dXJuOw0KPiA+
ID4gK30NCj4gPiA+ICsNCj4gPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wgdnRkX3Bhc2lkX2NhY2hl
X3ZhbGlkKA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgVlREUEFTSURBZGRyZXNz
U3BhY2UgKnZ0ZF9wYXNpZF9hcykgew0KPiA+ID4gKyAgICByZXR1cm4gdnRkX3Bhc2lkX2FzLT5p
b21tdV9zdGF0ZSAmJg0KPiA+DQo+ID4gVGhpcyBjaGVjayBjYW4gYmUgZHJvcHBlZCBiZWNhdXNl
IGFsd2F5cyB0cnVlPw0KPiA+DQo+ID4gSWYgeW91IGFncmVlIHdpdGggYm90aCB0aGUgY2hhbmdl
cywgcGxlYXNlIGFkZDoNCj4gPg0KPiA+IFJldmlld2VkLWJ5OiBQZXRlciBYdSA8cGV0ZXJ4QHJl
ZGhhdC5jb20+DQo+IA0KPiBJIHRoaW5rIHRoZSBjb2RlIHNob3VsZCBlbnN1cmUgYWxsIHRoZSBw
YXNpZF9hcyBpbiBoYXNoIHRhYmxlIGlzIHZhbGlkLiBBbmQgd2UgY2FuDQo+IHNpbmNlIGFsbCB0
aGUgb3BlcmF0aW9ucyBhcmUgdW5kZXIgcHJvdGVjdGlvbiBvZiBpb21tdV9sb2NrLg0KPiANClBl
dGVyLA0KDQpJIHRoaW5rIG15IHJlcGx5IHdhcyB3cm9uZy4gcGFzaWRfYXMgaW4gaGFzIHRhYmxl
IG1heSBiZSBzdGFsZSBzaW5jZQ0KdGhlIHBlciBwYXNpZF9hcyBjYWNoZV9nZW4gbWF5IGJlIG5v
dCBpZGVudGljYWwgd2l0aCB0aGUgY2FjaGVfZ2VuDQppbiBpb21tdV9zdGF0ZS4gZS5nLiB2dGRf
cGFzaWRfY2FjaGVfcmVzZXQoKSBvbmx5IGluY3JlYXNlcyB0aGUNCmNhY2hlX2dlbiBpbiBpb21t
dV9zdGF0ZS4gU28gdGhlcmUgd2lsbCBiZSBwYXNpZF9hcyBpbiBoYXNoIHRhYmxlDQp3aGljaCBo
YXMgY2FjaGVkIHBhc2lkIGVudHJ5IGJ1dCBpdHMgY2FjaGVfZ2VuIGlzIG5vdCBlcXVhbCB0byB0
aGUNCm9uZSBpbiBpb21tdV9zdGF0ZS4gRm9yIHN1Y2ggcGFzaWRfYXMsIHdlIHNob3VsZCB0cmVh
dCBpdCBhcyBzdGFsZS4NClNvIEkgZ3Vlc3MgdGhlIHZ0ZF9wYXNpZF9jYWNoZV92YWxpZCgpIGlz
IHN0aWxsIG5lY2Vzc2FyeS4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo=
