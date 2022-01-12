Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF348BF66
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 09:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351339AbiALIBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 03:01:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30268 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351336AbiALIBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 03:01:30 -0500
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JYg3h1dT1zbjsF;
        Wed, 12 Jan 2022 16:00:48 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 16:01:27 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Wed, 12 Jan 2022 16:01:27 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Alistair Francis <alistair23@gmail.com>
CC:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "open list:Overall" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "limingwang (A)" <limingwang@huawei.com>,
        Anup Patel <anup.patel@wdc.com>
Subject: RE: [PATCH v4 05/12] target/riscv: Implement kvm_arch_put_registers
Thread-Topic: [PATCH v4 05/12] target/riscv: Implement kvm_arch_put_registers
Thread-Index: AQHYBcLY5qBMkgvcJUyw1KKH9Z+yrqxcW9gAgAKtocA=
Date:   Wed, 12 Jan 2022 08:01:27 +0000
Message-ID: <d5f384244df6442faae5e4812d9791ab@huawei.com>
References: <20220110013831.1594-1-jiangyifei@huawei.com>
 <20220110013831.1594-6-jiangyifei@huawei.com>
 <CAKmqyKPsSidxir_1fncugsmLK33aSbHk63MP0JnS3OJLvy65EA@mail.gmail.com>
In-Reply-To: <CAKmqyKPsSidxir_1fncugsmLK33aSbHk63MP0JnS3OJLvy65EA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.186.236]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFsaXN0YWlyIEZyYW5jaXMg
W21haWx0bzphbGlzdGFpcjIzQGdtYWlsLmNvbV0NCj4gU2VudDogVHVlc2RheSwgSmFudWFyeSAx
MSwgMjAyMiA3OjA3IEFNDQo+IFRvOiBKaWFuZ3lpZmVpIDxqaWFuZ3lpZmVpQGh1YXdlaS5jb20+
DQo+IENjOiBxZW11LWRldmVsQG5vbmdudS5vcmcgRGV2ZWxvcGVycyA8cWVtdS1kZXZlbEBub25n
bnUub3JnPjsgb3Blbg0KPiBsaXN0OlJJU0MtViA8cWVtdS1yaXNjdkBub25nbnUub3JnPjsga3Zt
LXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmc7IG9wZW4NCj4gbGlzdDpPdmVyYWxsIDxrdm1Admdl
ci5rZXJuZWwub3JnPjsgbGlidmlyLWxpc3RAcmVkaGF0LmNvbTsgQW51cCBQYXRlbA0KPiA8YW51
cEBicmFpbmZhdWx0Lm9yZz47IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAZGFiYmVsdC5jb20+OyBB
bGlzdGFpcg0KPiBGcmFuY2lzIDxBbGlzdGFpci5GcmFuY2lzQHdkYy5jb20+OyBCaW4gTWVuZyA8
YmluLm1lbmdAd2luZHJpdmVyLmNvbT47DQo+IEZhbmxpYW5nIChFdWxlck9TKSA8ZmFubGlhbmdA
aHVhd2VpLmNvbT47IFd1YmluIChIKQ0KPiA8d3Uud3ViaW5AaHVhd2VpLmNvbT47IFdhbmdoYWli
aW4gKEQpIDx3YW5naGFpYmluLndhbmdAaHVhd2VpLmNvbT47DQo+IHdhbmJvIChHKSA8d2FuYm8x
M0BodWF3ZWkuY29tPjsgbGltaW5nd2FuZyAoQSkNCj4gPGxpbWluZ3dhbmdAaHVhd2VpLmNvbT47
IEFudXAgUGF0ZWwgPGFudXAucGF0ZWxAd2RjLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
NCAwNS8xMl0gdGFyZ2V0L3Jpc2N2OiBJbXBsZW1lbnQga3ZtX2FyY2hfcHV0X3JlZ2lzdGVycw0K
PiANCj4gT24gTW9uLCBKYW4gMTAsIDIwMjIgYXQgMTE6NTcgQU0gWWlmZWkgSmlhbmcgdmlhIDxx
ZW11LWRldmVsQG5vbmdudS5vcmc+DQo+IHdyb3RlOg0KPiA+DQo+ID4gUHV0IEdQUiBDU1IgYW5k
IEZQIHJlZ2lzdGVycyB0byBrdm0gYnkgS1ZNX1NFVF9PTkVfUkVHIGlvY3RsDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBZaWZlaSBKaWFuZyA8amlhbmd5aWZlaUBodWF3ZWkuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IE1pbmd3YW5nIExpIDxsaW1pbmd3YW5nQGh1YXdlaS5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IEFsaXN0YWlyIEZyYW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNvbT4NCj4g
PiBSZXZpZXdlZC1ieTogQW51cCBQYXRlbCA8YW51cC5wYXRlbEB3ZGMuY29tPg0KPiA+IC0tLQ0K
PiA+ICB0YXJnZXQvcmlzY3Yva3ZtLmMgfCAxMDQNCj4gPiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwMyBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3Jpc2N2
L2t2bS5jIGIvdGFyZ2V0L3Jpc2N2L2t2bS5jIGluZGV4DQo+ID4gNmQ0ZGYwZWY2ZC4uZTY5NWI5
MWRjNyAxMDA2NDQNCj4gPiAtLS0gYS90YXJnZXQvcmlzY3Yva3ZtLmMNCj4gPiArKysgYi90YXJn
ZXQvcmlzY3Yva3ZtLmMNCj4gPiBAQCAtNzMsNiArNzMsMTQgQEAgc3RhdGljIHVpbnQ2NF90IGt2
bV9yaXNjdl9yZWdfaWQoQ1BVUklTQ1ZTdGF0ZSAqZW52LA0KPiB1aW50NjRfdCB0eXBlLCB1aW50
NjRfdCBpZHgNCj4gPiAgICAgICAgICB9IFwNCj4gPiAgICAgIH0gd2hpbGUoMCkNCj4gPg0KPiA+
ICsjZGVmaW5lIEtWTV9SSVNDVl9TRVRfQ1NSKGNzLCBlbnYsIGNzciwgcmVnKSBcDQo+ID4gKyAg
ICBkbyB7IFwNCj4gPiArICAgICAgICBpbnQgcmV0ID0ga3ZtX3NldF9vbmVfcmVnKGNzLCBSSVND
Vl9DU1JfUkVHKGVudiwgY3NyKSwgJnJlZyk7IFwNCj4gPiArICAgICAgICBpZiAocmV0KSB7IFwN
Cj4gPiArICAgICAgICAgICAgcmV0dXJuIHJldDsgXA0KPiA+ICsgICAgICAgIH0gXA0KPiA+ICsg
ICAgfSB3aGlsZSgwKQ0KPiANCj4gVGhpcyBmYWlscyBjaGVja3BhdGNoLiBJIGtub3cgdGhlcmUg
aXMgbG90cyBvZiBRRU1VIGNvZGUgbGlrZSB0aGlzLCBidXQgaXQgcHJvYmFibHkNCj4gc2hvdWxk
IGJlIGB3aGlsZSAoMClgIHRvIGtlZXAgY2hlY2twYXRjaCBoYXBweS4NCj4gDQo+IFBsZWFzZSBy
dW4gY2hlY2twYXRjaCBvbiBhbGwgdGhlIHBhdGNoZXMuDQo+IA0KPiBBbGlzdGFpcg0KDQpPSywg
aXQgd2lsbCBiZSBtb2RpZmllZCBpbiB0aGUgbmV4dCBzZXJpZXMuDQoNCllpZmVpDQo=
