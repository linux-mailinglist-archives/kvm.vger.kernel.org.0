Return-Path: <kvm+bounces-54623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44223B257FE
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11184189C0E2
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90156301A9E;
	Wed, 13 Aug 2025 23:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIlPE/Qo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4F5301A8F;
	Wed, 13 Aug 2025 23:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129587; cv=none; b=hMrjHWGnWC/lZUwVLgXwNwTJAvtI1MPM9XDuAEkASTaF1aiDKBgE8x/9+6PvYyvE8frvmDy2ooeiprc1zGztI9fPaB9FcRVw5x/4r8smJXa7w4CqcN2jsUZtieZfj5Teh/TpOh1rxFCI4izzmo6TxzjAbi36k7ZCnIy4n6FnQL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129587; c=relaxed/simple;
	bh=kEXKic3dGl+hZ/XHZEbeEXIlQqYcgxBCNPzqY8fwb4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ridMp/a8Faxy8Yh0VH8yPDXwDq3Mu7tQtX9TYF/19j49O04G4bM3HwhwdzWnVDeBWVpt2KyyvbcIGMDtcSO06wLnblSAe032+Sc4h2P+SbaGGevKGSexQK5wY2WHo/3uUyP4GCwzOMKgaQJoMWx4qR6etBvyWa+ezjmTZ55arRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIlPE/Qo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129586; x=1786665586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kEXKic3dGl+hZ/XHZEbeEXIlQqYcgxBCNPzqY8fwb4M=;
  b=ZIlPE/QooxBanQBzDZ2pOWCQBCeTmget3ymKxPDYVVfBdfVBodlUJ7Ua
   SZEIWn60tRqjJOmUNZ8misfqSvsfDcn2XhYIR1ZHdCJE0CrYKUsM01mcT
   icvPK3QA4JRrlwNXIfTmOpwHRNOFvofL142nEuyeXxjEi3C1bSwvjRddj
   HUUGg9+mhMlyaMFMCW7LiJVnuEl3l0DMV5mDrQ65/GlvJyeSgAKMXWT+/
   6fK7ETZeVt6QnqJExphsajYyyQhRnCq0TtZLzKqI+sLxReiX8S/cq2VLi
   2MosgPBGASFZU0l6b+w89O0pwpS+qgRokXvydSK1hyO3Z9omBk+O9/U5w
   g==;
X-CSE-ConnectionGUID: l54JRZ9cQ2+sjYhargAhLw==
X-CSE-MsgGUID: occR9CWOQGmKx/1OmIlLKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014699"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014699"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:46 -0700
X-CSE-ConnectionGUID: xC/h8QFCQTGCWCZisM8PtQ==
X-CSE-MsgGUID: KUPckt4PRTGj3AeBdM+xOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105112"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:40 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH v6 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX partial write erratum
Date: Thu, 14 Aug 2025 11:59:04 +1200
Message-ID: <bc5553ebe8c8fe1fb9b78b130425471b82b56362.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755126788.git.kai.huang@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some early TDX-capable platforms have an erratum: A kernel partial
write (a write transaction of less than cacheline lands at memory
controller) to TDX private memory poisons that memory, and a subsequent
read triggers a machine check.

On those platforms, the old kernel must reset TDX private memory before
jumping to the new kernel, otherwise the new kernel may see unexpected
machine check.  Currently the kernel doesn't track which page is a TDX
private page.  For simplicity just fail kexec/kdump for those platforms.

Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
adding the check of the presence of the TDX erratum (which is only
checked for if the kernel is built with TDX host support).  This rejects
kexec/kdump when the kernel is loading the kexec/kdump kernel image.

The alternative is to reject kexec/kdump when the kernel is jumping to
the new kernel.  But for kexec this requires adding a new check (e.g.,
arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
justify because crash_kexec() is not supposed to abort.

It's feasible to further relax this limitation, i.e., only fail kexec
when TDX is actually enabled by the kernel.  But this is still a half
measure compared to resetting TDX private memory so just do the simplest
thing for now.

The impact to userspace is the users will get an error when loading the
kexec/kdump kernel image:

  kexec_load failed: Operation not supported

This might be confusing to the users, thus also print the reason in the
dmesg:

  [..] kexec: Not allowed on platform with tdx_pw_mce bug.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index dfb91091f451..15088d14904f 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -347,6 +347,22 @@ int machine_kexec_prepare(struct kimage *image)
 	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
 	int result;
 
+	/*
+	 * Some early TDX-capable platforms have an erratum.  A kernel
+	 * partial write (a write transaction of less than cacheline
+	 * lands at memory controller) to TDX private memory poisons that
+	 * memory, and a subsequent read triggers a machine check.
+	 *
+	 * On those platforms the old kernel must reset TDX private
+	 * memory before jumping to the new kernel otherwise the new
+	 * kernel may see unexpected machine check.  For simplicity
+	 * just fail kexec/kdump on those platforms.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
+		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* Setup the identity mapped 64bit page table */
 	result = init_pgtable(image, __pa(control_page));
 	if (result)
-- 
2.50.1


