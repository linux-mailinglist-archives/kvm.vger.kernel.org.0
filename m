Return-Path: <kvm+bounces-41593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C075CA6ACFA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09E1F17F6C7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB60226CF9;
	Thu, 20 Mar 2025 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LIgZL3UD"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043CD22687A
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742494489; cv=none; b=SMFaPcc8mOYs7FyUocgoMex+O7L3jJwG+8xvjR8hSIYPh2nGM1n+xYtNRcwT4Oxt0ErvjCXzsc7ZxewgysoJLMR70eGKtDsMuXg6tGpbxdUHt7estoiyuvYQYJa0BxOXMvQLHiJiIaAuiHQ3uMOujDLRTwSmXu1W1RKymafbWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742494489; c=relaxed/simple;
	bh=eHSnvQ6XhTYWAELznlpd0nObhNjlz62IdHaH+ijNn74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbsUetSazI0VZbb/ZAB61hczJGzYKQ39jxvl7TcwJjidprhULDU3b1XZ/O8ilgsHHzc6PvCW9pUvGIK92V4nMFsla1hgk2aNN5ZpjPuEXsdI9k8Og22CP+/joMMy1CeLL2qIdYpwnbBXI6MVmp/CkVn8zzcjgZk3Ez3hx55qy68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LIgZL3UD; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 18:14:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742494474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2IOmTqSF8VusdmE8MxtCc32BNiyhroRu8EGEaXViXs=;
	b=LIgZL3UD90N22INzZ79F/FPzmDaP+LUXj4N/xLoR5oBlA90P1ZCl0xgXcmDwPzYdTLByfz
	uTJ4Su47fkYozmqg/kjY6gEzkg+WVksySdFEx6IVMO0ovaPZduK9n7Xo0t7jqnrhMw4gMD
	cFG2mgUW71l7taAI9OjyBpFsdRyXTK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
Message-ID: <Z9xbBSaephBj-OO1@google.com>
References: <20250320142022.766201-1-seanjc@google.com>
 <20250320142022.766201-4-seanjc@google.com>
 <Z9xXd5CoHh5Eo2TK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xXd5CoHh5Eo2TK@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 10:59:19AM -0700, Sean Christopherson wrote:
> On Thu, Mar 20, 2025, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f76d655dc9a8..e7eb2198db26 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -227,6 +227,10 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> >  bool __read_mostly enable_apicv = true;
> >  EXPORT_SYMBOL_GPL(enable_apicv);
> >  
> > +bool __read_mostly enable_device_posted_irqs = true;
> > +module_param(enable_device_posted_irqs, bool, 0444);
> > +EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
> > +
> >  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> >  	KVM_GENERIC_VM_STATS(),
> >  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
> > @@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  	if (r != 0)
> >  		goto out_mmu_exit;
> >  
> > +	enable_device_posted_irqs &= enable_apicv &&
> > +				     irq_remapping_cap(IRQ_POSTING_CAP);
> 
> Drat, this is flawed.  Putting the module param in kvm.ko means that loading
> kvm.ko with enable_device_posted_irqs=true, but a vendor module with APICv/AVIC
> disabled, leaves enable_device_posted_irqs disabled for the lifetime of kvm.ko.
> I.e. reloading the vendor module with APICv/AVIC enabled can't enable device
> posted IRQs.
> 
> Option #1 is to do what we do for enable_mmio_caching, and snapshot userspace's
> desire.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e7eb2198db26..c84ad9109108 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -228,6 +228,7 @@ bool __read_mostly enable_apicv = true;
>  EXPORT_SYMBOL_GPL(enable_apicv);
>  
>  bool __read_mostly enable_device_posted_irqs = true;
> +bool __ro_after_init allow_device_posted_irqs;
>  module_param(enable_device_posted_irqs, bool, 0444);
>  EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
>  
> @@ -9776,8 +9777,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>         if (r != 0)
>                 goto out_mmu_exit;
>  
> -       enable_device_posted_irqs &= enable_apicv &&
> -                                    irq_remapping_cap(IRQ_POSTING_CAP);
> +       enable_device_posted_irqs = allow_device_posted_irqs && enable_apicv &&
> +                                   irq_remapping_cap(IRQ_POSTING_CAP);
>  
>         kvm_ops_update(ops);
>  
> @@ -14033,6 +14034,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
>  
>  static int __init kvm_x86_init(void)
>  {
> +       allow_device_posted_irqs = enable_device_posted_irqs;
> +
>         kvm_init_xstate_sizes();
>  
>         kvm_mmu_x86_module_init();
> 
> 
> Option #2 is to shove the module param into vendor code, but leave the variable
> in kvm.ko, like we do for enable_apicv.
> 
> I'm leaning toward option #2, as it's more flexible, arguably more intuitive, and
> doesn't prevent putting the logic in kvm_x86_vendor_init().

+1, option #1 seems a bit confusing to me.

