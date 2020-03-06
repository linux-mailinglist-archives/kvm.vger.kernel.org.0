Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6670B17B459
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCFCRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:17:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:3412 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbgCFCRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:17:13 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 067305A2E4406AC0004C;
        Fri,  6 Mar 2020 10:17:09 +0800 (CST)
Received: from dggeme702-chm.china.huawei.com (10.1.199.98) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Mar 2020 10:17:08 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Mar 2020 10:17:08 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 6 Mar 2020 10:17:08 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro
 ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
Thread-Topic: [PATCH] KVM: VMX: Use wrapper macro
 ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
Thread-Index: AdXzXJ/0DM6VN2+tTIaJSCGff/rcKw==
Date:   Fri, 6 Mar 2020 02:17:08 +0000
Message-ID: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com>
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

UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+T24gMDUvMDMvMjAg
MDM6MzUsIGxpbm1pYW9oZSB3cm90ZToNCj4+IChYODZfRUZMQUdTX0lPUEwgfCBYODZfRUZMQUdT
X1ZNKSBpbmRpY2F0ZXMgdGhlIGVmbGFnIGJpdHMgdGhhdCBjYW4gDQo+PiBub3QgYmUgb3duZWQg
YnkgcmVhbG1vZGUgZ3Vlc3QsIGkuZS4gflJNT0RFX0dVRVNUX09XTkVEX0VGTEFHU19CSVRTLg0K
Pg0KPi4uLiBidXQgflJNT0RFX0dVRVNUX09XTkVEX0VGTEFHU19CSVRTIGlzIHRoZSBiaXRzIHRo
YXQgYXJlIG93bmVkIGJ5IHRoZSBob3N0OyB0aGV5IGNvdWxkIGJlIDAgb3IgMSBhbmQgdGhhdCdz
IHdoeSB0aGUgY29kZSB3YXMgdXNpbmcgWDg2X0VGTEFHU19JT1BMIHwgWDg2X0VGTEFHU19WTS4N
Cj4NCj5JIHVuZGVyc3RhbmQgd2hlcmUgflJNT0RFX0dVRVNUX09XTkVEX0VGTEFHU19CSVRTIGlz
IGJldHRlciB0aGFuIFg4Nl9FRkxBR1NfSU9QTCB8IFg4Nl9FRkxBR1NfVk0sIGJ1dCBJIGNhbm5v
dCB0aGluayBvZiBhIHdheSB0byBleHByZXNzIGl0IHRoYXQgaXMgdGhlIGJlc3Qgb2YgYm90aCB3
b3JsZHMuDQo+DQoNCkRlZmluZSBhIG1hY3JvIFJNT0RFX0hPU1RfT1dORURfRUZMQUdTX0JJVFMg
Zm9yIChYODZfRUZMQUdTX0lPUEwgfCBYODZfRUZMQUdTX1ZNKSBhcyBzdWdnZXN0ZWQgYnkgVml0
YWx5IHNlZW1zIGEgZ29vZCB3YXkgdG8gZml4IHRoaXMgPyBUaGFua3MuDQoNCg==
