Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B65E599F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiIVDXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiIVDVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C6D98751
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348c4a1e12dso67416097b3.11
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=KEKh20sA3skiS2y1tjkcaSh6mpEKRlX+mUzCsGaPTmU=;
        b=tQHxD4jJLdl5cD7UjcbLre6cbqocqsFqdbsa51wZTMrPRdTs6ltgrAOvp+PqFIvBys
         hneyFdLPDtfCn12VflvNAyfLZGKxXV2TQbxmkmVEBu6GcVbKBnzABjy34/nUptg1f8jw
         MP0BUAXFdZxMN4LFrdDuezeJVcQHeg+jQQe67jnpnHto9lSNvgXOktK35qgreyleYNtT
         fbsmIUBPZpuUuvRTGxzkG+yw5R1RKlwnNZpvVwId0rUpnKKmAtC0miOTe2kwD90yKWcV
         X7wX8Soyi4k0lN+m6cU3R6y/wlKS4Jx4aQ2GEB9U1yskyhBL7uyYYRy/7BeVFlrW5XfJ
         F54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=KEKh20sA3skiS2y1tjkcaSh6mpEKRlX+mUzCsGaPTmU=;
        b=Yabwuqc2ZlqFhV5nK0c6VLm/9EJe3TCEUA0uNDahPpgW2qtsBxx+CPbaIdpMThIMf1
         Exr0lva4wt79cf7aD51DCM/8RdSBmK3FZ+agvHTLfsiv+AWSzhaaq6shMcRR5N7jLoxh
         +zALJeykSxATZQVpO62GV6Vk33gTfz+Bt0GrvkcLJRSMEy9FagiJv+BZv/u79cn1h1vu
         QhcgMyIGl22fkjJIqfZ64Ftk4myEIvj7FuAM45GW4aIWO+bq6YlAO3PleM0tTk7AEr2x
         4KzRm0tY/CnH8nbzXMF+fBLYsjMCyPUbCs9xvpzZzGhsf00UPhCSc3wJHU51dHzA6n9a
         +zOQ==
X-Gm-Message-State: ACrzQf0LsErb7oDhbFSvP+EpJMbUEB4R/ETQSQGNwRcIKMMDma8I6psH
        zVOhT1FQaeymOu8UO+ZLPfRgV+rsRd6ZP/d+gwDip3CkjM9YcJ5ifkxvSGDFNzVMxoqCpmbtP5/
        +h2r/o4laPajM3mid4BLNt++jFyhMCLzNSNWxwEaT899//ZuMeeFMXPLC3fF4xrs=
X-Google-Smtp-Source: AMsMyM7UKwulYMDaZZjrgXcFp3gBhAFMTc9QYJjQbdY7ZmJ0euQeqlL4sPcLCVYD9wy1A/xDZJS/vPfAeWL37Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:48c6:0:b0:345:4835:f62e with SMTP id
 v189-20020a8148c6000000b003454835f62emr1272373ywa.149.1663816763321; Wed, 21
 Sep 2022 20:19:23 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:57 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-15-ricarkol@google.com>
Subject: [PATCH v8 14/14] KVM: selftests: aarch64: Add mix of tests into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
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

Add some mix of tests into page_fault_test: memslots with all the
pairwise combinations of read-only, userfaultfd, and dirty-logging.  For
example, writing into a read-only memslot which has a hole handled with
userfaultfd.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 155 ++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 8f2a30402e27..23f8ceaaf9d1 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -399,6 +399,12 @@ static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
 	free(data_args.copy);
 }
 
+static int uffd_no_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	TEST_FAIL("There was no UFFD fault expected.");
+	return -1;
+}
+
 /* Returns false if the test should be skipped. */
 static bool punch_hole_in_memslot(struct kvm_vm *vm,
 				  struct userspace_mem_region *region)
@@ -802,6 +808,22 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_UFFD_AND_DIRTY_LOG(_access, _with_af, _uffd_data_handler,		\
+				_uffd_faults, _test_check)			\
+{										\
+	.name			= SCAT3(uffd_and_dirty_log, _access, _with_af),	\
+	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.expected_events	= { .uffd_faults = _uffd_faults, },		\
+}
+
 #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
@@ -821,6 +843,59 @@ static void help(char *name)
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
 }
 
+#define TEST_RO_MEMSLOT_AND_DIRTY_LOG(_access, _mmio_handler, _mmio_exits,	\
+				      _test_check)				\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits},			\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(_access, _test_check)		\
+{										\
+	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _test_check },				\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1 },			\
+}
+
+#define TEST_RO_MEMSLOT_AND_UFFD(_access, _mmio_handler, _mmio_exits,		\
+				 _uffd_data_handler, _uffd_faults)		\
+{										\
+	.name			= SCAT2(ro_memslot_uffd, _access),		\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits,			\
+				    .uffd_faults = _uffd_faults },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(_access, _uffd_data_handler,	\
+					     _uffd_faults)			\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_test		= _access,					\
+	.uffd_data_handler	= _uffd_data_handler,				\
+	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1,			\
+				    .uffd_faults = _uffd_faults },		\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -889,6 +964,35 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Access when the data and PT memslots are both marked for dirty
+	 * logging and UFFD at the same time. The expected result is that
+	 * writes should mark the dirty log and trigger a userfaultfd write
+	 * fault.  Reads/execs should result in a read userfaultfd fault, and
+	 * nothing in the dirty log.  Any S1PTW should result in a write in the
+	 * dirty log and a userfaultfd write.
+	 */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_read_handler,
+			2, guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, 0, 1,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_read_handler, 2,
+			guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_read_handler, 2,
+			guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_write_handler,
+			2, guest_check_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
+			uffd_data_write_handler, 2,
+			guest_check_write_in_dirty_log),
+
 	/*
 	 * Try accesses when the data memslot is marked read-only (with
 	 * KVM_MEM_READONLY). Writes with a syndrome result in an MMIO exit,
@@ -904,6 +1008,57 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
+	/*
+	 * Access when both the data memslot is both read-only and marked for
+	 * dirty logging at the same time. The expected result is that for
+	 * writes there should be no write in the dirty log. The readonly
+	 * handling is the same as if the memslot was not marked for dirty
+	 * logging: writes with a syndrome result in an MMIO exit, and writes
+	 * with no syndrome result in a failed vcpu run.
+	 */
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_read64, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_ld_preidx, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_at, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_exec, 0, 0,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_AND_DIRTY_LOG(guest_write64, mmio_on_test_gpa_handler,
+			1, guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_dc_zva,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_cas,
+			guest_check_no_write_in_dirty_log),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_DIRTY_LOG(guest_st_preidx,
+			guest_check_no_write_in_dirty_log),
+
+	/*
+	 * Access when the data memslot is both read-only and punched with
+	 * holes tracked with userfaultfd.  The expected result is the union of
+	 * both userfaultfd and read-only behaviors. For example, write
+	 * accesses result in a userfaultfd write fault and an MMIO exit.
+	 * Writes with no syndrome result in a failed vcpu run and no
+	 * userfaultfd write fault. Reads result in userfaultfd getting
+	 * triggered.
+	 */
+	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_write64, mmio_on_test_gpa_handler, 1,
+			uffd_data_write_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas,
+			uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva,
+			uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx,
+			uffd_no_handler, 1),
+
 	{ 0 }
 };
 
-- 
2.37.3.968.ga6b4b080e4-goog

