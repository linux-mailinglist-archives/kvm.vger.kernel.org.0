Return-Path: <kvm+bounces-55704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C72B34F74
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 01:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCD513BDB2B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37632D322C;
	Mon, 25 Aug 2025 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6TghaxF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1A92C21FE;
	Mon, 25 Aug 2025 22:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162769; cv=none; b=XKpEeUSlvefFR7d1MSwnU1MVh864hadPZBWcmP0QbDIcL9P02/0sZNi+cfKYOlyNfzvqxakVbu5hhJ+g1n1tHjKpjHz+tP/1Br9Z20vabPodcAg1EDQOKYxeSVPwzzxBf6X3Ci4muHYmYXpykHB84kYu3fLZo2xuqbKY7SqKjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162769; c=relaxed/simple;
	bh=ObPUqNlIio++VGV8CmQ4YDrJyoIrTWqqB4hd4548ko4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYeni5AW6IqvTw4qRfQk4FZZRI7sflDXllnuzL6Yl0LdsajJ3Esa4bXA37ZpURqxSW4grxZWZf0nT2NxsPPj3wYAjsiggIxBVOl7VvbCvwArZGHmhamkO1zROE1f8SQugA0GQ4zg3pzB/j15yjOPgyOLxZbA/ulC2iK+pUwclmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6TghaxF; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756162768; x=1787698768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ObPUqNlIio++VGV8CmQ4YDrJyoIrTWqqB4hd4548ko4=;
  b=W6TghaxFU1iMYY0TNtlN+uZi3hw4njzHCoebM+jkTEsLLRRjtx5/SqCc
   Rda1dVxz+oPcFQhXogGaTG7nawRTG+aBSFGYbjK1LOVQRwIqIie8fHJH8
   iWmgkTWjYGKyJbj9XIyDS+9Vw3uWLIL8oJ5h78zdLBWs8yGxvKpofP5DE
   H7Pn3pKYiE4UWdPXKQ3wwSHizAvwqbQBEqGunxGDTy8t0C5JtHqSAC32u
   idUqL0xRwL2BGTzCT8620ZDFOgULdWbN/krS5kWtYYuKobwwJWDgaRJqA
   I7Wi73s6n2Ur7NdTRtraFghGpPpEtF+fbMZymkzL8yaC751f5gM5imSiU
   A==;
X-CSE-ConnectionGUID: PUwMoC2vTEqbV78dv0S6Bw==
X-CSE-MsgGUID: IJ/hFvlITom4hmAek/Qtag==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58533412"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58533412"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:27 -0700
X-CSE-ConnectionGUID: ZXymxT8WRjeE5MBvrI62Xw==
X-CSE-MsgGUID: RD3v71PMQvy+wDqAr9IoZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200308455"
Received: from ldmartin-desk2.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.59])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:21 -0700
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
Subject: [PATCH v7 5/7] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Tue, 26 Aug 2025 10:58:40 +1200
Message-ID: <ae23d08b65611bea94e484b5225da42c62f170f4.1756161460.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756161460.git.kai.huang@intel.com>
References: <cover.1756161460.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During kexec it is now guaranteed that all dirty cachelines of TDX
private memory are flushed before jumping to the new kernel.  The TDX
private memory from the old kernel will remain as TDX private memory in
the new kernel, but it is OK because kernel read/write to TDX private
memory will never cause machine check, except on the platforms with the
TDX partial write erratum, which has already been handled.

It is safe to allow kexec to work together with TDX now.  Remove the
!KEXEC_CORE dependency.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100..e2cbfb021bc6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1896,7 +1896,6 @@ config INTEL_TDX_HOST
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
 	depends on CONTIG_ALLOC
-	depends on !KEXEC_CORE
 	depends on X86_MCE
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
-- 
2.50.1


