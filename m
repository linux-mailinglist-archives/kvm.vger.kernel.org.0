Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179EA29ABEA
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899730AbgJ0MUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 08:20:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2421 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439566AbgJ0MUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 08:20:14 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CL9l13sVBz4yfY;
        Tue, 27 Oct 2020 20:20:13 +0800 (CST)
Received: from dggema714-chm.china.huawei.com (10.3.20.78) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 27 Oct 2020 20:20:09 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggema714-chm.china.huawei.com (10.3.20.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 27 Oct 2020 20:20:08 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1913.007; Tue, 27 Oct 2020 12:20:06 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
Thread-Topic: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
Thread-Index: AQHWkZy5Y8YDMU7TmE6KILy51b1lHKl2CpqAgDWE0PA=
Date:   Tue, 27 Oct 2020 12:20:06 +0000
Message-ID: <cb5835e79b474e30af6702dbee0d46df@huawei.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
 <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
In-Reply-To: <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.24.15]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBpb21tdSBb
bWFpbHRvOmlvbW11LWJvdW5jZXNAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmddIE9uIEJlaGFs
ZiBPZg0KPiBBdWdlciBFcmljDQo+IFNlbnQ6IDIzIFNlcHRlbWJlciAyMDIwIDEyOjQ3DQo+IFRv
OiB5dXplbmdodWkgPHl1emVuZ2h1aUBodWF3ZWkuY29tPjsgZXJpYy5hdWdlci5wcm9AZ21haWwu
Y29tOw0KPiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsga3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdTsgam9yb0A4Ynl0ZXMub3JnOw0KPiBhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNv
bTsgamFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb207DQo+IHlpLmwubGl1QGludGVsLmNvbTsg
cm9iaW4ubXVycGh5QGFybS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTAgMDEvMTFdIHZm
aW86IFZGSU9fSU9NTVVfU0VUX1BBU0lEX1RBQkxFDQoNCi4uLg0KDQo+ID4gQmVzaWRlcywgYmVm
b3JlIGdvaW5nIHRocm91Z2ggdGhlIHdob2xlIHNlcmllcyBbMV1bMl0sIEknZCBsaWtlIHRvDQo+
ID4ga25vdyBpZiB0aGlzIGlzIHRoZSBsYXRlc3QgdmVyc2lvbiBvZiB5b3VyIE5lc3RlZC1TdGFn
ZS1TZXR1cCB3b3JrIGluDQo+ID4gY2FzZSBJIGhhZCBtaXNzZWQgc29tZXRoaW5nLg0KPiA+DQo+
ID4gWzFdDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMDMyMDE2MTkxMS4yNzQ5
NC0xLWVyaWMuYXVnZXJAcmVkaGF0LmNvbQ0KPiA+IFsyXQ0KPiA+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3IvMjAyMDA0MTQxNTA2MDcuMjg0ODgtMS1lcmljLmF1Z2VyQHJlZGhhdC5jb20NCj4g
DQo+IHllcyB0aG9zZSAyIHNlcmllcyBhcmUgdGhlIGxhc3Qgb25lcy4gVGhhbmsgeW91IGZvciBy
ZXZpZXdpbmcuDQo+IA0KPiBGWUksIEkgaW50ZW5kIHRvIHJlc3BpbiB3aXRoaW4gYSB3ZWVrIG9y
IDIgb24gdG9wIG9mIEphY29iJ3MgIFtQQVRDSCB2MTAgMC83XQ0KPiBJT01NVSB1c2VyIEFQSSBl
bmhhbmNlbWVudC4gDQoNClRoYW5rcyBmb3IgdGhhdC4gQWxzbyBpcyB0aGVyZSBhbnkgcGxhbiB0
byByZXNwaW4gdGhlIHJlbGF0ZWQgUWVtdSBzZXJpZXMgYXMgd2VsbD8NCkkga25vdyBkdWFsIHN0
YWdlIGludGVyZmFjZSBwcm9wb3NhbHMgYXJlIHN0aWxsIHVuZGVyIGRpc2N1c3Npb24sIGJ1dCBp
dCB3b3VsZCBiZQ0KbmljZSB0byBoYXZlIGEgdGVzdGFibGUgc29sdXRpb24gYmFzZWQgb24gbmV3
IGludGVyZmFjZXMgZm9yIEFSTTY0IGFzIHdlbGwuDQpIYXBweSB0byBoZWxwIHdpdGggYW55IHRl
c3RzIG9yIHZlcmlmaWNhdGlvbnMuDQoNClBsZWFzZSBsZXQgbWUga25vdy4NCg0KVGhhbmtzLA0K
U2hhbWVlcg0KICANCg0K
