Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC5569E8D
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 11:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiGGJ1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 05:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiGGJ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 05:27:13 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8ABA32EDA
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 02:27:11 -0700 (PDT)
Received: from BJHW-Mail-Ex06.internal.baidu.com (unknown [10.127.64.16])
        by Forcepoint Email with ESMTPS id E9EBBC9604B2142022AB;
        Thu,  7 Jul 2022 17:27:08 +0800 (CST)
Received: from bjkjy-mail-ex25.internal.baidu.com (172.31.50.41) by
 BJHW-Mail-Ex06.internal.baidu.com (10.127.64.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 7 Jul 2022 17:27:10 +0800
Received: from BC-Mail-Ex25.internal.baidu.com (172.31.51.19) by
 bjkjy-mail-ex25.internal.baidu.com (172.31.50.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.18; Thu, 7 Jul 2022 17:27:10 +0800
Received: from BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) by
 BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) with mapi id 15.01.2308.020;
 Thu, 7 Jul 2022 17:27:10 +0800
From:   "Wang,Guangju" <wangguangju@baidu.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "bp@alien8.de" <bp@alien8.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IHg4NjogQWRkIEVPSSBleGl0IGJpdG1hcCBo?=
 =?gb2312?Q?andlers_for_Hyper-V_SynIC_vectors?=
Thread-Topic: [PATCH] KVM: x86: Add EOI exit bitmap handlers for Hyper-V SynIC
 vectors
Thread-Index: AQHYkEqBPHzJhkwNOk28KoTifs6bBK1yD/EAgACVoCA=
Date:   Thu, 7 Jul 2022 09:27:10 +0000
Message-ID: <4ba5a5a28a284f379b0f7832e20d1458@baidu.com>
References: <20220705083732.168-1-wangguangju@baidu.com>
 <87v8s9qqen.fsf@redhat.com>
In-Reply-To: <87v8s9qqen.fsf@redhat.com>
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

PiBUaGlzIHdob2xlIHBhcnQ6DQo+DQo+IAlpZiAodG9faHZfdmNwdShhcGljLT52Y3B1KSAmJg0K
PgkgICAgdGVzdF9iaXQodmVjdG9yLCB0b19odl9zeW5pYyhhcGljLT52Y3B1KS0+dmVjX2JpdG1h
cCkpDQo+CQlrdm1faHZfc3luaWNfc2VuZF9lb2koYXBpYy0+dmNwdSwgdmVjdG9yKTsNCj4NCj4J
a3ZtX2lvYXBpY19zZW5kX2VvaShhcGljLCB2ZWN0b3IpOw0KPglrdm1fbWFrZV9yZXF1ZXN0KEtW
TV9SRVFfRVZFTlQsIGFwaWMtPnZjcHUpOw0KDQo+IGNvdWxkIGJlIHNwbGl0IGludG8gYW4gaW5s
aW5lIGZ1bmN0aW9uLCBzb21ldGhpbmcgbGlrZSAoY29tcGxldGVseQ0KPiB1bnRlc3RlZCk6DQoN
ClRoYW5rIHlvdSwgSSB3aWxsIG1vZGlmeSBhbmQgdGVzdCBpdCBhbmQgdGhlbiBzZW5kIGEgbmV3
IHBhdGNoLg0KDQotLQ0KV2FuZw0K
