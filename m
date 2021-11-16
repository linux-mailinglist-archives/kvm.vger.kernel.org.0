Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E99453B15
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhKPUny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKPUnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:43:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D5AC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:40:56 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so3276166pju.3
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYlzWtfhj+H2J4I4xba+I971s3h/h8xoWb8A++Men0M=;
        b=Sa3tbgA2z8xflXdmveknWjQyDnR/4JtAMT6St0Dk4Bo9IBK6sqPiEBybvLdrrhvoFO
         2zz/IBuiULgppYWInHhOFClHLUbUMWtyef46rjEBJPTEcK09w6acWzqTY4eSrP1twZos
         HmJ/yAgV+cp+7ROfOH6tTMH1SuVJy8PoZOqTiUEb0D5MpZ1x6wgAV4UWVGmn4OFDVzSx
         yIEDZOKVNCQKiH7y7vMTwIvOZIt/EykbOv7F562F/Rp8/D5ULsSs0iG7Uw6v77eIyQB0
         nA5zt3bS6mAEVxPxok4N7rb+p9ED+Si4HUnBgiy5FWhcXm9it6i2wFvNTIhZL7i3KP/j
         ywNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYlzWtfhj+H2J4I4xba+I971s3h/h8xoWb8A++Men0M=;
        b=gVPbthhT2wRy0WhN7vJK1255XDUSn30onzTk7u5MhKC/WhnIOdn1MK6Yj5MVab+O7F
         N2FjiuORh7IytnXotPpSh9CQh8GAQUWzdSFziRfjjIerfOfMRhjJJae3XXrefck6viZf
         gZ5j9QA97mviMwGdEwkSEFMYsqQKPhlAhZCnQNJy1Cr3Kc7IISFJ8ftH+yhTRFg3ETWI
         9opgEIfu6R7IKAmNZxRjN/jCV9Q6dmZQResckBMd1ZRpzlIQf0aNyTcxmihwyYEW0sA9
         jXPyd+ZPzbtstq5/RqDD5NcEiXsBf2UPh4CFdJna/afcGKVe/bKlVhNtQS0kcvSTtJur
         aoWA==
X-Gm-Message-State: AOAM533QQobm/Wj7cqxUL7TpFinSed9YZENyoAhBOq3lBdU+86HZ5h/R
        wpapctVmmhxliMlmEvqsSmO5iHISFzriNg==
X-Google-Smtp-Source: ABdhPJwYuN6HbUyNh+bJKAKL8yRNZ0RpWurFgI/HhmVQPpoy2hfFYAsh2a1yYSa4830RPiv7ZtWo8A==
X-Received: by 2002:a17:90b:4b4e:: with SMTP id mi14mr2421836pjb.122.1637095255424;
        Tue, 16 Nov 2021 12:40:55 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:40:54 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 00/10] x86_64 UEFI set up process refactor and scripts fixes
Date:   Tue, 16 Nov 2021 12:40:43 -0800
Message-Id: <20211116204053.220523-1-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series refactors the x86_64 UEFI set up process, fixes the
`run-tests.sh` script to run under UEFI, and improves the boot speed
under UEFI. The patches are organized as four parts.

The first part (patches 1-3) refactors the x86_64 UEFI set up process.
The previous UEFI setup calls arch-specific setup functions twice and
generates arch-specific data structure. As Andrew suggested [1], we
refactor this process to make only one call to the arch-specific
function and generate arch-neutral data structures. This simplifies the
set up process and makes it easier to develop UEFI support for other
architectures.

The second part (patch 4) converts several x86 test cases to
position-independent code (PIC) to run under UEFI. This patch is ported
from the initial UEFI support patchset [2] with fixes to the 32-bit
compilation.

The third part (patches 5-8) fixes the UEFI runner scripts. Patch 5
sets UEFI OVMF image as read-only. Patch 6 fixes test cases' return
code under UEFI, enabling Patch 7-8 to fix the `run-tests.sh` script
under UEFI.

The fourth part (patches 9-10) improves the boot speed under UEFI.
Patch 9 renames the EFI executables to EFI/BOOT/BOOTX64.EFI. UEFI OVMF
recognizes this file by default and skips the 5-second user input
waiting. Patch 10 makes `run-tests.sh` work with this new EFI
executable filename.

This patchset is based on the `uefi` branch.

Changes since V1:
V2 Patch #  Changes
----------  -------
     03/10  (New patch from Sean) Skip SEV-ES setup if SEV is not
            available
     04/10  Add more details to the commit message
     06/10  Add UEFI shutdown in case exit() doesn't work
     07/10  Simplify variable usages in scripts
     08/10  Simplify variable usages in scripts
     09/10  (New patch) Improve UEFI boot speed
     10/10  (New patch) Update run-tests.sh

Best regards,
Zixuan Wang and Marc Orr

[1] https://lore.kernel.org/kvm/20211005060549.clar5nakynz2zecl@gator.home/
[2] https://lore.kernel.org/kvm/20211004204931.1537823-1-zxwang42@gmail.com/


Marc Orr (3):
  scripts: Generalize EFI check
  x86 UEFI: Make run_tests.sh (mostly) work under UEFI
  x86 UEFI: Make _NO_FILE_4Uhere_ work w/ BOOTX64.EFI

Sean Christopherson (1):
  x86 AMD SEV: Skip SEV-ES if SEV is unsupported

Zixuan Wang (6):
  x86 UEFI: Remove mixed_mode
  x86 UEFI: Refactor set up process
  x86 UEFI: Convert x86 test cases to PIC
  x86 UEFI: Set UEFI OVMF as readonly
  x86 UEFI: Exit QEMU with return code
  x86 UEFI: Improve Boot Speed

 lib/efi.c            |  63 +++++++--
 lib/efi.h            |  19 ++-
 lib/linux/efi.h      | 317 ++++++++++++++-----------------------------
 lib/x86/acpi.c       |  36 +++--
 lib/x86/acpi.h       |   5 +-
 lib/x86/asm/setup.h  |  16 +--
 lib/x86/setup.c      | 145 +++++++++-----------
 lib/x86/usermode.c   |   3 +-
 scripts/runtime.bash |  14 +-
 x86/Makefile.common  |  10 +-
 x86/Makefile.x86_64  |   7 +-
 x86/access.c         |   9 +-
 x86/cet.c            |   8 +-
 x86/efi/run          |  45 +++---
 x86/emulator.c       |   5 +-
 x86/eventinj.c       |   8 ++
 x86/run              |   6 +-
 x86/smap.c           |  13 +-
 x86/umip.c           |  26 +++-
 19 files changed, 361 insertions(+), 394 deletions(-)

-- 
2.33.0

