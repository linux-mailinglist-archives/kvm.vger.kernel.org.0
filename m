Return-Path: <kvm+bounces-64268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36522C7BEC9
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 00:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 259084E15AE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF8C30C36F;
	Fri, 21 Nov 2025 23:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jlqulff8"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454242D3221
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 23:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763766766; cv=none; b=o9z0u9gEFr91eMA5RjpRdFKJbn9SBH3vX/mbj8Ayq6NX2LRyTxc4RcEy5DESsRop8X+hXrfSikW6QP3W5fFWpKMrkImuCakXEmUocf7wbQPXqJZm45TpebqE78rYUb/pUeaMIjIxm5AcmeuEeaRgIgF6JIQyHFDmmaDLfxHhuR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763766766; c=relaxed/simple;
	bh=Fpiw+0aa7nnhMcUOSMMWuEu/qTPVm8EKlePwrXOwE+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j08NfAoMmis9VnrzVcZ6rI4mXgvY3Tc4wHLPdksw93RLuA8Mfcw7E9HdsOHK/nFs6nWFXbWS4HO+RLATlyDoWRPKAhrqwJG2cyvDrckaKhaOh1r1N6konxHo63SYY52ESTUfrpVdTjitW1I7PxgfYPsdjrgeBulFcQlER5xbko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jlqulff8; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Nov 2025 23:12:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763766756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ySlAh1e2Q0K9i9Vx4U1YzJIhRkLozCNytX/mQJxVVc=;
	b=Jlqulff8GkacRcPh/hbCIkwZTXutIxzQbfmi+8U43Ddduc7cVeRxmOcp2rFyltABpdedRZ
	b2/mDtMcR8F1q7lPTImw0eg6WdQSBO/jmuGzo6unysTEpxfnzYONnUQNDbyonbQjAYrE43
	hRfSIpkJaU1iX/APghPaBARtWUEgmUs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ken Hofsass <hofsass@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Add CR3 to guest debug info
Message-ID: <ycaddg27z4z6xsclzklheriy2cr63v6senv7qxh37kvpb7envs@br7durjgj2ux>
References: <20251121193204.952988-1-yosry.ahmed@linux.dev>
 <20251121193204.952988-2-yosry.ahmed@linux.dev>
 <aSDTNDUPyu6LwvhW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSDTNDUPyu6LwvhW@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 21, 2025 at 01:01:40PM -0800, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > Add the value of CR3 to the information returned to userspace on
> > KVM_EXIT_DEBUG. Use KVM_CAP_X86_GUEST_DEBUG_CR3 to advertise this.
> > 
> > During guest debugging, the value of CR3 can be used by VM debuggers to
> > (roughly) identify the process running in the guest. This can be used to
> > index debugging events by process, or filter events from some processes
> > and quickly skip them.
> > 
> > Currently, debuggers would need to use the KVM_GET_SREGS ioctl on every
> > event to get the value of CR3, which considerably slows things down.
> > This can be easily avoided by adding the value of CR3 to the captured
> > debugging info.
> > 
> > Signed-off-by: Ken Hofsass <hofsass@google.com>
> > Co-developed-by: Ken Hofsass <hofsass@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 1 +
> >  arch/x86/kvm/svm/svm.c          | 2 ++
> >  arch/x86/kvm/vmx/vmx.c          | 2 ++
> >  arch/x86/kvm/x86.c              | 3 +++
> >  include/uapi/linux/kvm.h        | 1 +
> >  5 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 7ceff6583652..c351e458189b 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -293,6 +293,7 @@ struct kvm_debug_exit_arch {
> >  	__u64 pc;
> >  	__u64 dr6;
> >  	__u64 dr7;
> > +	__u64 cr3;
> >  };
> 
> I really, really don't like this.  It "solves" a very specific problem for a very
> specific use case without any consideration for uAPI, precedence or maintenance.
> E.g. in most cases, CR3 without CR0, CR4, EFER, etc. is largely meaningless.  The
> only thing it's really useful for is an opaque guest process identifer.

To be fair, I never advertised it to be anything more than that :P

> 
> KVM already provides kvm_run.kvm_valid_regs to let userspace grab register state
> on exit to userspace.  If userspace is debugging, why not simply save all regs on
> exit?
> 
> If the answer is "because it slows down all other exits", then I would much rather
> give userspace the ability to conditionally save registers based on the exit reason,
> e.g. something like this (completely untested, no CAP, etc.)

I like this approach conceptually, but I think it's an overkill for this
use case tbh. Especially the memory usage, that's 1K per vCPU for the
bitmap. I know it can be smaller, but probably not small either because
it will be a problem if we run out of bits.

I think it may be sufficient for now to add something
KVM_SYNC_REGS_DEBUG to sync registers on KVM_EXIT_DEBUG. Not very
generic, but I don't think a lot exit reasons will make use of this.

That being said, let me take a closer look at our VMM and see what
options could work for us before spending more time on this. We
currently use CR3 as implemented in this patch, so this would have been
a drop-in replacement. For anything else I need to make sure our VMM
will be able to use it first.

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c6d899d53dd..337043d49ee6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -127,7 +127,7 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu);
>  static void process_nmi(struct kvm_vcpu *vcpu);
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> -static void store_regs(struct kvm_vcpu *vcpu);
> +static void kvm_run_save_regs_on_exit(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
>  static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
>  
> @@ -10487,6 +10487,8 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_run *kvm_run = vcpu->run;
>  
> +       kvm_run_save_regs_on_exit(vcpu);
> +
>         kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
>         kvm_run->cr8 = kvm_get_cr8(vcpu);
>         kvm_run->apic_base = vcpu->arch.apic_base;
> @@ -11978,8 +11980,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  out:
>         kvm_put_guest_fpu(vcpu);
> -       if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
> -               store_regs(vcpu);
>         post_kvm_run_save(vcpu);
>         kvm_vcpu_srcu_read_unlock(vcpu);
>  
> @@ -12598,10 +12598,30 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>         return 0;
>  }
>  
> -static void store_regs(struct kvm_vcpu *vcpu)
> +static void kvm_run_save_regs_on_exit(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_run *run = vcpu->run;
> +       u32 nr_exit_reasons = sizeof(run->kvm_save_regs_on_exit) * BITS_PER_BYTE;
> +       u64 valid_regs = READ_ONCE(run->kvm_valid_regs);
> +       u32 exit_reason = READ_ONCE(run->exit_reason);
> +
>         BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
>  
> +       if (!valid_regs)
> +               return;
> +
> +       if (unlikely(!vcpu->arch.guest_state_protected))
> +               return;
> +
> +       if (valid_regs & KVM_SYNC_REGS_CONDITIONAL) {
> +               if (exit_reason >= nr_exit_reasons)
> +                       return;
> +
> +               exit_reason = array_index_nospec(exit_reason, nr_exit_reasons);
> +               if (!test_bit(exit_reason, (void *)run->kvm_save_regs_on_exit))
> +                       return;
> +       }
> +
>         if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_REGS)
>                 __get_regs(vcpu, &vcpu->run->s.regs.regs);
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab020..452805c1337b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -494,8 +494,12 @@ struct kvm_run {
>                 struct kvm_sync_regs regs;
>                 char padding[SYNC_REGS_SIZE_BYTES];
>         } s;
> +
> +       __u64 kvm_save_regs_on_exit[16];
>  };
>  
> +#define KVM_SYNC_REGS_CONDITIONAL      _BITULL(63)
> +
>  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
>  
>  struct kvm_coalesced_mmio_zone {

