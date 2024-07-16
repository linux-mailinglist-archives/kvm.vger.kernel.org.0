Return-Path: <kvm+bounces-21717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA5EF932C6D
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7780A1F24570
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2BD19E7C8;
	Tue, 16 Jul 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RRD7lWp6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3A1DDCE
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145310; cv=none; b=kiU0RO4F77i7LtDX87NP5q8HK/49X3D27K7aEKUIxt4DLY3OSJhmmI1KtdJXtt+hCySaKlRQKAE+mmmbDJ6rZxx+zpNDrUw4lC/KJKszuZ7ZHVIy52cbBBfyFdd+um23KLUiMeDg3X+WJpzIgrueEStuTAG18uxfXDDvIdLFFMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145310; c=relaxed/simple;
	bh=tpsLMKJIQFAky+/kJ60UZVyG/3DdjHMTPZcVXZFK/To=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HVsTDxEl/xAwhjppXz4XLx0mhoCVo0HjD0J64dkZxHX0FfpCjMooXnFTm1n5Hbc0YXZQOHvr11O/nftLPqs+n6rukqJTvyPJPClukrG7vNQuavvJ8CLz+D9n8vSfPPKSlHBHs2G7ua3FXaCmEZ8kbGhLfdGCYmb0I8tlpnRNPmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RRD7lWp6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145308; x=1752681308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tpsLMKJIQFAky+/kJ60UZVyG/3DdjHMTPZcVXZFK/To=;
  b=RRD7lWp6moraLoXirvOKmWIpuJSKLEoLbjRKZSk6EjKgOASGIQZyXN2y
   6GqiNnNJQWoK92mSqX4nf3rfDOLZE8tTEBtIzClRzDmMaR10gqV//MsxQ
   tG13IDTPD738FdXXD8D2iIyqnxtE8bFt+x6WIFsN4Sd2cjP6xbbvGvABb
   MHG9aeFtmS619Ih+74ysOoi8Q8bUzLYmbcFCw7K3CDcvw4gqh1nJTIQiG
   3BAqtnzFH3X8YT1fKBZhRqWvIxVJKZxwOZqZ0n5QabXqxo1gxuPZDkUOa
   je4pKihDmmjBCZmGg+0bWha8M+oqO/IUqS/0GNnIpM5nGsrvSIVewabEN
   g==;
X-CSE-ConnectionGUID: d+MtYt0QR/WkzBWOFldPMQ==
X-CSE-MsgGUID: 1DlP5yJESz6DNw8oIEVkSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743674"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743674"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:54:46 -0700
X-CSE-ConnectionGUID: 7RqqBhFbRve3yyEmcDLvqg==
X-CSE-MsgGUID: qmpv3ti6TzalfhsW7l2GoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788236"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:54:43 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 0/9] target/i386: Misc cleanup on KVM PV defs, outdated comments and error handling
Date: Wed, 17 Jul 2024 00:10:06 +0800
Message-Id: <20240716161015.263031-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is my v4 cleanup series. Compared with v3 [1],
 * Returned kvm_vm_ioctl() directly in kvm_install_msr_filters().
 * Added a patch (patch 9) to clean up ARRAY_SIZE(msr_handlers).


Background and Introduction
===========================

This series picks cleanup from my previous kvmclock [2] (as other
renaming attempts were temporarily put on hold).

In addition, this series also include the cleanup on a historically
workaround, recent comment of coco interface [3] and error handling
corner cases in kvm_arch_init().

Avoiding the fragmentation of these misc cleanups, I consolidated them
all in one series and was able to tackle them in one go!

[1]: https://lore.kernel.org/qemu-devel/20240715044955.3954304-1-zhao1.liu@intel.com/T/
[2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (9):
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of kvmclock2
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
  target/i386/confidential-guest: Fix comment of
    x86_confidential_guest_kvm_type()
  target/i386/kvm: Clean up return values of MSR filter related
    functions
  target/i386/kvm: Clean up error handling in kvm_arch_init()
  target/i386/kvm: Replace ARRAY_SIZE(msr_handlers) with
    KVM_MSR_FILTER_MAX_RANGES

 hw/i386/kvm/clock.c              |   5 +-
 target/i386/confidential-guest.h |   2 +-
 target/i386/cpu.h                |  25 +++++++
 target/i386/kvm/kvm.c            | 113 +++++++++++++++++--------------
 target/i386/kvm/kvm_i386.h       |   4 +-
 5 files changed, 92 insertions(+), 57 deletions(-)

-- 
2.34.1


