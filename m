Return-Path: <kvm+bounces-51573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E29AF8CCE
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0140174FCE
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100082ECE92;
	Fri,  4 Jul 2025 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4x1kEnh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CA628AAFD;
	Fri,  4 Jul 2025 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619044; cv=none; b=OGRkfLFFFNjnaKj8QAJy8+C0hIWOYALRqWypTy3l4PW7txlEn0G5dl7HZF7VhvWWjIc7CMsn7a7XSNarApQnkrcCwmXkKogDwKhaf9nMDY1ZeXRZdXzqoFDnr/7EK1BUhg6kLkutz+N7jf6g38ezlrpDHHp+sQ5ucPVI31Zu3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619044; c=relaxed/simple;
	bh=ifzlJJKzrjxhYiLcpEpRceqDjDzk47bgjX3b0+sae5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARW4gCTnOlQy92nxBksKPkJcalWhk8Q13SyANSryx6XEdiZjPUS9UVbWDRRzQ+8OWXX3cSX0xzHf0MhAxvImajy/5EZrwdlpZpk2R4nRkdJHnkcAxb/qguRhWgjLg3uhEQUvysctigN0/RSsmkNKdysUUQPXfOdO31Hia/CaAjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4x1kEnh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619041; x=1783155041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifzlJJKzrjxhYiLcpEpRceqDjDzk47bgjX3b0+sae5o=;
  b=Y4x1kEnhO2weS3i373P7TWdPcHQ1vAUdNAjYuhHFJHfnUre1Cr+K3jGH
   +4aoVHyTHN1wsGMKjtNSZvauDKPhI3h1445nsXPHwPlXAlibjrS31sWZE
   uVIXkFBn6etrFYa7f+qXD6NCpmkVLTm74Rf0h/f+GiKHQtLwGHcbMSxsS
   R0Y1/G0jt5XkhWo+UP52W633HcfDVLaGGCf7cpah6/zkNcYMmusUeiSQA
   iRcpDZ6utTTn014U008U2HbbPiWjBXh0w34P0V85fzI3lO2dB2Eerj9aT
   JPu94K8Y4AK1BtAcnbGfPMS0NZ/PFFLfPWP2GO3nvVYIq/HhC1GSmqLFJ
   Q==;
X-CSE-ConnectionGUID: h9yg3Tb8TZWx6pcFpYGBPA==
X-CSE-MsgGUID: yNHiwfF0Q9SGFpQjz4ynOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391617"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391617"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:37 -0700
X-CSE-ConnectionGUID: HgmLjA+DTk+qVTdwh7H8XQ==
X-CSE-MsgGUID: gsQz7G8vTGq7qZlVkRYXlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721962"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:37 -0700
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
Subject: [PATCH v11 06/23] KVM: x86: Report XSS as to-be-saved if there are supported features
Date: Fri,  4 Jul 2025 01:49:37 -0700
Message-ID: <20250704085027.182163-7-chao.gao@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
is non-zero, i.e. KVM supports at least one XSS based feature.

Before enabling CET virtualization series, guest IA32_MSR_XSS is
guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
with XSS == 0, which equals to the effect of XSAVE/XRSTOR.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5c2bf4a90e6..a018f327d5a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -332,7 +332,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
 	MSR_IA32_UMWAIT_CONTROL,
 
-	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7573,6 +7573,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.47.1


