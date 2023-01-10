Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF66646F3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbjAJRE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbjAJREL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:04:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4CD479E6
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id g32-20020a635660000000b00478c21b8095so5478694pgm.10
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jOOIrnjUtMWZUpL0L9JKdfnGMbr4TWaLxXxQkwwyrwA=;
        b=UU9Kqjf62PjHXAjjUmx5GGGgEBCLwLFNh8oCagqBmVN4Gtimz225qy4zb571uiDfM3
         WWVVb1/U3Z7DSGHoric/TMH/CtocLzrTSPsJUCPQ2iVzeiauDI66AOqidnNJ7qdMDoxa
         9n71dxrh4KmnrycACSboUQuY5APm/r8FzZ4KUVPnwUWX4oA8Fqw1+dORLldbesrNuBcY
         /Rpxz0ICqRmRtRezDq+VK28q21H1W/ygeSF+C4LKDW6YisE24VowXqqFdNavgRCLaXjW
         wQN1CpnKrNeC0th5ivqBi9ECsqpNFDskmzuSVycdLJzn2a/yYey/bXReoVQlIL/Rf7Av
         PYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jOOIrnjUtMWZUpL0L9JKdfnGMbr4TWaLxXxQkwwyrwA=;
        b=Nj+j43fd2ipsaHH9K0P4JV7YvWg0J/WO0zO7VdOVm9FfcvpA6C18UlV4miTfN+1b7X
         /TqfAnRG+T75f2iN8GhWfONHX1CckkvH8wJvlx8lkYtrFwCGya8vAN9aiMzV3GgJGQB+
         CqINpRIIVmtXDzD3wMqtWW/Q3F3qvNaqJQyBrDOTTYmRK6ZPE93yhWr1NhSgCJdEkCbT
         D3kmhUGwSRuXiL2wQvoKV7/8q/epoXW+OuK6M9BYsRcZhSrOdTyNzyEZcj2L3eG2i2rO
         FUuotPx+qpEm/78Bi6hcz49TRc+o6uV1XG4bO4JNy0/8CCGUsZ9mJ0Ksh7FZMqZ0SAWz
         pfDQ==
X-Gm-Message-State: AFqh2krfUeBvZSHnghQ4M70DS22cGMwAw5GnwN27wE1ounczD7ejXWww
        K90ta113PX3lplI6dEP4KsKH1w3zyH8J8ropoqVe4E5ZMsZLzPxJv0bVPOkCRKdSSiLguQ0Kr2j
        7iwasYUyL4xHav/zv0gdNo/ny/82L/fpmvRPK1+MuFJCoPFS3p4QDjejhTQ==
X-Google-Smtp-Source: AMrXdXtlTZ1hCS0jta1wB0FwopiNwOvlglAq474UPvN+IBSk3hkAsqthRVoNIdXgt/uvjGvSiGBB536oTNs=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:902:b7c1:b0:192:5838:afb3 with SMTP id
 v1-20020a170902b7c100b001925838afb3mr3664339plz.13.1673370248065; Tue, 10 Jan
 2023 09:04:08 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:03:55 -0800
In-Reply-To: <20230110170358.633793-1-pgonda@google.com>
Message-Id: <20230110170358.633793-5-pgonda@google.com>
Mime-Version: 1.0
References: <20230110170358.633793-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 4/7] KVM: selftests: add support for protected vm_vaddr_* allocations
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerly Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Peter Gonda <pgonda@google.com>
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

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f84d7777d5ca..5f3150ecfbbf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -435,6 +435,7 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ba771c2d949d..0d0a7ad7632d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1305,15 +1305,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+				     vm_vaddr_t vaddr_min,
+				     enum kvm_mem_region_type type,
+				     bool encrypt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
+	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
 					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      vm->memslots[type]);
+					      vm->memslots[type], encrypt);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1333,6 +1335,17 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, vm->protected);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA, false);
+}
+
 /*
  * VM Virtual Address Allocate
  *
-- 
2.39.0.314.g84b9a713c41-goog

