Return-Path: <kvm+bounces-67186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1448CFB590
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 00:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF106300B2A5
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 23:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BBD127B35F;
	Tue,  6 Jan 2026 23:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k/RbqFo4"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA4DAD24
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767742322; cv=none; b=Qgas5Ssy5jletPrlv/zXAyfqfdCDyA46/+la25Vn1TLEwmRFFsrwiG5OEZV/8lOVn6Dzx1/vUs2rgYOPWeCBc3/Y8O6m/1t1/mcPcx5wDRiW7PJcxNrzTFwTaKkcDinr6eZaeFnEBcMkDPkAxJaooxUToCILwEbt0y24utCGMjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767742322; c=relaxed/simple;
	bh=M1R3Zlut2J100ym5KpUqlAeMtjkOuAcrYnWtXH2CMJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrscI17sd+1Z9ftcO2gltq8lMYzRDc/3hzmDa53hzxwNCLGOwtWiQb2AOl5k2SRlAhLTwnGHBOZiUbLrBr2MTn2LmTJqlPZx4vurQa7HVoznVX+7EngrBfpJeVf4wtWzqrQ4faJyYL1G9gNOxWvXI47vuCNiCl8zdgpfGvpQ8T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k/RbqFo4; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Jan 2026 23:31:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767742318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0m+kAYtZAeWtHYs7lyG3TgSmTlYbXfsXfL6blMYe7ho=;
	b=k/RbqFo4Dx7slL38Y5Fgd2bcqx2FukE+StqlPPcvC3/sZNmMKAp3OzRgVcIxds1mF2LNgA
	4RNU3kJqt2dn/O0q+SBqO/I37emaNigocPvg5tUc9HTr4K3mK7JeLpD+MVclDVK+YNBETl
	MBufz0Ay+GuchfsVpAMD4XFTAxjFWOw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
Message-ID: <pbbfdqgd7vu6xknmrlg6ezrbhprnw42ngbkp7f55thxanqgnuf@7l4fkbrk7v76>
References: <20260106041250.2125920-1-chengkev@google.com>
 <20260106041250.2125920-3-chengkev@google.com>
 <aV1UpwppcDbOim_K@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV1UpwppcDbOim_K@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 06, 2026 at 10:29:59AM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Kevin Cheng wrote:
> > The AMD APM states that if VMMCALL instruction is not intercepted, the
> > instruction raises a #UD exception.
> > 
> > Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
> > from L2 is being handled by L0, which means that L1 did not intercept
> > the VMMCALL instruction.
> > 
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Co-developed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> Co-developed-by requires a SoB.  As Yosry noted off-list, he only provided the
> comment, and I have feedback on that :-)  Unless Yosry objects, just drop his.
> Co-developed-by.

Yup, no objections.

> 
> Ditt for me, just give me
> 
>   Suggested-by: Sean Christopherson <seanjc@google.com>
> 
> I don't need a Co-developed-by for a tossing a code snippet your way. though I
> appreciate the offer. :-)
> 
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index fc1b8707bb00c..482495ad72d22 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3179,6 +3179,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * If VMMCALL from L2 is not intercepted by L1, the instruction raises a
> > +	 * #UD exception
> > +	 */
> 
> Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
> IMO the most notable thing is what's missing: an intercept check.  _That_ is
> worth commenting, e.g.
> 
> 	/*
> 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> 	 * and only if the VMCALL intercept is not set in vmcb12.

Nit: VMMCALL

> 	 */
> 

Would it be too paranoid to WARN if the L1 intercept is set here?

WARN_ON_ONCE(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_VMMCALL));

> > +	if (is_guest_mode(vcpu)) {
> > +		kvm_queue_exception(vcpu, UD_VECTOR);
> > +		return 1;
> > +	}
> > +
> > +	return kvm_emulate_hypercall(vcpu);
> > +}
> > +
> >  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> >  	[SVM_EXIT_READ_CR0]			= cr_interception,
> >  	[SVM_EXIT_READ_CR3]			= cr_interception,
> > @@ -3229,7 +3243,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> >  	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
> >  	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
> >  	[SVM_EXIT_VMRUN]			= vmrun_interception,
> > -	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
> > +	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
> >  	[SVM_EXIT_VMLOAD]			= vmload_interception,
> >  	[SVM_EXIT_VMSAVE]			= vmsave_interception,
> >  	[SVM_EXIT_STGI]				= stgi_interception,
> > -- 
> > 2.52.0.351.gbe84eed79e-goog
> > 

