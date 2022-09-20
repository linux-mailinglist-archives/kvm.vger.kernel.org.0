Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3EC5BDBCD
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiITEur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiITEuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:50:44 -0400
X-Greylist: delayed 342 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Sep 2022 21:50:22 PDT
Received: from mail10.tencent.com (mail10.tencent.com [14.18.183.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A9D3E75E
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:50:22 -0700 (PDT)
Received: from EX-SZ021.tencent.com (unknown [10.28.6.73])
        by mail10.tencent.com (Postfix) with ESMTP id 11379D4907;
        Tue, 20 Sep 2022 12:44:38 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1663649078;
        bh=ZyARqJMFdysKk8MYGVUFgQsHULKhbzQIIkgr8sNCSgA=;
        h=From:To:CC:Subject:Date;
        b=LMZ87klsmKD64XwCGOUcSO5SHjCPoilE9ttbJWUjNYppDGS6S/Jipvx9gUZOPlo/4
         KcGJw7SU3GoAd68QymYsw+eGdIoI1pCGZybUsRLy0BE1ke2TEu33HjANBwbnhqA39A
         8Bgf/Do4JzqBGvrlGE75CDYHm54k9ZcV6vFfz224=
Received: from EX-SZ045.tencent.com (10.28.6.96) by EX-SZ021.tencent.com
 (10.28.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Sep
 2022 12:44:37 +0800
Received: from EX-SZ049.tencent.com (10.28.6.102) by EX-SZ045.tencent.com
 (10.28.6.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 20 Sep
 2022 12:44:37 +0800
Received: from EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7]) by
 EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7%8]) with mapi id
 15.01.2242.008; Tue, 20 Sep 2022 12:44:37 +0800
From:   =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] kvm: mmu: fix typos in struct kvm_arch
Thread-Topic: [RESEND PATCH] kvm: mmu: fix typos in struct kvm_arch
Thread-Index: AQHYzKuvOes+0LB2n0mt06s9Fk30YQ==
Date:   Tue, 20 Sep 2022 04:44:37 +0000
Message-ID: <6DB576D7-C37D-4D11-95BF-DB23522FA8ED@tencent.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.48.13]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D1FCB50A8AEDB458733501A3A281CAF@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tm8gJ2t2bXBfbW11X3BhZ2VzJywgaXQgc2hvdWxkIGJlICdrdm1fbW11X3BhZ2UnLiBBbmQNCnN0
cnVjdCBrdm1fbW11X3BhZ2VzIGFuZCBzdHJ1Y3Qga3ZtX21tdV9wYWdlIGFyZSBkaWZmZXJlbnQg
c3RydWN0dXJlcywNCmhlcmUgc2hvdWxkIGJlIGt2bV9tbXVfcGFnZS4NCmt2bV9tbXVfcGFnZXMg
aXMgZGVmaW5lZCBpbiBhcmNoL3g4Ni9rdm0vbW11L21tdS5jLg0KDQpTdWdnZXN0ZWQtYnk6IERh
dmlkIE1hdGxhY2sgPGRtYXRsYWNrQGdvb2dsZS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBQZW5nIEhh
byA8Zmx5aW5ncGVuZ0B0ZW5jZW50LmNvbT4NClJldmlld2VkLWJ5OiBEYXZpZCBNYXRsYWNrIDxk
bWF0bGFja0Bnb29nbGUuY29tPg0KLS0tDQogYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aCB8IDEyICsrKysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KaW5kZXggZTgyODFkNjRhNDMx
Li5lNjdiMmY2MDJmYjIgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQpAQCAtMTI3Miw4ICsx
MjcyLDggQEAgc3RydWN0IGt2bV9hcmNoIHsNCiAgICAgICAgYm9vbCB0ZHBfbW11X2VuYWJsZWQ7
DQoNCiAgICAgICAgLyoNCi0gICAgICAgICogTGlzdCBvZiBzdHJ1Y3Qga3ZtX21tdV9wYWdlcyBi
ZWluZyB1c2VkIGFzIHJvb3RzLg0KLSAgICAgICAgKiBBbGwgc3RydWN0IGt2bV9tbXVfcGFnZXMg
aW4gdGhlIGxpc3Qgc2hvdWxkIGhhdmUNCisgICAgICAgICogTGlzdCBvZiBrdm1fbW11X3BhZ2Ug
c3RydWN0cyBiZWluZyB1c2VkIGFzIHJvb3RzLg0KKyAgICAgICAgKiBBbGwga3ZtX21tdV9wYWdl
IHN0cnVjdHMgaW4gdGhlIGxpc3Qgc2hvdWxkIGhhdmUNCiAgICAgICAgICogdGRwX21tdV9wYWdl
IHNldC4NCiAgICAgICAgICoNCiAgICAgICAgICogRm9yIHJlYWRzLCB0aGlzIGxpc3QgaXMgcHJv
dGVjdGVkIGJ5Og0KQEAgLTEyOTIsOCArMTI5Miw4IEBAIHN0cnVjdCBrdm1fYXJjaCB7DQogICAg
ICAgIHN0cnVjdCBsaXN0X2hlYWQgdGRwX21tdV9yb290czsNCg0KICAgICAgICAvKg0KLSAgICAg
ICAgKiBMaXN0IG9mIHN0cnVjdCBrdm1wX21tdV9wYWdlcyBub3QgYmVpbmcgdXNlZCBhcyByb290
cy4NCi0gICAgICAgICogQWxsIHN0cnVjdCBrdm1fbW11X3BhZ2VzIGluIHRoZSBsaXN0IHNob3Vs
ZCBoYXZlDQorICAgICAgICAqIExpc3Qgb2Yga3ZtX21tdV9wYWdlIHN0cnVjdHMgbm90IGJlaW5n
IHVzZWQgYXMgcm9vdHMuDQorICAgICAgICAqIEFsbCBrdm1fbW11X3BhZ2Ugc3RydWN0cyBpbiB0
aGUgbGlzdCBzaG91bGQgaGF2ZQ0KICAgICAgICAgKiB0ZHBfbW11X3BhZ2Ugc2V0IGFuZCBhIHRk
cF9tbXVfcm9vdF9jb3VudCBvZiAwLg0KICAgICAgICAgKi8NCiAgICAgICAgc3RydWN0IGxpc3Rf
aGVhZCB0ZHBfbW11X3BhZ2VzOw0KQEAgLTEzMDMsOSArMTMwMyw5IEBAIHN0cnVjdCBrdm1fYXJj
aCB7DQogICAgICAgICAqIGlzIGhlbGQgaW4gcmVhZCBtb2RlOg0KICAgICAgICAgKiAgLSB0ZHBf
bW11X3Jvb3RzIChhYm92ZSkNCiAgICAgICAgICogIC0gdGRwX21tdV9wYWdlcyAoYWJvdmUpDQot
ICAgICAgICAqICAtIHRoZSBsaW5rIGZpZWxkIG9mIHN0cnVjdCBrdm1fbW11X3BhZ2VzIHVzZWQg
YnkgdGhlIFREUCBNTVUNCisgICAgICAgICogIC0gdGhlIGxpbmsgZmllbGQgb2Yga3ZtX21tdV9w
YWdlIHN0cnVjdHMgdXNlZCBieSB0aGUgVERQIE1NVQ0KICAgICAgICAgKiAgLSBscGFnZV9kaXNh
bGxvd2VkX21tdV9wYWdlcw0KLSAgICAgICAgKiAgLSB0aGUgbHBhZ2VfZGlzYWxsb3dlZF9saW5r
IGZpZWxkIG9mIHN0cnVjdCBrdm1fbW11X3BhZ2VzIHVzZWQNCisgICAgICAgICogIC0gdGhlIGxw
YWdlX2Rpc2FsbG93ZWRfbGluayBmaWVsZCBvZiBrdm1fbW11X3BhZ2Ugc3RydWN0cyB1c2VkDQog
ICAgICAgICAqICAgIGJ5IHRoZSBURFAgTU1VDQogICAgICAgICAqIEl0IGlzIGFjY2VwdGFibGUs
IGJ1dCBub3QgbmVjZXNzYXJ5LCB0byBhY3F1aXJlIHRoaXMgbG9jayB3aGVuDQogICAgICAgICAq
IHRoZSB0aHJlYWQgaG9sZHMgdGhlIE1NVSBsb2NrIGluIHdyaXRlIG1vZGUuDQotLQ0KMi4yNy4w
DQoNCg==
