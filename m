Return-Path: <kvm+bounces-69909-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLtHFwMNgWkCDwMAu9opvQ
	(envelope-from <kvm+bounces-69909-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:45:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF93D13DC
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:45:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2DB0B3042951
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 20:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D2730B518;
	Mon,  2 Feb 2026 20:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/y6xbqg"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5169F2C1788
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770065093; cv=none; b=o5ryMfdkyW6sxkJqQC3nNDV8NlU5YQvAXQ/CNLgRz0XwRW3drJdpUibV6Ipvdi9uouU4ruQDLsyeOjJL0EA+kcQZCnpddstV9muXLRw4/PXJvn024SbzB5bsEsCTSZ063+mmc3Oyf0KocLQhfzYhnJFjmUmJol/hzA56JydD+EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770065093; c=relaxed/simple;
	bh=HEa/53gPFbou3og6OCMWaGACBfEjJA0P67QtI/gXCio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB9v4GaLCx68W+Sa5ZY19gMM2W6znidDqqq4xPMW9R/xmm+59yUd1bejlP3ODkW2mS+4z21sj/H6C5i5PI46Qu3ng/So/Ld/iMNjv3YQSIOFermlaDWOvm1IsVNjBGWobWafuL8pEpnZGYhrSCQsIW3fzu+QfwLK6BHDJw7wAMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/y6xbqg; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 2 Feb 2026 20:44:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770065079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vumbmx0ORGVJ2XU9vfaSkwa13xhN2HHhdBz6/kFPDJM=;
	b=o/y6xbqg716DDTnQw6MW33/HBpYDfHqw+849UppbGucPyJa9mKZs8R039A2L4rp4mBp/X8
	hzbusQ6qpGKLLVLS5qSiq98d/VnujpVRZJ04HgYSm3pLt/Cd81LB1J1bQJ4BtraM9N8tT1
	d7I7AjD/0JP61WxQlnu0A86VBm+zmGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de
Subject: Re: [PATCH v5 4/5] KVM: SVM: Add support for
 KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs
Message-ID: <peroaux2ghnb2ypg2ebzflb3xvg3bzpaircqht3vdgy7tkrwn4@pfpkfhasn44i>
References: <20250502050346.14274-1-manali.shukla@amd.com>
 <20250502050346.14274-5-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502050346.14274-5-manali.shukla@amd.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69909-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,amd.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDF93D13DC
X-Rspamd-Action: no action

On Fri, May 02, 2025 at 05:03:45AM +0000, Manali Shukla wrote:
> Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs with Bus Lock
> Threshold, which is close enough to VMX's Bus Lock Detection VM-Exit to
> allow reusing KVM_CAP_X86_BUS_LOCK_EXIT.
> 
> The biggest difference between the two features is that Threshold is
> fault-like, whereas Detection is trap-like.  To allow the guest to make
> forward progress, Threshold provides a per-VMCB counter which is
> decremented every time a bus lock occurs, and a VM-Exit is triggered if
> and only if the counter is '0'.
> 
> To provide Detection-like semantics, initialize the counter to '0', i.e.
> exit on every bus lock, and when re-executing the guilty instruction, set
> the counter to '1' to effectively step past the instruction.
> 
> Note, in the unlikely scenario that re-executing the instruction doesn't
> trigger a bus lock, e.g. because the guest has changed memory types or
> patched the guilty instruction, the bus lock counter will be left at '1',
> i.e. the guest will be able to do a bus lock on a different instruction.
> In a perfect world, KVM would ensure the counter is '0' if the guest has
> made forward progress, e.g. if RIP has changed.  But trying to close that
> hole would incur non-trivial complexity, for marginal benefit; the intent
> of KVM_CAP_X86_BUS_LOCK_EXIT is to allow userspace rate-limit bus locks,
> not to allow for precise detection of problematic guest code.  And, it's
> simply not feasible to fully close the hole, e.g. if an interrupt arrives
> before the original instruction can re-execute, the guest could step past
> a different bus lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  Documentation/virt/kvm/api.rst |  5 +++++
>  arch/x86/kvm/svm/nested.c      | 34 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c         | 38 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h         |  1 +
>  4 files changed, 78 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index ad1859f4699e..f7d2d477c3cf 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7989,6 +7989,11 @@ apply some other policy-based mitigation. When exiting to userspace, KVM sets
>  KVM_RUN_X86_BUS_LOCK in vcpu-run->flags, and conditionally sets the exit_reason
>  to KVM_EXIT_X86_BUS_LOCK.
>  
> +Due to differences in the underlying hardware implementation, the vCPU's RIP at
> +the time of exit diverges between Intel and AMD.  On Intel hosts, RIP points at
> +the next instruction, i.e. the exit is trap-like.  On AMD hosts, RIP points at
> +the offending instruction, i.e. the exit is fault-like.
> +
>  Note! Detected bus locks may be coincident with other exits to userspace, i.e.
>  KVM_RUN_X86_BUS_LOCK should be checked regardless of the primary exit reason if
>  userspace wants to take action on all detected bus locks.
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 834b67672d50..5369d9517fbb 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -678,6 +678,33 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
>  
> +	/*
> +	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
> +	 * instrution; otherwise, reset the counter to '0'.
> +	 *
> +	 * In order to detect if L2 has made forward progress or not, track the
> +	 * RIP at which a bus lock has occurred on a per-vmcb12 basis.  If RIP
> +	 * is changed, guest has clearly made forward progress, bus_lock_counter
> +	 * still remained '1', so reset bus_lock_counter to '0'. Eg. In the
> +	 * scenario, where a buslock happened in L1 before VMRUN, the bus lock
> +	 * firmly happened on an instruction in the past. Even if vmcb01's
> +	 * counter is still '1', (because the guilty instruction got patched),
> +	 * the vCPU has clearly made forward progress and so KVM should reset
> +	 * vmcb02's counter to '0'.
> +	 *
> +	 * If the RIP hasn't changed, stash the bus lock counter at nested VMRUN
> +	 * to prevent the same guilty instruction from triggering a VM-Exit. Eg.
> +	 * if userspace rate-limits the vCPU, then it's entirely possible that
> +	 * L1's tick interrupt is pending by the time userspace re-runs the
> +	 * vCPU.  If KVM unconditionally clears the counter on VMRUN, then when
> +	 * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
> +	 * entire cycle start over.
> +	 */
> +	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))

Is vmcb02->save.rip the right thing to use here?

IIUC, we want to find out if L2 made forward progress since the last bus
lock #VMEXIT from L2 to L0, at which point we record bus_lock_rip.
However, on nested VMRUN, vmcb02->save.rip is only populated from the
vmcb12 in nested_vmcb02_prepare_save(), which doesn't happen until after
nested_vmcb02_prepare_control(). So waht we're comparing against here is
L2's RIP last time KVM ran it.

It's even worse in the KVM_SET_NESTED_STATE path, because
vmcb02->save.rip will be unintialized (probably zero).

Probably you want to use vmcb12_rip here, as this is the RIP that L1
wants to run L2 with, and what will end up in vmcb02->save.rip.

HOWEVER, that is also broken in the KVM_SET_NESTED_STATE path. In that
path we pass in the uninitialized vmcb02->save.rip as vmcb12_rip anyway.
Fixing this is non-trivial because KVM_SET_REGS could be called before
or after KVM_SET_NESTED_STATE, so the RIP may not be available at all at
that point.

We probably want to set a flag in svm_set_nested_state() that the RIP
needs fixing up, and the perhaps in svm_vcpu_pre_run() fix up the
control fields in vmcb02 that depend on it: namely the bus_lock_counter,
next_rip, and soft_int_* fields.

It gets worse because I think next_rip is also not always properly
saved/restored because we do not sync it from vmcb02 to cache in
nested_sync_control_from_vmcb02() -- but that one is not relevant to
bus_lock_counter AFAICT.

> +		vmcb02->control.bus_lock_counter = 1;
> +	else
> +		vmcb02->control.bus_lock_counter = 0;
> +
>  	/* Done at vmrun: asid.  */
>  
>  	/* Also overwritten later if necessary.  */

