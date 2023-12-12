Return-Path: <kvm+bounces-4242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D7D80F825
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970821C20DA5
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F4C64CCE;
	Tue, 12 Dec 2023 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sgwQFDBe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA500111
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d34b1ea914so693315ad.1
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414030; x=1703018830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+55M1H0qZo6X91hhLwa23PvdZhvqeKwQZ30mHQwEs=;
        b=sgwQFDBeO7D7AOiCS9F/WPcG2kU+yP66lxhitL1QjGb4ri/z+W1c8FvGKsgJkBynq1
         FBKU+vs04Gzf58dwetyTpmzBQWjqsO3MJP7Y9DKvYg5YZQPI4iQtbcUHqM5rIlvP2DVq
         JqPjBgmfH3D8OrPDfYrQ4gikRWEk8i1iXqWQa87M0Y7UvbbLHfqYyPMsJEBX9PVq6fgz
         VJzNLR8X522WaMZZ6JyaByDmehRh1vjH1Mz+j99ljatqIpy3NAZux2L374ov1jqyFfhj
         P43e5kD6u3SOYTZspRW3jHEG8OQwE92TlSSmlryy21XrEP2of0WP28TDdFR5iOHDSdjv
         bjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414030; x=1703018830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ+55M1H0qZo6X91hhLwa23PvdZhvqeKwQZ30mHQwEs=;
        b=T+evk9az6J1kxatjdgNN7nxVscLeTX3j1gfAcKCr7c9pMfUfN9z1MQX3pDnbUjtB/R
         9M3Fx8WvK61WbUCmRUR3pTEbZJWrjqJbYwiZbI01YWrGTWiRH43I29IXk8tcQNG65fvL
         ygH6QkDN356KbPeQKGPS8qGHuf1egT4Yhl1HadDSNLJ6KJ5i3BqH5G9+bXxX8J+4ebtG
         YetEAPiWC4W+V0WjR7GijZSscRtiMN0FNY1Nm06v4w52gMI+ffOoqkGcylujz68NeRqK
         krCJxIXLKOVcXzrRkkqpukyZhXUS8OMpku5WpdWMI3Daq9JyYuFFM56+24rOovyPFuc5
         +6fQ==
X-Gm-Message-State: AOJu0YztVK6cI/Hq4E9sQMzOXJTz+qH/r2z9KCB/wBuh6WhWmahBir/0
	F2uubE81k4fbmjRwPgq6352roWQJ0A==
X-Google-Smtp-Source: AGHT+IGrrCQ4I7TQxCpkYqcamRceKsuPqXvFL+HKwNI2jpNCtkJmM866iSTSbXOwhW4q37bO7UDTRHUXAQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:902:e84a:b0:1d0:c738:73ad with SMTP id
 t10-20020a170902e84a00b001d0c73873admr49342plg.7.1702414029871; Tue, 12 Dec
 2023 12:47:09 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:22 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-8-sagis@google.com>
Subject: [RFC PATCH v5 07/29] KVM: selftests: TDX: Update load_td_memory_region
 for VM memory backed by guest memfd
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

If guest memory is backed by restricted memfd

+ UPM is being used, hence encrypted memory region has to be
  registered
+ Can avoid making a copy of guest memory before getting TDX to
  initialize the memory region

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/lib/x86_64/tdx/tdx_util.c   | 41 +++++++++++++++----
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
index 6b995c3f6153..063ff486fb86 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
@@ -192,6 +192,21 @@ static void tdx_td_finalizemr(struct kvm_vm *vm)
 	tdx_ioctl(vm->fd, KVM_TDX_FINALIZE_VM, 0, NULL);
 }
 
+/*
+ * Other ioctls
+ */
+
+/**
+ * Register a memory region that may contain encrypted data in KVM.
+ */
+static void register_encrypted_memory_region(
+	struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	vm_set_memory_attributes(vm, region->region.guest_phys_addr,
+				 region->region.memory_size,
+				 KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
 /*
  * TD creation/setup/finalization
  */
@@ -376,30 +391,38 @@ static void load_td_memory_region(struct kvm_vm *vm,
 	if (!sparsebit_any_set(pages))
 		return;
 
+
+	if (region->region.guest_memfd != -1)
+		register_encrypted_memory_region(vm, region);
+
 	sparsebit_for_each_set_range(pages, i, j) {
 		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
 		const uint64_t offset =
 			(i - lowest_page_in_region) * vm->page_size;
 		const uint64_t hva = hva_base + offset;
 		const uint64_t gpa = gpa_base + offset;
-		void *source_addr;
+		void *source_addr = (void *)hva;
 
 		/*
 		 * KVM_TDX_INIT_MEM_REGION ioctl cannot encrypt memory in place,
 		 * hence we have to make a copy if there's only one backing
 		 * memory source
 		 */
-		source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
-				   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-		TEST_ASSERT(
-			source_addr,
-			"Could not allocate memory for loading memory region");
-
-		memcpy(source_addr, (void *)hva, size_to_load);
+		if (region->region.guest_memfd == -1) {
+			source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
+					MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+			TEST_ASSERT(
+				source_addr,
+				"Could not allocate memory for loading memory region");
+
+			memcpy(source_addr, (void *)hva, size_to_load);
+			memset((void *)hva, 0, size_to_load);
+		}
 
 		tdx_init_mem_region(vm, source_addr, gpa, size_to_load);
 
-		munmap(source_addr, size_to_load);
+		if (region->region.guest_memfd == -1)
+			munmap(source_addr, size_to_load);
 	}
 }
 
-- 
2.43.0.472.g3155946c3a-goog


