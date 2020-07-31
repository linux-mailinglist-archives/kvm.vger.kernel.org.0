Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE7233DA5
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 05:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbgGaDSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 23:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731193AbgGaDSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 23:18:14 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED077C061574;
        Thu, 30 Jul 2020 20:18:13 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id o21so4870088oie.12;
        Thu, 30 Jul 2020 20:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDX5BL8Kg6dz4NIfSq2/kBQgUQBoWLV9b549kguz+k4=;
        b=e4LOTTGO9VGAd0578jx3jnJEw7Knp2InuwW64gwhwP1NjzWkpHB9e2eEhIWvNHc7aL
         bFXR3LSVwPDoKzSQYVRq35xDuEi3hxBAAG2WHpkTO1ShQEFnLi7m22ShXTsrlx9TcdmH
         bAFUkGdivGbf+cgj7FBoK5Ik2JzTYzirMy/KkvCpq1XosjCB9kY9IuCZyd5x51CdkiJX
         Jsaxi7FaDT+yAAEPu22fEyA/yKeBhys02Q4s/ALn2dEHGasPFeHeB6sa+Lxu35+tzpKN
         nnu5WKwP19QTjzDNqpgpgk4pdsRGerPAOtiAndKrJWDN/ssFGxpg7L0DTnZ034WvjxTX
         Rr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDX5BL8Kg6dz4NIfSq2/kBQgUQBoWLV9b549kguz+k4=;
        b=bjwrz8B81y4wF2sT0IMKGt7VfsB4hHUPg7Hxg6dGbUi4f7YLmZv/FVXlwpw7kuFq3y
         YrAFAjHYVrxHP36r/O5OUzaWY5lyC/4GQ5mzaXwAhtaBDYetZtBsLI57uS1B2pbnMIEb
         3MfDxgp3W/ncg8OOhqlxqJoW4cELd6UTuEs20jnH3AKisF6PmDYSCDmipB3x3GvkAO8N
         OkR3Exdjxz9NNmwnR4yz5ggNEz1d5i/ckYot1Mk2sUwPGDHngeIC3yShsBVfxy8u8K0z
         RUZW2Eakz+QR6iOv//JHoPsJ7yT67+2NFHIjfVMOkmSeV/RWeD2NVaYY4RxUUTL7tQFH
         v20A==
X-Gm-Message-State: AOAM532aOhqQto/vYDgKkaQ7Hx63oxwjsJYN08aJsz0DoDxuYqHRiKTj
        w9Huv9VXZDi0T55qrv/4uy7N29ZkrqRXcPkzF4w=
X-Google-Smtp-Source: ABdhPJw2eyVem6mXOUYU37azi0C4t08WajaLglV8LeaogMNa+yfvnZEon1nqN+ZrCYvFutA1eXx9OIXCTS2FFLtU1tk=
X-Received: by 2002:a05:6808:b:: with SMTP id u11mr1499503oic.33.1596165493383;
 Thu, 30 Jul 2020 20:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
 <1595929506-9203-3-git-send-email-wanpengli@tencent.com> <87k0ymldg9.fsf@vitty.brq.redhat.com>
 <CANRm+Cx-VM=QGcDNG0oRq7YX+2wmmw8yDjESrJGxTeEWkUUv0A@mail.gmail.com> <875za5l0cm.fsf@vitty.brq.redhat.com>
In-Reply-To: <875za5l0cm.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 31 Jul 2020 11:18:02 +0800
Message-ID: <CANRm+CyDr3hj_Gg0Q9FrbAJMvuJCiYam_gd4Y6the=9XjCbp4w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Fix disable pause loop exit/pause
 filtering capability on SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jul 2020 at 19:16, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > On Wed, 29 Jul 2020 at 20:21, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Wanpeng Li <kernellwp@gmail.com> writes:
> >>
> >> > From: Wanpeng Li <wanpengli@tencent.com>
> >> >
> >> > Commit 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM) drops
> >> > disable pause loop exit/pause filtering capability completely, I guess it
> >> > is a merge fault by Radim since disable vmexits capabilities and pause
> >> > loop exit for SVM patchsets are merged at the same time. This patch
> >> > reintroduces the disable pause loop exit/pause filtering capability
> >> > support.
> >> >
> >> > We can observe 2.9% hackbench improvement for a 92 vCPUs guest on AMD
> >> > Rome Server.
> >> >
> >> > Reported-by: Haiwei Li <lihaiwei@tencent.com>
> >> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> >> > Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
> >> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >> > ---
> >> >  arch/x86/kvm/svm/svm.c | 9 ++++++---
> >> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> > index c0da4dd..c20f127 100644
> >> > --- a/arch/x86/kvm/svm/svm.c
> >> > +++ b/arch/x86/kvm/svm/svm.c
> >> > @@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> >> >       svm->nested.vmcb = 0;
> >> >       svm->vcpu.arch.hflags = 0;
> >> >
> >> > -     if (pause_filter_count) {
> >> > +     if (pause_filter_count && !kvm_pause_in_guest(svm->vcpu.kvm)) {
> >> >               control->pause_filter_count = pause_filter_count;
> >> >               if (pause_filter_thresh)
> >> >                       control->pause_filter_thresh = pause_filter_thresh;
> >> > @@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
> >> >       struct kvm_vcpu *vcpu = &svm->vcpu;
> >> >       bool in_kernel = (svm_get_cpl(vcpu) == 0);
> >> >
> >> > -     if (pause_filter_thresh)
> >> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >> >               grow_ple_window(vcpu);
> >> >
> >> >       kvm_vcpu_on_spin(vcpu, in_kernel);
> >> > @@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >> >
> >> >  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> >> >  {
> >> > -     if (pause_filter_thresh)
> >> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >> >               shrink_ple_window(vcpu);
> >> >  }
> >> >
> >> > @@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
> >> >
> >> >  static int svm_vm_init(struct kvm *kvm)
> >> >  {
> >> > +     if (!pause_filter_thresh)
> >> > +             kvm->arch.pause_in_guest = true;
> >>
> >> Would it make sense to do
> >>
> >>         if (!pause_filter_count || !pause_filter_thresh)
> >>                 kvm->arch.pause_in_guest = true;
> >>
> >> here and simplify the condition in init_vmcb()?
> >
> > kvm->arch.pause_in_guest can also be true when userspace sets the
> > KVM_CAP_X86_DISABLE_EXITS capability, so we can't simplify the
> > condition in init_vmcb().
> >
>
> I meant we simplify it to
>
> if (!kvm_pause_in_guest(svm->vcpu.kvm))
>
> as "!pause_filter_count" gets included.

Just do it in v3.

    Wanpeng
