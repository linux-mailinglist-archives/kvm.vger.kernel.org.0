Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97F751B8C0
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241182AbiEEH3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiEEH3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:29:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E841E3C1
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:26:04 -0700 (PDT)
Received: from kwepemi500011.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kv4tH12cHzGp6M;
        Thu,  5 May 2022 15:23:19 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 kwepemi500011.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 15:26:02 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 15:26:01 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Thu, 5 May 2022 08:25:59 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        jiangkunkun <jiangkunkun@huawei.com>
Subject: RE: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Topic: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Index: AQHYW0SOJt+hrtPz+UGjCaMWTRJpLK0GftqAgAArz4CACT+tUA==
Date:   Thu, 5 May 2022 07:25:59 +0000
Message-ID: <e25a157d76a64fb78793efeb072ff53c@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
In-Reply-To: <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9hbyBNYXJ0aW5zIFtt
YWlsdG86am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbV0NCj4gU2VudDogMjkgQXByaWwgMjAyMiAx
MjowNQ0KPiBUbzogVGlhbiwgS2V2aW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiBDYzogSm9l
cmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+OyBTdXJhdmVlIFN1dGhpa3VscGFuaXQNCj4gPHN1
cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPjsgV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9y
Zz47IFJvYmluDQo+IE11cnBoeSA8cm9iaW4ubXVycGh5QGFybS5jb20+OyBKZWFuLVBoaWxpcHBl
IEJydWNrZXINCj4gPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz47IHpodWtlcWlhbiA8emh1a2Vx
aWFuMUBodWF3ZWkuY29tPjsNCj4gU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFs
aS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPjsNCj4gRGF2aWQgV29vZGhvdXNlIDxkd213MkBp
bmZyYWRlYWQub3JnPjsgTHUgQmFvbHUNCj4gPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT47IEph
c29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+OyBOaWNvbGluIENoZW4NCj4gPG5pY29saW5j
QG52aWRpYS5jb20+OyBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT47IEVyaWMgQXVn
ZXINCj4gPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT47IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwu
Y29tPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT47IENv
cm5lbGlhIEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsg
aW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBS
RkMgMTUvMTldIGlvbW11L2FybS1zbW11LXYzOiBBZGQNCj4gc2V0X2RpcnR5X3RyYWNraW5nX3Jh
bmdlKCkgc3VwcG9ydA0KPiANCj4gT24gNC8yOS8yMiAwOToyOCwgVGlhbiwgS2V2aW4gd3JvdGU6
DQo+ID4+IEZyb206IEpvYW8gTWFydGlucyA8am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbT4NCj4g
Pj4gU2VudDogRnJpZGF5LCBBcHJpbCAyOSwgMjAyMiA1OjA5IEFNDQo+ID4+DQo+ID4+IFNpbWls
YXIgdG8gLnJlYWRfYW5kX2NsZWFyX2RpcnR5KCkgdXNlIHRoZSBwYWdlIHRhYmxlDQo+ID4+IHdh
bGtlciBoZWxwZXIgZnVuY3Rpb25zIGFuZCBzZXQgREJNfFJET05MWSBiaXQsIHRodXMNCj4gPj4g
c3dpdGNoaW5nIHRoZSBJT1BURSB0byB3cml0ZWFibGUtY2xlYW4uDQo+ID4NCj4gPiB0aGlzIHNo
b3VsZCBub3QgYmUgb25lLW9mZiBpZiB0aGUgb3BlcmF0aW9uIG5lZWRzIHRvIGJlDQo+ID4gYXBw
bGllZCB0byBJT1BURS4gU2F5IGEgbWFwIHJlcXVlc3QgY29tZXMgcmlnaHQgYWZ0ZXINCj4gPiBz
ZXRfZGlydHlfdHJhY2tpbmcoKSBpcyBjYWxsZWQuIElmIGl0J3MgYWdyZWVkIHRvIHJlbW92ZQ0K
PiA+IHRoZSByYW5nZSBvcCB0aGVuIHNtbXUgZHJpdmVyIHNob3VsZCByZWNvcmQgdGhlIHRyYWNr
aW5nDQo+ID4gc3RhdHVzIGludGVybmFsbHkgYW5kIHRoZW4gYXBwbHkgdGhlIG1vZGlmaWVyIHRv
IGFsbCB0aGUgbmV3DQo+ID4gbWFwcGluZ3MgYXV0b21hdGljYWxseSBiZWZvcmUgZGlydHkgdHJh
Y2tpbmcgaXMgZGlzYWJsZWQuDQo+ID4gT3RoZXJ3aXNlIHRoZSBzYW1lIGxvZ2ljIG5lZWRzIHRv
IGJlIGtlcHQgaW4gaW9tbXVmZCB0bw0KPiA+IGNhbGwgc2V0X2RpcnR5X3RyYWNraW5nX3Jhbmdl
KCkgZXhwbGljaXRseSBmb3IgZXZlcnkgbmV3DQo+ID4gaW9wdF9hcmVhIGNyZWF0ZWQgd2l0aGlu
IHRoZSB0cmFja2luZyB3aW5kb3cuDQo+IA0KPiBHYWgsIEkgdG90YWxseSBtaXNzZWQgdGhhdCBi
eSBtaXN0YWtlLiBOZXcgbWFwcGluZ3MgYXJlbid0DQo+IGNhcnJ5aW5nIG92ZXIgdGhlICJEQk0g
aXMgc2V0Ii4gVGhpcyBuZWVkcyBhIG5ldyBpby1wZ3RhYmxlDQo+IHF1aXJrIGFkZGVkIHBvc3Qg
ZGlydHktdHJhY2tpbmcgdG9nZ2xpbmcuDQo+IA0KPiBJIGNhbiBhZGp1c3QsIGJ1dCBJIGFtIGF0
IG9kZHMgb24gaW5jbHVkaW5nIHRoaXMgaW4gYSBmdXR1cmUNCj4gaXRlcmF0aW9uIGdpdmVuIHRo
YXQgSSBjYW4ndCByZWFsbHkgdGVzdCBhbnkgb2YgdGhpcyBzdHVmZi4NCj4gTWlnaHQgZHJvcCB0
aGUgZHJpdmVyIHVudGlsIEkgaGF2ZSBoYXJkd2FyZS9lbXVsYXRpb24gSSBjYW4NCj4gdXNlIChv
ciBtYXliZSBvdGhlcnMgY2FuIHRha2Ugb3ZlciB0aGlzKS4gSXQgd2FzIGluY2x1ZGVkDQo+IGZv
ciByZXZpc2luZyB0aGUgaW9tbXUgY29yZSBvcHMgYW5kIHdoZXRoZXIgaW9tbXVmZCB3YXMNCj4g
YWZmZWN0ZWQgYnkgaXQuDQoNClsrS3Vua3VuIEppYW5nXS4gSSB0aGluayBoZSBpcyBub3cgbG9v
a2luZyBpbnRvIHRoaXMgYW5kIG1pZ2h0IGhhdmUNCmEgdGVzdCBzZXR1cCB0byB2ZXJpZnkgdGhp
cy4NCg0KVGhhbmtzLA0KU2hhbWVlcg0KDQoNCg==
