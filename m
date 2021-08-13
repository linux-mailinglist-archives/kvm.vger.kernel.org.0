Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C23EBDBE
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhHMVMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhHMVMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:12:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848AFC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z23-20020a17090abd97b0290176898bbb9cso8494502pjr.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9IqAMVDN2NozdVtjFEdbk6JqKoFIu+WmwhRN6uOxFxA=;
        b=qAW77aiXYqzGGXHikozcZU2p17a9Y6rCtGOzJA+UEmS1rzERQOEuQxGk+Y9lDmR4pp
         2k5hgts2pqCYNDy6+kVw4tC6hhZUug5WAoXLHDDC1So6EGqBdC+AQqfsgArOulZBBY5r
         PYdXlDJ4ZnJrFOcvTyGaeyT76cQNoOsyj6nwGCBj/q7O+Dc/q2ExM8Kt2MDKVqEcGhc3
         TOqQAz/cDM9rahlnt4Utgn7xzWtLKUXJ1EQdIdj23BeB7afGERU0fjKB9jLWI27TzJpr
         M/FP8EEQL05ITRfq9gRfKzNMO0O45dmTwf3piTN01SZLzJQySVwZ+FJV9pMWZ91+kv/P
         EhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9IqAMVDN2NozdVtjFEdbk6JqKoFIu+WmwhRN6uOxFxA=;
        b=ZcHeLc42WYVGsGSxYnhkwuHEkYFQ9oyJ+RN21UwL9ObnEFjhzhio7y7+y0eJEWIbNE
         bEE1mN8whxVqJV8fZjJS54KwDWXc44G/01iCeTYXO+ALz11BPTb+UUERRk59c3QPyfBK
         qDfLVzWMIzO+/Q0heBed6enaD3RM+iR7pZdkY3WyzmGJ+Kj/akqgc+vYvVVb2Weqp488
         fcblEqQrNE/PNwacTtuZ3alQFwJ2WvjfwT33lv7z5fSWRjxoWn+8JDromGe4d5c/xqxT
         DwL0gBqPVrV14+rTI25TiKuDL3rUWYcKVYEQVl1yuU9YiilVINdaba0Fmg19qL+U2sMq
         59Xg==
X-Gm-Message-State: AOAM533ZssYA/rLuGvIwtuNTEsY50H5s5jC7BATzKuMU6w+K97sDBb0f
        JcqcVQf2ggzJAU0+6iziSkq5dXoEBZX/
X-Google-Smtp-Source: ABdhPJyVflo8FKcK6yfQ6pxwcQBZMBxsijeAF87NjaiPKul2DJpwaWfgn72+BmB3c7kswtIAUEtGHnucOTva
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1a49:b029:3e0:3b2c:c9c7 with SMTP
 id h9-20020a056a001a49b02903e03b2cc9c7mr4271401pfv.8.1628889145999; Fri, 13
 Aug 2021 14:12:25 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:01 +0000
Message-Id: <20210813211211.2983293-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-10). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Since the test heavily depends on interrupts, the patch series also
adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
to the KVM's aarch64 selftest framework (patch-9).

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, spinlock support,
and so on, are also introduced that the test/GICv3 takes advantage of.
These are presented in patches 1 through 8.

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

Raghavendra Rao Ananta (10):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add arch_timer test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/arch_timer.c        | 382 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          | 138 +++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 ++
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 ++++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 ++++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 13 files changed, 1172 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

