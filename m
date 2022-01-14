Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9E48E7CF
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiANJtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:49:13 -0500
Received: from mx24.baidu.com ([111.206.215.185]:52610 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229785AbiANJtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 04:49:13 -0500
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 8738C8A6672F1B599D0C;
        Fri, 14 Jan 2022 17:49:05 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:49:05 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Fri, 14 Jan 2022 17:49:05 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogeDg2OiBmaXgga3ZtX3ZjcHVfaXNfcHJl?=
 =?utf-8?Q?empted?=
Thread-Topic: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Thread-Index: AQHYCG09V2TCiAy6TkSx5H613fhU46xiRciQ
Date:   Fri, 14 Jan 2022 09:49:05 +0000
Message-ID: <6a03be7b0e444a1d84e27103e1235f2e@baidu.com>
References: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
 <57e8ee6e-e332-990c-2f4f-1767374b637b@redhat.com>
In-Reply-To: <57e8ee6e-e332-990c-2f4f-1767374b637b@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiBUaGUgY29tYmluYXRpb24gb2YgUFJFRU1Q
VEVEPTAsRkxVU0hfVExCPTEgaXMgaW52YWxpZCBhbmQgY2FuIG9ubHkNCj4gaGFwcGVucyBpZiB0
aGUgZ3Vlc3QgbWFsZnVuY3Rpb25zICh3aGljaCBpdCBkb2Vzbid0LCBpdCB1c2VzIGNtcHhjaGcg
dG8gc2V0DQo+IEtWTV9WQ1BVX1BSRUVNUFRFRCk7IHRoZSBob3N0IG9ubHkgZG9lcyBhbiB4Y2hn
IHdpdGggMCBhcyB0aGUgbmV3IHZhbHVlLg0KPiBTaW5jZSB0aGlzIGlzIGd1ZXN0IGNvZGUsIHRo
aXMgcGF0Y2ggZG9lcyBub3QgY2hhbmdlIGFuIGFjdHVhbCBlcnJvciBpbiB0aGUgY29kZSwNCj4g
ZG9lcyBpdD8NCj4gDQoNCllvdSBhcmUgcmlnaHQsIHRoaXMgaXMgbm90IGEgaXNzdWUgaW4gcHJh
Y3RpY2UgDQpUaGFua3MNCg0KLUxpDQo=
