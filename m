Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0D4365622
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhDTK2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhDTK2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:28:23 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F67FC06174A;
        Tue, 20 Apr 2021 03:27:51 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id k18so33537783oik.1;
        Tue, 20 Apr 2021 03:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P360YuDkMWuR4DNubJc7LyR38YU+VLLnGuOuUFMt2WI=;
        b=K8U4KoOULmsImmO9kv4ETzZ+RckCgZeKLSDQONeT3X1jD+XeihBw3Sb2W3jLw7jukb
         E7Km/Prm5Gp6sPBExz90WqnafzFy+AF2KhT4tH1/nhCSQtUI1BPzyoG0VGrCA7DvCHUw
         PBDhVQ6EMENw/CrxJzEaw9oqKcGKQzTHMbygacGiXxoCJtJ9A3nYrlqQFTmCTr9O8pbC
         jXtZ4hdp5wyvFlRUHG7O2eMSmvdfh8M6jcZJ9KgC+c4IeCzOuVpRnBqvBUBa8//cL4WZ
         u3yPhPkM0FrvcSmBVX3RpfB7sKx+WnLiaFgkleDhn2KDSYzGPWsfWwan0Kzl75jcZ+8r
         wRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P360YuDkMWuR4DNubJc7LyR38YU+VLLnGuOuUFMt2WI=;
        b=LZadYd4Zz2J9UPCCJzRZbA8EiWDfY7WVFbfWE3Wo+HXB7dYO+LsubHtPPGb0KwK/j6
         wZhXyMTnvjdagT/x2OSUIZiQbZnhdnjFh0HmGmjx2+iCXktvA0mik/8i+uxgq/gg6eKs
         Q6nm+OzhIUqq/GHBPl0wKPj62FeY5MNZu3FhcfBC4P17+7erQ9s1qbSbT8AFgmoeXJ4A
         9kO6t3k1vrt86HmnCmHBLfUA3hPnJUersrQfEAzJIEjeqAiteHNCraJYdhmE4Tg8GJKD
         kSyKmgApMh/ewtPOVbKm42t38uyFIz38eADYB9oQk+1NTWy3FGFx919i3ks6u9+X4M2z
         Qb0A==
X-Gm-Message-State: AOAM532b6aL2/aajNkBHxBP6u/Jg5Lg5XqfkV/LFdSethqUlq3F+lKM2
        maWQyHLR9qP902oN+LYutMzH6d9P6HQVdL/5utk=
X-Google-Smtp-Source: ABdhPJx25NJ382cQlZjTvnMUonFEsruY2URHmw0myEh5fIHziaFG0hsUl/KBIxM91G5RGJZ6LrFqMcw+1Et6WX0794Y=
X-Received: by 2002:aca:c08a:: with SMTP id q132mr2480666oif.5.1618914470861;
 Tue, 20 Apr 2021 03:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com> <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
 <YH2wnl05UBqVhcHr@google.com> <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
 <CANRm+CwQ266j6wTxqFZtGhp_HfQZ7Y_e843hzROqNUxf9BcaFA@mail.gmail.com>
 <CANRm+CyHX-_vQLck1a9wpCv8a-YnnemEWm+zVv4eWYby5gdAeg@mail.gmail.com>
 <b2fca9a5-9b2b-b8f2-0d1e-fc8b9d9b5659@redhat.com> <CANRm+Czysw6z1u+fbsRF3JUyiJc0jErVATusar_Vj8CcSBy5LQ@mail.gmail.com>
 <e1d07b55-1539-ed33-911c-713403d776b3@redhat.com>
In-Reply-To: <e1d07b55-1539-ed33-911c-713403d776b3@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 20 Apr 2021 18:27:39 +0800
Message-ID: <CANRm+Cy-78UnrkX8nh5WdHut2WW5NU=UL84FRJnUNjsAPK+Uww@mail.gmail.com>
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

On Tue, 20 Apr 2021 at 18:23, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/04/21 10:48, Wanpeng Li wrote:
> >> I was thinking of something simpler:
> >>
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index 9b8e30dd5b9b..455c648f9adc 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -3198,10 +3198,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool=
 yield_to_kernel_mode)
> >>    {
> >>          struct kvm *kvm =3D me->kvm;
> >>          struct kvm_vcpu *vcpu;
> >> -       int last_boosted_vcpu =3D me->kvm->last_boosted_vcpu;
> >>          int yielded =3D 0;
> >>          int try =3D 3;
> >> -       int pass;
> >> +       int pass, num_passes =3D 1;
> >>          int i;
> >>
> >>          kvm_vcpu_set_in_spin_loop(me, true);
> >> @@ -3212,13 +3211,14 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, boo=
l yield_to_kernel_mode)
> >>           * VCPU is holding the lock that we need and will release it.
> >>           * We approximate round-robin by starting at the last boosted=
 VCPU.
> >>           */
> >> -       for (pass =3D 0; pass < 2 && !yielded && try; pass++) {
> >> -               kvm_for_each_vcpu(i, vcpu, kvm) {
> >> -                       if (!pass && i <=3D last_boosted_vcpu) {
> >> -                               i =3D last_boosted_vcpu;
> >> -                               continue;
> >> -                       } else if (pass && i > last_boosted_vcpu)
> >> -                               break;
> >> +       for (pass =3D 0; pass < num_passes; pass++) {
> >> +               int idx =3D me->kvm->last_boosted_vcpu;
> >> +               int n =3D atomic_read(&kvm->online_vcpus);
> >> +               for (i =3D 0; i < n; i++, idx++) {
> >> +                       if (idx =3D=3D n)
> >> +                               idx =3D 0;
> >> +
> >> +                       vcpu =3D kvm_get_vcpu(kvm, idx);
> >>                          if (!READ_ONCE(vcpu->ready))
> >>                                  continue;
> >>                          if (vcpu =3D=3D me)
> >> @@ -3226,23 +3226,36 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, boo=
l yield_to_kernel_mode)
> >>                          if (rcuwait_active(&vcpu->wait) &&
> >>                              !vcpu_dy_runnable(vcpu))
> >>                                  continue;
> >> -                       if (READ_ONCE(vcpu->preempted) && yield_to_ker=
nel_mode &&
> >> -                               !kvm_arch_vcpu_in_kernel(vcpu))
> >> -                               continue;
> >>                          if (!kvm_vcpu_eligible_for_directed_yield(vcp=
u))
> >>                                  continue;
> >>
> >> +                       if (READ_ONCE(vcpu->preempted) && yield_to_ker=
nel_mode &&
> >> +                           !kvm_arch_vcpu_in_kernel(vcpu)) {
> >> +                           /*
> >> +                            * A vCPU running in userspace can get to =
kernel mode via
> >> +                            * an interrupt.  That's a worse choice th=
an a CPU already
> >> +                            * in kernel mode so only do it on a secon=
d pass.
> >> +                            */
> >> +                           if (!vcpu_dy_runnable(vcpu))
> >> +                                   continue;
> >> +                           if (pass =3D=3D 0) {
> >> +                                   num_passes =3D 2;
> >> +                                   continue;
> >> +                           }
> >> +                       }
> >> +
> >>                          yielded =3D kvm_vcpu_yield_to(vcpu);
> >>                          if (yielded > 0) {
> >>                                  kvm->last_boosted_vcpu =3D i;
> >> -                               break;
> >> +                               goto done;
> >>                          } else if (yielded < 0) {
> >>                                  try--;
> >>                                  if (!try)
> >> -                                       break;
> >> +                                       goto done;
> >>                          }
> >>                  }
> >>          }
> >> +done:
> >
> > We just tested the above post against 96 vCPUs VM in an over-subscribe
> > scenario, the score of pbzip2 fluctuated drastically. Sometimes it is
> > worse than vanilla, but the average improvement is around 2.2%. The
> > new version of my post is around 9.3%=EF=BC=8Cthe origial posted patch =
is
> > around 10% which is totally as expected since now both IPI receivers
> > in user-mode and lock-waiters are second class citizens.
>
> Fair enough.  Of the two patches you posted I prefer the original, so
> I'll go with that one.

Great! Thanks. :)

    Wanpeng
