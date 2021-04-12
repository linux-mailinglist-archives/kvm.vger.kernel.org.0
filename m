Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3929A35B935
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhDLEKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:10:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5127 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhDLEKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:10:06 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FJZvf4HGpzYWLD;
        Mon, 12 Apr 2021 12:07:42 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 12 Apr 2021 12:09:46 +0800
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggpemm000001.china.huawei.com (7.185.36.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 12:09:46 +0800
Received: from dggpemm000003.china.huawei.com ([7.185.36.128]) by
 dggpemm000003.china.huawei.com ([7.185.36.128]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 12:09:46 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjEgMDEvMTRdIHZmaW86IENyZWF0ZSB2ZmlvX2Zz?=
 =?utf-8?Q?=5Ftype_with_inode_per_device?=
Thread-Topic: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per device
Thread-Index: AQHXFGTEBL9vagM8VUiybsk55NZ2y6qrwTfwgAAn2gCABI/PsA==
Date:   Mon, 12 Apr 2021 04:09:46 +0000
Message-ID: <6a551b830c6d4850b970ab5d6d4e9f16@hisilicon.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
        <161524004828.3480.1817334832614722574.stgit@gimli.home>
        <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
 <20210409082400.1004fcef@x1.home.shazbot.org>
In-Reply-To: <20210409082400.1004fcef@x1.home.shazbot.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.69.38.183]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLemCruS7tuWOn+S7ti0tLS0tDQo+IOWPkeS7tuS6ujogQWxleCBXaWxsaWFtc29uIFtt
YWlsdG86YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAyMeW5
tDTmnIg55pelIDIyOjI0DQo+IOaUtuS7tuS6ujogWmVuZ3RhbyAoQikgPHByaW1lLnplbmdAaGlz
aWxpY29uLmNvbT4NCj4g5oqE6YCBOiBjb2h1Y2tAcmVkaGF0LmNvbTsga3ZtQHZnZXIua2VybmVs
Lm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgamdnQG52aWRpYS5jb207IHBl
dGVyeEByZWRoYXQuY29tDQo+IOS4u+mimDogUmU6IFtQQVRDSCB2MSAwMS8xNF0gdmZpbzogQ3Jl
YXRlIHZmaW9fZnNfdHlwZSB3aXRoIGlub2RlIHBlciBkZXZpY2UNCj4gDQo+IE9uIEZyaSwgOSBB
cHIgMjAyMSAwNDo1NDoyMyArMDAwMA0KPiAiWmVuZ3RhbyAoQikiIDxwcmltZS56ZW5nQGhpc2ls
aWNvbi5jb20+IHdyb3RlOg0KPiANCj4gPiA+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4gPiA+
IOWPkeS7tuS6ujogQWxleCBXaWxsaWFtc29uIFttYWlsdG86YWxleC53aWxsaWFtc29uQHJlZGhh
dC5jb21dDQo+ID4gPiDlj5HpgIHml7bpl7Q6IDIwMjHlubQz5pyIOeaXpSA1OjQ3DQo+ID4gPiDm
lLbku7bkuro6IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tDQo+ID4gPiDmioTpgIE6IGNvaHVj
a0ByZWRoYXQuY29tOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiA+ID4gbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgamdnQG52aWRpYS5jb207IHBldGVyeEByZWRoYXQuY29tDQo+ID4gPiDk
uLvpopg6IFtQQVRDSCB2MSAwMS8xNF0gdmZpbzogQ3JlYXRlIHZmaW9fZnNfdHlwZSB3aXRoIGlu
b2RlIHBlciBkZXZpY2UNCj4gPiA+DQo+ID4gPiBCeSBsaW5raW5nIGFsbCB0aGUgZGV2aWNlIGZk
cyB3ZSBwcm92aWRlIHRvIHVzZXJzcGFjZSB0byBhbiBhZGRyZXNzDQo+ID4gPiBzcGFjZSB0aHJv
dWdoIGEgbmV3IHBzZXVkbyBmcywgd2UgY2FuIHVzZSB0b29scyBsaWtlDQo+ID4gPiB1bm1hcF9t
YXBwaW5nX3JhbmdlKCkgdG8gemFwIGFsbCB2bWFzIGFzc29jaWF0ZWQgd2l0aCBhIGRldmljZS4N
Cj4gPiA+DQo+ID4gPiBTdWdnZXN0ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNv
bkByZWRoYXQuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy92ZmlvL3ZmaW8uYyB8ICAg
NTQNCj4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspDQo+ID4gPg0KPiA+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmMgYi9kcml2ZXJzL3ZmaW8vdmZpby5j
IGluZGV4DQo+ID4gPiAzODc3OWU2ZmQ4MGMuLmFiZGY4ZDUyYTkxMSAxMDA2NDQNCj4gPiA+IC0t
LSBhL2RyaXZlcnMvdmZpby92ZmlvLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvLmMN
Cj4gPiA+IEBAIC0zMiwxMSArMzIsMTggQEANCj4gPiA+ICAjaW5jbHVkZSA8bGludXgvdmZpby5o
Pg0KPiA+ID4gICNpbmNsdWRlIDxsaW51eC93YWl0Lmg+DQo+ID4gPiAgI2luY2x1ZGUgPGxpbnV4
L3NjaGVkL3NpZ25hbC5oPg0KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9wc2V1ZG9fZnMuaD4NCj4g
PiA+ICsjaW5jbHVkZSA8bGludXgvbW91bnQuaD4NCj4gPiBNaW5vcjoga2VlcCB0aGUgaGVhZGVy
cyBpbiBhbHBoYWJldGljYWwgb3JkZXIuDQo+IA0KPiBUaGV5IHN0YXJ0ZWQgb3V0IHRoYXQgd2F5
LCBidXQgdmFyaW91cyB0cmVlLXdpZGUgY2hhbmdlcyBpZ25vcmluZyB0aGF0LCBhbmQNCj4gbGlr
ZWx5IG92ZXJzaWdodHMgb24gbXkgcGFydCBhcyB3ZWxsLCBoYXMgbGVmdCB1cyB3aXRoIG51bWVy
b3VzIGJyZWFrcyBpbiB0aGF0DQo+IHJ1bGUgYWxyZWFkeS4NCj4gDQo+ID4gPg0KPiA+ID4gICNk
ZWZpbmUgRFJJVkVSX1ZFUlNJT04JIjAuMyINCj4gPiA+ICAjZGVmaW5lIERSSVZFUl9BVVRIT1IJ
IkFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+Ig0KPiA+ID4g
ICNkZWZpbmUgRFJJVkVSX0RFU0MJIlZGSU8gLSBVc2VyIExldmVsIG1ldGEtZHJpdmVyIg0KPiA+
ID4NCj4gPiA+ICsjZGVmaW5lIFZGSU9fTUFHSUMgMHg1NjQ2NDk0ZiAvKiAiVkZJTyIgKi8NCj4g
PiBNb3ZlIHRvIGluY2x1ZGUvdWFwaS9saW51eC9tYWdpYy5oID8NCj4gDQo+IEhtbSwgeWVhaCwg
SSBzdXBwb3NlIGl0IHByb2JhYmx5IHNob3VsZCBnbyB0aGVyZS4gIFRoYW5rcy4NCj4gDQo+IEZX
SVcsIEknbSBzdGlsbCB3b3JraW5nIG9uIGEgbmV4dCB2ZXJzaW9uIG9mIHRoaXMgc2VyaWVzLCBj
dXJyZW50bHkgc3RydWdnbGluZw0KPiBob3cgdG8gaGFuZGxlIGFuIGFyYml0cmFyeSBudW1iZXIg
b2Ygdm1hcyBwZXIgdXNlciBETUEgbWFwcGluZy4gIFRoYW5rcywNCj4gDQoNCldpbGwgZG8gc29t
ZSB0ZXN0aW5nIG9uIG91ciBwbGF0Zm9ybSwgYW5kIHdhbnQgdG8gbWFrZSBzdXJlIHRoZSBpc3N1
ZQ0KIEkgcmVwb3J0ZWQgaXMgaW5jbHVkZWQgOiANCiBodHRwczovL3BhdGNod29yay5rZXJuZWwu
b3JnL3Byb2plY3Qva3ZtL3BhdGNoLzE2MTUyMDE4OTAtODg3LTEtZ2l0LXNlbmQtZW1haWwtcHJp
bWUuemVuZ0BoaXNpbGljb24uY29tLw0KIA0KIFRoYW5rcw0KIHplbmd0YW8NCg0KDQo+IEFsZXgN
Cg0K
