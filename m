Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE13BBB2A
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhGEKZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:25:51 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3362 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhGEKZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 06:25:51 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJM1r5KNFz6M4KL;
        Mon,  5 Jul 2021 18:12:32 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 12:23:12 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:23:12 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 5 Jul 2021 11:23:12 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 3/4] crypto: hisilicon/qm - Export mailbox functions for
 common use
Thread-Topic: [RFC v2 3/4] crypto: hisilicon/qm - Export mailbox functions for
 common use
Thread-Index: AQHXbyj8BxvtavY7fkydwvpGgOj6XasygHiAgAGwWRA=
Date:   Mon, 5 Jul 2021 10:23:12 +0000
Message-ID: <0ebcb89c4fc64d289d5ffcdfe03529ec@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-4-shameerali.kolothum.thodi@huawei.com>
 <2f9c5fee-fcd1-3512-fef8-f2707df621ba@nvidia.com>
In-Reply-To: <2f9c5fee-fcd1-3512-fef8-f2707df621ba@nvidia.com>
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
YWlsdG86bWd1cnRvdm95QG52aWRpYS5jb21dDQo+IFNlbnQ6IDA0IEp1bHkgMjAyMSAxMDozNA0K
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogYWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb207IGpnZ0BudmlkaWEuY29tOyBMaW51eGFybQ0KPiA8bGludXhh
cm1AaHVhd2VpLmNvbT47IGxpdWxvbmdmYW5nIDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPjsgWmVu
Z3RhbyAoQikNCj4gPHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IHl1emVuZ2h1aSA8eXV6ZW5n
aHVpQGh1YXdlaS5jb20+OyBKb25hdGhhbg0KPiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1
YXdlaS5jb20+OyBXYW5nemhvdSAoQikNCj4gPHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiBT
dWJqZWN0OiBSZTogW1JGQyB2MiAzLzRdIGNyeXB0bzogaGlzaWxpY29uL3FtIC0gRXhwb3J0IG1h
aWxib3ggZnVuY3Rpb25zIGZvcg0KPiBjb21tb24gdXNlDQo+IA0KPiANCj4gT24gNy8yLzIwMjEg
MTI6NTggUE0sIFNoYW1lZXIgS29sb3RodW0gd3JvdGU6DQo+ID4gRnJvbTogTG9uZ2ZhbmcgTGl1
IDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPg0KPiA+DQo+ID4gRXhwb3J0IFFNIG1haWxib3ggZnVu
Y3Rpb25zIHNvIHRoYXQgdGhleSBjYW4gYmUgdXNlZCBmcm9tIEhpU2lsaWNvbg0KPiA+IEFDQyB2
ZmlvIGxpdmUgbWlncmF0aW9uIGRyaXZlciBpbiBmb2xsb3ctdXAgcGF0Y2guDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBMb25nZmFuZyBMaXUgPGxpdWxvbmdmYW5nQGh1YXdlaS5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogU2hhbWVlciBLb2xvdGh1bQ0KPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50
aG9kaUBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9jcnlwdG8vaGlzaWxpY29u
L3FtLmMgfCA4ICsrKysrLS0tDQo+ID4gICBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uaCB8
IDQgKysrKw0KPiA+ICAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3Ft
LmMNCj4gPiBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9xbS5jIGluZGV4IGNlNDM5YTBjNjZj
OS4uODdmYzAxOTk3MDVlDQo+ID4gMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL3FtLmMNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uYw0KPiA+
IEBAIC00OTIsNyArNDkyLDcgQEAgc3RhdGljIGJvb2wgcW1fcXBfYXZhaWxfc3RhdGUoc3RydWN0
IGhpc2lfcW0gKnFtLA0KPiBzdHJ1Y3QgaGlzaV9xcCAqcXAsDQo+ID4gICB9DQo+ID4NCj4gPiAg
IC8qIHJldHVybiAwIG1haWxib3ggcmVhZHksIC1FVElNRURPVVQgaGFyZHdhcmUgdGltZW91dCAq
LyAtc3RhdGljDQo+ID4gaW50IHFtX3dhaXRfbWJfcmVhZHkoc3RydWN0IGhpc2lfcW0gKnFtKQ0K
PiA+ICtpbnQgcW1fd2FpdF9tYl9yZWFkeShzdHJ1Y3QgaGlzaV9xbSAqcW0pDQo+ID4gICB7DQo+
ID4gICAJdTMyIHZhbDsNCj4gPg0KPiA+IEBAIC01MDAsNiArNTAwLDcgQEAgc3RhdGljIGludCBx
bV93YWl0X21iX3JlYWR5KHN0cnVjdCBoaXNpX3FtICpxbSkNCj4gPiAgIAkJCQkJICB2YWwsICEo
KHZhbCA+PiBRTV9NQl9CVVNZX1NISUZUKSAmDQo+ID4gICAJCQkJCSAgMHgxKSwgUE9MTF9QRVJJ
T0QsIFBPTExfVElNRU9VVCk7DQo+ID4gICB9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKHFtX3dh
aXRfbWJfcmVhZHkpOw0KPiA+DQo+ID4gICAvKiAxMjggYml0IHNob3VsZCBiZSB3cml0dGVuIHRv
IGhhcmR3YXJlIGF0IG9uZSB0aW1lIHRvIHRyaWdnZXIgYSBtYWlsYm94DQo+ICovDQo+ID4gICBz
dGF0aWMgdm9pZCBxbV9tYl93cml0ZShzdHJ1Y3QgaGlzaV9xbSAqcW0sIGNvbnN0IHZvaWQgKnNy
YykgQEANCj4gPiAtNTIzLDggKzUyNCw4IEBAIHN0YXRpYyB2b2lkIHFtX21iX3dyaXRlKHN0cnVj
dCBoaXNpX3FtICpxbSwgY29uc3Qgdm9pZA0KPiAqc3JjKQ0KPiA+ICAgCQkgICAgIDogIm1lbW9y
eSIpOw0KPiA+ICAgfQ0KPiA+DQo+ID4gLXN0YXRpYyBpbnQgcW1fbWIoc3RydWN0IGhpc2lfcW0g
KnFtLCB1OCBjbWQsIGRtYV9hZGRyX3QgZG1hX2FkZHIsIHUxNg0KPiBxdWV1ZSwNCj4gPiAtCQkg
Ym9vbCBvcCkNCj4gPiAraW50IHFtX21iKHN0cnVjdCBoaXNpX3FtICpxbSwgdTggY21kLCBkbWFf
YWRkcl90IGRtYV9hZGRyLCB1MTYgcXVldWUsDQo+ID4gKwkgIGJvb2wgb3ApDQo+ID4gICB7DQo+
ID4gICAJc3RydWN0IHFtX21haWxib3ggbWFpbGJveDsNCj4gPiAgIAlpbnQgcmV0ID0gMDsNCj4g
PiBAQCAtNTYzLDYgKzU2NCw3IEBAIHN0YXRpYyBpbnQgcW1fbWIoc3RydWN0IGhpc2lfcW0gKnFt
LCB1OCBjbWQsDQo+IGRtYV9hZGRyX3QgZG1hX2FkZHIsIHUxNiBxdWV1ZSwNCj4gPiAgIAkJYXRv
bWljNjRfaW5jKCZxbS0+ZGVidWcuZGZ4Lm1iX2Vycl9jbnQpOw0KPiA+ICAgCXJldHVybiByZXQ7
DQo+ID4gICB9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKHFtX21iKTsNCj4gPg0KPiA+ICAgc3Rh
dGljIHZvaWQgcW1fZGJfdjEoc3RydWN0IGhpc2lfcW0gKnFtLCB1MTYgcW4sIHU4IGNtZCwgdTE2
IGluZGV4LCB1OA0KPiBwcmlvcml0eSkNCj4gPiAgIHsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vaGlzaWxpY29uL3FtLmgNCj4gPiBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9x
bS5oIGluZGV4IGFjZWZkZjhiM2E1MC4uMThiMDEwZDU0NTJkDQo+ID4gMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3FtLmgNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0
by9oaXNpbGljb24vcW0uaA0KPiA+IEBAIC0zOTYsNiArMzk2LDEwIEBAIHBjaV9lcnNfcmVzdWx0
X3QgaGlzaV9xbV9kZXZfc2xvdF9yZXNldChzdHJ1Y3QNCj4gcGNpX2RldiAqcGRldik7DQo+ID4g
ICB2b2lkIGhpc2lfcW1fcmVzZXRfcHJlcGFyZShzdHJ1Y3QgcGNpX2RldiAqcGRldik7DQo+ID4g
ICB2b2lkIGhpc2lfcW1fcmVzZXRfZG9uZShzdHJ1Y3QgcGNpX2RldiAqcGRldik7DQo+ID4NCj4g
PiAraW50IHFtX3dhaXRfbWJfcmVhZHkoc3RydWN0IGhpc2lfcW0gKnFtKTsgaW50IHFtX21iKHN0
cnVjdCBoaXNpX3FtDQo+ID4gKypxbSwgdTggY21kLCBkbWFfYWRkcl90IGRtYV9hZGRyLCB1MTYg
cXVldWUsDQo+ID4gKwkgIGJvb2wgb3ApOw0KPiA+ICsNCj4gDQo+IG1heWJlIHlvdSBjYW4gcHV0
IGl0IHVuZGVyIGluY2x1ZGUvbGludXgvLi4gPw0KDQpPay4gSSBzdXBwb3NlIHdlIGNvdWxkIGRv
IHRoYXQuDQoNClRoYW5rcywNClNoYW1lZXINCg0KPiANCj4gDQo+ID4gICBzdHJ1Y3QgaGlzaV9h
Y2Nfc2dsX3Bvb2w7DQo+ID4gICBzdHJ1Y3QgaGlzaV9hY2NfaHdfc2dsICpoaXNpX2FjY19zZ19i
dWZfbWFwX3RvX2h3X3NnbChzdHJ1Y3QgZGV2aWNlDQo+ICpkZXYsDQo+ID4gICAJc3RydWN0IHNj
YXR0ZXJsaXN0ICpzZ2wsIHN0cnVjdCBoaXNpX2FjY19zZ2xfcG9vbCAqcG9vbCwNCg==
