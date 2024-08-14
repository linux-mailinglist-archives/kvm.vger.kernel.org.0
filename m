Return-Path: <kvm+bounces-24103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E989515FF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 346271C20F0F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0185D13D28D;
	Wed, 14 Aug 2024 08:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bmpR+4qC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E424D8B8
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622556; cv=none; b=Y6lZyk3N5W+fS9ugge3z6KqDyhc9PWx5jszs+6hYKiJtshvozjdBtZ5XDplEcdwTP3QptG77SfJyrwUIDN/v17/wmdSCbNZLK4zm5aolPHLpsto6uV1OtqpqWPeRF6QXffoav7niS6WpCEvFj8vGbX++rtt0tSQUoBaU9CPztmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622556; c=relaxed/simple;
	bh=Pc6v8vQDyhFUnCnaUpnKF0TGvteOoZKGCnvSfBFYwhY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B0AZZYdDgWTXGrJzbD/tLtXj/S9ZzuNh+QtnQrA1eqG4H0khsUogQihE8C+sBxJxFfreweS6IiSvUmb8GxfTkKFEoV094JWRkrfGisGJTfvPuSryPTnmqvdnV9kx3et2OT5GxcIKTu81MogkZX3cN69+VN64rKrUKJV2MlIbq4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bmpR+4qC; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622555; x=1755158555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pc6v8vQDyhFUnCnaUpnKF0TGvteOoZKGCnvSfBFYwhY=;
  b=bmpR+4qC5Oqswl6MPDGaLkdjWH4VwuO1m2YmVxn3Ck/Z4wHBSsrgYE6r
   lRLGOwSq3u8SaGYvdA1iyqpCrLIPFjJXrxAFrPL+sb2TxcVpLhlSx+f5h
   3+LoAVHp2j6RgICgiqEhFqpRuFYP5ahfGmwlS7rRWf8eBBOwINy8lVJRj
   +SV1RNzWrpQbuNwUTreCgZfJZTk32uuAe/V1BOsc2kiIfDUQpXQiIUEqY
   jTRm4u7u0CZjHzrsv3Q6VLDHqwfXzOHiQ3eVEfm0GthDkV5F8k7RbZxcu
   tBGblWMX9rMsQ+QsdXhLDVJx7NpQ3ax6wFVSWnfICqPuwVCGBsEC/Fjmd
   w==;
X-CSE-ConnectionGUID: x1GMQgU/SOGUW3BP+TymSg==
X-CSE-MsgGUID: X5LIuRUXRiuGDmLIc0iDjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584445"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584445"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:33 -0700
X-CSE-ConnectionGUID: v9MCkPMnRlyoOxRBYN7Qxw==
X-CSE-MsgGUID: S4LG+NLlRsGaUmQVXgYh/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048939"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:31 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 0/9] Misc patches for x86 CPUID
Date: Wed, 14 Aug 2024 03:54:22 -0400
Message-Id: <20240814075431.339209-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is a misc collection of patches for x86 CPUID. It contains
patches to add support for new CPUID bit, to fix the construction of
some CPUID leaves, to not expose AMD defined bits on Intel guest, and to
make invtsc migratable contioned on user_tsc_khz.

All of them are found during TDX development and testing. However, they
issues they aim to address are not TDX specific and the patches are not
TDX specific.

Xiaoyao Li (9):
  i386/cpu: Don't construct a all-zero entry for CPUID[0xD 0x3f]
  i386/cpu: Enable fdp-excptn-only and zero-fcs-fds
  i386/cpu: Add support for bits in CPUID.7_2.EDX
  i386/cpu: Construct valid CPUID leaf 5 iff CPUID_EXT_MONITOR
  i386/cpu: Construct CPUID 2 as stateful iff times > 1
  i386/cpu: Set topology info in 0x80000008.ECX only for AMD CPUs
  i386/cpu: Suppress CPUID values not defined by Intel
  i386/cpu: Drop AMD alias bits in FEAT_8000_0001_EDX for non-AMD guests
  i386/cpu: Make invtsc migratable when user sets tsc-khz explicitly

 target/i386/cpu.c     | 50 ++++++++++++++++++++++++++++++-------------
 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 17 +++++++++------
 3 files changed, 49 insertions(+), 22 deletions(-)

-- 
2.34.1


