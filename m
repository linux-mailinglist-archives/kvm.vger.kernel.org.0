Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A361419554
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhI0NsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:48:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3881 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbhI0NsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:48:12 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HJ3kV5c1Wz67Zx5;
        Mon, 27 Sep 2021 21:43:30 +0800 (CST)
Received: from lhreml711-chm.china.huawei.com (10.201.108.62) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 27 Sep 2021 15:46:32 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml711-chm.china.huawei.com (10.201.108.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 14:46:32 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Mon, 27 Sep 2021 14:46:32 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHXqhdQM13RiELH60aUjxjG41fnUKulAGMAgAAGK3CAAZpfgIARVJdw
Date:   Mon, 27 Sep 2021 13:46:31 +0000
Message-ID: <a440256250c14182b9eefc77d5d399b8@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
In-Reply-To: <20210916135833.GB327412@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.80.194]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IFttYWlsdG86amdnQG52aWRpYS5jb21dDQo+IFNlbnQ6IDE2IFNlcHRlbWJlciAyMDIxIDE0OjU5
DQo+IFRvOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRo
b2RpQGh1YXdlaS5jb20+DQo+IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBhbGV4Lndp
bGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gbWd1cnRvdm95QG52aWRpYS5jb207IGxpdWxvbmdmYW5n
IDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPjsgWmVuZ3RhbyAoQikNCj4gPHByaW1lLnplbmdAaGlz
aWxpY29uLmNvbT47IEpvbmF0aGFuIENhbWVyb24NCj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2Vp
LmNvbT47IFdhbmd6aG91IChCKSA8d2FuZ3pob3UxQGhpc2lsaWNvbi5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjMgNi82XSBoaXNpX2FjY192ZmlvX3BjaTogQWRkIHN1cHBvcnQgZm9yIFZG
SU8gbGl2ZQ0KPiBtaWdyYXRpb24NCj4gDQo+IE9uIFdlZCwgU2VwIDE1LCAyMDIxIGF0IDAxOjI4
OjQ3UE0gKzAwMDAsIFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gd3JvdGU6DQo+ID4NCj4g
Pg0KPiA+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIFttYWlsdG86amdnQG52aWRpYS5jb21dDQo+
ID4gPiBTZW50OiAxNSBTZXB0ZW1iZXIgMjAyMSAxNDowOA0KPiA+ID4gVG86IFNoYW1lZXJhbGkg
S29sb3RodW0gVGhvZGkNCj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4N
Cj4gPiA+IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOw0KPiA+ID4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgYWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb207DQo+ID4gPiBtZ3VydG92b3lAbnZpZGlhLmNvbTsgTGludXhhcm0gPGxpbnV4
YXJtQGh1YXdlaS5jb20+OyBsaXVsb25nZmFuZw0KPiA+ID4gPGxpdWxvbmdmYW5nQGh1YXdlaS5j
b20+OyBaZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsNCj4gPiA+IEpvbmF0
aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IFdhbmd6aG91IChCKQ0K
PiA+ID4gPHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRD
SCB2MyA2LzZdIGhpc2lfYWNjX3ZmaW9fcGNpOiBBZGQgc3VwcG9ydCBmb3IgVkZJTyBsaXZlDQo+
ID4gPiBtaWdyYXRpb24NCj4gPiA+DQo+ID4gPiBPbiBXZWQsIFNlcCAxNSwgMjAyMSBhdCAxMDo1
MDozN0FNICswMTAwLCBTaGFtZWVyIEtvbG90aHVtIHdyb3RlOg0KPiA+ID4gPiArLyoNCj4gPiA+
ID4gKyAqIEhpU2lsaWNvbiBBQ0MgVkYgZGV2wqBNTUlPIHNwYWNlIGNvbnRhaW5zIGJvdGggdGhl
IGZ1bmN0aW9uYWwNCj4gcmVnaXN0ZXINCj4gPiA+ID4gKyAqIHNwYWNlwqBhbmQgdGhlIG1pZ3Jh
dGlvbiBjb250cm9sIHJlZ2lzdGVyIHNwYWNlLiBXZSBoaWRlIHRoZQ0KPiBtaWdyYXRpb24NCj4g
PiA+ID4gKyAqIGNvbnRyb2wgc3BhY2XCoGZyb20gdGhlIEd1ZXN0LiBCdXQgdG8gc3VjY2Vzc2Z1
bGx5IGNvbXBsZXRlIHRoZSBsaXZlDQo+ID4gPiA+ICsgKiBtaWdyYXRpb24sIHdlIHN0aWxsIG5l
ZWQgYWNjZXNzIHRvIHRoZSBmdW5jdGlvbmFsIE1NSU8gc3BhY2UgYXNzaWduZWQNCj4gPiA+ID4g
KyAqIHRvIHRoZSBHdWVzdC4gVG8gYXZvaWQgYW55IHBvdGVudGlhbCBzZWN1cml0eSBpc3N1ZXMs
IHdlIG5lZWQgdG8gYmUNCj4gPiA+ID4gKyAqIGNhcmVmdWwgbm90IHRvIGFjY2VzcyB0aGlzIHJl
Z2lvbiB3aGlsZSB0aGUgR3Vlc3QgdkNQVXMgYXJlIHJ1bm5pbmcuDQo+ID4gPiA+ICsgKg0KPiA+
ID4gPiArICogSGVuY2UgY2hlY2sgdGhlIGRldmljZSBzdGF0ZSBiZWZvcmUgd2UgbWFwIHRoZSBy
ZWdpb24uDQo+ID4gPiA+ICsgKi8NCj4gPiA+DQo+ID4gPiBUaGUgcHJpb3IgcGF0Y2ggcHJldmVu
dHMgbWFwcGluZyB0aGlzIGFyZWEgaW50byB0aGUgZ3Vlc3QgYXQgYWxsLA0KPiA+ID4gcmlnaHQ/
DQo+ID4NCj4gPiBUaGF04oCZcyByaWdodC4gSXQgd2lsbCBwcmV2ZW50IEd1ZXN0IGZyb20gbWFw
cGluZyB0aGlzIGFyZWEuDQo+ID4NCj4gPiA+IFNvIHdoeSB0aGUgY29tbWVudCBhbmQgbG9naWM/
IElmIHRoZSBNTUlPIGFyZWEgaXNuJ3QgbWFwcGVkIHRoZW4gdGhlcmUNCj4gPiA+IGlzIG5vdGhp
bmcgdG8gZG8sIHJpZ2h0Pw0KPiA+ID4NCj4gPiA+IFRoZSBvbmx5IHJpc2sgaXMgUDJQIHRyYW5z
YWN0aW9ucyBmcm9tIGRldmljZXMgaW4gdGhlIHNhbWUgSU9NTVUNCj4gPiA+IGdyb3VwLCBhbmQg
eW91IG1pZ2h0IGRvIHdlbGwgdG8gbWl0aWdhdGUgdGhhdCBieSBhc3NlcnRpbmcgdGhhdCB0aGUN
Cj4gPiA+IGRldmljZSBpcyBpbiBhIHNpbmdsZXRvbiBJT01NVSBncm91cD8NCj4gPg0KPiA+IFRo
aXMgd2FzIGFkZGVkIGFzIGFuIGV4dHJhIHByb3RlY3Rpb24uIEkgd2lsbCBhZGQgdGhlIHNpbmds
ZXRvbiBjaGVjayBpbnN0ZWFkLg0KPiA+DQo+ID4gPiA+ICtzdGF0aWMgaW50IGhpc2lfYWNjX3Zm
aW9fcGNpX2luaXQoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2KQ0KPiA+ID4gPiAr
ew0KPiA+ID4gPiArCXN0cnVjdCBhY2NfdmZfbWlncmF0aW9uICphY2NfdmZfZGV2Ow0KPiA+ID4g
PiArCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdmRldi0+cGRldjsNCj4gPiA+ID4gKwlzdHJ1Y3Qg
cGNpX2RldiAqcGZfZGV2LCAqdmZfZGV2Ow0KPiA+ID4gPiArCXN0cnVjdCBoaXNpX3FtICpwZl9x
bTsNCj4gPiA+ID4gKwlpbnQgdmZfaWQsIHJldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCXBmX2Rl
diA9IHBkZXYtPnBoeXNmbjsNCj4gPiA+ID4gKwl2Zl9kZXYgPSBwZGV2Ow0KPiA+ID4gPiArDQo+
ID4gPiA+ICsJcGZfcW0gPSBwY2lfZ2V0X2RydmRhdGEocGZfZGV2KTsNCj4gPiA+ID4gKwlpZiAo
IXBmX3FtKSB7DQo+ID4gPiA+ICsJCXByX2VycigiSGlTaSBBQ0MgcW0gZHJpdmVyIG5vdCBsb2Fk
ZWRcbiIpOw0KPiA+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ID4gKwl9DQo+ID4gPg0K
PiA+ID4gTm9wZSwgdGhpcyBpcyBsb2NrZWQgd3JvbmcgYW5kIGhhcyBubyBsaWZldGltZSBtYW5h
Z2VtZW50Lg0KPiA+DQo+ID4gT2suIEhvbGRpbmcgdGhlIGRldmljZV9sb2NrKCkgc3VmZmljaWVu
dCBoZXJlPw0KPiANCj4gWW91IGNhbid0IGhvbGQgYSBoaXNpX3FtIHBvaW50ZXIgd2l0aCBzb21l
IGtpbmQgb2YgbGlmZWN5Y2xlDQo+IG1hbmFnZW1lbnQgb2YgdGhhdCBwb2ludGVyLiBkZXZpY2Vf
bG9jay9ldGMgaXMgbmVjZXNzYXJ5IHRvIGNhbGwNCj4gcGNpX2dldF9kcnZkYXRhKCkNCg0KU2lu
Y2UgdGhpcyBtaWdyYXRpb24gZHJpdmVyIG9ubHkgc3VwcG9ydHMgVkYgZGV2aWNlcyBhbmQgdGhl
IFBGDQpkcml2ZXIgd2lsbCBub3QgYmUgcmVtb3ZlZCB1bnRpbCBhbGwgdGhlIFZGIGRldmljZXMg
Z2V0cyByZW1vdmVkLA0KaXMgdGhlIGxvY2tpbmcgbmVjZXNzYXJ5IGhlcmU/DQoNClRoZSBmbG93
IGZyb20gUEYgZHJpdmVyIHJlbW92ZSgpIHBhdGggaXMgc29tZXRoaW5nIGxpa2UgdGhpcywNCg0K
aWYgKHFtLT5mdW5fdHlwZSA9PSBRTV9IV19QRiAmJiBxbS0+dmZzX251bSkNCgkJaGlzaV9xbV9z
cmlvdl9kaXNhYmxlKHBkZXYsIHRydWUpOw0KICAgICAgICAgIHBjaV9kaXNhYmxlX3NyaW92KHBk
ZXYpLg0KDQpUaGFua3MsDQpTaGFtZWVyDQoNCg0K
