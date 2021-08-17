Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1733EE529
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 05:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhHQDmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 23:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhHQDmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 23:42:38 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69902C061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 20:42:06 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t66so21663308qkb.0
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 20:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8kIof70Crrz0dHzhIf9BUFod7GmDQyP0ndWjYnUN6k=;
        b=aRz8TuTbt3IvOedfVRgn8yKMXre2w+MpnaBlunkBmVOnxPvdxGhDET4TzqMl8mqHUg
         iYDsMiG3EtzndnnlXBRF8XxASzirum4S9hbUmHeE6tnafFvzw6PttFH/NS08kOh0ih+R
         vfKD7yWJnY0LhggqecKPD3w1vq8N3t5Tofhm0vnJ2fKkoSsvz4OvEtHTGGN3M1ELjemD
         uoFZYls0sZCkUlYG6fSxNMeLTegiEXPp0zLXOqlQ3MYaeFuEPc293EZDOlGRzhModG9A
         teK+pBcnHjU3ZJZCTxz3KVOz4jvmIXVqIoN1nb39hU0mqT/1+JE2gK6D+ZvctdamIIYR
         8tPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8kIof70Crrz0dHzhIf9BUFod7GmDQyP0ndWjYnUN6k=;
        b=hKAVfpIOtpFT68uFPlWrsCfqtzBDZk2K319oOUVWSz/FgMEMmxI7eK0E+nnD+jveru
         LxVe2zjM7Zc3YzFF6qG9eME8WxtACfuzK1zlKA+ijmaaKLOD7IF7YtlDdNGSozb+6+KG
         1ND3VymtoNAGQIZEtnwNLpd8tf26vmpdKBqqtRV+HaeXALYkU/L686DfQJ4OH+iyQySm
         t+EVi3M0X+pte5n8MkCp+GANRPkZoNr09cCXioaxuqYQwMDS6BTPoJ03SMJ8yW3QVG+e
         BBhLR8DPVCfhmoCTy3BuMWCymLV0KFci8DAB+cHKXye4uMu1JRItiYOqXxRT0t+jrJAS
         zLFw==
X-Gm-Message-State: AOAM532Fdbk2dppybkdlBAC1nn9CC3F0fUGCt7p5fj4hrSQ5WXXxJJAJ
        ulaNwnylc7y8MQmRBkSGNY36XcpsVTcyJZZ/f+jFdw==
X-Google-Smtp-Source: ABdhPJxsUrC7bq7drRK94H9EKA6dxrxXvf4SGJxc2beFTCg6xqw+FNpAfQZ6vCyMpThrk3iT8UzSFqRocXybCpnfZrw=
X-Received: by 2002:a37:45c9:: with SMTP id s192mr1771003qka.21.1629171725266;
 Mon, 16 Aug 2021 20:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com> <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <20210816072629.zbxooxhr3mkxuwbx@gator.home>
In-Reply-To: <20210816072629.zbxooxhr3mkxuwbx@gator.home>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 16 Aug 2021 20:41:53 -0700
Message-ID: <CAA03e5GJO4wzp-bxG=zXJOfjgXCd6ZjEfUi-GPjrxhLmfyiNpQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Andrew Jones <drjones@redhat.com>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 12:26 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
> > On Fri, Jul 2, 2021 at 4:48 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > >
> > > This series brings EFI support to a reduced subset of kvm-unit-tests
> > > on x86_64. I'm sending it out for early review since it covers enough
> > > ground to allow adding KVM testcases for EFI-only environments.
> > >
> > > EFI support works by changing the test entrypoint to a stub entry
> > > point for the EFI loader to jump to in long mode, where the test binary
> > > exits EFI boot services, performs the remaining CPU bootstrapping,
> > > and then calls the testcase main().
> > >
> > > Since the EFI loader only understands PE objects, the first commit
> > > introduces a `configure --efi` mode which builds each test as a shared
> > > lib. This shared lib is repackaged into a PE via objdump.
> > >
> > > Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> > > relocate ELF .dynamic contents.
> > >
> > > Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
> > >
> > > Commit 6 patches out some broken tests for EFI. Testcases that refuse
> > > to build as shared libs are also left disabled, these need some massaging.
> > >
> > > git tree: https://github.com/varadgautam/kvm-unit-tests/commits/efi-stub
> >
> > Thanks for this patchset. My colleague, Zixuan Wang
> > <zixuanwang@google.com>, has also been working to extend
> > kvm-unit-tests to run under UEFI. Our goal is to enable running
> > kvm-unit-tests under SEV-ES.
> >
> > Our approach is a bit different. Rather than pull in bits of the EFI
> > library and Linux EFI ABI, we've elected to build the entire
> > kvm-unit-tests binaries as an EFI app (similar to the ARM approach).
> >
> > To date, we have _most_ x86 test cases (39/44) working under UEFI and
> > we've also got some of the test cases to boot under SEV-ES, using the
> > UEFI #VC handler.
> >
> > We will post our patchset as soon as possible (hopefully by Monday) so
> > that the community can see our approach. We are very eager to see
> > kvm-unit-tests running under SEV-ES (and SNP) and are happy to work
> > with you all on either approach, depending on what the community
> > thinks is the best approach.
> >
> > Thanks in advance,
> > Marc
> >
>
> Hi Marc,
>
> I'm definitely eager to see your approach. I was actually working on
> a second version of EFI support for ARM using the stub approach like
> this series before getting perpetually sidetracked. I've been wanted
> to experiment with Varad's code to continue that, but haven't been
> able to find the time. I'm curious if you considered the stub approach
> as well, but then opted for the app approach in the end. I was
> leaning towards the stub approach to avoid the gnu-efi dependency.

Ack. We never seriously contemplated the stub approach. In hindsight,
I think we were probably biased towards the EFI app approach because
we have some test cases running as UEFI EFI apps internally with great
success (not using the kvm-unit-tests framework though). That being
said, I agree that avoiding the gnu-efi dependency is a win. I also
asked Zixuan, who wrote our patches, if he had an opinion on this. He
said that GNU-EFI provides useful set up code and library functions,
so we do not have to re-implement and debug them in KVM-Unit-Tests.

In any case, we have the patchset ready to post. However, Zixuan ran
into some permission issues when he tried to post the patches because
they are outside of our corporate domain. We'll try to get these
permissions issues fixed up and post the patches tomorrow. If we
cannot get them fixed up, I can always post the patches on his behalf.

Also, we will spend some more time reading Varad's patches this week,
so we can better contrast the stub approach taken by Varad vs. the EFI
app approach that we've taken.

Thanks,
Marc
