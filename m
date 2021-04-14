Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4893635EDEF
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 08:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349539AbhDNG5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 02:57:45 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3400 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbhDNG5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 02:57:02 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FKtVG4wMfz5pKd;
        Wed, 14 Apr 2021 14:53:42 +0800 (CST)
Received: from dggpemm000002.china.huawei.com (7.185.36.174) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 14 Apr 2021 14:56:35 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggpemm000002.china.huawei.com (7.185.36.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 14:56:33 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Wed, 14 Apr 2021 07:56:31 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     wangxingang <wangxingang5@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        zhukeqian <zhukeqian1@huawei.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        lushenming <lushenming@huawei.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        jiangkunkun <jiangkunkun@huawei.com>
Subject: RE: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHXLsOlRqEdZyhfJE+gp2mWu6BauqqzP5GAgABYNgA=
Date:   Wed, 14 Apr 2021 06:56:31 +0000
Message-ID: <f6b0bcd156e04d0f958cf79a50ac69e2@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
 <55930e46-0a45-0d43-b34e-432cf332b42c@huawei.com>
In-Reply-To: <55930e46-0a45-0d43-b34e-432cf332b42c@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.32]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogd2FuZ3hpbmdhbmcNCj4g
U2VudDogMTQgQXByaWwgMjAyMSAwMzozNg0KPiBUbzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckBy
ZWRoYXQuY29tPjsgZXJpYy5hdWdlci5wcm9AZ21haWwuY29tOw0KPiBqZWFuLXBoaWxpcHBlQGxp
bmFyby5vcmc7IGlvbW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnOw0KPiBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBrdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1OyB3aWxsQGtlcm5lbC5vcmc7IG1hekBrZXJuZWwub3JnOw0KPiByb2Jp
bi5tdXJwaHlAYXJtLmNvbTsgam9yb0A4Ynl0ZXMub3JnOyBhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbTsNCj4gdG5Ac2VtaWhhbGYuY29tOyB6aHVrZXFpYW4gPHpodWtlcWlhbjFAaHVhd2VpLmNv
bT4NCj4gQ2M6IGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tOyB5aS5sLmxpdUBpbnRlbC5j
b207IHpoYW5nZmVpLmdhb0BsaW5hcm8ub3JnOw0KPiB6aGFuZ2ZlaS5nYW9AZ21haWwuY29tOyB2
aXZlay5nYXV0YW1AYXJtLmNvbTsgU2hhbWVlcmFsaSBLb2xvdGh1bQ0KPiBUaG9kaSA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsgeXV6ZW5naHVpDQo+IDx5dXplbmdodWlA
aHVhd2VpLmNvbT47IG5pY29sZW90c3VrYUBnbWFpbC5jb207IGx1c2hlbm1pbmcNCj4gPGx1c2hl
bm1pbmdAaHVhd2VpLmNvbT47IHZzZXRoaUBudmlkaWEuY29tOyBjaGVueGlhbmcgKE0pDQo+IDxj
aGVueGlhbmc2NkBoaXNpbGljb24uY29tPjsgdmR1bXBhQG52aWRpYS5jb207IGppYW5na3Vua3Vu
DQo+IDxqaWFuZ2t1bmt1bkBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxNSAw
MC8xMl0gU01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9NTVUgcGFydCkNCj4gDQo+IEhpIEVy
aWMsIEplYW4tUGhpbGlwcGUNCj4gDQo+IE9uIDIwMjEvNC8xMSAxOToxMiwgRXJpYyBBdWdlciB3
cm90ZToNCj4gPiBTTU1VdjMgTmVzdGVkIFN0YWdlIFNldHVwIChJT01NVSBwYXJ0KQ0KPiA+DQo+
ID4gVGhpcyBzZXJpZXMgYnJpbmdzIHRoZSBJT01NVSBwYXJ0IG9mIEhXIG5lc3RlZCBwYWdpbmcg
c3VwcG9ydA0KPiA+IGluIHRoZSBTTU1VdjMuIFRoZSBWRklPIHBhcnQgaXMgc3VibWl0dGVkIHNl
cGFyYXRlbHkuDQo+ID4NCj4gPiBUaGlzIGlzIGJhc2VkIG9uIEplYW4tUGhpbGlwcGUncw0KPiA+
IFtQQVRDSCB2MTQgMDAvMTBdIGlvbW11OiBJL08gcGFnZSBmYXVsdHMgZm9yIFNNTVV2Mw0KPiA+
IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2FybS1rZXJuZWwvbXNnODg2NTE4Lmh0bWwN
Cj4gPiAoaW5jbHVkaW5nIHRoZSBwYXRjaGVzIHRoYXQgd2VyZSBub3QgcHVsbGVkIGZvciA1LjEz
KQ0KPiA+DQo+ID4gVGhlIElPTU1VIEFQSSBpcyBleHRlbmRlZCB0byBzdXBwb3J0IDIgbmV3IEFQ
SSBmdW5jdGlvbmFsaXRpZXM6DQo+ID4gMSkgcGFzcyB0aGUgZ3Vlc3Qgc3RhZ2UgMSBjb25maWd1
cmF0aW9uDQo+ID4gMikgcGFzcyBzdGFnZSAxIE1TSSBiaW5kaW5ncw0KPiA+DQo+ID4gVGhlbiB0
aG9zZSBjYXBhYmlsaXRpZXMgZ2V0cyBpbXBsZW1lbnRlZCBpbiB0aGUgU01NVXYzIGRyaXZlci4N
Cj4gPg0KPiA+IFRoZSB2aXJ0dWFsaXplciBwYXNzZXMgaW5mb3JtYXRpb24gdGhyb3VnaCB0aGUg
VkZJTyB1c2VyIEFQSQ0KPiA+IHdoaWNoIGNhc2NhZGVzIHRoZW0gdG8gdGhlIGlvbW11IHN1YnN5
c3RlbS4gVGhpcyBhbGxvd3MgdGhlIGd1ZXN0DQo+ID4gdG8gb3duIHN0YWdlIDEgdGFibGVzIGFu
ZCBjb250ZXh0IGRlc2NyaXB0b3JzIChzby1jYWxsZWQgUEFTSUQNCj4gPiB0YWJsZSkgd2hpbGUg
dGhlIGhvc3Qgb3ducyBzdGFnZSAyIHRhYmxlcyBhbmQgbWFpbiBjb25maWd1cmF0aW9uDQo+ID4g
c3RydWN0dXJlcyAoU1RFKS4NCj4gPg0KPiA+IEJlc3QgUmVnYXJkcw0KPiA+DQo+ID4gRXJpYw0K
PiA+DQo+ID4gVGhpcyBzZXJpZXMgY2FuIGJlIGZvdW5kIGF0Og0KPiA+IHY1LjEyLXJjNi1qZWFu
LWlvcGYtMTQtMnN0YWdlLXYxNQ0KPiA+IChpbmNsdWRpbmcgdGhlIFZGSU8gcGFydCBpbiBpdHMg
bGFzdCB2ZXJzaW9uOiB2MTMpDQo+ID4NCj4gDQo+IEkgYW0gdGVzdGluZyB0aGUgcGVyZm9ybWFu
Y2Ugb2YgYW4gYWNjZWxlcmF0b3Igd2l0aC93aXRob3V0IFNWQS92U1ZBLA0KPiBhbmQgZm91bmQg
dGhlcmUgbWlnaHQgYmUgc29tZSBwb3RlbnRpYWwgcGVyZm9ybWFuY2UgbG9zcyByaXNrIGZvciBT
VkEvdlNWQS4NCj4gDQo+IEkgdXNlIGEgTmV0d29yayBhbmQgY29tcHV0aW5nIGVuY3J5cHRpb24g
ZGV2aWNlIChTRUMpLCBhbmQgc2VuZCAxTUINCj4gcmVxdWVzdCBmb3IgMTAwMDAgdGltZXMuDQo+
IA0KPiBJIHRyaWdnZXIgbW0gZmF1bHQgYmVmb3JlIEkgc2VuZCB0aGUgcmVxdWVzdCwgc28gdGhl
cmUgc2hvdWxkIGJlIG5vIGlvcGYuDQo+IA0KPiBIZXJlJ3Mgd2hhdCBJIGdvdDoNCj4gDQo+IHBo
eXNpY2FsIHNjZW5hcmlvOg0KPiBwZXJmb3JtYW5jZToJCVNWQTo5TUIvcyAgCU5PU1ZBOjlNQi9z
DQo+IHRsYl9taXNzOiAJCVNWQTozMDIsNjUxCU5PU1ZBOjEsMjIzDQo+IHRyYW5zX3RhYmxlX3dh
bGtfYWNjZXNzOlNWQTozMDIsMjc2CU5PU1ZBOjEsMjM3DQo+IA0KPiBWTSBzY2VuYXJpbzoNCj4g
cGVyZm9ybWFuY2U6CQl2U1ZBOjlNQi9zICAJTk92U1ZBOjZNQi9zICBhYm91dCAzMH40MCUgbG9z
cw0KPiB0bGJfbWlzczogCQl2U1ZBOjQsNDIzLDg5NwlOT3ZTVkE6MSw5MDcNCj4gdHJhbnNfdGFi
bGVfd2Fsa19hY2Nlc3M6dlNWQTo2MSw5MjgsNDMwCU5PdlNWQToyMSw5NDgNCj4gDQo+IEluIHBo
eXNpY2FsIHNjZW5hcmlvLCB0aGVyZSdzIGFsbW9zdCBubyBwZXJmb3JtYW5jZSBsb3NzLCBidXQg
dGhlDQo+IHRsYl9taXNzIGFuZCB0cmFuc190YWJsZV93YWxrX2FjY2VzcyBvZiBzdGFnZSAxIGZv
ciBTVkEgaXMgcXVpdGUgaGlnaCwNCj4gY29tcGFyaW5nIHRvIE5PU1ZBLg0KPiANCj4gSW4gVk0g
c2NlbmFyaW8sIHRoZXJlJ3MgYWJvdXQgMzB+NDAlIHBlcmZvcm1hbmNlIGxvc3MsIHRoaXMgaXMg
YmVjYXVzZQ0KPiB0aGUgdHdvIHN0YWdlIHRsYl9taXNzIGFuZCB0cmFuc190YWJsZV93YWxrX2Fj
Y2VzcyBpcyBldmVuIGhpZ2hlciwgYW5kDQo+IGltcGFjdCB0aGUgcGVyZm9ybWFuY2UuDQo+IA0K
PiBJIGNvbXBhcmUgdGhlIHByb2NlZHVyZSBvZiBidWlsZGluZyBwYWdlIHRhYmxlIG9mIFNWQSBh
bmQgTk9TVkEsIGFuZA0KPiBmb3VuZCB0aGF0IE5PU1ZBIHVzZXMgMk1CIG1hcHBpbmcgYXMgZmFy
IGFzIHBvc3NpYmxlLCB3aGlsZSBTVkEgdXNlcw0KPiBvbmx5IDRLQi4NCj4gDQo+IEkgcmV0ZXN0
IHdpdGggaHVnZSBwYWdlLCBhbmQgaHVnZSBwYWdlIGNvdWxkIHNvbHZlIHRoaXMgcHJvYmxlbSwg
dGhlDQo+IHBlcmZvcm1hbmNlIG9mIFNWQS92U1ZBIGlzIGFsbW9zdCB0aGUgc2FtZSBhcyBOT1NW
QS4NCj4gDQo+IEkgYW0gd29uZGVyaW5nIGRvIHlvdSBoYXZlIGFueSBvdGhlciBzb2x1dGlvbiBm
b3IgdGhlIHBlcmZvcm1hbmNlIGxvc3MNCj4gb2YgdlNWQSwgb3IgYW55IG90aGVyIG1ldGhvZCB0
byByZWR1Y2UgdGhlIHRsYl9taXNzL3RyYW5zX3RhYmxlX3dhbGsuDQoNCkhpIFhpbmdhbmcsDQoN
Ckp1c3QgY3VyaW91cywgZG8geW91IGhhdmUgRFZNIGVuYWJsZWQgb24gdGhpcyBib2FyZCBvciBk
b2VzIGl0IHVzZSBleHBsaWNpdA0KU01NVSBUTEIgaW52YWxpZGF0aW9ucz8NCg0KVGhhbmtzLA0K
U2hhbWVlcg0K
