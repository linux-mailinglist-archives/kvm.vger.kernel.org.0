Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191971EDCF0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgFDGJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:09:44 -0400
Received: from mx22.baidu.com ([220.181.50.185]:37906 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbgFDGJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:09:44 -0400
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 07A3E72BA719D212B263;
        Thu,  4 Jun 2020 14:09:31 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 4 Jun 2020 14:09:30 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 4 Jun 2020 14:09:25 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
        "wei.huang2@amd.com" <wei.huang2@amd.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF1bdjVdIEtWTTogWDg2OiBzdXBwb3J0?=
 =?utf-8?Q?_APERF/MPERF_registers?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Y1XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Index: AQHWNjvN8r9nufprD0OWRxID181WWai/6tGAgAGIe0D//4JRgIAHCw/A
Date:   Thu, 4 Jun 2020 06:09:25 +0000
Message-ID: <aa1bd610bf8d4bb5a626cd5dd6af17d3@baidu.com>
References: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
 <3f931ecf-7f1c-c178-d18c-46beadd1d313@intel.com>
 <e7ccee7dc30e4d1e8dcb8a002d6a6ed2@baidu.com>
 <9c870a06-ee46-5c9d-11c0-602aeb18c83d@intel.com>
In-Reply-To: <9c870a06-ee46-5c9d-11c0-602aeb18c83d@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.10]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex16_2020-06-04 14:09:30:838
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJTU8sIElmIHdlIHJlYWxseSB3YW50IHRvIGVuc3VyZSB0aGUgY29ycmVjdG5lc3Mgb2YgdXNl
cnNwYWNlIHByb3ZpZGVkIENQVUlEDQo+IHNldHRpbmdzLCB3ZSBuZWVkIHRvIHJldHVybiBFUlJP
UiB0byB1c2Vyc3BhY2UgaW5zdGVhZCBvZiBmaXhpbmcgaXQgc2lsaWVudGx5Lg0KPiANCg0KT2sg
LCBJIHdpbGwgbWFrZSBpdCByZXR1cm4gYSBlcnJvcg0KDQpUaGFua3MNCg0KLUxpDQoNCg0KPiAt
IFhpYW95YW8NCg==
