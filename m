Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46879441116
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 22:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJaV62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 17:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhJaV62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 17:58:28 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13CC061714
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 14:55:55 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 205so26342812ljf.9
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 14:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a2i5XTc1KMSXqatxOPSSBXpgpt/T0ryirE2DLf/LEoc=;
        b=Qz0rYF/9NPb60RRIcVAvRpepybf3qQuiBHgGCnQxEIsOHW+4AAM78OhYOJcGxhcwSv
         O9iHjj1HLdSLXkTypIztTbgU+1h/dMrOvHS6jRw6xlaclBfhyvueFORkI08ZjQwk9XIT
         J3LRb5szqeMLEeBLe6TSlR+s+JWyBWEEnomnELObTcU3V0nzRc4FEu1PdGLxqrXIHTHI
         D9lmTyOaFYVrE9Cvb5rtsd5CLJ0cgHMcfXj4AUZspY9ZJZATg2gzoywP4f/w+QBaYTJQ
         HGyKKP7GdxDiZCFkch1uZt5RaqgEnC94q+JB63LCQv2U1Sq3hg8EzOZfGUOoeQbuPZ5f
         JQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a2i5XTc1KMSXqatxOPSSBXpgpt/T0ryirE2DLf/LEoc=;
        b=CO3oNM/Lx7ETxQOTlYREcSsaXJfAJKIDXdVu6745Bj72ShJQkv4p+UIu6CU69wPXkY
         IOCVabvG60+aZqXCgAjBWHPjVjbiCORXcu6mW4M0bVq5uuEqVHdFL10kTCdMtSm71va6
         WvvKlcB4HfXDLz15FKxsVqPMrJwgv7YbLlauRvl+JsPcYG5VVHQocLeaVuKjgbvNNyhT
         ETHYc/kutkOXfcspI0D36+I5dD5qb2rSbcddRxeiQehtUTtG9ORcn2KROXROHNNVo36W
         5vjCHI+i7ED1T0jD1P2rtIqVrBz3ZXJBYUlYyPioSwDltFg9mXS9DETQdr3vOp49P8ZD
         aQHg==
X-Gm-Message-State: AOAM531SXRFvxAKIYD299nIGjygEdn9/2EtRvKRgVDk8tjyA3lRUy//B
        PTpGFYmmxcHm1o5sx3QX777rhASYv5D1D/MwYgQ=
X-Google-Smtp-Source: ABdhPJz34Cq7KTaCUcW0cjWR2BYL22TMTsiS/hnkugusIvDT6PJACvF651W8FCI07oqxhaomnxJL73VEVLQpnsjQy6g=
X-Received: by 2002:a05:651c:22b:: with SMTP id z11mr24501034ljn.36.1635717353788;
 Sun, 31 Oct 2021 14:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211031055634.894263-1-zxwang42@gmail.com> <d6c56f03-1da7-1ebf-1d2e-0ec1aa0b241c@redhat.com>
 <CAA03e5GZ6HnW8uk+2nh_vZcKvtt+wcdVchm4cjRm_yPFC-P7Eg@mail.gmail.com>
In-Reply-To: <CAA03e5GZ6HnW8uk+2nh_vZcKvtt+wcdVchm4cjRm_yPFC-P7Eg@mail.gmail.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Sun, 31 Oct 2021 14:54:00 -0700
Message-ID: <CAEDJ5ZRm6GtH6hL+Y_g7_5O=-GPWrSKu-bpKSf3yWcBuDJEKcg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/7] x86_64 UEFI set up process refactor
 and scripts fixes
To:     Marc Orr <marcorr@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 31, 2021 at 9:14 AM Marc Orr <marcorr@google.com> wrote:
>
> On Sun, Oct 31, 2021 at 12:28 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 31/10/21 06:56, Zixuan Wang wrote:
> > > Hello,
> > >
> > > This patch series refactors the x86_64 UEFI set up process and fixes the
> > > `run-tests.sh` script to run under UEFI. The patches are organized as
> > > three parts.
> > >
> > > The first part (patches 1-2) refactors the x86_64 UEFI set up process.
> > > The previous UEFI setup calls arch-specific setup functions twice and
> > > generates arch-specific data structure. As Andrew suggested [1], we
> > > refactor this process to make only one call to the arch-specific
> > > function and generate arch-neutral data structures. This simplifies the
> > > set up process and makes it easier to develop UEFI support for other
> > > architectures.
> > >
> > > The second part (patch 3) converts several x86 test cases to
> > > Position-Independent Code (PIC) to run under UEFI. This patch is ported
> > > from the initial UEFI support patchset [2] with fixes to the 32-bit
> > > compilation.
> > >
> > > The third part (patches 4-7) fixes the UEFI runner scripts. Patch 4 sets
> > > UEFI OVMF image as readonly. Patch 5 fixes test cases' return code under
> > > UEFI, enabling Patch 6-7 to fix the `run-tests.sh` script under UEFI.
> > >
> > > This patch set is based on the `uefi` branch.
> >
> > Thank you, for patches 1-6 I have squashed the patches when applicable
> > (1, 4, 5, 6) and queued the others (2 and 3).
> >
> > I did not queue patch 7 yet, it seems okay but I want to understand
> > better the changes it needs in the harness and what is missing.  I'll
> > take a look during the week.
>
> SGTM, thank you! Zixuan and I discussed a few things that are missing:
>
> 1. Test cases that take the `-append` arg are currently marked `SKIP`.
> Two issues need to be resolved here. First, we're not using QEMU's
> `-kernel` flag for EFI test cases [1]. And the `-append` flag does not
> work without the `-kernel` flag. I don't understand the details on why
> we don't use the `-kernel` flag myself. Maybe Zixuan can elaborate.
> Second, assuming we fix the first issue, then we need to enlighten the
> KVM-Unit-Tests under UEFI to parse kernel command line arguments and
> pass them down to the test cases via `argv`. Zixuan pointed out to me
> that there is some prior work from Drew [2] that we should be able to
> follow to make this work. So I'm hoping that Zixuan and I can work
> together on solving these issues to get the argument passing working
> next.

Thank you for the detailed summary!

Current kvm-unit-tests pass an EFI binary as part of a disk image,
instead of using the `-kernel` argument.

I just tested the `-kernel` argument and it seems to work with EFI
binaries, and more importantly, it's really fast (bypassing the
default 5-second user input waiting). I will update the `x86/efi/run`
to use `-kernel` argument to pass the EFI binaries.

Since `-kernel` is working, I can start to investigate how to use
`-append` to pass arguments. If that doesn't work well, an alternative
approach could be:

1. (host) create a file `args.txt` in the disk image, which contains
all the arguments needed
2. (guest) call UEFI filesystem interface to read this `args.txt` from
the disk image, parse it and pass the arguments to `main()`

> 2. We need a way to annotate test cases in `x86/unittests.cfg` as
> known to work under SEV. I'm thinking of doing this via new (very
> broad) test groups in `unittests.cfg`. I _think_ SEV is the primary
> scenario we care about. However, folks may care about running the test
> cases under UEFI outside of SEV. For example, last time I checked,
> emulator runs OK under UEFI minus SEV-ES but fails under SEV-ES. And
> similarly, while most test cases work under UEFI minus SEV, there are
> a few that do mis-behave -- and it probably makes sense to document
> this (e.g., via annotations in `unittests.cfg`). Also, there are many
> variations of SEV (SEV, SEV-ES, SEV-SNP)... And hopefully some of this
> will eventually be applicable to TDX as well. So many testgroups is
> not a good solution. I'm not sure.

Adding an `efi` group seems helpful. E.g., the current `x86/smap.c`
does not work under UEFI; but the `run-tests.sh` still tries to run
this test case, even if this test case is not compiled.

> 3. Multi-CPU needs to be made to work under UEFI. For now, patch #7
> forces all EFI test cases to run with 1 vCPU. I chatted with Brijesh,
> and he mentioned that Varad would like to work on this. However, if
> anything here changes, please let me know, because we can work on this
> as well. But for now, I'm not planning to work on it so we can avoid
> duplicating work.
> 4. UEFI runs a lot slower than SEABIOS. It doesn't help that the test
> harness launches QEMU more than once for each test case (i.e., it runs
> the `_NO_FILE_4Uhere_` scenario to check QEMU arguments). I'm not sure
> how much of an issue this is in practice. Depending on the answer, I
> know Zixuan had some ideas on how to speed this up in the current test
> harness. Or maybe we can explore an alternative to the
> `_NO_FILE_4Uhere_` approach instead.

As the `-kernel` argument now works with the EFI binaries and is
significantly faster, this should not be an issue anymore. We just
need to update the runner scripts to use `-kernel` argument.

> Zixuan: Please add/correct anything as needed!
>
> [1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/uefi/x86/run#L42-44
> [2] https://github.com/rhdrjones/kvm-unit-tests/blob/target-efi/scripts/mkefi.sh
>
> Thanks,
> Marc

Best regards,
Zixuan
