Return-Path: <kvm+bounces-68918-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2G88JjNfcmnbjAAAu9opvQ
	(envelope-from <kvm+bounces-68918-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:32:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D562D6B5B2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0634F3052185
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636E23A1A48;
	Thu, 22 Jan 2026 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r/uiTo7s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B22935B152
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100957; cv=none; b=KiH+VnwTUaU+i35kOpFul2P4MoNWacpSkpSOjDIgDLYl2bj4blVP25xR47X9rJlO4T2dGFFWuWDmhZxrB/sB3LRJ/JQbqIrqt79k6BnIXmfomcj2tFO2nPh4OVZcdMinvKGmZPO8rqGPwKvvgy7Hx/Yw1IrhizPN3zTIOAQv1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100957; c=relaxed/simple;
	bh=X+S9iGT2HZuWijXLu7tolVZGrlzdF76ew/mCGKUwvJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MWfRCKVmR6qCrq7KbOCg9mxU5/k2/8Sq7UY8cDB+8Md4e2HsKoInWnJz7LK8aeBM5tCxCEwJmZrihnqzqfc/mcvT/CN6aVFf7t0sf58GBELXgWLl2VAguPtudFoIynqvAVEPQekDjxULLIqk6CzSN4npsLYPoqH4S0Z1jtonQ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r/uiTo7s; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d058fc56so9886045ad.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100946; x=1769705746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zrRnfOe0PxE3nW6MpoxAPcIWhyGqLCRkYDS8HFbpPvg=;
        b=r/uiTo7sNASbUmviSbHcoHRPVmYC5EuVH9ifUucmktHpwz4EoLxZHY0xYKQrU+8Bep
         5BKJxDqTUbKnrCtVW90LwPuNvFT+rmE2IX6LgaqsgGslJ3F9xuU7WBZAsdGHDrv/cE85
         ZxNFOW/nEtUVIY0domMjs8VUhkzb1j34vGXSM+31u0vJ35e7bkM1Wg1ifpKhA7QfmaTM
         UTqW2cqxnmaRwn3K/lxs7MbG7dZkvVzcLLl9yk64jaf1f3bpGsc46okS8gWafSPHqZeg
         23HmHtgAOGJlf4PNAN0GRc5y/e29jdv8P/tCcOezO2BiegaIcSE8aA6yZcZkaZBw6Ioa
         7vSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100946; x=1769705746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zrRnfOe0PxE3nW6MpoxAPcIWhyGqLCRkYDS8HFbpPvg=;
        b=oLu4x9+JrIG8b8RyiuquADi+Wp20EZnqmhm4nkg5uZ9VbBzglcdgGau4OfgOqjn/dL
         l7AE0eBK5bFL/To7oxGJ9W21PzyUxI6rcP7Mf6k3o6tFYHLtsxY8xY31HwefIJByBmxA
         tAUuk+dY4tyeHhhJOZGf/Y3xgCvMcTjAcD1uNl4IUKHqJwNgbfjrbm52oUOvqHD6NuY/
         5PSwd81TPTEiF5uNtY+GjzU6mpfIw3xlgoUGDi+hWGAxKorsMkE0DIdDhgE98qCDch0y
         ogWo/TNVPoEs2u8MmZPrrNBjbXJAW/nFrQl95f+K9UNDeh17xnmzYAJBT9lxfTlE37ET
         hHcw==
X-Forwarded-Encrypted: i=1; AJvYcCUqj5LPXiEBxu+5+SU0j58DTRaHgJmwbZqguP0kJZeqKrPyIEkEJCBi8b1i8nUDDRdfA9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIPI+GaUKaAA6V0WFsF4MwkRXNf3WNUfK65I5m3OWTGHp0grXf
	Rnpzoec+hLNnSq34FKMkNuehcj8P5eYNGeqXVoDNi4seVUs8nnyi4H3Pz11g0wLjn4Ymc7qi44o
	nctzh0w==
X-Received: from plot23.prod.google.com ([2002:a17:902:8c97:b0:2a7:ca54:ed0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c2:b0:29e:e642:95d6
 with SMTP id d9443c01a7336-2a7fe77dd00mr370985ad.59.1769100945836; Thu, 22
 Jan 2026 08:55:45 -0800 (PST)
Date: Thu, 22 Jan 2026 08:55:44 -0800
In-Reply-To: <20260121225438.3908422-5-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-5-jmattson@google.com>
Message-ID: <aXJWkIw0oSzOmxLS@google.com>
Subject: Re: [PATCH 4/6] KVM: x86/pmu: [De]activate HG_ONLY PMCs at SVME
 changes and nested transitions
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68918-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D562D6B5B2
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Jim Mattson wrote:
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index f0aa6996811f..7b32796213a0 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -26,6 +26,7 @@ KVM_X86_PMU_OP_OPTIONAL(cleanup)
>  KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
>  KVM_X86_PMU_OP(mediated_load)
>  KVM_X86_PMU_OP(mediated_put)
> +KVM_X86_PMU_OP_OPTIONAL(set_pmc_eventsel_hw_enable)
>  
>  #undef KVM_X86_PMU_OP
>  #undef KVM_X86_PMU_OP_OPTIONAL
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 833ee2ecd43f..1541c201285b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1142,6 +1142,13 @@ void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_branch_retired);
>  
> +void kvm_pmu_set_pmc_eventsel_hw_enable(struct kvm_vcpu *vcpu,
> +				       unsigned long *bitmap, bool enable)
> +{
> +	kvm_pmu_call(set_pmc_eventsel_hw_enable)(vcpu, bitmap, enable);
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_set_pmc_eventsel_hw_enable);

Why bounce through a PMU op just to go from nested.c to pmu.c?  AFAICT, common
x86 code never calls kvm_pmu_set_pmc_eventsel_hw_enable(), just wire up calls
directly to amd_pmu_refresh_host_guest_eventsels().

> @@ -1054,6 +1055,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
>  		goto out_exit_err;
>  
> +	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> +		vcpu_to_pmu(vcpu)->pmc_hostonly, false);
> +	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> +		vcpu_to_pmu(vcpu)->pmc_guestonly, true);
> +
>  	if (nested_svm_merge_msrpm(vcpu))
>  		goto out;
>  
> @@ -1137,6 +1143,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	/* Exit Guest-Mode */
>  	leave_guest_mode(vcpu);
> +	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> +		vcpu_to_pmu(vcpu)->pmc_hostonly, true);
> +	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
> +		vcpu_to_pmu(vcpu)->pmc_guestonly, false);
>  	svm->nested.vmcb12_gpa = 0;
>  	WARN_ON_ONCE(svm->nested.nested_run_pending);

I don't think these are the right places to hook.  Shouldn't KVM update the
event selectors on _all_ transitions, whether they're architectural or not?  E.g.
by wrapping {enter,leave}_guest_mode()?

static void svm_enter_guest_mode(struct kvm_vcpu *vcpu)
{
	enter_guest_mode(vcpu);
	amd_pmu_refresh_host_guest_eventsels(vcpu);
}

static void svm_leave_guest_mode(struct kvm_vcpu *vcpu)
{
	leave_guest_mode(vcpu);
	amd_pmu_refresh_host_guest_eventsels(vcpu);
}

