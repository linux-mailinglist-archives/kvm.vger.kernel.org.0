Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4015FC49
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 03:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBOCAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 21:00:23 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2997 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727639AbgBOCAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 21:00:22 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id E9C182F6DADF3E965247;
        Sat, 15 Feb 2020 10:00:16 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 15 Feb 2020 10:00:16 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 15 Feb 2020 10:00:16 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 15 Feb 2020 10:00:16 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Add the check and free to avoid unknown errors.
Thread-Topic: [PATCH] KVM: Add the check and free to avoid unknown errors.
Thread-Index: AdXjojDYOXFel9aeTuSYbbuVH1Y8wQ==
Date:   Sat, 15 Feb 2020 02:00:16 +0000
Message-ID: <fdc45fbc0b9c4c38ab539c1abf0f1e4a@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGk6DQpIYWl3ZWkgTGkgPGxpaGFpd2VpLmtlcm5lbEBnbWFpbC5jb20+IHdyb3RlOg0KPiBGcm9t
OiBIYWl3ZWkgTGkgPGxpaGFpd2VpQHRlbmNlbnQuY29tPg0KPg0KPiBJZiAna3ZtX2NyZWF0ZV92
bV9kZWJ1Z2ZzKCknIGZhaWxzIGluICdremFsbG9jKHNpemVvZigqc3RhdF9kYXRhKSwgLi4uKScs
ICdrdm1fZGVzdHJveV92bV9kZWJ1Z2ZzKCknIHdpbGwgYmUgY2FsbGVkIGJ5IHRoZSBmaW5hbCBm
cHV0KGZpbGUpIGluICdrdm1fZGV2X2lvY3RsX2NyZWF0ZV92bSgpJy4NCj4NCj4gQWRkIHRoZSBj
aGVjayBhbmQgZnJlZSB0byBhdm9pZCB1bmtub3duIGVycm9ycy4NCg0KQWRkIHRoZSBjaGVjayBh
bmQgZnJlZT8gQWNjb3JkaW5nIHRvIHRoZSBjb2RlLGl0IHNlZW0gd2hhdCB5b3UgbWVhbiBpcyAi
YWRkIHRoZSBjaGVjayBhZ2FpbnN0IGZyZWUiID8NCiANCj4NCj4gU2lnbmVkLW9mZi1ieTogSGFp
d2VpIExpIDxsaWhhaXdlaUB0ZW5jZW50LmNvbT4NCj4NCj4gICAJaWYgKGt2bS0+ZGVidWdmc19z
dGF0X2RhdGEpIHsNCj4gLQkJZm9yIChpID0gMDsgaSA8IGt2bV9kZWJ1Z2ZzX251bV9lbnRyaWVz
OyBpKyspDQo+ICsJCWZvciAoaSA9IDA7IGkgPCBrdm1fZGVidWdmc19udW1fZW50cmllczsgaSsr
KSB7DQo+ICsJCQlpZiAoIWt2bS0+ZGVidWdmc19zdGF0X2RhdGFbaV0pDQo+ICsJCQkJYnJlYWs7
DQo+ICAgCQkJa2ZyZWUoa3ZtLT5kZWJ1Z2ZzX3N0YXRfZGF0YVtpXSk7DQo+ICsJCX0NCj4gICAJ
CWtmcmVlKGt2bS0+ZGVidWdmc19zdGF0X2RhdGEpOw0KPiAgIAl9DQo+ICAgfQ0KDQpJZiAoIWt2
bS0+ZGVidWdmc19zdGF0X2RhdGFbaV0pIGlzIGNoZWNrZWQgaW4ga2ZyZWUoKSBpbnRlcm5hbC4g
QW5kIGJyZWFrIGVhcmx5IHNlZW1zIGhhdmUgbm8gZGlmZmVyZW50IGVmZmVjdC4NCkNvdWxkIHlv
dSBwbGVhc2UgZXhwbGFpbiB3aGF0IHVua25vd24gZXJyb3JzIG1heSBvY2N1cj8gQW5kIGhvdz8g
VGhhbmtzLg0KDQo=
