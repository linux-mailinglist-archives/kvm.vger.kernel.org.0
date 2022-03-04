Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C601F4CD38B
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 12:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbiCDLel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 06:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCDLek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 06:34:40 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548AD156792;
        Fri,  4 Mar 2022 03:33:52 -0800 (PST)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K95Mh5qZHz6GD45;
        Fri,  4 Mar 2022 19:33:36 +0800 (CST)
Received: from lhreml712-chm.china.huawei.com (10.201.108.63) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 12:33:50 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml712-chm.china.huawei.com (10.201.108.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 11:33:49 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Fri, 4 Mar 2022 11:33:49 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Xu Zaibo <xuzaibo@huawei.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>
Subject: RE: [PATCH v8 1/9] crypto: hisilicon/qm: Move the QM header to
 include/linux
Thread-Topic: [PATCH v8 1/9] crypto: hisilicon/qm: Move the QM header to
 include/linux
Thread-Index: AQHYL1KvdvvmfOQ8/EWXRA8Gmnu5YKyu7r4AgAApqoA=
Date:   Fri, 4 Mar 2022 11:33:49 +0000
Message-ID: <f903b932c4d1431ea0b478330a6ffc76@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-2-shameerali.kolothum.thodi@huawei.com>
 <e819f99e-ddc6-018a-3a8a-53804b7f58f1@hisilicon.com>
In-Reply-To: <e819f99e-ddc6-018a-3a8a-53804b7f58f1@hisilicon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.88.247]
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

WysgWmFpYm9dDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogV2FuZ3po
b3UgKEIpDQo+IFNlbnQ6IDA0IE1hcmNoIDIwMjIgMDk6MDMNCj4gVG86IFNoYW1lZXJhbGkgS29s
b3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47DQo+IGt2
bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4
LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7
IGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tOyBqZ2dAbnZpZGlhLmNvbTsNCj4gY29odWNrQHJl
ZGhhdC5jb207IG1ndXJ0b3ZveUBudmlkaWEuY29tOyB5aXNoYWloQG52aWRpYS5jb207IExpbnV4
YXJtDQo+IDxsaW51eGFybUBodWF3ZWkuY29tPjsgbGl1bG9uZ2ZhbmcgPGxpdWxvbmdmYW5nQGh1
YXdlaS5jb20+OyBaZW5ndGFvIChCKQ0KPiA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsgSm9u
YXRoYW4gQ2FtZXJvbg0KPiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHY4IDEvOV0gY3J5cHRvOiBoaXNpbGljb24vcW06IE1vdmUgdGhlIFFNIGhl
YWRlciB0bw0KPiBpbmNsdWRlL2xpbnV4DQo+IA0KPiA+IFNpbmNlIHdlIGFyZSBnb2luZyB0byBp
bnRyb2R1Y2UgVkZJTyBQQ0kgSGlTaWxpY29uIEFDQyBkcml2ZXIgZm9yIGxpdmUNCj4gPiBtaWdy
YXRpb24gaW4gc3Vic2VxdWVudCBwYXRjaGVzLCBtb3ZlIHRoZSBBQ0MgUU0gaGVhZGVyIGZpbGUg
dG8gYQ0KPiA+IGNvbW1vbiBpbmNsdWRlIGRpci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNo
YW1lZXIgS29sb3RodW0NCj4gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4N
Cj4gDQo+IEhpIFNoYW1lZXIsDQo+IA0KPiBJdCBsb29rcyBnb29kIHRvIG1lIGZvciB0aGlzIG1v
dmVtZW50Lg0KPiANCj4gQWNrZWQtYnk6IFpob3UgV2FuZyA8d2FuZ3pob3UxQGhpc2lsaWNvbi5j
b20+DQoNClRoYW5rcy4gWytjYyBaYWlib10gZm9yIGhwcmUvc2VjIHBhcnQuDQoNCg0KPiANCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHByZS5oICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgMiArLQ0KPiA+ICBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0u
YyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAyICstDQo+ID4gIGRyaXZlcnMvY3J5
cHRvL2hpc2lsaWNvbi9zZWMyL3NlYy5oICAgICAgICAgICAgICAgICAgICAgICAgICB8IDIgKy0N
Cj4gPiAgZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3NnbC5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMiArLQ0KPiA+ICBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vemlwL3ppcC5o
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAyICstDQo+ID4gIGRyaXZlcnMvY3J5cHRvL2hp
c2lsaWNvbi9xbS5oID0+IGluY2x1ZGUvbGludXgvaGlzaV9hY2NfcW0uaCB8IDANCj4gPiAgNiBm
aWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4gIHJlbmFt
ZSBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uaCA9PiBpbmNsdWRlL2xpbnV4L2hpc2lfYWNj
X3FtLmgNCj4gKDEwMCUpDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL2hwcmUvaHByZS5oDQo+IGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHBy
ZS5oDQo+ID4gaW5kZXggZTBiNGExOTgyZWU5Li45YTA1NThlZDgyZjkgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHByZS5oDQo+ID4gKysrIGIvZHJpdmVy
cy9jcnlwdG8vaGlzaWxpY29uL2hwcmUvaHByZS5oDQo+ID4gQEAgLTQsNyArNCw3IEBADQo+ID4g
ICNkZWZpbmUgX19ISVNJX0hQUkVfSA0KPiA+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9saXN0Lmg+
DQo+ID4gLSNpbmNsdWRlICIuLi9xbS5oIg0KPiA+ICsjaW5jbHVkZSA8bGludXgvaGlzaV9hY2Nf
cW0uaD4NCj4gPg0KPiA+ICAjZGVmaW5lIEhQUkVfU1FFX1NJWkUJCQlzaXplb2Yoc3RydWN0IGhw
cmVfc3FlKQ0KPiA+ICAjZGVmaW5lIEhQUkVfUEZfREVGX1FfTlVNCQk2NA0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0uYyBiL2RyaXZlcnMvY3J5cHRvL2hpc2ls
aWNvbi9xbS5jDQo+ID4gaW5kZXggYzViODRhNWVhMzUwLi5lZDIzZTFkM2ZhMjcgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3FtLmMNCj4gPiArKysgYi9kcml2ZXJz
L2NyeXB0by9oaXNpbGljb24vcW0uYw0KPiA+IEBAIC0xNSw3ICsxNSw3IEBADQo+ID4gICNpbmNs
dWRlIDxsaW51eC91YWNjZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPg0KPiA+
ICAjaW5jbHVkZSA8dWFwaS9taXNjL3VhY2NlL2hpc2lfcW0uaD4NCj4gPiAtI2luY2x1ZGUgInFt
LmgiDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9oaXNpX2FjY19xbS5oPg0KPiA+DQo+ID4gIC8qIGVx
L2FlcSBpcnEgZW5hYmxlICovDQo+ID4gICNkZWZpbmUgUU1fVkZfQUVRX0lOVF9TT1VSQ0UJCTB4
MA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2VjMi9zZWMuaA0K
PiBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9zZWMyL3NlYy5oDQo+ID4gaW5kZXggZDk3Y2Yw
MmIxZGY3Li5jMmU5YjAxMTg3YTcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL3NlYzIvc2VjLmgNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2Vj
Mi9zZWMuaA0KPiA+IEBAIC00LDcgKzQsNyBAQA0KPiA+ICAjaWZuZGVmIF9fSElTSV9TRUNfVjJf
SA0KPiA+ICAjZGVmaW5lIF9fSElTSV9TRUNfVjJfSA0KPiA+DQo+ID4gLSNpbmNsdWRlICIuLi9x
bS5oIg0KPiA+ICsjaW5jbHVkZSA8bGludXgvaGlzaV9hY2NfcW0uaD4NCj4gPiAgI2luY2x1ZGUg
InNlY19jcnlwdG8uaCINCj4gPg0KPiA+ICAvKiBBbGdvcml0aG0gcmVzb3VyY2UgcGVyIGhhcmR3
YXJlIFNFQyBxdWV1ZSAqLw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGlj
b24vc2dsLmMgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2dsLmMNCj4gPiBpbmRleCAwNTcy
NzM3NjlmMjYuLmY3ZWZjMDJiMDY1ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9o
aXNpbGljb24vc2dsLmMNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vc2dsLmMN
Cj4gPiBAQCAtMSw5ICsxLDkgQEANCj4gPiAgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjANCj4gPiAgLyogQ29weXJpZ2h0IChjKSAyMDE5IEhpU2lsaWNvbiBMaW1pdGVkLiAqLw0K
PiA+ICAjaW5jbHVkZSA8bGludXgvZG1hLW1hcHBpbmcuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4
L2hpc2lfYWNjX3FtLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiAgI2lu
Y2x1ZGUgPGxpbnV4L3NsYWIuaD4NCj4gPiAtI2luY2x1ZGUgInFtLmgiDQo+ID4NCj4gPiAgI2Rl
ZmluZSBISVNJX0FDQ19TR0xfU0dFX05SX01JTgkJMQ0KPiA+ICAjZGVmaW5lIEhJU0lfQUNDX1NH
TF9OUl9NQVgJCTI1Ng0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24v
emlwL3ppcC5oDQo+IGIvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3ppcC96aXAuaA0KPiA+IGlu
ZGV4IDUxN2ZkYmRmZjNlYS4uM2RmZDNiYWM1YTMzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL2hpc2lsaWNvbi96aXAvemlwLmgNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNp
bGljb24vemlwL3ppcC5oDQo+ID4gQEAgLTcsNyArNyw3IEBADQo+ID4gICNkZWZpbmUgcHJfZm10
KGZtdCkJImhpc2lfemlwOiAiIGZtdA0KPiA+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9saXN0Lmg+
DQo+ID4gLSNpbmNsdWRlICIuLi9xbS5oIg0KPiA+ICsjaW5jbHVkZSA8bGludXgvaGlzaV9hY2Nf
cW0uaD4NCj4gPg0KPiA+ICBlbnVtIGhpc2lfemlwX2Vycm9yX3R5cGUgew0KPiA+ICAJLyogbmVn
YXRpdmUgY29tcHJlc3Npb24gKi8NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaGlz
aWxpY29uL3FtLmggYi9pbmNsdWRlL2xpbnV4L2hpc2lfYWNjX3FtLmgNCj4gPiBzaW1pbGFyaXR5
IGluZGV4IDEwMCUNCj4gPiByZW5hbWUgZnJvbSBkcml2ZXJzL2NyeXB0by9oaXNpbGljb24vcW0u
aA0KPiA+IHJlbmFtZSB0byBpbmNsdWRlL2xpbnV4L2hpc2lfYWNjX3FtLmgNCj4gPg0K
