Return-Path: <kvm+bounces-528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 333757E0974
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 20:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 542901C210CD
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BC423757;
	Fri,  3 Nov 2023 19:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0ouv/Kt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF422F11
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 19:29:30 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44109125
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 12:29:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so2909659276.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 12:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699039768; x=1699644568; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DcsXd0GFR+eHw7Zk01QzN5YVrXzmH+eGsiVjDLuLrbg=;
        b=q0ouv/KtIRi8DfeU0SGGgEFhL7bovC9C2z94ld7wrsLE6/20WKqMpcdEEquzlM/djF
         H/N6OeqO9QI8sjX0f0rLBqvbxR5l8g+vuwRfIuYICa22SIhCfv16ig3f+zXNB7+0/F1t
         86vS4EhttBRIRaHfZZ8WFe+DhGF8W2j7zgEvh3Yt+4Yzae1E42esVmc04jYAGuAar2iL
         QpMrWe8LyVeS/S1Eys2p3rCRFvIyhWVCrhzqhnhoi6ojIvU5Wj7XXmVq6grxEDyVNOdc
         oiSPqvXbz4ez8Z21SXxkEXIl/Ug+SGoHjZIc9VHrifLVO1qMh4c1sSXvc9cq0+fqIz5S
         gz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699039768; x=1699644568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcsXd0GFR+eHw7Zk01QzN5YVrXzmH+eGsiVjDLuLrbg=;
        b=Kh0rSg6Jfse/2u5n/4TaaXVHrZA0ptbIQopKnCquuim7ZviOJ2VNKS5A893wEDRCnH
         VRZsoHBiZhiQIScJ/MVTi9C2UefwWw5dPW7hptiU6yx58CoKEDg2vBjMFrvAfjyB3QRB
         BdNCCftM7HgxktscpoVuIHlj0Sry8ksmYmsybhpvkK8dpOYgQbwFB7aUXj9wdxqBOVfo
         pd4f62LwAmrhS6+xqqjlCeMmZXyWcXeR0ZZh3hN5S/8q+MF+0B25BtGlfhp0vQCrCr9Q
         euCDlEPFzKTg0GFA5qMnyVnT+0XMEYadIax/zZVSV0p6kNlhAawn5Aj0t/wxpbUiZXre
         z2MA==
X-Gm-Message-State: AOJu0YxGaSq54CeEbnZSS5hDd4k3EDdLZSlTQm1EuzddL1yt5RVCw4yY
	/wGvZJFCc4zt4RKjfKnABo+900xM79GbvUVwa0msnB208Exu0gFGClgUFr7jdbv9dYTUmK/i3sf
	FjqvSR0OFWNNKzq2XwEjVoASn9KNXp2sRcAHoj5bD4ivp7Sc8mOtkAgGzCijNiIwag18Rf34=
X-Google-Smtp-Source: AGHT+IHGX/OYyqwOZmrU0so7N+Il/tGEh7CejCMoEZfMDm9u+sO99+CKLZX94FrvOBKGkDnt0WUaY37ZjA0cDfL3dQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:aa07:0:b0:da0:c584:defe with SMTP
 id s7-20020a25aa07000000b00da0c584defemr403214ybi.13.1699039768395; Fri, 03
 Nov 2023 12:29:28 -0700 (PDT)
Date: Fri,  3 Nov 2023 19:29:13 +0000
In-Reply-To: <20231103192915.2209393-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103192915.2209393-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103192915.2209393-2-coltonlewis@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: selftests: Standardize GIC base addresses
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use default values during GIC initialization and setup to avoid
multiple tests needing to decide and declare base addresses for GICD
and GICR. Remove the repeated definitions of these addresses across
tests.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  8 ++------
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     | 11 ++---------
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  5 +----
 tools/testing/selftests/kvm/include/aarch64/gic.h  |  5 ++++-
 tools/testing/selftests/kvm/include/aarch64/vgic.h |  3 ++-
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |  7 ++++++-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |  7 ++++++-
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..f5101898c46a 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -59,9 +59,6 @@ static struct test_args test_args = {
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 enum guest_stage {
 	GUEST_STAGE_VTIMER_CVAL = 1,
 	GUEST_STAGE_VTIMER_TVAL,
@@ -204,8 +201,7 @@ static void guest_code(void)
 
 	local_irq_disable();
 
-	gic_init(GIC_V3, test_args.nr_vcpus,
-		(void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_init(GIC_V3, test_args.nr_vcpus);
 
 	timer_set_ctl(VIRTUAL, CTL_IMASK);
 	timer_set_ctl(PHYSICAL, CTL_IMASK);
@@ -391,7 +387,7 @@ static struct kvm_vm *test_vm_create(void)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
 	test_init_timer_irq(vm);
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
 
 	/* Make all the test's cmdline args visible to the guest */
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 2e64b4856e38..d3bf584d2cc1 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -19,9 +19,6 @@
 #include "gic_v3.h"
 #include "vgic.h"
 
-#define GICD_BASE_GPA		0x08000000ULL
-#define GICR_BASE_GPA		0x080A0000ULL
-
 /*
  * Stores the user specified args; it's passed to the guest and to every test
  * function.
@@ -49,9 +46,6 @@ struct test_args {
 #define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
 #define IRQ_DEFAULT_PRIO_REG	(IRQ_DEFAULT_PRIO << KVM_PRIO_SHIFT) /* 0xf0 */
 
-static void *dist = (void *)GICD_BASE_GPA;
-static void *redist = (void *)GICR_BASE_GPA;
-
 /*
  * The kvm_inject_* utilities are used by the guest to ask the host to inject
  * interrupts (e.g., using the KVM_IRQ_LINE ioctl).
@@ -478,7 +472,7 @@ static void guest_code(struct test_args *args)
 	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
-	gic_init(GIC_V3, 1, dist, redist);
+	gic_init(GIC_V3, 1);
 
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
@@ -764,8 +758,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpu, 1, args_gva);
 
-	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
-			GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, 1, nr_irqs);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..53c9d7a2611d 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -22,9 +22,6 @@
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 static int gic_fd;
 
 static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
@@ -33,7 +30,7 @@ static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
 	 * The test can still run even if hardware does not support GICv3, as it
 	 * is only an optimization to reduce guest exits.
 	 */
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 }
 
 static void arch_cleanup_vm(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index b217ea17cac5..9043eaef1076 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -16,13 +16,16 @@ enum gic_type {
 #define MIN_SPI			32
 #define MAX_SPI			1019
 #define IAR_SPURIOUS		1023
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
 
 #define INTID_IS_SGI(intid)	(0       <= (intid) && (intid) < MIN_PPI)
 #define INTID_IS_PPI(intid)	(MIN_PPI <= (intid) && (intid) < MIN_SPI)
 #define INTID_IS_SPI(intid)	(MIN_SPI <= (intid) && (intid) <= MAX_SPI)
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
+void _gic_init(enum gic_type type, unsigned int nr_cpus,
 		void *dist_base, void *redist_base);
+void gic_init(enum gic_type type, unsigned int nr_cpus);
 void gic_irq_enable(unsigned int intid);
 void gic_irq_disable(unsigned int intid);
 unsigned int gic_get_and_ack_irq(void);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index 0ac6f05c63f9..e116a815964a 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -16,8 +16,9 @@
 	((uint64_t)(flags) << 12) | \
 	index)
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
+int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
+int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs);
 
 #define VGIC_MAX_RESERVED	1023
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 55668631d546..9d15598d4e34 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -49,7 +49,7 @@ gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
 	spin_unlock(&gic_lock);
 }
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
+void _gic_init(enum gic_type type, unsigned int nr_cpus,
 		void *dist_base, void *redist_base)
 {
 	uint32_t cpu = guest_get_vcpuid();
@@ -63,6 +63,11 @@ void gic_init(enum gic_type type, unsigned int nr_cpus,
 	gic_cpu_init(cpu, redist_base);
 }
 
+void gic_init(enum gic_type type, unsigned int nr_cpus)
+{
+	_gic_init(type, nr_cpus, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+}
+
 void gic_irq_enable(unsigned int intid)
 {
 	GUEST_ASSERT(gic_common_ops);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b5f28d21a947..7cd5be5351c8 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -30,7 +30,7 @@
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
+int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
 {
 	int gic_fd;
@@ -79,6 +79,11 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	return gic_fd;
 }
 
+int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs)
+{
+	return _vgic_v3_setup(vm, nr_vcpus, nr_irqs, GICD_BASE_GPA, GICR_BASE_GPA);
+}
+
 /* should only work for level sensitive interrupts */
 int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 {
-- 
2.42.0.869.gea05f2083d-goog


