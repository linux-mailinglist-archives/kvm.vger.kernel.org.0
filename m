Return-Path: <kvm+bounces-41310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03575A65E89
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 20:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4442818924FD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E38D17A2EB;
	Mon, 17 Mar 2025 19:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OrE+s6JI"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C91A00F0
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 19:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742241299; cv=none; b=dGcIbfxCw/DT8avihjYlHHcSyVVeFNrDLWt+xhOdWHDnl6Hu7ph4xzgFbNdpF+cgIcXjFbSV3/QvI6xPAfu4nfvUvOcMyAjtH91SKLF7IONgDGV7mJosKweGhc9x0opf011IZ4DhksQbS2NXOAdzUyX9T/V8reoiKMzIfnhO5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742241299; c=relaxed/simple;
	bh=SxjTYKg2aIQG6dWKUbbXH3stAR3C9qID78xwGzP6DxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQmBReI8wiW5+JmWjwgMRtiAEpfuI+7A7hZ0rhTPPQ0fyFP4/mjG62gZvlDT2VRKEt/WkmngGc8xnpHElcBZ7yPIaN2Dw/5Aa0mWZ75NoZ2IM6k2rS394SH/iY3RCKA9ebcYb+DBrT7OEQY6ZsuS29VRdbpmEn5l4bUlmZs3cZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OrE+s6JI; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Mar 2025 19:54:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742241285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUoJ/GcN/vJw4cdVEkEY7Beh+Sm/ZGlbmQKOcW3Ar/k=;
	b=OrE+s6JINdxoINOiZmwheSWAZ93ycSx5/TInasEEqivQ5WTymEuz/h9QjwmtsT3SUVSPlj
	DAtQRvO7OH1klTsTpYM+bQ7VqfpNHtZvAcIHMyJ8VSgbcgZyKGKvvOfO7cNLrgWGq+JIGl
	pFRofY30bYJFwvL6fDv3wbKhOxPBAaY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add a module param to control and enumerate
 device posted IRQs
Message-ID: <Z9h-ADGIb7B8no50@google.com>
References: <20250315025615.2367411-1-seanjc@google.com>
 <Z9hvwW2C-7_ivkPU@google.com>
 <Z9h7eTs8i8TRRxqU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9h7eTs8i8TRRxqU@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 12:43:53PM -0700, Sean Christopherson wrote:
> On Mon, Mar 17, 2025, Yosry Ahmed wrote:
> > On Fri, Mar 14, 2025 at 07:56:15PM -0700, Sean Christopherson wrote:
> > > Add a module param to allow disabling device posted interrupts without
> > > having to sacrifice all of APICv/AVIC, and to also effectively enumerate
> > > to userspace whether or not KVM may be utilizing device posted IRQs.
> > > Disabling device posted interrupts is very desirable for testing, and can
> > > even be desirable for production environments, e.g. if the host kernel
> > > wants to interpose on device interrupts.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 1 +
> > >  arch/x86/kvm/svm/avic.c         | 3 +--
> > >  arch/x86/kvm/vmx/posted_intr.c  | 7 +++----
> > >  arch/x86/kvm/x86.c              | 9 ++++++++-
> > >  4 files changed, 13 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index d881e7d276b1..bf11c5ee50cb 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1922,6 +1922,7 @@ struct kvm_arch_async_pf {
> > >  extern u32 __read_mostly kvm_nr_uret_msrs;
> > >  extern bool __read_mostly allow_smaller_maxphyaddr;
> > >  extern bool __read_mostly enable_apicv;
> > > +extern bool __read_mostly enable_device_posted_irqs;
> > >  extern struct kvm_x86_ops kvm_x86_ops;
> > >  
> > >  #define kvm_x86_call(func) static_call(kvm_x86_##func)
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 65fd245a9953..e0f519565393 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -898,8 +898,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> > >  	struct kvm_irq_routing_table *irq_rt;
> > >  	int idx, ret = 0;
> > >  
> > > -	if (!kvm_arch_has_assigned_device(kvm) ||
> > > -	    !irq_remapping_cap(IRQ_POSTING_CAP))
> > > +	if (!kvm_arch_has_assigned_device(kvm) || !enable_device_posted_irqs)
> > 
> > This function will now also be skipped if enable_apicv is false. Is this
> > always the case here for some reason? Sorry if I missed something
> > obvious.
> 
> Working as intended, though I failed to document it.  Hrm, but I wasn't expecting
> this to be a functional change.  Oh, I know what happened.  I had originally
> tacked this on to a big series to clean up the IRTE stuff (spoiler alert), and in
> that series common code checked kvm_arch_has_irq_bypass() (which incorporates
> enable_apicv) before calling pi_update_irte().
> 
> I'll prepend a patch or three to do minimal cleanup before introducing the new
> module param.
> 
> > > @@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> > >  	if (r != 0)
> > >  		goto out_mmu_exit;
> > >  
> > > +	enable_device_posted_irqs = enable_device_posted_irqs && enable_apicv &&
> > > +				    irq_remapping_cap(IRQ_POSTING_CAP);
> > 
> > Maybe this is clearer:
> > 
> > 	enable_device_posted_irqs &= enable_avivc && irq_remapping_cap(IRQ_POSTING_CAP);
> 
> I don't have a strong opinion.  I went with the "self check" approach purely
> because SVM does so for a few params, e.b.
> 
> 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
> 
> Anyone else care either way?  If not, I'll go with Yosry's suggestion.

I can understand a consistency argument, so I am fine either way too.
The main reason I suggested this is that it took me a second to realize
this is the same thing on both sides of the assignment.

