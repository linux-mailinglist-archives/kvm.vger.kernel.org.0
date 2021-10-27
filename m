Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE0E43CBD8
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242462AbhJ0OVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:21:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242460AbhJ0OVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635344327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBSPA7SFj6S0l15DFmmTz29aiCenNhw8/4n7QaHyqGY=;
        b=FoIwbpjEU9RDfcqDKaMrOAvPF0B7uHviFTjjzq6XLjGqMlzlG6S2XkgGzHttlMMOkwCMFT
        +N/KTwLBwLV0VUuWS1iT8jpexuTudW/nZt2LJ/eas09etldymeHHotH1vEGFwb6VZdDsHS
        h8xqrpttIkMnbNRTdO15ALhFMd6zQ5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-EGGnys3PO8eSwUAtseuBvQ-1; Wed, 27 Oct 2021 10:18:44 -0400
X-MC-Unique: EGGnys3PO8eSwUAtseuBvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46F7487320A;
        Wed, 27 Oct 2021 14:18:40 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 714835C1B4;
        Wed, 27 Oct 2021 14:18:31 +0000 (UTC)
Message-ID: <e04b75455437da29fb009668e60b5be1732a183b.camel@redhat.com>
Subject: Re: [PATCH v2 12/43] KVM: x86: Tweak halt emulation helper names to
 free up kvm_vcpu_halt()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Wed, 27 Oct 2021 17:18:30 +0300
In-Reply-To: <363479dd55760979da208cacf015a6f7fe2afd69.camel@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-13-seanjc@google.com>
         <363479dd55760979da208cacf015a6f7fe2afd69.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-27 at 17:10 +0300, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Rename a variety of HLT-related helpers to free up the function name
> > "kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
> > between "block" and "halt".
> > 
> > No functional change intended.
> > 
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/vmx/nested.c       |  2 +-
> >  arch/x86/kvm/vmx/vmx.c          |  4 ++--
> >  arch/x86/kvm/x86.c              | 13 +++++++------
> >  4 files changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 7aafc27ce7a9..328103a520d3 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1689,7 +1689,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
> >  int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
> >  int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
> >  int kvm_emulate_halt(struct kvm_vcpu *vcpu);
> > -int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> > +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
> >  int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
> >  int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
> >  
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index af1bbb73430a..d0237a441feb 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3619,7 +3619,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >  		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
> >  		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
> >  			vmx->nested.nested_run_pending = 0;
> > -			return kvm_vcpu_halt(vcpu);
> > +			return kvm_emulate_halt_noskip(vcpu);
> >  		}
> >  		break;
> >  	case GUEST_ACTIVITY_WAIT_SIPI:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 1c8b2b6e7ed9..5517893f12fc 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4741,7 +4741,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
> >  		if (kvm_emulate_instruction(vcpu, 0)) {
> >  			if (vcpu->arch.halt_request) {
> >  				vcpu->arch.halt_request = 0;
> > -				return kvm_vcpu_halt(vcpu);
> > +				return kvm_emulate_halt_noskip(vcpu);
> 
> Could you elaborate on why you choose _noskip suffix? 
>  
> As far as I see, kvm_vcpu_halt just calls __kvm_vcpu_halt with new VCPU run state/exit reason,
> which is used only when local apic is not in the kernel (which is these days not that
> supported configuration).
> 
> Other user of __kvm_vcpu_halt is something SEV related.
>  
> Best regards,
> 	Maxim Levitsky
> 
> 
> >  			}
> >  			return 1;
> >  		}
> > @@ -5415,7 +5415,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> >  
> >  		if (vcpu->arch.halt_request) {
> >  			vcpu->arch.halt_request = 0;
> > -			return kvm_vcpu_halt(vcpu);
> > +			return kvm_emulate_halt_noskip(vcpu);
> >  		}
> >  
> >  		/*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4a52a08707de..9c23ae1d483d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8649,7 +8649,7 @@ void kvm_arch_exit(void)
> >  #endif
> >  }
> >  
> > -static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> > +static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
> >  {
> >  	++vcpu->stat.halt_exits;
> >  	if (lapic_in_kernel(vcpu)) {
> > @@ -8661,11 +8661,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> >  	}
> >  }
> >  
> > -int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> > +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
> >  {
> > -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
> > +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
> > +EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
> >  
> >  int kvm_emulate_halt(struct kvm_vcpu *vcpu)
> >  {
> > @@ -8674,7 +8674,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
> >  	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
> >  	 * KVM_EXIT_DEBUG here.
> >  	 */
> > -	return kvm_vcpu_halt(vcpu) && ret;
> > +	return kvm_emulate_halt_noskip(vcpu) && ret;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_halt);
> >  
> > @@ -8682,7 +8682,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
> >  {
> >  	int ret = kvm_skip_emulated_instruction(vcpu);
> >  
> > -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
> > +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
> > +					KVM_EXIT_AP_RESET_HOLD) && ret;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
> >  

Also while at it, why not to use say '__kvm_emulate_hlt' ('hlt' instead of 'halt') to 
put emphasis on the fact that we are emulating a cpu instruction?

Best regards,
	Maxim Levitsky
 

