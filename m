Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2047AA11
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhLTNCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:02:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29267 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhLTNCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:02:03 -0500
Received: from dggeme705-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHfqR65P5zbjX8;
        Mon, 20 Dec 2021 21:01:39 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggeme705-chm.china.huawei.com (10.1.199.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:02:01 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Mon, 20 Dec 2021 21:02:01 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        Anup Patel <anup@brainfault.org>
CC:     Bin Meng <bin.meng@windriver.com>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "limingwang (A)" <limingwang@huawei.com>,
        "KVM General" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "wanbo (G)" <wanbo13@huawei.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>
Subject: RE: [PATCH v2 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Thread-Topic: [PATCH v2 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Thread-Index: AQHX7a3NGxny0stTC0W1/sN92xUJx6wvXMSAgACreYCAC1/TIA==
Date:   Mon, 20 Dec 2021 13:02:01 +0000
Message-ID: <229748f67a154a728f149b02e1f097f9@huawei.com>
References: <20211210100732.1080-1-jiangyifei@huawei.com>
 <20211210100732.1080-11-jiangyifei@huawei.com>
 <CAAhSdy11yd+f6OZZxjX9mWxkVH4AC7Kz5Vp+RPUz6cCam9GvNQ@mail.gmail.com>
 <dec3147b-24bc-7e48-680b-a7423b0640f9@linaro.org>
In-Reply-To: <dec3147b-24bc-7e48-680b-a7423b0640f9@linaro.org>
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
IFttYWlsdG86cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZ10NCj4gU2VudDogTW9uZGF5LCBE
ZWNlbWJlciAxMywgMjAyMSAxMToyMCBQTQ0KPiBUbzogQW51cCBQYXRlbCA8YW51cEBicmFpbmZh
dWx0Lm9yZz47IEppYW5neWlmZWkgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4NCj4gQ2M6IEJpbiBN
ZW5nIDxiaW4ubWVuZ0B3aW5kcml2ZXIuY29tPjsgb3BlbiBsaXN0OlJJU0MtVg0KPiA8cWVtdS1y
aXNjdkBub25nbnUub3JnPjsgbGltaW5nd2FuZyAoQSkgPGxpbWluZ3dhbmdAaHVhd2VpLmNvbT47
IEtWTQ0KPiBHZW5lcmFsIDxrdm1Admdlci5rZXJuZWwub3JnPjsgbGlidmlyLWxpc3RAcmVkaGF0
LmNvbTsgQW51cCBQYXRlbA0KPiA8YW51cC5wYXRlbEB3ZGMuY29tPjsgUUVNVSBEZXZlbG9wZXJz
IDxxZW11LWRldmVsQG5vbmdudS5vcmc+Ow0KPiB3YW5ibyAoRykgPHdhbmJvMTNAaHVhd2VpLmNv
bT47IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAZGFiYmVsdC5jb20+Ow0KPiBrdm0tcmlzY3ZAbGlz
dHMuaW5mcmFkZWFkLm9yZzsgV2FuZ2hhaWJpbiAoRCkNCj4gPHdhbmdoYWliaW4ud2FuZ0BodWF3
ZWkuY29tPjsgQWxpc3RhaXIgRnJhbmNpcw0KPiA8QWxpc3RhaXIuRnJhbmNpc0B3ZGMuY29tPjsg
RmFubGlhbmcgKEV1bGVyT1MpIDxmYW5saWFuZ0BodWF3ZWkuY29tPjsNCj4gV3ViaW4gKEgpIDx3
dS53dWJpbkBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDEwLzEyXSB0YXJn
ZXQvcmlzY3Y6IEFkZCBrdm1fcmlzY3ZfZ2V0L3B1dF9yZWdzX3RpbWVyDQo+IA0KPiBPbiAxMi8x
Mi8yMSA5OjA1IFBNLCBBbnVwIFBhdGVsIHdyb3RlOg0KPiA+PiArICAgIHJldCA9IGt2bV9nZXRf
b25lX3JlZyhjcywgUklTQ1ZfVElNRVJfUkVHKGVudiwgc3RhdGUpLCAmcmVnKTsNCj4gPj4gKyAg
ICBpZiAocmV0KSB7DQo+ID4+ICsgICAgICAgIGFib3J0KCk7DQo+ID4+ICsgICAgfQ0KPiA+PiAr
ICAgIGVudi0+a3ZtX3RpbWVyX3N0YXRlID0gcmVnOw0KPiA+DQo+ID4gUGxlYXNlIHJlYWQgdGhl
IHRpbWVyIGZyZXF1ZW5jeSBoZXJlLg0KPiANCj4gWWVwLg0KPiANCj4gPj4gKw0KPiA+PiArICAg
IGVudi0+a3ZtX3RpbWVyX2RpcnR5ID0gdHJ1ZTsNCj4gPj4gK30NCj4gPj4gKw0KPiA+PiArc3Rh
dGljIHZvaWQga3ZtX3Jpc2N2X3B1dF9yZWdzX3RpbWVyKENQVVN0YXRlICpjcykgew0KPiA+PiAr
ICAgIGludCByZXQ7DQo+ID4+ICsgICAgdWludDY0X3QgcmVnOw0KPiA+PiArICAgIENQVVJJU0NW
U3RhdGUgKmVudiA9ICZSSVNDVl9DUFUoY3MpLT5lbnY7DQo+ID4+ICsNCj4gPj4gKyAgICBpZiAo
IWVudi0+a3ZtX3RpbWVyX2RpcnR5KSB7DQo+ID4+ICsgICAgICAgIHJldHVybjsNCj4gPj4gKyAg
ICB9DQo+ID4NCj4gPiBPdmVyIGhlcmUsIHdlIHNob3VsZCBnZXQgdGhlIHRpbWVyIGZyZXF1ZW5j
eSBhbmQgYWJvcnQoKSB3aXRoIGFuIGVycm9yDQo+ID4gbWVzc2FnZSBpZiBpdCBkb2VzIG5vdCBt
YXRjaCBlbnYtPmt2bV90aW1lcl9mcmVxdWVuY3kNCj4gPg0KPiA+IEZvciBub3csIG1pZ3JhdGlv
biB3aWxsIG5vdCB3b3JrIGJldHdlZW4gSG9zdHMgd2l0aCBkaWZmZXJlbnQgdGltZXINCj4gPiBm
cmVxdWVuY3kuDQo+IA0KPiBZb3Ugc2hvdWxkbid0IGhhdmUgdG8gZG8gdGhpcyBldmVyeSAicHV0
Iiwgb25seSBvbiBtaWdyYXRpb24sIGF0IHdoaWNoIHBvaW50IHlvdQ0KPiBjYW4gYWN0dWFsbHkg
c2lnbmFsIGEgbWlncmF0aW9uIGVycm9yIHJhdGhlciB0aGFuIGFib3J0aW5nIGRpcmVjdGx5Lg0K
PiANCj4gDQo+IHJ+DQoNClllcywgaXQgd2lsbCBiZSBtb2RpZmllZCBpbiB0aGUgbmV4dCBzZXJp
ZXMuDQoNCllpZmVpDQo=
