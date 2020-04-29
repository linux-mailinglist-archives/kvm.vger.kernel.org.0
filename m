Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9B1BD9A5
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD2KaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:30:17 -0400
Received: from mx21.baidu.com ([220.181.3.85]:58514 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgD2KaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:30:16 -0400
X-Greylist: delayed 2808 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2020 06:30:15 EDT
Received: from BC-Mail-Ex29.internal.baidu.com (unknown [172.31.51.23])
        by Forcepoint Email with ESMTPS id 7F328C5CEAAB4CD37337;
        Wed, 29 Apr 2020 17:43:24 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex29.internal.baidu.com (172.31.51.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Wed, 29 Apr 2020 17:43:24 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Wed, 29 Apr 2020 17:43:24 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVt2Ml0ga3ZtOiB4ODY6IGVtdWxhdGUgQVBFUkYvTVBF?=
 =?gb2312?Q?RF_registers?=
Thread-Topic: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWHgPRaxq7VoyE2kqvmC7wjQtzhaiP0WXQ
Date:   Wed, 29 Apr 2020 09:43:24 +0000
Message-ID: <00904210a2674cc88848061f2a173b65@baidu.com>
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
 <20200429085440.GG13592@hirez.programming.kicks-ass.net>
In-Reply-To: <20200429085440.GG13592@hirez.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.9]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex29_2020-04-29 17:43:24:383
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex29_GRAY_Inside_WithoutAtta_2020-04-29
 17:43:24:367
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gV291bGQgaXQgbWFrZSBzZW5zZSB0byBwcm92aWRlIGEgcGFzcy10aHJvdWdoIEFQRVJG
L01QRVJGIGZvcg0KPiBLVk1fSElOVFNfUkVBTFRJTUUgPyBCZWNhdXNlIHRoYXQgaGludCBndWFy
YW50ZWVzIHdlIGhhdmUgYSAxOjENCj4gdkNQVTpDUFUgYmluZGluZyBhbmQgZ3VhcmFudGVlZCBu
byBvdmVyLWNvbW1pdC4NCg0KTWFrZSBzZW5zZQ0KDQpJIHRoaW5rIHRoaXMgY2FuIGJlIGRvbmUg
aW4gYSBzZXBhcmF0ZSBwYXRjaCBmb3IgS1ZNX0hJTlRTX1JFQUxUSU1FDQoNClRoYW5rcw0KDQo9
TGkNCg==
