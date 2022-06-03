Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DA953C2D1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiFCAoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbiFCAnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:43:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468CA344D6
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:48 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j25-20020aa78d19000000b0051bb0c362a5so3480699pfe.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A2Yk1q82MRFC3fNkgpz/m7apoMQbehthuwSRqSROJ5Q=;
        b=WySL6Y3rEGrRF+t3glx+dd9FFmMMcgzjQXtcosLk9Sl1b/ot1F0NbU+2TB0qTTFVOB
         8bKf/iygmJRQWyrEyirRfSdBUoeZ0SvVj034Lk17Puia6arQ3V9wMgl9EzSEHY1fLXz5
         NKJLac+KOIBcOqzKm7C0Pd+tBdkq92sXftbFQ9PgD5kEcXPyPQiBNR23sT0aUF1d1q+x
         CWpgsoObHQ8x8JjYsNcfksBDdSLK79XNyK9CIfIn0yZ2sF5UyQjwVaHD8acQMah7l62x
         KaeDZYScZ2TFAb6kFag+7G4hfRE2UeliBfI+sj2oDk92wq9JTfjoLsxBTqadU2xH4Rg8
         mUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A2Yk1q82MRFC3fNkgpz/m7apoMQbehthuwSRqSROJ5Q=;
        b=zpQyKMO7NEC6L4Tx4RcR6dGHtrKmNTzEy1E1D+QiqKZ06a0vyzFVvPzb/AFi7Yhu4w
         MoyXzQv038mbm/P+sNLwlZXj1kQfzhbb1AEn1f5xdzqvnBdMeuv3KBWSAfUbQRRf2yue
         qvhpFHxj8M9ckLzsFui/mKCvAW9lU9SwV5sWGqokutf3O2ISsoJlrc7R8s/wiULnN+W1
         PwnuM4Njep/KpegCZ46HMp4FPWt0SaZ/uzpAk6BZKzA49ZwoGExrwBPtiC9FfgXqfPPS
         ljdVsT5o4md0wRbBd+XD4TKi9v9+jy2hb9oI4Ki68FAIXlQMVtpCH/NNADguetNEGSyh
         SpTw==
X-Gm-Message-State: AOAM530cFtfqWOnTVhF11WnOMe/lbi/8pSYFCYNElLwa3XsDte5tX2JI
        uUGcHuSOh2S1SlOcbTX38PFze3EzRro=
X-Google-Smtp-Source: ABdhPJyPH8jIZmiaGtHNv0usv0A2i2xZZceA8jOug1+7mbkK2PMqRG4H2FZs4HclSwj+uMFlQU8zZn+4USo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e94e:b0:154:3a4:c5e8 with SMTP id
 b14-20020a170902e94e00b0015403a4c5e8mr7659827pll.19.1654217027676; Thu, 02
 Jun 2022 17:43:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:13 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 006/144] KVM: selftests: Add another underscore to inner
 ioctl() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a second underscore to inner ioctl() helpers to better align with
commonly accepted kernel coding style, and to allow using a single
underscore variant in the future for macro shenanigans.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      |  6 ++---
 .../selftests/kvm/aarch64/hypercalls.c        |  2 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c |  8 +++----
 .../testing/selftests/kvm/aarch64/vgic_init.c |  2 +-
 .../selftests/kvm/include/kvm_util_base.h     |  8 +++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++----------
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 tools/testing/selftests/kvm/s390x/memop.c     |  4 ++--
 tools/testing/selftests/kvm/s390x/resets.c    |  4 ++--
 tools/testing/selftests/kvm/steal_time.c      |  6 ++---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  4 ++--
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  6 ++---
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  2 +-
 13 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index dd549cc75869..441c98ffb812 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -457,7 +457,7 @@ static void run_test(struct vcpu_config *c)
 		bool reject_reg = false;
 		int ret;
 
-		ret = _vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
+		ret = __vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
 		if (ret) {
 			printf("%s: Failed to get ", config_name(c));
 			print_reg(c, reg.id);
@@ -469,7 +469,7 @@ static void run_test(struct vcpu_config *c)
 		for_each_sublist(c, s) {
 			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
 				reject_reg = true;
-				ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+				ret = __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
 				if (ret != -1 || errno != EPERM) {
 					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
 					print_reg(c, reg.id);
@@ -481,7 +481,7 @@ static void run_test(struct vcpu_config *c)
 		}
 
 		if (!reject_reg) {
-			ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+			ret = __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
 			if (ret) {
 				printf("%s: Failed to set ", config_name(c));
 				print_reg(c, reg.id);
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 41e0210b7a5e..1eb9738453b4 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -148,7 +148,7 @@ static int set_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t val)
 		.addr = (uint64_t)&val,
 	};
 
-	return _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+	return __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
 }
 
 static void get_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t *addr)
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index d48129349213..271fa90e53fd 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -27,12 +27,12 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	vm_vcpu_add(vm, 0);
-	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
 	if (ret)
 		goto free_exit;
 
 	vm_vcpu_add(vm, 1);
-	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+	ret = __vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
 
 free_exit:
 	kvm_vm_free(vm);
@@ -54,11 +54,11 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
 	vm_vcpu_add(vm, 0);
 	vm_vcpu_add(vm, 1);
 
-	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
 	if (ret)
 		goto free_exit;
 
-	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+	ret = __vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
 
 free_exit:
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 5e3c26564192..8c16b5a750e5 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -55,7 +55,7 @@ static void guest_code(void)
 static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	ucall_init(vm, NULL);
-	int ret = _vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+	int ret = __vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
 	if (ret)
 		return -errno;
 	return 0;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 89b633b40247..662579a6358b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -159,12 +159,12 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
-int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
-		void *arg);
+int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
+		 void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
-int _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
+int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
 void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
-int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
+int __kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index da7e3369f4b8..03c1f885a98b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1719,7 +1719,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
 	struct kvm_reg_list reg_list_n = { .n = 0 }, *reg_list;
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_REG_LIST, &reg_list_n);
+	ret = __vcpu_ioctl(vm, vcpuid, KVM_GET_REG_LIST, &reg_list_n);
 	TEST_ASSERT(ret == -1 && errno == E2BIG, "KVM_GET_REG_LIST n=0");
 	reg_list = calloc(1, sizeof(*reg_list) + reg_list_n.n * sizeof(__u64));
 	reg_list->n = reg_list_n.n;
@@ -1905,7 +1905,7 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
 {
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
+	ret = __vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
 	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i (%s)",
 		    ret, errno, strerror(errno));
 }
@@ -1914,7 +1914,7 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
 {
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
+	ret = __vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
 	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i (%s)",
 		    ret, errno, strerror(errno));
 }
@@ -1923,7 +1923,7 @@ void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 {
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
+	ret = __vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
 	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i (%s)",
 		    ret, errno, strerror(errno));
 }
@@ -1932,7 +1932,7 @@ void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 {
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
+	ret = __vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
 	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i (%s)",
 		    ret, errno, strerror(errno));
 }
@@ -1955,13 +1955,13 @@ void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 {
 	int ret;
 
-	ret = _vcpu_ioctl(vm, vcpuid, cmd, arg);
+	ret = __vcpu_ioctl(vm, vcpuid, cmd, arg);
 	TEST_ASSERT(ret == 0, "vcpu ioctl %lu failed, rc: %i errno: %i (%s)",
 		cmd, ret, errno, strerror(errno));
 }
 
-int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
-		unsigned long cmd, void *arg)
+int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
+		 unsigned long cmd, void *arg)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int ret;
@@ -2025,12 +2025,12 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 {
 	int ret;
 
-	ret = _vm_ioctl(vm, cmd, arg);
+	ret = __vm_ioctl(vm, cmd, arg);
 	TEST_ASSERT(ret == 0, "vm ioctl %lu failed, rc: %i errno: %i (%s)",
 		cmd, ret, errno, strerror(errno));
 }
 
-int _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 {
 	return ioctl(vm->fd, cmd, arg);
 }
@@ -2056,7 +2056,7 @@ void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 		cmd, ret, errno, strerror(errno));
 }
 
-int _kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+int __kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 {
 	return ioctl(vm->kvm_fd, cmd, arg);
 }
@@ -2185,7 +2185,7 @@ int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
 		.level  = level,
 	};
 
-	return _vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+	return __vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
 }
 
 void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index abc0ae5a4fe1..c89e6b1fbfb1 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -295,7 +295,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	 * are powered-on using KVM_SET_MP_STATE ioctl().
 	 */
 	mps.mp_state = KVM_MP_STATE_RUNNABLE;
-	r = _vcpu_ioctl(vm, vcpuid, KVM_SET_MP_STATE, &mps);
+	r = __vcpu_ioctl(vm, vcpuid, KVM_SET_MP_STATE, &mps);
 	TEST_ASSERT(!r, "IOCTL KVM_SET_MP_STATE failed (error %d)", r);
 
 	/* Setup global pointer of guest to be same as the host */
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 49f26f544127..206ebc2df2d3 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -158,9 +158,9 @@ static void memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 {
 	if (vcpu.id == VM_VCPU_ID)
-		return _vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
+		return __vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
 	else
-		return _vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
+		return __vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
 }
 
 #define MEMOP(err, vcpu_p, mop_target_p, access_mode_p, buf_p, size_p, ...)	\
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index b143db6d8693..cc4b7c86d69f 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -76,7 +76,7 @@ static void assert_noirq(void)
 
 	irq_state.len = sizeof(buf);
 	irq_state.buf = (unsigned long)buf;
-	irqs = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
+	irqs = __vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
 	/*
 	 * irqs contains the number of retrieved interrupts. Any interrupt
 	 * (notably, the emergency call interrupt we have injected) should
@@ -196,7 +196,7 @@ static void inject_irq(int cpu_id)
 	irq_state.buf = (unsigned long)buf;
 	irq->type = KVM_S390_INT_EMERGENCY;
 	irq->u.emerg.code = cpu_id;
-	irqs = _vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state);
+	irqs = __vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state);
 	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
 }
 
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8c4e811bd586..75303fe8359d 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -166,7 +166,7 @@ static void steal_time_init(struct kvm_vm *vm)
 	};
 	int i, ret;
 
-	ret = _vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
+	ret = __vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
 	if (ret != 0 && errno == ENXIO) {
 		print_skip("steal-time not supported");
 		exit(KSFT_SKIP);
@@ -184,13 +184,13 @@ static void steal_time_init(struct kvm_vm *vm)
 		sync_global_to_guest(vm, st_gva[i]);
 
 		st_ipa = (ulong)st_gva[i] | 1;
-		ret = _vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+		ret = __vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
 		TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
 
 		st_ipa = (ulong)st_gva[i];
 		vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
 
-		ret = _vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+		ret = __vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
 		TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
 
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 8c245ab2d98a..7e45a3df8f98 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -121,9 +121,9 @@ void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
 	int ret;
 
 	if (!system)
-		ret = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+		ret = __vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 	else
-		ret = _kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+		ret = __kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 
 	TEST_ASSERT(ret == -1 && errno == E2BIG,
 		    "%s KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 2fe893ccedd0..ee3d058a9fe1 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -42,7 +42,7 @@ static void test_set_boot_busy(struct kvm_vm *vm)
 {
 	int res;
 
-	res = _vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID0);
+	res = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID0);
 	TEST_ASSERT(res == -1 && errno == EBUSY,
 			"KVM_SET_BOOT_CPU_ID set while running vm");
 }
@@ -133,13 +133,13 @@ static void check_set_bsp_busy(void)
 	add_x86_vcpu(vm, VCPU_ID0, true);
 	add_x86_vcpu(vm, VCPU_ID1, false);
 
-	res = _vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID1);
+	res = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID1);
 	TEST_ASSERT(res == -1 && errno == EBUSY, "KVM_SET_BOOT_CPU_ID set after adding vcpu");
 
 	run_vcpu(vm, VCPU_ID0);
 	run_vcpu(vm, VCPU_ID1);
 
-	res = _vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID1);
+	res = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *) VCPU_ID1);
 	TEST_ASSERT(res == -1 && errno == EBUSY, "KVM_SET_BOOT_CPU_ID set to a terminated vcpu");
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index 280c01fd2412..c35ada9f7f9c 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -186,7 +186,7 @@ int main(int argc, char *argv[])
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 
-	tsc_khz = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_TSC_KHZ, NULL);
+	tsc_khz = __vcpu_ioctl(vm, VCPU_ID, KVM_GET_TSC_KHZ, NULL);
 	TEST_ASSERT(tsc_khz != -1, "vcpu ioctl KVM_GET_TSC_KHZ failed");
 
 	/* scale down L1's TSC frequency */
-- 
2.36.1.255.ge46751e96f-goog

