Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D16A614B22
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 13:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiKAMvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiKAMvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 08:51:24 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCBD1B1FD
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 05:51:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l11so20413096edb.4
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I3ZWUelOBGuajwMCGSZuHahRmnca9IMPS5lnk5/9ETI=;
        b=SH22qPUXsEn3p/Floa1ZUMCLaXYV8bLk5ULHiQsQqH465E1SVAmIu6Gj850XUtWV9A
         D3vcOJJpkBKDfQObFbUbvPzsspuQeDi8iVxdxbPuOD5L9lqdeXzBxpoBhQrusiuhFHEW
         X5gb+sDNXCfylI/G4HA9XvQ5zBoOQLjxCMPiCtygwfXo80GSGpNvwLPh/Z+T/8bh3Zuk
         SwXqo9RR/EoPDC2jCc+HLc5z3HKMEmC/z195V79dBXKBEvrvXGJaudJx8wGWvzn2YMCf
         SHKwY8wXPJECzov7T2eLVkWbEI2/y+28jeSZJQxu8o71oB3W65T8TXYTCq5r5pvnAkJ1
         KxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3ZWUelOBGuajwMCGSZuHahRmnca9IMPS5lnk5/9ETI=;
        b=WBO+vR9tKlLIYfTKBYMX2jGDPYPqDOIttPLUI1RQtoq3U5jnm6lehe/RxKpF2HFqKF
         46XY7Pw0cyNuxQ/rkZ5bOgmHJBfP1jqnXl9io++5w9iRrB938MprWsaOqgJmMptgubz9
         DndHGqDaYRgzq/vLnmMvlEkTDZFVFh6dFkTGnG4sqzF7FMOzl7hzXoyE6X82NlsnPf7E
         5U1FcfoRMyPXMPKHzhP4qHx9DBwNqBm0F7/up1YSKhcxfEezPVymxueXRkB/R0Stc6hK
         aS974alq2GJIKDXPCXj2WDIbMqzFf15grhDq1aSfotZMsjlOEoA9BUHB+28Fo0barvmm
         QcLg==
X-Gm-Message-State: ACrzQf371353DngG6I+a9LutDfdAiLMoLUvPA06OWu430uBWdOYcXxrU
        5d95NnB+DEIntCEf39KGGc0kZg==
X-Google-Smtp-Source: AMsMyM49yeZoSu5tYqBhel3Vi41lPu+IDsM9aRBTodsPAIXmVMIiAGsNUkmhNpKrHHoSwAH+rwrGSg==
X-Received: by 2002:a05:6402:158d:b0:463:2343:b980 with SMTP id c13-20020a056402158d00b004632343b980mr14233232edv.150.1667307081713;
        Tue, 01 Nov 2022 05:51:21 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id e22-20020a17090658d600b007ad0b97e6e9sm4112927ejs.162.2022.11.01.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 05:51:21 -0700 (PDT)
Date:   Tue, 1 Nov 2022 13:51:20 +0100
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
Subject: Re: [RFC  4/9] RISC-V: KVM: Improve privilege mode filtering for perf
Message-ID: <20221101125120.lkd3n3yybihjhzyk@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-5-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-5-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 10:02:00AM -0700, Atish Patra wrote:
> Currently, the host driver doesn't have any method to identify if the
> requested perf event is from kvm or bare metal. As KVM runs in HS
> mode, there are no separate hypervisor privilege mode to distinguish
> between the attributes for guest/host.
> 
> Improve the privilege mode filtering by using the event specific
> config1 field.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 27 ++++++++++++++++++++++-----
>  include/linux/perf/riscv_pmu.h |  2 ++
>  2 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 5d0eef3ef136..34f9fcc221a8 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -275,6 +275,27 @@ int riscv_pmu_sbi_hpmc_width(void)
>  }
>  EXPORT_SYMBOL(riscv_pmu_sbi_hpmc_width);
>  
> +static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
> +{
> +	unsigned long cflags = 0;
> +	bool guest_events = false;
> +
> +	if (event->attr.config1 & RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS)
> +		guest_events = true;
> +	if (event->attr.exclude_kernel)
> +		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_user)
> +		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FLAG_SET_UINH;
> +	if (guest_events && event->attr.exclude_hv)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_host)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
> +	if (event->attr.exclude_guest)
> +		cflags |= SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
> +
> +	return cflags;
> +}
> +
>  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
> @@ -286,11 +307,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  	uint64_t cmask = GENMASK_ULL(rvpmu->num_counters - 1, 0);
>  	unsigned long cflags = 0;
>  
> -	if (event->attr.exclude_kernel)
> -		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
> -	if (event->attr.exclude_user)
> -		cflags |= SBI_PMU_CFG_FLAG_SET_UINH;
> -
> +	cflags = pmu_sbi_get_filter_flags(event);
>  	/* retrieve the available counter index */
>  #if defined(CONFIG_32BIT)
>  	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase, cmask,
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> index 6fee211c27b5..825b95253bc5 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -26,6 +26,8 @@
>  
>  #define RISCV_PMU_STOP_FLAG_RESET 1
>  
> +#define RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS 0x1
> +
>  struct cpu_hw_events {
>  	/* currently enabled events */
>  	int			n_events;
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
