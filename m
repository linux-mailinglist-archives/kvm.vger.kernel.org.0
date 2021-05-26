Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E34391E42
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhEZRkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhEZRkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 13:40:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25489C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:39:03 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s4so972710plg.12
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GJLBZVMEwbSbKIDqukcx7d1Y2z9DugvinO3Y2HE7Xb8=;
        b=qhCJ07l3+S5RaNOra6cGWWoLN5s4AiiMiSNsT4kmmZRWWeS3ywD0sHd0FiEtvhI6rB
         iDHzecKylmQV/alVl50UrPfL+lgoFTF+gwyC6OTbnRz/8S3G7cY1J+DXgCVBjokkOmQ3
         MNtedZ93sVJlDjGU4e+WVUzbZz+IRpSVv+hd4dCJp8MoVlUDsFBxYiFnfQYTkH16d0kD
         504lPpbw8Z6qcja/txaeMlwwOfnBJj8xaTI+/wuVhkhwDlXq+UPuO1cXMDDmQDDMvEb7
         JPXNnACYkRiaa6QdmwGLcGJSpt1CRxPSxFfhE9IcGSt424UFT8e5IRuVTDTTw8FHKEP/
         TZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GJLBZVMEwbSbKIDqukcx7d1Y2z9DugvinO3Y2HE7Xb8=;
        b=MfLXC8vmJEHRP75hRIjWScJqH/VleQFiRvwLkTsZPcBi9S0twhqTQtFHnM0kngIfJc
         KKNScKknWJUgCBr4mWJyYzNYImLy9mBSqtX0lBizXqJbsfV5SdRFAfCWIKpycY3VYy7O
         jmyfKogmVoOm4IFfqcq8jXc45G/lzbp6BD+cAtt3FnxwYR8LQzOojUi7LJxyXoJKAhx+
         0APmUfLarX2mMqCLWFZWCPVJTxTlalP3ANJ+wMsq0v5wTxqGkxO2sdRfTnwHrhd5puRx
         jBce4cKwjdNFxDyx1voWuWELn0cgQ73/4AyqwV6Bha4rQsPtbumIHctkWTPU1mzhkb3u
         ZN6A==
X-Gm-Message-State: AOAM530/ui4NEETl37WX+XRZ59J+UyJ78ANWIrXqyonsXkMtIgv0Zk7W
        hg+j6GcsAD/uO2CwW4mi4cz/2A==
X-Google-Smtp-Source: ABdhPJxleeFD/fo/p0B7jknSOU6gwCm53jI69+QHX5/sYO+byZxGUo96TTw409ZTZcLY8lmq7CZB6g==
X-Received: by 2002:a17:902:d4cd:b029:f5:4ec0:d593 with SMTP id o13-20020a170902d4cdb02900f54ec0d593mr36661426plg.19.1622050742416;
        Wed, 26 May 2021 10:39:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x9sm16309575pfd.66.2021.05.26.10.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:39:01 -0700 (PDT)
Date:   Wed, 26 May 2021 17:38:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pt: Do not inject TraceToPAPMI when guest PT
 isn't supported
Message-ID: <YK6HsR4QXbVuhZf8@google.com>
References: <20210514084436.848396-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514084436.848396-1-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021, Like Xu wrote:
> When a PT perf user is running in system-wide mode on the host,
> the guest (w/ pt_mode=0) will warn about anonymous NMIs from
> kvm_handle_intel_pt_intr():
> 
> [   18.126444] Uhhuh. NMI received for unknown reason 10 on CPU 0.
> [   18.126447] Do you have a strange power saving mode enabled?
> [   18.126448] Dazed and confused, but trying to continue
> 
> In this case, these PMIs should be handled by the host PT handler().
> When PT is used in guest-only mode, it's harmless to call host handler.
> 
> Fix: 8479e04e7d("KVM: x86: Inject PMI for KVM guest")

s/Fix/Fixes

> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/core.c | 3 +--
>  arch/x86/kvm/x86.c           | 3 +++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2521d03de5e0..2f09eb0853de 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2853,8 +2853,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>  		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
>  			perf_guest_cbs->handle_intel_pt_intr))
>  			perf_guest_cbs->handle_intel_pt_intr();
> -		else
> -			intel_pt_interrupt();
> +		intel_pt_interrupt();

Would it make sense to instead do something like:

	bool host_pmi = true;

	...

		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
			     perf_guest_cbs->handle_intel_pt_intr)
			host_pmi = !perf_guest_cbs->handle_intel_pt_intr();

		if (likely(host_pmi))
			intel_pt_interrupt();
>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6529e2023147..6660f3948cea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8087,6 +8087,9 @@ static void kvm_handle_intel_pt_intr(void)
>  {
>  	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
>  
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> +		return;
> +
>  	kvm_make_request(KVM_REQ_PMI, vcpu);
>  	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
>  			(unsigned long *)&vcpu->arch.pmu.global_status);
> -- 
> 2.31.1
> 
