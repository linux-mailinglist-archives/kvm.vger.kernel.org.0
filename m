Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A055374F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiFUQGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353456AbiFUQGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:06:40 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8FEFDE
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:06:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 68so8095540pgb.10
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MVIoP5JlRYJj7zIlLXW2/KXdAWrSbsQe7aXgNhaYJ38=;
        b=dGModeRbTszqDTYIlDory2a9h9neXbYf8jV1B6Gvp41FL6uw8ZeDGn0Z2LcP7TQnEV
         XdwdPFY0Dn+albP+acHfEk/xRh7CGOqw5vusSp3lqjY3KE7E8LrD0P6hp3nB9iiZjwWQ
         R1nIsbWeOJGEYkQYxRFzvYL6yEwhFRrrUFyoqzq5IzqFOgLaBMXHhbAN7qApJHyXxaIf
         z7s2fGdDJLuEj8SX0wy6OgKCa7GiUPsrWvOKmE2Hb4XSTQvNxnsfyIyJ8P6r9JeJRpYE
         +7iXsglLYaVMlJ2FOhZcHP3gpWMjh2kOM1BKdNDYKns3o+aygmERzLkyrWZrxAMSc/Ja
         LUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MVIoP5JlRYJj7zIlLXW2/KXdAWrSbsQe7aXgNhaYJ38=;
        b=YgunWMyOSqx5GvijYpM32jHwFzS8CQ51/Kq9ugmRN027xPhkDFjkDMSuzWrxB3hnWl
         lV5n/Bi9VJdmlZgRxfbatVPxxymXB0w9IjwLrGS8lKfE/XFfIm6bH2Dr/Uovu6NLyB6b
         OOeTj+vNlZNLzsga6foc2O1DQ62+P81sg2415aJhrRb/GuAizdCmYARtaj+M2eHcwVY5
         IIMc9oVuppwRUgDhHMy0sP2U84UzchSsb+M9RBGp/xhs9c+2der8sGfrgMKCHrPY+kv4
         4iZs4DNfLz20g8CryMPp+HB6e3CX8LQPHhrTYsL0ya7k+yFcVHKXYETm4FMsJj+fJMoy
         HNjw==
X-Gm-Message-State: AJIora8+WOYyv++dVXt5jNCWKvGa32fD3axuC/rFFxD7uGXf8LvR6Rp3
        11I7Fr6Ogs/pR9s5KhvkMKyzxA==
X-Google-Smtp-Source: AGRyM1sGzf2JW9Xx4SHLPtvKcCb54gXSbHfXGHaGkJSyLu4icYxWWuzKQ4pOsWEAuEfhMFgkIu0/gA==
X-Received: by 2002:a05:6a00:2353:b0:520:6d4f:4594 with SMTP id j19-20020a056a00235300b005206d4f4594mr30821692pfj.34.1655827596914;
        Tue, 21 Jun 2022 09:06:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h9-20020a056a001a4900b0052515e20df8sm6336041pfv.152.2022.06.21.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:06:36 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:06:33 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 05/23] arm/arm64: Add support for
 setting up the PSCI conduit through ACPI
Message-ID: <YrHsiUHys4B2EYOg@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-6-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-6-nikos.nikoleris@arm.com>
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

On Fri, May 06, 2022 at 09:55:47PM +0100, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the FADT to discover whether PSCI calls need to use smc or hvc
> calls. This change implements this but retains the default behavior;
> we check if a valid DT is provided, if not, we try to setup the PSCI
> conduit using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/Makefile.common |  1 +
>  lib/acpi.h          |  5 +++++
>  lib/arm/psci.c      | 23 ++++++++++++++++++++++-
>  lib/devicetree.c    |  2 +-
>  4 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 38385e0..8e9b3bb 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
> +cflatobjs += lib/acpi.o
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-host-generic.o
>  cflatobjs += lib/pci-testdev.o
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 9f27eb1..139ccba 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -130,6 +130,11 @@ struct acpi_table_fadt
>      u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
>  }  __attribute__ ((packed));
>  
> +/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
> +
> +#define ACPI_FADT_PSCI_COMPLIANT    (1)         /* 00: [V5+] PSCI 0.2+ is implemented */
> +#define ACPI_FADT_PSCI_USE_HVC      (1<<1)      /* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
> +
>  struct facs_descriptor_rev1
>  {
>      u32 signature;           /* ACPI Signature */
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 9c031a1..0e96d19 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -6,6 +6,7 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <acpi.h>
>  #include <devicetree.h>
>  #include <asm/psci.h>
>  #include <asm/setup.h>
> @@ -56,7 +57,7 @@ void psci_system_off(void)
>  	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>  }
>  
> -void psci_set_conduit(void)
> +static void psci_set_conduit_fdt(void)
>  {
>  	const void *fdt = dt_fdt();
>  	const struct fdt_property *method;
> @@ -75,3 +76,23 @@ void psci_set_conduit(void)
>  	else
>  		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
>  }
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +	assert_msg(fadt, "Unable to find ACPI FADT");
> +	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> +		   "PSCI is not supported in this platfrom");
> +	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
> +		psci_invoke = psci_invoke_hvc;
> +	else
> +		psci_invoke = psci_invoke_smc;
> +}
> +
> +void psci_set_conduit(void)
> +{
> +	if (dt_available())
> +		psci_set_conduit_fdt();
> +	else
> +		psci_set_conduit_acpi();
> +}
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 78c1f6f..3ff9d16 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -16,7 +16,7 @@ const void *dt_fdt(void)
>  
>  bool dt_available(void)
>  {
> -	return fdt_check_header(fdt) == 0;
> +	return fdt && fdt_check_header(fdt) == 0;
>  }
>  
>  int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
> -- 
>2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
