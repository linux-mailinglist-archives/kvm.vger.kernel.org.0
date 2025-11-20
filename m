Return-Path: <kvm+bounces-63765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0145BC72349
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 05:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id ADC5A29EE6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 04:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6F51FAC42;
	Thu, 20 Nov 2025 04:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAQ5wcBP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744648CFC;
	Thu, 20 Nov 2025 04:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763613950; cv=none; b=umCzIIxXiQSR3uuTmnzH+UNnp8DtIF8x8gLdOaxOgy6+TqtVTVJ6js90KwWOEujhRzhT7pwApvFZRHYkXXaxl0cVTLfJPyqkVC0YfzszVokKzk8g2UT6l5ewOU+ub6zhbii2Kvmrl6JYArPNq/jw5g/afczHGOELuLIospSvRT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763613950; c=relaxed/simple;
	bh=p95QluZZJnezMqSowNQCpR24jQPVhHDUGudCNk9HV8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hoaLcJDFaSrpgioUWISqKrlYoZELmPu+XeWAqVoko+E2J98r1aSzxl0c1n+t+4nbvR6ARnvgI2Ok17nWT/pxFXf7n/X0Lxm0XA3zroST4V9am+voJZ8X24Zoqx/gul5eRZ78tGNLkqS++Yt0/J5AoADLf51rDvq69Nzc8anYEP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAQ5wcBP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763613948; x=1795149948;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p95QluZZJnezMqSowNQCpR24jQPVhHDUGudCNk9HV8k=;
  b=HAQ5wcBPNyImfT4yrAkS98gYcuoO1uaUEg4jqGoTqnoJxCjtJGRnAgcc
   bcftiRRqPcUcMlo4QXWvJkkkZZ2I7wrEwudHw4S5g/xHZvvtmFC+N392n
   rYKb+iKc3Ktc37gjXI1Lk6LXvWQ6XY6cViI+qxLOQJXaB5mSiQNRMSbvd
   QZmj/Spi3Srw6IASZs8r7MxdSs27kXI6jDPF9M9jKQsYHXp+lfO0pKOKq
   iFpIA7Itq0jaN/uPZ8Ev6EsaaCr9eMKxVT6404XTi0h111ZtGig87RqVu
   nGXUrvRoAnPZ1M7Gx7I7LGqFTYiCvPSsyCxtpcnnQ0mgdrgn0FrI2njtQ
   Q==;
X-CSE-ConnectionGUID: 4DJO9g5bSZGhM/so4VouBg==
X-CSE-MsgGUID: RqyzofCHTiyuPX4fcHyKiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65602246"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65602246"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 20:45:47 -0800
X-CSE-ConnectionGUID: EZUaproFSIWT2LRBTsJ+Qw==
X-CSE-MsgGUID: YHKEMx03Ts+BHnsIkAQ9Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196380880"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 19 Nov 2025 20:45:45 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 0/4] KVM: x86: Advertise new instruction CPUIDs for Intel Diamond Rapids
Date: Thu, 20 Nov 2025 13:07:16 +0800
Message-Id: <20251120050720.931449-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series advertises new instruction CPUIDs to userspace, which are
supported by Intel Diamond Rapids platform.

I've attached the spec link for each (family of) instruction in each
patch. Since the instructions included in this series don't require
additional enabling work, pass them through to guests directly.

This series is based on the master branch at the commit 23cb64fb7625
("Merge tag 'soc-fixes-6.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc").

Thanks for your review!

Best Regards,
Zhao
---
Zhao Liu (4):
  KVM: x86: Advertise MOVRS CPUID to userspace
  KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
  KVM: x86: Advertise AVX10.2 CPUID to userspace
  KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/cpuid.c               | 46 ++++++++++++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h       | 15 ++++++++++
 4 files changed, 62 insertions(+), 2 deletions(-)

-- 
2.34.1


