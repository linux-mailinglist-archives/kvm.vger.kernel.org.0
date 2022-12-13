Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC664AC35
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiLMASH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiLMARa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:30 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B7C1CB34
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:19 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y23-20020aa78057000000b00574277cb386so891084pfm.16
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eNeoa7csEjZXS4nNUWfUXOC3GAkYvm3KSI3vPgdh1Hc=;
        b=mJVQ3J71TIf/kXKUEz+LFWUlXUwi5Fn829r9/F+jKMKFD4BX9cFHLDREQiDQPES+Ak
         IsJZx7T4Ctp3CvaNXmRG/S9LMkC6p4SJeQ7vhCx7azzf2FYrOQs59C0S4oam/Tt/TNN6
         KoEmjdO1m3Dtfv7hFhdcvwOM/V4HRf0iRoZV5YirpsZ+Xn44cYXZ63CnJZmx6bhCU06F
         f3wHpodtBVxyo+5Bl4tTMmeJO8obcRiXOlnP/n65+6pYmKAsZS51bghqerpD3kjj0AJD
         T+vh5xWrOU5+dxNVeJvu7iMSEb+AtbbcuvPjTs1w7m9o300pJgiy/4tjaifKbzBX65vg
         vYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNeoa7csEjZXS4nNUWfUXOC3GAkYvm3KSI3vPgdh1Hc=;
        b=u0QQc7qemlGQKHca0ZD6WPdUfXwE3LPnI3WEIvPwssyi2KbA2beVxqhHrdeuKxynrh
         sUB1xERd2kfFRSKxm1dicOoFkkQLhu2nAvo0xC1LfStERUNjlUw39ukXJCMGyMTtQYor
         d/K5zxMqZAd2jxJtJ9Dzktb8Jc0WX06wePZpDP2SQfFUDPHd5Q7qoLTTezLirDkGwR9p
         xnON1ZYRV4jYLFGyrmE8roV/LGNhur2w+x9F19Q2miNzc4KEDzw44mwlAP5VfJLb58u+
         TDtuIHwkJ2T55n+AQcy+a/kYgTfSw++28IRkRUTJOExQ8JEz+O8DbNIao80iBT3uV5IH
         QRmg==
X-Gm-Message-State: ANoB5pmLxhW0ln89hJIWpH4WJ6k88cE4cc2mUMAIc1O/FBpvJW9oqHxh
        vgMl1DoK8ButU1a+PzdrLJo4X39BF/o=
X-Google-Smtp-Source: AA0mqf72aG4eMlmlLa5V1S9JQeHaTz6mijlirgGI+sJQncOxwgWOZlIzxtYJYyefsALi6PH9bUR6dp5aPXM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3752:b0:219:baef:3c7 with SMTP id
 ne18-20020a17090b375200b00219baef03c7mr73407pjb.57.1670890638946; Mon, 12 Dec
 2022 16:17:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:52 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-14-seanjc@google.com>
Subject: [PATCH 13/14] KVM: selftests: Use wildcards to find targets and test
 source files
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use $(wildcard ...) to find the test targets (.sh files) and test source
files (.c and .S) instead of manually adding files/targets for every
architecture, which is a maintenance burden and error prone, e.g. RISC-V
supports RSEQ but doesn't build the test for reasons unknown.

To deal with common tests that are only supported on a subset of
architectures, add a dummy macro TEST_UNSUPPORTED() that tests can use
to declare the test as unsupported for a given architecture, and filter
out unsupported tests for the target architecture via grep.  As a bonus,
explicitly naming unsupported architectures will also force developers to
opt-out of architectures (or opt-out of tests when adding a new arch).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          | 128 +-----------------
 .../selftests/kvm/access_tracking_perf_test.c |   3 +
 .../selftests/kvm/dirty_log_perf_test.c       |   3 +
 .../selftests/kvm/hardware_disable_test.c     |   4 +
 .../testing/selftests/kvm/include/test_util.h |  11 ++
 .../selftests/kvm/max_guest_memory_test.c     |   4 +
 .../kvm/memslot_modification_stress_test.c    |   3 +
 .../testing/selftests/kvm/memslot_perf_test.c |   3 +
 tools/testing/selftests/kvm/rseq_test.c       |   2 +
 tools/testing/selftests/kvm/steal_time.c      |   3 +
 .../kvm/system_counter_offset_test.c          |   4 +
 11 files changed, 46 insertions(+), 122 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a9930e9197da..76382850a28f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -19,130 +19,14 @@ else
 $(error Unknown architecture '$(ARCH)')
 endif
 
-# Non-compiled test targets
-TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
+TESTS_SRC := $(shell grep -L TEST_UNSUPPORTED\($(ARCH_DIR)\) *.c)
+TESTS_SRC += $(wildcard $(ARCH_DIR)/*.c)
 
-# Compiled test targets
-TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
-TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
-TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
-TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
-TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_evmcs
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
-TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
-TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
-TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
-TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
-TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
-TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
-TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
-TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
-TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
-TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
-TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
-TEST_GEN_PROGS_x86_64 += x86_64/smm_test
-TEST_GEN_PROGS_x86_64 += x86_64/state_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_shutdown_test
-TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
-TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
-TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
-TEST_GEN_PROGS_x86_64 += x86_64/ucna_injection_test
-TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
-TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
-TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
-TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
-TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
-TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
-TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
-TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
-TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
-TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
-TEST_GEN_PROGS_x86_64 += x86_64/amx_test
-TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
-TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
-TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
-TEST_GEN_PROGS_x86_64 += demand_paging_test
-TEST_GEN_PROGS_x86_64 += dirty_log_test
-TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
-TEST_GEN_PROGS_x86_64 += hardware_disable_test
-TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += max_guest_memory_test
-TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
-TEST_GEN_PROGS_x86_64 += memslot_perf_test
-TEST_GEN_PROGS_x86_64 += rseq_test
-TEST_GEN_PROGS_x86_64 += set_memory_region_test
-TEST_GEN_PROGS_x86_64 += steal_time
-TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
-TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_PROGS := $(wildcard *.sh)
+TEST_PROGS += $(wildcard $(ARCH_DIR)/*.sh)
 
-# Compiled outputs used by test targets
-TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
-
-TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
-TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
-TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
-TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
-TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
-TEST_GEN_PROGS_aarch64 += aarch64/psci_test
-TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
-TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
-TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
-TEST_GEN_PROGS_aarch64 += demand_paging_test
-TEST_GEN_PROGS_aarch64 += dirty_log_test
-TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
-TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_aarch64 += kvm_page_table_test
-TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
-TEST_GEN_PROGS_aarch64 += memslot_perf_test
-TEST_GEN_PROGS_aarch64 += rseq_test
-TEST_GEN_PROGS_aarch64 += set_memory_region_test
-TEST_GEN_PROGS_aarch64 += steal_time
-TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
-
-TEST_GEN_PROGS_s390x = s390x/memop
-TEST_GEN_PROGS_s390x += s390x/resets
-TEST_GEN_PROGS_s390x += s390x/sync_regs_test
-TEST_GEN_PROGS_s390x += s390x/tprot
-TEST_GEN_PROGS_s390x += demand_paging_test
-TEST_GEN_PROGS_s390x += dirty_log_test
-TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
-TEST_GEN_PROGS_s390x += kvm_page_table_test
-TEST_GEN_PROGS_s390x += rseq_test
-TEST_GEN_PROGS_s390x += set_memory_region_test
-TEST_GEN_PROGS_s390x += kvm_binary_stats_test
-
-TEST_GEN_PROGS_riscv += demand_paging_test
-TEST_GEN_PROGS_riscv += dirty_log_test
-TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
-TEST_GEN_PROGS_riscv += kvm_page_table_test
-TEST_GEN_PROGS_riscv += set_memory_region_test
-TEST_GEN_PROGS_riscv += kvm_binary_stats_test
-
-TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
-LIBKVM += $(LIBKVM_$(ARCH_DIR))
+TEST_GEN_PROGS := $(patsubst %.c, %, $(filter-out $(TEST_PROGS),$(TESTS_SRC)))
+TEST_GEN_PROGS_EXTENDED := $(patsubst %.c, %, $(filter $(TEST_PROGS),$(TESTS_SRC)))
 
 # lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
 # importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..a6e20103116e 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -48,6 +48,9 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 /* Global variable used to synchronize all of the vCPU threads. */
 static int iteration;
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89..65ef1e1ddab9 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -19,6 +19,9 @@
 #include "memstress.h"
 #include "guest_modes.h"
 
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f5d59b9934f1..f844cdb93611 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -19,6 +19,10 @@
 
 #include "kvm_util.h"
 
+TEST_UNSUPPORTED(aarch64);
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #define VCPU_NUM 4
 #define SLEEPING_THREAD_NUM (1 << 4)
 #define FORK_NUM (1ULL << 9)
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 80d6416f3012..fd94e94dfb78 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -20,6 +20,17 @@
 #include <sys/mman.h>
 #include "kselftest.h"
 
+/*
+ * Flags a common test as unsupported for a given architecture.  Parsed during
+ * the build by the Makefile to filter out the test as appropriate.
+ */
+#define TEST_UNSUPPORTED(arch)				\
+	static_assert(!strcmp(#arch, "aarch64") ||	\
+		      !strcmp(#arch, "s390x")	||	\
+		      !strcmp(#arch, "riscv")	||	\
+		      !strcmp(#arch, "x86_64"),		\
+		      "Unsupported architecture: " #arch)
+
 static inline int _no_printf(const char *format, ...) { return 0; }
 
 #ifdef DEBUG
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index feaf2be20ff2..d5bc0cce1e36 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -18,6 +18,10 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+TEST_UNSUPPORTED(aarch64);
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
 	uint64_t gpa;
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..b9bdbde664f4 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -26,6 +26,9 @@
 #include "test_util.h"
 #include "guest_modes.h"
 
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #define DUMMY_MEMSLOT_INDEX 7
 
 #define DEFAULT_MEMSLOT_MODIFICATION_ITERATIONS 10
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e6587e193490..37085d2c2a03 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -26,6 +26,9 @@
 #include <kvm_util.h>
 #include <processor.h>
 
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #define MEM_EXTRA_SIZE		SZ_64K
 
 #define MEM_SIZE		(SZ_512M + MEM_EXTRA_SIZE)
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 3045fdf9bdf5..34c3df9b4e81 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -22,6 +22,8 @@
 
 #include "../rseq/rseq.c"
 
+TEST_UNSUPPORTED(riscv);
+
 /*
  * Any bug related to task migration is likely to be timing-dependent; perform
  * a large number of migrations to reduce the odds of a false negative.
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index c87f38712073..66f873ea8a73 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -17,6 +17,9 @@
 #include "kvm_util.h"
 #include "processor.h"
 
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #define NR_VCPUS		4
 #define ST_GPA_BASE		(1 << 30)
 
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7f5b330b6a1b..dc7f5dc5fbcc 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -14,6 +14,10 @@
 #include "kvm_util.h"
 #include "processor.h"
 
+TEST_UNSUPPORTED(aarch64);
+TEST_UNSUPPORTED(s390x);
+TEST_UNSUPPORTED(riscv);
+
 #ifdef __x86_64__
 
 struct test_case {
-- 
2.39.0.rc1.256.g54fd8350bd-goog

