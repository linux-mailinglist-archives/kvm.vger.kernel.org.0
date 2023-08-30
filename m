Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A023678D0E9
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbjH3AHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241368AbjH3AGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF23BCC3
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56fb25e0c0dso5304513a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693354001; x=1693958801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XjLWzRn8wcKpt0GH3xFiPtZnpiJqVfnw/dQjtC9o2Z4=;
        b=w00jqN8cq0yfXp9vEKtMwOEsZyhtvIkIf7IpWdKzS0cQCBskfVYRCOb8Lp+bC0WO67
         UbBroT8Y0/Q23d2nTppiwPVDRco8/IaGrvivVFjfoyjdIUcGl+j9/Bqv2iB2FlLn630W
         zcJPVZ9iM7mCUDMGzokUCFmOMzgso1c3sWtQkbS7hcLTPt9qHe9D650515uOU5H9jKXM
         iHT0ABwZGJdDHDoIoXx3ex5DWGbC0wV23+d8GfLGty3sCdV7EfX8e3r99e94RFpQhDf3
         LflTJ/xiqvE3PKlc/ELKzIN8E3LHUcOGv4YCngNHIQ3M1/x1V7Wl90AJW15mnqxJ6dBr
         Dwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693354001; x=1693958801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XjLWzRn8wcKpt0GH3xFiPtZnpiJqVfnw/dQjtC9o2Z4=;
        b=BnBrzLI6UI/HglqKEo1X05j5sOxJ4uQlKjGUp4A+pzo0cXtkkTULU3T0xFEc3QD2Wu
         ANLecviHQyNDwKcJmB0V8Wkx9Snrn2h3lGckCqyHncdMU+22y942wkK20aTvytzNUnoa
         rVNyyEGFPq+pdz71MALyGXHBvb51k2xCq7WEJQoPH/4SEY1MGTHf0lOK6CrLjoX0jzLS
         Qv4apF/EDAE5WFLBj8KODVbHnZg3rqfnqAWFh2bnq7a0YnFDiN3tVZ2oZQ9WbAvn/bGl
         tXaJPWrEivClkBelIKI6PNL/ChlSR8B0EcSKvu+GdBenwmfnlVYfyh8D7fDpaatDBwOv
         BNaQ==
X-Gm-Message-State: AOJu0YwLkvvmLBldzS0BDMy/e01JPjjOIgepyF3yy94B2ourXXn/Fm7n
        V12dJ35+Sn3rMoE7uN9kvXtLrNwmJ/w=
X-Google-Smtp-Source: AGHT+IGbSOmacSoM1ZKF5uwR6BD/+f2W0Jt6UMWeWXFuLJHWy+5HMydpWpq2nliyYqfgGSK+RN7J2qNSh2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:a706:0:b0:56a:b197:12ca with SMTP id
 d6-20020a63a706000000b0056ab19712camr86809pgf.2.1693354001481; Tue, 29 Aug
 2023 17:06:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:28 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull common/misc x86 changes.  The two highlights are overhauling the
emergency reboot code and adding a framework to allow querying if the guest can
use a feature via guest_can_use(vcpu, X86_FEATURE_*) without having to search
through guest CPUID at runtime.

The guest_can_use() changes conflict with LBR virtualization cleanups from the
SVM pull request.  Below is the resolution I've been using.  FWIW, I've been
merging this "misc" branch last in all of my merges to kvm-x86/next, trying to
merge "svm" after "misc" yields a truly ugly conflict (IMO).

diff --cc arch/x86/kvm/svm/svm.c
index 5cf2380c89dd,226b3a780d0f..b21253c9ceb4
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@@ -1004,10 -1017,16 +1040,10 @@@ static struct vmcb *svm_get_lbr_vmcb(st
  void svm_update_lbrv(struct kvm_vcpu *vcpu)
  {
        struct vcpu_svm *svm = to_svm(vcpu);
 -
 -      bool enable_lbrv = svm_get_lbr_msr(svm, MSR_IA32_DEBUGCTLMSR) &
 -                                         DEBUGCTLMSR_LBR;
 -
 -      bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
 -                                    LBR_CTL_ENABLE_MASK);
 -
 -      if (unlikely(is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV)))
 -              if (unlikely(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))
 -                      enable_lbrv = true;
 +      bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
 +      bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
-                          (is_guest_mode(vcpu) && svm->lbrv_enabled &&
++                         (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 +                          (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
  
        if (enable_lbrv == current_enable_lbrv)
                return;


The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.6

for you to fetch changes up to 9717efbe5ba3f52d4b3cc637c7f7f6149ea264bb:

  KVM: x86: Disallow guest CPUID lookups when IRQs are disabled (2023-08-17 11:43:32 -0700)

----------------------------------------------------------------
KVM x86 changes for 6.6:

 - Misc cleanups

 - Retry APIC optimized recalculation if a vCPU is added/enabled

 - Overhaul emergency reboot code to bring SVM up to par with VMX, tie the
   "emergency disabling" behavior to KVM actually being loaded, and move all of
   the logic within KVM

 - Fix user triggerable WARNs in SVM where KVM incorrectly assumes the TSC
   ratio MSR can diverge from the default iff TSC scaling is enabled, and clean
   up related code

 - Add a framework to allow "caching" feature flags so that KVM can check if
   the guest can use a feature without needing to search guest CPUID

----------------------------------------------------------------
Li zeming (1):
      x86: kvm: x86: Remove unnecessary initial values of variables

Like Xu (2):
      KVM: x86: Use sysfs_emit() instead of sprintf()
      KVM: x86: Remove break statements that will never be executed

Michal Luczaj (1):
      KVM: x86: Remove x86_emulate_ops::guest_has_long_mode

Sean Christopherson (44):
      KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
      KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
      KVM: x86: Retry APIC optimized map recalc if vCPU is added/enabled
      x86/reboot: VMCLEAR active VMCSes before emergency reboot
      x86/reboot: Harden virtualization hooks for emergency reboot
      x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
      x86/reboot: KVM: Disable SVM during reboot via virt/KVM reboot callback
      x86/reboot: Assert that IRQs are disabled when turning off virtualization
      x86/reboot: Hoist "disable virt" helpers above "emergency reboot" path
      x86/reboot: Disable virtualization during reboot iff callback is registered
      x86/reboot: Expose VMCS crash hooks if and only if KVM_{INTEL,AMD} is enabled
      x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
      x86/virt: KVM: Move VMXOFF helpers into KVM VMX
      KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
      x86/virt: Drop unnecessary check on extended CPUID level in cpu_has_svm()
      x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
      KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_supported()
      KVM: VMX: Ensure CPU is stable when probing basic VMX support
      x86/virt: KVM: Move "disable SVM" helper into KVM SVM
      KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
      KVM: SVM: Use "standard" stgi() helper when disabling SVM
      KVM: VMX: Skip VMCLEAR logic during emergency reboots if CR4.VMXE=0
      KVM: nSVM: Check instead of asserting on nested TSC scaling support
      KVM: nSVM: Load L1's TSC multiplier based on L1 state, not L2 state
      KVM: nSVM: Use the "outer" helper for writing multiplier to MSR_AMD64_TSC_RATIO
      KVM: SVM: Clean up preemption toggling related to MSR_AMD64_TSC_RATIO
      KVM: x86: Always write vCPU's current TSC offset/ratio in vendor hooks
      KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if guest state isn't loaded
      KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU
      KVM: x86: Add a framework for enabling KVM-governed x86 features
      KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES enabled"
      KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
      KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE enabling
      KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_XYZ"
      KVM: x86: Use KVM-governed feature framework to track "XSAVES enabled"
      KVM: nVMX: Use KVM-governed feature framework to track "nested VMX enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LOAD} enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "LBRv enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "Pause Filter enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vGIF enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vNMI enabled"
      KVM: x86: Disallow guest CPUID lookups when IRQs are disabled

Takahiro Itazuri (1):
      KVM: x86: Advertise host CPUID 0x80000005 in KVM_GET_SUPPORTED_CPUID

Tao Su (1):
      KVM: x86: Advertise AMX-COMPLEX CPUID to userspace

 arch/x86/include/asm/kexec.h     |   2 -
 arch/x86/include/asm/kvm_host.h  |  24 ++++-
 arch/x86/include/asm/reboot.h    |   7 ++
 arch/x86/include/asm/virtext.h   | 154 -------------------------------
 arch/x86/include/asm/vmx.h       |   2 +-
 arch/x86/kernel/crash.c          |  31 -------
 arch/x86/kernel/reboot.c         |  66 ++++++++++----
 arch/x86/kvm/Kconfig             |   2 +-
 arch/x86/kvm/cpuid.c             |  40 ++++++++-
 arch/x86/kvm/cpuid.h             |  46 ++++++++++
 arch/x86/kvm/emulate.c           |   2 -
 arch/x86/kvm/governed_features.h |  21 +++++
 arch/x86/kvm/hyperv.c            |   1 -
 arch/x86/kvm/kvm_emulate.h       |   1 -
 arch/x86/kvm/lapic.c             |  29 +++++-
 arch/x86/kvm/mmu/mmu.c           |  22 +----
 arch/x86/kvm/reverse_cpuid.h     |   1 +
 arch/x86/kvm/svm/nested.c        |  57 +++++++-----
 arch/x86/kvm/svm/svm.c           | 150 +++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h           |  18 ++--
 arch/x86/kvm/vmx/capabilities.h  |   2 +-
 arch/x86/kvm/vmx/hyperv.c        |   2 +-
 arch/x86/kvm/vmx/nested.c        |  13 +--
 arch/x86/kvm/vmx/nested.h        |   2 +-
 arch/x86/kvm/vmx/vmx.c           | 190 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h           |   3 +-
 arch/x86/kvm/x86.c               |  46 +++++-----
 arch/x86/kvm/x86.h               |   1 +
 28 files changed, 490 insertions(+), 445 deletions(-)
 delete mode 100644 arch/x86/include/asm/virtext.h
 create mode 100644 arch/x86/kvm/governed_features.h
