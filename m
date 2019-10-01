Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955EAC36F2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 16:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388973AbfJAOU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 10:20:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41924 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfJAOU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 10:20:27 -0400
Received: by mail-io1-f65.google.com with SMTP id n26so19855584ioj.8
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 07:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D/xSwAO+ZHPX/90H8l9qiIZ/X2lvmU5qlfHvvHmawI8=;
        b=SghKJhyuubfUZGba9D/J3HbXP788J5my0wVH+70DG65wZCi0tD81arck0qSRRFOc5p
         ROa9DY+5OQiLSKDAWgz9ZxOOuqyecT5SZbjarSpZVJMrrdM2v5xstDXZM6r6LEQTSsy/
         JpL8w/eYqsOdhP5mA84yBexYXyNIQwHqIwjzkfoca8hTjwFuedCv0SB33LDnjB9km3Wu
         pgCtd4C6zReX7mKSHIBbt8fgv6+5j8aPfNLW+RRBBo3nndV+5oiGzjypuYfC3EIw9lb1
         sdQioFkHVeVershGm9BJ9HH37tou059WCQ7erjx2tv9vmrk0z2lCyIN2US01DrdWmPT5
         Ls2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D/xSwAO+ZHPX/90H8l9qiIZ/X2lvmU5qlfHvvHmawI8=;
        b=lP43PGEPhgEi3hZdHwI47XRt3Ae6LPF59kWeiv7L/f6dPdAkl96N7mhqsQs2dfkJOl
         Na8gOBh5CMi2NOpvd50aWhUqB2Ih8+A5DRn+5zYzXJl1ftzsfBr5h8OSj3siHaIz3GA/
         xGkGZJ7m9UiraAAgkjgFOFdthzdZwR4LWVrgw/hNQLVbXHe8bzqg4fbLrRJ4wGCOXsOq
         /VGDNxUx6ENWGnjyaPRYcaf8QB2yzkkHrFW06vVlQPgOEHKZqEoX90qe+VtOrOQkSrSM
         eSDMs/Y0Yj43jHY3rgUYzb/ywjynofI/we4lUv0tqXbRz+gFALyTrHK7NZn4IwtJITNu
         2XmQ==
X-Gm-Message-State: APjAAAXi7jFM7T0MYlTFcUPQGEpGaVgWvjdwSGvtRPBI5jiFI+I+gq4n
        Be4taUqeGF8Ch3Ikjr37TGweWlNGO5/+jVKNr7eCYg==
X-Google-Smtp-Source: APXvYqxcvuQbyQ2lsmmk9D+terHcutbpXWHXy3e3XC8Gq2nJlGu4QIv5X/u+eSgAAB6aXCYaaTBZIAtbRCY3Lz4mxfI=
X-Received: by 2002:a92:5ad1:: with SMTP id b78mr26611534ilg.118.1569939625754;
 Tue, 01 Oct 2019 07:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com> <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
 <20190930175449.GB4084@habkost.net> <CALMp9eR88jE7YV-TmZSSD2oJhEpbsgo-LCgsWHkyFtHcHTmnzw@mail.gmail.com>
 <9bbe864ab8fb16d9e64745b930c89b1db24ccc3a.camel@intel.com>
In-Reply-To: <9bbe864ab8fb16d9e64745b930c89b1db24ccc3a.camel@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 07:20:17 -0700
Message-ID: <CALMp9eSe_7on+F=ng05DkvvBpnWhSirEpSVz9Bua4Sy606xJnw@mail.gmail.com>
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 5:45 PM Huang, Kai <kai.huang@intel.com> wrote:
>
> On Mon, 2019-09-30 at 12:23 -0700, Jim Mattson wrote:
> > On Mon, Sep 30, 2019 at 10:54 AM Eduardo Habkost <ehabkost@redhat.com> =
wrote:
> > > CCing qemu-devel.
> > >
> > > On Tue, Sep 24, 2019 at 01:30:04PM -0700, Jim Mattson wrote:
> > > > On Wed, Dec 19, 2018 at 1:02 PM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> > > > > On 19/12/18 18:39, Jim Mattson wrote:
> > > > > > Is this an instruction that kvm has to be able to emulate befor=
e it
> > > > > > can enumerate its existence?
> > > > >
> > > > > It doesn't have any operands, so no.
> > > > >
> > > > > Paolo
> > > > >
> > > > > > On Wed, Dec 19, 2018 at 5:51 AM Robert Hoo <robert.hu@linux.int=
el.com>
> > > > > > wrote:
> > > > > > > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > > > > > ---
> > > > > > >  arch/x86/include/asm/cpufeatures.h | 1 +
> > > > > > >  arch/x86/kvm/cpuid.c               | 2 +-
> > > > > > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/arch/x86/include/asm/cpufeatures.h
> > > > > > > b/arch/x86/include/asm/cpufeatures.h
> > > > > > > index 28c4a50..932b19f 100644
> > > > > > > --- a/arch/x86/include/asm/cpufeatures.h
> > > > > > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > > > > > @@ -280,6 +280,7 @@
> > > > > > >  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), w=
ord 13
> > > > > > > */
> > > > > > >  #define X86_FEATURE_CLZERO             (13*32+ 0) /* CLZERO
> > > > > > > instruction */
> > > > > > >  #define X86_FEATURE_IRPERF             (13*32+ 1) /* Instruc=
tions
> > > > > > > Retired Count */
> > > > > > > +#define X86_FEATURE_WBNOINVD           (13*32+ 9) /* Writeba=
ck and
> > > > > > > Don't invalid cache */
> > > > > > >  #define X86_FEATURE_XSAVEERPTR         (13*32+ 2) /* Always
> > > > > > > save/restore FP error pointers */
> > > > > > >  #define X86_FEATURE_AMD_IBPB           (13*32+12) /* "" Indi=
rect
> > > > > > > Branch Prediction Barrier */
> > > > > > >  #define X86_FEATURE_AMD_IBRS           (13*32+14) /* "" Indi=
rect
> > > > > > > Branch Restricted Speculation */
> > > > > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > > > > index cc6dd65..763e115 100644
> > > > > > > --- a/arch/x86/kvm/cpuid.c
> > > > > > > +++ b/arch/x86/kvm/cpuid.c
> > > > > > > @@ -380,7 +380,7 @@ static inline int __do_cpuid_ent(struct
> > > > > > > kvm_cpuid_entry2 *entry, u32 function,
> > > > > > >
> > > > > > >         /* cpuid 0x80000008.ebx */
> > > > > > >         const u32 kvm_cpuid_8000_0008_ebx_x86_features =3D
> > > > > > > -               F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) |
> > > > > > > F(VIRT_SSBD) |
> > > > > > > +               F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) |
> > > > > > > F(AMD_SSBD) | F(VIRT_SSBD) |
> > > > > > >                 F(AMD_SSB_NO) | F(AMD_STIBP);
> > > > > > >
> > > > > > >         /* cpuid 0xC0000001.edx */
> > > > > > > --
> > > > > > > 1.8.3.1
> > > > > > >
> > > >
> > > > What is the point of enumerating support for WBNOINVD if kvm is goi=
ng
> > > > to implement it as WBINVD?
> > >
> > > I expect GET_SUPPORTED_CPUID to return WBNOINVD, because it
> > > indicates to userspace what is supported by KVM.  Are there any
> > > expectations that GET_SUPPORTED_CPUID will also dictate what is
> > > enabled by default in some cases?
> > >
> > > In either case, your question applies to QEMU: why do we want
> > > WBNOINVD to be enabled by "-cpu host" by default and be part of
> > > QEMU's Icelake-* CPU model definitions?
> >
> > I had only looked at the SVM implementation of WBNOINVD, which is
> > exactly the same as the SVM implementation of WBINVD. So, the question
> > is, "why enumerate WBNOINVD if its implementation is exactly the same
> > as WBINVD?"
> >
> > WBNOINVD appears to be only partially documented in Intel document
> > 319433-037, "Intel=C2=AE Architecture Instruction Set Extensions and Fu=
ture
> > Features Programming Reference." In particular, there is no
> > documentation regarding the instruction's behavior in VMX non-root
> > mode. Does WBNOINVD cause a VM-exit when the VM-execution control,
> > "WBINVD exiting," is set? If so, does it have the same VM-exit reason
> > as WBINVD (54), or a different one? If it does have the same VM-exit
> > reason (a la SVM), how does one distinguish a WBINVD VM-exit from a
> > WBNOINVD VM-exit? If one can't distinguish (a la SVM), then it would
> > seem that the VMX implementation also implements WBNOINVD as WBINVD.
> > If that's the case, the question for VMX is the same as for SVM.
>
> Unfortunately WBNOINVD interaction with VMX has not been made to public y=
et. I
> am reaching out internally to see when it can be done. I agree it may not=
 be
> necessary to expose WBNOINVD if its implementation is exactly the same as
> WBINVD, but it also doesn't have any harm, right?

If nested VMX changes are necessary to be consistent with hardware,
then enumerating WBNOINVD support in the guest CPUID information at
this time--without the attendant nested VMX changes--is premature. No
changes to nested SVM are necessary, so it's fine for AMD systems.

If no changes to nested VMX are necessary, then it is true that
WBNOINVD can be emulated by WBINVD. However, it provides no value to
specifically enumerate the instruction.

If there is some value that I'm missing, then why make guest support
for the instruction contingent on host support for the instruction?
KVM can implement WBNOINVD as WBINVD on any host with WBINVD,
regardless of whether or not the host supports WBNOINVD.

> Thanks,
> -Kai
