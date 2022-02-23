Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9194C17C9
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbiBWPy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242473AbiBWPyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:54:25 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2D6C1149;
        Wed, 23 Feb 2022 07:53:56 -0800 (PST)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K3gYG6lG5z67mg9;
        Wed, 23 Feb 2022 23:53:06 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 16:53:54 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 15:53:53 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 23 Feb 2022 15:53:53 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Thread-Topic: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Thread-Index: AQHYJxfp35LqMMCcBk6T3RpIMatBf6yevfmAgAE454CAAVIL4A==
Date:   Wed, 23 Feb 2022 15:53:53 +0000
Message-ID: <0f77f9dcd1ac4ec099e8d05a6adf0fde@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220222004943.GF193956@nvidia.com>
 <20220222122939.0394d152.alex.williamson@redhat.com>
In-Reply-To: <20220222122939.0394d152.alex.williamson@redhat.com>
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
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleCBXaWxsaWFtc29u
IFttYWlsdG86YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb21dDQo+IFNlbnQ6IDIyIEZlYnJ1YXJ5
IDIwMjIgMTk6MzANCj4gVG86IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IENj
OiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1
YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBjb2h1Y2tAcmVkaGF0LmNv
bTsgbWd1cnRvdm95QG52aWRpYS5jb207DQo+IHlpc2hhaWhAbnZpZGlhLmNvbTsgTGludXhhcm0g
PGxpbnV4YXJtQGh1YXdlaS5jb20+OyBsaXVsb25nZmFuZw0KPiA8bGl1bG9uZ2ZhbmdAaHVhd2Vp
LmNvbT47IFplbmd0YW8gKEIpIDxwcmltZS56ZW5nQGhpc2lsaWNvbi5jb20+Ow0KPiBKb25hdGhh
biBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+OyBXYW5nemhvdSAoQikNCj4g
PHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY1IDAvOF0g
dmZpby9oaXNpbGljb246IGFkZCBBQ0MgbGl2ZSBtaWdyYXRpb24gZHJpdmVyDQo+IA0KPiBPbiBN
b24sIDIxIEZlYiAyMDIyIDIwOjQ5OjQzIC0wNDAwDQo+IEphc29uIEd1bnRob3JwZSA8amdnQG52
aWRpYS5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBNb24sIEZlYiAyMSwgMjAyMiBhdCAxMTo0MDoz
NUFNICswMDAwLCBTaGFtZWVyIEtvbG90aHVtIHdyb3RlOg0KPiA+ID4NCj4gPiA+IEhpLA0KPiA+
ID4NCj4gPiA+IFRoaXMgc2VyaWVzIGF0dGVtcHRzIHRvIGFkZCB2ZmlvIGxpdmUgbWlncmF0aW9u
IHN1cHBvcnQgZm9yDQo+ID4gPiBIaVNpbGljb24gQUNDIFZGIGRldmljZXMgYmFzZWQgb24gdGhl
IG5ldyB2MiBtaWdyYXRpb24gcHJvdG9jb2wNCj4gPiA+IGRlZmluaXRpb24gYW5kIG1seDUgdjgg
c2VyaWVzIGRpc2N1c3NlZCBoZXJlWzBdLg0KPiA+ID4NCj4gPiA+IFJGQ3Y0IC0tPiB2NQ0KPiA+
ID4gICAtIERyb3BwZWQgUkZDIHRhZyBhcyB2MiBtaWdyYXRpb24gQVBJcyBhcmUgbW9yZSBzdGFi
bGUgbm93Lg0KPiA+ID4gICAtIEFkZHJlc3NlZCByZXZpZXcgY29tbWVudHMgZnJvbSBKYXNvbiBh
bmQgQWxleCAoVGhhbmtzISkuDQo+ID4gPg0KPiA+ID4gVGhpcyBpcyBzYW5pdHkgdGVzdGVkIG9u
IGEgSGlTaWxpY29uIHBsYXRmb3JtIHVzaW5nIHRoZSBRZW11IGJyYW5jaA0KPiA+ID4gcHJvdmlk
ZWQgaGVyZVsxXS4NCj4gPiA+DQo+ID4gPiBQbGVhc2UgdGFrZSBhIGxvb2sgYW5kIGxldCBtZSBr
bm93IHlvdXIgZmVlZGJhY2suDQo+ID4gPg0KPiA+ID4gVGhhbmtzLA0KPiA+ID4gU2hhbWVlcg0K
PiA+ID4gWzBdDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIyMDIyMDA5NTcxNi4x
NTM3NTctMS15aXNoYWloQG52aWRpYS5jb20vDQo+ID4gPiBbMV0gaHR0cHM6Ly9naXRodWIuY29t
L2pndW50aG9ycGUvcWVtdS9jb21taXRzL3ZmaW9fbWlncmF0aW9uX3YyDQo+ID4gPg0KPiA+ID4N
Cj4gPiA+IHYzIC0tPiBSRkN2NA0KPiA+ID4gLUJhc2VkIG9uIG1pZ3JhdGlvbiB2MiBwcm90b2Nv
bCBhbmQgbWx4NSB2NyBzZXJpZXMuDQo+ID4gPiAtQWRkZWQgUkZDIHRhZyBhZ2FpbiBhcyBtaWdy
YXRpb24gdjIgcHJvdG9jb2wgaXMgc3RpbGwgdW5kZXIgZGlzY3Vzc2lvbi4NCj4gPiA+IC1BZGRl
ZCBuZXcgcGF0Y2ggIzYgdG8gcmV0cmlldmUgdGhlIFBGIFFNIGRhdGEuDQo+ID4gPiAtUFJFX0NP
UFkgY29tcGF0aWJpbGl0eSBjaGVjayBpcyBub3cgZG9uZSBhZnRlciB0aGUgbWlncmF0aW9uIGRh
dGENCj4gPiA+IMKgdHJhbnNmZXIuIFRoaXMgaXMgbm90IGlkZWFsIGFuZCBuZWVkcyBkaXNjdXNz
aW9uLg0KPiA+DQo+ID4gQWxleCwgZG8geW91IHdhbnQgdG8ga2VlcCB0aGUgUFJFX0NPUFkgaW4g
anVzdCBmb3IgYWNjIGZvciBub3c/IE9yIGRvDQo+ID4geW91IHRoaW5rIHRoaXMgaXMgbm90IGEg
Z29vZCB0ZW1wb3JhcnkgdXNlIGZvciBpdD8NCj4gPg0KPiA+IFdlIGhhdmUgc29tZSB3b3JrIHRv
d2FyZCBkb2luZyB0aGUgY29tcGF0YWJpbGl0eSBtb3JlIGdlbmVyYWxseSwgYnV0IEkNCj4gPiB0
aGluayBpdCB3aWxsIGJlIGEgd2hpbGUgYmVmb3JlIHRoYXQgaXMgYWxsIHNldHRsZWQuDQo+IA0K
PiBJbiB0aGUgb3JpZ2luYWwgbWlncmF0aW9uIHByb3RvY29sIEkgcmVjYWxsIHRoYXQgd2UgZGlz
Y3Vzc2VkIHRoYXQNCj4gdXNpbmcgdGhlIHByZS1jb3B5IHBoYXNlIGZvciBjb21wYXRpYmlsaXR5
IHRlc3RpbmcsIGV2ZW4gd2l0aG91dA0KPiBhZGRpdGlvbmFsIGRldmljZSBkYXRhLCBhcyBhIHZh
bGlkIHVzZSBjYXNlLiAgVGhlIG1pZ3JhdGlvbiBkcml2ZXIgb2YNCj4gY291cnNlIG5lZWRzIHRv
IGFjY291bnQgZm9yIHRoZSBmYWN0IHRoYXQgdXNlcnNwYWNlIGlzIG5vdCByZXF1aXJlZCB0bw0K
PiBwZXJmb3JtIGEgcHJlLWNvcHksIGFuZCB0aGVyZWZvcmUgY2Fubm90IHJlbHkgb24gdGhhdCBl
eGNsdXNpdmVseSBmb3INCj4gY29tcGF0aWJpbGl0eSB0ZXN0aW5nLCBidXQgZmFpbGluZyBhIG1p
Z3JhdGlvbiBlYXJsaWVyIGR1ZSB0byBkZXRlY3Rpb24NCj4gb2YgYW4gaW5jb21wYXRpYmlsaXR5
IGlzIGdlbmVyYWxseSBhIGdvb2QgdGhpbmcuDQo+IA0KPiBJZiB0aGUgQUNDIGRyaXZlciB3YW50
cyB0byByZS1pbmNvcnBvcmF0ZSB0aGlzIGJlaGF2aW9yIGludG8gYSBub24tUkZDDQo+IHByb3Bv
c2VkIHNlcmllcyBhbmQgd2UgY291bGQgYWxpZ24gYWNjZXB0aW5nIHRoZW0gaW50byB0aGUgc2Ft
ZSBrZXJuZWwNCj4gcmVsZWFzZSwgdGhhdCBzb3VuZHMgb2sgdG8gbWUuICBUaGFua3MsDQoNCk9r
LiBJIHdpbGwgYWRkIHRoZSBzdXBwb3J0IHRvIFBSRV9DT1BZIGFuZCBjaGVjayBjb21wYXRpYmls
aXR5IGVhcmx5LiANCg0KRnJvbSBGU00gYXJjIHBvaW50IG9mIHZpZXcsIEkgZ3Vlc3MgaXQgaXMg
YWRkaW5nLA0KDQpTVEFURV9SVU5OSU5HIC0tPiBTVEFURV9QUkVfQ09QWQ0KICAgY3JlYXRlIHRo
ZSBzYXZpbmcgZmlsZS4NCiAgIGdldF9tYXRjaF9kYXRhKCk7DQogICByZXR1cm4gZmQ7DQoNClNU
QVRFX1BSRV9DT1BZICAtLT4gU1RBVEVfU1RPUF9DT1BZDQogICBzdG9wX2RldmljZSgpDQogICBn
ZXRfZGV2aWNlX2RhdGEoKQ0KICAgdXBkYXRlIHRoZSBzYXZpbmcgbWlnZiB0b3RhbF9sZW47DQoN
CnJlc3VtZV93cml0ZSgpDQogICBjaGVjayBjb21wYXRpYmlsaXR5IG9uY2Ugd2UgaGF2ZSBlbm91
Z2ggYnl0ZXMuDQoNCkFsc28gYWRkIHN1cHBvcnQgdG8gSU9DVEwgVkZJT19ERVZJQ0VfTUlHX1BS
RUNPUFkuDQoNCkkgd2lsbCBoYXZlIGEgZ28gYW5kIHNlbnQgb3V0IGEgcmV2aXNlZCBvbmUuDQoN
ClRoYW5rcywNClNoYW1lZXIgICANCg0K
