Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CE3BBB21
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGEKVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:21:40 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3361 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhGEKVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 06:21:39 -0400
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJM036r5xz6G8CN;
        Mon,  5 Jul 2021 18:10:59 +0800 (CST)
Received: from lhreml713-chm.china.huawei.com (10.201.108.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 5 Jul 2021 12:19:00 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml713-chm.china.huawei.com (10.201.108.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:19:00 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 5 Jul 2021 11:19:00 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHXbyjyY32E69+qSUOJDcpRvpWsY6syVlwAgAGohwCAABXkAIAAGLOw
Date:   Mon, 5 Jul 2021 10:18:59 +0000
Message-ID: <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal> <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
In-Reply-To: <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.49]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF4IEd1cnRvdm95IFtt
YWlsdG86bWd1cnRvdm95QG52aWRpYS5jb21dDQo+IFNlbnQ6IDA1IEp1bHkgMjAyMSAxMDo0Mg0K
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsNCj4gTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+DQo+IENj
OiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBs
aW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsg
amdnQG52aWRpYS5jb207DQo+IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsgbGl1bG9u
Z2ZhbmcgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+Ow0KPiBaZW5ndGFvIChCKSA8cHJpbWUuemVu
Z0BoaXNpbGljb24uY29tPjsgeXV6ZW5naHVpDQo+IDx5dXplbmdodWlAaHVhd2VpLmNvbT47IEpv
bmF0aGFuIENhbWVyb24NCj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IFdhbmd6aG91
IChCKSA8d2FuZ3pob3UxQGhpc2lsaWNvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYyIDEv
NF0gaGlzaS1hY2MtdmZpby1wY2k6IGFkZCBuZXcgdmZpb19wY2kgZHJpdmVyIGZvciBIaVNpbGlj
b24NCj4gQUNDIGRldmljZXMNCj4gDQo+IA0KPiBPbiA3LzUvMjAyMSAxMTo0NyBBTSwgU2hhbWVl
cmFsaSBLb2xvdGh1bSBUaG9kaSB3cm90ZToNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+PiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgW21haWx0bzpsZW9uQGtlcm5lbC5v
cmddDQo+ID4+IFNlbnQ6IDA0IEp1bHkgMjAyMSAwODowNA0KPiA+PiBUbzogU2hhbWVlcmFsaSBL
b2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+
PiBDYzoga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsN
Cj4gPj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgYWxleC53aWxsaWFtc29uQHJlZGhh
dC5jb207DQo+IGpnZ0BudmlkaWEuY29tOw0KPiA+PiBtZ3VydG92b3lAbnZpZGlhLmNvbTsgTGlu
dXhhcm0gPGxpbnV4YXJtQGh1YXdlaS5jb20+OyBsaXVsb25nZmFuZw0KPiA+PiA8bGl1bG9uZ2Zh
bmdAaHVhd2VpLmNvbT47IFplbmd0YW8gKEIpIDxwcmltZS56ZW5nQGhpc2lsaWNvbi5jb20+Ow0K
PiA+PiB5dXplbmdodWkgPHl1emVuZ2h1aUBodWF3ZWkuY29tPjsgSm9uYXRoYW4gQ2FtZXJvbg0K
PiA+PiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPjsgV2FuZ3pob3UgKEIpDQo+IDx3YW5n
emhvdTFAaGlzaWxpY29uLmNvbT4NCj4gPj4gU3ViamVjdDogUmU6IFtSRkMgdjIgMS80XSBoaXNp
LWFjYy12ZmlvLXBjaTogYWRkIG5ldyB2ZmlvX3BjaSBkcml2ZXIgZm9yDQo+IEhpU2lsaWNvbg0K
PiA+PiBBQ0MgZGV2aWNlcw0KPiA+Pg0KPiA+PiBPbiBGcmksIEp1bCAwMiwgMjAyMSBhdCAxMDo1
ODo0NkFNICswMTAwLCBTaGFtZWVyIEtvbG90aHVtIHdyb3RlOg0KPiA+Pj4gQWRkIGEgdmVuZG9y
LXNwZWNpZmljIHZmaW9fcGNpIGRyaXZlciBmb3IgSGlTaWxpY29uIEFDQyBkZXZpY2VzLg0KPiA+
Pj4gVGhpcyB3aWxsIGJlIGV4dGVuZGVkIGluIGZvbGxvdy11cCBwYXRjaGVzIHRvIGFkZCBzdXBw
b3J0IGZvcg0KPiA+Pj4gdmZpbyBsaXZlIG1pZ3JhdGlvbiBmZWF0dXJlLg0KPiA+Pj4NCj4gPj4+
IFNpZ25lZC1vZmYtYnk6IFNoYW1lZXIgS29sb3RodW0NCj4gPj4gPHNoYW1lZXJhbGkua29sb3Ro
dW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICBkcml2ZXJzL3ZmaW8vcGNp
L0tjb25maWcgICAgICAgICAgICAgfCAgIDkgKysrDQo+ID4+PiAgIGRyaXZlcnMvdmZpby9wY2kv
TWFrZWZpbGUgICAgICAgICAgICB8ICAgMiArDQo+ID4+PiAgIGRyaXZlcnMvdmZpby9wY2kvaGlz
aV9hY2NfdmZpb19wY2kuYyB8IDEwMA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
Pj4+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxMTEgaW5zZXJ0aW9ucygrKQ0KPiA+Pj4gICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy92ZmlvL3BjaS9oaXNpX2FjY192ZmlvX3BjaS5jDQo+ID4+IDwu
Li4+DQo+ID4+DQo+ID4+PiArc3RhdGljIGNvbnN0IHN0cnVjdCB2ZmlvX2RldmljZV9vcHMgaGlz
aV9hY2NfdmZpb19wY2lfb3BzID0gew0KPiA+Pj4gKwkubmFtZQkJPSAiaGlzaS1hY2MtdmZpby1w
Y2kiLA0KPiA+Pj4gKwkub3BlbgkJPSBoaXNpX2FjY192ZmlvX3BjaV9vcGVuLA0KPiA+Pj4gKwku
cmVsZWFzZQk9IHZmaW9fcGNpX2NvcmVfcmVsZWFzZSwNCj4gPj4+ICsJLmlvY3RsCQk9IHZmaW9f
cGNpX2NvcmVfaW9jdGwsDQo+ID4+PiArCS5yZWFkCQk9IHZmaW9fcGNpX2NvcmVfcmVhZCwNCj4g
Pj4+ICsJLndyaXRlCQk9IHZmaW9fcGNpX2NvcmVfd3JpdGUsDQo+ID4+PiArCS5tbWFwCQk9IHZm
aW9fcGNpX2NvcmVfbW1hcCwNCj4gPj4+ICsJLnJlcXVlc3QJPSB2ZmlvX3BjaV9jb3JlX3JlcXVl
c3QsDQo+ID4+PiArCS5tYXRjaAkJPSB2ZmlvX3BjaV9jb3JlX21hdGNoLA0KPiA+Pj4gKwkucmVm
bGNrX2F0dGFjaAk9IHZmaW9fcGNpX2NvcmVfcmVmbGNrX2F0dGFjaCwNCj4gPj4gSSBkb24ndCBy
ZW1lbWJlciB3aGF0IHdhcyBwcm9wb3NlZCBpbiB2ZmlvLXBjaS1jb3JlIGNvbnZlcnNpb24gcGF0
Y2hlcywNCj4gPj4gYnV0IHdvdWxkIGV4cGVjdCB0aGF0IGRlZmF1bHQgYmVoYXZpb3VyIGlzIHRv
IGZhbGxiYWNrIHRvIHZmaW9fcGNpX2NvcmVfKg0KPiBBUEkNCj4gPj4gaWYgIi5yZWxlYXNlLy5p
b2N0bC9lLnQuYyIgYXJlIG5vdCByZWRlZmluZWQuDQo+ID4gWWVzLCB0aGF0IHdvdWxkIGJlIG5p
Y2UsIGJ1dCBkb24ndCB0aGluayBpdCBkb2VzIHRoYXQgaW4gbGF0ZXN0KHY0KS4NCj4gPg0KPiA+
IEhpIE1heCwNCj4gPiBDb3VsZCB3ZSBwbGVhc2UgY29uc2lkZXIgZmFsbCBiYWNrIHRvIHRoZSBj
b3JlIGRlZmF1bHRzLCBtYXkgYmUgY2hlY2sgYW5kDQo+IGFzc2lnbiBkZWZhdWx0cw0KPiA+IGlu
IHZmaW9fcGNpX2NvcmVfcmVnaXN0ZXJfZGV2aWNlKCkgPw0KPiANCj4gSSBkb24ndCBzZWUgd2h5
IHdlIHNob3VsZCBkbyB0aGlzLg0KPiANCj4gdmZpb19wY2lfY29yZS5rbyBpcyBqdXN0IGEgbGli
cmFyeSBkcml2ZXIuIEl0IHNob3VsZG4ndCBkZWNpZGUgZm9yIHRoZQ0KPiB2ZW5kb3IgZHJpdmVy
IG9wcy4NCj4gDQo+IElmIGEgdmVuZG9yIGRyaXZlciB3b3VsZCBsaWtlIHRvIHVzZSBpdHMgaGVs
cGVyIGZ1bmN0aW9ucyAtIGdyZWF0Lg0KPiANCj4gSWYgaXQgd2FudHMgdG8gb3ZlcnJpZGUgaXQg
LSBncmVhdC4NCj4gDQo+IElmIGl0IHdhbnRzIHRvIGxlYXZlIHNvbWUgb3AgYXMgTlVMTCAtIGl0
IGNhbiBkbyBpdCBhbHNvLg0KDQpCYXNlZCBvbiB0aGUgZG9jdW1lbnRhdGlvbiBvZiB0aGUgdmZp
b19kZXZpY2Vfb3BzIGNhbGxiYWNrcywNCkl0IGxvb2tzIGxpa2Ugd2UgYWxyZWFkeSBoYXZlIGEg
cHJlY2VkZW5jZSBpbiB0aGUgY2FzZSBvZiByZWZsY2tfYXR0YWNoDQpjYWxsYmFjayB3aGVyZSBp
dCB1c2VzIHRoZSB2ZmlvIGNvcmUgZGVmYXVsdCBvbmUsIGlmIGl0IGlzIG5vdCBpbXBsZW1lbnRl
ZC4NCg0KQWxzbyBJIHdvdWxkIGltYWdpbmUgdGhhdCBpbiBtYWpvcml0eSB1c2UgY2FzZXMgdGhl
IHZlbmRvciBkcml2ZXJzIHdpbGwgYmUNCmRlZmF1bHRpbmcgdG8gY29yZSBmdW5jdGlvbnMuIA0K
DQpJIHRoaW5rLCBpbiBhbnkgY2FzZSwgaXQgd291bGQgYmUgZ29vZCB0byB1cGRhdGUgdGhlIERv
Y3VtZW50YXRpb24gYmFzZWQgb24NCndoaWNoIHdheSB3ZSBlbmQgdXAgZG9pbmcgdGhpcy4NCg0K
VGhhbmtzLA0KU2hhbWVlciANCg0KIA0KPiANCj4gDQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gU2hh
bWVlcg0K
