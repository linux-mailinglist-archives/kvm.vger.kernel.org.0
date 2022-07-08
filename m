Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68D456AFB2
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 03:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiGHBAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 21:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiGHBAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 21:00:09 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82F11183A3;
        Thu,  7 Jul 2022 18:00:08 -0700 (PDT)
Received: from BC-Mail-Ex18.internal.baidu.com (unknown [172.31.51.12])
        by Forcepoint Email with ESMTPS id CBCCE2E67E316B519FAF;
        Fri,  8 Jul 2022 09:00:05 +0800 (CST)
Received: from BC-Mail-Ex25.internal.baidu.com (172.31.51.19) by
 BC-Mail-Ex18.internal.baidu.com (172.31.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 8 Jul 2022 09:00:07 +0800
Received: from BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) by
 BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) with mapi id 15.01.2308.020;
 Fri, 8 Jul 2022 09:00:07 +0800
From:   "Wang,Guangju" <wangguangju@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "bp@alien8.de" <bp@alien8.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chu,Kaiping" <chukaiping@baidu.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IHg4NjogQWRkIEVPSV9JTkRVQ0VEIGV4aXQg?=
 =?gb2312?Q?handlers_for_Hyper-V_SynIC_vectors?=
Thread-Topic: [PATCH] KVM: x86: Add EOI_INDUCED exit handlers for Hyper-V
 SynIC vectors
Thread-Index: AQHYkf0ndxqgj4EsMEqsgQUTLQABEa1ylY4AgAESAGA=
Date:   Fri, 8 Jul 2022 01:00:07 +0000
Message-ID: <4068ff4962154900a6a3535454f4706e@baidu.com>
References: <20220707122854.87-1-wangguangju@baidu.com>
 <YscLvipHbNx+Wy9y@google.com>
In-Reply-To: <YscLvipHbNx+Wy9y@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.211]
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

PiBSYXRoZXIgdGhhbiBhZGQgYSB0aGlyZCBoZWxwZXIsIHdoYXQgYWJvdXQgcmVuYW1pbmcga3Zt
X2FwaWNfc2V0X2VvaV9hY2NlbGVyYXRlZCgpIGFuZCBoYXZpbmcgdGhlIG5vbi1hY2NlbGVyYXRl
ZCBoZWxwZXIgY2FsbCB0aGUgImFjY2xlcmF0ZWQiIHZlcnNpb24/ICBUaGF0IHdpbGwgZG9jdW1l
bnQgdGhlIGRlbHRhIGJldHdlZW4gdGhlIG5vbi1hY2NlbGVyYXRlZCBwYXRjaCBhbmQgdGhlIGFj
Y2VsZXJhdGVkIHBhdGguDQo+IFRoZSBvbmx5IGhpY2N1cCBpcyB0cmFjaW5nLCBidXQgdGhhdCdz
IGVhc3kgdG8gcmVzb2x2ZSAob3Igd2UgY291bGQganVzdCBub3QgdHJhY2UgaWYgdGhlcmUncyBu
byB2YWxpZCB2ZWN0b3IgdG8gRU9JKSwgZS5nLg0KDQpZZWFoLCByZW5hbWUgdGhlIGZ1bmN0aW9u
IGFuZCBpbnRlZ3JhdGUgdHdvIHBhdGhzIGxvb2tzIGNsZWFyZXIgYW5kIGVhc2llciB0byB1bmRl
cnN0YW5kPw0KVGhhbmtzIFNlYW4gZm9yIHRoZSBzdWdnZXN0aW9uLCBJIHdpbGwgc2VuZCBhIG5l
dyBwYXRjaCB3aXRoIGEgbmV3IHN1YmplY3QgYW5kIGNoYW5nZWxvZy4NCg0KLS0NCldhbmcNCg0K
