Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F7D3BEC73
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhGGQp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 12:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhGGQpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 12:45:25 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFF8C061762
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 09:42:44 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so2809519otq.11
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGs8qC7yLeuU76aGHT+b9/9uNPRLJI8gTxSyotZUZjQ=;
        b=ulqDE9XePT0F3X1rxoUkPWYmj/cjMwrSpkBWRNe6WgiTfaJW/vXMef8qiVm4PydT4M
         jbH39id9qamVcenVkkU3LeJWCriDFwFdPEDgjjS/jH8FbNRapZZOavwTz+8vjvPMKYai
         ee5TcQDOeoV2RAyE0sTUpqCNMFI7LpO7vyQ5DPYWTmFw6BehRCEknNp3jMKpUG3He1wY
         z0yGFQC4J0szM/5KLyN1KSfwvCe7YC6gYJBOLqpqf64LE3MwloxNKpcNkr+oVpFYFmMA
         mtFZxq6hgdQaQaKQKoy+QB5/J2IKaJvcDNPOESZeLDQXVmPo39QEhvj5Vlm3UZG80JcE
         Ejow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGs8qC7yLeuU76aGHT+b9/9uNPRLJI8gTxSyotZUZjQ=;
        b=iv5RAzAKsJJgSGvTbRYZ7HXNqf3l3LBMuY0wtmJnrjvgshVmxfYZl5Qd0BGR+9kZvT
         F4AKTd2S2kqGYpbsVSgYOKmFJRm0f4H0Je5ikJlcWkEqhamj/jD6dgEz2NKwgX5vzL1d
         t1unKRBk46zbUiygVmS8mm8THMWhqgEuNYYFqyfh7o9qnRQbK1AzWETZ5NFZ8H9Lz1OV
         BQ2YuopWRaHFHm4Iw/tr3Ieh0a32n1mjTiJEsMAq5UMEO95ZFMWv6rgIwJL5hQZO6HhW
         u9hwGW0IdK6POStFFdvVnsuELIgYtYGAIvBAVZwxuPlShXdv6no7S86a/FuymhW/Ku1/
         xqyw==
X-Gm-Message-State: AOAM531l6kadFTKpoG8HX5BKSGo0Kn4YlHDbfCMidxhSBvNdAj07hgg6
        wRZX/dYJHVeOHAh+89/pvwlVamPzTAmmhM0yaqwEIg==
X-Google-Smtp-Source: ABdhPJxV/BWpTieutmD1GHOrCDI3SB0Memv132JxXJ8jgEqQapcXhpkMcicwRomyQ3PoTY61I19Y36tPpb8y777naR4=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr20870914oth.241.1625676163750;
 Wed, 07 Jul 2021 09:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.2d906c322f72ec1420955136ebaa7a4c5073917c.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <de6b97a567e273adff1f5268998692bad548aa10.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <20210706195233.h6w4cm73oktfqpgz@habkost.net> <4cc2c5fe-2153-05c5-dedd-8cb650753740@redhat.com>
 <CAOpTY_qdbbnauTkbjkz+cZmo8=Hz6qqLNY6i6uamqhcty=Q1sw@mail.gmail.com>
 <671be35f-220a-f583-aa31-3a2da7dae93a@redhat.com> <CAOpTY_paTO=xqfGXPCC2Paty5ptJ6Dqpo4Tzb4C2hrO_t=vS8w@mail.gmail.com>
In-Reply-To: <CAOpTY_paTO=xqfGXPCC2Paty5ptJ6Dqpo4Tzb4C2hrO_t=vS8w@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 7 Jul 2021 09:42:26 -0700
Message-ID: <CALMp9eSJyvU1=FndZyR+hZMtKPWwgibKisBqp0Xcx4jxjrWn2w@mail.gmail.com>
Subject: Re: [PATCH 4/4] x86/tsx: Add cmdline tsx=fake to not clear CPUID bits
 RTM and HLE
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Victor Ding <victording@google.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Anand K Mistry <amistry@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, Jiri Denemark <jdenemar@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Michal Privoznik <mprivozn@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 8:09 AM Eduardo Habkost <ehabkost@redhat.com> wrote:
>
> CCing libvir-list, Jiri Denemark, Michal Privoznik, so they are aware
> that the definition of "supported CPU features" will probably become a
> bit more complex in the future.

Has there ever been a clear definition? Family, model, and stepping,
for instance: are these the only values supported? That would make
cross-platform migration impossible. What about the vendor string? Is
that the only value supported? That would make cross-vendor migration
impossible. For the maximum input value for basic CPUID information
(CPUID.0H:EAX), is that the only value supported, or is it the maximum
value supported? On the various individual feature bits, does a '1'
imply that '0' is also supported, or is '1' the only value supported?
What about the feature bits with reversed polarity (e.g.
CPUID.(EAX=07H,ECX=0):EBX.FDP_EXCPTN_ONLY[bit 6])?

This API has never made sense to me. I have no idea how to interpret
what it is telling me.

> On Tue, Jul 6, 2021 at 5:58 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 06/07/21 23:33, Eduardo Habkost wrote:
> > > On Tue, Jul 6, 2021 at 5:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >> It's a bit tricky, because HLE and RTM won't really behave well.  An old
> > >> guest that sees RTM=1 might end up retrying and aborting transactions
> > >> too much.  So I'm not sure that a QEMU "-cpu host" guest should have HLE
> > >> and RTM enabled.
> > >
> > > Is the purpose of GET_SUPPORTED_CPUID to return what is supported by
> > > KVM, or to return what "-cpu host" should enable by default? They are
> > > conflicting requirements in this case.
> >
> > In theory there is GET_EMULATED_CPUID for the former, so it should be
> > the latter.  In practice neither QEMU nor Libvirt use it; maybe now we
> > have a good reason to add it, but note that userspace could also check
> > host RTM_ALWAYS_ABORT.
> >
> > > Returning HLE=1,RTM=1 in GET_SUPPORTED_CPUID makes existing userspace
> > > take bad decisions until it's updated.
> > >
> > > Returning HLE=0,RTM=0 in GET_SUPPORTED_CPUID prevents existing
> > > userspace from resuming existing VMs (despite being technically
> > > possible).
> > >
> > > The first option has an easy workaround that doesn't require a
> > > software update (disabling HLE/RTM in the VM configuration). The
> > > second option doesn't have a workaround. I'm inclined towards the
> > > first option.
> >
> > The default has already been tsx=off for a while though, so checking
> > either GET_EMULATED_CPUID or host RTM_ALWAYS_ABORT in userspace might
> > also be feasible for those that are still on tsx=on.
>
> This sounds like a perfect use case for GET_EMULATED_CPUID. My only
> concern is breaking existing userspace.
>
> But if this was already broken for a few kernel releases due to
> tsx=off being the default, maybe GET_EMULATED_CPUID will be a
> reasonable approach.
>
> --
> Eduardo
>
