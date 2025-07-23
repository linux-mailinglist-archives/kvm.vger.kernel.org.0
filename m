Return-Path: <kvm+bounces-53223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FC9B0F1DF
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 724273B170D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BE62E5B05;
	Wed, 23 Jul 2025 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RgxvzIq3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC0615A87C;
	Wed, 23 Jul 2025 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753272359; cv=none; b=WevKwgnkPQb9iiJY5//pJnu2EieK3xkpMloCJtGtMDqzpHDmiUlT59Com3lXehfdGlNe8mzgBSIpZtmp47HAaYeCHWkS/kji3jl0ktSXTjCnOaPaiCyeQXAeknF7EnW5YMn0f7fJ0tdOHAAf6TgI89wmoStMg0nHyR5GQ7ea/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753272359; c=relaxed/simple;
	bh=Mow2kC3IacSZWQPiIr4pg35iuks13IZ+nPS4mpSBR+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FI4aOYOn0cWv/G18Fg0EuYJrwGijcfHrQAKlD0eR0xtylffu5+uFWEsK1IqlcX2Sn6azZtVsshGMMdSg4uLkrrHkqUZ+4uBYtZ9xwC0DrVruG23jzin0XKfdeLGQ+3h2tdjmcheP4D29BUV6rFy3UVoEhfsFLsIyvW/tN19JWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RgxvzIq3; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753272357; x=1784808357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Mow2kC3IacSZWQPiIr4pg35iuks13IZ+nPS4mpSBR+8=;
  b=RgxvzIq3kohAfDirt6Q8JpC8Jyl8/XngKv/V9hbqM1x0JA7auesfKCZd
   pzAY1WqAsVqy0rqRAc2Ebk85qjIhmPt7cyEL72rt7YOlCNu46tnw4LixC
   ga1OpMyeanCgwKVf2MeI7nVSxaQ9Ow0QA+UB2LKJNs7g9HVToPm446vf/
   lDwhcWqKewqYCOlwSpQE+rvVbvi0RszRXngHBPI6fvjQdeEzzIldiwbrO
   uYKn8UoXwQfqXybdxpjoOQYa97ywxhYCGKzibbY96szGFRgr9gehOuIKw
   fju5Px068JSvlI5LLaAg1tYvZLSBZ+u46spDMbC2JNxydNM/rSrGZ/XqS
   w==;
X-CSE-ConnectionGUID: yhcp6HN6SfmWrnLlf+oZcQ==
X-CSE-MsgGUID: 9vis5eRXTD+l7doXCoomGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66249177"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66249177"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:05:57 -0700
X-CSE-ConnectionGUID: uzyQmLCpTcOJg3Z8UVPBIw==
X-CSE-MsgGUID: 8x0sJCmeTe21dMw/9gvF/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="183154007"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:05:52 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V4 0/2] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Wed, 23 Jul 2025 15:05:37 +0300
Message-ID: <20250723120539.122752-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Here are 2 small self-explanatory patches related to clearing TDX private
pages.

Patch 1 is a minor tidy-up.

In patch 2, by skipping the clearing step, shutdown time can improve by
up to 40%.


Changes in V4:

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Add and use tdx_quirk_reset_page() for KVM (Sean)

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Add TDX Module Base spec. version (Rick)
	Add Rick's Rev'd-by

Changes in V3:

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Explain "quirk" rename in commit message (Rick)
	Explain mb() change in commit message  (Rick)
	Add Rev'd-by, Ack'd-by tags

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Remove "flush cache" comments (Rick)
	Update function comment to better relate to "quirk" naming (Rick)
	Add "via MOVDIR64B" to comment (Xiaoyao)
	Add Rev'd-by, Ack'd-by tags

Changes in V2 (as requested by Dave):

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
	Call tdx_quirk_reset_paddr() directly

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Improve the comment


Adrian Hunter (2):
      x86/tdx: Eliminate duplicate code in tdx_clear_page()
      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c | 20 +++++++++++++++-----
 3 files changed, 20 insertions(+), 27 deletions(-)


Regards
Adrian

