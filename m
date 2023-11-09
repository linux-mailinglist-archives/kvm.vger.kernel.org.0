Return-Path: <kvm+bounces-1373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BBB7E7345
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9B261C20AA1
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFCE38FA0;
	Thu,  9 Nov 2023 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="df/9vJiy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ED738DE7
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:49 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F99468D
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5af16e00fadso18869057b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563828; x=1700168628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nUPeAHfZEyhmLdl3NqUNDrUfGjWmU/+Qb2Tjd/grrc=;
        b=df/9vJiy5kAJx1daqXAOmwoap63JARAlMoCmGJSV6SAUheBUve3b3fgGeSYwmf/Gwr
         66LRqMOFXmnHH5JohSpT72xP4J0qpRD4kDP/bkUVuIPLnaPGPPOLJBVpEo5TyS5JQTS9
         fTXkLDWO/d+q2tzi2s8McGUGu2uB1SVSI8f+KlqZ9ZMCvhmnpQ8GXm7GZiQB+Eb2xxr4
         C71udoZi52qsXYJ5zmfsajcwF4DN7Toq0XJ6qsxfuZXdt6vxxyYeh8kQytJIuQuJanRR
         mDFeM0h934Pub+XNRR6ARagThoPUJZ0bRpLPFpJ27ZddIBDS6h5FFHdw2ZP740MmEbeL
         RndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563828; x=1700168628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nUPeAHfZEyhmLdl3NqUNDrUfGjWmU/+Qb2Tjd/grrc=;
        b=aJZPZjnzlJs6NDnU2/JSsl9nFtFacR7/zne7uewYeI6KaNSzkYUEYby1iwO6UvgFU6
         pwHCRwDhRgIdYkuD6g5fD36ISWIjZmHu4Ub3pUC29tdOOWSY+bQ9sCkDMxWRLbktKBU6
         qCe0dy1gnoA2eZvsguNQLbA93jnduPMMQ0Fe/Z1IHKZFgv90V+n9RqT5kTqfSBAHAGBJ
         B7CvlS5U6J3K7jSmAzkXkL1CIiOX4qJ88KnBM6Vkw4giPvJ6bBehYuf4K+ZRt7aEl6s2
         Znbf291KyWLZgjSePkesJzlqphPyuDK3qD8hJ7fmy1FclEexEp3YoVBTJG5m9FNdzqhK
         dLaA==
X-Gm-Message-State: AOJu0YxTLkGSEEbuswDaJXFBpgzUVi20kPGZGF6qey4u10fQYT26lmN+
	Xhbn8Hb/cw8ttDUO5S21W8aVPOpk3sTpsw==
X-Google-Smtp-Source: AGHT+IGYRKD7rEcFCG/FkA77dggqygTDLeWg1w3kaLGy0YrkzhLxkHgLcnRLFPcg6Q/Xm7V2ZW+NzaJ/Oc7KBg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e643:0:b0:d9a:c218:8177 with SMTP id
 d64-20020a25e643000000b00d9ac2188177mr146076ybh.8.1699563827866; Thu, 09 Nov
 2023 13:03:47 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:15 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-5-amoorthy@google.com>
Subject: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++++
 include/linux/kvm_host.h       | 9 ++++++++-
 include/uapi/linux/kvm.h       | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c13ede498369..a07964f601de 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6979,6 +6979,9 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+  #define KVM_MEMORY_EXIT_FLAG_READ     (1ULL << 0)
+  #define KVM_MEMORY_EXIT_FLAG_WRITE    (1ULL << 1)
+  #define KVM_MEMORY_EXIT_FLAG_EXEC     (1ULL << 2)
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
@@ -6990,6 +6993,8 @@ could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
 guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
+ - KVM_MEMORY_EXIT_FLAG_READ/WRITE/EXEC - When set, indicates that the memory
+   fault occurred on a read/write/exec access respectively.
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d5d139b0bde..5201400358da 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2372,8 +2372,15 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.gpa = gpa;
 	vcpu->run->memory_fault.size = size;
 
-	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
+
+	if (is_write)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_WRITE;
+	else if (is_exec)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_EXEC;
+	else
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_READ;
+
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b4ba4b53b834..bda5622a9c68 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -535,6 +535,9 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+#define KVM_MEMORY_EXIT_FLAG_READ       (1ULL << 0)
+#define KVM_MEMORY_EXIT_FLAG_WRITE      (1ULL << 1)
+#define KVM_MEMORY_EXIT_FLAG_EXEC       (1ULL << 2)
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
-- 
2.42.0.869.gea05f2083d-goog


