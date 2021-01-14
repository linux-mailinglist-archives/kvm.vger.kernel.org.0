Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E92F66FF
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbhANRJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:09:54 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2978 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbhANRJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:09:53 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DGrNq2mQkzR3Vn;
        Fri, 15 Jan 2021 01:08:11 +0800 (CST)
Received: from dggemi751-chm.china.huawei.com (10.1.198.137) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 15 Jan 2021 01:09:07 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggemi751-chm.china.huawei.com (10.1.198.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 15 Jan 2021 01:09:06 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.002; Thu, 14 Jan 2021 17:09:04 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Xieyingtai <xieyingtai@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        wangxingang <wangxingang5@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        qubingbing <qubingbing@hisilicon.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Topic: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Thread-Index: AQHWvZ36CODK3kmCyk2T9hmchYhCqqniWTe/gANqCPCAAQgyAIAABi8QgAACSYCAQN3PgIAAAmvA
Date:   Thu, 14 Jan 2021 17:09:04 +0000
Message-ID: <0bfab7bc762d4356bed81255749f94c3@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
 <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
 <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
In-Reply-To: <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBdWdlciBF
cmljIFttYWlsdG86ZXJpYy5hdWdlckByZWRoYXQuY29tXQ0KPiBTZW50OiAxNCBKYW51YXJ5IDIw
MjEgMTY6NTgNCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29s
b3RodW0udGhvZGlAaHVhd2VpLmNvbT47DQo+IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1w
aGlsaXBwZUBsaW5hcm8ub3JnPg0KPiBDYzogWGlleWluZ3RhaSA8eGlleWluZ3RhaUBodWF3ZWku
Y29tPjsgYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207DQo+IHdhbmd4aW5nYW5nIDx3YW5neGlu
Z2FuZzVAaHVhd2VpLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hekBrZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyB2aXZlay5nYXV0YW1AYXJtLmNvbTsNCj4g
aW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IHF1YmluZ2JpbmcgPHF1YmluZ2JpbmdA
aGlzaWxpY29uLmNvbT47DQo+IFplbmd0YW8gKEIpIDxwcmltZS56ZW5nQGhpc2lsaWNvbi5jb20+
OyB6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZzsNCj4gZXJpYy5hdWdlci5wcm9AZ21haWwuY29tOyB3
aWxsQGtlcm5lbC5vcmc7IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7DQo+IHJvYmluLm11
cnBoeUBhcm0uY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEzIDA3LzE1XSBpb21tdS9zbW11
djM6IEFsbG93IHN0YWdlIDEgaW52YWxpZGF0aW9uIHdpdGgNCj4gdW5tYW5hZ2VkIEFTSURzDQo+
IA0KPiBIaSBTaGFtZWVyLCBKZWFuLVBoaWxpcHBlLA0KPiANCj4gT24gMTIvNC8yMCAxMToyMyBB
TSwgQXVnZXIgRXJpYyB3cm90ZToNCj4gPiBIaSBTaGFtZWVyLCBKZWFuLVBoaWxpcHBlLA0KPiA+
DQo+ID4gT24gMTIvNC8yMCAxMToyMCBBTSwgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSB3cm90
ZToNCj4gPj4gSGkgSmVhbiwNCj4gPj4NCj4gPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4+PiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgW21haWx0bzpqZWFuLXBoaWxpcHBl
QGxpbmFyby5vcmddDQo+ID4+PiBTZW50OiAwNCBEZWNlbWJlciAyMDIwIDA5OjU0DQo+ID4+PiBU
bzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaQ0KPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPg0KPiA+Pj4gQ2M6IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT47IHdhbmd4aW5nYW5nDQo+ID4+PiA8d2FuZ3hpbmdhbmc1QGh1YXdlaS5jb20+OyBYaWV5aW5n
dGFpIDx4aWV5aW5ndGFpQGh1YXdlaS5jb20+Ow0KPiA+Pj4ga3ZtQHZnZXIua2VybmVsLm9yZzsg
bWF6QGtlcm5lbC5vcmc7IGpvcm9AOGJ5dGVzLm9yZzsNCj4gd2lsbEBrZXJuZWwub3JnOw0KPiA+
Pj4gaW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+ID4+PiB2aXZlay5nYXV0YW1AYXJtLmNvbTsgYWxleC53aWxsaWFtc29uQHJl
ZGhhdC5jb207DQo+ID4+PiB6aGFuZ2ZlaS5nYW9AbGluYXJvLm9yZzsgcm9iaW4ubXVycGh5QGFy
bS5jb207DQo+ID4+PiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1OyBlcmljLmF1Z2VyLnBy
b0BnbWFpbC5jb207IFplbmd0YW8gKEIpDQo+ID4+PiA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29t
PjsgcXViaW5nYmluZyA8cXViaW5nYmluZ0BoaXNpbGljb24uY29tPg0KPiA+Pj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MTMgMDcvMTVdIGlvbW11L3NtbXV2MzogQWxsb3cgc3RhZ2UgMSBpbnZhbGlk
YXRpb24NCj4gd2l0aA0KPiA+Pj4gdW5tYW5hZ2VkIEFTSURzDQo+ID4+Pg0KPiA+Pj4gSGkgU2hh
bWVlciwNCj4gPj4+DQo+ID4+PiBPbiBUaHUsIERlYyAwMywgMjAyMCBhdCAwNjo0Mjo1N1BNICsw
MDAwLCBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IHdyb3RlOg0KPiA+Pj4+IEhpIEplYW4v
emhhbmdmZWksDQo+ID4+Pj4gSXMgaXQgcG9zc2libGUgdG8gaGF2ZSBhIGJyYW5jaCB3aXRoIG1p
bmltdW0gcmVxdWlyZWQgU1ZBL1VBQ0NFIHJlbGF0ZWQNCj4gPj4+IHBhdGNoZXMNCj4gPj4+PiB0
aGF0IGFyZSBhbHJlYWR5IHB1YmxpYyBhbmQgY2FuIGJlIGEgInN0YWJsZSIgY2FuZGlkYXRlIGZv
ciBmdXR1cmUgcmVzcGluDQo+IG9mDQo+ID4+PiBFcmljJ3Mgc2VyaWVzPw0KPiA+Pj4+IFBsZWFz
ZSBzaGFyZSB5b3VyIHRob3VnaHRzLg0KPiA+Pj4NCj4gPj4+IEJ5ICJzdGFibGUiIHlvdSBtZWFu
IGEgZml4ZWQgYnJhbmNoIHdpdGggdGhlIGxhdGVzdCBTVkEvVUFDQ0UgcGF0Y2hlcw0KPiA+Pj4g
YmFzZWQgb24gbWFpbmxpbmU/DQo+ID4+DQo+ID4+IFllcy4NCj4gPj4NCj4gPj4gIFRoZSB1YWNj
ZS1kZXZlbCBicmFuY2hlcyBmcm9tDQo+ID4+PiBodHRwczovL2dpdGh1Yi5jb20vTGluYXJvL2xp
bnV4LWtlcm5lbC11YWRrIGRvIHByb3ZpZGUgdGhpcyBhdCB0aGUgbW9tZW50DQo+ID4+PiAodGhl
eSB0cmFjayB0aGUgbGF0ZXN0IHN2YS96aXAtZGV2ZWwgYnJhbmNoDQo+ID4+PiBodHRwczovL2pw
YnJ1Y2tlci5uZXQvZ2l0L2xpbnV4LyB3aGljaCBpcyByb3VnaGx5IGJhc2VkIG9uIG1haW5saW5l
LikNCj4gQXMgSSBwbGFuIHRvIHJlc3BpbiBzaG9ydGx5LCBwbGVhc2UgY291bGQgeW91IGNvbmZp
cm0gdGhlIGJlc3QgYnJhbmNoIHRvDQo+IHJlYmFzZSBvbiBzdGlsbCBpcyB0aGF0IG9uZSAodWFj
Y2UtZGV2ZWwgZnJvbSB0aGUgbGludXgta2VybmVsLXVhZGsgZ2l0DQo+IHJlcG8pLiBJcyBpdCB1
cCB0byBkYXRlPyBDb21taXRzIHNlZW0gdG8gYmUgcXVpdGUgb2xkIHRoZXJlLg0KDQpJIHRoaW5r
IGl0IGlzIHRoZSB1YWNjZS1kZXZlbC01LjExIGJyYW5jaCwgYnV0IHdpbGwgd2FpdCBmb3IgSmVh
biBvciBaaGFuZ2ZlaQ0KdG8gY29uZmlybS4NCg0KVGhhbmtzLA0KU2hhbWVlcg0KDQo+IFRoYW5r
cw0KPiANCj4gRXJpYw0KPiA+Pg0KPiA+PiBUaGFua3MuDQo+ID4+DQo+ID4+IEhpIEVyaWMsDQo+
ID4+DQo+ID4+IENvdWxkIHlvdSBwbGVhc2UgdGFrZSBhIGxvb2sgYXQgdGhlIGFib3ZlIGJyYW5j
aGVzIGFuZCBzZWUgd2hldGhlciBpdCBtYWtlDQo+IHNlbnNlDQo+ID4+IHRvIHJlYmFzZSBvbiB0
b3Agb2YgZWl0aGVyIG9mIHRob3NlPw0KPiA+Pg0KPiA+PiBGcm9tIHZTVkEgcG9pbnQgb2Ygdmll
dywgaXQgd2lsbCBiZSBsZXNzIHJlYmFzZSBoYXNzbGUgaWYgd2UgY2FuIGRvIHRoYXQuDQo+ID4N
Cj4gPiBTdXJlLiBJIHdpbGwgcmViYXNlIG9uIHRvcCBvZiB0aGlzIDstKQ0KPiA+DQo+ID4gVGhh
bmtzDQo+ID4NCj4gPiBFcmljDQo+ID4+DQo+ID4+IFRoYW5rcywNCj4gPj4gU2hhbWVlcg0KPiA+
Pg0KPiA+Pj4gVGhhbmtzLA0KPiA+Pj4gSmVhbg0KPiA+Pg0KPiA+DQo+ID4gX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gPiBpb21tdSBtYWlsaW5nIGxp
c3QNCj4gPiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZw0KPiA+IGh0dHBzOi8vbGlz
dHMubGludXhmb3VuZGF0aW9uLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2lvbW11DQo+ID4NCg0K
