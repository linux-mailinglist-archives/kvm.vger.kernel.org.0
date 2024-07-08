Return-Path: <kvm+bounces-21090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5310929EF4
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E8A81C21640
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F9B605BA;
	Mon,  8 Jul 2024 09:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8InsDeN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11CA433CA;
	Mon,  8 Jul 2024 09:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720430434; cv=none; b=R599wRXZ99n+bfNp9xrKCwoi7LZB3R9xvEwJ/ahRHrlkcvqh0Iw7dcNCf7UU/e8CvuX32dVbtjObTCTefVBw/q55qveREgOIAe9YGRZ1HU2da7a9B5ToVyuVSiwT+oBFdg2C71HkzDa8cQABzDg0Jhr3a2tTMjYQXs7fRHIllYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720430434; c=relaxed/simple;
	bh=JvazNq2yJjVWDrWffSa/TeIxb06gPHqopbVVFQ6TJAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Eav9SM5CAaJIdShiVnZrKHTald8uUqifbd5EQXJUtklOAJPsmUULSW+gDZm/FgXwVJS4ZXxg9MHBLcKsAUSGN8xgHS9QuqR55QEBL17QrHGx03TqoDQ5ipP1L5XN/NTkelAsKCuPzi+qeEn2kaqHuOZJQ4iWCH2AO+fo99P9wJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8InsDeN; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720430434; x=1751966434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JvazNq2yJjVWDrWffSa/TeIxb06gPHqopbVVFQ6TJAM=;
  b=j8InsDeNA25f9ONiFolzRIWGHvZHwrYrbimN0d6d9MyEPzXXhRiGSpWs
   h8hEydeTdNjuWIZmnQPUXI+5uqdPuwr2RGz9WX0oI8/whIysse+GJhMw2
   VAomBFm2hKh9aCsV4QFv2SUZGbKfguBlsdDGhTR99eaJPfV0QXCk8VMr6
   e7gc5uA27ln/i95RWCLtJUrhPhwTSgxS7e2LHiWuHWMO0qD97whcOarbi
   s3Ou8/xKI4vumrWEDcBneaxOh2EDV3qJiEthisobkbGt7VSxPBhUIuhHx
   V3ZwyXCEZ5FyshuHLIC0X9kNWaTO5DphabET9w5l9hTEbmH0w27IE+AaX
   A==;
X-CSE-ConnectionGUID: zHhMSzI0SAWGys0aXZMutw==
X-CSE-MsgGUID: IMKQzUsxQ0m8cLzgGcZdXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="17577712"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="17577712"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:33 -0700
X-CSE-ConnectionGUID: +A2zP4EAQVG4Z+OjO8CSWQ==
X-CSE-MsgGUID: p6b8F8sFQJmWCEOdx22Q9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="51866610"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 02:20:30 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH 0/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Mon,  8 Jul 2024 17:21:48 +0800
Message-ID: <20240708092150.1799371-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently in kvm_emulate_hypercall, KVM_HC_MAP_GPA_RANGE is checked
specifically to decide whether a KVM hypercall needs to exit to userspace
or not.  Do the check based on the hypercall_exit_enabled field of
struct kvm_arch.

Also use the API is_kvm_hc_exit_enabled() to replace the opencode.

Binbin Wu (2):
  KVM: x86: Check hypercall's exit to userspace generically
  KVM: x86: Use is_kvm_hc_exit_enabled() instead of opencode

 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 6 +++---
 arch/x86/kvm/x86.h     | 4 ++++
 3 files changed, 9 insertions(+), 5 deletions(-)


base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.43.2


