Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAA135196B
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhDARxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3066 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbhDARqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:46:00 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FB2h24HlxzWQLW;
        Thu,  1 Apr 2021 20:34:58 +0800 (CST)
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 1 Apr 2021 20:38:19 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggpemm000003.china.huawei.com (7.185.36.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 1 Apr 2021 20:38:19 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Thu, 1 Apr 2021 13:38:17 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        yuzenghui <yuzenghui@huawei.com>
CC:     "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
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
        zhukeqian <zhukeqian1@huawei.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        wangxingang <wangxingang5@huawei.com>,
        jiangkunkun <jiangkunkun@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        lushenming <lushenming@huawei.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: RE: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
Thread-Topic: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than
 one context descriptor
Thread-Index: AQHXCibIIJ3XeBlNOUapPYfC9gSwdKqcZ70AgANNIQCAABX1MA==
Date:   Thu, 1 Apr 2021 12:38:16 +0000
Message-ID: <27a474c325fc46a092c2e11854baaccc@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
 <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
 <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
In-Reply-To: <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.25.230]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXVnZXIgRXJpYyBbbWFp
bHRvOmVyaWMuYXVnZXJAcmVkaGF0LmNvbV0NCj4gU2VudDogMDEgQXByaWwgMjAyMSAxMjo0OQ0K
PiBUbzogeXV6ZW5naHVpIDx5dXplbmdodWlAaHVhd2VpLmNvbT4NCj4gQ2M6IGVyaWMuYXVnZXIu
cHJvQGdtYWlsLmNvbTsgaW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7DQo+IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHU7IHdpbGxAa2VybmVsLm9yZzsgbWF6QGtlcm5lbC5vcmc7DQo+
IHJvYmluLm11cnBoeUBhcm0uY29tOyBqb3JvQDhieXRlcy5vcmc7IGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tOw0KPiB0bkBzZW1paGFsZi5jb207IHpodWtlcWlhbiA8emh1a2VxaWFuMUBodWF3
ZWkuY29tPjsNCj4gamFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb207IHlpLmwubGl1QGludGVs
LmNvbTsgd2FuZ3hpbmdhbmcNCj4gPHdhbmd4aW5nYW5nNUBodWF3ZWkuY29tPjsgamlhbmdrdW5r
dW4gPGppYW5na3Vua3VuQGh1YXdlaS5jb20+Ow0KPiBqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc7
IHpoYW5nZmVpLmdhb0BsaW5hcm8ub3JnOyB6aGFuZ2ZlaS5nYW9AZ21haWwuY29tOw0KPiB2aXZl
ay5nYXV0YW1AYXJtLmNvbTsgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaQ0KPiA8c2hhbWVlcmFs
aS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsgbmljb2xlb3RzdWthQGdtYWlsLmNvbTsNCj4g
bHVzaGVubWluZyA8bHVzaGVubWluZ0BodWF3ZWkuY29tPjsgdnNldGhpQG52aWRpYS5jb207IFdh
bmdoYWliaW4gKEQpDQo+IDx3YW5naGFpYmluLndhbmdAaHVhd2VpLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MTQgMTMvMTNdIGlvbW11L3NtbXV2MzogQWNjZXB0IGNvbmZpZ3Mgd2l0aCBt
b3JlIHRoYW4NCj4gb25lIGNvbnRleHQgZGVzY3JpcHRvcg0KPiANCj4gSGkgWmVuZ2h1aSwNCj4g
DQo+IE9uIDMvMzAvMjEgMTE6MjMgQU0sIFplbmdodWkgWXUgd3JvdGU6DQo+ID4gSGkgRXJpYywN
Cj4gPg0KPiA+IE9uIDIwMjEvMi8yNCA0OjU2LCBFcmljIEF1Z2VyIHdyb3RlOg0KPiA+PiBJbiBw
cmVwYXJhdGlvbiBmb3IgdlNWQSwgbGV0J3MgYWNjZXB0IHVzZXJzcGFjZSBwcm92aWRlZCBjb25m
aWdzDQo+ID4+IHdpdGggbW9yZSB0aGFuIG9uZSBDRC4gV2UgY2hlY2sgdGhlIG1heCBDRCBhZ2Fp
bnN0IHRoZSBob3N0IGlvbW11DQo+ID4+IGNhcGFiaWxpdHkgYW5kIGFsc28gdGhlIGZvcm1hdCAo
bGluZWFyIHZlcnN1cyAyIGxldmVsKS4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBTaGFtZWVy
IEtvbG90aHVtDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+DQo+ID4+
IC0tLQ0KPiA+PiDCoCBkcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5j
IHwgMTMgKysrKysrKystLS0tLQ0KPiA+PiDCoCAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYw0KPiA+PiBiL2RyaXZlcnMvaW9tbXUvYXJt
L2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMNCj4gPj4gaW5kZXggMzMyZDMxYzA2ODBmLi5hYjc0
YTAyODk4OTMgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYz
L2FybS1zbW11LXYzLmMNCj4gPj4gKysrIGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMv
YXJtLXNtbXUtdjMuYw0KPiA+PiBAQCAtMzAzOCwxNCArMzAzOCwxNyBAQCBzdGF0aWMgaW50DQo+
IGFybV9zbW11X2F0dGFjaF9wYXNpZF90YWJsZShzdHJ1Y3QNCj4gPj4gaW9tbXVfZG9tYWluICpk
b21haW4sDQo+ID4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoc21tdV9kb21haW4tPnMxX2NmZy5z
ZXQpDQo+ID4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Ow0KPiA+PiDCoCAt
wqDCoMKgwqDCoMKgwqAgLyoNCj4gPj4gLcKgwqDCoMKgwqDCoMKgwqAgKiB3ZSBjdXJyZW50bHkg
c3VwcG9ydCBhIHNpbmdsZSBDRCBzbyBzMWZtdCBhbmQgczFkc3MNCj4gPj4gLcKgwqDCoMKgwqDC
oMKgwqAgKiBmaWVsZHMgYXJlIGFsc28gaWdub3JlZA0KPiA+PiAtwqDCoMKgwqDCoMKgwqDCoCAq
Lw0KPiA+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKGNmZy0+cGFzaWRfYml0cykNCj4gPj4gK8KgwqDC
oMKgwqDCoMKgIGxpc3RfZm9yX2VhY2hfZW50cnkobWFzdGVyLCAmc21tdV9kb21haW4tPmRldmlj
ZXMsDQo+ID4+IGRvbWFpbl9oZWFkKSB7DQo+ID4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChjZmctPnBhc2lkX2JpdHMgPiBtYXN0ZXItPnNzaWRfYml0cykNCj4gPj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsNCj4gPj4gK8KgwqDCoMKgwqDCoMKgIH0NCj4g
Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChjZmctPnZlbmRvcl9kYXRhLnNtbXV2My5zMWZtdCA9PQ0K
PiA+PiBTVFJUQUJfU1RFXzBfUzFGTVRfNjRLX0wyICYmDQo+ID4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgIShzbW11LT5mZWF0dXJlcyAmDQo+IEFSTV9TTU1VX0ZFQVRfMl9MVkxf
Q0RUQUIpKQ0KPiA+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsNCj4gPj4g
wqAgwqDCoMKgwqDCoMKgwqDCoMKgIHNtbXVfZG9tYWluLT5zMV9jZmcuY2RjZmcuY2R0YWJfZG1h
ID0gY2ZnLT5iYXNlX3B0cjsNCj4gPj4gK8KgwqDCoMKgwqDCoMKgIHNtbXVfZG9tYWluLT5zMV9j
ZmcuczFjZG1heCA9IGNmZy0+cGFzaWRfYml0czsNCj4gPj4gK8KgwqDCoMKgwqDCoMKgIHNtbXVf
ZG9tYWluLT5zMV9jZmcuczFmbXQgPQ0KPiBjZmctPnZlbmRvcl9kYXRhLnNtbXV2My5zMWZtdDsN
Cj4gPg0KPiA+IEFuZCB3aGF0IGFib3V0IHRoZSBTSURTUyBmaWVsZD8NCj4gPg0KPiBJIGFkZGVk
IHRoaXMgcGF0Y2ggdXBvbiBTaGFtZWVyJ3MgcmVxdWVzdCwgdG8gYmUgbW9yZSB2U1ZBIGZyaWVu
ZGx5Lg0KPiBIb3dlciB0aGlzIHNlcmllcyBkb2VzIG5vdCByZWFsbHkgdGFyZ2V0IG11bHRpcGxl
IENEIHN1cHBvcnQuIEF0IHRoZQ0KPiBtb21lbnQgdGhlIGRyaXZlciBvbmx5IHN1cHBvcnRzIFNU
UlRBQl9TVEVfMV9TMURTU19TU0lEMCAoMHgyKSBJIHRoaW5rLg0KPiBBdCB0aGlzIG1vbWVudCBt
YXliZSBJIGNhbiBvbmx5IGNoZWNrIHRoZSBzMWRzcyBmaWVsZCBpcyAweDIuIE9yIHNpbXBseQ0K
PiByZW1vdmVzIHRoaXMgcGF0Y2g/DQo+IA0KPiBUaG91Z2h0cz8NCg0KUmlnaHQuIFRoaXMgd2Fz
IHVzZWZ1bCBmb3IgdlNWQSB0ZXN0cy4gQnV0IHllcywgdG8gcHJvcGVybHkgc3VwcG9ydCBtdWx0
aXBsZSBDRHMNCndlIG5lZWQgdG8gcGFzcyB0aGUgUzFEU1MgZnJvbSBRZW11LiBBbmQgdGhhdCBy
ZXF1aXJlcyBmdXJ0aGVyIGNoYW5nZXMuDQpTbyBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIHJlbW92
ZSB0aGlzIHBhdGNoIGFuZCByZWplY3QgUzFDRE1BWCAhPSAwIGNhc2VzLg0KDQpUaGFua3MsDQpT
aGFtZWVyDQogICANCj4gDQo+IEVyaWMNCg0K
