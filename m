Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27986103EF
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiJ0VEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 17:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbiJ0VDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 17:03:18 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E309526A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:02 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id f17-20020a5d8591000000b006bcbe59b6cdso2169825ioj.14
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5eYIYEMsC/jQPMR/QSjFg9rOVcWw1Z3eVOiEG1XRd4=;
        b=lLRwcXfjkh7yXiP6Y58F8BImI6OGP5mXUbMJb5khTI8lEHAyaYqCpAsBLJpEz60shT
         Wp8N2R1I1oohCHEcOgymiZP1rsEPbFhnVnijZAL9kogBqCx6765aQ+cCb/mw3MNyc8lt
         +TdWJOoCD00LQxs6h+TUGEFlKuP5KVOi7/kjdaZdSbxwri6EKpuJy1N+IJwAZVO/5KW9
         WvN9Bx7NmFFVpfucFigmQz/QtAscBNz92iY278s5uX0gnJGpgQrEn6/DGdkyL/ToEz6e
         X2HxWsFGjEjaXqotn9ZseyEI82bXD3FnpqT3PCkASJPNImJQo+SdwiUNsfbd25/EL2JI
         VxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5eYIYEMsC/jQPMR/QSjFg9rOVcWw1Z3eVOiEG1XRd4=;
        b=yJK4WiXXOX1TAaNfvUF1i5wuJzCcgfEPQzvcmP2TYtQPxMYf7C9zOCzh06yAXRl6PZ
         Y7JkbURlj6LdfX9ge7ZWqzXRbyRRL7Ar0fcwP43u9cpfZ2t4wLAuXY4AMDlBnd3fqtoR
         h+nVv7MuYHX0tsKhgwOqSUlsFG4IYYs0/ygiOQNDa7vNpv2vkPtLxC6VMUnkCjcnskUf
         8w8ztMZFHOO5ooN0mG0OkU3WebpBmzrq3/wcdaiqujwoSUEvOLY9be3LIODUd+eYEAGf
         04BPEjA9Wh9jILJwzo/w4TbhHfW85QKpVZnYdAQa2+6B1R9VA1UrqhILdjPU5xKfR5M9
         qFJA==
X-Gm-Message-State: ACrzQf0Ms3bfEx+hhEjOiB3vggl4vtbtnx9rf+5tL1RJduyYGGvQT/qN
        +j15wQBBj5ppAgB04HWKv7x3tPgMX60pwEoXjUgCvYeNBVolTJZlqZRzAdHkr/U0j9BOniZvLlu
        iFnmZvFwB15Df+nY4rMO04qKSLMBNNQhoOEynPxwaQLkUTkO4upfQjN42nV11ZoijfgANT4w=
X-Google-Smtp-Source: AMsMyM5T6g3PUPcqcjM6ve0GwOnFYjSs1JncksyIDjjT/VecMGmGRkr98UdaWDRywaHSxDPEBOqGC2+R5zckraysGA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:c24f:0:b0:300:1003:d7ab with SMTP
 id k15-20020a92c24f000000b003001003d7abmr12108172ilo.10.1666904222279; Thu,
 27 Oct 2022 13:57:02 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:56:29 +0000
In-Reply-To: <20221027205631.340339-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221027205631.340339-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027205631.340339-3-coltonlewis@google.com>
Subject: [PATCH v8 2/4] KVM: selftests: create -r argument to specify random seed
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a -r argument to specify a random seed. If no argument is
provided, the seed defaults to 1. The random seed is set with
perf_test_set_random_seed() and must be set before guest_code runs to
apply.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
 tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c     |  7 +++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..c97a5e455699 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t random_seed;
 };
 
 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
@@ -225,6 +226,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+	/* If no argument provided, random seed will be 1. */
+	pr_info("Random seed: %u\n", p->random_seed);
+	perf_test_set_random_seed(vm, p->random_seed ? p->random_seed : 1);
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
@@ -352,7 +356,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -380,6 +384,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
+	printf(" -r: specify the starting random seed.\n");
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
@@ -406,7 +411,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
 		case 'e':
 			/* 'e' is for evil. */
@@ -442,6 +447,9 @@ int main(int argc, char *argv[])
 		case 'o':
 			p.partition_vcpu_memory_access = false;
 			break;
+		case 'r':
+			p.random_seed = atoi(optarg);
+			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..f1050fd42d10 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -35,6 +35,7 @@ struct perf_test_args {
 	uint64_t gpa;
 	uint64_t size;
 	uint64_t guest_page_size;
+	uint32_t random_seed;
 	int wr_fract;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
@@ -52,6 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..5f0eebb626b5 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -49,6 +49,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	uint64_t gva;
 	uint64_t pages;
 	int i;
+	struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -229,6 +230,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
+{
+	perf_test_args.random_seed = random_seed;
+	sync_global_to_guest(vm, perf_test_args.random_seed);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
-- 
2.38.1.273.g43a17bfeac-goog

