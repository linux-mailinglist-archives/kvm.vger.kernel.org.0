Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEBB6166C8
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiKBQAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKBQAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:00:17 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24062197
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:00:16 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id w16-20020a6b4a10000000b006a5454c789eso14663280iob.20
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBK3THjfM00hK0Ybjyd8D/mGedv8JDwjrzgy5dwB9z4=;
        b=dbyGbrfAsVPTI9iGgH/v3lJgbF6lyQwv4R3CSgTCRB+aVUaCEPcg1nD3Xie/rvlR7d
         HTPTCdAAr/y8MugQRXbBLNrJATNub17S/vMyO9ma6rYzCHsoPcWF5Wa8BJiLdrN4msYr
         4JzCXH/wlt27vs0sceY2lKc5052Q2IiPCmUHrhOxaX3AO7LkL/LpnrPmM+3SqoA6HDNe
         QS4kk89UswRVhODhg7ZiROMMSCiRkFx71w82IHmfVe/1A+yYR/kKAe/Lgj+tM2vAfATR
         1R0z9YVqhmFQ8B4A8z28r3fisXiFU6awVpKqTrjzdTXDiiU/m4XXY3p1HzRFcYKaebai
         N7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBK3THjfM00hK0Ybjyd8D/mGedv8JDwjrzgy5dwB9z4=;
        b=CEvJ0i1MGlQD5Sdu+xI+qGODfimTcaB3WIJjIw+8m12dDIRpsoYEs+G6I/fVVmoXjB
         f0c/2ad9TEYuORfIvWYUxC8g06++/sJIFTF8ObdHGexYmmmFt/Y2Z5KJMQzmphClB7qf
         XPPnFv5Oq6TFVA3jtkFvRVwYWG9e37YnSLYuhr+8+gP7e0bJaFfh3t0Ccl9BcZY5F6FF
         I+5iboJEIgSuBJ1CI6bzDPfwOEkWAjP83VjMpZMKBkUTavt9s03eQ5GSx9ogUr/2VWOz
         w7k2ZKa/ehBfcoUO/uzYwovWfitOIj1s2QANrf6ihb4VxktsCOcEOQ+foczA5rgcDN1d
         XwQg==
X-Gm-Message-State: ACrzQf0++hhweyzn7zV09AhsR0aGOIa8HE4C1IDWuJCwkojFri0TSuAC
        qgItYzfTFWYnsCEvMzVrcAWNRgIfZ3FTQgSgN7HUjGobzEdWVRqpUzLcPl0n4/w14R148W/mVv2
        dPq31dE3ZP+r1edBW3zQmdasA7w6udaXd1s+24c17p/SlTWJBTpRzdTLlphZ9giHq+el7K14=
X-Google-Smtp-Source: AMsMyM4zfXEA1KKsNsALv/tZdGC6baN3Yw4J0cpPH6OSvdBdq2Zks9Erp+jcvZ4twbrjdx9FjGOh3cMTbEn/0Ny3MA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:cf8f:0:b0:373:9526:ff08 with SMTP
 id w15-20020a02cf8f000000b003739526ff08mr17431866jar.298.1667404816007; Wed,
 02 Nov 2022 09:00:16 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:00:05 +0000
In-Reply-To: <20221102160007.1279193-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221102160007.1279193-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102160007.1279193-3-coltonlewis@google.com>
Subject: [PATCH v9 2/4] KVM: selftests: create -r argument to specify random seed
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
 tools/testing/selftests/kvm/lib/perf_test_util.c     |  6 ++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

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
index 9618b37c66f7..0bb0659b9a0d 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -229,6 +229,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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

