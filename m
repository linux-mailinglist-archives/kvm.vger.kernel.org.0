Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA96553745
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353581AbiFUQHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353533AbiFUQHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:07:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633EAF1E
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:07:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g8so12948043plt.8
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CxxwIUKYZuGYVao+PWX0X7XcmN82hYa0bOxXcAjwdSE=;
        b=Ftvf43psDpi2/zqmRTRHSCBYnwPEtttrQklF/yTD2YbVU4Debq+rdsiiarqS3wezJb
         VS7PSJyHuGRvqIAbK5QIsppFRZrk0YATHc/eP4MUav3HVV/gQSrYtGJiU1+bERcllbgI
         N9x420IeYLSpa2siFy0IgBEx78CnNYWAe4jgqG28I251qJixG0AMYLUZ2ssb/bXn5zHI
         CmBT4F3KG9xXJuHWouMZHkEhVqLct72rubkBeKoYhIET6RuV+OSa9qXQ0ym607w+mAd5
         rHiX6ktA0o1t3xGLWARn/ahQ83TXJLl8IO/rXJq2ColVw9t418TYLqXfs77ANbILBR7S
         U/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CxxwIUKYZuGYVao+PWX0X7XcmN82hYa0bOxXcAjwdSE=;
        b=FRt9tMQvJXTvvzJ4iZ4To12YbEaImZCaJ79AdpZn1q5z2nQi5w7SKHJFwxGHlfv+GP
         2DzIaM6wQEpS07dVjxf1Zocb03+61kE7u8yqPs4bwc6chxH5Z4NUtqTUFQio7eBFwSBk
         5A1QXaaNj88YxzGBsK7rzwo61XI1jsGxmHp32NG3ULoMdxo7YN3TXVAtw3KzxynsFk7f
         xRrD11FwJlOFOVoGsWM7efbRI6AOIWck6Qx68SQbze13VVgZ10ce4Cr/lWHPvweRT9XZ
         lXA0RMvdF/m0IugHml4KU+RzzG7VmM6vqXaCiOJUSZOPx6xdOsdiqNO3npnKQ9YP2yB9
         bV2w==
X-Gm-Message-State: AJIora/LuEm55t9tOkk4tnlggMhd2mQKh5xWAZFUleK/r2WKB5nbovWZ
        tqRgwGY/JA6IH76UfEJ56sxitw==
X-Google-Smtp-Source: AGRyM1tp6tKvf5xpKCMMsJMYyYzNjgzs85zFeRT7RkMMjzcqMp7ky42YXpJpfIhGZU6KNqjOFNsN2w==
X-Received: by 2002:a17:90b:388:b0:1ec:cc6c:5616 with SMTP id ga8-20020a17090b038800b001eccc6c5616mr3700704pjb.180.1655827623612;
        Tue, 21 Jun 2022 09:07:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w9-20020a62c709000000b0051ba97b788bsm11642623pfg.27.2022.06.21.09.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:07:03 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:07:00 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 06/23] arm/arm64: Add support for
 discovering the UART through ACPI
Message-ID: <YrHspKrH/Nt/Z96l@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-7-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-7-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:48PM +0100, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the SPCR to discover the serial port address range. This change
> implements this but retains the default behavior; we check if a valid
> DT is provided, if not, we try to discover the UART using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h     | 25 +++++++++++++++++++++++++
>  lib/arm/io.c   | 21 +++++++++++++++++++--
>  lib/arm/psci.c |  4 +++-
>  3 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 139ccba..5213299 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -16,6 +16,7 @@
>  #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>  
>  
>  #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
> @@ -147,6 +148,30 @@ struct facs_descriptor_rev1
>      u8  reserved3 [40];         /* Reserved - must be zero */
>  } __attribute__ ((packed));
>  
> +struct spcr_descriptor {
> +    ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
> +    u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
> +    u8 reserved[3];
> +    struct acpi_generic_address serial_port;
> +    u8 interrupt_type;
> +    u8 pc_interrupt;
> +    u32 interrupt;
> +    u8 baud_rate;
> +    u8 parity;
> +    u8 stop_bits;
> +    u8 flow_control;
> +    u8 terminal_type;
> +    u8 reserved1;
> +    u16 pci_device_id;
> +    u16 pci_vendor_id;
> +    u8 pci_bus;
> +    u8 pci_device;
> +    u8 pci_function;
> +    u32 pci_flags;
> +    u8 pci_segment;
> +    u32 reserved2;
> +} __attribute__ ((packed));
> +
>  void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>  void* find_acpi_table_addr(u32 sig);
>  
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e108..893bdfc 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -8,6 +8,7 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <acpi.h>
>  #include <libcflat.h>
>  #include <devicetree.h>
>  #include <chr-testdev.h>
> @@ -29,7 +30,7 @@ static struct spinlock uart_lock;
>  #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>  static volatile u8 *uart0_base = UART_EARLY_BASE;
>  
> -static void uart0_init(void)
> +static void uart0_init_fdt(void)
>  {
>  	/*
>  	 * kvm-unit-tests uses the uart only for output. Both uart models have
> @@ -73,9 +74,25 @@ static void uart0_init(void)
>  	}
>  }
>  
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> +
> +	if (uart0_base != UART_EARLY_BASE) {
> +		printf("WARNING: early print support may not work. "
> +		       "Found uart at %p, but early base is %p.\n",
> +			uart0_base, UART_EARLY_BASE);
> +	}
> +}
> +
>  void io_init(void)
>  {
> -	uart0_init();
> +	if (dt_available())
> +		uart0_init_fdt();
> +	else
> +		uart0_init_acpi();
>  	chr_testdev_init();
>  }
>  
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 0e96d19..afbc33d 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -80,9 +80,11 @@ static void psci_set_conduit_fdt(void)
>  static void psci_set_conduit_acpi(void)
>  {
>  	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +
>  	assert_msg(fadt, "Unable to find ACPI FADT");
>  	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> -		   "PSCI is not supported in this platfrom");
> +		   "PSCI is not supported in this platform");
> +
>  	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
>  		psci_invoke = psci_invoke_hvc;
>  	else
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
