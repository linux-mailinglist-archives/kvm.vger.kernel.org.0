Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160D6258E76
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgIAMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:46:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3083 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728019AbgIAMKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 08:10:20 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 6770DB76158366D02882;
        Tue,  1 Sep 2020 20:10:18 +0800 (CST)
Received: from DGGEML524-MBX.china.huawei.com ([169.254.1.71]) by
 DGGEML402-HUB.china.huawei.com ([fe80::fca6:7568:4ee3:c776%31]) with mapi id
 14.03.0487.000; Tue, 1 Sep 2020 20:10:10 +0800
From:   "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
To:     Jason Wang <jasowang@redhat.com>, Peter Xu <peterx@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENIIFYyXSB2ZmlvIGRtYV9t?=
 =?utf-8?Q?ap/unmap:_optimized_for_hugetlbfs_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSCBWMl0gdmZpbyBkbWFfbWFwL3VubWFw?=
 =?utf-8?Q?:_optimized_for_hugetlbfs_pages?=
Thread-Index: AQHWcePn246e6Z2xQkKwoyKqsTP1MqlI20CAgAGejeD//5OugIADObaQ///cqQCABYTEgIAAwC5g
Date:   Tue, 1 Sep 2020 12:10:10 +0000
Message-ID: <8B561EC9A4D13649A62CF60D3A8E8CB28C2DC473@dggeml524-mbx.china.huawei.com>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
 <20200825205907.GB8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2D9ABB@dggeml524-mbx.china.huawei.com>
 <20200826151509.GD8235@xz-x1>
 <8B561EC9A4D13649A62CF60D3A8E8CB28C2DBE7A@dggeml524-mbx.china.huawei.com>
 <20200828142400.GA3197@xz-x1>
 <a07f4db3-7680-14ac-dd1e-6851e051aa4e@redhat.com>
In-Reply-To: <a07f4db3-7680-14ac-dd1e-6851e051aa4e@redhat.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.151.129]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gMjAyMC84LzI4IOS4i+WNiDEwOjI0LCBQZXRlciBYdSB3cm90ZToNCj4gPiBPbiBG
cmksIEF1ZyAyOCwgMjAyMCBhdCAwOToyMzowOEFNICswMDAwLCBNYW9taW5nIChtYW9taW5nLCBD
bG91ZA0KPiBJbmZyYXN0cnVjdHVyZSBTZXJ2aWNlIFByb2R1Y3QgRGVwdC4pIHdyb3RlOg0KPiA+
PiBJbiBodWdldGxiX3B1dF9wZm4oKSwgSSBkZWxldGUgdW5waW5fdXNlcl9wYWdlc19kaXJ0eV9s
b2NrKCkgYW5kIHVzZSBzb21lDQo+IHNpbXBsZSBjb2RlIHRvIHB1dCBodWdldGxiIHBhZ2VzLg0K
PiA+PiBJcyB0aGlzIHJpZ2h0Pw0KPiA+IEkgdGhpbmsgd2Ugc2hvdWxkIHN0aWxsIHVzZSB0aGUg
QVBJcyBiZWNhdXNlIG9mIHRoZSB0aGUgc2FtZSByZWFzb24uDQo+ID4gSG93ZXZlciBhZ2FpbiBJ
IGRvbid0IGtub3cgdGhlIHBlcmZvcm1hbmNlIGltcGFjdCBvZiB0aGF0IHRvIHlvdXINCj4gPiBw
YXRjaCwgYnV0IEkgc3RpbGwgdGhpbmsgdGhhdCBjb3VsZCBiZSBkb25lIGluc2lkZSBndXAgaXRz
ZWxmIHdoZW4NCj4gPiBuZWVkZWQgKGUuZy4sIGEgc3BlY2lhbCBwYXRoIGZvciBodWdldGxiZnMg
Zm9yIFt1bl1waW5uaW5nIGNvbnRpbnVvdXMNCj4gPiBwYWdlczsgdGhvdWdoIGlmIHRoYXQncyB0
aGUgY2FzZSB0aGF0IGNvdWxkIGJlIHNvbWV0aGluZyB0byBiZSBkaXNjdXNzZWQgb24NCj4gLW1t
IHRoZW4gYXMgYSBzZXBhcmF0ZSBwYXRjaCwgaW1obykuDQo+ID4NCj4gPiBUaGFua3MsDQo+IA0K
PiANCj4gKzEsIHdlIHNob3VsZCBtYWtlIHRoaXMgYXMgYSBnZW5lcmljIG9wdGltaXphdGlvbiBp
bnN0ZWFkIG9mIFZGSU8NCj4gc3BlY2lmaWMgY29uc2lkZXIgdGhlcmUncmUgYSBsb3Qgb2YgR1VQ
IHVzZXJzLg0KPiANCj4gVGhhbmtzDQo+IA0KDQoNClRoYW5rcyBmb3IgeW91ciBzdWdnZXN0aW9u
cy4NCllvdSBhcmUgcmlnaHQsIEkgd2lsbCBmaXggaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg==
