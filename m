Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889776D87DE
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjDEUJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbjDEUIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:08:02 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC4B7EC4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:07:54 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w15-20020a056830410f00b006a386a0568dso4365436ott.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680725273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RhuMLQBR3rCl5VaE4Hh/yoxhUD1OUMBEn6EcaPgazrI=;
        b=kppZoR/1zW6G4gbfVxrRR4+8q+hkzKbeskQd0eUY/mk5GSG1/5iCfKnThI8KkKkX7O
         ejsfgROLtdbTWv6JMTBunwyggZlFSRFGh0Z3DYTR66yzCD5kBBHxKY9po2D22t/0o4J3
         +91RKQYNS8ABFg4rtxkODTQFJDwX5fC14sD1zf9P/QTTL60ta+T4FF0yYe6N7DJpHktV
         wSwFGxP4CcwElfLyqw4NFVYGaeFIKJR6TwduC6NgBg74tLXpqZ0Vap4ivNToOJu/905+
         mxyQEA6S7G8kKnkatzOkjfI+cdUXsyPUn8YywCUlFhHPyzNyMvyHyiCHYoRXgSHl3olG
         yBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RhuMLQBR3rCl5VaE4Hh/yoxhUD1OUMBEn6EcaPgazrI=;
        b=IvlkuMQEEr2vhiHVpqdIK+5ntDpJy1UaxL4K7nWpnVWsjG9Vo18WJSF8h4MHCnHNFy
         dHMgFUZagypgJ27np4NnJsINkNRQfxkskBWEBZOaPotUUUsohkrvh2IUEXP4gVTEDyug
         tV1hArhdM5KnWWWcrpGe1jTHYEMaGhZ+pSvyNSM7dYJxkgeL+sUsm3FKxx4dWW66TTTr
         zx4nGmnzfMFN/WdU32K3YtLkjgzA70yXsxnbYlq7QbLmIqMccRcM5111xPIfEXInlbi6
         K7aYKHaPezjjG0z8KhkNhj8YkCIaokRPARVesI/o29/UiY+jVrCqsrYT1DWHhEwIQDh8
         iSwg==
X-Gm-Message-State: AAQBX9caTWv/k8TcppEvNi7BNLsbd5lYV88BlO7IPbnUAxBBj9d+Y9Hi
        j2H5GWCZhu/orp/mFfOO/fGHfzFS9ks=
X-Google-Smtp-Source: AKy350YiSmUilKBLhtGMkDdEkcF20XopvLMbOWeSCDMkvT7LnCLKjzIhC+ILBPXNxeO6263OpKyUnQ==
X-Received: by 2002:a9d:76d5:0:b0:69f:a723:bd60 with SMTP id p21-20020a9d76d5000000b0069fa723bd60mr3301505otl.5.1680725273722;
        Wed, 05 Apr 2023 13:07:53 -0700 (PDT)
Received: from [192.168.68.107] ([191.255.108.232])
        by smtp.gmail.com with ESMTPSA id q16-20020a056830019000b0069fb87285fdsm7212817ota.59.2023.04.05.13.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 13:07:53 -0700 (PDT)
Message-ID: <330814bb-1568-9f64-b7ab-005776671ec5@gmail.com>
Date:   Wed, 5 Apr 2023 17:07:49 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 08/10] target/ppc: Restrict KVM-specific field from
 ArchCPU
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-9-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20230405160454.97436-9-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/23 13:04, Philippe Mathieu-Daudé wrote:
> The 'kvm_sw_tlb' field shouldn't be accessed when KVM is not available.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   target/ppc/cpu.h        | 2 ++
>   target/ppc/mmu_common.c | 4 ++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index 557d736dab..0ec3957397 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1148,7 +1148,9 @@ struct CPUArchState {
>       int tlb_type;    /* Type of TLB we're dealing with */
>       ppc_tlb_t tlb;   /* TLB is optional. Allocate them only if needed */
>       bool tlb_dirty;  /* Set to non-zero when modifying TLB */
> +#ifdef CONFIG_KVM
>       bool kvm_sw_tlb; /* non-zero if KVM SW TLB API is active */
> +#endif /* CONFIG_KVM */
>       uint32_t tlb_need_flush; /* Delayed flush needed */
>   #define TLB_NEED_LOCAL_FLUSH   0x1
>   #define TLB_NEED_GLOBAL_FLUSH  0x2
> diff --git a/target/ppc/mmu_common.c b/target/ppc/mmu_common.c
> index 7235a4befe..21843c69f6 100644
> --- a/target/ppc/mmu_common.c
> +++ b/target/ppc/mmu_common.c
> @@ -917,10 +917,12 @@ static void mmubooke_dump_mmu(CPUPPCState *env)
>       ppcemb_tlb_t *entry;
>       int i;
>   
> +#ifdef CONFIG_KVM
>       if (kvm_enabled() && !env->kvm_sw_tlb) {
>           qemu_printf("Cannot access KVM TLB\n");
>           return;
>       }
> +#endif
>   
>       qemu_printf("\nTLB:\n");
>       qemu_printf("Effective          Physical           Size PID   Prot     "
> @@ -1008,10 +1010,12 @@ static void mmubooke206_dump_mmu(CPUPPCState *env)
>       int offset = 0;
>       int i;
>   
> +#ifdef CONFIG_KVM
>       if (kvm_enabled() && !env->kvm_sw_tlb) {
>           qemu_printf("Cannot access KVM TLB\n");
>           return;
>       }
> +#endif
>   
>       for (i = 0; i < BOOKE206_MAX_TLBN; i++) {
>           int size = booke206_tlb_size(env, i);
