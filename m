Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CC440D46
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhJaF7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhJaF7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBEC061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:38 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v20so9524081plo.7
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBNhVfuCJj6AQYDEu16MrPF3LkK18qjyFVQeTPxLcfc=;
        b=QXvYhQlC8s4UyAA4nzRvZvZ71/xxKO0sc21IyM71Mq1hUk8W2axTFJFAQS8AVpf77X
         jI0m2hRhDZ3k15KiZHrA5Mer3OQMOQWZXbnS+AVa9BDWttRQb2caPSzguvtTWqRS43zD
         rZW3GCCzTCcDOg/SnjMvByy9ypLvNTj5B/SzVl4XoBzaSZp1cRmF483xj9wjd7OfHtrx
         ZyiuSGrT8PGVIbcddFFftYK3WFH4FP0WvfrnYCj6uCc2Wiyql0KzKyRuoCAOGbQphl7a
         3juT+ogZW2gKy9lxMzgQWaWUoX3UxBAvIV4s9HRYGGw7Nsgx8ycT4vuZDs8dbu/PxulZ
         jtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBNhVfuCJj6AQYDEu16MrPF3LkK18qjyFVQeTPxLcfc=;
        b=pDJNdWyXEmEAjBEomVj/aLTbJP1iKGbofz1iJ0QR/bTZPyDD6ONsLH4icpY627sFMr
         yd4c6pkdRDfn9eS4EZdTTPHqFdNHsqi5qKGhLiJlamnuVhw7Wb3a6pLh3p4KxqFO07XA
         X3opyK2u1zpKyLbG2rkMpt80NPAKSDRa4lPBteXQzQs2tNNnzxEuwHlsU5bmZcEA2m+P
         l9W96GZDUAwQHmDpF3GNoI7u9wfeLumVTwnKWihTJowqaY/QH8UV0NSu3jBUlCBd2FPC
         /n8SASGF6YV2VjhidV0VdA3R/fGzcS+XkzWcKIORUSRn1YGtjewU0Dpi07UdAd7k0dpn
         DMUQ==
X-Gm-Message-State: AOAM531rLJu8eiQD7509ep3h7mOpDneNDyweyGOVL/6vfGToELVQjPyd
        LEHfmWuwiLb0g64L63P3ozNl28OQ64/2yg==
X-Google-Smtp-Source: ABdhPJyfVKf1D+Af++/iJsWGft+GorMAUQ7qidqjZfWNeBvdH9qS8lZWQ7jqJEnqZ4fRMjrhZGDc0w==
X-Received: by 2002:a17:902:8549:b0:141:6804:5fb7 with SMTP id d9-20020a170902854900b0014168045fb7mr18583538plo.39.1635659797230;
        Sat, 30 Oct 2021 22:56:37 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:36 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 0/7] x86_64 UEFI set up process refactor and scripts fixes
Date:   Sat, 30 Oct 2021 22:56:27 -0700
Message-Id: <20211031055634.894263-1-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series refactors the x86_64 UEFI set up process and fixes the
`run-tests.sh` script to run under UEFI. The patches are organized as
three parts.

The first part (patches 1-2) refactors the x86_64 UEFI set up process.
The previous UEFI setup calls arch-specific setup functions twice and
generates arch-specific data structure. As Andrew suggested [1], we
refactor this process to make only one call to the arch-specific
function and generate arch-neutral data structures. This simplifies the
set up process and makes it easier to develop UEFI support for other
architectures.

The second part (patch 3) converts several x86 test cases to
Position-Independent Code (PIC) to run under UEFI. This patch is ported
from the initial UEFI support patchset [2] with fixes to the 32-bit
compilation.

The third part (patches 4-7) fixes the UEFI runner scripts. Patch 4 sets
UEFI OVMF image as readonly. Patch 5 fixes test cases' return code under
UEFI, enabling Patch 6-7 to fix the `run-tests.sh` script under UEFI.

This patch set is based on the `uefi` branch.

Best regards,
Zixuan Wang and Marc Orr

[1] https://lore.kernel.org/kvm/20211005060549.clar5nakynz2zecl@gator.home/
[2] https://lore.kernel.org/kvm/20211004204931.1537823-1-zxwang42@gmail.com/

Marc Orr (2):
  scripts: Generalize EFI check
  x86 UEFI: Make run_tests.sh (mostly) work under UEFI

Zixuan Wang (5):
  x86 UEFI: Remove mixed_mode
  x86 UEFI: Refactor set up process
  x86 UEFI: Convert x86 test cases to PIC
  x86 UEFI: Set UEFI OVMF as readonly
  x86 UEFI: Exit QEMU with return code

 lib/efi.c            |  54 ++++++--
 lib/efi.h            |  19 ++-
 lib/linux/efi.h      | 317 ++++++++++++++-----------------------------
 lib/x86/acpi.c       |  36 +++--
 lib/x86/acpi.h       |   5 +-
 lib/x86/asm/setup.h  |  16 +--
 lib/x86/setup.c      | 153 ++++++++++-----------
 lib/x86/usermode.c   |   3 +-
 scripts/common.bash  |   9 +-
 scripts/runtime.bash |  15 +-
 x86/Makefile.common  |  10 +-
 x86/Makefile.x86_64  |   7 +-
 x86/access.c         |   9 +-
 x86/cet.c            |   8 +-
 x86/efi/run          |  27 +++-
 x86/emulator.c       |   5 +-
 x86/eventinj.c       |   8 ++
 x86/run              |   6 +-
 x86/smap.c           |  13 +-
 x86/umip.c           |  26 +++-
 20 files changed, 360 insertions(+), 386 deletions(-)

-- 
2.33.0

