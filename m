Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3480E1C6429
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 00:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEEWuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 18:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEEWuo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 18:50:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066A6C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 15:50:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so3708pfc.12
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 15:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+/snCucJYmXVL3VfK5/0iPYTFLegLBtAM5Ty8Sf5ask=;
        b=VcEi8NcxFNwjBWDj2dLrM79vjG9QfCzrkcOQncGzWuaSPSTxHLahKtlCxtVmahLCtT
         aZiVeYbwvmBTOe0qPUDrhYUqqARNkQZG+RQix9Tzjn0lBC+xiq2bK+tUJqy+CQvY977D
         3oLi481+zfmfiU7Lbapq0agP0HjD7ghTCb7j+8jnevSnyxI8ism/C49Nf+Y2Ckeb5LlH
         WfwxC/AW+FPeK/IPJhpXw6nhijrbNUhBInqzA6CMiRooQPsl8JpZNhxZ45fmE0Pf7eyQ
         XhAlu51ozlgAxiUC7wXFpuIBYerTL9QzHDoAjTYzdbUEiDjrOXJddO10jQ3I2KrrSnRA
         nYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+/snCucJYmXVL3VfK5/0iPYTFLegLBtAM5Ty8Sf5ask=;
        b=sdvsMgoZzMBZw6sDEDH8OsIJW5n030BA0jAZ68goW0CR0VKQ7M39cYIUeSpRsu3t9s
         GeI1kGMCiB/QA+qltiVn8hXVRa81xomIi8wvFZ7zE+BktNLidOpIZcMrSYobIWlPV4o7
         S4MopvDNCZC9tTTfJjJnNDDhmDcYPUvXTmbXAWUtyktHrWv4zoxZmT7qCIVImT9sG9yR
         S0MCN6ktXji8/w0+NLb8Rugj/yitUkORypTNUk4B4KNm+rG/+LG+r6idmQ5dcc7irciV
         0pQzMBcMdMU2OOTj6J90GoBeFV4PH8igwlKSAUpi8hf2nwRGea5tBmFNRai6ANcC1c+0
         3aGw==
X-Gm-Message-State: AGi0Pub1f6/ESJJTpdWrt7oie3GELb+ZemXXA+7L5FO2MuDNVnAOIYG0
        N76tQI1UMzGEN8Qn27KVj+iAwQ==
X-Google-Smtp-Source: APiQypIANoA+BHt51IyzJhaxcN/lxc/pwYJsdliLzwUX+3STkyVrKH960UHFmSjTDO0aipkre79WLg==
X-Received: by 2002:aa7:9891:: with SMTP id r17mr5265176pfl.5.1588719042908;
        Tue, 05 May 2020 15:50:42 -0700 (PDT)
Received: from google.com ([2620:0:1008:11:304b:ceac:77c4:3da4])
        by smtp.gmail.com with ESMTPSA id t23sm2962204pji.32.2020.05.05.15.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 15:50:42 -0700 (PDT)
Date:   Tue, 5 May 2020 15:50:37 -0700
From:   Forrest Yuan Yu <yuanyu@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, alaingef@google.com, ningyang@google.com
Subject: Re: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
Message-ID: <20200505225037.GC192370@google.com>
References: <20200501185147.208192-1-yuanyu@google.com>
 <20200501185147.208192-2-yuanyu@google.com>
 <20200501204552.GD4760@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501204552.GD4760@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 01:45:52PM -0700, Sean Christopherson wrote:
> On Fri, May 01, 2020 at 11:51:47AM -0700, Forrest Yuan Yu wrote:
> > The purpose of this new hypercall is to exchange message between
> > guest and hypervisor. For example, a guest may want to ask hypervisor
> > to harden security by setting restricted access permission on guest
> > SLAT entry. In this case, the guest can use this hypercall to send
> 
> Please do s/SLAT/TDP everywhere.  IMO, TDP is a less than stellar acronym,
> e.g. what will we do if we go to three dimensions!?!?  But, we're stuck
> with it :-)

Will do.

> 
> > a message to the hypervisor which will do its job and send back
> > anything it wants the guest to know.
> 
> Hrm, so this reintroduces KVM_EXIT_HYPERCALL without justifying _why_ it
> needs to be reintroduced.  I'm not familiar with the history, but the
> comments in the documentation advise "use KVM_EXIT_IO or KVM_EXIT_MMIO".
> 
> Off the top of my head, IO and/or MMIO has a few advantages:
> 
>   - Allows the guest kernel to delegate permissions to guest userspace,
>     whereas KVM restrict hypercalls to CPL0.
>   - Allows "pass-through", whereas VMCALL is unconditionally forwarded to
>     L1.
>   - Is vendor agnostic, e.g. VMX and SVM recognized different opcodes for
>     VMCALL vs VMMCALL.

Yes I'm aware of the document advice but still feel hypercall is the
right thing to do. First of all, hypercalls, by definition, exist for
exactly these kind of jobs. When a guest wants to talk to the
hypervisor, it makes a hypercall. It just feels natural.

Of course IO/MMIO can do the same thing, but for simple jobs like asking
hypervisor to set restricted access permission, IO/MMIO feels heavy (and
IMHO feels a little hacky).

Also I'm not reintroducing KVM_EXIT_HYPERCALL the same way as before, in
that we don't pass all unkown hypercalls to userspace. Instead, we just
pass one specific call to userspace, one that userspace has opted into.

When userspace does nothing -- not opting in -- the behavior is the same
as the current code base.

There are many ways to allow certain hypercalls to be delegated from the
guest kernel to guest userspace, and we would probably want a mechanism
that allows finer control than I/O permission bitmaps (for PIO) or
mapping MMIO regions as writable in a userspace context. Something like
this is not tied to a particular communication channel.

Regarding the nested scenario, I would argue there should not be a
hypercall interface from a guest to any hypervisor other than its
immediate parent.

VMCALL and VMMCALL having different opcodes shouldn't be a problem since
kvm already supports hypercalls using these opcodes.

>  
> > Signed-off-by: Forrest Yuan Yu <yuanyu@google.com>
> > ---
> > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > index 01b081f6e7ea..ff313f6827bf 100644
> > --- a/Documentation/virt/kvm/cpuid.rst
> > +++ b/Documentation/virt/kvm/cpuid.rst
> > @@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
> >                                                before using paravirtualized
> >                                                sched yield.
> >  
> > +KVM_FEATURE_UCALL                 14          guest checks this feature bit
> > +                                              before calling hypercall ucall.
> 
> Why make the UCALL a KVM CPUID feature?  I can understand wanting to query
> KVM support from host userspace, but presumably the guest will care about
> capabiliteis built on top of the UCALL, not the UCALL itself.

This is to keep the behavior the same when UCALL is not recognized by
the current userspaces which are not aware of this hypercall. Without
this, userspace may break if a guest invokes UCALL.

> 
> > +
> >  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
> >                                                per-cpu warps are expeced in
> >                                                kvmclock
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c5835f9cb9ad..388a4f89464d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_GET_MSR_FEATURES:
> >  	case KVM_CAP_MSR_PLATFORM_INFO:
> >  	case KVM_CAP_EXCEPTION_PAYLOAD:
> > +	case KVM_CAP_UCALL:
> 
> For whatever reason I have a metnal block with UCALL, can we call this
> KVM_CAP_USERSPACE_HYPERCALL

I was trying to follow the convention. The name UCALL was used in places
like tools/testing/selftests/kvm/include/kvm_util.h for similar
purposes. I can rename it for better readability.

> 
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_SYNC_REGS:
> > @@ -4895,6 +4896,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		kvm->arch.exception_payload_enabled = cap->args[0];
> >  		r = 0;
> >  		break;
> > +	case KVM_CAP_UCALL:
> > +		kvm->arch.hypercall_ucall_enabled = cap->args[0];
> > +		r = 0;
> > +		break;
> >  	default:
> >  		r = -EINVAL;
> >  		break;
> > @@ -7554,6 +7559,19 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> >  		kvm_vcpu_yield_to(target);
> >  }
> >  
> > +static int complete_hypercall(struct kvm_vcpu *vcpu)
> > +{
> > +	u64 ret = vcpu->run->hypercall.ret;
> > +
> > +	if (!is_64_bit_mode(vcpu))
> 
> Do we really anticipate adding support in 32-bit guests?  Honest question.

Oh I was trying to keep the behavior exactly the same. It was there
under kvm_emulate_hypercall() so I pasted this block here.

> 
> > +		ret = (u32)ret;
> > +	kvm_rax_write(vcpu, ret);
> > +
> > +	++vcpu->stat.hypercalls;
> > +
> > +	return kvm_skip_emulated_instruction(vcpu);
> > +}
> > +
> >  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long nr, a0, a1, a2, a3, ret;
> > @@ -7605,17 +7623,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_UCALL:
> > +		if (vcpu->kvm->arch.hypercall_ucall_enabled) {
> > +			vcpu->run->hypercall.nr = nr;
> > +			vcpu->run->hypercall.args[0] = a0;
> > +			vcpu->run->hypercall.args[1] = a1;
> > +			vcpu->run->hypercall.args[2] = a2;
> > +			vcpu->run->hypercall.args[3] = a3;
> 
> If performance is a justification for a more direct userspace exit, why
> limit it to just four parameters?  E.g. why not copy all registers to
> kvm_sync_regs and reverse the process on the way back in?
> 
> > +			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> > +			vcpu->arch.complete_userspace_io = complete_hypercall;
> > +			return 0; // message is going to userspace
> > +		}
> > +		ret = -KVM_ENOSYS;
> > +		break;
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
> >  	}
> >  out:
> > -	if (!op_64_bit)
> > -		ret = (u32)ret;
> > -	kvm_rax_write(vcpu, ret);
> > -
> > -	++vcpu->stat.hypercalls;
> > -	return kvm_skip_emulated_instruction(vcpu);
> > +	vcpu->run->hypercall.ret = ret;
> > +	return complete_hypercall(vcpu);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
