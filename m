Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E5F14C00D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgA1Sns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:43:48 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:47003 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgA1Sns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 13:43:48 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so15579680ioi.13
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 10:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S0yVDKlo40D6IXErayq+yyqlVff2Mz3BxlSQ+ud0Sd4=;
        b=gM3S5FswHdvGhgEEKuQ4Rp3dfpapiMICF/Gvzb2jkVJYtvB3VYjwp/Tg68paewBHrD
         Ndxmqc/d2AF0+52kbRXBCRTzYEvLynNy9nmOv25rQxEkezfDEnSb4cG0P9scrsq07a69
         E2SaZ58+mME0hVCqJYIMh0tS4gQVgY4E1Hvrpk4YXRWWp40VNSR9owuUKjyMNJLWbYZ/
         BL2nYmwYZD6qtRHb+nJ51WBg23IwLJEqBQ5xFZ6Y9BfjtTkiyilVWDPrRkMmJZgkMB4/
         85sqmZGDPVkgDYlxYFwDve2A9GRZteMaiKX7ENRQJG/mVZsgjqGhV1cTD0Gap1U/sm32
         hrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S0yVDKlo40D6IXErayq+yyqlVff2Mz3BxlSQ+ud0Sd4=;
        b=k2amgI4HBAdOl3txchK8jaJDf/ItwTjBjv3E7Z+SplvS7/L2O9yaBJ0CcMPoNiFdB+
         QLJUznzvO9D/fQhGqztNda+hVe4xB3ogy76Hz9opbIdJmrEdN5eM4EA7vx9x+YUWRbNW
         w7Bf8G2j+MN0oDhmwOTlTFgDK3LluhC1yywwPeLJk/HiJidFGLrAuxSENe844OrcJAjX
         G8/LLXKCSEAAdkVdKi94XSrZclQnouekId8CSOYWzNw+dpOxPdtEYEXhEeNeiRwBgrnN
         9TwMc7W+lpcvL//UjY5tnpPcN+NjVj1qVRT4J2xRkRWQo0aHaZq2zlNnDPzWLT1CjVhE
         eCmw==
X-Gm-Message-State: APjAAAUyicvv+B6sQDOcY9no3VnsOKWSnghasUxxyyD8/2HRWOZy4xyz
        XTuCs/aT5PHM3Vt4IKjpTd8/ZHbl0QeKLrIGc4y+HA==
X-Google-Smtp-Source: APXvYqzRGQx0EtAI/w8K6WQDhJIBGounypNc95ex6JioP4JZrGVlSNKotIco7ZnWd3qReRtvHRtJc4o/UULOamYXhTQ=
X-Received: by 2002:a6b:740c:: with SMTP id s12mr19127095iog.108.1580237027205;
 Tue, 28 Jan 2020 10:43:47 -0800 (PST)
MIME-Version: 1.0
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com> <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com> <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com> <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
 <20200127205606.GC2523@linux.intel.com> <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
 <20200128183345.GB18652@linux.intel.com> <71E3EDDD-9DEA-43A1-BD77-FD31F10D8DEA@gmail.com>
In-Reply-To: <71E3EDDD-9DEA-43A1-BD77-FD31F10D8DEA@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jan 2020 10:43:36 -0800
Message-ID: <CALMp9eQF_afgLw6vRq8wHQT1kQsVAfz-PcAymVepqD2018d-BA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 10:42 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jan 28, 2020, at 10:33 AM, Sean Christopherson <sean.j.christopherso=
n@intel.com> wrote:
> >
> > On Tue, Jan 28, 2020 at 09:59:45AM -0800, Jim Mattson wrote:
> >> On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
> >> <sean.j.christopherson@intel.com> wrote:
> >>> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
> >>>> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> wr=
ote:
> >>>>>> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> wro=
te:
> >>>>>>
> >>>>>> If I had to guess, you probably have SMM malware on your host. Rem=
ove
> >>>>>> the malware, and the test should pass.
> >>>>>
> >>>>> Well, malware will always be an option, but I doubt this is the cas=
e.
> >>>>
> >>>> Was my innuendo too subtle? I consider any code executing in SMM to =
be malware.
> >>>
> >>> SMI complications seem unlikely.  The straw that broke the camel's ba=
ck
> >>> was a 1152 cyle delta, presumably the other failing runs had similar =
deltas.
> >>> I've never benchmarked SMI+RSM, but I highly doubt it comes anywhere =
close
> >>> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. I
> >>> wouldn't be surprised if just SMI+RSM is over 1500 cycles.
> >>
> >> Good point. What generation of hardware are you running on, Nadav?
> >
> > Skylake.
>
> Indeed. Thanks for answering on my behalf ;-)
>
> >
> >>>>> Interestingly, in the last few times the failure did not reproduce.=
 Yet,
> >>>>> thinking about it made me concerned about MTRRs configuration, and =
that
> >>>>> perhaps performance is affected by memory marked as UC after boot, =
since
> >>>>> kvm-unit-test does not reset MTRRs.
> >>>>>
> >>>>> Reading the variable range MTRRs, I do see some ranges marked as UC=
 (most of
> >>>>> the range 2GB-4GB, if I read the MTRRs correctly):
> >>>>>
> >>>>>  MSR 0x200 =3D 0x80000000
> >>>>>  MSR 0x201 =3D 0x3fff80000800
> >>>>>  MSR 0x202 =3D 0xff000005
> >>>>>  MSR 0x203 =3D 0x3fffff000800
> >>>>>  MSR 0x204 =3D 0x38000000000
> >>>>>  MSR 0x205 =3D 0x3f8000000800
> >>>>>
> >>>>> Do you think we should set the MTRRs somehow in KVM-unit-tests? If =
yes, can
> >>>>> you suggest a reasonable configuration?
> >>>>
> >>>> I would expect MTRR issues to result in repeatable failures. For
> >>>> instance, if your VMCS ended up in UC memory, that might slow things
> >>>> down quite a bit. But, I would expect the VMCS to end up at the same
> >>>> address each time the test is run.
> >>>
> >>> Agreed on the repeatable failures part, but putting the VMCS in UC me=
mory
> >>> shouldn't affect this type of test.  The CPU's internal VMCS cache is=
n't
> >>> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen to=
 be
> >>> UC.
> >>
> >> But the internal VMCS cache only contains selected fields, doesn't it?
> >> Uncached fields would have to be written to memory on VM-exit. Or are
> >> all of the mutable fields in the internal VMCS cache?
> >
> > Hmm.  I can neither confirm nor deny?  The official Intel response to t=
his
> > would be "it's microarchitectural".  I'll put it this way: it's in Inte=
l's
> > best interest to minimize the latency of VMREAD, VMWRITE, VM-Enter and
> > VM-Exit.
>
> I will run some more experiments and get back to you. It is a shame that
> every experiment requires a (real) boot=E2=80=A6

Yes! It's not just a shame; it's a serious usability issue.
