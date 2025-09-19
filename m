Return-Path: <kvm+bounces-58139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 993F7B891D4
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E9693A8619
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5406A3081D8;
	Fri, 19 Sep 2025 10:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkMfayxN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5352FE062;
	Fri, 19 Sep 2025 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758278368; cv=none; b=Cxx8CVZ9Bo8BFGpiDJDt6UilCcghv4/oNgzigZqW8yqeH4EPRGJe09PjeBVfcadEN8W4PpwG25JkqYOFYPm6E5Pp8FCpRtdnfJOkYi9H8C5JzxKYp1IjHxGiPq6ryOdgtN1nAhVN+x+72J8fz8j62sPhLY2E2TcrbQ9YSKVYFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758278368; c=relaxed/simple;
	bh=OtjBanaouj2WXiAOhOlAoeQp9qZ53hLdEsL1+yK90RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HgNa7KNUSUhw7RsOZqMj9e0GIlDyIwon/4cTBTD4zOKrQoG2hKez4HKQVsr9Np9FJI09qLJKMiM4Io4oolBGx58Yj22VveReTkD4E6nkw2n/tEmnvWhQApDfDAoEubmXIvZdkY+c9KnoDN9/mx5a0JjUmcHt22TBkiMV8/VG3oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkMfayxN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9C0C4CEF0;
	Fri, 19 Sep 2025 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758278368;
	bh=OtjBanaouj2WXiAOhOlAoeQp9qZ53hLdEsL1+yK90RQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkMfayxNCcQer7F9jfqRmc0ldb2z8HZWwKP0ddHr2YwEFfkvoKxPk33/3cQr/MOhP
	 THp6/XWXhGqo6sz/4ruVfmJiWPOa+MehCwYr4ag+QtWf+f680DEB+ogkXIqgu1zvIE
	 mi09dXUkaZGgHKBp4UXKFRVB/FyRqmcD8BgMzCDX5bcOcciqHm0sgPamUkYxMiW4iq
	 2GcV81pWEEpS5A6tL5mytp5DTe8rAZIhdoSTdmK1JTuml0ttody1fMNvBsMdv7cDKn
	 JplS0JIps+KpjJ0iIsaiY/Bg7q2Qu0e3XQ0ZTTkdu1nu9SVxbfc8Qgf4rltdpq/b2e
	 P56w08DUsxckg==
Date: Fri, 19 Sep 2025 16:01:55 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KVM: SVM: Move global "avic" variable to avic.c
Message-ID: <73txiv6ycd3umvlptnqnepsc6hozuo4rfmyqj4rhtv7ahkm43k@37jbftataicw>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-6-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:35PM -0700, Sean Christopherson wrote:
> Move "avic" to avic.c so that it's colocated with the other AVIC specific
> globals and module params, and so that avic_hardware_setup() is a bit more
> self-contained, e.g. similar to sev_hardware_setup().
> 
> Deliberately set enable_apicv in svm.c as it's already globally visible
> (defined by kvm.ko, not by kvm-amd.ko), and to clearly capture the
> dependency on enable_apicv being initialized (svm_hardware_setup() clears
> several AVIC-specific hooks when enable_apicv is disabled).
> 
> Alternatively, clearing of the hooks (and enable_ipiv) could be moved to
> avic_hardware_setup(), but that's not obviously better, e.g. it's helpful
> to isolate the setting of enable_apicv when reading code from the generic
> x86 side of the world.
> 
> No functional change intended.
> 
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 32 ++++++++++++++++++++++++--------
>  arch/x86/kvm/svm/svm.c  | 11 +----------
>  2 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 497d755c206f..e059dcae6945 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -64,6 +64,14 @@
>  
>  static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
>  
> +/*
> + * enable / disable AVIC.  Because the defaults differ for APICv
> + * support between VMX and SVM we cannot use module_param_named.
> + */
> +static bool avic;
> +module_param(avic, bool, 0444);
> +module_param(enable_ipiv, bool, 0444);
> +
>  static bool force_avic;
>  module_param_unsafe(force_avic, bool, 0444);
>  
> @@ -1141,15 +1149,9 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  	avic_vcpu_load(vcpu, vcpu->cpu);
>  }
>  
> -/*
> - * Note:
> - * - The module param avic enable both xAPIC and x2APIC mode.
> - * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> - * - The mode can be switched at run-time.
> - */
> -bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
> +static bool __init avic_want_avic_enable(void)

Maybe avic_can_enable()?

>  {
> -	if (!npt_enabled)
> +	if (!avic || !npt_enabled)
>  		return false;
>  
>  	/* AVIC is a prerequisite for x2AVIC. */
> @@ -1174,6 +1176,20 @@ bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
>  		pr_warn("AVIC unsupported in CPUID but force enabled, your system might crash and burn\n");
>  
>  	pr_info("AVIC enabled\n");

I think it would be good to keep this in avic_hardware_setup() alongside 
the message printing "x2AVIC enabled".

Otherwise:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


