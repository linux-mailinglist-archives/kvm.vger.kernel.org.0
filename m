Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED57278DF
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbjFHHd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjFHHdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:33:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46F5E6C
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:33:52 -0700 (PDT)
Received: from kwepemm000008.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QcGCr2jpvzTlG4;
        Thu,  8 Jun 2023 15:33:28 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000008.china.huawei.com (7.193.23.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 15:33:49 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Thu, 8 Jun 2023 08:33:47 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH v2 1/3] vfio/pci: Cleanup Kconfig
Thread-Topic: [PATCH v2 1/3] vfio/pci: Cleanup Kconfig
Thread-Index: AQHZmZUhIbzKmD7di0W2z0FFWpRKIq+AgjgA
Date:   Thu, 8 Jun 2023 07:33:47 +0000
Message-ID: <6325cf9955524b848091c8446829e51f@huawei.com>
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
 <20230607230918.3157757-2-alex.williamson@redhat.com>
In-Reply-To: <20230607230918.3157757-2-alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleCBXaWxsaWFtc29u
IFttYWlsdG86YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb21dDQo+IFNlbnQ6IDA4IEp1bmUgMjAy
MyAwMDowOQ0KPiBUbzoga3ZtQHZnZXIua2VybmVsLm9yZw0KPiBDYzogQWxleCBXaWxsaWFtc29u
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT47IGpnZ0BudmlkaWEuY29tOw0KPiBjbGdAcmVk
aGF0LmNvbTsgZXJpYy5hdWdlckByZWRoYXQuY29tOyBsaXVsb25nZmFuZw0KPiA8bGl1bG9uZ2Zh
bmdAaHVhd2VpLmNvbT47IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gPHNoYW1lZXJhbGku
a29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47IHlpc2hhaWhAbnZpZGlhLmNvbTsNCj4ga2V2aW4u
dGlhbkBpbnRlbC5jb20NCj4gU3ViamVjdDogW1BBVENIIHYyIDEvM10gdmZpby9wY2k6IENsZWFu
dXAgS2NvbmZpZw0KPiANCj4gSXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvIHNlbGVjdCB2ZmlvLXBj
aSB2YXJpYW50IGRyaXZlcnMgd2l0aG91dCBidWlsZGluZw0KPiB2ZmlvLXBjaSBpdHNlbGYsIHdo
aWNoIGltcGxpZXMgZWFjaCB2YXJpYW50IGRyaXZlciBzaG91bGQgc2VsZWN0DQo+IHZmaW8tcGNp
LWNvcmUuDQo+IA0KPiBGaXggdGhlIHRvcCBsZXZlbCB2ZmlvIE1ha2VmaWxlIHRvIHRyYXZlcnNl
IHBjaSBiYXNlZCBvbiB2ZmlvLXBjaS1jb3JlDQo+IHJhdGhlciB0aGFuIHZmaW8tcGNpLg0KPiAN
Cj4gTWFyayBNTUFQIGFuZCBJTlRYIG9wdGlvbnMgZGVwZW5kaW5nIG9uIHZmaW8tcGNpLWNvcmUg
dG8gY2xlYW51cA0KPiByZXN1bHRpbmcNCj4gY29uZmlnIGlmIGNvcmUgaXMgbm90IGVuYWJsZWQu
DQo+IA0KPiBQdXNoIGFsbCBQQ0kgcmVsYXRlZCB2ZmlvIG9wdGlvbnMgdG8gYSBzdWItbWVudSBh
bmQgbWFrZSBkZXNjcmlwdGlvbnMNCj4gY29uc2lzdGVudC4NCj4gDQo+IFJldmlld2VkLWJ5OiBD
w6lkcmljIExlIEdvYXRlciA8Y2xnQHJlZGhhdC5jb20+DQo+IFJldmlld2VkLWJ5OiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggV2lsbGlh
bXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy92Zmlv
L01ha2VmaWxlICAgICAgICAgICAgICB8IDIgKy0NCj4gIGRyaXZlcnMvdmZpby9wY2kvS2NvbmZp
ZyAgICAgICAgICAgfCA4ICsrKysrKy0tDQo+ICBkcml2ZXJzL3ZmaW8vcGNpL2hpc2lsaWNvbi9L
Y29uZmlnIHwgNCArKy0tDQo+ICBkcml2ZXJzL3ZmaW8vcGNpL21seDUvS2NvbmZpZyAgICAgIHwg
MiArLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9NYWtlZmlsZSBiL2RyaXZlcnMvdmZp
by9NYWtlZmlsZQ0KPiBpbmRleCA3MGU3ZGNiMzAyZWYuLjE1MWU4MTZiMmZmOSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy92ZmlvL01ha2VmaWxlDQo+ICsrKyBiL2RyaXZlcnMvdmZpby9NYWtlZmls
ZQ0KPiBAQCAtMTAsNyArMTAsNyBAQCB2ZmlvLSQoQ09ORklHX1ZGSU9fVklSUUZEKSArPSB2aXJx
ZmQubw0KPiANCj4gIG9iai0kKENPTkZJR19WRklPX0lPTU1VX1RZUEUxKSArPSB2ZmlvX2lvbW11
X3R5cGUxLm8NCj4gIG9iai0kKENPTkZJR19WRklPX0lPTU1VX1NQQVBSX1RDRSkgKz0gdmZpb19p
b21tdV9zcGFwcl90Y2Uubw0KPiAtb2JqLSQoQ09ORklHX1ZGSU9fUENJKSArPSBwY2kvDQo+ICtv
YmotJChDT05GSUdfVkZJT19QQ0lfQ09SRSkgKz0gcGNpLw0KPiAgb2JqLSQoQ09ORklHX1ZGSU9f
UExBVEZPUk0pICs9IHBsYXRmb3JtLw0KPiAgb2JqLSQoQ09ORklHX1ZGSU9fTURFVikgKz0gbWRl
di8NCj4gIG9iai0kKENPTkZJR19WRklPX0ZTTF9NQykgKz0gZnNsLW1jLw0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL3BjaS9LY29uZmlnIGIvZHJpdmVycy92ZmlvL3BjaS9LY29uZmlnDQo+
IGluZGV4IGY5ZDBjOTA4ZTczOC4uODZiYjc4MzVjZjNjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3ZmaW8vcGNpL0tjb25maWcNCj4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS9LY29uZmlnDQo+IEBA
IC0xLDUgKzEsNyBAQA0KPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5
DQo+IC1pZiBQQ0kgJiYgTU1VDQo+ICttZW51ICJWRklPIHN1cHBvcnQgZm9yIFBDSSBkZXZpY2Vz
Ig0KPiArCWRlcGVuZHMgb24gUENJICYmIE1NVQ0KPiArDQo+ICBjb25maWcgVkZJT19QQ0lfQ09S
RQ0KPiAgCXRyaXN0YXRlDQo+ICAJc2VsZWN0IFZGSU9fVklSUUZEDQo+IEBAIC03LDkgKzksMTEg
QEAgY29uZmlnIFZGSU9fUENJX0NPUkUNCj4gDQo+ICBjb25maWcgVkZJT19QQ0lfTU1BUA0KPiAg
CWRlZl9ib29sIHkgaWYgIVMzOTANCj4gKwlkZXBlbmRzIG9uIFZGSU9fUENJX0NPUkUNCj4gDQo+
ICBjb25maWcgVkZJT19QQ0lfSU5UWA0KPiAgCWRlZl9ib29sIHkgaWYgIVMzOTANCj4gKwlkZXBl
bmRzIG9uIFZGSU9fUENJX0NPUkUNCj4gDQo+ICBjb25maWcgVkZJT19QQ0kNCj4gIAl0cmlzdGF0
ZSAiR2VuZXJpYyBWRklPIHN1cHBvcnQgZm9yIGFueSBQQ0kgZGV2aWNlIg0KPiBAQCAtNTksNCAr
NjMsNCBAQCBzb3VyY2UgImRyaXZlcnMvdmZpby9wY2kvbWx4NS9LY29uZmlnIg0KPiANCj4gIHNv
dXJjZSAiZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vS2NvbmZpZyINCj4gDQo+IC1lbmRpZg0K
PiArZW5kbWVudQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vS2Nv
bmZpZw0KPiBiL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL0tjb25maWcNCj4gaW5kZXggNWRh
YTBmNDVkMmY5Li5jYmYxYzMyZjZlYmYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdmZpby9wY2kv
aGlzaWxpY29uL0tjb25maWcNCj4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vS2Nv
bmZpZw0KPiBAQCAtMSwxMyArMSwxMyBAQA0KPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMC1vbmx5DQo+ICBjb25maWcgSElTSV9BQ0NfVkZJT19QQ0kNCj4gLQl0cmlzdGF0ZSAi
VkZJTyBQQ0kgc3VwcG9ydCBmb3IgSGlTaWxpY29uIEFDQyBkZXZpY2VzIg0KPiArCXRyaXN0YXRl
ICJWRklPIHN1cHBvcnQgZm9yIEhpU2lsaWNvbiBBQ0MgUENJIGRldmljZXMiDQoNClRoYW5rcyBm
b3IgY29ycmVjdGluZyB0aGlzLg0KDQo+ICAJZGVwZW5kcyBvbiBBUk02NCB8fCAoQ09NUElMRV9U
RVNUICYmIDY0QklUKQ0KPiAtCWRlcGVuZHMgb24gVkZJT19QQ0lfQ09SRQ0KPiAgCWRlcGVuZHMg
b24gUENJX01TSQ0KPiAgCWRlcGVuZHMgb24gQ1JZUFRPX0RFVl9ISVNJX1FNDQo+ICAJZGVwZW5k
cyBvbiBDUllQVE9fREVWX0hJU0lfSFBSRQ0KPiAgCWRlcGVuZHMgb24gQ1JZUFRPX0RFVl9ISVNJ
X1NFQzINCj4gIAlkZXBlbmRzIG9uIENSWVBUT19ERVZfSElTSV9aSVANCj4gKwlzZWxlY3QgVkZJ
T19QQ0lfQ09SRQ0KPiAgCWhlbHANCj4gIAkgIFRoaXMgcHJvdmlkZXMgZ2VuZXJpYyBQQ0kgc3Vw
cG9ydCBmb3IgSGlTaWxpY29uIEFDQyBkZXZpY2VzDQo+ICAJICB1c2luZyB0aGUgVkZJTyBmcmFt
ZXdvcmsuDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL21seDUvS2NvbmZpZyBiL2Ry
aXZlcnMvdmZpby9wY2kvbWx4NS9LY29uZmlnDQo+IGluZGV4IDI5YmE5YzUwNGE3NS4uNzA4OGVk
YzRmYjI4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL21seDUvS2NvbmZpZw0KPiAr
KysgYi9kcml2ZXJzL3ZmaW8vcGNpL21seDUvS2NvbmZpZw0KPiBAQCAtMiw3ICsyLDcgQEANCj4g
IGNvbmZpZyBNTFg1X1ZGSU9fUENJDQo+ICAJdHJpc3RhdGUgIlZGSU8gc3VwcG9ydCBmb3IgTUxY
NSBQQ0kgZGV2aWNlcyINCj4gIAlkZXBlbmRzIG9uIE1MWDVfQ09SRQ0KPiAtCWRlcGVuZHMgb24g
VkZJT19QQ0lfQ09SRQ0KPiArCXNlbGVjdCBWRklPX1BDSV9DT1JFDQo+ICAJaGVscA0KPiAgCSAg
VGhpcyBwcm92aWRlcyBtaWdyYXRpb24gc3VwcG9ydCBmb3IgTUxYNSBkZXZpY2VzIHVzaW5nIHRo
ZSBWRklPDQo+ICAJICBmcmFtZXdvcmsuDQoNClJldmlld2VkLWJ5OiBTaGFtZWVyIEtvbG90aHVt
IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+DQoNClRoYW5rcywNClNoYW1l
ZXINCg==
