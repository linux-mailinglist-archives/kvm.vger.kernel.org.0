Return-Path: <kvm+bounces-61250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B05C1229F
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 12AF14EF4FE
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4171F5435;
	Tue, 28 Oct 2025 00:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbYjObmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1186B1DEFE8;
	Tue, 28 Oct 2025 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611315; cv=none; b=Y94uRuHp6MxiF2KuNv11FK/3i0u3Lz8UTDKHKbaASun77RhnQjvouJvyiMr+Js3ENq91PQ/1IzSr57wztquHpnfDJndu+Cj8wg73WQsZDcREi0XCBZ1IIC3j86oIkC/sKZo8xUkjoRDqgcivXMIDs1iqQjPbzb4xytzETEwhPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611315; c=relaxed/simple;
	bh=O9r9SqoXgXXFWNnj6936GGaEnFwZ1KbD5C04lY3OlKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJSdTUX0I9NOINvIVba2Gv8iRbx9MSboTdhSXPofQKsx170bWVUw4KUcSyZ2iNgG8JhZbv0d3ocZRku0c4RbRqrSTMNJv0qO/DcmKGxkW1DKR6HrsRCDSCAa/osRhz4dopslabSOrjCW5MZI6dOb/KEHtu6R7reDgD07bzN2+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbYjObmZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761611314; x=1793147314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O9r9SqoXgXXFWNnj6936GGaEnFwZ1KbD5C04lY3OlKM=;
  b=RbYjObmZKXBJdSRuwfmkCmPx+mi3qLxxaAyMe4c3KeYAMYe3eza1AAtL
   R3pFlN012+MMRUl1p6TFuPjGoQrRhLzAdEYfULcgyHExu57D6eZhpI2ej
   ThQm1udRITMOWc2kIxZZ2tDNiqLEkVPlAIW7Amc+Pu+ElUWJ29sszqoWM
   lDXO2Dnssei/Fkx6aFeKDS7QblEtkXe/dFtW+VMPCljFCgLSDGKiJViv1
   nGp7xUZlSfwp9+yWe9ZxwBa+hhpLGBeuLeC66LjZHh2qpzJEQklKbmD/I
   eUSxSUULMj7yLwnZHn6kaQTb32e0DVS7bk0WJ8IyPaTvzobkiDGEq01kw
   A==;
X-CSE-ConnectionGUID: 905TVoovRh6Q/iCVa9/rCQ==
X-CSE-MsgGUID: WsQAij2wSFKlRkaeb64XTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81334624"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="81334624"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:28:33 -0700
X-CSE-ConnectionGUID: MtsX8J75QwO7JVf7pLQ1Rw==
X-CSE-MsgGUID: sxeH5MnIQqC0pE4YKx+1fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="222400872"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:28:32 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com
Cc: ackerleytng@google.com,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	binbin.wu@linux.intel.com,
	borntraeger@linux.ibm.com,
	chenhuacai@kernel.org,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	maddy@linux.ibm.com,
	maobibo@loongson.cn,
	maz@kernel.org,
	michael.roth@amd.com,
	oliver.upton@linux.dev,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org,
	rick.p.edgecombe@intel.com,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	zhaotianrui@loongson.cn
Subject: [PATCH] KVM: TDX: Take MMU lock around tdh_vp_init()
Date: Mon, 27 Oct 2025 17:28:24 -0700
Message-ID: <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <aP-1qlTkmFUgTld-@google.com>
References: <aP-1qlTkmFUgTld-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Take MMU lock around tdh_vp_init() in KVM_TDX_INIT_VCPU to prevent
meeting contention during retries in some no-fail MMU paths.

The TDX module takes various try-locks internally, which can cause
SEAMCALLs to return an error code when contention is met. Dealing with
an error in some of the MMU paths that make SEAMCALLs is not straight
forward, so KVM takes steps to ensure that these will meet no contention
during a single BUSY error retry. The whole scheme relies on KVM to take
appropriate steps to avoid making any SEAMCALLs that could contend while
the retry is happening.

Unfortunately, there is a case where contention could be met if userspace
does something unusual. Specifically, hole punching a gmem fd while
initializing the TD vCPU. The impact would be triggering a KVM_BUG_ON().

The resource being contended is called the "TDR resource" in TDX docs 
parlance. The tdh_vp_init() can take this resource as exclusive if the 
'version' passed is 1, which happens to be version the kernel passes. The 
various MMU operations (tdh_mem_range_block(), tdh_mem_track() and 
tdh_mem_page_remove()) take it as shared.

There isn't a KVM lock that maps conceptually and in a lock order friendly 
way to the TDR lock. So to minimize infrastructure, just take MMU lock 
around tdh_vp_init(). This makes the operations we care about mutually 
exclusive. Since the other operations are under a write mmu_lock, the code 
could just take the lock for read, however this is weirdly inverted from 
the actual underlying resource being contended. Since this is covering an 
edge case that shouldn't be hit in normal usage, be a little less weird 
and take the mmu_lock for write around the call.

Fixes: 02ab57707bdb ("KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table")
Reported-by: Yan Zhao <yan.y.zhao@intel.com>
Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
Hi,

It was indeed awkward, as Sean must have sniffed. But seems ok enough to
close the issue.

Yan, can you give it a look?

Posted here, but applies on top of this series.

Thanks,

Rick
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index daec88d4b88d..8bf5d2624152 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2938,9 +2938,18 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		}
 	}
 
-	err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
-	if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
-		return -EIO;
+	/*
+	 * tdh_vp_init() can take a exclusive lock of the TDR resource inside
+	 * the TDX module. This resource is also taken as shared in several
+	 * no-fail MMU paths, which could return TDX_OPERAND_BUSY on contention.
+	 * A read lock here would be enough to exclude the contention, but take
+	 * a write lock to avoid the weird inversion.
+	 */
+	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
+		err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
+		if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
+			return -EIO;
+	}
 
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-- 
2.51.1


