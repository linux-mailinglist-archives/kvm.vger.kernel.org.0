Return-Path: <kvm+bounces-67125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEE0CF822C
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C926431408D4
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E42331A42;
	Tue,  6 Jan 2026 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WwYV/NKd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D6533122D;
	Tue,  6 Jan 2026 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695096; cv=none; b=FaJ4TRLJSrOzihWpC/uPTdsYENlZoBnOnxjSI6KeDgIlUhRTuZ+JvcCgSBefCvBMXGTqx8vJKTIwozElEmN2DE8c5INfSzyf99GOmpMoxiskMebpSJbnZnROkFZPuHHWTi7OHAJwuo0CzsJJKAocuECbPXcaClLadRg8/SDnGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695096; c=relaxed/simple;
	bh=4ml7WsyFlngxKSf5JvOWbQKUiTbUj6eH/V5cMjcRqcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnkZq4CdcKYzsTI9YqzN9kGnRDEG4OcEF6xt8Y0SmJse0BKbVvbt+2aqmOXnXQnigjdhTsEgwH2HaKV83tMsi4Mdeb8PBlM0SZPTu5mDULwuxddk0h2cPhmigaNeG3PTIPWf3a38/bzizH+An+cE+iH8fkfjJvKXeTDLf7QcU2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WwYV/NKd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695093; x=1799231093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ml7WsyFlngxKSf5JvOWbQKUiTbUj6eH/V5cMjcRqcU=;
  b=WwYV/NKdcXEaWnTa+jWPLNNNStdVioGqaZI1KA39L5rvjc558Yn8nTuj
   CDkYdxgYZrCMgDPLKxf/V5njs8eEGuT0gEr1hOOb8mYBX5TDSyb8dh0XQ
   rFhOnkHScWBMSdArBmPqVfpBbQUWLIPAcaO5Ftjt0ToTrMIMPrrYU3in3
   V804/nka5obwSVXd5fGwmoDiXA7AMj0yOgA6w8XDg1cCmXg9H7+W31Y86
   nCAtqZUD+x0CbsttVJ3NYhIuVEZkgTMzGoMy0kWdfY0mFke6yWhPo7Y2f
   OAGtGQEhTPJ5U1b50OAfdTJIGey4I6d6ehCj7uGvvCyOdcVpcS40b8Iq9
   g==;
X-CSE-ConnectionGUID: o+IzO1hySG67eV4FVu3c5A==
X-CSE-MsgGUID: PmQnvXcZT7yITUrmcKHOkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80427399"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80427399"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:52 -0800
X-CSE-ConnectionGUID: 77UUouFeSpCgozuCMjOCeA==
X-CSE-MsgGUID: IDWJSDqzSqiZh0SFaZn13w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202681611"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:48 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 16/24] KVM: guest_memfd: Split for punch hole and private-to-shared conversion
Date: Tue,  6 Jan 2026 18:22:50 +0800
Message-ID: <20260106102250.25194-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In TDX, private page tables require precise zapping because faulting back
the zapped mappings necessitates guest re-acceptance. Therefore, before
performing a zap for hole punching and private-to-shared conversions, huge
leaves that cross the boundary of the zapping GFN range in the mirror page
table must be split.

Splitting may fail (usually due to out of memory). If this happens, hole
punching and private-to-shared conversion should bail out early and return
an error to userspace.

Splitting is not necessary for zapping shared mappings or zapping in
kvm_gmem_release()/kvm_gmem_error_folio(). The penalty of zapping more
shared mappings than necessary is minimal. All mappings are zapped in
kvm_gmem_release(). kvm_gmem_error_folio() zaps the entire folio range, and
KVM's basic assumption is that a huge mapping must have a single backend
folio.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rebased to [2].
- Do not flush TLB for kvm_split_cross_boundary_leafs(), i.e., only flush
  TLB if zaps are performed.

[2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25

RFC v2:
- Rebased to [1]. As changes in this patch are gmem specific, they may need
  to be updated if the implementation in [1] changes.
- Update kvm_split_boundary_leafs() to kvm_split_cross_boundary_leafs() and
  invoke it before kvm_gmem_punch_hole() and private-to-shared conversion.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/

RFC v1:
- new patch.
---
 virt/kvm/guest_memfd.c | 67 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 03613b791728..8e7fbed57a20 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -486,6 +486,55 @@ static int merge_truncate_range(struct inode *inode, pgoff_t start,
 	return ret;
 }
 
+static int __kvm_gmem_split_private(struct gmem_file *f, pgoff_t start, pgoff_t end)
+{
+	enum kvm_gfn_range_filter attr_filter = KVM_FILTER_PRIVATE;
+
+	bool locked = false;
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = f->kvm;
+	unsigned long index;
+	int ret = 0;
+
+	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
+		pgoff_t pgoff = slot->gmem.pgoff;
+		struct kvm_gfn_range gfn_range = {
+			.start = slot->base_gfn + max(pgoff, start) - pgoff,
+			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
+			.slot = slot,
+			.may_block = true,
+			.attr_filter = attr_filter,
+		};
+
+		if (!locked) {
+			KVM_MMU_LOCK(kvm);
+			locked = true;
+		}
+
+		ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
+		if (ret)
+			break;
+	}
+
+	if (locked)
+		KVM_MMU_UNLOCK(kvm);
+
+	return ret;
+}
+
+static int kvm_gmem_split_private(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct gmem_file *f;
+	int r = 0;
+
+	kvm_gmem_for_each_file(f, inode->i_mapping) {
+		r = __kvm_gmem_split_private(f, start, end);
+		if (r)
+			break;
+	}
+	return r;
+}
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	pgoff_t start = offset >> PAGE_SHIFT;
@@ -499,6 +548,13 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	filemap_invalidate_lock(inode->i_mapping);
 
 	kvm_gmem_invalidate_begin(inode, start, end);
+
+	ret = kvm_gmem_split_private(inode, start, end);
+	if (ret) {
+		kvm_gmem_invalidate_end(inode, start, end);
+		filemap_invalidate_unlock(inode->i_mapping);
+		return ret;
+	}
 	kvm_gmem_zap(inode, start, end);
 
 	ret = merge_truncate_range(inode, start, len >> PAGE_SHIFT, true);
@@ -907,6 +963,17 @@ static int kvm_gmem_convert(struct inode *inode, pgoff_t start,
 	invalidate_start = kvm_gmem_compute_invalidate_start(inode, start);
 	invalidate_end = kvm_gmem_compute_invalidate_end(inode, end);
 	kvm_gmem_invalidate_begin(inode, invalidate_start, invalidate_end);
+
+	if (!to_private) {
+		r = kvm_gmem_split_private(inode, start, end);
+		if (r) {
+			*err_index = start;
+			mas_destroy(&mas);
+			kvm_gmem_invalidate_end(inode, invalidate_start, invalidate_end);
+			return r;
+		}
+	}
+
 	kvm_gmem_zap(inode, start, end);
 	kvm_gmem_invalidate_end(inode, invalidate_start, invalidate_end);
 
-- 
2.43.2


