Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A4C7D6CED
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbjJYNRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbjJYNRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:17:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50277116
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:17:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so888872366b.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698239839; x=1698844639; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jy1KAByMy5a9RQfpu8qBOEbRmatxzjbYkxJIicvAit0=;
        b=ZqqXPLfmxDqFoJecDJjGT3gxzC5nHTMXo+4g8mEXF/Ov6jjJv2Izf4YRppL3Rk94zf
         Dp+gsK5XUiLyAEzhjiVosqKTcOVYD8UIGo1wJRzfGMu6Zu0uCUowFnc+4mzH8s9bPGoq
         n3kUsqhPt2Nxku3MWC8lVhGiL8C0FGNwmK1MG/+D9Nxs5LCeZKiHdgQGtpb+vsfPWGbB
         MH+0XYJVriABJVos+MhqyM3xJyZP+waAKW1wnQ8OR2TjVZv+UhMQK1MEUEZdOEcLRkZD
         XW43dvpTxFI3yDT090E1h7V5U0XkUca837ptFQYaI7PBc1d1QillK8ivoZY02y6Wg1xl
         fSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239839; x=1698844639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jy1KAByMy5a9RQfpu8qBOEbRmatxzjbYkxJIicvAit0=;
        b=qODf87uGz6hUqGeMr8O0hs3H4xFCYcgMfboZHpbjGd53tIyckz/h9+HOTQRLVKOElQ
         vYOVmwHIyPPKSAMQEV4pKubckF1Qj+TVP/xL+pg07TbkZKR86yNPWpk2ztKeeGscOBze
         zYNNsJJ47dTGrwDeelxe8NhymSjaT10aZBzYc9s+D+JO481tsXosYEA2+aANII3f0Fee
         3BlhLjUpFHSmmpmU6ZTlGHyVq8/TjYj9Upb8srhO8SC/JerPfBVmoq8d41+dU9TPXJdG
         yIfmIWpuEjnCArnbxxsJNrjneJ4jQlmQhAuROy4EH+2O04TWnheHbHUEutJPtmKecHoI
         jPNA==
X-Gm-Message-State: AOJu0YzxzBvFC4P4Q8Cqv+gpLUuPV49RGRrBydr+4lhO2tZ9RvOBaFH6
        lz90tLEjPObSz+z+b8RJ+HIRRg==
X-Google-Smtp-Source: AGHT+IH+cCNf+3pG6YkI2bMEmIX5BBkX6XMkqTdirqLRe9UvLaWhL/+WZ5XUIX9zv1lbciz+9wg3ag==
X-Received: by 2002:a17:907:2da3:b0:9bf:60f9:9b7f with SMTP id gt35-20020a1709072da300b009bf60f99b7fmr12579815ejc.4.1698239838688;
        Wed, 25 Oct 2023 06:17:18 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id qk2-20020a170906d9c200b009b97aa5a3aesm9985279ejb.34.2023.10.25.06.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:17:18 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:17:17 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 4/6] riscv: Add IRQFD support for in-kernel
 AIA irqchip
Message-ID: <20231025-dbbd1ae8936d3f31aa136179@orel>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-5-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918125730.1371985-5-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 06:27:28PM +0530, Anup Patel wrote:
> To use irqfd with in-kernel AIA irqchip, we add custom
> irq__add_irqfd and irq__del_irqfd functions. This allows
> us to defer actual KVM_IRQFD ioctl() until AIA irqchip
> is initialized by KVMTOOL.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/include/kvm/kvm-arch.h | 11 ++++++
>  riscv/irq.c                  | 73 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index cd37fc6..1a8af6a 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -98,11 +98,22 @@ extern void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm);
>  extern u32 riscv_irqchip_phandle;
>  extern u32 riscv_irqchip_msi_phandle;
>  extern bool riscv_irqchip_line_sensing;
> +extern bool riscv_irqchip_irqfd_ready;
>  
>  void plic__create(struct kvm *kvm);
>  
>  void pci__generate_fdt_nodes(void *fdt);
>  
> +int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
> +		     int resample_fd);
> +
> +void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd);
> +
> +#define irq__add_irqfd riscv__add_irqfd
> +#define irq__del_irqfd riscv__del_irqfd
> +
> +int riscv__setup_irqfd_lines(struct kvm *kvm);
> +
>  void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
>  
>  void riscv__irqchip_create(struct kvm *kvm);
> diff --git a/riscv/irq.c b/riscv/irq.c
> index b608a2f..e6c0939 100644
> --- a/riscv/irq.c
> +++ b/riscv/irq.c
> @@ -12,6 +12,7 @@ void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm) = NULL;
>  u32 riscv_irqchip_phandle = PHANDLE_RESERVED;
>  u32 riscv_irqchip_msi_phandle = PHANDLE_RESERVED;
>  bool riscv_irqchip_line_sensing = false;
> +bool riscv_irqchip_irqfd_ready = false;
>  
>  void kvm__irq_line(struct kvm *kvm, int irq, int level)
>  {
> @@ -46,6 +47,78 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
>  	}
>  }
>  
> +struct riscv_irqfd_line {
> +	unsigned int		gsi;
> +	int			trigger_fd;
> +	int			resample_fd;
> +	struct list_head	list;
> +};
> +
> +static LIST_HEAD(irqfd_lines);
> +
> +int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
> +		     int resample_fd)
> +{
> +	struct riscv_irqfd_line *line;
> +
> +	if (riscv_irqchip_irqfd_ready)
> +		return irq__common_add_irqfd(kvm, gsi, trigger_fd,
> +					     resample_fd);
> +
> +	/* Postpone the routing setup until we have a distributor */

This comment comes from the Arm code. We probably want to replace
distributor with "until the AIA is initialized" or something.

> +	line = malloc(sizeof(*line));
> +	if (!line)
> +		return -ENOMEM;
> +
> +	*line = (struct riscv_irqfd_line) {
> +		.gsi		= gsi,
> +		.trigger_fd	= trigger_fd,
> +		.resample_fd	= resample_fd,
> +	};
> +	list_add(&line->list, &irqfd_lines);
> +
> +	return 0;
> +}
> +
> +void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd)
> +{
> +	struct riscv_irqfd_line *line;
> +
> +	if (riscv_irqchip_irqfd_ready) {
> +		irq__common_del_irqfd(kvm, gsi, trigger_fd);
> +		return;
> +	}
> +
> +	list_for_each_entry(line, &irqfd_lines, list) {
> +		if (line->gsi != gsi)
> +			continue;
> +
> +		list_del(&line->list);
> +		free(line);
> +		break;
> +	}
> +}
> +
> +int riscv__setup_irqfd_lines(struct kvm *kvm)
> +{
> +	int ret;
> +	struct riscv_irqfd_line *line, *tmp;
> +
> +	list_for_each_entry_safe(line, tmp, &irqfd_lines, list) {
> +		ret = irq__common_add_irqfd(kvm, line->gsi, line->trigger_fd,
> +					    line->resample_fd);
> +		if (ret < 0) {
> +			pr_err("Failed to register IRQFD");
> +			return ret;
> +		}
> +
> +		list_del(&line->list);
> +		free(line);
> +	}
> +
> +	return 0;
> +}
> +
>  void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
>  {
>  	u32 prop[2], size;
> -- 
> 2.34.1
>

Other than the comment,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
