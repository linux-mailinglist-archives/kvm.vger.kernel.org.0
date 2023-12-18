Return-Path: <kvm+bounces-4736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E09B4817719
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A5FC28557C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231314FF7F;
	Mon, 18 Dec 2023 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fPC+Rxku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30242392
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6d8668f2d43so535469b3a.2
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915953; x=1703520753; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SbICF1fkgvxxCgQV2nManH0yP77HuHuA1kyLJRiJrn0=;
        b=fPC+Rxku6r2mv1o+BQobchTFL1qSciOnsmEdmbHR+KxqGCiK3EMji2GFGEL8OjfaCZ
         Kp0Vg4SWoMC8/BMrIRY+Rl7zzlvt2JJqiv5LAyDj94gJ4iH/NQGPlMK+6I6fXh0qhSLg
         mnovj4hplM59PCJWUyo2v9aZ0dpAj0FBgbB/DB8l3E8VTvMWsxZR/yS4egLk7Dkq2Bpr
         MCqkWhw1+ce9WlBfDzqcaLmpn8wEf0zHuWNMgbaPUw3QPKFTF/UFs2pJMCJcF9bZPiZW
         5jMP5jp1O1HUN5PsVZSU2+ThLyMp0krckPzIpokxpz9CY+uXFy3uO7jmWMWapfZzZkrw
         LYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915953; x=1703520753;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbICF1fkgvxxCgQV2nManH0yP77HuHuA1kyLJRiJrn0=;
        b=bAJvMm25IlgPjeZzqp1117WKizLPqBa+pxTrG+8gfZoOJUAGOchW6i3uItj1AXhS4r
         rXWmIB8885ZFDUxvBi2FAlQ0j3VviPtj/foOh3WNv4oCavNUMPOuYz0iXA4XJ5JGa8Fv
         KkT7ktzxBPpx/O5XcRl2rd91SSYoDJuDN8pIuOh87Ip5LtxZe0Kxx4DDi8/c3Tngrwyi
         aLVYX4/1FKoX9y8oFIB0dBJwI8B7eVphfPSB1fM9pKY0Ts04dLoI/KQ6G/Mk9G+ASTCE
         7mv7aq5vMZvSu1BPDekO9ULPhPbBEgiW8ndt+bV9hRnwaV9nSVmN9RQucCKTFwZyiXIj
         8EQQ==
X-Gm-Message-State: AOJu0YyigIHgi1yN6S6tmaRHCTr5m50CTNCIM4UoACX/rtYAkqlVszRl
	gK/KPBP1t03zvBtU62mCN7LG8xLvhVV0KSmLE3/6U/tTPC+p/Zyz/b2IC2p4EVsZHPBGHJw1l8z
	kz/kYxlD6FCxmOmhrKGlmiwYMpjbzMuy3nB0/929Jx3XqZfUWrwreWWZjRg==
X-Google-Smtp-Source: AGHT+IFqEfyGWyuO0VoQqJSo3LI4BpPlPeAwvNMEUC+okeGFXa9Xlaab/qukz4zpMxfysEJRm0JqnHNPgf8=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:c81:b0:6ce:5904:6e85 with SMTP id
 a1-20020a056a000c8100b006ce59046e85mr2380919pfv.0.1702915952236; Mon, 18 Dec
 2023 08:12:32 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:41 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-4-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 3/8] KVM: selftests: add hooks for managing protected guest memory
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_vm.protected metadata. Protected VMs memory, potentially
register and other state may not be accessible to KVM. This combined
with a new protected_phy_pages bitmap will allow the selftests to check
if a given pages is accessible.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h        | 15 +++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++++++++---
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index ca99cc41685d..71c0ed6a1197 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -88,6 +88,7 @@ _Static_assert(NUM_VM_SUBTYPES < 256);
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
 	int fd;
 	off_t offset;
 	enum vm_mem_backing_src_type backing_src_type;
@@ -155,6 +156,9 @@ struct kvm_vm {
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
 
+	/* VM protection enabled: SEV, etc*/
+	bool protected;
+
 	/* Cache of information for binary stats interface */
 	int stats_fd;
 	struct kvm_stats_header stats_header;
@@ -727,10 +731,17 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
+}
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bb8bbebbd935..6b94b84ce2e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -693,6 +693,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 	if (region->fd >= 0) {
@@ -1040,6 +1041,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
+	region->protected_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1829,6 +1831,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
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
@@ -1941,8 +1947,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1975,8 +1982,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
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
2.43.0.472.g3155946c3a-goog


