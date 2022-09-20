Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C05BDB4F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiITEQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiITEPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BD653023
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x5-20020a056902102500b006af1376b813so1070372ybt.16
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=MX8S263yqB0ICFX8DuXOastxTXECyhjpvmbnjSusPbc=;
        b=UFj0AJeAXls+oRTlOQGufBmkTEZ0I5JQmRHaiwJUB6oZidvhXKImGKrkqG5pIMR4tX
         C747UkceKIssGpuzIah+anFS90urYqVztR0zqcws6xIiydr2n7lp8LaUQYjdsUElzIal
         OUmXOS4p449n3xrTYKsNJoIRYL/hvypcqBoqeUzZ3Mrlb41QJdkgMI+oA5WaJmwwg9GC
         yvv4Ncx+RBlnq/oq5WRH9SCvRtEVPN2+daMEtgpup9iM7ghUMwB8yNPawkfee7ntwceI
         ezJ83DXS0MV4jkqd0ZF9ZpMrWG33Js3TZZXLIrIICU5OvQha93ULUezLFk/dZwUn3xPt
         J4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=MX8S263yqB0ICFX8DuXOastxTXECyhjpvmbnjSusPbc=;
        b=VAmW2F6bDEV+KG3dGYQsx3ahBdUQb0b2RoKiIsoxh1yaKIjwAoCUEYoOgJAMOZ/r/x
         ET2XMcTVLVxFkjbeXDrqpbj9IBEX8rzCnG2KyuTbVBq68SKi260Vmc51ps3hy/Kui3KD
         F/s+CFoLb4f9WPaYS4TjTYWGP8j6yPQfSajwDl1i6pDpqIPVJ2OBfze9zBvYyM0Epwpw
         y2TiNd07xOB6JldZvdHSzo9Var1dtgyxPqRxn3Se4gQHsltF/dmxl1oBmSeOdpGYYJ1k
         XizHlZZu5PRHLC22f2Gaqfh0E7UrpZS9R8O7lrOmni1nj24FAjHSbCURFVFDt5tWORAu
         0avg==
X-Gm-Message-State: ACrzQf2AFtCWBqcoE17nIYgxmRTbE37r6VUGXMLglF8qOL8AvZVXULvZ
        N4onfHPwYJoQCj8uIOtha35saPagV9hSbjJGAtuDFnWsSjPKgAhCPgtOwK99VxVIoL5A3uGZzQp
        OaP1EG3E1rI9f2VzaUNjqiZuOCXuaaDsT5F/pmYWWTnwEDaY6kT7tN3JzD5w6e1k=
X-Google-Smtp-Source: AMsMyM5JE06YIrMSfk8gOD5uy72FbiJ/dLHkpinChQcxvaCx3t6RX4zUTUTAbwn3kHxvYKo5Xny58cJELHeRiA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:ccf:0:b0:6b3:ae46:1646 with SMTP id
 e15-20020a5b0ccf000000b006b3ae461646mr10767357ybr.74.1663647333429; Mon, 19
 Sep 2022 21:15:33 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:15:09 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-14-ricarkol@google.com>
Subject: [PATCH v6 13/13] KVM: selftests: aarch64: Add mix of tests into page_fault_test
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
index 386c20b47723..cf72edbd42ef 100644
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
@@ -806,6 +812,22 @@ static void help(char *name)
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
@@ -825,6 +847,59 @@ static void help(char *name)
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
@@ -893,6 +968,35 @@ static struct test_desc tests[] = {
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
@@ -908,6 +1012,57 @@ static struct test_desc tests[] = {
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

