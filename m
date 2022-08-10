Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B43858F209
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiHJR7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiHJR70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:59:26 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08857435E
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:20 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id s3-20020a056e021a0300b002e10f0e8965so6145983ild.23
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=8YxIK1vO/kVXwILnIyHigQIhxhgLW6OGRDtVKQjE7JM=;
        b=UC082f0wHKovpE2PqGNkoLp+nLJC8K2fFdudOOGz58g1ZA8b3olf/vC61Bhe513nhc
         ErmZEy22ArrMeRKrsh6JOatHWtSh++B7zLsrTP6FRo36LRP6xCL0Ee+nFkOXTYXYeNKg
         k9VP7ing3TRDBDuHRfhaMjZ02UYJpdHXJeGCNDmlGQHCI6ey0LqILFSztlZulxDFuWoP
         Ky1OnSYJ4c1OO3K3xceGKijf2L2fxUM8kpfo7cvRpwnCukpLkFo+IavB+c6kbzRWdigF
         Tw8ZICNZP5UqaAPmVpwaMWvqpZNeSq3RS507li4/NBb512VSvLNAHm7plGVQ5+/6vQ37
         NVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=8YxIK1vO/kVXwILnIyHigQIhxhgLW6OGRDtVKQjE7JM=;
        b=hKpoCEjLbC0j19a3qlMA3oVuWwwgnysLNFJPEjftEcpPls93v9BxXZnwKqCXodLPFW
         RP9Qt33J4/O7IBSb3LViakJ1vTshUbFh3OivZsN6PyA5iqB//cJ04vAj3klntypmW1Xs
         ny2DX7N0tHjxHJLjCVk52JuQ3MdmX5mvB5YHOHF+HlARJUlOpWdVnKrsXieb2rhogF8i
         y3x2KnpwmQ1xKJaCrYf1/kRtZe3oyLkiokrbqpMVpNCSS2ZjEGbiH9HneZeAm9YdmTnS
         HfGndUm0zQOC5y8pXYcmOBkPN11FDW+Qh3Ouv5b2Vpxh+Eny5Iyx/1PSeHdqjzYBQJS2
         sK3A==
X-Gm-Message-State: ACgBeo2S/7H6du0dfwXEO1XP/ynpFWWVeuWdrK7+PPRvrKwrpYzTleKb
        M1mxm7FaCGNoJilNQGlE4uRLqlNfi7Gx37f21gEs5iwG3WpXfK/e4oxz92yxSIyd121VgZYhQXF
        rjwpN5jTaqd/HR1YRzKyCdatwk2hoFhEeCfybksqoOC+Yljj9hR4LKI6f5SEL8nVtbhuRTlc=
X-Google-Smtp-Source: AA6agR5fFvi1FFC5xNy6E9BQCHq8iMFojKgjZGksQGanQ9sH/HRl/Aty79xb64Y2Wj++aOS0bRpT5WLbEEOICZa4kg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1c8a:b0:2de:dd01:e091 with
 SMTP id w10-20020a056e021c8a00b002dedd01e091mr13350069ill.233.1660154359835;
 Wed, 10 Aug 2022 10:59:19 -0700 (PDT)
Date:   Wed, 10 Aug 2022 17:58:29 +0000
In-Reply-To: <20220810175830.2175089-1-coltonlewis@google.com>
Message-Id: <20220810175830.2175089-3-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220810175830.2175089-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH 2/3] KVM: selftests: Randomize which pages are written vs read
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Randomize which pages are written vs read by using the random number
table for each page modulo 100. This changes how the -w argument
works. It is now a percentage from 0 to 100 inclusive that represents
what percentage of accesses are writes. It keeps the same default of
100 percent writes.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 12 +++++++-----
 tools/testing/selftests/kvm/lib/perf_test_util.c  |  4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 80a1cbe7fbb0..dcc5d44fc757 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -381,8 +381,8 @@ static void help(char *name)
 	       "     (default: 1G)\n");
 	printf(" -f: specify the fraction of pages which should be written to\n"
 	       "     as opposed to simply read, in the form\n"
-	       "     1/<fraction of pages to write>.\n"
-	       "     (default: 1 i.e. all pages are written to.)\n");
+	       "     [0-100]%% of pages to write.\n"
+	       "     (default: 100 i.e. all pages are written to.)\n");
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
@@ -399,7 +399,7 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
-		.wr_fract = 1,
+		.wr_fract = 100,
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
@@ -439,8 +439,10 @@ int main(int argc, char *argv[])
 			break;
 		case 'f':
 			p.wr_fract = atoi(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+			TEST_ASSERT(p.wr_fract >= 0,
+				    "Write fraction cannot be less than 0");
+			TEST_ASSERT(p.wr_fract <= 100,
+				    "Write fraction cannot be greater than 100");
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b04e8d2c0f37..3c7b93349fef 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -64,7 +64,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 		for (i = 0; i < pages; i++) {
 			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
+			if (random_table[vcpu_idx][i] % 100 < pta->wr_fract)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -168,7 +168,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	pta->wr_fract = 100;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
-- 
2.37.1.559.g78731f0fdb-goog

