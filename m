Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B9747AA13
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhLTNC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:02:56 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30077 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhLTNCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:02:55 -0500
Received: from canpemm100007.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JHfnH37hxz1DK9N;
        Mon, 20 Dec 2021 20:59:47 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm100007.china.huawei.com (7.192.105.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:02:53 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Mon, 20 Dec 2021 21:02:53 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>
CC:     "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "anup.patel@wdc.com" <anup.patel@wdc.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Alistair.Francis@wdc.com" <Alistair.Francis@wdc.com>,
        "bin.meng@windriver.com" <bin.meng@windriver.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "limingwang (A)" <limingwang@huawei.com>
Subject: RE: [PATCH v2 12/12] target/riscv: Support virtual time context
 synchronization
Thread-Topic: [PATCH v2 12/12] target/riscv: Support virtual time context
 synchronization
Thread-Index: AQHX7a3Q8Bse7NrOd02XaMfvJUw+zqwwCNIAgAtfe4A=
Date:   Mon, 20 Dec 2021 13:02:53 +0000
Message-ID: <93bc5000c51042e5bb45053707109947@huawei.com>
References: <20211210100732.1080-1-jiangyifei@huawei.com>
 <20211210100732.1080-13-jiangyifei@huawei.com>
 <10d2d911-e975-64b3-8ab6-e950c5064b9e@linaro.org>
In-Reply-To: <10d2d911-e975-64b3-8ab6-e950c5064b9e@linaro.org>
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
ZWNlbWJlciAxMywgMjAyMSAxMToyMiBQTQ0KPiBUbzogSmlhbmd5aWZlaSA8amlhbmd5aWZlaUBo
dWF3ZWkuY29tPjsgcWVtdS1kZXZlbEBub25nbnUub3JnOw0KPiBxZW11LXJpc2N2QG5vbmdudS5v
cmcNCj4gQ2M6IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnOyBrdm1Admdlci5rZXJuZWwu
b3JnOw0KPiBsaWJ2aXItbGlzdEByZWRoYXQuY29tOyBhbnVwLnBhdGVsQHdkYy5jb207IHBhbG1l
ckBkYWJiZWx0LmNvbTsNCj4gQWxpc3RhaXIuRnJhbmNpc0B3ZGMuY29tOyBiaW4ubWVuZ0B3aW5k
cml2ZXIuY29tOyBGYW5saWFuZyAoRXVsZXJPUykNCj4gPGZhbmxpYW5nQGh1YXdlaS5jb20+OyBX
dWJpbiAoSCkgPHd1Lnd1YmluQGh1YXdlaS5jb20+OyBXYW5naGFpYmluIChEKQ0KPiA8d2FuZ2hh
aWJpbi53YW5nQGh1YXdlaS5jb20+OyB3YW5ibyAoRykgPHdhbmJvMTNAaHVhd2VpLmNvbT47DQo+
IGxpbWluZ3dhbmcgKEEpIDxsaW1pbmd3YW5nQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjIgMTIvMTJdIHRhcmdldC9yaXNjdjogU3VwcG9ydCB2aXJ0dWFsIHRpbWUgY29udGV4
dA0KPiBzeW5jaHJvbml6YXRpb24NCj4gDQo+IE9uIDEyLzEwLzIxIDI6MDcgQU0sIFlpZmVpIEpp
YW5nIHZpYSB3cm90ZToNCj4gPiArc3RhdGljIGJvb2wga3ZtdGltZXJfbmVlZGVkKHZvaWQgKm9w
YXF1ZSkgew0KPiA+ICsgICAgcmV0dXJuIGt2bV9lbmFibGVkKCk7DQo+ID4gK30NCj4gPiArDQo+
ID4gKw0KPiA+ICtzdGF0aWMgY29uc3QgVk1TdGF0ZURlc2NyaXB0aW9uIHZtc3RhdGVfa3ZtdGlt
ZXIgPSB7DQo+ID4gKyAgICAubmFtZSA9ICJjcHUva3ZtdGltZXIiLA0KPiA+ICsgICAgLnZlcnNp
b25faWQgPSAxLA0KPiA+ICsgICAgLm1pbmltdW1fdmVyc2lvbl9pZCA9IDEsDQo+ID4gKyAgICAu
bmVlZGVkID0ga3ZtdGltZXJfbmVlZGVkLA0KPiA+ICsgICAgLmZpZWxkcyA9IChWTVN0YXRlRmll
bGRbXSkgew0KPiA+ICsgICAgICAgIFZNU1RBVEVfVUlOVDY0KGVudi5rdm1fdGltZXJfdGltZSwg
UklTQ1ZDUFUpLA0KPiA+ICsgICAgICAgIFZNU1RBVEVfVUlOVDY0KGVudi5rdm1fdGltZXJfY29t
cGFyZSwgUklTQ1ZDUFUpLA0KPiA+ICsgICAgICAgIFZNU1RBVEVfVUlOVDY0KGVudi5rdm1fdGlt
ZXJfc3RhdGUsIFJJU0NWQ1BVKSwNCj4gPiArDQo+ID4gKyAgICAgICAgVk1TVEFURV9FTkRfT0Zf
TElTVCgpDQo+ID4gKyAgICB9DQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGNwdV9w
b3N0X2xvYWQodm9pZCAqb3BhcXVlLCBpbnQgdmVyc2lvbl9pZCkgew0KPiA+ICsgICAgUklTQ1ZD
UFUgKmNwdSA9IG9wYXF1ZTsNCj4gPiArICAgIENQVVJJU0NWU3RhdGUgKmVudiA9ICZjcHUtPmVu
djsNCj4gPiArDQo+ID4gKyAgICBpZiAoa3ZtX2VuYWJsZWQoKSkgew0KPiA+ICsgICAgICAgIGVu
di0+a3ZtX3RpbWVyX2RpcnR5ID0gdHJ1ZTsNCj4gPiArICAgIH0NCj4gPiArICAgIHJldHVybiAw
Ow0KPiA+ICt9DQo+IA0KPiBUaGlzIHBvc3QtbG9hZCBiZWxvbmdzIG9uIHRoZSB2bXN0YXRlX2t2
bXRpbWVyIHN0cnVjdCwgc28gdGhhdCB5b3UgbmVlZCBub3QNCj4gcmUtY2hlY2sga3ZtX2VuYWJs
ZWQoKS4NCj4gDQo+ID4gICBjb25zdCBWTVN0YXRlRGVzY3JpcHRpb24gdm1zdGF0ZV9yaXNjdl9j
cHUgPSB7DQo+ID4gICAgICAgLm5hbWUgPSAiY3B1IiwNCj4gPiAtICAgIC52ZXJzaW9uX2lkID0g
MywNCj4gPiAtICAgIC5taW5pbXVtX3ZlcnNpb25faWQgPSAzLA0KPiA+ICsgICAgLnZlcnNpb25f
aWQgPSA0LA0KPiA+ICsgICAgLm1pbmltdW1fdmVyc2lvbl9pZCA9IDQsDQo+ID4gKyAgICAucG9z
dF9sb2FkID0gY3B1X3Bvc3RfbG9hZCwNCj4gDQo+IE5vIG5lZWQgZm9yIHZlcnNpb24gY2hhbmdl
Lg0KPiANCj4gDQo+IHJ+DQoNCk9rLCBpdCB3aWxsIGJlIG1vZGlmaWVkIGluIHRoZSBuZXh0IHNl
cmllcy4NCg0KWWlmZWkNCg==
