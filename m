Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF95A7396
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiHaBx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiHaBxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:53:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8943DB02A9;
        Tue, 30 Aug 2022 18:53:54 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MHRtd2WtszYd10;
        Wed, 31 Aug 2022 09:49:29 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 09:53:52 +0800
Subject: Re: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220823063237.47299-1-linmiaohe@huawei.com>
 <Yw6DsUwSInpz97IV@google.com>
 <e1199046d184ad7210ebb100fc2f4b77d1ef4fba.camel@intel.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d0ad65ec-cbfb-f8c6-121b-ac3b8f5b7aaf@huawei.com>
Date:   Wed, 31 Aug 2022 09:53:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e1199046d184ad7210ebb100fc2f4b77d1ef4fba.camel@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

On 2022/8/31 6:42, Huang, Kai wrote:
> On Tue, 2022-08-30 at 21:40 +0000, Sean Christopherson wrote:
>> On Tue, Aug 23, 2022, Miaohe Lin wrote:
>>> When register_shrinker() fails, we forgot to release the percpu counter
> 
>>> kvm_total_used_mmu_pages leading to memoryleak. Fix this issue by calling
>>> percpu_counter_destroy() when register_shrinker() fails.
>>>
>>> Fixes: ab271bd4dfd5 ("x86: kvm: propagate register_shrinker return code")
>>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>>> ---
>>
>> Pushed to branch `for_paolo/6.1` at:
>>
>>     https://github.com/sean-jc/linux.git
>>
>> Unless you hear otherwise, it will make its way to kvm/queue "soon".
>>
>> Note, the commit IDs are not guaranteed to be stable.
> 
> Sorry for late reply.
> 
> The commit message has "we".  Should we get rid of it?

Sean has kindly tweaked the commit message. Many thanks both.

BTW: Is it unsuitable to use "we" in the commit message? If so, I will try to not use it
in later patches.

Thanks,
Miaohe Lin
