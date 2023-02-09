Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE7690B30
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBIOBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 09:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjBIOBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 09:01:47 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227817CDF
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 06:01:19 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bk16so1838169wrb.11
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 06:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+evB1wRIs1YVh0m9vaXYV1Eimg/bc2fS/Wf/QcyEWEw=;
        b=UGsJrKn/adIrTsqzAoUfhxwKHIdPn9Y7s8MU+fSlMTU8+s1TsE5C1qr2E6V0Ck1JId
         7pjLj77ibjPXMmLEIdnyLL7TSbE05wnyyY2UDeIh0dCvgPG15TCcMAYwoNJ5XbY34WcQ
         f4l0zRUYxbU8FjNN+HkNJcJgxbwpuWTOPbVEgTAYew0JeB8YAk8NpBx51e05EWZ2dVx+
         Aa7qUQiPBwU6qGIf9H9CfI66kGI0UY1HiSIG8vwJyvqD5vlWmMq2tv0takrRQHdymbzB
         2ZrHtZRcA51yblR01blR6SKOzIUEidTff0AyMyogoHMlxbbO9JOrO59IRZQQgE4EONws
         Y8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+evB1wRIs1YVh0m9vaXYV1Eimg/bc2fS/Wf/QcyEWEw=;
        b=TOzTTo0zy0Lq3HfEqXfMOwE6xgxlGJD9rCbTbb0YFJ7atNiCEOxSfCbti9opsulcPV
         UD4pLpcmK0xDr3o4/XshE1106iIsqKy1KnY7FKnYZQ7ocwVUBZ7pFuKRyLRPKXHGO9jD
         o+YxHZlDfao/c70SNZvFQJHL3/6MWoAhEU/gdebfS6ZEn9zcvgzlF52CQ6nhM+uve3gO
         XXZjeK/qq0mlaSxMAz1c+xKC6kIsYoEQ+kxx84nP9UjXwcmsHrzZT4uqMoM/S7URe8f2
         xgFEXSxFcjKMEhCwXwMkbKG53Kp+oY0KvQcjJ7MG90NJyTRAIJAYK/VP7n011M1NjDlc
         aM6w==
X-Gm-Message-State: AO0yUKV/v9O3NUHVZhuw6NmZ67REgpdAOcCR5Op6/E+Nfq01C+HFMeh6
        cz+AoPj4qXXwdNRIK6zAKZ5mOg==
X-Google-Smtp-Source: AK7set/triGcOEnXv54PfBvlOjeLPOXQlW6J0JP7sHfm/HOZJPeU5N1LK50kZokAKRQ/43+UigvVpg==
X-Received: by 2002:a5d:65c3:0:b0:2bf:bd69:234b with SMTP id e3-20020a5d65c3000000b002bfbd69234bmr10570099wrw.32.1675951278415;
        Thu, 09 Feb 2023 06:01:18 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8009:2525:9580:8db2? ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6741000000b002bdd96d88b4sm1405476wrw.75.2023.02.09.06.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 06:01:17 -0800 (PST)
Message-ID: <46212587-aac6-9513-70a2-32be7eeded14@bytedance.com>
Date:   Thu, 9 Feb 2023 14:01:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@kernel.org
Cc:     kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
 <8e2f03e2-9517-aeb4-df60-b36ef3ff3a75@bytedance.com>
 <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
 <87357f2gyd.ffs@tglx>
 <eea887fb7d634c24529743fce8295b2f78eb861d.camel@infradead.org>
 <76b8560c940f4506a690152e91e2f030eb24f86e.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <76b8560c940f4506a690152e91e2f030eb24f86e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2023 13:48, David Woodhouse wrote:
> On Thu, 2023-02-09 at 12:10 +0000, David Woodhouse wrote:
>> On Thu, 2023-02-09 at 12:53 +0100, Thomas Gleixner wrote:
>>> On Thu, Feb 09 2023 at 11:03, David Woodhouse wrote:
>>>> This one also fixes it for me. If we're happy with this approach, I'll
>>>> work it into Thomas's original patch (and hopefully eventually he'll be
>>>> happy enough with it and the commit message that he'll give us his
>>>> Signed-off-by for it.)
>>>
>>> I'm happy enough by now, but I'm not sure how much of the original patch
>>> is still left. Also you did the heavy lifting of making it work and
>>> writing the nice changelog. So please make this:
>>>
>>> From: David Woodhouse <dwmw2@infradead.org>
>>>
>>> Co-developed-by: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>>
>> Thanks. I'll flip that to the Amazon address, of course. It's useless
>> for actual email (until I apply that LART some more) but I should still
>> use it for that.
>>
>> I think I'm going to make one more change to that as I review it; in
>> the "should never happen" case of not finding the APIC ID in the
>> cpuid_to_apicid[] array it would just keep searching for ever. I don't
>> know if there's a better thing to do other than just dropping the
>> trampoline lock and 1:cli;hlt;jmp 1b but at least it's *attempting* to
>> handle the failure.
>>
>> Patch below, and I'll update the tree shortly. There's a "what if
>> there's noise in the top 32 bits of %rcx" fix in there too.
> 
> All done and pushed out to parallel-6.2-rc7-part1 (and not -part1)
> branches. Usama, are you able to redo the testing and take it from
> here? Thanks for that; it's saving me a lot of time!
> 
Thanks! Will retest and repost now!

Usama

> 
> I'm mostly done for the week now as by this time tomorrow, I need to
> have the skis on the roof of the car and be ready to pick the family up
> from school and start driving south...
