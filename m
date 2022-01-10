Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4651489E24
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 18:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbiAJROI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 12:14:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238061AbiAJROI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 12:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641834847;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OwkNEmN55JU96/ASO65aR43EkpF+6fG5Yz1cY2wG7A=;
        b=gU40bLJ52rUovQUFNLHpDtbqYtPGqJGMAUR4AveKt3mr9vrkVqj75YoobLVxvAEcxar7k6
        Pfa64xDzMhjuzd4HWs5AWwuHZe/Q1kFR0WwMMcs4LJN/cxaVuBZH0Sd5kXqgPr08rTgQdT
        D3n9S/3eBhkFhAe5LxTU17oPTxG0Bbg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-lq-9FAlaPcuO66_hlNPKpA-1; Mon, 10 Jan 2022 12:14:06 -0500
X-MC-Unique: lq-9FAlaPcuO66_hlNPKpA-1
Received: by mail-wm1-f71.google.com with SMTP id o18-20020a05600c511200b00345c1603997so2399530wms.1
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:14:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=/OwkNEmN55JU96/ASO65aR43EkpF+6fG5Yz1cY2wG7A=;
        b=QQDlrTV2bJnNwLNjwa5YhhVrhCfNHvhxKUHlfnbhQesGreNmuX2oJXaBJNJxA7yxMh
         YL8SC1vpJ0wfT/LC9sMfEjNpdIxxyfrkDL5bVk4gWDIyYOABZwnQ7TpXA5tz4PfLp3ZZ
         8WqTopdrGDvaB95FIlcrkTSY7GW9W1uKXGpu3vcgBfrLUuG3LOCUBimMHDY7EIsihoY8
         +EpznSLfh/6Setrd1Ap7tK9cYxK009l+dpUjt6mCAXQXwibSP22c4zTQRTAWjmjF7Nem
         SyxzkKredQrRqMtPvyxaFCioCl0cQxgZL9Ahy3TZEVMWwn8odSCP9Kx7Wb/78ScSe3Je
         GhwQ==
X-Gm-Message-State: AOAM531L+dCfKa7Q6REr6QOH9qzKUCX7J4vidlddgxNCT53o0lbGDA9M
        rrgkc+99LDo/1L+BjRwHQjaMyeiF2DGiDV/SVDTz/lpEOeRYfldwpJQfzy7SeQ9E6oSmoo2KB8F
        Yxp/cDRkvEp9a
X-Received: by 2002:a1c:1b8f:: with SMTP id b137mr13975731wmb.115.1641834845310;
        Mon, 10 Jan 2022 09:14:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX/AVDnmSq9VH+zfYVCj+he8c52vstnXhZ8DJLq9SVI9o4IHfyMCkkhoDPHbGcjU2e6D7Ycg==
X-Received: by 2002:a1c:1b8f:: with SMTP id b137mr13975716wmb.115.1641834845157;
        Mon, 10 Jan 2022 09:14:05 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w7sm1646476wrv.96.2022.01.10.09.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 09:14:04 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 6/6] hw/arm/virt: Drop superfluous checks against
 highmem
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-7-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <ddb29c44-bcbb-b3fd-c226-889b352b1dc8@redhat.com>
Date:   Mon, 10 Jan 2022 18:14:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> Now that the devices present in the extended memory map are checked
> against the available PA space and disabled when they don't fit,
> there is no need to keep the same checks against highmem, as
> highmem really is a shortcut for the PA space being 32bit.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  hw/arm/virt-acpi-build.c | 2 --
>  hw/arm/virt.c            | 5 +----
>  2 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 505c61e88e..cdac009419 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -946,8 +946,6 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> -    vms->highmem_redists &= vms->highmem;
> -
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 70b4773b3e..641c6a9c31 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2170,9 +2170,6 @@ static void machvirt_init(MachineState *machine)
>  
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
> -    vms->highmem_mmio &= vms->highmem;
> -    vms->highmem_redists &= vms->highmem;
> -
>      create_gic(vms, sysmem);
>  
>      virt_cpu_post_init(vms, sysmem);
> @@ -2191,7 +2188,7 @@ static void machvirt_init(MachineState *machine)
>                         machine->ram_size, "mach-virt.tag");
>      }
>  
> -    vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
> +    vms->highmem_ecam &= (!firmware_loaded || aarch64);
>  
>      create_rtc(vms);
>  

