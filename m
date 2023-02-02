Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4268896E
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 23:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjBBWAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 17:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBBWAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 17:00:45 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70641889A0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:59:52 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so1022692wms.0
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GpQqIcYzW24NoE4rYiVknf6KZVN8LYqH5TXYzHdb+3M=;
        b=mwh5EjD+CrWzvqutd8IljFnMGRQXj2tCaUtzf/ip7Fx/7JXdbc97L+E/EmTW9Oae73
         9Ylt/v4jzuked0HEBtzU/q3pRrnsFRx+ZB7WxAQGE8qH+gWxbrIkpVhl87nxs73n9loO
         fKG1uIuwKrHYhfZQ+GxXK4Cyn7XlbcZLSSv3McW7GHfVkWOwcoyIllOSckfARaD6G+cA
         SLHOb1wgrhTf/xClLk9ydPorX3wtcu9Z8rh43CQLnMwktRcRnfudxaqmRpIG2SRkHYiC
         o4fmZ7B88lQ0yrepdi8nofN2wQUWuoS+ZOn8VLEx2+i4Mzp60kYLRL2cVJ2vIsUzkfwR
         LydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpQqIcYzW24NoE4rYiVknf6KZVN8LYqH5TXYzHdb+3M=;
        b=NjKMMtRvY0faP/4nab2VJKM/tu5lxkmqwBDutPXBoHIRuhL5JYTmFQJMeq0dwuG7cU
         RIax6cLpurl1QqIb5U0TKlC6l1uTqo2+cuG759scPCr5Z3F3rP9EUAP3gn35o4AKprAJ
         k4k6/xyf1pBgTaknrkd45GEJNXigLstoVil0jrrTLz0Q9BDlItmRewm1De5CQ2HVSNik
         DDPIDzBUFnFdv7iLhl3imSwiDBsvQpvfR4f39WnsDzsg/fKiaq4HO6q+JlbCqs+mao4i
         44GVxXItS8grGGUJlj1m5gMZTvqp5jFpBfbRQqH9OkLES0ArGbZW1P1nyLdvDxpqlQSu
         /rfA==
X-Gm-Message-State: AO0yUKVa2/FmmN2cdQIOzoK3gOufTUkumyzc7dfbmV9WS3KcdbMEDy3O
        88fy1mJmF9qlDj0UIftTTM6GTw==
X-Google-Smtp-Source: AK7set8o50YFSBYeEBNtkAiBgAaIbG+rH/XDVtTCYV/fEyqOwguJihiZFYOvbTE8c29A7YdgzKGIMw==
X-Received: by 2002:a05:600c:1c1f:b0:3dc:5e21:8aa2 with SMTP id j31-20020a05600c1c1f00b003dc5e218aa2mr7362676wms.34.1675375170436;
        Thu, 02 Feb 2023 13:59:30 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71? ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id l16-20020a1c7910000000b003dc1d668866sm5710640wme.10.2023.02.02.13.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 13:59:29 -0800 (PST)
Message-ID: <702e3663-ceaa-c2b9-960f-1c909865f3d2@bytedance.com>
Date:   Thu, 2 Feb 2023 21:59:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/9] Parallel CPU bringup for x86_64
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
References: <20230201204338.1337562-1-usama.arif@bytedance.com>
 <de9c33a14c370d09cefaa331b18525e164436082.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <de9c33a14c370d09cefaa331b18525e164436082.camel@infradead.org>
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



On 02/02/2023 10:02, David Woodhouse wrote:
> On Wed, 2023-02-01 at 20:43 +0000, Usama Arif wrote:
>> This patchseries is from the work done by David Woodhouse (v4: https://lore.kernel.org/all/20220201205328.123066-1-dwmw2@infradead.org/).
>> The parallel CPU bringup is disabled for all AMD CPUs in this version: (see discussions: https://lore.kernel.org/all/bc3f2b1332c4bb77558df8aa36493a55542fe5b9.camel@infradead.org/ and
>> https://lore.kernel.org/all/3b6ac86fdc800cac5806433daf14a9095be101e9.camel@infradead.org/).
>>
>> Doing INIT/SIPI/SIPI in parallel brings down the time for smpboot from ~700ms
>> to 100ms (85% improvement) on a server with 128 CPUs split across 2 NUMA
>> nodes.
>>
>> Adding another cpuhp state for do_wait_cpu_initialized to make sure cpu_init
>> is reached in parallel as proposed by David in v1 will bring it down further
>> to ~30ms. Making this change would be dependent on this patchseries, so they
>> could be explored if this gets merged.
>>
>> Changes across versions:
>> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
>> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>>      in preparation for more parallelisation.
>> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>>      avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>>      24 bits of the physical X2APIC ID to be used. That patch still needs
>>      a Signed-off-by from its original author, who once claimed not to
>>      remember writing it at all. But now we've fixed it, hopefully he'll
>>      admit it now :)
>> v5: rebase to v6.1 and remeasure performance, disable parallel bringup
>>      for AMD CPUs.
> 
> Thanks, Usama.
> 
> I've updated to v6.2-rc6 since there were a few more tweaks required
> (and we should double-check that the new handling of cache_ap_init from
> a dedicated cpuhp step works right if that ends up being done in
> parallel).
> 
> I also fixed up the complaints from the test robot; including
> <linux/smpboot.h> from smpboot.c and making do_cpu_up() static, and
> putting #ifdef CONFIG_SMP around the 'are we booting the AP?' check and
> code segment in head_64.S.
> 
> I've made the AMD thing a CPU bug as Peter suggested, and pushed it to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-rc6
> for you to do the real work of actually testing it :)

Thanks David! I have tested and reposted the v6.2-rc6 patches. One thing 
I was mistaken about since I had rebased the patches together was that 
the last 100ms to 30ms optimization was coming from parallelization in 
x86/cpu:wait-init, when it seems to have a negligible affect. The last 
70ms optimization was coming mainly from reusing timer calibration. Its 
a simple patch and I have added it at the end of the series. The only 
thing thats' missing was a sign-off from the author who I have added to 
the latest series.
