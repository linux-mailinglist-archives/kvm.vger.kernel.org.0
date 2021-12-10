Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BEA46FE5D
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbhLJKFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:05:44 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29174 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhLJKFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:05:42 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J9RGQ0dvcz8vmy;
        Fri, 10 Dec 2021 17:59:58 +0800 (CST)
Received: from dggpeml100022.china.huawei.com (7.185.36.176) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:02:05 +0800
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggpeml100022.china.huawei.com (7.185.36.176) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:02:05 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 18:02:05 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>
CC:     "bin.meng@windriver.com" <bin.meng@windriver.com>,
        "limingwang (A)" <limingwang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "anup.patel@wdc.com" <anup.patel@wdc.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "Alistair.Francis@wdc.com" <Alistair.Francis@wdc.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Subject: RE: [PATCH v1 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
Thread-Topic: [PATCH v1 08/12] target/riscv: Handle KVM_EXIT_RISCV_SBI exit
Thread-Index: AQHX3eLPKi0N90Bnsk2GR2KUrJd5IKwL0V8AgB/MstA=
Date:   Fri, 10 Dec 2021 10:02:05 +0000
Message-ID: <8722f544a1d747f6937dccf0b4272779@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-9-jiangyifei@huawei.com>
 <afe5b14f-ec27-2722-73a8-b9f6716d207e@amsat.org>
In-Reply-To: <afe5b14f-ec27-2722-73a8-b9f6716d207e@amsat.org>
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIFttYWlsdG86cGhpbGlwcGUubWF0aGlldS5kYXVkZUBnbWFpbC5jb21dDQo+IE9uIEJl
aGFsZiBPZiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqQ0KPiBTZW50OiBTYXR1cmRheSwgTm92ZW1i
ZXIgMjAsIDIwMjEgODoyNSBQTQ0KPiBUbzogSmlhbmd5aWZlaSA8amlhbmd5aWZlaUBodWF3ZWku
Y29tPjsgcWVtdS1kZXZlbEBub25nbnUub3JnOw0KPiBxZW11LXJpc2N2QG5vbmdudS5vcmcNCj4g
Q2M6IGJpbi5tZW5nQHdpbmRyaXZlci5jb207IGxpbWluZ3dhbmcgKEEpIDxsaW1pbmd3YW5nQGh1
YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBsaWJ2aXItbGlzdEByZWRoYXQuY29t
OyBhbnVwLnBhdGVsQHdkYy5jb207IHdhbmJvIChHKQ0KPiA8d2FuYm8xM0BodWF3ZWkuY29tPjsg
QWxpc3RhaXIuRnJhbmNpc0B3ZGMuY29tOw0KPiBrdm0tcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgV2FuZ2hhaWJpbiAoRCkNCj4gPHdhbmdoYWliaW4ud2FuZ0BodWF3ZWkuY29tPjsgcGFsbWVy
QGRhYmJlbHQuY29tOyBGYW5saWFuZyAoRXVsZXJPUykNCj4gPGZhbmxpYW5nQGh1YXdlaS5jb20+
OyBXdWJpbiAoSCkgPHd1Lnd1YmluQGh1YXdlaS5jb20+OyBBbGV4IEJlbm7DqWUNCj4gPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMDgvMTJdIHRhcmdl
dC9yaXNjdjogSGFuZGxlIEtWTV9FWElUX1JJU0NWX1NCSSBleGl0DQo+IA0KPiBIaSwNCj4gDQo+
IE9uIDExLzIwLzIxIDA4OjQ2LCBZaWZlaSBKaWFuZyB3cm90ZToNCj4gPiBVc2UgY2hhci1mZSB0
byBoYW5kbGUgY29uc29sZSBzYmkgY2FsbCwgd2hpY2ggaW1wbGVtZW50IGVhcmx5IGNvbnNvbGUN
Cj4gPiBpbyB3aGlsZSBhcHBseSAnZWFybHljb249c2JpJyBpbnRvIGtlcm5lbCBwYXJhbWV0ZXJz
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWlmZWkgSmlhbmcgPGppYW5neWlmZWlAaHVhd2Vp
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaW5nd2FuZyBMaSA8bGltaW5nd2FuZ0BodWF3ZWku
Y29tPg0KPiA+IC0tLQ0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtLmMgICAgICAgICAgICAgICAgIHwg
NDIgKysrKysrKysrKysrKysrKy0NCj4gPiAgdGFyZ2V0L3Jpc2N2L3NiaV9lY2FsbF9pbnRlcmZh
Y2UuaCB8IDcyDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmls
ZXMgY2hhbmdlZCwgMTEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkgIGNyZWF0ZSBtb2Rl
IDEwMDY0NA0KPiA+IHRhcmdldC9yaXNjdi9zYmlfZWNhbGxfaW50ZXJmYWNlLmgNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS90YXJnZXQvcmlzY3Yva3ZtLmMgYi90YXJnZXQvcmlzY3Yva3ZtLmMgaW5k
ZXgNCj4gPiA4ZGEyNjQ4ZDFhLi42ZDQxOWJhMDJlIDEwMDY0NA0KPiA+IC0tLSBhL3RhcmdldC9y
aXNjdi9rdm0uYw0KPiA+ICsrKyBiL3RhcmdldC9yaXNjdi9rdm0uYw0KPiA+IEBAIC0zOCw2ICsz
OCw4IEBADQo+ID4gICNpbmNsdWRlICJxZW11L2xvZy5oIg0KPiA+ICAjaW5jbHVkZSAiaHcvbG9h
ZGVyLmgiDQo+ID4gICNpbmNsdWRlICJrdm1fcmlzY3YuaCINCj4gPiArI2luY2x1ZGUgInNiaV9l
Y2FsbF9pbnRlcmZhY2UuaCINCj4gPiArI2luY2x1ZGUgImNoYXJkZXYvY2hhci1mZS5oIg0KPiA+
DQo+ID4gIHN0YXRpYyB1aW50NjRfdCBrdm1fcmlzY3ZfcmVnX2lkKENQVVJJU0NWU3RhdGUgKmVu
diwgdWludDY0X3QgdHlwZSwNCj4gPiB1aW50NjRfdCBpZHgpICB7IEBAIC00NDAsOSArNDQyLDQ3
IEBAIGJvb2wNCj4gPiBrdm1fYXJjaF9zdG9wX29uX2VtdWxhdGlvbl9lcnJvcihDUFVTdGF0ZSAq
Y3MpDQo+ID4gICAgICByZXR1cm4gdHJ1ZTsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQg
a3ZtX3Jpc2N2X2hhbmRsZV9zYmkoc3RydWN0IGt2bV9ydW4gKnJ1bikgew0KPiA+ICsgICAgaW50
IHJldCA9IDA7DQo+ID4gKyAgICB1bnNpZ25lZCBjaGFyIGNoOw0KPiA+ICsgICAgc3dpdGNoIChy
dW4tPnJpc2N2X3NiaS5leHRlbnNpb25faWQpIHsNCj4gPiArICAgIGNhc2UgU0JJX0VYVF8wXzFf
Q09OU09MRV9QVVRDSEFSOg0KPiA+ICsgICAgICAgIGNoID0gcnVuLT5yaXNjdl9zYmkuYXJnc1sw
XTsNCj4gPiArICAgICAgICBxZW11X2Nocl9mZV93cml0ZShzZXJpYWxfaGQoMCktPmJlLCAmY2gs
IHNpemVvZihjaCkpOw0KPiA+ICsgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgY2FzZSBTQklfRVhU
XzBfMV9DT05TT0xFX0dFVENIQVI6DQo+ID4gKyAgICAgICAgcmV0ID0gcWVtdV9jaHJfZmVfcmVh
ZF9hbGwoc2VyaWFsX2hkKDApLT5iZSwgJmNoLCBzaXplb2YoY2gpKTsNCj4gPiArICAgICAgICBp
ZiAocmV0ID09IHNpemVvZihjaCkpIHsNCj4gPiArICAgICAgICAgICAgcnVuLT5yaXNjdl9zYmku
YXJnc1swXSA9IGNoOw0KPiA+ICsgICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgIHJ1
bi0+cmlzY3Zfc2JpLmFyZ3NbMF0gPSAtMTsNCj4gPiArICAgICAgICB9DQo+ID4gKyAgICAgICAg
YnJlYWs7DQo+IA0KPiBTaG91bGRuJ3QgdGhpcyBjb2RlIHVzZSB0aGUgU2VtaWhvc3RpbmcgQ29u
c29sZSBBUEkgZnJvbQ0KPiAic2VtaWhvc3RpbmcvY29uc29sZS5oIiBpbnN0ZWFkPw0KDQpUaGFu
a3MsIEkgd2lsbCB1c2UgdGhpcyBBUEkgaW4gdGhlIG5leHQgc2VyaWVzLg0KDQpZaWZlaQ0K
