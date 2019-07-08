Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB061AD4
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 09:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfGHG7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 02:59:51 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:33058 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbfGHG7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 02:59:51 -0400
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2CD05F0471F05A2FC7B9;
        Mon,  8 Jul 2019 07:59:49 +0100 (IST)
Received: from LHREML524-MBS.china.huawei.com ([169.254.2.154]) by
 lhreml703-cah.china.huawei.com ([10.201.108.44]) with mapi id 14.03.0415.000;
 Mon, 8 Jul 2019 07:59:40 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH v7 2/6] vfio/type1: Check reserve region conflict and
 update iova list
Thread-Topic: [PATCH v7 2/6] vfio/type1: Check reserve region conflict and
 update iova list
Thread-Index: AQHVLDHlfv32Tq6P8k2BSud+nbtQFqa5VEOAgAEf3kCAAXe2AIAEcOwg
Date:   Mon, 8 Jul 2019 06:59:39 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA83F2E198C@lhreml524-mbs.china.huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-3-shameerali.kolothum.thodi@huawei.com>
 <20190703143427.2d63c15f@x1.home>
 <5FC3163CFD30C246ABAA99954A238FA83F2DDB68@lhreml524-mbs.china.huawei.com>
 <d70c59ec-e837-7697-acb1-c2b5027570ee@redhat.com>
In-Reply-To: <d70c59ec-e837-7697-acb1-c2b5027570ee@redhat.com>
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

SGkgRXJpYw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEF1Z2VyIEVy
aWMgW21haWx0bzplcmljLmF1Z2VyQHJlZGhhdC5jb21dDQo+IFNlbnQ6IDA1IEp1bHkgMjAxOSAx
MzoxMA0KPiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1
bS50aG9kaUBodWF3ZWkuY29tPjsNCj4gQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25A
cmVkaGF0LmNvbT4NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGlvbW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnOyBMaW51eGFy
bSA8bGludXhhcm1AaHVhd2VpLmNvbT47IEpvaG4NCj4gR2FycnkgPGpvaG4uZ2FycnlAaHVhd2Vp
LmNvbT47IHh1d2VpIChPKSA8eHV3ZWk1QGh1YXdlaS5jb20+Ow0KPiBrZXZpbi50aWFuQGludGVs
LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY3IDIvNl0gdmZpby90eXBlMTogQ2hlY2sgcmVz
ZXJ2ZSByZWdpb24gY29uZmxpY3QgYW5kDQo+IHVwZGF0ZSBpb3ZhIGxpc3QNCj4gDQo+IEhpIFNo
YW1lZXIsDQo+IA0KPiBPbiA3LzQvMTkgMjo1MSBQTSwgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9k
aSB3cm90ZToNCj4gPg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+
IEZyb206IGt2bS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzprdm0tb3duZXJAdmdlci5r
ZXJuZWwub3JnXSBPbg0KPiA+PiBCZWhhbGYgT2YgQWxleCBXaWxsaWFtc29uDQo+ID4+IFNlbnQ6
IDAzIEp1bHkgMjAxOSAyMTozNA0KPiA+PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8
c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+PiBDYzogZXJpYy5hdWdl
ckByZWRoYXQuY29tOyBwbW9yZWxAbGludXgudm5ldC5pYm0uY29tOw0KPiA+PiBrdm1Admdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBpb21tdUBsaXN0
cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgTGludXhhcm0gPGxpbnV4YXJtQGh1YXdlaS5jb20+Ow0K
PiBKb2huDQo+ID4+IEdhcnJ5IDxqb2huLmdhcnJ5QGh1YXdlaS5jb20+OyB4dXdlaSAoTykgPHh1
d2VpNUBodWF3ZWkuY29tPjsNCj4gPj4ga2V2aW4udGlhbkBpbnRlbC5jb20NCj4gPj4gU3ViamVj
dDogUmU6IFtQQVRDSCB2NyAyLzZdIHZmaW8vdHlwZTE6IENoZWNrIHJlc2VydmUgcmVnaW9uIGNv
bmZsaWN0IGFuZA0KPiA+PiB1cGRhdGUgaW92YSBsaXN0DQo+ID4+DQo+ID4+IE9uIFdlZCwgMjYg
SnVuIDIwMTkgMTY6MTI6NDQgKzAxMDANCj4gPj4gU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVlcmFs
aS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPiB3cm90ZToNCj4gPj4NCj4gPj4+IFRoaXMgcmV0
cmlldmVzIHRoZSByZXNlcnZlZCByZWdpb25zIGFzc29jaWF0ZWQgd2l0aCBkZXYgZ3JvdXAgYW5k
DQo+ID4+PiBjaGVja3MgZm9yIGNvbmZsaWN0cyB3aXRoIGFueSBleGlzdGluZyBkbWEgbWFwcGlu
Z3MuIEFsc28gdXBkYXRlDQo+ID4+PiB0aGUgaW92YSBsaXN0IGV4Y2x1ZGluZyB0aGUgcmVzZXJ2
ZWQgcmVnaW9ucy4NCj4gPj4+DQo+ID4+PiBSZXNlcnZlZCByZWdpb25zIHdpdGggdHlwZSBJT01N
VV9SRVNWX0RJUkVDVF9SRUxBWEFCTEUgYXJlDQo+ID4+PiBleGNsdWRlZCBmcm9tIGFib3ZlIGNo
ZWNrcyBhcyB0aGV5IGFyZSBjb25zaWRlcmVkIGFzIGRpcmVjdGx5DQo+ID4+PiBtYXBwZWQgcmVn
aW9ucyB3aGljaCBhcmUga25vd24gdG8gYmUgcmVsYXhhYmxlLg0KPiA+Pj4NCj4gPj4+IFNpZ25l
ZC1vZmYtYnk6IFNoYW1lZXIgS29sb3RodW0NCj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlA
aHVhd2VpLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gIGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5
cGUxLmMgfCA5Ng0KPiA+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPj4+
ICAxIGZpbGUgY2hhbmdlZCwgOTYgaW5zZXJ0aW9ucygrKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4+IGIvZHJpdmVycy92Zmlv
L3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+Pj4gaW5kZXggOTcwZDFlYzA2YWVkLi5iNmJmZGZhMTZj
MzMgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+
ID4+PiArKysgYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4+PiBAQCAtMTU1
OSw2ICsxNjQxLDcgQEAgc3RhdGljIGludCB2ZmlvX2lvbW11X3R5cGUxX2F0dGFjaF9ncm91cCh2
b2lkDQo+ID4+ICppb21tdV9kYXRhLA0KPiA+Pj4gIAlwaHlzX2FkZHJfdCByZXN2X21zaV9iYXNl
Ow0KPiA+Pj4gIAlzdHJ1Y3QgaW9tbXVfZG9tYWluX2dlb21ldHJ5IGdlbzsNCj4gPj4+ICAJTElT
VF9IRUFEKGlvdmFfY29weSk7DQo+ID4+PiArCUxJU1RfSEVBRChncm91cF9yZXN2X3JlZ2lvbnMp
Ow0KPiA+Pj4NCj4gPj4+ICAJbXV0ZXhfbG9jaygmaW9tbXUtPmxvY2spOw0KPiA+Pj4NCj4gPj4+
IEBAIC0xNjQ0LDYgKzE3MjcsMTMgQEAgc3RhdGljIGludA0KPiB2ZmlvX2lvbW11X3R5cGUxX2F0
dGFjaF9ncm91cCh2b2lkDQo+ID4+ICppb21tdV9kYXRhLA0KPiA+Pj4gIAkJZ290byBvdXRfZGV0
YWNoOw0KPiA+Pj4gIAl9DQo+ID4+Pg0KPiA+Pj4gKwlpb21tdV9nZXRfZ3JvdXBfcmVzdl9yZWdp
b25zKGlvbW11X2dyb3VwLA0KPiAmZ3JvdXBfcmVzdl9yZWdpb25zKTsNCj4gPj4NCj4gPj4gVGhp
cyBjYW4gZmFpbCBhbmQgc2hvdWxkIGhhdmUgYW4gZXJyb3IgY2FzZS4gIEkgYXNzdW1lIHdlJ2Qg
ZmFpbCB0aGUNCj4gPj4gZ3JvdXAgYXR0YWNoIG9uIGZhaWx1cmUuICBUaGFua3MsDQo+ID4NCj4g
PiBSaWdodC4gSSB3aWxsIGFkZCB0aGUgY2hlY2suIERvIHlvdSB0aGluayB3ZSBzaG91bGQgZG8g
dGhlIHNhbWUgaW4NCj4gdmZpb19pb21tdV9oYXNfc3dfbXNpKCkNCj4gPiBhcyB3ZWxsPyAoSW4g
ZmFjdCwgaXQgbG9va3MgbGlrZSBpb21tdV9nZXRfZ3JvdXBfcmVzdl9yZWdpb25zKCkgcmV0IGlz
IG5vdA0KPiBjaGVja2VkIGFueXdoZXJlIGluDQo+ID4ga2VybmVsKS4NCj4gDQo+IEkgdGhpbmsg
dGhlIGNhbiBiZSB0aGUgdG9waWMgb2YgYW5vdGhlciBzZXJpZXMuIEkganVzdCBub3RpY2VkIHRo
YXQgaW4NCj4gaW9tbXVfaW5zZXJ0X3Jlc3ZfcmVnaW9uKCksIHdoaWNoIGlzIHJlY3Vyc2l2ZSBp
biBjYXNlIG90IG1lcmdlLCBJDQo+IGZhaWxlZCB0byBwcm9wYWdhdGUgcmV0dXJuZWQgdmFsdWUg
b3IgcmVjdXJzaXZlIGNhbGxzLiBUaGlzIGFsc28gbmVlZHMNCj4gdG8gYmUgZml4ZWQuIEkgdm9s
dW50ZWVyIHRvIHdvcmsgb24gdGhvc2UgY2hhbmdlcyBpZiB5b3UgcHJlZmVyLiBKdXN0DQo+IGxl
dCBtZSBrbm93Lg0KDQpPay4gUGxlYXNlIGdvIGFoZWFkLg0KDQpUaGFua3MsDQpTaGFtZWVyDQoN
Cg==
