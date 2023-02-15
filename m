Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152B369733C
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjBOBKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjBOBKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:10:17 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBEC32E4C
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:49 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l18-20020a17090add9200b00230f60889d6so7236484pjv.3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=03cgvFPbNe6ByH9lxxxwUZiJnOgauDq0XtWJ16612IY=;
        b=Y4Ns2yXU/Y3lRHxaf5/ChQCqmGY80GsFChbWemb2iDqSQX5BNtQdidHVvWioMgOMr1
         QpXz/wqCPLUUSAAXmiBtHOI3ytlnxOaaebtdQEe8M01pamoBvcU+nFjo2yvCfnQjsV3Q
         PHQmA4vCwZ34u1+dZv+tfN0f1jOG6aR2kyybkNuESg5JC92/oy8Z5JPoufdyvHyyeLk2
         hEBD8VdmV68LiO+PCau6sDEc2TRFwdpu0fk0XLrjD5dEM3N/XmYsy7I8jz2Jj7mIWZQs
         3LTUS77F0RdPnwgXwKEbOA8BS20vWLbSuptIoFI+EWaIt//atn2OLxzor+GeIDMPzQim
         b/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03cgvFPbNe6ByH9lxxxwUZiJnOgauDq0XtWJ16612IY=;
        b=KsfDeQ7BStg1pMry2SIQys1NdBjBokAXLS1su9Er4pxgCzEyW2iAdR0R13QcYp6gYd
         bQQc8BD84cHgbZN9X+oXFhb9VVFAJ+eJ+ESjg/W3uPWaZpNlUcC4kEk2lZMbVzsE8610
         9d0cnuHJ8t8G7y8F276y7RELoavJXL/l+3hverW4bxIenAAJgkQUSEzxTi9fGGkmjSAQ
         JtjK7vKUDyxfxaNDv4ZBkakEWR0jZ4YTyjYfAg9OunXHpGuYOSnxwWEpxd7lk/mad6Yz
         PMUha6e1pr200DUZcuru/YUXvFpLb0m06XjgGkc1w1gPAPudMa/cvQyOmJIaKK6w3B4N
         8UoQ==
X-Gm-Message-State: AO0yUKXrkD6SQ+BT9F+LuFaOjSouwtkAGPMHJS8Oy3gffcb0BQPh9AW/
        6spf8fp/yMC05I3/LElQeqL8PQVhot4=
X-Google-Smtp-Source: AK7set/dFXuS4OKP5Jhrmgn9iWQBsZg8tuoPs/ACl5tisbkxkQp1bPDAQSy/w3we1Na6WQVOIex1AlSKVR0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:5b86:0:b0:5a8:d169:581e with SMTP id
 p128-20020a625b86000000b005a8d169581emr16698pfb.49.1676423312040; Tue, 14 Feb
 2023 17:08:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:13 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Misc KVM x86 changes for 6.3.

Note, the cpufeatures.h change will conflict with changes in the tip tree, but
the resolution should be straightforward.

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.3

for you to fetch changes up to e73ba25fdc241c06ab48a1f708a30305d6036e66:

  KVM: x86: Simplify msr_io() (2023-02-03 15:55:17 -0800)

----------------------------------------------------------------
KVM x86 changes for 6.3:

 - Advertise support for Intel's fancy new fast REP string features

 - Fix a double-shootdown issue in the emergency reboot code

 - Ensure GIF=1 and disable SVM during an emergency reboot, i.e. give SVM
   similar treatment to VMX

 - Update Xen's TSC info CPUID sub-leaves as appropriate

 - Add support for Hyper-V's extended hypercalls, where "support" at this
   point is just forwarding the hypercalls to userspace

 - Clean up the kvm->lock vs. kvm->srcu sequences when updating the PMU and
   MSR filters

 - One-off fixes and cleanups

----------------------------------------------------------------
David Matlack (1):
      KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging

Jim Mattson (2):
      x86/cpufeatures: Add macros for Intel's new fast rep string features
      KVM: x86: Advertise fast REP string features inherent to the CPU

Kees Cook (1):
      KVM: x86: Replace 0-length arrays with flexible arrays

Michal Luczaj (8):
      KVM: x86/emulator: Fix segment load privilege level validation
      KVM: x86/emulator: Fix comment in __load_segment_descriptor()
      KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_SET_PMU_EVENT_FILTER)
      KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_X86_SET_MSR_FILTER)
      KVM: x86: Simplify msr_filter update
      KVM: x86: Explicitly state lockdep condition of msr_filter update
      KVM: x86: Remove unnecessary initialization in kvm_vm_ioctl_set_msr_filter()
      KVM: x86: Simplify msr_io()

Paul Durrant (2):
      KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also capture limit
      KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present

Sean Christopherson (4):
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Vipin Sharma (5):
      KVM: x86: hyper-v: Use common code for hypercall userspace exit
      KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
      KVM: selftests: Test Hyper-V extended hypercall enablement
      KVM: selftests: Replace hardcoded Linux OS id with HYPERV_LINUX_OS_ID
      KVM: selftests: Test Hyper-V extended hypercall exit to userspace

ye xingchen (1):
      KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()

 arch/x86/include/asm/cpufeatures.h                 |  3 +
 arch/x86/include/asm/kvm_host.h                    |  9 +-
 arch/x86/include/asm/reboot.h                      |  2 +
 arch/x86/include/asm/virtext.h                     | 16 +++-
 arch/x86/include/asm/xen/hypervisor.h              |  4 +-
 arch/x86/include/uapi/asm/kvm.h                    |  5 +-
 arch/x86/kernel/crash.c                            | 17 +---
 arch/x86/kernel/reboot.c                           | 88 ++++++++++++++------
 arch/x86/kernel/smp.c                              |  6 +-
 arch/x86/kvm/cpuid.c                               | 31 ++++---
 arch/x86/kvm/emulate.c                             |  6 +-
 arch/x86/kvm/hyperv.c                              | 55 ++++++++----
 arch/x86/kvm/pmu.c                                 |  3 +-
 arch/x86/kvm/vmx/vmx.c                             |  9 +-
 arch/x86/kvm/x86.c                                 | 34 +++-----
 arch/x86/kvm/xen.c                                 | 26 ++++++
 arch/x86/kvm/xen.h                                 |  7 ++
 tools/testing/selftests/kvm/Makefile               |  1 +
 .../testing/selftests/kvm/include/x86_64/hyperv.h  |  5 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |  1 +
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |  2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        | 97 ++++++++++++++++++++++
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  9 ++
 23 files changed, 327 insertions(+), 109 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
