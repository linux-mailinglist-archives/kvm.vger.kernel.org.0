Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC35686BEE
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBAQi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjBAQiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:38:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72298C166
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 08:38:16 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q5so17925901wrv.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 08:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mrcqv7iS1cquJvqoLMbtEWKy/UDB0TOdu8u7+euImwo=;
        b=HEnQif1tx0zTKMoBmkbT/iretYU8xu0ia36crD/trQlO9VlhcVSmUCN7JS+mDuJR0r
         xhIq3L+JUzUfNlSm5Ys44fRrSdBdwnpqGZzoWWuMxYTw3WC3sTQxbHP8Fz/gsAZY0xt2
         jIv+diZVnT53pAec9I8up8qiO4aoDW/v/rMGjqtP546MMJeiHeRcqz/I22nD6BI3k8g3
         +76rPG4dPa/NrF51x5fqtQiJWCi13TmPVOPjqfeaqoNfFmy5ppaAnoBQKkB0cw3Y2ET6
         a12d/ZY4PnuDz1suVsmH6J1iT/RA8UrW57OdnsYnyP3vw+8e/cLeu52TbTQ68niy52to
         Eb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrcqv7iS1cquJvqoLMbtEWKy/UDB0TOdu8u7+euImwo=;
        b=65n+1mI5FnkieSt9tAFGGUddfTOLQQPWORuMNqnJvu7L/brkpNKs+nSQd0INYQR+fI
         dajkEnR2G5TI/0KYK2I1Cc7sHO8lgu7kL2+xbbzaRPrvIqwiDptIsiSZGGMrQI2LXlNa
         paB+UXHcCZg+TBln5HVU8rhN8RvLG/qMMaslWXD5a8/hVyVfxPpCBQIAmIHeuqe7pJjP
         ph7Qxmn3rEPlYoTVNpWhUhw6bKQj4wwZDswscF3lahh8WWasJGmuwOHIPvaMQaGKopIJ
         gxVXnRkNUp5dByfLMeBWMMbXT7psvHLZoaHT8WhpC4pLZIgkVrH6wcDQtZB7EKow8VmC
         q2Tw==
X-Gm-Message-State: AO0yUKVbEpY0GRZrjGrLh+lwIw5IGLNpojHNEsmCfYVBxfMR+6LHP51m
        45Nf/nKfnm3xcrwRTrEGsk0FwA==
X-Google-Smtp-Source: AK7set8OjV9bsPy0E5o71+igl9MbubLZ/y4xjVKKORsyD+9B+4sJKoouxiK/GQ+Z54tO2tWR7YYa9w==
X-Received: by 2002:adf:c713:0:b0:2bf:e9dc:5536 with SMTP id k19-20020adfc713000000b002bfe9dc5536mr3432655wrg.45.1675269495424;
        Wed, 01 Feb 2023 08:38:15 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:7611:c340:3d8d:d46c? ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id k6-20020a5d6d46000000b002bfeccd872bsm9688027wri.70.2023.02.01.08.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 08:38:15 -0800 (PST)
Message-ID: <7fda05c9-9d4a-6005-0ce5-91bda1bb06c1@bytedance.com>
Date:   Wed, 1 Feb 2023 16:38:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v4 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Fam Zheng <fam.zheng@bytedance.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20220201205328.123066-1-dwmw2@infradead.org>
 <ff876008-b642-4dbc-aa41-1639905e08b6@bytedance.com>
 <1d0ed92ab68409b62a14cd29d0021f92c6e2568a.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <1d0ed92ab68409b62a14cd29d0021f92c6e2568a.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/2023 15:08, David Woodhouse wrote:
> On Wed, 2023-02-01 at 14:40 +0000, Usama Arif wrote:
>> On 01/02/2022 20:53, David Woodhouse wrote:
>>> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
>>> them shaves about 80% off the AP bringup time on a 96-thread 2-socket
>>> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
>>>
>>> There are more wins to be had with further parallelisation, but this is
>>> the simple part.
>>>
>>
>> Hi,
>>
>> We are interested in reducing the boot time of servers (with kexec), and
>> smpboot takes up a significant amount of time while booting. When
>> testing the patch series (rebased to v6.1) on a server with 128 CPUs
>> split across 2 NUMA nodes, it brought down the smpboot time from ~700ms
>> to 100ms. Adding another cpuhp state for do_wait_cpu_initialized to make
>> sure cpu_init is reached (as done in v1 of the series + using the
>> cpu_finishup_mask) brought it down further to ~30ms.
>>
>> I just wanted to check what was needed to progress the patch series
>> further for review? There weren't any comments on v4 of the patch so I
>> couldn't figure out what more is needed. I think its quite useful to
>> have this working so would be really glad help in anything needed to
>> restart the review.
> 
> 
> I believe the only thing holding it back was the fact that it broke on
> some AMD CPUs.
> 
> We don't *think* there are any remaining software issues; we think it's
> hardware. Either an actual hardware race in CPU or chipset, or perhaps
> even something as simple as a voltage regulator which can't cope with
> an increase in power draw from *all* the CPUs at the same time.
> 
> We have prodded AMD a few times to investigate, but so far to no avail.
> 
> Last time I actually spoke to Thomas in person, I think he agreed that
> we should just merge it and disable the parallel mode for the affected
> AMD CPUs.
>

 From the comments in v3, it seems to affect multiple generations, would 
it be worth proceeding with the patches by disabling it on all AMD CPUs 
to be on the safe side, until the actual issue is found and what causes 
it, and then follow up later if the issue is found by disabling it only 
on affected cpus. Maybe simply do something like below?

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0f144773a7fc..6b8884592341 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1575,7 +1575,8 @@ void __init native_smp_prepare_cpus(unsigned int 
max_cpus)
          * for SEV-ES guests because they can't use CPUID that early.
          */
         if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 
0x0B ||
-           cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+           cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) ||
+           boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
                 do_parallel_bringup = false;

         if (do_parallel_bringup) {




> If you've already rebased to a newer kernel and tested it, perhaps now
> is the time to do just that.

If you would like me to repost the rebased patches to restart the 
reviews (with do_parallel_bringup disabled for AMD), please let me know!

Thanks,
Usama
