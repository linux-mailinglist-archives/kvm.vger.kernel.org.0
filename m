Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C0E41C16F
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 11:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhI2JSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 05:18:04 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3888 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbhI2JSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 05:18:03 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HK9fK4kp6z67qS3;
        Wed, 29 Sep 2021 17:13:45 +0800 (CST)
Received: from lhreml719-chm.china.huawei.com (10.201.108.70) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 29 Sep 2021 11:16:19 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:16:19 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Wed, 29 Sep 2021 10:16:17 +0100
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
Thread-Index: AQHXqhcv8rGxctog9kC36bxSe2rONqu6Z2mAgABdanD///ilAIAAErXQ
Date:   Wed, 29 Sep 2021 09:16:17 +0000
Message-ID: <a128301751974352a648bcc0f50bc464@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <2e0c062947b044179603ab45989808ff@huawei.com>
 <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGlhbiwgS2V2aW4gW21h
aWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gU2VudDogMjkgU2VwdGVtYmVyIDIwMjEgMTA6
MDYNCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0u
dGhvZGlAaHVhd2VpLmNvbT47DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGFs
ZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBqZ2dAbnZpZGlhLmNvbTsgbWd1cnRvdm95QG52aWRp
YS5jb207DQo+IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgbGl1bG9uZ2ZhbmcgPGxp
dWxvbmdmYW5nQGh1YXdlaS5jb20+Ow0KPiBaZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGlj
b24uY29tPjsgSm9uYXRoYW4gQ2FtZXJvbg0KPiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29t
PjsgV2FuZ3pob3UgKEIpDQo+IDx3YW5nemhvdTFAaGlzaWxpY29uLmNvbT47IEhlLCBTaGFvcGVu
ZyA8c2hhb3BlbmcuaGVAaW50ZWwuY29tPjsgWmhhbywNCj4gWWFuIFkgPHlhbi55LnpoYW9AaW50
ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHYzIDAvNl0gdmZpby9oaXNpbGljb246IGFk
ZCBhY2MgbGl2ZSBtaWdyYXRpb24gZHJpdmVyDQo+IA0KPiA+IEZyb206IFNoYW1lZXJhbGkgS29s
b3RodW0gVGhvZGkNCj4gPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0K
PiA+DQo+ID4gSGkgS2V2aW4sDQo+ID4NCj4gPiA+IEZyb206IFRpYW4sIEtldmluIFttYWlsdG86
a2V2aW4udGlhbkBpbnRlbC5jb21dDQo+ID4gPiBTZW50OiAyOSBTZXB0ZW1iZXIgMjAyMSAwNDo1
OA0KPiA+ID4NCj4gPiA+IEhpLCBTaGFtZWVyLA0KPiA+ID4NCj4gPiA+ID4gRnJvbTogU2hhbWVl
ciBLb2xvdGh1bSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+ID4g
PiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxNSwgMjAyMSA1OjUxIFBNDQo+ID4gPiA+DQo+
ID4gPiA+IEhpLA0KPiA+ID4gPg0KPiA+ID4gPiBUaGFua3MgdG8gdGhlIGludHJvZHVjdGlvbiBv
ZiB2ZmlvX3BjaV9jb3JlIHN1YnN5c3RlbSBmcmFtZXdvcmtbMF0sDQo+ID4gPiA+IG5vdyBpdCBp
cyBwb3NzaWJsZSB0byBwcm92aWRlIHZlbmRvciBzcGVjaWZpYyBmdW5jdGlvbmFsaXR5IHRvDQo+
ID4gPiA+IHZmaW8gcGNpIGRldmljZXMuIFRoaXMgc2VyaWVzIGF0dGVtcHRzIHRvIGFkZCB2Zmlv
IGxpdmUgbWlncmF0aW9uDQo+ID4gPiA+IHN1cHBvcnQgZm9yIEhpU2lsaWNvbiBBQ0MgVkYgZGV2
aWNlcyBiYXNlZCBvbiB0aGUgbmV3IGZyYW1ld29yay4NCj4gPiA+ID4NCj4gPiA+ID4gSGlTaWxp
Y29uIEFDQyBWRiBkZXZpY2UgTU1JTyBzcGFjZSBpbmNsdWRlcyBib3RoIHRoZSBmdW5jdGlvbmFs
DQo+ID4gPiA+IHJlZ2lzdGVyIHNwYWNlIGFuZCBtaWdyYXRpb24gY29udHJvbCByZWdpc3RlciBz
cGFjZS4gQXMgZGlzY3Vzc2VkDQo+ID4gPiA+IGluIFJGQ3YxWzFdLCB0aGlzIG1heSBjcmVhdGUg
c2VjdXJpdHkgaXNzdWVzIGFzIHRoZXNlIHJlZ2lvbnMgZ2V0DQo+ID4gPiA+IHNoYXJlZCBiZXR3
ZWVuIHRoZSBHdWVzdCBkcml2ZXIgYW5kIHRoZSBtaWdyYXRpb24gZHJpdmVyLg0KPiA+ID4gPiBC
YXNlZCBvbiB0aGUgZmVlZGJhY2ssIHdlIHRyaWVkIHRvIGFkZHJlc3MgdGhvc2UgY29uY2VybnMg
aW4NCj4gPiA+ID4gdGhpcyB2ZXJzaW9uLg0KPiA+ID4NCj4gPiA+IFRoaXMgc2VyaWVzIGRvZXNu
J3QgbWVudGlvbiBhbnl0aGluZyByZWxhdGVkIHRvIGRpcnR5IHBhZ2UgdHJhY2tpbmcuDQo+ID4g
PiBBcmUgeW91IHJlbHkgb24gS2VxaWFuJ3Mgc2VyaWVzIGZvciB1dGlsaXppbmcgaGFyZHdhcmUg
aW9tbXUgZGlydHkNCj4gPiA+IGJpdCAoZS5nLiBTTU1VIEhUVFUpPw0KPiA+DQo+ID4gWWVzLCB0
aGlzIGRvZXNuJ3QgaGF2ZSBkaXJ0eSBwYWdlIHRyYWNraW5nIGFuZCB0aGUgcGxhbiBpcyB0byBt
YWtlIHVzZSBvZg0KPiA+IEtlcWlhbidzIFNNTVUgSFRUVSB3b3JrIHRvIGltcHJvdmUgcGVyZm9y
bWFuY2UuIFdlIGhhdmUgZG9uZSBiYXNpYw0KPiA+IHNhbml0eSB0ZXN0aW5nIHdpdGggdGhvc2Ug
cGF0Y2hlcy4NCj4gPg0KPiANCj4gRG8geW91IHBsYW4gdG8gc3VwcG9ydCBtaWdyYXRpb24gdy9v
IEhUVFUgYXMgdGhlIGZhbGxiYWNrIG9wdGlvbj8NCj4gR2VuZXJhbGx5IG9uZSB3b3VsZCBleHBl
Y3QgdGhlIGJhc2ljIGZ1bmN0aW9uYWxpdHkgcmVhZHkgYmVmb3JlIHRhbGtpbmcNCj4gYWJvdXQg
b3B0aW1pemF0aW9uLg0KDQpZZXMsIHRoZSBwbGFuIGlzIHRvIGdldCB0aGUgYmFzaWMgbGl2ZSBt
aWdyYXRpb24gd29ya2luZyBhbmQgdGhlbiB3ZSBjYW4gb3B0aW1pemUNCml0IHdpdGggU01NVSBI
VFRVIHdoZW4gaXQgaXMgYXZhaWxhYmxlLg0KDQo+IElmIG5vdCwgaG93IGRvZXMgdXNlcnNwYWNl
IGtub3cgdGhhdCBtaWdyYXRpb24gb2YgYSBnaXZlbiBkZXZpY2UgY2FuDQo+IGJlIGFsbG93ZWQg
b25seSB3aGVuIHRoZSBpb21tdSBzdXBwb3J0cyBoYXJkd2FyZSBkaXJ0eSBiaXQ/DQoNClllcy4g
SXQgd291bGQgYmUgbmljZSB0byBoYXZlIHRoYXQgaW5mbyBhdmFpbGFibGUgSSBndWVzcy4gQnV0
IGZvciB0aGVzZSBkZXZpY2VzLA0KdGhleSBhcmUgaW50ZWdyYXRlZCBlbmQgcG9pbnQgZGV2aWNl
cyBhbmQgdGhlIHBsYXRmb3JtIHRoYXQgc3VwcG9ydHMgdGhlc2UNCndpbGwgaGF2ZSBTTU1VdjMg
d2l0aCBIVFRVLg0KDQpUaGFua3MsDQpTaGFtZWVyDQoNCj4gVGhhbmtzDQo+IEtldmluDQo=
