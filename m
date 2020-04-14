Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED811A7649
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436987AbgDNIis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436981AbgDNIir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 04:38:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD28C0A3BDC
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:38:47 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e4so8895097ils.4
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEOfVFGXBuHbfwy1nQNfrAIsJm16d5xsd+q2y8uVaNM=;
        b=YKKuGz+yE+jDl40oZTkwZmrSjo/+wrt4nET81EUE9g2kWh3divrVX/sPKaYM5KiE6s
         bjYACeuiKixil3Gmy2Ntx5p2iOcSRM+V0WHTkgk/OY5byMFLcXmyfzbUBjp8vXMEm8kf
         3BUd/s/ghbrVsYEgYBU3j4rp20nOUlOF+i0cnEVt0qyL0c5fCelnBkWZjaazHGj7Bz1g
         8XVMQRra8uQbS6QQZ3Q0d3AZdxV0M7RhMfjsxf2U5Ehg5JAJY8/K0i/UTifi/M4QtS9R
         Bw2WQLTbxs80SkKXxeIe4hfH/w2g/BItxQFiBGvjiKqHWAamJ4JH1oVWv5dLRdTQaLtM
         qw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEOfVFGXBuHbfwy1nQNfrAIsJm16d5xsd+q2y8uVaNM=;
        b=qONjBawk23Lx17pvKkRPLEs1i/7wXnLTH0j+S5/Ppn4x5IA2WoXqpI2pEnV1gUjFH3
         k0e/3VX0X9ackG54MIhPBwq4txPqiBfVO3k4V5xPFdfkECjk1gx0rC8TcHF68SggtA1M
         wU2DcBrsaAZt98zZhUeU38THWaA7Hxcaf+uJ0/fATnjM2EDiebLh4NhDMZvKtuvsTuUZ
         lqm4iSzI37ekfNf0jxU8G4aYWUU8qwkpvWMTryR4aAckjTb80oJoT/hnCEglkNmhXk+6
         GdEPpeMgUtVQzNYZF3uhfYp/O+XYzJ0s1r420GbGPzB+j+U3CHIgTwdU8LswjHRHseYy
         7s6A==
X-Gm-Message-State: AGi0PuY9AP113A0f7N6PxiL1Tr3tjFxOeBBF/0vyERwD868+pgTKLhSM
        hTynyyiie2hNhZDP9ymzfOtbfM/3hbNWnRxecAU=
X-Google-Smtp-Source: APiQypICtgMefAiQ70FmLd8+Nd1LJ+IyLghRa2ChcH4fkYD3rc4us9kvLL/yAl/GEDEXFbgbbj4Kg2vdQtHc2S0p+30=
X-Received: by 2002:a92:c910:: with SMTP id t16mr21213528ilp.254.1586853526645;
 Tue, 14 Apr 2020 01:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200411153627.3474710-1-ubizjak@gmail.com> <265cb525-6fa7-d1a0-b666-5b17fc590e42@redhat.com>
In-Reply-To: <265cb525-6fa7-d1a0-b666-5b17fc590e42@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 14 Apr 2020 10:38:35 +0200
Message-ID: <CAFULd4Z25D9J2PUJBMx07ubAHnRDuML5bwg6COGmw_uW=L-DKg@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: SVM: Use do_machine_check to pass MCE to the host
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 10:28 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/04/20 17:36, Uros Bizjak wrote:
> > Use do_machine_check instead of INT $12 to pass MCE to the host,
> > the same approach VMX uses.
> >
> > On a related note, there is no reason to limit the use of do_machine_check
> > to 64 bit targets, as is currently done for VMX. MCE handling works
> > for both target families.
> >
> > The patch is only compile tested, for both, 64 and 32 bit targets,
> > someone should test the passing of the exception by injecting
> > some MCEs into the guest.
> >
> > For future non-RFC patch, kvm_machine_check should be moved to some
> > appropriate header file.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 26 +++++++++++++++++++++-----
> >  arch/x86/kvm/vmx/vmx.c |  2 +-
> >  2 files changed, 22 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 061d19e69c73..cd773f6261e3 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -33,6 +33,7 @@
> >  #include <asm/debugreg.h>
> >  #include <asm/kvm_para.h>
> >  #include <asm/irq_remapping.h>
> > +#include <asm/mce.h>
> >  #include <asm/spec-ctrl.h>
> >  #include <asm/cpu_device_id.h>
> >
> > @@ -1839,6 +1840,25 @@ static bool is_erratum_383(void)
> >       return true;
> >  }
> >
> > +/*
> > + * Trigger machine check on the host. We assume all the MSRs are already set up
> > + * by the CPU and that we still run on the same CPU as the MCE occurred on.
> > + * We pass a fake environment to the machine check handler because we want
> > + * the guest to be always treated like user space, no matter what context
> > + * it used internally.
> > + */
> > +static void kvm_machine_check(void)
> > +{
> > +#if defined(CONFIG_X86_MCE)
> > +     struct pt_regs regs = {
> > +             .cs = 3, /* Fake ring 3 no matter what the guest ran on */
> > +             .flags = X86_EFLAGS_IF,
> > +     };
> > +
> > +     do_machine_check(&regs, 0);
> > +#endif
> > +}
> > +
> >  static void svm_handle_mce(struct vcpu_svm *svm)
> >  {
> >       if (is_erratum_383()) {
> > @@ -1857,11 +1877,7 @@ static void svm_handle_mce(struct vcpu_svm *svm)
> >        * On an #MC intercept the MCE handler is not called automatically in
> >        * the host. So do it by hand here.
> >        */
> > -     asm volatile (
> > -             "int $0x12\n");
> > -     /* not sure if we ever come back to this point */
> > -
> > -     return;
> > +     kvm_machine_check();
> >  }
> >
> >  static int mc_interception(struct vcpu_svm *svm)
>
> Looks good, but please move kvm_machine_check() to x86.c instead.

Will do, after the confirmation that the patch works for AMD hosts.

OTOH, the function is just a simple wrapper around do_machine_check,
so I was thinking to move it to a kvm_host.h header as a static
inline. This way, we could save a call to a wrapper function.

Uros.
