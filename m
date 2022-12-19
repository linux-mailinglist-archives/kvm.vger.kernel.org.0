Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C703B6507F2
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiLSHE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLSHE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:04:58 -0500
Received: from hmat.qianxin.com (hmat.qianxin.com [220.181.41.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596D7E33;
        Sun, 18 Dec 2022 23:04:51 -0800 (PST)
Received: from hmat.qianxin.com (srv-mail04.esg.360es.cn [172.24.6.24])
        by hmat.qianxin.com (SkyGuard) with ESMTPS id 4Nb9gZ4ltxz2LZwN;
        Mon, 19 Dec 2022 15:04:42 +0800 (CST)
Received: from qax-bjmail04.ESG.360ES.CN (10.44.121.98) by
 SRV-MAIL06.ESG.360ES.CN (172.24.6.26) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Mon, 19 Dec 2022 15:04:27 +0800
Received: from qax-bjmail06.ESG.360ES.CN
 (2402:d040:0:8425:2849:52e7:3abe:7096) by qax-bjmail04.ESG.360ES.CN
 (2402:d040:0:8425:e8d8:c276:4bf1:2b8c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 19 Dec 2022 15:04:27 +0800
Received: from qax-bjmail06.ESG.360ES.CN ([fe80::2849:52e7:3abe:7096]) by
 qax-bjmail06.ESG.360ES.CN ([fe80::2849:52e7:3abe:7096%5]) with mapi id
 15.01.2308.020; Mon, 19 Dec 2022 15:04:27 +0800
From:   =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Subject: =?utf-8?B?562U5aSNOiBGb3VuZCBhIG1lbW9yeSBsZWFrIGluIGt2bSBtb2R1bGU=?=
Thread-Topic: Found a memory leak in kvm module
Thread-Index: AdkN1svXVRrWKvJvSge7YI3WbO6bxgCl5kaAAMJGbkA=
Date:   Mon, 19 Dec 2022 07:04:27 +0000
Message-ID: <2895069420eb4af3a3b3a949af4010f3@qianxin.com>
References: <7144ff750e554ad28aaa59e98c36d4fc@qianxin.com>
 <Y5tkpxOiDoF0X/On@google.com>
In-Reply-To: <Y5tkpxOiDoF0X/On@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.110.119.69]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBoYWQgdHJpZWQgdG8gcmV0ZXN0IHdpdGggeW91ciBwYXRjaCxhbmQgSSB0aGluayB0aGUgbWVt
b3J5IGxlYWsgd2FzIHJlc29sdmVkIGJ5IGl0Lg0KVGhhbmtzIQ0KDQotLS0tLemCruS7tuWOn+S7
ti0tLS0tDQrlj5Hku7bkuro6IFNlYW4gQ2hyaXN0b3BoZXJzb24gW21haWx0bzpzZWFuamNAZ29v
Z2xlLmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjLlubQxMuaciDE25pelIDI6MTcNCuaUtuS7tuS6
ujog5p+z6I+B5bOwIDxsaXVqaW5nZmVuZ0BxaWFueGluLmNvbT4NCuaKhOmAgTogbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0
LmNvbTsgc3l6a2FsbGVyQGdvb2dsZWdyb3Vwcy5jb20NCuS4u+mimDogUmU6IEZvdW5kIGEgbWVt
b3J5IGxlYWsgaW4ga3ZtIG1vZHVsZQ0KDQpPbiBNb24sIERlYyAxMiwgMjAyMiwg5p+z6I+B5bOw
IHdyb3RlOg0KPiBIZWxsbyxJIGhhdmUgZm91bmQgYSBtZW1vcnkgbGVhayBidWcgaW4ga3ZtIG1v
ZHVsZSBieSBzeXprYWxsZXIuSXQgd2FzIA0KPiBmb3VuZCBpbiBsaW51eC01LjQgYnV0IGl0IGFs
c28gY291bGQgYmUgcmVwcm9kdWNlZCBpbiB0aGUgbGF0ZXN0IGxpbnV4IHZlcnNpb24uDQoNCkFo
LCBJIGFzc3VtZSBieSAibGludXgtNS40IiB5b3UgbWVhbiAic3RhYmxlIHY1LjQueCBrZXJuZWxz
IHRoYXQgY29udGFpbiBjb21taXQNCjdkMWJjMzJkNjQ3NyAoIktWTTogU3RvcCBsb29raW5nIGZv
ciBjb2FsZXNjZWQgTU1JTyB6b25lcyBpZiB0aGUgYnVzIGlzIGRlc3Ryb3llZCIpIiwgYmVjYXVz
ZSB3aXRob3V0IHRoYXQgZml4IEkgY2FuJ3Qgc2VlIGFueSBidWcgdGhhdCB3b3VsZCBhZmZlY3Qg
Ym90aCA1LjQgYW5kIHRoZSB1cHN0cmVhbSBrZXJuZWwuDQoNCklmIG15IGFzc3VtcHRpb24gaXMg
Y29ycmVjdCwgdGhlbiBJJ20gOTklIGNlcnRhaW4gdGhlIGlzc3VlIGlzIHRoYXQgdGhlIHRhcmdl
dCBkZXZpY2UgaXNuJ3QgZGVzdHJveWVkIGlmIGFsbG9jYXRpbmcgdGhlIG5ldyBidXMgZmFpbHMu
ICBJIGhhdmVuJ3QgaGFkIGx1Y2sgd2l0aCB0aGUgYXV0b21hdGljIGZhdWx0IGluamVjdGlvbiwg
YnV0IHdhcyBhYmxlIHRvIGNvbmZpcm0gYSBsZWFrIHdpdGggdGhpcyBoYWNrLg0KDQpkaWZmIC0t
Z2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMgaW5kZXggMTNl
ODgyOTdmOTk5Li4yMmQ5YWIxYjVjMjUgMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5j
DQorKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jDQpAQCAtNTQyNCw3ICs1NDI0LDcgQEAgaW50IGt2
bV9pb19idXNfdW5yZWdpc3Rlcl9kZXYoc3RydWN0IGt2bSAqa3ZtLCBlbnVtIGt2bV9idXMgYnVz
X2lkeCwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBrdm1faW9fZGV2aWNl
ICpkZXYpICB7DQogICAgICAgIGludCBpLCBqOw0KLSAgICAgICBzdHJ1Y3Qga3ZtX2lvX2J1cyAq
bmV3X2J1cywgKmJ1czsNCisgICAgICAgc3RydWN0IGt2bV9pb19idXMgKm5ld19idXMgPSBOVUxM
LCAqYnVzOw0KIA0KICAgICAgICBsb2NrZGVwX2Fzc2VydF9oZWxkKCZrdm0tPnNsb3RzX2xvY2sp
Ow0KIA0KQEAgLTU0NDEsNiArNTQ0MSw3IEBAIGludCBrdm1faW9fYnVzX3VucmVnaXN0ZXJfZGV2
KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsDQogICAgICAgIGlmIChpID09
IGJ1cy0+ZGV2X2NvdW50KQ0KICAgICAgICAgICAgICAgIHJldHVybiAwOw0KIA0KKyAgICAgICBp
ZiAoIUlTX0VOQUJMRUQoQ09ORklHX1g4Nl82NCkpDQogICAgICAgIG5ld19idXMgPSBrbWFsbG9j
KHN0cnVjdF9zaXplKGJ1cywgcmFuZ2UsIGJ1cy0+ZGV2X2NvdW50IC0gMSksDQogICAgICAgICAg
ICAgICAgICAgICAgICAgIEdGUF9LRVJORUxfQUNDT1VOVCk7DQogICAgICAgIGlmIChuZXdfYnVz
KSB7DQoNCg0KVGhlIGZpeCBpcyB0byBkZXN0cm95IHRoZSB0YXJnZXQgZGV2aWNlIGJlZm9yZSBi
YWlsaW5nLiAgSSdsbCBzZW5kIGEgcHJvcGVyIHBhdGNoIGVpdGhlciB3YXksIGJ1dCBpdCB3b3Vs
ZCBiZSBuaWNlIHRvIGdldCBjb25maXJtYXRpb24gdGhhdCB0aGlzIGlzIHRoZSBzYW1lIGJ1ZyB0
aGF0IHlvdSBoaXQgd2l0aCAibGludXgtNS40Ii4NCg0KVGhhbmtzIQ0KDQotLS0NCiB2aXJ0L2t2
bS9jb2FsZXNjZWRfbW1pby5jIHwgOCArKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9jb2FsZXNj
ZWRfbW1pby5jIGIvdmlydC9rdm0vY29hbGVzY2VkX21taW8uYyBpbmRleCAwYmU4MGMyMTNmN2Yu
LjVlZjg4ZjVhMDg2NCAxMDA2NDQNCi0tLSBhL3ZpcnQva3ZtL2NvYWxlc2NlZF9tbWlvLmMNCisr
KyBiL3ZpcnQva3ZtL2NvYWxlc2NlZF9tbWlvLmMNCkBAIC0xODcsMTUgKzE4NywxNyBAQCBpbnQg
a3ZtX3ZtX2lvY3RsX3VucmVnaXN0ZXJfY29hbGVzY2VkX21taW8oc3RydWN0IGt2bSAqa3ZtLA0K
IAkJCXIgPSBrdm1faW9fYnVzX3VucmVnaXN0ZXJfZGV2KGt2bSwNCiAJCQkJem9uZS0+cGlvID8g
S1ZNX1BJT19CVVMgOiBLVk1fTU1JT19CVVMsICZkZXYtPmRldik7DQogDQorCQkJa3ZtX2lvZGV2
aWNlX2Rlc3RydWN0b3IoJmRldi0+ZGV2KTsNCisNCiAJCQkvKg0KIAkJCSAqIE9uIGZhaWx1cmUs
IHVucmVnaXN0ZXIgZGVzdHJveXMgYWxsIGRldmljZXMgb24gdGhlDQogCQkJICogYnVzIF9leGNl
cHRfIHRoZSB0YXJnZXQgZGV2aWNlLCBpLmUuIGNvYWxlc2NlZF96b25lcw0KLQkJCSAqIGhhcyBi
ZWVuIG1vZGlmaWVkLiAgTm8gbmVlZCB0byByZXN0YXJ0IHRoZSB3YWxrIGFzDQotCQkJICogdGhl
cmUgYXJlbid0IGFueSB6b25lcyBsZWZ0Lg0KKwkJCSAqIGhhcyBiZWVuIG1vZGlmaWVkLiAgQmFp
bCBhZnRlciBkZXN0cm95aW5nIHRoZSB0YXJnZXQNCisJCQkgKiBkZXZpY2UsIHRoZXJlJ3Mgbm8g
bmVlZCB0byByZXN0YXJ0IHRoZSB3YWxrIGFzIHRoZXJlDQorCQkJICogYXJlbid0IGFueSB6b25l
cyBsZWZ0Lg0KIAkJCSAqLw0KIAkJCWlmIChyKQ0KIAkJCQlicmVhazsNCi0JCQlrdm1faW9kZXZp
Y2VfZGVzdHJ1Y3RvcigmZGV2LT5kZXYpOw0KIAkJfQ0KIAl9DQogDQoNCmJhc2UtY29tbWl0OiAw
ZjMwYjI1ZWRlYTQ4NDMzZWIzMjQ0ODk5MDU1NzM2NDQzNjgxOGU2DQotLSANCg==
