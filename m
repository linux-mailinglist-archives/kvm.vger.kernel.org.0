Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0096146FE3C
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhLJJ6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:58:47 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15721 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239677AbhLJJ6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:58:45 -0500
Received: from canpemm100003.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J9R5X0Z20zZcDQ;
        Fri, 10 Dec 2021 17:52:16 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm100003.china.huawei.com (7.192.104.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 17:55:09 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 17:55:08 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>
CC:     "bin.meng@windriver.com" <bin.meng@windriver.com>,
        "limingwang (A)" <limingwang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "anup.patel@wdc.com" <anup.patel@wdc.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>
Subject: RE: [PATCH v1 03/12] target/riscv: Implement function
 kvm_arch_init_vcpu
Thread-Topic: [PATCH v1 03/12] target/riscv: Implement function
 kvm_arch_init_vcpu
Thread-Index: AQHX3eLJwQnXP9IbnEK93wh1nF4bZawMd2KAgB8ks/A=
Date:   Fri, 10 Dec 2021 09:55:08 +0000
Message-ID: <8e09fe10ba1a4062831b934a836ff861@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-4-jiangyifei@huawei.com>
 <d3f974e1-6278-8c11-898a-a1cc55965786@linaro.org>
In-Reply-To: <d3f974e1-6278-8c11-898a-a1cc55965786@linaro.org>
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJpY2hhcmQgSGVuZGVyc29u
IFttYWlsdG86cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZ10NCj4gU2VudDogU3VuZGF5LCBO
b3ZlbWJlciAyMSwgMjAyMSA2OjE5IEFNDQo+IFRvOiBKaWFuZ3lpZmVpIDxqaWFuZ3lpZmVpQGh1
YXdlaS5jb20+OyBxZW11LWRldmVsQG5vbmdudS5vcmc7DQo+IHFlbXUtcmlzY3ZAbm9uZ251Lm9y
Zw0KPiBDYzogYmluLm1lbmdAd2luZHJpdmVyLmNvbTsgbGltaW5nd2FuZyAoQSkgPGxpbWluZ3dh
bmdAaHVhd2VpLmNvbT47DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpYnZpci1saXN0QHJlZGhh
dC5jb207IGFudXAucGF0ZWxAd2RjLmNvbTsgd2FuYm8gKEcpDQo+IDx3YW5ibzEzQGh1YXdlaS5j
b20+OyBBbGlzdGFpciBGcmFuY2lzIDxhbGlzdGFpci5mcmFuY2lzQHdkYy5jb20+Ow0KPiBrdm0t
cmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZzsgV2FuZ2hhaWJpbiAoRCkNCj4gPHdhbmdoYWliaW4u
d2FuZ0BodWF3ZWkuY29tPjsgcGFsbWVyQGRhYmJlbHQuY29tOyBGYW5saWFuZyAoRXVsZXJPUykN
Cj4gPGZhbmxpYW5nQGh1YXdlaS5jb20+OyBXdWJpbiAoSCkgPHd1Lnd1YmluQGh1YXdlaS5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMDMvMTJdIHRhcmdldC9yaXNjdjogSW1wbGVtZW50
IGZ1bmN0aW9uDQo+IGt2bV9hcmNoX2luaXRfdmNwdQ0KPiANCj4gT24gMTEvMjAvMjEgODo0NiBB
TSwgWWlmZWkgSmlhbmcgd3JvdGU6DQo+ID4gKyAgICBpZCA9IGt2bV9yaXNjdl9yZWdfaWQoZW52
LCBLVk1fUkVHX1JJU0NWX0NPTkZJRywNCj4gS1ZNX1JFR19SSVNDVl9DT05GSUdfUkVHKGlzYSkp
Ow0KPiA+ICsgICAgcmV0ID0ga3ZtX2dldF9vbmVfcmVnKGNzLCBpZCwgJmlzYSk7DQo+ID4gKyAg
ICBpZiAocmV0KSB7DQo+ID4gKyAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArICAgIH0NCj4gPiAr
ICAgIGVudi0+bWlzYV9teGwgfD0gaXNhOw0KPiANCj4gVGhpcyBkb2Vzbid0IGxvb2sgcmlnaHQu
DQo+IEknbSBzdXJlIHlvdSBtZWFudA0KPiANCj4gICAgICBlbnYtPm1pc2FfZXh0ID0gaXNhOw0K
PiANCj4gDQo+IHJ+DQoNClRoYW5rcywgaXQgd2lsbCBiZSBtb2RpZmllZCBpbiB0aGUgbmV4dCBz
ZXJpZXMuDQoNCllpZmVpDQo=
