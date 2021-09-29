Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C597441C0B5
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbhI2Ig2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 04:36:28 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3887 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244595AbhI2Ig1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 04:36:27 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HK8jh2QFbz67Lyy;
        Wed, 29 Sep 2021 16:31:36 +0800 (CST)
Received: from lhreml719-chm.china.huawei.com (10.201.108.70) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:34:43 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 09:34:43 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Wed, 29 Sep 2021 09:34:43 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Topic: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHXqhcv8rGxctog9kC36bxSe2rONqu6Z2mAgABdanA=
Date:   Wed, 29 Sep 2021 08:34:42 +0000
Message-ID: <2e0c062947b044179603ab45989808ff@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.81.239]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgS2V2aW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGlhbiwg
S2V2aW4gW21haWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gU2VudDogMjkgU2VwdGVtYmVy
IDIwMjEgMDQ6NTgNCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGku
a29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBqZ2dAbnZpZGlhLmNvbTsgbWd1cnRv
dm95QG52aWRpYS5jb207DQo+IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgbGl1bG9u
Z2ZhbmcgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+Ow0KPiBaZW5ndGFvIChCKSA8cHJpbWUuemVu
Z0BoaXNpbGljb24uY29tPjsgSm9uYXRoYW4gQ2FtZXJvbg0KPiA8am9uYXRoYW4uY2FtZXJvbkBo
dWF3ZWkuY29tPjsgV2FuZ3pob3UgKEIpDQo+IDx3YW5nemhvdTFAaGlzaWxpY29uLmNvbT47IEhl
LCBTaGFvcGVuZyA8c2hhb3BlbmcuaGVAaW50ZWwuY29tPjsgWmhhbywNCj4gWWFuIFkgPHlhbi55
LnpoYW9AaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHYzIDAvNl0gdmZpby9oaXNp
bGljb246IGFkZCBhY2MgbGl2ZSBtaWdyYXRpb24gZHJpdmVyDQo+IA0KPiBIaSwgU2hhbWVlciwN
Cj4gDQo+ID4gRnJvbTogU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDE1LCAyMDIxIDU6
NTEgUE0NCj4gPg0KPiA+IEhpLA0KPiA+DQo+ID4gVGhhbmtzIHRvIHRoZSBpbnRyb2R1Y3Rpb24g
b2YgdmZpb19wY2lfY29yZSBzdWJzeXN0ZW0gZnJhbWV3b3JrWzBdLA0KPiA+IG5vdyBpdCBpcyBw
b3NzaWJsZSB0byBwcm92aWRlIHZlbmRvciBzcGVjaWZpYyBmdW5jdGlvbmFsaXR5IHRvDQo+ID4g
dmZpbyBwY2kgZGV2aWNlcy4gVGhpcyBzZXJpZXMgYXR0ZW1wdHMgdG8gYWRkIHZmaW8gbGl2ZSBt
aWdyYXRpb24NCj4gPiBzdXBwb3J0IGZvciBIaVNpbGljb24gQUNDIFZGIGRldmljZXMgYmFzZWQg
b24gdGhlIG5ldyBmcmFtZXdvcmsuDQo+ID4NCj4gPiBIaVNpbGljb24gQUNDIFZGIGRldmljZSBN
TUlPIHNwYWNlIGluY2x1ZGVzIGJvdGggdGhlIGZ1bmN0aW9uYWwNCj4gPiByZWdpc3RlciBzcGFj
ZSBhbmQgbWlncmF0aW9uIGNvbnRyb2wgcmVnaXN0ZXIgc3BhY2UuIEFzIGRpc2N1c3NlZA0KPiA+
IGluIFJGQ3YxWzFdLCB0aGlzIG1heSBjcmVhdGUgc2VjdXJpdHkgaXNzdWVzIGFzIHRoZXNlIHJl
Z2lvbnMgZ2V0DQo+ID4gc2hhcmVkIGJldHdlZW4gdGhlIEd1ZXN0IGRyaXZlciBhbmQgdGhlIG1p
Z3JhdGlvbiBkcml2ZXIuDQo+ID4gQmFzZWQgb24gdGhlIGZlZWRiYWNrLCB3ZSB0cmllZCB0byBh
ZGRyZXNzIHRob3NlIGNvbmNlcm5zIGluDQo+ID4gdGhpcyB2ZXJzaW9uLg0KPiANCj4gVGhpcyBz
ZXJpZXMgZG9lc24ndCBtZW50aW9uIGFueXRoaW5nIHJlbGF0ZWQgdG8gZGlydHkgcGFnZSB0cmFj
a2luZy4NCj4gQXJlIHlvdSByZWx5IG9uIEtlcWlhbidzIHNlcmllcyBmb3IgdXRpbGl6aW5nIGhh
cmR3YXJlIGlvbW11IGRpcnR5DQo+IGJpdCAoZS5nLiBTTU1VIEhUVFUpPyANCg0KWWVzLCB0aGlz
IGRvZXNuJ3QgaGF2ZSBkaXJ0eSBwYWdlIHRyYWNraW5nIGFuZCB0aGUgcGxhbiBpcyB0byBtYWtl
IHVzZSBvZg0KS2VxaWFuJ3MgU01NVSBIVFRVIHdvcmsgdG8gaW1wcm92ZSBwZXJmb3JtYW5jZS4g
V2UgaGF2ZSBkb25lIGJhc2ljDQpzYW5pdHkgdGVzdGluZyB3aXRoIHRob3NlIHBhdGNoZXMuICAN
Cg0KVGhhbmtzLA0KU2hhbWVlcg0KDQpJZiBub3QsIHN1cHBvc2Ugc29tZSBzb2Z0d2FyZSB0cmlj
ayBpcyBzdGlsbA0KPiByZXF1aXJlZCBlLmcuIGJ5IGR5bmFtaWNhbGx5IG1lZGlhdGluZyBndWVz
dC1zdWJtaXR0ZWQgZGVzY3JpcHRvcnMNCj4gdG8gY29tcG9zZSB0aGUgZGlydHkgcGFnZSBpbmZv
cm1hdGlvbiBpbiB0aGUgbWlncmF0aW9uIHBoYXNlLi4uDQo+IA0KPiBUaGFua3MNCj4gS2V2aW4N
Cg==
