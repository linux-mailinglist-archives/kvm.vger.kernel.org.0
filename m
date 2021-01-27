Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C05305CDB
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313729AbhAZWl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:41:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390726AbhAZR5p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 12:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611683778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cjcRuMlXWMX2jcWSUD4WW4Hh5bqDrTG5xDVGalMcWRw=;
        b=Yv6kQKq5qrHBclSbN/cytZ8ipPVtmfWe0HY65/e+pZm/N/pJ7BcLMi5BOrZjPT70daa6j6
        CbxAFX0RkROD6C2otKx69am0dLV7R1L1DEWEISx2CEumEHRKgEUb+OrJXJgPXreEakaAQx
        /IxnB/BP85mjTTG5Sa9FYPos0RcS/SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-BbtHlCX8NPCzdHK19d6gLA-1; Tue, 26 Jan 2021 12:56:14 -0500
X-MC-Unique: BbtHlCX8NPCzdHK19d6gLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39718107ACF9;
        Tue, 26 Jan 2021 17:56:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD6D05D6AD;
        Tue, 26 Jan 2021 17:56:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.11-rc5
Date:   Tue, 26 Jan 2021 12:56:12 -0500
Message-Id: <20210126175612.1533411-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7c53f6b671f4aba70ff15e1b05148b10d58c2837:

  Linux 5.11-rc3 (2021-01-10 14:34:50 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9a78e15802a87de2b08dfd1bd88e855201d2c8fa:

  KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX (2021-01-25 18:54:09 -0500)

----------------------------------------------------------------
* x86 bugfixes
* Documentation fixes
* Avoid performance regression due to SEV-ES patches

ARM:
- Don't allow tagged pointers to point to memslots
- Filter out ARMv8.1+ PMU events on v8.0 hardware
- Hide PMU registers from userspace when no PMU is configured
- More PMU cleanups
- Don't try to handle broken PSCI firmware
- More sys_reg() to reg_to_encoding() conversions

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Use the reg_to_encoding() macro instead of sys_reg()

David Brazdil (1):
      KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return

Jay Zhou (1):
      KVM: x86: get smi pending status correctly

Like Xu (2):
      KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()
      KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Lorenzo Brescia (1):
      kvm: tracing: Fix unmatched kvm_entry and kvm_exit events

Marc Zyngier (4):
      KVM: arm64: Hide PMU registers from userspace when not available
      KVM: arm64: Simplify handling of absent PMU system registers
      KVM: arm64: Filter out v8.1+ events on v8.0 HW
      KVM: Forbid the use of tagged userspace addresses for memslots

Maxim Levitsky (1):
      KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.11-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX

Quentin Perret (1):
      KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM

Sean Christopherson (3):
      KVM: x86: Add more protection against undefined behavior in rsvd_bits()
      KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN of SEV-ES guest
      KVM: x86: Revert "KVM: x86: Mark GPRs dirty when written"

Steven Price (1):
      KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag

Zenghui Yu (1):
      KVM: Documentation: Update description of KVM_{GET,CLEAR}_DIRTY_LOG

 Documentation/virt/kvm/api.rst       | 21 ++++----
 arch/arm64/kvm/arm.c                 |  3 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 13 ++---
 arch/arm64/kvm/pmu-emul.c            | 10 ++--
 arch/arm64/kvm/sys_regs.c            | 93 ++++++++++++++++++++++--------------
 arch/x86/kvm/kvm_cache_regs.h        | 51 ++++++++++----------
 arch/x86/kvm/mmu.h                   |  9 +++-
 arch/x86/kvm/svm/nested.c            |  3 ++
 arch/x86/kvm/svm/sev.c               | 15 +++---
 arch/x86/kvm/svm/svm.c               |  2 +
 arch/x86/kvm/vmx/nested.c            | 44 ++++++++++++-----
 arch/x86/kvm/vmx/pmu_intel.c         |  6 ++-
 arch/x86/kvm/vmx/vmx.c               |  2 +
 arch/x86/kvm/x86.c                   | 11 +++--
 virt/kvm/kvm_main.c                  |  1 +
 15 files changed, 172 insertions(+), 112 deletions(-)

