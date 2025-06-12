Return-Path: <kvm+bounces-49236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CCF5AD6A50
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 000CB161DED
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB712222A0;
	Thu, 12 Jun 2025 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fln1If3g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4281918DB2A;
	Thu, 12 Jun 2025 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716393; cv=none; b=Sxfggi4eaCFicF1gV2abGUxLE+g0RSBCXtpP5qemH76z4EhCdC0eDBT+mxFWOEvdr3fDCjPWbfXdVBJqgxzA++c+MHNgiqOIP09D6aTBqIve/7Fxm55w9eqrjJb79ZE9C1fjr1kdrvpDekoaMV3H4VznWsFt2IXJ4I5+CoQzz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716393; c=relaxed/simple;
	bh=bLwxmpCXhY7A4jarLKtqhwKENaZxzcsjFRXZkude62w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+BfMwp66I7MIa8XvaabsW/HiWXV1FtX3VA2tinQ317A7MXWSNs99kIG6h/KqWSkkOZHmx94X4DdkoQDwKVvY+aj9+eidt6j40A6A20P2p0uryh0BZveWCrE3QN2A3pqbeWZ8ysazsy33kYljvOwOvSXhoUgXys2qNyPmKQHyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fln1If3g; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716392; x=1781252392;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bLwxmpCXhY7A4jarLKtqhwKENaZxzcsjFRXZkude62w=;
  b=fln1If3gBxHxOZ4kKsOdPYMILZVp6C9anP0NjG8zeL25dlkhnjhEvVra
   ZjI735BxQMSIMpvoIVonlGPbHXOomWGTC5D9l5PO3mac5B/NPyagc5irO
   69KsRWVG1EhtrqJ52RlJmzfQxf2RntgbtAvLpcEK2P8lGdoS0RJZQUMyC
   1T69EvqllPmDDHhqhLhpnA5S2z3W3jIuZkcYQbmDpM032ArnDZK2BTD/x
   Vpsd3yOGLleJEZQspud3fDqx4IMPbE6SZnm3h6VJoDOH65El1MNFoQR7F
   2bXme0jDo2s5yqHGSsgqPnxyumMo6oX6VcumzwAF9Upc9eNtiboE8hSB+
   w==;
X-CSE-ConnectionGUID: zS62DAJAQ/yazUhrUH3nFQ==
X-CSE-MsgGUID: nGinsKIESeOu+HFeq9ixzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51759988"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51759988"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
X-CSE-ConnectionGUID: p3VQKHUZSx2/HhQOAdVHOA==
X-CSE-MsgGUID: a3q284Y2TviN8hEJmnCp/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147322370"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:19:50 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	dapeng1.mi@linux.intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 0/2] More cleanups to MSR interception code
Date: Thu, 12 Jun 2025 01:19:45 -0700
Message-ID: <20250612081947.94081-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Deduplicate MSR interception APIs and simplify the handling of IA32_XSS
MSR. This series builds upon Sean's MSR cleanups series [*]

[*]: https://lore.kernel.org/kvm/20250610225737.156318-1-seanjc@google.com/

Note that this series has been tested on Intel hardware only.

Chao Gao (2):
  KVM: x86: Deduplicate MSR interception enabling and disabling
  KVM: SVM: Simplify MSR interception logic for IA32_XSS MSR

 arch/x86/kvm/svm/sev.c |  8 +++-----
 arch/x86/kvm/svm/svm.c | 23 +++++++++--------------
 arch/x86/kvm/svm/svm.h | 10 +---------
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++----------------
 arch/x86/kvm/vmx/vmx.h | 10 +---------
 5 files changed, 23 insertions(+), 53 deletions(-)

-- 
2.47.1


