Return-Path: <kvm+bounces-24108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C90951604
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 801BE1F22DD6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700D7140E23;
	Wed, 14 Aug 2024 08:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHk9qu2n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FF813DDBD
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622561; cv=none; b=rMkyRKyZUZDKVQ+lU2tK43JvNlIvji5C3bxyD41p6FAKlKn0fgUHS0ya/JDZZwkUTr0YlH7fIBRaxoxPiOsonAOskgHxuMhQK6iHR+jAHVTvt1rR016Kl/LawWmY4Jcl/taKTEkjjMq8ETQIXlgN2GpMkNfqMdeHW/4AB8Hadhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622561; c=relaxed/simple;
	bh=l9ibDxi4pjx2BEry03rv9wc5np14WZq/dpLp+/IOpk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieliIbwngif0479/rO+eH2DcxcEWwTB7JyPQnYwOX+ypsZXOnpuKL1GulZBHxwW64y6Ex32KU7VwBaikjutGJy84FlGv2cevt0zAkf3PRwIpzwqf9hW1z5zk8qgl1zq/gznX8aA8Vm5A/+SL3ROj4FsNN+iZpHkpctENtTVcyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GHk9qu2n; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622561; x=1755158561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l9ibDxi4pjx2BEry03rv9wc5np14WZq/dpLp+/IOpk4=;
  b=GHk9qu2n2Rshd+ymqXaHf5XECD6ASMUJj5MiQrArUrYanrjIVO1nskxv
   duwKDm5ogDzQ5JJqgycjjaFuAyExRnhA1BKkOZBn0Q1pmcKBUAvqaVsGz
   EVflQfORHFIm1Rzs4NEsos796khYEcPtw8AEuBymOfwLayts3xVl9LTYZ
   8VP1R2n9NjOXGYX6bNzazFiDj6VfQYwEuUPWi5iYypg78yAAZ0eT1bG/M
   rSvNDzZwk9AsxdAEJLg7i7TSGYKiRTPyPUihDpPwiW9izznTEDhVBBMXJ
   mcV6bV61EcdpPXC94oWf8EcZhn0BNJpCngPu7mDYyd7etCo6K+/Q2fA5T
   Q==;
X-CSE-ConnectionGUID: 3v73tpX0QgmmfovHBY6zOQ==
X-CSE-MsgGUID: +E6r+WDfS7+po20l7C+RoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584483"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584483"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:41 -0700
X-CSE-ConnectionGUID: w+NWm/qsQEObMRIL6k8yPQ==
X-CSE-MsgGUID: SZlHgF/pR8av3GAvF8+zDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048955"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:38 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 5/9] i386/cpu: Construct CPUID 2 as stateful iff times > 1
Date: Wed, 14 Aug 2024 03:54:27 -0400
Message-Id: <20240814075431.339209-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When times == 1, the CPUID leaf 2 is not stateful.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c168ff5691df..6618259f265c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1818,10 +1818,12 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
             int times;
 
             c->function = i;
-            c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC |
-                       KVM_CPUID_FLAG_STATE_READ_NEXT;
             cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
             times = c->eax & 0xff;
+            if (times > 1) {
+                c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC |
+                           KVM_CPUID_FLAG_STATE_READ_NEXT;
+            }
 
             for (j = 1; j < times; ++j) {
                 if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-- 
2.34.1


