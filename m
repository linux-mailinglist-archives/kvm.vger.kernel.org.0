Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D221BAECC
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 22:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgD0UIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 16:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgD0UIO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 16:08:14 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7631BC0610D5
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 13:08:14 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q10so18019044ile.0
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 13:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uE7r1bxZarqXZYdCTFoacrsaCwJFjjRY47IcHW3Ejr0=;
        b=Rj6Nz3TrIAG71jOyfWtHE1mX74mHswvj/GOgyily7Wlf61y4QTu2tV2ZfJ30nchDa7
         X4Ie2ztGPLOdImkbnGj6dFQgjTOxD1ErdrzFvCPp3HCQxsAPW4pKOIAFgQ/8j5fcC4Rw
         gQ7swod7CujaRy+E5baGevmVmY0uYrg0WDLXqDAg/73L0r8z/fB8mYpOQz1UqsmcowJA
         IxaEqMQaowR30hRJlgy3AeYpJtV2k7pgYdTd8zKZJ1yyrBKNtPKH3Dmd75497A5Jrq0c
         VywtIKdHYhamPVcXxeHKQS6CBnTAfa0TpnWvXJqbZzIPz5tZDck/qcQDNWR72I90BtJn
         wMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uE7r1bxZarqXZYdCTFoacrsaCwJFjjRY47IcHW3Ejr0=;
        b=psUmSAb9LPY4ry6z95NTXq9422bsqzybX2mZ6kE0Hi6jmcLLG98ssiWoTCPR3cY3yW
         mqojKFKaApsytZRcyYsI8TgjoV9NmJmPAfgu7MOzlpAQzLhdZB8HkFh3DtH7wWgF0L7R
         1u0d6TxBW8P/yncq315LDs8vDke/FLrZWAusiqyrmgKcMd+NeB67TKW+5e4HMX0YYkzu
         tLun/NIdQLC8ENLMADoQQ46iOxlHZ6bF+sMevmDDEbEcCs87XbtMyF507zRAR5BBS8U1
         f5ir3vNQvDlztkK5sEppeBfZiHHSmWipVPCKVlUVbRX8UBAtAV/bWCXCaQ+beLpLt9t4
         jCUQ==
X-Gm-Message-State: AGi0PublAiUKd6m3+eYJUYR97tv+uYetIkX53ccyNYQDizkrmT4WvxYl
        84l78l5gyCTwN4qdfu6AmBISJ8XOaLkkVwvoUcv323vmjMQ=
X-Google-Smtp-Source: APiQypLxfAc2gzjAMf/c1qVFSr7ki3LjwUwo+h6l3xKw9nzhJKauClJIXx9bgho/zXKCwOB5Q5gChg2h1Iey0AzrpRM=
X-Received: by 2002:a92:d186:: with SMTP id z6mr22090929ilz.119.1588018093718;
 Mon, 27 Apr 2020 13:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200426115255.305060-1-ubizjak@gmail.com> <20200427192512.GT14870@linux.intel.com>
In-Reply-To: <20200427192512.GT14870@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 27 Apr 2020 22:08:01 +0200
Message-ID: <CAFULd4bJR0bHCkbHdioBtKCs6=cRyrj8v6XYCezrNLUTf8OwgA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 9:25 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Apr 26, 2020 at 01:52:55PM +0200, Uros Bizjak wrote:
> > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > - use "n" operand constraint instead of "i" and remove
>
> What's the motivation for using 'n'?  The 'i' variant is much more common,
> i.e. less likely to trip up readers.
>
>   $ git grep -E "\"i\"\s*\(" | wc -l
>   768
>   $ git grep -E "\"n\"\s*\(" | wc -l
>   11

When only numerical constants are allowed, "n" should be used, as
demonstrated by the following artificial example:

--cut here--
#define IMM 123

int z;

int
test (void)
{
  __label__ lab;
  __asm__ __volatile__ ("push %0" :: "n"(IMM));
  __asm__ __volatile__ ("push %0" :: "i"(&z));
  __asm__ __volatile__ ("push %0" :: "i"(&&lab));
  return 1;
 lab:
  return 0;
}
--cut here--

changing "i" to "n" will trigger a compiler error in the second and
the third case.

The compiler documentation is a bit unclear here:

'i'
     An immediate integer operand (one with constant value) is allowed.
     This includes symbolic constants whose values will be known only at
     assembly time or later.

'n'
     An immediate integer operand with a known numeric value is allowed.
     Many systems cannot support assembly-time constants for operands
     less than a word wide.  Constraints for these operands should use
     'n' rather than 'i'.

PUSH is able to use "i" here, since the operand is word wide. But, do
we really want to allow symbol references and labels here?

> >   unneeded %c operand modifiers and "$" prefixes
> > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > - use $-16 immediate to align %rsp
>
> Heh, this one depends on the reader, I find 0xfffffffffffffff0 to be much
> more intuitive, though admittedly also far easier to screw up.

I was beaten by this in the past ... but don't want to bikeshed here.

BR,
Uros.

> > - remove unneeded use of __ASM_SIZE macro
> > - define "ss" named operand only for X86_64
> >
> > The patch introduces no functional changes.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c2c6335a998c..7471f1b948b3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6283,13 +6283,13 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> >
> >       asm volatile(
> >  #ifdef CONFIG_X86_64
> > -             "mov %%" _ASM_SP ", %[sp]\n\t"
> > -             "and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
> > -             "push $%c[ss]\n\t"
> > +             "mov %%rsp, %[sp]\n\t"
> > +             "and $-16, %%rsp\n\t"
> > +             "push %[ss]\n\t"
> >               "push %[sp]\n\t"
> >  #endif
> >               "pushf\n\t"
> > -             __ASM_SIZE(push) " $%c[cs]\n\t"
> > +             "push %[cs]\n\t"
> >               CALL_NOSPEC
> >               :
> >  #ifdef CONFIG_X86_64
> > @@ -6298,8 +6298,10 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> >               ASM_CALL_CONSTRAINT
> >               :
> >               [thunk_target]"r"(entry),
> > -             [ss]"i"(__KERNEL_DS),
> > -             [cs]"i"(__KERNEL_CS)
> > +#ifdef CONFIG_X86_64
> > +             [ss]"n"(__KERNEL_DS),
> > +#endif
> > +             [cs]"n"(__KERNEL_CS)
> >       );
> >
> >       kvm_after_interrupt(vcpu);
> > --
> > 2.25.3
> >
