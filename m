Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2178C3EF684
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhHRAJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbhHRAJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D4DC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w200-20020a25c7d10000b02905585436b530so915387ybe.21
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Qe1cV4nBrsRVrpYHmoGhXwi78PW5L7oZ+zPxnBbLhm8=;
        b=moLrxbc6KN2FJ/RI0iY+itxgN0vImUX3GMUCbu43fUX1R+VArQap3YI2toY1fyfFJl
         06diS6xB9PP+K5ZMRrGCtyamGQAHLP0nNQV7e1BXyPfwgEz0zbEe2IJEmUYDxV5vTw1/
         p9jXPkfuSO8FF3/8kaJ2fpGC8OPI6H+k9g0x3s+pE6UZ1+qRi4vmrtEWlmRSsRAaOjEQ
         Ha1azAEAZQ/O3r7vxrvZIylHlMvj84VUYk1rHfbkcXRkO0JyMG3nbB6LVEw5tOptTgUO
         pmfX5k1bzTPHvRDFFIJkM8Tlf1w+04Sp1lKmPI5VQ63+j1P7TmFn+LQ3nFgN7fhLmRiJ
         6INw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Qe1cV4nBrsRVrpYHmoGhXwi78PW5L7oZ+zPxnBbLhm8=;
        b=ntBY11qoyXCnpN9HCjK04XEUEBP8suVhjvFq36lzd+1wgc9UjQA8Qdmzg9wds4UqHy
         7ZSm8kgkdWfh8kZgrS+R92Ym4ooQoDTI0Mr4ZI6qa0GxkYRObgqWVKf5NQtIfuSFg5Ou
         5xR2vT90WFTm+vFmB5qxl8Cq3zomf7+QdKx/qAmsWVmMVhkmYQF1QAHb246t+h+lY4wr
         ofUrC9j28GdGV5WE2e8Iq25PqTETN/uYYsJWeZz5HVSfkKYP1mgLDQ7Maufp0+jIVbqL
         lezghnq/1PZArMWx7U2XWXZ112VxzyQMNtCVbksoV65B07mF99oaw/iTYfiIdZn45bgG
         3Bsw==
X-Gm-Message-State: AOAM531y6Gxq1YOHpkn1nQhSsjzfHIbU0x6R2/Ynyk6UqgfJDrTIrqcl
        ba1CyrgvIkB4AS0BOZtTbZ2OhxyhsSm7S+0OwOnWe56F66OTE8SrP6Xea7dg66zK6A2bugPORjJ
        b5ryZn2XYs3Svsjc0v4VAMZiJeX5nC5Bi0tQU/oGAVQ8aLeYlbgguD00LlsBfwmmB4VhE
X-Google-Smtp-Source: ABdhPJw4kxT0ADh9mbIp8J8EZw+50ykbpK+ImOFwOz6iJmkdnC3Exz056CfQ0Q9M/kKGIQ2hch/0CT2ETl3FDw/8
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:99c8:: with SMTP id
 q8mr8570537ybo.63.1629245354060; Tue, 17 Aug 2021 17:09:14 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:49 +0000
Message-Id: <20210818000905.1111226-1-zixuanwang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 00/16] x86_64 UEFI and AMD SEV/SEV-ES support
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series updates the x86_64 KVM-Unit-Tests to run under UEFI
and culminates in enabling AMD SEV/SEV-ES. We are sending it out for
early review as it provides basic support to run test cases in UEFI,
and also enables AMD SEV and SEV-ES features.

The patches are organized as two parts. The first part (patches 1-9)
enables the x86_64 test cases to run under UEFI. In particular, these
patches allow the x86_64 test cases to be built as EFI applications.
The efi_main() function sets up the KVM-Unit-Tests framework to run
under UEFI and then launches the test cases' main() function. To date,
we have 38/43 test cases running with UEFI using this approach.

The second part of the series (patches 10-16) focuses on SEV. In
particular, these patches introduce SEV/SEV-ES set up code into the EFI
set up process, including checking if SEV is supported, setting c-bits
for page table entries, and (notably) reusing the UEFI #VC handler so
that the set up process does not need to re-implement it (a test case
can always implement a new #VC handler and load it after set up is
finished). Using this approach, we are able to launch the x86_64 test
cases under SEV-ES and exercise KVM's VMGEXIT handler.

See the Part 1 and Part 2 summaries, below, for a high-level breakdown
of how the patches are organized.

Part 1 Summary:
Commits 1-3 introduce support to build test cases as EFI applications
(with the GNU-EFI library).

Commits 4-8 set up KVM-Unit-Tests to run under UEFI. In doing so, these
patches incrementally enable most existing x86_64 test cases to run
under UEFI.

Commit 9 fixes several test cases that fail to compile with GNU-EFI due
to UEFI's position independent code (PIC) requirement.

Part 2 Summary:
Commits 10-11 introduce support for SEV by adding new configuration
flags and set up code to set the SEV c-bit in page table entries.
SEV-related code is currently injected by configuration flags and C
macros, it is also possible to remove these flags and macros and
implement runtime SEV check and set up functions.

Commits 12-15 introduce support for SEV-ES by reusing the UEFI #VC
handler in KVM-Unit-Tests. They also fix GDT and IDT issues that occur
when reusing UEFI functions in KVM-Unit-Tests.

Commit 16 adds additional test cases for SEV-ES.

Regards,
Zixuan Wang

Zixuan Wang (16):
  x86 UEFI: Copy code from GNU-EFI
  x86 UEFI: Boot from UEFI
  x86 UEFI: Move setjmp.h out of desc.h
  x86 UEFI: Load KVM-Unit-Tests IDT after UEFI boot up
  x86 UEFI: Load GDT and TSS after UEFI boot up
  x86 UEFI: Set up memory allocator
  x86 UEFI: Set up RSDP after UEFI boot up
  x86 UEFI: Set up page tables
  x86 UEFI: Convert x86 test cases to PIC
  x86 AMD SEV: Initial support
  x86 AMD SEV: Page table with c-bit
  x86 AMD SEV-ES: Check SEV-ES status
  x86 AMD SEV-ES: Load GDT with UEFI segments
  x86 AMD SEV-ES: Copy UEFI #VC IDT entry
  x86 AMD SEV-ES: Set up GHCB page
  x86 AMD SEV-ES: Add test cases

 .gitignore                 |   3 +
 Makefile                   |  47 ++++++-
 README.md                  |   6 +
 configure                  |  29 +++++
 lib/efi.c                  |  60 +++++++++
 lib/string.c               |   3 +
 lib/x86/acpi.c             |  38 +++++-
 lib/x86/acpi.h             |   4 +
 lib/x86/amd_sev.c          | 147 +++++++++++++++++++++
 lib/x86/amd_sev.h          |  59 +++++++++
 lib/x86/asm/page.h         |  14 +-
 lib/x86/asm/setup.h        |  37 ++++++
 lib/x86/desc.c             |   4 +
 lib/x86/desc.h             |   5 -
 lib/x86/setup.c            | 259 +++++++++++++++++++++++++++++++++++++
 lib/x86/usermode.c         |   3 +-
 lib/x86/vm.c               |  18 ++-
 x86/Makefile.common        |  75 ++++++++---
 x86/Makefile.i386          |   5 +-
 x86/Makefile.x86_64        |  58 ++++++---
 x86/access.c               |   6 +-
 x86/amd_sev.c              |  97 ++++++++++++++
 x86/cet.c                  |   8 +-
 x86/efi/README.md          |  72 +++++++++++
 x86/efi/efistart64.S       | 141 ++++++++++++++++++++
 x86/efi/elf_x86_64_efi.lds |  81 ++++++++++++
 x86/efi/run                |  63 +++++++++
 x86/emulator.c             |   5 +-
 x86/eventinj.c             |   6 +-
 x86/run                    |  16 ++-
 x86/smap.c                 |   8 +-
 x86/umip.c                 |  10 +-
 x86/vmx.c                  |   1 +
 33 files changed, 1311 insertions(+), 77 deletions(-)
 create mode 100644 lib/efi.c
 create mode 100644 lib/x86/amd_sev.c
 create mode 100644 lib/x86/amd_sev.h
 create mode 100644 lib/x86/asm/setup.h
 create mode 100644 x86/amd_sev.c
 create mode 100644 x86/efi/README.md
 create mode 100644 x86/efi/efistart64.S
 create mode 100644 x86/efi/elf_x86_64_efi.lds
 create mode 100755 x86/efi/run

--
2.33.0.rc1.237.g0d66db33f3-goog

