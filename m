Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA5554801
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiFVLmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiFVLmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:42:14 -0400
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9B8167D6;
        Wed, 22 Jun 2022 04:42:12 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 23so29698696ybe.8;
        Wed, 22 Jun 2022 04:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JCV2OlM0n75yGXq5Ao9M4QymaqH2JncanYB6RHIUZPs=;
        b=5KxsD1k27CkrO/nDlmgGnk7hRTxzA7TxK47lcvSFr7XxCZJYc5vv+IA3XQbk7KFoWy
         xeGnC6M78g7W1C0ia3jjMiCdS7c177xXI6oyfsbtQC4DGpevrp9T7/jdNJZbQe898nQt
         s//GcgLlZ9PnDTeXuHPfQGQj0LHXzfgpU8hPz17twbCyNM5bAq9AvUHQhV0nT4+Z08gh
         s1n5bBF4F7XmyeVBM3eI3B5v0KDqvgWHAOP0p2vUVsmWb55OOgX4dS3cQMLfVMQtyb3G
         /Keut+hSTy1DUPO7dW6GySz1L78Ul1RZ+bqGh56+Iq/zplSUYwJ+Z8pZTN89yJ0gcwlY
         nkmw==
X-Gm-Message-State: AJIora997Lv+RXvSWAiRwlYH20smtYY/ooYb6jQOksuwyYz46GoEMglO
        7NK21NrKBDclAFMO5gwZmpAl0L1VMyzq4XC1dpQ=
X-Google-Smtp-Source: AGRyM1t+UjB+W2u6c+KuvcQjZuiaMyR3JXTBhu8MFDYNtSJKpufG9a3kUq98N60z/GIEsB/1Kw+FvYOnSJeztB9YtCI=
X-Received: by 2002:a25:e910:0:b0:668:d4c6:8c2d with SMTP id
 n16-20020a25e910000000b00668d4c68c2dmr3091586ybd.81.1655898132092; Wed, 22
 Jun 2022 04:42:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655894131.git.kai.huang@intel.com> <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
In-Reply-To: <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Jun 2022 13:42:01 +0200
Message-ID: <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
To:     Kai Huang <kai.huang@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Tianyu.Lan@microsoft.com, Randy Dunlap <rdunlap@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>, dongli.zhang@oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
>
> Platforms with confidential computing technology may not support ACPI
> CPU hotplug when such technology is enabled by the BIOS.  Examples
> include Intel platforms which support Intel Trust Domain Extensions
> (TDX).
>
> If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> bug and reject the new CPU.  For hot-removal, for simplicity just assume
> the kernel cannot continue to work normally, and BUG().
>
> Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
> platform doesn't support ACPI CPU hotplug, so that kernel can handle
> ACPI CPU hotplug events for such platform.  The existing attribute
> CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.
>
> In acpi_processor_{add|remove}(), add early check against this attribute
> and handle accordingly if it is set.
>
> Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
> CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/coco/core.c          |  2 +-
>  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
>  include/linux/cc_platform.h   | 15 +++++++++++++--
>  kernel/cpu.c                  |  2 +-
>  4 files changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 4320fadae716..1bde1af75296 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
>  {
>         switch (attr) {
>         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> -       case CC_ATTR_HOTPLUG_DISABLED:
> +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
>         case CC_ATTR_GUEST_MEM_ENCRYPT:
>         case CC_ATTR_MEM_ENCRYPT:
>                 return true;
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index 6737b1cbf6d6..b960db864cd4 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -15,6 +15,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/cc_platform.h>
>
>  #include <acpi/processor.h>
>
> @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
>         struct device *dev;
>         int result = 0;
>
> +       /*
> +        * If the confidential computing platform doesn't support ACPI
> +        * memory hotplug, the BIOS should never deliver such event to
> +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> +        * the new CPU.
> +        */
> +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {

This will affect initialization, not just hotplug AFAICS.

You should reset the .hotplug.enabled flag in processor_handler to
false instead.

> +               dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI CPU hotplug.  New CPU ignored.\n");
> +               return -EINVAL;
> +       }
> +
>         pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
>         if (!pr)
>                 return -ENOMEM;
> @@ -434,6 +446,17 @@ static void acpi_processor_remove(struct acpi_device *device)
>         if (!device || !acpi_driver_data(device))
>                 return;
>
> +       /*
> +        * The confidential computing platform is broken if ACPI memory
> +        * hot-removal isn't supported but it happened anyway.  Assume
> +        * it's not guaranteed that the kernel can continue to work
> +        * normally.  Just BUG().
> +        */
> +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> +               dev_err(&device->dev, "Platform doesn't support ACPI CPU hotplug. BUG().\n");
> +               BUG();
> +       }
> +
>         pr = acpi_driver_data(device);
>         if (pr->id >= nr_cpu_ids)
>                 goto out;
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index 691494bbaf5a..9ce9256facc8 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -74,14 +74,25 @@ enum cc_attr {
>         CC_ATTR_GUEST_UNROLL_STRING_IO,
>
>         /**
> -        * @CC_ATTR_HOTPLUG_DISABLED: Hotplug is not supported or disabled.
> +        * @CC_ATTR_CPU_HOTPLUG_DISABLED: CPU hotplug is not supported or
> +        *                                disabled.
>          *
>          * The platform/OS is running as a guest/virtual machine does not
>          * support CPU hotplug feature.
>          *
>          * Examples include TDX Guest.
>          */
> -       CC_ATTR_HOTPLUG_DISABLED,
> +       CC_ATTR_CPU_HOTPLUG_DISABLED,
> +
> +       /**
> +        * @CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED: ACPI CPU hotplug is not
> +        *                                     supported.
> +        *
> +        * The platform/OS does not support ACPI CPU hotplug.
> +        *
> +        * Examples include TDX platform.
> +        */
> +       CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED,
>  };
>
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index edb8c199f6a3..966772cce063 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1191,7 +1191,7 @@ static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
>          * If the platform does not support hotplug, report it explicitly to
>          * differentiate it from a transient offlining failure.
>          */
> -       if (cc_platform_has(CC_ATTR_HOTPLUG_DISABLED))
> +       if (cc_platform_has(CC_ATTR_CPU_HOTPLUG_DISABLED))
>                 return -EOPNOTSUPP;
>         if (cpu_hotplug_disabled)
>                 return -EBUSY;
> --
> 2.36.1
>
