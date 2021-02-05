Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A952A310645
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhBEIGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:06:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbhBEIG0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 03:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612512300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Va8uAp49smeqnrGGNNLNfaP87j7pFRlQR8LmmQQElkQ=;
        b=Of1tirRHisVfp397yUBJbRCJpwcxZu/yGoeTT7ulxKwO5DuPhNq5qhD1PvQrqukpvIZYN1
        +NzrA6ra9megP7fh9v3Oxods5Ed1IDW1tNAN58vLZH/5FVPzZY2tH5+ghrva3xqTI2JYxe
        szn1yKLdfzsx1/704+HSp907QHMi6L4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-_G6phLwKNFSCJM1iRO4bTQ-1; Fri, 05 Feb 2021 03:04:58 -0500
X-MC-Unique: _G6phLwKNFSCJM1iRO4bTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42264192D785;
        Fri,  5 Feb 2021 08:04:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2A275D9D3;
        Fri,  5 Feb 2021 08:04:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 5.11-rc7
Date:   Fri,  5 Feb 2021 03:04:56 -0500
Message-Id: <20210205080456.30446-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9a78e15802a87de2b08dfd1bd88e855201d2c8fa:

  KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX (2021-01-25 18:54:09 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 031b91a5fe6f1ce61b7617614ddde9ed61e252be:

  KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset (2021-02-04 12:59:28 -0500)

----------------------------------------------------------------
x86 has lots of small bugfixes, mostly one liners.  It's quite late in
5.11-rc but none of them are related to this merge window; it's just
bugs coming in at the wrong time.  Of note among the others:
- "KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off"
  (live migration failure seen on distros that hadn't switched to tsx=off
  right away)

ARM:
- Avoid clobbering extra registers on initialisation

----------------------------------------------------------------
Andrew Scull (1):
      KVM: arm64: Don't clobber x4 in __do_hyp_init

Ben Gardon (1):
      KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs

Michael Roth (1):
      KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2 ioctl

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-5.11-3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off
      KVM: x86: cleanup CR3 reserved bits checks

Peter Gonda (1):
      Fix unsynchronized access to sev members through svm_register_enc_region

Sean Christopherson (3):
      KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode
      KVM: SVM: Treat SVM as unsupported when running as an SEV guest
      KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset

Vitaly Kuznetsov (1):
      KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check

Yu Zhang (1):
      KVM: Documentation: Fix documentation for nested.

Zheng Zhan Liang (1):
      KVM/x86: assign hva with the right value to vm_munmap the pages

 Documentation/virt/kvm/nested-vmx.rst            |  6 +++--
 Documentation/virt/kvm/running-nested-guests.rst |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S               | 20 ++++++++-------
 arch/x86/kvm/cpuid.c                             |  2 +-
 arch/x86/kvm/emulate.c                           |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c                       |  6 ++---
 arch/x86/kvm/svm/nested.c                        | 13 +++-------
 arch/x86/kvm/svm/sev.c                           | 17 +++++++------
 arch/x86/kvm/svm/svm.c                           |  5 ++++
 arch/x86/kvm/svm/svm.h                           |  3 ---
 arch/x86/kvm/vmx/vmx.c                           | 17 ++++++++++---
 arch/x86/kvm/x86.c                               | 31 ++++++++++++++++--------
 arch/x86/kvm/x86.h                               |  2 ++
 arch/x86/mm/mem_encrypt.c                        |  1 +
 14 files changed, 77 insertions(+), 50 deletions(-)

