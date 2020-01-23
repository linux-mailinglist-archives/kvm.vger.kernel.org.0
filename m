Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7851464AB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 10:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAWJge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 04:36:34 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:45680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbgAWJgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 04:36:33 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 58B8F9300ED82D6FD96C;
        Thu, 23 Jan 2020 17:36:31 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jan 2020 17:36:30 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 23 Jan 2020 17:36:30 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 23 Jan 2020 17:36:30 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
Thread-Topic: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
Thread-Index: AdXRz6RAoVCeZerqGEOd3DyH2pYaqQ==
Date:   Thu, 23 Jan 2020 09:36:30 +0000
Message-ID: <a3eb519e5831459db1c926776ad97cca@huawei.com>
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

UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IE9uIDIzLzAxLzIw
IDA5OjU1LCBWaXRhbHkgS3V6bmV0c292IHdyb3RlOg0KPiA+IFlvdXIgcGF0Y2ggc2VlbXMgdG8g
ZG8gdGhlIHJpZ2h0IHRoaW5nLCBob3dldmVyLCBJIHN0YXJ0ZWQgd29uZGVyaW5nIA0KPiA+IGlm
DQo+ID4gV0FSTl9PTl9PTkNFKCkgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvLiBTRE0gc2F5cyB0
aGF0ICJJZiBhbiANCj4gPiB1bnN1cHBvcnRlZCBJTlZWUElEIHR5cGUgaXMgc3BlY2lmaWVkLCB0
aGUgaW5zdHJ1Y3Rpb24gZmFpbHMuIiBhbmQgDQo+ID4gdGhpcyBpcyBzaW1pbGFyIHRvIElOVkVQ
VCBhbmQgSSBkZWNpZGVkIHRvIGNoZWNrIHdoYXQgaGFuZGxlX2ludmVwdCgpIA0KPiA+IGRvZXMu
IFdlbGwsIGl0IGRvZXMgQlVHX09OKCkuDQo+ID4gDQo+ID4gQXJlIHdlIGRvaW5nIHRoZSByaWdo
dCB0aGluZyBpbiBhbnkgb2YgdGhlc2UgY2FzZXM/DQo+DQo+IFllcywgYm90aCBJTlZFUFQgYW5k
IElOVlZQSUQgY2F0Y2ggdGhpcyBlYXJsaWVyLg0KPg0KPiBGb3IgSU5WRVBUOg0KPg0KPiAgICAg
ICAgIHR5cGVzID0gKHZteC0+bmVzdGVkLm1zcnMuZXB0X2NhcHMgPj4gVk1YX0VQVF9FWFRFTlRf
U0hJRlQpICYgNjsNCj4NCj4gICAgICAgICBpZiAodHlwZSA+PSAzMiB8fCAhKHR5cGVzICYgKDEg
PDwgdHlwZSkpKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIG5lc3RlZF92bXhfZmFpbFZhbGlk
KHZjcHUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgVk1YRVJSX0lOVkFMSURf
T1BFUkFORF9UT19JTlZFUFRfSU5WVlBJRCk7DQo+DQo+DQo+DQo+IEZvciBJTlZWUElEOg0KPg0K
PiAgICAgICAgIHR5cGVzID0gKHZteC0+bmVzdGVkLm1zcnMudnBpZF9jYXBzICYNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgVk1YX1ZQSURfRVhURU5UX1NVUFBPUlRFRF9NQVNLKSA+PiA4Ow0K
Pg0KPiAgICAgICAgIGlmICh0eXBlID49IDMyIHx8ICEodHlwZXMgJiAoMSA8PCB0eXBlKSkpDQo+
ICAgICAgICAgICAgICAgICByZXR1cm4gbmVzdGVkX3ZteF9mYWlsVmFsaWQodmNwdSwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgVk1YRVJSX0lOVkFMSURfT1BFUkFORF9UT19JTlZFUFRfSU5W
VlBJRCk7DQo+DQo+IFNvIEknbSBsZWFuaW5nIHRvd2FyZHMgbm90IGFwcGx5aW5nIE1pYW9oZSdz
IHBhdGNoLiAgSGFwcHkgTW91c2UgWWVhciB0byBldmVyeW9uZSwgaGVyZSBpcyBhbiBBU0NJSSBh
cnQgKGV4Y2VwdCBmb3Igb25lIFVuaWNvZGUgY2hhcmFjdGVyKSBtb3VzZToNCj4NCj4NCj4gICAg
ICAgIF9fKCkoKQ0KPiAgICAgICAvICAgICBvKQ0KPiAgIH5+fn5cXyxfXyxfPsKwDQo+DQo+IFRo
YW5rcywNCg0KWWVzLCBpdCBzZWVtcyBteSBwYXRjaCBpcyBtZWFuaW5nbGVzcy4gQW5kIHRoYW5r
cyBmb3IgYm90aCBvZiB5b3VyIHJldmlldyBhbmQgcmVwbHkuDQpIYXBweSBNb3VzZSBZZWFyIGFu
ZCBJIGNhdGNoIGEgbWlja2V5IG1vdXNlOg0KDQogICAjIyMjIyMjIyMjIw0KICAjIyMjIyMjIyMj
IyMjIyMgICAgICAgIF9fLS0tLS1fXyAgICAgICAgICAjIw0KIyMjIyMjIyMjIyMjIyMjIyMjICAg
ICMjIyAgICAgICAgICBcICAgICAgICMjIyMNCiMjIyMjIyMjIyMjIyMjIyMjIyAjIyMjICMgICAg
ICAgICAgICBcICAgICAjICMjDQogIyMjIyMjIyMjIyMjIyMjIyMjIyMgICAgICAgICAgICBcfn5c
ICBcICAgLCMjIiwNCiAgIyMjIyMjIyMjIyMjIyMjIyMgICAgICAgL35+XCAgICBcIyMgXCAgXCIg
ICAgIDoNCiAgICAjIyMjIyMjIyMjIyMjIyMgICAgICAgXCAgICBcICAgXCMjIiAvICAgICAgIDoN
CiAgICAgICAgICAgICAgIyMjIyMjIyAgICAgICBcIyMjIFwgICAgLyAgICAgICAgIDoNCiAgICAg
ICAgICAgICAgIyMjIyMjIyMjIyMjIyAgXCMjIy8gICAgICAgICAgICAgOg0KICAgICAgICAgICAg
ICAgIyMjIyMjIyMgICAgICAgICAgICAgICAgICAgICAgIDoNCiAgICAgICAgICAgICAgICAjIyMj
IyMgICBfXyAgICAgICAgICAgICAgICAgIDoNCiAgICAgICAgICAgICAgICAgIyMjIyAgIC9cICAg
ICAgICAgICAgICAgICAgLw0KICAgICAgIyMjIyMjIyMjIyMjICMjIyAgICBcXF9fX19fX19fX19f
X19fL3wNCiAgICAjIyMjIyMjIyMjIyMjIyMjIyMgICAgIFwgX18gICAgICAgICAvIC8NCiAgIyMj
IyMjIyMjIyMjIyMjIyMjIyNcX18gICAgXCAgXC0tLVwsLyAvDQogICMjIyMjIyMjIyMjIyMjIyMj
IyMgICAgXCAgICAgXF9fX19fLyAvDQogICAjIyMjIyMjIyMjIyMjIyMjIyAgICAgICBcX19fX19f
X19fLw0KICAgICMjIyMjIyMjIyMjIyMjIw0KICAgICAgIyMjIyMjIyMjIyMNCg0KVGhhbmtzIGJv
dGggYWdhaW4uDQo=
