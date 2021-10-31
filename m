Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5283440F49
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 17:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJaQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 12:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhJaQRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 12:17:10 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486CCC061570
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 09:14:38 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id g125so21443675oif.9
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gM1NYq8tqFljzCysQFVWza8eGeUxnOBuiBailDG0Fxc=;
        b=b6SAZPKifTTyKnSgnq4Lpnz88tGEnWSIH1IclIgZ2wKQio00JDBtZOwQgWZe0ml+JR
         Nnydx47Aujj9AaMLvJuXIQl2qn2M4egxEEEmqOiyDrJfywX8jmN5BOV5yNz8oNFl2eX3
         4SWS7OBeB7AzNMYNXYhAzOhCHtJwjMw9MM2hCsfcn6F7rilvXuZAd4dSMfDTxugDefBT
         RvuF3NZBuBe8sn9GY4HktJrCw3alDfcfuIleOQJJ7mrVf6SVqrkxyeRur0NXtzIB5Cer
         DmwVDfiRSPeXw52BaM7ZBRTQPqIyJbwBArUGTVw6mXVJuWgzGYEf75G3nZitsEq5gM4g
         rtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gM1NYq8tqFljzCysQFVWza8eGeUxnOBuiBailDG0Fxc=;
        b=f62ubRWY7SLno4mxSNg8HP4KwlqMphTK6CdIWH1g6gyNBRrII0lgzYFONhv25kMxzd
         ZE7dtxNiiTvCfT6EI9sbTHlK1WrAYA/5DUuwoes7T19bUkztqLZ8TEeAODPb4nI82RaZ
         0boT5KM/2j13tXGECTg4usXkVS6yUdklC/L5YejXcoodLptKeaWIo9RG70OvB1QZG/Ox
         3k7xBdJS2YqQe4nmVsmfBP/BluBj0oA7S47AfMiY9EvPYq1frlIzN3qu1HMlTcGjz43c
         Acws0VSp/0Gb5PmCG+yN/iIc6mKA37cgOmxY9T6omuOlfKf8ujtL4VQxtJDq2ZPPdmvB
         5OJw==
X-Gm-Message-State: AOAM533HG8yC0r4igCPOOrcoF2jG8mT6OUIHxv/jnL13tDQC63a/xGY2
        ZBMkwKeaTuNU9VRtPq02rQ1j6VjIGOGkqRGWRvAzeg==
X-Google-Smtp-Source: ABdhPJzFa8OvIqPc6FWgR7FHW4Jt2cpZhA/bb19lK9q9biT4dZHkVXaleA8A5NPI8CZmKryW+tViq0w7yWuC1bdVIK8=
X-Received: by 2002:a05:6808:2128:: with SMTP id r40mr14795202oiw.164.1635696876987;
 Sun, 31 Oct 2021 09:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211031055634.894263-1-zxwang42@gmail.com> <d6c56f03-1da7-1ebf-1d2e-0ec1aa0b241c@redhat.com>
In-Reply-To: <d6c56f03-1da7-1ebf-1d2e-0ec1aa0b241c@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sun, 31 Oct 2021 09:14:25 -0700
Message-ID: <CAA03e5GZ6HnW8uk+2nh_vZcKvtt+wcdVchm4cjRm_yPFC-P7Eg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/7] x86_64 UEFI set up process refactor
 and scripts fixes
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 31, 2021 at 12:28 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/10/21 06:56, Zixuan Wang wrote:
> > Hello,
> >
> > This patch series refactors the x86_64 UEFI set up process and fixes the
> > `run-tests.sh` script to run under UEFI. The patches are organized as
> > three parts.
> >
> > The first part (patches 1-2) refactors the x86_64 UEFI set up process.
> > The previous UEFI setup calls arch-specific setup functions twice and
> > generates arch-specific data structure. As Andrew suggested [1], we
> > refactor this process to make only one call to the arch-specific
> > function and generate arch-neutral data structures. This simplifies the
> > set up process and makes it easier to develop UEFI support for other
> > architectures.
> >
> > The second part (patch 3) converts several x86 test cases to
> > Position-Independent Code (PIC) to run under UEFI. This patch is ported
> > from the initial UEFI support patchset [2] with fixes to the 32-bit
> > compilation.
> >
> > The third part (patches 4-7) fixes the UEFI runner scripts. Patch 4 sets
> > UEFI OVMF image as readonly. Patch 5 fixes test cases' return code under
> > UEFI, enabling Patch 6-7 to fix the `run-tests.sh` script under UEFI.
> >
> > This patch set is based on the `uefi` branch.
>
> Thank you, for patches 1-6 I have squashed the patches when applicable
> (1, 4, 5, 6) and queued the others (2 and 3).
>
> I did not queue patch 7 yet, it seems okay but I want to understand
> better the changes it needs in the harness and what is missing.  I'll
> take a look during the week.

SGTM, thank you! Zixuan and I discussed a few things that are missing:

1. Test cases that take the `-append` arg are currently marked `SKIP`.
Two issues need to be resolved here. First, we're not using QEMU's
`-kernel` flag for EFI test cases [1]. And the `-append` flag does not
work without the `-kernel` flag. I don't understand the details on why
we don't use the `-kernel` flag myself. Maybe Zixuan can elaborate.
Second, assuming we fix the first issue, then we need to enlighten the
KVM-Unit-Tests under UEFI to parse kernel command line arguments and
pass them down to the test cases via `argv`. Zixuan pointed out to me
that there is some prior work from Drew [2] that we should be able to
follow to make this work. So I'm hoping that Zixuan and I can work
together on solving these issues to get the argument passing working
next.
2. We need a way to annotate test cases in `x86/unittests.cfg` as
known to work under SEV. I'm thinking of doing this via new (very
broad) test groups in `unittests.cfg`. I _think_ SEV is the primary
scenario we care about. However, folks may care about running the test
cases under UEFI outside of SEV. For example, last time I checked,
emulator runs OK under UEFI minus SEV-ES but fails under SEV-ES. And
similarly, while most test cases work under UEFI minus SEV, there are
a few that do mis-behave -- and it probably makes sense to document
this (e.g., via annotations in `unittests.cfg`). Also, there are many
variations of SEV (SEV, SEV-ES, SEV-SNP)... And hopefully some of this
will eventually be applicable to TDX as well. So many testgroups is
not a good solution. I'm not sure.
3. Multi-CPU needs to be made to work under UEFI. For now, patch #7
forces all EFI test cases to run with 1 vCPU. I chatted with Brijesh,
and he mentioned that Varad would like to work on this. However, if
anything here changes, please let me know, because we can work on this
as well. But for now, I'm not planning to work on it so we can avoid
duplicating work.
4. UEFI runs a lot slower than SEABIOS. It doesn't help that the test
harness launches QEMU more than once for each test case (i.e., it runs
the `_NO_FILE_4Uhere_` scenario to check QEMU arguments). I'm not sure
how much of an issue this is in practice. Depending on the answer, I
know Zixuan had some ideas on how to speed this up in the current test
harness. Or maybe we can explore an alternative to the
`_NO_FILE_4Uhere_` approach instead.

Zixuan: Please add/correct anything as needed!

[1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/uefi/x86/run#L42-44
[2] https://github.com/rhdrjones/kvm-unit-tests/blob/target-efi/scripts/mkefi.sh

Thanks,
Marc
