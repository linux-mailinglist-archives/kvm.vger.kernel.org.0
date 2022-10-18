Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D2F603471
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 22:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJRU7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJRU7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 16:59:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E50C09B6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q12-20020a170902dacc00b00184ba4faf1cso10535040plx.23
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZEM2Q9nzB7T1LpqHIaGf2vJIOKjOHavkTCUOr3ZRUg=;
        b=L8xBPJIbH2fFvWt3Nn0n5TviDwSCrB7kaYUmdmF7LrZ0bSGXPMRvjU/VXc//G0Nw9K
         MC83S93NdveyiStgpg8eMNHtClOJoKDefasKGeN5aIDu+gfB8i7Vh08g0BUPwb3W/aMI
         1jQoKMxEquGWBcNf1zul641XBvckpW/PE9a4Kd9S+OVgsjvQlneCdvH2W54FAslGLSYy
         H6Ydqme6FfNJG0MJBM5GTCCm3i0GlKUrdwRpP8i443kd97ec9EJKWHLU58zTI4zkSn9e
         r4oG/B9JpvhkcC6rsWS0wEIpg9LSyQgtRrek6tgIA07D0n2ILqVuCP1yAegWB4zZqJFY
         6VjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZEM2Q9nzB7T1LpqHIaGf2vJIOKjOHavkTCUOr3ZRUg=;
        b=oAozYunH9k1uTi6WAHMYPBDConPzy3NWO8b4BEdv4EDdyK+7yYZUF+7aIZhBz6LqM4
         H3uhODBs4t7Qw+64p1v/URwygcqCdI8ugP99J0x8gxk+dP5DYx3eoH3hklxpzjzQ1UQ6
         xa/842bQua6SAPcnILYh8pYR6U3ESTFOkkHjpuHmPYcRzS3Yk1fGHuOcmM+zZvh9uw5F
         UoqnnMSrz0w+Qh63VdXc1yr4vdLhuAsrQyTIRhK/r+NT/t1o1kWgfnsuBOD4XV776y2D
         8pcafYvevhotXN578G31qOwY71/Fib4thY5VwI42zoqoz0N4VQUx9KWGJhf/BKGZHO9e
         jSrg==
X-Gm-Message-State: ACrzQf14CwRpFOWRdmv1hDyz9vW6DtCgSE7fYRIz2+Em3RBwcd0YH5ET
        yxfV5ZZcyft1e5Qzwom9nNUsDlAo79HYDIvl3NJZAZCGkmYmbMNd0hqmkUS1ALULRvRGY4/cAVL
        pnt01cgalADkdIspNcYl7R71j1dLK9AyRTJei1IQ58DIuVRRvubR/A3xcYg==
X-Google-Smtp-Source: AMsMyM6b9NbTo2MNrWHhAHbq6REay0R4wjyGL0o8pGS1ccgmryWYhfkrMdQypemTiVJuMgUMbO/LaE3jvHQ=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:c89b:7f49:3437:9db8])
 (user=pgonda job=sendgmr) by 2002:a17:902:cec8:b0:185:505b:95da with SMTP id
 d8-20020a170902cec800b00185505b95damr4875973plg.83.1666126741535; Tue, 18 Oct
 2022 13:59:01 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:58:42 -0700
In-Reply-To: <20221018205845.770121-1-pgonda@google.com>
Message-Id: <20221018205845.770121-5-pgonda@google.com>
Mime-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Subject: [PATCH V5 4/7] KVM: selftests: add support for protected vm_vaddr_* allocations
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, pgonda@google.com, vannapurve@google.com
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

From: Michael Roth <michael.roth@amd.com>

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since protected vms will have their
memory encrypted by default an interface is needed to explicitly
request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9aacc6110d09..4224026fbe25 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -396,6 +396,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f5f18a802434..d753345993d6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1231,12 +1231,13 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 }
 
 /*
- * VM Virtual Address Allocate
+ * VM Virtual Address Allocate Shared/Encrypted
  *
  * Input Args:
  *   vm - Virtual Machine
  *   sz - Size in bytes
  *   vaddr_min - Minimum starting virtual address
+ *   encrypt - Whether the region should be handled as encrypted
  *
  * Output Args: None
  *
@@ -1249,13 +1250,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+static vm_vaddr_t
+_vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min, bool encrypt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
+					       KVM_UTIL_MIN_PFN * vm->page_size,
+					       0, encrypt);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1276,6 +1279,16 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, vm->protected);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, false);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
-- 
2.38.0.413.g74048e4d9e-goog

