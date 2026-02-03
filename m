Return-Path: <kvm+bounces-70017-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAoVBfASgmkgPAMAu9opvQ
	(envelope-from <kvm+bounces-70017-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:23:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58736DB3B6
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68B1A3040AB4
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 15:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B6D3B8BDA;
	Tue,  3 Feb 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XvVq5FrJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A58350A27
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770132193; cv=none; b=r71bdxP1jg08ji68RyTANOe+9FmKyRonfO0y3Yb1RFSn8EcV3unmhXkUmnuf/UFFh/GQrQRns4z5XlwKLk6Kt8Un0H85xOUYKC323esNpkCJBjkZjgPz0iIHy80nSiVSJBqVfeDe5at2krggwM9VQr1IW0C+VxEHjBBz6Koqzu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770132193; c=relaxed/simple;
	bh=rzQGt1N2ZO8dOd7i79sx1Ao/WEEnEvDQP1VOYJUDuaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZ2cd9Ip8TO/0ZT3GETmqxTX3J6CfEj30lDZm5Am+iipG0Q+6A6aiLRVFi/PEvKgxzGruLcn7tOCeBcPmsa2bed8MX+tYPZVUfPs7/T/bi6yuhPZFifohSEHJcDXd5UalQgNepQhkEJv+TN9oupFA3ZBrFbqS59GvObTnniD0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XvVq5FrJ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Feb 2026 15:23:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770132187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HvRUbJAJAbOWe9IJQankgjel8Z/R5+36b3jfTfYLbOk=;
	b=XvVq5FrJWuTtHIVgOoTGTflq0zBhAJ2MrAY8DKjvDDbt1Rah1QdzL2tXN4r2S7fNBHI5bB
	z7sKK2RlgyY6npl1Uef9d7csmM8ZDG424f9ji2Qdot6gP9q6nNK/mCJEt4p8ieDT51TWlq
	GlIcao1EN2aZ1iQ3dajJFZOmhPDPD+E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de
Subject: Re: [PATCH v5 4/5] KVM: SVM: Add support for
 KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs
Message-ID: <mn5drqp24qayx7lmjdpwjtjztjkc5cezgdrv4gvqb5xu3obowc@jwlkjbpcuew6>
References: <20250502050346.14274-1-manali.shukla@amd.com>
 <20250502050346.14274-5-manali.shukla@amd.com>
 <peroaux2ghnb2ypg2ebzflb3xvg3bzpaircqht3vdgy7tkrwn4@pfpkfhasn44i>
 <aYINAAGPto_TqLt-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYINAAGPto_TqLt-@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70017-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 58736DB3B6
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 06:58:08AM -0800, Sean Christopherson wrote:
> On Mon, Feb 02, 2026, Yosry Ahmed wrote:
> > On Fri, May 02, 2025 at 05:03:45AM +0000, Manali Shukla wrote:
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 834b67672d50..5369d9517fbb 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -678,6 +678,33 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> > >  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> > >  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> > >  
> > > +	/*
> > > +	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
> > > +	 * instrution; otherwise, reset the counter to '0'.
> > > +	 *
> > > +	 * In order to detect if L2 has made forward progress or not, track the
> > > +	 * RIP at which a bus lock has occurred on a per-vmcb12 basis.  If RIP
> > > +	 * is changed, guest has clearly made forward progress, bus_lock_counter
> > > +	 * still remained '1', so reset bus_lock_counter to '0'. Eg. In the
> > > +	 * scenario, where a buslock happened in L1 before VMRUN, the bus lock
> > > +	 * firmly happened on an instruction in the past. Even if vmcb01's
> > > +	 * counter is still '1', (because the guilty instruction got patched),
> > > +	 * the vCPU has clearly made forward progress and so KVM should reset
> > > +	 * vmcb02's counter to '0'.
> > > +	 *
> > > +	 * If the RIP hasn't changed, stash the bus lock counter at nested VMRUN
> > > +	 * to prevent the same guilty instruction from triggering a VM-Exit. Eg.
> > > +	 * if userspace rate-limits the vCPU, then it's entirely possible that
> > > +	 * L1's tick interrupt is pending by the time userspace re-runs the
> > > +	 * vCPU.  If KVM unconditionally clears the counter on VMRUN, then when
> > > +	 * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
> > > +	 * entire cycle start over.
> > > +	 */
> > > +	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
> > 
> > Is vmcb02->save.rip the right thing to use here?
> 
> Objection, leading the witness your honor.

Withdrawn.

> 
> > IIUC, we want to find out if L2 made forward progress since the last bus
> > lock #VMEXIT from L2 to L0
> 
> More or less.
>   
> >, at which point we record bus_lock_rip.
> > However, on nested VMRUN, vmcb02->save.rip is only populated from the
> > vmcb12 in nested_vmcb02_prepare_save(), which doesn't happen until after
> > nested_vmcb02_prepare_control(). So waht we're comparing against here is
> > L2's RIP last time KVM ran it.
> 
> Hrm, that definitely seems like what past me intended[*], as this quite clearly
> suggests my intent was to check the RIP coming from vmcb12:
> 
>  : Again, it's imperfect, e.g. if L1 happens to run a different vCPU at the same
>  : RIP, then KVM will allow a bus lock for the wrong vCPU.  But the odds of that
>  : happening are absurdly low unless L1 is deliberately doing weird things, and so
>  : I don't think
> 
> I have this vague feeling that I deliberately didn't check @vmcb12_rip, but the
> more I look at this, the more I'm convinced I simply didn't notice @vmcb12_rip
> when typing up the suggestion.

Yeah I looked through the history trying to figure out if the choice was
intentional but I couldn't find a clue.

> 
> [*] https://lore.kernel.org/all/Zw6rJ3y_F-10xBcH@google.com
> 
> > It's even worse in the KVM_SET_NESTED_STATE path, because
> > vmcb02->save.rip will be unintialized (probably zero).
> 
> FWIW, this one is arguably ideal, in the sense that KVM should probably assume
> the worst if userspace is loading guest state.
> 
> > Probably you want to use vmcb12_rip here, as this is the RIP that L1
> > wants to run L2 with, and what will end up in vmcb02->save.rip.
> >
> > HOWEVER, that is also broken in the KVM_SET_NESTED_STATE path. In that
> > path we pass in the uninitialized vmcb02->save.rip as vmcb12_rip anyway.
> 
> 
> > Fixing this is non-trivial because KVM_SET_REGS could be called before
> > or after KVM_SET_NESTED_STATE, so the RIP may not be available at all at
> > that point.
> 
> Eh, this code is completely meaningless on KVM_SET_NESTED_STATE.  There is no
> "right" answer, because KVM has no clue what constitutes forward progress.
> 
> Luckily, no answer is completely "wrong" either, because the #VMEXIT is transparent
> to L1 and L2.  E.g. it's like saying that sending an IRQ to CPU running a vCPU is
> "wrong"; it's never truly "wrong", just suboptimal (sometimes *very* suboptimal).
> 
> > We probably want to set a flag in svm_set_nested_state() that the RIP
> > needs fixing up, and the perhaps in svm_vcpu_pre_run() fix up the
> > control fields in vmcb02 that depend on it: namely the bus_lock_counter,
> > next_rip, and soft_int_* fields.
> 
> Nah, not unless there's a meaningful, negative impact on a real world setup.
> And as above, in practice the only impact is effectively a performance blip due
> to generating an unwanted userspace exit.  If userspace is stuffing nested state
> so often that that's actually a performance problem, then userspace can set regs
> before nested state.

But the wrong @vmcb12_rip also affects soft IRQ injection, which I know
is not relevant here, but is part of the reason I brought this up.

If the guest has NRIPS, we use @vmcb12_rip to figure out if we need to
reset next_rip after a VMRUN. If the guest does not have NRIPS, we put
it directly in next_rip.

Either way we could end up with a messed up next_rip, and that can mess
up the guest IIUC. Of course, all of that only happens if we migrate
with a pending soft IRQ which is probably unlikely, but could happen.

> 
> There are a pile of edge cases and "what ifs" around this, none of which have a
> perfect answer since KVM doesn't know userspace's intent.  And so I want to go
> with a solution that is as simple as possible without risking putting L2 into an
> infinite loop.
> 
> > It gets worse because I think next_rip is also not always properly
> > saved/restored because we do not sync it from vmcb02 to cache in
> > nested_sync_control_from_vmcb02() -- but that one is not relevant to
> > bus_lock_counter AFAICT.
> 
> Correct.
> 
> All in all, I think just this?

For the bus lock thing that's probably the right thing to do. It fixes
the usual nested VMRUN path and doesn't really make the
KVM_SET_NESTED_STATE path any worse (feel free to add a Reviewed-by from
me).

But I am wondering if we should also fix @vmcb12_rip in the
KVM_SET_NESTED_STATE path (separately), for the soft IRQ case as well.

> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..482092b2051c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -809,7 +809,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>          * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
>          * entire cycle start over.
>          */
> -       if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
> +       if (vmcb12_rip && (svm->nested.ctl.bus_lock_rip == vmcb12_rip))
>                 vmcb02->control.bus_lock_counter = 1;
>         else
>                 vmcb02->control.bus_lock_counter = 0;

