Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B8C2842
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 23:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfI3VIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 17:08:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41193 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732409AbfI3VIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 17:08:24 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so13633804ioj.8
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 14:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=te5DLMfWA8onNH/OLne9dKpTPcg6x4Ky9UphxWzylvw=;
        b=T4vTjQ75Y01t3ZuQQZB6uIpMpoB8+HbO+lprqja2QsgE6m8xCvpfYvXTfj4mBsPtPI
         uXbzSqvg0HjmFw5S7dHFu0VH+jiZanNFjDw9FqJbcJWU6tI4PZ/0yYW79+ZVHDDqd2j4
         sYFzZQCOCoB3B/m9iyKCX/USFn+7bD47wTsCUitsnoCPHsXabSbFa25GuRKanox6Yrdq
         2Nj83szPQ8JFUmqoMuRUzFTqC1WNP34vvwaPAK+9BDPdARAa9D6XvRtzj4z2tP371rZp
         hAvJAnILDqzqmjQk91WH/txyoKC1dcUjiGRxwlxMC6w0E7+f/IqNBj9icaikPYO7Hp0u
         ICgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=te5DLMfWA8onNH/OLne9dKpTPcg6x4Ky9UphxWzylvw=;
        b=Z6OBQZNvbZaxREIZ6xYffN14PPHRvNWaD9lxSlo6qDzd30EzvkLQwT+WBFQ0twPILK
         qLcJ0e2qwDQiE0Fy7fomNZ+bOmvNLKrBAraxLVGO/BMeL7sCYBjbA7Uz1guAcmHd/eOu
         0UafCfSgry7hk/RrRo/ehQiIqoBBJtK6dmXWCAJgd9bTAw4ncvRin1mJJ3oHdzzX4lbR
         a3V2jfJtKZGWsf20wcUgg6akCKMuuy4V3UYSEjH/rHFUZSQ1Go2Cmiqq69BFEG5hObTo
         szV52f7oZhva/bYuA+N47afgsnCNxgEsZi71pK/ALuGoVZm6Q2uagkQDHMg04vdObta5
         mSDg==
X-Gm-Message-State: APjAAAXPcvu35RfyYMuT+l1Ezl6pZn/GgO7RmicQ3TiImQHD5x0o4yuE
        FfjLCcLU5LJi3g1WgN2d9zZbbdHyj4vP9n3EYuBVY/821PP5RQ==
X-Google-Smtp-Source: APXvYqyh5cl7iTKHGju1AEiNOEY1mvnuS/pE37L9S/BwjAy2cS5ALkcQa2vk5F2+u5JX/YYVahjZalo7eMIaf8j0fcs=
X-Received: by 2002:a05:6638:3:: with SMTP id z3mr15548285jao.54.1569871433117;
 Mon, 30 Sep 2019 12:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com> <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
 <20190930175449.GB4084@habkost.net>
In-Reply-To: <20190930175449.GB4084@habkost.net>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 30 Sep 2019 12:23:41 -0700
Message-ID: <CALMp9eR88jE7YV-TmZSSD2oJhEpbsgo-LCgsWHkyFtHcHTmnzw@mail.gmail.com>
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 10:54 AM Eduardo Habkost <ehabkost@redhat.com> wrot=
e:
>
> CCing qemu-devel.
>
> On Tue, Sep 24, 2019 at 01:30:04PM -0700, Jim Mattson wrote:
> > On Wed, Dec 19, 2018 at 1:02 PM Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> > >
> > > On 19/12/18 18:39, Jim Mattson wrote:
> > > > Is this an instruction that kvm has to be able to emulate before it
> > > > can enumerate its existence?
> > >
> > > It doesn't have any operands, so no.
> > >
> > > Paolo
> > >
> > > > On Wed, Dec 19, 2018 at 5:51 AM Robert Hoo <robert.hu@linux.intel.c=
om> wrote:
> > > >>
> > > >> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > >> ---
> > > >>  arch/x86/include/asm/cpufeatures.h | 1 +
> > > >>  arch/x86/kvm/cpuid.c               | 2 +-
> > > >>  2 files changed, 2 insertions(+), 1 deletion(-)
> > > >>
> > > >> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include=
/asm/cpufeatures.h
> > > >> index 28c4a50..932b19f 100644
> > > >> --- a/arch/x86/include/asm/cpufeatures.h
> > > >> +++ b/arch/x86/include/asm/cpufeatures.h
> > > >> @@ -280,6 +280,7 @@
> > > >>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 1=
3 */
> > > >>  #define X86_FEATURE_CLZERO             (13*32+ 0) /* CLZERO instr=
uction */
> > > >>  #define X86_FEATURE_IRPERF             (13*32+ 1) /* Instructions=
 Retired Count */
> > > >> +#define X86_FEATURE_WBNOINVD           (13*32+ 9) /* Writeback an=
d Don't invalid cache */
> > > >>  #define X86_FEATURE_XSAVEERPTR         (13*32+ 2) /* Always save/=
restore FP error pointers */
> > > >>  #define X86_FEATURE_AMD_IBPB           (13*32+12) /* "" Indirect =
Branch Prediction Barrier */
> > > >>  #define X86_FEATURE_AMD_IBRS           (13*32+14) /* "" Indirect =
Branch Restricted Speculation */
> > > >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > >> index cc6dd65..763e115 100644
> > > >> --- a/arch/x86/kvm/cpuid.c
> > > >> +++ b/arch/x86/kvm/cpuid.c
> > > >> @@ -380,7 +380,7 @@ static inline int __do_cpuid_ent(struct kvm_cp=
uid_entry2 *entry, u32 function,
> > > >>
> > > >>         /* cpuid 0x80000008.ebx */
> > > >>         const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
> > > >> -               F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_S=
SBD) |
> > > >> +               F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SS=
BD) | F(VIRT_SSBD) |
> > > >>                 F(AMD_SSB_NO) | F(AMD_STIBP);
> > > >>
> > > >>         /* cpuid 0xC0000001.edx */
> > > >> --
> > > >> 1.8.3.1
> > > >>
> >
> > What is the point of enumerating support for WBNOINVD if kvm is going
> > to implement it as WBINVD?
>
> I expect GET_SUPPORTED_CPUID to return WBNOINVD, because it
> indicates to userspace what is supported by KVM.  Are there any
> expectations that GET_SUPPORTED_CPUID will also dictate what is
> enabled by default in some cases?
>
> In either case, your question applies to QEMU: why do we want
> WBNOINVD to be enabled by "-cpu host" by default and be part of
> QEMU's Icelake-* CPU model definitions?

I had only looked at the SVM implementation of WBNOINVD, which is
exactly the same as the SVM implementation of WBINVD. So, the question
is, "why enumerate WBNOINVD if its implementation is exactly the same
as WBINVD?"

WBNOINVD appears to be only partially documented in Intel document
319433-037, "Intel=C2=AE Architecture Instruction Set Extensions and Future
Features Programming Reference." In particular, there is no
documentation regarding the instruction's behavior in VMX non-root
mode. Does WBNOINVD cause a VM-exit when the VM-execution control,
"WBINVD exiting," is set? If so, does it have the same VM-exit reason
as WBINVD (54), or a different one? If it does have the same VM-exit
reason (a la SVM), how does one distinguish a WBINVD VM-exit from a
WBNOINVD VM-exit? If one can't distinguish (a la SVM), then it would
seem that the VMX implementation also implements WBNOINVD as WBINVD.
If that's the case, the question for VMX is the same as for SVM.
