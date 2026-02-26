Return-Path: <kvm+bounces-71964-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFvxJ700oGkqgwQAu9opvQ
	(envelope-from <kvm+bounces-71964-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:55:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DF01A5695
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A37CC302EE09
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5B537BE95;
	Thu, 26 Feb 2026 11:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjOyB6Tk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5237647B;
	Thu, 26 Feb 2026 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772106884; cv=none; b=l1nK3kJX0zawSmLsRkiObiMauUBh/TZPg17592CYEE2Lp4sHhKTV9Cx+Ys84eFdIkJCjQcYQwNLxrmdJByP7w7Gcx94gIm5vcuBjS/Vp6Ofc4U+BV7QlKu30y8OJ8WUqXBfyqtS9qaofNFvS6H2mYMDL5OCJJVA3jvRvrAVhTsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772106884; c=relaxed/simple;
	bh=OyAr9XFcljdspYg5t17dcELHy4wQhUIdS4b5HT4e440=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ON33VSJ8tRI3V0VI+GqLKh1WdB8vOSoL/OZj/JyJ6Ena7qMUW61K3ONWNbc6khTJywmdHLJBIa5tQLPUMLv/1vHdGp+7VO7hb/ZkbZslF5yYnv+yr6zqIpU/ILqLxRaN1LLOZlqmf1TA1I6N7nYyqZDD7RoeV9dXU3qhJRSsQWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjOyB6Tk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F171C116C6;
	Thu, 26 Feb 2026 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772106884;
	bh=OyAr9XFcljdspYg5t17dcELHy4wQhUIdS4b5HT4e440=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VjOyB6TkX+EEVepdSNPexvT+s7nDTrYLKVA41GUwq8DTQAD6f3c7ZIkWTjYHwyAk5
	 bzHTpCvYiK5azhCJvNTYXSBqxhWun4OudCC5gpFxkQLFgAHsg1NknF5MP4qvqv/rrB
	 HLHysS4LqC/u1qhq0d7tjX1VCgfVaaX2JiIKglFivWhx1X/NMKkxBlx6knYGuWrRoG
	 Pec22q6Ev86r+TqNbafl03Z/gM9gMCEOgfb0gWOD4zItvoHJx0xEihu4Dv7qgBMz7i
	 5xznQyEETiC0hzTXlHftorZASsOojgkmiw25lD0U9bjsmMhbRyn3Tfb+yN6tQxYkEF
	 FQE75YhVWy1Yg==
Date: Thu, 26 Feb 2026 03:54:42 -0800
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Message-ID: <aaA0gn9O8QAf9Gpu@kernel.org>
References: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
 <20260225-hybrid-v3-1-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-hybrid-v3-1-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71964-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oupton@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B9DF01A5695
X-Rspamd-Action: no action

Hi Akihiko,

On Wed, Feb 25, 2026 at 01:31:15PM +0900, Akihiko Odaki wrote:
> @@ -629,6 +629,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		kvm_vcpu_load_vhe(vcpu);
>  	kvm_arch_vcpu_load_fp(vcpu);
>  	kvm_vcpu_pmu_restore_guest(vcpu);
> +	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
> +		kvm_make_request(KVM_REQ_CREATE_PMU, vcpu);

We only need to set the request if the vCPU has migrated to a different
PMU implementation, no?

>  	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>  		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>  
> @@ -1056,6 +1058,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
>  			kvm_vcpu_reload_pmu(vcpu);
>  
> +		if (kvm_check_request(KVM_REQ_CREATE_PMU, vcpu))
> +			kvm_vcpu_create_pmu(vcpu);
> +

My strong preference would be to squash the migration handling into
kvm_vcpu_reload_pmu(). It is already reprogramming PMU events in
response to other things.

>  		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
>  			kvm_vcpu_pmu_restore_guest(vcpu);
>  
> @@ -1516,7 +1521,8 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  	 * When the vCPU has a PMU, but no PMU is set for the guest
>  	 * yet, set the default one.
>  	 */
> -	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
> +	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
> +	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
>  		ret = kvm_arm_set_default_pmu(kvm);

I'd rather just initialize it to a default than have to deal with the
field being sometimes null.

> -static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
> +static u64 kvm_pmu_enabled_counter_mask(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> -	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +	u64 mask = 0;
>  
> -	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
> -		return false;
> +	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME)
> +		mask |= kvm_pmu_hyp_counter_mask(vcpu);
>  
> -	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
> -		return mdcr & MDCR_EL2_HPME;
> +	if (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)
> +		mask |= ~kvm_pmu_hyp_counter_mask(vcpu);
>  
> -	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
> +	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> +}
> +
> +static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
> +{
> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> +
> +	return kvm_pmu_enabled_counter_mask(vcpu) & BIT(pmc->idx);
>  }

You're churning a good bit of code, this needs to happen in a separate
patch (if at all).

> @@ -689,6 +710,14 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>  	int eventsel;
>  	u64 evtreg;
>  
> +	if (!arm_pmu) {
> +		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);

kvm_pmu_probe_armpmu() takes a global mutex, I'm not sure that's what we
want.

What prevents us from opening a PERF_TYPE_RAW event and allowing perf to
work out the right PMU for this CPU?

> +		if (!arm_pmu) {
> +			vcpu_set_on_unsupported_cpu(vcpu);

At this point it seems pretty late to flag the CPU as unsupported. Maybe
instead we can compute the union cpumask for all the PMU implemetations
the VM may schedule on.

> @@ -1249,6 +1299,10 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		irq = vcpu->arch.pmu.irq_num;
>  		return put_user(irq, uaddr);
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
> +		lockdep_assert_held(&vcpu->kvm->arch.config_lock);
> +		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
> +			return 0;

We don't need a getter for this, userspace should remember how it
provisioned the VM.

Thanks,
Oliver

