Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A182530BF
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgHZN5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 09:57:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3075 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730520AbgHZN5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 09:57:01 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 280655977C8843E0192B;
        Wed, 26 Aug 2020 21:56:54 +0800 (CST)
Received: from DGGEML423-HUB.china.huawei.com (10.1.199.40) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 26 Aug 2020 21:56:53 +0800
Received: from DGGEML524-MBX.china.huawei.com ([169.254.1.71]) by
 dggeml423-hub.china.huawei.com ([10.1.199.40]) with mapi id 14.03.0487.000;
 Wed, 26 Aug 2020 21:56:43 +0800
From:   "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggVjJdIHZmaW8gZG1hX21hcC91bm1hcDogb3B0aW1p?=
 =?utf-8?Q?zed_for_hugetlbfs_pages?=
Thread-Topic: [PATCH V2] vfio dma_map/unmap: optimized for hugetlbfs pages
Thread-Index: AQHWcePn246e6Z2xQkKwoyKqsTP1MqlI20CAgAGejeA=
Date:   Wed, 26 Aug 2020 13:56:43 +0000
Message-ID: <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
 <20200825205907.GB8235@xz-x1>
In-Reply-To: <20200825205907.GB8235@xz-x1>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.151.129]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCg0KDQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IFBldGVyIFh1IFttYWls
dG86cGV0ZXJ4QHJlZGhhdC5jb21dIA0K5Y+R6YCB5pe26Ze0OiAyMDIw5bm0OOaciDI25pelIDQ6
NTkNCuaUtuS7tuS6ujogTWFvbWluZyAobWFvbWluZywgQ2xvdWQgSW5mcmFzdHJ1Y3R1cmUgU2Vy
dmljZSBQcm9kdWN0IERlcHQuKSA8bWFvbWluZy5tYW9taW5nQGh1YXdlaS5jb20+DQrmioTpgIE6
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tOyBjb2h1Y2tAcmVkaGF0LmNvbTsgWmhvdWppYW4gKGpheSkg
PGppYW5qYXkuemhvdUBodWF3ZWkuY29tPjsgSHVhbmd3ZWlkb25nIChDKSA8d2VpZG9uZy5odWFu
Z0BodWF3ZWkuY29tPjsgYWFyY2FuZ2VAcmVkaGF0LmNvbQ0K5Li76aKYOiBSZTogW1BBVENIIFYy
XSB2ZmlvIGRtYV9tYXAvdW5tYXA6IG9wdGltaXplZCBmb3IgaHVnZXRsYmZzIHBhZ2VzDQoNCk9u
IEZyaSwgQXVnIDE0LCAyMDIwIGF0IDEwOjM3OjI5QU0gKzA4MDAsIE1pbmcgTWFvIHdyb3RlOg0K
PiArc3RhdGljIGxvbmcgaHVnZXRsYl9wYWdlX3ZhZGRyX2dldF9wZm4odW5zaWduZWQgbG9uZyB2
YWRkciwgbG9uZyBucGFnZSwNCj4gKwkJCQkJCXVuc2lnbmVkIGxvbmcgcGZuKQ0KPiArew0KPiAr
CWxvbmcgaHVnZXRsYl9yZXNpZHVhbF9ucGFnZTsNCj4gKwlsb25nIGNvbnRpZ3VvdXNfbnBhZ2U7
DQo+ICsJc3RydWN0IHBhZ2UgKmhlYWQgPSBjb21wb3VuZF9oZWFkKHBmbl90b19wYWdlKHBmbikp
Ow0KPiArDQo+ICsJLyoNCj4gKwkgKiBJZiBwZm4gaXMgdmFsaWQsDQo+ICsJICogaHVnZXRsYl9y
ZXNpZHVhbF9ucGFnZSBpcyBncmVhdGVyIHRoYW4gb3IgZXF1YWwgdG8gMS4NCj4gKwkgKi8NCj4g
KwlodWdldGxiX3Jlc2lkdWFsX25wYWdlID0gaHVnZXRsYl9nZXRfcmVzaWR1YWxfcGFnZXModmFk
ZHIsDQo+ICsJCQkJCQljb21wb3VuZF9vcmRlcihoZWFkKSk7DQo+ICsJaWYgKGh1Z2V0bGJfcmVz
aWR1YWxfbnBhZ2UgPCAwKQ0KPiArCQlyZXR1cm4gLTE7DQo+ICsNCj4gKwkvKiBUaGUgcGFnZSBv
ZiB2YWRkciBoYXMgYmVlbiBnb3R0ZW4gYnkgdmFkZHJfZ2V0X3BmbiAqLw0KPiArCWNvbnRpZ3Vv
dXNfbnBhZ2UgPSBtaW5fdChsb25nLCAoaHVnZXRsYl9yZXNpZHVhbF9ucGFnZSAtIDEpLCBucGFn
ZSk7DQo+ICsJaWYgKCFjb250aWd1b3VzX25wYWdlKQ0KPiArCQlyZXR1cm4gMDsNCj4gKwkvKg0K
PiArCSAqIFVubGlrZSBUSFAsIHRoZSBzcGxpdHRpbmcgc2hvdWxkIG5vdCBoYXBwZW4gZm9yIGh1
Z2V0bGIgcGFnZXMuDQo+ICsJICogU2luY2UgUEdfcmVzZXJ2ZWQgaXMgbm90IHJlbGV2YW50IGZv
ciBjb21wb3VuZCBwYWdlcywgYW5kIHRoZSBwZm4gb2YNCj4gKwkgKiBQQUdFX1NJWkUgcGFnZSB3
aGljaCBpbiBodWdldGxiIHBhZ2VzIGlzIHZhbGlkLA0KPiArCSAqIGl0IGlzIG5vdCBuZWNlc3Nh
cnkgdG8gY2hlY2sgcnN2ZCBmb3IgaHVnZXRsYiBwYWdlcy4NCj4gKwkgKiBXZSBkbyBub3QgbmVl
ZCB0byBhbGxvYyBwYWdlcyBiZWNhdXNlIG9mIHZhZGRyIGFuZCB3ZSBjYW4gZmluaXNoIGFsbA0K
PiArCSAqIHdvcmsgYnkgYSBzaW5nbGUgb3BlcmF0aW9uIHRvIHRoZSBoZWFkIHBhZ2UuDQo+ICsJ
ICovDQo+ICsJYXRvbWljX2FkZChjb250aWd1b3VzX25wYWdlLCBjb21wb3VuZF9waW5jb3VudF9w
dHIoaGVhZCkpOw0KPiArCXBhZ2VfcmVmX2FkZChoZWFkLCBjb250aWd1b3VzX25wYWdlKTsNCj4g
Kwltb2Rfbm9kZV9wYWdlX3N0YXRlKHBhZ2VfcGdkYXQoaGVhZCksIE5SX0ZPTExfUElOX0FDUVVJ
UkVELCANCj4gK2NvbnRpZ3VvdXNfbnBhZ2UpOw0KDQpJIHRoaW5rIEkgYXNrZWQgdGhpcyBxdWVz
dGlvbiBpbiB2MSwgYnV0IEkgZGlkbid0IGdldCBhbnkgYW5zd2VyLi4uIFNvIEknbSB0cnlpbmcg
YWdhaW4uLi4NCg0KQ291bGQgSSBhc2sgd2h5IG1hbnVhbCByZWZlcmVuY2luZyBvZiBwYWdlcyBp
cyBkb25lIGhlcmUgcmF0aGVyIHRoYW4gdXNpbmcNCnBpbl91c2VyX3BhZ2VzX3JlbW90ZSgpIGp1
c3QgbGlrZSB3aGF0IHdlJ3ZlIGRvbmUgd2l0aCB2YWRkcl9nZXRfcGZuKCksIGFuZCBsZXQNCnRy
eV9ncmFiX3BhZ2UoKSB0byBkbyB0aGUgcGFnZSByZWZlcmVuY2UgYW5kIGFjY291bnRpbmdzPw0K
DQpJIGZlZWwgbGlrZSB0aGlzIGF0IGxlYXN0IGlzIGFnYWluc3QgdGhlIEZPTExfUElOIHdvcmtm
bG93IG9mIGd1cCwgYmVjYXVzZSB0aG9zZSBGT0xMX1BJTiBwYXRocyB3ZXJlIGJ5cGFzc2VkLCBh
ZmFpY3QuDQoNCg0KSGksDQpNeSBhcG9sb2dpZXMgZm9yIG5vdCBhbnN3ZXJpbmcgeW91ciBxdWVz
dGlvbi4NCkFzIEkgdW5kZXJzdGFuZCwgcGluX3VzZXJfcGFnZXNfcmVtb3RlKCkgbWlnaHQgc3Bl
bmQgbXVjaCB0aW1lLg0KQmVjYXVzZSBhbGwgUEFHRV9TSVpFLXBhZ2VzIGluIGEgaHVnZXRsYiBw
YWdlIGFyZSBwaW5uZWQgb25lIGJ5IG9uZSBpbiBwaW5fdXNlcl9wYWdlc19yZW1vdGUoKSBhbmQg
dHJ5X2dyYWJfcGFnZSgpLg0KU28gSSB0aGluayBtYXliZSB3ZSBjYW4gdXNlIHRoZXNlIHNpbXBs
ZSBjb2RlIHRvIGRvIGFsbCB3b3JrLg0KQW0gSSB3cm9uZz8gQW5kIGlzIHRoZXJlIHNvbWV0aGlu
ZyBlbHNlIHdlIGNhbiB1c2U/IEZvciBleGFtcGxlIDpwaW5fdXNlcl9wYWdlc19mYXN0KCkNCg0K
DQo+ICsNCj4gKwlyZXR1cm4gY29udGlndW91c19ucGFnZTsNCj4gK30NCg0KLS0NClBldGVyIFh1
DQoNCg==
