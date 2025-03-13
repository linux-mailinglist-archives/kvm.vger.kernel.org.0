Return-Path: <kvm+bounces-40984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A470CA60141
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC7ED42028E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D67C1F4614;
	Thu, 13 Mar 2025 19:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bac5Zrmj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCF71F30A8;
	Thu, 13 Mar 2025 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741894235; cv=none; b=KJCgxOWIi8hCiVqHjIa+z99NKWlCSF0/s4R0VrabYtikMOmG51wu2Rb/9oNA4NRn9f7hnNTlRisGSfrJeNrUDxUTVsemPCcQ3RlJS9qS8TVC2PPurkEa54tspohlSAvB4vNrAivgIihJBwrl16G6AFGD15a0IoFqaZqbHYC4YY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741894235; c=relaxed/simple;
	bh=R/nwEuUO6VXcXYOWii2gV/kZVgWoprf8O+FmFkrqFuI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NyyMgFYOCia/AgW03NMyAYJvxk4obXxX7031YEGVPeyrP8/q+IQwTlp/Ae8XD/ni+hvuyfAUhShHM8auYzOed3K91z9bNPfHrJfymXpxVYycKj0Z4ozkoKE2gQmEH+T+ljcOdqXkajpuMumcuY57RiIwTT5Xg/HKJOTdMNk3sNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bac5Zrmj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741894232; x=1773430232;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=R/nwEuUO6VXcXYOWii2gV/kZVgWoprf8O+FmFkrqFuI=;
  b=bac5Zrmjhj6yLTfOIJkoptPndSrRDQT2LZ74IV73nkaYfwhnsXcOE+CG
   j5LijA0uYnrjwn5GO5Vr0m/1A3FzHR17E93RAFfecIJp3W1QCgz9NE18g
   1m+eE+0b5jxC1MBHWIN6sNaLhwY3Bwf1uCao0+ObAhdW4BXfzgrEjpob5
   wdLMUDFoabhcvMcZ0MyJG/hiHZmhBmbCv/dpOV9smmbmCSkIeCi7/oNn1
   kQoAud4oE7GfQS4R46OWoItiWK7xuv2TxpRxpIeWnWeQTzMuWBvZUOMrO
   4qlpLGiphzqKoId1r7HWT5rFKT/4T9OYbhom/KXYrbb5R7IE77xSbId4i
   Q==;
X-CSE-ConnectionGUID: fcGs4j0mSbSs7URjX+jeMg==
X-CSE-MsgGUID: +n/ro7ddQweEB++G313S4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43237121"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="43237121"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:29 -0700
X-CSE-ConnectionGUID: KaUv7VIzR8aJuhVL1P/8eg==
X-CSE-MsgGUID: oz3+vXOqQgiZnbWkz0qpag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="151988222"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.108.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:29 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 13 Mar 2025 13:30:03 -0600
Subject: [PATCH 3/4] KVM: VMX: Make naming consistent for
 kvm_complete_insn_gp via define
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-vverma7-cleanup_x86_ops-v1-3-0346c8211a0c@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
In-Reply-To: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=R/nwEuUO6VXcXYOWii2gV/kZVgWoprf8O+FmFkrqFuI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOmXjYL5P7vvvGkZkv2k7KtwWfU8n5R4t8L+RxzhZ2MPJ
 tsayx7oKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwEQWLWf4zeJdO3mW9dffB/9U
 dctd39sxt+VEtaUR85wEYb2PPFEsJxgZjm72Wdx7fEGB0403XtMKOPTbF/A/dIzLitz9+srazZJ
 8TAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for defining x86_ops using macros, make the naming of
kvm_complete_insn_gp() in the non TDX case more consistent with other
vmx_ops - i.e. use a #define to allow it to be referred as
vmx_complete_emulated_msr().

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kvm/vmx/x86_ops.h | 1 +
 arch/x86/kvm/vmx/main.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 4704bed033b1..112dabce83aa 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,6 +58,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 int vmx_get_feature_msr(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+#define vmx_complete_emulated_msr kvm_complete_insn_gp
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ccb81a8b73f7..e46005c81e5f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -239,7 +239,7 @@ static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (is_td_vcpu(vcpu))
 		return tdx_complete_emulated_msr(vcpu, err);
 
-	return kvm_complete_insn_gp(vcpu, err);
+	return vmx_complete_emulated_msr(vcpu, err);
 }
 
 #ifdef CONFIG_KVM_SMM

-- 
2.48.1


