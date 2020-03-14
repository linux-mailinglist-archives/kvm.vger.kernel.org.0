Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44821858BE
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCOCWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:22:50 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:40169 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbgCOCWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:22:50 -0400
Received: by mail-wm1-f54.google.com with SMTP id z12so5094218wmf.5;
        Sat, 14 Mar 2020 19:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=BqK64CqX9MkYP0O18+eeXN3RJtGVpqkBACDnpy+yIYU=;
        b=PSRMlx9UOnyMJETtPmTFyRyfM+BrbnsVgo7ymMS2qabHUK+Mh/9EQ4Xqdjj56eRgjq
         YXnbaGeH26G/27dfND5UORZz7taHyHrCkbcrg9pfAnoTF0nfhnZw53HiACa+WKwen3zY
         lhpD7RXrVFX9yIQ8UBxXzpR97lyzB+EVbHKpRxZV8P+xjhMllZpUvm+GH72ZeN7L2bHo
         L9/J+GM/vJq/aK2bbnrJzWA+F47f8azWZw0JZb6tkru58eMu0lhPDsUo5Jmk9N8b0RQ9
         AoECPocZeqzz7vng8s+TnBcn3gY9XDNaGVbyi9F+Bpb0kwm7G8v9ovRA4FnXZW+8CRij
         /GGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=BqK64CqX9MkYP0O18+eeXN3RJtGVpqkBACDnpy+yIYU=;
        b=jLMPmRPea0/trkCXglj5PqbsNFqe9rXJzUsLdbyVz3sr+l39rQCUtxC1Bw0hi5Ns3D
         tV440fBR79erH8MJDWArcmLFohbcSJa3wMpJMtuRPHKDPFX6JaJk8c7A4k4mTIHdXIrG
         SHv5fA8d/AVaAYsMADK/akkUPNRDm58raBqGFsy9WkwGRTIFZ7sEwc8sMh++4jrdpIKk
         bGDIOz7WczcJo9cFKuT8HF3UEunKFDZyb8u8kAc8UCAeko1k/nOUyxiWwzDL5hNxiKSf
         K4cM5fCTAdksIygZWUpcU5rspbh1T7+/1pKTAqR6psrvxGc8t7BgTvnrvPYFCql10kZj
         J1IA==
X-Gm-Message-State: ANhLgQ1TaA75f69yjeGEIajoQZaIjMy1EuuPs/8nnlcLWPq6sBJonD2I
        hQNMloRHBo0qfVBHZmVnzmUNSgxC
X-Google-Smtp-Source: ADFU+vuH6dqS2RIj/k++jM0ssC6J89atScvbiezFQRbu9tPKgJiU8oHViSeao2b+BkefI6C7rgjbXg==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr17582653wmb.124.1584212973682;
        Sat, 14 Mar 2020 12:09:33 -0700 (PDT)
Received: from 640k.lan ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id c26sm21731452wmb.8.2020.03.14.12.09.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Mar 2020 12:09:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.6-rc6
Date:   Sat, 14 Mar 2020 20:09:30 +0100
Message-Id: <1584212970-13453-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 86f7e90ce840aa1db407d3ea6e9b3a52b2ce923c:

  KVM: VMX: check descriptor table exits on instruction emulation (2020-03-01 19:26:31 +0100)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 018cabb694e3923998fdc2908af5268f1d89f48f:

  Merge branch 'kvm-null-pointer-fix' into kvm-master (2020-03-14 12:49:37 +0100)

----------------------------------------------------------------

Bugfixes, x86+s390.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: Also reset registers in sync regs for initial cpu reset

Haiwei Li (1):
      KVM: SVM: Fix the svm vmexit code for WRMSR

Jason A. Donenfeld (1):
      KVM: fix Kconfig menu text for -Werror

Nitesh Narayan Lal (1):
      KVM: x86: Initializing all kvm_lapic_irq fields in ioapic_write_indirect

Paolo Bonzini (2):
      Merge tag 'kvm-s390-master-5.6-1' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge branch 'kvm-null-pointer-fix' into kvm-master

Sean Christopherson (1):
      KVM: VMX: Condition ENCLS-exiting enabling on CPU support for SGX1

Vitaly Kuznetsov (3):
      KVM: x86: clear stale x86_emulate_ctxt->intercept value
      KVM: x86: remove stale comment from struct x86_emulate_ctxt
      KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs

Wanpeng Li (1):
      KVM: X86: Fix dereference null cpufreq policy

 arch/s390/kvm/kvm-s390.c           | 18 +++++++++++++++++-
 arch/x86/include/asm/kvm_emulate.h |  1 -
 arch/x86/kvm/Kconfig               |  2 +-
 arch/x86/kvm/emulate.c             |  1 +
 arch/x86/kvm/ioapic.c              |  7 +++++--
 arch/x86/kvm/svm.c                 |  3 ++-
 arch/x86/kvm/vmx/nested.c          |  5 +++--
 arch/x86/kvm/vmx/vmx.c             | 16 ++++++++++++++--
 arch/x86/kvm/x86.c                 |  8 +++++---
 9 files changed, 48 insertions(+), 13 deletions(-)
