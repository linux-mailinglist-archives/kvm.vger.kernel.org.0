Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB1954C0CF
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 06:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiFOEhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 00:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiFOEhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 00:37:12 -0400
X-Greylist: delayed 947 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 21:37:10 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E62B27FFF
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 21:37:10 -0700 (PDT)
Received: from BJHW-Mail-Ex08.internal.baidu.com (unknown [10.127.64.18])
        by Forcepoint Email with ESMTPS id 89628443559C07418D0D;
        Wed, 15 Jun 2022 12:21:20 +0800 (CST)
Received: from bjkjy-mail-ex26.internal.baidu.com (172.31.50.42) by
 BJHW-Mail-Ex08.internal.baidu.com (10.127.64.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 15 Jun 2022 12:21:21 +0800
Received: from BC-Mail-Ex25.internal.baidu.com (172.31.51.19) by
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.18; Wed, 15 Jun 2022 12:21:21 +0800
Received: from BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) by
 BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) with mapi id 15.01.2308.020;
 Wed, 15 Jun 2022 12:21:21 +0800
From:   "Wang,Guangju" <wangguangju@baidu.com>
To:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.co" <dave.hansen@linux.intel.co>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.orga" <linux-kernel@vger.kernel.orga>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IHg4NjogYWRkIGEgYm9vbCB2YXJpYWJsZSB0?=
 =?gb2312?Q?o_distinguish_whether_to_use_PVIPI?=
Thread-Topic: [PATCH] KVM: x86: add a bool variable to distinguish whether to
 use PVIPI
Thread-Index: AQHYfyPr/9L7okltJU2kC54bFkCPZK1NDlYAgAChdACAAMV9AIAABh+AgAFi4vA=
Date:   Wed, 15 Jun 2022 04:21:21 +0000
Message-ID: <aa618267a02c4ca9b10d75b5035b92d0@baidu.com>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
 <YqdxAFhkeLjvi7L5@google.com> <20220614025434.GA15042@gao-cwp>
 <YqieGua0ouUePWol@google.com> <20220614150319.GA13174@gao-cwp>
In-Reply-To: <20220614150319.GA13174@gao-cwp>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.190]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex08_2022-06-15 12:21:21:956
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pk9uIE1vbiwgSnVuIDEzLCAyMDIyIGF0IDA1OjE2OjQ4UE0gKzAwMDAsIFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gd3JvdGU6DQo+PlRoZSBzaG9ydGxvZyBpcyBub3QgYXQgYWxsIGhlbHBmdWwsIGl0IGRv
ZXNuJ3Qgc2F5IGFueXRoaW5nIGFib3V0IHdoYXQgDQo+PmFjdHVhbCBmdW5jdGlvbmFsIGNoYW5n
ZS4NCj4+DQo+PiAgS1ZNOiB4ODY6IERvbid0IGFkdmVydGlzZSBQViBJUEkgdG8gdXNlcnNwYWNl
IGlmIElQSXMgYXJlIHZpcnR1YWxpemVkDQo+Pg0KPj5PbiBNb24sIEp1biAxMywgMjAyMiwgd2Fu
Z2d1YW5nanUgd3JvdGU6DQo+Pj4gQ29tbWl0IGQ1ODhiYjliZTFkYSAoIktWTTogVk1YOiBlbmFi
bGUgSVBJIHZpcnR1YWxpemF0aW9uIikgZW5hYmxlIA0KPj4gPklQSSB2aXJ0dWFsaXphdGlvbiBp
biBJbnRlbCBTUFIgcGxhdGZvcm0uVGhlcmUgaXMgbm8gcG9pbnQgaW4gdXNpbmcgDQo+PiA+UFZJ
UEkgaWYgSVBJdiBpcyBzdXBwb3J0ZWQsIGl0IGRvZXNuJ3Qgd29yayBsZXNzIGdvb2Qgd2l0aCBQ
VklQSSB0aGFuIA0KPj4gPndpdGhvdXQgaXQuDQo+Pj4gDQo+PiA+U28gYWRkIGEgYm9vbCB2YXJp
YWJsZSB0byBkaXN0aW5ndWlzaCB3aGV0aGVyIHRvIHVzZSBQVklQSS4NCj4+DQo+PlNpbWlsYXIg
Y29tcGxhaW50IHdpdGggdGhlIGNoYW5nZWxvZywgaXQgZG9lc24ndCBhY3R1YWxseSBjYWxsIG91
dCB3aHkgDQo+PlBWIElQSXMgYXJlIHVud2FudGVkLg0KPj4NCj4+ICBEb24ndCBhZHZlcnRpc2Ug
UFYgSVBJIHN1cHBvcnQgdG8gdXNlcnNwYWNlIGlmIElQSSB2aXJ0dWFsaXphdGlvbiBpcyAgDQo+
ID5zdXBwb3J0ZWQgYnkgdGhlIENQVS4gIEhhcmR3YXJlIHZpcnR1YWxpemF0aW9uIG9mIElQSXMg
bW9yZSBwZXJmb3JtYW50ICANCj4gPmFzIHNlbmRlcnMgZG8gbm90IG5lZWQgdG8gZXhpdC4NCg0K
PlBWSVBJIGlzIG1haW5seSBbKl0gZm9yIHNlbmRpbmcgbXVsdGktY2FzdCBJUElzLiBJbnRlbCBJ
UEkgdmlydHVhbGl6YXRpb24gY2FuIHZpcnR1YWxpemUgb25seSB1bmktY2FzdCBJUElzLiBUaGVp
ciB1c2UgY2FzZXMgZG9uJ3Qgb3ZlcmxhcC4gU28sIEkgZG9uJ3QgdGhpbmsgaXQgbWFrZXMgc2Vu
c2UgdG8gZGlzYWJsZSBQVklQSSBpZiBpbnRlbCBJUEkgdmlydHVhbGl6YXRpb24gaXMgc3VwcG9y
dGVkLg0KQSBxdWVzdGlvbiwgbGlrZSB4MmFwaWMgbW9kZSwgZ3Vlc3QgdXNlcyBQVklQSSB3aXRo
IHJlcGxhY2UgYXBpYy0+c2VuZF9JUElfbWFzayB0byBrdm1fc2VuZF9pcGlfbWFzay4gVGhlIG9y
aWdpbmFsIGZ1bmN0aW9uIGltcGxlbWVudGF0aW9uIGlzIF9feDJhcGljX3NlbmRfSVBJX21hc2sg
LCBhbmQgaXQgcG9sbCBlYWNoIENQVSB0byBzZW5kIElQSS4gU28gaW4gdGhpcyBjYXNlIA0KSW50
ZWwgdmlydHVhbGl6YXRpb24gY2FuIG5vdCB3b3JrPyBUaGFua3MuDQoNCnN0YXRpYyB2b2lkDQpf
X3gyYXBpY19zZW5kX0lQSV9tYXNrKGNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNrLCBpbnQgdmVj
dG9yLCBpbnQgYXBpY19kZXN0KQ0Kew0KCXVuc2lnbmVkIGxvbmcgcXVlcnlfY3B1Ow0KCXVuc2ln
bmVkIGxvbmcgdGhpc19jcHU7DQoJdW5zaWduZWQgbG9uZyBmbGFnczsNCg0KCS8qIHgyYXBpYyBN
U1JzIGFyZSBzcGVjaWFsIGFuZCBuZWVkIGEgc3BlY2lhbCBmZW5jZTogKi8NCgl3ZWFrX3dybXNy
X2ZlbmNlKCk7DQoNCglsb2NhbF9pcnFfc2F2ZShmbGFncyk7DQoNCgl0aGlzX2NwdSA9IHNtcF9w
cm9jZXNzb3JfaWQoKTsNCglmb3JfZWFjaF9jcHUocXVlcnlfY3B1LCBtYXNrKSB7DQoJCWlmIChh
cGljX2Rlc3QgPT0gQVBJQ19ERVNUX0FMTEJVVCAmJiB0aGlzX2NwdSA9PSBxdWVyeV9jcHUpDQoJ
CQljb250aW51ZTsNCgkJX194MmFwaWNfc2VuZF9JUElfZGVzdChwZXJfY3B1KHg4Nl9jcHVfdG9f
YXBpY2lkLCBxdWVyeV9jcHUpLA0KCQkJCSAgICAgICB2ZWN0b3IsIEFQSUNfREVTVF9QSFlTSUNB
TCk7DQoJfQ0KCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCn0NCg==
