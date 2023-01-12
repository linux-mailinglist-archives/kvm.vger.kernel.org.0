Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28558666F8B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbjALK0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 05:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjALK0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 05:26:01 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A2B2644
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:21:44 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qk9so43602108ejc.3
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2jyknxSTt2NQw2hfgMQYd2CfekI+TJ/MujvE+w3CPTs=;
        b=ID1mSBwtij4q3V+xmbjdDpYaTZjx5gqBxN6wsmB3LUOo9WXhzTjYZLpcihT2JeGRVM
         f1a/bjEGrHwJ1UXMBdtC7GKaCMXaLvVyBEsYKUFo5k8Bv98faLHBuWF49h/V71CdPeFO
         O6Ux1M5i1GeASyV7JwiNzqrYzfrlB04kojMNAnnF+r3lzznyJkrwEf6BywnPh2k/LPK1
         QByR9e2mG5BqRa76SCYo+oyEUW41X6Api2I/YJTmKKsY9vJsMPBACvBZm0WFg43LXrw8
         KGjpSGPtykno+ClZgQWUC8BT52Ge0oLX9YZIOzlUhi09YdFtIVmi2+mAT3VBoeQS7fd6
         oNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jyknxSTt2NQw2hfgMQYd2CfekI+TJ/MujvE+w3CPTs=;
        b=kihkj1xsF3FsOIv0rLX/EIqUdFHgW4nqX1a5gFFtVTaliYfg+e6qeGDPk+1ffsxw/c
         pppZys/zExRdHU7Ws+Kgj9i+ZH0qZ1K09ycjjQdzGeqJEksWMQlT5SI96IwKzJn2ajiu
         OutUTsgEoOf9uOS6tw1Fh57uduPaZjEFDmlAFZ7veHG7+EyxWrprF5Z0xAQmddxYW4dx
         7DWSEAMkquw0yt8SMiMO1K1jqOkdS20NXxRvb9v3N+Djj+Do8VKf+NR9l1JptLGixTv8
         g6IOrbp54L5QI2i07dwPCG33ZSAbP/MNM34frfayaDAnl24Gmnwlt6qVXMYoMBESrprY
         M0+Q==
X-Gm-Message-State: AFqh2kqbo0dqfqbMtrQVh/5ZLN583j1wymPQDxH/FNV2eAXAlX8g1kEq
        fMBqsOwlZB09UAZebUJBfS5JPg==
X-Google-Smtp-Source: AMrXdXstE2goO/ZfgFaOC5o6KAc94kfn/S1VI810KcC/mfZ5erQj9qFTjhY6z9iVjYkkQngORCF0fw==
X-Received: by 2002:a17:907:3ad8:b0:85d:3771:18b7 with SMTP id fi24-20020a1709073ad800b0085d377118b7mr5031588ejc.70.1673518902582;
        Thu, 12 Jan 2023 02:21:42 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906318900b0080c433a9eeesm7252556ejy.182.2023.01.12.02.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 02:21:42 -0800 (PST)
Date:   Thu, 12 Jan 2023 11:21:41 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 02/11] RISC-V: KVM: Define a probe function for SBI
 extension data structures
Message-ID: <20230112102141.chpcqzoko25s2cak@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-3-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-3-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:37AM -0800, Atish Patra wrote:
> Currently the probe function just checks if an SBI extension is
> registered or not. However, the extension may not want to advertise
> itself depending on some other condition.
> An additional extension specific probe function will allow
> extensions to decide if they want to be advertised to the caller or
> not. Any extension that does not require additional dependency checks
> can avoid implementing this function.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index f79478a..61dac1b 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
>  	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
>  		       bool *exit);
> +
> +	/* Extension specific probe function */
> +	unsigned long (*probe)(struct kvm_vcpu *vcpu, unsigned long extid);

It doesn't seem like the extid parameter should be necessary since the
probe function is specific to the extension, but it doesn't hurt either.

>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 5d65c63..89e2415 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  {
>  	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	const struct kvm_vcpu_sbi_extension *sbi_ext;
>  
>  	switch (cp->a6) {
>  	case SBI_EXT_BASE_GET_SPEC_VERSION:
> @@ -43,8 +44,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			 */
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
>  			*exit = true;
> -		} else
> -			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +		} else {
> +			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> +			if (sbi_ext) {
> +				if (sbi_ext->probe)
> +					*out_val = sbi_ext->probe(vcpu, cp->a0);
> +				else
> +					*out_val = 1;
> +			} else
> +				*out_val = 0;
> +		}
>  		break;
>  	case SBI_EXT_BASE_GET_MVENDORID:
>  		*out_val = vcpu->arch.mvendorid;
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
