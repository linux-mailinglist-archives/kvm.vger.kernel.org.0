Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E054CB011
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiCBUkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbiCBUkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:40:46 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22551D5F69;
        Wed,  2 Mar 2022 12:40:02 -0800 (PST)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K85Yk53XBz67xV0;
        Thu,  3 Mar 2022 04:38:50 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 21:40:00 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 20:39:59 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 2 Mar 2022 20:39:59 +0000
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
Subject: RE: [PATCH v7 01/10] crypto: hisilicon/qm: Move the QM header to
 include/linux
Thread-Topic: [PATCH v7 01/10] crypto: hisilicon/qm: Move the QM header to
 include/linux
Thread-Index: AQHYLlsiyjfcBSsT4ke9mXDxHCdeCqysb3oAgAAewzA=
Date:   Wed, 2 Mar 2022 20:39:59 +0000
Message-ID: <58f8a835cedb4707b0dcb758904712d3@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-2-shameerali.kolothum.thodi@huawei.com>
 <6e3bcece-1046-0c2f-78d8-21d5030a8d71@huawei.com>
In-Reply-To: <6e3bcece-1046-0c2f-78d8-21d5030a8d71@huawei.com>
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
ZW50OiAwMiBNYXJjaCAyMDIyIDE4OjQ4DQo+IFRvOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2Rp
IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1wY2lAdmdlci5rZXJuZWwub3JnOyBhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbTsgamdnQG52aWRpYS5jb207DQo+IGNvaHVja0ByZWRoYXQuY29tOyBt
Z3VydG92b3lAbnZpZGlhLmNvbTsgeWlzaGFpaEBudmlkaWEuY29tOyBMaW51eGFybQ0KPiA8bGlu
dXhhcm1AaHVhd2VpLmNvbT47IGxpdWxvbmdmYW5nIDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPjsg
WmVuZ3RhbyAoQikNCj4gPHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IEpvbmF0aGFuIENhbWVy
b24NCj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IFdhbmd6aG91IChCKSA8d2FuZ3po
b3UxQGhpc2lsaWNvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDEvMTBdIGNyeXB0
bzogaGlzaWxpY29uL3FtOiBNb3ZlIHRoZSBRTSBoZWFkZXIgdG8NCj4gaW5jbHVkZS9saW51eA0K
PiANCj4gT24gMDIvMDMvMjAyMiAxNzoyOCwgU2hhbWVlciBLb2xvdGh1bSB3cm90ZToNCj4gPiBT
aW5jZSB3ZSBhcmUgZ29pbmcgdG8gaW50cm9kdWNlIFZGSU8gUENJIEhpU2lsaWNvbiBBQ0MNCj4g
PiBkcml2ZXIgZm9yIGxpdmUgbWlncmF0aW9uIGluIHN1YnNlcXVlbnQgcGF0Y2hlcywgbW92ZQ0K
PiA+IHRoZSBBQ0MgUU0gaGVhZGVyIGZpbGUgdG8gYSBjb21tb24gaW5jbHVkZSBkaXIuDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTaGFtZWVyIEtvbG90aHVtDQo+IDxzaGFtZWVyYWxpLmtvbG90
aHVtLnRob2RpQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2NyeXB0by9oaXNp
bGljb24vaHByZS9ocHJlLmggICAgICAgICAgICAgICAgICAgICAgICAgfCAyICstDQo+ID4gICBk
cml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAyICstDQo+ID4gICBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2VjMi9zZWMuaCAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAyICstDQo+ID4gICBkcml2ZXJzL2NyeXB0by9oaXNpbGlj
b24vc2dsLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAyICstDQo+ID4gICBkcml2
ZXJzL2NyeXB0by9oaXNpbGljb24vemlwL3ppcC5oICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAyICstDQo+ID4gICBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uaCA9PiBpbmNsdWRlL2xp
bnV4L2hpc2lfYWNjX3FtLmggfCAwDQo+IA0KPiBpbmNsdWRlL2xpbnV4L2NyeXB0byBzZWVtcyBh
IGJldHRlciBsb2NhdGlvbi4gSSdtIG5vdCBzdXJlIGlmIHNvbWVvbmUNCj4gc3VnZ2VzdGVkIGEg
bG9jYXRpb24gYWxyZWFkeSwgdGhvdWdoLg0KDQpIbW0uLi5Ob3Qgc3VyZSB3ZSBuZWVkIHRvIGNy
ZWF0ZSAiY3J5cHRvIiBqdXN0IGZvciB0aGlzIG9uZS4NCj4gDQo+ID4gICA2IGZpbGVzIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiAgIHJlbmFtZSBkcml2ZXJz
L2NyeXB0by9oaXNpbGljb24vcW0uaCA9PiBpbmNsdWRlL2xpbnV4L2hpc2lfYWNjX3FtLmgNCj4g
KDEwMCUpDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL2hw
cmUvaHByZS5oDQo+IGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHByZS5oDQo+ID4g
aW5kZXggZTBiNGExOTgyZWU5Li45YTA1NThlZDgyZjkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHByZS5oDQo+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8v
aGlzaWxpY29uL2hwcmUvaHByZS5oDQo+ID4gQEAgLTQsNyArNCw3IEBADQo+ID4gICAjZGVmaW5l
IF9fSElTSV9IUFJFX0gNCj4gPg0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCj4gPiAt
I2luY2x1ZGUgIi4uL3FtLmgiDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9oaXNpX2FjY19xbS5oPg0K
PiA+DQo+ID4gICAjZGVmaW5lIEhQUkVfU1FFX1NJWkUJCQlzaXplb2Yoc3RydWN0IGhwcmVfc3Fl
KQ0KPiA+ICAgI2RlZmluZSBIUFJFX1BGX0RFRl9RX05VTQkJNjQNCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3FtLmMgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24v
cW0uYw0KPiA+IGluZGV4IGM1Yjg0YTVlYTM1MC4uZWQyM2UxZDNmYTI3IDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9xbS5jDQo+ID4gKysrIGIvZHJpdmVycy9jcnlw
dG8vaGlzaWxpY29uL3FtLmMNCj4gPiBAQCAtMTUsNyArMTUsNyBAQA0KPiA+ICAgI2luY2x1ZGUg
PGxpbnV4L3VhY2NlLmg+DQo+ID4gICAjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPg0KPiA+ICAg
I2luY2x1ZGUgPHVhcGkvbWlzYy91YWNjZS9oaXNpX3FtLmg+DQo+ID4gLSNpbmNsdWRlICJxbS5o
Ig0KPiA+ICsjaW5jbHVkZSA8bGludXgvaGlzaV9hY2NfcW0uaD4NCj4gPg0KPiA+ICAgLyogZXEv
YWVxIGlycSBlbmFibGUgKi8NCj4gPiAgICNkZWZpbmUgUU1fVkZfQUVRX0lOVF9TT1VSQ0UJCTB4
MA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2VjMi9zZWMuaA0K
PiBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9zZWMyL3NlYy5oDQo+ID4gaW5kZXggZDk3Y2Yw
MmIxZGY3Li5jMmU5YjAxMTg3YTcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL3NlYzIvc2VjLmgNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2Vj
Mi9zZWMuaA0KPiA+IEBAIC00LDcgKzQsNyBAQA0KPiA+ICAgI2lmbmRlZiBfX0hJU0lfU0VDX1Yy
X0gNCj4gPiAgICNkZWZpbmUgX19ISVNJX1NFQ19WMl9IDQo+ID4NCj4gPiAtI2luY2x1ZGUgIi4u
L3FtLmgiDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9oaXNpX2FjY19xbS5oPg0KPiA+ICAgI2luY2x1
ZGUgInNlY19jcnlwdG8uaCINCj4gPg0KPiA+ICAgLyogQWxnb3JpdGhtIHJlc291cmNlIHBlciBo
YXJkd2FyZSBTRUMgcXVldWUgKi8NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL3NnbC5jIGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3NnbC5jDQo+ID4gaW5kZXgg
MDU3MjczNzY5ZjI2Li41MzQ2ODc0MDExMzUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlw
dG8vaGlzaWxpY29uL3NnbC5jDQo+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3Nn
bC5jDQo+ID4gQEAgLTMsNyArMyw3IEBADQo+ID4gICAjaW5jbHVkZSA8bGludXgvZG1hLW1hcHBp
bmcuaD4NCj4gPiAgICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiAgICNpbmNsdWRlIDxs
aW51eC9zbGFiLmg+DQo+ID4gLSNpbmNsdWRlICJxbS5oIg0KPiA+ICsjaW5jbHVkZSA8bGludXgv
aGlzaV9hY2NfcW0uaD4NCj4gDQo+IGFscGhhYmV0aWMgb3JkZXJpbmcgKGlnbm9yaW5nIHByZXZp
b3VzIHBvaW50KT8NCg0KU3VyZS4NCg0KVGhhbmtzLA0KU2hhbWVlcg0KPiA+DQo+ID4gICAjZGVm
aW5lIEhJU0lfQUNDX1NHTF9TR0VfTlJfTUlOCQkxDQo+ID4gICAjZGVmaW5lIEhJU0lfQUNDX1NH
TF9OUl9NQVgJCTI1Ng0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24v
emlwL3ppcC5oDQo+IGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3ppcC96aXAuaA0KPiA+IGlu
ZGV4IDUxN2ZkYmRmZjNlYS4uM2RmZDNiYWM1YTMzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL2hpc2lsaWNvbi96aXAvemlwLmgNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNp
bGljb24vemlwL3ppcC5oDQo+ID4gQEAgLTcsNyArNyw3IEBADQo+ID4gICAjZGVmaW5lIHByX2Zt
dChmbXQpCSJoaXNpX3ppcDogIiBmbXQNCj4gPg0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L2xpc3Qu
aD4NCj4gPiAtI2luY2x1ZGUgIi4uL3FtLmgiDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9oaXNpX2Fj
Y19xbS5oPg0KPiA+DQo+ID4gICBlbnVtIGhpc2lfemlwX2Vycm9yX3R5cGUgew0KPiA+ICAgCS8q
IG5lZ2F0aXZlIGNvbXByZXNzaW9uICovDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRv
L2hpc2lsaWNvbi9xbS5oIGIvaW5jbHVkZS9saW51eC9oaXNpX2FjY19xbS5oDQo+ID4gc2ltaWxh
cml0eSBpbmRleCAxMDAlDQo+ID4gcmVuYW1lIGZyb20gZHJpdmVycy9jcnlwdG8vaGlzaWxpY29u
L3FtLmgNCj4gPiByZW5hbWUgdG8gaW5jbHVkZS9saW51eC9oaXNpX2FjY19xbS5oDQoNCg==
