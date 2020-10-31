Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9E52A12CE
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 03:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgJaCUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 22:20:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2422 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaCUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 22:20:25 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CNNF35fNhz4wjS;
        Sat, 31 Oct 2020 10:20:23 +0800 (CST)
Received: from dggema757-chm.china.huawei.com (10.1.198.199) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 31 Oct 2020 10:20:22 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema757-chm.china.huawei.com (10.1.198.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 31 Oct 2020 10:20:22 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Sat, 31 Oct 2020 10:20:22 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHZmaW86IHBsYXRmb3JtOiBmaXggcmVmZXJlbmNl?=
 =?utf-8?B?IGxlYWsgaW4gdmZpb19wbGF0Zm9ybV9vcGVu?=
Thread-Topic: [PATCH] vfio: platform: fix reference leak in vfio_platform_open
Thread-Index: AQHWrtSwcdQJsuLJmkC2ly2HJv4yZ6mw9I4A
Date:   Sat, 31 Oct 2020 02:20:22 +0000
Message-ID: <df107e9bf9784e239cbf7e2b1b1c659f@huawei.com>
References: <20201030154754.99431-1-zhangqilong3@huawei.com>
 <8260f3ed-1b0a-d6d9-f058-9580949bf34e@redhat.com>
In-Reply-To: <8260f3ed-1b0a-d6d9-f058-9580949bf34e@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIEF1Z2VyDQoNCj4gT24gMTAvMzAvMjAgNDo0NyBQTSwgWmhhbmcgUWlsb25nIHdyb3RlOg0K
PiA+IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSB3aWxsIGluY3JlbWVudCBwbSB1c2FnZSBjb3VudGVy
IGV2ZW4gaXQgZmFpbGVkLg0KPiA+IEZvcmdldHRpbmcgdG8gY2FsbCBwbV9ydW50aW1lX3B1dF9u
b2lkbGUgd2lsbCByZXN1bHQgaW4gcmVmZXJlbmNlIGxlYWsNCj4gPiBpbiB2ZmlvX3BsYXRmb3Jt
X29wZW4sIHNvIHdlIHNob3VsZCBmaXggaXQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBaaGFu
ZyBRaWxvbmcgPHpoYW5ncWlsb25nM0BodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L3ZmaW8vcGxhdGZvcm0vdmZpb19wbGF0Zm9ybV9jb21tb24uYyB8IDQgKysrLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BsYXRmb3JtL3ZmaW9fcGxhdGZvcm1fY29tbW9uLmMNCj4g
PiBiL2RyaXZlcnMvdmZpby9wbGF0Zm9ybS92ZmlvX3BsYXRmb3JtX2NvbW1vbi5jDQo+ID4gaW5k
ZXggYzA3NzFhOTU2N2ZiLi5hYTk3ZjE2Nzg5ODEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92
ZmlvL3BsYXRmb3JtL3ZmaW9fcGxhdGZvcm1fY29tbW9uLmMNCj4gPiArKysgYi9kcml2ZXJzL3Zm
aW8vcGxhdGZvcm0vdmZpb19wbGF0Zm9ybV9jb21tb24uYw0KPiA+IEBAIC0yNjYsOCArMjY2LDEw
IEBAIHN0YXRpYyBpbnQgdmZpb19wbGF0Zm9ybV9vcGVuKHZvaWQgKmRldmljZV9kYXRhKQ0KPiA+
ICAJCQlnb3RvIGVycl9pcnE7DQo+ID4NCj4gPiAgCQlyZXQgPSBwbV9ydW50aW1lX2dldF9zeW5j
KHZkZXYtPmRldmljZSk7DQo+ID4gLQkJaWYgKHJldCA8IDApDQo+ID4gKwkJaWYgKHJldCA8IDAp
IHsNCj4gPiArCQkJcG1fcnVudGltZV9wdXRfbm9pZGxlKHZkZXYtPmRldmljZSk7DQo+IGNhbid0
IHdlIGp1bXAgdG8gZXJyX3JzdCB0aGVuPw0KDQpXZSBjb3VsZCBqdW1wIHRvIGVycl9yc3QgaGVy
ZS4gVGhlIGRpZmZlcmVuY2UgaXMgdGhhdCBwbV9ydW50aW1lX3B1dCB3aWxsIGxlYXZlIHRoaXMN
CmRldmljZSBpZGxlIHN0YXRlIGlmIHdlIGRlY3JlYXNlIHVzYWdlIGNvdW50IGZhaWxlZCB0aGF0
IGlzIG1lYW5sZXNzLiBCZWNhdXNlIHRoaXMNCm1vZHVsZSB3aWxsIGJlIHB1dC4gR2VuZXJhbGx5
IHNwZWFraW5nLCB0aGUgYWN0aW9uIG9mIHBtX3J1bnRpbWVfcHV0IGFuZA0KcG1fcnVudGltZV9w
dXRfbm9pZGxlIGlzIHRoZSBzYW1lIGhlcmUgdGhhdCBvbmx5IGRlY3JlYXNlcyB1c2FnZSBjb3Vu
dC4gSnVtcGluZyB0bw0KZXJyX3JzdCBjb3VsZCBiZSBtb3JlIGJldHRlciBmb3IgcmVhZCB2aWV3
LiBJJ2xsIGltcHJvdmUgaXQgaW4gcGF0Y2ggVjIuDQoNClRoYW5rcw0KDQpaaGFuZyBRaWxvbmcN
Cj4gDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPiA+ICAJCQlnb3RvIGVycl9wbTsNCj4gPiArCQl9
DQo+ID4NCj4gPiAgCQlyZXQgPSB2ZmlvX3BsYXRmb3JtX2NhbGxfcmVzZXQodmRldiwgJmV4dHJh
X2RiZyk7DQo+ID4gIAkJaWYgKHJldCAmJiB2ZGV2LT5yZXNldF9yZXF1aXJlZCkgew0KPiA+DQoN
Cg==
