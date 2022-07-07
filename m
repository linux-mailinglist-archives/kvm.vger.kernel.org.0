Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2456A1FD
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiGGMcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 08:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiGGMcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 08:32:22 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B314C1BEBD;
        Thu,  7 Jul 2022 05:32:21 -0700 (PDT)
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id EFABD9E8B5DBB35BA265;
        Thu,  7 Jul 2022 20:32:18 +0800 (CST)
Received: from bjkjy-mail-ex20.internal.baidu.com (172.31.50.14) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 7 Jul 2022 20:32:20 +0800
Received: from BC-Mail-Ex25.internal.baidu.com (172.31.51.19) by
 bjkjy-mail-ex20.internal.baidu.com (172.31.50.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.18; Thu, 7 Jul 2022 20:32:20 +0800
Received: from BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) by
 BC-Mail-Ex25.internal.baidu.com ([172.31.51.19]) with mapi id 15.01.2308.020;
 Thu, 7 Jul 2022 20:32:20 +0800
From:   "Wang,Guangju" <wangguangju@baidu.com>
To:     "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "bp@alien8.de" <bp@alien8.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang,Guangju" <wangguangju@baidu.com>,
        "Chu,Kaiping" <chukaiping@baidu.com>
Subject: =?gb2312?B?s7e72DogW1BBVENIXSBLVk06IHg4NjogQWRkIEVPSV9JTkRVQ0VEIGV4aXQg?=
 =?gb2312?Q?handlers_for_Hyper-V_SynIC_vectors?=
Thread-Topic: [PATCH] KVM: x86: Add EOI_INDUCED exit handlers for Hyper-V
 SynIC vectors
Thread-Index: AQHYkf2Zdxqgj4EsMEqsgQUTLQABEQ==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 35
X-FaxNumberOfPages: 0
Date:   Thu, 7 Jul 2022 12:32:20 +0000
Message-ID: <72fc9fb240a24de4bf538f94860a655a@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.211]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

V2FuZyxHdWFuZ2p1IL2rs7e72NPKvP6hsFtQQVRDSF0gS1ZNOiB4ODY6IEFkZCBFT0lfSU5EVUNF
RCBleGl0IGhhbmRsZXJzIGZvciBIeXBlci1WIFN5bklDIHZlY3RvcnOhsaGj
