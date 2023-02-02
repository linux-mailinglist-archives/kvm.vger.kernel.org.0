Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3D0688A08
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 23:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjBBWvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 17:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBBWvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 17:51:10 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC46B341
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 14:50:43 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bk16so3089835wrb.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 14:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmNw6gCZpx4RvIbwFLXsxH5+IgysNjAa6GJEESnvefg=;
        b=Dqbw8Xha2h2/HgfPheKArV4xHxovX8Fd4p8XMUUrKSix7F7lh3OYyfLwEH3viWYlvd
         Vm23GOGPlDf3FCjr6uE7pJkD0admsUWPxAL6plLMsCtjCr9w1pExZaXi03w2lYW09YhE
         RoRwhtz6o1O4E9WlEoRIIrK7FY9ipvM33fym+53YNVPfxnryF6P9hAt2oJex+eG/PXqM
         bpO0P2eDVdpjN9bEvp9wxWBb5/rv+B8SrMPyneGkCncnSV97Xeo0UftFR+nXWekdNldV
         rQJ/XJKGFfE7MWOEym7mSOf8FCgCp3e7IudH5N2hvcBDkRZENmw3Uc2xRCoVABIQiTIC
         JW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmNw6gCZpx4RvIbwFLXsxH5+IgysNjAa6GJEESnvefg=;
        b=kz4pYLVg0EanTGvtP35rGZ+O4OqvZ3LL3pj5cabPh89F9ks22nes5zr9mNQvsGyfez
         CGui05iMQtWH2Sf/EePBHAicgWud1LYdVcuwCsYpJV8lNctqQfB4bWju32plgZxJY5is
         h302LP/1QIIZ2KWIwAeaLKCpNr1b/dLWab0nc4gioRlBiV3MsIRPSaPc91RBr6HCbJt7
         mZgRbKMvzQzFdQQ5cTwYS0hrxZ82Zd+pHKldLij5f1H9i4kNWSElZbh6bzUde2Rkc+uR
         mw9XNL99waiLB+Tml8R9e4UTzhQrjoSUggm5Cd1vtII+NFFt0cT34G+cKZYTCnmJVXB4
         JQhQ==
X-Gm-Message-State: AO0yUKUKqPhG0+/xzcy+lgqXYs2ZunxbpntGWq/MZ3MF8zgxi5Rbo2Tv
        SjR9dhG6/L/yyK/a99IbHRHyKQ==
X-Google-Smtp-Source: AK7set8KEmD64bD4UhoJ72eD7ad0O5B8iXzZ67UVg99cNn/bPeBnj8WdLKGnttqzbBBJ4l1QgvgXiw==
X-Received: by 2002:a05:6000:1a45:b0:2bf:dd17:5657 with SMTP id t5-20020a0560001a4500b002bfdd175657mr7409948wry.49.1675378241976;
        Thu, 02 Feb 2023 14:50:41 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71? ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600002a200b002bfd687a96dsm599053wry.16.2023.02.02.14.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 14:50:41 -0800 (PST)
Message-ID: <fb3e75fa-1a6f-0570-218f-ba9133fb72c6@bytedance.com>
Date:   Thu, 2 Feb 2023 22:50:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v6 06/11] x86/smpboot: Support parallel
 startup of secondary CPUs
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, tglx@linutronix.de,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-7-usama.arif@bytedance.com>
 <dac090d2a61137b9e2fecd6cb3bfb4d5a9656fb6.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <dac090d2a61137b9e2fecd6cb3bfb4d5a9656fb6.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/02/2023 22:30, David Woodhouse wrote:
> On Thu, 2023-02-02 at 21:56 +0000, Usama Arif wrote:
>> @@ -1515,6 +1530,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>>   
>>          speculative_store_bypass_ht_init();
>>   
>> +       /*
>> +        * We can do 64-bit AP bringup in parallel if the CPU reports its
>> +        * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard. And not
>> +        * for SEV-ES guests because they can't use CPUID that early.
>> +        * Also, some AMD CPUs crash when doing parallel cpu bringup, disable
>> +        * it for all AMD CPUs to be on the safe side.
>> +        */
>> +       if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B ||
>> +           cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
>> +               do_parallel_bringup = false;
>> +
>>          snp_set_wakeup_secondary_cpu();
>>   }
> 
> Oops, I thought I'd removed those two lines about AMD in the comment
> when I removed the actual code that did so. Turns out we remove those
> lines again in the *next* patch instead.

Ah, sorry about that, should have caught it while reviewing before 
posting. To think of it, it might be better to squash this and next AMD 
disabling patch, if anyone testing on AMD ever happens to check out at 
this specific patch, their machine might not boot :). Will repost only 
after getting the OK for the rest of the patches along with addressing 
any other comments that come up.

Thanks,
Usama

