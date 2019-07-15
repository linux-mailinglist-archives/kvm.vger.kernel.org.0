Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18968367
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 08:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfGOGHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 02:07:05 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34138 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfGOGHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 02:07:05 -0400
Received: by mail-ot1-f66.google.com with SMTP id n5so15780453otk.1;
        Sun, 14 Jul 2019 23:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e/V3fOKAqFz7F8UXbx8aEY6Mof27QH3jzM2T/OFVXo4=;
        b=cNP6KnN2CVYzZklUDMO268TTsTR3Oo0Izc/87Xvc6415jKGeT+RGKSYpKnMoMl8t+7
         kMO7Q+ieZfcTwDV5VCWKZ4SShAqu2x7CWJ8LY/kNEdTr2IVrcXtRlgVCF/xPFOQdsPLX
         j55LJQ0HcEaUs7QG/gzdU/FquOnnCYW9W8yNcB3H8i6Gtuf/RNBXk1IkzXnHTKRNBJbL
         lWI4M3PNZD0TvYHvgyrJYivgHfJVdG+f82WsL8GjLhPJDdJ0ndWaFm6kG1kqtqPc3yMF
         2H+P8E1LRjvuED4LNqSWdOUZflu+Xn43uhi1wpa9MjMAYbuePi4AN//6XbfITpZfKdUd
         +Dvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e/V3fOKAqFz7F8UXbx8aEY6Mof27QH3jzM2T/OFVXo4=;
        b=PIWAt6siy4sZHfm7Zltivy+pqd9REN7MPOCBw9ek/xUWQXVBQIQ1MV1DCAUxYnfqen
         4HGe+wJg7qQSgVjB0R/WiliPnVPQEA/TDk/an8P83Qn506EdRHx8ts8T61P6/7WRb8nF
         EDxscQ4pxiiiG3x3Fnx7ly/VGqY93yXRt3hYewqQvqO0a6DVYpPX1Wy8ZrRHv2nmxXuD
         elhWpH+rE3fr17PQr1ho93tmVBC+4IsGySjQlV5RAtDYmyXyJo/tJ3CbyaTfeICT7V02
         6IF86pwZOm5VhKngGVaEL9TZvhs8TohyU0TKv2iuX/7HhnLIgZ814dkdw6T5TkD83MR8
         QN/A==
X-Gm-Message-State: APjAAAWk+tfIESKiLxmJvV3xpXNmCypcWGHDBiBXJp4bv4WmdvGwKkoZ
        ga8i2k0phviQwU+d7bySmDch+Fj3XdpzhdsIjclFHBF29T8=
X-Google-Smtp-Source: APXvYqzApiSqvTXuZTSRWeHV9EozVFnTRZ81DrkcKPtu4rWfAj+PD4gqULP0rPXSOydUG70DXUf2COjPa1j7OqQImiQ=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr17332980ote.254.1563170824512;
 Sun, 14 Jul 2019 23:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <1562824197-13658-1-git-send-email-jing2.liu@linux.intel.com> <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
In-Reply-To: <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 15 Jul 2019 14:06:56 +0800
Message-ID: <CANRm+CzOp6orH+7sqCQjLuxsYRccfq7H-o4QBcgxGfT-=RaJ-w@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: expose AVX512_BF16 feature to guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 Jul 2019 at 18:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/07/19 07:49, Jing Liu wrote:
> > AVX512 BFLOAT16 instructions support 16-bit BFLOAT16 floating-point
> > format (BF16) for deep learning optimization.
> >
> > Intel adds AVX512 BFLOAT16 feature in CooperLake, which is CPUID.7.1.EA=
X[5].
> >
> > Detailed information of the CPUID bit can be found here,
> > https://software.intel.com/sites/default/files/managed/c5/15/\
> > architecture-instruction-set-extensions-programming-reference.pdf.
> >
> > Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> > ---
> >
> > This patch depends on kernel patch https://lkml.org/lkml/2019/6/19/912
> > and Paolo's patch set https://lkml.org/lkml/2019/7/4/468.
> >
> >  arch/x86/kvm/cpuid.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 8fc6039..0c125dd 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -358,9 +358,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpui=
d_entry2 *entry, int index)
> >               F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP)=
 |
> >               F(MD_CLEAR);
> >
> > +     /* cpuid 7.1.eax */
> > +     const u32 kvm_cpuid_7_1_eax_x86_features =3D
> > +             F(AVX512_BF16);
> > +
> >       switch (index) {
> >       case 0:
> > -             entry->eax =3D 0;
> > +             entry->eax =3D min(entry->eax, 1);
> >               entry->ebx &=3D kvm_cpuid_7_0_ebx_x86_features;
> >               cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
> >               /* TSC_ADJUST is emulated */
> > @@ -384,6 +388,12 @@ static inline void do_cpuid_7_mask(struct kvm_cpui=
d_entry2 *entry, int index)
> >                */
> >               entry->edx |=3D F(ARCH_CAPABILITIES);
> >               break;
> > +     case 1:
> > +             entry->eax &=3D kvm_cpuid_7_1_eax_x86_features;
> > +             entry->ebx =3D 0;
> > +             entry->ecx =3D 0;
> > +             entry->edx =3D 0;
> > +             break;
> >       default:
> >               WARN_ON_ONCE(1);
> >               entry->eax =3D 0;
> >
>
> Queued, thanks.

I see this in kvm/queue:

In file included from ./include/linux/list.h:9:0,
                 from ./include/linux/preempt.h:11,
                 from ./include/linux/hardirq.h:5,
                 from ./include/linux/kvm_host.h:7,
                 from /home/kernel/data/kvm/arch/x86/kvm//cpuid.c:12:
/home/kernel/data/kvm/arch/x86/kvm//cpuid.c: In function =E2=80=98do_cpuid_=
7_mask=E2=80=99:
./include/linux/kernel.h:819:29: warning: comparison of distinct
pointer types lacks a cast
   (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
                             ^
./include/linux/kernel.h:833:4: note: in expansion of macro =E2=80=98__type=
check=E2=80=99
   (__typecheck(x, y) && __no_side_effects(x, y))
    ^
./include/linux/kernel.h:843:24: note: in expansion of macro =E2=80=98__saf=
e_cmp=E2=80=99
  __builtin_choose_expr(__safe_cmp(x, y), \
                        ^
./include/linux/kernel.h:852:19: note: in expansion of macro =E2=80=98__car=
eful_cmp=E2=80=99
 #define min(x, y) __careful_cmp(x, y, <)
                   ^
/home/kernel/data/kvm/arch/x86/kvm//cpuid.c:377:16: note: in expansion
of macro =E2=80=98min=E2=80=99
   entry->eax =3D min(entry->eax, 1);
                ^
