Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C361AF3
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfGHHLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 03:11:00 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:33060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbfGHHLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 03:11:00 -0400
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 8199DD30215B82A241FA;
        Mon,  8 Jul 2019 08:10:58 +0100 (IST)
Received: from LHREML524-MBS.china.huawei.com ([169.254.2.154]) by
 lhreml701-cah.china.huawei.com ([10.201.108.42]) with mapi id 14.03.0415.000;
 Mon, 8 Jul 2019 08:10:51 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH v7 3/6] vfio/type1: Update iova list on detach
Thread-Topic: [PATCH v7 3/6] vfio/type1: Update iova list on detach
Thread-Index: AQHVLDHlzsp7WZ6o0k2WlwGboVZ1gKa/QQsAgAEeOtA=
Date:   Mon, 8 Jul 2019 07:10:51 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA83F2E19CB@lhreml524-mbs.china.huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-4-shameerali.kolothum.thodi@huawei.com>
 <3bab52b1-da0f-10fe-34e4-889c74e3caad@redhat.com>
In-Reply-To: <3bab52b1-da0f-10fe-34e4-889c74e3caad@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.206.221]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBdWdlciBF
cmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQ0KPiBTZW50OiAwNyBKdWx5IDIwMTkg
MTY6MDMNCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3Ro
dW0udGhvZGlAaHVhd2VpLmNvbT47DQo+IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBwbW9y
ZWxAbGludXgudm5ldC5pYm0uY29tDQo+IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9y
ZzsgTGludXhhcm0gPGxpbnV4YXJtQGh1YXdlaS5jb20+OyBKb2huDQo+IEdhcnJ5IDxqb2huLmdh
cnJ5QGh1YXdlaS5jb20+OyB4dXdlaSAoTykgPHh1d2VpNUBodWF3ZWkuY29tPjsNCj4ga2V2aW4u
dGlhbkBpbnRlbC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NyAzLzZdIHZmaW8vdHlwZTE6
IFVwZGF0ZSBpb3ZhIGxpc3Qgb24gZGV0YWNoDQo+IA0KPiBIaSBTaGFtZWVyLA0KPiANCj4gT24g
Ni8yNi8xOSA1OjEyIFBNLCBTaGFtZWVyIEtvbG90aHVtIHdyb3RlOg0KPiA+IEdldCBhIGNvcHkg
b2YgaW92YSBsaXN0IG9uIF9ncm91cF9kZXRhY2ggYW5kIHRyeSB0byB1cGRhdGUgdGhlIGxpc3Qu
DQo+ID4gT24gc3VjY2VzcyByZXBsYWNlIHRoZSBjdXJyZW50IG9uZSB3aXRoIHRoZSBjb3B5LiBM
ZWF2ZSB0aGUgbGlzdCBhcw0KPiA+IGl0IGlzIGlmIHVwZGF0ZSBmYWlscy4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlA
aHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEu
YyB8IDkxDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgOTEgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmZpby92ZmlvX2lvbW11X3R5cGUxLmMNCj4gYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBl
MS5jDQo+ID4gaW5kZXggYjZiZmRmYTE2YzMzLi5lODcyZmIzYTBmMzkgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZp
by92ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiBAQCAtMTg3MywxMiArMTg3Myw4OCBAQCBzdGF0aWMg
dm9pZCB2ZmlvX3Nhbml0eV9jaGVja19wZm5fbGlzdChzdHJ1Y3QNCj4gdmZpb19pb21tdSAqaW9t
bXUpDQo+ID4gIAlXQVJOX09OKGlvbW11LT5ub3RpZmllci5oZWFkKTsNCj4gPiAgfQ0KPiA+DQo+
ID4gKy8qDQo+ID4gKyAqIENhbGxlZCB3aGVuIGEgZG9tYWluIGlzIHJlbW92ZWQgaW4gZGV0YWNo
LiBJdCBpcyBwb3NzaWJsZSB0aGF0DQo+ID4gKyAqIHRoZSByZW1vdmVkIGRvbWFpbiBkZWNpZGVk
IHRoZSBpb3ZhIGFwZXJ0dXJlIHdpbmRvdy4gTW9kaWZ5IHRoZQ0KPiA+ICsgKiBpb3ZhIGFwZXJ0
dXJlIHdpdGggdGhlIHNtYWxsZXN0IHdpbmRvdyBhbW9uZyBleGlzdGluZyBkb21haW5zLg0KPiA+
ICsgKi8NCj4gPiArc3RhdGljIHZvaWQgdmZpb19pb21tdV9hcGVyX2V4cGFuZChzdHJ1Y3QgdmZp
b19pb21tdSAqaW9tbXUsDQo+ID4gKwkJCQkgICBzdHJ1Y3QgbGlzdF9oZWFkICppb3ZhX2NvcHkp
DQo+IE1heWJlIHlvdSBjb3VsZCBqdXN0IHJlbW92ZSBpb3ZhX2NvcHkgZm9yIHRoZSBhcmdzIGFu
ZCByZXR1cm4gc3RhcnQsDQo+IHNpemUuIFNlZSBjb21tZW50IGJlbG93Lg0KPiA+ICt7DQo+ID4g
KwlzdHJ1Y3QgdmZpb19kb21haW4gKmRvbWFpbjsNCj4gPiArCXN0cnVjdCBpb21tdV9kb21haW5f
Z2VvbWV0cnkgZ2VvOw0KPiA+ICsJc3RydWN0IHZmaW9faW92YSAqbm9kZTsNCj4gPiArCWRtYV9h
ZGRyX3Qgc3RhcnQgPSAwOw0KPiA+ICsJZG1hX2FkZHJfdCBlbmQgPSAoZG1hX2FkZHJfdCl+MDsN
Cj4gPiArDQo+ID4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGRvbWFpbiwgJmlvbW11LT5kb21haW5f
bGlzdCwgbmV4dCkgew0KPiA+ICsJCWlvbW11X2RvbWFpbl9nZXRfYXR0cihkb21haW4tPmRvbWFp
biwNCj4gRE9NQUlOX0FUVFJfR0VPTUVUUlksDQo+ID4gKwkJCQkgICAgICAmZ2VvKTsNCj4gPiAr
CQlpZiAoZ2VvLmFwZXJ0dXJlX3N0YXJ0ID4gc3RhcnQpDQo+ID4gKwkJCXN0YXJ0ID0gZ2VvLmFw
ZXJ0dXJlX3N0YXJ0Ow0KPiA+ICsJCWlmIChnZW8uYXBlcnR1cmVfZW5kIDwgZW5kKQ0KPiA+ICsJ
CQllbmQgPSBnZW8uYXBlcnR1cmVfZW5kOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qIE1vZGlm
eSBhcGVydHVyZSBsaW1pdHMuIFRoZSBuZXcgYXBlciBpcyBlaXRoZXIgc2FtZSBvciBiaWdnZXIg
Ki8NCj4gPiArCW5vZGUgPSBsaXN0X2ZpcnN0X2VudHJ5KGlvdmFfY29weSwgc3RydWN0IHZmaW9f
aW92YSwgbGlzdCk7DQo+ID4gKwlub2RlLT5zdGFydCA9IHN0YXJ0Ow0KPiA+ICsJbm9kZSA9IGxp
c3RfbGFzdF9lbnRyeShpb3ZhX2NvcHksIHN0cnVjdCB2ZmlvX2lvdmEsIGxpc3QpOw0KPiA+ICsJ
bm9kZS0+ZW5kID0gZW5kOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBDYWxsZWQg
d2hlbiBhIGdyb3VwIGlzIGRldGFjaGVkLiBUaGUgcmVzZXJ2ZWQgcmVnaW9ucyBmb3IgdGhhdA0K
PiA+ICsgKiBncm91cCBjYW4gYmUgcGFydCBvZiB2YWxpZCBpb3ZhIG5vdy4gQnV0IHNpbmNlIHJl
c2VydmVkIHJlZ2lvbnMNCj4gPiArICogbWF5IGJlIGR1cGxpY2F0ZWQgYW1vbmcgZ3JvdXBzLCBw
b3B1bGF0ZSB0aGUgaW92YSB2YWxpZCByZWdpb25zDQo+ID4gKyAqIGxpc3QgYWdhaW4uDQo+ID4g
KyAqLw0KPiA+ICtzdGF0aWMgaW50IHZmaW9faW9tbXVfcmVzdl9yZWZyZXNoKHN0cnVjdCB2Zmlv
X2lvbW11ICppb21tdSwNCj4gPiArCQkJCSAgIHN0cnVjdCBsaXN0X2hlYWQgKmlvdmFfY29weSkN
Cj4gPiArew0KPiA+ICsJc3RydWN0IHZmaW9fZG9tYWluICpkOw0KPiA+ICsJc3RydWN0IHZmaW9f
Z3JvdXAgKmc7DQo+ID4gKwlzdHJ1Y3QgdmZpb19pb3ZhICpub2RlOw0KPiA+ICsJZG1hX2FkZHJf
dCBzdGFydCwgZW5kOw0KPiA+ICsJTElTVF9IRUFEKHJlc3ZfcmVnaW9ucyk7DQo+ID4gKwlpbnQg
cmV0Ow0KPiA+ICsNCj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkoZCwgJmlvbW11LT5kb21haW5f
bGlzdCwgbmV4dCkgew0KPiA+ICsJCWxpc3RfZm9yX2VhY2hfZW50cnkoZywgJmQtPmdyb3VwX2xp
c3QsIG5leHQpDQo+ID4gKwkJCWlvbW11X2dldF9ncm91cF9yZXN2X3JlZ2lvbnMoZy0+aW9tbXVf
Z3JvdXAsDQo+ID4gKwkJCQkJCSAgICAgJnJlc3ZfcmVnaW9ucyk7DQo+ID4gKwl9DQo+ID4gKw0K
PiA+ICsJaWYgKGxpc3RfZW1wdHkoJnJlc3ZfcmVnaW9ucykpDQo+ID4gKwkJcmV0dXJuIDA7DQo+
IHZmaW9faW9tbXVfYXBlcl9leHBhbmQoKSBqdXN0IGV4dGVuZGVkIHRoZSBzdGFydC9lbmQgb2Yg
Zmlyc3QgJiBsYXN0DQo+IG5vZGUgcmVzcGVjdGl2ZWx5LiAgSW4gY2FzZSB0aGUgaW92YV9jb3B5
KCkgZmVhdHVyZWQgZXhjbHVkZWQgcmVzdg0KPiByZWdpb25zIGJlZm9yZSBhbmQgbm93IHlvdSBk
b24ndCBoYXZlIGFueSBhbnltb3JlLCB0aGUgcHJldmlvdXMgaG9sZXMNCj4gd2lsbCBzdGF5IGlm
IEkgZG9uJ3QgbWlzcyBhbnl0aGluZz8NCg0KR29vZCBjYXRjaCEuIFllcywgSSB0aGluayB0aGVy
ZSBpcyBhIHByb2JsZW0gaGVyZS4NCg0KPiANCj4gWW91IG1heSB1bmNvbmRpdGlvbmFsbHkgcmVj
b21wdXRlIHN0YXJ0L2VuZCwgZnJlZSB0aGUgY29weSwNCj4gYXBlcl9yZXNpemUoKSB3aXRoIG5l
dyBzdGFydC9lbmQgYW5kIGV4Y2x1ZGUgcmVzdiByZWdpb25zIGFnYWluPw0KDQpPay4gSSB3aWxs
IGZpeCB0aGlzIGluIG5leHQgcmV2aXNpb24uDQoNCkNoZWVycywNClNoYW1lZXINCiANCg==
