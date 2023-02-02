Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE836880E6
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBBPB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjBBPBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 10:01:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52D24103
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 07:01:50 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so3940075wma.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 07:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkw1fMzfUTVbCYC+KtqbnG3D7NE4RNDzj4aOJdcTTk=;
        b=Hho5VEknzD/I/ybD9eCMzmpRc5S0us958IbJ7J/1fOM/sMv2DQL3iAMA7/kNkhPGjA
         XcGcRcBo7q8Zrpkv8E0gm/Zl+cWITnUGBosIor6P+Y6RcYQjVhHd8X6QXj5GcEY7juCf
         oQbdA9+Trz94l2yW9eYsLdiV5ZuZQeSrI70SYnkQZCMt1B816Tl4ICeb/hY8ei+8qQbD
         ALpl31iaWKT1EMEW/x6OYFtxtPuwuoZzraMSczPesUN7vxHfbFWVqQNIb2+hr9Kq3SMZ
         NU5W997TUgLLYjZp0dXWufSQi+pp4D5P2ZQ/ydYfENIuicO0zThSp2KYnhkVfuTab/mA
         bZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlkw1fMzfUTVbCYC+KtqbnG3D7NE4RNDzj4aOJdcTTk=;
        b=u6cg3WnvdfjrrgaK1U9avbnjsF9XUaERgVVeJAsOOsebk35Mbd6ZsiZyE3/k3jTVK1
         4mzzRwfaNapgL7dcXDgqxzbwD618N7yYiUcXUUx68BGkPLq8YKkSev12JzLnUAqJpMlI
         wrUTnd4KaipUl9w8cFG4Kimk95Rm8MEWmSKboPK1zfLPNmpmxh+HCXOyT5jQMVEpTpbH
         gjYXnQE9q75gW1R+1SCmi7Sl986ShwfIUx26YBkmvoHv5+HxaWrrfDf+VueN/lIbZ5lF
         SIRoUR5Sa0nGpzQMHNjblE/C3d6MJ2hLrSzH1q/wdN66XO9O6JL450lktID1uuHBQQo4
         Nq7w==
X-Gm-Message-State: AO0yUKVlakjV5XBjPzNKZbEneVqU2vyZbCCocF0yScCvdAtHjF7dTcWO
        NTi68pH7qfPhTr61tjAzVSfxHg==
X-Google-Smtp-Source: AK7set+hOCzRrJzDZKwxlLiUpPd/5jC0lc768lBbKuEI78OyTsoNb0Vd/M4/19caZPBs7ICsW7MVAA==
X-Received: by 2002:a05:600c:46ca:b0:3dc:47d4:58d2 with SMTP id q10-20020a05600c46ca00b003dc47d458d2mr6333357wmo.25.1675350108726;
        Thu, 02 Feb 2023 07:01:48 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c469000b003a84375d0d1sm5479060wmo.44.2023.02.02.07.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:01:48 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:01:47 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 03/14] RISC-V: Improve SBI PMU extension related
 definitions
Message-ID: <20230202150147.zcj7s3ezwrg7pqfp@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-4-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-4-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:39PM -0800, Atish Patra wrote:
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
> ---
>  arch/riscv/include/asm/sbi.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 4ca7fba..945b7be 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -169,9 +169,9 @@ enum sbi_pmu_fw_generic_events_t {
>  	SBI_PMU_FW_ILLEGAL_INSN		= 4,
>  	SBI_PMU_FW_SET_TIMER		= 5,
>  	SBI_PMU_FW_IPI_SENT		= 6,
> -	SBI_PMU_FW_IPI_RECVD		= 7,
> +	SBI_PMU_FW_IPI_RCVD		= 7,
>  	SBI_PMU_FW_FENCE_I_SENT		= 8,
> -	SBI_PMU_FW_FENCE_I_RECVD	= 9,
> +	SBI_PMU_FW_FENCE_I_RCVD		= 9,
>  	SBI_PMU_FW_SFENCE_VMA_SENT	= 10,
>  	SBI_PMU_FW_SFENCE_VMA_RCVD	= 11,
>  	SBI_PMU_FW_SFENCE_VMA_ASID_SENT	= 12,
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

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
