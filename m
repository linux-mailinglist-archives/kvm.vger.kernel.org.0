Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA28130FDF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgAFKDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:03:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgAFKDz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 05:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aS+41g0w6JovPAuziGAza/HJJ4u/O5f+CUldkMIEhSI=;
        b=KK1jSoa1NkdXE1OeFr0dEufN5mcciJR3GH7ZB42fFRrdY7e17FWVYjEF/zdtjJEZslwH2c
        Rtx8Lt4Ux9VriUiNRfn2btMZgzZZ8vceREH6oR+dA5dFCIJMLEuLbqOu5lI30JnFDziJeM
        gW/2h1jY5OdV3GbDohE7tY3+vdv6zBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-iASw-BJ4PaqNXNlLbx0zOQ-1; Mon, 06 Jan 2020 05:03:50 -0500
X-MC-Unique: iASw-BJ4PaqNXNlLbx0zOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E162F60
        for <kvm@vger.kernel.org>; Mon,  6 Jan 2020 10:03:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F08B563BCA;
        Mon,  6 Jan 2020 10:03:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 00/17] arm/arm64: fixes and updates
Date:   Mon,  6 Jan 2020 11:03:30 +0100
Message-Id: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Happy New Year and please pull.

Thanks,
drew


The following changes since commit 2c6589bc4e8bb0299cf4e8af84fa05cbbb3095=
2d:

  Update AMD instructions to conform to LLVM assembler (2019-12-18 18:31:=
17 +0100)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests arm/queue

for you to fetch changes up to ada4c643a2332c408a262a749b0365a1f970084c:

  arm: cstart64.S: Remove icache invalidation from asm_mmu_enable (2020-0=
1-06 10:30:43 +0100)

----------------------------------------------------------------
Alexandru Elisei (13):
      lib: arm/arm64: Remove unnecessary dcache maintenance operations
      lib: arm: Add proper data synchronization barriers for TLBIs
      lib: Add WRITE_ONCE and READ_ONCE implementations in compiler.h
      lib: arm/arm64: Use WRITE_ONCE to update the translation tables
      lib: arm/arm64: Remove unused CPU_OFF parameter
      lib: arm/arm64: Add missing include for alloc_page.h in pgtable.h
      lib: arm: Implement flush_tlb_all
      lib: arm/arm64: Teach mmu_clear_user about block mappings
      arm64: timer: Write to ICENABLER to disable timer IRQ
      lib: arm/arm64: Refuse to disable the MMU with non-identity stack p=
ointer
      arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
      arm/arm64: Invalidate TLB before enabling MMU
      arm: cstart64.S: Remove icache invalidation from asm_mmu_enable

Andrew Jones (2):
      arm: Enable the VFP
      arm/arm64: PL031: Fix check_rtc_irq

Chen Qun (1):
      arm: Add missing test name prefix for pl031 and spinlock

Zeng Tao (1):
      devicetree: Fix the dt_for_each_cpu_node

 .gitlab-ci.yml                |  2 +-
 arm/Makefile.arm              |  2 +-
 arm/cache.c                   |  3 +-
 arm/cstart.S                  | 25 +++++++++++--
 arm/cstart64.S                |  5 ++-
 arm/pl031.c                   |  5 +--
 arm/spinlock-test.c           |  1 +
 arm/timer.c                   | 22 ++++++------
 lib/arm/asm/gic-v3.h          |  1 +
 lib/arm/asm/gic.h             |  1 +
 lib/arm/asm/mmu-api.h         |  2 +-
 lib/arm/asm/mmu.h             | 18 ++++++----
 lib/arm/asm/pgtable-hwdef.h   | 11 ++++++
 lib/arm/asm/pgtable.h         | 20 ++++++++---
 lib/arm/mmu.c                 | 60 ++++++++++++++++++-------------
 lib/arm/psci.c                |  4 +--
 lib/arm64/asm/pgtable-hwdef.h |  3 ++
 lib/arm64/asm/pgtable.h       | 15 ++++++--
 lib/devicetree.c              |  2 +-
 lib/linux/compiler.h          | 83 +++++++++++++++++++++++++++++++++++++=
++++++
 20 files changed, 221 insertions(+), 64 deletions(-)
 create mode 100644 lib/linux/compiler.h

--=20
2.21.0

