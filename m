Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815E24D12E3
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245129AbiCHIxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiCHIx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:53:29 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6BADF9E;
        Tue,  8 Mar 2022 00:52:33 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KCTZJ5hGSz6F93y;
        Tue,  8 Mar 2022 16:51:04 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:52:31 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 08:52:30 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Tue, 8 Mar 2022 08:52:30 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1LUtVDDY2S/e06nk5NDxfriXKy1IT6AgAASKKA=
Date:   Tue, 8 Mar 2022 08:52:30 +0000
Message-ID: <50b0d11d57d3488da809f318576466cd@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB527661103A2CFE13E4F3EC528C099@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527661103A2CFE13E4F3EC528C099@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.27.151]
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGlhbiwgS2V2aW4gW21h
aWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gU2VudDogMDggTWFyY2ggMjAyMiAwNzo0Mg0K
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgt
cGNpQHZnZXIua2VybmVsLm9yZzsgYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IGpnZ0Budmlk
aWEuY29tOw0KPiBjb2h1Y2tAcmVkaGF0LmNvbTsgbWd1cnRvdm95QG52aWRpYS5jb207IHlpc2hh
aWhAbnZpZGlhLmNvbTsgTGludXhhcm0NCj4gPGxpbnV4YXJtQGh1YXdlaS5jb20+OyBsaXVsb25n
ZmFuZyA8bGl1bG9uZ2ZhbmdAaHVhd2VpLmNvbT47IFplbmd0YW8gKEIpDQo+IDxwcmltZS56ZW5n
QGhpc2lsaWNvbi5jb20+OyBKb25hdGhhbiBDYW1lcm9uDQo+IDxqb25hdGhhbi5jYW1lcm9uQGh1
YXdlaS5jb20+OyBXYW5nemhvdSAoQikgPHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiBTdWJq
ZWN0OiBSRTogW1BBVENIIHY4IDgvOV0gaGlzaV9hY2NfdmZpb19wY2k6IEFkZCBzdXBwb3J0IGZv
ciBWRklPIGxpdmUNCj4gbWlncmF0aW9uDQo+IA0KPiA+IEZyb206IFNoYW1lZXIgS29sb3RodW0g
PHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiBTZW50OiBGcmlkYXks
IE1hcmNoIDQsIDIwMjIgNzowMiBBTQ0KPiA+ICsvKg0KPiA+ICsgKiBFYWNoIHN0YXRlIFJlZyBp
cyBjaGVja2VkIDEwMCB0aW1lcywNCj4gPiArICogd2l0aCBhIGRlbGF5IG9mIDEwMCBtaWNyb3Nl
Y29uZHMgYWZ0ZXIgZWFjaCBjaGVjayAgKi8gc3RhdGljIHUzMg0KPiA+ICthY2NfY2hlY2tfcmVn
X3N0YXRlKHN0cnVjdCBoaXNpX3FtICpxbSwgdTMyIHJlZ3MpDQo+IA0KPiBxbV9jaGVja19yZWdf
c3RhdGUoKSBnaXZlbiB0aGUgMXN0IGFyZ3VtZW50IGlzIHFtDQo+IA0KPiA+ICsvKiBDaGVjayB0
aGUgUEYncyBSQVMgc3RhdGUgYW5kIEZ1bmN0aW9uIElOVCBzdGF0ZSAqLyBzdGF0aWMgaW50DQo+
ID4gK3FtX2NoZWNrX2ludF9zdGF0ZShzdHJ1Y3QgaGlzaV9hY2NfdmZfY29yZV9kZXZpY2UgKmhp
c2lfYWNjX3ZkZXYpDQo+IA0KPiB0aGVuIHRoaXMgc2hvdWxkIGJlIGFjY19jaGVja19pbnRfc3Rh
dGUoKSBnaXZlbiB0aGUgaW5wdXQgaXMgYW4gYWNjIGRldmljZT8NCj4gDQo+IGFueXdheSBwbGVh
c2UgaGF2ZSBhIGNvbnNpc3RlbnQgbmFtaW5nIGNvbnZlbnRpb24gaGVyZS4NCj4gDQo+ID4gK3N0
YXRpYyBpbnQgcW1fcmVhZF9yZWcoc3RydWN0IGhpc2lfcW0gKnFtLCB1MzIgcmVnX2FkZHIsDQo+
ID4gKwkJICAgICAgIHUzMiAqZGF0YSwgdTggbnVtcykNCj4gDQo+IHFtX3JlYWRfcmVncygpIHRv
IHJlZmxlY3QgdGhhdCBtdWx0aXBsZSByZWdpc3RlcnMgYXJlIHByb2Nlc3NlZC4NCj4gDQo+ID4g
Kw0KPiA+ICtzdGF0aWMgaW50IHFtX3dyaXRlX3JlZyhzdHJ1Y3QgaGlzaV9xbSAqcW0sIHUzMiBy
ZWcsDQo+ID4gKwkJCXUzMiAqZGF0YSwgdTggbnVtcykNCj4gDQo+IHFtX3dyaXRlX3JlZ3MoKQ0K
PiANCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgcW1fcndfcmVnc19yZWFkKHN0cnVjdCBoaXNpX3Ft
ICpxbSwgc3RydWN0IGFjY192Zl9kYXRhDQo+ID4gKyp2Zl9kYXRhKQ0KPiANCj4gcW1fbG9hZF9y
ZWdzKCkuIEl0J3MgY29uZnVzaW5nIHRvIGhhdmUgYm90aCAncncnIGFuZCAncmVhZCcuDQo+IA0K
PiA+ICsNCj4gPiArc3RhdGljIGludCBxbV9yd19yZWdzX3dyaXRlKHN0cnVjdCBoaXNpX3FtICpx
bSwgc3RydWN0IGFjY192Zl9kYXRhDQo+ID4gKnZmX2RhdGEpDQo+IA0KPiBxbV9zYXZlX3JlZ3Mo
KQ0KDQpSaWdodC4gSSBhbSBPayB3aXRoIHRoZSBhYm92ZSBzdWdnZXN0aW9ucy4NCg0KPiANCj4g
PiArc3RhdGljIGludCBoaXNpX2FjY192Zl9xbV9pbml0KHN0cnVjdCBoaXNpX2FjY192Zl9jb3Jl
X2RldmljZQ0KPiA+ICsqaGlzaV9hY2NfdmRldikgew0KPiA+ICsJc3RydWN0IHZmaW9fcGNpX2Nv
cmVfZGV2aWNlICp2ZGV2ID0gJmhpc2lfYWNjX3ZkZXYtPmNvcmVfZGV2aWNlOw0KPiA+ICsJc3Ry
dWN0IGhpc2lfcW0gKnZmX3FtID0gJmhpc2lfYWNjX3ZkZXYtPnZmX3FtOw0KPiA+ICsJc3RydWN0
IHBjaV9kZXYgKnZmX2RldiA9IHZkZXYtPnBkZXY7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAq
IEFDQyBWRiBkZXYgQkFSMiByZWdpb24gY29uc2lzdHMgb2YgYm90aCBmdW5jdGlvbmFsIHJlZ2lz
dGVyIHNwYWNlDQo+ID4gKwkgKiBhbmQgbWlncmF0aW9uIGNvbnRyb2wgcmVnaXN0ZXIgc3BhY2Uu
IEZvciBtaWdyYXRpb24gdG8gd29yaywgd2UNCj4gPiArCSAqIG5lZWQgYWNjZXNzIHRvIGJvdGgu
IEhlbmNlLCB3ZSBtYXAgdGhlIGVudGlyZSBCQVIyIHJlZ2lvbiBoZXJlLg0KPiA+ICsJICogQnV0
IGZyb20gYSBzZWN1cml0eSBwb2ludCBvZiB2aWV3LCB3ZSByZXN0cmljdCBhY2Nlc3MgdG8gdGhl
DQo+ID4gKwkgKiBtaWdyYXRpb24gY29udHJvbCBzcGFjZSBmcm9tIEd1ZXN0KFBsZWFzZSBzZWUN
Cj4gPiBtbWFwL2lvY3RsL3JlYWQvd3JpdGUNCj4gPiArCSAqIG92ZXJyaWRlIGZ1bmN0aW9ucyku
DQo+IA0KPiAoUGxlYXNlIHNlZSBoaXNpX2FjY192ZmlvX3BjaV9taWdybl9vcHMpDQo+IA0KPiA+
ICsJICoNCj4gPiArCSAqIEFsc28gdGhlIEhpU2lsaWNvbiBBQ0MgVkYgZGV2aWNlcyBzdXBwb3J0
ZWQgYnkgdGhpcyBkcml2ZXIgb24NCj4gPiArCSAqIEhpU2lsaWNvbiBoYXJkd2FyZSBwbGF0Zm9y
bXMgYXJlIGludGVncmF0ZWQgZW5kIHBvaW50IGRldmljZXMNCj4gPiArCSAqIGFuZCBoYXMgbm8g
Y2FwYWJpbGl0eSB0byBwZXJmb3JtIFBDSWUgUDJQLg0KPiANCj4gQWNjb3JkaW5nIHRvIHY1IGRp
c2N1c3Npb24gSSB0aGluayBpdCBpcyB0aGUgcGxhdGZvcm0gd2hpY2ggbGFja3Mgb2YgdGhlIFAy
UA0KPiBjYXBhYmlsaXR5IGluc3RlYWQgb2YgdGhlIGRldmljZS4gQ3VycmVudCB3cml0aW5nIGlz
IHJlYWQgdG8gdGhlIGxhdHRlci4NCj4gDQo+IGJldHRlciBjbGFyaWZ5IGl0IGFjY3VyYXRlbHku
IPCfmIoNCg0KVGhhdOKAmXMgcmlnaHQuIEl0IGlzIHRoZSBwbGF0Zm9ybS4NCg0KPiANCj4gPiAg
c3RhdGljIGludCBoaXNpX2FjY192ZmlvX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwg
Y29uc3Qgc3RydWN0DQo+ID4gcGNpX2RldmljZV9pZCAqaWQpICB7DQo+ID4gLQlzdHJ1Y3QgdmZp
b19wY2lfY29yZV9kZXZpY2UgKnZkZXY7DQo+ID4gKwlzdHJ1Y3QgaGlzaV9hY2NfdmZfY29yZV9k
ZXZpY2UgKmhpc2lfYWNjX3ZkZXY7DQo+ID4gKwlzdHJ1Y3QgaGlzaV9xbSAqcGZfcW07DQo+ID4g
IAlpbnQgcmV0Ow0KPiA+DQo+ID4gLQl2ZGV2ID0ga3phbGxvYyhzaXplb2YoKnZkZXYpLCBHRlBf
S0VSTkVMKTsNCj4gPiAtCWlmICghdmRldikNCj4gPiArCWhpc2lfYWNjX3ZkZXYgPSBremFsbG9j
KHNpemVvZigqaGlzaV9hY2NfdmRldiksIEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFoaXNpX2Fj
Y192ZGV2KQ0KPiA+ICAJCXJldHVybiAtRU5PTUVNOw0KPiA+DQo+ID4gLQl2ZmlvX3BjaV9jb3Jl
X2luaXRfZGV2aWNlKHZkZXYsIHBkZXYsICZoaXNpX2FjY192ZmlvX3BjaV9vcHMpOw0KPiA+ICsJ
cGZfcW0gPSBoaXNpX2FjY19nZXRfcGZfcW0ocGRldik7DQo+ID4gKwlpZiAocGZfcW0gJiYgcGZf
cW0tPnZlciA+PSBRTV9IV19WMykgew0KPiA+ICsJCXJldCA9IGhpc2lfYWNjX3ZmaW9fcGNpX21p
Z3JuX2luaXQoaGlzaV9hY2NfdmRldiwgcGRldiwNCj4gPiBwZl9xbSk7DQo+ID4gKwkJaWYgKCFy
ZXQpIHsNCj4gPiArCQkJdmZpb19wY2lfY29yZV9pbml0X2RldmljZSgmaGlzaV9hY2NfdmRldi0N
Cj4gPiA+Y29yZV9kZXZpY2UsIHBkZXYsDQo+ID4gKw0KPiA+ICZoaXNpX2FjY192ZmlvX3BjaV9t
aWdybl9vcHMpOw0KPiA+ICsJCX0gZWxzZSB7DQo+ID4gKwkJCXBjaV93YXJuKHBkZXYsICJtaWdy
YXRpb24gc3VwcG9ydCBmYWlsZWQsIGNvbnRpbnVlDQo+ID4gd2l0aCBnZW5lcmljIGludGVyZmFj
ZVxuIik7DQo+ID4gKwkJCXZmaW9fcGNpX2NvcmVfaW5pdF9kZXZpY2UoJmhpc2lfYWNjX3ZkZXYt
DQo+ID4gPmNvcmVfZGV2aWNlLCBwZGV2LA0KPiA+ICsJCQkJCQkgICZoaXNpX2FjY192ZmlvX3Bj
aV9vcHMpOw0KPiA+ICsJCX0NCj4gDQo+IFRoaXMgbG9naWMgbG9va3Mgd2VpcmQuIEVhcmxpZXIg
eW91IHN0YXRlIHRoYXQgdGhlIG1pZ3JhdGlvbiBjb250cm9sIHJlZ2lvbiBtdXN0DQo+IGJlIGhp
ZGRlbiBmcm9tIHRoZSB1c2Vyc3BhY2UgYXMgYSBzZWN1cml0eSByZXF1aXJlbWVudCwgYnV0IGFi
b3ZlIGxvZ2ljIHJlYWRzDQo+IGxpa2UgaWYgdGhlIGRyaXZlciBmYWlscyB0byBpbml0aWFsaXpl
IG1pZ3JhdGlvbiBzdXBwb3J0IHRoZW4gd2UganVzdCBmYWxsIGJhY2sgdG8gdGhlDQo+IGRlZmF1
bHQgb3BzIHdoaWNoIGdyYW50cyB0aGUgdXNlciB0aGUgZnVsbCBhY2Nlc3MgdG8gdGhlIGVudGly
ZSBNTUlPIGJhci4NCg0KQXMgSSBleHBsYWluZWQgcHJldmlvdXNseSB0aGUgcmlzayBvZiBleHBv
c2luZyBtaWdyYXRpb24gQkFSIGlzIG9ubHkgbGltaXRlZCB0byBtaWdyYXRpb24NCnVzZSBjYXNl
LiBTbyBpZiBmb3Igc29tZSByZWFzb24gd2UgY2FuJ3QgZ2V0IHRoZSBtaWdyYXRpb24gd29ya2lu
Zywgd2UgZGVmYXVsdCB0byB0aGUNCmdlbmVyaWMgdmZpby1wY2kgbGlrZSBiZWhhdmlvci4NCiAN
Cj4gDQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCXZmaW9fcGNpX2NvcmVfaW5pdF9kZXZpY2UoJmhp
c2lfYWNjX3ZkZXYtPmNvcmVfZGV2aWNlLCBwZGV2LA0KPiA+ICsJCQkJCSAgJmhpc2lfYWNjX3Zm
aW9fcGNpX29wcyk7DQo+ID4gKwl9DQo+IA0KPiBJZiB0aGUgaGFyZHdhcmUgaXRzZWxmIGRvZXNu
J3Qgc3VwcG9ydCB0aGUgbWlncmF0aW9uIGNhcGFiaWxpdHksIGNhbiB3ZSBqdXN0DQo+IG1vdmUg
aXQgb3V0IG9mIHRoZSBpZCB0YWJsZSBhbmQgbGV0IHZmaW8tcGNpIHRvIGRyaXZlIGl0Pw0KPiAN
CiBCdXQgdGhlIGFib3ZlIGlzIGp1c3QgbGlrZSB2ZmlvLXBjaSBkcml2aW5nIGl0LCByaWdodD8N
Cg0KVGhhbmtzLA0KU2hhbWVlcg0K
