Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FFB169B91
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 02:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBXBH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 20:07:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2970 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727148AbgBXBH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 20:07:57 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 43B0C58324CD8F3D7D0C;
        Mon, 24 Feb 2020 09:07:55 +0800 (CST)
Received: from DGGEMM421-HUB.china.huawei.com (10.1.198.38) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 24 Feb 2020 09:07:54 +0800
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.45]) by
 dggemm421-hub.china.huawei.com ([10.1.198.38]) with mapi id 14.03.0439.000;
 Mon, 24 Feb 2020 09:07:47 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>
CC:     Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: RE: RFC: Split EPT huge pages in advance of dirty logging
Thread-Topic: RFC: Split EPT huge pages in advance of dirty logging
Thread-Index: AdXmU97BvyK5YKoyS5++my9GnvXVk///1+yA//428yCAA1S3gP/+abuggAMs8gCAAd62AIAAJJ4A//xJ+gA=
Date:   Mon, 24 Feb 2020 01:07:47 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB18354@dggemm508-mbx.china.huawei.com>
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
 <20200218174311.GE1408806@xz-x1>
 <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
 <20200219171919.GA34517@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB03772@DGGEMM528-MBX.china.huawei.com>
 <CANgfPd-P_=GqcMiwLSSkUhZDt42aMLUsCJt+CPdUN5yR3RLHmQ@mail.gmail.com>
 <cd4626a1-44b5-1a62-cf4b-716950a6db1b@google.com>
 <CAM3pwhGF3ABoew5UOd9xUxtm14VN_o0gr+D=KfR3ZEQjmKgUdQ@mail.gmail.com>
In-Reply-To: <CAM3pwhGF3ABoew5UOd9xUxtm14VN_o0gr+D=KfR3ZEQjmKgUdQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgRmVpbmVyIFtt
YWlsdG86cGZlaW5lckBnb29nbGUuY29tXQ0KPiBTZW50OiBTYXR1cmRheSwgRmVicnVhcnkgMjIs
IDIwMjAgODoxOSBBTQ0KPiBUbzogSnVuYWlkIFNoYWhpZCA8anVuYWlkc0Bnb29nbGUuY29tPg0K
PiBDYzogQmVuIEdhcmRvbiA8YmdhcmRvbkBnb29nbGUuY29tPjsgWmhvdWppYW4gKGpheSkNCj4g
PGppYW5qYXkuemhvdUBodWF3ZWkuY29tPjsgUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPjsN
Cj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgcWVtdS1kZXZlbEBub25nbnUub3JnOyBwYm9uemluaUBy
ZWRoYXQuY29tOw0KPiBkZ2lsYmVydEByZWRoYXQuY29tOyBxdWludGVsYUByZWRoYXQuY29tOyBM
aXVqaW5zb25nIChQYXVsKQ0KPiA8bGl1LmppbnNvbmdAaHVhd2VpLmNvbT47IGxpbmZlbmcgKE0p
IDxsaW5mZW5nMjNAaHVhd2VpLmNvbT47IHdhbmd4aW4gKFUpDQo+IDx3YW5neGlueGluLndhbmdA
aHVhd2VpLmNvbT47IEh1YW5nd2VpZG9uZyAoQykNCj4gPHdlaWRvbmcuaHVhbmdAaHVhd2VpLmNv
bT4NCj4gU3ViamVjdDogUmU6IFJGQzogU3BsaXQgRVBUIGh1Z2UgcGFnZXMgaW4gYWR2YW5jZSBv
ZiBkaXJ0eSBsb2dnaW5nDQo+IA0KPiBPbiBGcmksIEZlYiAyMSwgMjAyMCBhdCAyOjA4IFBNIEp1
bmFpZCBTaGFoaWQgPGp1bmFpZHNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiAyLzIw
LzIwIDk6MzQgQU0sIEJlbiBHYXJkb24gd3JvdGU6DQo+ID4gPg0KPiA+ID4gRldJVywgd2UgY3Vy
cmVudGx5IGRvIHRoaXMgZWFnZXIgc3BsaXR0aW5nIGF0IEdvb2dsZSBmb3IgbGl2ZQ0KPiA+ID4g
bWlncmF0aW9uLiBXaGVuIHRoZSBsb2ctZGlydHktbWVtb3J5IGZsYWcgaXMgc2V0IG9uIGEgbWVt
c2xvdCB3ZQ0KPiA+ID4gZWFnZXJseSBzcGxpdCBhbGwgcGFnZXMgaW4gdGhlIHNsb3QgZG93biB0
byA0ayBncmFudWxhcml0eS4NCj4gPiA+IEFzIEpheSBzYWlkLCB0aGlzIGRvZXMgbm90IGNhdXNl
IGNyaXBwbGluZyBsb2NrIGNvbnRlbnRpb24gYmVjYXVzZQ0KPiA+ID4gdGhlIHZDUFUgcGFnZSBm
YXVsdHMgZ2VuZXJhdGVkIGJ5IHdyaXRlIHByb3RlY3Rpb24gLyBzcGxpdHRpbmcgY2FuDQo+ID4g
PiBiZSByZXNvbHZlZCBpbiB0aGUgZmFzdCBwYWdlIGZhdWx0IHBhdGggd2l0aG91dCBhY3F1aXJp
bmcgdGhlIE1NVSBsb2NrLg0KPiA+ID4gSSBiZWxpZXZlICtKdW5haWQgU2hhaGlkIHRyaWVkIHRv
IHVwc3RyZWFtIHRoaXMgYXBwcm9hY2ggYXQgc29tZQ0KPiA+ID4gcG9pbnQgaW4gdGhlIHBhc3Qs
IGJ1dCB0aGUgcGF0Y2ggc2V0IGRpZG4ndCBtYWtlIGl0IGluLiAoVGhpcyB3YXMNCj4gPiA+IGJl
Zm9yZSBteSB0aW1lLCBzbyBJJ20gaG9waW5nIGhlIGhhcyBhIGxpbmsuKSBJIGhhdmVuJ3QgZG9u
ZSB0aGUNCj4gPiA+IGFuYWx5c2lzIHRvIGtub3cgaWYgZWFnZXIgc3BsaXR0aW5nIGlzIG1vcmUg
b3IgbGVzcyBlZmZpY2llbnQgd2l0aA0KPiA+ID4gcGFyYWxsZWwgc2xvdy1wYXRoIHBhZ2UgZmF1
bHRzLCBidXQgaXQncyBkZWZpbml0ZWx5IGZhc3RlciB1bmRlciB0aGUNCj4gPiA+IE1NVSBsb2Nr
Lg0KPiA+ID4NCj4gPg0KPiA+IEkgYW0gbm90IHN1cmUgaWYgd2UgZXZlciBwb3N0ZWQgdGhvc2Ug
cGF0Y2hlcyB1cHN0cmVhbS4gUGV0ZXIgRmVpbmVyIHdvdWxkDQo+IGtub3cgZm9yIHN1cmUuIE9u
ZSBub3RhYmxlIGRpZmZlcmVuY2UgaW4gd2hhdCB3ZSBkbyBjb21wYXJlZCB0byB0aGUgYXBwcm9h
Y2gNCj4gb3V0bGluZWQgYnkgSmF5IGlzIHRoYXQgd2UgZG9uJ3QgcmVseSBvbiB0ZHBfcGFnZV9m
YXVsdCgpIHRvIGRvIHRoZSBzcGxpdHRpbmcuIFNvDQo+IHdlIGRvbid0IGhhdmUgdG8gY3JlYXRl
IGEgZHVtbXkgVkNQVSBhbmQgdGhlIHNwZWNpYWxpemVkIHNwbGl0IGZ1bmN0aW9uIGlzIGFsc28N
Cj4gbXVjaCBmYXN0ZXIuDQoNCkknbSBjdXJpb3VzIGFuZCBpbnRlcmVzdGVkIGluIHRoZSB3YXkg
eW91IGltcGxlbWVudGVkLCBlc3BlY2lhbGx5IHlvdSBtZW50aW9uZWQNCnRoYXQgdGhlIHBlcmZv
cm1hbmNlIGlzIG11Y2ggZmFzdGVyIHdpdGhvdXQgYSBkdW1teSBWQ1BVLg0KDQo+IFdlJ3ZlIGJl
ZW4gY2FycnlpbmcgdGhlc2UgcGF0Y2hlcyBzaW5jZSAyMDE1LiBJJ3ZlIG5ldmVyIHBvc3RlZCB0
aGVtLg0KPiBHZXR0aW5nIHRoZW0gaW4gc2hhcGUgZm9yIHVwc3RyZWFtIGNvbnN1bXB0aW9uIHdp
bGwgdGFrZSBzb21lIHdvcmsuIEkgY2FuDQo+IGxvb2sgaW50byB0aGlzIG5leHQgd2Vlay4NCg0K
SXQgd2lsbCBiZSBuaWNlIGlmIHlvdSdyZSBnb2luZyB0byBwb3N0IGl0IHRvIHRoZSB1cHN0cmVh
bS4NCg0KUmVnYXJkcywNCkpheSBaaG91DQoNCj4gDQo+IFBldGVyDQo=
