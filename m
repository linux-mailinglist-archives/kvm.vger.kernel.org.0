Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7691659FF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 10:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgBTJSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 04:18:38 -0500
Received: from mx21.baidu.com ([220.181.3.85]:44128 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbgBTJSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 04:18:38 -0500
X-Greylist: delayed 1857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2020 04:18:34 EST
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 6299E3CC4DF0E1EDB5B5;
        Thu, 20 Feb 2020 16:31:33 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 20 Feb 2020 16:31:32 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 20 Feb 2020 16:31:32 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     linmiaohe <linmiaohe@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVtyZXNlbmRdIEtWTTogZml4IGVycm9yIGhhbmRsaW5n?=
 =?gb2312?B?IGluIHN2bV9jcHVfaW5pdA==?=
Thread-Topic: [PATCH][resend] KVM: fix error handling in svm_cpu_init
Thread-Index: AdXnxCuvQCn2ngYdSyKWLfuyXd13zwAA6TeA
Date:   Thu, 20 Feb 2020 08:31:32 +0000
Message-ID: <4d0b722be5cc4343a9fc9557dfbd00a1@baidu.com>
References: <4cf5d767b570430a9e0b515a9d6d8fbd@huawei.com>
In-Reply-To: <4cf5d767b570430a9e0b515a9d6d8fbd@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.156.28]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-02-20 16:31:33:229
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-02-20
 16:31:33:198
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogbGlubWlhb2hlIFttYWlsdG86bGlu
bWlhb2hlQGh1YXdlaS5jb21dDQo+ILeiy83KsbzkOiAyMDIwxOoy1MIyMMjVIDE2OjE4DQo+IMrV
vP7IyzogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsgcGJvbnppbmlAcmVkaGF0
LmNvbTsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbQ0KPiCzrcvNOiBMaXJhbiBBbG9uIDxsaXJhbi5h
bG9uQG9yYWNsZS5jb20+OyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyB4ODZAa2VybmVsLm9yZw0KPiDW98ziOiBSZTogW1BBVENIXVtyZXNlbmRd
IEtWTTogZml4IGVycm9yIGhhbmRsaW5nIGluIHN2bV9jcHVfaW5pdA0KPiANCj4gSGksDQo+IExp
IFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4gd3JpdGVzOg0KPiA+DQo+ID5zZC0+c2F2
ZV9hcmVhIHNob3VsZCBiZSBmcmVlZCBpbiBlcnJvciBwYXRoDQo+ID4NCj4gPkZpeGVzOiA3MGNk
OTRlNjBjNzMzICgiS1ZNOiBTVk06IFZNUlVOIHNob3VsZCB1c2UgYXNzb2NpYXRlZCBBU0lEIHdo
ZW4NCj4gPlNFViBpcyBlbmFibGVkIikNCj4gPlNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxs
aXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPlJldmlld2VkLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlq
ZXNoLnNpbmdoQGFtZC5jb20+DQo+ID5SZXZpZXdlZC1ieTogVml0YWx5IEt1em5ldHNvdiA8dmt1
em5ldHNAcmVkaGF0LmNvbT4NCj4gPi0tLQ0KPiA+IGFyY2gveDg2L2t2bS9zdm0uYyB8IDggKysr
KystLS0NCj4gPiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPiANCj4gT2gsIGl0J3Mgc3RyYW5nZS4gVGhpcyBpcyBhbHJlYWR5IGZpeGVkIGluIG15IHBy
ZXZpb3VzIHBhdGNoIDogW1BBVENIIHYyXSBLVk06DQo+IFNWTTogRml4IHBvdGVudGlhbCBtZW1v
cnkgbGVhayBpbiBzdm1fY3B1X2luaXQoKS4NCj4gQW5kIFZpdGFseSBhbmQgTGlyYW4gZ2F2ZSBt
ZSBSZXZpZXdlZC1ieSB0YWdzIGFuZCBQYW9sbyBxdWV1ZWQgaXQgb25lIG1vbnRoDQo+IGFnby4g
QnV0IEkgY2FuJ3QgZm91bmQgaXQgaW4gbWFzdGVyIG9yIHF1ZXVlIGJyYW5jaC4gVGhlcmUgbWln
aHQgYmUgc29tZXRoaW5nDQo+IHdyb25nLiA6KA0KDQoNCkluIGZhY3QsIEkgc2VuZCB0aGlzIHBh
dGNoIDIwMTkvMDIvLCBhbmQgZ2V0IFJldmlld2VkLWJ5LCAgYnV0IGRpZCBub3QgcXVldWUNCg0K
aHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMDg1Mzk3My8NCg0KYW5kIHJlc2Vu
ZCBpdCAyMDE5LzA3DQoNCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTEwMzIw
ODEvDQoNCg0KLUxpDQoNCg0K
