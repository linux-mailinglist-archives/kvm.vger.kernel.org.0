Return-Path: <kvm+bounces-63773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 351B0C72515
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4743634650D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876442EC0AC;
	Thu, 20 Nov 2025 06:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aehQqYlD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD84255F52;
	Thu, 20 Nov 2025 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619501; cv=none; b=QT9TbeQkm+/kdXGfygXF1UfDi6X53Qxr1xgu7J/iekx6pdb+MbrpzkxYwH7Fp5Rz/q08b8TuDUiJn8JjUWX+YUjIvSnrwUoyoCXWcgQ4GGODtQlhgoz5n13SU+MOeU3g7U7fCSaC0SLw1T4k+9MeT8mCNgnOanXbKwYgSd9ETfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619501; c=relaxed/simple;
	bh=mqr1DwsjC/lR8ZMpgT6YDiIITwyIWzvkQ5wM7nXl0pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPribgMG7yEzJAfHJr5KbhCOJFi5AqN+6Ni3tXsyygebOnEd2riRpiorxLoTRGhTW5L4EZ2E7HVBegwq6UfggFt3pKzsJlJaoXXtAD4yQt4M1UhOvONADJ6XfGk9xdejujPyibBpEj5UTBTPciRR36FYJdnQn+4zPJKvfrF7/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aehQqYlD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619500; x=1795155500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mqr1DwsjC/lR8ZMpgT6YDiIITwyIWzvkQ5wM7nXl0pc=;
  b=aehQqYlDG9+JhoxD0ATd9+WTKRmQVXYD6IcENFi+xVSztldjFYf1qZ2y
   I5HZXaBUCLm5Wb3OmRJYpG8Fjf/AJ2Zk3ltiL5sT2k12QK9uf2MbLJF+l
   4VDOvnvH5EFuClypHOZgums1Grd9B92QLLtOhWhMmYoMVSLpeCD4flkvX
   8ZEE5vHDvcnOxUKGvUw3+emXOUmYVFJu4SkgKe4gWT+MwMJwAMrFBqv8d
   nvJmXBn24XWKWv8dr/zoXQbiqvJyHQRRpswv/OVodE7Bdo3eof1mATguP
   rtbZsnln8K+VpFM+2twTYQDmSB1RA6p4j/6AdPBTIIuhrctD3QSda4R+b
   Q==;
X-CSE-ConnectionGUID: 1t4BNa4PQSWgE7QmA0wt3Q==
X-CSE-MsgGUID: OYvAR1g1Tam2xL335CxshA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76005173"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76005173"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:20 -0800
X-CSE-ConnectionGUID: DImX4dMmSG+++TKqikwyWA==
X-CSE-MsgGUID: lWvM0eECSQubid+VD+EnZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="221918802"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:20 -0800
Date: Wed, 19 Nov 2025 22:18:19 -0800
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
Subject: [PATCH v4 03/11] x86/bhi: Make the depth of BHB-clearing configurable
Message-ID: <20251119-vmscape-bhb-v4-3-1adad4e69ddc@linux.intel.com>
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

The BHB clearing sequence has two nested loops that determine the depth of
BHB to be cleared. Introduce an argument to the macro to allow the loop
count (and hence the depth) to be controlled from outside the macro.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index a62dbc89c5e75b955ebf6d84f20d157d4bce0253..a2891af416c874349c065160708752c41bc6ba36 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1527,8 +1527,8 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * Note, callers should use a speculation barrier like LFENCE immediately after
  * a call to this function to ensure BHB is cleared before indirect branches.
  */
-.macro	CLEAR_BHB_LOOP_SEQ
-	movl	$5, %ecx
+.macro	CLEAR_BHB_LOOP_SEQ outer_loop_count:req, inner_loop_count:req
+	movl	$\outer_loop_count, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1550,7 +1550,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	$\inner_loop_count, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax
@@ -1573,7 +1573,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	push	%rbp
 	mov	%rsp, %rbp
 
-	CLEAR_BHB_LOOP_SEQ
+	CLEAR_BHB_LOOP_SEQ 5, 5
 
 	pop	%rbp
 	RET

-- 
2.34.1



