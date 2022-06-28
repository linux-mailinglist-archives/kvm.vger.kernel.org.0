Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C437555CEAA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbiF1IP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243814AbiF1IPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:15:37 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC2E2CE23
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:14:54 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXHQC67Flz6H7jC;
        Tue, 28 Jun 2022 16:12:35 +0800 (CST)
Received: from lhreml716-chm.china.huawei.com (10.201.108.67) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 10:14:52 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml716-chm.china.huawei.com (10.201.108.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 09:14:51 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Tue, 28 Jun 2022 09:14:51 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Yi Liu <yi.l.liu@intel.com>,
        "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0OTGNprklv2E6ANQZpjBJsW60CAlLggAATGICAABalMIAAOoCAgBRJ8gCAANfIgIAAO+qAgABf6QCAAAMMAIAAFykAgAGUvYCAAToMAIAH2gMAgAF4VACAAG9AgIBAHOOA
Date:   Tue, 28 Jun 2022 08:14:51 +0000
Message-ID: <c1ee978d787b4e43af4619fb4ef0bfc1@huawei.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <4f920d463ebf414caa96419b625632d5@huawei.com>
        <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
        <4ac4956cfe344326a805966535c1dc43@huawei.com>
        <20220426103507.5693a0ca.alex.williamson@redhat.com>
        <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
        <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
        <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
        <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
        <20220510124554.GY49344@nvidia.com>
        <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
        <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
        <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
        <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
        <tencent_C3C342C7F0605284FB368A1A63534B5A4806@qq.com>
 <24cb7ff5-dec8-3c84-b23e-4170d331a4d2@intel.com>
In-Reply-To: <24cb7ff5-dec8-3c84-b23e-4170d331a4d2@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWWkgTGl1IFttYWlsdG86
eWkubC5saXVAaW50ZWwuY29tXQ0KPiBTZW50OiAxOCBNYXkgMjAyMiAxNTowMQ0KPiBUbzogemhh
bmdmZWkuZ2FvQGZveG1haWwuY29tOyBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPjsN
Cj4gWmhhbmdmZWkgR2FvIDx6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZz4NCj4gQ2M6IGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbTsgQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNv
bT47DQo+IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29sb3RodW0udGhv
ZGlAaHVhd2VpLmNvbT47DQo+IGNvaHVja0ByZWRoYXQuY29tOyBxZW11LWRldmVsQG5vbmdudS5v
cmc7DQo+IGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdTsgdGh1dGhAcmVkaGF0LmNvbTsgZmFy
bWFuQGxpbnV4LmlibS5jb207DQo+IG1qcm9zYXRvQGxpbnV4LmlibS5jb207IGFrcm93aWFrQGxp
bnV4LmlibS5jb207IHBhc2ljQGxpbnV4LmlibS5jb207DQo+IGpqaGVybmVAbGludXguaWJtLmNv
bTsgamFzb3dhbmdAcmVkaGF0LmNvbTsga3ZtQHZnZXIua2VybmVsLm9yZzsNCj4gbmljb2xpbmNA
bnZpZGlhLmNvbTsgZXJpYy5hdWdlci5wcm9AZ21haWwuY29tOyBrZXZpbi50aWFuQGludGVsLmNv
bTsNCj4gY2hhby5wLnBlbmdAaW50ZWwuY29tOyB5aS55LnN1bkBpbnRlbC5jb207IHBldGVyeEBy
ZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDAwLzE4XSB2ZmlvOiBBZG9wdCBpb21tdWZk
DQo+IA0KPiBPbiAyMDIyLzUvMTggMTU6MjIsIHpoYW5nZmVpLmdhb0Bmb3htYWlsLmNvbSB3cm90
ZToNCj4gPg0KPiA+DQo+ID4gT24gMjAyMi81LzE3IOS4i+WNiDQ6NTUsIFlpIExpdSB3cm90ZToN
Cj4gPj4gSGkgWmhhbmdmZWksDQo+ID4+DQo+ID4+IE9uIDIwMjIvNS8xMiAxNzowMSwgemhhbmdm
ZWkuZ2FvQGZveG1haWwuY29tIHdyb3RlOg0KPiA+Pj4NCj4gPj4+IEhpLCBZaQ0KPiA+Pj4NCj4g
Pj4+IE9uIDIwMjIvNS8xMSDkuIvljYgxMDoxNywgemhhbmdmZWkuZ2FvQGZveG1haWwuY29tIHdy
b3RlOg0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+PiBPbiAyMDIyLzUvMTAg5LiL5Y2IMTA6MDgsIFlp
IExpdSB3cm90ZToNCj4gPj4+Pj4gT24gMjAyMi81LzEwIDIwOjQ1LCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6DQo+ID4+Pj4+PiBPbiBUdWUsIE1heSAxMCwgMjAyMiBhdCAwODozNTowMFBNICswODAw
LCBaaGFuZ2ZlaSBHYW8gd3JvdGU6DQo+ID4+Pj4+Pj4gVGhhbmtzIFlpIGFuZCBFcmljLA0KPiA+
Pj4+Pj4+IFRoZW4gd2lsbCB3YWl0IGZvciB0aGUgdXBkYXRlZCBpb21tdWZkIGtlcm5lbCBmb3Ig
dGhlIFBDSSBNTUlPDQo+IHJlZ2lvbi4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IEFub3RoZXIgcXVl
c3Rpb24sDQo+ID4+Pj4+Pj4gSG93IHRvIGdldCB0aGUgaW9tbXVfZG9tYWluIGluIHRoZSBpb2N0
bC4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBUaGUgSUQgb2YgdGhlIGlvbW11X2RvbWFpbiAoY2FsbGVk
IHRoZSBod3B0KSBpdCBzaG91bGQgYmUgcmV0dXJuZWQNCj4gYnkNCj4gPj4+Pj4+IHRoZSB2Zmlv
IGF0dGFjaCBpb2N0bC4NCj4gPj4+Pj4NCj4gPj4+Pj4geWVzLCBod3B0X2lkIGlzIHJldHVybmVk
IGJ5IHRoZSB2ZmlvIGF0dGFjaCBpb2N0bCBhbmQgcmVjb3JkZWQgaW4NCj4gPj4+Pj4gcWVtdS4g
WW91IGNhbiBxdWVyeSBwYWdlIHRhYmxlIHJlbGF0ZWQgY2FwYWJpbGl0aWVzIHdpdGggdGhpcyBp
ZC4NCj4gPj4+Pj4NCj4gPj4+Pj4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjIw
NDE0MTA0NzEwLjI4NTM0LTE2LXlpLmwubGl1QGludGVsLmNvbS8NCj4gPj4+Pj4NCj4gPj4+PiBU
aGFua3MgWWksDQo+ID4+Pj4NCj4gPj4+PiBEbyB3ZSB1c2UgaW9tbXVmZF9od19wYWdldGFibGVf
ZnJvbV9pZCBpbiBrZXJuZWw/DQo+ID4+Pj4NCj4gPj4+PiBUaGUgcWVtdSBzZW5kIGh3cHRfaWQg
dmlhIGlvY3RsLg0KPiA+Pj4+IEN1cnJlbnRseSBWRklPSU9NTVVGRENvbnRhaW5lciBoYXMgaHdw
dF9saXN0LA0KPiA+Pj4+IFdoaWNoIG1lbWJlciBpcyBnb29kIHRvIHNhdmUgaHdwdF9pZCwgSU9N
TVVUTEJFbnRyeT8NCj4gPj4+DQo+ID4+PiBDYW4gVkZJT0lPTU1VRkRDb250YWluZXLCoCBoYXZl
IG11bHRpIGh3cHQ/DQo+ID4+DQo+ID4+IHllcywgaXQgaXMgcG9zc2libGUNCj4gPiBUaGVuIGhv
dyB0byBnZXQgaHdwdF9pZCBpbiBtYXAvdW5tYXBfbm90aWZ5KElPTU1VTm90aWZpZXIgKm4sDQo+
IElPTU1VVExCRW50cnkNCj4gPiAqaW90bGIpDQo+IA0KPiBpbiBtYXAvdW5tYXAsIHNob3VsZCB1
c2UgaW9hc19pZCBpbnN0ZWFkIG9mIGh3cHRfaWQNCj4gDQo+ID4NCj4gPj4NCj4gPj4+IFNpbmNl
IFZGSU9JT01NVUZEQ29udGFpbmVyIGhhcyBod3B0X2xpc3Qgbm93Lg0KPiA+Pj4gSWYgc28sIGhv
dyB0byBnZXQgc3BlY2lmaWMgaHdwdCBmcm9tIG1hcC91bm1hcF9ub3RpZnkgaW4gaHcvdmZpby9h
cy5jLA0KPiA+Pj4gd2hlcmUgbm8gdmJhc2VkZXYgY2FuIGJlIHVzZWQgZm9yIGNvbXBhcmUuDQo+
ID4+Pg0KPiA+Pj4gSSBhbSB0ZXN0aW5nIHdpdGggYSB3b3JrYXJvdW5kLCBhZGRpbmcgVkZJT0lP
QVNId3B0ICpod3B0IGluDQo+ID4+PiBWRklPSU9NTVVGRENvbnRhaW5lci4NCj4gPj4+IEFuZCBz
YXZlIGh3cHQgd2hlbiB2ZmlvX2RldmljZV9hdHRhY2hfY29udGFpbmVyLg0KPiA+Pj4NCj4gPj4+
Pg0KPiA+Pj4+IEluIGtlcm5lbCBpb2N0bDogaW9tbXVmZF92ZmlvX2lvY3RsDQo+ID4+Pj4gQGRl
djogRGV2aWNlIHRvIGdldCBhbiBpb21tdV9kb21haW4gZm9yDQo+ID4+Pj4gaW9tbXVmZF9od19w
YWdldGFibGVfZnJvbV9pZChzdHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgsIHUzMiBwdF9pZCwNCj4g
Pj4+PiBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4+Pj4gQnV0IGlvbW11ZmRfdmZpb19pb2N0bCBz
ZWVtcyBubyBwYXJhIGRldj8NCj4gPj4+DQo+ID4+PiBXZSBjYW4gc2V0IGRldj1OdWxsIHNpbmNl
IElPTU1VRkRfT0JKX0hXX1BBR0VUQUJMRSBkb2VzIG5vdA0KPiBuZWVkIGRldi4NCj4gPj4+IGlv
bW11ZmRfaHdfcGFnZXRhYmxlX2Zyb21faWQoaWN0eCwgaHdwdF9pZCwgTlVMTCkNCj4gPj4NCj4g
Pj4gdGhpcyBpcyBub3QgZ29vZC4gZGV2IGlzIHBhc3NlZCBpbiB0byB0aGlzIGZ1bmN0aW9uIHRv
IGFsbG9jYXRlIGRvbWFpbg0KPiA+PiBhbmQgYWxzbyBjaGVjayBzd19tc2kgdGhpbmdzLiBJZiB5
b3UgcGFzcyBpbiBhIE5VTEwsIGl0IG1heSBldmVuIHVuYWJsZQ0KPiA+PiB0byBnZXQgYSBkb21h
aW4gZm9yIHRoZSBod3B0LiBJdCB3b24ndCB3b3JrIEkgZ3Vlc3MuDQo+ID4NCj4gPiBUaGUgaW9t
bXVmZF9od19wYWdldGFibGVfZnJvbV9pZCBjYW4gYmUgdXNlZCBmb3INCj4gPiAxLCBhbGxvY2F0
ZSBkb21haW4sIHdoaWNoIG5lZWQgcGFyYSBkZXYNCj4gPiBjYXNlIElPTU1VRkRfT0JKX0lPQVMN
Cj4gPiBod3B0ID0gaW9tbXVmZF9od19wYWdldGFibGVfYXV0b19nZXQoaWN0eCwgaW9hcywgZGV2
KTsNCj4gDQo+IHRoaXMgaXMgdXNlZCB3aGVuIGF0dGFjaGluZyBpb2FzLg0KPiANCj4gPiAyLiBK
dXN0IHJldHVybiBhbGxvY2F0ZWQgZG9tYWluIHZpYSBod3B0X2lkLCB3aGljaCBkb2VzIG5vdCBu
ZWVkIGRldi4NCj4gPiBjYXNlIElPTU1VRkRfT0JKX0hXX1BBR0VUQUJMRToNCj4gPiByZXR1cm4g
Y29udGFpbmVyX29mKG9iaiwgc3RydWN0IGlvbW11ZmRfaHdfcGFnZXRhYmxlLCBvYmopOw0KPiAN
Cj4geWVzLCB0aGlzIHdvdWxkIGJlIHRoZSB1c2FnZSBpbiBuZXN0aW5nLiB5b3UgbWF5IGNoZWNr
IG15IGJlbG93DQo+IGJyYW5jaC4gSXQncyBmb3IgbmVzdGluZyBpbnRlZ3JhdGlvbi4NCj4gDQo+
IGh0dHBzOi8vZ2l0aHViLmNvbS9sdXhpczE5OTkvaW9tbXVmZC90cmVlL2lvbW11ZmQtdjUuMTgt
cmM0LW5lc3RpbmcNCj4gDQo+ID4gQnkgdGhlIHdheSwgYW55IHBsYW4gb2YgdGhlIG5lc3RlZCBt
b2RlPw0KPiBJJ20gd29ya2luZyB3aXRoIEVyaWMsIE5pYyBvbiBpdC4gQ3VycmVudGx5LCBJJ3Zl
IGdvdCB0aGUgYWJvdmUga2VybmVsDQo+IGJyYW5jaCwgUUVNVSBzaWRlIGlzIGFsc28gV0lQLg0K
DQpIaSBZaS9FcmljLA0KDQpJIGhhZCBhIGxvb2sgYXQgdGhlIGFib3ZlIG5lc3Rpbmcga2VybmVs
IGFuZCBRZW11IGJyYW5jaGVzIGFuZCBhcyBtZW50aW9uZWQNCmluIHRoZSBjb3ZlciBsZXR0ZXIg
aXQgaXMgbm90IHdvcmtpbmcgb24gQVJNIHlldC4NCg0KSUlVQywgdG8gZ2V0IGl0IHdvcmtpbmcg
dmlhIHRoZSBpb21tdWZkIHRoZSBtYWluIHRoaW5nIGlzIHdlIG5lZWQgYSB3YXkgdG8gY29uZmln
dXJlDQp0aGUgcGh5cyBTTU1VIGluIG5lc3RlZCBtb2RlIGFuZCBzZXR1cCB0aGUgbWFwcGluZ3Mg
Zm9yIHRoZSBzdGFnZSAyLiBUaGUNCkNhY2hlL1BBU0lEIHJlbGF0ZWQgY2hhbmdlcyBsb29rcyBt
b3JlIHN0cmFpZ2h0IGZvcndhcmQuIA0KDQpJIGhhZCBxdWl0ZSBhIGZldyBoYWNrcyB0byBnZXQg
aXQgd29ya2luZyBvbiBBUk0sIGJ1dCBzdGlsbCBhIFdJUC4gU28ganVzdCB3b25kZXJpbmcNCmRv
IHlvdSBndXlzIGhhdmUgc29tZXRoaW5nIHRoYXQgY2FuIGJlIHNoYXJlZCB5ZXQ/DQoNClBsZWFz
ZSBsZXQgbWUga25vdy4NCg0KVGhhbmtzLA0KU2hhbWVlcg0K
