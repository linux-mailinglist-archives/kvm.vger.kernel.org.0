Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE632B5B9C
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 10:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgKQJQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 04:16:36 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2109 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgKQJQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 04:16:35 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cb0cs31WYz67Dgf;
        Tue, 17 Nov 2020 17:14:21 +0800 (CST)
Received: from lhreml711-chm.china.huawei.com (10.201.108.62) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 17 Nov 2020 10:16:31 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml711-chm.china.huawei.com (10.201.108.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 17 Nov 2020 09:16:30 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Tue, 17 Nov 2020 09:16:30 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "bbhushan2@marvell.com" <bbhushan2@marvell.com>
Subject: RE: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHWvL1bJ6oI5HGxCEiiFCHGumIkrqnMBqRQ
Date:   Tue, 17 Nov 2020 09:16:30 +0000
Message-ID: <ed1cd49f58c04963be4e65b824e6ef63@huawei.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
 <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
 <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
 <3858dd8c-ee55-b0d7-96cc-3c047ba8f652@redhat.com>
 <9e323c4668e94ea89beec3689376b893@huawei.com>
 <a96395ff-09c2-8839-7a72-7b4031b5a5f4@redhat.com>
In-Reply-To: <a96395ff-09c2-8839-7a72-7b4031b5a5f4@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.11.163]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KRmlyc3QsIG1hbnkgdGhhbmtzIGZvciB0aGUgcmVzcGluLiBJIHdpbGwgZ28g
dGhyb3VnaCBhbGwgb2YgdGhlc2UoaW9tbXUvdmZpby9RZW11KQ0KYW5kIHdpbGwgZG8gYSB0aG9y
b3VnaCB2ZXJpZmljYXRpb24vdGVzdHMgb24gb3VyIGhhcmR3YXJlLiANCg0KPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBdWdlciBFcmljIFttYWlsdG86ZXJpYy5hdWdlckBy
ZWRoYXQuY29tXQ0KPiBTZW50OiAxNyBOb3ZlbWJlciAyMDIwIDA4OjQwDQo+IFRvOiBTaGFtZWVy
YWxpIEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+
Ow0KPiBaaGFuZ2ZlaSBHYW8gPHpoYW5nZmVpLmdhb0BsaW5hcm8ub3JnPjsgZXJpYy5hdWdlci5w
cm9AZ21haWwuY29tOw0KPiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsga3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdTsgd2lsbEBrZXJuZWwub3JnOw0KPiBqb3JvQDhieXRlcy5vcmc7
IG1hekBrZXJuZWwub3JnOyByb2Jpbi5tdXJwaHlAYXJtLmNvbQ0KPiBDYzogamVhbi1waGlsaXBw
ZUBsaW5hcm8ub3JnOyBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gamFjb2IuanVuLnBh
bkBsaW51eC5pbnRlbC5jb207IHlpLmwubGl1QGludGVsLmNvbTsgcGV0ZXIubWF5ZGVsbEBsaW5h
cm8ub3JnOw0KPiB0bkBzZW1paGFsZi5jb207IGJiaHVzaGFuMkBtYXJ2ZWxsLmNvbQ0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYxMSAwMC8xM10gU01NVXYzIE5lc3RlZCBTdGFnZSBTZXR1cCAoSU9N
TVUgcGFydCkNCj4gDQo+IEhpIFNoYW1lZXIsDQo+IA0KPiBPbiA1LzEzLzIwIDU6NTcgUE0sIFNo
YW1lZXJhbGkgS29sb3RodW0gVGhvZGkgd3JvdGU6DQo+ID4gSGkgRXJpYywNCj4gPg0KPiA+PiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBBdWdlciBFcmljIFttYWlsdG86
ZXJpYy5hdWdlckByZWRoYXQuY29tXQ0KPiA+PiBTZW50OiAxMyBNYXkgMjAyMCAxNDoyOQ0KPiA+
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsNCj4gPj4gWmhhbmdmZWkgR2FvIDx6aGFuZ2ZlaS5nYW9AbGluYXJvLm9y
Zz47IGVyaWMuYXVnZXIucHJvQGdtYWlsLmNvbTsNCj4gPj4gaW9tbXVAbGlzdHMubGludXgtZm91
bmRhdGlvbi5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4+IGt2bUB2Z2Vy
Lmtlcm5lbC5vcmc7IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7IHdpbGxAa2VybmVsLm9y
ZzsNCj4gPj4gam9yb0A4Ynl0ZXMub3JnOyBtYXpAa2VybmVsLm9yZzsgcm9iaW4ubXVycGh5QGFy
bS5jb20NCj4gPj4gQ2M6IGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZzsgYWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb207DQo+ID4+IGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tOyB5aS5sLmxp
dUBpbnRlbC5jb207DQo+IHBldGVyLm1heWRlbGxAbGluYXJvLm9yZzsNCj4gPj4gdG5Ac2VtaWhh
bGYuY29tOyBiYmh1c2hhbjJAbWFydmVsbC5jb20NCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
MTEgMDAvMTNdIFNNTVV2MyBOZXN0ZWQgU3RhZ2UgU2V0dXAgKElPTU1VIHBhcnQpDQo+ID4+DQo+
ID4gWy4uLl0NCj4gPg0KPiA+Pj4+PiBZZXMgdGhhdCdzIG5vcm1hbCB0aGlzIHNlcmllcyBpcyBu
b3QgbWVhbnQgdG8gc3VwcG9ydCB2U1ZNIGF0IHRoaXMgc3RhZ2UuDQo+ID4+Pj4+DQo+ID4+Pj4+
IEkgaW50ZW5kIHRvIGFkZCB0aGUgbWlzc2luZyBwaWVjZXMgZHVyaW5nIHRoZSBuZXh0IHdlZWtz
Lg0KPiA+Pj4+DQo+ID4+Pj4gVGhhbmtzIGZvciB0aGF0LiBJIGhhdmUgbWFkZSBhbiBhdHRlbXB0
IHRvIGFkZCB0aGUgdlNWQSBiYXNlZCBvbg0KPiA+Pj4+IHlvdXIgdjEwICsgSlBCcyBzdmEgcGF0
Y2hlcy4gVGhlIGhvc3Qga2VybmVsIGFuZCBRZW11IGNoYW5nZXMgY2FuDQo+ID4+Pj4gYmUgZm91
bmQgaGVyZVsxXVsyXS4NCj4gPj4+Pg0KPiA+Pj4+IFRoaXMgYmFzaWNhbGx5IGFkZHMgbXVsdGlw
bGUgcGFzaWQgc3VwcG9ydCBvbiB0b3Agb2YgeW91ciBjaGFuZ2VzLg0KPiA+Pj4+IEkgaGF2ZSBk
b25lIHNvbWUgYmFzaWMgc2FuaXR5IHRlc3RpbmcgYW5kIHdlIGhhdmUgc29tZSBpbml0aWFsIHN1
Y2Nlc3MNCj4gPj4+PiB3aXRoIHRoZSB6aXAgdmYgZGV2IG9uIG91ciBEMDYgcGxhdGZvcm0uIFBs
ZWFzZSBub3RlIHRoYXQgdGhlIFNUQUxMIGV2ZW50DQo+IGlzDQo+ID4+Pj4gbm90IHlldCBzdXBw
b3J0ZWQgdGhvdWdoLCBidXQgd29ya3MgZmluZSBpZiB3ZSBtbG9jaygpIGd1ZXN0IHVzciBtZW0u
DQo+ID4+Pg0KPiA+Pj4gSSBoYXZlIGFkZGVkIFNUQUxMIHN1cHBvcnQgZm9yIG91ciB2U1ZBIHBy
b3RvdHlwZSBhbmQgaXQgc2VlbXMgdG8gYmUNCj4gPj4+IHdvcmtpbmcob24gb3VyIGhhcmR3YXJl
KS4gSSBoYXZlIHVwZGF0ZWQgdGhlIGtlcm5lbCBhbmQgcWVtdSBicmFuY2hlcw0KPiA+PiB3aXRo
DQo+ID4+PiB0aGUgc2FtZVsxXVsyXS4gSSBzaG91bGQgd2FybiB5b3UgdGhvdWdoIHRoYXQgdGhl
c2UgYXJlIHByb3RvdHlwZSBjb2RlDQo+IGFuZCBJDQo+ID4+IGFtIHByZXR0eQ0KPiA+Pj4gbXVj
aCByZS11c2luZyB0aGUgVkZJT19JT01NVV9TRVRfUEFTSURfVEFCTEUgaW50ZXJmYWNlIGZvciBh
bG1vc3QNCj4gPj4gZXZlcnl0aGluZy4NCj4gPj4+IEJ1dCB0aG91Z2h0IG9mIHNoYXJpbmcsIGlu
IGNhc2UgaWYgaXQgaXMgdXNlZnVsIHNvbWVob3chLg0KPiA+Pg0KPiA+PiBUaGFuayB5b3UgYWdh
aW4gZm9yIHNoYXJpbmcgdGhlIFBPQy4gSSBsb29rZWQgYXQgdGhlIGtlcm5lbCBhbmQgUUVNVQ0K
PiA+PiBicmFuY2hlcy4NCj4gPj4NCj4gPj4gSGVyZSBhcmUgc29tZSBwcmVsaW1pbmFyeSBjb21t
ZW50czoNCj4gPj4gLSAiYXJtLXNtbXUtdjM6IFJlc2V0IFMyVFRCIHdoaWxlIHN3aXRjaGluZyBi
YWNrIGZyb20gbmVzdGVkIHN0YWdlIjoNCj4gYXMNCj4gPj4geW91IG1lbnRpb25uZWQgUzJUVEIg
cmVzZXQgbm93IGlzIGZlYXR1cmVkIGluIHYxMQ0KPiA+DQo+ID4gWWVzLg0KPiA+DQo+ID4+IC0g
ImFybS1zbW11LXYzOiBBZGQgc3VwcG9ydCBmb3IgbXVsdGlwbGUgcGFzaWQgaW4gbmVzdGVkIG1v
ZGUiOiBJIGNvdWxkDQo+ID4+IGVhc2lseSBpbnRlZ3JhdGUgdGhpcyBpbnRvIG15IHNlcmllcy4g
VXBkYXRlIHRoZSBpb21tdSBhcGkgZmlyc3QgYW5kDQo+ID4+IHBhc3MgbXVsdGlwbGUgQ0QgaW5m
byBpbiBhIHNlcGFyYXRlIHBhdGNoDQo+ID4NCj4gPiBPay4NCj4gaW4gdjEyLCBJIGFkZGVkDQo+
IFtQQVRDSCB2MTIgMTQvMTVdIGlvbW11L3NtbXV2MzogQWNjZXB0IGNvbmZpZ3Mgd2l0aCBtb3Jl
IHRoYW4gb25lDQo+IGNvbnRleHQgZGVzY3JpcHRvcg0KPiANCj4gSSBkb24ndCB0aGluayB5b3Ug
bmVlZCB0byBhZGQgczFjZG1heCBhZGRpdGlvbiBhcyB3ZSBhbHJlYWR5IGhhdmUNCj4gcGFzaWRf
Yml0cyB3aGljaCBzaG91bGQgZG8gdGhlIGpvYi4NCg0KT2suDQogDQo+ID4+IC0gImFybS1zbW11
LXYzOiBBZGQgc3VwcG9ydCB0byBJbnZhbGlkYXRlIENEIjogQ0QgaW52YWxpZGF0aW9uIHNob3Vs
ZCBiZQ0KPiA+PiBjYXNjYWRlZCB0byBob3N0IHRocm91Z2ggdGhlIFBBU0lEIGNhY2hlIGludmFs
aWRhdGlvbiB1YXBpIChubyBwYiB5b3UNCj4gPj4gd2FybmVkIHVzIGZvciB0aGUgUE9DIHlvdSBz
aW1wbHkgdXNlZCBWRklPX0lPTU1VX1NFVF9QQVNJRF9UQUJMRSkuIEkNCj4gPj4gdGhpbmsgSSBz
aG91bGQgYWRkIHRoaXMgc3VwcG9ydCBpbiBteSBvcmlnaW5hbCBzZXJpZXMgYWx0aG91Z2ggaXQg
ZG9lcw0KPiA+PiBub3Qgc2VlbSB0byB0cmlnZ2VyIGFueSBpc3N1ZSB1cCB0byBub3cuDQo+ID4N
Cj4gPiBBZ3JlZS4gQ2FjaGUgaW52YWxpZGF0aW9uIHVhcGkgaXMgYSBiZXR0ZXIgaW50ZXJmYWNl
IGZvciB0aGlzLiBBbHNvIEkgZG9u4oCZdCB0aGluaw0KPiA+IHRoaXMgbWF0dGVycyBmb3Igbm9u
LXZzdmEgY2FzZXMgYXMgR3Vlc3Qga2VybmVsIHRhYmxlL0NEKHBhc2lkIDApIHdpbGwgbmV2ZXIN
Cj4gPiBnZXQgaW52YWxpZGF0ZWQuDQo+IGluIHYxMiBJIGFkZGVkIFtQQVRDSCB2MTIgMTUvMTVd
IGlvbW11L3NtbXV2MzogQWRkIFBBU0lEIGNhY2hlDQo+IGludmFsaWRhdGlvbiBwZXIgUEFTSUQu
IEkgaGF2ZSBub3QgdGVzdGVkIGl0IHRob3VnaC4NCg0KT2suIFdpbGwgdmVyaWZ5IHRoaXMuDQoN
Cj4gPj4gLSAiYXJtLXNtbXUtdjM6IFJlbW92ZSBkdXBsaWNhdGlvbiBvZiBmYXVsdCBwcm9wYWdh
dGlvbiIuIEkgdW5kZXJzdGFuZA0KPiA+PiB0aGUgdHJhbnNjb2RlIGlzIGRvbmUgc29tZXdoZXJl
IGVsc2Ugd2l0aCBTVkEgYnV0IHdlIHN0aWxsIG5lZWQgdG8gZG8gaXQNCj4gPj4gaWYgYSBzaW5n
bGUgQ0QgaXMgdXNlZCwgcmlnaHQ/IEkgd2lsbCByZXZpZXcgdGhlIFNWQSBjb2RlIHRvIGJldHRl
cg0KPiA+PiB1bmRlcnN0YW5kLg0KPiANCj4gU2luY2UgSSBoYXZlIHJlYmFzZSBvbiA1LjEwLXJj
NCB5b3Ugd2lsbCBzdGlsbCBoYXZlIHRoaXMgZHVwbGljYXRpb24gdG8NCj4gaGFuZGxlLg0KDQpP
Sy4NCg0KPiA+IEhtbS4ubm90IHN1cmUuIE5lZWQgdG8gdGFrZSBhbm90aGVyIGxvb2sgdG8gc2Vl
IHdoZXRoZXIgd2UgbmVlZCBhIHNwZWNpYWwNCj4gPiBoYW5kbGluZyBmb3Igc2luZ2xlIENEIG9y
IG5vdC4NCj4gPg0KPiA+PiAtIGZvciB0aGUgU1RBTEwgcmVzcG9uc2UgaW5qZWN0aW9uIEkgd291
bGQgdGVuZCB0byB1c2UgYSBuZXcgVkZJTyByZWdpb24NCj4gPj4gZm9yIHJlc3BvbnNlcy4gQXQg
dGhlIG1vbWVudCB0aGVyZSBpcyBhIHNpbmdsZSBWRklPIHJlZ2lvbiBmb3IgcmVwb3J0aW5nDQo+
ID4+IHRoZSBmYXVsdC4NCj4gDQo+IGluIHYxMiBJIGFkZGVkIGEgbmV3IFZGSU8gcmVnaW9uIHRv
IGluamVjdCB5b3VyIGZhdWx0LiBUaGlzIHdhcyB0ZXN0ZWQNCj4gd2l0aCBkdW1teSBldmVudCBp
bmplY3Rpb24sIHRoaXMgc2hvdWxkIHdvcmsgcHJvcGVybHkuDQoNClRoYXTigJlzIGNvb2wuIEkg
d2lsbCBjaGVjayB0aGlzLg0KIA0KPiBJZiB3ZSBjbGVhcmx5IGlkZW50aWZ5IGFsbCB0aGUgcHVi
bGljIGRlcGVuZGVuY2llcyBuZWVkZWQgZm9yIHZTVkEvQVJNIEkNCj4gY2FuIGhlbHAgeW91IHJl
c3Bpbm5pbmcgb24gdG9wIG9mIHRoZW0NCg0KU3VyZS4gSSB3aWxsIHJlYmFzZSB0aGUgdlNWQSBy
ZWxhdGVkIGNoYW5nZXMgb24gdG9wIG9mIHlvdXIgc2VyaWVzIGFuZCB0aGVuDQp3ZSBjYW4gdGFr
ZSBpdCBmcm9tIHRoZXJlLiBUaGFua3MgZm9yIHlvdXIgc3VwcG9ydC4NCg0KVGhhbmtzLA0KU2hh
bWVlcg0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPiA+DQo+ID4gU3VyZS4gVGhhdCB3aWxsIGJl
IG11Y2ggY2xlYW5lciBhbmQgcHJvYmFibHkgaW1wcm92ZSB0aGUgY29udGV4dCBzd2l0Y2gNCj4g
PiBsYXRlbmN5LiBBbm90aGVyIHRoaW5nIEkgbm90ZWQgd2l0aCBTVEFMTCBpcyB0aGF0IHBhc2lk
X3ZhbGlkIGZsYWcgbmVlZHMgdG8gYmUNCj4gPiB0YWtlbiBjYXJlIGluIHRoZSBTVkEga2VybmVs
IHBhdGguDQo+ID4NCj4gPiAiaW9tbXU6IFJlbW92ZSBwYXNpZCB2YWxpZGl0eSBjaGVjayBmb3Ig
U1RBTEwgbW9kZWwgcGFnZSByZXNwb25zZSBtc2ciDQo+ID4gTm90IHN1cmUgdGhpcyBvbmUgaXMg
YSBwcm9wZXIgd2F5IHRvIGhhbmRsZSB0aGlzLg0KPiA+DQo+ID4+IE9uIFFFTVUgc2lkZToNCj4g
Pj4gLSBJIGFtIGN1cnJlbnRseSB3b3JraW5nIG9uIDMuMiByYW5nZSBpbnZhbGlkYXRpb24gc3Vw
cG9ydCB3aGljaCBpcw0KPiA+PiBuZWVkZWQgZm9yIERQREsvVkZJTw0KPiA+PiAtIFdoaWxlIGF0
IGl0IEkgd2lsbCBsb29rIGF0IGhvdyB0byBpbmNyZW1lbnRhbGx5IGludHJvZHVjZSBzb21lIG9m
IHRoZQ0KPiA+PiBmZWF0dXJlcyB5b3UgbmVlZCBpbiB0aGlzIHNlcmllcy4NCj4gPg0KPiA+IE9r
Lg0KPiA+DQo+ID4gVGhhbmtzIGZvciB0YWtpbmcgYSBsb29rIGF0IHRoZSBQT0MuDQo+ID4NCj4g
PiBDaGVlcnMsDQo+ID4gU2hhbWVlcg0KPiA+DQoNCg==
