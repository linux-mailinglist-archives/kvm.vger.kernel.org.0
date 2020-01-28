Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6789014C113
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 20:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgA1Tex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 14:34:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34731 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgA1Tew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 14:34:52 -0500
Received: by mail-io1-f68.google.com with SMTP id z193so15778595iof.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 11:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NXRaTtMy+/bHlou9bS+sONKham2s2UJNSMD0pqwnozA=;
        b=HFH6hDAwgxBBkRg3S4Ayog928ndkdxJEz1kHTb01XXXXhwN57NRjpFpiINAcFwvkS/
         kiBT5GcX6BOXljE9UgdwQ7o2VhKRJJVoQIleQHA60mWHObKkU7g08nRu4aD2jt4FEU6f
         lFOthwbF+QBSL7kISFLvaNiUfhAAtwF54pDWypLWtNYUSTVL2dC7YpI6/NvSOtdPvA7s
         TkmDiAWKdWF0yLcxXfxuYTzHwq0fhPWKZvnaURrvO+objQvUG/2Wwdvi6Tug7HPiX/g5
         6i5LSkQ1Mf83jPAmxfcTg5fYVz/TSDMUbOaRCXW7+buPgcAP/Yn1DR7ul5wI1KwmekxQ
         HqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NXRaTtMy+/bHlou9bS+sONKham2s2UJNSMD0pqwnozA=;
        b=AnOxxb0wISD8t/YCHB62UWE6/8KiwANpMDKO+dPobAVu6/ygJ6rQkMJrNEJ7gXgefs
         9uSUXwFRtBMeSK3RKLFXHAyqon+r2wMlBzKEATcwvY/kw+eATSQd4eNmcDu864aCMvk5
         g5OXM+r4V9LZWvn/JZV+JYyZXmRjI0VXeMJBEJ8c15J1mWzBcp0id100d+NDXVzXjmvI
         Kgyf/WM2aTWq5JAkxuPMYZZ2JkZ9wbByj7jkh1/td2OaUmIrDzLJJiez04EtWVpQxKLY
         LQz6C3hkQNc5Odh5ymMFrJJZZyQwX8e9tMVciEbgYKhDbn8xj2cCQQklmJwSczQ3/5NR
         eqrQ==
X-Gm-Message-State: APjAAAXERAkPD/Rlq9qWbj0xq4CXfcXtk+eTAQLwfWStpyc5WH2+TB6L
        dlOgVPaZJBVif0NP3+VF2CREPYTTBdpM4LPb7iiHkg==
X-Google-Smtp-Source: APXvYqzhf5YSVeXPk8zR5NIRfcAhm+5i64ZvK0gOQPIxatwWxiAOpqTuq1+0azplvBZnhYzPitxqgciaWCC8WN4o5FA=
X-Received: by 2002:a5e:8e4c:: with SMTP id r12mr17727455ioo.119.1580240091496;
 Tue, 28 Jan 2020 11:34:51 -0800 (PST)
MIME-Version: 1.0
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com> <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com> <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com> <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
 <20200127205606.GC2523@linux.intel.com> <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
 <20200128183345.GB18652@linux.intel.com> <71E3EDDD-9DEA-43A1-BD77-FD31F10D8DEA@gmail.com>
 <CALMp9eQF_afgLw6vRq8wHQT1kQsVAfz-PcAymVepqD2018d-BA@mail.gmail.com> <961A121B-2572-4FAC-BBD6-30A84D5A4EFD@gmail.com>
In-Reply-To: <961A121B-2572-4FAC-BBD6-30A84D5A4EFD@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jan 2020 11:34:40 -0800
Message-ID: <CALMp9eR2rduf_mKXWfcbQAFysa=i=HGcRhS8iB0bnN_gbjMapA@mail.gmail.com>
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

On Tue, Jan 28, 2020 at 11:03 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jan 28, 2020, at 10:43 AM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Tue, Jan 28, 2020 at 10:42 AM Nadav Amit <nadav.amit@gmail.com> wrot=
e:
> >>> On Jan 28, 2020, at 10:33 AM, Sean Christopherson <sean.j.christopher=
son@intel.com> wrote:
> >>>
> >>> On Tue, Jan 28, 2020 at 09:59:45AM -0800, Jim Mattson wrote:
> >>>> On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
> >>>> <sean.j.christopherson@intel.com> wrote:
> >>>>> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
> >>>>>> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
> >>>>>>>> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> w=
rote:
> >>>>>>>>
> >>>>>>>> If I had to guess, you probably have SMM malware on your host. R=
emove
> >>>>>>>> the malware, and the test should pass.
> >>>>>>>
> >>>>>>> Well, malware will always be an option, but I doubt this is the c=
ase.
> >>>>>>
> >>>>>> Was my innuendo too subtle? I consider any code executing in SMM t=
o be malware.
> >>>>>
> >>>>> SMI complications seem unlikely.  The straw that broke the camel's =
back
> >>>>> was a 1152 cyle delta, presumably the other failing runs had simila=
r deltas.
> >>>>> I've never benchmarked SMI+RSM, but I highly doubt it comes anywher=
e close
> >>>>> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. =
I
> >>>>> wouldn't be surprised if just SMI+RSM is over 1500 cycles.
> >>>>
> >>>> Good point. What generation of hardware are you running on, Nadav?
> >>>
> >>> Skylake.
> >>
> >> Indeed. Thanks for answering on my behalf ;-)
> >>
> >>>>>>> Interestingly, in the last few times the failure did not reproduc=
e. Yet,
> >>>>>>> thinking about it made me concerned about MTRRs configuration, an=
d that
> >>>>>>> perhaps performance is affected by memory marked as UC after boot=
, since
> >>>>>>> kvm-unit-test does not reset MTRRs.
> >>>>>>>
> >>>>>>> Reading the variable range MTRRs, I do see some ranges marked as =
UC (most of
> >>>>>>> the range 2GB-4GB, if I read the MTRRs correctly):
> >>>>>>>
> >>>>>>> MSR 0x200 =3D 0x80000000
> >>>>>>> MSR 0x201 =3D 0x3fff80000800
> >>>>>>> MSR 0x202 =3D 0xff000005
> >>>>>>> MSR 0x203 =3D 0x3fffff000800
> >>>>>>> MSR 0x204 =3D 0x38000000000
> >>>>>>> MSR 0x205 =3D 0x3f8000000800
> >>>>>>>
> >>>>>>> Do you think we should set the MTRRs somehow in KVM-unit-tests? I=
f yes, can
> >>>>>>> you suggest a reasonable configuration?
> >>>>>>
> >>>>>> I would expect MTRR issues to result in repeatable failures. For
> >>>>>> instance, if your VMCS ended up in UC memory, that might slow thin=
gs
> >>>>>> down quite a bit. But, I would expect the VMCS to end up at the sa=
me
> >>>>>> address each time the test is run.
> >>>>>
> >>>>> Agreed on the repeatable failures part, but putting the VMCS in UC =
memory
> >>>>> shouldn't affect this type of test.  The CPU's internal VMCS cache =
isn't
> >>>>> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen =
to be
> >>>>> UC.
> >>>>
> >>>> But the internal VMCS cache only contains selected fields, doesn't i=
t?
> >>>> Uncached fields would have to be written to memory on VM-exit. Or ar=
e
> >>>> all of the mutable fields in the internal VMCS cache?
> >>>
> >>> Hmm.  I can neither confirm nor deny?  The official Intel response to=
 this
> >>> would be "it's microarchitectural".  I'll put it this way: it's in In=
tel's
> >>> best interest to minimize the latency of VMREAD, VMWRITE, VM-Enter an=
d
> >>> VM-Exit.
> >>
> >> I will run some more experiments and get back to you. It is a shame th=
at
> >> every experiment requires a (real) boot=E2=80=A6
> >
> > Yes! It's not just a shame; it's a serious usability issue.
>
> The easy way to run these experiments would have been to use an Intel CRB
> (Customer Reference Board), which boots relatively fast, with an ITP
> (In-Target Probe). This would have simplified testing and debugging
> considerably. Perhaps some sort of PXE-boot would also be beneficial.
> Unfortunately, I do not have the hardware and it does not seem other care
> that much so far.

Not true. I think others do care (I know I do). It's just that bare
metal testing is too hard right now. We need a way to "fire and
forget" the entire test suite and then check a log for failures once
it's done. I'm not suggesting that you do that; I'm just suggesting
that lowering the barrier to bare-metal testing would increase the
likelihood of people doing it.

> Despite the usability issues, running the tests on bare-metal already
> revealed several bugs in KVM (and one SDM issue), which were not apparent
> since the tests were wrong.

I'm not surprised. It's ludicrous that the test results are not
verified on hardware.
