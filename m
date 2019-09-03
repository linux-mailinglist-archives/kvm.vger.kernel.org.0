Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6193A7658
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfICVj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:39:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42261 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfICVj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:39:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id y1so8499296plp.9
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9nuYb4tBvJQAZu1p+OtYH6W7mD0VPXjyBijfT0/0inw=;
        b=PmF0Nj9AvFRU3I7XR25x8TCY1ES4WlxhUZBS8tYh8LEqUy+fHqXtEUCTtHS7gKooBl
         uyLmXKW2kZOOujrV8TRALSAmCtIeCdjHP4rsLjkPxHFI6CT1qKn020J7/8kpFgwdFLAM
         yRdr75V4IfzwUOhRVKRcVXS1SyjitvEVuyJTr9I/9f8gCg0/180SKvEqqEVm0XiG5B7A
         8hJ5i7BT/l5L78cfsv7Gidwf68JTCw1TFe8vDG0LWlf/cKjYQWQOCoH7UTAFkRZ95Pte
         xmdVfqWZxc2yVz3H1MXkdJZ4zeeN5NmIoAUrcD2qIoimiDpi3ajCmkxm16CC6V5xteS6
         zsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9nuYb4tBvJQAZu1p+OtYH6W7mD0VPXjyBijfT0/0inw=;
        b=tTDhwkxNWTHdJ7QLqurHNznic9wWOZcLN4BE2gPCPELwlLnDc5rM4+CXsSn9rMPXdN
         qAT/0nSpEHGqVCQW0xGVSzEZtYCpPGJiuUxAPlm0I0oiNR1VTNRxQNuckuWbrYvBClg9
         4Ipb3uJrQ2X9XOcJlzx1ZyMUFdovVTBFTVb6/CD5PBuxlQDyOUSDGnG2/1xKMyTLFkZA
         Yo20P+dQPYd7Pf3+FIkyFh2QBpKqwEUPs3PrFHblU9R6wLaTFFvKlC5sQNWPHMVCBlS6
         i9RtgrzZUMU5P2CA2BAX/DrOcZ5ospK0vls21M8nAc2SurtBRZE87UdvDTrcYtsJTePZ
         k9Pg==
X-Gm-Message-State: APjAAAV6A6Dcs9U3y6wtsDWSZfmOWZpeYsxiWn8x40SY/8RPxIHftBei
        q+fkyIKo04ZWIG0hiN2JLJKyek3KCYiu5O3B
X-Google-Smtp-Source: APXvYqxCzuhOM6SMIwhjIrVMKdpZv7iz/FIBK8DYcuk5RaoVrzFLTrEqLMfvIcGi/0R6iSjiXmBlUA==
X-Received: by 2002:a17:902:ff15:: with SMTP id f21mr17213564plj.185.1567546795875;
        Tue, 03 Sep 2019 14:39:55 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id j1sm17308175pgl.12.2019.09.03.14.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 14:39:51 -0700 (PDT)
Date:   Tue, 3 Sep 2019 14:39:47 -0700
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 3/8] KVM: VMX: Add helper to check reserved bits in
 IA32_PERF_GLOBAL_CTRL
Message-ID: <20190903213947.GA177933@google.com>
References: <20190903213044.168494-1-oupton@google.com>
 <20190903213044.168494-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903213044.168494-4-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 03, 2019 at 02:30:39PM -0700, Oliver Upton wrote:
> Create a helper function to check the validity of a proposed value for
> IA32_PERF_GLOBAL_CTRL from the existing check in intel_pmu_set_msr().

Clobbered my updated commit message. Will fix with the other comment
below.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/pmu.h           | 6 ++++++
>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 58265f761c3b..779427b44c2f 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -79,6 +79,12 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>  	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
>  }
>  
> +static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_pmu *pmu,
> +						 u64 data)
> +{
> +	return pmu->global_ctrl == data || !(pmu->global_ctrl_mask & data);

Going to resend this one more time. Just had a conversation with Jim
offline and decided that the 'pmu->global_ctrl == data' check (as seen
in intel_pmu_set_msr()) isn't really providing us anything here.

> +}
> +
>  /* returns general purpose PMC with the specified MSR. Note that it can be
>   * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
>   * paramenter to tell them apart.
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 4dea0e0e7e39..963766d631ad 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -223,7 +223,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_CORE_PERF_GLOBAL_CTRL:
>  		if (pmu->global_ctrl == data)
>  			return 0;
> -		if (!(data & pmu->global_ctrl_mask)) {
> +		if (kvm_is_valid_perf_global_ctrl(pmu, data)) {
>  			global_ctrl_changed(pmu, data);
>  			return 0;
>  		}
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
