Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDCCB12C8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfILQ3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:29:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35691 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730233AbfILQ3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:29:04 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so55500774ion.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/bUM2dznk3XwWgKl0HE7RE3gTJxY3w5pUDNSto2T69A=;
        b=PzPlon00TN4IAlMrf/8lncLToLzYqJ6JwX3+81T/8d4Vk0jMztmj3LWhYFyept2EdF
         oa+M2QMNUuFwCCtDu3S45XuEoAVDx1OeY77pUE8lCiPeMO4YtMPcI3tN2VMvuT23z1dG
         2RbDKPL36z1+Q2ACQphSUWToSAAK02M7RmIwHIrcOPoSJiVkGzQniUUAdA8LnJ0l+H4t
         QMhMqF5YJwf44lXOs3+HoYIZ2EocIvEmQVyMxAFlI+Z+WtCTfogbgzT4KoKJg9Mgrs8n
         abynkkw2vkrpmx1cTDJTAst9QvkCsfPPqR1g3EDWWrUL8ixkGjxtso6hsZlXAG0ysqDT
         5eyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/bUM2dznk3XwWgKl0HE7RE3gTJxY3w5pUDNSto2T69A=;
        b=D4iNgFfUyXTEZNn/PVAti8UT6rtNjL5r9fcODaVUhuLXZmrTugdXD65kH5zAzBm/if
         hWojDb2vUBIXPAZgWil6bnOw9UnaDuGd/iAFgOa6xeBfUz4cmsFljSi2TxHaFnIjjrcw
         Dp+kUq+vGanIwl+xrkDgDB8w6sRkh5g3ICkLmIbBOILQQLLwU9LZLycxQDyRdgZdO5Sc
         w9RUpKWxZffT81kbZtEl07ZBiKO1GCnnsuS241gR+a1s5HsbZBX83/0jVhrfEQ22/Ky8
         GW11L8cZA1gxGSEW+NYow5wg/oQ8xhlCw6WmiFWHmIVB3nQm+fUj9Wkq0ekfw6/3lmL2
         hKNA==
X-Gm-Message-State: APjAAAWJm6fXqPhuhH7Mh17fzmY6s7WJ4pQHvu3pRr9wlNvUKvdn2r4T
        Mxxq1+JKs6j/uRQz7h7CJvXGEdGoBWAebIweDLnS2Q==
X-Google-Smtp-Source: APXvYqyyriBHQj7Wx4nFxArqtGOZtLxRDDbpeaOq6GK1TeKXXD+ixW2nNj3gKjd0hzVkqplCOjUfANLbqIG6lLRofnQ=
X-Received: by 2002:a02:3b21:: with SMTP id c33mr45717550jaa.54.1568305742046;
 Thu, 12 Sep 2019 09:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190909222812.232690-1-jmattson@google.com> <20190909222812.232690-2-jmattson@google.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D571502@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D571502@SHSMSX104.ccr.corp.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Sep 2019 09:28:50 -0700
Message-ID: <CALMp9eRHpyGz=o6K66UZLnGVmJDZKY5HRb0X4Srq9CmVxzRfZA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 1/1] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dan Cross <dcross@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 12:48 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Jim Mattson
> > Sent: Tuesday, September 10, 2019 6:28 AM
> >
> > If the "virtualize APIC accesses" VM-execution control is set in the
> > VMCS, the APIC virtualization hardware is triggered when a page walk
> > in VMX non-root mode terminates at a PTE wherein the address of the 4k
> > page frame matches the APIC-access address specified in the VMCS. On
> > hardware, the APIC-access address may be any valid 4k-aligned physical
> > address.
> >
> > KVM's nVMX implementation enforces the additional constraint that the
> > APIC-access address specified in the vmcs12 must be backed by
> > cacheable memory in L1. If not, L0 will simply clear the "virtualize
> > APIC accesses" VM-execution control in the vmcs02.
> >
> > The problem with this approach is that the L1 guest has arranged the
> > vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> > VM-execution control is clear in the vmcs12--so that the L2 guest
> > physical address(es)--or L2 guest linear address(es)--that reference
> > the L2 APIC map to the APIC-access address specified in the
> > vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> > the vmcs02, the APIC accesses in the L2 guest will directly access the
> > APIC-access page in L1.
> >
> > When L0 has no mapping whatsoever for the APIC-access address in L1,
> > the L2 VM just loses the intended APIC virtualization. However, when
> > the L2 APIC-access address is mapped to an MMIO region in L1, the L2
> > guest gets direct access to the L1 MMIO device. For example, if the
> > APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> > gets direct access to L1's APIC.
>
> 'direct access to L1 APIC' is conceptually correct but won't happen
> in current KVM design. Above either leads to direct access to L0's
> APIC-access page (if L0 VMM enables "virtualized APIC accesses"
> and maps L1 0xfee00000 to L0 APIC-access page), which doesn't
> really hold L1's APIC state, or cause nested EPT violation fault into
> L1 VMM (if L0 VMM disables "virtualized APIC accesses", thus L1
> 0xfee00000 has no valid mapping in L0 EPT). Of course either way
> is still broken. The former cannot properly virtualize the L2 APIC,
> while the latter may confuse the L1 VMM if only APIC-access
> VM exit is expected. But there is not direct L2 access to L1's APIC
> state anyway. :-)
>
> >
> > Fixing this correctly is complicated. Since this vmcs12 configuration
> > is something that KVM cannot faithfully emulate, the appropriate
>
> Why cannot it be faithfully emulated? At least your comments in
> below code already represents a feasible option. Although, yes, it
> is possibly complicated...

Right. It can be done. It just can't be done with KVM as it is today.
It's a lot harder than just moving the APIC base address, for
instance, and KVM punts on even that simple operation, because the KVM
MMU isn't designed to handle the case where pieces of the extended
page tables can't be shared among all vCPUs in a VM.

> > response is to exit to userspace with
> > KVM_INTERNAL_ERROR_EMULATION. Sadly, the kvm-unit-tests fail, so I'm
> > posting this as an RFC.
> >
> > Note that the 'Code' line emitted by qemu in response to this error
> > shows the guest %rip two instructions after the
> > vmlaunch/vmresume. Hmmm.
> >
> > Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and
> > vmcs12")
> > Reported-by: Dan Cross <dcross@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Dan Cross <dcross@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/vmx/nested.c       | 65 +++++++++++++++++++++------------
> >  arch/x86/kvm/x86.c              |  9 ++++-
> >  3 files changed, 49 insertions(+), 27 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h
> > index 74e88e5edd9cf..e95acf8c82b47 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1191,7 +1191,7 @@ struct kvm_x86_ops {
> >       int (*set_nested_state)(struct kvm_vcpu *vcpu,
> >                               struct kvm_nested_state __user
> > *user_kvm_nested_state,
> >                               struct kvm_nested_state *kvm_state);
> > -     void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> > +     int (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> >
> >       int (*smi_allowed)(struct kvm_vcpu *vcpu);
> >       int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index ced9fba32598d..04b5069d4a9b3 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2871,7 +2871,7 @@ static int nested_vmx_check_vmentry_hw(struct
> > kvm_vcpu *vcpu)
> >  static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu
> > *vcpu,
> >                                                struct vmcs12 *vmcs12);
> >
> > -static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > +static int nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >  {
> >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -2891,19 +2891,33 @@ static void nested_get_vmcs12_pages(struct
> > kvm_vcpu *vcpu)
> >                       vmx->nested.apic_access_page = NULL;
> >               }
> >               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12-
> > >apic_access_addr);
> > -             /*
> > -              * If translation failed, no matter: This feature asks
> > -              * to exit when accessing the given address, and if it
> > -              * can never be accessed, this feature won't do
> > -              * anything anyway.
> > -              */
> > -             if (!is_error_page(page)) {
> > +             if (likely(!is_error_page(page))) {
> >                       vmx->nested.apic_access_page = page;
> >                       hpa = page_to_phys(vmx-
> > >nested.apic_access_page);
> >                       vmcs_write64(APIC_ACCESS_ADDR, hpa);
> >               } else {
> > -                     secondary_exec_controls_clearbit(vmx,
> > -
> >       SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> > +                     /*
> > +                      * Since there is no backing page, we can't
> > +                      * just rely on the usual L1 GPA -> HPA
> > +                      * translation mechanism to do the right
> > +                      * thing. We'd have to assign an appropriate
> > +                      * HPA for the L1 APIC-access address, and
> > +                      * then we'd have to modify the MMU to ensure
> > +                      * that the L1 APIC-access address is mapped
> > +                      * to the assigned HPA if and only if an L2 VM
> > +                      * with that APIC-access address and the
> > +                      * "virtualize APIC accesses" VM-execution
> > +                      * control set in the vmcs12 is running. For
> > +                      * now, just admit defeat.
> > +                      */
> > +                     pr_warn_ratelimited("Unsupported vmcs12 APIC-
> > access address 0x%llx\n",
> > +                             vmcs12->apic_access_addr);
> > +                     vcpu->run->exit_reason =
> > KVM_EXIT_INTERNAL_ERROR;
> > +                     vcpu->run->internal.suberror =
> > +                             KVM_INTERNAL_ERROR_EMULATION;
> > +                     vcpu->run->internal.ndata = 1;
> > +                     vcpu->run->internal.data[0] = vmcs12-
> > >apic_access_addr;
> > +                     return -EINTR;
>
> What about always using L0 APIC-access address in vmcs02 and mapping
>
>
> >               }
> >       }
> >
> > @@ -2948,6 +2962,7 @@ static void nested_get_vmcs12_pages(struct
> > kvm_vcpu *vcpu)
> >               exec_controls_setbit(vmx,
> > CPU_BASED_USE_MSR_BITMAPS);
> >       else
> >               exec_controls_clearbit(vmx,
> > CPU_BASED_USE_MSR_BITMAPS);
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -2986,11 +3001,11 @@ static void load_vmcs12_host_state(struct
> > kvm_vcpu *vcpu,
> >  /*
> >   * If from_vmentry is false, this is being called from state restore (either
> > RSM
> >   * or KVM_SET_NESTED_STATE).  Otherwise it's called from
> > vmlaunch/vmresume.
> > -+ *
> > -+ * Returns:
> > -+ *   0 - success, i.e. proceed with actual VMEnter
> > -+ *   1 - consistency check VMExit
> > -+ *  -1 - consistency check VMFail
> > + *
> > + * Returns:
> > + * -EINTR  - exit to userspace
> > + * -EINVAL - VMentry failure; continue
> > + *  0      - success, i.e. proceed with actual VMEnter
> >   */
> >  int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool
> > from_vmentry)
> >  {
> > @@ -2999,6 +3014,7 @@ int nested_vmx_enter_non_root_mode(struct
> > kvm_vcpu *vcpu, bool from_vmentry)
> >       bool evaluate_pending_interrupts;
> >       u32 exit_reason = EXIT_REASON_INVALID_STATE;
> >       u32 exit_qual;
> > +     int r;
> >
> >       evaluate_pending_interrupts = exec_controls_get(vmx) &
> >               (CPU_BASED_VIRTUAL_INTR_PENDING |
> > CPU_BASED_VIRTUAL_NMI_PENDING);
> > @@ -3035,11 +3051,15 @@ int nested_vmx_enter_non_root_mode(struct
> > kvm_vcpu *vcpu, bool from_vmentry)
> >       prepare_vmcs02_early(vmx, vmcs12);
> >
> >       if (from_vmentry) {
> > -             nested_get_vmcs12_pages(vcpu);
> > +             r = nested_get_vmcs12_pages(vcpu);
> > +             if (unlikely(r))
> > +                     return r;
> >
> >               if (nested_vmx_check_vmentry_hw(vcpu)) {
> >                       vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> > -                     return -1;
> > +                     r = nested_vmx_failValid(vcpu,
> > +
> > VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > +                     return r ? -EINVAL : -EINTR;
> >               }
> >
> >               if (nested_vmx_check_guest_state(vcpu, vmcs12,
> > &exit_qual))
> > @@ -3119,14 +3139,14 @@ int nested_vmx_enter_non_root_mode(struct
> > kvm_vcpu *vcpu, bool from_vmentry)
> >       vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> >
> >       if (!from_vmentry)
> > -             return 1;
> > +             return -EINVAL;
> >
> >       load_vmcs12_host_state(vcpu, vmcs12);
> >       vmcs12->vm_exit_reason = exit_reason |
> > VMX_EXIT_REASONS_FAILED_VMENTRY;
> >       vmcs12->exit_qualification = exit_qual;
> >       if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
> >               vmx->nested.need_vmcs12_to_shadow_sync = true;
> > -     return 1;
> > +     return -EINVAL;
> >  }
> >
> >  /*
> > @@ -3200,11 +3220,8 @@ static int nested_vmx_run(struct kvm_vcpu
> > *vcpu, bool launch)
> >       vmx->nested.nested_run_pending = 1;
> >       ret = nested_vmx_enter_non_root_mode(vcpu, true);
> >       vmx->nested.nested_run_pending = !ret;
> > -     if (ret > 0)
> > -             return 1;
> > -     else if (ret)
> > -             return nested_vmx_failValid(vcpu,
> > -                     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > +     if (ret)
> > +             return ret != -EINTR;
> >
> >       /* Hide L1D cache contents from the nested guest.  */
> >       vmx->vcpu.arch.l1tf_flush_l1d = true;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 290c3c3efb877..5ddbf16c8b108 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7803,8 +7803,13 @@ static int vcpu_enter_guest(struct kvm_vcpu
> > *vcpu)
> >       bool req_immediate_exit = false;
> >
> >       if (kvm_request_pending(vcpu)) {
> > -             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES,
> > vcpu))
> > -                     kvm_x86_ops->get_vmcs12_pages(vcpu);
> > +             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES,
> > vcpu)) {
> > +                     r = kvm_x86_ops->get_vmcs12_pages(vcpu);
> > +                     if (unlikely(r)) {
> > +                             r = 0;
> > +                             goto out;
> > +                     }
> > +             }
> >               if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
> >                       kvm_mmu_unload(vcpu);
> >               if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> > --
> > 2.23.0.162.g0b9fbb3734-goog
>
