Return-Path: <kvm+bounces-51948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94BD6AFEBD2
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05FA45C41F3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7012E54B3;
	Wed,  9 Jul 2025 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJwiWyA0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D55276025;
	Wed,  9 Jul 2025 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070712; cv=none; b=N61ViKQ0OkaB31kQldChcRe4n6YKXyhXXE6siCH1+nh3RoD4GY4Egc3K5msJGMXXFGrfKBbiUNtHsEwuFsv0SgB51PxC8FegsA13bcKv5Jilg5uVdhlCI/lGZQMVN35sUv4RSHuz+4PWHo4Yg3R/UaojP1QDD6kchMVm3Fus3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070712; c=relaxed/simple;
	bh=OENTxUU6mdDY92C/NOL14GnVLsxzDa319iL2JkpR7/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LqR4OhIVErBizyvWox+Grq4HjnkmY+lpEu95YbLfyBMTS7wc8qwTjR12620FX1csYzZ2f/XoVa8/My/M2fURDNESTF0ByATHjrJJ83neMi2Gf3hTplQrKdyasGu3WR42a8adz6PCeKg7uQdnP1JpVKg1vkH2Rx0uiC2fTiGIiC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJwiWyA0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752070711; x=1783606711;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OENTxUU6mdDY92C/NOL14GnVLsxzDa319iL2JkpR7/U=;
  b=EJwiWyA0LRCaAUXfrhrkeeWvaFojFEZOa6Q1HMMp/Sl4tydBtLguf/LC
   BGF/07MT/1ygxzHkMTfMJXzTHzIZD0Yf5LD7R3xQ8FAnfATJUqyRZyqmo
   rGpmyawp/YqWioRA5Y5xIp2YrJBsNS8GrZB9tJutbM74p1BKfuV2yOewe
   rlo0Ql+FZhaPc23Z8b9iZNjRAW2WoDKYY95G4t+3UQgMdom6X4hGbJNi4
   e+yT627tvl2FEVnsWTb6db5J6sPP2P9E+7HcOu5A0HlKDkhi9XceYquX4
   K5U7wfy/TSvO0dgA1LHvhcei3K+pPbzRHMPKAAsFwHV2RfnXiFjEBi28v
   A==;
X-CSE-ConnectionGUID: +bCT5fIcR7OmWS8Cv6u1mA==
X-CSE-MsgGUID: qeY2HhW/R2WxR7h/5mjIpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="41956153"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="41956153"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:18:30 -0700
X-CSE-ConnectionGUID: 7yWtpJG6Rg6KTR8esRC+GA==
X-CSE-MsgGUID: nGHKQhmtQIaZZWyfnLFhHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161447456"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 09 Jul 2025 07:18:26 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: [PATCH] MAINTAINERS: Add KVM mail list to the TDX entry
Date: Wed,  9 Jul 2025 22:10:35 +0800
Message-ID: <20250709141035.70299-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM is the primary user of TDX within the kernel, and it is KVM that
provides support for running TDX guests.

Add the KVM mailing list to the TDX entry so that KVM people can be
informed of proposed changes and updates related to TDX.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c1d245bf7b8..f1fb15729460 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26907,6 +26907,7 @@ M:	Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
 R:	Dave Hansen <dave.hansen@linux.intel.com>
 L:	x86@kernel.org
 L:	linux-coco@lists.linux.dev
+L:	kvm@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/tdx
 F:	Documentation/ABI/testing/sysfs-devices-virtual-misc-tdx_guest
-- 
2.43.0


