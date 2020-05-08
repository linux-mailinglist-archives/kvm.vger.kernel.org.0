Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA01CA08E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgEHCNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:13:45 -0400
Received: from mx21.baidu.com ([220.181.3.85]:46520 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbgEHCNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 22:13:44 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id DBA462D79D7BEB6C9639;
        Fri,  8 May 2020 09:57:43 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Fri, 8 May 2020 09:57:43 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 8 May 2020 09:57:43 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     kbuild test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBbdjRdIEtWTTogWDg2OiBzdXBwb3J0IEFQRVJGL01Q?=
 =?gb2312?Q?ERF_registers?=
Thread-Topic: [PATCH] [v4] KVM: X86: support APERF/MPERF registers
Thread-Index: AQHWI4hA2UL01sCWs0SOXj1gXofOAKibPPeAgAIzWnA=
Date:   Fri, 8 May 2020 01:57:43 +0000
Message-ID: <279090c97595496db37658c4abab1ca4@baidu.com>
References: <1588757115-19754-1-git-send-email-lirongqing@baidu.com>
 <202005070842.JFNeGs0v%lkp@intel.com>
In-Reply-To: <202005070842.JFNeGs0v%lkp@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.9]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-05-08 09:57:43:943
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-05-08
 09:57:43:912
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBIaSBMaSwNCj4gDQo+IFRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoISBQZXJoYXBzIHNvbWV0aGlu
ZyB0byBpbXByb3ZlOg0KPiANCj4gW2F1dG8gYnVpbGQgdGVzdCBXQVJOSU5HIG9uIGt2bS9saW51
eC1uZXh0XSBbYWxzbyBidWlsZCB0ZXN0IFdBUk5JTkcgb24NCj4gbmV4dC0yMDIwMDUwNV0gW2Nh
bm5vdCBhcHBseSB0byB0aXAvYXV0by1sYXRlc3QgbGludXMvbWFzdGVyIGxpbnV4L21hc3Rlcg0K
PiB2NS43LXJjNF0gW2lmIHlvdXIgcGF0Y2ggaXMgYXBwbGllZCB0byB0aGUgd3JvbmcgZ2l0IHRy
ZWUsIHBsZWFzZSBkcm9wIHVzIGEgbm90ZSB0bw0KPiBoZWxwIGltcHJvdmUgdGhlIHN5c3RlbS4g
QlRXLCB3ZSBhbHNvIHN1Z2dlc3QgdG8gdXNlICctLWJhc2UnIG9wdGlvbiB0byBzcGVjaWZ5DQo+
IHRoZSBiYXNlIHRyZWUgaW4gZ2l0IGZvcm1hdC1wYXRjaCwgcGxlYXNlIHNlZQ0KPiBodHRwczov
L3N0YWNrb3ZlcmZsb3cuY29tL2EvMzc0MDY5ODJdDQo+IA0KPiB1cmw6DQo+IGh0dHBzOi8vZ2l0
aHViLmNvbS8wZGF5LWNpL2xpbnV4L2NvbW1pdHMvTGktUm9uZ1FpbmcvS1ZNLVg4Ni1zdXBwb3J0
LUFQRQ0KPiBSRi1NUEVSRi1yZWdpc3RlcnMvMjAyMDA1MDctMDIzMzI3DQo+IGJhc2U6ICAgaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL3ZpcnQva3ZtL2t2bS5naXQgbGludXgtbmV4dA0K
PiBjb25maWc6IHg4Nl82NC1hbGxtb2Rjb25maWcgKGF0dGFjaGVkIGFzIC5jb25maWcpDQo+IGNv
bXBpbGVyOiBnY2MtNyAoVWJ1bnR1IDcuNS4wLTZ1YnVudHUyKSA3LjUuMA0KPiByZXByb2R1Y2U6
DQo+ICAgICAgICAgIyBzYXZlIHRoZSBhdHRhY2hlZCAuY29uZmlnIHRvIGxpbnV4IGJ1aWxkIHRy
ZWUNCj4gICAgICAgICBtYWtlIEFSQ0g9eDg2XzY0DQo+IA0KPiBJZiB5b3UgZml4IHRoZSBpc3N1
ZSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFnIGFzIGFwcHJvcHJpYXRlDQo+IFJlcG9ydGVkLWJ5
OiBrYnVpbGQgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gDQo+IE5vdGU6IGl0IG1heSB3
ZWxsIGJlIGEgRkFMU0Ugd2FybmluZy4gRldJVyB5b3UgYXJlIGF0IGxlYXN0IGF3YXJlIG9mIGl0
IG5vdy4NCj4gaHR0cDovL2djYy5nbnUub3JnL3dpa2kvQmV0dGVyX1VuaW5pdGlhbGl6ZWRfV2Fy
bmluZ3MNCj4gDQo+IEFsbCB3YXJuaW5ncyAobmV3IG9uZXMgcHJlZml4ZWQgYnkgPj4pOg0KPiAN
Cj4gICAgYXJjaC94ODYva3ZtL3g4Ni5jOiBJbiBmdW5jdGlvbiAndmNwdV9lbnRlcl9ndWVzdCc6
DQo+ID4+IGFyY2gveDg2L2t2bS94ODYuYzo4MjE5OjEzOiB3YXJuaW5nOiAnYXBlcmYnIG1heSBi
ZSB1c2VkDQo+ID4+IHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbiBbLVdtYXliZS11bmlu
aXRpYWxpemVkXQ0KPiAgICAgIHU2NCBtcGVyZiwgYXBlcmY7DQo+ICAgICAgICAgICAgICAgICBe
fn5+fg0KPiA+PiBhcmNoL3g4Ni9rdm0veDg2LmM6ODIxOTo2OiB3YXJuaW5nOiAnbXBlcmYnIG1h
eSBiZSB1c2VkIHVuaW5pdGlhbGl6ZWQNCj4gPj4gaW4gdGhpcyBmdW5jdGlvbiBbLVdtYXliZS11
bmluaXRpYWxpemVkXQ0KPiAgICAgIHU2NCBtcGVyZiwgYXBlcmY7DQo+ICAgICAgICAgIF5+fn5+
DQoNCkkgdGhpbmsgdGhpcyBpcyBhIEZBTFNFIHdhcm5pbmcsIHNldCBhbmQgdXNlIG1wZXJmL2Fw
ZXJmIG9ubHkgaWYgZW5hYmxlX2FwZXJmbXBlcmYgaXMgdHJ1ZQ0KDQoNCi1MaQ0K
