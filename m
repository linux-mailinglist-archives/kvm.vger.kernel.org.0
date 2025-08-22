Return-Path: <kvm+bounces-55482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCAEB30FFA
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1C0B173D64
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E443F2E7BC6;
	Fri, 22 Aug 2025 07:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PiBVN39Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAE02E62B5;
	Fri, 22 Aug 2025 07:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846368; cv=none; b=GPsbgo7sju+tb5D76Uv1umLxOZpFyH2onQQsmlcTvt166ZKBKOei28vcnwJdQlmyhuKbVcef+xjHcC6ymO4HWoAF0eMo7bwZExWjbVnH+Lq3cTrv7i7eqI5bfHNVybdb4dIsYidrszozRyQDAJoPZcsVG8ZyME8FEv7x3CvAWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846368; c=relaxed/simple;
	bh=0LFBzy/1ND4vvMfeYVthXvze9VjxghC/baD6CkbxVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYKBWcAM+YHPu7KVUtOXMVSHvLEaTplz6Z+CCgKsfDXoSrxkyxvhBgfZx4/iB98114foEuMmEGfnizMTE0oe56xPxvqGP+uJSbz4DtHDI2SYKa3xqxQ/+oFPYtcKBNCQ2vqdF6fGqq96ruCcLD5iKXaj95UGgIa5z6HHyVGROwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PiBVN39Z; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755846366; x=1787382366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0LFBzy/1ND4vvMfeYVthXvze9VjxghC/baD6CkbxVpg=;
  b=PiBVN39ZFZGiSDS9hxw7QDG2kqM+xdtHnrVO44SSTZrioTnk/Cw+NBXo
   maMIArXgBk+gJx5E4PcQ0TCfxO4/oP16AW5dVYTUT5ByITMbAfuMU3GIV
   jN7hmWXBTVIKfMZdnS5pFPCmaeYEIGpKo7q8lkFXmaX6u8jqDUVBl4NY6
   hhZcDLZN1dC4SrTGi7jfoFf1yBxZ8mP+iUpX8H2Y38uIvjE9tZzHHd5Wb
   KH3TgvH+OJQCJAkcsOpWLhzEb0RpNpFLW6nvJlkmKapinBuNS7CJ2Vue+
   xWe4EjGZKzIQWPxSjlD+RdHXi5frfZf87OdMlEIOzkuDEv7Fm2LUsrlxF
   A==;
X-CSE-ConnectionGUID: R2BNde0AR7iy5Ff7eF6HoA==
X-CSE-MsgGUID: XDkBM5vRTI2eEj9li0V8Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58012896"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58012896"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:06:05 -0700
X-CSE-ConnectionGUID: wg4jZzJKQ1yxQKl/rSFcww==
X-CSE-MsgGUID: tdrdyDRTSsiLdv40MP81iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168143631"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:06:03 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/3] KVM: TDX: Do not retry locally when the retry is caused by invalid memslot
Date: Fri, 22 Aug 2025 15:05:23 +0800
Message-ID: <20250822070523.26495-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822070305.26427-1-yan.y.zhao@intel.com>
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Avoid local retries within the TDX EPT violation handler if a retry is
triggered by faulting in an invalid memslot, indicating that the memslot is
undergoing a removal process.

This prevents the slot removal process from being blocked while waiting for
the VMExit handler to release the SRCU lock.

Opportunistically, export symbol kvm_vcpu_gfn_to_memslot() to allow for
per-vCPU acceleration of gfn_to_memslot translation.

[Yan: Wrote patch log, comment, fixed a minor error, function export]

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
 virt/kvm/kvm_main.c    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6784aaaced87..de2c4bb36069 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1992,6 +1992,11 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * blocked by TDs, false positives are inevitable i.e., KVM may re-enter
 	 * the guest even if the IRQ/NMI can't be delivered.
 	 *
+	 * Breaking out of the local retries if a retry is caused by faulting
+	 * in an invalid memslot (indicating the slot is under removal), so that
+	 * the slot removal will not be blocked due to waiting for releasing
+	 * SRCU lock in the VMExit handler.
+	 *
 	 * Note: even without breaking out of local retries, zero-step
 	 * mitigation may still occur due to
 	 * - invoking of TDH.VP.ENTER after KVM_EXIT_MEMORY_FAULT,
@@ -2002,6 +2007,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * handle retries locally in their EPT violation handlers.
 	 */
 	while (1) {
+		struct kvm_memory_slot *slot;
+
 		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
 
 		if (ret != RET_PF_RETRY || !local_retry)
@@ -2015,6 +2022,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
+		if (slot && slot->flags & KVM_MEMSLOT_INVALID)
+			break;
+
 		cond_resched();
 	}
 	return ret;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..f769d1dccc21 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2661,6 +2661,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.43.2


