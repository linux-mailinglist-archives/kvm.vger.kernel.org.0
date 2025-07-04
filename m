Return-Path: <kvm+bounces-51590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EBADAF8CFA
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB4651C45868
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D98D2F6F80;
	Fri,  4 Jul 2025 08:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VBbPmMdY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF082F5315;
	Fri,  4 Jul 2025 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619055; cv=none; b=m+EhnBevjn9LIBTkaKLhogiadYl2ux4eB3tijiRFGwap6bWKw5B4sN0hJSu+iMnJvFSSyw0nWKqV6c51LBlAs1NJPANoz2s9722ENd3NF739IdM+EteJtSDR8JSSYO+bgpBXRMyL9dcQnjfbchcOvh6rwRJ0zugwbkGhsTDX/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619055; c=relaxed/simple;
	bh=tsiHOXD2vsdLipYj+KaxJZCa99FFtyETrcYwCjDN4Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/+x12HX+MRV+ftkZdiFSA893/x/JHOdu2Z3Y0pHhh89jF11nm8tokSoW0UaBN1rIRS+qjihSjIyuE/Dmd0sWKgD4l7Z4B4ZshqX+CM/vsTVQAGD+RQvVLGUcIj0/Tuz6zGmXEHwRXx2fNOycM4vfw6A4ZlqDv24mVbGRxl1tT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VBbPmMdY; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619054; x=1783155054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tsiHOXD2vsdLipYj+KaxJZCa99FFtyETrcYwCjDN4Yc=;
  b=VBbPmMdY/3liO/tEoptjUeru4yxvvW6xxkCgglONJ8SNDE80kG8LA4wh
   c7/Zf8lxrfflmLSQCUMnequl++3c5LPpois2uA6ozBqEoIWNslwqNKhjG
   SH2ju8uYltLlAX9Ex4FUOTJqOIBMydg4xZlNXR/7blBbBbBEqbrGBU0Ve
   RK+YE4oOLkg1mFOZ3PTGNH15UhdmlBk6ICkCESiFqmrhhfAJhM5KhFhrg
   2kQvqiCr4tbofLwiP7zXoWeR5inlgWfKVCcUwhNCaqiTRUjMJUiQTUATZ
   xWVklz/xvQGrAPdLpVcp/tGzbdB1dgrPsYjWnhpVBmTZIGy8qEExJsnJl
   Q==;
X-CSE-ConnectionGUID: RTBs4vbzSIeDlLVvqBQ+pA==
X-CSE-MsgGUID: AdXe6q8dQOGwDi8YuTLP+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391786"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391786"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:46 -0700
X-CSE-ConnectionGUID: 5qJJQPcSQamfvKKl/Y8Qjg==
X-CSE-MsgGUID: NJtkEjEoR+aCFTVs1kXk9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154722025"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:46 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 22/23] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
Date: Fri,  4 Jul 2025 01:49:53 -0700
Message-ID: <20250704085027.182163-23-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
area in the VMCS12. This ensures that configurations with CR4.CET set and
CR0.WP not set result in VM-entry failure, aligning with architectural
behavior.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3e6f7b4fc374..362e241a2cbb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3108,6 +3108,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
+	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
 	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
@@ -3222,6 +3225,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
 	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
 	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-- 
2.47.1


