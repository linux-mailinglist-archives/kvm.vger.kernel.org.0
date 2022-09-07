Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654825B00E7
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 11:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiIGJwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 05:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGJwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 05:52:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6B0AC241;
        Wed,  7 Sep 2022 02:52:15 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x1so9617827plv.5;
        Wed, 07 Sep 2022 02:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hL8/0bQbvljbE9pavMAjl/JlKZsZvqQAigUYdJU1uNM=;
        b=nn4GlzU6eneYHeNiRJYFF1ODlYXAcRj82i4PpS+yK0zhDEqxJwTAlsALlBDEkXyXyq
         Ut8bkJ9Y0eHKoXjBXlGidIqP/vd5KLcAto0LzSvaI6pG1V+k+W8ATsx+ux6B3GMwetH0
         TUa+Ag0MK/wMVnM4JJju00UevVpKerJHOp/eyWi5Kw5LCBOSZoEX762GqSLx9bmw9FVX
         4COcooCEWMvm4/IJyYBNNFbR5GO/K4aLh+eSpSOXkYU/LTTG3zl+YZoHY57KEFfKGEIu
         C3Qmdrv88jOEsp2XvArsTA4AxTYfPzuLkR2Grx7VUs0782eIm7pmDnSkhYnu16c1f7yb
         drXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hL8/0bQbvljbE9pavMAjl/JlKZsZvqQAigUYdJU1uNM=;
        b=EQcb85Nm6CRiwG/XG7wnyYSVj95O1ng4vxvDNiurhwt/BdiVk9vw/Benbc+Ez+CWao
         UrT1adrD+iO2dlh8+ejtqY+d029Sg/Kxfg9W3OsxMHV5FYhjVQ3KEWtISF5SforPUomZ
         yc8LTwAScnTSBOdULre9hKrxHZZ5HYjCpIIDYva9HMGeHVWJzvc+Yfv7j0UmcPs6ejCO
         qgilhyQY75jNUKqEyM28ws/o3l3hoBVYWvdN3/bchEFKBudfsJvomuIUoJDi0covO/I5
         LWOspKkYmBiwWIKjUNabW9IOhnpj9KzNV4IeV/U3oCREkwlrAlJVHxYH1jOgu5Zbb+Bv
         HUiw==
X-Gm-Message-State: ACgBeo0BvGfoFm5QxPp/brp1uw9G0TMOQps7A2eQeLfJ20vD6FAn6n6X
        sCBRwomH5lPU5nxnsNiOLKLNT6mhLuytXA==
X-Google-Smtp-Source: AA6agR75M9T0PXWboUABs6dH9vDqBGzSP/US0yIYjWgFl5EDD3PXFx1q/YwxiO2oR7ml1/ZMDz8Lrw==
X-Received: by 2002:a17:902:ec90:b0:16e:d8d8:c2db with SMTP id x16-20020a170902ec9000b0016ed8d8c2dbmr3065483plg.69.1662544334697;
        Wed, 07 Sep 2022 02:52:14 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u195-20020a6279cc000000b00537eb00850asm12130450pfc.130.2022.09.07.02.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 02:52:14 -0700 (PDT)
Message-ID: <4a74d218-6266-cf6c-3ebb-4cbb49327440@gmail.com>
Date:   Wed, 7 Sep 2022 17:52:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 0/7] x86/pmu: Corner cases fixes and optimization
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220831085328.45489-1-likexu@tencent.com>
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A review reminder for shepherds. Thanks!

On 31/8/2022 4:53 pm, Like Xu wrote:
> Good well-designed tests can help us find more bugs, especially when
> the test steps differ from the Linux kernel behaviour in terms of the
> timing of access to virtualized hw resources.
> 
> Please feel free to run tests, add more or share comments.
> 
> Previous:
> https://lore.kernel.org/kvm/20220823093221.38075-1-likexu@tencent.com/
> 
> V2 RESEND -> V3 Changelog:
> - Post perf change as a separate patch to the perf folks; (Sean)
> - Rewrite the deferred logic using imperative mood; (Sean)
> - Drop some useless comment; (Sean)
> - Rename __reprogram_counter() to kvm_pmu_request_counter_reprogam(); (Sean)
> - Replace a play-by-play of the code changes with a high level description; (); (Sean)
> - Rename pmc->stale_counter to pmc->prev_counter; (Sean)
> - Drop an unnecessary check about pmc->prev_counter; (Sean)
> - Simply the code about "CTLn is even, CTRn is odd"; (Sean)
> - Refine commit message to avoid pronouns; (Sean)
> 
> Like Xu (7):
>    KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
>    KVM: x86/pmu: Don't generate PEBS records for emulated instructions
>    KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
>    KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
>    KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
>    KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement
>      amd_*_to_pmc()
>    KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters
>      scalability
> 
>   arch/x86/include/asm/kvm_host.h |   6 +-
>   arch/x86/kvm/pmu.c              |  44 +++++++-----
>   arch/x86/kvm/pmu.h              |   6 +-
>   arch/x86/kvm/svm/pmu.c          | 121 ++++++--------------------------
>   arch/x86/kvm/vmx/pmu_intel.c    |  36 +++++-----
>   5 files changed, 75 insertions(+), 138 deletions(-)
> 
