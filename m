Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1854A455E52
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhKROj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:39:26 -0500
Received: from mx22.baidu.com ([220.181.50.185]:59502 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233318AbhKROjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 09:39:10 -0500
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 6550440438449A9E2B80;
        Thu, 18 Nov 2021 22:35:56 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 18 Nov 2021 22:35:56 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Thu, 18 Nov 2021 22:35:56 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: =?gb2312?B?tPC4tDogW3Y0XVtQQVRDSCAxLzJdIEtWTTogeDg2OiBkb24ndCBwcmludCB3?=
 =?gb2312?Q?hen_fail_to_read/write_pv_eoi_memory?=
Thread-Topic: [v4][PATCH 1/2] KVM: x86: don't print when fail to read/write pv
 eoi memory
Thread-Index: AQHX0XL4zrtJKNgLKkyrgXw0a+QnqKwJcBmA
Date:   Thu, 18 Nov 2021 14:35:55 +0000
Message-ID: <e9948d6b4619420bacee3dd855313c4b@baidu.com>
References: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.27]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGluZw0KDQpUaGFua3MNCg0KLUxpDQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7Iyzog
TGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiC3osvNyrG85DogMjAyMcTqMTHU
wjTI1SAxOTo1Ng0KPiDK1bz+yMs6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHBib256aW5pQHJlZGhh
dC5jb207IHNlYW5qY0Bnb29nbGUuY29tOw0KPiB2a3V6bmV0c0ByZWRoYXQuY29tOyBMaSxSb25n
cWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+Ow0KPiBzdGFibGVAa2VybmVsLm9yZw0KPiDW98zi
OiBbdjRdW1BBVENIIDEvMl0gS1ZNOiB4ODY6IGRvbid0IHByaW50IHdoZW4gZmFpbCB0byByZWFk
L3dyaXRlIHB2IGVvaQ0KPiBtZW1vcnkNCj4gDQo+IElmIGd1ZXN0IGdpdmVzIE1TUl9LVk1fUFZf
RU9JX0VOIGEgd3JvbmcgdmFsdWUsIHRoaXMgcHJpbnRrKCkgd2lsbCBiZSB0cmlnZ2VkLA0KPiBh
bmQga2VybmVsIGxvZyBpcyBzcGFtbWVkIHdpdGggdGhlIHVzZWxlc3MgbWVzc2FnZQ0KPiANCj4g
Rml4ZXM6IDBkODg4MDBkNTQ3MiAoImt2bTogeDg2OiBpb2FwaWMgYW5kIGFwaWMgZGVidWcgbWFj
cm9zIGNsZWFudXAiKQ0KPiBSZXBvcnRlZC1ieTogVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNA
cmVkaGF0LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJl
ZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT4NCj4gQ2M6IHN0YWJsZUBrZXJuZWwub3JnDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL2xh
cGljLmMgfCAgIDE4ICsrKysrKy0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlcyBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS9sYXBpYy5jIGIvYXJjaC94ODYva3ZtL2xhcGljLmMgaW5kZXggZDZhYzMyZi4uNzUyYzQ4
ZQ0KPiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL2xhcGljLmMNCj4gQEAgLTY3NiwzMSArNjc2LDI1IEBAIHN0YXRpYyBpbmxpbmUgYm9v
bCBwdl9lb2lfZW5hYmxlZChzdHJ1Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUpICBzdGF0aWMgYm9vbCBw
dl9lb2lfZ2V0X3BlbmRpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KSAgew0KPiAgCXU4IHZhbDsN
Cj4gLQlpZiAocHZfZW9pX2dldF91c2VyKHZjcHUsICZ2YWwpIDwgMCkgew0KPiAtCQlwcmludGso
S0VSTl9XQVJOSU5HICJDYW4ndCByZWFkIEVPSSBNU1IgdmFsdWU6IDB4JWxseFxuIiwNCj4gLQkJ
CSAgICh1bnNpZ25lZCBsb25nIGxvbmcpdmNwdS0+YXJjaC5wdl9lb2kubXNyX3ZhbCk7DQo+ICsJ
aWYgKHB2X2VvaV9nZXRfdXNlcih2Y3B1LCAmdmFsKSA8IDApDQo+ICAJCXJldHVybiBmYWxzZTsN
Cj4gLQl9DQo+ICsNCj4gIAlyZXR1cm4gdmFsICYgS1ZNX1BWX0VPSV9FTkFCTEVEOw0KPiAgfQ0K
PiANCj4gIHN0YXRpYyB2b2lkIHB2X2VvaV9zZXRfcGVuZGluZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpICB7DQo+IC0JaWYgKHB2X2VvaV9wdXRfdXNlcih2Y3B1LCBLVk1fUFZfRU9JX0VOQUJMRUQp
IDwgMCkgew0KPiAtCQlwcmludGsoS0VSTl9XQVJOSU5HICJDYW4ndCBzZXQgRU9JIE1TUiB2YWx1
ZTogMHglbGx4XG4iLA0KPiAtCQkJICAgKHVuc2lnbmVkIGxvbmcgbG9uZyl2Y3B1LT5hcmNoLnB2
X2VvaS5tc3JfdmFsKTsNCj4gKwlpZiAocHZfZW9pX3B1dF91c2VyKHZjcHUsIEtWTV9QVl9FT0lf
RU5BQkxFRCkgPCAwKQ0KPiAgCQlyZXR1cm47DQo+IC0JfQ0KPiArDQo+ICAJX19zZXRfYml0KEtW
TV9BUElDX1BWX0VPSV9QRU5ESU5HLCAmdmNwdS0+YXJjaC5hcGljX2F0dGVudGlvbik7ICB9DQo+
IA0KPiAgc3RhdGljIHZvaWQgcHZfZW9pX2Nscl9wZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkgIHsNCj4gLQlpZiAocHZfZW9pX3B1dF91c2VyKHZjcHUsIEtWTV9QVl9FT0lfRElTQUJMRUQp
IDwgMCkgew0KPiAtCQlwcmludGsoS0VSTl9XQVJOSU5HICJDYW4ndCBjbGVhciBFT0kgTVNSIHZh
bHVlOiAweCVsbHhcbiIsDQo+IC0JCQkgICAodW5zaWduZWQgbG9uZyBsb25nKXZjcHUtPmFyY2gu
cHZfZW9pLm1zcl92YWwpOw0KPiArCWlmIChwdl9lb2lfcHV0X3VzZXIodmNwdSwgS1ZNX1BWX0VP
SV9ESVNBQkxFRCkgPCAwKQ0KPiAgCQlyZXR1cm47DQo+IC0JfQ0KPiArDQo+ICAJX19jbGVhcl9i
aXQoS1ZNX0FQSUNfUFZfRU9JX1BFTkRJTkcsDQo+ICZ2Y3B1LT5hcmNoLmFwaWNfYXR0ZW50aW9u
KTsgIH0NCj4gDQo+IC0tDQo+IDEuNy4xDQoNCg==
