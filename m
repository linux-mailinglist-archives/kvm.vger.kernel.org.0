Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6254D68742E
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjBBEA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBBEAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:00:22 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626BB74A52
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 20:00:21 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mc11so2399745ejb.10
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 20:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+uHzkzRU34mQdnn5lWvnZyqUSrv1eWF6wggHxGMhz5Y=;
        b=vDT2PW4noC2y8fUJv4T030Qs0ou+utnvprCD69Bni7JoZBDDy5JeATGsFmUPIsZF4D
         mjpm5Dv9mpAz/UHO/X/4nOZxZxCrp+zupKy+L6VHedmaNDxxP8axYp/tiqjLL0drYw8+
         kcAKZdwMo3hAeKNvIVA0YZF+r1E5LaZ1W0Gk3VFLwZssP6vyk/Qoe7uH+H9G0UoXtTBU
         MWk1j2t+xoBe940QlWS8JHz+u5ov81ET2mEhMykFV56LBActmHNkNYaVPdPPbop5LKJi
         Cd1GLSbR1rkobqMeJ5X0W3+EoNlv0NWtn4eehuL0lm20DqKJlwZxrrSDlIj6d3JELApG
         6DaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uHzkzRU34mQdnn5lWvnZyqUSrv1eWF6wggHxGMhz5Y=;
        b=TjbfFfl8a2XPCcYga86Z40SL4OWan4qOwBOhmgk5OjcsKlqkTkySagT7yfQjk4OkEI
         pg6Xp++czuUcf6HDFlmW9ocabmzQm23pjXKjRAHfDq/+YsvLCJFf2Z3arXdHGcZgXKRg
         XLkFPA0jBLjHVagRhN6EFqRrM9OH8QVPUvoRvsOkYcnWG5ihBnlLuCY/cbyp3tJAVRGe
         bmiuOzVMbVCZzdKaBKCjfq4Y1YLYZS3ZZnaJpY85M/dWHAxn97weqEELegA3YhjH6x39
         6c+jWA9N9g+tsqA8ZFJ6DARHqcFsS5lp9hScTXBLi+TSwMD+0wzbInv6JBTV1k4uL0Ir
         g+9g==
X-Gm-Message-State: AO0yUKWGTh/8vimqKoh1HWK/oezv1H8VhbIShgHE8qJQgLqsV0wIz7jo
        u6WN0i7p+SudP/Kzl02RSzl0AahZhVrni0U7YdVyog==
X-Google-Smtp-Source: AK7set9Gl20xL0r/kUXbPTHGGlCdGEFHpzn6184j2T2lV6HyNUYLcbnvJOnFSAICYR9hzlq2DJHtCSbzB41rik4ah9w=
X-Received: by 2002:a17:906:8597:b0:87d:d218:3923 with SMTP id
 v23-20020a170906859700b0087dd2183923mr1535177ejx.117.1675310419808; Wed, 01
 Feb 2023 20:00:19 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-4-atishp@rivosinc.com>
In-Reply-To: <20230201231250.3806412-4-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Feb 2023 09:30:09 +0530
Message-ID: <CAAhSdy2KSBq3NgCe00pHbTkxQkezrbGbo6XcZZ2Cgu6L_-osww@mail.gmail.com>
Subject: Re: [PATCH v4 03/14] RISC-V: Improve SBI PMU extension related definitions
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 4:42 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> This patch fixes/improve few minor things in SBI PMU extension
> definition.
>
> 1. Align all the firmware event names.
> 2. Add macros for bit positions in cache event ID & ops.
>
> The changes were small enough to combine them together instead
> of creating 1 liner patches.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/sbi.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 4ca7fba..945b7be 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -169,9 +169,9 @@ enum sbi_pmu_fw_generic_events_t {
>         SBI_PMU_FW_ILLEGAL_INSN         = 4,
>         SBI_PMU_FW_SET_TIMER            = 5,
>         SBI_PMU_FW_IPI_SENT             = 6,
> -       SBI_PMU_FW_IPI_RECVD            = 7,
> +       SBI_PMU_FW_IPI_RCVD             = 7,
>         SBI_PMU_FW_FENCE_I_SENT         = 8,
> -       SBI_PMU_FW_FENCE_I_RECVD        = 9,
> +       SBI_PMU_FW_FENCE_I_RCVD         = 9,
>         SBI_PMU_FW_SFENCE_VMA_SENT      = 10,
>         SBI_PMU_FW_SFENCE_VMA_RCVD      = 11,
>         SBI_PMU_FW_SFENCE_VMA_ASID_SENT = 12,
> @@ -215,6 +215,9 @@ enum sbi_pmu_ctr_type {
>  #define SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK 0x06
>  #define SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK 0x01
>
> +#define SBI_PMU_EVENT_CACHE_ID_SHIFT 3
> +#define SBI_PMU_EVENT_CACHE_OP_SHIFT 1
> +
>  #define SBI_PMU_EVENT_IDX_INVALID 0xFFFFFFFF
>
>  /* Flags defined for config matching function */
> --
> 2.25.1
>
