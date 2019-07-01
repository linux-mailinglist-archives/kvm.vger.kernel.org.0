Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F233D4D3E9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbfFTQip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:38:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfFTQio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:38:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so3748296wrv.2;
        Thu, 20 Jun 2019 09:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=E1zSQny9YRRdHwfEgEpwDA5eSOxszmxLDpT/5VN+UTI=;
        b=n0MyWeLMjOjk56sWHslQ5KowK4Xqqy4KEjaqMiv5ywD0u7uUowp/XKK1Ob6+2AZnTe
         tcQym3wmLJeFk9wOp+qfTKHHZ2VqSMqmyJD93XVxzc+DCHX/bQPmVlckMkCd/m+YPL+A
         zy5+B7dA5J1uEqZrYFJtZVewDs0Lx+MX9/XVwQ74nWWnYu4+xhDEeAyREbNrb30gsIJL
         M3qEeHPeOqjAckkX3i/okUBvmbzndQxiCNmz2av9X2awP6vxSefjuXZK3DUsxn2+R4AO
         /5x/uTmz79Ccb+5sUKES6+fQa8ufvKs6awd2XbaRRA+b2z0SypTXNbwdErbL5kB2cdZN
         /3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=E1zSQny9YRRdHwfEgEpwDA5eSOxszmxLDpT/5VN+UTI=;
        b=VcHWkMz7bMU9Fs7S79GGv1Y2U4Kp4pONESt4qhRhlUTO2I8p64+QNGRdttUB52Be53
         AzyJjjOFV1+Xp/IJTKKsu4+wXWwVx17p3NcZy2sk+9LJ4YPBtrcrg3iM13Us/M2iEnTD
         ITNgA8NCweu0blP6Zn9I2psBiGKvfFRhgkT05AkqK3lzT/xS700nNAL8Zx4K7JNjiqFe
         /19ycM59MgpX+Coma/HkyZGU0gIxsr14W/VQdoiqQ+jssLWlsHjGFVA26/XeTI7DQGIa
         GXByABlXXElCjvcm6BIRaExMXtYUmGSIYUJmUzXMbniDFTRaUWQW4hUAKGk6clvv24Nx
         qpMw==
X-Gm-Message-State: APjAAAV+CBr5WCOAi7TLSZmUyjtZt3FqTkeEGgWX89zlvR4CYE95gukZ
        csG0dCLqV6Lxn6UVBRUekzG2hZHz
X-Google-Smtp-Source: APXvYqxBW54IZ8TGH3u+omyIeOTsx4gy8ScfRrWDXzbYvIlOB0fBPQY3OP9ShlNw2Tg0ZimHm5JXkg==
X-Received: by 2002:adf:de90:: with SMTP id w16mr59995339wrl.217.1561048721772;
        Thu, 20 Jun 2019 09:38:41 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u6sm87286wml.9.2019.06.20.09.38.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 09:38:40 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.2-rc6
Date:   Thu, 20 Jun 2019 18:38:39 +0200
Message-Id: <1561048719-38059-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit f8d221d2e0e1572d0d60174c118e3554d1aa79fa:

  Merge tag 'kvm-s390-master-5.2-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2019-06-01 00:49:02 +0200)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b21e31b253048b7f9768ca7cc270e67765fd6ba2:

  Merge tag 'kvmarm-fixes-for-5.2-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-06-20 18:24:18 +0200)

----------------------------------------------------------------

Fixes for ARM and x86, plus selftest patches and nicer structs
for nested state save/restore.

----------------------------------------------------------------
Aaron Lewis (2):
      kvm: tests: Sort tests in the Makefile alphabetically
      tests: kvm: Check for a kernel warning

Andrew Jones (1):
      KVM: arm/arm64: Fix emulated ptimer irq injection

Dave Martin (2):
      KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
      KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Dennis Restle (1):
      KVM: fix typo in documentation

Liran Alon (1):
      KVM: x86: Modify struct kvm_nested_state to have explicit fields for data

Paolo Bonzini (2):
      KVM: nVMX: reorganize initial steps of vmx_set_nested_state
      Merge tag 'kvmarm-fixes-for-5.2-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Sean Christopherson (1):
      KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT

Viresh Kumar (1):
      KVM: arm64: Implement vq_present() as a macro

Vitaly Kuznetsov (1):
      KVM: nVMX: use correct clean fields when copying from eVMCS

 Documentation/virtual/kvm/api.txt                  |  48 +++++---
 arch/arm64/kvm/guest.c                             |  65 +++++++----
 arch/x86/include/uapi/asm/kvm.h                    |  33 ++++--
 arch/x86/kvm/mmu.c                                 |  16 ++-
 arch/x86/kvm/vmx/nested.c                          | 103 +++++++++--------
 arch/x86/kvm/vmx/vmcs12.h                          |   5 +-
 tools/arch/x86/include/uapi/asm/kvm.h              |   2 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |  21 ++--
 tools/testing/selftests/kvm/include/kvm_util.h     |   2 +
 .../selftests/kvm/include/x86_64/processor.h       |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  36 ++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  16 +++
 .../selftests/kvm/x86_64/mmio_warning_test.c       | 126 +++++++++++++++++++++
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  68 ++++++-----
 virt/kvm/arm/arch_timer.c                          |   5 +-
 virt/kvm/arm/vgic/vgic-its.c                       |   1 +
 17 files changed, 405 insertions(+), 145 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
