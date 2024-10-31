Return-Path: <kvm+bounces-30258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE03F9B85AE
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A33CB21ED9
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A83E1CBE97;
	Thu, 31 Oct 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iQvPfPlR"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ADE1922F1
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730411217; cv=none; b=rDfgKVmkilP312VGM+f9WO1ea/SDh8l3PFbUBSYJzsu60YqCZEeyqCdCAKlKRJ2+B9Qo3WdZM8CeLe5T1dsHaufh5PF7SVudawzDe+CjCMFeqmej72qiiYlLlmpWPKYqQIawsRqNceM85QfLiDk0xt5H6lzzVgOX6OvlGyQt6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730411217; c=relaxed/simple;
	bh=BsZib7sokzrsLYASZ5FuWcTgP66UHo261J1lD/nH/Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UbC2RejNz+LnGjXgI2dzWAEGpJGI945fVTLi1acDSUOvF+o4A9QUuF2GseVzJ10gQlnfVM9nV8sXy6VBCc7zgnCUqLBh4um9fHSFQQrvxRtm8XMfcBeHFWs7/3CdG8keOqo/H/AdeiC8OwzVrcXqHMwaUS4frqwTkoh3WayyNYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iQvPfPlR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 31 Oct 2024 21:46:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730411207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qKFJMALNUJxy+K52N5OoWGpav88DkFPxeSQGU+lIc8I=;
	b=iQvPfPlRSmHoLgWtQ4dqbKGiyqPjjygOZ0vhrb5q6vMCULJZOJ3neinrycnRGcQj7QYJz3
	MsQ0fceu5GLOLWz02s2otVx9So1/4Ppbpz0K4KTI58SWO6DI0EfFBI9Ye9S0hHVjFqJCRM
	1CrjS6CT2UnxJWEoChZ4DA+kWlNeuXU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, duenwen@google.com,
	rananta@google.com
Subject: Re: [RFC PATCH v1] KVM: arm64: Introduce KVM_CAP_ARM_SIGBUS_ON_SEA
Message-ID: <ZyP6whdv4bmsI13x@linux.dev>
References: <20241031212104.1429609-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031212104.1429609-1-jiaqiyan@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jiaqi,

Thank you for sending this out.

On Thu, Oct 31, 2024 at 09:21:04PM +0000, Jiaqi Yan wrote:
> Currently KVM handles SEA in guest by injecting async SError into
> guest directly, bypassing VMM, usually results in guest kernel panic.
> 
> One major situation of guest SEA is when vCPU consumes uncorrectable
> memory error on the physical memory. Although SError and guest kernel
> panic effectively stops the propagation of corrupted memory, it is not
> easy for VMM and guest to recover from memory error in a more graceful
> manner.
> 
> Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
> how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
> thread.
> In addition to the benifit that KVM's handling for SEA becomes aligned
> with core kernel behavior
> - The blast radius in VM can be limited to only the consuming thread
>   in guest, instead of entire guest kernel, unless the consumption is
>   from guest kernel.
> - VMM now has the chance to do its duties to stop the VM from repeatedly
>   consuming corrupted data. For example, VMM can unmap the guest page
>   from stage-2 table to intercept forseen memory poison consumption,
>   and for every consumption injects SEA to EL1 with synthetic memory
>   error CPER.
> 
> Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
> can opt in this new capability if it prefers SIGBUS than SError
> injection during VM init. Now SEA handling in KVM works as follows:

I'm somewhat tempted to force the new behavior on userspace
unconditionally. Working back from an unexpected SError in the VM to the
KVM SEA handler is a bit of a mess, and can be annoying if the operator
can't access console logs of the VM.

As it stands today, UAPI expectations around SEAs are platform
dependent. If APEI claims the SEA and decides to offline a page, the
user will get a SIGBUS.

So sending a SIGBUS for the case that firmware _doesn't_ claim the SEA
seems like a good move from a consistency PoV. But it is a decently-sized
change to do without explicit buy-in from userspace so let's see what
others think.

> 1. Delegate to APEI/GHES to see if SEA can be claimed by them.
> 2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
>    enabled for the VM, and the SEA is NOT about translation table,
>    send SIGBUS BUS_OBJERR signal with host virtual address.
> 3. Otherwise directly inject async SError to guest.

The other reason I'm a bit lukewarm on user buy in is the UAPI suffers
from the same issue we do today: it depends on the platform. If the SEA
is claimed by APEI/GHES then the cap does nothing.

> +static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
> +{
> +	/* apei_claim_sea(NULL) expects to mask interrupts itself */
> +	lockdep_assert_irqs_enabled();
> +	return apei_claim_sea(NULL);
> +}

Consider dropping parameters from this since they're unused.

> +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> +{
> +	bool sigbus_on_sea;
> +	int idx;
> +	u64 vcpu_esr = kvm_vcpu_get_esr(vcpu);
> +	u8 fsc = kvm_vcpu_trap_get_fault(vcpu);
> +	phys_addr_t fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
> +	/* When FnV is set, send 0 as si_addr like what do_sea() does. */
> +	unsigned long hva = 0UL;
> +
> +	/*
> +	 * For RAS the host kernel may handle this abort.
> +	 * There is no need to SIGBUS VMM, or pass the error into the guest.
> +	 */
> +	if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) == 0)
> +		return;
> +
> +	sigbus_on_sea = test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
> +				 &(vcpu->kvm->arch.flags));
> +
> +	/*
> +	 * In addition to userspace opt-in, SIGBUS only makes sense if the
> +	 * abort is NOT about translation table walk and NOT about hardware
> +	 * update of translation table.
> +	 */
> +	sigbus_on_sea &= (fsc == ESR_ELx_FSC_EXTABT || fsc == ESR_ELx_FSC_SECC);

Is this because we potentially can't determine a valid HVA for the
fault? Maybe these should go out to userspace still with si_addr = 0.

-- 
Thanks,
Oliver

