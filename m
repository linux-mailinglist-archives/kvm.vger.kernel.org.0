Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAD3359436
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 06:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhDIEyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 00:54:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3522 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhDIEyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 00:54:38 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FGm2Z0NyGzRWCj;
        Fri,  9 Apr 2021 12:52:22 +0800 (CST)
Received: from dggpemm000002.china.huawei.com (7.185.36.174) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 9 Apr 2021 12:54:23 +0800
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggpemm000002.china.huawei.com (7.185.36.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 12:54:23 +0800
Received: from dggpemm000003.china.huawei.com ([7.185.36.128]) by
 dggpemm000003.china.huawei.com ([7.185.36.128]) with mapi id 15.01.2106.013;
 Fri, 9 Apr 2021 12:54:23 +0800
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
Thread-Index: AQHXFGTEBL9vagM8VUiybsk55NZ2y6qrwTfw
Date:   Fri, 9 Apr 2021 04:54:23 +0000
Message-ID: <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524004828.3480.1817334832614722574.stgit@gimli.home>
In-Reply-To: <161524004828.3480.1817334832614722574.stgit@gimli.home>
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
tDPmnIg55pelIDU6NDcNCj4g5pS25Lu25Lq6OiBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbQ0K
PiDmioTpgIE6IGNvaHVja0ByZWRoYXQuY29tOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBqZ2dAbnZpZGlhLmNvbTsgcGV0ZXJ4QHJlZGhhdC5j
b20NCj4g5Li76aKYOiBbUEFUQ0ggdjEgMDEvMTRdIHZmaW86IENyZWF0ZSB2ZmlvX2ZzX3R5cGUg
d2l0aCBpbm9kZSBwZXIgZGV2aWNlDQo+IA0KPiBCeSBsaW5raW5nIGFsbCB0aGUgZGV2aWNlIGZk
cyB3ZSBwcm92aWRlIHRvIHVzZXJzcGFjZSB0byBhbiBhZGRyZXNzIHNwYWNlDQo+IHRocm91Z2gg
YSBuZXcgcHNldWRvIGZzLCB3ZSBjYW4gdXNlIHRvb2xzIGxpa2UNCj4gdW5tYXBfbWFwcGluZ19y
YW5nZSgpIHRvIHphcCBhbGwgdm1hcyBhc3NvY2lhdGVkIHdpdGggYSBkZXZpY2UuDQo+IA0KPiBT
dWdnZXN0ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy92ZmlvL3ZmaW8uYyB8ICAgNTQNCj4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNTQgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmMgYi9kcml2
ZXJzL3ZmaW8vdmZpby5jIGluZGV4DQo+IDM4Nzc5ZTZmZDgwYy4uYWJkZjhkNTJhOTExIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpby5jDQo+ICsrKyBiL2RyaXZlcnMvdmZpby92Zmlv
LmMNCj4gQEAgLTMyLDExICszMiwxOCBAQA0KPiAgI2luY2x1ZGUgPGxpbnV4L3ZmaW8uaD4NCj4g
ICNpbmNsdWRlIDxsaW51eC93YWl0Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvc2NoZWQvc2lnbmFs
Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvcHNldWRvX2ZzLmg+DQo+ICsjaW5jbHVkZSA8bGludXgv
bW91bnQuaD4NCk1pbm9yOiBrZWVwIHRoZSBoZWFkZXJzIGluIGFscGhhYmV0aWNhbCBvcmRlci4N
Cg0KPiANCj4gICNkZWZpbmUgRFJJVkVSX1ZFUlNJT04JIjAuMyINCj4gICNkZWZpbmUgRFJJVkVS
X0FVVEhPUgkiQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4iDQo+
ICAjZGVmaW5lIERSSVZFUl9ERVNDCSJWRklPIC0gVXNlciBMZXZlbCBtZXRhLWRyaXZlciINCj4g
DQo+ICsjZGVmaW5lIFZGSU9fTUFHSUMgMHg1NjQ2NDk0ZiAvKiAiVkZJTyIgKi8NCk1vdmUgdG8g
aW5jbHVkZS91YXBpL2xpbnV4L21hZ2ljLmggPyANCg0KPiArDQo+ICtzdGF0aWMgaW50IHZmaW9f
ZnNfY250Ow0KPiArc3RhdGljIHN0cnVjdCB2ZnNtb3VudCAqdmZpb19mc19tbnQ7DQo+ICsNCj4g
IHN0YXRpYyBzdHJ1Y3QgdmZpbyB7DQo+ICAJc3RydWN0IGNsYXNzCQkJKmNsYXNzOw0KPiAgCXN0
cnVjdCBsaXN0X2hlYWQJCWlvbW11X2RyaXZlcnNfbGlzdDsNCj4gQEAgLTk3LDYgKzEwNCw3IEBA
IHN0cnVjdCB2ZmlvX2RldmljZSB7DQo+ICAJc3RydWN0IHZmaW9fZ3JvdXAJCSpncm91cDsNCj4g
IAlzdHJ1Y3QgbGlzdF9oZWFkCQlncm91cF9uZXh0Ow0KPiAgCXZvaWQJCQkJKmRldmljZV9kYXRh
Ow0KPiArCXN0cnVjdCBpbm9kZQkJCSppbm9kZTsNCj4gIH07DQo+IA0KPiAgI2lmZGVmIENPTkZJ
R19WRklPX05PSU9NTVUNCj4gQEAgLTUyOSw2ICs1MzcsMzQgQEAgc3RhdGljIHN0cnVjdCB2Zmlv
X2dyb3VwDQo+ICp2ZmlvX2dyb3VwX2dldF9mcm9tX2RldihzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+
ICAJcmV0dXJuIGdyb3VwOw0KPiAgfQ0KPiANCj4gK3N0YXRpYyBpbnQgdmZpb19mc19pbml0X2Zz
X2NvbnRleHQoc3RydWN0IGZzX2NvbnRleHQgKmZjKSB7DQo+ICsJcmV0dXJuIGluaXRfcHNldWRv
KGZjLCBWRklPX01BR0lDKSA/IDAgOiAtRU5PTUVNOyB9DQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3Qg
ZmlsZV9zeXN0ZW1fdHlwZSB2ZmlvX2ZzX3R5cGUgPSB7DQo+ICsJLm5hbWUgPSAidmZpbyIsDQo+
ICsJLm93bmVyID0gVEhJU19NT0RVTEUsDQo+ICsJLmluaXRfZnNfY29udGV4dCA9IHZmaW9fZnNf
aW5pdF9mc19jb250ZXh0LA0KPiArCS5raWxsX3NiID0ga2lsbF9hbm9uX3N1cGVyLA0KPiArfTsN
Cj4gKw0KPiArc3RhdGljIHN0cnVjdCBpbm9kZSAqdmZpb19mc19pbm9kZV9uZXcodm9pZCkgew0K
PiArCXN0cnVjdCBpbm9kZSAqaW5vZGU7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHNp
bXBsZV9waW5fZnMoJnZmaW9fZnNfdHlwZSwgJnZmaW9fZnNfbW50LCAmdmZpb19mc19jbnQpOw0K
PiArCWlmIChyZXQpDQo+ICsJCXJldHVybiBFUlJfUFRSKHJldCk7DQo+ICsNCj4gKwlpbm9kZSA9
IGFsbG9jX2Fub25faW5vZGUodmZpb19mc19tbnQtPm1udF9zYik7DQo+ICsJaWYgKElTX0VSUihp
bm9kZSkpDQo+ICsJCXNpbXBsZV9yZWxlYXNlX2ZzKCZ2ZmlvX2ZzX21udCwgJnZmaW9fZnNfY250
KTsNCj4gKw0KPiArCXJldHVybiBpbm9kZTsNCj4gK30NCj4gKw0KPiAgLyoqDQo+ICAgKiBEZXZp
Y2Ugb2JqZWN0cyAtIGNyZWF0ZSwgcmVsZWFzZSwgZ2V0LCBwdXQsIHNlYXJjaA0KPiAgICovDQo+
IEBAIC01MzksMTEgKzU3NSwxOSBAQCBzdHJ1Y3QgdmZpb19kZXZpY2UNCj4gKnZmaW9fZ3JvdXBf
Y3JlYXRlX2RldmljZShzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXAsDQo+ICAJCQkJCSAgICAgdm9p
ZCAqZGV2aWNlX2RhdGEpDQo+ICB7DQo+ICAJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2U7DQo+
ICsJc3RydWN0IGlub2RlICppbm9kZTsNCj4gDQo+ICAJZGV2aWNlID0ga3phbGxvYyhzaXplb2Yo
KmRldmljZSksIEdGUF9LRVJORUwpOw0KPiAgCWlmICghZGV2aWNlKQ0KPiAgCQlyZXR1cm4gRVJS
X1BUUigtRU5PTUVNKTsNCj4gDQo+ICsJaW5vZGUgPSB2ZmlvX2ZzX2lub2RlX25ldygpOw0KPiAr
CWlmIChJU19FUlIoaW5vZGUpKSB7DQo+ICsJCWtmcmVlKGRldmljZSk7DQo+ICsJCXJldHVybiBF
UlJfQ0FTVChpbm9kZSk7DQo+ICsJfQ0KPiArCWRldmljZS0+aW5vZGUgPSBpbm9kZTsNCj4gKw0K
PiAgCWtyZWZfaW5pdCgmZGV2aWNlLT5rcmVmKTsNCj4gIAlkZXZpY2UtPmRldiA9IGRldjsNCj4g
IAlkZXZpY2UtPmdyb3VwID0gZ3JvdXA7DQo+IEBAIC01NzQsNiArNjE4LDkgQEAgc3RhdGljIHZv
aWQgdmZpb19kZXZpY2VfcmVsZWFzZShzdHJ1Y3Qga3JlZiAqa3JlZikNCj4gDQo+ICAJZGV2X3Nl
dF9kcnZkYXRhKGRldmljZS0+ZGV2LCBOVUxMKTsNCj4gDQo+ICsJaXB1dChkZXZpY2UtPmlub2Rl
KTsNCj4gKwlzaW1wbGVfcmVsZWFzZV9mcygmdmZpb19mc19tbnQsICZ2ZmlvX2ZzX2NudCk7DQo+
ICsNCj4gIAlrZnJlZShkZXZpY2UpOw0KPiANCj4gIAkvKiB2ZmlvX2RlbF9ncm91cF9kZXYgbWF5
IGJlIHdhaXRpbmcgZm9yIHRoaXMgZGV2aWNlICovIEBAIC0xNDg4LDYNCj4gKzE1MzUsMTMgQEAg
c3RhdGljIGludCB2ZmlvX2dyb3VwX2dldF9kZXZpY2VfZmQoc3RydWN0IHZmaW9fZ3JvdXAgKmdy
b3VwLA0KPiBjaGFyICpidWYpDQo+ICAJICovDQo+ICAJZmlsZXAtPmZfbW9kZSB8PSAoRk1PREVf
TFNFRUsgfCBGTU9ERV9QUkVBRCB8IEZNT0RFX1BXUklURSk7DQo+IA0KPiArCS8qDQo+ICsJICog
VXNlIHRoZSBwc2V1ZG8gZnMgaW5vZGUgb24gdGhlIGRldmljZSB0byBsaW5rIGFsbCBtbWFwcw0K
PiArCSAqIHRvIHRoZSBzYW1lIGFkZHJlc3Mgc3BhY2UsIGFsbG93aW5nIHVzIHRvIHVubWFwIGFs
bCB2bWFzDQo+ICsJICogYXNzb2NpYXRlZCB0byB0aGlzIGRldmljZSB1c2luZyB1bm1hcF9tYXBw
aW5nX3JhbmdlKCkuDQo+ICsJICovDQo+ICsJZmlsZXAtPmZfbWFwcGluZyA9IGRldmljZS0+aW5v
ZGUtPmlfbWFwcGluZzsNCj4gKw0KPiAgCWF0b21pY19pbmMoJmdyb3VwLT5jb250YWluZXJfdXNl
cnMpOw0KPiANCj4gIAlmZF9pbnN0YWxsKHJldCwgZmlsZXApOw0KDQo=
