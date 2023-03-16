Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE16BC2B3
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjCPAck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjCPAcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:32:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970C5A4B3A
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 20-20020a630514000000b0050bed8b0b61so13549pgf.11
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678926685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=36lklAKITNKcvpGi9bBaV0pg92rnpur43Kuea+YFpfM=;
        b=swpVj1SmNmgvWlTTZKcMha4lkIplKfRmILDkyWfcGRLXWLuIlK2d6RzDWw2bYkkCHP
         soiW4nXc7/hBbAleU8BqoI0AbG96N9laDULGWA+oYmBxb9+GZWi0B0T26gJnbwIFOCwo
         5kpRG9JizdS1Y6EbQlta+wo8Fhd+ryKKJGTqSzbsLYaWB10pCI4jhMlJ9DGRJ4DSAtGk
         3aahsJCHmb9Uk47t1vgWw/SYjxk2SvIyeXgaVgaNp1TPH4oC+vl3KgGYbWyD1TlOcBi1
         gvD1hR4NtBHZOvW4SAlG3B1IpFX0JT8Zq0hcF2742mhE+c1PzdSmxBYs2Pwk5wn4zjuL
         RaVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36lklAKITNKcvpGi9bBaV0pg92rnpur43Kuea+YFpfM=;
        b=EwNKk8oB5CmvqFYNqs9YKGCG4CvErK/m8H+628sbFW+RuzySLvOA0zE5XC4md/tRuL
         vWUEjr1IYpySSRNGVQg8HzXFrQoWD/T2knLoEDER60Mt11bWgVO+PDao5YaT3BAfuGrK
         KvFDy0mi4/n8ZgSz2rqTHhDp46H7lAJaI3W8MQEuG3si/a15BFSx0ye+pOtd8QOY2/1t
         B4LxJOKIIb6EGuAFNKhB8TfeKD6BIR9f53pyDMJmKMIIPuo+w4hCb+Gc0MAnsw0F+iNP
         ZMS1NBoxjXDK61SPi00dPwjFwyjJVBdzLs1ytRhoMgRyv8DQY3Yk6jCAypkCBCOlY2QS
         Wq0Q==
X-Gm-Message-State: AO0yUKXJ2FpSuIbr3ZyYG9OTlCFS+rDVk2aeiigmorjwDThJOnL//S+A
        3oHkBSd2Zl7PFQfDi9KFM6xC1FHDZILPXd4dpXjq4/4FSiZU054D4vhbX6Ekgs/NMPhOFsyNujw
        j2bnsaUWGZCPWaDv3h/vp2LrGOQpL5RtgrfXS84dEm+X2FAfpA+CIEwsct+BKMtcCY9Gip60=
X-Google-Smtp-Source: AK7set9HhZ92PQ2OitTC4KZtYEJK0EXqsjjwLnoPjbnEyW7GD+pO7NNEnen5rh0nKaexCpnSy3z8RFk0Cysc1DaScg==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:d50d:b0:1a0:5402:b17f with
 SMTP id b13-20020a170902d50d00b001a05402b17fmr634600plg.6.1678926685342; Wed,
 15 Mar 2023 17:31:25 -0700 (PDT)
Date:   Thu, 16 Mar 2023 00:30:59 +0000
In-Reply-To: <cover.1678926164.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1678926164.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <c554a93f38f5a79627a341309ffa974531d35697.1678926164.git.ackerleytng@google.com>
Subject: [RFC PATCH 06/10] KVM: selftests: Default private_mem_conversions_test
 to use 1 memslot for test data
From:   Ackerley Tng <ackerleytng@google.com>
To:     kvm@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, qemu-devel@nongnu.org
Cc:     aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org,
        arnd@arndb.de, bfields@fieldses.org, bp@alien8.de,
        chao.p.peng@linux.intel.com, corbet@lwn.net, dave.hansen@intel.com,
        david@redhat.com, ddutile@redhat.com, dhildenb@redhat.com,
        hpa@zytor.com, hughd@google.com, jlayton@kernel.org,
        jmattson@google.com, joro@8bytes.org, jun.nakajima@intel.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        luto@kernel.org, mail@maciej.szmigiero.name, mhocko@suse.com,
        michael.roth@amd.com, mingo@redhat.com, naoya.horiguchi@nec.com,
        pbonzini@redhat.com, qperret@google.com, rppt@kernel.org,
        seanjc@google.com, shuah@kernel.org, steven.price@arm.com,
        tabba@google.com, tglx@linutronix.de, vannapurve@google.com,
        vbabka@suse.cz, vkuznets@redhat.com, wanpengli@tencent.com,
        wei.w.wang@intel.com, x86@kernel.org, yu.c.zhang@linux.intel.com,
        Ackerley Tng <ackerleytng@google.com>
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

Default the private/shared memory conversion tests to use a single
memslot, while executing on multiple vCPUs in parallel, to stress-test
the restrictedmem subsystem.

Also add a flag to allow multiple memslots to be used.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 14aa90e9a89b..afaf8d0e52e6 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -335,7 +335,8 @@ static void add_memslot_for_vcpu(
 }
 
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type,
-				 uint8_t nr_vcpus, uint32_t iterations)
+				 uint8_t nr_vcpus, uint32_t iterations,
+				 bool use_multiple_memslots)
 {
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
@@ -355,6 +356,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type,
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
 	npages_for_all_vcpus = DATA_SIZE / vm->page_size * nr_vcpus;
+
+	if (use_multiple_memslots) {
+		for (i = 0; i < nr_vcpus; i++)
+			add_memslot_for_vcpu(vm, src_type, i);
+	} else {
+		vm_userspace_mem_region_add(
+			vm, src_type, DATA_GPA_BASE, DATA_SLOT_BASE,
+			npages_for_all_vcpus, KVM_MEM_PRIVATE);
+	}
+
 	virt_map(vm, DATA_GPA_BASE, DATA_GPA_BASE, npages_for_all_vcpus);
 
 	for (i = 0; i < nr_vcpus; i++)
@@ -371,13 +382,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type,
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(threads[i], NULL);
 
-	test_invalidation_code_unbound(vm, nr_vcpus, DATA_SIZE);
+	if (!use_multiple_memslots)
+		test_invalidation_code_unbound(vm, 1, DATA_SIZE * nr_vcpus);
+	else
+		test_invalidation_code_unbound(vm, nr_vcpus, DATA_SIZE);
 }
 
 static void usage(const char *command)
 {
 	puts("");
-	printf("usage: %s [-h] [-s mem-type] [-n number-of-vcpus] [-i number-of-iterations]\n",
+	printf("usage: %s [-h] [-m] [-s mem-type] [-n number-of-vcpus] [-i number-of-iterations]\n",
 	       command);
 	puts("");
 	backing_src_help("-s");
@@ -388,6 +402,8 @@ static void usage(const char *command)
 	puts(" -i: specify the number iterations of memory conversion");
 	puts("     tests to run. (default: 10)");
 	puts("");
+	puts(" -m: use multiple memslots (default: use 1 memslot)");
+	puts("");
 }
 
 int main(int argc, char *argv[])
@@ -395,12 +411,13 @@ int main(int argc, char *argv[])
 	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
 	uint8_t nr_vcpus = 2;
 	uint32_t iterations = 10;
+	bool use_multiple_memslots = false;
 	int opt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_EXIT_HYPERCALL));
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_PROTECTED_VM));
 
-	while ((opt = getopt(argc, argv, "hs:n:i:")) != -1) {
+	while ((opt = getopt(argc, argv, "mhs:n:i:")) != -1) {
 		switch (opt) {
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
@@ -411,6 +428,9 @@ int main(int argc, char *argv[])
 		case 's':
 			src_type = parse_backing_src_type(optarg);
 			break;
+		case 'm':
+			use_multiple_memslots = true;
+			break;
 		case 'h':
 		default:
 			usage(argv[0]);
@@ -418,6 +438,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	test_mem_conversions(src_type, nr_vcpus, iterations);
+	test_mem_conversions(src_type, nr_vcpus, iterations, use_multiple_memslots);
 	return 0;
 }
-- 
2.40.0.rc2.332.ga46443480c-goog

