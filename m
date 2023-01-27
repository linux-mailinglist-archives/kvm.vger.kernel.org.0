Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F289E67F095
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjA0VoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjA0VoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:44:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE147AE67
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r8-20020a252b08000000b007b989d5e105so6668057ybr.11
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxl12ovx7VRU+WHFkX8OH/d12QRd76yC440A+zPHtE=;
        b=gMp4A6O6/1b4rlE7oumSCdXh/cftkGSCBQDtrZZLgJJbNnN5ktVKxgYwy14+GTVYhL
         19CRJB7jQag9sLKRMgdiLPErYNYcDO+hI/1rxGUgJSn/BtPFZIu3hM+FEjvjoBj72W0g
         2fdzi87UIWXrHC9ZirA+iJk32u+Ns8cF5sUZej8ZXSMTdCgB7T7N14lDnk6jrDVExsHu
         9j2eZFAeijK9gVqP9LChqBtLBngE5MB1oadQgqm21QW5q1Ilrb8KTKtJ9A6ceu5seJx9
         0QYaGqvRh2pvudNwpYy/ERKoc3wVabf+Ij3/Ll0uSoWnch3jQB8Z3oiUo55PuobPfFf4
         vNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxl12ovx7VRU+WHFkX8OH/d12QRd76yC440A+zPHtE=;
        b=khgJ88OtM8QpONpIpVWh2Vx6AbHGb5LPOznU4fMwApw3ofR5ausVgYeTCpb0s9Kk/h
         OTi8obA0ktTjEI9B7CqYs3+EfEG78Q2tcRBCwRwKUxpIc4mXEd9jpFpMB41OJEdyzP17
         DJ/knzNWXHZObAKdlYnBMrtC5m+NjTC+1n5reB47ejj3/tDkfPKg1vCTMpU22THSzGfq
         WXZbDbGms7b7aoi3LZAXH18vcQOQT2ek6ShRQQg7uNCujojocuEiZW9nRSerxGmgniLk
         bButGmUwnwJ2TLU6+XjH95q1nplfo3emzPIhf3bnTH89pKLPkpK9dwYw+TvGeTdhnk5u
         G4wg==
X-Gm-Message-State: AO0yUKXh8PKjxto39ZbdJ+YybPwamp4rPQCSinb8tDyKqu11emoBkzRp
        KggN5BdoBtp9/HoebZ9ahJtbKxVRXyOQE6WsXVHUHrpfooP5XzoNVv4w2ktI1R6Quv+e0DSgupC
        NzoabjwV0uVCTeUpvthawGVVaYBOE3Df2o3jhSvMg0DnGN5INTXZujkfFzfrMcb0=
X-Google-Smtp-Source: AK7set9rGLaAY6JNAkStpkpA30vS3fvFUTMvtgFrmN3hnUo+1nFQnv0AQ1lED/vU32yoKHevFZLJuTyRYzOq/Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6d89:0:b0:506:6313:9436 with SMTP id
 i131-20020a816d89000000b0050663139436mr1588894ywc.137.1674855842075; Fri, 27
 Jan 2023 13:44:02 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:43:53 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-5-ricarkol@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
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

Extend the read-only memslot tests in page_fault_test to test
read-only PT (Page table) memslots. Note that this was not allowed
before commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
memslots") as all S1PTW faults were treated as writes which resulted
in an (unrecoverable) exception inside the guest.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c    | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 2e2178a7d0d8..54680dc5887f 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -829,8 +829,9 @@ static void help(char *name)
 
 #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
 {										\
-	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.name			= SCAT2(ro_memslot, _access),			\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.mmio_handler		= _mmio_handler,				\
@@ -841,6 +842,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_test		= _access,					\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
@@ -849,9 +851,9 @@ static void help(char *name)
 #define TEST_RO_MEMSLOT_AND_DIRTY_LOG(_access, _mmio_handler, _mmio_exits,	\
 				      _test_check)				\
 {										\
-	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.name			= SCAT2(ro_memslot, _access),			\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
@@ -863,7 +865,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
@@ -875,6 +877,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_uffd, _access),		\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
@@ -890,6 +893,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
@@ -1024,7 +1028,7 @@ static struct test_desc tests[] = {
 				guest_check_write_in_dirty_log,
 				guest_check_s1ptw_wr_in_dirty_log),
 	/*
-	 * Try accesses when the data memory region is marked read-only
+	 * Access when both the PT and data regions are marked read-only
 	 * (with KVM_MEM_READONLY). Writes with a syndrome result in an
 	 * MMIO exit, writes with no syndrome (e.g., CAS) result in a
 	 * failed vcpu run, and reads/execs with and without syndroms do
@@ -1040,7 +1044,7 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
 	/*
-	 * Access when both the data region is both read-only and marked
+	 * The PT and data regions are both read-only and marked
 	 * for dirty logging at the same time. The expected result is that
 	 * for writes there should be no write in the dirty log. The
 	 * readonly handling is the same as if the memslot was not marked
@@ -1065,7 +1069,7 @@ static struct test_desc tests[] = {
 						  guest_check_no_write_in_dirty_log),
 
 	/*
-	 * Access when the data region is both read-only and punched with
+	 * The PT and data regions are both read-only and punched with
 	 * holes tracked with userfaultfd.  The expected result is the
 	 * union of both userfaultfd and read-only behaviors. For example,
 	 * write accesses result in a userfaultfd write fault and an MMIO
-- 
2.39.1.456.gfc5497dd1b-goog

