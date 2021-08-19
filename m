Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D443F1841
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhHSLft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbhHSLfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:35:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93244C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id f5so8548224wrm.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sbYd0WEekw+QLghvfL0BP+ReA9I5TQN9JU0YkzI7KTQ=;
        b=Obj5fTbP/u5e+iWPyXLejP4yYBPA/Ivbc0TavosY9MGYF+FIdqNi/oTNjjMQPmDIY2
         BctjW22FS1/CesNloSRVCs+/BlTDo+BreBaIGIAZT1lGgUNrYRZxny3nU7ycbl7odkjj
         LHhajEnlm3+6k0Cjx2iE9LfPIm0trm47wnt9YitGkMYdEfb13MroIrw+1piUFrZtoI72
         ahqUSMd+KdX0waPaRd+yWzOP4jNfH/MPdmiZItcpHq5NNYK+2+UDoGIIjv5K47/MZZ9z
         vhx/5Jc3GPmMmwGT7ntA4qIxbZ+axp9Ju+F6nMXWXXphmhXje9+2qnrQdL1QcYMeYuKs
         tu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sbYd0WEekw+QLghvfL0BP+ReA9I5TQN9JU0YkzI7KTQ=;
        b=KPbPBRde97N6Z5XpBLoOk/0PR22ZPMdmqfU6IbnCy92bfsDtcFhLbHmUjrtTOL0g1Y
         DO2z0cfJjyQTizMfOpMghlVQENCBSikNPrkmYnzBYva3G4sYmDG7w2/dS58m+PvitXFj
         9smEN5GjeiNydLE1Vrq/sT3TIq4XODqh9dWMcDh0SOFL/Xeo63Oc0izb7gJdSMfYnF30
         voZSsvjJEzzIog6X+crpspAOASRe9R7ppOQ/txzICDjj4ZoN40fuU+gbMNEuH575V82z
         Rxv9baWg0xi28SG84lqFGusGGCh19u3k5TvnXMLISLuKvA8ThvE3gx+qkBXSW+WelWBM
         1A5w==
X-Gm-Message-State: AOAM533Z8H71m6X/maMnaKNDsrXGYaNSnWBgsMbuZfV9k1/bwJ10KtF7
        NXQUwNxb8IRJzJMYzgEEpu8=
X-Google-Smtp-Source: ABdhPJzwRZydutPtN144d9RU/VtXc8H5TN9tlP6YTjaoWM8gCnNXZPuqlzml3SGFQezqI9k57tAUBw==
X-Received: by 2002:adf:c549:: with SMTP id s9mr3303603wrf.344.1629372910154;
        Thu, 19 Aug 2021 04:35:10 -0700 (PDT)
Received: from xps13.suse.de (ip5f5a5c19.dynamic.kabel-deutschland.de. [95.90.92.25])
        by smtp.gmail.com with ESMTPSA id w11sm2682859wrr.48.2021.08.19.04.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:35:09 -0700 (PDT)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v2 0/6] Initial x86_64 UEFI support
Date:   Thu, 19 Aug 2021 13:33:54 +0200
Message-Id: <20210819113400.26516-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series brings EFI support to kvm-unit-tests on x86_64.

EFI support works by changing the test entrypoint to a stub entry
point for the EFI loader to jump to in long mode, where the test binary
exits EFI boot services, performs the remaining CPU bootstrapping,
and then calls the testcase main().

Since the EFI loader only understands PE objects, the first commit
introduces a `configure --efi` mode which builds each test as a shared
lib. This shared lib is repackaged into a PE via objdump.

Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
relocate ELF .dynamic contents.

Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.

Commit 6 from Zixuan [1] fixes up some testcases with non-PIC inline
asm stubs which allows building these as PIC.

Changes in v2:
- Add Zixuan's patch to enable more testcases.
- Fix TSS setup in cstart64.S for CONFIG_EFI.

[1]: https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google.com/
git tree: https://github.com/varadgautam/kvm-unit-tests/tree/efi-stub-v2

Varad Gautam (5):
  x86: Build tests as PE objects for the EFI loader
  x86: Call efi_main from _efi_pe_entry
  x86: efi_main: Get EFI memory map and exit boot services
  x86: efi_main: Self-relocate ELF .dynamic addresses
  cstart64.S: x86_64 bootstrapping after exiting EFI

Zixuan Wang (1):
  x86 UEFI: Convert x86 test cases to PIC

 .gitignore          |   2 +
 Makefile            |  16 +-
 configure           |  11 +
 lib/linux/uefi.h    | 518 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/usermode.c  |   3 +-
 x86/Makefile.common |  53 +++--
 x86/Makefile.x86_64 |  52 +++--
 x86/access.c        |   6 +-
 x86/cet.c           |   8 +-
 x86/cstart64.S      |  91 ++++++++
 x86/efi.lds         |  67 ++++++
 x86/efi_main.c      | 167 ++++++++++++++
 x86/emulator.c      |   5 +-
 x86/eventinj.c      |   6 +-
 x86/smap.c          |   8 +-
 x86/umip.c          |  10 +-
 16 files changed, 966 insertions(+), 57 deletions(-)
 create mode 100644 lib/linux/uefi.h
 create mode 100644 x86/efi.lds
 create mode 100644 x86/efi_main.c

-- 
2.30.2

