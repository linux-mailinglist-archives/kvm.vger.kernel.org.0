Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F5716E43
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 22:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjE3UBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 16:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjE3UBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 16:01:11 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DEAE8
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:01:09 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33baee0235cso3895ab.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685476869; x=1688068869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOgW2DmdPpAa5gxVGXjS+ma4aLYG4S9BuG54lTeIOm0=;
        b=jlAbPq2VKtPtKLOqQdEcwmfJf5DsTcDWL7JREPeRfD5h2d+PTIDrydmk4MmfGq+9oT
         P35Cuq1QCDm+xU3vVvh82DdxhLUTBERA8yLSi0Mwz2++t1sVibtgYBPCW85yRzOrsHy3
         G7lOTvC17x5qzumqRQtC0bCwlQLFKxyZqwTENtu8PayaBuuaAZpVvN0w912GxQS+vEx9
         KEeaEjRinzBWOGPqItNsxASEZAHecdC+UkhWwml9bdU6hZEHzBymfMLccFLtKEPCVHFl
         aHEE9vu9MPe+BYa3NnCXePhQKCtLL6eDARSd/rZrwpS8QXXtqto53FrQ0Ulu+M6FzKfd
         I3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685476869; x=1688068869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOgW2DmdPpAa5gxVGXjS+ma4aLYG4S9BuG54lTeIOm0=;
        b=anemsZT8Wau0uLNTkyP4frcICTBwD+U66JKtje3vaIPqnh+LnznQCukqt7bIHjK6FV
         /lM1QESG0lxG7Ung01DybXXMOtXVD6Kagiukw0/Mx86wqxzZK2nueRqfRCg32nDcyDK+
         PlNTN3m35bTpU/8C4iAeHS6n7gTF8bwD/rb+eZ0p6gwHUP2o+Tur0tqiiHPIpBCz9/kh
         cvIFrcZ2OfSjnSG2cNsmUUHGMluwe6wFUlNCfQEaYvxbsZyb3gS4v88F5+Sn0XfovVPl
         vDkQDEXGaZOWywIjgWBtSQUdGi2NZjxB/Ivxeg15Tq5DOOjnbg7+BtGGJ5fY6m3U+S8p
         g9Kw==
X-Gm-Message-State: AC+VfDwW45NOSsZdbP/dPNCD5WRxPlbP5OU/iGaE+pJ1fp/3dAPFGa3e
        OyRPDCy1bprJ/ga8O9RIJigibGUnJmvDXCacbQWc1Q==
X-Google-Smtp-Source: ACHHUZ7zRW004Pqa4fbvUS9wuvWBXleaORnVrVWL7uDs5GctGak3K26b9kpF74wS50tfBmKhL/MCN368lITTv1zMHLc=
X-Received: by 2002:a92:c56e:0:b0:33b:5343:c1be with SMTP id
 b14-20020a92c56e000000b0033b5343c1bemr18534ilj.29.1685476868683; Tue, 30 May
 2023 13:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZC99f+AO1tZguu1I@google.com> <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com> <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com> <ZG52cgmjgaqY8jvq@google.com>
 <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com>
 <ZG6BrSXDnOdDvUZh@google.com> <CALMp9eQrDX6=gJzybegjzDJ665NCuWmESt-sZrKHcncnuENdpA@mail.gmail.com>
 <ec42501c-2e66-5248-5b97-4827344418f3@gmail.com>
In-Reply-To: <ec42501c-2e66-5248-5b97-4827344418f3@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 May 2023 13:00:57 -0700
Message-ID: <CALMp9eSQWTTGQoJQ+f=ondF2wiiCaMiO-PMV0eaYJNXXrt4gQA@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 7:51=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> On 25/5/2023 5:32 am, Jim Mattson wrote:
> > On Wed, May 24, 2023 at 2:29=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> >>
> >> On Wed, May 24, 2023, Jim Mattson wrote:
> >>> On Wed, May 24, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> >>>>
> >>>> On Wed, Apr 26, 2023, Sandipan Das wrote:
> >>>>> Hi Sean, Like,
> >>>>>
> >>>>> On 4/19/2023 7:11 PM, Like Xu wrote:
> >>>>>>> Heh, it's very much explicable, it's just not desirable, and you =
and I would argue
> >>>>>>> that it's also incorrect.
> >>>>>>
> >>>>>> This is completely inaccurate from the end guest pmu user's perspe=
ctive.
> >>>>>>
> >>>>>> I have a toy that looks like virtio-pmu, through which guest users=
 can get hypervisor performance data.
> >>>>>> But the side effect of letting the guest see the VMRUN instruction=
 by default is unacceptable, isn't it ?
> >>>>>>
> >>>>>>>
> >>>>>>> AMD folks, are there plans to document this as an erratum?=C3=AF=
=C2=BF=C2=BD I agree with Like that
> >>>>>>> counting VMRUN as a taken branch in guest context is a CPU bug, e=
ven if the behavior
> >>>>>>> is known/expected.
> >>>>>>
> >>>>>
> >>>>> This behaviour is architectural and an erratum will not be issued. =
However, for clarity, a future
> >>>>> release of the APM will include additional details like the followi=
ng:
> >>>>>
> >>>>>    1) From the perspective of performance monitoring counters, VMRU=
Ns are considered as far control
> >>>>>       transfers and VMEXITs as exceptions.
> >>>>>
> >>>>>    2) When the performance monitoring counters are set up to count =
events only in certain modes
> >>>>>       through the "OsUserMode" and "HostGuestOnly" bits, instructio=
ns and events that change the
> >>>>>       mode are counted in the target mode. For example, a SYSCALL f=
rom CPL 3 to CPL 0 with a
> >>>>>       counter set to count retired instructions with USR=3D1 and OS=
=3D0 will not cause an increment of
> >>>>>       the counter. However, the SYSRET back from CPL 0 to CPL 3 wil=
l cause an increment of the
> >>>>>       counter and the total count will end up correct. Similarly, w=
hen counting PMCx0C6 (retired
> >>>>>       far control transfers, including exceptions and interrupts) w=
ith Guest=3D1 and Host=3D0, a VMRUN
> >>>>>       instruction will cause an increment of the counter. However, =
the subsequent VMEXIT that occurs,
> >>>>>       since the target is in the host, will not cause an increment =
of the counter and so the total
> >>>>>       count will end up correct.
> >>>>
> >>>> The count from the guest's perspective does not "end up correct".  U=
nlike SYSCALL,
> >>>> where _userspace_ deliberately and synchronously executes a branch i=
nstruction,
> >>>> VMEXIT and VMRUN are supposed to be transparent to the guest and can=
 be completely
> >>>> asynchronous with respect to guest code execution, e.g. if the host =
is spamming
> >>>> IRQs, the guest will see a potentially large number of bogus (from i=
t's perspective)
> >>>> branches retired.
> >>>
> >>> The reverse problem occurs when a PMC is configured to count "CPUID
> >>> instructions retired." Since KVM intercepts CPUID and emulates it, th=
e
> >>> PMC will always read 0, even if the guest executes a tight loop of
> >>> CPUID instructions.
>
> Unlikely. KVM will count any emulated instructions based on kvm_pmu_incr_=
counter().
> Did I miss some conditions ?

That code only increments PMCs configured to count "instructions
retired" and "branch instructions retired." It does not increment PMCs
configured to count "CPUID instructions retired."

> >>>
> >>> The PMU is not virtualizable on AMD CPUs without significant
> >>> hypervisor corrections. I have to wonder if it's really worth the
> >>> effort.
>
> I used to think so, until I saw the AMD64_EVENTSEL_GUESTONLY bit.
> Hardware architects are expected to put more effort into this area.
>
> >>
> >> Per our offlist chat, my understanding is that there are caveats with =
vPMUs that
> >> it's simply not feasible for a hypervisor to handle.  I.e. virtualizin=
g any x86
> >> PMU with 100% accuracy isn't happening anytime soon.
>
> Indeed, and any more detailed complaints ?

Reference cycles unhalted fails to increment outside of guest mode.

SMIs received counts *physical* rather than virtual SMIs

Interrupts taken counts *physical* rather than virtual interrupts taken.

> >>
> >> The way forward is likely to evaluate each caveat on a case-by-case ba=
sis to
> >> determine whether or not the cost of the fixup in KVM is worth the ben=
efit to
> >> the guest.  E.g. emulating "CPUID instructions retired" seems like it =
would be
> >> fairly straightforward.  AFAICT, fixing up the VMRUN stuff is quite di=
fficult though.
> >
> > Yeah. The problem with fixing up "CPUID instructions retired" is
> > tracking what the event encoding is for every F/M/S out there. It's
> > not worth it.
>
> I don't think it's feasible to emulate 100% accuracy on Intel. For guest =
pmu
> users, it is motivated by wanting to know how effective they are running =
on
> the current pCPU, and any vPMU eimulation behavior that helps this
> understanding would be valuable.

But at least Intel has a list of architected events, which are mostly
amenable to virtualization.
