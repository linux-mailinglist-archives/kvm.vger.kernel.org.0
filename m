Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9BE4DA77E
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352998AbiCPBsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 21:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbiCPBsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 21:48:53 -0400
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FE5848329
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 18:47:40 -0700 (PDT)
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 08687375419E48B8E693;
        Wed, 16 Mar 2022 09:47:32 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 16 Mar 2022 09:47:31 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Wed, 16 Mar 2022 09:47:31 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
CC:     Peter Zijlstra <peterz@infradead.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF1bdjNdIEtWTTogeDg2OiBTdXBwb3J0?=
 =?utf-8?B?IHRoZSB2Q1BVIHByZWVtcHRpb24gY2hlY2sgd2l0aCBub3B2c3BpbiBhbmQg?=
 =?utf-8?Q?realtime_hint?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YzXSBLVk06IHg4NjogU3VwcG9ydCB0aGUgdkNQ?=
 =?utf-8?B?VSBwcmVlbXB0aW9uIGNoZWNrIHdpdGggbm9wdnNwaW4gYW5kIHJlYWx0aW1l?=
 =?utf-8?Q?_hint?=
Thread-Index: AQHYM5I5mrxWJfv1YU6NVnR2zxvzbKy2QxKAgACNlPD//6hmgIAJkKgAgAE+VhA=
Date:   Wed, 16 Mar 2022 01:47:31 +0000
Message-ID: <828235bb146840d89bae3f7af6538ead@baidu.com>
References: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
         <7746aad0-3968-ffba-1b7e-97e52b1afd6a@redhat.com>
         <172ca8e11130473c90c5533ce51dfa49@baidu.com>
         <a5d2a8c4-b907-91f9-e320-43fbba92a50d@redhat.com>
 <08b1b0be792ab54fac19b3e473ae0f28531cfab6.camel@redhat.com>
In-Reply-To: <08b1b0be792ab54fac19b3e473ae0f28531cfab6.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.10]
Content-Type: text/plain; charset="utf-8"
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

SGk6DQoNCkkgYW0gc29ycnksIEkgc2VuZCBhIG5ldyB2ZXJzaW9uDQoNCmh0dHBzOi8vcGF0Y2h3
b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9rdm0vcGF0Y2gvMTY0Njg5MTY4OS01MzM2OC0xLWdpdC1z
ZW5kLWVtYWlsLWxpcm9uZ3FpbmdAYmFpZHUuY29tLw0KDQp0aGFua3MNCg0KLUxpDQo=
