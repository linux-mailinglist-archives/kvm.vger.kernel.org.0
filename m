Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFDF52BF97
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiERQKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbiERQKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:10:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C941DB5BB
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:10:32 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q4so2205599plr.11
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=03plgJS7936PL3sSEzNXKGbAi9Hc+JkyewXYalh3t/Q=;
        b=BwfTVH+i4WiQaXvQ0b+3TT85/Pwh01BlCWec9mzmPXhMIDyDDoDI/pSPyhFCpcH2+h
         Ky5bMXRMHj/h1gYyQuWhgHgrCahoLjKq+u2qYqZPQtpKOJ5sraSwgymZFbJaQ64DbezR
         9f8woeDYOj6dw8yb4PNP7u1A9JpLLpeUdwy+xTQbXh2LvuHrZtVIdlLmmpV/lIRX44wz
         WloAHP3oYxjHqq/jRtzNOfDVFNKNRlFKS+BXhxP7SEudR5RTQaSR1Qebv1k520vrQSeL
         1MZtFEKhe/VxNfdenbke1sks0SkgU2BNdlmW2KWhcCNnd9vEpw7gErb0d2UpLYg+ncqY
         4mhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=03plgJS7936PL3sSEzNXKGbAi9Hc+JkyewXYalh3t/Q=;
        b=7g3dIMTlRA0RZkCYFjYtpPTWom3cDepOEFbQtai0u1S+QMtprwhc1tlRUTcOrXgLaW
         bHnhDppz0QDjS5yhTwdQGwM6Q/MhEBH4gJpB073+tlQie4j/c4OlrqGMhJ9gKe6tV4Wm
         +vNM3aog27O5HxEb+vshXbxGC2rh8O8CJDiB9r8K+wAF/JjC6X7XUKVqx5m5e7lc+PQG
         0DTlICjJ2k6hfjUq24ALPnBqg/vKpi/j0xTaaygE2j2G58zMTYZYS2QiHUakUe8RKMEs
         MUaDYtqPhp+S3supzGd1EQDKI4mSs3arcgucUi8JQ81qp2wwcD+wuxO2YnS7Ifv+DevD
         BmnQ==
X-Gm-Message-State: AOAM531x1RApcE4SPITfKQ7sM+eanaWhl1/UzovHPw0IioIvHI8Qu7b4
        VUL0E+x+bYZ8llwCqthgANSBvA==
X-Google-Smtp-Source: ABdhPJwOKlBtvCcPGJhXpuH1ix0JO+C70F4tllEt/OhN4o/nspCZKG2OeOe09QI9rJ4eHDewyGBxAQ==
X-Received: by 2002:a17:90a:690c:b0:1df:3b6f:d073 with SMTP id r12-20020a17090a690c00b001df3b6fd073mr784208pjj.18.1652890231314;
        Wed, 18 May 2022 09:10:31 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id v24-20020a170902e8d800b0015f086e4aa5sm1904580plg.291.2022.05.18.09.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:10:30 -0700 (PDT)
Date:   Wed, 18 May 2022 09:10:27 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 00/23] EFI and ACPI support for arm64
Message-ID: <YoUacwFnWpL6Hk7S@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <YoPhyyz+l3NkcAb5@google.com>
 <3376d2b0-7eec-212b-aedf-c4aa34be254c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3376d2b0-7eec-212b-aedf-c4aa34be254c@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On Wed, May 18, 2022 at 01:44:20PM +0100, Nikos Nikoleris wrote:
> Hi Ricardo,
> 
> On 17/05/2022 18:56, Ricardo Koller wrote:
> > Hi Nikos,
> > 
> > On Fri, May 06, 2022 at 09:55:42PM +0100, Nikos Nikoleris wrote:
> > > Hello,
> > > 
> > > This patch series adds initial support for building arm64 tests as EFI
> > > tests and running them under QEMU. Much like x86_64 we import external
> > > dependencies from gnu-efi and adopt them to work with types and other
> > > assumptions from kvm-unit-tests. In addition, this series adds support
> > > for discovering parts of the machine using ACPI.
> > > 
> > > The first set of patches moves the existing ACPI code to the common
> > > lib path. Then, it extends definitions and functions to allow for more
> > > robust discovery of ACPI tables. In arm64, we add support for setting
> > > up the PSCI conduit, discovering the UART, timers and cpus via
> > > ACPI. The code retains existing behavior and gives priority to
> > > discovery through DT when one has been provided.
> > > 
> > > In the second set of patches, we add support for getting the command
> > > line from the EFI shell. This is a requirement for many of the
> > > existing arm64 tests.
> > > 
> > > In the third set of patches, we import code from gnu-efi, make minor
> > > changes and add an alternative setup sequence from arm64 systems that
> > > boot through EFI. Finally, we add support in the build system and a
> > > run script which is used to run an EFI app.
> > > 
> > > After this set of patches one can build arm64 EFI tests:
> > > 
> > > $> ./configure --enable-efi
> > > $> make
> > > 
> > > And use the run script to run an EFI tests:
> > > 
> > > $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> > > 
> > 
> > Thanks very much for this!
> > 
> > I'm having some issues with the other tests. I'm cross-compiling with
> > gcc-11. But then "selftest setup" passes and others, like the timer
> > test, fail:
> > 
> > 	$ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- \
> > 		--processor=max --enable-efi
> > 	$ make
> > 
> > 	passes:
> > 	$ ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 \
> > 		-append "setup smp=2 mem=256"
> > 
> > 	fails:
> > 	$ ./arm/efi/run ./arm/timer.efi -smp 1 -m 256
> > 
> > 	Load address: 5833e000
> > 	PC: 5834ad20 PC offset: cd20
> > 	Unhandled exception ec=0x25 (DABT_EL1)
> > 	Vector: 4 (el1h_sync)
> > 	ESR_EL1:         96000006, ec=0x25 (DABT_EL1)
> > 	FAR_EL1: 0000000000000004 (valid)
> > 	Exception frame registers:
> > 	pc : [<000000005834ad20>] lr : [<000000005834cadc>] pstate: 600003c5
> > 	sp : 000000005f70fd80
> > 	x29: 000000005f70ffe0 x28: 0000000000000000
> > 	x27: 000000005835dc50 x26: 000000005834eb80
> > 	x25: 000000000000d800 x24: 000000005f70fe50
> > 	x23: 0000000000000000 x22: 000000005835f000
> > 	x21: 000000005834eb80 x20: 0000000000000000
> > 	x19: 00000000ffffffff x18: 0000000000000000
> > 	x17: 0000000000000009 x16: 000000005bae8c38
> > 	x15: 0000000000000002 x14: 0000000000000001
> > 	x13: 0000000058350000 x12: 0000000058350000
> > 	x11: 000000005833e000 x10: 000000000005833d
> > 	x9 : 0000000000000000 x8 : 0000000000000000
> > 	x7 : 0000000000000000 x6 : 0000000000000001
> > 	x5 : 00000000000000c9 x4 : 000000005f70fe68
> > 	x3 : 000000005f70fe68 x2 : 000000005834eb80
> > 	x1 : 00000000ffffffff x0 : 0000000000000000
> > 
> 
> Thank you for having a look!
> 
> Apologies, I should have been more explicit about this. At this point, not
> all tests run successfully. There are bits and pieces missing, some of which
> I tried to list in this TODO list and more that I missed. For example, to
> get the timer tests to pass we have to add support for GIC initialization
> through ACPI.
> 
> I've continued working on this series, and I will be ironing some of these
> issues out and, in the meantime, I wanted some early feedback on whether

Sounds good, will take a look as well. Thanks!

> some of these features are even desirable upstream (e.g., ACPI support for
> arm64).

It's highly desirable for us. This is great.

Thanks,
Ricardo

> 
> I don't want to spam the list too much and I will wait for comments before I
> send a v3 but I already have a couple of fixes and one more patch [1]. With
> these applied both the timer and most gicv3 tests pass.
> 
> [1]: https://github.com/relokin/kvm-unit-tests/tree/target-efi-upstream
> 
> Thanks,
> 
> Nikos
> 
> > Thanks!
> > Ricardo
> > 
> > > Or all tests:
> > > 
> > > $> ./run_tests.sh
> > > 
> > > There are a few items that this series does not address but they would
> > > be useful to have:
> > > 
> > > * Support for booting the system from EL2. Currently, we assume that a
> > > tests starts running at EL1. This the case when we run with EFI, it's
> > > not always the case in hardware.
> > > 
> > > * Support for reading environment variables and populating __envp.
> > > 
> > > * Support for discovering the chr-testdev through ACPI.
> > > 
> > > PS: Apologies for the mess with v1. Due to a mistake in my git
> > > send-email configuration some patches didn't make it to the list and
> > > the right recipients.
> > > 
> > > Thanks,
> > > 
> > > Nikos
> > > 
> > > Andrew Jones (3):
> > >    arm/arm64: mmu_disable: Clean and invalidate before disabling
> > >    arm/arm64: Rename etext to _etext
> > >    arm64: Add a new type of memory type flag MR_F_RESERVED
> > > 
> > > Nikos Nikoleris (20):
> > >    lib: Move acpi header and implementation to lib
> > >    lib: Ensure all struct definition for ACPI tables are packed
> > >    lib: Add support for the XSDT ACPI table
> > >    lib: Extend the definition of the ACPI table FADT
> > >    arm/arm64: Add support for setting up the PSCI conduit through ACPI
> > >    arm/arm64: Add support for discovering the UART through ACPI
> > >    arm/arm64: Add support for timer initialization through ACPI
> > >    arm/arm64: Add support for cpu initialization through ACPI
> > >    lib/printf: Support for precision modifier in printing strings
> > >    lib/printf: Add support for printing wide strings
> > >    lib/efi: Add support for getting the cmdline
> > >    lib: Avoid ms_abi for calls related to EFI on arm64
> > >    arm/arm64: Add a setup sequence for systems that boot through EFI
> > >    arm64: Copy code from GNU-EFI
> > >    arm64: Change GNU-EFI imported file to use defined types
> > >    arm64: Use code from the gnu-efi when booting with EFI
> > >    lib: Avoid external dependency in libelf
> > >    x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
> > >    arm64: Add support for efi in Makefile
> > >    arm64: Add an efi/run script
> > > 
> > >   scripts/runtime.bash        |  14 +-
> > >   arm/efi/run                 |  61 +++++++++
> > >   arm/run                     |   8 +-
> > >   configure                   |  15 ++-
> > >   Makefile                    |   4 -
> > >   arm/Makefile.arm            |   6 +
> > >   arm/Makefile.arm64          |  18 ++-
> > >   arm/Makefile.common         |  48 +++++--
> > >   x86/Makefile.common         |   2 +-
> > >   x86/Makefile.x86_64         |   4 +
> > >   lib/linux/efi.h             |  44 ++++++
> > >   lib/arm/asm/setup.h         |   3 +
> > >   lib/arm/asm/timer.h         |   2 +
> > >   lib/x86/asm/setup.h         |   2 +-
> > >   lib/acpi.h                  | 260 ++++++++++++++++++++++++++++++++++++
> > >   lib/stdlib.h                |   1 +
> > >   lib/x86/acpi.h              | 112 ----------------
> > >   lib/acpi.c                  | 124 +++++++++++++++++
> > >   lib/arm/io.c                |  21 ++-
> > >   lib/arm/mmu.c               |   4 +
> > >   lib/arm/psci.c              |  25 +++-
> > >   lib/arm/setup.c             | 247 +++++++++++++++++++++++++++-------
> > >   lib/arm/timer.c             |  73 ++++++++++
> > >   lib/devicetree.c            |   2 +-
> > >   lib/efi.c                   | 123 +++++++++++++++++
> > >   lib/printf.c                | 183 +++++++++++++++++++++++--
> > >   lib/string.c                |   2 +-
> > >   lib/x86/acpi.c              |  82 ------------
> > >   arm/efi/elf_aarch64_efi.lds |  63 +++++++++
> > >   arm/flat.lds                |   2 +-
> > >   arm/cstart.S                |  29 +++-
> > >   arm/cstart64.S              |  28 +++-
> > >   arm/efi/crt0-efi-aarch64.S  | 143 ++++++++++++++++++++
> > >   arm/dummy.c                 |   4 +
> > >   arm/efi/reloc_aarch64.c     |  93 +++++++++++++
> > >   x86/s3.c                    |  20 +--
> > >   x86/vmexit.c                |   4 +-
> > >   37 files changed, 1556 insertions(+), 320 deletions(-)
> > >   create mode 100755 arm/efi/run
> > >   create mode 100644 lib/acpi.h
> > >   delete mode 100644 lib/x86/acpi.h
> > >   create mode 100644 lib/acpi.c
> > >   create mode 100644 lib/arm/timer.c
> > >   delete mode 100644 lib/x86/acpi.c
> > >   create mode 100644 arm/efi/elf_aarch64_efi.lds
> > >   create mode 100644 arm/efi/crt0-efi-aarch64.S
> > >   create mode 100644 arm/dummy.c
> > >   create mode 100644 arm/efi/reloc_aarch64.c
> > > 
> > > -- 
> > > 2.25.1
> > > 
