Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D11DC0E2
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgETVFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:05:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727018AbgETVFX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 17:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590008721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLCT0TpScS+rOAwWMzjEcVXtzZd0pBk5KPLl7C2BIRA=;
        b=U44mhWO8sVV2S7BmbSD6DoQAXYiJLoQczacC/5QqYBYTer+LINQ7EkFwkx/NWhif3IgLY7
        /zfs1fQaC5XmYV+1WumLAssO4s1kqx95Nz36/vf61/yoRMC9rMa3jQnSJ3MQLj2mjrMO89
        e3zi5zscZk6hbHiMNKdV1kKyZusgRJM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-sPoBrryWMkGNIFOs_gUv1w-1; Wed, 20 May 2020 17:05:20 -0400
X-MC-Unique: sPoBrryWMkGNIFOs_gUv1w-1
Received: by mail-ej1-f70.google.com with SMTP id x21so1864191ejb.14
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 14:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aLCT0TpScS+rOAwWMzjEcVXtzZd0pBk5KPLl7C2BIRA=;
        b=fSUXIKoun5pNsM4W2RUGFM1z1Z+qfHO9SIZDFxKLom6m106VRdK4X1O6dPS7en00Vm
         LC47+E6QTn3Uz6XPbk5ASOtct25ouTB1B8r3F8GdjgHcQmQh8BiQ7DTkX2wDimbYd+pS
         y3fND0AlE9O6SNUlP06p2Oha1xINI3QKZs8uYjegNeK95azXd+PhaqhHksSJNlGzttoS
         7sX/vt5nsGP6gfP8MLnmACjJWEXoEqlJMgOzMYqqRv/Fxnhj8OWvqr8yPBR5H9375ELp
         hDS93g+6EuIB7r985NMOgPupwy9riQhKgyulj/BxZUGl12z9u8AZVd7u6mvP51Vt2GDh
         gKDQ==
X-Gm-Message-State: AOAM531laaxSqO0lGFbUdpav8P2lRTj+3CIVZNQxqqKZ3M2hTbLqAI1m
        FIuiflZ+lxroNOXkxq9JhcJD/drfUNxuHjSKgYA1G5j072aKepub0s6mvrdaUM7S1oshaOtoQcW
        DEvvKrUWrx4KU
X-Received: by 2002:aa7:d706:: with SMTP id t6mr5386521edq.210.1590008718963;
        Wed, 20 May 2020 14:05:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdj0rEE7VOx55X3WVnq+v7TuIew2T9xwMKBujpNIgUudK+JoGBLTn0XSONUJWDNmsCh2/7Aw==
X-Received: by 2002:aa7:d706:: with SMTP id t6mr5386508edq.210.1590008718704;
        Wed, 20 May 2020 14:05:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id dm23sm2518052edb.0.2020.05.20.14.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:05:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200520160740.6144-1-mlevitsk@redhat.com>
 <20200520160740.6144-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
Date:   Wed, 20 May 2020 23:05:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520160740.6144-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 18:07, Maxim Levitsky wrote:
> This msr is only available when the host supports WAITPKG feature.
> 
> This breaks a nested guest, if the L1 hypervisor is set to ignore
> unknown msrs, because the only other safety check that the
> kernel does is that it attempts to read the msr and
> rejects it if it gets an exception.
> 
> Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe3a24fd6b263..9c507b32b1b77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
>  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
> +			break;
> +		case MSR_IA32_UMWAIT_CONTROL:
> +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> +				continue;
>  		default:
>  			break;
>  		}

The patch is correct, and matches what is done for the other entries of
msrs_to_save_all.  However, while looking at it I noticed that
X86_FEATURE_WAITPKG is actually never added, and that is because it was
also not added to the supported CPUID in commit e69e72faa3a0 ("KVM: x86:
Add support for user wait instructions", 2019-09-24), which was before
the kvm_cpu_cap mechanism was added.

So while at it you should also fix that.  The right way to do that is to
add a

        if (vmx_waitpkg_supported())
                kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);

in vmx_set_cpu_caps.

Thanks,

Paolo

