Return-Path: <kvm+bounces-3013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FB27FFB5A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 189161C2108E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DBC52F75;
	Thu, 30 Nov 2023 19:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VDlfnnuS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD4A93
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:29:30 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-a195e0145acso54958566b.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701372569; x=1701977369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu/G57LnazjPF+hhit8sVOHNi2qaherFjM1RsRjPAGA=;
        b=VDlfnnuSf8lFNoAtvEgqwyGmIFFgmC1gT0VDYbP44YR5hzvZO6fITUUgrje/w+TeUW
         p+Za+jONVFpVXWHCRXzzSlUWC708OxJmajg+y60i7+CnwkFD0zPAQUV0kJ//Bd/8AsPD
         xll/n8PFntgTMe4WgDNLWstR58d7Bmn/2ykaSd15BKlBqGwnV98ZmVgmq5r84X2P4S/6
         cHjRt4OoPbtxMO0lApuoP2/uhTD/NpyXycLeH/0bOU7tvAbEKFC8zL7KCAENYKQLKw1G
         zWTx0jlUO8ZS4r5hoWLMzLetIfxfr25iBVc35yBmPsL7Xsc5eEibYidpBDsWPS8AJ/KP
         j0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372569; x=1701977369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qu/G57LnazjPF+hhit8sVOHNi2qaherFjM1RsRjPAGA=;
        b=YwWmw0r2hLuJiGVpWx/7NZP4fwpweiecJUIoWX2KzKl8lamHkmnQekr9eCplOuBv15
         KABGt+hMW1V7kKl/KrOJ7r+EqIzZ/YD5UwNXbGNCh3XhVN3Py7VLA88qOsP1q9HyVFv2
         qxhmhqKTon8r4H6yy9NAy+Py0CgSA2TRhZzsXgF/NIupHNJrzCQ1fjNGhIetvQNY44f+
         SMppg1/rA7HYHF0L14yb4TBLZYTw0/UJ4VRaFPY5EShD35fPgMB6BXrneGV8GMjMxaxS
         i8Z/1JTbBXI/+pwjXqIHGWmFD2roAyzz9t2yWw5u/DZz8t6ebBDlNf/4OjdwdB8mT+ix
         SM5A==
X-Gm-Message-State: AOJu0YxGO/NtUeLZw1Y4bXWLZDHJDc1U2EDVBMpYhn0HRJPcRFXdNFsm
	nn8wn55VLjKDfwWrsBUlZruHl74YPRt6g+ChWOU=
X-Google-Smtp-Source: AGHT+IHa+HTBgwPhkJZoBMr5lzGTwWzN2zRvlyUhmTbPbO/HwbuZuUp4S65V/IpvSmICdp3auWh37g==
X-Received: by 2002:a17:906:1091:b0:a19:a19b:422a with SMTP id u17-20020a170906109100b00a19a19b422amr4455eju.149.1701368913770;
        Thu, 30 Nov 2023 10:28:33 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id jz22-20020a17090775f600b009fdcc65d720sm954665ejc.72.2023.11.30.10.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 10:28:33 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev
Subject: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
Date: Thu, 30 Nov 2023 19:28:33 +0100
Message-ID: <20231130182832.54603-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

A few __TEST_REQUIRE callers are appending their own newline, resulting
in an extra one being output. Rather than remove the newlines from
those callers, remove it from __TEST_REQUIRE and add newlines to all
the other callers, as __TEST_REQUIRE was the only output function
appending newlines and consistency is a good thing.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---

Applies to kvm-x86/selftests (I chose that branch to ensure I got the
MAGIC_TOKEN change)

 tools/testing/selftests/kvm/aarch64/arch_timer.c          | 4 ++--
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c    | 4 ++--
 tools/testing/selftests/kvm/aarch64/vgic_irq.c            | 2 +-
 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c | 2 +-
 tools/testing/selftests/kvm/access_tracking_perf_test.c   | 4 ++--
 tools/testing/selftests/kvm/include/test_util.h           | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c                | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
 tools/testing/selftests/kvm/rseq_test.c                   | 2 +-
 tools/testing/selftests/kvm/system_counter_offset_test.c  | 2 +-
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c   | 2 +-
 11 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..89b93e342654 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -392,7 +392,7 @@ static struct kvm_vm *test_vm_create(void)
 
 	test_init_timer_irq(vm);
 	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3\n");
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
@@ -470,7 +470,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 
 	__TEST_REQUIRE(!test_args.migration_freq_ms || get_nprocs() >= 2,
-		       "At least two physical CPUs needed for vCPU migration");
+		       "At least two physical CPUs needed for vCPU migration\n");
 
 	vm = test_vm_create();
 	test_run(vm);
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 866002917441..19088a971b1f 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -540,7 +540,7 @@ void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
 
 	/* Number of breakpoints */
 	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), aa64dfr0) + 1;
-	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
+	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required\n");
 
 	/* Number of watchpoints */
 	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs), aa64dfr0) + 1;
@@ -585,7 +585,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
 	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
-		       "Armv8 debug architecture not supported.");
+		       "Armv8 debug architecture not supported.\n");
 	kvm_vm_free(vm);
 
 	while ((opt = getopt(argc, argv, "i:")) != -1) {
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 2e64b4856e38..e4452c4b60c2 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -766,7 +766,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
-	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping\n");
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
 		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5ea78986e665..3c5b83e0e776 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -458,7 +458,7 @@ static void create_vpmu_vm(void *guest_code)
 	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
 					GICD_BASE_GPA, GICR_BASE_GPA);
 	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
-		       "Failed to create vgic-v3, skipping");
+		       "Failed to create vgic-v3, skipping\n");
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
 	vcpu_get_reg(vpmu_vm.vcpu,
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..65efec6f4f90 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -103,7 +103,7 @@ static uint64_t lookup_pfn(int pagemap_fd, struct kvm_vm *vm, uint64_t gva)
 		return 0;
 
 	pfn = entry & PAGEMAP_PFN_MASK;
-	__TEST_REQUIRE(pfn, "Looking up PFNs requires CAP_SYS_ADMIN");
+	__TEST_REQUIRE(pfn, "Looking up PFNs requires CAP_SYS_ADMIN\n");
 
 	return pfn;
 }
@@ -385,7 +385,7 @@ int main(int argc, char *argv[])
 
 	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
 	__TEST_REQUIRE(page_idle_fd >= 0,
-		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
+		       "CONFIG_IDLE_PAGE_TRACKING is not enabled\n");
 	close(page_idle_fd);
 
 	for_each_guest_mode(run_test, &params);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a0c7dd3a5b30..88763f0e1b78 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -37,10 +37,10 @@ void __printf(1, 2) print_skip(const char *fmt, ...);
 #define __TEST_REQUIRE(f, fmt, ...)				\
 do {								\
 	if (!(f))						\
-		ksft_exit_skip("- " fmt "\n", ##__VA_ARGS__);	\
+		ksft_exit_skip("- " fmt, ##__VA_ARGS__);	\
 } while (0)
 
-#define TEST_REQUIRE(f) __TEST_REQUIRE(f, "Requirement not met: %s", #f)
+#define TEST_REQUIRE(f) __TEST_REQUIRE(f, "Requirement not met: %s\n", #f)
 
 ssize_t test_write(int fd, const void *buf, size_t count);
 ssize_t test_read(int fd, void *buf, size_t count);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 17a978b8a2c4..7b40990d9b08 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -27,7 +27,7 @@ int open_path_or_exit(const char *path, int flags)
 	int fd;
 
 	fd = open(path, flags);
-	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)", path, errno);
+	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)\n", path, errno);
 
 	return fd;
 }
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..abd19059b236 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -719,12 +719,12 @@ void __vm_xsave_require_permission(uint64_t xfeature, const char *name)
 	close(kvm_fd);
 
 	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
-		__TEST_REQUIRE(0, "KVM_X86_XCOMP_GUEST_SUPP not supported");
+		__TEST_REQUIRE(0, "KVM_X86_XCOMP_GUEST_SUPP not supported\n");
 
 	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
 
 	__TEST_REQUIRE(bitmask & xfeature,
-		       "Required XSAVE feature '%s' not supported", name);
+		       "Required XSAVE feature '%s' not supported\n", name);
 
 	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, ilog2(xfeature)));
 
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index f74e76d03b7e..e825fe6807fa 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -183,7 +183,7 @@ static void calc_min_max_cpu(void)
 	}
 
 	__TEST_REQUIRE(cnt >= 2,
-		       "Only one usable CPU, task migration not possible");
+		       "Only one usable CPU, task migration not possible\n");
 }
 
 int main(int argc, char *argv[])
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7f5b330b6a1b..46e4ca694e6d 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -30,7 +30,7 @@ static void check_preconditions(struct kvm_vcpu *vcpu)
 {
 	__TEST_REQUIRE(!__vcpu_has_device_attr(vcpu, KVM_VCPU_TSC_CTRL,
 					       KVM_VCPU_TSC_OFFSET),
-		       "KVM_VCPU_TSC_OFFSET not supported; skipping test");
+		       "KVM_VCPU_TSC_OFFSET not supported; skipping test\n");
 }
 
 static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 83e25bccc139..a3f4edbd9add 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -259,7 +259,7 @@ int main(int argc, char **argv)
 	__TEST_REQUIRE(token == MAGIC_TOKEN,
 		       "This test must be run with the magic token %d.\n"
 		       "This is done by nx_huge_pages_test.sh, which\n"
-		       "also handles environment setup for the test.", MAGIC_TOKEN);
+		       "also handles environment setup for the test.\n", MAGIC_TOKEN);
 
 	run_test(reclaim_period_ms, false, reboot_permissions);
 	run_test(reclaim_period_ms, true, reboot_permissions);
-- 
2.43.0


