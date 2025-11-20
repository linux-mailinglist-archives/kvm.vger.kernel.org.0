Return-Path: <kvm+bounces-63777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A83C72549
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 45A6A4E87BE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AA72EC0AC;
	Thu, 20 Nov 2025 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6MHKJpU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849E274B42;
	Thu, 20 Nov 2025 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619563; cv=none; b=Sg/LZbrLKodZ6+SMScUtZcs6gkbVkoJbVVOqEMWJo3ZuQpNQxI5ZrhYE9vnCeZ/vaj0BJqEBr73jCdJRnSAR5JVzjPIpXsHV1fHjd24Cpbb3A89DbcZ3qFQHKxeSEZIxiyirqVg3DBW0+XM8LktJiUyD62Dw+U6NlU0k08Vob20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619563; c=relaxed/simple;
	bh=ZQ2tXtjYQpLw/tK7Ozi2ZUDvtQLKAQOdV+P5M2kZF6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUa5nRFPZxY+n/X2aO9EStMB2Xv/m3HgeFP6EkElJxQV5W6K7z6kDoPdrv99uKKCGMtbt4W4jyT8To3Jc0D6kjsqQtBSZuDVM/C63GG+eSL8fmYP3y+VOWQP3zANCWbgfQd1UGZ6sMrW2CpRn///AEf2rZbYmBeYhY4H+Y5tISU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6MHKJpU; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619561; x=1795155561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZQ2tXtjYQpLw/tK7Ozi2ZUDvtQLKAQOdV+P5M2kZF6s=;
  b=j6MHKJpUywh0c5GaFk0xTYP25GN9F4BtwoTz+oWRlBRiFCgUit00maRf
   +0mrtEdClKZS3ZEEadY3K5lbnQ3DHc3mrn+HY8LhQZHTW6+V8priF9RZU
   J0JWRk8A8gf4hPS/qLoTwsUgfefHVdwx+QoJiXcp8KlyVD4nEsaBRCt8o
   7ugztSyiC4Vi5mNh25WjaF/AVxvT5erz7QJxZUmGJwKoUOTeWnO7lukUm
   BKbS+h8zZtJnHpo9tmGrDG1Bqyofek3zqnFDsi2RAZ/6Y0f6UjP1AZNdS
   8ga34yeBxOS+3e1qj8uRbeQC6hD0OeLY15sCqvla/BZAxZJB2gfiG72Ai
   g==;
X-CSE-ConnectionGUID: 9NqK+2EPSVCOsXkc1Fcv0Q==
X-CSE-MsgGUID: LuYNPyOzQBG3yhZK3m1Ojg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65706184"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65706184"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:21 -0800
X-CSE-ConnectionGUID: eeoVeduwTzG6Xgwn1R7tlw==
X-CSE-MsgGUID: 2lnfAHWMT26nQnPpneFmfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196234830"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:20 -0800
Date: Wed, 19 Nov 2025 22:19:19 -0800
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
Subject: [PATCH v4 07/11] x86/vmscape: Use write_ibpb() instead of
 indirect_branch_prediction_barrier()
Message-ID: <20251119-vmscape-bhb-v4-7-1adad4e69ddc@linux.intel.com>
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

indirect_branch_prediction_barrier() is a wrapper to write_ibpb(), which
also checks if the CPU supports IBPB. For VMSCAPE, call to
indirect_branch_prediction_barrier() is only possible when CPU supports
IBPB.

Simply call write_ibpb() directly to avoid unnecessary alternative
patching.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index c45858db16c92fc1364fb818185fba7657840991..78b143673ca72642149eb2dbf3e3e31370fe6b28 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -97,7 +97,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	/* Avoid unnecessary reads of 'x86_predictor_flush_exit_to_user' */
 	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
 	    this_cpu_read(x86_predictor_flush_exit_to_user)) {
-		indirect_branch_prediction_barrier();
+		write_ibpb();
 		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
 }

-- 
2.34.1



