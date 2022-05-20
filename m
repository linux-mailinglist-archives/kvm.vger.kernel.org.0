Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D652EE33
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350315AbiETOcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350301AbiETOcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:32:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F155DA36;
        Fri, 20 May 2022 07:32:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c14so7940438pfn.2;
        Fri, 20 May 2022 07:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=DliqDdVLATY2qmDlzuw2Sy2dYKnj/zu7Z7ooTERfLQo=;
        b=AWXXJlYZFLt3+B9c+JQnWf20eGJcpoHR/ApnEH6fCOCn8YZvan4Pq02t9vikOzSkcg
         13DxQMQZi3ruNku7zwKXgu+ypa/cgl4ZGvUyMH1IrgxkK/yYUEwT6sH96W9A+XkJgVKG
         wpg2pfHYrMxyQ3pLyTaT2E9i2ev5rWiPI21NGS1PJtIA+yOngssBxrL0UQwtf4FpejzY
         edUMdlwNTnuB9sHMKyhBgA7UfWGAarRaSLwJoKndU4/4nkRSviDLogafeyJSUEoYOYSK
         0wSN2/Et2XGodwhs5ED5oCQjVu/qHJCPdcq9TnOyFPSXpe+OqmNbrqAZJpr5Kpvx6BYy
         iejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=DliqDdVLATY2qmDlzuw2Sy2dYKnj/zu7Z7ooTERfLQo=;
        b=o4LpRg8bxSYQ+0CRUygkSpHhF5UNjKlNc8Cid1dUNcfCfV8/t2CiUYqwsFn+IFINye
         BhTIvG3cj9V+2nZCXWDG738nP17O9402iRPSAUUIuxeJgjao3v3Y8c6e9DXlqIn6bPOB
         rqwMfzSx63klTJF95jO+gG1+cSndJA4zHEDHiLWINbDNcSWnl+BIZVar63rR+OoHEqTh
         Kbu5gRcKhMyqNWy2SzSscjIiataDdkQK0be8mvYWfxx0yxxhng39FwMgvdSDOqOAAQU2
         MmqkKKbVWBlAixspIiiqCflBaVx69I8T7BgEuTUVD7yEMkrEKWSq4HOGunQE3JM2srR8
         6BEA==
X-Gm-Message-State: AOAM533KpT+GP5u0OQaGH28+/5LR3fk9ellFvl6hl6pSMxaKuNSBcuSq
        GOPB1wjQwSj2J9uY4HLH1R0=
X-Google-Smtp-Source: ABdhPJwEjqQxlAIYNFza5WSzeMiUxPFvCIHxPPjZ8yx7cnNPUm3lAIkFIRppCawR/krh1/gazfxQYw==
X-Received: by 2002:a65:6e88:0:b0:382:3851:50c8 with SMTP id bm8-20020a656e88000000b00382385150c8mr8895014pgb.270.1653057131297;
        Fri, 20 May 2022 07:32:11 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902c1d100b0015e8d4eb243sm5661324plc.141.2022.05.20.07.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:32:10 -0700 (PDT)
Message-ID: <e7b67a64-d5d4-b251-f414-f4e1ae08e199@gmail.com>
Date:   Fri, 20 May 2022 22:32:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/3] KVM: x86/svm/pmu: Drop 'enum index' for more counters
 scalability
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, sandipan.das@amd.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220510115718.93335-1-likexu@tencent.com>
 <20220510115718.93335-3-likexu@tencent.com>
In-Reply-To: <20220510115718.93335-3-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The third patch is buggy, please ignore it.
I will post a new version. Sorry for the noise.

On 10/5/2022 7:57 pm, Like Xu wrote:
> From: Like Xu<likexu@tencent.com>
> 
> If the number of AMD gp counters continues to grow, the code will
> be very clumsy and the switch-case design of inline get_gp_pmc_amd()
> will also bloat the kernel text size.
> 
> The target code is taught to manage two groups of MSRs, each
> representing a different version of the AMD PMU counter MSRs.
> The MSR addresses of each group are contiguous, with no holes,
> and there is no intersection between two sets of addresses,
> but they are discrete in functionality by design like this:
> 
> [Group A : All counter MSRs are tightly bound to all event select MSRs ]
> 
>    MSR_K7_EVNTSEL0			0xc0010000
>    MSR_K7_EVNTSELi			0xc0010000 + i
>    ...
>    MSR_K7_EVNTSEL3			0xc0010003
>    MSR_K7_PERFCTR0			0xc0010004
>    MSR_K7_PERFCTRi			0xc0010004 + i
>    ...
>    MSR_K7_PERFCTR3			0xc0010007
> 
> [Group B : The counter MSRs are interleaved with the event select MSRs ]
> 
>    MSR_F15H_PERF_CTL0		0xc0010200
>    MSR_F15H_PERF_CTR0		(0xc0010200 + 1)
>    ...
>    MSR_F15H_PERF_CTLi		(0xc0010200 + 2 * i)
>    MSR_F15H_PERF_CTRi		(0xc0010200 + 2 * i + 1)
>    ...
>    MSR_F15H_PERF_CTL5		(0xc0010200 + 2 * 5)
>    MSR_F15H_PERF_CTR5		(0xc0010200 + 2 * 5 + 1)
> 
> Rewrite get_gp_pmc_amd() in this way: first determine which group of
> registers is accessed by the pass-in 'msr' address, then determine
> which msr 'base' is referenced by 'type', applying different address
> scaling ratios separately, and finally get the pmc_idx.
> 
> If the 'base' does not match its 'type', it continues to remain invalid.
> 
> Signed-off-by: Like Xu<likexu@tencent.com>
