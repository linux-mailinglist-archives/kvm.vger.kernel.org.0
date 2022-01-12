Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4748BF70
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 09:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349130AbiALIEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 03:04:32 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34898 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiALIEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 03:04:31 -0500
Received: from dggeme708-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JYg7B1zKdzccYv;
        Wed, 12 Jan 2022 16:03:50 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggeme708-chm.china.huawei.com (10.1.199.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 12 Jan 2022 16:04:28 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Wed, 12 Jan 2022 16:04:28 +0800
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
        "limingwang (A)" <limingwang@huawei.com>
Subject: RE: [PATCH v4 02/12] target/riscv: Add target/riscv/kvm.c to place
 the public kvm interface
Thread-Topic: [PATCH v4 02/12] target/riscv: Add target/riscv/kvm.c to place
 the public kvm interface
Thread-Index: AQHYBcLUGMfQsFAEYkiaTOaz7LIFQKxcXLYAgAKtIxA=
Date:   Wed, 12 Jan 2022 08:04:28 +0000
Message-ID: <d0b2766fb1c3465095c76e2b1efbae5c@huawei.com>
References: <20220110013831.1594-1-jiangyifei@huawei.com>
 <20220110013831.1594-3-jiangyifei@huawei.com>
 <CAKmqyKOOD-iRxX8aj7V2Vtfmi6=i9jCDT=0qgUvxX1j1DOOHXg@mail.gmail.com>
In-Reply-To: <CAKmqyKOOD-iRxX8aj7V2Vtfmi6=i9jCDT=0qgUvxX1j1DOOHXg@mail.gmail.com>
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
MSwgMjAyMiA3OjEwIEFNDQo+IFRvOiBKaWFuZ3lpZmVpIDxqaWFuZ3lpZmVpQGh1YXdlaS5jb20+
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
NCAwMi8xMl0gdGFyZ2V0L3Jpc2N2OiBBZGQgdGFyZ2V0L3Jpc2N2L2t2bS5jIHRvIHBsYWNlIHRo
ZQ0KPiBwdWJsaWMga3ZtIGludGVyZmFjZQ0KPiANCj4gT24gTW9uLCBKYW4gMTAsIDIwMjIgYXQg
MTE6NDggQU0gWWlmZWkgSmlhbmcgdmlhIDxxZW11LWRldmVsQG5vbmdudS5vcmc+DQo+IHdyb3Rl
Og0KPiA+DQo+ID4gQWRkIHRhcmdldC9yaXNjdi9rdm0uYyB0byBwbGFjZSBrdm1fYXJjaF8qIGZ1
bmN0aW9uIG5lZWRlZCBieQ0KPiA+IGt2bS9rdm0tYWxsLmMuIE1lYW53aGlsZSwgYWRkIGt2bSBz
dXBwb3J0IGluIG1lc29uLmJ1aWxkIGZpbGUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaWZl
aSBKaWFuZyA8amlhbmd5aWZlaUBodWF3ZWkuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE1pbmd3
YW5nIExpIDxsaW1pbmd3YW5nQGh1YXdlaS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEFsaXN0YWly
IEZyYW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQW51
cCBQYXRlbCA8YW51cC5wYXRlbEB3ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICBtZXNvbi5idWlsZCAg
ICAgICAgICAgICAgfCAgIDIgKw0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtLmMgICAgICAgfCAxMzMN
Cj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIHRhcmdldC9y
aXNjdi9tZXNvbi5idWlsZCB8ICAgMSArDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTM2IGluc2Vy
dGlvbnMoKykNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9yaXNjdi9rdm0uYw0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL21lc29uLmJ1aWxkIGIvbWVzb24uYnVpbGQgaW5kZXggNTMwNjVl
OTZlYy4uN2VhZWMzMWEzYQ0KPiA+IDEwMDY0NA0KPiA+IC0tLSBhL21lc29uLmJ1aWxkDQo+ID4g
KysrIGIvbWVzb24uYnVpbGQNCj4gPiBAQCAtOTAsNiArOTAsOCBAQCBlbGlmIGNwdSBpbiBbJ3Bw
YycsICdwcGM2NCddDQo+ID4gICAga3ZtX3RhcmdldHMgPSBbJ3BwYy1zb2Z0bW11JywgJ3BwYzY0
LXNvZnRtbXUnXSAgZWxpZiBjcHUgaW4NCj4gPiBbJ21pcHMnLCAnbWlwczY0J10NCj4gPiAgICBr
dm1fdGFyZ2V0cyA9IFsnbWlwcy1zb2Z0bW11JywgJ21pcHNlbC1zb2Z0bW11JywgJ21pcHM2NC1z
b2Z0bW11JywNCj4gPiAnbWlwczY0ZWwtc29mdG1tdSddDQo+ID4gK2VsaWYgY3B1IGluIFsncmlz
Y3YnXQ0KPiA+ICsgIGt2bV90YXJnZXRzID0gWydyaXNjdjMyLXNvZnRtbXUnLCAncmlzY3Y2NC1z
b2Z0bW11J10NCj4gPiAgZWxzZQ0KPiA+ICAgIGt2bV90YXJnZXRzID0gW10NCj4gPiAgZW5kaWYN
Cj4gDQo+IENhbiB5b3UgYWRkIHRoaXMgYXMgYSBzZXBhcmF0ZSBjb21taXQgYXQgdGhlIGVuZCBv
ZiB0aGUgc2VyaWVzPw0KPiANCj4gVGhhdCB3YXkgd2UgaGF2ZSBpbXBsZW1lbnRlZCBLVk0gc3Vw
cG9ydCBiZWZvcmUgd2UgZW5hYmxlIGl0IGZvciB1c2Vycy4NCj4gDQo+IEFsaXN0YWlyDQoNClll
cywgdGhhdCBtYWtlcyBzZW5zZS4NCg0KWWlmZWkNCg==
