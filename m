Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B47349790
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 18:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCYRG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 13:06:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCYRG1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 13:06:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616691986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+xYOd6K4hzFLD2UfjTuC+ChACntrzPK8KQPBSWzho/g=;
        b=gDOn5IDzxcCOcHXsWSUBPetC4TCnkDd2WnD4DJHpmkKhsK90uAOHQHblPeNRvlGJIVXZBL
        aXSwKzoYxP7vk7zKTHo99BONkewOAK/OqgRMBcbFwisUMlb8B4QVyFjmc0BGl+UYMmAWeI
        dVyHZU4waeGXSHj21h6dvOmnC2mgnlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-hmBdeHScPYG3Q2UmrarTXw-1; Thu, 25 Mar 2021 13:06:24 -0400
X-MC-Unique: hmBdeHScPYG3Q2UmrarTXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EE901B2C98D;
        Thu, 25 Mar 2021 17:05:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78779891C1;
        Thu, 25 Mar 2021 17:05:55 +0000 (UTC)
Date:   Thu, 25 Mar 2021 18:05:52 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com,
        nikos.nikoleris@arm.com, wangjingyi11@huawei.com
Subject: Re: [PULL kvm-unit-tests] gitlab MR requested
Message-ID: <20210325170552.47hx7fhcjj2hxjvp@kamzik.brq.redhat.com>
References: <20210325165737.604357-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325165737.604357-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi email readers,

I forgot to copy the gitlab MR description - copied below. (I need to
figure out how to better deal with this gitlab+email workflow.)

  This MR is a collection of fixes and improvements found while testing
  in different environments and also by code inspection. Some issues were
  found when experimenting with target-efi. Additionally, as preparation
  for target-efi, libfdt has been updated, which includes the need for a
  few more string functions being added to kvm-unit-test's libc, as well
  as some compiler builtin support to support those string functions.
  Finally, also in preparation for target-efi, we improve support for
  setting our "earlycon" (we want printf to work very early) and we
  explicitly zero the BSS and thread-info.

Thanks,
drew


On Thu, Mar 25, 2021 at 05:57:37PM +0100, Andrew Jones wrote:
> The following changes since commit 3054ca26152d01aed6e4a9b7dc03e447882aeccc:
> 
>   Merge branch 's390x-pull-2021-08-03' of https://gitlab.com/frankja/kvm-unit-tests.git into 'master' (2021-03-08 14:35:51 +0000)
> 
> are available in the Git repository at:
> 
>   https://gitlab.com/rhdrjones/kvm-unit-tests.git arm/queue
> 
> for you to fetch changes up to a09aa3fb909cf5be5a7bb0e0c1f2c36fdde2af94:
> 
>   arm64: Output PC load offset on unhandled exceptions (2021-03-25 17:26:05 +0100)
> 
> ----------------------------------------------------------------
> Alexandru Elisei (19):
>       arm: pmu: Don't read PMCR if PMU is not present
>       lib: arm/arm64: gicv3: Add missing barrier when sending IPIs
>       lib: arm/arm64: gicv2: Document existing barriers when sending IPIs
>       arm/arm64: gic: Remove SMP synchronization from ipi_clear_active_handler()
>       arm/arm64: gic: Remove unnecessary synchronization with stats_reset()
>       arm/arm64: gic: Use correct memory ordering for the IPI test
>       arm/arm64: gic: Check spurious and bad_sender in the active test
>       arm/arm64: gic: Wait for writes to acked or spurious to complete
>       arm/arm64: gic: Split check_acked() into two functions
>       arm/arm64: gic: Make check_acked() more generic
>       arm64: gic: its-trigger: Don't trigger the LPI while it is pending
>       arm64: gic: Use IPI test checking for the LPI tests
>       configure: arm/arm64: Add --earlycon option to set UART type and address
>       arm64: Remove unnecessary ISB when writing to SPSel
>       arm/arm64: Remove dcache_line_size global variable
>       arm/arm64: Remove unnecessary ISB when doing dcache maintenance
>       lib: arm64: Consolidate register definitions to sysreg.h
>       arm64: Configure SCTLR_EL1 at boot
>       arm64: Disable TTBR1_EL1 translation table walks
> 
> Andrew Jones (4):
>       compiler: Add builtin overflow flag and predicate wrappers
>       arm/arm64: Zero BSS and stack at startup
>       arm64: argc is an int
>       arm64: Output PC load offset on unhandled exceptions
> 
> Jingyi Wang (1):
>       arm64: microbench: fix unexpected PPI
> 
> Nikos Nikoleris (7):
>       lib/string: Add strnlen, strrchr and strtoul
>       libfdt: Pull v1.6.0
>       Makefile: Remove overriding recipe for libfdt_clean
>       devicetree: Parse correctly the stdout-path
>       arm/arm64: Avoid calling cpumask_test_cpu for CPUs above nr_cpus
>       arm/arm64: Read system registers to get the state of the MMU
>       arm/arm64: Add sanity checks to the cpumask API
> 
>  Makefile                      |  16 +-
>  arm/Makefile.common           |   2 +-
>  arm/cstart.S                  |  39 +-
>  arm/cstart64.S                |  53 ++-
>  arm/flat.lds                  |   5 +
>  arm/gic.c                     | 336 ++++++++--------
>  arm/micro-bench.c             |   2 +-
>  arm/pmu.c                     |   3 +-
>  configure                     |  53 +++
>  lib/arm/asm/assembler.h       |  53 +++
>  lib/arm/asm/cpumask.h         |   7 +-
>  lib/arm/asm/mmu-api.h         |   7 +-
>  lib/arm/asm/processor.h       |   9 +-
>  lib/arm/gic-v2.c              |   6 +
>  lib/arm/gic-v3.c              |   6 +
>  lib/arm/mmu.c                 |  20 +-
>  lib/arm/processor.c           |   5 +
>  lib/arm/setup.c               |   7 -
>  lib/arm64/asm/arch_gicv3.h    |   6 -
>  lib/arm64/asm/assembler.h     |  54 +++
>  lib/arm64/asm/pgtable-hwdef.h |   1 +
>  lib/arm64/asm/processor.h     |  18 +-
>  lib/arm64/asm/sysreg.h        |  24 ++
>  lib/arm64/processor.c         |  12 +
>  lib/devicetree.c              |  15 +-
>  lib/libfdt/Makefile.libfdt    |  10 +-
>  lib/libfdt/README             |   5 +-
>  lib/libfdt/fdt.c              | 200 ++++++----
>  lib/libfdt/fdt.h              |  53 +--
>  lib/libfdt/fdt_addresses.c    | 101 +++++
>  lib/libfdt/fdt_check.c        |  74 ++++
>  lib/libfdt/fdt_empty_tree.c   |  48 +--
>  lib/libfdt/fdt_overlay.c      | 881 ++++++++++++++++++++++++++++++++++++++++++
>  lib/libfdt/fdt_ro.c           | 512 ++++++++++++++++++------
>  lib/libfdt/fdt_rw.c           | 231 ++++++-----
>  lib/libfdt/fdt_strerror.c     |  53 +--
>  lib/libfdt/fdt_sw.c           | 297 +++++++++-----
>  lib/libfdt/fdt_wip.c          |  90 ++---
>  lib/libfdt/libfdt.h           | 766 +++++++++++++++++++++++++++++++-----
>  lib/libfdt/libfdt_env.h       | 109 +++---
>  lib/libfdt/libfdt_internal.h  | 206 +++++++---
>  lib/libfdt/version.lds        |  24 +-
>  lib/linux/compiler.h          |  33 ++
>  lib/stdlib.h                  |  13 +
>  lib/string.c                  | 101 ++++-
>  lib/string.h                  |   5 +-
>  powerpc/Makefile.common       |   2 +-
>  47 files changed, 3478 insertions(+), 1095 deletions(-)
>  create mode 100644 lib/arm/asm/assembler.h
>  create mode 100644 lib/arm64/asm/assembler.h
>  create mode 100644 lib/libfdt/fdt_addresses.c
>  create mode 100644 lib/libfdt/fdt_check.c
>  create mode 100644 lib/libfdt/fdt_overlay.c
>  create mode 100644 lib/stdlib.h

