Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195B0336ABB
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 04:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCKDcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 22:32:54 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:3356 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhCKDci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 22:32:38 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DwvbH3y6Mz5Zbk;
        Thu, 11 Mar 2021 11:30:19 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 11 Mar 2021 11:32:35 +0800
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggpemm000001.china.huawei.com (7.185.36.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Mar 2021 11:32:35 +0800
Received: from dggpemm000003.china.huawei.com ([7.185.36.128]) by
 dggpemm000003.china.huawei.com ([7.185.36.128]) with mapi id 15.01.2106.013;
 Thu, 11 Mar 2021 11:32:35 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Peter Xu <peterx@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        "Kevin Tian" <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSB2ZmlvL3BjaTogbWFrZSB0aGUgdmZpb19wY2lfbW1h?=
 =?gb2312?Q?p=5Ffault_reentrant?=
Thread-Topic: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Thread-Index: AQHXFPkm9ckbuB60HkCuAqujlnhp/qp7VacAgAAjpoCAAAq/gIAAR1eAgABsLICAAWa7IA==
Date:   Thu, 11 Mar 2021 03:32:35 +0000
Message-ID: <70e217159188451b8b0a7c88dd15cb44@hisilicon.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
        <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
        <20210309082951.75f0eb01@x1.home.shazbot.org>
        <20210309164004.GJ2356281@nvidia.com>   <20210309184739.GD763132@xz-x1>
        <20210309122607.0b68fb9b@omen.home.shazbot.org>
        <20210309234127.GM2356281@nvidia.com>
 <20210309230837.394cb101@x1.home.shazbot.org>
In-Reply-To: <20210309230837.394cb101@x1.home.shazbot.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.69.38.183]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxleDoNCg0KPiAtLS0tLdPKvP7Urbz+LS0tLS0NCj4gt6K8/sjLOiBBbGV4IFdpbGxpYW1z
b24gW21haWx0bzphbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbV0NCj4gt6LLzcqxvOQ6IDIwMjHE
6jPUwjEwyNUgMTQ6MDkNCj4gytW8/sjLOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29t
Pg0KPiCzrcvNOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+OyBaZW5ndGFvIChCKSA8cHJp
bWUuemVuZ0BoaXNpbGljb24uY29tPjsNCj4gQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5j
b20+OyBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT47DQo+IEFuZHJldyBNb3J0b24g
PGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyBHaW92YW5uaSBDYWJpZGR1DQo+IDxnaW92YW5u
aS5jYWJpZGR1QGludGVsLmNvbT47IE1pY2hlbCBMZXNwaW5hc3NlIDx3YWxrZW5AZ29vZ2xlLmNv
bT47IEphbm4NCj4gSG9ybiA8amFubmhAZ29vZ2xlLmNvbT47IE1heCBHdXJ0b3ZveSA8bWd1cnRv
dm95QG52aWRpYS5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBMaW51eGFybQ0KPiA8bGludXhhcm1AaHVhd2VpLmNvbT4NCj4g1vfM4jog
UmU6IFtQQVRDSF0gdmZpby9wY2k6IG1ha2UgdGhlIHZmaW9fcGNpX21tYXBfZmF1bHQgcmVlbnRy
YW50DQo+IA0KPiBPbiBUdWUsIDkgTWFyIDIwMjEgMTk6NDE6MjcgLTA0MDANCj4gSmFzb24gR3Vu
dGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIFR1ZSwgTWFyIDA5LCAy
MDIxIGF0IDEyOjI2OjA3UE0gLTA3MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPg0KPiA+
ID4gSW4gdGhlIG5ldyBzZXJpZXMsIEkgdGhpbmsgdGhlIGZhdWx0IGhhbmRsZXIgYmVjb21lcyAo
dW50ZXN0ZWQpOg0KPiA+ID4NCj4gPiA+IHN0YXRpYyB2bV9mYXVsdF90IHZmaW9fcGNpX21tYXBf
ZmF1bHQoc3RydWN0IHZtX2ZhdWx0ICp2bWYpIHsNCj4gPiA+ICAgICAgICAgc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWEgPSB2bWYtPnZtYTsNCj4gPiA+ICAgICAgICAgc3RydWN0IHZmaW9fcGNp
X2RldmljZSAqdmRldiA9IHZtYS0+dm1fcHJpdmF0ZV9kYXRhOw0KPiA+ID4gICAgICAgICB1bnNp
Z25lZCBsb25nIGJhc2VfcGZuLCBwZ29mZjsNCj4gPiA+ICAgICAgICAgdm1fZmF1bHRfdCByZXQg
PSBWTV9GQVVMVF9TSUdCVVM7DQo+ID4gPg0KPiA+ID4gICAgICAgICBpZiAodmZpb19wY2lfYmFy
X3ZtYV90b19wZm4odm1hLCAmYmFzZV9wZm4pKQ0KPiA+ID4gICAgICAgICAgICAgICAgIHJldHVy
biByZXQ7DQo+ID4gPg0KPiA+ID4gICAgICAgICBwZ29mZiA9ICh2bWYtPmFkZHJlc3MgLSB2bWEt
PnZtX3N0YXJ0KSA+PiBQQUdFX1NISUZUOw0KPiA+DQo+ID4gSSBkb24ndCB0aGluayB0aGlzIG1h
dGggaXMgY29tcGxldGVseSBzYWZlLCBpdCBuZWVkcyB0byBwYXJzZSB0aGUNCj4gPiB2bV9wZ29m
Zi4uDQo+ID4NCj4gPiBJJ20gd29ycmllZCB1c2Vyc3BhY2UgY291bGQgc3BsaXQvcHVuY2gvbWFu
Z2xlIGEgVk1BIHVzaW5nDQo+ID4gbXVubWFwL21yZW1hcC9ldGMvZXRjIGluIGEgd2F5IHRoYXQg
ZG9lcyB1cGRhdGUgdGhlIHBnX29mZiBidXQgaXMNCj4gPiBpbmNvbXBhdGlibGUgd2l0aCB0aGUg
YWJvdmUuDQo+IA0KPiBwYXJzaW5nIHZtX3Bnb2ZmIGlzIGRvbmUgaW46DQo+IA0KPiBzdGF0aWMg
aW50IHZmaW9fcGNpX2Jhcl92bWFfdG9fcGZuKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgKnBmbikg
ew0KPiAgICAgICAgIHN0cnVjdCB2ZmlvX3BjaV9kZXZpY2UgKnZkZXYgPSB2bWEtPnZtX3ByaXZh
dGVfZGF0YTsNCj4gICAgICAgICBzdHJ1Y3QgcGNpX2RldiAqcGRldiA9IHZkZXYtPnBkZXY7DQo+
ICAgICAgICAgaW50IGluZGV4Ow0KPiAgICAgICAgIHU2NCBwZ29mZjsNCj4gDQo+ICAgICAgICAg
aW5kZXggPSB2bWEtPnZtX3Bnb2ZmID4+IChWRklPX1BDSV9PRkZTRVRfU0hJRlQgLSBQQUdFX1NI
SUZUKTsNCj4gDQo+ICAgICAgICAgaWYgKGluZGV4ID49IFZGSU9fUENJX1JPTV9SRUdJT05fSU5E
RVggfHwNCj4gICAgICAgICAgICAgIXZkZXYtPmJhcl9tbWFwX3N1cHBvcnRlZFtpbmRleF0gfHwg
IXZkZXYtPmJhcm1hcFtpbmRleF0pDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsN
Cj4gDQo+ICAgICAgICAgcGdvZmYgPSB2bWEtPnZtX3Bnb2ZmICYNCj4gICAgICAgICAgICAgICAg
ICgoMVUgPDwgKFZGSU9fUENJX09GRlNFVF9TSElGVCAtIFBBR0VfU0hJRlQpKSAtIDEpOw0KPiAN
Cj4gICAgICAgICAqcGZuID0gKHBjaV9yZXNvdXJjZV9zdGFydChwZGV2LCBpbmRleCkgPj4gUEFH
RV9TSElGVCkgKyBwZ29mZjsNCj4gDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+IH0NCj4gDQo+IEJ1
dCBnaXZlbiBQZXRlcidzIGNvbmNlcm4gYWJvdXQgZmF1bHRpbmcgaW5kaXZpZHVhbCBwYWdlcywg
SSB0aGluayB0aGUgZmF1bHQgaGFuZGxlcg0KPiBiZWNvbWVzOg0KPiANCj4gc3RhdGljIHZtX2Zh
dWx0X3QgdmZpb19wY2lfbW1hcF9mYXVsdChzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikgew0KPiAgICAg
ICAgIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hID0gdm1mLT52bWE7DQo+ICAgICAgICAgc3Ry
dWN0IHZmaW9fcGNpX2RldmljZSAqdmRldiA9IHZtYS0+dm1fcHJpdmF0ZV9kYXRhOw0KPiAgICAg
ICAgIHVuc2lnbmVkIGxvbmcgdmFkZHIsIHBmbjsNCj4gICAgICAgICB2bV9mYXVsdF90IHJldCA9
IFZNX0ZBVUxUX1NJR0JVUzsNCj4gDQo+ICAgICAgICAgaWYgKHZmaW9fcGNpX2Jhcl92bWFfdG9f
cGZuKHZtYSwgJnBmbikpDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiANCj4gICAg
ICAgICBkb3duX3JlYWQoJnZkZXYtPm1lbW9yeV9sb2NrKTsNCj4gDQo+ICAgICAgICAgaWYgKF9f
dmZpb19wY2lfbWVtb3J5X2VuYWJsZWQodmRldikpIHsNCj4gICAgICAgICAgICAgICAgIGZvciAo
dmFkZHIgPSB2bWEtPnZtX3N0YXJ0Ow0KPiAgICAgICAgICAgICAgICAgICAgICB2YWRkciA8IHZt
YS0+dm1fZW5kOyB2YWRkciArPSBQQUdFX1NJWkUsIHBmbisrKSB7DQpPbmUgY29uY2VybiBoZXJl
IGlzIHRoZSBwZXJmb3JtYW5jZSwgc2luY2UgeW91IGFyZSBkb2luZyB0aGUgbWFwcGluZyBmb3Ig
dGhlDQogd2hvbGUgdm1hLCB3aGF0IGFib3V0IHVzaW5nIGJsb2NrIG1hcHBpbmcgaWYgYXBwbGlj
YWJsZT8NCg0KPiAgICAgICAgICAgICAgICAgICAgICAgICByZXQgPSB2bWZfaW5zZXJ0X3Bmbl9w
cm90KHZtYSwgdmFkZHIsIHBmbiwNCj4gDQo+IHBncHJvdF9kZWNyeXB0ZWQodm1hLT52bV9wYWdl
X3Byb3QpKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHJldCAhPSBWTV9GQVVMVF9O
T1BBR0UpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB6YXBfdm1hX3B0ZXMo
dm1hLCB2bWEtPnZtX3N0YXJ0LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB2YWRkciAtIHZtYS0+dm1fc3RhcnQpOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+ICAgICAg
ICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0KPiANCj4gICAgICAgICB1cF9yZWFkKCZ2ZGV2LT5t
ZW1vcnlfbG9jayk7DQo+IA0KPiAgICAgICAgIHJldHVybiByZXQ7DQo+IH0NCj4gDQo+IFRoYW5r
cywNCj4gQWxleA0K
