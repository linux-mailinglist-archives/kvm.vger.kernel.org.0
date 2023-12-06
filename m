Return-Path: <kvm+bounces-3725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E242F8075FD
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A45EA2815F2
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E4849F7D;
	Wed,  6 Dec 2023 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YucjFptM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020F310EB
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:44 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-50bf1e32571so4929060e87.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882163; x=1702486963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Me0qqRrskpa11GvKdt5GrXiD/qCgAfM3AQizYA0X8fg=;
        b=YucjFptMosu/lRiTlcqu+zVoCMYeW8TBBSTDdbWlIqiaTNfSUJKaKW7z/lrYJOW4he
         J1ZGPufuEPCjEa/uRzJnvX9rBrMVk702sFG4ilyUrR+5VXd6aAAnIVVSJVyu4HAchdI1
         vNZJhKjTVKyCuh0DpKc/IEMPGGU6aCQJzeL09H0gQQLZrfQGNbXCQl23Rs+3cHma0ltM
         nQDbckdZjgigvfGU6ym4ohWR32MUP5GU8FtqIaLuI00i69VsLG7NW+4JL/TWQQVfygj+
         z9vKl2Mr5P3T7c7obxVBYxluP6XRY3aCMQ5BY2eaKSP+l9B7ZtPN2n6az8jZIQVVr5Jb
         rBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882163; x=1702486963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me0qqRrskpa11GvKdt5GrXiD/qCgAfM3AQizYA0X8fg=;
        b=tRHN0f7fqysSoP3JpWMOiLYHI2nbDeZcRZSVEta9qsy0LurjyHkth8/8OX0U7/FS68
         U0Q3ZKeHBCusd0TCkORMFrF4gi3ctLiV/wa6TqG5P2PlGeoWy3v7F/1vnt5BQpMHU/bM
         AX4qSSawc3f9v28wS38BWNyzbpqIKd6uM27CrGHnJrGQuu3dYzejYlm2jlWAaJ0BRz2J
         TpsIFh4PVqAjsf7/m5M5FbDBc+NDY7BfphJHoZIw6TM7cx00H5qYhUjeqEOQmjV+7v6z
         2Eh6YmFLrCWW88JAZAUHW1sjrMiTmM83syRTefPYLxi90YLRpLqwu8b2833MJFDjDnR2
         aSiQ==
X-Gm-Message-State: AOJu0Ywbvt2C2hWmYjPd2zlFmbjHX8gHqWyOqZTX7XCdH0garhqTFekg
	HWDwNdkTuG+m61HnrEw7+HsQgLgWxQEDLIHbdOc=
X-Google-Smtp-Source: AGHT+IECVyI5nSuArrzUeLvq2gF2I0dRUO6u4KVRrS6V9wDhUNsXaChckaX+LSPb1AXIsiukHIvlxQ==
X-Received: by 2002:a05:6512:549:b0:50b:d3cf:1e8c with SMTP id h9-20020a056512054900b0050bd3cf1e8cmr612707lfl.43.1701882162556;
        Wed, 06 Dec 2023 09:02:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l4-20020a056402344400b0054cc474b25fsm189776edc.40.2023.12.06.09.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:42 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 0/5] KVM: selftests: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:42 +0100
Message-ID: <20231206170241.82801-7-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

This series has a lot of churn for dubious value, but I'm posting it
anyway since I've already done the work. Each patch in the series is
simply removing trailing newlines from format strings in TEST_* function
callsites, since TEST_* functions append their own. The first patch
addresses common lib and test code, the rest of the changes are split
by arch in the remaining patches.

Figuring out which newlines to delete was done with a long, ugly
grep regular expression[*] and then highlighting '\n' in the output
and manually skimming to find, and then manually fix, each instance.
I'm sure there's some AI tool that would have done everything for me,
but this was my chance to prove I'm still as capable as AI (well,
unless I missed some...)

[*] grep -rn . tools/testing/selftests/kvm |
    grep -Pzo '(?s)\n[^\n]*TEST_(ASSERT|REQUIRE|FAIL)\(.*?\)\s*;' |
    tr '\0' '\n'


Andrew Jones (5):
  KVM: selftests: Remove redundant newlines
  KVM: selftests: aarch64: Remove redundant newlines
  KVM: selftests: riscv: Remove redundant newlines
  KVM: selftests: s390x: Remove redundant newlines
  KVM: selftests: x86_64: Remove redundant newlines

 .../selftests/kvm/aarch64/arch_timer.c        | 12 ++++----
 .../selftests/kvm/aarch64/hypercalls.c        | 16 +++++------
 .../selftests/kvm/aarch64/page_fault_test.c   |  6 ++--
 .../selftests/kvm/aarch64/smccc_filter.c      |  2 +-
 .../kvm/aarch64/vpmu_counter_access.c         | 12 ++++----
 .../selftests/kvm/demand_paging_test.c        |  4 +--
 .../selftests/kvm/dirty_log_perf_test.c       |  4 +--
 tools/testing/selftests/kvm/dirty_log_test.c  |  4 +--
 tools/testing/selftests/kvm/get-reg-list.c    |  2 +-
 .../testing/selftests/kvm/guest_print_test.c  |  8 +++---
 .../selftests/kvm/hardware_disable_test.c     |  6 ++--
 .../selftests/kvm/kvm_create_max_vcpus.c      |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  4 +--
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  4 +--
 tools/testing/selftests/kvm/lib/elf.c         |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 16 +++++------
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  2 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 10 +++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  6 ++--
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |  6 ++--
 .../selftests/kvm/riscv/get-reg-list.c        |  2 +-
 tools/testing/selftests/kvm/rseq_test.c       |  4 +--
 tools/testing/selftests/kvm/s390x/resets.c    |  4 +--
 .../selftests/kvm/s390x/sync_regs_test.c      | 20 ++++++-------
 .../selftests/kvm/set_memory_region_test.c    |  6 ++--
 .../kvm/system_counter_offset_test.c          |  2 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  4 +--
 .../selftests/kvm/x86_64/flds_emulation.h     |  2 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  4 +--
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  2 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  8 +++---
 .../selftests/kvm/x86_64/platform_info_test.c |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 28 +++++++++----------
 .../smaller_maxphyaddr_emulation_test.c       |  4 +--
 .../selftests/kvm/x86_64/sync_regs_test.c     | 10 +++----
 .../kvm/x86_64/ucna_injection_test.c          |  8 +++---
 .../selftests/kvm/x86_64/userspace_io_test.c  |  2 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 16 +++++------
 .../vmx_exception_with_invalid_guest_state.c  |  2 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  8 +++---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  2 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |  2 +-
 51 files changed, 144 insertions(+), 144 deletions(-)

-- 
2.43.0


