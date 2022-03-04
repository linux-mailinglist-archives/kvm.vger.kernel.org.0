Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91954CD381
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 12:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiCDLco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 06:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiCDLcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 06:32:42 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD17177D32;
        Fri,  4 Mar 2022 03:31:54 -0800 (PST)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K95KR0QsPz6GD5J;
        Fri,  4 Mar 2022 19:31:39 +0800 (CST)
Received: from lhreml719-chm.china.huawei.com (10.201.108.70) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 12:31:52 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 11:31:51 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Fri, 4 Mar 2022 11:31:51 +0000
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
Subject: RE: [PATCH v8 6/9] hisi_acc_vfio_pci: Add helper to retrieve the
 struct pci_driver
Thread-Topic: [PATCH v8 6/9] hisi_acc_vfio_pci: Add helper to retrieve the
 struct pci_driver
Thread-Index: AQHYL1LKWZjK0hk+c061mSNBOxZn8ayu+SGAgAAerGA=
Date:   Fri, 4 Mar 2022 11:31:51 +0000
Message-ID: <5a7e722a526f46f1818a3113c81fc352@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-7-shameerali.kolothum.thodi@huawei.com>
 <a7d41c01-9032-14a1-b16f-a4a6a954addf@hisilicon.com>
In-Reply-To: <a7d41c01-9032-14a1-b16f-a4a6a954addf@hisilicon.com>
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdhbmd6aG91IChCKQ0KPiBT
ZW50OiAwNCBNYXJjaCAyMDIyIDA5OjQxDQo+IFRvOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2Rp
IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1wY2lAdmdlci5rZXJuZWwub3JnOyBhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbTsgamdnQG52aWRpYS5jb207DQo+IGNvaHVja0ByZWRoYXQuY29tOyBt
Z3VydG92b3lAbnZpZGlhLmNvbTsgeWlzaGFpaEBudmlkaWEuY29tOyBMaW51eGFybQ0KPiA8bGlu
dXhhcm1AaHVhd2VpLmNvbT47IGxpdWxvbmdmYW5nIDxsaXVsb25nZmFuZ0BodWF3ZWkuY29tPjsg
WmVuZ3RhbyAoQikNCj4gPHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IEpvbmF0aGFuIENhbWVy
b24NCj4gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SCB2OCA2LzldIGhpc2lfYWNjX3ZmaW9fcGNpOiBBZGQgaGVscGVyIHRvIHJldHJpZXZlIHRoZSBz
dHJ1Y3QNCj4gcGNpX2RyaXZlcg0KPiANCj4gPiBzdHJ1Y3QgcGNpX2RyaXZlciBwb2ludGVyIGlz
IGFuIGlucHV0IGludG8gdGhlIHBjaV9pb3ZfZ2V0X3BmX2RydmRhdGEoKS4+DQo+IEludHJvZHVj
ZSBoZWxwZXJzIHRvIHJldHJpZXZlIHRoZSBBQ0MgUEYgZGV2IHN0cnVjdCBwY2lfZHJpdmVyIHBv
aW50ZXJzDQo+ID4gYXMgd2UgdXNlIHRoaXMgaW4gQUNDIHZmaW8gbWlncmF0aW9uIGRyaXZlci4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNoYW1lZXIgS29sb3RodW0NCj4gPHNoYW1lZXJhbGku
a29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gDQo+IEFja2VkLWJ5OiBaaG91IFdhbmcgPHdh
bmd6aG91MUBoaXNpbGljb24uY29tPg0KDQpUaGFua3MuDQoNClsrY2MgWmFpYm9dIGZvciBocHJl
L3NlYyBwYXJ0DQoNCj4gDQo+IEJlc3QsDQo+IFpob3UNCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZl
cnMvY3J5cHRvL2hpc2lsaWNvbi9ocHJlL2hwcmVfbWFpbi5jIHwgNiArKysrKysNCj4gPiAgZHJp
dmVycy9jcnlwdG8vaGlzaWxpY29uL3NlYzIvc2VjX21haW4uYyAgfCA2ICsrKysrKw0KPiA+ICBk
cml2ZXJzL2NyeXB0by9oaXNpbGljb24vemlwL3ppcF9tYWluLmMgICB8IDYgKysrKysrDQo+ID4g
IGluY2x1ZGUvbGludXgvaGlzaV9hY2NfcW0uaCAgICAgICAgICAgICAgIHwgNSArKysrKw0KPiA+
ICA0IGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vaHByZS9ocHJlX21haW4uYw0KPiBiL2RyaXZlcnMv
Y3J5cHRvL2hpc2lsaWNvbi9ocHJlL2hwcmVfbWFpbi5jDQo+ID4gaW5kZXggMzU4OWQ4ODc5YjVl
Li4zNmFiMzBlOWU2NTQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29u
L2hwcmUvaHByZV9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9oaXNpbGljb24vaHBy
ZS9ocHJlX21haW4uYw0KPiA+IEBAIC0xMTkwLDYgKzExOTAsMTIgQEAgc3RhdGljIHN0cnVjdCBw
Y2lfZHJpdmVyIGhwcmVfcGNpX2RyaXZlciA9IHsNCj4gPiAgCS5kcml2ZXIucG0JCT0gJmhwcmVf
cG1fb3BzLA0KPiA+ICB9Ow0KPiA+DQo+ID4gK3N0cnVjdCBwY2lfZHJpdmVyICpoaXNpX2hwcmVf
Z2V0X3BmX2RyaXZlcih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gJmhwcmVfcGNpX2RyaXZl
cjsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChoaXNpX2hwcmVfZ2V0X3BmX2RyaXZl
cik7DQo+ID4gKw0KPiA+ICBzdGF0aWMgdm9pZCBocHJlX3JlZ2lzdGVyX2RlYnVnZnModm9pZCkN
Cj4gPiAgew0KPiA+ICAJaWYgKCFkZWJ1Z2ZzX2luaXRpYWxpemVkKCkpDQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9zZWMyL3NlY19tYWluLmMNCj4gYi9kcml2ZXJz
L2NyeXB0by9oaXNpbGljb24vc2VjMi9zZWNfbWFpbi5jDQo+ID4gaW5kZXggMzExYTg3NDdiNWJm
Li40MjFhNDA1Y2EzMzcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaGlzaWxpY29u
L3NlYzIvc2VjX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9zZWMy
L3NlY19tYWluLmMNCj4gPiBAQCAtMTA4OCw2ICsxMDg4LDEyIEBAIHN0YXRpYyBzdHJ1Y3QgcGNp
X2RyaXZlciBzZWNfcGNpX2RyaXZlciA9IHsNCj4gPiAgCS5kcml2ZXIucG0gPSAmc2VjX3BtX29w
cywNCj4gPiAgfTsNCj4gPg0KPiA+ICtzdHJ1Y3QgcGNpX2RyaXZlciAqaGlzaV9zZWNfZ2V0X3Bm
X2RyaXZlcih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gJnNlY19wY2lfZHJpdmVyOw0KPiA+
ICt9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKGhpc2lfc2VjX2dldF9wZl9kcml2ZXIpOw0KPiA+
ICsNCj4gPiAgc3RhdGljIHZvaWQgc2VjX3JlZ2lzdGVyX2RlYnVnZnModm9pZCkNCj4gPiAgew0K
PiA+ICAJaWYgKCFkZWJ1Z2ZzX2luaXRpYWxpemVkKCkpDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY3J5cHRvL2hpc2lsaWNvbi96aXAvemlwX21haW4uYw0KPiBiL2RyaXZlcnMvY3J5cHRvL2hp
c2lsaWNvbi96aXAvemlwX21haW4uYw0KPiA+IGluZGV4IDY2ZGVjZmUwNzI4Mi4uNDUzNGUxZTEw
N2QxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi96aXAvemlwX21h
aW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi96aXAvemlwX21haW4uYw0K
PiA+IEBAIC0xMDEyLDYgKzEwMTIsMTIgQEAgc3RhdGljIHN0cnVjdCBwY2lfZHJpdmVyIGhpc2lf
emlwX3BjaV9kcml2ZXIgPSB7DQo+ID4gIAkuZHJpdmVyLnBtCQk9ICZoaXNpX3ppcF9wbV9vcHMs
DQo+ID4gIH07DQo+ID4NCj4gPiArc3RydWN0IHBjaV9kcml2ZXIgKmhpc2lfemlwX2dldF9wZl9k
cml2ZXIodm9pZCkNCj4gPiArew0KPiA+ICsJcmV0dXJuICZoaXNpX3ppcF9wY2lfZHJpdmVyOw0K
PiA+ICt9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKGhpc2lfemlwX2dldF9wZl9kcml2ZXIpOw0K
PiA+ICsNCj4gPiAgc3RhdGljIHZvaWQgaGlzaV96aXBfcmVnaXN0ZXJfZGVidWdmcyh2b2lkKQ0K
PiA+ICB7DQo+ID4gIAlpZiAoIWRlYnVnZnNfaW5pdGlhbGl6ZWQoKSkNCj4gPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9oaXNpX2FjY19xbS5oIGIvaW5jbHVkZS9saW51eC9oaXNpX2FjY19x
bS5oDQo+ID4gaW5kZXggNmE2NDc3YzM0NjY2Li4wMGYyYTRkYjg3MjMgMTAwNjQ0DQo+ID4gLS0t
IGEvaW5jbHVkZS9saW51eC9oaXNpX2FjY19xbS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9o
aXNpX2FjY19xbS5oDQo+ID4gQEAgLTQ3Niw0ICs0NzYsOSBAQCB2b2lkIGhpc2lfcW1fcG1faW5p
dChzdHJ1Y3QgaGlzaV9xbSAqcW0pOw0KPiA+ICBpbnQgaGlzaV9xbV9nZXRfZGZ4X2FjY2Vzcyhz
dHJ1Y3QgaGlzaV9xbSAqcW0pOw0KPiA+ICB2b2lkIGhpc2lfcW1fcHV0X2RmeF9hY2Nlc3Moc3Ry
dWN0IGhpc2lfcW0gKnFtKTsNCj4gPiAgdm9pZCBoaXNpX3FtX3JlZ3NfZHVtcChzdHJ1Y3Qgc2Vx
X2ZpbGUgKnMsIHN0cnVjdCBkZWJ1Z2ZzX3JlZ3NldDMyDQo+ICpyZWdzZXQpOw0KPiA+ICsNCj4g
PiArLyogVXNlZCBieSBWRklPIEFDQyBsaXZlIG1pZ3JhdGlvbiBkcml2ZXIgKi8NCj4gPiArc3Ry
dWN0IHBjaV9kcml2ZXIgKmhpc2lfc2VjX2dldF9wZl9kcml2ZXIodm9pZCk7DQo+ID4gK3N0cnVj
dCBwY2lfZHJpdmVyICpoaXNpX2hwcmVfZ2V0X3BmX2RyaXZlcih2b2lkKTsNCj4gPiArc3RydWN0
IHBjaV9kcml2ZXIgKmhpc2lfemlwX2dldF9wZl9kcml2ZXIodm9pZCk7DQo+ID4gICNlbmRpZg0K
PiA+DQo=
