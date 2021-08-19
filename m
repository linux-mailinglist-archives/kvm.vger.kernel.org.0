Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E63F2052
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhHSTC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 15:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhHSTC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 15:02:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B411DC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 12:01:50 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f10so293234lfv.6
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 12:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VFzrnE3a6L9Tczohj9RQoEEFySSh7029ha5hRjL+eHw=;
        b=nAXPqnq8r7hRAo7LMukK3FFDgAFvo2pTbT/9kA4weITIpvudhMRFjcyZuQSF1+Tidc
         4to5t2isU4WD+5oY2M+EXS65EE1dc0/ysfqB9QJ9qElKerQkHTRlJ105G08UQvxQ668u
         jFQHZISKbmEaUfZRL1RrahlJlqbdN1K/VbVWMshTvjBiktCHxxB2l4x2OLRL7lFQv0ij
         4PsMbCaJp+KlqFx4Kzb6LqQjQEzLVpejIGtxN1wHuYfX0Q4M2CnVsTmKeNsZz9HTKC/I
         tmoCBPmf6kBzuNjSlhbSni179zh7s3QVbQcxFxnL8Gat2T1un+H3YuszPKDOA+L4Igi/
         DZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VFzrnE3a6L9Tczohj9RQoEEFySSh7029ha5hRjL+eHw=;
        b=cLAdGCEHlRDPPScqbbcR1G4VvLorWGs5vyanpBaF58KhbXPuI2sJyN7qy1HXVwxvbh
         5SV9GXcFjHT+uvp363qnadMhdUvm+BmMSDS3dPfqoNJswVpNZNra0sqF8/+M1Meo8rtV
         xSC5HqIagkXX75fwHVAqVfq227pN5l0OmomJG+C6EhA1XYRtDiDMk8JDwJr+F5T2zIqF
         Ja2sQY9uTpRffKDmjrj99GrhRF9DXovSZfIiRO+Umkpa0Nss7bLP0hEFRJXQ9mVdsztQ
         2wcOQ9hqAshuzecxhyaxsZyumWKKzxXCRhp5EBEccMnKosiOmFabfuDfE9HfLhHi2lLI
         erOg==
X-Gm-Message-State: AOAM530ASHU8EDAFKHUqoXxdG/FEXHqvuT+qt10oIqR7y5rYsYsN3nzH
        Q9lDh387Y9NCsNMxF/4GiIi0kLs4be4mK0Cfn31nBw==
X-Google-Smtp-Source: ABdhPJy2Rp/Ofz/vN4S4Mu6xZhzJcQL/XGazpZ0dZOz9gs/hSB8B5S+3xc07DJs8r696z9LWxTff8d/C/uRfaW8cMfQ=
X-Received: by 2002:ac2:5964:: with SMTP id h4mr11906960lfp.473.1629399708798;
 Thu, 19 Aug 2021 12:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210819180012.744855-1-jingzhangos@google.com> <CALzav=cP17YXD8dRJnYFe_qmox3CTtpVBtLbU42Ei9zea2w21Q@mail.gmail.com>
In-Reply-To: <CALzav=cP17YXD8dRJnYFe_qmox3CTtpVBtLbU42Ei9zea2w21Q@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 19 Aug 2021 12:01:37 -0700
Message-ID: <CAAdAUtj95EGkJOacbhtK81EvK6vg7QKNPq4H_3SU_Qwv7Lu2NA@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: x86: vmx: add exit reason stats to vt-x instructions
To:     David Matlack <dmatlack@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On Thu, Aug 19, 2021 at 11:43 AM David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Aug 19, 2021 at 11:00 AM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > These stats will be used to monitor the nested virtualization use in
> > VMs. Most importantly: VMXON exits are evidence that the guest has
> > enabled VMX, VMLAUNCH/VMRESUME exits are evidence that the guest has run
> > an L2.
>
> This series is superseded by Peter Feiner's internal KVM patch that
> exports an array of counts, one for each VM-exit reason ("kvm: vmx
> exit reason stats"). This is better since it does not require
> instrumenting every VM-exit handler in KVM and introducing a stat for
> every exit.
>
> Assuming upstream would want exit count stats I would suggest we drop
> this patch and upstream Peter's instead. Although we need to sort out
> AMD and other architectures as well.
>
Sure, will drop this.

Thanks,
Jing
> >
> > Original-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 11 +++++++++++
> >  arch/x86/kvm/vmx/nested.c       | 17 +++++++++++++++++
> >  arch/x86/kvm/x86.c              | 13 ++++++++++++-
> >  3 files changed, 40 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 09b256db394a..e3afbc7926e0 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1257,6 +1257,17 @@ struct kvm_vcpu_stat {
> >         u64 directed_yield_attempted;
> >         u64 directed_yield_successful;
> >         u64 guest_mode;
> > +       u64 vmclear_exits;
> > +       u64 vmlaunch_exits;
> > +       u64 vmptrld_exits;
> > +       u64 vmptrst_exits;
> > +       u64 vmread_exits;
> > +       u64 vmresume_exits;
> > +       u64 vmwrite_exits;
> > +       u64 vmoff_exits;
> > +       u64 vmon_exits;
> > +       u64 invept_exits;
> > +       u64 invvpid_exits;
> >  };
> >
> >  struct x86_instruction_info;
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index bc6327950657..8696f2612953 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4879,6 +4879,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
> >         const u64 VMXON_NEEDED_FEATURES = FEAT_CTL_LOCKED
> >                 | FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >
> > +       ++vcpu->stat.vmon_exits;
> >         /*
> >          * The Intel VMX Instruction Reference lists a bunch of bits that are
> >          * prerequisite to running VMXON, most notably cr4.VMXE must be set to
> > @@ -4964,6 +4965,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
> >  /* Emulate the VMXOFF instruction */
> >  static int handle_vmoff(struct kvm_vcpu *vcpu)
> >  {
> > +       ++vcpu->stat.vmoff_exits;
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -4984,6 +4986,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
> >         u64 evmcs_gpa;
> >         int r;
> >
> > +       ++vcpu->stat.vmclear_exits;
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -5025,6 +5028,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
> >  /* Emulate the VMLAUNCH instruction */
> >  static int handle_vmlaunch(struct kvm_vcpu *vcpu)
> >  {
> > +       ++vcpu->stat.vmlaunch_exits;
> >         return nested_vmx_run(vcpu, true);
> >  }
> >
> > @@ -5032,6 +5036,7 @@ static int handle_vmlaunch(struct kvm_vcpu *vcpu)
> >  static int handle_vmresume(struct kvm_vcpu *vcpu)
> >  {
> >
> > +       ++vcpu->stat.vmresume_exits;
> >         return nested_vmx_run(vcpu, false);
> >  }
> >
> > @@ -5049,6 +5054,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> >         short offset;
> >         int len, r;
> >
> > +       ++vcpu->stat.vmread_exits;
> > +
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -5141,6 +5148,8 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> >          */
> >         u64 value = 0;
> >
> > +       ++vcpu->stat.vmwrite_exits;
> > +
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -5245,6 +5254,8 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
> >         gpa_t vmptr;
> >         int r;
> >
> > +       ++vcpu->stat.vmptrld_exits;
> > +
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -5311,6 +5322,8 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
> >         gva_t gva;
> >         int r;
> >
> > +       ++vcpu->stat.vmptrst_exits;
> > +
> >         if (!nested_vmx_check_permission(vcpu))
> >                 return 1;
> >
> > @@ -5351,6 +5364,8 @@ static int handle_invept(struct kvm_vcpu *vcpu)
> >         } operand;
> >         int i, r;
> >
> > +       ++vcpu->stat.invept_exits;
> > +
> >         if (!(vmx->nested.msrs.secondary_ctls_high &
> >               SECONDARY_EXEC_ENABLE_EPT) ||
> >             !(vmx->nested.msrs.ept_caps & VMX_EPT_INVEPT_BIT)) {
> > @@ -5431,6 +5446,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
> >         u16 vpid02;
> >         int r;
> >
> > +       ++vcpu->stat.invvpid_exits;
> > +
> >         if (!(vmx->nested.msrs.secondary_ctls_high &
> >               SECONDARY_EXEC_ENABLE_VPID) ||
> >                         !(vmx->nested.msrs.vpid_caps & VMX_VPID_INVVPID_BIT)) {
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1a00af1b076b..c2c95b4c1a68 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -277,7 +277,18 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >         STATS_DESC_COUNTER(VCPU, nested_run),
> >         STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
> >         STATS_DESC_COUNTER(VCPU, directed_yield_successful),
> > -       STATS_DESC_ICOUNTER(VCPU, guest_mode)
> > +       STATS_DESC_ICOUNTER(VCPU, guest_mode),
> > +       STATS_DESC_COUNTER(VCPU, vmclear_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmlaunch_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmptrld_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmptrst_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmread_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmresume_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmwrite_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmoff_exits),
> > +       STATS_DESC_COUNTER(VCPU, vmon_exits),
> > +       STATS_DESC_COUNTER(VCPU, invept_exits),
> > +       STATS_DESC_COUNTER(VCPU, invvpid_exits),
> >  };
> >
> >  const struct kvm_stats_header kvm_vcpu_stats_header = {
> >
> > base-commit: 47e7414d53fc12407b7a43bba412ecbf54c84f82
> > --
> > 2.33.0.rc2.250.ged5fa647cd-goog
> >
