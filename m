Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7887D6D6F
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbjJYNjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbjJYNjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:39:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6B9133
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:39:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9bf86b77a2aso828885966b.0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698241149; x=1698845949; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xlqZcQmKJam/uuOhZJqqiwwBGbkLbhBUAM8p8PiCjlE=;
        b=SNKSUr8lkBY2HmWmSKcH3kZS57ZllP1+QIlHfEnCvECJaA9/JR5cOynA+suDQsUwfn
         oPczwQmJPEKffHJyWkQ/oK1uB2yK83lk5Gz0oHu+JKgYQgfLwn5LU/FMchC23f+MFJlK
         naCKumcGx+Fv028fWVF2ntbb058OS4hq6Qg6NDtLloS9PM66F2oDmCWrMLYC4MvHJ4Sb
         1MmY6tRKBUwEsx93V9wfmc8vH1fdYRGER4tEOnQWxs1lFuFpg9vneldnH4Wv6tGuMk5+
         8M80tN+0V0SQNdk/SO3Nwo9OA3F+Naf/ezbKC+IVzJl1YJN7J/sY2m8WvxnqdUjE1Fxp
         INYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698241149; x=1698845949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlqZcQmKJam/uuOhZJqqiwwBGbkLbhBUAM8p8PiCjlE=;
        b=fa5/EmmNB9t+vgkzEIPKYOsgL5zPq7/cORNMPGIpm75mKN4yP46lwd7SMnu5AeffXw
         AX+fJMOiUwqmmcQV5JylirT/BvML6pkM74mj/zaxidJuP/MPhyvlPlW/k4aQ5f38H88F
         FqDEmsm8QJfaJQwG/TaazXABB+9T4j2/hUPeF2RJ06z5TYKGOlwDF8JoL13KHGJ0IXa2
         4OonEQWOwEH3N7oyxAl0dYSqgwo52/DiuXvTwmAgebGPO1kMlaVLSmXgcVk2rsprTl06
         YgxAdxFEiVjXttLlIcNtwQUK+N3+yU3s8nRZs0efaZlTDt3T5c9fG0mE+kJ1NlFhvJwk
         fnXg==
X-Gm-Message-State: AOJu0YxSobnah+WkC4ciskpRkDBUE7j+YTlsRgmZjX0kLBtnsJ7AR0eQ
        Ve+JSSbQblgQEwZNxMs7v1ALPQ==
X-Google-Smtp-Source: AGHT+IGn2t9Bsc0iffDnje7GoEGhSQtsoiqyUE5VJQvq9pWNS8yBxIOButQeVdCRtH5D+PLo0xl0sQ==
X-Received: by 2002:a17:907:1ca4:b0:9bf:5696:9155 with SMTP id nb36-20020a1709071ca400b009bf56969155mr12224965ejc.8.1698241148706;
        Wed, 25 Oct 2023 06:39:08 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id lh22-20020a170906f8d600b0099290e2c163sm9777132ejb.204.2023.10.25.06.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:39:08 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:39:07 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 5/6] riscv: Use AIA in-kernel irqchip whenever
 KVM RISC-V supports
Message-ID: <20231025-2e789d3351d686df825e65f6@orel>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-6-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918125730.1371985-6-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 06:27:29PM +0530, Anup Patel wrote:
> The KVM RISC-V kernel module supports AIA in-kernel irqchip when
> underlying host has AIA support. We detect and use AIA in-kernel
> irqchip whenever possible otherwise we fallback to PLIC emulated
> in user-space.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  Makefile                     |   1 +
>  riscv/aia.c                  | 227 +++++++++++++++++++++++++++++++++++
>  riscv/include/kvm/fdt-arch.h |   8 +-
>  riscv/include/kvm/kvm-arch.h |   2 +
>  riscv/irq.c                  |   3 +
>  5 files changed, 240 insertions(+), 1 deletion(-)
>  create mode 100644 riscv/aia.c
> 
> diff --git a/Makefile b/Makefile
> index e711670..acd5ffd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -220,6 +220,7 @@ ifeq ($(ARCH),riscv)
>  	OBJS		+= riscv/kvm-cpu.o
>  	OBJS		+= riscv/pci.o
>  	OBJS		+= riscv/plic.o
> +	OBJS		+= riscv/aia.o
>  	ifeq ($(RISCV_XLEN),32)
>  		CFLAGS	+= -mabi=ilp32d -march=rv32gc
>  	endif
> diff --git a/riscv/aia.c b/riscv/aia.c
> new file mode 100644
> index 0000000..8c85b3f
> --- /dev/null
> +++ b/riscv/aia.c
> @@ -0,0 +1,227 @@
> +#include "kvm/devices.h"
> +#include "kvm/fdt.h"
> +#include "kvm/ioeventfd.h"
> +#include "kvm/ioport.h"
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/irq.h"
> +#include "kvm/util.h"
> +
> +static int aia_fd = -1;
> +
> +static u32 aia_mode = KVM_DEV_RISCV_AIA_MODE_EMUL;
> +static struct kvm_device_attr aia_mode_attr = {
> +	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +	.attr	= KVM_DEV_RISCV_AIA_CONFIG_MODE,
> +};
> +
> +static u32 aia_nr_ids = 0;
> +static struct kvm_device_attr aia_nr_ids_attr = {
> +	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +	.attr	= KVM_DEV_RISCV_AIA_CONFIG_IDS,
> +};
> +
> +static u32 aia_nr_sources = 0;
> +static struct kvm_device_attr aia_nr_sources_attr = {
> +	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +	.attr	= KVM_DEV_RISCV_AIA_CONFIG_SRCS,
> +};
> +
> +static u32 aia_hart_bits = 0;
> +static struct kvm_device_attr aia_hart_bits_attr = {
> +	.group	= KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +	.attr	= KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
> +};
> +
> +static u32 aia_nr_harts = 0;
> +
> +#define IRQCHIP_AIA_NR			0
> +
> +#define AIA_IMSIC_BASE			RISCV_IRQCHIP
> +#define AIA_IMSIC_ADDR(__hart)		\
> +	(AIA_IMSIC_BASE + (__hart) * KVM_DEV_RISCV_IMSIC_SIZE)
> +#define AIA_IMSIC_SIZE			\
> +	(aia_nr_harts * KVM_DEV_RISCV_IMSIC_SIZE)
> +#define AIA_APLIC_ADDR(__nr_harts)	\
> +	(AIA_IMSIC_BASE + (__nr_harts) * KVM_DEV_RISCV_IMSIC_SIZE)

AIA_APLIC_ADDR() probably doesn't need to take nr_harts since it's
always called with aia_nr_harts. So it could just be defined as

 #define AIA_APLIC_ADDR (AIA_IMSIC_BASE + AIA_IMSIC_SIZE)

> +
> +static void aia__generate_fdt_node(void *fdt, struct kvm *kvm)
> +{
> +	u32 i;
> +	char name[64];
> +	u32 reg_cells[4], *irq_cells;
> +
> +	irq_cells = calloc(aia_nr_harts * 2, sizeof(u32));
> +	if (!irq_cells)
> +		die("Failed to alloc irq_cells");
> +
> +	sprintf(name, "imsics@%08x", (u32)AIA_IMSIC_BASE);
> +	_FDT(fdt_begin_node(fdt, name));
> +	_FDT(fdt_property_string(fdt, "compatible", "riscv,imsics"));
> +	reg_cells[0] = 0;
> +	reg_cells[1] = cpu_to_fdt32(AIA_IMSIC_BASE);
> +	reg_cells[2] = 0;
> +	reg_cells[3] = cpu_to_fdt32(AIA_IMSIC_SIZE);
> +	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
> +	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0));
> +	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
> +	_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
> +	_FDT(fdt_property_cell(fdt, "riscv,num-ids", aia_nr_ids));
> +	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_IMSIC));
> +	for (i = 0; i < aia_nr_harts; i++) {
> +		irq_cells[2*i + 0] = cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
> +		irq_cells[2*i + 1] = cpu_to_fdt32(9);
> +	}
> +	_FDT(fdt_property(fdt, "interrupts-extended", irq_cells,
> +			  sizeof(u32) * aia_nr_harts * 2));
> +	_FDT(fdt_end_node(fdt));
> +
> +	free(irq_cells);
> +
> +	/* Skip APLIC node if we have no interrupt sources */
> +	if (!aia_nr_sources)
> +		return;
> +
> +	sprintf(name, "aplic@%08x", (u32)AIA_APLIC_ADDR(aia_nr_harts));
> +	_FDT(fdt_begin_node(fdt, name));
> +	_FDT(fdt_property_string(fdt, "compatible", "riscv,aplic"));
> +	reg_cells[0] = 0;
> +	reg_cells[1] = cpu_to_fdt32(AIA_APLIC_ADDR(aia_nr_harts));
> +	reg_cells[2] = 0;
> +	reg_cells[3] = cpu_to_fdt32(KVM_DEV_RISCV_APLIC_SIZE);
> +	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
> +	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 2));
> +	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
> +	_FDT(fdt_property_cell(fdt, "riscv,num-sources", aia_nr_sources));
> +	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_APLIC));
> +	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_AIA_IMSIC));
> +	_FDT(fdt_end_node(fdt));
> +}
> +
> +static int aia__irq_routing_init(struct kvm *kvm)
> +{
> +	int r;
> +	int irqlines = aia_nr_sources + 1;
> +
> +	/* Skip this if we have no interrupt sources */
> +	if (!aia_nr_sources)
> +		return 0;
> +
> +	/*
> +	 * This describes the default routing that the kernel uses without
> +	 * any routing explicitly set up via KVM_SET_GSI_ROUTING. So we
> +	 * don't need to commit these setting right now. The first actual
> +	 * user (MSI routing) will engage these mappings then.
> +	 */
> +	for (next_gsi = 0; next_gsi < irqlines; next_gsi++) {
> +		r = irq__allocate_routing_entry();
> +		if (r)
> +			return r;
> +
> +		irq_routing->entries[irq_routing->nr++] =
> +			(struct kvm_irq_routing_entry) {
> +				.gsi = next_gsi,
> +				.type = KVM_IRQ_ROUTING_IRQCHIP,
> +				.u.irqchip.irqchip = IRQCHIP_AIA_NR,
> +				.u.irqchip.pin = next_gsi,
> +		};
> +	}
> +
> +	return 0;
> +}
> +
> +static int aia__init(struct kvm *kvm)
> +{
> +	int i, ret;
> +	u64 aia_addr = 0;
> +	struct kvm_device_attr aia_addr_attr = {
> +		.group	= KVM_DEV_RISCV_AIA_GRP_ADDR,
> +		.addr	= (u64)(unsigned long)&aia_addr,
> +	};
> +	struct kvm_device_attr aia_init_attr = {
> +		.group	= KVM_DEV_RISCV_AIA_GRP_CTRL,
> +		.attr	= KVM_DEV_RISCV_AIA_CTRL_INIT,
> +	};
> +
> +	/* Setup global device attribute variables */
> +	aia_mode_attr.addr = (u64)(unsigned long)&aia_mode;
> +	aia_nr_ids_attr.addr = (u64)(unsigned long)&aia_nr_ids;
> +	aia_nr_sources_attr.addr = (u64)(unsigned long)&aia_nr_sources;
> +	aia_hart_bits_attr.addr = (u64)(unsigned long)&aia_hart_bits;
> +
> +	/* Do nothing if AIA device not created */
> +	if (aia_fd < 0)
> +		return 0;
> +
> +	/* Set/Get AIA device config parameters */
> +	ret = ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_mode_attr);
> +	if (ret)
> +		return ret;
> +	ret = ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_nr_ids_attr);
> +	if (ret)
> +		return ret;
> +	aia_nr_sources = irq__get_nr_allocated_lines();
> +	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
> +	if (ret)
> +		return ret;
> +	aia_hart_bits = fls_long(kvm->nrcpus);
> +	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
> +	if (ret)
> +		return ret;
> +
> +	/* Save number of HARTs for FDT generation */
> +	aia_nr_harts = kvm->nrcpus;
> +
> +	/* Set AIA device addresses */
> +	aia_addr = AIA_APLIC_ADDR(aia_nr_harts);
> +	aia_addr_attr.attr = KVM_DEV_RISCV_AIA_ADDR_APLIC;
> +	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr);
> +	if (ret)
> +		return ret;
> +	for (i = 0; i < kvm->nrcpus; i++) {
> +		aia_addr = AIA_IMSIC_ADDR(i);
> +		aia_addr_attr.attr = KVM_DEV_RISCV_AIA_ADDR_IMSIC(i);
> +		ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Setup default IRQ routing */
> +	aia__irq_routing_init(kvm);
> +
> +	/* Initialize the AIA device */
> +	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_init_attr);
> +	if (ret)
> +		return ret;
> +
> +	/* Mark IRQFD as ready */
> +	riscv_irqchip_irqfd_ready = true;
> +
> +	return 0;
> +}
> +late_init(aia__init);
> +
> +void aia__create(struct kvm *kvm)
> +{
> +	int err;
> +	struct kvm_create_device aia_device = {
> +		.type = KVM_DEV_TYPE_RISCV_AIA,
> +		.flags = 0,
> +	};
> +
> +	if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
> +		return;
> +
> +	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
> +	if (err)
> +		return;
> +	aia_fd = aia_device.fd;
> +
> +	riscv_irqchip = IRQCHIP_AIA;
> +	riscv_irqchip_inkernel = true;
> +	riscv_irqchip_trigger = NULL;
> +	riscv_irqchip_generate_fdt_node = aia__generate_fdt_node;
> +	riscv_irqchip_phandle = PHANDLE_AIA_APLIC;
> +	riscv_irqchip_msi_phandle = PHANDLE_AIA_IMSIC;
> +	riscv_irqchip_line_sensing = true;
> +}
> diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
> index f7548e8..d88b832 100644
> --- a/riscv/include/kvm/fdt-arch.h
> +++ b/riscv/include/kvm/fdt-arch.h
> @@ -1,7 +1,13 @@
>  #ifndef KVM__KVM_FDT_H
>  #define KVM__KVM_FDT_H
>  
> -enum phandles {PHANDLE_RESERVED = 0, PHANDLE_PLIC, PHANDLES_MAX};
> +enum phandles {
> +	PHANDLE_RESERVED = 0,
> +	PHANDLE_PLIC,
> +	PHANDLE_AIA_APLIC,
> +	PHANDLE_AIA_IMSIC,
> +	PHANDLES_MAX
> +};
>  
>  #define PHANDLE_CPU_INTC_BASE	PHANDLES_MAX
>  
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index 1a8af6a..9f2159f 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -100,6 +100,8 @@ extern u32 riscv_irqchip_msi_phandle;
>  extern bool riscv_irqchip_line_sensing;
>  extern bool riscv_irqchip_irqfd_ready;
>  
> +void aia__create(struct kvm *kvm);
> +

nit: I'd remove the blank line between *__create functions.

>  void plic__create(struct kvm *kvm);
>  
>  void pci__generate_fdt_nodes(void *fdt);
> diff --git a/riscv/irq.c b/riscv/irq.c
> index e6c0939..be3e7ac 100644
> --- a/riscv/irq.c
> +++ b/riscv/irq.c
> @@ -135,6 +135,9 @@ void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
>  
>  void riscv__irqchip_create(struct kvm *kvm)
>  {
> +	/* Try AIA in-kernel irqchip. */
> +	aia__create(kvm);
> +
>  	/* Try PLIC irqchip */
>  	plic__create(kvm);

I realize plic__create() just returns if aia__create() successful set up
the irqchip, but structuring this like

 ret = aia__create(kvm);
 if (!ret)
    ret = plic__create(kvm);
 if (!ret)
    die(...);

Might be a little easier to for future readers of the code to grok on
first read.


Either way,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
