Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC42E10EF
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgLWA4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 19:56:10 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:48705 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbgLWA4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 19:56:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id EA3045DD;
        Tue, 22 Dec 2020 19:55:22 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Tue, 22 Dec 2020 19:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=6kFEE3GwaATWThh1+0jLcDB4KLvAh5H
        UDoc98c2gT9U=; b=dW3tm6LhScmUgVyTU7IoYbI5gFQ3sCGtH/YmCLfsoA0YUpI
        vsKQPpAhojrCeOslShbXMPl2wwR5dd4/GqxIQ9ea2++KzkA6gRNVrw0aatik1iJS
        6SoaVOVaUP+piSyU84T2aFdJb7xIXoOc5ll1FWA3Dc6vkGs8yqGEubZI4fwIpyCh
        xrdMwxfxDoug36PjkNbcYhSgHMIDv3Ml8srru+BPe/t8UzQ55yGnghDWzqYF33HT
        gbl4QEl24gvfEpz72bYuYQCblle0D074X349EBQV5USlAOEkPXrkRWA1QvIaQEQx
        JHgHhNyNkFl0DaU3HE+AzPgVqwopU43FowGG2hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6kFEE3
        GwaATWThh1+0jLcDB4KLvAh5HUDoc98c2gT9U=; b=bRnY0omdHjnqef1MZqoOK/
        sxOaLff+bJcJFbo7BYR3SFXVC2Y7C5bkjrC9loneA/naVJ3XSsv4IU5GKHk3j8vd
        72/QXwE0P663Ynbsu4LEMyuHqYx+BJM59aEQbCpW+PkAiAd0ri9K5qUEveABFFXr
        RJIvalGLCut8pnZarHy/D3wqCA4GNZxcsJOkM6Nij2+G9qRrm8gq2X46/SryAill
        VUBaXIcJWnpWKUuLyrnidZTsmBaItM+PCMhJbpKbOmh9XfG0o25z66u2z4Gn2z2c
        PWDN/SiGFOrz1Z657d10QinGc+7Imda/K3YYpb0OLaFL+aXOvtMBRhVjKrqhlNJQ
        ==
X-ME-Sender: <xms:d5XiXyOk4v37zLU-KCvnKQfzI00IINWyAK3NnKh88JHz9jH3mY_ZGw>
    <xme:d5XiXw9xMascvpNzhyKzFBMxCi0hAvNJZhszj89R3B0xl0JB78xpF-nKiezoJ4pt5
    ZdlComtmgdy7FFAk-I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddthedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdflihgr
    gihunhcujggrnhhgfdcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpeeliefhjeffhfejffetveevvdehvefftdejveethedtgffh
    gffghedvudefuedvveenucffohhmrghinhepphgrthgthhgvfidrohhrghdpghhithhhuh
    gsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:d5XiX5T11IL4W6EIKLLpOCpUkBXmkEBIrsSR7XICVxrQsMhU-pBe0A>
    <xmx:d5XiXyv0ogq4EmLPE1CUO8oP52FsUq0bRWgXUqZusw3tkLTu4W047w>
    <xmx:d5XiX6dcqIzrk_11BBsPU9o-mOkt3j1nV5xS1genLet6CIFStwe6Jg>
    <xmx:eZXiXx8Y2iQMPUChrMLR1IeHbUNPxFhKtDRYz-IRfx-Y5IzQK0KjlpmljMzw24PePJ1jVA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 03F49C200A5; Tue, 22 Dec 2020 19:55:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.1-61-gb52c239-fm-20201210.001-gb52c2396
Mime-Version: 1.0
Message-Id: <805db597-032a-4afd-a500-338c25bdecb8@www.fastmail.com>
In-Reply-To: <431a4029-afdf-9a31-ba9a-ebfeef24faaa@redhat.com>
References: <160851280526.21294.6201442635975331015@600e7e483b3a>
 <1389d6d1-33fe-46cc-b03c-f2a40e03853b@www.fastmail.com>
 <431a4029-afdf-9a31-ba9a-ebfeef24faaa@redhat.com>
Date:   Wed, 23 Dec 2020 08:54:57 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     "Wainer dos Santos Moschetta" <wainersm@redhat.com>,
        qemu-devel@nongnu.org
Cc:     kwolf@redhat.com, fam@euphon.net, thuth@redhat.com,
        kvm@vger.kernel.org, viktor.prutyanov@phystech.edu,
        lvivier@redhat.com, alex.bennee@linaro.org, alistair@alistair23.me,
        groug@kaod.org, mreitz@redhat.com, qemu-ppc@nongnu.org,
        "Paolo Bonzini" <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        david@gibson.dropbear.id.au
Subject: Re: [PATCH 0/9] Alpine Linux build fix and CI pipeline
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Dec 23, 2020, at 2:41 AM, Wainer dos Santos Moschetta wrote:
> Hi,
> 
> On 12/21/20 5:25 AM, Jiaxun Yang wrote:
> >
> > On Mon, Dec 21, 2020, at 9:06 AM, no-reply@patchew.org wrote:
> >> Patchew URL:
> >> https://patchew.org/QEMU/20201221005318.11866-1-jiaxun.yang@flygoat.com/
> >>
> >>
> >>
> >> Hi,
> >>
> >> This series seems to have some coding style problems. See output below for
> >> more information:
> >>
> >> Type: series
> >> Message-id: 20201221005318.11866-1-jiaxun.yang@flygoat.com
> >> Subject: [PATCH 0/9] Alpine Linux build fix and CI pipeline
> >>
> >> === TEST SCRIPT BEGIN ===
> >> #!/bin/bash
> >> git rev-parse base > /dev/null || exit 0
> >> git config --local diff.renamelimit 0
> >> git config --local diff.renames True
> >> git config --local diff.algorithm histogram
> >> ./scripts/checkpatch.pl --mailback base..
> >> === TEST SCRIPT END ===
> >>
> >> Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
> >>  From https://github.com/patchew-project/qemu
> >>   * [new tag]
> >> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com ->
> >> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com
> >> Switched to a new branch 'test'
> >> 10095a9 gitlab-ci: Add alpine to pipeline
> >> a177af3 tests: Rename PAGE_SIZE definitions
> >> 5fcb0ed accel/kvm: avoid using predefined PAGE_SIZE
> >> e7febdf hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
> >> ba307d5 elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
> >> 0ccf92b libvhost-user: Include poll.h instead of sys/poll.h
> >> 41a10db configure/meson: Only check sys/signal.h on non-Linux
> >> 0bcd2f2 configure: Add sys/timex.h to probe clk_adjtime
> >> a16c7ff tests/docker: Add dockerfile for Alpine Linux
> >>
> >> === OUTPUT BEGIN ===
> >> 1/9 Checking commit a16c7ff7d859 (tests/docker: Add dockerfile for Alpine Linux)
> >> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> >> #20:
> >> new file mode 100644
> >>
> >> total: 0 errors, 1 warnings, 56 lines checked
> >>
> >> Patch 1/9 has style problems, please review.  If any of these errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >> 2/9 Checking commit 0bcd2f2eae84 (configure: Add sys/timex.h to probe
> >> clk_adjtime)
> >> 3/9 Checking commit 41a10dbdc8da (configure/meson: Only check
> >> sys/signal.h on non-Linux)
> >> 4/9 Checking commit 0ccf92b8ec37 (libvhost-user: Include poll.h instead
> >> of sys/poll.h)
> >> 5/9 Checking commit ba307d5a51aa (elf2dmp: Rename PAGE_SIZE to
> >> ELF2DMP_PAGE_SIZE)
> >> WARNING: line over 80 characters
> >> #69: FILE: contrib/elf2dmp/main.c:284:
> >> +        h.PhysicalMemoryBlock.NumberOfPages += ps->block[i].size /
> >> ELF2DMP_PAGE_SIZE;
> >>
> >> WARNING: line over 80 characters
> >> #79: FILE: contrib/elf2dmp/main.c:291:
> >> +    h.RequiredDumpSpace += h.PhysicalMemoryBlock.NumberOfPages <<
> >> ELF2DMP_PAGE_BITS;
> >>
> >> total: 0 errors, 2 warnings, 70 lines checked
> >>
> >> Patch 5/9 has style problems, please review.  If any of these errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >> 6/9 Checking commit e7febdf0b056 (hw/block/nand: Rename PAGE_SIZE to
> >> NAND_PAGE_SIZE)
> >> ERROR: code indent should never use tabs
> >> #26: FILE: hw/block/nand.c:117:
> >> +# define PAGE_START(page)^I(PAGE(page) * (NAND_PAGE_SIZE + OOB_SIZE))$
> >>
> >> ERROR: code indent should never use tabs
> >> #46: FILE: hw/block/nand.c:134:
> >> +# define NAND_PAGE_SIZE^I^I2048$
> >>
> >> WARNING: line over 80 characters
> >> #65: FILE: hw/block/nand.c:684:
> >> +        mem_and(iobuf + (soff | off), s->io, MIN(s->iolen,
> >> NAND_PAGE_SIZE - off));
> >>
> >> WARNING: line over 80 characters
> >> #70: FILE: hw/block/nand.c:687:
> >> +            mem_and(s->storage + (page << OOB_SHIFT), s->io +
> >> NAND_PAGE_SIZE - off,
> >>
> >> total: 2 errors, 2 warnings, 120 lines checked
> >>
> >> Patch 6/9 has style problems, please review.  If any of these errors
> >> are false positives report them to the maintainer, see
> >> CHECKPATCH in MAINTAINERS.
> >>
> >> 7/9 Checking commit 5fcb0ed1331a (accel/kvm: avoid using predefined PAGE_SIZE)
> >> 8/9 Checking commit a177af33938d (tests: Rename PAGE_SIZE definitions)
> >> 9/9 Checking commit 10095a92643d (gitlab-ci: Add alpine to pipeline)
> >> === OUTPUT END ===
> >>
> >> Test command exited with code: 1
> > All pre-existing errors.
> 
> Apparently some style errors were introduced by the patches 05 and 06.

I'm just doing string replacement, should I add a patch separately to fix existing issues than replace the string?

Thanks.

> 
> - Wainer
> 
> >
> >>
> >> The full log is available at
> >> http://patchew.org/logs/20201221005318.11866-1-jiaxun.yang@flygoat.com/testing.checkpatch/?type=message.
> >> ---
> >> Email generated automatically by Patchew [https://patchew.org/].
> >> Please send your feedback to patchew-devel@redhat.com
> 
>

-- 
- Jiaxun
