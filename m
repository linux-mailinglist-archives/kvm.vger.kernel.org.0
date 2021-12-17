Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D50478300
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 03:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhLQCLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 21:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLQCLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 21:11:53 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423F7C061574;
        Thu, 16 Dec 2021 18:11:53 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id m6so1582956oim.2;
        Thu, 16 Dec 2021 18:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RSQtSqbGAahik3lofKuwuzkCALOuuG/K6xcfqSLYhNA=;
        b=SHLw4f2H+5gWTcS6HVLp1w4KnEdCBxTCtWAdg4Qz+l7oer8vx4fAqjANgo0F1TbYx/
         1GuYcQ16H7wTPRKWZMUxhJdHr/tCT4ZnTSHRgZxBkcxHgOEzGwOAbvsYuPlshL0i7T/F
         hIV/v9Zczgwly4IeAYNKS9N1s+mNUlYCLZJbPR14S484XekgZZno/6rjwIDV6oBA6XV0
         eZzupvk9wnrvUj72wP5c30fRVgIcXVsbB6GOi6lp2f7sUvcHs2HZV24JHdlYIzsnOozZ
         OC8G+JFB3BY1JcmpyJKtRPxqioNGb5n8kSUazp5rPe9aQvq9DR1DhdXTIgNsv/llx3y6
         Ld/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSQtSqbGAahik3lofKuwuzkCALOuuG/K6xcfqSLYhNA=;
        b=LrxyASK4flgHOnKpjhl0nCjR2Dy4YCzD53JsBCjbLZpacwRM0D+KUOd7tza1I3UIO9
         Mdp9XqFiU6mKa2cZtPQ5gsd8Wq3JdH6/+KTApE9IxI1AR6BQZFFvWoyH4smdSvJFccfF
         4DKaE63Rz5u4WxtayBpS7rLocH5f4vhslLuPdwImtn0UWhgZ/gvyCaCtog41Iil+LwYH
         wPHNiM1rt+cpjMTpd8grxtIqFxSX+PGspcdUihUD2uv4fx5Va3TI8ugSC0aCt3yw3k6w
         EtBGiBBn/mtSqg6ESVbLPC+9ctEWwLD2bOhP89uAEoGymY8DLdtc5SSZixcUMEIdwBjI
         biGw==
X-Gm-Message-State: AOAM530Xu1zZgBNcFxSr7JNjqzYuz9wdtzruzTompmk63nBqq/oq3WiE
        pWrkElSwo22pwJ45sG8SGOqG+SKb5QBmgH0rOA0=
X-Google-Smtp-Source: ABdhPJwfrvfnTOnAEYB4YjLS/zEy0yUDDe6beDVjzqRnidWGzK3Gg2JACukT+DRDVtVJseugwJuePp3UXhdTBNFRagg=
X-Received: by 2002:a05:6808:68f:: with SMTP id k15mr6105547oig.5.1639707112651;
 Thu, 16 Dec 2021 18:11:52 -0800 (PST)
MIME-Version: 1.0
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com> <YbjWFTtNo9Ap7kDp@google.com>
 <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com> <Ybtea42RxZ9aVzCh@google.com>
In-Reply-To: <Ybtea42RxZ9aVzCh@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 17 Dec 2021 10:11:41 +0800
Message-ID: <CANRm+CwbOw8sXL4h9e5S6O7XcerUkfD+uG=iNu365qROeJTMKw@mail.gmail.com>
Subject: Re: The vcpu won't be wakened for a long time
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Dec 2021 at 07:48, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 16, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> > > What kernel version?  There have been a variety of fixes/changes in the
> > > area in recent kernels.
> >
> > The kernel version is 4.18, and it seems the latest kernel also has this problem.
> >
> > The following code can fixes this bug, I've tested it on 4.18.
> >
> > (4.18)
> >
> > @@ -3944,6 +3944,11 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
> >         if (pi_test_and_set_on(&vmx->pi_desc))
> >                 return;
> >
> > +       if (swq_has_sleeper(kvm_arch_vcpu_wq(vcpu))) {
> > +               kvm_vcpu_kick(vcpu);
> > +               return;
> > +       }
> > +
> >         if (vcpu != kvm_get_running_vcpu() &&
> >                 !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> >                 kvm_vcpu_kick(vcpu);
> >
> >
> > (latest)
> >
> > @@ -3959,6 +3959,11 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
> >         if (pi_test_and_set_on(&vmx->pi_desc))
> >                 return 0;
> >
> > +       if (rcuwait_active(&vcpu->wait)) {
> > +               kvm_vcpu_kick(vcpu);
> > +               return 0;
> > +       }
> > +
> >         if (vcpu != kvm_get_running_vcpu() &&
> >             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> >                 kvm_vcpu_kick(vcpu);
> >
> > Do you have any suggestions ?
>
> Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.

This was introduced in 5.8-rc1, however, his kernel version is 4.18.

> Can you try running with the below commit?  It's currently sitting in kvm/queue,
> but not marked for stable because I didn't think it was possible for the check
> to a cause a missed wake event in KVM's current code base.
>
> commit 6a8110fea2c1b19711ac1ef718680dfd940363c6
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed Dec 8 01:52:27 2021 +0000
>
>     KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU
>
>     Drop a check that guards triggering a posted interrupt on the currently
>     running vCPU, and more importantly guards waking the target vCPU if
>     triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
>     The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
>     doesn't have a path to ->deliver_posted_interrupt() from asynchronous
>     context, e.g. if apic_timer_expired() were changed to always go down the
>     posted interrupt path for APICv, or if the IN_GUEST_MODE check in
>     kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
>     kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
>     would be scheduled() out without being awakened, i.e. would "miss" the
>     timer interrupt.
>
>     One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
>     context for the current running vCPU should be illegal, but nothing in
>     KVM actually enforces that rules.  There's also no strong obvious benefit
>     to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
>     kvm_vcpu_wake_up() is at worst marginally more costly than querying the
>     current running vCPU.
>
>     Lastly, this aligns the non-nested and nested usage of triggering posted
>     interrupts, and will allow for additional cleanups.
>
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
>     Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>     Message-Id: <20211208015236.1616697-18-seanjc@google.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 38749063da0e..f61a6348cffd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3995,8 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>          * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
>          * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>          */
> -       if (vcpu != kvm_get_running_vcpu() &&
> -           !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> +       if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_wake_up(vcpu);
>
>         return 0;
