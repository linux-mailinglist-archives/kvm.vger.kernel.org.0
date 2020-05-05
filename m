Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31B71C64A4
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgEEXyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 19:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgEEXyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 19:54:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED95DC061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 16:54:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id a4so289495pgc.0
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 16:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M5EBZjD1d0xdQx1wxu69jpqkN0p5PY4zPWFtfDNWO68=;
        b=tfTzNGZCpNGQGxDgIc0kaCCEc1ASP5wWDYnPpFKAoETEm0c/s7wkw/pQSxLYJigwQF
         vkt20kjVzJBgA+O49AOjWshQRSxzDlLMdw5VE62g6hnXV1n6bLcq7f59d9Y/WdH7X8gL
         ZCCXEVjob1Y/cEOdcHKXcOM+cfwuP0DOOB04wJKayBRiDYB7HqJeM4qmYZemKL39mwOK
         HV5LDhJrqJcd0gik/nECLYceL22Xkt22iy6ruwySdKHNTAzI+3Wzav3A3Wx7RxqCFWFI
         KCUh4mWw3TAVmyYgsQnRteY1l66swt8YCs795PRKdy6EF1C1cO/3cR6JDePWSKPXsm56
         jjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M5EBZjD1d0xdQx1wxu69jpqkN0p5PY4zPWFtfDNWO68=;
        b=qEvh6MR8ewpk8UmLk+eAejhycCCi/zmq3utP1lplQvesNDQNTVOkAZfOznEQjuEAW+
         Jv0qONMiFi5XTXok2cHa+9dym0feObCCMm/AEjUFzBp1r0HvWdZsTpBUv+s9Z6SSzQ02
         12J7UKz6nPWa9JyZoOuDlyfJWCp3nR8N0EK+lo6HjXVo9FRnx6kOKBDDjVLZNFFDK8bo
         GUT8xQUzDYXHMzx8xyvFYRBRk7H7cOUcWIwL3eN4cPIwfmxZM2hYAm+9faNSajI2UJc6
         UzAjO+cO0EG4eP8yNnZSiryOh2Lsfj8BW0U9F8Os2/IaHwaHV78UUgulJqIkDWN7WXzx
         tqYQ==
X-Gm-Message-State: AGi0Pub8xaJ6CWYl0BoM3lWHOqoK/Rb3myKzyldr7qmpgXgpIUPxUXYx
        ovLwUPl7Dn22PuL5h5RG0jgUGhzPsMw=
X-Google-Smtp-Source: APiQypKneCg3cMsULx9xVz9Bf+1vhFD9F5nJWslRXN+pQycLL7Uc/lWLSB4Tqdgny/dQFZkIXEf2CA==
X-Received: by 2002:a63:df54:: with SMTP id h20mr4819343pgj.169.1588722844846;
        Tue, 05 May 2020 16:54:04 -0700 (PDT)
Received: from google.com ([2620:0:1008:11:304b:ceac:77c4:3da4])
        by smtp.gmail.com with ESMTPSA id x12sm36694pfo.62.2020.05.05.16.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:54:04 -0700 (PDT)
Date:   Tue, 5 May 2020 16:53:59 -0700
From:   Forrest Yuan Yu <yuanyu@google.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, ningyang@google.com, alaingef@google.com
Subject: Re: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
Message-ID: <20200505235359.GD192370@google.com>
References: <20200501185147.208192-1-yuanyu@google.com>
 <20200501185147.208192-2-yuanyu@google.com>
 <20200501204552.GD4760@linux.intel.com>
 <49fea649-9376-f8f8-1718-72672926e1bf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49fea649-9376-f8f8-1718-72672926e1bf@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 02, 2020 at 04:05:06AM +0300, Liran Alon wrote:
> 
> On 01/05/2020 23:45, Sean Christopherson wrote:
> > On Fri, May 01, 2020 at 11:51:47AM -0700, Forrest Yuan Yu wrote:
> > > The purpose of this new hypercall is to exchange message between
> > > guest and hypervisor. For example, a guest may want to ask hypervisor
> > > to harden security by setting restricted access permission on guest
> > > SLAT entry. In this case, the guest can use this hypercall to send
> > > 
> > > a message to the hypervisor which will do its job and send back
> > > anything it wants the guest to know.
> > Hrm, so this reintroduces KVM_EXIT_HYPERCALL without justifying _why_ it
> > needs to be reintroduced.  I'm not familiar with the history, but the
> > comments in the documentation advise "use KVM_EXIT_IO or KVM_EXIT_MMIO".
> Both of these options have the disadvantage of requiring instruction
> emulation (Although a trivial one for PIO). Which enlarge host attack
> surface.
> I think this is one of the reasons why Hyper-V defined their PV devices
> (E.g. NetVSC/StorVSC) doorbell kick with hypercall instead of PIO/MMIO.
> (This is currently not much relevant as KVM's instruction emulator is not
> optional and is not even offloaded to host userspace. But relevant for the
> future...)

Good point. Again to me the simplicity of the hypercall interface really
makes it an ideal mechanism for message passing.

> > 
> > Off the top of my head, IO and/or MMIO has a few advantages:
> > 
> >    - Allows the guest kernel to delegate permissions to guest userspace,
> >      whereas KVM restrict hypercalls to CPL0.
> >    - Allows "pass-through", whereas VMCALL is unconditionally forwarded to
> >      L1.
> >    - Is vendor agnostic, e.g. VMX and SVM recognized different opcodes for
> >      VMCALL vs VMMCALL.
> I agree with all the above (I believe similar rational had led VMware to
> design their Backdoor PIO interface).
> 
> Also note that recently AWS introduced Nitro Enclave PV device which is also
> de-facto a PV control-plane interface between guest and host userspace.
> Why similar approach couldn't have been used here?
> (Capability is exposed on a per-VM basis by attaching PV device to VM,
> communication interface is device specific and no KVM changes, only host
> userspace changes).
> > > Signed-off-by: Forrest Yuan Yu <yuanyu@google.com>
> > > ---
> > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > index 01b081f6e7ea..ff313f6827bf 100644
> > > --- a/Documentation/virt/kvm/cpuid.rst
> > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > @@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
> > >                                                 before using paravirtualized
> > >                                                 sched yield.
> > > +KVM_FEATURE_UCALL                 14          guest checks this feature bit
> > > +                                              before calling hypercall ucall.
> > Why make the UCALL a KVM CPUID feature?  I can understand wanting to query
> > KVM support from host userspace, but presumably the guest will care about
> > capabiliteis built on top of the UCALL, not the UCALL itself.
> I agree with this.
> In case of PV device approach, device detection by guest will be the
> capability discovery.
> > 
> > > +
> > >   KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > >                                                 per-cpu warps are expeced in
> > >                                                 kvmclock
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index c5835f9cb9ad..388a4f89464d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >   	case KVM_CAP_GET_MSR_FEATURES:
> > >   	case KVM_CAP_MSR_PLATFORM_INFO:
> > >   	case KVM_CAP_EXCEPTION_PAYLOAD:
> > > +	case KVM_CAP_UCALL:
> > For whatever reason I have a metnal block with UCALL, can we call this
> > KVM_CAP_USERSPACE_HYPERCALL
> +1
> > 
> > >   		r = 1;
> > >   		break;
> > >   	case KVM_CAP_SYNC_REGS:
> > > @@ -4895,6 +4896,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >   		kvm->arch.exception_payload_enabled = cap->args[0];
> > >   		r = 0;
> > >   		break;
> > > +	case KVM_CAP_UCALL:
> > > +		kvm->arch.hypercall_ucall_enabled = cap->args[0];
> > > +		r = 0;
> > > +		break;
> > >   	default:
> > >   		r = -EINVAL;
> > >   		break;
> > > @@ -7554,6 +7559,19 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> > >   		kvm_vcpu_yield_to(target);
> > >   }
> > > +static int complete_hypercall(struct kvm_vcpu *vcpu)
> > > +{
> > > +	u64 ret = vcpu->run->hypercall.ret;
> > > +
> > > +	if (!is_64_bit_mode(vcpu))
> > Do we really anticipate adding support in 32-bit guests?  Honest question.
> > 
> > > +		ret = (u32)ret;
> > > +	kvm_rax_write(vcpu, ret);
> > > +
> > > +	++vcpu->stat.hypercalls;
> > > +
> > > +	return kvm_skip_emulated_instruction(vcpu);
> > > +}
> > > +
> > >   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >   {
> > >   	unsigned long nr, a0, a1, a2, a3, ret;
> > > @@ -7605,17 +7623,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >   		kvm_sched_yield(vcpu->kvm, a0);
> > >   		ret = 0;
> > >   		break;
> > > +	case KVM_HC_UCALL:
> > > +		if (vcpu->kvm->arch.hypercall_ucall_enabled) {
> > > +			vcpu->run->hypercall.nr = nr;
> > > +			vcpu->run->hypercall.args[0] = a0;
> > > +			vcpu->run->hypercall.args[1] = a1;
> > > +			vcpu->run->hypercall.args[2] = a2;
> > > +			vcpu->run->hypercall.args[3] = a3;
> > If performance is a justification for a more direct userspace exit, why
> > limit it to just four parameters?  E.g. why not copy all registers to
> > kvm_sync_regs and reverse the process on the way back in?
> I don't think performance should be relevant for a hypercall interface. It's
> control-plane path.
> If a fast-path is required, guest should use this interface to coordinate a
> separate fast-path (e.g. via ring-buffer on some guest memory page).
> 
> Anyway, these kind of questions is another reason why I agree with Sean it
> seems using a PV device is preferred.

I agree. Performance is not an issue here. However, I also don't think
this would make a PV device very suitable for a task like message
passing. When I try to imagine using a device to pass several bytes of
messages, it doesn't feel right ...

> Instead of forcing a general userspace hypercall interface standard, one
> could just implement whatever PV device it wants in host userspace which is
> device specific.
> 
> In QEMU's VMPort implementation BTW, userspace calls cpu_synchronize_state()
> which de-facto syncs tons of vCPU state from KVM to userspace. Not just the
> GP registers.
> Because it's a slow-path, it's considered fine. :P
> 
> -Liran
> 
> > 
> > > +			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> > > +			vcpu->arch.complete_userspace_io = complete_hypercall;
> > > +			return 0; // message is going to userspace
> > > +		}
> > > +		ret = -KVM_ENOSYS;
> > > +		break;
> > >   	default:
> > >   		ret = -KVM_ENOSYS;
> > >   		break;
> > >   	}
> > >   out:
> > > -	if (!op_64_bit)
> > > -		ret = (u32)ret;
> > > -	kvm_rax_write(vcpu, ret);
> > > -
> > > -	++vcpu->stat.hypercalls;
> > > -	return kvm_skip_emulated_instruction(vcpu);
> > > +	vcpu->run->hypercall.ret = ret;
> > > +	return complete_hypercall(vcpu);
> > >   }
> > >   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
