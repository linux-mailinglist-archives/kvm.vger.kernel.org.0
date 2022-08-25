Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861135A06F8
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 03:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiHYBve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 21:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiHYBvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 21:51:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D91C56;
        Wed, 24 Aug 2022 18:44:45 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MClzl0gDjznTdD;
        Thu, 25 Aug 2022 09:41:07 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 25 Aug 2022 09:43:26 +0800
Subject: Re: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220823063237.47299-1-linmiaohe@huawei.com>
 <YwZHYZFj5Q8NzZha@google.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <acc676e3-8dde-89c3-a031-67c3487c8f35@huawei.com>
Date:   Thu, 25 Aug 2022 09:43:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YwZHYZFj5Q8NzZha@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/8/24 23:44, Sean Christopherson wrote:
> Nit for future patches, please use
> 
>   KVM: x86/mmu:
> 
> for the scope.

Will take care of it.

> 
> On Tue, Aug 23, 2022, Miaohe Lin wrote:
>> When register_shrinker() fails, we forgot to release the percpu counter
>> kvm_total_used_mmu_pages leading to memoryleak. Fix this issue by calling
>> percpu_counter_destroy() when register_shrinker() fails.
>>
>> Fixes: ab271bd4dfd5 ("x86: kvm: propagate register_shrinker return code")
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Many thanks for your review.

Thanks,
Miaohe Lin


