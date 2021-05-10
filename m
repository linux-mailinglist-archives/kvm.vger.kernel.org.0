Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06AD379A3D
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 00:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhEJWl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 18:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhEJWlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 18:41:25 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A8EC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 15:40:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j12so8297924pgh.7
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 15:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hbH0C8P8Jk3egpmCRvdSA5W5Q4AjZh56OZVlG79oi5c=;
        b=A+xlxTb/7lkPj03icNYGlzQpfUJGeogr1P2hfAIiS6/3JQyu0vO6r5DAucRJeq+enP
         i5zbzHECRyMxzPr7MQM53STbDIDcceKOeZnybqIVnfY5VVMNvIBU8HjZZNJeVXWimXLU
         V8yj3USNQudRfzWVfXAt5oJApFpDAjuFAZTjzTMumcnMe0+zAdEjooDffz+mstlPIGbC
         Kzyt4DCWTF+Fm3+QXFn+FQ9XNwLMJaZoM69SB9YAYPOUqsgUYp1IZcFR06wS86LWGTlH
         iQcGS6l5IzM2NO+SI6sCQO38MN5gIjZwIchV7zNf0SSqu4InPIWUdBH3VZWo6RlrM1xl
         KQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hbH0C8P8Jk3egpmCRvdSA5W5Q4AjZh56OZVlG79oi5c=;
        b=LSHqcY3D1cxI499ogZpwC9Lc8NDeeUbu3iXpA3/5AVZNhAioLxf6u8a7RRrjy1ukV4
         M9BB9XIRkIdBnVqqIynfDx0FpweXutn15rUaBA+WYwWCXi7SwpbiHaDz4Pla5zK0yoa9
         zX2dYhGV3QI+R9j3Q2e/G41uHg3D/Q3j3nloB51qzTR0b2PepGpKzSX1jeie3UIm8bVy
         TWw9oz1OpkThsmqqlnc6pPsyqA4DpVOnIqHPveW8Ot74R9RkC5u9XigEtq/6NTjNnyve
         vzTsdRc4jbtdZqiTMCOzLjlf44FMTz4WEEk3vEum2VAQSmfWkWeftyZ6FkjuUeELQaju
         61EA==
X-Gm-Message-State: AOAM530H7TBSQY6Rgp7nOf9vGiPvpDgYuGNh1ceHT4htchwd2jESOryz
        Kpw9RIlwRzp321pv2UBoz9xJKQ==
X-Google-Smtp-Source: ABdhPJwf9X8xH3jIgjeORQIx2SfTico/ajOH9CLwd2EbFrzvR88MdP2uV0vBGdNelb+tLqnIvu7CRQ==
X-Received: by 2002:aa7:904e:0:b029:28f:da01:1a5f with SMTP id n14-20020aa7904e0000b029028fda011a5fmr26907997pfo.67.1620686419178;
        Mon, 10 May 2021 15:40:19 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z29sm12097398pga.52.2021.05.10.15.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:40:18 -0700 (PDT)
Date:   Mon, 10 May 2021 22:40:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs
 for protected guests
Message-ID: <YJm2TkGFyciplA8l@google.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-3-seanjc@google.com>
 <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com>
 <YJla8vpwqCxqgS8C@google.com>
 <12fe8f83-49b4-1a22-7903-84e45f16c372@amd.com>
 <YJmfV1sO8miqvQLM@google.com>
 <26da40a0-c9b4-f517-94a6-5d3d69c4a207@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26da40a0-c9b4-f517-94a6-5d3d69c4a207@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Tom Lendacky wrote:
> On 5/10/21 4:02 PM, Sean Christopherson wrote:
> > On Mon, May 10, 2021, Tom Lendacky wrote:
> >> On 5/10/21 11:10 AM, Sean Christopherson wrote:
> >>> On Fri, May 07, 2021, Tom Lendacky wrote:
> >>>> On 5/7/21 11:59 AM, Sean Christopherson wrote:
> >>>>> Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
> >>>>> protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
> >>>>> tracks the aforementioned registers by trapping guest writes, and also
> >>>>> exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
> >>>>> in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
> >>>>> match the known hardware state.
> >>>>
> >>>> This is very similar to the original patch I had proposed that you were
> >>>> against :)
> >>>
> >>> I hope/think my position was that it should be unnecessary for KVM to need to
> >>> know the guest's CR0/4/0 and EFER values, i.e. even the trapping is unnecessary.
> >>> I was going to say I had a change of heart, as EFER.LMA in particular could
> >>> still be required to identify 64-bit mode, but that's wrong; EFER.LMA only gets
> >>> us long mode, the full is_64_bit_mode() needs access to cs.L, which AFAICT isn't
> >>> provided by #VMGEXIT or trapping.
> >>
> >> Right, that one is missing. If you take a VMGEXIT that uses the GHCB, then
> >> I think you can assume we're in 64-bit mode.
> > 
> > But that's not technically guaranteed.  The GHCB even seems to imply that there
> > are scenarios where it's legal/expected to do VMGEXIT with a valid GHCB outside
> > of 64-bit mode:
> > 
> >   However, instead of issuing a HLT instruction, the AP will issue a VMGEXIT
> >   with SW_EXITCODE of 0x8000_0004 ((this implies that the GHCB was updated prior
> >   to leaving 64-bit long mode).
> 
> Right, but in order to fill in the GHCB so that the hypervisor can read
> it, the guest had to have been in 64-bit mode. Otherwise, whatever the
> guest wrote will be seen as encrypted data and make no sense to the
> hypervisor anyway.

Having once been in 64-bit is not the same thing as currently being in 64-bit.
E.g. if the VMM _knows_ that the vCPU is not in 64-bit, e.g. because it traps
writes to CR0, then ignoring bits 63:32 of GPRs would be entirely reasonable.

In practice it probably won't matter since the guest will have to go out of its
way to do VMGEXIT outside of 64-bit mode with valid data in the GHCB, but ideally
KVM will conform to a spec, not implement a best guess as to what will/won't work
for the guest.

> >>> I.e. either the ghcb_cpl_is_valid() check should be nuked, or more likely KVM
> >>
> >> The ghcb_cpl_is_valid() is still needed to see whether the VMMCALL was
> >> from userspace or not (a VMMCALL will generate a #VC).
> > 
> > Blech.  I get that the GHCB spec says CPL must be provided/checked for VMMCALL,
> > but IMO that makes no sense whatsover.
> > 
> > If the guest restricts the GHCB to CPL0, then the CPL field is pointless because
> > the VMGEXIT will only ever come from CPL0.  Yes, technically the guest kernel
> > can proxy a VMMCALL from userspace to the host, but the guest kernel _must_ be
> > the one to enforce any desired CPL checks because the VMM is untrusted, at least
> > once you get to SNP.
> > 
> > If the guest exposes the GHCB to any CPL, then the CPL check is worthless because
> 
> The GHCB itself is not exposed to any CPL.

That is a guest decision.  Nothing in the GHCB spec requires the GHCB to be
accessible only in CPL0.  I'm not arguing that any sane guest will actually map
the GHCB into userspace, but from an architectural perspective it's not a given.

> A VMMCALL will generate a #VC.

But that's irrevelant from an architectural perspective.  It is 100% legal to
do VMGEXIT(VMMCALL) without first doing VMMCALL and taking a #VC.

> The guest #VC handler will extract the CPL level from the context that
> generated the #VC (see vc_handle_vmmcall() in arch/x86/kernel/sev-es.c),
> so that a VMMCALL from userspace will have the proper CPL value in the
> GHCB when the #VC handler issues the VMGEXIT instruction.

I get how the CPL ended up as a requirement for VMMCALL in the GHCB, I'm arguing
that it's useless information.  From the guest's perspective, it must handle
privilege checks for those checks to have any meaning with respect to security.
From the VMM's perspective, the checks have zero meaning whatsoever because the
CPL field is software controlled.  The fact that the VMM got a VMGEXIT with
valid data in the GHCB is proof enough that the guest blessed the VMGEXIT.

It's kind of a moot point because the extra CPL doesn't break anything, but it
gives a false sense of security since it implies the guest can/should rely on
the VMM to do privilege enforcement.

Actually, after looking at the Linux guest code, the entire VMCALL->#VC->VMGEXIT
concept is flawed.  E.g. kvm_sev_es_hcall_prepare() copies over all _possible_
GPRs.  That means users of kvm_hypercall{1,2,3}() are leaking random register
state to the VMM.  That can be "fixed" by zeroing unused registers or reflecting
on regs->ax, but at that point it's far easier and more performant to simply do
VMGEXIT(VMCALL) directly and skip the #VC.

As for VMMCALL from userspace, IMO the kernel's default should be to reject them
unconditionally.  KVM and Hyper-V APIs do not allow hypercalls from CPL>0.  At a
glance, neither does Xen (Xen skips the CPL check, but AFAICT only when the vCPU
is in real mode and thus the CPL check is meaningless).  No idea about VMware.
If there is a use case for allowing VMMCALL from userspace, then it absolutely
needs to be handled in a x86_hyper_runtime hook, because otherwise the kernel
has zero clue whether or not the hypercall should be allowed, and if it's
allowed, precisely which registers to expose.  I.e. the hook would have to
expose only the registers needed for that exact hypercall, otherwise the kernel
would unintentionally leak userspace register state.
