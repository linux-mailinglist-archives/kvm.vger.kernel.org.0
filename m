Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BA219E5A3
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDDOh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:37:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726254AbgDDOh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+ZfjS5WVKE89dM9IIdzKrNx4ck9ojKPYZar0T+gS4i4=;
        b=KHZqxQGbVktdTh6ROM2JWiCKlIbhNTHgsRuV65ikoT3/Ja76o8VoctzrhQBwVwFr1NQPSW
        UECynMS5uFjkZ/aT96xaYruPBbrelFM7I9Raz5Uf6MhfKgzkPfVUfXfiz8ZUnMVBoRX50U
        xhu4ANQV1MV5RcA/XkiXzFMoOa+LDbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-RhwhUHFIPYGMr4ejWcg7_A-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: RhwhUHFIPYGMr4ejWcg7_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0405800D4E;
        Sat,  4 Apr 2020 14:37:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 201EE9B912;
        Sat,  4 Apr 2020 14:37:33 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PULL kvm-unit-tests 00/39] arm/arm64: The old and new
Date:   Sat,  4 Apr 2020 16:36:52 +0200
Message-Id: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This pull request is a repost of an older request, plus it
contains Eric's new PMU and ITS tests.

Thanks,
drew


The following changes since commit ce27fa2c7cd4d07859a9a2e81c7ff641897818=
d1:

  x86: vmx: skip atomic_switch_overflow_msrs_test on bare metal (2020-03-=
31 13:01:41 -0400)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests arm/queue

for you to fetch changes up to de582149c5be94a1ff7d3d8ee3526501b26c7f03:

  arm/arm64: ITS: pending table migration test (2020-04-04 10:03:44 +0200=
)

----------------------------------------------------------------
Alexandru Elisei (10):
      Makefile: Use no-stack-protector compiler options
      arm/arm64: psci: Don't run C code without stack or vectors
      arm64: timer: Add ISB after register writes
      arm64: timer: Add ISB before reading the counter value
      arm64: timer: Make irq_received volatile
      arm64: timer: EOIR the interrupt after masking the timer
      arm64: timer: Wait for the GIC to sample timer interrupt state
      arm64: timer: Check the timer interrupt state
      arm64: timer: Test behavior when timer disabled or masked
      arm/arm64: Perform dcache clean + invalidate after turning MMU off

Andrew Jones (2):
      arm64: timer: Speed up gic-timer-state check
      arm64: Provide read/write_sysreg_s

Eric Auger (24):
      arm: pmu: Let pmu tests take a sub-test parameter
      arm: pmu: Don't check PMCR.IMP anymore
      arm: pmu: Add a pmu struct
      arm: pmu: Introduce defines for PMU versions
      arm: pmu: Check Required Event Support
      arm: pmu: Basic event counter Tests
      arm: pmu: Test SW_INCR event count
      arm: pmu: Test chained counters
      arm: pmu: test 32-bit <-> 64-bit transitions
      arm: gic: Introduce gic_irq_set_clr_enable() helper
      arm: pmu: Test overflow interrupts
      libcflat: Add other size defines
      page_alloc: Introduce get_order()
      arm/arm64: gic: Introduce setup_irq() helper
      arm/arm64: gicv3: Add some re-distributor defines
      arm/arm64: gicv3: Set the LPI config and pending tables
      arm/arm64: ITS: Introspection tests
      arm/arm64: ITS: its_enable_defaults
      arm/arm64: ITS: Device and collection Initialization
      arm/arm64: ITS: Commands
      arm/arm64: ITS: INT functional tests
      arm/run: Allow Migration tests
      arm/arm64: ITS: migration tests
      arm/arm64: ITS: pending table migration test

Zenghui Yu (3):
      arm/arm64: gic: Move gic_state enumeration to asm/gic.h
      arm64: timer: Use the proper RDist register name in GICv3
      arm64: timer: Use existing helpers to access counter/timers

 Makefile                   |   4 +-
 arm/Makefile.arm64         |   1 +
 arm/Makefile.common        |   2 +-
 arm/cstart.S               |  22 ++
 arm/cstart64.S             |  23 ++
 arm/gic.c                  | 482 ++++++++++++++++++++++++--
 arm/pmu.c                  | 831 +++++++++++++++++++++++++++++++++++++++=
++++--
 arm/psci.c                 |  14 +-
 arm/run                    |   2 +-
 arm/timer.c                |  82 +++--
 arm/unittests.cfg          | 101 +++++-
 errata.txt                 |   1 +
 lib/alloc_page.c           |   7 +-
 lib/alloc_page.h           |   1 +
 lib/arm/asm/gic-v3-its.h   |  27 ++
 lib/arm/asm/gic-v3.h       |  33 ++
 lib/arm/asm/gic.h          |  13 +
 lib/arm/asm/processor.h    |  15 +
 lib/arm/gic-v3.c           |  78 +++++
 lib/arm/gic.c              | 116 ++++++-
 lib/arm/io.c               |  28 ++
 lib/arm/setup.c            |   8 +
 lib/arm64/asm/gic-v3-its.h | 174 ++++++++++
 lib/arm64/asm/processor.h  |  12 +
 lib/arm64/asm/sysreg.h     |  17 +
 lib/arm64/gic-v3-its-cmd.c | 459 +++++++++++++++++++++++++
 lib/arm64/gic-v3-its.c     | 171 ++++++++++
 lib/bitops.h               |   3 +
 lib/libcflat.h             |   3 +
 29 files changed, 2635 insertions(+), 95 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm64/asm/gic-v3-its.h
 create mode 100644 lib/arm64/gic-v3-its-cmd.c
 create mode 100644 lib/arm64/gic-v3-its.c

--=20
2.25.1

