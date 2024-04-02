Return-Path: <kvm+bounces-13343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6C8894BB4
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8319282FBD
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D4C2C683;
	Tue,  2 Apr 2024 06:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K2lF3pDG"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D292BB1F
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 06:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040321; cv=none; b=md1KEq8XzA4eHeCD/QAPMs0DnpyBHSWfODQu/tF+4fBqhcmTI5eGHeIxvRgf267oz23nE2EI2vCu4BT81zMQNaAom4XCqMqpDh7OeTl0lm/DobEMR/VJay1HOqTCtkGegskCLNBHh8bt01YFDMXEhqA1aTedotIfR10YoPIkLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040321; c=relaxed/simple;
	bh=gzqz7q4r7z0bZ6DFUwqsA0eIefQX12YLOiC0yCy0EbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkZROSLlml7nUYYOO/SNzXcUgOw+hG95a/7WSFDogIH2rXSAfsHUxyibCy6d4Vvpb/D5iMNSv7QmPyFIykm62q9Sm/LlHtnMiAuGPu5JddSafkyA0h1X/8WUCzyEbczBlkGlGb8K05weqq7jJjw4XJ+c/pdmiEmo6qoKJEYAQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K2lF3pDG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 1 Apr 2024 23:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712040317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mq9AuEi8/S5UYzDB5Bm6UzRBTBeITNOQlNgUFt/hCLA=;
	b=K2lF3pDGykNJP+Odcxr6HVpWjmQPj6gwa7brhClqMg/6VKUv5dJLjc0uGwlIBEMzvpNksK
	GI92H4xJXnZzVUSChZVGmD5pqHoT4rQ0Guqo8gwSYOqAXou00eCuwu4bskpI3l1A4oc3CO
	RukxUi8EYtV2fn+IqGBbjnQXZ46Cjqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #1
Message-ID: <ZgupcZjEGLTmed_5@linux.dev>
References: <ZgtsA88wkIDaKEXk@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgtsA88wkIDaKEXk@linux.dev>
X-Migadu-Flow: FLOW_OUT

+cc lists...

On Mon, Apr 01, 2024 at 07:23:13PM -0700, Oliver Upton wrote:
> Hi Paolo,
> 
> Here's the first set of fixes for 6.9. Several good fixes piled up here,
> partly because I've had limited availability due to travel.
> 
> Details are in the tag. Please pull.
> 
> -- 
> Best,
> Oliver
> 
> The following changes since commit 4cece764965020c22cff7665b18a012006359095:
> 
>   Linux 6.9-rc1 (2024-03-24 14:10:05 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.9-1
> 
> for you to fetch changes up to d96c66ab9fb3ad8b243669cf6b41e68d0f7f9ecd:
> 
>   KVM: arm64: Rationalise KVM banner output (2024-04-01 01:33:52 -0700)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.9, part #1
> 
>  - Ensure perf events programmed to count during guest execution
>    are actually enabled before entering the guest in the nVHE
>    configuration.
> 
>  - Restore out-of-range handler for stage-2 translation faults.
> 
>  - Several fixes to stage-2 TLB invalidations to avoid stale
>    translations, possibly including partial walk caches.
> 
>  - Fix early handling of architectural VHE-only systems to ensure E2H is
>    appropriately set.
> 
>  - Correct a format specifier warning in the arch_timer selftest.
> 
>  - Make the KVM banner message correctly handle all of the possible
>    configurations.
> 
> ----------------------------------------------------------------
> Marc Zyngier (2):
>       arm64: Fix early handling of FEAT_E2H0 not being implemented
>       KVM: arm64: Rationalise KVM banner output
> 
> Oliver Upton (1):
>       KVM: arm64: Fix host-programmed guest events in nVHE
> 
> Sean Christopherson (1):
>       KVM: selftests: Fix __GUEST_ASSERT() format warnings in ARM's arch timer test
> 
> Will Deacon (4):
>       KVM: arm64: Don't defer TLB invalidation when zapping table entries
>       KVM: arm64: Don't pass a TLBI level hint when zapping table entries
>       KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
>       KVM: arm64: Ensure target address is granule-aligned for range TLBI
> 
> Wujie Duan (1):
>       KVM: arm64: Fix out-of-IPA space translation fault handling
> 
>  arch/arm64/kernel/head.S                         | 29 +++++++++++++-----------
>  arch/arm64/kvm/arm.c                             | 13 ++++-------
>  arch/arm64/kvm/hyp/nvhe/tlb.c                    |  3 ++-
>  arch/arm64/kvm/hyp/pgtable.c                     | 23 ++++++++++++-------
>  arch/arm64/kvm/hyp/vhe/tlb.c                     |  3 ++-
>  arch/arm64/kvm/mmu.c                             |  2 +-
>  include/kvm/arm_pmu.h                            |  2 +-
>  tools/testing/selftests/kvm/aarch64/arch_timer.c |  2 +-
>  8 files changed, 43 insertions(+), 34 deletions(-)

