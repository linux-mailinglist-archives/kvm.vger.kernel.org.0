Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77E1614E65
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiKAPcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiKAPco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:32:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CCB15FF4
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:32:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v27so22323555eda.1
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EkOTr9SItjKJoDycMahI5/oHi6EPM1ssOxtlPzqceFY=;
        b=HNNzcgpfiO+zdeymquvREye/XQQhuyJO32ZM+OqtMJdNWMBVTHM3M/1qdMB4gg7K/F
         WVZnvEtB/S24D8t/nt2qn/KwsTtdkBlzYY35jVsuJr5buka4uZNjj4rOz6y8K8I7b2L1
         RxxOeXbwMEZpDEiwA7P5weMWERGXjsDvSIzG3jwozI0WCAFC5317ty/YtJaZshbWmTGt
         UaopkjfHNJNLLCUha2AzfFiGcigpO4+QlTYJI73s4zN49Nbz8bPsoeo+zIYUZoRtW0tj
         UDFNZKVPdpZLYMi2SohA7ETdxoJAd1uLR8i6IEkyKNASBJAkdG3moY6Kk234I9ViCaSL
         ucbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkOTr9SItjKJoDycMahI5/oHi6EPM1ssOxtlPzqceFY=;
        b=3nJtbwtO6vsT+EP3x0pQDK7vYR7CYPQpgqswMRGgMIYcxLch/2O5p2nqEu6w7EavUc
         VTpVuyMEQuwCxFtF/PAY1kEEp/q98066Iwjvy8zKpDOVOQHg27FHLPz2bLqUi/mEComf
         Z2CPb1SvHXeMh+WkS3vPOUZFauPcHB8r/MQlULiTeHQD1yAkd7HWoIwRZwTzkUzsRBID
         tnB0kJ9VWpCQZvPEi+5ns1G1QZH+r89g19BxQ7pl4Xi0HjnYCafGEE62XlVDKkAqvPmT
         TR1JXUPik7pBChe6dkCxTx3Hsirn/FTLePpA4rA2aTKPy6ADPXBuUTqd4PKTrbldNGib
         tk2g==
X-Gm-Message-State: ACrzQf22zwtt0v/Z11/sclJ+/ko6L5Ak3kdHTZP/3dNmmwNEBj9zf/gz
        UvSniI9/Pd3+fBYiY1Wl6ahhmg==
X-Google-Smtp-Source: AMsMyM7rzsOnx9cmR8tUrWyQkYnuHkdHVOzYOHLWUDVt+oT0IjgcykUJSaf1PBY/vEUjSl+YMEs2Jg==
X-Received: by 2002:a05:6402:2802:b0:43a:9098:55a0 with SMTP id h2-20020a056402280200b0043a909855a0mr19417901ede.179.1667316762391;
        Tue, 01 Nov 2022 08:32:42 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id kx1-20020a170907774100b007add62dafb7sm2277851ejc.5.2022.11.01.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 08:32:42 -0700 (PDT)
Date:   Tue, 1 Nov 2022 16:32:41 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC  3/9] RISC-V: KVM: Define a probe function for SBI
 extension data structures
Message-ID: <20221101153241.wnox5zp7ymyg4gnx@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-4-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-4-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 10:01:59AM -0700, Atish Patra wrote:
> c,urrently the probe function just check if an SBI extension is
Currently                            checks

> registered or not. However, the extension may not want to advertise
> itself depending on some other condition.
> An additional extension specific probe function will allow
> extensions to decide if they want to be advertised to the caller or
> not. Any extension that do not require additional dependency check
                          does                                 checks

> does not required to implement this function.

s/does/is/

> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 83d6d4d2b1df..5853a1ef71ea 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -25,6 +25,9 @@ struct kvm_vcpu_sbi_extension {
>  	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
>  		       bool *exit);
> +
> +	/* Extension specific probe function */
> +	unsigned long (*probe)(unsigned long extid);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 48f431091cdb..14be1a819588 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -22,6 +22,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	struct sbiret ecall_ret;
> +	const struct kvm_vcpu_sbi_extension *sbi_ext;
>  
>  	switch (cp->a6) {
>  	case SBI_EXT_BASE_GET_SPEC_VERSION:
> @@ -46,8 +47,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			 */
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
>  			*exit = true;
> -		} else
> -			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +		} else {
> +			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> +			if (sbi_ext) {
> +				if (sbi_ext->probe)
> +					*out_val = sbi_ext->probe(cp->a0);
> +				else
> +					*out_val = 1;
> +			} else
> +				*out_val = 0;
> +		}
>  		break;
>  	case SBI_EXT_BASE_GET_MVENDORID:
>  	case SBI_EXT_BASE_GET_MARCHID:
> -- 
> 2.25.1
>

Other than the commit message fixes

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
