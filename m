Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA817679AA
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjG2Agy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjG2Agw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:36:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A8430E4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d114bc2057fso2457999276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591008; x=1691195808;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnJjXAesqZCa/d3cAwxx/7WBSyt0lo9G6LRvakzkto4=;
        b=jUn8aeUMa4Mel0fxTNeUgmAdowfZ8WdDGevz115eMJUb1kWUnD1KrKGJn3athxmT3Q
         nRztJg0rHN4brYK7r7uNEA05fwZh3DLvFUJWuvJ6SOZYBSZTJ4Cxm5M6Er3edx3p0nqd
         EipI9uNwne4aghFFZm8RGTZgXq/F+oCMjD3uNDjI61cdHJIFyKNswZS7CQrX9W0hBL9e
         ncYtX7j2qXZvLgBHOLxrIk6u3Z1lCcUKjIuKoy6bzqabjM0hDon6blY6ba+Yb1ooL6x+
         SCEjsfZRKXucBcWnW1SsdeYILzCk+TIAMVRylmeWuCWIrAHTmXCnrkVlx5GfYWdBEG5F
         Ykdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591008; x=1691195808;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lnJjXAesqZCa/d3cAwxx/7WBSyt0lo9G6LRvakzkto4=;
        b=SxXGDTXnh4u0S9izoTScNgrGaAuBZ223zlESs5yj+/PUYcL9SFqcslCZIBppd6AKys
         v88nxv8YoCkQJcbkiu4jfikP56EUXDzuvRfAe035L+fqyJxhNYilwqOeugI3kZetwbSj
         mY62DQ8/hcpN4ywqfJGtigmorsbeioT6kZ0dSEPFOBBOkV2UQhWMhFXFKNoliIsPAOKg
         mjK0KJ4do1N9Kjjc74k62IHrjR4h7uOXWCcAYBYMd1oYG9jRowyXrAA/WlnZgFNEBtAN
         oSEaUq3kyBabyeCgPS1ugR8nnZUtJhEYOxBuFeHi09/rPCeRm/d4TvYCl0OUPojJAWXa
         Y81A==
X-Gm-Message-State: ABy/qLahNO9I9O8EQq2v4eQBjsSL/nmJYnHWwyS4um/B4QQpWDHXaX0B
        /jWVeZmr9637kln6stytQfj7DwkS6Fw=
X-Google-Smtp-Source: APBJJlFAx7cM9mJRAhoJzWwy39g4Sjs+107mmAbO5cwLAWMvlzZPNUnBMDTU+W65N0ydcBPy6HTiHL+Uhj4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1582:b0:d0a:353b:b93b with SMTP id
 k2-20020a056902158200b00d0a353bb93bmr18365ybu.3.1690591008343; Fri, 28 Jul
 2023 17:36:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:10 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-2-seanjc@google.com>
Subject: [PATCH v4 01/34] KVM: selftests: Rename the ASSERT_EQ macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

There is already an ASSERT_EQ macro in the file
tools/testing/selftests/kselftest_harness.h, so we currently
can't include test_util.h from the KVM selftests together with
that file. Rename the macro in the KVM selftests to TEST_ASSERT_EQ
to avoid the problem - it is also more similar to the other macros
in test_util.h that way.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |  8 +--
 .../selftests/kvm/aarch64/page_fault_test.c   | 10 +--
 .../testing/selftests/kvm/include/test_util.h |  4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 .../selftests/kvm/max_guest_memory_test.c     |  2 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c | 62 +++++++++----------
 tools/testing/selftests/kvm/s390x/memop.c     |  6 +-
 tools/testing/selftests/kvm/s390x/tprot.c     |  4 +-
 .../x86_64/dirty_log_page_splitting_test.c    | 18 +++---
 .../x86_64/exit_on_emulation_failure_test.c   |  2 +-
 .../kvm/x86_64/nested_exceptions_test.c       | 12 ++--
 .../kvm/x86_64/recalc_apic_map_test.c         |  6 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      | 32 +++++-----
 .../vmx_exception_with_invalid_guest_state.c  |  2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  3 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   |  8 +--
 .../selftests/kvm/x86_64/xen_vmcall_test.c    | 20 +++---
 17 files changed, 101 insertions(+), 100 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/=
testing/selftests/kvm/aarch64/aarch32_id_regs.c
index 4951ac53d1f8..b90580840b22 100644
--- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
@@ -98,7 +98,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 		uint64_t val;
=20
 		vcpu_get_reg(vcpu, reg_id, &val);
-		ASSERT_EQ(val, 0);
+		TEST_ASSERT_EQ(val, 0);
=20
 		/*
 		 * Expect the ioctl to succeed with no effect on the register
@@ -107,7 +107,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
 		vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
=20
 		vcpu_get_reg(vcpu, reg_id, &val);
-		ASSERT_EQ(val, 0);
+		TEST_ASSERT_EQ(val, 0);
 	}
 }
=20
@@ -127,14 +127,14 @@ static void test_user_raz_invariant(struct kvm_vcpu *=
vcpu)
 		uint64_t val;
=20
 		vcpu_get_reg(vcpu, reg_id, &val);
-		ASSERT_EQ(val, 0);
+		TEST_ASSERT_EQ(val, 0);
=20
 		r =3D __vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
 		TEST_ASSERT(r < 0 && errno =3D=3D EINVAL,
 			    "unexpected KVM_SET_ONE_REG error: r=3D%d, errno=3D%d", r, errno);
=20
 		vcpu_get_reg(vcpu, reg_id, &val);
-		ASSERT_EQ(val, 0);
+		TEST_ASSERT_EQ(val, 0);
 	}
 }
=20
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/=
testing/selftests/kvm/aarch64/page_fault_test.c
index df10f1ffa20d..e5bb8767d2cb 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -318,7 +318,7 @@ static int uffd_generic_handler(int uffd_mode, int uffd=
, struct uffd_msg *msg,
=20
 	TEST_ASSERT(uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MISSING,
 		    "The only expected UFFD mode is MISSING");
-	ASSERT_EQ(addr, (uint64_t)args->hva);
+	TEST_ASSERT_EQ(addr, (uint64_t)args->hva);
=20
 	pr_debug("uffd fault: addr=3D%p write=3D%d\n",
 		 (void *)addr, !!(flags & UFFD_PAGEFAULT_FLAG_WRITE));
@@ -432,7 +432,7 @@ static void mmio_on_test_gpa_handler(struct kvm_vm *vm,=
 struct kvm_run *run)
 	region =3D vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	hva =3D (void *)region->region.userspace_addr;
=20
-	ASSERT_EQ(run->mmio.phys_addr, region->region.guest_phys_addr);
+	TEST_ASSERT_EQ(run->mmio.phys_addr, region->region.guest_phys_addr);
=20
 	memcpy(hva, run->mmio.data, run->mmio.len);
 	events.mmio_exits +=3D 1;
@@ -631,9 +631,9 @@ static void setup_default_handlers(struct test_desc *te=
st)
=20
 static void check_event_counts(struct test_desc *test)
 {
-	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
-	ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
-	ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_runs);
+	TEST_ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+	TEST_ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
+	TEST_ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_run=
s);
 }
=20
 static void print_test_banner(enum vm_guest_mode mode, struct test_params =
*p)
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h
index a6e9f215ce70..e734e52d8a3a 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -53,11 +53,11 @@ void test_assert(bool exp, const char *exp_str,
 #define TEST_ASSERT(e, fmt, ...) \
 	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
=20
-#define ASSERT_EQ(a, b) do { \
+#define TEST_ASSERT_EQ(a, b) do { \
 	typeof(a) __a =3D (a); \
 	typeof(b) __b =3D (b); \
 	TEST_ASSERT(__a =3D=3D __b, \
-		    "ASSERT_EQ(%s, %s) failed.\n" \
+		    "TEST_ASSERT_EQ(%s, %s) failed.\n" \
 		    "\t%s is %#lx\n" \
 		    "\t%s is %#lx", \
 		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index 9741a7ff6380..3170d7a4520b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -994,7 +994,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	if (src_type =3D=3D VM_MEM_SRC_ANONYMOUS_THP)
 		alignment =3D max(backing_src_pagesz, alignment);
=20
-	ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
+	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
=20
 	/* Add enough memory to align up if necessary */
 	if (alignment > 1)
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/te=
sting/selftests/kvm/max_guest_memory_test.c
index feaf2be20ff2..6628dc4dda89 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -55,7 +55,7 @@ static void rendezvous_with_boss(void)
 static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu_run(vcpu);
-	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 }
=20
 static void *vcpu_worker(void *data)
diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/=
selftests/kvm/s390x/cmma_test.c
index 1d73e78e8fa7..c8e0a6495a63 100644
--- a/tools/testing/selftests/kvm/s390x/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
@@ -237,8 +237,8 @@ static void test_get_cmma_basic(void)
=20
 	/* GET_CMMA_BITS without CMMA enabled should fail */
 	rc =3D vm_get_cmma_bits(vm, 0, &errno_out);
-	ASSERT_EQ(rc, -1);
-	ASSERT_EQ(errno_out, ENXIO);
+	TEST_ASSERT_EQ(rc, -1);
+	TEST_ASSERT_EQ(errno_out, ENXIO);
=20
 	enable_cmma(vm);
 	vcpu =3D vm_vcpu_add(vm, 1, guest_do_one_essa);
@@ -247,31 +247,31 @@ static void test_get_cmma_basic(void)
=20
 	/* GET_CMMA_BITS without migration mode and without peeking should fail *=
/
 	rc =3D vm_get_cmma_bits(vm, 0, &errno_out);
-	ASSERT_EQ(rc, -1);
-	ASSERT_EQ(errno_out, EINVAL);
+	TEST_ASSERT_EQ(rc, -1);
+	TEST_ASSERT_EQ(errno_out, EINVAL);
=20
 	/* GET_CMMA_BITS without migration mode and with peeking should work */
 	rc =3D vm_get_cmma_bits(vm, KVM_S390_CMMA_PEEK, &errno_out);
-	ASSERT_EQ(rc, 0);
-	ASSERT_EQ(errno_out, 0);
+	TEST_ASSERT_EQ(rc, 0);
+	TEST_ASSERT_EQ(errno_out, 0);
=20
 	enable_dirty_tracking(vm);
 	enable_migration_mode(vm);
=20
 	/* GET_CMMA_BITS with invalid flags */
 	rc =3D vm_get_cmma_bits(vm, 0xfeedc0fe, &errno_out);
-	ASSERT_EQ(rc, -1);
-	ASSERT_EQ(errno_out, EINVAL);
+	TEST_ASSERT_EQ(rc, -1);
+	TEST_ASSERT_EQ(errno_out, EINVAL);
=20
 	kvm_vm_free(vm);
 }
=20
 static void assert_exit_was_hypercall(struct kvm_vcpu *vcpu)
 {
-	ASSERT_EQ(vcpu->run->exit_reason, 13);
-	ASSERT_EQ(vcpu->run->s390_sieic.icptcode, 4);
-	ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x8300);
-	ASSERT_EQ(vcpu->run->s390_sieic.ipb, 0x5010000);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, 13);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, 4);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x8300);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipb, 0x5010000);
 }
=20
 static void test_migration_mode(void)
@@ -283,8 +283,8 @@ static void test_migration_mode(void)
=20
 	/* enabling migration mode on a VM without memory should fail */
 	rc =3D __enable_migration_mode(vm);
-	ASSERT_EQ(rc, -1);
-	ASSERT_EQ(errno, EINVAL);
+	TEST_ASSERT_EQ(rc, -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
 	TEST_ASSERT(!is_migration_mode_on(vm), "migration mode should still be of=
f");
 	errno =3D 0;
=20
@@ -304,8 +304,8 @@ static void test_migration_mode(void)
=20
 	/* migration mode when memslots have dirty tracking off should fail */
 	rc =3D __enable_migration_mode(vm);
-	ASSERT_EQ(rc, -1);
-	ASSERT_EQ(errno, EINVAL);
+	TEST_ASSERT_EQ(rc, -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
 	TEST_ASSERT(!is_migration_mode_on(vm), "migration mode should still be of=
f");
 	errno =3D 0;
=20
@@ -314,7 +314,7 @@ static void test_migration_mode(void)
=20
 	/* enabling migration mode should work now */
 	rc =3D __enable_migration_mode(vm);
-	ASSERT_EQ(rc, 0);
+	TEST_ASSERT_EQ(rc, 0);
 	TEST_ASSERT(is_migration_mode_on(vm), "migration mode should be on");
 	errno =3D 0;
=20
@@ -350,7 +350,7 @@ static void test_migration_mode(void)
 	 */
 	vm_mem_region_set_flags(vm, TEST_DATA_TWO_MEMSLOT, KVM_MEM_LOG_DIRTY_PAGE=
S);
 	rc =3D __enable_migration_mode(vm);
-	ASSERT_EQ(rc, 0);
+	TEST_ASSERT_EQ(rc, 0);
 	TEST_ASSERT(is_migration_mode_on(vm), "migration mode should be on");
 	errno =3D 0;
=20
@@ -394,9 +394,9 @@ static void assert_all_slots_cmma_dirty(struct kvm_vm *=
vm)
 	};
 	memset(cmma_value_buf, 0xff, sizeof(cmma_value_buf));
 	vm_ioctl(vm, KVM_S390_GET_CMMA_BITS, &args);
-	ASSERT_EQ(args.count, MAIN_PAGE_COUNT);
-	ASSERT_EQ(args.remaining, TEST_DATA_PAGE_COUNT);
-	ASSERT_EQ(args.start_gfn, 0);
+	TEST_ASSERT_EQ(args.count, MAIN_PAGE_COUNT);
+	TEST_ASSERT_EQ(args.remaining, TEST_DATA_PAGE_COUNT);
+	TEST_ASSERT_EQ(args.start_gfn, 0);
=20
 	/* ...and then - after a hole - the TEST_DATA memslot should follow */
 	args =3D (struct kvm_s390_cmma_log){
@@ -407,9 +407,9 @@ static void assert_all_slots_cmma_dirty(struct kvm_vm *=
vm)
 	};
 	memset(cmma_value_buf, 0xff, sizeof(cmma_value_buf));
 	vm_ioctl(vm, KVM_S390_GET_CMMA_BITS, &args);
-	ASSERT_EQ(args.count, TEST_DATA_PAGE_COUNT);
-	ASSERT_EQ(args.start_gfn, TEST_DATA_START_GFN);
-	ASSERT_EQ(args.remaining, 0);
+	TEST_ASSERT_EQ(args.count, TEST_DATA_PAGE_COUNT);
+	TEST_ASSERT_EQ(args.start_gfn, TEST_DATA_START_GFN);
+	TEST_ASSERT_EQ(args.remaining, 0);
=20
 	/* ...and nothing else should be there */
 	args =3D (struct kvm_s390_cmma_log){
@@ -420,9 +420,9 @@ static void assert_all_slots_cmma_dirty(struct kvm_vm *=
vm)
 	};
 	memset(cmma_value_buf, 0xff, sizeof(cmma_value_buf));
 	vm_ioctl(vm, KVM_S390_GET_CMMA_BITS, &args);
-	ASSERT_EQ(args.count, 0);
-	ASSERT_EQ(args.start_gfn, 0);
-	ASSERT_EQ(args.remaining, 0);
+	TEST_ASSERT_EQ(args.count, 0);
+	TEST_ASSERT_EQ(args.start_gfn, 0);
+	TEST_ASSERT_EQ(args.remaining, 0);
 }
=20
 /**
@@ -498,11 +498,11 @@ static void assert_cmma_dirty(u64 first_dirty_gfn,
 			      u64 dirty_gfn_count,
 			      const struct kvm_s390_cmma_log *res)
 {
-	ASSERT_EQ(res->start_gfn, first_dirty_gfn);
-	ASSERT_EQ(res->count, dirty_gfn_count);
+	TEST_ASSERT_EQ(res->start_gfn, first_dirty_gfn);
+	TEST_ASSERT_EQ(res->count, dirty_gfn_count);
 	for (size_t i =3D 0; i < dirty_gfn_count; i++)
-		ASSERT_EQ(cmma_value_buf[0], 0x0); /* stable state */
-	ASSERT_EQ(cmma_value_buf[dirty_gfn_count], 0xff); /* not touched */
+		TEST_ASSERT_EQ(cmma_value_buf[0], 0x0); /* stable state */
+	TEST_ASSERT_EQ(cmma_value_buf[dirty_gfn_count], 0xff); /* not touched */
 }
=20
 static void test_get_skip_holes(void)
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/self=
tests/kvm/s390x/memop.c
index 8e4b94d7b8dd..de73dc030905 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -281,8 +281,8 @@ enum stage {
 	if (uc.cmd =3D=3D UCALL_ABORT) {					\
 		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");		\
 	}								\
-	ASSERT_EQ(uc.cmd, UCALL_SYNC);					\
-	ASSERT_EQ(uc.args[1], __stage);					\
+	TEST_ASSERT_EQ(uc.cmd, UCALL_SYNC);				\
+	TEST_ASSERT_EQ(uc.args[1], __stage);				\
 })									\
=20
 static void prepare_mem12(void)
@@ -808,7 +808,7 @@ static void test_termination(void)
 	HOST_SYNC(t.vcpu, STAGE_IDLED);
 	MOP(t.vm, ABSOLUTE, READ, &teid, sizeof(teid), GADDR(prefix + 168));
 	/* Bits 56, 60, 61 form a code, 0 being the only one allowing for termina=
tion */
-	ASSERT_EQ(teid & teid_mask, 0);
+	TEST_ASSERT_EQ(teid & teid_mask, 0);
=20
 	kvm_vm_free(t.kvm_vm);
 }
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/self=
tests/kvm/s390x/tprot.c
index a9a0b76e5fa4..40d3ea16c052 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -191,8 +191,8 @@ static void guest_code(void)
 	get_ucall(__vcpu, &uc);					\
 	if (uc.cmd =3D=3D UCALL_ABORT)				\
 		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");	\
-	ASSERT_EQ(uc.cmd, UCALL_SYNC);				\
-	ASSERT_EQ(uc.args[1], __stage);				\
+	TEST_ASSERT_EQ(uc.cmd, UCALL_SYNC);			\
+	TEST_ASSERT_EQ(uc.args[1], __stage);			\
 })
=20
 #define HOST_SYNC(vcpu, stage)			\
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_te=
st.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index beb7e2c10211..634c6bfcd572 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -72,7 +72,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_=
args)
=20
 		vcpu_run(vcpu);
=20
-		ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+		TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
=20
 		vcpu_last_completed_iteration[vcpu_idx] =3D current_iteration;
=20
@@ -179,12 +179,12 @@ static void run_test(enum vm_guest_mode mode, void *u=
nused)
 	 * with that capability.
 	 */
 	if (dirty_log_manual_caps) {
-		ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
-		ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
-		ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepag=
es);
+		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
+		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
+		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hu=
gepages);
 	} else {
-		ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
-		ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
+		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
+		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
 	}
=20
 	/*
@@ -192,9 +192,9 @@ static void run_test(enum vm_guest_mode mode, void *unu=
sed)
 	 * memory again, the page counts should be the same as they were
 	 * right after initial population of memory.
 	 */
-	ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
-	ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
-	ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
+	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
+	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
+	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
 }
=20
 static void help(char *name)
diff --git a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_t=
est.c b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
index e334844d6e1d..6c2e5e0ceb1f 100644
--- a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
+++ b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
@@ -35,7 +35,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	handle_flds_emulation_failure_exit(vcpu);
 	vcpu_run(vcpu);
-	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
=20
 	kvm_vm_free(vm);
 	return 0;
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/=
tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
index 6502aa23c2f8..5f074a6da90c 100644
--- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -247,12 +247,12 @@ int main(int argc, char *argv[])
=20
 	/* Verify the pending events comes back out the same as it went in. */
 	vcpu_events_get(vcpu, &events);
-	ASSERT_EQ(events.flags & KVM_VCPUEVENT_VALID_PAYLOAD,
-		  KVM_VCPUEVENT_VALID_PAYLOAD);
-	ASSERT_EQ(events.exception.pending, true);
-	ASSERT_EQ(events.exception.nr, SS_VECTOR);
-	ASSERT_EQ(events.exception.has_error_code, true);
-	ASSERT_EQ(events.exception.error_code, SS_ERROR_CODE);
+	TEST_ASSERT_EQ(events.flags & KVM_VCPUEVENT_VALID_PAYLOAD,
+			KVM_VCPUEVENT_VALID_PAYLOAD);
+	TEST_ASSERT_EQ(events.exception.pending, true);
+	TEST_ASSERT_EQ(events.exception.nr, SS_VECTOR);
+	TEST_ASSERT_EQ(events.exception.has_error_code, true);
+	TEST_ASSERT_EQ(events.exception.error_code, SS_ERROR_CODE);
=20
 	/*
 	 * Run for real with the pending #SS, L1 should get a VM-Exit due to
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c b/to=
ols/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
index 4c416ebe7d66..cbc92a862ea9 100644
--- a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
+++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
@@ -57,7 +57,7 @@ int main(void)
 	for (i =3D 0; i < KVM_MAX_VCPUS; i++)
 		vcpu_set_msr(vcpus[i], MSR_IA32_APICBASE, LAPIC_X2APIC);
=20
-	ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);
+	TEST_ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);
=20
 	vcpuN =3D vcpus[KVM_MAX_VCPUS - 1];
 	for (t =3D time(NULL) + TIMEOUT; time(NULL) < t;) {
@@ -65,8 +65,8 @@ int main(void)
 		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_DISABLED);
 	}
=20
-	ASSERT_EQ(pthread_cancel(thread), 0);
-	ASSERT_EQ(pthread_join(thread, NULL), 0);
+	TEST_ASSERT_EQ(pthread_cancel(thread), 0);
+	TEST_ASSERT_EQ(pthread_join(thread, NULL), 0);
=20
 	kvm_vm_free(vm);
=20
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/tes=
ting/selftests/kvm/x86_64/tsc_msrs_test.c
index c9f67702f657..9265965bd2cd 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -103,39 +103,39 @@ int main(void)
 	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
=20
 	val =3D 0;
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
=20
 	/* Guest: writes to MSR_IA32_TSC affect both MSRs.  */
 	run_vcpu(vcpu, 1);
 	val =3D 1ull * GUEST_STEP;
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
=20
 	/* Guest: writes to MSR_IA32_TSC_ADJUST affect both MSRs.  */
 	run_vcpu(vcpu, 2);
 	val =3D 2ull * GUEST_STEP;
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
=20
 	/*
 	 * Host: writes to MSR_IA32_TSC set the host-side offset
 	 * and therefore do not change MSR_IA32_TSC_ADJUST.
 	 */
 	vcpu_set_msr(vcpu, MSR_IA32_TSC, HOST_ADJUST + val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
 	run_vcpu(vcpu, 3);
=20
 	/* Host: writes to MSR_IA32_TSC_ADJUST do not modify the TSC.  */
 	vcpu_set_msr(vcpu, MSR_IA32_TSC_ADJUST, UNITY * 123456);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_TSC_ADJUST), UNITY * 123456);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	TEST_ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_TSC_ADJUST), UNITY * 123456);
=20
 	/* Restore previous value.  */
 	vcpu_set_msr(vcpu, MSR_IA32_TSC_ADJUST, val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
=20
 	/*
 	 * Guest: writes to MSR_IA32_TSC_ADJUST do not destroy the
@@ -143,8 +143,8 @@ int main(void)
 	 */
 	run_vcpu(vcpu, 4);
 	val =3D 3ull * GUEST_STEP;
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
=20
 	/*
 	 * Guest: writes to MSR_IA32_TSC affect both MSRs, so the host-side
@@ -152,8 +152,8 @@ int main(void)
 	 */
 	run_vcpu(vcpu, 5);
 	val =3D 4ull * GUEST_STEP;
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
-	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val - HOST_ADJUST);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val - HOST_ADJUST=
);
=20
 	kvm_vm_free(vm);
=20
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_=
guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_inval=
id_guest_state.c
index be0bdb8c6f78..a9b827c69f32 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_s=
tate.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_s=
tate.c
@@ -50,7 +50,7 @@ static void set_timer(void)
 	timer.it_value.tv_sec  =3D 0;
 	timer.it_value.tv_usec =3D 200;
 	timer.it_interval =3D timer.it_value;
-	ASSERT_EQ(setitimer(ITIMER_REAL, &timer, NULL), 0);
+	TEST_ASSERT_EQ(setitimer(ITIMER_REAL, &timer, NULL), 0);
 }
=20
 static void set_or_clear_invalid_guest_state(struct kvm_vcpu *vcpu, bool s=
et)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools=
/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 4c90f76930f9..34efd57c2b32 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -103,7 +103,8 @@ static void test_guest_wrmsr_perf_capabilities(union pe=
rf_capabilities host_cap)
 		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 	}
=20
-	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabi=
lities);
+	TEST_ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES),
+			host_cap.capabilities);
=20
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
=20
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/=
testing/selftests/kvm/x86_64/xapic_state_test.c
index 396c13f42457..ab75b873a4ad 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -65,17 +65,17 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t=
 val)
 	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &xapic);
=20
 	vcpu_run(vcpu);
-	ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
-	ASSERT_EQ(uc.args[1], val);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], val);
=20
 	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
 	icr =3D (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
 	if (!x->is_x2apic) {
 		val &=3D (-1u | (0xffull << (32 + 24)));
-		ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
+		TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 	} else {
-		ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
+		TEST_ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
 	}
 }
=20
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/t=
esting/selftests/kvm/x86_64/xen_vmcall_test.c
index c94cde3b523f..e149d0574961 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -108,16 +108,16 @@ int main(int argc, char *argv[])
 		vcpu_run(vcpu);
=20
 		if (run->exit_reason =3D=3D KVM_EXIT_XEN) {
-			ASSERT_EQ(run->xen.type, KVM_EXIT_XEN_HCALL);
-			ASSERT_EQ(run->xen.u.hcall.cpl, 0);
-			ASSERT_EQ(run->xen.u.hcall.longmode, 1);
-			ASSERT_EQ(run->xen.u.hcall.input, INPUTVALUE);
-			ASSERT_EQ(run->xen.u.hcall.params[0], ARGVALUE(1));
-			ASSERT_EQ(run->xen.u.hcall.params[1], ARGVALUE(2));
-			ASSERT_EQ(run->xen.u.hcall.params[2], ARGVALUE(3));
-			ASSERT_EQ(run->xen.u.hcall.params[3], ARGVALUE(4));
-			ASSERT_EQ(run->xen.u.hcall.params[4], ARGVALUE(5));
-			ASSERT_EQ(run->xen.u.hcall.params[5], ARGVALUE(6));
+			TEST_ASSERT_EQ(run->xen.type, KVM_EXIT_XEN_HCALL);
+			TEST_ASSERT_EQ(run->xen.u.hcall.cpl, 0);
+			TEST_ASSERT_EQ(run->xen.u.hcall.longmode, 1);
+			TEST_ASSERT_EQ(run->xen.u.hcall.input, INPUTVALUE);
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[0], ARGVALUE(1));
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[1], ARGVALUE(2));
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[2], ARGVALUE(3));
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[3], ARGVALUE(4));
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[4], ARGVALUE(5));
+			TEST_ASSERT_EQ(run->xen.u.hcall.params[5], ARGVALUE(6));
 			run->xen.u.hcall.result =3D RETVALUE;
 			continue;
 		}
--=20
2.41.0.487.g6d72f3e995-goog

