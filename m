Return-Path: <kvm+bounces-38775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA678A3E4B4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95A157A709F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C02263899;
	Thu, 20 Feb 2025 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FK/iqH6P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551D51E9B1C;
	Thu, 20 Feb 2025 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078287; cv=none; b=S7XR+Ao6kcnBVbQm1qZ48VrsP/gRUmk8eWt54w6VFb3brjZfjMvXyj4L0TPPL4lRqxmYjjApdvN7KBGSQOp17wpZ49+FMRuoOCqTWIsYi1rVQafnpj+5QibsEMHEkFq+EAZzech8i+Kk6wtW7mMNbTOIgTm3JD2WNYbBPR8ZzPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078287; c=relaxed/simple;
	bh=BidZBS4eZtZfPvk6NhNjN/ATM5JUN1oiVrgLI+zExt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0dZmKoUO08xh5e2+gqeFFtvP7s+1sJC3ZHvHF1fE8aF+UP7O+bi67zcZQdQEOprI6zFsPsm03vqhY2z3e/Mpz/mlOX40bnftzDnp9e9Pqhr2OmYgzevNpzYWSLhMgd6om+BjmcIAvjuoN10aUPDUMTzrrmgCWdMDxQgb/xgWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FK/iqH6P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC9BC4CED1;
	Thu, 20 Feb 2025 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740078286;
	bh=BidZBS4eZtZfPvk6NhNjN/ATM5JUN1oiVrgLI+zExt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FK/iqH6PNbcQF5B1y3CsPysLW0iMFMA7tEmbhrHcz84/IYRfR4UolbVwGexX2jmSA
	 7J6FR+6QoDlivhw+cgvcxeuG6cyO9qh1zwmP+vUeQZGL4enPSMt+nFULd9RKrLkLV/
	 U1457FIcVKH/qJaHB/4puMeiVV91SdAS8d/W1D74Saprm6T5Ot825DS/poIICRPrpy
	 kS+141SgXIMHX2OJiK23PoKYh10q7RI5iKzqWWLrygplonbp7EUsnGYG77t1C344QK
	 Fen5Z4thKWJuwK88Iv9/x+DGM6LB3R38omFR3kdkygLp47tcWAkmvnGuA+24VjhKvC
	 f4uutTlLjKZpg==
Date: Thu, 20 Feb 2025 11:04:44 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] IBPB cleanups and a fixup
Message-ID: <20250220190444.7ytrua37fszvuouy@jpoimboe>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250219220826.2453186-1-yosry.ahmed@linux.dev>

On Wed, Feb 19, 2025 at 10:08:20PM +0000, Yosry Ahmed wrote:
> This series removes X86_FEATURE_USE_IBPB, and fixes a KVM nVMX bug in
> the process. The motivation is mostly the confusing name of
> X86_FEATURE_USE_IBPB, which sounds like it controls IBPBs in general,
> but it only controls IBPBs for spectre_v2_mitigation. A side effect of
> this confusion is the nVMX bug, where virtualizing IBRS correctly
> depends on the spectre_v2_user mitigation.
> 
> The feature bit is mostly redundant, except in controlling the IBPB in
> the vCPU load path. For that, a separate static branch is introduced,
> similar to switch_mm_*_ibpb.

Thanks for doing this.  A few months ago I was working on patches to fix
the same thing but I got preempted multiple times over.

> I wanted to do more, but decided to stay conservative. I was mainly
> hoping to merge indirect_branch_prediction_barrier() with entry_ibpb()
> to have a single IBPB primitive that always stuffs the RSB if the IBPB
> doesn't, but this would add some overhead in paths that currently use
> indirect_branch_prediction_barrier(), and I was not sure if that's
> acceptable.

We always rely on IBPB clearing RSB, so yes, I'd say that's definitely
needed.  In fact I had a patch to do exactly that, with it ending up
like this:

static inline void indirect_branch_prediction_barrier(void)
{
	asm volatile(ALTERNATIVE("", "call write_ibpb", X86_FEATURE_IBPB)
		     : ASM_CALL_CONSTRAINT
		     : : "rax", "rcx", "rdx", "memory");
}

I also renamed "entry_ibpb" -> "write_ibpb" since it's no longer just
for entry code.

-- 
Josh

