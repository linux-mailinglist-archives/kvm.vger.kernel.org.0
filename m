Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B776ED396
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjDXRfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjDXRfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1256EB8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:38 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f9af249edso76328927b3.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357737; x=1684949737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hQQyacbvV+fZi1Gj6MygzKif6Fhxl4s9g1Kbo2gn6ek=;
        b=Rf+Lew+f/1NMGOQtBMJyQ0SXpfCGJqnYBHPDwEbJu00V6NR0Ca6xZ39JO/yydzYlhm
         18IVQlQcMdur1Ith/LZo173hbyvBbUdIX4QhTNpBVFwCehjAJ3ZDas/McMwfdfc0a2Qa
         WzgEv3YaJTv5KYZWV6PreV7rOAHcK2RNVM87OZePBrOgznuPUPq4oARa1Ld3BMno7w1Q
         YIjnSo9vbB9J4JrZb9z+CdGN5y4WFr6+9zOggWe6673j2oEUp0aRxMkdC2I4IRDQsOJ6
         2BqqxFoOSem8alzKWQJOs10CTYvsxvixlB4d7NENkmRngA4FAme+TTUdr6OtT1U0K2Np
         s3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357737; x=1684949737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQQyacbvV+fZi1Gj6MygzKif6Fhxl4s9g1Kbo2gn6ek=;
        b=ZLVXJNsjSlRyaaZWjnncyVs6UA95+POGno06gNmX7Y7L07w17qXWl/OxngHz+KTP83
         Muysh0JiKlPttAGNUhETvfZPEpSOf45nqxCmdEGEiLfFvcXkmH7GbSwm82v4hoSIJ3jq
         WOwOriCy6h417xdlhgQNkthdSEPs8OIVNN5w7+1tYwZiLEV2gLDh8s1SQfAAXfLz65u4
         3UpXygZ9/YUp+a0YoqJYS8UvdiNJ9wP3jLxznFtEaKXhXrZheeBIjrmtWb7jWUdfMwIm
         6dbWZYCCOf1TuMrBANr3H5bb6FNcPIJKfoHpddYLCHpIw7shX8+UrcPXb314L2i00OUa
         NFWA==
X-Gm-Message-State: AAQBX9d3A8suvUHrJ/zClZkhKVXCaiPLJWS7E6xKTqcxtFMzIH8X8Aw4
        FzETaAIsra3U8ZQehrkj5YDqWAXdQfM=
X-Google-Smtp-Source: AKy350YDvUzFGQ65l7LYQNt+ze3A6niNgLXD/u30TY8SnAHTc0dX0NI3660pB4Z/bioXIWuOcJcKHiPY4Ac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4145:0:b0:556:fa9:f1c7 with SMTP id
 f5-20020a814145000000b005560fa9f1c7mr6551696ywk.10.1682357737369; Mon, 24 Apr
 2023 10:35:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:24 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.4.
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86 "misc" changes for 6.4.  The two highlights are Mathias'
optimization for CR0.WP toggling and Binbin's addition of helpers to query
individual CR0/CR4 bits (a very nice and overdue cleanup).

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.4

for you to fetch changes up to cf9f4c0eb1699d306e348b1fd0225af7b2c282d3:

  KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults (2023-04-10 15:25:36 -0700)

----------------------------------------------------------------
KVM x86 changes for 6.4:

 - Optimize CR0.WP toggling by avoiding an MMU reload when TDP is enabled,
   and by giving the guest control of CR0.WP when EPT is enabled on VMX
   (VMX-only because SVM doesn't support per-bit controls)

 - Add CR0/CR4 helpers to query single bits, and clean up related code
   where KVM was interpreting kvm_read_cr4_bits()'s "unsigned long" return
   as a bool

 - Move AMD_PSFD to cpufeatures.h and purge KVM's definition

 - Misc cleanups

----------------------------------------------------------------
Binbin Wu (4):
      KVM: x86: Add helpers to query individual CR0/CR4 bits
      KVM: x86: Use boolean return value for is_{pae,pse,paging}()
      KVM: SVM: Use kvm_is_cr4_bit_set() to query SMAP/SMEP in "can emulate"
      KVM: x86: Change return type of is_long_mode() to bool

Mathias Krause (4):
      KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
      KVM: x86: Ignore CR0.WP toggles in non-paging mode
      KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
      KVM: VMX: Make CR0.WP a guest owned bit

Robert Hoo (1):
      KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()

Sean Christopherson (4):
      KVM: SVM: Fix benign "bool vs. int" comparison in svm_set_cr0()
      x86: KVM: Add common feature flag for AMD's PSFD
      KVM: x86: Assert that the emulator doesn't load CS with garbage in !RM
      KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults

Tom Rix (1):
      KVM: x86: set "mitigate_smt_rsb" storage-class-specifier to static

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/cpuid.c               | 12 +++-------
 arch/x86/kvm/emulate.c             |  8 +++++++
 arch/x86/kvm/kvm_cache_regs.h      | 18 ++++++++++++++-
 arch/x86/kvm/mmu.h                 | 28 ++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu.c             | 15 +++++++++++++
 arch/x86/kvm/pmu.c                 |  4 ++--
 arch/x86/kvm/svm/svm.c             |  6 ++---
 arch/x86/kvm/vmx/nested.c          |  6 ++---
 arch/x86/kvm/vmx/vmx.c             |  8 +++----
 arch/x86/kvm/vmx/vmx.h             | 18 +++++++++++++++
 arch/x86/kvm/x86.c                 | 45 ++++++++++++++++++++++++--------------
 arch/x86/kvm/x86.h                 | 22 +++++++++----------
 13 files changed, 139 insertions(+), 52 deletions(-)
