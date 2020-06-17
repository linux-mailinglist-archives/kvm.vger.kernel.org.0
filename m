Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA031FD64A
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFQUov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 16:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgFQUor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 16:44:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBC1C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 13:44:46 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id o5so4514551iow.8
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 13:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GZigFg+AvbWNujGJsMBiFE6h4YqhrsYxylqkiIvxC6Y=;
        b=X1vjpckcErcYZOFBeD3lD0I46BbRjMolG6a7xKjeBT7bfg8dOkaADUjJAYsV9y4ZTJ
         HHnZ+fFtWYBxGbN0O+ZovP7PJpvb46/5sUBGtjLMfdUNVkCqZY5dYUEfMP5wQ5qBI9iV
         WCV/8hzXs++H8qExT8KcBLIHOI+5qAzxLG1glOqayRJbgDST0aGjH0qzQLksm+xH8/jP
         pKq7oWQaKMJAbK+Esvg0GnqrKZn73WJs03GLA9FyU9EEoJooP9erSIaJ6oh62pgpKS6H
         xoXJntHSfXQTI+OUVJjadEup7wGIPyFOyCiOGDPRY4IC+jwQY3lXpN3CGwMN2QUqM/9K
         bUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GZigFg+AvbWNujGJsMBiFE6h4YqhrsYxylqkiIvxC6Y=;
        b=BJhhy8LdhVQTUv42ZB7uIgbpSZo/J7x7sXiWlZ/N4TqMAoxwa3s4R+DSMZL02xmERQ
         wzX2MRPzOSgfjEEyp7VTtqobqFdjgrJbvVupdkQ9qOPY6g3FnPRxIVbPWgI1DrOnAu/v
         /Qw7rdMEi8yRSIsv8m2xoYUh1sLWouoEqxwhJNtedFlH/Z6GPBLlR9e3YoYjxoRZwy+C
         gfUcoJt/nsMIYfoi2x/5m+x0eNF9z9mptjZUD8t60r7c3Uw+/wv474XBwhe4ZVh9NtAF
         Um8Fz+i53gmvWLI/PjFpY5JlnNlvgrdBKt/W/c5omzf+2iLVIPK5dQY/iq4FfXS9C9Eu
         ntRg==
X-Gm-Message-State: AOAM533fjU1WzmxFq+Bkh1O3K3ORkr8dP6Glj5MSGO7OehOpKHJN1R12
        BsxZ+S/7TzIVlE7wRDmXcVGQd2LYTZH8jZyXLJtFKQ==
X-Google-Smtp-Source: ABdhPJxU/fCZ3oq1s10ZJ/1fRogcbiXb+m3PjfautY889daNcE2+6CQEmHdwVQ5oYQEm7VevVWhiWrYkB4edNtNHwUI=
X-Received: by 2002:a02:390b:: with SMTP id l11mr1175011jaa.54.1592426685256;
 Wed, 17 Jun 2020 13:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
 <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
 <CALMp9eTxs5nb9Ay0ELVa71cmA9VPzaMSuGgW_iM2tmAVvXs4Pg@mail.gmail.com>
 <0b271987-3168-969d-5f96-ad99e31978fb@amd.com> <9063259c-d87e-4c6e-11d0-d561a1a88989@amd.com>
In-Reply-To: <9063259c-d87e-4c6e-11d0-d561a1a88989@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 17 Jun 2020 13:44:34 -0700
Message-ID: <CALMp9eRdHNKnXh3h6+GzYKaS1gOoZ0DeZxB75foo+Oz_hDw=qg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
To:     Babu Moger <babu.moger@amd.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 11:11 AM Babu Moger <babu.moger@amd.com> wrote:
>
> Jim,
>
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> > Of Babu Moger
> > Sent: Wednesday, June 17, 2020 9:31 AM
> > To: Jim Mattson <jmattson@google.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> > the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paolo
> > Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>;
> > Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.or=
g>;
> > kvm list <kvm@vger.kernel.org>
> > Subject: RE: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> >
> >
> >
> > > -----Original Message-----
> > > From: Jim Mattson <jmattson@google.com>
> > > Sent: Tuesday, June 16, 2020 6:17 PM
> > > To: Moger, Babu <Babu.Moger@amd.com>
> > > Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org=
>;
> > > the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> > > <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> > > Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Paol=
o
> > > Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>=
;
> > > Thomas Gleixner <tglx@linutronix.de>; LKML <linux-kernel@vger.kernel.=
org>;
> > > kvm list <kvm@vger.kernel.org>
> > > Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
> > >
> > > On Tue, Jun 16, 2020 at 3:03 PM Babu Moger <babu.moger@amd.com>
> > wrote:
> > > >
> > > > The new intercept bits have been added in vmcb control
> > > > area to support the interception of INVPCID instruction.
> > > >
> > > > The following bit is added to the VMCB layout control area
> > > > to control intercept of INVPCID:
> > > >
> > > > Byte Offset     Bit(s)          Function
> > > > 14h             2               intercept INVPCID
> > > >
> > > > Add the interfaces to support these extended interception.
> > > > Also update the tracing for extended intercepts.
> > > >
> > > > AMD documentation for INVPCID feature is available at "AMD64
> > > > Architecture Programmer=E2=80=99s Manual Volume 2: System Programmi=
ng,
> > > > Pub. 24593 Rev. 3.34(or later)"
> > > >
> > > > The documentation can be obtained at the links below:
> > > > Link:
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww=
.a
> > >
> > md.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=3D02%7C01%7
> > >
> > Cbabu.moger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8
> > >
> > 961fe4884e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;s
> > >
> > data=3DoRQq0hj0O43A4lnl8JEb%2BHt8oCFHWxcqvLaA1%2BacTJc%3D&amp;reser
> > > ved=3D0
> > > > Link:
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbug=
zilla.
> > >
> > kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=3D02%7C01%7Cbabu.m
> > >
> > oger%40amd.com%7C4cedcb3567194883601e08d8124b6be7%7C3dd8961fe48
> > >
> > 84e608e11a82d994e183d%7C0%7C0%7C637279463210520563&amp;sdata=3DEtA
> > > rCUBB8etloN%2B%2Blx42RZqai12QFvtJefnxBn1ryMQ%3D&amp;reserved=3D0
> > >
> > > Not your change, but this documentation is terrible. There is no
> > > INVLPCID instruction, nor is there a PCID instruction.
> >
> > Sorry about that. I will bring this to their notice.
> >
> > >
> > > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > > > ---
> > > >  arch/x86/include/asm/svm.h |    3 ++-
> > > >  arch/x86/kvm/svm/nested.c  |    6 +++++-
> > > >  arch/x86/kvm/svm/svm.c     |    1 +
> > > >  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
> > > >  arch/x86/kvm/trace.h       |   12 ++++++++----
> > > >  5 files changed, 34 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.=
h
> > > > index 8a1f5382a4ea..62649fba8908 100644
> > > > --- a/arch/x86/include/asm/svm.h
> > > > +++ b/arch/x86/include/asm/svm.h
> > > > @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__))
> > vmcb_control_area {
> > > >         u32 intercept_dr;
> > > >         u32 intercept_exceptions;
> > > >         u64 intercept;
> > > > -       u8 reserved_1[40];
> > > > +       u32 intercept_extended;
> > > > +       u8 reserved_1[36];
> > >
> > > It seems like a more straightforward implementation would simply
> > > change 'u64 intercept' to 'u32 intercept[3].'
> >
> > Sure. Will change it.
>
> This involves much more changes than I originally thought.  All these
> following code needs to be modified. Here is my cscope output for the C
> symbol intercept.
>
> 0 nested.c recalc_intercepts                123 c->intercept =3D h->inter=
cept;
> 1 nested.c recalc_intercepts                135 c->intercept &=3D ~(1ULL =
<<
> INTERCEPT_VINTR);
> 2 nested.c recalc_intercepts                139 c->intercept &=3D ~(1ULL =
<<
> INTERCEPT_VMMCALL);
> 3 nested.c recalc_intercepts                144 c->intercept |=3D g->inte=
rcept;
> 4 nested.c copy_vmcb_control_area           153 dst->intercept =3D
> from->intercept;
> 5 nested.c nested_svm_vmrun_msrpm           186 if
> (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> 6 nested.c nested_vmcb_check_controls 212 if ((control->intercept & (1ULL
> << INTERCEPT_VMRUN)) =3D=3D 0)NIT));
> 7 nested.c nested_svm_vmrun                 436
> nested_vmcb->control.intercept);
> 8 nested.c nested_svm_exit_handled_msr      648 if
> (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_MSR_PROT)))
> 9 nested.c nested_svm_intercept_ioio        675 if
> (!(svm->nested.ctl.intercept & (1ULL << INTERCEPT_IOIO_PROT)))
> a nested.c nested_svm_intercept             732 if
> (svm->nested.ctl.intercept & exit_bits)
> b nested.c nested_exit_on_init              840 return
> (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INIT));
> c svm.c    check_selective_cr0_intercepted 2205 u64 intercept;
> d svm.c    check_selective_cr0_intercepted 2207 intercept =3D
> svm->nested.ctl.intercept;
> e svm.c    check_selective_cr0_intercepted 2210 (!(intercept & (1ULL <<
> INTERCEPT_SELECTIVE_CR0))))
> f svm.c    dump_vmcb                       2803 pr_err("%-20s%016llx\n",
> "intercepts:", control->intercept);
> m svm.c    svm_check_intercept             3687 intercept =3D
> svm->nested.ctl.intercept;
> n svm.c    svm_check_intercept             3689 if (!(intercept & (1ULL <=
<
> INTERCEPT_SELECTIVE_CR0)))
> 6 svm.c    svm_apic_init_signal_blocked    3948
> (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
> 7 svm.h    set_intercept                    300 vmcb->control.intercept |=
=3D
> (1ULL << bit);
> 8 svm.h    clr_intercept                    309 vmcb->control.intercept &=
=3D
> ~(1ULL << bit);
> 9 svm.h    is_intercept tercept_ioio        316 return
> (svm->vmcb->control.intercept & (1ULL << bit)) !=3D 0;
> a svm.h    nested_exit_on_smi               377 return
> (svm->nested.ctl.intercept & (1ULL << INTERCEPT_SMI));
> b svm.h    nested_exit_on_intr              382 return
> (svm->nested.ctl.intercept & (1ULL << INTERCEPT_INTR));
> c svm.h    nested_exit_on_nmi               387 return
> (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
>
> I will have to test extensively if I go ahead with these changes.  What d=
o
> you think?

I see a lot of open-coding of the nested version of is_intercept(),
which would be a good preparatory cleanup.  It also looks like it
might be useful to introduce __set_intercept() and __clr_intercept()
which do the same thing as set_intercept() and clr_intercept(),
without calling recalc_intercepts(), for use *in* recalc_intercepts.
This code needs a little love. While your original proposal is more
expedient, taking the time to fix up the existing mess will be more
beneficial in the long run.
