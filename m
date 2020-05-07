Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38EA1C8404
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 09:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgEGH5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 03:57:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725848AbgEGH5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 03:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588838231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9mwxyuCup0Q6hGGVaVop/Mcsx5sPEES6xR+JKy3xlE=;
        b=V854R5vXvdDRQXPHZpUvoYbX/wxLa+DCdkGbSE012N0pIQsytM8Ho4uw3B48cgiZOQLuRk
        fRoxDtUjpB65fqK2x8bNpMmzl2/p/LZN5nlfPfe0cGWhR9M3QLAKmNTtozOL6dan6+NU5t
        TN7FCIDppUKhEotKQCgv8QeRXNTUmaU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-7C35HNUoOb6lFS50bE4gOA-1; Thu, 07 May 2020 03:57:09 -0400
X-MC-Unique: 7C35HNUoOb6lFS50bE4gOA-1
Received: by mail-wr1-f72.google.com with SMTP id q13so2926609wrn.14
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 00:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9mwxyuCup0Q6hGGVaVop/Mcsx5sPEES6xR+JKy3xlE=;
        b=DgpVzP1CXfrwLPtJXztH5J0ip+rbnGV38b1rIj9253YQzJlJGql1Yrl03y/TN74/v8
         BcgMMk/XoNydvYz+oeWILOu6Oxv4tFdErDkbYgXGMt8jCbWDMk9DCX98YkmNvLQR5ZEr
         cmObVcBs2KruhmBpLGiaW/VmwxZCG0p361dimBuUY3McSLt3K7GjFRMqYWR0k5+3an85
         Wd9uMZKMCx7Rd8KcEtyCMRwYKs8LZA8GZjDNbiDzp0VbflNozCIypyLXrszNCXo2yfUq
         UpwxRZsqQktZxNgs1M+CHKLWhMcirZA7ICjBLv67rJghi2p1kx6gfImtSxTWqDloz/Tl
         x7Kw==
X-Gm-Message-State: AGi0PuYRK43E2113phk/PkKAxeMESkVxIYOKfb+cHSUft/UrK+xeVRMX
        qSLCbjXgxjprFCC+G4lucD6wpEuk0y3XdVw011X37evmj1lwjzVrUJFmB7EahUFDSmx6mHL7Rxa
        dKsBEnJyIRSbu
X-Received: by 2002:a1c:3206:: with SMTP id y6mr8660126wmy.111.1588838228718;
        Thu, 07 May 2020 00:57:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ1HGj369geDqMTet3EHW3ra3/6X7k36PjWNlzfDZu8OSHXRqpZOWKYn7h+nDpGIM9yv2dipw==
X-Received: by 2002:a1c:3206:: with SMTP id y6mr8660098wmy.111.1588838228397;
        Thu, 07 May 2020 00:57:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id m15sm6619827wmc.35.2020.05.07.00.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 00:57:07 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86/pmu: Support full width counting
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200507021452.174646-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fb56700-7f0b-59e1-527a-f8eb601185b1@redhat.com>
Date:   Thu, 7 May 2020 09:57:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507021452.174646-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 04:14, Like Xu wrote:
> +static inline u64 vmx_get_perf_capabilities(void)
> +{
> +	u64 perf_cap = 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_PDCM))
> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
> +
> +	/* Currently, KVM only supports Full-Width Writes. */
> +	perf_cap &= PMU_CAP_FW_WRITES;
> +
> +	return perf_cap;
> +}
> +

Since counters are virtualized, it seems to me that you can support
PMU_CAP_FW_WRITES unconditionally, even if the host lacks it.  So just
return PMU_CAP_FW_WRITES from this function.

> +	case MSR_IA32_PERF_CAPABILITIES:
> +		return 1; /* RO MSR */
>  	default:

You need to allow writes from the host if (data &
~vmx_get_perf_capabilities()) == 0.

> -			if (!msr_info->host_initiated)
> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> +			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> +			if (data & ~pmu->counter_bitmask[KVM_PMC_GP])
> +				return 1;
> +			if (!fw_writes_is_enabled(pmu))
>  				data = (s64)(s32)data;


You are dropping the test on msr_info->host_initiated here, you should
keep it otherwise you allow full-width write to MSR_IA32_PERFCTR0 as
well.  So:

#define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)

	if (!msr_info->host_initiated && !(msr & MSR_PMC_FULL_WIDTH_BIT))
		data = (s64)(s32)data;

> +	case MSR_IA32_PERF_CAPABILITIES:
> +		if (!nested)
> +			return 1;
> +		msr->data = vmx_get_perf_capabilities();
> +		return 0;

The !nested check is wrong.

> 
> +++ b/arch/x86/kvm/x86.c
> @@ -1220,6 +1220,13 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_IA32_PMC0, MSR_IA32_PMC0 + 1, MSR_IA32_PMC0 + 2,
> +	MSR_IA32_PMC0 + 3, MSR_IA32_PMC0 + 4, MSR_IA32_PMC0 + 5,
> +	MSR_IA32_PMC0 + 6, MSR_IA32_PMC0 + 7, MSR_IA32_PMC0 + 8,
> +	MSR_IA32_PMC0 + 9, MSR_IA32_PMC0 + 10, MSR_IA32_PMC0 + 11,
> +	MSR_IA32_PMC0 + 12, MSR_IA32_PMC0 + 13, MSR_IA32_PMC0 + 14,
> +	MSR_IA32_PMC0 + 15, MSR_IA32_PMC0 + 16, MSR_IA32_PMC0 + 17,
>  };

This is not needed because the full-width content is already accessible
from the host via MSR_IA32_PERFCTRn.

Given the bugs, it is clear that you should also modify the pmu.c
testcase for kvm-unit-tests to cover full-width writes (and especially
the non-full-width write behavior of MSR_IA32_PERFCTRn).  Even before
the QEMU side is begin worked on, you can test it with "-cpu
host,migratable=off".

Thanks,

Paolo

