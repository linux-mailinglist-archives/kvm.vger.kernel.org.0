Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6935D4C7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 03:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbhDMBY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 21:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbhDMBY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 21:24:28 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E06C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 18:24:09 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id z9so12740771ilb.4
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 18:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUmp65OKga7Fa908vsiFesS/CNcu0CoSYOI2iJ8BVn0=;
        b=mWH1jvzIIsqbQO0VCrMBUeKY1REO7QIAXg2Ahso0oMwbDF7Gp/0EjZvMLUqcQDz0OY
         edT/vE9WE1yOEOP+MnkNV6U96gQeADW0Y36UOZ8YSwn3DWLcTsVAAvLQ7wNCiEiDOWuP
         vt2ZUAPTA6IsVUYbuh6nNXJKBlhlCjXtE2fXPQ4bTnQdEIvJsUspi9n9R+6BYOd7aHnv
         pw6AV6gg/8ldKbGsriPVIP2xtrb/udPEe0HHxfl20R38HhKSspQNeh+Z51rEk8A/hMgM
         abU/0le3+VyFGs7gxcwTieM41JpAU5Me1SqhOZXuoU/Sp0po06Dn+lQlHzupvS+NEQti
         IeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUmp65OKga7Fa908vsiFesS/CNcu0CoSYOI2iJ8BVn0=;
        b=CalhkptQrL5pXWyu65bnqGF1m3ii3Cm/kYUM+tVYFELmL1A9cXsJUYiRpdeFB4tGR8
         dQJJquwcDkCR66dIBYs9e+GmeGin0wWul+jLE02CMYu+AH34QopCLiXt1ZPtAS40hOso
         xg1u6DhhcWirUVsH2Yt5FDqNHQANwPuFpH52Hn81PPZHNm73aN83dTleQPmIRp4w6k26
         kvxoaw3AA4qvWTLIuaavGfSJqsfIb5FKpfNoNm9BaE9/l+KmusnLFa0xJy4tgdKM956v
         0CNRDVJ/o4wvYsysuE+ITDmIIhUh43UbG/8Ol6C1M0vHBwDncMMYkJtRgHAWWWDkG3oR
         MHwg==
X-Gm-Message-State: AOAM530SRgLYeRy93G1sCqBhaxScHQvVVcTYS1zvrGAXRIbAh6Cu00//
        WZPcxMgv/EJuJRr2+xcyeqSy+/qbYx5tf/k7nkyYzQ==
X-Google-Smtp-Source: ABdhPJzwDZOMOYmg6Afacdfp+S385yZo/J1B4fzYR1tYx3UW8QwSYc2S7e02Pwuu4lmET6uOaU/cikaq8jE1zZG5Eaw=
X-Received: by 2002:a05:6e02:12b4:: with SMTP id f20mr24887556ilr.212.1618277048665;
 Mon, 12 Apr 2021 18:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
 <CABayD+cNLdoPHYvw0ZAXZS2wRg4cCFGTMvON0Ja2cWJ4juHNbA@mail.gmail.com>
In-Reply-To: <CABayD+cNLdoPHYvw0ZAXZS2wRg4cCFGTMvON0Ja2cWJ4juHNbA@mail.gmail.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 18:23:32 -0700
Message-ID: <CABayD+c2P9miY2pKG=k1Ey3cj6RZG98WgssLCnBJgoW9Fng7gg@mail.gmail.com>
Subject: Re: [PATCH v12 13/13] x86/kvm: Add kexec support for SEV Live Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 5:22 PM Steve Rutherford <srutherford@google.com> wrote:
>
> On Mon, Apr 12, 2021 at 12:48 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Reset the host's shared pages list related to kernel
> > specific page encryption status settings before we load a
> > new kernel by kexec. We cannot reset the complete
> > shared pages list here as we need to retain the
> > UEFI/OVMF firmware specific settings.
> >
> > The host's shared pages list is maintained for the
> > guest to keep track of all unencrypted guest memory regions,
> > therefore we need to explicitly mark all shared pages as
> > encrypted again before rebooting into the new guest kernel.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index bcc82e0c9779..4ad3ed547ff1 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -39,6 +39,7 @@
> >  #include <asm/cpuidle_haltpoll.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/svm.h>
> > +#include <asm/e820/api.h>
> >
> >  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
> >
> > @@ -384,6 +385,29 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> >          */
> >         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> >                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> > +       /*
> > +        * Reset the host's shared pages list related to kernel
> > +        * specific page encryption status settings before we load a
> > +        * new kernel by kexec. NOTE: We cannot reset the complete
> > +        * shared pages list here as we need to retain the
> > +        * UEFI/OVMF firmware specific settings.
> > +        */
> > +       if (sev_live_migration_enabled & (smp_processor_id() == 0)) {
> What happens if the reboot of CPU0 races with another CPU servicing a
> device request (while the reboot is pending for that CPU)?
> Seems like you could run into a scenario where you have hypercalls racing.
>
> Calling this on every core isn't free, but it is an easy way to avoid this race.
> You could also count cores, and have only last core do the job, but
> that seems more complicated.
On second thought, I think this may be insufficient as a fix, since my
read of kernel/reboot.c seems to imply that devices aren't shutdown
until after these notifiers occur. As such, a single thread might be
able to race with itself. I could be wrong here though.

The heavy hammer would be to disable migration through the MSR (which
the subsequent boot will re-enable).

I'm curious if there is a less "blocking" way of handling kexecs (that
strategy would block LM while the guest booted).

One option that comes to mind would be for the guest to "mute" the
encryption status hypercall after the call to reset the encryption
status. The problem would be that the encryption status for pages
would be very temporarily inaccurate in the window between that call
and the start of the next boot. That isn't ideal, but, on the other
hand, the VM was about to reboot anyway, so a corrupted shared page
for device communication probably isn't super important. Still, I'm
not really a fan of that. This would avoid corrupting the next boot,
which is clearly an improvement.

Each time the kernel boots it could also choose something like a
generation ID, and pass that down each time it calls the hypercall.
This would then let userspace identify which requests were coming from
the subsequent boot.

Everything here (except, perhaps, disabling migration through the MSR)
seems kind of complicated. I somewhat hope my interpretation of
kernel/reboot.c is wrong and this race just is not possible in the
first place.

Steve
> Steve
> > +               int i;
> > +               unsigned long nr_pages;
> > +
> > +               for (i = 0; i < e820_table->nr_entries; i++) {
> > +                       struct e820_entry *entry = &e820_table->entries[i];
> > +
> > +                       if (entry->type != E820_TYPE_RAM)
> > +                               continue;
> > +
> > +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> > +
> > +                       kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > +                                          entry->addr, nr_pages, 1);
> > +               }
> > +       }
> >         kvm_pv_disable_apf();
> >         kvm_disable_steal_time();
> >  }
> > --
> > 2.17.1
> >
