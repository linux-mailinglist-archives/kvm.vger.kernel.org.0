Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C324B663743
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjAJCYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbjAJCYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:24:41 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB71838E
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:24:40 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4d1ef31a677so5063147b3.9
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 18:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=99MdrKCHNb/EnniLYabkWU6shDvbnK0IFCwPU+3Kegs=;
        b=goqQyEZz3AX3VF0i8F/2n8h3q9EaASVvzy1WurFfeDTJSfaCWiqusou8hzRN8LHBM0
         woTZpUXAgQDu4HlB3KZbA8ZBfQot5JyNmWKfh+LJWEr8kkxLwmYjPJxsCg+FIZPLJ5/A
         8t6kSVW4a1G/NArJ7Wh0A0YQhBSer56eZicERrORdAIF9uNumi2AG2sPduy0yzQ4MSpo
         eX1aNVuZQkCSEfw6IchKsn722Up8PAexGhob5E3SCCPj08DUWGSo/8QvwGsws3bHNBY8
         YBC4wbq0qeLCxqrzi8lJEfP6PVS3Wd/zoB4Y9hatHzwtqA2kETiVg/mqh8elLrpj/lFf
         iWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99MdrKCHNb/EnniLYabkWU6shDvbnK0IFCwPU+3Kegs=;
        b=jpGee/9T6bn/upj9F5/86har5A8ScDcnt0Myd/S7xBHLybsXSajRWnAqrvWqo73O+m
         xFaqInWjbucDkCMZ6bNLquruxTA8Cg/BvcTei4XUOt+wap/64SjYJh5oWbvf5+p3txqY
         wTkqDLFxWBxJiBjowAf5ylK9Q1xrxUaGSJJ0+wainsxVXKnEn6vr5AeecDzaf3SCqoPy
         PnFbSgHRpnm3+fFFi3phtr+37+Kg/qFgCZ/OhG/U2ZpoNhpJKCNtz4ZfrQyD0tMKQ9Zm
         pbC3MQ7mBFn46LXOjjz5BwL9itQB+tAGVI2q/2jTtVhtGHOEqZOmU5pNV0Ou9RSCL3Br
         0lvg==
X-Gm-Message-State: AFqh2ko6VPOxKjKNe6yUofvOeR6KRBRlnistsk6qDYKVCbDhhJmdSOOC
        B4lOPXLcdCBqu5yefvx+c3nNBGILcHo8bK4h37yQ9DVyZUUQugRrVwKH1diIo07cUv5Wax/LBxh
        dxMievLkpvpSXRbqrlfySguz5ppEJ+rnuYsjVp3W9m6b5NPkQM6wZYyuarLgsp84=
X-Google-Smtp-Source: AMrXdXtJRvDxmNIjfRKTwUiyRLnk+aa1vC/sh0XoLF5RTvS1oItI2r5+3fSNtNeWn22FK5DFY/DMrfCUQPaTAQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:56e:b0:6fb:4f99:d6b1 with SMTP
 id a14-20020a056902056e00b006fb4f99d6b1mr6574349ybt.371.1673317479251; Mon,
 09 Jan 2023 18:24:39 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:24:30 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-3-ricarkol@google.com>
Subject: [PATCH 2/4] KVM: selftests: aarch64: Do not default to dirty PTE
 pages on all S1PTWs
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com,
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

Only Stage1 Page table walks (S1PTW) trying to write into a PTE should
result in the PTE page being dirty in the log.  However, the dirty log
tests in page_fault_test default to treat all S1PTW accesses as writes.
Fix the relevant tests by asserting dirty pages only for S1PTW writes,
which in these tests only applies to when Hardware management of the Access
Flag is enabled.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 93 ++++++++++++-------
 1 file changed, 60 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 0dda58766185..1a3bb2bd8657 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -237,6 +237,11 @@ static void guest_check_s1ptw_wr_in_dirty_log(void)
 	GUEST_SYNC(CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG);
 }
 
+static void guest_check_no_s1ptw_wr_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG);
+}
+
 static void guest_exec(void)
 {
 	int (*code)(void) = (int (*)(void))TEST_EXEC_GVA;
@@ -791,7 +796,7 @@ static void help(char *name)
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
-#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check, _pt_check)		\
 {										\
 	.name			= SCAT3(dirty_log, _access, _with_af),		\
 	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
@@ -799,13 +804,12 @@ static void help(char *name)
 	.guest_prepare		= { _PREPARE(_with_af),				\
 				    _PREPARE(_access) },			\
 	.guest_test		= _access,					\
-	.guest_test_check	= { _CHECK(_with_af), _test_check,		\
-				    guest_check_s1ptw_wr_in_dirty_log},		\
+	.guest_test_check	= { _CHECK(_with_af), _test_check, _pt_check },	\
 	.expected_events	= { 0 },					\
 }
 
 #define TEST_UFFD_AND_DIRTY_LOG(_access, _with_af, _uffd_data_handler,		\
-				_uffd_faults, _test_check)			\
+				_uffd_faults, _test_check, _pt_check)		\
 {										\
 	.name			= SCAT3(uffd_and_dirty_log, _access, _with_af),	\
 	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
@@ -814,7 +818,7 @@ static void help(char *name)
 				    _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
-	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
+	.guest_test_check	= { _CHECK(_with_af), _test_check, _pt_check },	\
 	.uffd_data_handler	= _uffd_data_handler,				\
 	.uffd_pt_handler	= uffd_pt_handler,				\
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
@@ -953,16 +957,25 @@ static struct test_desc tests[] = {
 	 * Try accesses when the data and PT memory regions are both
 	 * tracked for dirty logging.
 	 */
-	TEST_DIRTY_LOG(guest_read64, with_af, guest_check_no_write_in_dirty_log),
-	/* no_af should also lead to a PT write. */
-	TEST_DIRTY_LOG(guest_read64, no_af, guest_check_no_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_ld_preidx, with_af, guest_check_no_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_at, no_af, guest_check_no_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_exec, with_af, guest_check_no_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_write64, with_af, guest_check_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_cas, with_af, guest_check_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
-	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_read64, with_af, guest_check_no_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_read64, no_af, guest_check_no_write_in_dirty_log,
+		       guest_check_no_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_ld_preidx, with_af,
+		       guest_check_no_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_at, no_af, guest_check_no_write_in_dirty_log,
+		       guest_check_no_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_exec, with_af, guest_check_no_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_write64, with_af, guest_check_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_cas, with_af, guest_check_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
+	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log,
+		       guest_check_s1ptw_wr_in_dirty_log),
 
 	/*
 	 * Access when the data and PT memory regions are both marked for
@@ -972,27 +985,41 @@ static struct test_desc tests[] = {
 	 * fault, and nothing in the dirty log.  Any S1PTW should result in
 	 * a write in the dirty log and a userfaultfd write.
 	 */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_handler, 2,
-				guest_check_no_write_in_dirty_log),
-	/* no_af should also lead to a PT write. */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_handler, 2,
-				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_handler,
-				2, guest_check_no_write_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af,
+				uffd_data_handler, 2,
+				guest_check_no_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af,
+				uffd_data_handler, 2,
+				guest_check_no_write_in_dirty_log,
+				guest_check_no_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af,
+				uffd_data_handler,
+				2, guest_check_no_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
 	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, uffd_no_handler, 1,
-				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_handler, 2,
-				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_handler,
-				2, guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_handler, 2,
-				guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_handler,
-				2, guest_check_write_in_dirty_log),
+				guest_check_no_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af,
+				uffd_data_handler, 2,
+				guest_check_no_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af,
+				uffd_data_handler,
+				2, guest_check_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af,
+				uffd_data_handler, 2,
+				guest_check_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af,
+				uffd_data_handler,
+				2, guest_check_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
 	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
 				uffd_data_handler, 2,
-				guest_check_write_in_dirty_log),
-
+				guest_check_write_in_dirty_log,
+				guest_check_s1ptw_wr_in_dirty_log),
 	/*
 	 * Try accesses when the data memory region is marked read-only
 	 * (with KVM_MEM_READONLY). Writes with a syndrome result in an
-- 
2.39.0.314.g84b9a713c41-goog

