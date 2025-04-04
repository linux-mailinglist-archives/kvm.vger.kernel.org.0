Return-Path: <kvm+bounces-42679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F575A7C1E4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8F93BC7C0
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCA01F416F;
	Fri,  4 Apr 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n4susH18"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B16820E30F
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785725; cv=none; b=HfBCqMfxbQ3e0N6lalXUMoD6wLWWxDx5qCpflZNSOwWwvhBwwCCTqzPr8EHPxeZVY0wEYaruEmYQsJq8So86v+lYvQ7A6JN27QwH3INHkKmUaqGUH+kkcR8/kGEjFWFLuFUMqi/woVSMd5/gki4f0liAdO4MUCtj4AfbIy2L2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785725; c=relaxed/simple;
	bh=+29bukFlDoVMoE6bFGzhVQJH69MdKYyJyarYDzKLDb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEySXbjTNE4De9HjVBykoyK4VBZ9x91C4UTZJnTNNPvgD508ml8iSgJPWV4iJzaxkICnr8bd4iaHTCZXakYy2ekAB9Hnipt7KhUN2jDJ1ks+YFnYYwAfDBcqd0E7zLlIAPBF5PSc/IVPOyZwDnd40fdMCrdZvySu9EVCd3qK2tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n4susH18; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Apr 2025 09:55:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E46+B+TgAlocdrVhG7reiJZpNqFrKjnyNTh73PBoXDI=;
	b=n4susH18Grg5mWuEHLUut/iSXGX/t0ubJrHuqIJr+Nvxhag3LQq3NqKY7xCinh150YjpOZ
	hzfIhA6tpYgv9eOXbJE8OoyhjR8sUyA0CwoDtwM+7246GbJhJag3xqMJKKH0VEPRxrltOO
	DlsQ0hI948kOGRLOER94mgRdd2e/kHQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 00/19] KVM: arm64: Debug cleanups
Message-ID: <Z_AO8A_GGHLg7FuH@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
 <20250404165233.3205127-11-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404165233.3205127-11-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

Oops, forgot to clean out directory where I stage patches.

Thanks,
Oliver

On Fri, Apr 04, 2025 at 09:52:33AM -0700, Oliver Upton wrote:
> Hopefully the last round.
> 
> v3 -> v4:
>  - Collect Tested-by from James (thanks!)
>  - Delete stray if condition (Marc)
>  - Write mdcr_el2 from kvm_arm_setup_mdcr_el2() on VHE
>  - Purge DBGxVR/DBGxCR accessors since it isn't nice to look at
> 
> Oliver Upton (19):
>   KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
>   KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
>   KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
>     vCPU
>   KVM: arm64: Move host SME/SVE tracking flags to host data
>   KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
>   KVM: arm64: Evaluate debug owner at vcpu_load()
>   KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
>   KVM: arm64: Select debug state to save/restore based on debug owner
>   KVM: arm64: Remove debug tracepoints
>   KVM: arm64: Remove vestiges of debug_ptr
>   KVM: arm64: Use debug_owner to track if debug regs need save/restore
>   KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
>   KVM: arm64: Compute MDCR_EL2 at vcpu_load()
>   KVM: arm64: Don't hijack guest context MDSCR_EL1
>   KVM: arm64: Manage software step state at load/put
>   KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
>   KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
>   KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
>   KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads
> 
>  arch/arm64/include/asm/kvm_asm.h           |   5 +-
>  arch/arm64/include/asm/kvm_host.h          |  94 ++---
>  arch/arm64/include/asm/kvm_nested.h        |   1 +
>  arch/arm64/kvm/arm.c                       |  14 +-
>  arch/arm64/kvm/debug.c                     | 384 +++++++--------------
>  arch/arm64/kvm/emulate-nested.c            |  23 +-
>  arch/arm64/kvm/fpsimd.c                    |  12 +-
>  arch/arm64/kvm/guest.c                     |  31 +-
>  arch/arm64/kvm/handle_exit.c               |   5 +-
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 ++-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
>  arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
>  arch/arm64/kvm/sys_regs.c                  | 245 ++++---------
>  arch/arm64/kvm/trace_handle_exit.h         |  75 ----
>  16 files changed, 353 insertions(+), 647 deletions(-)
> 
> 
> base-commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
> -- 
> 2.39.5
> 

