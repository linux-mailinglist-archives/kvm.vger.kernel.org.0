Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC164300B9
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 09:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbhJPHCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 03:02:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243712AbhJPHCk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 03:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634367632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRh3dObWKYPS1WmhqT54QuiW1HLNqnWc5bFo7265d4M=;
        b=D0Lscy7RVJSpgWT12y1wgnmYPuT83G32a6ScsBqqVNVyVVQxYf5WCp810AbncuoW2ucsE9
        lcJ37Tn1WaoViHVStt5xLMTkIcMDtlTjXH89tw7IVJIrXLlNUTnw4XMHHQd5K5szQd/ImF
        jVAZsE+OxpW5DEeMm0/udiogSL9Tizc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-aYgJaAFJN1aZT0hOnZxJtg-1; Sat, 16 Oct 2021 03:00:31 -0400
X-MC-Unique: aYgJaAFJN1aZT0hOnZxJtg-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so10088344edl.17
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 00:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cRh3dObWKYPS1WmhqT54QuiW1HLNqnWc5bFo7265d4M=;
        b=rC4GsJ0LWfjyEi1noSzF9yVUvXjNpHi5IFW6t755kTVeI3bKOhOjQMxLpDs9F02gpF
         5JZEXanZQzLg0ymzRK2euct8HOrJ9RnDeZgs9pQNQ3lwoydjDRu3xM8C7Xb5VooLwYWX
         LYE7ymnxAt1cd8hyNZ+c3xfscrj9qFYquMGv03ZJVkWLn6cDQSe9ECGglcaz9JNTssgS
         Dhn7l2n58qxgDCOZnGM/GbTqy9UlxgG84AvY97PD3wVeotBAaDlmN/lAFkMf8KAyy8uj
         3G0amyjwg8lDWOn6Xn7sYJk4UfPYYXCnsUf8aS00kvthKkeEgSFgqkqnBPCSheOTPzNC
         Ly3g==
X-Gm-Message-State: AOAM530VC79RVSWgZftNc5663Z/V0K13n+mFfNoZIHfT1Opc294jyNq1
        VbdAfV/L8jjhD1EGDDNeQBG0K/opEf7EHfWnWZtHcVsC5SHeI13fq2IenZ089suRPE08UjkLiDn
        gEj8MltcwMBti
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr24008828edd.256.1634367629576;
        Sat, 16 Oct 2021 00:00:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpPhs483wh6gYtRthyjNLC1PdFXxp1N+iqug39r4c7QRhh7XrcJF1+5yDIWxmIYsTkdOQgEA==
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr24008798edd.256.1634367629343;
        Sat, 16 Oct 2021 00:00:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id h7sm6236913edt.37.2021.10.16.00.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 00:00:28 -0700 (PDT)
Message-ID: <f513e90b-8eed-53ef-6c80-e588f1260e18@redhat.com>
Date:   Sat, 16 Oct 2021 09:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] kvm: x86: mmu: Make NX huge page recovery period
 configurable
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com,
        dmatlack@google.com
References: <20211016005052.3820023-1-junaids@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211016005052.3820023-1-junaids@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/21 02:50, Junaid Shahid wrote:
> Currently, the NX huge page recovery thread wakes up every minute and
> zaps 1/nx_huge_pages_recovery_ratio of the total number of split NX
> huge pages at a time. This is intended to ensure that only a
> relatively small number of pages get zapped at a time. But for very
> large VMs (or more specifically, VMs with a large number of
> executable pages), a period of 1 minute could still result in this
> number being too high (unless the ratio is changed significantly,
> but that can result in split pages lingering on for too long).
> 
> This change makes the period configurable instead of fixing it at
> 1 minute (though that is still kept as the default). Users of
> large VMs can then adjust both the ratio and the period together to
> reduce the number of pages zapped at one time while still
> maintaining the same overall duration for cycling through the
> entire list (e.g. the period could be set to 1 second and the ratio
> to 3600 to maintain the overall cycling period of 1 hour).

The patch itself looks good, but perhaps the default (corresponding to a 
period of 0) could be 3600000 / ratio, so that it's enough to adjust the 
ratio?

Paolo

> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |  8 ++++-
>   arch/x86/kvm/mmu/mmu.c                        | 33 +++++++++++++------
>   2 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..8e2b426726e5 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2353,7 +2353,13 @@
>   			[KVM] Controls how many 4KiB pages are periodically zapped
>   			back to huge pages.  0 disables the recovery, otherwise if
>   			the value is N KVM will zap 1/Nth of the 4KiB pages every
> -			minute.  The default is 60.
> +			period (see below).  The default is 60.
> +
> +	kvm.nx_huge_pages_recovery_period_ms=
> +			[KVM] Controls the time period at which KVM zaps 4KiB pages
> +			back to huge pages. 0 disables the recovery, otherwise if
> +			the value is N, KVM will zap a portion (see ratio above) of
> +			the pages every N msecs. The default is 60000 (i.e. 1 min).
>   
>   	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
>   			Default is 1 (enabled)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..47e113fc05ab 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -61,28 +61,33 @@ int __read_mostly nx_huge_pages = -1;
>   #ifdef CONFIG_PREEMPT_RT
>   /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
>   static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
> +static uint __read_mostly nx_huge_pages_recovery_period_ms = 0;
>   #else
>   static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
> +static uint __read_mostly nx_huge_pages_recovery_period_ms = 60000;
>   #endif
>   
>   static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
>   
>   static const struct kernel_param_ops nx_huge_pages_ops = {
>   	.set = set_nx_huge_pages,
>   	.get = param_get_bool,
>   };
>   
> -static const struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
> -	.set = set_nx_huge_pages_recovery_ratio,
> +static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
> +	.set = set_nx_huge_pages_recovery_param,
>   	.get = param_get_uint,
>   };
>   
>   module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
>   __MODULE_PARM_TYPE(nx_huge_pages, "bool");
> -module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
> +module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_param_ops,
>   		&nx_huge_pages_recovery_ratio, 0644);
>   __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
> +module_param_cb(nx_huge_pages_recovery_period_ms, &nx_huge_pages_recovery_param_ops,
> +		&nx_huge_pages_recovery_period_ms, 0644);
> +__MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
>   
>   static bool __read_mostly force_flush_and_sync_on_reuse;
>   module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> @@ -6088,18 +6093,23 @@ void kvm_mmu_module_exit(void)
>   	mmu_audit_disable();
>   }
>   
> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
>   {
> -	unsigned int old_val;
> +	bool was_recovery_enabled, is_recovery_enabled;
>   	int err;
>   
> -	old_val = nx_huge_pages_recovery_ratio;
> +	was_recovery_enabled = nx_huge_pages_recovery_ratio &&
> +			       nx_huge_pages_recovery_period_ms;
> +
>   	err = param_set_uint(val, kp);
>   	if (err)
>   		return err;
>   
> +	is_recovery_enabled = nx_huge_pages_recovery_ratio &&
> +			      nx_huge_pages_recovery_period_ms;
> +
>   	if (READ_ONCE(nx_huge_pages) &&
> -	    !old_val && nx_huge_pages_recovery_ratio) {
> +	    !was_recovery_enabled && is_recovery_enabled) {
>   		struct kvm *kvm;
>   
>   		mutex_lock(&kvm_lock);
> @@ -6162,8 +6172,11 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>   
>   static long get_nx_lpage_recovery_timeout(u64 start_time)
>   {
> -	return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
> -		? start_time + 60 * HZ - get_jiffies_64()
> +	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> +	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
> +
> +	return READ_ONCE(nx_huge_pages) && ratio && period
> +		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
>   		: MAX_SCHEDULE_TIMEOUT;
>   }
>   
> 

