Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7A258E87
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgIAMsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:48:30 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3496 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727991AbgIAMKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 08:10:13 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 89EA5ACF72CEEA37BECC;
        Tue,  1 Sep 2020 20:10:06 +0800 (CST)
Received: from DGGEML524-MBX.china.huawei.com ([169.254.1.71]) by
 dggeml406-hub.china.huawei.com ([10.3.17.50]) with mapi id 14.03.0487.000;
 Tue, 1 Sep 2020 20:09:58 +0800
From:   "Maoming (maoming, Cloud Infrastructure Service Product Dept.)" 
        <maoming.maoming@huawei.com>
To:     Hugh Dickins <hughd@google.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIFYzXSB2ZmlvIGRtYV9tYXAvdW5tYXA6IG9wdGltaXpl?=
 =?gb2312?Q?d_for_hugetlbfs_pages?=
Thread-Topic: [PATCH V3] vfio dma_map/unmap: optimized for hugetlbfs pages
Thread-Index: AQHWfR1kmRi9Q8RQ4keHVlEcbZc2qalRRsGAgAIMtzA=
Date:   Tue, 1 Sep 2020 12:09:58 +0000
Message-ID: <8B561EC9A4D13649A62CF60D3A8E8CB28C2DC466@dggeml524-mbx.china.huawei.com>
References: <20200828092649.853-1-maoming.maoming@huawei.com>
 <alpine.LSU.2.11.2008302332330.2382@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.2008302332330.2382@eggly.anvils>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.151.129]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPiA+IEluIHRoZSBvcmlnaW5hbCBwcm9jZXNzIG9mIGRtYV9tYXAvdW5tYXAgcGFnZXMg
Zm9yIFZGSU8tZGV2aWNlcywgdG8NCj4gPiBtYWtlIHN1cmUgdGhlIHBhZ2VzIGFyZSBjb250aWd1
b3VzLCB3ZSBoYXZlIHRvIGNoZWNrIHRoZW0gb25lIGJ5IG9uZS4NCj4gPiBBcyBhIHJlc3VsdCwg
ZG1hX21hcC91bm1hcCBjb3VsZCBzcGVuZCBhIGxvbmcgdGltZS4NCj4gPiBVc2luZyB0aGUgaHVn
ZXRsYiBwYWdlcywgd2UgY2FuIGF2b2lkIHRoaXMgcHJvYmxlbS4NCj4gPiBBbGwgcGFnZXMgaW4g
aHVnZXRsYiBwYWdlcyBhcmUgY29udGlndW91cy5BbmQgdGhlIGh1Z2V0bGIgcGFnZSBzaG91bGQN
Cj4gPiBub3QgYmUgc3BsaXQuU28gd2UgY2FuIGRlbGV0ZSB0aGUgZm9yIGxvb3BzLg0KPiANCj4g
SSBrbm93IG5vdGhpbmcgYWJvdXQgVkZJTywgYnV0IEknbSBzdXJwcmlzZWQgdGhhdCB5b3UncmUg
cGF5aW5nIHN1Y2ggYXR0ZW50aW9uDQo+IHRvIFBhZ2VIdWdlIGh1Z2V0bGJmcyBwYWdlcywgcmF0
aGVyIHRoYW4gdG8gUGFnZUNvbXBvdW5kDQo+IHBhZ2VzOiB3aGljaCB3b3VsZCBhbHNvIGluY2x1
ZGUgVHJhbnNwYXJlbnQgSHVnZSBQYWdlcywgb2YgdGhlIHRyYWRpdGlvbmFsDQo+IGFub255bW91
cyBraW5kLCBvciB0aGUgaHVnZSB0bXBmcyBraW5kLCBvciB0aGUgbW9yZSBnZW5lcmFsIChub3Qg
bmVjZXNzYXJpbHkNCj4gcG1kLXNpemVkKSBraW5kIHRoYXQgTWF0dGhldyBXaWxjb3ggaXMgY3Vy
cmVudGx5IHdvcmtpbmcgb24uDQo+IA0KPiBJdCdzIHRydWUgdGhhdCBodWdldGxiZnMgaXMgcGVj
dWxpYXIgZW5vdWdoIHRoYXQgd2hhdGV2ZXIgeW91IHdyaXRlIGZvciBpdCBtYXkNCj4gbmVlZCBz
b21lIHR3ZWFrcyB0byBjb3ZlciB0aGUgVEhQIGNhc2UgdG9vLCBvciB2aWNlIHZlcnNhOyBidXQg
d291bGRuJ3QgeW91cg0KPiBwYXRjaCBiZSBhIGxvdCBiZXR0ZXIgZm9yIGNvdmVyaW5nIGFsbCBj
YXNlcz8NCj4gDQo+IFlvdSBtZW50aW9uIGFib3ZlIHRoYXQgInRoZSBodWdldGxiIHBhZ2Ugc2hv
dWxkIG5vdCBiZSBzcGxpdCI6DQo+IHBlcmhhcHMgeW91IGhhdmUgYmVlbiB3b3JyaWVkIHRoYXQg
YSBUSFAgY291bGQgYmUgc3BsaXQgYmVuZWF0aCB5b3U/DQo+IFRoYXQgdXNlZCB0byBiZSBhIHBv
c3NpYmlsaXR5IHNvbWUgeWVhcnMgYWdvLCBidXQgbm93YWRheXMgYSBUSFAgY2Fubm90IGJlDQo+
IHNwbGl0IHdoaWxlIGFueW9uZSBpcyBwaW5uaW5nIGl0IHdpdGggYW4gZXh0cmEgcmVmZXJlbmNl
Lg0KPiANCj4gSHVnaA0KPiANCg0KDQpUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlvbnMuDQpZb3Ug
bWVudGlvbiB0aGF0IGEgVEhQIGNhbm5vdCBiZSBzcGxpdCB3aGlsZSBhbnlvbmUgaXMgcGlubmlu
ZyBpdC4NCkRvIHlvdSBtZWFuIHRoZSBjaGVjayBvZiBjYW5fc3BsaXRfaHVnZV9wYWdlKCkoaW4g
c3BsaXRfaHVnZV9wYWdlX3RvX2xpc3QoKSk/DQpXaGVuIHdlIHdhbnQgdG8gcGluIHBhZ2VzLCB2
ZmlvX3Bpbl9wYWdlc19yZW1vdGUoKSBhbHdheXMgZ2V0cyBhIG5vcm1hbCBwYWdlIGZpcnN0Lg0K
SW4gdGhpcyBjYXNlLCBhIFRIUCBjYW5ub3QgYmUgc3BsaXQgYmVjYXVzZSBvZiB0aGUgaW5jcmVh
c2VkIHJlZmVyZW5jZS4NCklzIHRoaXMgcmlnaHQ/DQoNCk1heWJlIEkgY2FuIG9wdGltaXplIGZv
ciBodWdldGxiIHBhZ2VzIGFzIGEgZmlyc3Qgc3RlcCwgYW5kIHRoZW4gY292ZXIgYWxsIGNvbXBv
dW5kIHBhZ2VzLg0KDQoNCg0KDQoNCg==
