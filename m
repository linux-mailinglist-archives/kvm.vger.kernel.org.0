Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5C1D159B
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgEMNfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387927AbgEMNfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 09:35:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B6CC061A0C;
        Wed, 13 May 2020 06:35:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so6830376pls.8;
        Wed, 13 May 2020 06:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0BGOGNqih27OV/hxwThO6MefRy8fXlj0Bh5UXUHoSvM=;
        b=RDEBDtHUoB1XiuAgWSyUddc44FRdseR2E78Z2zPCqCd8Z18kCEdZEGX8U2vpI0yzzA
         u2yPqNpHUZtsoZpZmOjFllF1DBlsIz5XDxmvPXLVmQVKCvvwifTfdv2vhxD1NgzQMmnz
         N1T/Czl/NCNGfDgTC4rx1m6afLlOJBLwgGkiPiQdaV0BM/6IUr7WpfXp65yBUaCwb2ET
         dx8UCWSsBCyEVu7hIoYFsdvu7x+zpnp3t7U8kws9RKec49ogUfYr6QiV1kaS9G+CSQjS
         Ao0jU/DLcKfDuCB9R7JGFBPoV5YU98EC03q4FXf01dcm6m24eDSmLsg95KzXWHPIeGJm
         jwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0BGOGNqih27OV/hxwThO6MefRy8fXlj0Bh5UXUHoSvM=;
        b=IZBC0RCc0eim7ct/DWqhTa4twr5i6pWQheMKg7J/e4fgs1WK9Ws86VrqY3TugHMQA3
         U+D7PrkbDnKc6emwCRAL3XVYBQhNLEw8x5ikjfKqEZdWcS1+NOLET2g38+Jf3TmpDt40
         gOVvcFqfEtdWSuu+ggdI4IFXva8qO2uUiyjwEvb9879aOArPO1RkwQODeXcCjxfzHgM7
         Tnhv+l79grrHGDi1GNQg9CXdn3TVSsgo4g8H0P35EOyKgmLcbHTCHfeNJ2b6gXVcw5aG
         2/8U5aW7guZyY+0msxXYSr3Yom58uG6i4T6kVzTtWy7nhZy8UpSGwsFybjdDMND+E8kA
         fHoQ==
X-Gm-Message-State: AOAM531HWIVdkRcNth2Ab/UZj8ryNo9SxiqR5m+GjQ0FzXZSN3/tiBND
        i2RfEfqwaeSbAUJXJLnglT8=
X-Google-Smtp-Source: ABdhPJxHvVgkgDedkqYMSZJj59AIFKH74OH/HffWU0Oj7KNku+s6st0bccLkx8cK0rvdzp2DPZN+dw==
X-Received: by 2002:a17:90a:7ace:: with SMTP id b14mr2252495pjl.116.1589376930438;
        Wed, 13 May 2020 06:35:30 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:18:efed::a31c])
        by smtp.gmail.com with ESMTPSA id g9sm13207294pgj.89.2020.05.13.06.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 06:35:30 -0700 (PDT)
Subject: Re: [PATCH] x86/hyperv: Properly suspend/resume reenlightenment
 notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
References: <20200512160153.134467-1-vkuznets@redhat.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3507d1b3-8d90-8d0e-c20f-a75f9f280230@gmail.com>
Date:   Wed, 13 May 2020 21:35:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512160153.134467-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/2020 12:01 AM, Vitaly Kuznetsov wrote:
> Errors during hibernation with reenlightenment notifications enabled were
> reported:
> 
>   [   51.730435] PM: hibernation entry
>   [   51.737435] PM: Syncing filesystems ...
>   ...
>   [   54.102216] Disabling non-boot CPUs ...
>   [   54.106633] smpboot: CPU 1 is now offline
>   [   54.110006] unchecked MSR access error: WRMSR to 0x40000106 (tried to
>       write 0x47c72780000100ee) at rIP: 0xffffffff90062f24
>       native_write_msr+0x4/0x20)
>   [   54.110006] Call Trace:
>   [   54.110006]  hv_cpu_die+0xd9/0xf0
>   ...
> 
> Normally, hv_cpu_die() just reassigns reenlightenment notifications to some
> other CPU when the CPU receiving them goes offline. Upon hibernation, there
> is no other CPU which is still online so cpumask_any_but(cpu_online_mask)
> returns >= nr_cpu_ids and using it as hv_vp_index index is incorrect.
> Disable the feature when cpumask_any_but() fails.
> 
> Also, as we now disable reenlightenment notifications upon hibernation we
> need to restore them on resume. Check if hv_reenlightenment_cb was
> previously set and restore from hv_resume().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/hyperv/hv_init.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index fd51bac11b46..acf76b466db6 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -226,10 +226,18 @@ static int hv_cpu_die(unsigned int cpu)
>   
>   	rdmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
>   	if (re_ctrl.target_vp == hv_vp_index[cpu]) {
> -		/* Reassign to some other online CPU */
> +		/*
> +		 * Reassign reenlightenment notifications to some other online
> +		 * CPU or just disable the feature if there are no online CPUs
> +		 * left (happens on hibernation).
> +		 */
>   		new_cpu = cpumask_any_but(cpu_online_mask, cpu);
>   
> -		re_ctrl.target_vp = hv_vp_index[new_cpu];
> +		if (new_cpu < nr_cpu_ids)
> +			re_ctrl.target_vp = hv_vp_index[new_cpu];
> +		else
> +			re_ctrl.enabled = 0;
> +
>   		wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
>   	}
>   
> @@ -293,6 +301,13 @@ static void hv_resume(void)
>   
>   	hv_hypercall_pg = hv_hypercall_pg_saved;
>   	hv_hypercall_pg_saved = NULL;
> +
> +	/*
> +	 * Reenlightenment notifications are disabled by hv_cpu_die(0),
> +	 * reenable them here if hv_reenlightenment_cb was previously set.
> +	 */
> +	if (hv_reenlightenment_cb)
> +		set_hv_tscchange_cb(hv_reenlightenment_cb);
>   }
>   
>   /* Note: when the ops are called, only CPU0 is online and IRQs are disabled. */
> 

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
