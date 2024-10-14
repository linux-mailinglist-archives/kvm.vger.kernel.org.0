Return-Path: <kvm+bounces-28750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 473B099C923
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99222B2B55E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4721A7068;
	Mon, 14 Oct 2024 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Po16YDKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B01199FC9;
	Mon, 14 Oct 2024 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905547; cv=none; b=EX663VA3HWiouTFurRY/hAv70a2uG6LL6xmtfMPwFcVH0bn2i+lLwN8iZXNujdZdsSkW0p5s0Y9nQlPBCjaDkqft+Gyp+PLbj/yZQr9eQUbTrWN7TIpLcQ417YraCCznK4tK1AfciLwsahopnCRag1pmQFUGBLJ9whaHo0T/Umg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905547; c=relaxed/simple;
	bh=PNGHYl26Z+AOnJWsvbC2lB6vddHl8DJkpeMOxdEnyBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsrbvNGXZ9h+EvzZfLSZ++kZLoAOi27Gb4seTzItbe8BWmhHlp8mq67O9Q0hj2Obc/LMtuRhLKQadreY1EXDVis7EgazNUNmOndxTSvn6AybjzySzD0F7m+xPCKA56WwJAoHEui4yzIMUeN7j8fAXvO7TOvwiZrZiz6zFouOkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Po16YDKZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905546; x=1760441546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PNGHYl26Z+AOnJWsvbC2lB6vddHl8DJkpeMOxdEnyBo=;
  b=Po16YDKZZnFJvfdDsL4RXScSqBmic9jLuDGnpj/F4iht/4nbBtej4ZHZ
   MLV1O1wwjajCLToA0smYHJ9A0+iFeHxiYD4z7mmrwa2CpIdRJPnP5hCR9
   FGUZBw+UKl7tstR4gB3UMtN4w6py58yOoxSBgkvyTCOxUgouhDmFS3r3o
   f9JWrJ618qToErUaA38qNlXvBw9PCes//hBqzYokzC4NyR8r4p9mLkWDh
   fJQ5IYa1Lnvgc/99R2xAGYXAeAkel6bAhI27U0zhGNvcyPuoa4KwG1S/t
   m4kLwYR3qRKn3SKE8jRdBiDfobdaeGlJi4osw/YyBQS2Sc8jK8qF/31DQ
   w==;
X-CSE-ConnectionGUID: KgoLduWXQL+Jzyv4aKqrzQ==
X-CSE-MsgGUID: UTkdX0oDT+OuHkchJZSsjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166502"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166502"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:25 -0700
X-CSE-ConnectionGUID: Y/JODufOSgiLF/j4/tX0bQ==
X-CSE-MsgGUID: 1G3g5VoERbShPG09sfmj+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117479"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:22 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v5 4/8] x86/virt/tdx: Refine a comment to reflect the latest TDX spec
Date: Tue, 15 Oct 2024 00:31:51 +1300
Message-ID: <9a5adc84bf8de51e0340300903c7ea048686077e.1728903647.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1728903647.git.kai.huang@intel.com>
References: <cover.1728903647.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old versions of "Intel TDX Module v1.5 ABI Specification" contain
the definitions of all global metadata field IDs directly in a table.

However, the latest spec moves those definitions to a dedicated
'global_metadata.json' file as part of a new (separate) "Intel TDX
Module v1.5 ABI definitions" [1].

Update the comment to reflect this.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/795381

Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---
 arch/x86/virt/vmx/tdx/tdx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7a8204a05bf7..8345ae1f7fb1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -29,7 +29,7 @@
 /*
  * Global scope metadata field ID.
  *
- * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
+ * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
-- 
2.46.2


