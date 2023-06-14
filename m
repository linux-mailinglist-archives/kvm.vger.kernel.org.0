Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2B72F159
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 03:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjFNBJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 21:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbjFNBJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 21:09:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7FFD1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 18:09:54 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-976a0a1a92bso31453666b.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 18:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1686704992; x=1689296992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CefrVBFgylDvVaVNQyLqjXfzc+7GKkMNBkU5AGBDehw=;
        b=P7p4i++CYaQL68iVpgKv7CXaICXGXHpzr0EaquZeSA8o03NtvkE1FBUeS33jggLyqN
         UdtQs1xx8A/WMx/NcTyEXyi3f3IMCLmi0lTQfYYqmDmEb6td3npppdmrD7RgUv+desx1
         bESozDhReo/9yZA4S+lnrWAL/t+UVxnZRZuKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686704992; x=1689296992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CefrVBFgylDvVaVNQyLqjXfzc+7GKkMNBkU5AGBDehw=;
        b=X6rbXbln31LQ2SYb+yGhK018KaYIzay3bYCcrdhvT5lBwpMDaa4TdfCzMeGud/frDU
         M+TjV+5Zqb/86FuTKCw3DEN5jSfYFCDcaK9zhEol7Fn/odeRmUxL3+zDL5nCObFPzj6J
         ArxT88HNUIdCcfXSCiipmLNJpYS4Fw4JNBGBFnYSU5k2QIrvxggE4SuBVFOPAzqK1JPQ
         jTM7C/1q+8Dz2y/6iuTReoRB/0aONOfnFwtsYeXTFcJjpYigRq/mXhHLeCo8XDFr4usz
         8+6ME9U6tszR90/wX8BIFoRrmkpEUim225Fd3JpnVY+N8MSM4JE2D4BxHhO0jeY1JNgy
         pdAA==
X-Gm-Message-State: AC+VfDyFmZ817ZVuQ0CJtYjbn7Ny7fym6osnDfufFAYipOWd2Gtws8hJ
        dPtXccw7IMADA4+6383Ih6Z0txK6qonZT3+TNho=
X-Google-Smtp-Source: ACHHUZ5Dnfwh3dO42sbHs29HyLn6tpyx6vfROmjBOqEVtFCACOQZ0PfGkFtLZZ2a0UtwXF/X6af1kYcgzpjYeH79U/s=
X-Received: by 2002:a17:907:2ce5:b0:978:af9d:4d4c with SMTP id
 hz5-20020a1709072ce500b00978af9d4d4cmr15656973ejc.75.1686704992255; Tue, 13
 Jun 2023 18:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230608075826.86217-1-npiggin@gmail.com>
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 14 Jun 2023 01:09:39 +0000
Message-ID: <CACPK8XdpAxjvP+bFNFJzQQzBYvEwsE69QkbNWRumZtUW2wOrrA@mail.gmail.com>
Subject: Re: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URIBL_CSS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Jun 2023 at 07:58, Nicholas Piggin <npiggin@gmail.com> wrote:
>
> Posting again, a couple of patches were merged and accounted for review
> comments from last time.

I saw some failures in the spr tests running on a power9 powernv system:

$ TESTNAME=sprs TIMEOUT=90s ACCEL= ./powerpc/run powerpc/sprs.elf -smp
1 |grep FAIL
FAIL: WORT      ( 895):    0x00000000c0deba80 <==> 0x0000000000000000

$ MIGRATION=yes TESTNAME=sprs-migration TIMEOUT=90s ACCEL=
./powerpc/run powerpc/sprs.elf -smp 1 -append '-w' | grep FAIL
FAIL: SRR0      (  26):    0xcafefacec0debabc <==> 0x0000000000402244
FAIL: SRR1      (  27):    0xc0000006409ebab6 <==> 0x8000000000001001
FAIL: CTRL      ( 136):            0x00000000 <==>         0x00008001
FAIL: WORT      ( 895):    0x00000000c0deba80 <==> 0x0000000000000000
FAIL: PIR       (1023):            0x00000010 <==>         0x00000049

Linux 6.2.0-20-generic
QEMU emulator version 7.2.0 (Debian 1:7.2+dfsg-5ubuntu2)

On a power8 powernv:

MIGRATION=yes TESTNAME=sprs-migration TIMEOUT=90s ACCEL= ./powerpc/run
powerpc/sprs.elf -smp 1 -append '-w' |grep FAIL
FAIL: SRR0      (  26):    0xcafefacec0debabc <==> 0x0000000000402234
FAIL: SRR1      (  27):    0xc0000006409ebab6 <==> 0x8000000000001000
FAIL: CTRL      ( 136):            0x00000000 <==>         0x00008001
FAIL: PIR       (1023):            0x00000060 <==>         0x00000030

Linux 5.4.0-146-generic
QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.26)

Cheers,

Joel

>
> Thanks,
> Nick
>
> Nicholas Piggin (12):
>   powerpc: Report instruction address and MSR in unhandled exception
>     error
>   powerpc: Add some checking to exception handler install
>   powerpc: Abstract H_CEDE calls into a sleep functions
>   powerpc: Add ISA v3.1 (POWER10) support to SPR test
>   powerpc: Extract some common helpers and defines to headers
>   powerpc/sprs: Specify SPRs with data rather than code
>   powerpc/spapr_vpa: Add basic VPA tests
>   powerpc: Expand exception handler vector granularity
>   powerpc: Add support for more interrupts including HV interrupts
>   powerpc: Discover runtime load address dynamically
>   powerpc: Support powernv machine with QEMU TCG
>   powerpc/sprs: Test hypervisor registers on powernv machine
>
>  lib/powerpc/asm/handlers.h  |   2 +-
>  lib/powerpc/asm/hcall.h     |   1 +
>  lib/powerpc/asm/ppc_asm.h   |   9 +
>  lib/powerpc/asm/processor.h |  55 ++-
>  lib/powerpc/handlers.c      |  10 +-
>  lib/powerpc/hcall.c         |   4 +-
>  lib/powerpc/io.c            |  27 +-
>  lib/powerpc/io.h            |   6 +
>  lib/powerpc/processor.c     |  79 ++++-
>  lib/powerpc/setup.c         |   8 +-
>  lib/ppc64/asm/opal.h        |  15 +
>  lib/ppc64/asm/vpa.h         |  62 ++++
>  lib/ppc64/opal-calls.S      |  46 +++
>  lib/ppc64/opal.c            |  74 +++++
>  powerpc/Makefile.ppc64      |   4 +-
>  powerpc/cstart64.S          | 105 ++++--
>  powerpc/run                 |  35 +-
>  powerpc/spapr_hcall.c       |   9 +-
>  powerpc/spapr_vpa.c         | 172 ++++++++++
>  powerpc/sprs.c              | 645 ++++++++++++++++++++++++++----------
>  powerpc/tm.c                |  20 +-
>  powerpc/unittests.cfg       |   3 +
>  22 files changed, 1133 insertions(+), 258 deletions(-)
>  create mode 100644 lib/ppc64/asm/opal.h
>  create mode 100644 lib/ppc64/asm/vpa.h
>  create mode 100644 lib/ppc64/opal-calls.S
>  create mode 100644 lib/ppc64/opal.c
>  create mode 100644 powerpc/spapr_vpa.c
>
> --
> 2.40.1
>
