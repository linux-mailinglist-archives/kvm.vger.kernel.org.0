Return-Path: <kvm+bounces-1376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 487817E734D
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F38FB1F21975
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3DB3985A;
	Thu,  9 Nov 2023 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KpycGLKB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F49838F9E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:54 +0000 (UTC)
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC7E49DD
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:53 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id af79cd13be357-778b3526240so147393285a.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563833; x=1700168633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcXPtnv49h6RAm6cS9G5VMrOnN29qVgKtjpOURCfKY=;
        b=KpycGLKBMqfkE0N7EQ0j6/0DWWO3N23UArSyO2Fv1bjR+SjyHgyjwi8hfUKYzi7Cm5
         uaRPVzxiAigaLxKS9ruIofjhTjl1T3Tg9G2Ca7aYseDdTa+48zfnSzWaRYKMspT5QsM5
         VhogVEnJh/Y4i2ChjPW/CokUz8JBcC4GkrnijOztGgggi9BfKIGmvR8xNUikspRcc35+
         SGrlqRNqfy/OLKWu5eaYjgifO5Sogzfr3OBYK/66H9lWLZ7LVhFHccblTq6bX3r0Nz3I
         Mp9I8/hf7MASaUlnx0Ut//IYajIVyUaPG3Unx8vBkgR7xvma7Cs6fmxnXX5oDfJ6Md/V
         4Bqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563833; x=1700168633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcXPtnv49h6RAm6cS9G5VMrOnN29qVgKtjpOURCfKY=;
        b=QLPo3KcKDOV3kHwYsKAKQoeoRrOXpjh1y9FUFuZAPr7Gn4Yw8H7B6leGkcsm6SagVE
         vTSK7+hHKwisViHWGcnw3KMCnSZzWHoPUgiB6IUfyqSDeAfOvZcF30s/E7NvP5IBlzbH
         GFCdEDxO83JP6jlKwbRlkpI21469jVeml5UdJKUsqAZattt21MsdIcpmzf1fkLicYt5E
         h/PZWHF1lZ3Ejp9FjMxGSWp26Hb021ZqBdNDHkvYSmC21VhM2aY+cMUZJmV79vu1wa+c
         sxDfc2NT5F+bWpA6epSIySk21D7mT8OAyLLBSRXJSAy/+OvhhFInZX+prqygs/H5OLOD
         TXfw==
X-Gm-Message-State: AOJu0Yx2VbhR6DnDps1eKvFzBYP1r3HhDIU//2sAZuLtTvIK2R9BYeYo
	XG0LYIFawsRF6FbvKBL/c4d3wWYugGAo6A==
X-Google-Smtp-Source: AGHT+IEPvmgFr/ZO9CbrgP1bKZHB0+G4ikHM0pFYVGxmjxS0Pviry7UBKDcbDGJlyuhvYt2yNZUCp14aW3sEOA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:4509:b0:775:7572:4e62 with SMTP
 id t9-20020a05620a450900b0077575724e62mr188628qkp.2.1699563833047; Thu, 09
 Nov 2023 13:03:53 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:20 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-10-amoorthy@google.com>
Subject: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
calls to check the memslot flag.

To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
when the stage-2 handler cannot resolve the pfn for a fault. With
KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
faults as vCPU exits, which userspace can attempt to resolve without
terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 arch/arm64/kvm/mmu.c           | 7 +++++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fd87bbfbfdf2..67fcb9dbe855 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 1a777715199f..d6fae31f7e1a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,6 +43,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
 	select XARRAY_MULTI
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 13066a6fdfff..3b9fb80672ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1486,13 +1486,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, false, NULL);
+				   write_fault, &writable, true, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.42.0.869.gea05f2083d-goog


