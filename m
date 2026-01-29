Return-Path: <kvm+bounces-69494-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBjbEB23emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69494-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F91AAB35
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBF1530BD890
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB59E33A6E0;
	Thu, 29 Jan 2026 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MzDw42XP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0C378D6D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649410; cv=none; b=XWIT0gmdDlF69MJe8P77awxyNHodiQplc7r6I9OhjMe7akXiwgTUjNScFyvttEgM2PfzrjRKQ7136GUHr3sadWF58mI9Q+w4YD4SGMjzeH+/42gzsW++fwKFSIsj+RyHt5WSTrNGAA+ZO9zocusP77kVyHUJ4GQoe0xymVpmTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649410; c=relaxed/simple;
	bh=NFixUjF3MwoYkH+QN/YHmqd9LbNtFdN+U0RPFkdel4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UsoNQAXTpoKyPBjFFOwRD/924OMpwnLQ3E/2/wEj8M2xQbJXetezuJqTo+s3wRW32jAWTCrlFiRCMlkzncwHE9y/NusLswaqd0YXCdtxLqZvA+BD40w40Eu0A36MmfjohT8IDAknvoba9GFepZ/fw2FF9vjYCafIqEo/sgrBabg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MzDw42XP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c38781efcso369205a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649408; x=1770254208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UsNtWhNO0vhkCUAU93bPMBDIA0a/SH6YuHE+/bCD4zo=;
        b=MzDw42XP4OeqhyRho5tVL44TcTjVpEWc2zaS/MNoTUt05mQd3pmd2/G+2oUIw9/dV3
         7zktCZ0uF1m97EKQC2h1xCT4r6xxrzOjk1Lhb0qbSHPk+XnhmF4NPvM2sEAoGJQlj0JM
         emiZ4QcLNIzVqwt3XUcaT0jXB4933aHSSRO5xbnsgLmhFWP281Y8vJllgkdLhcx0huL2
         wK15KuRhixaKVHlvRRW9QuMZ5D4vBXYI1aTR6tilQUR+5Dth9bescmvQ7QYMpiPW2OrP
         FVOIJVEaLQU2UnUZ23OhhWwgcabR16qXsp23Xqb9XKw1rtqapIQEsr4hffBrkWoTf8qx
         l0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649408; x=1770254208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UsNtWhNO0vhkCUAU93bPMBDIA0a/SH6YuHE+/bCD4zo=;
        b=DWKyk9QobTpQmCKeMO6vlEV90Ud+sxOrpUvSxlMLzmJTJH5OvAuMPcBtjfAwE4k8Eq
         LBI69rIjEUdxBKT/oZjoh0k5FNTJVCnzWTlAGHO6Mm1gk0v4V47oYDyXboYgODIQrB5b
         40lR665nI5zu7yusOf2oyz7aR9GcGXEk3WFwXZ7OuzocpFBcd+DRlNrRfV9jNtQyyqTp
         VUU+vfG81JwZMWqLc8tZTQAJFLYghrF3iHEOmz0oNhB3Q+OUGYahRXlKvUVqJMo59qHM
         6nAqJxtjK1fCm/C8EbCqfd795vlGSO47+CA2MCF4JM2y7slzW7Q/+6AvphhJ2KyftGOC
         RRMw==
X-Forwarded-Encrypted: i=1; AJvYcCX5l7XlZN4y3HziNr1qq+ulYfH3H7A4Q8KvPV1mWG9CKGRdZEAtc/GLsHbsZDbzPpMsf+s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyih1vNriUwv/l1PQVYLk1mkxDOaqNlPAUSZqqocv8Ga/8+/1U
	5G4hWI3jmq5Vcj5hO/Z8/7zm8cnJkBtQTPsfJSCd7vK8jUFTbSZF14fGjImx5YI9Yd8jufWXTPs
	Nq0BAmA==
X-Received: from pjbga13.prod.google.com ([2002:a17:90b:38d:b0:349:3867:ccc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d19:b0:366:14ac:e20f
 with SMTP id adf61e73a8af0-38ec6581747mr6919458637.77.1769649408354; Wed, 28
 Jan 2026 17:16:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:15 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-44-seanjc@google.com>
Subject: [RFC PATCH v5 43/45] *** DO NOT MERGE *** KVM: guest_memfd: Add
 pre-zap arch hook for shared<=>private conversion
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69494-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B5F91AAB35
X-Rspamd-Action: no action

Add a gmem "pre-zap" hook to allow arch code to take action before a
shared<=>private conversion, and just as importantly, to let arch code
reject/fail a conversion, e.g. if the conversion requires new page tables
and KVM hits in OOM situation.

The new hook will be used by TDX to split hugepages as necessary to avoid
overzapping PTEs, which for all intents and purposes corrupts guest data
for TDX VMs (memory is wiped when private PTEs are removed).

TODO: Wire this up the convert path, not the PUNCH_HOLE path, once in-place
      conversion is supported.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig       |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c |  8 ++++++
 include/linux/kvm_host.h   |  5 ++++
 virt/kvm/Kconfig           |  4 +++
 virt/kvm/guest_memfd.c     | 50 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d916bd766c94..5f8d8daf4289 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -138,6 +138,7 @@ config KVM_INTEL_TDX
 	depends on INTEL_TDX_HOST
 	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
+	select HAVE_KVM_ARCH_GMEM_CONVERT
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0cdc6782e508..c46ebdacdb50 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1630,6 +1630,14 @@ int kvm_tdp_mmu_split_huge_pages(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_split_huge_pages);
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
+			  bool to_private)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT */
+
 static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 782f4d670793..c0bafff274b6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2588,6 +2588,11 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
 		       kvm_gmem_populate_cb post_populate, void *opaque);
 #endif
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
+			  bool to_private);
+#endif
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 267c7369c765..05d69eaa50ae 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -125,3 +125,7 @@ config HAVE_KVM_ARCH_GMEM_INVALIDATE
 config HAVE_KVM_ARCH_GMEM_POPULATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_GMEM_CONVERT
+       bool
+       depends on KVM_GUEST_MEMFD
\ No newline at end of file
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 51dbb309188f..b01f333a5e95 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -164,6 +164,46 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+static int __kvm_gmem_convert(struct gmem_file *f, pgoff_t start, pgoff_t end,
+			      bool to_private)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long index;
+	int r;
+
+	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
+		r = kvm_arch_gmem_convert(f->kvm,
+					  kvm_gmem_get_start_gfn(slot, start),
+					  kvm_gmem_get_end_gfn(slot, end),
+					  to_private);
+		if (r)
+			return r;
+	}
+	return 0;
+}
+
+static int kvm_gmem_convert(struct inode *inode, pgoff_t start, pgoff_t end,
+			    bool to_private)
+{
+	struct gmem_file *f;
+	int r;
+
+	kvm_gmem_for_each_file(f, inode->i_mapping) {
+		r = __kvm_gmem_convert(f, start, end, to_private);
+		if (r)
+			return r;
+	}
+	return 0;
+}
+#else
+static int kvm_gmem_convert(struct inode *inode, pgoff_t start, pgoff_t end,
+			    bool to_private)
+{
+	return 0;
+}
+#endif
+
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
@@ -244,6 +284,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
+	int r;
 
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end
@@ -253,13 +294,18 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_begin(inode, start, end);
 
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	/*
+	 * For demonstration purposes, pretend this is a private=>shared conversion.
+	 */
+	r = kvm_gmem_convert(inode, start, end, false);
+	if (!r)
+		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
 	kvm_gmem_invalidate_end(inode, start, end);
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
-	return 0;
+	return r;
 }
 
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
-- 
2.53.0.rc1.217.geba53bf80e-goog


