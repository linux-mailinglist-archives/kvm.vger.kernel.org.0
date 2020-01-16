Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DD213D624
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgAPIvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:51:09 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2927 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731326AbgAPIvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 03:51:07 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id DA255764A2E338198254;
        Thu, 16 Jan 2020 16:51:03 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 16:51:03 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 16 Jan 2020 16:51:03 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 16 Jan 2020 16:51:03 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: Adding 'else' to reduce checking.
Thread-Topic: [PATCH] KVM: Adding 'else' to reduce checking.
Thread-Index: AdXMSW9HbPEI3mwRZ0ulzm8GsLwwxQ==
Date:   Thu, 16 Jan 2020 08:51:02 +0000
Message-ID: <c889c5a718514fdbbc386c696a237e6e@huawei.com>
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

SGk6DQpIYWl3ZWkgTGkgPGxpaGFpd2VpLmtlcm5lbEBnbWFpbC5jb20+IHdyaXRlczoNCj4gRnJv
bSA0ZTE5NDM2Njc5YTk3ZTNjZWU3M2I0YWU2MTNmZjkxNTgwYzcyMWQyIE1vbiBTZXAgMTcgMDA6
MDA6MDAgMjAwMQ0KPiBGcm9tOiBIYWl3ZWkgTGkgPGxpaGFpd2VpQHRlbmNlbnQuY29tPg0KPiBE
YXRlOiBUaHUsIDE2IEphbiAyMDIwIDEzOjUxOjAzICswODAwDQo+IFN1YmplY3Q6IFtQQVRDSF0g
QWRkaW5nICdlbHNlJyB0byByZWR1Y2UgY2hlY2tpbmcuDQo+DQo+IFRoZXNlIHR3byBjb25kaXRp
b25zIGFyZSBpbiBjb25mbGljdCwgYWRkaW5nICdlbHNlJyB0byByZWR1Y2UgY2hlY2tpbmcuDQo+
DQo+IFNpZ25lZC1vZmYtYnk6IEhhaXdlaSBMaSA8bGloYWl3ZWlAdGVuY2VudC5jb20+DQo+IC0t
LQ0KPiAgIGFyY2gveDg2L2t2bS9sYXBpYy5jIHwgMiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL2xhcGljLmMgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBpbmRleCA2Nzk2OTJiLi5lZjU4MDJm
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiArKysgYi9hcmNoL3g4Ni9r
dm0vbGFwaWMuYw0KPiBAQCAtMTU3Myw3ICsxNTczLDcgQEAgc3RhdGljIHZvaWQNCj4ga3ZtX2Fw
aWNfaW5qZWN0X3BlbmRpbmdfdGltZXJfaXJxcyhzdHJ1Y3Qga3ZtX2xhcGljICphcGljKQ0KPiAg
ICAgICAgICBrdm1fYXBpY19sb2NhbF9kZWxpdmVyKGFwaWMsIEFQSUNfTFZUVCk7DQo+ICAgICAg
ICAgIGlmIChhcGljX2x2dHRfdHNjZGVhZGxpbmUoYXBpYykpDQo+ICAgICAgICAgICAgICAgICAg
a3RpbWVyLT50c2NkZWFkbGluZSA9IDA7DQo+IC0gICAgICAgaWYgKGFwaWNfbHZ0dF9vbmVzaG90
KGFwaWMpKSB7DQo+ICsgICAgICAgZWxzZSBpZiAoYXBpY19sdnR0X29uZXNob3QoYXBpYykpIHsN
Cj4gICAgICAgICAgICAgICAgICBrdGltZXItPnRzY2RlYWRsaW5lID0gMDsNCj4gICAgICAgICAg
ICAgICAgICBrdGltZXItPnRhcmdldF9leHBpcmF0aW9uID0gMDsNCj4gICAgICAgICAgfQ0KDQpF
eGNlcHQgZm9yIHRoZSBjb2Rpbmcgc3R5bGUgZmlndXJlZCBvdXQgYnkgVml0YWx5LCB0aGlzIHBh
dGNoIGxvb2tzIGZpbmUgZm9yIG1lLiBTbzoNCg0KUmV2aWV3ZWQtYnk6IE1pYW9oZSBMaW4gPGxp
bm1pYW9oZUBodWF3ZWkuY29tPg0K
