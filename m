Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1944365486
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhDTItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhDTItQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 04:49:16 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2DDC06174A;
        Tue, 20 Apr 2021 01:48:45 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id k25so38260492oic.4;
        Tue, 20 Apr 2021 01:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yl+W1V0m+opW/0EqdN8+IoffaI54c9BDR8b/OZaYnnk=;
        b=RDr0Dp/6Ya8bvRiwLw6jT3MAJ6cD5SVHOArSsZ7O9E67IKOUY7cEXdEENf3bFAI61p
         1UEvNcP3uUR3xD62JnqSGtfPbvMLuEN52aAW8jrT3hyfB1x0ZqGaoROIZIbJTqEelCTy
         XOx4rhYuoMpmp8RyUaEOkVgG7mmWerEfp0il5fhVEb65u+ifqIZu4sDqruB3K1cvp5Ln
         5BSVriAputCzn0bdJQJIetgkdIFCN40WiK+qBmSDA6/Ao5Qij2WEnWxRaBssCijAggm4
         js0O10KDH0Hr5yVyvdTEFYT5FXH5NCjv26y9IAU6RGt/UE9biFfmaVHzD05FGhm5QfCn
         sMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yl+W1V0m+opW/0EqdN8+IoffaI54c9BDR8b/OZaYnnk=;
        b=RJgW2K/UuZYD1J/Vm1PQ/yywAwZVM9fWNxGPMjmPcFZvQIscLYlcyvVSoM+7a6KGtR
         2Ve3MkLuMjLQo1SUMW00FNQN5sgCsYaUh16QOiapXNV5J8/kNzf4+U4uB3383FFVxcDc
         M6+KmKs13lEu1WplH/vFt07eTNAYpoBACDCsjwWUQF8gV0i0siMGe2eFVT5bZ7UgK876
         QNhL7N+jNk5eXuCeDlN8sn3n5KMK/AsldH45jnmMIZ9nB2RARDVWtayOMMWvgjxFr4Uu
         24LhxEGB42t4kHR+30a1uGBdaagZXJ2GiBdtxwLH6e3ROYxUrSjGwjo2o2jw01AtvLv+
         gv5g==
X-Gm-Message-State: AOAM532ESY9XuW7vg+tgYBWHWJLVrkTSFO9/PjY52wxdMGgGWAUheyEG
        E6e6KoybmYNbWQ6I0QXMOJP0b12r++2lI1qpKuI=
X-Google-Smtp-Source: ABdhPJx2b0v5jru395h7T1ONj2h2n/VdWTSbyMd1iaPa7sD5g1l8Es6Paf2OL4y5cM4zmRUvzdQZZ4qDtoG5/wl7bOw=
X-Received: by 2002:aca:bb09:: with SMTP id l9mr2369011oif.33.1618908524615;
 Tue, 20 Apr 2021 01:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com> <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
 <YH2wnl05UBqVhcHr@google.com> <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
 <CANRm+CwQ266j6wTxqFZtGhp_HfQZ7Y_e843hzROqNUxf9BcaFA@mail.gmail.com>
 <CANRm+CyHX-_vQLck1a9wpCv8a-YnnemEWm+zVv4eWYby5gdAeg@mail.gmail.com> <b2fca9a5-9b2b-b8f2-0d1e-fc8b9d9b5659@redhat.com>
In-Reply-To: <b2fca9a5-9b2b-b8f2-0d1e-fc8b9d9b5659@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 20 Apr 2021 16:48:34 +0800
Message-ID: <CANRm+Czysw6z1u+fbsRF3JUyiJc0jErVATusar_Vj8CcSBy5LQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Apr 2021 at 15:23, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/04/21 08:08, Wanpeng Li wrote:
> > On Tue, 20 Apr 2021 at 14:02, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>
> >> On Tue, 20 Apr 2021 at 00:59, Paolo Bonzini <pbonzini@redhat.com> wrot=
e:
> >>>
> >>> On 19/04/21 18:32, Sean Christopherson wrote:
> >>>> If false positives are a big concern, what about adding another pass=
 to the loop
> >>>> and only yielding to usermode vCPUs with interrupts in the second fu=
ll pass?
> >>>> I.e. give vCPUs that are already in kernel mode priority, and only y=
ield to
> >>>> handle an interrupt if there are no vCPUs in kernel mode.
> >>>>
> >>>> kvm_arch_dy_runnable() pulls in pv_unhalted, which seems like a good=
 thing.
> >>>
> >>> pv_unhalted won't help if you're waiting for a kernel spinlock though=
,
> >>> would it?  Doing two passes (or looking for a "best" candidate that
> >>> prefers kernel mode vCPUs to user mode vCPUs waiting for an interrupt=
)
> >>> seems like the best choice overall.
> >>
> >> How about something like this:
>
> I was thinking of something simpler:
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9b8e30dd5b9b..455c648f9adc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3198,10 +3198,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yi=
eld_to_kernel_mode)
>   {
>         struct kvm *kvm =3D me->kvm;
>         struct kvm_vcpu *vcpu;
> -       int last_boosted_vcpu =3D me->kvm->last_boosted_vcpu;
>         int yielded =3D 0;
>         int try =3D 3;
> -       int pass;
> +       int pass, num_passes =3D 1;
>         int i;
>
>         kvm_vcpu_set_in_spin_loop(me, true);
> @@ -3212,13 +3211,14 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool y=
ield_to_kernel_mode)
>          * VCPU is holding the lock that we need and will release it.
>          * We approximate round-robin by starting at the last boosted VCP=
U.
>          */
> -       for (pass =3D 0; pass < 2 && !yielded && try; pass++) {
> -               kvm_for_each_vcpu(i, vcpu, kvm) {
> -                       if (!pass && i <=3D last_boosted_vcpu) {
> -                               i =3D last_boosted_vcpu;
> -                               continue;
> -                       } else if (pass && i > last_boosted_vcpu)
> -                               break;
> +       for (pass =3D 0; pass < num_passes; pass++) {
> +               int idx =3D me->kvm->last_boosted_vcpu;
> +               int n =3D atomic_read(&kvm->online_vcpus);
> +               for (i =3D 0; i < n; i++, idx++) {
> +                       if (idx =3D=3D n)
> +                               idx =3D 0;
> +
> +                       vcpu =3D kvm_get_vcpu(kvm, idx);
>                         if (!READ_ONCE(vcpu->ready))
>                                 continue;
>                         if (vcpu =3D=3D me)
> @@ -3226,23 +3226,36 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool y=
ield_to_kernel_mode)
>                         if (rcuwait_active(&vcpu->wait) &&
>                             !vcpu_dy_runnable(vcpu))
>                                 continue;
> -                       if (READ_ONCE(vcpu->preempted) && yield_to_kernel=
_mode &&
> -                               !kvm_arch_vcpu_in_kernel(vcpu))
> -                               continue;
>                         if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>                                 continue;
>
> +                       if (READ_ONCE(vcpu->preempted) && yield_to_kernel=
_mode &&
> +                           !kvm_arch_vcpu_in_kernel(vcpu)) {
> +                           /*
> +                            * A vCPU running in userspace can get to ker=
nel mode via
> +                            * an interrupt.  That's a worse choice than =
a CPU already
> +                            * in kernel mode so only do it on a second p=
ass.
> +                            */
> +                           if (!vcpu_dy_runnable(vcpu))
> +                                   continue;
> +                           if (pass =3D=3D 0) {
> +                                   num_passes =3D 2;
> +                                   continue;
> +                           }
> +                       }
> +
>                         yielded =3D kvm_vcpu_yield_to(vcpu);
>                         if (yielded > 0) {
>                                 kvm->last_boosted_vcpu =3D i;
> -                               break;
> +                               goto done;
>                         } else if (yielded < 0) {
>                                 try--;
>                                 if (!try)
> -                                       break;
> +                                       goto done;
>                         }
>                 }
>         }
> +done:

We just tested the above post against 96 vCPUs VM in an over-subscribe
scenario, the score of pbzip2 fluctuated drastically. Sometimes it is
worse than vanilla, but the average improvement is around 2.2%. The
new version of my post is around 9.3%=EF=BC=8Cthe origial posted patch is
around 10% which is totally as expected since now both IPI receivers
in user-mode and lock-waiters are second class citizens. Big VM
increases the probability multiple vCPUs may enter PLE handler, the
previous vCPU who starts searching earlier can mark IPI receivers in
user-mode as dy_eligible, the vCPU who starts searching a little later
can select it directly. However, after the above posting, the
PLE-caused vCPU should search the second full pass by himself.

    Wanpeng
