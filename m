Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B4640CEDC
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhIOVcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhIOVcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:32:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A00C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u13-20020a17090a4bcd00b00198e965f8f4so5071533pjl.8
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xE1wWNgSxANJ47KmLcYyykwPZY/TSwAMFYT90WI0sL8=;
        b=Zgw22gepYbLSMmm0NGMFYtKmolyeEItbNzpbhyujWJz3IjL8IRABeLdbIgSzS57xi1
         kMlP12SpXbXNf7nzqxXOcr4BkRMfvVl7Dr2SPjn5eXNKCcWDDUprzf8RUf7jShv4fX7F
         4NsBrsLcUEK9F0B6UNWXf+D78GLimT/NWTD4OU/z7gIa/gPG+0MJFa1fU6W4nqS+RpCu
         IRSkmtA0OJcF9Q1Gpa4XGGDsZGwflY6fHAQgFZ6fiIBxCJB78a1CDmfnomiCmmyLld2N
         SXPfYCXiGiuzhR8n1NxSOcoQbW5bCBpO/ZLeo4e6VhidU4fgvTTcv9Uf7Os5u86MoTla
         qZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xE1wWNgSxANJ47KmLcYyykwPZY/TSwAMFYT90WI0sL8=;
        b=057jRKRxsUVe2JEVbJr+W8GPXwlifUNJmLA+FWVPO+P8C0NI7ZovsgSR6FuqLreUPm
         9XiUOSqBBtYs4OuNeYaR8y0RgoPZ/0CI5hB7posuiA+jalm5ki7zO+kQcMwNcsHbpX+O
         B6iGx9yM5o4nSOcsIrB28DSk/s+QIt27ptjvuV9smpGx1M5YqyY5ICj5v0hZKUb0PCRm
         8CjopsRlpf4rp3iZFF2ocHpIrD5tEPBXExzdy5nbcOe6prLb0+AEqkrTQe6aZbtOWfaZ
         DG67dURzwX+pQy0+6Dnt3rvuVhQ4sRo+IjI2l8XVjI8l57g74E57PTP9kSaukIEUwpw6
         44Zg==
X-Gm-Message-State: AOAM530GVl9CNtXDx6o+kF3tcyae4WQ3R3ovNgCoRXL+13FFTuKokAdJ
        lUCkYpYs3TWINSMd7+/TKpy1E3vktluOKA==
X-Google-Smtp-Source: ABdhPJwfaXckmxGpGSMBytgTkPOOEHKpB4eIgJxRLk7Bylmqwws8jADBsxH67kWbn+woovFdfNkwauByM1Yy6A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1150:b0:40a:78df:8179 with SMTP
 id b16-20020a056a00115000b0040a78df8179mr1922998pfm.67.1631741442000; Wed, 15
 Sep 2021 14:30:42 -0700 (PDT)
Date:   Wed, 15 Sep 2021 21:30:33 +0000
In-Reply-To: <20210915213034.1613552-1-dmatlack@google.com>
Message-Id: <20210915213034.1613552-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 2/3] KVM: selftests: Refactor help message for -s backing_src
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All selftests that support the backing_src option were printing their
own description of the flag and then calling backing_src_help() to dump
the list of available backing sources. Consolidate the flag printing in
backing_src_help() to align indentation, reduce duplicated strings, and
improve consistency across tests.

Note: Passing "-s" to backing_src_help is unnecessary since every test
uses the same flag. However I decided to keep it for code readability
at the call sites.

While here this opportunistically fixes the incorrectly interleaved
printing -x help message and list of backing source types in
dirty_log_perf_test.

Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c   |  6 ++----
 .../testing/selftests/kvm/demand_paging_test.c  |  5 ++---
 .../testing/selftests/kvm/dirty_log_perf_test.c |  8 +++-----
 tools/testing/selftests/kvm/include/test_util.h |  5 ++++-
 .../testing/selftests/kvm/kvm_page_table_test.c |  7 ++-----
 tools/testing/selftests/kvm/lib/test_util.c     | 17 +++++++++++++----
 6 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 71e277c7c3f3..5d95113c7b7c 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -371,9 +371,7 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
-	printf(" -s: specify the type of memory that should be used to\n"
-	       "     back the guest data region.\n\n");
-	backing_src_help();
+	backing_src_help("-s");
 	puts("");
 	exit(0);
 }
@@ -381,7 +379,7 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	struct test_params params = {
-		.backing_src = VM_MEM_SRC_ANONYMOUS,
+		.backing_src = DEFAULT_VM_MEM_SRC,
 		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
 		.vcpus = 1,
 	};
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 735c081e774e..96cd3e0357f6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -426,8 +426,7 @@ static void help(char *name)
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
-	printf(" -s: The type of backing memory to use. Default: anonymous\n");
-	backing_src_help();
+	backing_src_help("-s");
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
@@ -439,7 +438,7 @@ int main(int argc, char *argv[])
 {
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
-		.src_type = VM_MEM_SRC_ANONYMOUS,
+		.src_type = DEFAULT_VM_MEM_SRC,
 		.partition_vcpu_memory_access = true,
 	};
 	int opt;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 3c30d0045d8d..5ad9f2bc7369 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -308,11 +308,9 @@ static void help(char *name)
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
-	printf(" -s: specify the type of memory that should be used to\n"
-	       "     back the guest data region.\n\n");
+	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
-	       "     (default: 1)");
-	backing_src_help();
+	       "     (default: 1)\n");
 	puts("");
 	exit(0);
 }
@@ -324,7 +322,7 @@ int main(int argc, char *argv[])
 		.iterations = TEST_HOST_LOOP_N,
 		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
-		.backing_src = VM_MEM_SRC_ANONYMOUS,
+		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
 	};
 	int opt;
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d79be15dd3d2..2f09f2994733 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -68,6 +68,7 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_elapsed(struct timespec start);
 struct timespec timespec_div(struct timespec ts, int divisor);
 
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
@@ -90,6 +91,8 @@ enum vm_mem_backing_src_type {
 	NUM_SRC_TYPES,
 };
 
+#define DEFAULT_VM_MEM_SRC VM_MEM_SRC_ANONYMOUS
+
 struct vm_mem_backing_src_alias {
 	const char *name;
 	uint32_t flag;
@@ -100,7 +103,7 @@ size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
 const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
 size_t get_backing_src_pagesz(uint32_t i);
-void backing_src_help(void);
+void backing_src_help(const char *flag);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
 
 /*
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 0d04a7db7f24..36407cb0ec85 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -456,10 +456,7 @@ static void help(char *name)
 	       "     (default: 1G)\n");
 	printf(" -v: specify the number of vCPUs to run\n"
 	       "     (default: 1)\n");
-	printf(" -s: specify the type of memory that should be used to\n"
-	       "     back the guest data region.\n"
-	       "     (default: anonymous)\n\n");
-	backing_src_help();
+	backing_src_help("-s");
 	puts("");
 }
 
@@ -468,7 +465,7 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.test_mem_size = DEFAULT_TEST_MEM_SIZE,
-		.src_type = VM_MEM_SRC_ANONYMOUS,
+		.src_type = DEFAULT_VM_MEM_SRC,
 	};
 	int opt;
 
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index af1031fed97f..ea23a86132ed 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -279,13 +279,22 @@ size_t get_backing_src_pagesz(uint32_t i)
 	}
 }
 
-void backing_src_help(void)
+void print_available_backing_src_types(const char *prefix)
 {
 	int i;
 
-	printf("Available backing src types:\n");
+	printf("%sAvailable backing src types:\n", prefix);
+
 	for (i = 0; i < NUM_SRC_TYPES; i++)
-		printf("\t%s\n", vm_mem_backing_src_alias(i)->name);
+		printf("%s    %s\n", prefix, vm_mem_backing_src_alias(i)->name);
+}
+
+void backing_src_help(const char *flag)
+{
+	printf(" %s: specify the type of memory that should be used to\n"
+	       "     back the guest data region. (default: %s)\n",
+	       flag, vm_mem_backing_src_alias(DEFAULT_VM_MEM_SRC)->name);
+	print_available_backing_src_types("     ");
 }
 
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
@@ -296,7 +305,7 @@ enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
 		if (!strcmp(type_name, vm_mem_backing_src_alias(i)->name))
 			return i;
 
-	backing_src_help();
+	print_available_backing_src_types("");
 	TEST_FAIL("Unknown backing src type: %s", type_name);
 	return -1;
 }
-- 
2.33.0.309.g3052b89438-goog

