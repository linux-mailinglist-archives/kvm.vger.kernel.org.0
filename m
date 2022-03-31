Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC764ED181
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 04:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352450AbiCaCGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 22:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343905AbiCaCG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 22:06:27 -0400
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CE9A31519;
        Wed, 30 Mar 2022 19:04:40 -0700 (PDT)
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 5320F87DF62C4E1BD89F;
        Thu, 31 Mar 2022 10:04:29 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 31 Mar 2022 10:04:29 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Thu, 31 Mar 2022 10:04:28 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: =?gb2312?B?tPC4tDogbGludXgtbmV4dDogbWFudWFsIG1lcmdlIG9mIHRoZSBrdm0gdHJl?=
 =?gb2312?Q?e_with_Linus'_tree?=
Thread-Topic: linux-next: manual merge of the kvm tree with Linus' tree
Thread-Index: AQHYRI/WF84Qva+clk2v/qstzx06eqzYun6g
Date:   Thu, 31 Mar 2022 02:04:28 +0000
Message-ID: <c1f9b1c98be74b43960de6f4f1dd4c62@baidu.com>
References: <20220331104224.665e456b@canb.auug.org.au>
In-Reply-To: <20220331104224.665e456b@canb.auug.org.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.40]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IEhpIGFsbCwNCj4gDQo+IFRvZGF5J3MgbGludXgtbmV4dCBtZXJnZSBvZiB0aGUga3ZtIHRy
ZWUgZ290IGEgY29uZmxpY3QgaW46DQo+IA0KPiAgIGFyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiAN
Cj4gYmV0d2VlbiBjb21taXQ6DQo+IA0KPiAgIGMzYjAzNzkxN2M2YSAoIng4Ni9pYnQscGFyYXZp
cnQ6IFNwcmlua2xlIEVOREJSIikNCj4gDQo+IGZyb20gTGludXMnIHRyZWUgYW5kIGNvbW1pdDoN
Cj4gDQo+ICAgOGM1NjQ5ZTAwZTAwICgiS1ZNOiB4ODY6IFN1cHBvcnQgdGhlIHZDUFUgcHJlZW1w
dGlvbiBjaGVjayB3aXRoDQo+IG5vcHZzcGluIGFuZCByZWFsdGltZSBoaW50IikNCj4gDQo+IGZy
b20gdGhlIGt2bSB0cmVlLg0KPiANCj4gSSBmaXhlZCBpdCB1cCAoc2VlIGJlbG93KSBhbmQgY2Fu
IGNhcnJ5IHRoZSBmaXggYXMgbmVjZXNzYXJ5LiBUaGlzIGlzIG5vdyBmaXhlZCBhcyBmYXINCj4g
YXMgbGludXgtbmV4dCBpcyBjb25jZXJuZWQsIGJ1dCBhbnkgbm9uIHRyaXZpYWwgY29uZmxpY3Rz
IHNob3VsZCBiZSBtZW50aW9uZWQgdG8NCj4geW91ciB1cHN0cmVhbSBtYWludGFpbmVyIHdoZW4g
eW91ciB0cmVlIGlzIHN1Ym1pdHRlZCBmb3IgbWVyZ2luZy4gIFlvdSBtYXkNCj4gYWxzbyB3YW50
IHRvIGNvbnNpZGVyIGNvb3BlcmF0aW5nIHdpdGggdGhlIG1haW50YWluZXIgb2YgdGhlIGNvbmZs
aWN0aW5nIHRyZWUgdG8NCj4gbWluaW1pc2UgYW55IHBhcnRpY3VsYXJseSBjb21wbGV4IGNvbmZs
aWN0cy4NCj4gDQo+IC0tDQo+IENoZWVycywNCj4gU3RlcGhlbiBSb3Rod2VsbA0KPiANCj4gZGlm
ZiAtLWNjIGFyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiBpbmRleCA3OWUwYjhkNjNmZmEsMjE5MzMw
OTVhMTBlLi4wMDAwMDAwMDAwMDANCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2t2bS5jDQo+ICsr
KyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiBAQEAgLTc1Miw2IC03NTIsMzkgKzc1Miw0MCBA
QEAgc3RhdGljIHZvaWQga3ZtX2NyYXNoX3NodXRkb3duKHN0cnVjdCBwDQo+ICAgfQ0KPiAgICNl
bmRpZg0KPiANCj4gKyAjaWZkZWYgQ09ORklHX1g4Nl8zMg0KPiArIF9fdmlzaWJsZSBib29sIF9f
a3ZtX3ZjcHVfaXNfcHJlZW1wdGVkKGxvbmcgY3B1KSB7DQo+ICsgCXN0cnVjdCBrdm1fc3RlYWxf
dGltZSAqc3JjID0gJnBlcl9jcHUoc3RlYWxfdGltZSwgY3B1KTsNCj4gKw0KPiArIAlyZXR1cm4g
ISEoc3JjLT5wcmVlbXB0ZWQgJiBLVk1fVkNQVV9QUkVFTVBURUQpOyB9DQo+ICsgUFZfQ0FMTEVF
X1NBVkVfUkVHU19USFVOSyhfX2t2bV92Y3B1X2lzX3ByZWVtcHRlZCk7DQo+ICsNCj4gKyAjZWxz
ZQ0KPiArDQoNCkkgYW0gc29ycnk7ICBJIHNlZSB2MyBpcyBtZXJnZWQgaW50byBuZXh0LCB0aGlz
IHZlcnNpb24gd2lsbCBjYXVzZSBidWlsZGluZyBmYWlsdXJlLCBsaWtlIHJlcG9ydGVkIGluIA0K
aHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva3ZtL21zZzI3MDYwNy5odG1sDQoNCkkgc2Vu
ZCBhIG5ldyB2ZXJzaW9uDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qva3Zt
L3BhdGNoLzE2NDY4OTE2ODktNTMzNjgtMS1naXQtc2VuZC1lbWFpbC1saXJvbmdxaW5nQGJhaWR1
LmNvbS8NCg0KDQotTGkgDQoNCg==
