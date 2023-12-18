Return-Path: <kvm+bounces-4738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2B081771B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4F3C1C25C15
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD2F42392;
	Mon, 18 Dec 2023 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EUu2AsJl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849AE498B5
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cd8c7cc13fso351638a12.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915957; x=1703520757; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzghRQCe+c1bjrH02U4KTpcWvp5L0do2OThRRrP9pkk=;
        b=EUu2AsJl94vnC1BqTjLburrhfsOAJaQaKyBCRbYe9Of+Fp3pncAEW1jy42Cdrqkn4I
         B/iFNhiDLELZe0U83n+80hUnjkhFy3DgXA6xNiDB/j00kuXjkgIbVhLov1fM+62Ciyoz
         Ir1ymu3K0TbyMjCqT4kC7WTXSG+CnOKA27bHZCEI+3tqh6th76VlvkDyjaHauFjqcIN6
         qVXZUovAHzIgRtsnnDoK290tHx/nAouZRApVGFS013jb6IeJP6H8YCFgHWjITfsUw4fO
         u9i6sI5IgLEV/nGVxFC2mkAcuAc+qTvGd457n71kKKx4o4bodb4soG14d+oemuavOY11
         neXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915957; x=1703520757;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzghRQCe+c1bjrH02U4KTpcWvp5L0do2OThRRrP9pkk=;
        b=DYjm41qhLDtNmCylE8UQTCfK7fP+ljMuuAYHjz5uMQEL0dj454NZYP+/cCngwJCq1G
         N7HIGT0TELm4j/3taymDo9ZoE2/saaMbIVAVZzQ8bW0MDLLH6SoYi3Lpgc8sTfW2oS8k
         Wsf8Et0dzwaKvKfHkTqNKSgk93V3iphjdVhW7oBGBYnDVPDOyCXwXvONCkppJM0GkIZN
         6SUWJuZeFCBzGuEv4pT+7aGKdvJUvUPtyx+D0vrXAGMpPUXtQT/xJJ4yfJE0MzdQ78KE
         ce7NIWXSHIYaIO5fd1CSiGEt4Bu2MezloY71IaRQU3OZK1mhAZr462re8clopZ5uxFBh
         /Vrw==
X-Gm-Message-State: AOJu0YzTXOFGEY0evoqbgMhH31PH9c2wM0wcN8kjexFjPNGEXJuA9g0V
	3GupaIVTOYEkpmVSBUY0Bdn777m/YVdbp17nbMNGpTTQ9GkI5DZh7o39IhmiRaRvMPAgMO86dm8
	VT0eni+syCQxDtXWlMFNUSF7L56J4a8FUqcfik8U6iQJqLbj4OglELGLPtg==
X-Google-Smtp-Source: AGHT+IFSmCJccK5VsIe5wPQ4Uu/Q+qj0pzOQp9lPC5Eptd1gfdJ++Ojzmqdq34Rh+9zDmPauvvruLv5VRWc=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a05:6a02:4a5:b0:5cd:927b:2d20 with SMTP id
 bw37-20020a056a0204a500b005cd927b2d20mr14062pgb.10.1702915956083; Mon, 18 Dec
 2023 08:12:36 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:43 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-6-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 5/8] KVM: selftests: add support for protected vm_vaddr_* allocations
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

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
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 25 +++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 8267476c76df..1b1a29ff035e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -482,6 +482,9 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3ab0fb0b6136..4a4ee1afd738 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1336,15 +1336,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+				     vm_vaddr_t vaddr_min,
+				     enum kvm_mem_region_type type,
+				     bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      vm->memslots[type]);
+	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
+						KVM_UTIL_MIN_PFN * vm->page_size,
+						vm->memslots[type], protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1364,6 +1366,19 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, vm->protected);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+}
+
 /*
  * VM Virtual Address Allocate
  *
-- 
2.43.0.472.g3155946c3a-goog


