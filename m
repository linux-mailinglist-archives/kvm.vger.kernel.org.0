Return-Path: <kvm+bounces-63774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78590C7250F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id D455D2F50A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4F22E54D6;
	Thu, 20 Nov 2025 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/qI+mR/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E5255F52;
	Thu, 20 Nov 2025 06:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619517; cv=none; b=fInFDcv5jUtMTMEHQ5HQKTuaizSDilWTtI+e6FnNIf0KYFpY3DzZmqXo4R8IREX4Y2gPmKmXp0GEXuHqncoOClyJSRMgr9e3yfs3YWYrlH8RnxtCh6JPfYMSwycxe1y2q/vNS7fmi3D6P3ENK99+cIo1Lf8xPKNHtOEYyzi9E7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619517; c=relaxed/simple;
	bh=A078uDWWBxMpCRyZUtp0NO+vlPMBgGrOzAyzm3kgiPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3TYgL6ZewebjwVfdCg5BLiSl2wljihrGosolPCEWwKEtGL6N1JIee/I2RXThEROsmc6Lay9aj9RPFMIVbzS2WLettUef0xg26DClMv3Yx3PvKUR9oRSsDnszuDHKvDMqU8qfDZVGmCVU7MFpoyOCw71yBs3hK1o9QO8uARDEEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/qI+mR/; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619515; x=1795155515;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A078uDWWBxMpCRyZUtp0NO+vlPMBgGrOzAyzm3kgiPQ=;
  b=d/qI+mR/xLYx/XoDIAIefeathDGYrMCYJMKl0s1Br1ZSuvD0cSwwW3Fd
   sjNBlnK6y8U8ByzGd0SOhNWFG9gH168Cmr1Ycup7yfeiCBQ5jTaFefiW0
   z9EN8knoN4YrLZKZp81SIR7h2WEqSpS/hZhxBUlmg58jZEF6p0+5Hd7iG
   KX3mG0c1b5Y2+vVtjjo91H+EnwhjW2G/UyAnsF+j6AOPvG5OGwMI6UbtE
   mZZdMZLBevrUagYyzberUgRXyZTsqfJYgrzAPuvFsRDWQhvsXFB1XsUGk
   LQUQtyWbOfyKS93ACaJEVDk6AZ7n7XBs5OoYHi9BFvv5r7S1Ro3OZNbe9
   Q==;
X-CSE-ConnectionGUID: WPTKKm7PR66tVFq2vfmTYg==
X-CSE-MsgGUID: VaQ/Jxw/QBSIJCtEkfjcoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76005220"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76005220"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:35 -0800
X-CSE-ConnectionGUID: 4FP6WjdZTOGn59peiLV6NA==
X-CSE-MsgGUID: m/UcgTrUTreYBTaJHo39hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="221918826"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:35 -0800
Date: Wed, 19 Nov 2025 22:18:34 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
Message-ID: <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
the Branch History Buffer (BHB). On Alder Lake and newer parts this
sequence is not sufficient because it doesn't clear enough entries. This
was not an issue because these CPUs have a hardware control (BHI_DIS_S)
that mitigates BHI in kernel.

BHI variant of VMSCAPE requires isolating branch history between guests and
userspace. Note that there is no equivalent hardware control for userspace.
To effectively isolate branch history on newer CPUs, clear_bhb_loop()
should execute sufficient number of branches to clear a larger BHB.

Dynamically set the loop count of clear_bhb_loop() such that it is
effective on newer CPUs too. Use the hardware control enumeration
X86_FEATURE_BHI_CTRL to select the appropriate loop count.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index a2891af416c874349c065160708752c41bc6ba36..6cddd7d6dc927704357d97346fcbb34559608888 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1563,17 +1563,20 @@ SYM_CODE_END(rewind_stack_and_make_dead)
 .endm
 
 /*
- * This should be used on parts prior to Alder Lake. Newer parts should use the
- * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
- * virtualized on newer hardware the VMM should protect against BHI attacks by
- * setting BHI_DIS_S for the guests.
+ * For protecting the kernel against BHI, this should be used on parts prior to
+ * Alder Lake. Although the sequence works on newer parts, BHI_DIS_S hardware
+ * control has lower overhead, and should be used instead. If a pre-Alder Lake
+ * part is being virtualized on newer hardware the VMM should protect against
+ * BHI attacks by setting BHI_DIS_S for the guests.
  */
 SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
 
-	CLEAR_BHB_LOOP_SEQ 5, 5
+	/* loop count differs based on CPU-gen, see Intel's BHI guidance */
+	ALTERNATIVE __stringify(CLEAR_BHB_LOOP_SEQ 5, 5),  \
+		    __stringify(CLEAR_BHB_LOOP_SEQ 12, 7), X86_FEATURE_BHI_CTRL
 
 	pop	%rbp
 	RET

-- 
2.34.1



