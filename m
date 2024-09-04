Return-Path: <kvm+bounces-25823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BECEF96AF17
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7523A1F25DE0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7A913D297;
	Wed,  4 Sep 2024 03:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IESJHrnE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03A113213C;
	Wed,  4 Sep 2024 03:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419684; cv=none; b=G6cv+SMDdzIicLbTRNz/A5y0LlIIjE0LAr2t43SPK6wInoJ/ZkkVOKzaOeyifuUeARk5dpZys8YNz8HPmrZwbnYBozTv7sL45aercLEcpPD0lv3AEOhR06r1BPj9wGF8BONQyTpBxKXiMjDjPgnMyYVB7sVK/C1B2GDSNAVeoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419684; c=relaxed/simple;
	bh=d0oDl1sG8BMASTdCO/CxO7ARHn2ISwq2R/yNIapUptI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bNqmvY+xiaCwI5JMyQXKuObrYEojaKC3k3heYXeTeix7k+VFZLuPvJXA33PkfERV6FnTv0/i9iWMJryokiVU+fO+ywTF4CS8UrnECEZYkdy2D8yyd84MnBIQCXtV6dzLZamxYflqrfPfk7aQbpPBgItDH4HstRZI6m8IMzaSH08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IESJHrnE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419681; x=1756955681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d0oDl1sG8BMASTdCO/CxO7ARHn2ISwq2R/yNIapUptI=;
  b=IESJHrnEkNwFvAPQ2uFLktEXdMAvuXF5k2rSJhi7PuQGVdtxSH5K1fkc
   P7QX9IUQaoDl6O3EmCM+OV1NvDjxVeLXS6QuFRw7oU53QhOy31pDbVdD1
   nY4gSLOBqsKszwfvJk9QHq83GrmOPmdpxOQ4cjoHYzqiyo575LoR+pJUF
   hSlkKUjnMu4Qv87lFDR8JNnNcEuXGDw13uisGCb6ERlszRImf0YGXPEKG
   3CRbP7rQ3Pv1b66SXzfhaHuQO6NXPoScHC34Hns+0ZWebF6KuxfYQ+MLp
   UqeMM6SOBWMITfPEZhTqSEmoxbO5DD9PwvVyVfj5aXY3+NLNoyNhAQUGW
   Q==;
X-CSE-ConnectionGUID: pjjRD9m9SOmhoqZxFra8Ug==
X-CSE-MsgGUID: FyzFPjiGTBahVUyVqyTrEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564721"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564721"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:11 -0700
X-CSE-ConnectionGUID: ksDleisLR8SMl+QPSHVQ+A==
X-CSE-MsgGUID: i2gq4rBVRYK7Q8BbEdpkhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106367"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:11 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 18/21] KVM: x86/mmu: Export kvm_tdp_map_page()
Date: Tue,  3 Sep 2024 20:07:48 -0700
Message-Id: <20240904030751.117579-19-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In future changes coco specific code will need to call kvm_tdp_map_page()
from within their respective gmem_post_populate() callbacks. Export it
so this can be done from vendor specific code. Since kvm_mmu_reload()
will be needed for this operation, export it as well.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d26b235d8f84..1a7965cfa08e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4754,6 +4754,7 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
@@ -5776,6 +5777,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-- 
2.34.1


