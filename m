Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA173467073
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 04:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378353AbhLCDHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 22:07:02 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15690 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbhLCDHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 22:07:01 -0500
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J4yJ42NjvzZdNW;
        Fri,  3 Dec 2021 11:00:52 +0800 (CST)
Received: from dggpemm100005.china.huawei.com (7.185.36.231) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:03:36 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpemm100005.china.huawei.com (7.185.36.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:03:35 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Fri, 3 Dec 2021 11:03:35 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "cornelia.huck@de.ibm.com" <cornelia.huck@de.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH] kvm/eventfd: fix the misleading comment in
 kvm_irqfd_assign
Thread-Topic: [PATCH] kvm/eventfd: fix the misleading comment in
 kvm_irqfd_assign
Thread-Index: AQHX5NNH1Leb7fxkY0SkUYfU1jQEjawaOSSAgAXTy/A=
Date:   Fri, 3 Dec 2021 03:03:35 +0000
Message-ID: <5c5f0f0982df4fc6a858f8e095c4eaa5@huawei.com>
References: <20211129034328.1604-1-longpeng2@huawei.com>
 <c6b7c933-2d48-1504-7c45-110b0ab317ad@linux.ibm.com>
In-Reply-To: <c6b7c933-2d48-1504-7c45-110b0ab317ad@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXN0aWFuIEJvcm50
cmFlZ2VyIFttYWlsdG86Ym9ybnRyYWVnZXJAbGludXguaWJtLmNvbV0NCj4gU2VudDogVHVlc2Rh
eSwgTm92ZW1iZXIgMzAsIDIwMjEgMToxNCBBTQ0KPiBUbzogTG9uZ3BlbmcgKE1pa2UsIENsb3Vk
IEluZnJhc3RydWN0dXJlIFNlcnZpY2UgUHJvZHVjdCBEZXB0LikNCj4gPGxvbmdwZW5nMkBodWF3
ZWkuY29tPjsgcGJvbnppbmlAcmVkaGF0LmNvbQ0KPiBDYzogY29ybmVsaWEuaHVja0BkZS5pYm0u
Y29tOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBHb25nbGVpIChBcmVpKSA8YXJlaS5nb25nbGVpQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0hdIGt2bS9ldmVudGZkOiBmaXggdGhlIG1pc2xlYWRpbmcgY29tbWVudCBpbiBrdm1f
aXJxZmRfYXNzaWduDQo+IA0KPiANCj4gDQo+IEFtIDI5LjExLjIxIHVtIDA0OjQzIHNjaHJpZWIg
TG9uZ3BlbmcoTWlrZSk6DQo+ID4gRnJvbTogTG9uZ3BlbmcgPGxvbmdwZW5nMkBodWF3ZWkuY29t
Pg0KPiA+DQo+ID4gVGhlIGNvbW1lbnQgYWJvdmUgdGhlIGludm9jYXRpb24gb2YgdmZzX3BvbGwo
KSBpcyBtaXNsZWFkaW5nLCBtb3ZlDQo+ID4gaXQgdG8gdGhlIHJpZ2h0IHBsYWNlLg0KPiA+DQo+
IEkgdGhpbmsgdGhhdCB0aGUgY3VycmVudCB2YXJpYW50IGlzIGJldHRlci4NCj4gZXZlbnRzIGlz
IG9ubHkgdXNlZCBpbiB0aGF0IGZ1bmN0aW9uIHRvIGNoZWNrIGZvciBFUE9MTElOLCBzbyB0aGUN
Cj4gYXNzaWdubWVudCBhbmQgdGhlIGlmIGJlbG9uZyB0b2dldGhlciBmcm9tIGEgIndoYXQgYW0g
SSBkb2luZyBoZXJlIiBwZXJzcGVjdGl2ZS4NCj4gDQoNCkhpIENocmlzdGlhbiwNCg0KSSB0aGlu
ayB0aGF0IGFkZCB0aGUgaXJxZmQtPndhaXQgdG8gdGhlIGZpbGUncyB3YWl0IHF1ZXVlIGlzIG11
Y2ggbW9yZQ0KaW1wb3J0YW50LCB0aGUgY3VycmVudCB2YXJpYW50IG1heSBsZWFkIHRvIGlnbm9y
aW5nIGl0Lg0KDQpCb3RoIG9mIHRoZXNlIHR3byB2YXJpYW50cyBhcmUgc3VwcG9ydGVkIGluIHRo
ZSBjdXJyZW50IGtlcm5lbDoNCg0KWzFdIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4
L2xhdGVzdC9zb3VyY2UvZHJpdmVycy92ZmlvL3ZpcnFmZC5jI0wxNjkNCmBgYA0KCWV2ZW50cyA9
IHZmc19wb2xsKGlycWZkLmZpbGUsICZ2aXJxZmQtPnB0KTsNCg0KCS8qDQoJICogQ2hlY2sgaWYg
dGhlcmUgd2FzIGFuIGV2ZW50IGFscmVhZHkgcGVuZGluZyBvbiB0aGUgZXZlbnRmZA0KCSAqIGJl
Zm9yZSB3ZSByZWdpc3RlcmVkIGFuZCB0cmlnZ2VyIGl0IGFzIGlmIHdlIGRpZG4ndCBtaXNzIGl0
Lg0KCSAqLw0KCWlmIChldmVudHMgJiBFUE9MTElOKSB7DQoJCWlmICgoIWhhbmRsZXIgfHwgaGFu
ZGxlcihvcGFxdWUsIGRhdGEpKSAmJiB0aHJlYWQpDQoJCQlzY2hlZHVsZV93b3JrKCZ2aXJxZmQt
PmluamVjdCk7DQoJfQ0KYGBgDQoNClsyXSBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51
eC9sYXRlc3Qvc291cmNlL2RyaXZlcnMvdmlydC9hY3JuL2lycWZkLmMjTDE2MQ0KYGBgDQoJLyog
Q2hlY2sgdGhlIHBlbmRpbmcgZXZlbnQgaW4gdGhpcyBzdGFnZSAqLw0KCWV2ZW50cyA9IHZmc19w
b2xsKGYuZmlsZSwgJmlycWZkLT5wdCk7DQoNCglpZiAoZXZlbnRzICYgRVBPTExJTikNCgkJYWNy
bl9pcnFmZF9pbmplY3QoaXJxZmQpOw0KYGBgDQoNClNpbmNlIHRoZXJlJ3Mgbm8gYW55IGNvZGUg
Y2hhbmdlcywgSSBhZ3JlZSB0byBkcm9wIHRoaXMgdW5tZWFuaW5nIGNoYW5nZS4NCg0KVGhhbmtz
Lg0KDQo+ID4gRml4ZXM6IDY4NGEwYjcxOWRkYiAoIktWTTogZXZlbnRmZDogRml4IGxvY2sgb3Jk
ZXIgaW52ZXJzaW9uIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBMb25ncGVuZyA8bG9uZ3BlbmcyQGh1
YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gICB2aXJ0L2t2bS9ldmVudGZkLmMgfCA0ICsrLS0NCj4g
PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vZXZlbnRmZC5jIGIvdmlydC9rdm0vZXZlbnRmZC5j
DQo+ID4gaW5kZXggMmFkMDEzYi4uY2QwMTgxNCAxMDA2NDQNCj4gPiAtLS0gYS92aXJ0L2t2bS9l
dmVudGZkLmMNCj4gPiArKysgYi92aXJ0L2t2bS9ldmVudGZkLmMNCj4gPiBAQCAtNDA2LDEyICs0
MDYsMTIgQEAgYm9vbCBfX2F0dHJpYnV0ZV9fKCh3ZWFrKSkNCj4ga3ZtX2FyY2hfaXJxZmRfcm91
dGVfY2hhbmdlZCgNCj4gPg0KPiA+ICAgCXNwaW5fdW5sb2NrX2lycSgma3ZtLT5pcnFmZHMubG9j
ayk7DQo+ID4NCj4gPiArCWV2ZW50cyA9IHZmc19wb2xsKGYuZmlsZSwgJmlycWZkLT5wdCk7DQo+
ID4gKw0KPiA+ICAgCS8qDQo+ID4gICAJICogQ2hlY2sgaWYgdGhlcmUgd2FzIGFuIGV2ZW50IGFs
cmVhZHkgcGVuZGluZyBvbiB0aGUgZXZlbnRmZA0KPiA+ICAgCSAqIGJlZm9yZSB3ZSByZWdpc3Rl
cmVkLCBhbmQgdHJpZ2dlciBpdCBhcyBpZiB3ZSBkaWRuJ3QgbWlzcyBpdC4NCj4gPiAgIAkgKi8N
Cj4gPiAtCWV2ZW50cyA9IHZmc19wb2xsKGYuZmlsZSwgJmlycWZkLT5wdCk7DQo+ID4gLQ0KPiA+
ICAgCWlmIChldmVudHMgJiBFUE9MTElOKQ0KPiA+ICAgCQlzY2hlZHVsZV93b3JrKCZpcnFmZC0+
aW5qZWN0KTsNCj4gPg0K
