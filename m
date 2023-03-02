Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A755E6A78AE
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 02:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCBBGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 20:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBBG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 20:06:29 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EFA567A6;
        Wed,  1 Mar 2023 17:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=CDt+m4AI+Ja7f8iL1HnP9+Emn/qOIFgs9//Kb9pOgJM=; b=dRXXgt8kLdn3jJrUOfCAcJ0y5+
        ejYMmbzhA/IzNseTjds/k3XpudD5lY/1HO7J9IRVMQ6Eya8XyzM9TvsYznuwtU6kWD3tb83jDRnLL
        yRn91RVl5auUFdZs3mPwjMXX4E/uKlzwMbRhE1c4u77lJ3YX2ECyuBkx2duQ94VguBcmu1CTyhVhI
        8ngGoSpUNWt6SjAocAOWhsClwFRlfG1FzLvfGUEKyRUFqOYOT4/2geN+1s/yvnHCIKay0qV1kultp
        DVEEa2NAtpXGBQmCIfzG1BbN7KHyB8OXktr3aHp7fS3ZYP1sgg60shLw6uUmlgVAQaPaeO2AvH04k
        GrCregRA==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXXOA-000QGm-VI; Thu, 02 Mar 2023 01:05:43 +0000
Message-ID: <41baeedf-f3ee-7342-7a5e-097f9a3c4de0@infradead.org>
Date:   Wed, 1 Mar 2023 17:05:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
To:     paulmck@kernel.org, Josh Triplett <josh@joshtriplett.org>
Cc:     Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
 <Y/+2Wuunn1sIF8eT@localhost>
 <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y//Q4Mh6/65Keruu@localhost>
 <20230302002851.GK2948950@paulmck-ThinkPad-P17-Gen-1>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230302002851.GK2948950@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/23 16:28, Paul E. McKenney wrote:
> On Wed, Mar 01, 2023 at 02:25:36PM -0800, Josh Triplett wrote:
>> On Wed, Mar 01, 2023 at 02:16:32PM -0800, Paul E. McKenney wrote:
>>> On Wed, Mar 01, 2023 at 12:32:26PM -0800, Josh Triplett wrote:
>>>> On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
>>>>   Thomas Gleixner wrote:
>>>>>>
>>>>>> Maybe we should enforce CONFIG_SMP=y first :)
>>>>>>
>>>>>> Thanks,
>>>>>
>>>>> for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
>>>>> maybe even for 32 bit if it just makes the code simpler I suppose
>>>>
>>>> As one of the folks keeping an eye on tinyconfig and kernel size, I
>>>> actually think we *should* make this change and rip out !CONFIG_SMP,
>>>> albeit carefully.
>>>>
>>>> In particular, I would propose that we rip out !CONFIG_SMP, *but* we
>>>> allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
>>>> case that the compiler can recognize that at compile time and optimize
>>>> accordingly, so that it might provide some of the UP optimizations for
>>>> us.)
>>>>
>>>> Then, any *optimizations* for the "will only have one CPU, ever" case
>>>> can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
>>>> those optimizations may be worth keeping for small embedded systems, or
>>>> for cases like Linux-as-bootloader or similar.
>>>>
>>>> The difference here would be that code written for !CONFIG_SMP today
>>>> needs to account for the UP case for *correctness*, whereas code written
>>>> for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
>>>> *performance*.
>>>
>>> It certainly would not make much sense to keep Tiny RCU and Tiny SRCU
>>> around if there was no CONFIG_SMP=n.
>>
>> On the contrary, I think it's entirely appropriate to keep them for
>> CONFIG_NR_CPUS=1; that's exactly the kind of simple optimization that
>> seems well worth having. (Ideal optimization: "very very simple for UP,
>> complex for SMP"; non-ideal optimization: "complex for SMP, differently
>> complex for UP".)
> 
> Fair enough, but how does removing CONFIG_SMP help with that?  Given that
> it is not all that hard to work around the lack of CONFIG_SMP for Tiny
> RCU and Tiny SRCU, then it cannot be all that hard to work around that
> lack for the use cases that you are trying to get rid of, right?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
> index 9071182b1284b..7487bee3d4341 100644
> --- a/kernel/rcu/Kconfig
> +++ b/kernel/rcu/Kconfig
> @@ -7,7 +7,7 @@ menu "RCU Subsystem"
>  
>  config TREE_RCU
>  	bool
> -	default y if SMP
> +	default y if CONFIG_NR_CPUS = 1
>  	# Dynticks-idle tracking
>  	select CONTEXT_TRACKING_IDLE
>  	help
> @@ -31,7 +31,7 @@ config PREEMPT_RCU
>  
>  config TINY_RCU
>  	bool
> -	default y if !PREEMPTION && !SMP
> +	default y if !PREEMPTION && CONFIG_NR_CPUS != 1
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for UP systems from which real-time response

but drop the CONFIG_ prefixes...

-- 
~Randy
