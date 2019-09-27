Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D20C096A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfI0QSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:18:47 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51830 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfI0QSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:18:47 -0400
Received: by mail-pg1-f201.google.com with SMTP id o32so3855521pgm.18
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z1+6YnORORJpDPx0AFYn1dOo56cI4E/TWHsOcAHEr2k=;
        b=Zs3Zy66/fdR+77P3vb+NTQbTKVD1qPyOQpKRHebdpq9Z3GeBZThrfZC4N7Y+yF0Pox
         3rajRELdEoIX5lt6E2eO1iS4GHPmvR/Q+vQUXy9gZxtanwxiVjpb+lIimnwvae14U/uU
         0ridh0WqTAliLNwLv5RGqALKbzt3fwqz6/hA63lejNPuvDaWxGsjrBrtO3EYzMaDyWfj
         Qy6qt8DDgBkkjcCksWpIyF80AWUsuBeolM+8is+1buqmlA+N0ml+DgWk72VtvUM/4xJX
         bs+Cqg0rEX6fRuVKK0Ai/zbMgwpOLM6fg++CytIq1lz5g+AtKslt5UM/YBR0GHnTUAa5
         HZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z1+6YnORORJpDPx0AFYn1dOo56cI4E/TWHsOcAHEr2k=;
        b=c7hrzRc1aCLdw94yQzQ+KRAFRwUoWoyL2nSPnTVPxVAxaMrs89u0SxkPVr/MO19VTe
         yCvBj3ddZc6EofgFFAbiQMS+RShRVHA45NFQVzdlUxi3i82OsVtD7WhSL+Y6sp531sWh
         5huPX3G5iDItvKrg489/9mK3+HNtavz7G6kNby3FCFLoAPAqhJJXlvQkUd41jZbol/s6
         e6efWjU4oJRZQCijfJbf/PtgxobsDT8k9plA4jRQNdpKe7OvFGZdKOc2ijwtaToWDJX5
         ndcF893o30tIhYVNENRnUP1VPtb7LCMnqxwukMn3NaETkOxQBGB0O8y79xjY5eAXXR1V
         i3UQ==
X-Gm-Message-State: APjAAAVkjIse+JvRFcuY4f/cZJGqaDzrgddJ5Zh3Fv9zoNVwm6sJizFs
        1kCV6A7Y5FzdbGNSmVUP5mO/lO/DrOtajs/G20MowGuzjbOPFt6nsNm78q6Kp1mjEbI79UrszVQ
        GqqAMo/rFj/jgqRPAM7YPSRdu7Bn93J+oGx/YHu0f2A0Zn/fyoxVeiNx8WKPf
X-Google-Smtp-Source: APXvYqyFAximtgaKY3v89h1XKCJQ7ZZYPYzW9ka3x3G3HMJM7o0TUI3U8IinsO+VCYmtgqFWAwQSvN9sUR7L
X-Received: by 2002:a63:c645:: with SMTP id x5mr10199467pgg.425.1569601126534;
 Fri, 27 Sep 2019 09:18:46 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:18:31 -0700
In-Reply-To: <20190927161836.57978-1-bgardon@google.com>
Message-Id: <20190927161836.57978-4-bgardon@google.com>
Mime-Version: 1.0
References: <20190927161836.57978-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH 3/9] KVM: selftests: Add memory size parameter to the demand
 paging test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument to allow the demand paging test to work on larger and
smaller guest sizes.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 55 ++++++++++++-------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 61ba4e6a8214a..19982a33a0ca2 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -32,6 +32,8 @@
 /* Default guest test virtual memory offset */
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
 
+#define DEFAULT_GUEST_TEST_MEM_SIZE (1 << 30) /* 1G */
+
 #define __NR_userfaultfd 323
 
 /*
@@ -255,10 +257,9 @@ static int setup_demand_paging(struct kvm_vm *vm,
 	return 0;
 }
 
-#define GUEST_MEM_SHIFT 30 /* 1G */
 #define PAGE_SHIFT_4K  12
 
-static void run_test(enum vm_guest_mode mode)
+static void run_test(enum vm_guest_mode mode, uint64_t guest_memory_bytes)
 {
 	pthread_t vcpu_thread;
 	pthread_t uffd_handler_thread;
@@ -266,33 +267,40 @@ static void run_test(enum vm_guest_mode mode)
 	int r;
 
 	/*
-	 * We reserve page table for 2 times of extra dirty mem which
-	 * will definitely cover the original (1G+) test range.  Here
-	 * we do the calculation with 4K page size which is the
-	 * smallest so the page number will be enough for all archs
-	 * (e.g., 64K page size guest will need even less memory for
-	 * page tables).
+	 * We reserve page table for twice the ammount of memory we intend
+	 * to use in the test region for demand paging. Here we do the
+	 * calculation with 4K page size which is the smallest so the page
+	 * number will be enough for all archs. (e.g., 64K page size guest
+	 * will need even less memory for page tables).
 	 */
 	vm = create_vm(mode, VCPU_ID,
-		       2ul << (GUEST_MEM_SHIFT - PAGE_SHIFT_4K),
+		       (2 * guest_memory_bytes) >> PAGE_SHIFT_4K,
 		       guest_code);
 
 	guest_page_size = vm_get_page_size(vm);
-	/*
-	 * A little more than 1G of guest page sized pages.  Cover the
-	 * case where the size is not aligned to 64 pages.
-	 */
-	guest_num_pages = (1ul << (GUEST_MEM_SHIFT -
-				   vm_get_page_shift(vm))) + 16;
+
+	TEST_ASSERT(guest_memory_bytes % guest_page_size == 0,
+		    "Guest memory size is not guest page size aligned.");
+
+	guest_num_pages = guest_memory_bytes / guest_page_size;
+
 #ifdef __s390x__
 	/* Round up to multiple of 1M (segment size) */
 	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
 #endif
+	/*
+	 * If there should be more memory in the guest test region than there
+	 * can be pages in the guest, it will definitely cause problems.
+	 */
+	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
+		    "Requested more guest memory than address space allows.\n"
+		    "    guest pages: %lx max gfn: %lx\n",
+		    guest_num_pages, vm_get_max_gfn(vm));
 
 	host_page_size = getpagesize();
-	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
-			 !!((guest_num_pages * guest_page_size) %
-			    host_page_size);
+	TEST_ASSERT(guest_memory_bytes % host_page_size == 0,
+		    "Guest memory size is not host page size aligned.");
+	host_num_pages = guest_memory_bytes / host_page_size;
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
 			      guest_page_size;
@@ -369,7 +377,7 @@ static void help(char *name)
 	int i;
 
 	puts("");
-	printf("usage: %s [-h] [-m mode]\n", name);
+	printf("usage: %s [-h] [-m mode] [-b bytes test memory]\n", name);
 	printf(" -m: specify the guest mode ID to test\n"
 	       "     (default: test all supported modes)\n"
 	       "     This option may be used multiple times.\n"
@@ -378,6 +386,8 @@ static void help(char *name)
 		printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
 		       vm_guest_mode_params[i].supported ? " (supported)" : "");
 	}
+	printf(" -b: specify the number of bytes of memory which should be\n"
+	       "     allocated to the guest.\n");
 	puts("");
 	exit(0);
 }
@@ -385,6 +395,7 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	bool mode_selected = false;
+	uint64_t guest_memory_bytes = DEFAULT_GUEST_TEST_MEM_SIZE;
 	unsigned int mode;
 	int opt, i;
 #ifdef __aarch64__
@@ -410,7 +421,7 @@ int main(int argc, char *argv[])
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 #endif
 
-	while ((opt = getopt(argc, argv, "hm:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:b:")) != -1) {
 		switch (opt) {
 		case 'm':
 			if (!mode_selected) {
@@ -423,6 +434,8 @@ int main(int argc, char *argv[])
 				    "Guest mode ID %d too big", mode);
 			vm_guest_mode_params[mode].enabled = true;
 			break;
+		case 'b':
+			guest_memory_bytes = strtoull(optarg, NULL, 0);
 		case 'h':
 		default:
 			help(argv[0]);
@@ -436,7 +449,7 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(vm_guest_mode_params[i].supported,
 			    "Guest mode ID %d (%s) not supported.",
 			    i, vm_guest_mode_string(i));
-		run_test(i);
+		run_test(i, guest_memory_bytes);
 	}
 
 	return 0;
-- 
2.23.0.444.g18eeb5a265-goog

