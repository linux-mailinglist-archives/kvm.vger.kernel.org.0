Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B73967F093
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjA0VoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjA0VoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:44:00 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD035C0F7
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:43:59 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso6653898ybx.19
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+r80jWRktn2NXYocBPnV6+jERXxFLfpYOl4OGFb20o=;
        b=o1qiwhaf5VNUGPwPHauz2LHwKG5PKadP96Jxg6kvIH/Vpr2iILmdqOMYUAF8czkPaB
         m/0nTNKm0JpiZrrUndrKIX76uZJ1HTobFk3AL17pZDFnEdaqiIJsBne0Y3Y3gXn6i/+Y
         Idz3C6Hr2kW/q+S2EAA1WyYgYQsz9atvzmXnOT1tDt1MSmACmH52CSQeguLBVhgTxqfb
         2t1qlULufXoA7RZcyjwwEXSJQk+95/e4uHKVQSgx9fNq7VrPIerMA9VqghU2bbienn2S
         TKja9xylT0RJpk222EiQZGuOiwLi534soxMxkbc1hn8zhwarwqS3Rmwce0s3+ObmiXwE
         ed8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+r80jWRktn2NXYocBPnV6+jERXxFLfpYOl4OGFb20o=;
        b=3N/lTggZtQ2uG1TX6qHepLHBa9WKg5FqKY0qhXvkA4QY11wVZU4nUiI31jHxVorE7S
         TE5xvUwMyErt0qaRJAS1eXBiY2xByjP7rC2ZAchDE6Qyjp3HdR0mdn7ZsuO4o3B5SsFj
         rvvwe9ZlsH2as1IH6fxOfudAKuZvteUNx2V8xFrBIMkIKSYmv79fy5Oe/GzvcMNT93Pw
         pgzCuAWthtzOhHGbX71eFatAq+s2CJM7jA1gL5OOSxmcC0IhdtKCstGLVE9N0tuKOG9w
         Lg6fTdR1Rug27aCmG+e1YXh6Wdkjk7YpljhrfiytmFzs3aE1+Vayer/RVcg8nwNc/zPV
         Ib8w==
X-Gm-Message-State: AFqh2kpvTVVFb+HbK9+svOkG4F9cSU6fYYi0Q1mvKLrgrkTuzvRZgmqk
        O8PWichSStKmsRUWHs1BchhjJMeohAlDJBYouNG43TMlXRzLQJDONKeEKzRyM3sIXmWddmrD1Vh
        rIUKhh63LwwXI14rNlGP6hhPrpaYW2r98g/WFc6Zb2ACImE6bans9Dz4YO1vrApQ=
X-Google-Smtp-Source: AMrXdXv3u98ikSStj4vN5ayjbW1hSRMZ37W2JFGeqjYB5CTwpoTEhfzhZwc2Y9DCTvMJHW1fulrjYTjwrltFlQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:4c15:0:b0:483:77a:a272 with SMTP id
 z21-20020a814c15000000b00483077aa272mr5280570ywa.472.1674855838691; Fri, 27
 Jan 2023 13:43:58 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:43:51 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-3-ricarkol@google.com>
Subject: [PATCH v2 2/4] KVM: selftests: aarch64: Do not default to dirty PTE
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
2.39.1.456.gfc5497dd1b-goog

