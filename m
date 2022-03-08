Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1614E4D1294
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345077AbiCHIrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiCHIrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:47:17 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12953EB99;
        Tue,  8 Mar 2022 00:46:20 -0800 (PST)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KCTSK616vz67wM9;
        Tue,  8 Mar 2022 16:45:53 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:46:18 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 08:46:18 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Tue, 8 Mar 2022 08:46:17 +0000
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
Subject: RE: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state register
Thread-Topic: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state
 register
Thread-Index: AQHYL1LPlUMwjDEdUEiD24VoqGSdyqy1DYoAgAAji+A=
Date:   Tue, 8 Mar 2022 08:46:17 +0000
Message-ID: <fe8dbea8868f46f0ad9699f6a12c1e63@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5276D3F8869BEAB2CBB16B498C099@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276D3F8869BEAB2CBB16B498C099@BN9PR11MB5276.namprd11.prod.outlook.com>
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
aWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gU2VudDogMDggTWFyY2ggMjAyMiAwNjozMQ0K
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgt
cGNpQHZnZXIua2VybmVsLm9yZzsgYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IGpnZ0Budmlk
aWEuY29tOw0KPiBjb2h1Y2tAcmVkaGF0LmNvbTsgbWd1cnRvdm95QG52aWRpYS5jb207IHlpc2hh
aWhAbnZpZGlhLmNvbTsgTGludXhhcm0NCj4gPGxpbnV4YXJtQGh1YXdlaS5jb20+OyBsaXVsb25n
ZmFuZyA8bGl1bG9uZ2ZhbmdAaHVhd2VpLmNvbT47IFplbmd0YW8gKEIpDQo+IDxwcmltZS56ZW5n
QGhpc2lsaWNvbi5jb20+OyBKb25hdGhhbiBDYW1lcm9uDQo+IDxqb25hdGhhbi5jYW1lcm9uQGh1
YXdlaS5jb20+OyBXYW5nemhvdSAoQikgPHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiBTdWJq
ZWN0OiBSRTogW1BBVENIIHY4IDcvOV0gY3J5cHRvOiBoaXNpbGljb24vcW06IFNldCB0aGUgVkYg
UU0gc3RhdGUgcmVnaXN0ZXINCj4gDQo+ID4gRnJvbTogU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+IFNlbnQ6IEZyaWRheSwgTWFyY2gg
NCwgMjAyMiA3OjAxIEFNDQo+ID4NCj4gPiBGcm9tOiBMb25nZmFuZyBMaXUgPGxpdWxvbmdmYW5n
QGh1YXdlaS5jb20+DQo+ID4NCj4gPiBXZSB1c2UgVkYgUU0gc3RhdGUgcmVnaXN0ZXIgdG8gcmVj
b3JkIHRoZSBzdGF0dXMgb2YgdGhlIFFNIGNvbmZpZ3VyYXRpb24NCj4gPiBzdGF0ZS4gVGhpcyB3
aWxsIGJlIHVzZWQgaW4gdGhlIEFDQyBtaWdyYXRpb24gZHJpdmVyIHRvIGRldGVybWluZSB3aGV0
aGVyDQo+ID4gd2UgY2FuIHNhZmVseSBzYXZlIGFuZCByZXN0b3JlIHRoZSBRTSBkYXRhLg0KPiAN
Cj4gQ2FuIHlvdSBzYXkgc29tZXRoaW5nIGFib3V0IHdoYXQgUU0gaXMgYW5kIGhvdyBpdCBpcyBy
ZWxhdGVkIHRvIHRoZSBWRiBzdGF0ZQ0KPiB0byBiZSBtaWdyYXRlZD8gSXQgbWlnaHQgYmUgb2J2
aW91cyB0byBhY2MgZHJpdmVyIHBlb3BsZSBidXQgbm90IHNvIHRvIHRvDQo+IG90aGVycyBpbiB2
ZmlvIGNvbW11bml0eSBsaWtlIG1lLiDwn5iKDQoNCk9rLCB1bmRlcnN0YW5kIHRoYXQuIEkgd2ls
bCBsaWZ0IGEgZGVzY3JpcHRpb24gZnJvbSB0aGUgUU0gZHJpdmVyIHBhdGNoIDopLg0KDQpRTSBz
dGFuZHMgZm9yIFF1ZXVlIE1hbmFnZW1lbnQgd2hpY2ggaXMgYSBnZW5lcmljIElQIHVzZWQgYnkg
QUNDIGRldmljZXMuDQpJdCBwcm92aWRlcyBhIGdlbmVyYWwgUENJZSBpbnRlcmZhY2UgZm9yIHRo
ZSBDUFUgYW5kIHRoZSBBQ0MgZGV2aWNlcyB0byBzaGFyZQ0KYSBncm91cCBvZiBxdWV1ZXMuDQoN
ClFNIGludGVncmF0ZWQgaW50byBhbiBhY2NlbGVyYXRvciBwcm92aWRlcyBxdWV1ZSBtYW5hZ2Vt
ZW50IHNlcnZpY2UuDQpRdWV1ZXMgY2FuIGJlIGFzc2lnbmVkIHRvIFBGIGFuZCBWRnMsIGFuZCBx
dWV1ZXMgY2FuIGJlIGNvbnRyb2xsZWQgYnkNCnVuaWZpZWQgbWFpbGJveGVzIGFuZCBkb29yYmVs
bHMuIFRoZSBRTSBkcml2ZXIoZHJpdmVycy9jcnlwdG8vaGlzaWxpY29uL3FtLmMpDQpwcm92aWRl
cyBnZW5lcmljIGludGVyZmFjZXMgdG8gQUNDIGRyaXZlcnMgdG8gbWFuYWdlIHRoZSBRTS4NCg0K
SSB3aWxsIGFkZCBzb21lIG9mIHRoaXMgaW4gZWl0aGVyIHRoaXMgY29tbWl0IG1zZyBvciBpbiB0
aGUgYWN0dWFsIGZpbGUgc29tZXdoZXJlLg0KDQpUaGFua3MsDQpTaGFtZWVyDQo=
