Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4259A4CAFF1
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbiCBUd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244113AbiCBUdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:33:25 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA2C5F96;
        Wed,  2 Mar 2022 12:32:30 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K85Ny1nYfz67Nln;
        Thu,  3 Mar 2022 04:31:14 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 21:32:27 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 20:32:26 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 2 Mar 2022 20:32:26 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     John Garry <john.garry@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v7 04/10] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [PATCH v7 04/10] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHYLlsz/33ZeFvw7UOxSpAU81YIs6ysc3GAgAAY+FA=
Date:   Wed, 2 Mar 2022 20:32:26 +0000
Message-ID: <26885cd104714b748ab4337f6b924288@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-5-shameerali.kolothum.thodi@huawei.com>
 <499b0d93-9352-b52f-0ee8-7dc7fd0bac5c@huawei.com>
In-Reply-To: <499b0d93-9352-b52f-0ee8-7dc7fd0bac5c@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.91.128]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBHYXJyeQ0KPiBT
ZW50OiAwMiBNYXJjaCAyMDIyIDE5OjAzDQo+IFRvOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2Rp
IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1wY2lAdmdlci5rZXJuZWwub3JnOyBhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbTsgamdnQG52aWRpYS5jb207DQo+IGNvaHVja0ByZWRoYXQuY29tOyBt
Z3VydG92b3lAbnZpZGlhLmNvbTsgeWlzaGFpaEBudmlkaWEuY29tOyBMaW51eGFybQ0KPiA8bGlu
dXhhcm1AaHVhd2VpLmNvbT47IGxpdWxvbmdmYW5nIDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPjsg
WmVuZ3RhbyAoQikNCj4gPHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IEpvbmF0aGFuIENhbWVy
b24NCj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IFdhbmd6aG91IChCKSA8d2FuZ3po
b3UxQGhpc2lsaWNvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDQvMTBdIGhpc2lf
YWNjX3ZmaW9fcGNpOiBhZGQgbmV3IHZmaW9fcGNpIGRyaXZlciBmb3INCj4gSGlTaWxpY29uIEFD
QyBkZXZpY2VzDQo+IA0KPiBPbiAwMi8wMy8yMDIyIDE3OjI4LCBTaGFtZWVyIEtvbG90aHVtIHdy
b3RlOg0KPiA+ICtjb25maWcgSElTSV9BQ0NfVkZJT19QQ0kNCj4gPiArCXRyaXN0YXRlICJWRklP
IFBDSSBzdXBwb3J0IGZvciBIaVNpbGljb24gQUNDIGRldmljZXMiDQo+ID4gKwlkZXBlbmRzIG9u
IChBUk02NCAmJiBWRklPX1BDSV9DT1JFKSB8fCAoQ09NUElMRV9URVNUICYmIDY0QklUKQ0KPiAN
Cj4gVGhpcyBtZWFucyB0aGF0IHdlIHdpbGwgaGF2ZSBISVNJX0FDQ19WRklPX1BDST15IGZvciBD
T01QSUxFX1RFU1Q9eSBhbmQNCj4gNjRCSVQ9eSBhbmQgVkZJT19QQ0lfQ09SRT1uLCBidXQgLi4u
DQo+IA0KPiA+ICsJaGVscA0KPiA+ICsJICBUaGlzIHByb3ZpZGVzIGdlbmVyaWMgUENJIHN1cHBv
cnQgZm9yIEhpU2lsaWNvbiBBQ0MgZGV2aWNlcw0KPiA+ICsJICB1c2luZyB0aGUgVkZJTyBmcmFt
ZXdvcmsuDQo+ID4gKw0KPiA+ICsJICBJZiB5b3UgZG9uJ3Qga25vdyB3aGF0IHRvIGRvIGhlcmUs
IHNheSBOLg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL2hpc2lsaWNvbi9NYWtl
ZmlsZQ0KPiBiL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL01ha2VmaWxlDQo+ID4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmM2NmIzNzgzZjJmOQ0KPiA+
IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL2hpc2lsaWNvbi9NYWtl
ZmlsZQ0KPiA+IEBAIC0wLDAgKzEsNCBAQA0KPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wLW9ubHkNCj4gPiArb2JqLSQoQ09ORklHX0hJU0lfQUNDX1ZGSU9fUENJKSArPSBo
aXNpLWFjYy12ZmlvLXBjaS5vDQo+ID4gK2hpc2ktYWNjLXZmaW8tcGNpLXkgOj0gaGlzaV9hY2Nf
dmZpb19wY2kubw0KPiA+ICsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS9oaXNp
bGljb24vaGlzaV9hY2NfdmZpb19wY2kuYw0KPiBiL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29u
L2hpc2lfYWNjX3ZmaW9fcGNpLmMNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4
IDAwMDAwMDAwMDAwMC4uODEyOWMzNDU3YjNiDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBi
L2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL2hpc2lfYWNjX3ZmaW9fcGNpLmMNCj4gPiBAQCAt
MCwwICsxLDEwMCBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1v
bmx5DQo+ID4gKy8qDQo+ID4gKyAqIENvcHlyaWdodCAoYykgMjAyMSwgSGlTaWxpY29uIEx0ZC4N
Cj4gPiArICovDQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvZGV2aWNlLmg+DQo+ID4gKyNp
bmNsdWRlIDxsaW51eC9ldmVudGZkLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9maWxlLmg+DQo+
ID4gKyNpbmNsdWRlIDxsaW51eC9oaXNpX2FjY19xbS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgv
aW50ZXJydXB0Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiArI2luY2x1
ZGUgPGxpbnV4L3BjaS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvdmZpby5oPg0KPiA+ICsjaW5j
bHVkZSA8bGludXgvdmZpb19wY2lfY29yZS5oPg0KPiA+ICsNCj4gPiArc3RhdGljIGludCBoaXNp
X2FjY192ZmlvX3BjaV9vcGVuX2RldmljZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmNvcmVfdmRldikN
Cj4gPiArew0KPiA+ICsJc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2ID0NCj4gPiAr
CQljb250YWluZXJfb2YoY29yZV92ZGV2LCBzdHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UsIHZk
ZXYpOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlyZXQgPSB2ZmlvX3BjaV9jb3JlX2Vu
YWJsZSh2ZGV2KTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+
ID4gKwl2ZmlvX3BjaV9jb3JlX2ZpbmlzaF9lbmFibGUodmRldik7DQo+IA0KPiAuLi4gdGhlcmUg
ZG9lcyBub3Qgc2VlbSB0byBiZSBhIHN0dWIgZm9yIHZmaW9fcGNpX2NvcmVfZmluaXNoX2VuYWJs
ZSgpLA0KPiBzbyBJIGRvbid0IHRoaW5rIHRoYXQgd2UgY29tcGlsZSB1bmRlciB0aGUgY29uZGl0
aW9ucyBkZXNjcmliZWQuIEkgdGhpbmsNCj4gdGhhdCBISVNJX0FDQ19WRklPX1BDSSBzaG91bGQg
YWx3YXlzIGRlcGVuZHMgb24gSElTSV9BQ0NfVkZJT19QQ0kNCj4gDQoNClRoYXQgbG9va3Mgcmln
aHQuIEkgZG8gcmVtZW1iZXIgcnVubmluZyBhIGNvbXBpbGUgdGVzdCB3aXRoIHg4Nl82NC4gTWF5
DQpiZSBWRklPX1BDSV9DT1JFIHdhcyBzb21laG93IHNlbGVjdGVkLg0KDQpJIHdpbGwgbWFrZSB0
aGUgImRlcGVuZHMgb24gVkZJT19QQ0lfQ09SRSIgY29tbW9uLg0KDQpUaGFua3MsDQpTaGFtZWVy
DQo=
