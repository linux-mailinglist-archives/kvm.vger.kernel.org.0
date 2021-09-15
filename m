Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A07040C66B
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhIONaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 09:30:10 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3821 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhIONaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 09:30:09 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8gwH5cVrz67gsl;
        Wed, 15 Sep 2021 21:26:23 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 15:28:48 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 14:28:48 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Wed, 15 Sep 2021 14:28:48 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHXqhdQM13RiELH60aUjxjG41fnUKulAGMAgAAGK3A=
Date:   Wed, 15 Sep 2021 13:28:47 +0000
Message-ID: <fe5d6659e28244da82b7028b403e11ae@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
In-Reply-To: <20210915130742.GJ4065468@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.177]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IFttYWlsdG86amdnQG52aWRpYS5jb21dDQo+IFNlbnQ6IDE1IFNlcHRlbWJlciAyMDIxIDE0OjA4
DQo+IFRvOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRo
b2RpQGh1YXdlaS5jb20+DQo+IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBhbGV4Lndp
bGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gbWd1cnRvdm95QG52aWRpYS5jb207IExpbnV4YXJtIDxs
aW51eGFybUBodWF3ZWkuY29tPjsgbGl1bG9uZ2ZhbmcNCj4gPGxpdWxvbmdmYW5nQGh1YXdlaS5j
b20+OyBaZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsNCj4gSm9uYXRoYW4g
Q2FtZXJvbiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPjsgV2FuZ3pob3UgKEIpDQo+IDx3
YW5nemhvdTFAaGlzaWxpY29uLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyA2LzZdIGhp
c2lfYWNjX3ZmaW9fcGNpOiBBZGQgc3VwcG9ydCBmb3IgVkZJTyBsaXZlDQo+IG1pZ3JhdGlvbg0K
PiANCj4gT24gV2VkLCBTZXAgMTUsIDIwMjEgYXQgMTA6NTA6MzdBTSArMDEwMCwgU2hhbWVlciBL
b2xvdGh1bSB3cm90ZToNCj4gPiArLyoNCj4gPiArICogSGlTaWxpY29uIEFDQyBWRiBkZXbCoE1N
SU8gc3BhY2UgY29udGFpbnMgYm90aCB0aGUgZnVuY3Rpb25hbCByZWdpc3Rlcg0KPiA+ICsgKiBz
cGFjZcKgYW5kIHRoZSBtaWdyYXRpb24gY29udHJvbCByZWdpc3RlciBzcGFjZS4gV2UgaGlkZSB0
aGUgbWlncmF0aW9uDQo+ID4gKyAqIGNvbnRyb2wgc3BhY2XCoGZyb20gdGhlIEd1ZXN0LiBCdXQg
dG8gc3VjY2Vzc2Z1bGx5IGNvbXBsZXRlIHRoZSBsaXZlDQo+ID4gKyAqIG1pZ3JhdGlvbiwgd2Ug
c3RpbGwgbmVlZCBhY2Nlc3MgdG8gdGhlIGZ1bmN0aW9uYWwgTU1JTyBzcGFjZSBhc3NpZ25lZA0K
PiA+ICsgKiB0byB0aGUgR3Vlc3QuIFRvIGF2b2lkIGFueSBwb3RlbnRpYWwgc2VjdXJpdHkgaXNz
dWVzLCB3ZSBuZWVkIHRvIGJlDQo+ID4gKyAqIGNhcmVmdWwgbm90IHRvIGFjY2VzcyB0aGlzIHJl
Z2lvbiB3aGlsZSB0aGUgR3Vlc3QgdkNQVXMgYXJlIHJ1bm5pbmcuDQo+ID4gKyAqDQo+ID4gKyAq
IEhlbmNlIGNoZWNrIHRoZSBkZXZpY2Ugc3RhdGUgYmVmb3JlIHdlIG1hcCB0aGUgcmVnaW9uLg0K
PiA+ICsgKi8NCj4gDQo+IFRoZSBwcmlvciBwYXRjaCBwcmV2ZW50cyBtYXBwaW5nIHRoaXMgYXJl
YSBpbnRvIHRoZSBndWVzdCBhdCBhbGwsDQo+IHJpZ2h0Pw0KDQpUaGF04oCZcyByaWdodC4gSXQg
d2lsbCBwcmV2ZW50IEd1ZXN0IGZyb20gbWFwcGluZyB0aGlzIGFyZWEuDQoNCj4gU28gd2h5IHRo
ZSBjb21tZW50IGFuZCBsb2dpYz8gSWYgdGhlIE1NSU8gYXJlYSBpc24ndCBtYXBwZWQgdGhlbiB0
aGVyZQ0KPiBpcyBub3RoaW5nIHRvIGRvLCByaWdodD8NCj4gDQo+IFRoZSBvbmx5IHJpc2sgaXMg
UDJQIHRyYW5zYWN0aW9ucyBmcm9tIGRldmljZXMgaW4gdGhlIHNhbWUgSU9NTVUNCj4gZ3JvdXAs
IGFuZCB5b3UgbWlnaHQgZG8gd2VsbCB0byBtaXRpZ2F0ZSB0aGF0IGJ5IGFzc2VydGluZyB0aGF0
IHRoZQ0KPiBkZXZpY2UgaXMgaW4gYSBzaW5nbGV0b24gSU9NTVUgZ3JvdXA/DQoNClRoaXMgd2Fz
IGFkZGVkIGFzIGFuIGV4dHJhIHByb3RlY3Rpb24uIEkgd2lsbCBhZGQgdGhlIHNpbmdsZXRvbiBj
aGVjayBpbnN0ZWFkLg0KDQo+ID4gK3N0YXRpYyBpbnQgaGlzaV9hY2NfdmZpb19wY2lfaW5pdChz
dHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBh
Y2NfdmZfbWlncmF0aW9uICphY2NfdmZfZGV2Ow0KPiA+ICsJc3RydWN0IHBjaV9kZXYgKnBkZXYg
PSB2ZGV2LT5wZGV2Ow0KPiA+ICsJc3RydWN0IHBjaV9kZXYgKnBmX2RldiwgKnZmX2RldjsNCj4g
PiArCXN0cnVjdCBoaXNpX3FtICpwZl9xbTsNCj4gPiArCWludCB2Zl9pZCwgcmV0Ow0KPiA+ICsN
Cj4gPiArCXBmX2RldiA9IHBkZXYtPnBoeXNmbjsNCj4gPiArCXZmX2RldiA9IHBkZXY7DQo+ID4g
Kw0KPiA+ICsJcGZfcW0gPSBwY2lfZ2V0X2RydmRhdGEocGZfZGV2KTsNCj4gPiArCWlmICghcGZf
cW0pIHsNCj4gPiArCQlwcl9lcnIoIkhpU2kgQUNDIHFtIGRyaXZlciBub3QgbG9hZGVkXG4iKTsN
Cj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCX0NCj4gDQo+IE5vcGUsIHRoaXMgaXMgbG9j
a2VkIHdyb25nIGFuZCBoYXMgbm8gbGlmZXRpbWUgbWFuYWdlbWVudC4NCg0KT2suIEhvbGRpbmcg
dGhlIGRldmljZV9sb2NrKCkgc3VmZmljaWVudCBoZXJlPw0KDQo+IA0KPiA+ICsJaWYgKHBmX3Ft
LT52ZXIgPCBRTV9IV19WMykgew0KPiA+ICsJCWRldl9lcnIoJnBkZXYtPmRldiwNCj4gPiArCQkJ
Ik1pZ3JhdGlvbiBub3Qgc3VwcG9ydGVkLCBodyB2ZXJzaW9uOiAweCV4XG4iLA0KPiA+ICsJCQkg
cGZfcW0tPnZlcik7DQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJdmZfaWQgPSBQQ0lfRlVOQyh2Zl9kZXYtPmRldmZuKTsNCj4gPiArCWFjY192Zl9kZXYgPSBr
emFsbG9jKHNpemVvZigqYWNjX3ZmX2RldiksIEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFhY2Nf
dmZfZGV2KQ0KPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiANCj4gRG9uJ3QgZG8gdGhlIG1lbW9y
eSBsaWtlIHRoaXMsIHRoZSBlbnRpcmUgZHJpdmVyIHNob3VsZCBoYXZlIGEgZ2xvYmFsDQo+IHN0
cnVjdCwgbm90IG9uZSB0aGF0IGlzIGFsbG9jYXRlZC9mcmVlZCBhcm91bmQgb3Blbi9jbG9zZV9k
ZXZpY2UNCj4gDQo+IHN0cnVjdCBoaXNpX2FjY192ZmlvX2RldmljZSB7DQo+ICAgICAgIHN0cnVj
dCB2ZmlvX3BjaV9jb3JlX2RldmljZSBjb3JlX2RldmljZTsNCj4gICAgICAgW3B1dCBhY2NfdmZf
bWlncmF0aW9uIGhlcmVdDQo+ICAgICAgIFtwdXQgcmVxdWlyZWQgc3RhdGUgZnJvbSBtaWdfY3Rs
IGhlcmUsIGRvbid0IGFsbG9jYXRlIGFnYWluXQ0KPiAgICAgICBzdHJ1Y3QgYWNjX3ZmX2RhdGEg
bWlnX2RhdGE7IC8vIERvbid0IHVzZSB3b25reSBwb2ludGVyIG1hdGhzDQo+IH0NCj4gDQo+IFRo
ZW4gbGVhdmUgdGhlIHJlbGVhZSBmdW5jdGlvbiBvbiB0aGUgcmVnIG9wcyBOVUxMIGFuZCBjb25z
aXN0ZW50bHkNCj4gcGFzcyB0aGUgaGlzaV9hY2NfdmZpb19kZXZpY2UgZXZlcnl3aGVyZSBpbnN0
ZWFkIG9mDQo+IGFjY192Zl9taWdyYXRpb24uIFRoaXMgd2F5IGFsbCB0aGUgZnVuY3Rpb25zIGdl
dCBhbGwgdGhlIG5lZWRlZA0KPiBpbmZvcm1hdGlvbiwgZWcgaWYgdGhleSB3YW50IHRvIGxvZyBv
ciBzb21ldGhpbmcuDQo+IA0KPiBUaGUgbWx4NSBkcml2ZXIgdGhhdCBzaG91bGQgYmUgcG9zdGVk
IHNvb24gd2lsbCBzaG93IGhvdyB0byBzdHJ1Y3R1cmUNCj4gbW9zdCBvZiB0aGlzIHdlbGwgYW5k
IGluY2x1ZGUgc2V2ZXJhbCBtb3JlIHBhdGNoZXMgeW91J2xsIHdhbnQgdG8gYmUNCj4gdXNpbmcg
aGVyZS4NCg0KT2suIFRoYW5rcyBmb3IgdGFraW5nIGEgbG9vay4gSSB3aWxsIHRha2UgYSBjbG9z
ZXIgbG9vayBhdCB0aGUgbWx4NSBkcml2ZXIgYW5kDQpyZXdvcmsgYmFzZWQgb24gaXQuDQoNClRo
YW5rcywNClNoYW1lZXINCg==
