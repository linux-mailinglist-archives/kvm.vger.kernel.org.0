Return-Path: <kvm+bounces-57066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FB8B4A863
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E52974407B5
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841322D23B1;
	Tue,  9 Sep 2025 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2FmErpi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB3E2D063C;
	Tue,  9 Sep 2025 09:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410798; cv=none; b=mQ5QWu2CtOmuUAu0kcmzGAp6vvlMWJLtCMKFlcn8288R7BeB9ADxFySip7q79jF2yYjJ/cQwk0wqoxel8E4pyzJ+yro15QJqD56uVTKV1v3+vcDsWn5fB5qonew6T8zY0RwR5840pj+SuO/yqLHDQLNpQ4axUH5O2scNjLMZujg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410798; c=relaxed/simple;
	bh=Fj8v4Hih6hXxJMbSs0FaWO11xw9VDfkLb23OVwiQtmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFaX4o+IemmHmto2ewz5wGI6HKy2+T94vLBT+i0fiCajr9dhb2emjfmbDWqyWgB9EYa4zhWfCDc1wCIDHxOxqa5Z2vqai20kkvTOpUto4S4EX2qOiVMa68vevtqvEO4u2MZIqQF3gW3aZLAojk7+mge/Vebq1bT/KjV4g+3UoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2FmErpi; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410797; x=1788946797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fj8v4Hih6hXxJMbSs0FaWO11xw9VDfkLb23OVwiQtmg=;
  b=Z2FmErpi2H1jc3B33QVvaDsz2gGegYp7ZzNl/OvUrW80/no4dRnGZd5j
   OjUsMAdL1Ul2jvkOTIco2xZ3BzFGvV3v29gs3/1RuJma7lsIpk1eXkpxD
   je6CdJALPbq1XNE2rciPEshWnPCFVwyFpVFBa/AkYkIHI55NLC1zC8qHl
   sRxLLbzO/brqobonPYXETHK+Pa6XLg/LF3cIhu+6mMQQZ4+1E7zctf9PW
   OsVCO7JZTacbngB0wiVOLxystA+UlGWcOTRFkDOEf6UOz27vIRmAi978U
   8LG/9PBhy0z74KjCYz01jlfbgGDGdrR1thFXYDDzrkZE9eOIK1YoaBMdC
   Q==;
X-CSE-ConnectionGUID: kNneRjUUStGk93vjbFAXYw==
X-CSE-MsgGUID: 7x0GRDreR2mhYHOYA8V9MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307185"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307185"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
X-CSE-ConnectionGUID: ltLyn+j9RC26luHz5KoPAA==
X-CSE-MsgGUID: vZmtrfTBSrCx4pierXEUIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207391"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
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
Subject: [PATCH v14 02/22] KVM: x86: Report XSS as to-be-saved if there are supported features
Date: Tue,  9 Sep 2025 02:39:33 -0700
Message-ID: <20250909093953.202028-3-chao.gao@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
is non-zero, i.e. KVM supports at least one XSS based feature.

Before enabling CET virtualization series, guest IA32_MSR_XSS is
guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
with XSS == 0, which equals to the effect of XSAVE/XRSTOR.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32d3edfc7b1..47b60f275fd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -335,7 +335,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
 	MSR_IA32_UMWAIT_CONTROL,
 
-	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7470,6 +7470,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
 			return;
 		break;
+	case MSR_IA32_XSS:
+		if (!kvm_caps.supported_xss)
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3


