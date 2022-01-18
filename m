Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6566E49277D
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 14:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243162AbiARNvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 08:51:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235780AbiARNvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 08:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642513876;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtsWfSO5g+1IkZhp0URadLZGJDH3pn6puBwMTeb0Tvw=;
        b=A+kWj0oV0pnk/UIQLc9/x7AC65xKv5yjo9eGSOWIaeoIBukMQmx+HDfPnkHpClu/pHfgKl
        RRHU+g8NZjuqVdB1Ocuc0PoODd12Xh91GQbsg9cIuS9JUavs57qwx16pBUZCgBe82XEz2c
        LxzEn3iRQ45IO2yuTHxK0pj9aI9f4/c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-gqhYFXamOqu66IHY8mnRpQ-1; Tue, 18 Jan 2022 08:51:15 -0500
X-MC-Unique: gqhYFXamOqu66IHY8mnRpQ-1
Received: by mail-wm1-f69.google.com with SMTP id az10-20020a05600c600a00b0034d64b1203aso524382wmb.4
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 05:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=XtsWfSO5g+1IkZhp0URadLZGJDH3pn6puBwMTeb0Tvw=;
        b=0TMfsjnq9vbqc0od05glSiPvGNheT2ytKRTMD8n8aEo7ekfeeQP8ZWo8SBfAamn9O0
         /qfNqnKG/c+lf66kMuS5jGoTxFNP8zkii07ain2A88QpgiT1udmuXlUcvZvMLA5xHOmf
         4MYker7D8sBfrx6++v+XoZ82QqjHuqTYtHCsHIj1WS85aASWh+t5B1s87xTw5boKTK4J
         ewX3W6relrw+Amw7iN6OiUKCwnYbZgm81cluDh1bAxqQez3+Fa5MgeLs8XWRnGYaFjiK
         xEzHYKvxHVkYr1SNArmaAbMNtlOdcNo7K9xsHYW7JYgvO7po+OSdyXvQFUFWoilFIokY
         CdEg==
X-Gm-Message-State: AOAM5303hqgI6WFGIcCmxhb44RsgMD//0ELcgkz2i5lzwl9DtT9e2DUa
        noFT1EnU2nHq10lkHgVK/EH/vnDIlMowRAtlHpk9k2a1p5+XKgmJo7Rxy1Njcy9qz53o/iWddHX
        tqAOAqs0vfgRZ
X-Received: by 2002:adf:d216:: with SMTP id j22mr24178138wrh.577.1642513873895;
        Tue, 18 Jan 2022 05:51:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+zdAwpffOMmGVouMShoWBPumbBdn/bH0H3D0yY6l0Qqa/DIEvHGXEORdmRbsUH9omHoWCww==
X-Received: by 2002:adf:d216:: with SMTP id j22mr24178127wrh.577.1642513873737;
        Tue, 18 Jan 2022 05:51:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w9sm2903086wmc.36.2022.01.18.05.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 05:51:13 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20220114140741.1358263-1-maz@kernel.org>
 <20220114140741.1358263-3-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <8a25a161-6ad5-4a2a-c16b-b3784dd60af6@redhat.com>
Date:   Tue, 18 Jan 2022 14:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114140741.1358263-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/22 3:07 PM, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
>
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 2 ++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 449fab0080..0757c28f69 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -947,6 +947,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index ed8ea96acc..e734a75850 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2106,6 +2106,7 @@ static void machvirt_init(MachineState *machine)
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
>      vms->highmem_mmio &= vms->highmem;
> +    vms->highmem_redists &= vms->highmem;
>  
>      create_gic(vms, sysmem);
>  
> @@ -2805,6 +2806,7 @@ static void virt_instance_init(Object *obj)
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
>      vms->highmem_mmio = true;
> +    vms->highmem_redists = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 9c54acd10d..dc9fa26faa 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -144,6 +144,7 @@ struct VirtMachineState {
>      bool highmem;
>      bool highmem_ecam;
>      bool highmem_mmio;
> +    bool highmem_redists;
>      bool its;
>      bool tcg_its;
>      bool virt;
> @@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>  
>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>  
> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> +            vms->highmem_redists) ? 2 : 1;
>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */

