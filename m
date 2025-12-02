Return-Path: <kvm+bounces-65077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF694C9A39F
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 497BD3A6628
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E75301002;
	Tue,  2 Dec 2025 06:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4xFI9bv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2A72FD7CA;
	Tue,  2 Dec 2025 06:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656402; cv=none; b=PeUD54Jiyi7BkNlLx1Ik7Ra9rmLWEm7j0dIX76V26cj3Fxt9iH2U5ilGIEUreP5OtKprspLggYms6rnG5V6I9477B4EWFtjcGxqvJEh7ZyJwfqlTfC4tdoYBNH39Y5yeNcaSHUTZy1yt5X5S5WGNjXFzqagVrh3eVAyJYomzprs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656402; c=relaxed/simple;
	bh=E6xCR9bLpamxJsQ0brS4ODlqWxsh/fFZQVosRkMhOPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ez3/TeOlWsncZvqApHURDfavmnRgrP7DzsfyHrWhhHpMnPo9TGEhoNfeRW8fTH8u3shPywO4Nzfwc6zSsPTxH89DgHlt0Z/6/2v45T7x6OXZH8u7QgmZlPQbqcZb2cTYxCI0xYlCmxINJ9C5lxetuOgLfSrkswXYRal5yMRbZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4xFI9bv; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656400; x=1796192400;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E6xCR9bLpamxJsQ0brS4ODlqWxsh/fFZQVosRkMhOPo=;
  b=S4xFI9bvpEeTnEaK+gVtdyLp1FYyqG+lRYPZNrY6TMwssMBdKiNqQYfw
   YU7fwewyFa9S0nDMgANOR0oZoB4qZPFspetBrX1FicNmgvMO8UvM9ofLj
   htzpkztY5UJpfz9F5JCyLtDVwORw8HXJj93uZP4S+JlIRszhWiKvZtLRr
   aeitTz/nyWF+c8RwlQSxYL4KBSsC18hVoDKHLfLv9ncff35lF8OHaleEJ
   q9KqWYFKoA3BrgoC6ORu9/YHj95z9o+/z6jdu4RY36hH7W48eCIz0x/SF
   ds6OpILASDyzpYltqK1lEqUh8EjjsSk4cgj+UFELiTNeq1EbGBU5YnA89
   w==;
X-CSE-ConnectionGUID: pnrFgVqSSDytTesPsPLayA==
X-CSE-MsgGUID: XDex8jxHQqaCeUoLMi7SEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="54165867"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="54165867"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:00 -0800
X-CSE-ConnectionGUID: bzBH77pdQ+e0Cl5JkV/PLw==
X-CSE-MsgGUID: tnkZrSH7QM+3lowqXstA0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="193580407"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:00 -0800
Date: Mon, 1 Dec 2025 22:19:59 -0800
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
Subject: [PATCH v6 5/9] x86/vmscape: Use write_ibpb() instead of
 indirect_branch_prediction_barrier()
Message-ID: <20251201-vmscape-bhb-v6-5-d610dd515714@linux.intel.com>
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

indirect_branch_prediction_barrier() is a wrapper to write_ibpb(), which
also checks if the CPU supports IBPB. For VMSCAPE, call to
indirect_branch_prediction_barrier() is only possible when CPU supports
IBPB.

Simply call write_ibpb() directly to avoid unnecessary alternative
patching.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
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



