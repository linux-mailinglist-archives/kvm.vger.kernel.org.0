Return-Path: <kvm+bounces-53368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E10E4B10ADD
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14CD57BBD24
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FD42D5400;
	Thu, 24 Jul 2025 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XW2ex7ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ABD1FECA1;
	Thu, 24 Jul 2025 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753362253; cv=none; b=UClaYJ7EnE+FYAoRHuJMSj3DPmGlSPukwdy7IJgcZGXCtyhJjRIL0TTthXBK1zp84c/nl2j17vyUdiAv/0aVUWRzal66Vv5YvmuTwfSsQEW1N+cYIN0OdSPhfRGUlmi02G92Mv+V0Und9gRIfK9jsUctFeFrdiDBdyIeXWo3t8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753362253; c=relaxed/simple;
	bh=wqF6O/RajDlUzZLf3o7faiOAdbJO7ryL0x31/07G3sI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J7eWcWu+yD/9u1g3Jjz4Ykz/mOYKvIAStutZpeZjaq0XksIBDGHjrMqN9nLEmhb84ex/N8WtzXE/WSFRdjPw37sPIUiympVkS1XsyhcGtQN/Kn6Vqoke5PHdMeDHgsCSPR4wtNep5uEw6C8d1WQM6rw7QUdVhmcgbdlEKGPassA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XW2ex7ZA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753362252; x=1784898252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wqF6O/RajDlUzZLf3o7faiOAdbJO7ryL0x31/07G3sI=;
  b=XW2ex7ZArckRpQedSpBT0WY4eJRYzZFmAnaFZ/lfvUKYVE/9qT9hxIDz
   K9V5SENC7vakDbZfzvEesH1uPo+T+2HY+ZkzeozjmWwkg94wnn4SPTgtc
   3+J9GooDfu2qHnWDdqBNtghjx7QL2rOW1SejS1PLVIC+hscNDuJZzpyOa
   cJJbf0gaW4gml/zX2KHNO0UalB6WO5LK0bDsc9C23lrZBLGhmHaF5e0HI
   InQL9UE6FKO93v0ihjGjX1eYuWriDlV6WnY6IyLW8c9cDPTP+YAAeE5UQ
   c3kFaVeF7jd9kUfg73X4K8k0fbVPIJKUHrqBChlpVVb/ADilgWGFFRYZK
   w==;
X-CSE-ConnectionGUID: vKHQHW+tRaKmTKO/nIVVtw==
X-CSE-MsgGUID: D8LZJtubRZKw7kIMbU+u8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59480653"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59480653"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:12 -0700
X-CSE-ConnectionGUID: TJlSrT+aTO+xNXCHZhNfWA==
X-CSE-MsgGUID: cfr6l25WRIiYv3l29eovWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165598951"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:06 -0700
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
Subject: [PATCH V6 0/3] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu, 24 Jul 2025 16:03:51 +0300
Message-ID: <20250724130354.79392-1-adrian.hunter@intel.com>
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

Here are 3 small self-explanatory patches related to clearing TDX private
pages.

Patch 1 and 2 are minor tidy-ups.

In patch 3, by skipping the clearing step, shutdown time can improve by
up to 40%.


Changes in V6:

      x86/tdx: Eliminate duplicate code in tdx_clear_page()
	Add Sean's Ack

      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
	Add Xiaoyao's Rev'd-by

Changes in V5:

      x86/tdx: Tidy reset_pamt functions
	New patch

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


Adrian Hunter (3):
      x86/tdx: Eliminate duplicate code in tdx_clear_page()
      x86/tdx: Tidy reset_pamt functions
      x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c | 36 +++++++++++++++++++-----------------
 3 files changed, 24 insertions(+), 39 deletions(-)


Regards
Adrian

