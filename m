Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4679A4B395C
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 06:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiBMFFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 00:05:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiBMFFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 00:05:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD74F5E768
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 21:05:38 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y5so23535195pfe.4
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 21:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:cc:in-reply-to:content-transfer-encoding;
        bh=SvASqGw57nnd+VLnYfU88dyRPvfuj1Dziis/gpDvPDQ=;
        b=XBfoxrRuIu3fmcbhjJ9kr7VMkCaBcJPqOurHmRK/FiCs/ms8WaQX1+mimEBoUIpFTy
         xJbVxkqyJGJ+3UaCl4oKwzFlzG9jWw5b1pRVl2DvbkLXt03ATv+tkT6D1Dpp0xtWy8xv
         G/w5f5rX2k0b2B82um9zrqxd9V3zkCE+/AiXXRm+uP0S7fTIPQVH6S1pVpdsAYSvtmCf
         lo3U4Guzx78b+GBEBIboxzMUhDuEKvceAKQ6rXaYq6Xw5WUPmZyzrQhI3aq0IwY4C3x+
         kXP3BMcSfvyqPG/yUZpOrSqvpzoywuA8txl+CJiOghHDWc9QTtX3iOZOoh62DGcofK60
         uJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:cc:in-reply-to
         :content-transfer-encoding;
        bh=SvASqGw57nnd+VLnYfU88dyRPvfuj1Dziis/gpDvPDQ=;
        b=Hxh9YpV0NIKCGtFkOd+CpcTQoVXkDqzETgJuM8tTfmi0GppjdQVbg85y7eIHXJiK1W
         beAE2BgGWZMHEYjvAzmEG0Lxkh94bTK+fKMdWBj7Np2WxhIfX4nHMDeB4W8fV6GVbehy
         HGmytmHGBHDB7veGOWL1LTiAZ758lkfUz6fsDT8REpG45b7wTND35PzJhmX15rO7I+Gr
         bL1JFoGIxnmQ+yN+Abqf6zTpl2TA/yyMQRArCaJqlpF8jjP4/BaMwvBWgaY/uH6g2SU/
         hkdd61rBafYb4atjcjKUbkf2gOLjupEAEJ/MU8PsaoaJlUtVul4yxwFV19/qJKN67rop
         yMdg==
X-Gm-Message-State: AOAM530zCibhfe8gHJxKiIKuxOUnAZk+ivP90jmmbL32auNnE4+E4pwE
        kanphef1CO8TpfrDFRAYpfQ=
X-Google-Smtp-Source: ABdhPJyB1aKZywkCHJZjJmET0O2A221R61VkLCC7y5fqq25Y8mxu103Gzp1+U5B1a7FbncablDHLaQ==
X-Received: by 2002:a05:6a00:98e:: with SMTP id u14mr8601475pfg.12.1644728738382;
        Sat, 12 Feb 2022 21:05:38 -0800 (PST)
Received: from [192.168.66.3] (p912131-ipoe.ipoe.ocn.ne.jp. [153.243.13.130])
        by smtp.gmail.com with ESMTPSA id l8sm34061282pfc.187.2022.02.12.21.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Feb 2022 21:05:37 -0800 (PST)
Message-ID: <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
Date:   Sun, 13 Feb 2022 14:05:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org>
From:   Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
In-Reply-To: <20220120123630.267975-19-peter.maydell@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/01/20 21:36, Peter Maydell wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit.
> Similarily, nothing seem to check that the memory is within
> the limit set by the highmem=off option.
> 
> This leads to failures in virt_kvm_type() on systems that have
> a crippled IPA range, as the reported IPA space is larger than
> what it should be.
> 
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum, and fail if we have memory
> crossing the 4GiB limit.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Message-id: 20220114140741.1358263-4-maz@kernel.org
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
> ---
>   hw/arm/virt.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 62bdce1eb4b..3b839ba78ba 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1670,7 +1670,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>   static void virt_set_memmap(VirtMachineState *vms)
>   {
>       MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>       int i;
>   
>       vms->memmap = extended_memmap;
> @@ -1697,7 +1697,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>       device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>   
>       /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    if (!vms->highmem && memtop > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>       if (base < device_memory_base) {
>           error_report("maxmem/slots too huge");
>           exit(EXIT_FAILURE);
> @@ -1714,7 +1718,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>           vms->memmap[i].size = size;
>           base += size;
>       }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
>       if (device_memory_size > 0) {
>           ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>           ms->device_memory->base = device_memory_base;

Hi,
This breaks in a case where highmem is disabled but can have more than 4 
GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF, 
which is not enough for highmem MMIO but is enough to contain 32 GiB of RAM.

Where the magic number of 4 GiB / 32-bit came from? I also don't quite 
understand what failures virt_kvm_type() had.

Regards,
Akihiko Odaki
