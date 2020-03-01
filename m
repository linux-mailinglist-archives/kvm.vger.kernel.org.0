Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADC174F13
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCATDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 14:03:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55149 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgCATDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 14:03:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id z12so8785964wmi.4;
        Sun, 01 Mar 2020 11:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=58YbdIpK87d+hqR4j1GhCFXTctvcaAuYQyq9nvn5aB4=;
        b=dZIh3WrV88DSs0OHE2R/OsBpcSrRCSKkiHA6OP470nSFenuh9szh4Hiod4/y6IZ7To
         NSCwLT1izTkX4TsOGp5kMp0+nb+JMtHLJ9lp5emwKxPZzOUuG06pVWz/ie2cZemsBpWo
         duyl2iAjXgEZQU68ZfGAnzdB9kaEnA/t/ttpQ6j/XVVH2GG4E+IyOmgR0jIAS7LOZXiB
         CN4rPlnUB6GB+J+nB4ESSgOacx5CWsa2bh93X5QGLBm0fEeJfgvGdPg/dTaiopusLQRd
         XU7fVJxkNRRtHppPVKt7NqhrWVBpa8/PT6qFHWj/GsEGQUzpLg1ieMszMGvdFLJ3+Pqt
         P8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=58YbdIpK87d+hqR4j1GhCFXTctvcaAuYQyq9nvn5aB4=;
        b=YCPanVr+43CvabKKQc63051FMeebvyQNwNjbDQJoL3amj9yG7PprADAMMSDL9ooq6p
         YCFneI2cEei1YUXyKcd0C0nwxlb5fkMRc0q40mKqeYvZNwwKzX8XEiK5gPcdQxA6xz8Q
         sB3D4pAWiH7M9LV1hHfy132z51ZjIE59dwVZApM2QCVyGkhqY19YhOClBdv8p2upuMzG
         wGUa7aPMFEW7aGg0wqX7RbjDob0y75SGMvkx0hq8/KFj48Y9gAO/3d3Eq6zbmVr0s24a
         d/IDtoqx065ptWNcXkXC6PBnxGqR9jypNLxCKKb7lOKXOxMQ4m6Vv0etuOB98TC+D/MB
         eb6A==
X-Gm-Message-State: APjAAAUSh4AHGQGLcG2qrpuCvWo77KM3D4PT+Jqaaye2gd8hFczu0L3X
        GEmKzeTESwiIZPyRqVcXabSw/sF7
X-Google-Smtp-Source: APXvYqx+DCwQoDcqnYshPLa/WLdrCvjNxFBw1VLiMslSm7d1FYeYnUIzvMR5kKSpZ8YHZj6iOsN+vQ==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr15214727wmj.17.1583089393723;
        Sun, 01 Mar 2020 11:03:13 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b16sm19004486wrq.14.2020.03.01.11.03.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2020 11:03:13 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.6-rc4 (or rc5)
Date:   Sun,  1 Mar 2020 20:03:10 +0100
Message-Id: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit a93236fcbe1d0248461b29c0f87cb0b510c94e6f:

  KVM: s390: rstify new ioctls in api.rst (2020-02-24 19:28:40 +0100)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 86f7e90ce840aa1db407d3ea6e9b3a52b2ce923c:

  KVM: VMX: check descriptor table exits on instruction emulation (2020-03-01 19:26:31 +0100)

----------------------------------------------------------------
More bugfixes, including a few remaining "make W=1" issues such
as too large frame sizes on some configurations.  On the
ARM side, the compiler was messing up shadow stacks between
EL1 and EL2 code, which is easily fixed with __always_inline.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: let declaration of kvm_get_running_vcpus match implementation

Erwan Velu (1):
      kvm: x86: Limit the number of "kvm: disabled by bios" messages

James Morse (3):
      KVM: arm64: Ask the compiler to __always_inline functions used at HYP
      KVM: arm64: Define our own swab32() to avoid a uapi static inline
      arm64: Ask the compiler to __always_inline functions used by KVM at HYP

Jeremy Cline (1):
      KVM: arm/arm64: Fix up includes for trace.h

Mark Rutland (1):
      kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()

Oliver Upton (1):
      KVM: VMX: check descriptor table exits on instruction emulation

Paolo Bonzini (4):
      KVM: SVM: allocate AVIC data structures based on kvm_amd module parameter
      KVM: allow disabling -Werror
      KVM: x86: avoid useless copy of cpufreq policy
      Merge tag 'kvmarm-fixes-5.6-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Valdis Kletnieks (1):
      KVM: x86: allow compiling as non-module with W=1

Wanpeng Li (2):
      KVM: Introduce pv check helpers
      KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis

 arch/arm/include/asm/kvm_host.h          |  3 --
 arch/arm64/include/asm/arch_gicv3.h      |  2 +-
 arch/arm64/include/asm/cache.h           |  2 +-
 arch/arm64/include/asm/cacheflush.h      |  2 +-
 arch/arm64/include/asm/cpufeature.h      | 10 ++---
 arch/arm64/include/asm/io.h              |  4 +-
 arch/arm64/include/asm/kvm_emulate.h     | 48 +++++++++++------------
 arch/arm64/include/asm/kvm_host.h        | 32 ----------------
 arch/arm64/include/asm/kvm_hyp.h         |  7 ++++
 arch/arm64/include/asm/kvm_mmu.h         |  3 +-
 arch/arm64/include/asm/virt.h            |  2 +-
 arch/arm64/kvm/hyp/switch.c              | 39 ++++++++++++++++++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  4 +-
 arch/x86/kernel/kvm.c                    | 65 +++++++++++++++++++++-----------
 arch/x86/kvm/Kconfig                     | 13 +++++++
 arch/x86/kvm/Makefile                    |  2 +-
 arch/x86/kvm/svm.c                       |  5 ++-
 arch/x86/kvm/vmx/vmx.c                   | 17 +++++++++
 arch/x86/kvm/x86.c                       | 14 +++----
 include/linux/kvm_host.h                 |  2 +-
 virt/kvm/arm/arm.c                       |  2 -
 virt/kvm/arm/trace.h                     |  1 +
 22 files changed, 171 insertions(+), 108 deletions(-)
