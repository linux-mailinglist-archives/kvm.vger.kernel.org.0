Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DA563FD23
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiLBAeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiLBAdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:33:54 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75692206
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:33:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a9so3216988pld.7
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 16:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=99AB5yLn4wHr5VWY8pXZ3nmcKZnM4CFSDh5cKvddspM=;
        b=Fm9QBgowk3rlowiCNfE607bjU7a2SgGOvYst9sgpc4CVGPrKyXVrOIMoY/2sc3U1j6
         TnxwZERFvZB974UlbBNO3CnBMMFLJvB/y4YB5quAYcQ0Hq49flqUHRLN4Ajyyjfcd2x4
         TxHxQ8e7AC8VUdFNCY57uBxWlFryoO2k0NM0PekYTekMDiS2MwC5snOxaGt/bV2m5NXc
         9RTr/5o/LDvU2SR2c0/Qm33g5vQFyaQXzwCqO62T+TOQJ+n7yqHZY346nKCZ8xyxlGEk
         vRmwOMD98dj9JPRN4xldxyJwlTbfxUPaQ0UmC1qXjml/TdjzUSl8c4VYopNsoGqlDD11
         +yRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99AB5yLn4wHr5VWY8pXZ3nmcKZnM4CFSDh5cKvddspM=;
        b=wcnYtPMqDpljfOqpx7dstWtkWiTpku8Nrl4uZopw/a3un3NXHA5K3ih7lrA/GY8RBs
         XWWjD8zcUe2qFEjl20ZOmFwZ50u8UZYR43BwkEg9vTYPWC+JGiux58DSZzjMgds+ChUO
         qfBIoBn0YvsRYoVOxEsGlSXlKWpQSe0LL96uC689m7uE+TFwZM64vwtd0gk4xCLfafe4
         FR/IZf/E83CZlqT92j9c0MjHgQZqERgSPaTp6+hou8kvL0UwI/HyrrZ5jf8mcHOUzuGk
         rIdZ+JIiw+OlZSfkvSQOGqPk1XbD5Mp8QFLpK1XlqrXkRgBSDWrDytfFiFUzwMSelavU
         ioCg==
X-Gm-Message-State: ANoB5pkk+0y+h171rl8RS/Ji52OJb5ZEIVmrnRKaT2iokCqktNIESKkt
        SCObFRzbVFAxIcZ4T2DuVHow3A==
X-Google-Smtp-Source: AA0mqf44am8PewPamjr4vW67vf5uYIQU4AYgdXJKWqIWlAhth6XmgHUzb05YTM7//dQfhK8tDPVYlw==
X-Received: by 2002:a17:902:6ac4:b0:186:bb44:946d with SMTP id i4-20020a1709026ac400b00186bb44946dmr50949121plt.11.1669941193863;
        Thu, 01 Dec 2022 16:33:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jc18-20020a17090325d200b001891a17bd93sm4276138plb.43.2022.12.01.16.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 16:33:13 -0800 (PST)
Date:   Fri, 2 Dec 2022 00:33:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [GIT PULL] KVM: x86: Fixes and cleanups for 6.2
Message-ID: <Y4lHxds8pvBhxXFX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull misc x86 fixes and cleanups that have been floating around for a
while.  These haven't been plugged into any bot-visible branch; I forgot about
most of them until doing a bit of fall/winter cleaning.  That said, the only
one that is substantially complex is Anton's TSC snapshot fix, and that's been
on the lists for many months.

Jim's IBPB fix is arguably fodder for 6.1, but the bug has been around for
2+ years so squeezing it in this late in the cycle doesn't seem necessary.

Holler if any of these give you pause!

Thanks!


The following changes since commit df0bb47baa95aad133820b149851d5b94cbc6790:

  KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT (2022-11-30 11:50:39 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.2-1

for you to fetch changes up to 3ebcbd2244f5a69e06e5f655bfbd8127c08201c7:

  KVM: x86: Use current rather than snapshotted TSC frequency if it is constant (2022-11-30 16:31:27 -0800)

----------------------------------------------------------------
Misc KVM x86 fixes and cleanups for 6.2:

 - One-off fixes for various emulation flows (SGX, VMXON, NRIPS=0).

 - Reinstate IBPB on emulated VM-Exit that was incorrectly dropped a few
   years back when eliminating unnecessary barriers when switching between
   vmcs01 and vmcs02.

 - Clean up the MSR filter docs.

 - Clean up vmread_error_trampoline() to make it more obvious that params
   must be passed on the stack, even for x86-64.

 - Let userspace set all supported bits in MSR_IA32_FEAT_CTL irrespective
   of the current guest CPUID.

 - Fudge around a race with TSC refinement that results in KVM incorrectly
   thinking a guest needs TSC scaling when running on a CPU with a
   constant TSC, but no hardware-enumerated TSC frequency.

----------------------------------------------------------------
Anton Romanov (1):
      KVM: x86: Use current rather than snapshotted TSC frequency if it is constant

Jim Mattson (2):
      KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
      KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

Peng Hao (1):
      KVM: x86: Keep the lock order consistent between SRCU and gpc spinlock

Sean Christopherson (12):
      KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
      KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
      KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid
      KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
      KVM: x86: Delete documentation for READ|WRITE in KVM_X86_SET_MSR_FILTER
      KVM: x86: Reword MSR filtering docs to more precisely define behavior
      KVM: x86: Clean up KVM_CAP_X86_USER_SPACE_MSR documentation
      KVM: nVMX: Reword comments about generating nested CR0/4 read shadows
      KVM: VMX: Make vmread_error_trampoline() uncallable from C code
      KVM: VMX: Allow userspace to set all supported FEATURE_CONTROL bits
      KVM: VMX: Move MSR_IA32_FEAT_CTL.LOCKED check into "is valid" helper
      KVM: selftests: Verify userspace can stuff IA32_FEATURE_CONTROL at will

Zhao Liu (1):
      KVM: SVM: Replace kmap_atomic() with kmap_local_page()

 Documentation/virt/kvm/api.rst                         | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 arch/x86/kvm/svm/sev.c                                 |   4 ++--
 arch/x86/kvm/svm/svm.c                                 |  10 ++++++++--
 arch/x86/kvm/vmx/nested.c                              |  80 +++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 arch/x86/kvm/vmx/nested.h                              |   7 ++++---
 arch/x86/kvm/vmx/sgx.c                                 |   4 +++-
 arch/x86/kvm/vmx/vmenter.S                             |   2 ++
 arch/x86/kvm/vmx/vmx.c                                 |  51 ++++++++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx_ops.h                             |  18 +++++++++++++++--
 arch/x86/kvm/x86.c                                     |  48 +++++++++++++++++++++++++++++++++------------
 arch/x86/kvm/xen.c                                     |   4 ++--
 tools/testing/selftests/kvm/include/x86_64/processor.h |   2 ++
 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c     |  47 ++++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 277 insertions(+), 117 deletions(-)
