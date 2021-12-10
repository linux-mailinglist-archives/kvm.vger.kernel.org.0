Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1294C46FD2B
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 09:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbhLJJDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbhLJJDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:03:14 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE40BC061746;
        Fri, 10 Dec 2021 00:59:39 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 133so7479047pgc.12;
        Fri, 10 Dec 2021 00:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=TKZVGmzLds7Dqq+Wm8gZnHdVmVXrt99fZTYTv3M+v/w=;
        b=OVaJqeYCr5xksauiqL2Fcqu72QtydgchP1Pf5hI+bat2LAdFY4lUmtlUAAgYQ/Jpj5
         FJbgfjLUUZxptaCuGVc0P7HERGu4TAh0r9in7gOFqrh9HVeKDhgxmX+sqJHrGReAFtgK
         GLR7TPUTglflkuXP3GVJ3arYn0CGPKlpaeropcXu3LNwyH+wDb1Rkpgv2ZBAd8ev7Mne
         pLdiJcRHyDKTzeoksn7vzDNGqNy4FwFaR+4GI3hLJPfPrH7iH+Pqu/ga4tjEfW+ID6BA
         zuNA6hupLFO+jkdLhZUiITx04Fneq10DPiZA9/K8/JzcGZt+CFaoygecBHnFCunT4OS3
         lE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=TKZVGmzLds7Dqq+Wm8gZnHdVmVXrt99fZTYTv3M+v/w=;
        b=UZ6bExrK4ucOkOVWRdaIyq2aQQx4b4Kkx4ydoQII/+vHNReILGbZkZEHvG07bovI/Q
         3SLv1V7ttzBqDYO2zfSXPsX+XFKQcMGVJ/PMIYBD+rqNmiGmuDk0Wteql4yVVoQbtwA1
         Mf06ElBQZs1Y03JglKOuaWtADxmuxGIhBWDDu7RoLSRAaOtnmyZD+7KfpAwkJDxf4M4t
         yCME+4F6Y7o1zAsEaHd9MyzvL/dnoX52AjrT/Lui8w3OwM1iEEZbEngCCv+Vd/vQ9GZE
         RlU2YbS+u+TpmBUn0mHsGAQOI9ghhZBa0koA5QaDY76RD9EVbe/YhXY9jWqNUr8fBtwe
         8lwg==
X-Gm-Message-State: AOAM531i7eP6vgBIl8x63KN5b9FYYgCTki7IvwajS4efBVpgJ6hzZTLU
        2ZLXNQeqVHnvZTTVWtiWUPaKh+9R3d0=
X-Google-Smtp-Source: ABdhPJz+ouXtJcQG/7HCb0//R1wRRENqCo8oiGK05wt79Lv9Ny2H3y3HdNgB4KlonlG8/VQntdt4rw==
X-Received: by 2002:a63:2a95:: with SMTP id q143mr39006853pgq.45.1639126779088;
        Fri, 10 Dec 2021 00:59:39 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s24sm2245834pfm.100.2021.12.10.00.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 00:59:38 -0800 (PST)
Message-ID: <7a2fc1d7-6ef4-cf4c-5ba0-c0eaefd2c66b@gmail.com>
Date:   Fri, 10 Dec 2021 16:59:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     jmattson@google.com, wanpengli@tencent.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
References: <20211209191101.288041-1-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM: x86: avoid out of bounds indices for fixed
 performance counters
In-Reply-To: <20211209191101.288041-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2021 3:11 am, Paolo Bonzini wrote:
> Because IceLake has 4 fixed performance counters but KVM only supports 3,
> it is possible for reprogram_fixed_counters to pass to

Emm, it's possible for a unwise user space or smart syzkaller.

> reprogram_fixed_counter an index that is out of bounds for
> the fixed_pmc_events array.
> 
> Ultimately intel_find_fixed_event, which is the only place that uses
> fixed_pmc_events, handles this correctly because it checks against the
> size of fixed_pmc_events anyway.  Every other place
> operates on the fixed_counters[] array which is sized
> according to INTEL_PMC_MAX_FIXED.  However, it is cleaner if
> the unsupported performance counters are culled early on
> in reprogram_fixed_counters.

How about introducing a static "struct x86_pmu_capability" variable [1] so that 
we can

(1) setup num_counters_fixed just once in the kvm_init_pmu_capability(), and
(2) avoid repeated calls to perf_get_x86_pmu_capability() ;

?

[1] https://lore.kernel.org/kvm/20210806133802.3528-17-lingshan.zhu@intel.com/
By the way, do you need a re-based version of the guest PBES feature ?

Thanks,
Like Xu

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 1b7456b2177b..d33e9799276e 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -91,7 +91,7 @@ static unsigned intel_find_fixed_event(int idx)
>   	u32 event;
>   	size_t size = ARRAY_SIZE(fixed_pmc_events);
>   
> -	if (idx >= size)
> +	if (WARN_ON_ONCE(idx >= size))
>   		return PERF_COUNT_HW_MAX;
>   
>   	event = fixed_pmc_events[array_index_nospec(idx, size)];
> @@ -500,8 +500,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   		pmu->nr_arch_fixed_counters = 0;
>   	} else {
>   		pmu->nr_arch_fixed_counters =
> -			min_t(int, edx.split.num_counters_fixed,
> -			      x86_pmu.num_counters_fixed);
> +			min3(ARRAY_SIZE(fixed_pmc_events),
> +			     (size_t) edx.split.num_counters_fixed,
> +			     (size_t) x86_pmu.num_counters_fixed);
>   		edx.split.bit_width_fixed = min_t(int,
>   			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
>   		pmu->counter_bitmask[KVM_PMC_FIXED] =
