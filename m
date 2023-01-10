Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679266647B0
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbjAJRvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbjAJRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:51:09 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6DD33D75
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i70-20020a638749000000b004b2b09ec530so3135970pge.3
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HEafxR5smy9VpjPjO6IaK/ycja7cEDG1FQOzKPOmrvg=;
        b=M8l0s71GXEiAd1irLSOXHosGqiLUsf9u7hMTKJrNdITyMK+Eqv5AJ3+GI1+pq+mfsP
         prOS78xMVy7Llhncf+9yNn2fkaUP8QQiFfg8Qdt8eg4NiaLxrXWXC+S/QZRN5PPTY0nr
         lk0K1EfXGz6EpjqbseQYcROjBUAP42GrjXwhxtaQboyN5Cbw2b9cNnLgDoGOf9oXTiy4
         5pqO9E4tYyWPbyw49QaVmIZBVrbkqnOD6YmJnlQgRardJQw3yIUO/Z4en1ZmugApzSw9
         kE8I7nl/jNnMyWceEzT15p1yFj/W/GDw6nUuQsJYj9qjukUZYLIBcxFMI9fukxHIRBCW
         1K8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEafxR5smy9VpjPjO6IaK/ycja7cEDG1FQOzKPOmrvg=;
        b=kzygnwnQd0nGSRIoVHkCskn8NVxjTk8yOgqUnjfkFXziClFlcoitnTUtAvYlBcR6Y7
         J9UQCYxysNtrOONje1XxEb2KY5GGgZsh0hK73D3pT0RRL4WzYob5yVQleCpOJw7DmjyR
         uOFHNfNhtY8r1SeN6v8owNv30QeJWHM3Uc0khyhahuGFYmViuupXGMCPlTRR59U/XeaY
         XdYIxnmmUgmLaayRIXxrJQV5aT4mzm6FXZl28HFTN5ehqYc+g+QMwLKf6MApdIat4UlD
         fXU8R3YI3G+KfyWsdIbop6x63xMsXvDq5fLn8bZwmGecpwSLK5LC4ko3Xn/Wt3KkNjEJ
         LSJA==
X-Gm-Message-State: AFqh2koQueo8mP2NCLWCXt5MDwN2OiGBP8sqVELNfOBqLnHgb8zrbzQJ
        szotueYoM1o0Epv2S8nepgpeeVn+1ddBUqEzi2eZmMZHHlTnwbgdEgJFXip/xq1nEMpi+RnMiBL
        dbEVY2OEPasLbg508e05xHPXKNNbO3m4ZyWJuDIIjyYPa4BnV1iEdykbs+A==
X-Google-Smtp-Source: AMrXdXti+Iwjyna3LMdSgPjaVvI4CHqbzL19eNkQkJ+RXWo4qC9XPkTz511QRSQsPpvJgE4ZiHuGhZ1C1/c=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:902:bb8f:b0:192:fa87:f109 with SMTP id
 m15-20020a170902bb8f00b00192fa87f109mr1326191pls.173.1673373067783; Tue, 10
 Jan 2023 09:51:07 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:50:52 -0800
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
Message-Id: <20230110175057.715453-3-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 2/7] KVM: selftests: add hooks for managing protected guest memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm_vm.protected metadata. Protected VMs memory, potentially
register and other state may not be accessible to KVM. This combined
with a new protected_phy_pages bitmap will allow the selftests to check
if a given pages is accessible.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h        | 14 ++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++++++++---
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8..015b59a0b80e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -45,6 +45,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
 	int fd;
 	off_t offset;
 	enum vm_mem_backing_src_type backing_src_type;
@@ -111,6 +112,9 @@ struct kvm_vm {
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
 
+	/* VM protection enabled: SEV, etc*/
+	bool protected;
+
 	/* Cache of information for binary stats interface */
 	int stats_fd;
 	struct kvm_stats_header stats_header;
@@ -679,10 +683,16 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t _vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot, bool protected);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
+}
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56d5ea949cbb..63913b219b42 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -663,6 +663,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 	if (region->fd >= 0) {
@@ -1010,6 +1011,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
+	region->protected_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1799,6 +1801,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (vm->protected) {
+			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->protected_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -1895,8 +1901,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t _vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			       vm_paddr_t paddr_min, uint32_t memslot,
+			       bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1929,8 +1936,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (protected)
+			sparsebit_set(region->protected_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
-- 
2.39.0.314.g84b9a713c41-goog

