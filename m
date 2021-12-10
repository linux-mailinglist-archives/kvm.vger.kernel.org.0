Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E1B46FE60
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhLJKHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:07:17 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29118 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhLJKHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:07:17 -0500
Received: from dggeme706-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J9RHM5kBbz1DLHg;
        Fri, 10 Dec 2021 18:00:47 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggeme706-chm.china.huawei.com (10.1.199.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:03:40 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 18:03:40 +0800
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
        "Alistair.Francis@wdc.com" <Alistair.Francis@wdc.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>
Subject: RE: [PATCH v1 12/12] target/riscv: Support virtual time context
 synchronization
Thread-Topic: [PATCH v1 12/12] target/riscv: Support virtual time context
 synchronization
Thread-Index: AQHX3eLUE1sOoznHAU+RC9Ifd4t+hKwMe9AAgB8iu4A=
Date:   Fri, 10 Dec 2021 10:03:40 +0000
Message-ID: <e30f810bbb1349f6883204cfeebd503b@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-13-jiangyifei@huawei.com>
 <d9c9196a-692c-cbcf-339b-8e84ecde7cee@linaro.org>
In-Reply-To: <d9c9196a-692c-cbcf-339b-8e84ecde7cee@linaro.org>
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
b3ZlbWJlciAyMSwgMjAyMSA2OjM1IEFNDQo+IFRvOiBKaWFuZ3lpZmVpIDxqaWFuZ3lpZmVpQGh1
YXdlaS5jb20+OyBxZW11LWRldmVsQG5vbmdudS5vcmc7DQo+IHFlbXUtcmlzY3ZAbm9uZ251Lm9y
Zw0KPiBDYzogYmluLm1lbmdAd2luZHJpdmVyLmNvbTsgbGltaW5nd2FuZyAoQSkgPGxpbWluZ3dh
bmdAaHVhd2VpLmNvbT47DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpYnZpci1saXN0QHJlZGhh
dC5jb207IGFudXAucGF0ZWxAd2RjLmNvbTsgd2FuYm8gKEcpDQo+IDx3YW5ibzEzQGh1YXdlaS5j
b20+OyBBbGlzdGFpci5GcmFuY2lzQHdkYy5jb207DQo+IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRl
YWQub3JnOyBXYW5naGFpYmluIChEKQ0KPiA8d2FuZ2hhaWJpbi53YW5nQGh1YXdlaS5jb20+OyBw
YWxtZXJAZGFiYmVsdC5jb207IEZhbmxpYW5nIChFdWxlck9TKQ0KPiA8ZmFubGlhbmdAaHVhd2Vp
LmNvbT47IFd1YmluIChIKSA8d3Uud3ViaW5AaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MSAxMi8xMl0gdGFyZ2V0L3Jpc2N2OiBTdXBwb3J0IHZpcnR1YWwgdGltZSBjb250ZXh0
DQo+IHN5bmNocm9uaXphdGlvbg0KPiANCj4gT24gMTEvMjAvMjEgODo0NiBBTSwgWWlmZWkgSmlh
bmcgd3JvdGU6DQo+ID4gICBjb25zdCBWTVN0YXRlRGVzY3JpcHRpb24gdm1zdGF0ZV9yaXNjdl9j
cHUgPSB7DQo+ID4gICAgICAgLm5hbWUgPSAiY3B1IiwNCj4gPiAgICAgICAudmVyc2lvbl9pZCA9
IDMsDQo+ID4gICAgICAgLm1pbmltdW1fdmVyc2lvbl9pZCA9IDMsDQo+ID4gKyAgICAucG9zdF9s
b2FkID0gY3B1X3Bvc3RfbG9hZCwNCj4gPiAgICAgICAuZmllbGRzID0gKFZNU3RhdGVGaWVsZFtd
KSB7DQo+ID4gICAgICAgICAgIFZNU1RBVEVfVUlOVFRMX0FSUkFZKGVudi5ncHIsIFJJU0NWQ1BV
LCAzMiksDQo+ID4gICAgICAgICAgIFZNU1RBVEVfVUlOVDY0X0FSUkFZKGVudi5mcHIsIFJJU0NW
Q1BVLCAzMiksIEBAIC0yMTEsNg0KPiA+ICsyMjEsMTAgQEAgY29uc3QgVk1TdGF0ZURlc2NyaXB0
aW9uIHZtc3RhdGVfcmlzY3ZfY3B1ID0gew0KPiA+ICAgICAgICAgICBWTVNUQVRFX1VJTlQ2NChl
bnYubXRvaG9zdCwgUklTQ1ZDUFUpLA0KPiA+ICAgICAgICAgICBWTVNUQVRFX1VJTlQ2NChlbnYu
dGltZWNtcCwgUklTQ1ZDUFUpLA0KPiA+DQo+ID4gKyAgICAgICAgVk1TVEFURV9VSU5UNjQoZW52
Lmt2bV90aW1lcl90aW1lLCBSSVNDVkNQVSksDQo+ID4gKyAgICAgICAgVk1TVEFURV9VSU5UNjQo
ZW52Lmt2bV90aW1lcl9jb21wYXJlLCBSSVNDVkNQVSksDQo+ID4gKyAgICAgICAgVk1TVEFURV9V
SU5UNjQoZW52Lmt2bV90aW1lcl9zdGF0ZSwgUklTQ1ZDUFUpLA0KPiA+ICsNCj4gPiAgICAgICAg
ICAgVk1TVEFURV9FTkRfT0ZfTElTVCgpDQo+ID4gICAgICAgfSwNCj4gDQo+IENhbid0IGFsdGVy
IFZNU3RhdGVEZXNjcmlwdGlvbi5maWVsZHMgd2l0aG91dCBidW1waW5nIHZlcnNpb24uDQo+IA0K
PiBJZiB0aGlzIGlzIHJlYWxseSBrdm0tb25seSBzdGF0ZSwgY29uc2lkZXIgcGxhY2luZyBpdCBp
bnRvIGEgc3Vic2VjdGlvbi4gIEJ1dCBJDQo+IHdvcnJ5IGFib3V0IGt2bS1vbmx5IHN0YXRlIGJl
Y2F1c2UgaWRlYWxseSB3ZSdkIGJlIGFibGUgdG8gbWlncmF0ZSBiZXR3ZWVuDQo+IHRjZyBhbmQg
a3ZtIChpZiBvbmx5IGZvciBkZWJ1Z2dpbmcpLg0KPiANCj4gDQo+IHJ+DQoNClRoYW5rcywgSSB3
aWxsIHVwZGF0ZSB0aGUgdmVyc2lvbiBpbiB0aGUgbmV4dCBzZXJpZXMgYW5kIHBsYWNlIGl0IGlu
dG8gYSBzdWJzZWN0aW9uLg0KDQpZaWZlaQ0K
