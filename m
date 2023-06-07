Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236A07271EF
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjFGWpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjFGWpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026B1BCE
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:30 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53feeb13975so3104497a12.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177929; x=1688769929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vHN1EB9Pz0wYRGAClVk5phIwLmb5scjxhf2nuPTbv8E=;
        b=UZb133IrKwO1aXFhHgSOeibmNQGQhT29PTXfI5vi18qVzF14egC/FKhZUCGdfig5pD
         qRS6jQT/ny+83XL04h+D6VMidCSZaLT+j6M/JqZDFywOmZLtGdsCLOapT3srnna1o9Sy
         D3RMSMm7f6PYMRhBvNbRfUjaiEzX0x7qDSrv4daFSYvAz9RbwExdn4cNCV+uroZPHEZk
         jXZz93gZZ41Dn/YjEG+oD3fpy4N1OzRdvUjfvQHUt/bSdLeSUQl+i2+SFahavugthstE
         hoABwHnZOHFnoxEHL/S4SMdlObXdbCWV2f3MfyxfMSTiPqW5/brQIFxEAHgCBiyi9+vu
         oCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177929; x=1688769929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHN1EB9Pz0wYRGAClVk5phIwLmb5scjxhf2nuPTbv8E=;
        b=RSRKtB5q7taHxZptmjd/UYQRSg4hrnpKdDEP51wDOcSLyrEodKbRZ01r6rRAfRU3ic
         wNPMsmCs704HNcNPBke1VwYEixBtnSFIG4//OpU7faZD588KEfKAtlg4A7TYdVSAjvn9
         oZf++Md6LOlJB46/+/EnqcGiYv3isWfjzrHxfP/WOcUiYN8oQI3SdkjxJXNV/cXDImt0
         4Xy9Y6yIPWscIR7yoKjo8BUrpn3Q45uqEU1OeMmEU3/NGW6+xOJJUJ4ct7ZbpOp0wME8
         vD5LEBHk9xIac/t1g1SSHv6wGHvvzVmeqOB8A8j8FgTB35uNOO1jZvyjXc/d4i1sIU8b
         awyg==
X-Gm-Message-State: AC+VfDx9BOKeD3iJoR+TH01dGLq+JPdEyN1DNi+8lmRQuYUjLU3bj/EI
        i9HrZ6r59SMcns/VPDE7QmGlhoOjggNi75EoJgsxxIWSliFNxOcQYJaBuGxF8Vm6xuNSODhIdZ5
        z8eLj2ucBf+1dXHMdKh1hYr3OsUzXMmVZetaYIs40afTtD3SFU8/gGrdZaekGLoTYjsM8
X-Google-Smtp-Source: ACHHUZ6wEY7C9rr6apdqE1PzgttrSSN31BGvYJ1zy2VlsMN2QMpbRrS5gCqp3yyujUCtVyDmFxBkZHH/Ix7M2dY0
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a63:4c1b:0:b0:530:3a44:1581 with SMTP
 id z27-20020a634c1b000000b005303a441581mr1522106pga.9.1686177929443; Wed, 07
 Jun 2023 15:45:29 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:18 +0000
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-4-aaronlewis@google.com>
Subject: [PATCH v3 3/5] KVM: selftests: Add additional pages to the guest to
 accommodate ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add additional pages to the guest to account for the number of pages
the ucall headers need.  The only reason things worked before is the
ucall headers are fairly small.  If they were ever to increase in
size the guest could run out of memory.

This is done in preparation for adding string formatting options to
the guest through the ucall framework which increases the size of
the ucall headers.

Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 4 ++++
 tools/testing/selftests/kvm/lib/ucall_common.c     | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1a6aaef5ccae..bcbb362aa77f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -34,6 +34,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+int ucall_nr_pages_required(uint64_t page_size);
 
 /*
  * Perform userspace call without any associated data.  This bare call avoids
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 298c4372fb1a..80b3df2a79e6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -312,6 +312,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
+	uint64_t page_size = vm_guest_mode_params[mode].page_size;
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
@@ -340,6 +341,9 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	 */
 	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
 
+	/* Account for the number of pages needed by ucall. */
+	nr_pages += ucall_nr_pages_required(page_size);
+
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..77ada362273d 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -11,6 +11,11 @@ struct ucall_header {
 	struct ucall ucalls[KVM_MAX_VCPUS];
 };
 
+int ucall_nr_pages_required(uint64_t page_size)
+{
+	return align_up(sizeof(struct ucall_header), page_size) / page_size;
+}
+
 /*
  * ucall_pool holds per-VM values (global data is duplicated by each VM), it
  * must not be accessed from host code.
-- 
2.41.0.rc0.172.g3f132b7071-goog

