Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D4682266
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 03:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjAaCz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 21:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAaCz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 21:55:26 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D39CB443
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 18:55:25 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be8so13687715plb.7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 18:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vj6mBMzk1d7uFNyPaGxFlLal+ZLcp4ObFIbVZwyVdts=;
        b=c10AGnuxU4RL9IxtfFUwBrTVTiJph3zrj4fXpZJ+Zu5Tb0CS3eNXW76Vnbyrnf0CBP
         vYY6+hSh33fgNUM1a2O0dBYOppWJVAiIvjluZBat4cSfgSXOojd95QGqEILRsplYhpRH
         bUM5z2ORHLMlPMzV1K+hoP4wkPr5E7rOkNqOOkmnGRjh7UMaMKp9kHKnlloXFeBhBKBc
         JEOrFqMogrS2FiGasIEP6aLyc0yciJhSm/c5IxhDA6ez/AwFOiNnom4OMHduD8vqedSl
         THaGruHsWr/M11bK0EH2NXrCKHD705z7mn4gtfQnh/10jxwtzAXN/OMkI5jRKN1gDBvr
         B6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vj6mBMzk1d7uFNyPaGxFlLal+ZLcp4ObFIbVZwyVdts=;
        b=w1g6luJBkJCvSA1wLZAiApBsrg3iUNcZvpL8J9P2wTt6tbWAxTGcKkcEaWbS717i25
         Quq14eN5aPvm4zjN7Xumsk8XG6n/my3uilqP2XsS9EqfAanHF7xlliGjj42HQbrWL1h4
         3602c82EfF9rimwCaCp3vZofS2HS1GCYD/0Phpb43gTAIVSgK8eHLJ4iMeEcS2LuhYkW
         rcVqUdKbvETVS7U+fiXicDC63AY0opJ0SnG5W8XtQZUZjGkGFaBw9o2D4OpxH5CuKKOk
         EBr0BCFNKr+mbrSaODHcLeMW6vqe2E82DTAX2uk4iujsJhGMxxulG4dfMUwBMcGIiRcq
         l4xA==
X-Gm-Message-State: AFqh2kpICXK8C+eWIjhvcOUwH9pgPWA6WJ7jC03YocT1wC+yvzJcSJ1R
        jG8lEQaxcHEPOp8UYaZknjdMEw==
X-Google-Smtp-Source: AMrXdXv96l/xdFLQ6INRtgspaPh3hBc/9mcpvHcDtAc10wMKebvj1EOqzLsynmdrvhXZsWZzggxBuA==
X-Received: by 2002:a17:902:7881:b0:192:bb38:c412 with SMTP id q1-20020a170902788100b00192bb38c412mr47612855pll.44.1675133724677;
        Mon, 30 Jan 2023 18:55:24 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902694500b001967580f60fsm3918169plt.260.2023.01.30.18.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 18:55:24 -0800 (PST)
Message-ID: <eb3a3efd-89f7-db94-f99a-daa51065706c@rivosinc.com>
Date:   Mon, 30 Jan 2023 18:55:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH -next v13 09/19] riscv: Add task switch support for vector
Content-Language: en-US
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Nick Knight <nick.knight@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-10-andy.chiu@sifive.com>
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <20230125142056.18356-10-andy.chiu@sifive.com>
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

Hi Andy,

For some reason I was looking closely at this patch today.

On 1/25/23 06:20, Andy Chiu wrote:
>   /* Whitelist the fstate from the task_struct for hardened usercopy */
> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
> index df1aa589b7fd..69e24140195d 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -8,6 +8,7 @@
>   
>   #include <linux/jump_label.h>
>   #include <linux/sched/task_stack.h>
> +#include <asm/vector.h>
>   #include <asm/hwcap.h>
>   #include <asm/processor.h>
>   #include <asm/ptrace.h>
> @@ -68,6 +69,21 @@ static __always_inline bool has_fpu(void) { return false; }
>   #define __switch_to_fpu(__prev, __next) do { } while (0)
>   #endif
>   
> +#ifdef CONFIG_RISCV_ISA_V
> +static inline void __switch_to_vector(struct task_struct *prev,
> +				      struct task_struct *next)
> +{
> +	struct pt_regs *regs;
> +
> +	regs = task_pt_regs(prev);
> +	if (unlikely(regs->status & SR_SD))

Do we really need to check SR_SD, isn't checking for  SR_VS_DIRTY enough.
If yes, we can remove the check here and keep the existing one on 
vstate_save()

> +		vstate_save(prev, regs);
> +	vstate_restore(next, task_pt_regs(next));
> +}
> +#else /* ! CONFIG_RISCV_ISA_V  */
> +#define __switch_to_vector(__prev, __next) do { } while (0)
> +#endif /* CONFIG_RISCV_ISA_V  */
> +

Can we de-lutter switch_to.h some more and move both the definitions of 
__switch_to_vector into vector.h ?


>   extern struct task_struct *__switch_to(struct task_struct *,
>   				       struct task_struct *);
>   
> @@ -77,6 +93,8 @@ do {							\
>   	struct task_struct *__next = (next);		\
>   	if (has_fpu())					\
>   		__switch_to_fpu(__prev, __next);	\
> +	if (has_vector())					\
> +		__switch_to_vector(__prev, __next);	\
>   	((last) = __switch_to(__prev, __next));		\
>   } while (0)
>   


