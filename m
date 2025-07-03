Return-Path: <kvm+bounces-51498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E27AF7C90
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87CF8163982
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E8022333B;
	Thu,  3 Jul 2025 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nToDnmAz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B966F2DE6F1;
	Thu,  3 Jul 2025 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751557052; cv=none; b=K7buz8H/VtNAO6xnxw6rjG/AYw/sqSeCNkRvuKU4OGVyPtvXTTD0zOCDTQ2t/+H1Cq2AzFezXG0PgewUcYQY105yHehaYFirZwph5nDoRC3WzSY9xDzccZ8L78L6kJkCK+QbV1OSni7Q5YtCUW8/0btCrySBV0PXaoaZF6R2g+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751557052; c=relaxed/simple;
	bh=PG8kZ/GY/zO2V+FT8JqnduyAZzDlLNvlfDqA7IsapfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NRkJgU/NT5Lo1dq5PK38OwIVYxwXG1tV4jWAqW3H6H31G2St2hHrL0quTed481JbIs2IeTmhzfQIP7xoib0tZeHfq23aXaCo24taVBvONKRjcVjtoDgMtId8BsNY3a9yyT+/Gv0FGbMkio13gxspYV6tPsnXm5GOICxTmE8iUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nToDnmAz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751557051; x=1783093051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PG8kZ/GY/zO2V+FT8JqnduyAZzDlLNvlfDqA7IsapfQ=;
  b=nToDnmAzLKebl/FMJ1TcMJg8usn7Zc6boPp5uqAF0aPWPUssWj0W1GPk
   MOsdPKjUwKC77pIy9UZ38cQ1Z+IhGORxW+LJO1bCkszwlFrImoPTTqpRQ
   OnFtUnXrwoKkNtebTBzR8+VyPmKQUa7+RAZ+CfcwYfb7Xf4onFkS2+Jty
   UmEp7jOICnAj356zCmfuz3b8lNZYPVUuhH+Jche5yJ+FFvIwO44fpJd6L
   tOBs6IXskdXuk/JpADIYDz1KWV63w67Q6UgnDyBRzP4lw7pZSDZGwR2EH
   BOCBdv5+A4QgL8Ew6LkCutcRUukgRtO1feGG3wXYpw99UJ9Am4iH70uBY
   Q==;
X-CSE-ConnectionGUID: g4ZBJZW+QCyvOFnGgbEBvQ==
X-CSE-MsgGUID: tiFrVgvjRAi2UTe5UDtWcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76436646"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="76436646"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:30 -0700
X-CSE-ConnectionGUID: xWjytiHcTkOP31GxAiNVqQ==
X-CSE-MsgGUID: CQyWMTkbRayFjFD2y4kOdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="178065068"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:25 -0700
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
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 0/2] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu,  3 Jul 2025 18:37:10 +0300
Message-ID: <20250703153712.155600-1-adrian.hunter@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 13 +++++++++++--
 3 files changed, 16 insertions(+), 24 deletions(-)


Regards
Adrian

