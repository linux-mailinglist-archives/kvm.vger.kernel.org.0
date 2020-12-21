Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AB22DF9FA
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 09:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgLUIhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 03:37:00 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:35961 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgLUIhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 03:37:00 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 03:36:59 EST
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 1049E746;
        Mon, 21 Dec 2020 03:25:32 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Mon, 21 Dec 2020 03:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=lQSJlbSnCrIxq7ACsUlUgE3h2uggyz5
        DzOSy8q0FVIM=; b=u2j79H66TxeTWNVEiDwkPDSOgmbgaI3/eCwYXlietxyr7gd
        0nwr73Uu6KcoZL/4NrEt10DRTJphQRqVdPPHFuIjSa626iz9kiViCJ350izVuDB+
        WZ1w0JU1I8iDOKUCuPvntAP9aMlIkR0C67xNT+whX/uslnYuqqZcHIZhvrw85HfJ
        oS4TtyZF10E/7l9eehYgsXpc5nS6Ws/8iVFoR0s1S/jmcj661Q0LC68vmxqLaAuP
        8kTwX/sQZAMqRkvQyKqVuD9UIcoBqpa4CiRgvvyHEoZ0ALSOSgxr67icCgxm4uXk
        Wil/JsWfPhT0BVwhdLqatpLsTIUsTh2z6kRfN2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lQSJlb
        SnCrIxq7ACsUlUgE3h2uggyz5DzOSy8q0FVIM=; b=kQL17YDH5+IaBFLRnqkj2E
        TAXGznBi6tmWeKRltJ2osDqyQI95vhC4oIM8gC0b6/YfLWwX2FSbDwzXm5k+OA0v
        +VQf9WZLRw/2DjiclSzMSv03qnEVlbgJwp10aZib1svDL+lxW8Uk9+o9uE/J48Cu
        BCee1tvH2mRT5zTn61ZRrdCMkkoSKvYqE+lMLqCAqXkgFZzDZLTF9WVRF27mmdPj
        aP98DKaqBeu8IdITEI5Nt6LhrY9yHcDYPJ0SjyhWiRAeVk4jV2K97LMr02p/mlLI
        FS/LAJu3DskgNuUilzKjpjc5SHwdYqXTI1Y6BD6cFoNIUs9ZjJ8XlCvxpOtSiKsQ
        ==
X-ME-Sender: <xms:-VvgX_JIcdRuwMwazIJG4Z_VJ25pYTssF3a7TKP8IwzwJOermgJqPg>
    <xme:-VvgXzKX057BOIJ3gf5e_KFTjaUTabBq6xZBN6DapTWj5yciQXdIw3GQcHiF_yJkH
    HcBmXv-haphFTYth78>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkjghffffhvffutgesth
    dtredtreertdenucfhrhhomhepfdflihgrgihunhcujggrnhhgfdcuoehjihgrgihunhdr
    higrnhhgsehflhihghhorghtrdgtohhmqeenucggtffrrghtthgvrhhnpeeliefhjeffhf
    ejffetveevvdehvefftdejveethedtgffhgffghedvudefuedvveenucffohhmrghinhep
    phgrthgthhgvfidrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihg
    ohgrthdrtghomh
X-ME-Proxy: <xmx:-VvgX3ukZm8eAKPtlngEBKY8pYjJ-p_x6x66LKPk3lp4CaRKevIUlg>
    <xmx:-VvgX4b2wTYvvZhbG9PAGznolGePGqj0FuEAxveX9ztI-841IYRDCA>
    <xmx:-VvgX2Yf3keCw4ui2iD8kfNnEBF-vnC3nPEcxsiArbgWsI6QiTkKLw>
    <xmx:-1vgX-pd_hzIMV1mCwlNF3tNfQm0ujR25DjCs8UaL9kKXIMA0riqeAAVv9U5RNplLpmI2A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0EF61C200A5; Mon, 21 Dec 2020 03:25:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.1-61-gb52c239-fm-20201210.001-gb52c2396
Mime-Version: 1.0
Message-Id: <1389d6d1-33fe-46cc-b03c-f2a40e03853b@www.fastmail.com>
In-Reply-To: <160851280526.21294.6201442635975331015@600e7e483b3a>
References: <160851280526.21294.6201442635975331015@600e7e483b3a>
Date:   Mon, 21 Dec 2020 16:25:08 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     kwolf@redhat.com, fam@euphon.net, thuth@redhat.com,
        kvm@vger.kernel.org, viktor.prutyanov@phystech.edu,
        lvivier@redhat.com, philmd@redhat.com, alistair@alistair23.me,
        groug@kaod.org, wainersm@redhat.com, mreitz@redhat.com,
        qemu-ppc@nongnu.org, pbonzini@redhat.com, qemu-block@nongnu.org,
        alex.bennee@linaro.org, david@gibson.dropbear.id.au
Subject: Re: [PATCH 0/9] Alpine Linux build fix and CI pipeline
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Mon, Dec 21, 2020, at 9:06 AM, no-reply@patchew.org wrote:
> Patchew URL: 
> https://patchew.org/QEMU/20201221005318.11866-1-jiaxun.yang@flygoat.com/
> 
> 
> 
> Hi,
> 
> This series seems to have some coding style problems. See output below for
> more information:
> 
> Type: series
> Message-id: 20201221005318.11866-1-jiaxun.yang@flygoat.com
> Subject: [PATCH 0/9] Alpine Linux build fix and CI pipeline
> 
> === TEST SCRIPT BEGIN ===
> #!/bin/bash
> git rev-parse base > /dev/null || exit 0
> git config --local diff.renamelimit 0
> git config --local diff.renames True
> git config --local diff.algorithm histogram
> ./scripts/checkpatch.pl --mailback base..
> === TEST SCRIPT END ===
> 
> Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
> From https://github.com/patchew-project/qemu
>  * [new tag]         
> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com -> 
> patchew/20201221005318.11866-1-jiaxun.yang@flygoat.com
> Switched to a new branch 'test'
> 10095a9 gitlab-ci: Add alpine to pipeline
> a177af3 tests: Rename PAGE_SIZE definitions
> 5fcb0ed accel/kvm: avoid using predefined PAGE_SIZE
> e7febdf hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
> ba307d5 elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
> 0ccf92b libvhost-user: Include poll.h instead of sys/poll.h
> 41a10db configure/meson: Only check sys/signal.h on non-Linux
> 0bcd2f2 configure: Add sys/timex.h to probe clk_adjtime
> a16c7ff tests/docker: Add dockerfile for Alpine Linux
> 
> === OUTPUT BEGIN ===
> 1/9 Checking commit a16c7ff7d859 (tests/docker: Add dockerfile for Alpine Linux)
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #20: 
> new file mode 100644
> 
> total: 0 errors, 1 warnings, 56 lines checked
> 
> Patch 1/9 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 2/9 Checking commit 0bcd2f2eae84 (configure: Add sys/timex.h to probe 
> clk_adjtime)
> 3/9 Checking commit 41a10dbdc8da (configure/meson: Only check 
> sys/signal.h on non-Linux)
> 4/9 Checking commit 0ccf92b8ec37 (libvhost-user: Include poll.h instead 
> of sys/poll.h)
> 5/9 Checking commit ba307d5a51aa (elf2dmp: Rename PAGE_SIZE to 
> ELF2DMP_PAGE_SIZE)
> WARNING: line over 80 characters
> #69: FILE: contrib/elf2dmp/main.c:284:
> +        h.PhysicalMemoryBlock.NumberOfPages += ps->block[i].size / 
> ELF2DMP_PAGE_SIZE;
> 
> WARNING: line over 80 characters
> #79: FILE: contrib/elf2dmp/main.c:291:
> +    h.RequiredDumpSpace += h.PhysicalMemoryBlock.NumberOfPages << 
> ELF2DMP_PAGE_BITS;
> 
> total: 0 errors, 2 warnings, 70 lines checked
> 
> Patch 5/9 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 6/9 Checking commit e7febdf0b056 (hw/block/nand: Rename PAGE_SIZE to 
> NAND_PAGE_SIZE)
> ERROR: code indent should never use tabs
> #26: FILE: hw/block/nand.c:117:
> +# define PAGE_START(page)^I(PAGE(page) * (NAND_PAGE_SIZE + OOB_SIZE))$
> 
> ERROR: code indent should never use tabs
> #46: FILE: hw/block/nand.c:134:
> +# define NAND_PAGE_SIZE^I^I2048$
> 
> WARNING: line over 80 characters
> #65: FILE: hw/block/nand.c:684:
> +        mem_and(iobuf + (soff | off), s->io, MIN(s->iolen, 
> NAND_PAGE_SIZE - off));
> 
> WARNING: line over 80 characters
> #70: FILE: hw/block/nand.c:687:
> +            mem_and(s->storage + (page << OOB_SHIFT), s->io + 
> NAND_PAGE_SIZE - off,
> 
> total: 2 errors, 2 warnings, 120 lines checked
> 
> Patch 6/9 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 7/9 Checking commit 5fcb0ed1331a (accel/kvm: avoid using predefined PAGE_SIZE)
> 8/9 Checking commit a177af33938d (tests: Rename PAGE_SIZE definitions)
> 9/9 Checking commit 10095a92643d (gitlab-ci: Add alpine to pipeline)
> === OUTPUT END ===
> 
> Test command exited with code: 1

All pre-existing errors.

> 
> 
> The full log is available at
> http://patchew.org/logs/20201221005318.11866-1-jiaxun.yang@flygoat.com/testing.checkpatch/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com

-- 
- Jiaxun
