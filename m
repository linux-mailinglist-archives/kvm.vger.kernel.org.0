Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139F24C3BBC
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 03:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiBYC2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 21:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiBYC2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 21:28:13 -0500
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A81871045AD
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 18:27:41 -0800 (PST)
Received: from BJHW-MAIL-EX04.internal.baidu.com (unknown [10.127.64.14])
        by Forcepoint Email with ESMTPS id 02C51943DD9D64290285;
        Fri, 25 Feb 2022 10:27:40 +0800 (CST)
Received: from bjkjy-mail-ex28.internal.baidu.com (172.31.50.44) by
 BJHW-MAIL-EX04.internal.baidu.com (10.127.64.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 25 Feb 2022 10:27:39 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 bjkjy-mail-ex28.internal.baidu.com (172.31.50.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.18; Fri, 25 Feb 2022 10:27:39 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Fri, 25 Feb 2022 10:27:39 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "Yuan,Zhaoxiong" <yuanzhaoxiong@baidu.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHYyXSBLVk06IFg4NjogSW50cm9kdWNlIHZmaW9faW50?=
 =?gb2312?Q?r=5Fstat_per-vm_debugfs_file?=
Thread-Topic: [PATCH v2] KVM: X86: Introduce vfio_intr_stat per-vm debugfs
 file
Thread-Index: AQHYHOkI+uIUeNYELkivTLhX/eeXu6yjpHMw
Date:   Fri, 25 Feb 2022 02:27:39 +0000
Message-ID: <dd872a587e874576900bec770d244ad7@baidu.com>
References: <1644324020-17639-1-git-send-email-yuanzhaoxiong@baidu.com>
In-Reply-To: <1644324020-17639-1-git-send-email-yuanzhaoxiong@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.205.248]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiDW98ziOiBbUEFUQ0ggdjJdIEtWTTogWDg2OiBJbnRyb2R1Y2UgdmZpb19pbnRyX3N0YXQgcGVy
LXZtIGRlYnVnZnMgZmlsZQ0KPiANCj4gVXNlIHRoaXMgZmlsZSB0byBleHBvcnQgY29ycmVzcG9u
ZGVuY2UgYmV0d2VlbiBndWVzdF9pcnEsIGhvc3RfaXJxLCB2ZWN0b3IgYW5kDQo+IHZjcHUgYmVs
b25naW5nIHRvIFZGSU8gcGFzc3Rocm91Z2ggZGV2aWNlcy4NCj4gDQo+IEFuIGV4YW1wbGUgb3V0
cHV0IG9mIHRoaXMgbG9va3MgbGlrZSAoYSB2bSB3aXRoIFZGSU8gcGFzc3Rocm91Z2gNCj4gZGV2
aWNlcyk6DQo+ICAgIGd1ZXN0X2lycSAgICAgaG9zdF9pcnEgICAgICAgdmVjdG9yICAgICAgICAg
dmNwdQ0KPiAgICAgICAgICAgMjQgICAgICAgICAgMjAxICAgICAgICAgICAzNyAgICAgICAgICAg
IDgNCj4gICAgICAgICAgIDI1ICAgICAgICAgIDIwMiAgICAgICAgICAgMzUgICAgICAgICAgIDI1
DQo+ICAgICAgICAgICAyNiAgICAgICAgICAyMDMgICAgICAgICAgIDM1ICAgICAgICAgICAyMA0K
PiAgICAuLi4uLi4NCj4gDQo+IFdoZW4gYSBWTSBoYXMgVkZJTyBwYXNzdGhyb3VnaCBkZXZpY2Vz
LCB0aGUgY29ycmVzcG9uZGVuY2UgYmV0d2Vlbg0KPiBndWVzdF9pcnEsIGhvc3RfaXJxLCB2ZWN0
b3IgYW5kIHZjcHUgbWF5IG5lZWQgdG8gYmUga25vd24gZXNwZWNpYWxseSBpbiBBTUQNCj4gcGxh
dGZvcm0gd2l0aCBhdmljIGRpc2FibGVkLiBUaGUgQU1EIGF2aWMgaXMgZGlzYWJsZWQsIGFuZCB0
aGUgcGFzc3Rocm91Z2gNCj4gZGV2aWNlcyBtYXkgY2F1c2UgdmNwdSB2bSBleGl0IHR3aWNlIGZv
ciBhIGludGVycnVwdC4NCj4gT25lIGV4dHJlcm5hbCBpbnRlcnJ1cHQgY2F1c2VkIGJ5IHZmaW8g
aG9zdCBpcnEsIG90aGVyIGlwaSB0byBpbmplY3QgYSBpbnRlcnJ1cHQgdG8NCj4gdm0uDQo+IA0K
PiBJZiB0aGUgc3lzdGVtIGFkbWluaXN0cmF0b3Iga25vd24gdGhlc2UgaW5mb3JtYXRpb24sIHNl
dCB2ZmlvIGhvc3QgaXJxIGFmZmluaXR5IHRvDQo+IFBjcHUgd2hpY2ggdGhlIGNvcnJlc3BvbmRl
Y2UgZ3Vlc3QgaXJxIGFmZmluaXRlZCB2Y3B1LCB0byBhdm9pZCBleHRyYSB2bSBleGl0Lg0KPiAN
Cj4gQ28tZGV2ZWxvcGVkLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogWXVhbiBaaGFvWGlvbmcgPHl1YW56aGFveGlvbmdAYmFpZHUuY29tPg0KPiAt
LS0NCg0KUGluZw0KDQpUaGFua3MNCg0KLUxpDQo=
