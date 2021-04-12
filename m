Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1620535B932
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhDLEDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:03:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3082 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhDLEDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:03:45 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FJZkY1310zWWV0;
        Mon, 12 Apr 2021 11:59:49 +0800 (CST)
Received: from dggemm752-chm.china.huawei.com (10.1.198.58) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 12 Apr 2021 12:03:24 +0800
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggemm752-chm.china.huawei.com (10.1.198.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 12:03:24 +0800
Received: from dggpemm000003.china.huawei.com ([7.185.36.128]) by
 dggpemm000003.china.huawei.com ([7.185.36.128]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 12:03:24 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHYxIDAxLzE0XSB2ZmlvOiBDcmVhdGUgdmZpb19mc190?=
 =?gb2312?Q?ype_with_inode_per_device?=
Thread-Topic: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per device
Thread-Index: AQHXFGTEBL9vagM8VUiybsk55NZ2y6qrwTfwgAAn2gCAADSaAIAEWT+g
Date:   Mon, 12 Apr 2021 04:03:24 +0000
Message-ID: <46881012f8214a8fa50d1ce2d10c5651@hisilicon.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524004828.3480.1817334832614722574.stgit@gimli.home>
 <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
 <20210409082400.1004fcef@x1.home.shazbot.org>
 <20210409173216.GA7405@nvidia.com>
In-Reply-To: <20210409173216.GA7405@nvidia.com>
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

PiAtLS0tLdPKvP7Urbz+LS0tLS0NCj4gt6K8/sjLOiBKYXNvbiBHdW50aG9ycGUgW21haWx0bzpq
Z2dAbnZpZGlhLmNvbV0NCj4gt6LLzcqxvOQ6IDIwMjHE6jTUwjEwyNUgMTozMg0KPiDK1bz+yMs6
IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ILOty806IFpl
bmd0YW8gKEIpIDxwcmltZS56ZW5nQGhpc2lsaWNvbi5jb20+OyBjb2h1Y2tAcmVkaGF0LmNvbTsN
Cj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgcGV0
ZXJ4QHJlZGhhdC5jb20NCj4g1vfM4jogUmU6IFtQQVRDSCB2MSAwMS8xNF0gdmZpbzogQ3JlYXRl
IHZmaW9fZnNfdHlwZSB3aXRoIGlub2RlIHBlciBkZXZpY2UNCj4gDQo+IE9uIEZyaSwgQXByIDA5
LCAyMDIxIGF0IDA4OjI0OjAwQU0gLTA2MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gDQo+
ID4gPiA+ICAjZGVmaW5lIERSSVZFUl9WRVJTSU9OCSIwLjMiDQo+ID4gPiA+ICAjZGVmaW5lIERS
SVZFUl9BVVRIT1IJIkFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5j
b20+Ig0KPiA+ID4gPiAgI2RlZmluZSBEUklWRVJfREVTQwkiVkZJTyAtIFVzZXIgTGV2ZWwgbWV0
YS1kcml2ZXIiDQo+ID4gPiA+DQo+ID4gPiA+ICsjZGVmaW5lIFZGSU9fTUFHSUMgMHg1NjQ2NDk0
ZiAvKiAiVkZJTyIgKi8NCj4gPiA+IE1vdmUgdG8gaW5jbHVkZS91YXBpL2xpbnV4L21hZ2ljLmgg
Pw0KPiA+DQo+ID4gSG1tLCB5ZWFoLCBJIHN1cHBvc2UgaXQgcHJvYmFibHkgc2hvdWxkIGdvIHRo
ZXJlLiAgVGhhbmtzLg0KPiANCj4gRnJvbSBteSByZXZpZXcgd2UgaGF2ZW4ndCBiZWVuIGRvaW5n
IHRoYXQgdW5sZXNzIGl0IGlzIGFjdHVhbGx5IHVhcGkgcmVsYXZlbnQNCj4gZm9yIHNvbWUgcmVh
c29uICh0aGlzIGlzIG5vdCkNCj4NClllcywgaXQncyBub3QgdWFwaSByZWxhdmVudCwgYW5kIEkg
c3RpbGwgdGhpbmsgaXQncyBiZXR0ZXIgdG8gcHV0IG1hZ2ljDQogaW4gYSBzaW5nbGUgaGVhZGVy
LCBhbmQgY3VycmVudGx5IG5vdCBhbGwgbWljcm9zIGluIG1hZ2ljLmggYXJlIGZvcg0KIHVhcGks
IHNvbWUgd29yayBzaG91bGQgYmUgZG9uZSBmb3IgdGhhdCwgYnV0IG5vIGlkZWFzIG5vdywgOikN
CiANCj4gSW4gcGFydGljdWxhciB3aXRoIENIIGhhdmluZyBhIHBhdGNoIHNlcmllcyB0byBlbGlt
aW5hdGUgYWxsIG9mIHRoZXNlIGNhc2VzIGFuZA0KPiBkcm9wIHRoZSBjb25zdGFudHMuLg0KPiAN
CkludGVyZXN0ZWQsIGNvdWxkIHlvdSBzaGFyZSB0aGUgbGlua3MgZm9yIHRoYXQ/DQoNClRoYW5r
cyANClplbmd0YW8gDQoNCj4gSmFzb24NCg==
