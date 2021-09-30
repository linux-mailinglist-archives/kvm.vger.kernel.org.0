Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278BC41D377
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 08:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348114AbhI3GgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 02:36:20 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3892 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbhI3GgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 02:36:19 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HKk1C0VPPz67vpZ;
        Thu, 30 Sep 2021 14:31:59 +0800 (CST)
Received: from lhreml712-chm.china.huawei.com (10.201.108.63) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 08:34:34 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml712-chm.china.huawei.com (10.201.108.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 07:34:33 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Thu, 30 Sep 2021 07:34:33 +0100
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
Thread-Index: AQHXqhcv8rGxctog9kC36bxSe2rONqu6Z2mAgABdanD///ilAIAAErXQgADy6QCAAGw8QA==
Date:   Thu, 30 Sep 2021 06:34:33 +0000
Message-ID: <61274f6497424f039397677fb5d003d0@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <2e0c062947b044179603ab45989808ff@huawei.com>
 <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a128301751974352a648bcc0f50bc464@huawei.com>
 <BN9PR11MB543384431856FEF80C1AA4C58CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB543384431856FEF80C1AA4C58CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.34]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGlhbiwgS2V2aW4gW21h
aWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gU2VudDogMzAgU2VwdGVtYmVyIDIwMjEgMDE6
NDINCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0u
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
PiA+DQo+ID4gPiBGcm9tOiBUaWFuLCBLZXZpbiBbbWFpbHRvOmtldmluLnRpYW5AaW50ZWwuY29t
XQ0KPiA+ID4gU2VudDogMjkgU2VwdGVtYmVyIDIwMjEgMTA6MDYNCj4gPiA+DQo+ID4gPiA+IEZy
b206IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gPiA+ID4gPHNoYW1lZXJhbGkua29sb3Ro
dW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiA+ID4NCj4gPiA+ID4gSGkgS2V2aW4sDQo+ID4gPiA+
DQo+ID4gPiA+ID4gRnJvbTogVGlhbiwgS2V2aW4gW21haWx0bzprZXZpbi50aWFuQGludGVsLmNv
bV0NCj4gPiA+ID4gPiBTZW50OiAyOSBTZXB0ZW1iZXIgMjAyMSAwNDo1OA0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gSGksIFNoYW1lZXIsDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEZyb206IFNoYW1l
ZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiA+
ID4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDE1LCAyMDIxIDU6NTEgUE0NCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiBIaSwNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGFua3Mg
dG8gdGhlIGludHJvZHVjdGlvbiBvZiB2ZmlvX3BjaV9jb3JlIHN1YnN5c3RlbSBmcmFtZXdvcmtb
MF0sDQo+ID4gPiA+ID4gPiBub3cgaXQgaXMgcG9zc2libGUgdG8gcHJvdmlkZSB2ZW5kb3Igc3Bl
Y2lmaWMgZnVuY3Rpb25hbGl0eSB0bw0KPiA+ID4gPiA+ID4gdmZpbyBwY2kgZGV2aWNlcy4gVGhp
cyBzZXJpZXMgYXR0ZW1wdHMgdG8gYWRkIHZmaW8gbGl2ZSBtaWdyYXRpb24NCj4gPiA+ID4gPiA+
IHN1cHBvcnQgZm9yIEhpU2lsaWNvbiBBQ0MgVkYgZGV2aWNlcyBiYXNlZCBvbiB0aGUgbmV3IGZy
YW1ld29yay4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBIaVNpbGljb24gQUNDIFZGIGRldmlj
ZSBNTUlPIHNwYWNlIGluY2x1ZGVzIGJvdGggdGhlIGZ1bmN0aW9uYWwNCj4gPiA+ID4gPiA+IHJl
Z2lzdGVyIHNwYWNlIGFuZCBtaWdyYXRpb24gY29udHJvbCByZWdpc3RlciBzcGFjZS4gQXMgZGlz
Y3Vzc2VkDQo+ID4gPiA+ID4gPiBpbiBSRkN2MVsxXSwgdGhpcyBtYXkgY3JlYXRlIHNlY3VyaXR5
IGlzc3VlcyBhcyB0aGVzZSByZWdpb25zIGdldA0KPiA+ID4gPiA+ID4gc2hhcmVkIGJldHdlZW4g
dGhlIEd1ZXN0IGRyaXZlciBhbmQgdGhlIG1pZ3JhdGlvbiBkcml2ZXIuDQo+ID4gPiA+ID4gPiBC
YXNlZCBvbiB0aGUgZmVlZGJhY2ssIHdlIHRyaWVkIHRvIGFkZHJlc3MgdGhvc2UgY29uY2VybnMg
aW4NCj4gPiA+ID4gPiA+IHRoaXMgdmVyc2lvbi4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoaXMg
c2VyaWVzIGRvZXNuJ3QgbWVudGlvbiBhbnl0aGluZyByZWxhdGVkIHRvIGRpcnR5IHBhZ2UgdHJh
Y2tpbmcuDQo+ID4gPiA+ID4gQXJlIHlvdSByZWx5IG9uIEtlcWlhbidzIHNlcmllcyBmb3IgdXRp
bGl6aW5nIGhhcmR3YXJlIGlvbW11IGRpcnR5DQo+ID4gPiA+ID4gYml0IChlLmcuIFNNTVUgSFRU
VSk/DQo+ID4gPiA+DQo+ID4gPiA+IFllcywgdGhpcyBkb2Vzbid0IGhhdmUgZGlydHkgcGFnZSB0
cmFja2luZyBhbmQgdGhlIHBsYW4gaXMgdG8gbWFrZSB1c2Ugb2YNCj4gPiA+ID4gS2VxaWFuJ3Mg
U01NVSBIVFRVIHdvcmsgdG8gaW1wcm92ZSBwZXJmb3JtYW5jZS4gV2UgaGF2ZSBkb25lDQo+IGJh
c2ljDQo+ID4gPiA+IHNhbml0eSB0ZXN0aW5nIHdpdGggdGhvc2UgcGF0Y2hlcy4NCj4gPiA+ID4N
Cj4gPiA+DQo+ID4gPiBEbyB5b3UgcGxhbiB0byBzdXBwb3J0IG1pZ3JhdGlvbiB3L28gSFRUVSBh
cyB0aGUgZmFsbGJhY2sgb3B0aW9uPw0KPiA+ID4gR2VuZXJhbGx5IG9uZSB3b3VsZCBleHBlY3Qg
dGhlIGJhc2ljIGZ1bmN0aW9uYWxpdHkgcmVhZHkgYmVmb3JlIHRhbGtpbmcNCj4gPiA+IGFib3V0
IG9wdGltaXphdGlvbi4NCj4gPg0KPiA+IFllcywgdGhlIHBsYW4gaXMgdG8gZ2V0IHRoZSBiYXNp
YyBsaXZlIG1pZ3JhdGlvbiB3b3JraW5nIGFuZCB0aGVuIHdlIGNhbg0KPiA+IG9wdGltaXplDQo+
ID4gaXQgd2l0aCBTTU1VIEhUVFUgd2hlbiBpdCBpcyBhdmFpbGFibGUuDQo+IA0KPiBUaGUgaW50
ZXJlc3RpbmcgdGhpbmcgaXMgdGhhdCB3L28gSFRUVSB2ZmlvIHdpbGwganVzdCByZXBvcnQgZXZl
cnkgcGlubmVkDQo+IHBhZ2UgYXMgZGlydHksIGkuZS4gdGhlIGVudGlyZSBndWVzdCBtZW1vcnkg
aXMgZGlydHkuIFRoaXMgY29tcGxldGVseSBraWxscw0KPiB0aGUgYmVuZWZpdCBvZiBwcmVjb3B5
IHBoYXNlIHNpbmNlIFFlbXUgc3RpbGwgbmVlZHMgdG8gdHJhbnNmZXIgdGhlIGVudGlyZQ0KPiBn
dWVzdCBtZW1vcnkgaW4gdGhlIHN0b3AtY29weSBwaGFzZS4gVGhpcyBpcyBub3QgYSAnd29ya2lu
ZycgbW9kZWwgZm9yDQo+IGxpdmUgbWlncmF0aW9uLg0KPiANCj4gU28gaXQgbmVlZHMgdG8gYmUg
Y2xlYXIgd2hldGhlciBIVFRVIGlzIHJlYWxseSBhbiBvcHRpbWl6YXRpb24gb3INCj4gYSBoYXJk
IGZ1bmN0aW9uYWwtcmVxdWlyZW1lbnQgZm9yIG1pZ3JhdGluZyBzdWNoIGRldmljZS4gSWYgdGhl
IGxhdHRlcg0KPiB0aGUgbWlncmF0aW9uIHJlZ2lvbiBpbmZvIGlzIG5vdCBhIG5pY2UtdG8taGF2
ZSB0aGluZy4NCg0KWWVzLCBhZ3JlZSB0aGF0IHdlIGhhdmUgdG8gdHJhbnNmZXIgdGhlIGVudGly
ZSBHdWVzdCBtZW1vcnkgaW4gdGhpcyBjYXNlLg0KQnV0IGRvbid0IHRoaW5rIHRoYXQgaXMgYSBr
aWxsZXIgaGVyZSBhcyB3ZSB3b3VsZCBzdGlsbCBsaWtlIHRvIGhhdmUgdGhlIA0KYmFzaWMgbGl2
ZSBtaWdyYXRpb24gZW5hYmxlZCBvbiB0aGVzZSBwbGF0Zm9ybXMgYW5kIGNhbiBiZSB1c2VkDQp3
aGVyZSB0aGUgY29uc3RyYWludHMgb2YgbWVtb3J5IHRyYW5zZmVyIGlzIGFjY2VwdGFibGUuDQog
DQo+IGJ0dyB0aGUgZmFsbGJhY2sgb3B0aW9uIHRoYXQgSSByYWlzZWQgZWFybGllciBpcyBtb3Jl
IGxpa2Ugc29tZSBzb2Z0d2FyZQ0KPiBtaXRpZ2F0aW9uIGZvciBjb2xsZWN0aW5nIGRpcnR5IHBh
Z2VzLCBlLmcuIGFuYWx5emluZyB0aGUgcmluZyBkZXNjcmlwdG9ycw0KPiB0byBidWlsZCBzb2Z0
d2FyZS10cmFja2VkIGRpcnR5IGluZm8gYnkgbWVkaWF0aW5nIHRoZSBjbWQgcG9ydGFsDQo+ICh3
aGljaCByZXF1aXJlcyBkeW5hbWljYWxseSB1bm1hcHBpbmcgY21kIHBvcnRhbCBmcm9tIHRoZSBm
YXN0LXBhdGgNCj4gdG8gZW5hYmxlIG1lZGlhdGlvbikuIFdlIGFyZSBsb29raW5nIGludG8gdGhp
cyBvcHRpb24gZm9yIHNvbWUgcGxhdGZvcm0NCj4gd2hpY2ggbGFja3Mgb2YgSU9NTVUgZGlydHkg
Yml0IHN1cHBvcnQuDQoNCkludGVyZXN0aW5nLiBJcyB0aGVyZSBhbnl0aGluZyBhdmFpbGFibGUg
cHVibGljbHkgc28gdGhhdCB3ZSBjYW4gdGFrZSBhIGxvb2s/DQoNClRoYW5rcywNClNoYW1lZXIN
Cg==
