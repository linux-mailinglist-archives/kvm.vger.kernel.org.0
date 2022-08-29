Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801955A46A1
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiH2J70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 05:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiH2J7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 05:59:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2025EDF2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 02:59:23 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MGQll4kkGzYcr4;
        Mon, 29 Aug 2022 17:54:59 +0800 (CST)
Received: from kwepemm000007.china.huawei.com (7.193.23.189) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 17:59:21 +0800
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 17:59:20 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Mon, 29 Aug 2022 10:59:18 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        zhukeqian <zhukeqian1@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        jiangkunkun <jiangkunkun@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Topic: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Index: AQHYW0SOJt+hrtPz+UGjCaMWTRJpLK0GftqAgAArz4CACT+tUIAAGgyAgLZdwzA=
Date:   Mon, 29 Aug 2022 09:59:18 +0000
Message-ID: <daf48dd4dd134b05b19fb58e6d92d9ee@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <e25a157d76a64fb78793efeb072ff53c@huawei.com>
 <dbc96a71-4571-ac8a-e6e4-d2763f9c251d@oracle.com>
In-Reply-To: <dbc96a71-4571-ac8a-e6e4-d2763f9c251d@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.156.182]
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9hbyBNYXJ0aW5zIFtt
YWlsdG86am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbV0NCj4gU2VudDogMDUgTWF5IDIwMjIgMTA6
NTMNCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0u
dGhvZGlAaHVhd2VpLmNvbT4NCj4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPjsg
U3VyYXZlZSBTdXRoaWt1bHBhbml0DQo+IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1kLmNvbT47
IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+OyBSb2Jpbg0KPiBNdXJwaHkgPHJvYmluLm11
cnBoeUBhcm0uY29tPjsgSmVhbi1QaGlsaXBwZSBCcnVja2VyDQo+IDxqZWFuLXBoaWxpcHBlQGxp
bmFyby5vcmc+OyB6aHVrZXFpYW4gPHpodWtlcWlhbjFAaHVhd2VpLmNvbT47IERhdmlkDQo+IFdv
b2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+Ow0KPiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPjsgTmljb2xpbiBD
aGVuIDxuaWNvbGluY0BudmlkaWEuY29tPjsNCj4gWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52aWRp
YS5jb20+OyBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ow0KPiBMaXUsIFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT47IEFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20+OyBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT47DQo+IGt2bUB2
Z2VyLmtlcm5lbC5vcmc7IGlvbW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnOyBqaWFuZ2t1
bmt1bg0KPiA8amlhbmdrdW5rdW5AaHVhd2VpLmNvbT47IFRpYW4sIEtldmluIDxrZXZpbi50aWFu
QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBSRkMgMTUvMTldIGlvbW11L2FybS1z
bW11LXYzOiBBZGQNCj4gc2V0X2RpcnR5X3RyYWNraW5nX3JhbmdlKCkgc3VwcG9ydA0KPiANCj4g
T24gNS81LzIyIDA4OjI1LCBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpIHdyb3RlOg0KPiA+PiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBKb2FvIE1hcnRpbnMgW21haWx0
bzpqb2FvLm0ubWFydGluc0BvcmFjbGUuY29tXQ0KPiA+PiBTZW50OiAyOSBBcHJpbCAyMDIyIDEy
OjA1DQo+ID4+IFRvOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4+IENj
OiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdA0K
PiA+PiA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+OyBXaWxsIERlYWNvbiA8d2lsbEBr
ZXJuZWwub3JnPjsgUm9iaW4NCj4gPj4gTXVycGh5IDxyb2Jpbi5tdXJwaHlAYXJtLmNvbT47IEpl
YW4tUGhpbGlwcGUgQnJ1Y2tlcg0KPiA+PiA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPjsgemh1
a2VxaWFuIDx6aHVrZXFpYW4xQGh1YXdlaS5jb20+Ow0KPiA+PiBTaGFtZWVyYWxpIEtvbG90aHVt
IFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+Ow0KPiA+PiBEYXZp
ZCBXb29kaG91c2UgPGR3bXcyQGluZnJhZGVhZC5vcmc+OyBMdSBCYW9sdQ0KPiA+PiA8YmFvbHUu
bHVAbGludXguaW50ZWwuY29tPjsgSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT47IE5p
Y29saW4NCj4gQ2hlbg0KPiA+PiA8bmljb2xpbmNAbnZpZGlhLmNvbT47IFlpc2hhaSBIYWRhcyA8
eWlzaGFpaEBudmlkaWEuY29tPjsgRXJpYyBBdWdlcg0KPiA+PiA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPjsgTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+OyBBbGV4IFdpbGxpYW1zb24NCj4g
Pj4gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsgQ29ybmVsaWEgSHVjayA8Y29odWNrQHJl
ZGhhdC5jb20+Ow0KPiA+PiBrdm1Admdlci5rZXJuZWwub3JnOyBpb21tdUBsaXN0cy5saW51eC1m
b3VuZGF0aW9uLm9yZw0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQyAxNS8xOV0gaW9tbXUv
YXJtLXNtbXUtdjM6IEFkZA0KPiA+PiBzZXRfZGlydHlfdHJhY2tpbmdfcmFuZ2UoKSBzdXBwb3J0
DQo+ID4+DQo+ID4+IE9uIDQvMjkvMjIgMDk6MjgsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+
IEZyb206IEpvYW8gTWFydGlucyA8am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbT4NCj4gPj4+PiBT
ZW50OiBGcmlkYXksIEFwcmlsIDI5LCAyMDIyIDU6MDkgQU0NCj4gPj4+Pg0KPiA+Pj4+IFNpbWls
YXIgdG8gLnJlYWRfYW5kX2NsZWFyX2RpcnR5KCkgdXNlIHRoZSBwYWdlIHRhYmxlDQo+ID4+Pj4g
d2Fsa2VyIGhlbHBlciBmdW5jdGlvbnMgYW5kIHNldCBEQk18UkRPTkxZIGJpdCwgdGh1cw0KPiA+
Pj4+IHN3aXRjaGluZyB0aGUgSU9QVEUgdG8gd3JpdGVhYmxlLWNsZWFuLg0KPiA+Pj4NCj4gPj4+
IHRoaXMgc2hvdWxkIG5vdCBiZSBvbmUtb2ZmIGlmIHRoZSBvcGVyYXRpb24gbmVlZHMgdG8gYmUN
Cj4gPj4+IGFwcGxpZWQgdG8gSU9QVEUuIFNheSBhIG1hcCByZXF1ZXN0IGNvbWVzIHJpZ2h0IGFm
dGVyDQo+ID4+PiBzZXRfZGlydHlfdHJhY2tpbmcoKSBpcyBjYWxsZWQuIElmIGl0J3MgYWdyZWVk
IHRvIHJlbW92ZQ0KPiA+Pj4gdGhlIHJhbmdlIG9wIHRoZW4gc21tdSBkcml2ZXIgc2hvdWxkIHJl
Y29yZCB0aGUgdHJhY2tpbmcNCj4gPj4+IHN0YXR1cyBpbnRlcm5hbGx5IGFuZCB0aGVuIGFwcGx5
IHRoZSBtb2RpZmllciB0byBhbGwgdGhlIG5ldw0KPiA+Pj4gbWFwcGluZ3MgYXV0b21hdGljYWxs
eSBiZWZvcmUgZGlydHkgdHJhY2tpbmcgaXMgZGlzYWJsZWQuDQo+ID4+PiBPdGhlcndpc2UgdGhl
IHNhbWUgbG9naWMgbmVlZHMgdG8gYmUga2VwdCBpbiBpb21tdWZkIHRvDQo+ID4+PiBjYWxsIHNl
dF9kaXJ0eV90cmFja2luZ19yYW5nZSgpIGV4cGxpY2l0bHkgZm9yIGV2ZXJ5IG5ldw0KPiA+Pj4g
aW9wdF9hcmVhIGNyZWF0ZWQgd2l0aGluIHRoZSB0cmFja2luZyB3aW5kb3cuDQo+ID4+DQo+ID4+
IEdhaCwgSSB0b3RhbGx5IG1pc3NlZCB0aGF0IGJ5IG1pc3Rha2UuIE5ldyBtYXBwaW5ncyBhcmVu
J3QNCj4gPj4gY2Fycnlpbmcgb3ZlciB0aGUgIkRCTSBpcyBzZXQiLiBUaGlzIG5lZWRzIGEgbmV3
IGlvLXBndGFibGUNCj4gPj4gcXVpcmsgYWRkZWQgcG9zdCBkaXJ0eS10cmFja2luZyB0b2dnbGlu
Zy4NCj4gPj4NCj4gPj4gSSBjYW4gYWRqdXN0LCBidXQgSSBhbSBhdCBvZGRzIG9uIGluY2x1ZGlu
ZyB0aGlzIGluIGEgZnV0dXJlDQo+ID4+IGl0ZXJhdGlvbiBnaXZlbiB0aGF0IEkgY2FuJ3QgcmVh
bGx5IHRlc3QgYW55IG9mIHRoaXMgc3R1ZmYuDQo+ID4+IE1pZ2h0IGRyb3AgdGhlIGRyaXZlciB1
bnRpbCBJIGhhdmUgaGFyZHdhcmUvZW11bGF0aW9uIEkgY2FuDQo+ID4+IHVzZSAob3IgbWF5YmUg
b3RoZXJzIGNhbiB0YWtlIG92ZXIgdGhpcykuIEl0IHdhcyBpbmNsdWRlZA0KPiA+PiBmb3IgcmV2
aXNpbmcgdGhlIGlvbW11IGNvcmUgb3BzIGFuZCB3aGV0aGVyIGlvbW11ZmQgd2FzDQo+ID4+IGFm
ZmVjdGVkIGJ5IGl0Lg0KPiA+DQo+ID4gWytLdW5rdW4gSmlhbmddLiBJIHRoaW5rIGhlIGlzIG5v
dyBsb29raW5nIGludG8gdGhpcyBhbmQgbWlnaHQgaGF2ZQ0KPiA+IGEgdGVzdCBzZXR1cCB0byB2
ZXJpZnkgdGhpcy4NCj4gDQo+IEknbGwga2VlcCBoaW0gQ0MnZWQgbmV4dCBpdGVyYXRpb25zLiBU
aGFua3MhDQo+IA0KPiBGV0lXLCB0aGUgc2hvdWxkIGNoYW5nZSBhIGJpdCBvbiBuZXh0IGl0ZXJh
dGlvbiAoc2ltcGxlcikNCj4gYnkgYWx3YXlzIGVuYWJsaW5nIERCTSBmcm9tIHRoZSBzdGFydC4g
U01NVXYzIDo6c2V0X2RpcnR5X3RyYWNraW5nKCkNCj4gYmVjb21lcw0KPiBhIHNpbXBsZXIgZnVu
Y3Rpb24gdGhhdCB0ZXN0cyBxdWlya3MgKGkuZS4gREJNIHNldCkgYW5kIHdoYXQgbm90LCBhbmQg
Y2FsbHMNCj4gcmVhZF9hbmRfY2xlYXJfZGlydHkoKSB3aXRob3V0IGEgYml0bWFwIGFyZ3VtZW50
IHRvIGNsZWFyIGRpcnRpZXMuDQoNCkhpIEpvYW8sDQoNCkhvcGUgc29vbiB3ZSB3aWxsIGhhdmUg
YSByZXZpc2VkIHNwaW4gb24gdGhpcyBzZXJpZXMuIE1lYW50aW1lLCBJIHRyaWVkIHRvDQpoYWNr
IHRoZSBRZW11IHZTTU1VdjMgdG8gZW11bGF0ZSB0aGUgc3VwcG9ydCByZXF1aXJlZCB0byB0ZXN0
IHRoaXMgYXMgDQphY2Nlc3MgdG8gSGFyZHdhcmUgaXMgdmVyeSBsaW1pdGVkLiBJIG1hbmFnZSB0
byBoYXZlIGEganVzdCBlbm91Z2ggc2V0dXAgDQp0byBjb3ZlciB0aGUgQVJNIHNpZGUgb2YgdGhp
cyBzZXJpZXMuIEJhc2VkIG9uIHRoZSB0ZXN0IGNvdmVyYWdlIEkgaGFkIA0KYW5kIGdvaW5nIHRo
cm91Z2ggdGhlIGNvZGUsIHBsZWFzZSBzZWUgbXkgY29tbWVudHMgb24gZmV3IG9mIHRoZQ0KcGF0
Y2hlcyBvbiB0aGlzIHNlcmllcy4gSG9wZSwgaXQgd2lsbCBiZSBoZWxwZnVsIHdoZW4geW91IGF0
dGVtcHQgYSByZS1zcGluLg0KDQpUaGFua3MsDQpTaGFtZWVyDQogDQo=
