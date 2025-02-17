Return-Path: <kvm+bounces-38328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 535C6A37B1E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 07:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FE6D188BBF8
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 06:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3802A18DB3E;
	Mon, 17 Feb 2025 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fM3aEylp"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2372F154BFE
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 06:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739772013; cv=none; b=epkJpMP5975aBcA91qWBSQ0hQclG29fXBw2AEpgcXQXNCEfqBPqx/39bESysI01fGG+XFTFeStTh9ANLgchepu8DIpcuunxvcSUm3C3NUlhvUyepvMBKqb6o+E1k83AtdW5KlG9okEaujRMut7A30bTjugpnq/6/1gXZ0mQaaGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739772013; c=relaxed/simple;
	bh=uIlLLYZk/rqc1yAEIcADHlCXLTsIBOxyC5v9MFk4mc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcZsWRSw8BAN3XKuACejbqgLOFpUVzsok/AWE3xbXS6qoqjvfapngf557AvKQRu7/WRTpJ4G0bBIPchJBgTS3T36ZIq4cU8T/YGE/Tqi/2AEJJNTpMuuqMrbPK/A5JTne2RNaot6BCUe1SgOuPeibAx8CQnpynkkZP1hm7NqvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fM3aEylp; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 16 Feb 2025 21:59:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739772009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8uQ7hYciG6TfKnfmxwzHYdxDSn8v9ytZX5MkrF5naHM=;
	b=fM3aEylpgbwKQ9ukztcJbXIuNz42X/RfxVSkZWeulNbfqq60XOR5TQcSf/8zp2FBdnm5sa
	3fNa4fMG9uAsuI1e4nS0AMVYpeMmQiqjIGVbbMWFPnDFwuivFMNYlDmfbNQfPwXuALv/YQ
	bd4OehO2Oq1u5xMaTD9+o5zXabYmA8A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z7LQX3j5Gfi8aps8@Asmaa.>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 01:53:07PM +0100, Borislav Petkov wrote:
> On Fri, Feb 14, 2025 at 09:10:05PM +0100, Borislav Petkov wrote:
> > After talking with folks internally, you're probably right. We should slap an
> > IBPB before clearing. Which means, I cannot use the MSR return slots anymore.
> > I will have to resurrect some of the other solutions we had lined up...
> 
> So I'm thinking about this (totally untested ofc) but I'm doing it in the CLGI
> region so no need to worry about migration etc.
> 
> Sean, that ok this way?

I am no Sean, but I have some questions about this approach if that's
okay :)

First of all, the use of indirect_branch_prediction_barrier() is
interesting to me because it only actually performs an IBPB if
X86_FEATURE_USE_IBPB is set, which is set according to the spectre_v2
mitigation. It seems to me that indirect_branch_prediction_barrier() was
originally intended for use only in switch_mm_irqs_off() ->
cond_mitigation(), where the spectre_v2 mitigations are executed, then
made its way to other places like KVM.

Second, and probably more importantly, it seems like with this approach
we will essentially be doing an IBPB on every VM-exit AND running the
guest with reduced speculation. At least on the surface, this looks
worse than an IBPB on VM-exit. My understanding is that this MSR is
intended to be a more efficient mitigation than IBPB on VM-exit.

This probably performs considerably worse than the previous approaches,
so I am wondering which approach is the 1-2% regression figure
associated with.

If 1-2% is the cost for keeping the MSR enabled at all times, I wonder
if we should just do that for simplicitly, and have it its own
mitigation option (chosen by the cmdline).

Alternatively, if that's too expensive, perhaps we can choose another
boundary to clear the MSR at and perform an IBPB. I can think of two
places:

- Upon return to userspace (similar to your previous proposal). In this
  case we run userspace with the MSR cleared, and only perform an IBPB
  in the exit to userspace pace.

- In the switch_mm() path (around cond_mitigation()). Basically we keep
  the MSR bit set until we go to a different process, at which point we
  clear it and do an IBPB. The MSR will bet set while the VMM is
  running, but other processes in the system won't take the hit. We can
  even be smarter and only do the MSR clear + IBPB if we're going from
  a process using KVM to process that isn't. We'll need more bookkeeping
  for that though.

Any thoughts? Am I completely off base?


> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6ea3632af580..dcc4e5935b82 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4272,8 +4272,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
>  
> +	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> +
>  	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
>  
> +	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +		indirect_branch_prediction_barrier();
> +		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> +	}
> +
>  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
>  
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

