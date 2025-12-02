Return-Path: <kvm+bounces-65074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8300EC9A37E
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C9E7E4E32B3
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EC93002DB;
	Tue,  2 Dec 2025 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ay06hgPs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552352FE060;
	Tue,  2 Dec 2025 06:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656357; cv=none; b=PR6aFlmaHT1x6o2TfQZZ0GI7gMivveyR2ISva0KgvxeasqYrIZftYzA+F4H3WCy3HULr0yRU0sfrVpTvPstVlFO2BxlvlLBHvsx/qOxfmxOTxCOV46LPciAHiIqGjNgKnDyDNiKXqKN4Ayeo/mbSVV/48kVgIxtMWerFx1Uzo4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656357; c=relaxed/simple;
	bh=26Gb2aAL5y3KjVhUT8doU80e2/xN6+BATNJ5g7ulYUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOo2LpmvNmjEyFhkX6jSLPACDzX2KvzRiCPWzyZnvsK9AhDKvNSKF6NXNKrvCuY92OIMDY+zU3TIkubdBPHdVJ6lQl9xZt6SWMnbsW8td1loRXpw/unHFt7oIP1Z9i/nMMo468RCgpoQFuHWLhca2TJpHcj++hODZ6i8TqZ+k7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ay06hgPs; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656355; x=1796192355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=26Gb2aAL5y3KjVhUT8doU80e2/xN6+BATNJ5g7ulYUQ=;
  b=ay06hgPsf65dwSoH3cjKzOkgtDbMI7q7QzAt0mI6xAPOX0OpIsx+2XXb
   mCjDpIBgsZ5xIjqw+DzwFAVDPURWxrVxf/rs2KWebVUkme83PjOefnHyY
   bbOsZDqSYDQk8etf6T9Ck8O92nQ3XnMM0CXSSFeEjL17f4SOaZPw2tUBw
   cPV+de/JQcIT3QIXaCy9FDNOrovkpSyjXP1N3EohO0wbCvm54LgHu1Rws
   9McqvmYctph4prX+WH3lCIltnE+lnt3DnxP07+MpuAUmXUz3+w8LlWy6r
   AHRB3Q2Uww4cVmBXIwcmMjT8n65H2Riyyknyr+g4+7wNFBvnuXUIfSx4Q
   Q==;
X-CSE-ConnectionGUID: 91IW8bcsQnqp5FPG6ghJUg==
X-CSE-MsgGUID: ZyZuYfqpStC8tasdolxYvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66499100"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="66499100"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:15 -0800
X-CSE-ConnectionGUID: pRCHdKrNRcmzqdyzU18LTQ==
X-CSE-MsgGUID: Sdv5/h5ORsqW4LPd+tYOpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="194276813"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:15 -0800
Date: Mon, 1 Dec 2025 22:19:14 -0800
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
Subject: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer CPUs
Message-ID: <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>

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
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b11e25e2fbcc77489d 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
-	movl	$5, %ecx
+
+	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
+	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
+		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL
+
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	%edx, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax

-- 
2.34.1



