Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35BC601863
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiJQT7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJQT7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:59:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1806279A45
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k16-20020a170902c41000b00184987e3d09so8381238plk.21
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBDWxwhGTtBIvO3uG7VQCGhtW5Kgp6bQMeyMfJhYG9w=;
        b=dVc2PJLvdjMt7UrxqsYH8pYEo0ol6ovPvdnyRpTPQwujEnqxK/xg+K5SO1zJdBE7Zj
         3gMg5MvozH3O7rRFSLxWmoN+b1zCu6vTM6xbCtJgOoS6Olf+R2WsAMGzj8scQgsneEVM
         GFOQggc72Pu+SowYmfPqbM9pC05p+QHs13YYorVhynwf5LFQsr3PhpDL5NuhaKxuMWUw
         0GWkmd3r0yyOu+fS+0hbjRNnTObgpSrTuJQFbxbci0q1WXOzPiDaynhD4kacZV0VGBbP
         EHwbylirMmZ/Cs4deIy1eu0/pwxHqdxai1GGVFJqIQbD14GaPpoP+qgVD6ucfcarYf2V
         UT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBDWxwhGTtBIvO3uG7VQCGhtW5Kgp6bQMeyMfJhYG9w=;
        b=IhwzYiyqBOhXTFQsIY+EiRGnWWVWBcACvylN/Qr6ET1emU2MftceucgYApaLxbHPDn
         bbJRJ4E7t8R8x2bce2VkPgx1i0ctMDWJQdnVhq2ZTq0qpusIJUn17YP/OTxkZDGQymx+
         wJvuBLK4nnINaz/FTMLmKc5/aaRixFXMBXPXWWo53PPPXxyqg0NH/vmOhnCoZ53V+XbJ
         /pb492exWi6Na6jzh2AF2rKg3qoevfjuRG/0dfhPLUM5rR8LpNORoOFj0XuHiCkMI31h
         CfD/pbicJmiPVRO9fjwEArlzWe3A4BIdO0BmMFXF8NGH/odE8M9Go1iWLtHZ27Y0ZLN3
         kdUg==
X-Gm-Message-State: ACrzQf23sIdN6uxgyYteG7bru1Y9I6lf2yITFFLzBEy19fll2PcweZRw
        bfnomrrTk3MD1Ym+sfTIOc3Joi1Ky3jTd6wcofbMNJDIgnmdfo87fycTtu0Ybfy3Tnut3tL/9/5
        rJXaCHfeTB0MF9/445QCsWovAcM5Zb1kRRT5UAHuYJiU1UjRzL4Nk4m8paPNdcWc=
X-Google-Smtp-Source: AMsMyM7aiArYgvRUrD+wkSx4bzLNpl24zYj+Ro2hWgzZVmQJixARrwpIsgydjij1J61/bDrpPx1M0qScinAwxw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:6b44:0:b0:46a:fa55:b6a0 with SMTP id
 g65-20020a636b44000000b0046afa55b6a0mr12134633pgc.614.1666036736838; Mon, 17
 Oct 2022 12:58:56 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:32 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-13-ricarkol@google.com>
Subject: [PATCH v10 12/14] KVM: selftests: aarch64: Add dirty logging tests
 into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memory regions for dirty logging, perform some accesses, and
check that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 8ecc2ac8c476..a36001143aff 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -31,6 +31,11 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CMD_SKIP_TEST				(1ULL << 1)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_DATA				(1ULL << 3)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 4)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG	(1ULL << 7)
+#define CMD_SET_PTE_AF				(1ULL << 8)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -213,6 +218,21 @@ static void guest_check_pte_af(void)
 	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
 }
 
+static void guest_check_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_no_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_NO_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_s1ptw_wr_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG);
+}
+
 static void guest_exec(void)
 {
 	int (*code)(void) = (int (*)(void))TEST_EXEC_GVA;
@@ -395,6 +415,22 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
 	return true;
 }
 
+static bool check_write_in_dirty_log(struct kvm_vm *vm,
+				     struct userspace_mem_region *region,
+				     uint64_t host_pg_nr)
+{
+	unsigned long *bmap;
+	bool first_page_dirty;
+	uint64_t size = region->region.memory_size;
+
+	/* getpage_size() is not always equal to vm->page_size */
+	bmap = bitmap_zalloc(size / getpagesize());
+	kvm_vm_get_dirty_log(vm, region->region.slot, bmap);
+	first_page_dirty = test_bit(host_pg_nr, bmap);
+	free(bmap);
+	return first_page_dirty;
+}
+
 /* Returns true to continue the test, and false if it should be skipped. */
 static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
@@ -411,6 +447,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		continue_test = punch_hole_in_backing_store(vm, pt_region);
 	if (cmd & CMD_HOLE_DATA)
 		continue_test = punch_hole_in_backing_store(vm, data_region);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
+			    "Missing write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+			    "Missing s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
+			    "Unexpected write in dirty log");
+	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+			    "Unexpected s1ptw write in dirty log");
 
 	return continue_test;
 }
@@ -673,6 +721,19 @@ static void help(char *name)
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+{										\
+	.name			= SCAT3(dirty_log, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _CHECK(_with_af), _test_check,		\
+				    guest_check_s1ptw_wr_in_dirty_log},		\
+	.expected_events	= { 0 },					\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -732,6 +793,21 @@ static struct test_desc tests[] = {
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
 		  uffd_data_read_handler, uffd_pt_write_handler, 2),
 
+	/*
+	 * Try accesses when the data and PT memory regions are both
+	 * tracked for dirty logging.
+	 */
+	TEST_DIRTY_LOG(guest_read64, with_af, guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_DIRTY_LOG(guest_read64, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_ld_preidx, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_at, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_exec, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_write64, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_cas, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
+
 	{ 0 }
 };
 
-- 
2.38.0.413.g74048e4d9e-goog

