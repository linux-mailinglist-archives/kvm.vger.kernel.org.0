Return-Path: <kvm+bounces-55002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B00B2C8E0
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E07C1C2610C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37B52BDC17;
	Tue, 19 Aug 2025 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1X78vtx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666FC28C00C;
	Tue, 19 Aug 2025 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619108; cv=none; b=jTAgP/ad2YoUWK6B4xLvvuuywYX1zVNOZ9Gqfi7VKcE1SYfbOsP99Xp7ou+AmZEHBP4sxDgtCuJroy9dFZ5w/zG94OQC0M+y/8xKUyXh1oAeRQ5M+s549W6rOsst00pRynprnTO4RuY8TS+uUe4TiaYBW+4qqldd85CSr0hLsKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619108; c=relaxed/simple;
	bh=jnxoUrTdVf2n6ay691SJPgQa2tUH5sIHGXiB49yWm7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oggnC7V/IUzwDZl+FV/FbJrb5StIBG6ZODLXvmQQI1Jj9gzJSe67Kc7XJLxBbtMFHGWseMiBNHmLT7zWRfLAPNuX1GXpHSOz5d5amAd6LhTYvbqk72Q23VjIfeM6GLb9JeJM8geSmElihEj9LV7jMP8Nqy37HiAviNrRUgrRDGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1X78vtx; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619107; x=1787155107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jnxoUrTdVf2n6ay691SJPgQa2tUH5sIHGXiB49yWm7s=;
  b=P1X78vtx7S9lzzPCdD4VNJ89pkFOphTxj9YbvosE7wwJlU7oMtAVtG7+
   LyrmUHyAkHGrmYfqaAf5T2467NSBHh3LNQWbEI+lHA30/GBnZHY1Ghm+M
   pgX/zOVA/dAsN+1lBtwllvHiH1sMXgBU0ohWi9EDnA6L94keKjPFAQeqE
   RNmNdNSshLIjXqtQ1XTLBDqEu8J7dZ9eBMSYOj0fJNMSKFqrvKzMHEExj
   4uPisJxVNdPLbMQQSIcTaRqOZitCV9L3DlfC1dkm1tvFYW2uhHemXDepE
   gRC4UJR2PNvFhiXLxOtAJtOyDpBhFXZDQkooT6LNsx/XYIKS0ctODaYW1
   Q==;
X-CSE-ConnectionGUID: /IJGraZiRU+MsqmocFwVqg==
X-CSE-MsgGUID: 5McY+a6qQaOqVmuqYMisEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57780294"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57780294"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:58:26 -0700
X-CSE-ConnectionGUID: 2Qoq3QmZQeeD05rMKNvieA==
X-CSE-MsgGUID: riFvopK9RHuQOAKN3SggFw==
X-ExtLoop1: 1
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.66])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:58:21 -0700
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
Subject: [PATCH V7 0/3] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Tue, 19 Aug 2025 18:58:08 +0300
Message-ID: <20250819155811.136099-1-adrian.hunter@intel.com>
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


Changes in V7:

	Add Rev'd-by, Ack'd-by tags

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

