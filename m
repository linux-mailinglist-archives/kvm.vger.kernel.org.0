Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5967C717BAD
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 11:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbjEaJVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 05:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjEaJVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 05:21:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67AEA0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 02:21:18 -0700 (PDT)
Received: from lhrpeml100005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QWNtB5f9bz6J71d;
        Wed, 31 May 2023 17:16:18 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 10:21:15 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Wed, 31 May 2023 10:21:15 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
 IOMMU_DOMAIN_F_ENFORCE_DIRTY
Thread-Topic: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
 IOMMU_DOMAIN_F_ENFORCE_DIRTY
Thread-Index: AQHZicpBslUZ4SR8FEqbgFGqVge/dq9y6VZwgABJwwCAAPqi0A==
Date:   Wed, 31 May 2023 09:21:15 +0000
Message-ID: <fd9b48c15edf4060b860e2aeb0c310b1@huawei.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-25-joao.m.martins@oracle.com>
 <244a1a22766e4b46b75a74d202254b0d@huawei.com>
 <b42dbaa1-ea68-b0f2-a74b-95832413e44b@oracle.com>
In-Reply-To: <b42dbaa1-ea68-b0f2-a74b-95832413e44b@oracle.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9hbyBNYXJ0aW5zIFtt
YWlsdG86am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbV0NCj4gU2VudDogMzAgTWF5IDIwMjMgMjA6
MjANCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0u
dGhvZGlAaHVhd2VpLmNvbT4NCj4gQ2M6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+
OyBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT47DQo+IEx1IEJhb2x1IDxiYW9sdS5s
dUBsaW51eC5pbnRlbC5jb20+OyBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT47IFlpIFkgU3Vu
DQo+IDx5aS55LnN1bkBpbnRlbC5jb20+OyBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5j
b20+OyBOaWNvbGluIENoZW4NCj4gPG5pY29saW5jQG52aWRpYS5jb20+OyBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz47IEplYW4tUGhpbGlwcGUNCj4gQnJ1Y2tlciA8amVhbi1waGlsaXBw
ZUBsaW5hcm8ub3JnPjsgU3VyYXZlZSBTdXRoaWt1bHBhbml0DQo+IDxzdXJhdmVlLnN1dGhpa3Vs
cGFuaXRAYW1kLmNvbT47IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBSb2Jpbg0KPiBN
dXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4Lndp
bGxpYW1zb25AcmVkaGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGlvbW11QGxpc3Rz
LmxpbnV4LmRldg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQ3YyIDI0LzI0XSBpb21tdS9hcm0t
c21tdS12MzogQWR2ZXJ0aXNlDQo+IElPTU1VX0RPTUFJTl9GX0VORk9SQ0VfRElSVFkNCj4gDQo+
IE9uIDMwLzA1LzIwMjMgMTU6MTAsIFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgd3JvdGU6DQo+
ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEpvYW8gTWFydGlucyBb
bWFpbHRvOmpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb21dDQo+ID4+IFNlbnQ6IDE4IE1heSAyMDIz
IDIxOjQ3DQo+ID4+IFRvOiBpb21tdUBsaXN0cy5saW51eC5kZXYNCj4gPj4gQ2M6IEphc29uIEd1
bnRob3JwZSA8amdnQG52aWRpYS5jb20+OyBLZXZpbiBUaWFuDQo+IDxrZXZpbi50aWFuQGludGVs
LmNvbT47DQo+ID4+IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3Ro
dW0udGhvZGlAaHVhd2VpLmNvbT47DQo+IEx1DQo+ID4+IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+OyBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT47IFlpIFkgU3VuDQo+ID4+IDx5
aS55LnN1bkBpbnRlbC5jb20+OyBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+OyBO
aWNvbGluIENoZW4NCj4gPj4gPG5pY29saW5jQG52aWRpYS5jb20+OyBKb2VyZyBSb2VkZWwgPGpv
cm9AOGJ5dGVzLm9yZz47IEplYW4tUGhpbGlwcGUNCj4gPj4gQnJ1Y2tlciA8amVhbi1waGlsaXBw
ZUBsaW5hcm8ub3JnPjsgU3VyYXZlZSBTdXRoaWt1bHBhbml0DQo+ID4+IDxzdXJhdmVlLnN1dGhp
a3VscGFuaXRAYW1kLmNvbT47IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBSb2Jpbg0K
PiA+PiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPjsgQWxleCBXaWxsaWFtc29uDQo+ID4+
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IEpvYW8g
TWFydGlucw0KPiA+PiA8am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbT4NCj4gPj4gU3ViamVjdDog
W1BBVENIIFJGQ3YyIDI0LzI0XSBpb21tdS9hcm0tc21tdS12MzogQWR2ZXJ0aXNlDQo+ID4+IElP
TU1VX0RPTUFJTl9GX0VORk9SQ0VfRElSVFkNCj4gPj4NCj4gPj4gTm93IHRoYXQgd2UgcHJvYmUs
IGFuZCBoYW5kbGUgdGhlIERCTSBiaXQgbW9kaWZpZXIsIHVuYmxvY2sNCj4gPj4gdGhlIGtBUEkg
dXNhZ2UgYnkgZXhwb3NpbmcgdGhlIElPTU1VX0RPTUFJTl9GX0VORk9SQ0VfRElSVFkNCj4gPj4g
YW5kIGltcGxlbWVudCBpdCdzIHJlcXVpcmVtZW50IG9mIHJldm9raW5nIGRldmljZSBhdHRhY2ht
ZW50DQo+ID4+IGluIHRoZSBpb21tdV9jYXBhYmxlLiBGaW5hbGx5IGV4cG9zZSB0aGUgSU9NTVVf
Q0FQX0RJUlRZIHRvDQo+ID4+IHVzZXJzIChJT01NVUZEX0RFVklDRV9HRVRfQ0FQUykuDQo+ID4+
DQo+ID4+IFNpZ25lZC1vZmYtYnk6IEpvYW8gTWFydGlucyA8am9hby5tLm1hcnRpbnNAb3JhY2xl
LmNvbT4NCj4gPj4gLS0tDQo+ID4+ICBkcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0t
c21tdS12My5jIHwgOCArKysrKysrKw0KPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUt
djMvYXJtLXNtbXUtdjMuYw0KPiA+PiBiL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2Fy
bS1zbW11LXYzLmMNCj4gPj4gaW5kZXggYmYwYWFjMzMzNzI1Li43MWRkOTVhNjg3ZmQgMTAwNjQ0
DQo+ID4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMN
Cj4gPj4gKysrIGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYw0K
PiA+PiBAQCAtMjAxNCw2ICsyMDE0LDggQEAgc3RhdGljIGJvb2wgYXJtX3NtbXVfY2FwYWJsZShz
dHJ1Y3QgZGV2aWNlDQo+ICpkZXYsDQo+ID4+IGVudW0gaW9tbXVfY2FwIGNhcCkNCj4gPj4gIAkJ
cmV0dXJuIG1hc3Rlci0+c21tdS0+ZmVhdHVyZXMgJg0KPiA+PiBBUk1fU01NVV9GRUFUX0NPSEVS
RU5DWTsNCj4gPj4gIAljYXNlIElPTU1VX0NBUF9OT0VYRUM6DQo+ID4+ICAJCXJldHVybiB0cnVl
Ow0KPiA+PiArCWNhc2UgSU9NTVVfQ0FQX0RJUlRZOg0KPiA+PiArCQlyZXR1cm4gYXJtX3NtbXVf
ZGJtX2NhcGFibGUobWFzdGVyLT5zbW11KTsNCj4gPj4gIAlkZWZhdWx0Og0KPiA+PiAgCQlyZXR1
cm4gZmFsc2U7DQo+ID4+ICAJfQ0KPiA+PiBAQCAtMjQzMCw2ICsyNDMyLDExIEBAIHN0YXRpYyBp
bnQgYXJtX3NtbXVfYXR0YWNoX2RldihzdHJ1Y3QNCj4gPj4gaW9tbXVfZG9tYWluICpkb21haW4s
IHN0cnVjdCBkZXZpY2UgKmRldikNCj4gPj4gIAltYXN0ZXIgPSBkZXZfaW9tbXVfcHJpdl9nZXQo
ZGV2KTsNCj4gPj4gIAlzbW11ID0gbWFzdGVyLT5zbW11Ow0KPiA+Pg0KPiA+PiArCWlmIChkb21h
aW4tPmZsYWdzICYgSU9NTVVfRE9NQUlOX0ZfRU5GT1JDRV9ESVJUWSAmJg0KPiA+PiArCSAgICAh
YXJtX3NtbXVfZGJtX2NhcGFibGUoc21tdSkpDQo+ID4+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+
PiArDQo+ID4+ICsNCj4gPg0KPiA+IFNpbmNlIHdlIGhhdmUgdGhlIHN1cHBvcnRlZF9mbGFncyBh
bHdheXMgc2V0IHRvICINCj4gSU9NTVVfRE9NQUlOX0ZfRU5GT1JDRV9ESVJUWSINCj4gPiBiZWxv
dywgcGxhdGZvcm1zIHRoYXQgZG9lc24ndCBoYXZlIERCTSBjYXBhYmlsaXR5IHdpbGwgZmFpbCBo
ZXJlLCByaWdodD8NCj4gPiBPciB0aGUgaWRlYSBpcyB0byBzZXQNCj4gPiBkb21haW4gZmxhZyBv
bmx5IGlmIHRoZSBjYXBhYmlsaXR5IGlzIHJlcG9ydGVkIHRydWU/IEJ1dCB0aGUNCj4gaW9tbXVf
ZG9tYWluX3NldF9mbGFncygpIGRvZXNuJ3QNCj4gPiBzZWVtcyB0byBjaGVjayB0aGUgY2FwYWJp
bGl0eSB0aG91Z2guDQo+ID4NCj4gQXMgcG9zdGVkIHRoZSBjaGVja2luZyB3YXMgb25seSB0YWtl
IHBsYWNlIGF0IGRldmljZV9hdHRhY2ggKGFuZCB5b3Ugd291bGQNCj4gc2V0DQo+IHRoZSBlbmZv
cmNlbWVudCBmbGFnIGlmIGlvbW11ZmQgcmVwb3J0cyB0aGUgY2FwYWJpbGl0eSBmb3IgdGhlIGRl
dmljZSB2aWENCj4gSU9NTVVfREVWSUNFX0dFVF9DQVBTKS4NCg0KT2suIFNvIENBUFMgaXMgcmV0
cmlldmVkIGJlZm9yZSB3ZSBzZXQgdGhlIGVuZm9yY2VtZW50IGZsYWcuDQoNCj4gDQo+IEJ1dCB0
aGUgd29ya2Zsb3cgd2lsbCBjaGFuZ2UgYSBiaXQ6IHdoaWxlIHRoZSBlbmZvcmNlbWVudCBhbHNv
IHRha2VzIHBsYWNlDQo+IG9uDQo+IGRldmljZSBhdHRhY2gsIGJ1dCB3aGVuIHdlIGNyZWF0ZSBh
IEhXUFQgZG9tYWluIHdpdGggZmxhZ3MgKGluDQo+IGRvbWFpbl9hbGxvY191c2VyWzBdKSwgdGhl
IGRpcnR5IHRyYWNraW5nIGlzIGFsc28gZ29pbmcgdG8gYmUgY2hlY2tlZCB0aGVyZQ0KPiBhZ2Fp
bnN0IHRoZSBkZXZpY2UgcGFzc2VkIGluIGRvbWFpbl9hbGxvY191c2VyKCkgaW4gdGhlIGRyaXZl
cg0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gQW5kIG90aGVyd2lzZSBmYWlsIGlmIGRvZXNuJ3Qgc3Vw
cG9ydCB3aGVuIGRpcnR5LXRyYWNraW5nIHN1cHBvcnQNCj4gZW5mb3JjZW1lbnQgYXMNCj4gcGFz
c2VkIGJ5IGZsYWdzLiBXaGVuIHdlIGRvbid0IHJlcXVlc3QgZGlydHkgdHJhY2tpbmcgdGhlIGlv
bW11IG9wcyB0aGF0DQo+IHBlcmZvcm0NCj4gdGhlIGRpcnR5IHRyYWNraW5nIHdpbGwgYWxzbyBi
ZSBrZXB0IGNsZWFyZWQuDQoNCk9rLg0KDQo+IA0KPiBbMF0NCj4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGludXgtaW9tbXUvMjAyMzA1MTExNDM4NDQuMjI2OTMtMi15aS5sLmxpdUBpbnRlDQo+
IGwuY29tLw0KPiANCj4gPiAoVGhpcyBzZWVtcyB0byBiZSBjYXVzaW5nIHByb2JsZW0gd2l0aCBh
IHJlYmFzZWQgUWVtdSBicmFuY2ggZm9yIEFSTSBJDQo+IGhhdmUgd2hpbGUgc2FuaXR5DQo+ID4g
dGVzdGluZyBvbiBhIHBsYXRmb3JtIHRoYXQgZG9lc24ndCBoYXZlIERCTS4gSSBuZWVkIHRvIGRv
dWJsZSBjaGVjaw0KPiB0aG91Z2gpLg0KPiA+DQo+IA0KPiBQZXJoYXBzIGR1ZSB0byB0aGUgYnJv
a2VuIGNoZWNrIEkgaGFkIHRoYXQgSSBuZWVkIHZhbGlkYXRlIHRoZSB0d28gYml0cw0KPiB0b2dl
dGhlciwgd2hlbiBpdCBkaWRuJ3QgaGFkIERCTSBzZXQ/DQoNCkkgaGF2ZSB0aGF0IGZpeGVkIGlu
IG15IGJyYW5jaCBub3cuDQoNCiBPciBJIHN1c3BlY3QgYmVjYXVzZSB0aGUgcWVtdSBsYXN0DQo+
IHBhdGNoIEkNCj4gd2FzIGFsd2F5cyBlbmQgdXAgc2V0dGluZyBJT01NVV9ET01BSU5fRl9FTkZP
UkNFX0RJUlRZIFsqXSwgYW5kDQo+IGJlY2F1c2UgdGhlDQo+IGNoZWNraW5nIGlzIGFsd2F5cyBl
bmFibGVkIHlvdSBjYW4gbmV2ZXIgYXR0YWNoIGRldmljZXMuDQoNCkFoLi4gdGhpcyBpcyBpdC4g
DQoNCj4gWypdIFRoYXQgbGFzdCBwYXRjaCBpc24ndCBxdWl0ZSB0aGVyZSB5ZXQgYXMgaXQgaXMg
bWVhbnQgdG8gYmUgdXNpbmcNCj4gZGV2aWNlLWdldC1jYXBzIHByaW9yIHRvIHNldHRpbmcgdGhl
IGVuZm9yY2VtZW50LCBsaWtlIHRoZSBzZWxmdGVzdHMNCg0KR290IGl0Lg0KDQpUaGFua3MsDQpT
aGFtZWVyDQo=
