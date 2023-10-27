Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE347DA1FB
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346555AbjJ0Utt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346529AbjJ0Utp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE00B1B8
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:42 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5b79f96718eso1361171a12.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439782; x=1699044582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=di11lWawOmLCcXEAkUakkRrsqpIr6RYJN4TydENb44I=;
        b=vuQo9lr2Pg5EwCwgzhYdltwG4B8DOCJcgzrfLOX6yiCsGAWjpXxutiv1fRg8N4QOcI
         6Y6p6Vh37qBmYo5COVLuOZXdY2aXJz/utC3QLk93IjbvAEVbqMsjF24lgYr0xD9kFC1o
         0cLEM7PZR2Nk18mSK3KaCvAYOjP4i9LvSA8oWDivVX/GXDqAMJClYY4m3du664AlIQzU
         BKmA1s/aEu0BfS/JWJr5/zv8fzCyo2efkupLS8ihW33Wym8MC3I2L4UTpLa+qMZmFr+k
         wMGeyQ1IiEUjM+J5cSKwPPPzddOAoUYhu3mqOXfITP2bOTBf7fJqCfaKECzkSeULbLyM
         6a+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439782; x=1699044582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=di11lWawOmLCcXEAkUakkRrsqpIr6RYJN4TydENb44I=;
        b=tX7rUVUYykwb85mo9g8N4eglV/eTqxkDZyRs5mMi5orKbPVxRQWGgKjAPMtX1AsO0A
         6YCG2yx+xw7DbOQGy2eIKfEYZEtCat2Iw4UbPhupMCWKLZwxfRGUXNDps8GiaQlxfinn
         0wky10FdWTh6kFxD2tTL4EYfnbq6cd62VYzxJtiv1ulsW6Vuh+I3o3S1o/wI2jOqaSfx
         uLfeREPDvqPm35AFK65qOw3SYARyGmvACpL5hhnDHUFzueTLYAZT3oHC1pd8tLj/nAaR
         Gu2T2gpKnT/4uMtxhuFxoZZojOGtuAn0UPh8FSYHqz/IW5RKNBsodXZzDr0G08h02GKw
         a4zw==
X-Gm-Message-State: AOJu0YzuZojgGqQMa7po0hP4VVoe8e5M1kPuBEbwTXWiqh+q0BtTa0+C
        o6cwzrODAfzU1W7nxVJ25kbHv4CCHfw=
X-Google-Smtp-Source: AGHT+IFG4adNV6ZGP294DPLWrLbLf1SbNverFr5REYOdsktQrGEafacyYVaodboc6PQEjupRj8t7zXSvZ4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ad49:0:b0:5b9:2ff5:1fc9 with SMTP id
 y9-20020a63ad49000000b005b92ff51fc9mr94769pgo.5.1698439782477; Fri, 27 Oct
 2023 13:49:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:27 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A truly miscellaneous collection of patches this time around.  David M's PML
fix obviously belongs in the MMU pull request, but I applied it to the wrong
branch and didn't want to rebase for such a silly thing.

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.7

for you to fetch changes up to 2770d4722036d6bd24bcb78e9cd7f6e572077d03:

  KVM: x86: Ignore MSR_AMD64_TW_CFG access (2023-10-19 10:55:14 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.7:

 - Add CONFIG_KVM_MAX_NR_VCPUS to allow supporting up to 4096 vCPUs without
   forcing more common use cases to eat the extra memory overhead.

 - Add IBPB and SBPB virtualization support.

 - Fix a bug where restoring a vCPU snapshot that was taken within 1 second of
   creating the original vCPU would cause KVM to try to synchronize the vCPU's
   TSC and thus clobber the correct TSC being set by userspace.

 - Compute guest wall clock using a single TSC read to avoid generating an
   inaccurate time, e.g. if the vCPU is preempted between multiple TSC reads.

 - "Virtualize" HWCR.TscFreqSel to make Linux guests happy, which complain
    about a "Firmware Bug" if the bit isn't set for select F/M/S combos.

 - Don't apply side effects to Hyper-V's synthetic timer on writes from
   userspace to fix an issue where the auto-enable behavior can trigger
   spurious interrupts, i.e. do auto-enabling only for guest writes.

 - Remove an unnecessary kick of all vCPUs when synchronizing the dirty log
   without PML enabled.

 - Advertise "support" for non-serializing FS/GS base MSR writes as appropriate.

 - Use octal notation for file permissions through KVM x86.

 - Fix a handful of typo fixes and warts.

----------------------------------------------------------------
David Matlack (1):
      KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log when PML is disabled

David Woodhouse (1):
      KVM: x86: Refine calculation of guest wall clock to use a single TSC read

Dongli Zhang (1):
      KVM: x86: remove always-false condition in kvmclock_sync_fn

Jim Mattson (4):
      KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
      KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
      KVM: selftests: Test behavior of HWCR, a.k.a. MSR_K7_HWCR
      x86: KVM: Add feature flag for CPUID.80000021H:EAX[bit 1]

Josh Poimboeuf (2):
      KVM: x86: Add IBPB_BRTYPE support
      KVM: x86: Add SBPB support

Kyle Meyer (1):
      KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS to allow up to 4096 vCPUs

Liang Chen (1):
      KVM: x86: remove the unused assigned_dev_head from kvm_arch

Like Xu (1):
      KVM: x86: Don't sync user-written TSC against startup values

Maciej S. Szmigiero (1):
      KVM: x86: Ignore MSR_AMD64_TW_CFG access

Michal Luczaj (2):
      KVM: x86: Remove redundant vcpu->arch.cr0 assignments
      KVM: x86: Force TLB flush on userspace changes to special registers

Mingwei Zhang (1):
      KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()

Nicolas Saenz Julienne (1):
      KVM: x86: hyper-v: Don't auto-enable stimer on write from user-space

Peng Hao (1):
      KVM: x86: Use octal for file permission

 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |  12 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kvm/Kconfig                               |  11 ++
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/cpuid.h                               |   3 +-
 arch/x86/kvm/hyperv.c                              |  10 +-
 arch/x86/kvm/smm.c                                 |   1 -
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  20 +--
 arch/x86/kvm/x86.c                                 | 195 ++++++++++++++++-----
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/kvm/xen.c                                 |   4 +-
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c |  47 +++++
 15 files changed, 251 insertions(+), 66 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
