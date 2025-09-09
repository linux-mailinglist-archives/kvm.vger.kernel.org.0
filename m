Return-Path: <kvm+bounces-57085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF2BB4A88C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5CEE360A05
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8220B3112D0;
	Tue,  9 Sep 2025 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQ6tERyi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BDF30EF9F;
	Tue,  9 Sep 2025 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410812; cv=none; b=mfQeBcN+3dIecpXQqOM29XVVWOOdm1mivsVReV300cQjF5e7/luhfOc/ynd/auQ93IdJt+DQCO8crb5sxytWS/m/oSGR9R9nLHkgaE/doNE04CCn9d35GRiHhNadSnSWEVQ+SVv4hen4uruzBsaE2kyI7oJpYbNIMNnpO7vKahE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410812; c=relaxed/simple;
	bh=iMNuByi8uUQXki/9D3JvgGOvtVFo5mIZNHM2fuUZcK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3sytwhbQYJovx8sGfOEhqNCj4efitKbzLGW9F0MRmeTcM7TypId5qHDTORhFOS0k8pKDeAJeDR5b907X2oeygY3tV9176UP4IEnweMUjLocvfOC9vs8Cm0T3pxsINZE4g08nA9yuBr/0XRS+VekHE76CAtaSMSENjRXfgtTMtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQ6tERyi; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410810; x=1788946810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iMNuByi8uUQXki/9D3JvgGOvtVFo5mIZNHM2fuUZcK8=;
  b=MQ6tERyiV/6zZJGQnfRgELBZCiNElSbX+2lT8kg0NrialCwNYQz3qOuL
   D+QsTDuwhRMVQJ7tPVINe4614P9xQ99D0gHHC6eDFk++V43KHn7TTQ4Rd
   xuFTGKUdHjZLmzQi+H8NJ9yEULkhYpBdAxMy1GjBHYA85a0B2xRI2mq+A
   FD/QNYpg7gbYW1FyBesAipCRdlA6rgWn5/Fa8SotBUYGh/ZhdsmElvTy+
   2nERa7gYYz9bjdXM6UCHLo0XMlZYDWSnAKfQygsmBKdN9/0qiArfq+Na6
   UrgLt7tR9nu27j9wBIIlCMubFPFmR1WTbAbjXhfLQfjA3iG6ooxpgj6/S
   g==;
X-CSE-ConnectionGUID: CLHDU/+qTiSa28DGmu/oKQ==
X-CSE-MsgGUID: Dx2wShmrTjSCfjNPK6dMgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307353"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307353"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:57 -0700
X-CSE-ConnectionGUID: vAdhzwSiTdSYkK+UVdxoTQ==
X-CSE-MsgGUID: qFUhYb5PT4mQOYvaNTuIGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207448"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:58 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 21/22] KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state
Date: Tue,  9 Sep 2025 02:39:52 -0700
Message-ID: <20250909093953.202028-22-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise new VM-Entry/Exit control bits as all nested support for
CET virtualization, including consistency checks, is in place.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index edb3b877a0f6..d7e2fb30fc1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7176,7 +7176,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7198,7 +7198,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
-- 
2.47.3


