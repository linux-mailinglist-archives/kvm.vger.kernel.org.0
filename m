Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FC046D47A
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 14:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhLHNhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:37:00 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29103 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhLHNhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 08:37:00 -0500
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J8J2M1rlSz1DJwS;
        Wed,  8 Dec 2021 21:30:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 21:33:25 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 21:33:24 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.020; Wed, 8 Dec 2021 13:33:23 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        zhukeqian <zhukeqian1@huawei.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        wangxingang <wangxingang5@huawei.com>,
        jiangkunkun <jiangkunkun@huawei.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "sumitg@nvidia.com" <sumitg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>
Subject: RE: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHXyx+ynNPh4l6d+UCGL4y4ns48GKwg7BKAgAYnz4CAAAIkgIAACKEAgAG5fXA=
Date:   Wed, 8 Dec 2021 13:33:22 +0000
Message-ID: <e78864fff56041848eda08c60e694160@huawei.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
 <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
 <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
 <15a9875b-130a-e889-4e13-e063ef2ce4f9@redhat.com>
In-Reply-To: <15a9875b-130a-e889-4e13-e063ef2ce4f9@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.84.149]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBBdWdlciBbbWFp
bHRvOmVyaWMuYXVnZXJAcmVkaGF0LmNvbV0NCj4gU2VudDogMDcgRGVjZW1iZXIgMjAyMSAxMTow
Ng0KPiBUbzogWmhhbmdmZWkgR2FvIDx6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZz47IGVyaWMuYXVn
ZXIucHJvQGdtYWlsLmNvbTsNCj4gaW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7IGpvcm9AOGJ5dGVzLm9yZzsNCj4gd2lsbEBrZXJuZWwu
b3JnOyByb2Jpbi5tdXJwaHlAYXJtLmNvbTsgamVhbi1waGlsaXBwZUBsaW5hcm8ub3JnOw0KPiB6
aHVrZXFpYW4gPHpodWtlcWlhbjFAaHVhd2VpLmNvbT4NCj4gQ2M6IGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tOyBqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbTsNCj4geWkubC5saXVAaW50
ZWwuY29tOyBrZXZpbi50aWFuQGludGVsLmNvbTsgYXNob2sucmFqQGludGVsLmNvbTsNCj4gbWF6
QGtlcm5lbC5vcmc7IHBldGVyLm1heWRlbGxAbGluYXJvLm9yZzsgdml2ZWsuZ2F1dGFtQGFybS5j
b207DQo+IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0udGhv
ZGlAaHVhd2VpLmNvbT47DQo+IHdhbmd4aW5nYW5nIDx3YW5neGluZ2FuZzVAaHVhd2VpLmNvbT47
IGppYW5na3Vua3VuDQo+IDxqaWFuZ2t1bmt1bkBodWF3ZWkuY29tPjsgeXV6ZW5naHVpIDx5dXpl
bmdodWlAaHVhd2VpLmNvbT47DQo+IG5pY29sZW90c3VrYUBnbWFpbC5jb207IGNoZW54aWFuZyAo
TSkgPGNoZW54aWFuZzY2QGhpc2lsaWNvbi5jb20+Ow0KPiBzdW1pdGdAbnZpZGlhLmNvbTsgbmlj
b2xpbmNAbnZpZGlhLmNvbTsgdmR1bXBhQG52aWRpYS5jb207DQo+IHpoYW5nZmVpLmdhb0BnbWFp
bC5jb207IGx1c2hlbm1pbmdAaHVhd2VpLmNvbTsgdnNldGhpQG52aWRpYS5jb20NCj4gU3ViamVj
dDogUmU6IFtSRkMgdjE2IDAvOV0gU01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9NTVUgcGFy
dCkNCj4gDQo+IEhpIFpoYW5nZmVpLA0KPiANCj4gT24gMTIvNy8yMSAxMTozNSBBTSwgWmhhbmdm
ZWkgR2FvIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiAyMDIxLzEyLzcg5LiL5Y2INjoyNywgRXJp
YyBBdWdlciB3cm90ZToNCj4gPj4gSGkgWmhhbmdmZWksDQo+ID4+DQo+ID4+IE9uIDEyLzMvMjEg
MToyNyBQTSwgWmhhbmdmZWkgR2FvIHdyb3RlOg0KPiA+Pj4gSGksIEVyaWMNCj4gPj4+DQo+ID4+
PiBPbiAyMDIxLzEwLzI3IOS4i+WNiDY6NDQsIEVyaWMgQXVnZXIgd3JvdGU6DQo+ID4+Pj4gVGhp
cyBzZXJpZXMgYnJpbmdzIHRoZSBJT01NVSBwYXJ0IG9mIEhXIG5lc3RlZCBwYWdpbmcgc3VwcG9y
dA0KPiA+Pj4+IGluIHRoZSBTTU1VdjMuDQo+ID4+Pj4NCj4gPj4+PiBUaGUgU01NVXYzIGRyaXZl
ciBpcyBhZGFwdGVkIHRvIHN1cHBvcnQgMiBuZXN0ZWQgc3RhZ2VzLg0KPiA+Pj4+DQo+ID4+Pj4g
VGhlIElPTU1VIEFQSSBpcyBleHRlbmRlZCB0byBjb252ZXkgdGhlIGd1ZXN0IHN0YWdlIDENCj4g
Pj4+PiBjb25maWd1cmF0aW9uIGFuZCB0aGUgaG9vayBpcyBpbXBsZW1lbnRlZCBpbiB0aGUgU01N
VXYzIGRyaXZlci4NCj4gPj4+Pg0KPiA+Pj4+IFRoaXMgYWxsb3dzIHRoZSBndWVzdCB0byBvd24g
dGhlIHN0YWdlIDEgdGFibGVzIGFuZCBjb250ZXh0DQo+ID4+Pj4gZGVzY3JpcHRvcnMgKHNvLWNh
bGxlZCBQQVNJRCB0YWJsZSkgd2hpbGUgdGhlIGhvc3Qgb3ducyB0aGUNCj4gPj4+PiBzdGFnZSAy
IHRhYmxlcyBhbmQgbWFpbiBjb25maWd1cmF0aW9uIHN0cnVjdHVyZXMgKFNURSkuDQo+ID4+Pj4N
Cj4gPj4+PiBUaGlzIHdvcmsgbWFpbmx5IGlzIHByb3ZpZGVkIGZvciB0ZXN0IHB1cnBvc2UgYXMg
dGhlIHVwcGVyDQo+ID4+Pj4gbGF5ZXIgaW50ZWdyYXRpb24gaXMgdW5kZXIgcmV3b3JrIGFuZCBi
b3VuZCB0byBiZSBiYXNlZCBvbg0KPiA+Pj4+IC9kZXYvaW9tbXUgaW5zdGVhZCBvZiBWRklPIHR1
bm5lbGluZy4gSW4gdGhpcyB2ZXJzaW9uIHdlIGFsc28gZ2V0DQo+ID4+Pj4gcmlkIG9mIHRoZSBN
U0kgQklORElORyBpb2N0bCwgYXNzdW1pbmcgdGhlIGd1ZXN0IGVuZm9yY2VzDQo+ID4+Pj4gZmxh
dCBtYXBwaW5nIG9mIGhvc3QgSU9WQXMgdXNlZCB0byBiaW5kIHBoeXNpY2FsIE1TSSBkb29yYmVs
bHMuDQo+ID4+Pj4gSW4gdGhlIGN1cnJlbnQgUUVNVSBpbnRlZ3JhdGlvbiB0aGlzIGlzIGFjaGll
dmVkIGJ5IGV4cG9zaW5nDQo+ID4+Pj4gUk1ScyB0byB0aGUgZ3Vlc3QsIHVzaW5nIFNoYW1lZXIn
cyBzZXJpZXMgWzFdLiBUaGlzIGFwcHJvYWNoDQo+ID4+Pj4gaXMgUkZDIGFzIHRoZSBJT1JUIHNw
ZWMgaXMgbm90IHJlYWxseSBtZWFudCB0byBkbyB0aGF0DQo+ID4+Pj4gKHNpbmdsZSBtYXBwaW5n
IGZsYWcgbGltaXRhdGlvbikuDQo+ID4+Pj4NCj4gPj4+PiBCZXN0IFJlZ2FyZHMNCj4gPj4+Pg0K
PiA+Pj4+IEVyaWMNCj4gPj4+Pg0KPiA+Pj4+IFRoaXMgc2VyaWVzIChIb3N0KSBjYW4gYmUgZm91
bmQgYXQ6DQo+ID4+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51eC90cmVlL3Y1LjE1
LXJjNy1uZXN0ZWQtdjE2DQo+ID4+Pj4gVGhpcyBpbmNsdWRlcyBhIHJlYmFzZWQgVkZJTyBpbnRl
Z3JhdGlvbiAoYWx0aG91Z2ggbm90IG1lYW50DQo+ID4+Pj4gdG8gYmUgdXBzdHJlYW1lZCkNCj4g
Pj4+Pg0KPiA+Pj4+IEd1ZXN0IGtlcm5lbCBicmFuY2ggY2FuIGJlIGZvdW5kIGF0Og0KPiA+Pj4+
IGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvbGludXgvdHJlZS9zaGFtZWVyX3JtcnJfdjcNCj4g
Pj4+PiBmZWF0dXJpbmcgWzFdDQo+ID4+Pj4NCj4gPj4+PiBRRU1VIGludGVncmF0aW9uIChzdGls
bCBiYXNlZCBvbiBWRklPIGFuZCBleHBvc2luZyBSTVJzKQ0KPiA+Pj4+IGNhbiBiZSBmb3VuZCBh
dDoNCj4gPj4+Pg0KPiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3FlbXUvdHJlZS92Ni4xLjAt
cm1yLXYyLW5lc3RlZF9zbW11djNfdjEwDQo+ID4+Pj4gKHVzZSBpb21tdT1uZXN0ZWQtc21tdXYz
IEFSTSB2aXJ0IG9wdGlvbikNCj4gPj4+Pg0KPiA+Pj4+IEd1ZXN0IGRlcGVuZGVuY3k6DQo+ID4+
Pj4gWzFdIFtQQVRDSCB2NyAwLzldIEFDUEkvSU9SVDogU3VwcG9ydCBmb3IgSU9SVCBSTVIgbm9k
ZQ0KPiA+Pj4gVGhhbmtzIGEgbG90IGZvciB1cGdyYWRpbmcgdGhlc2UgcGF0Y2hlcy4NCj4gPj4+
DQo+ID4+PiBJIGhhdmUgYmFzaWNhbGx5IHZlcmlmaWVkIHRoZXNlIHBhdGNoZXMgb24gSGlTaWxp
Y29uIEt1bnBlbmc5MjAuDQo+ID4+PiBBbmQgaW50ZWdyYXRlZCB0aGVtIHRvIHRoZXNlIGJyYW5j
aGVzLg0KPiA+Pj4gaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9saW51eC1rZXJuZWwtdWFkay90
cmVlL3VhY2NlLWRldmVsLTUuMTYNCj4gPj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9MaW5hcm8vcWVt
dS90cmVlL3Y2LjEuMC1ybXItdjItbmVzdGVkX3NtbXV2M192MTANCj4gPj4+DQo+ID4+PiBUaG91
Z2ggdGhleSBhcmUgcHJvdmlkZWQgZm9yIHRlc3QgcHVycG9zZSwNCj4gPj4+DQo+ID4+PiBUZXN0
ZWQtYnk6IFpoYW5nZmVpIEdhbyA8emhhbmdmZWkuZ2FvQGxpbmFyby5vcmc+DQo+ID4+IFRoYW5r
IHlvdSB2ZXJ5IG11Y2guIEFzIHlvdSBtZW50aW9uZWQsIHVudGlsIHdlIGRvIG5vdCBoYXZlIHRo
ZQ0KPiA+PiAvZGV2L2lvbW11IGludGVncmF0aW9uIHRoaXMgaXMgbWFpbnRhaW5lZCBmb3IgdGVz
dGluZyBwdXJwb3NlLiBUaGUgU01NVQ0KPiA+PiBjaGFuZ2VzIHNob3VsZG4ndCBiZSBtdWNoIGlt
cGFjdGVkIHRob3VnaC4NCj4gPj4gVGhlIGFkZGVkIHZhbHVlIG9mIHRoaXMgcmVzcGluIHdhcyB0
byBwcm9wb3NlIGFuIE1TSSBiaW5kaW5nIHNvbHV0aW9uDQo+ID4+IGJhc2VkIG9uIFJNUlJzIHdo
aWNoIHNpbXBsaWZ5IHRoaW5ncyBhdCBrZXJuZWwgbGV2ZWwuDQo+ID4NCj4gPiBDdXJyZW50IFJN
UlIgc29sdXRpb24gcmVxdWlyZXMgdWVmaSBlbmFibGVkLA0KPiA+IGFuZCBRRU1VX0VGSS5mZMKg
IGhhcyB0byBiZSBwcm92aWRlZCB0byBzdGFydCBxZW11Lg0KPiA+DQo+ID4gQW55IHBsYW4gdG8g
c3VwcG9ydCBkdGIgYXMgd2VsbCwgd2hpY2ggd2lsbCBiZSBzaW1wbGVyIHNpbmNlIG5vIG5lZWQN
Cj4gPiBRRU1VX0VGSS5mZCBhbnltb3JlLg0KPiBZZXMgdGhlIHNvbHV0aW9uIGlzIGJhc2VkIG9u
IEFDUEkgSU9SVCBub2Rlcy4gTm8gY2x1ZSBpZiBzb21lIERUDQo+IGludGVncmF0aW9uIGlzIHVu
ZGVyIHdvcmsuIFNoYW1lZXI/DQoNClRoZXJlIHdhcyBzb21lIGF0dGVtcHQgaW4gdGhlIHBhc3Qg
dG8gY3JlYXRlIGlkZW50aXR5IG1hcHBpbmdzIHVzaW5nIERULg0KVGhpcyBpcyB0aGUgbGF0ZXN0
IEkgY2FuIGZpbmQgb24gaXQsDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS9Z
VGVsREh4MlJFSUl2ViUyRk5Ab3JvbWUuZnJpdHouYm94L1QvDQoNClRoYW5rcywNClNoYW1lZXIN
Cg0K
