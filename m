Return-Path: <kvm+bounces-43581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD733A91D97
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 15:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9CE440CDD
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 13:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D938241678;
	Thu, 17 Apr 2025 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DFWyXApu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F11F2F24;
	Thu, 17 Apr 2025 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744896002; cv=none; b=JIQM2Kn4QNj+E8JgSHXukF3Cm6p0ABkv8Tghmr79RGYf9wkx/Tn5D6/3LCXbWhMoB6L3TQ7xxPGsTODuoZMog9fbapTMoTph+PBmvj1csVOJVkzD2Wzk2I/CvF6udn2QbqifYE+NtyE6nSPlJYWeVSC7HgXGnehdA2mLQCLvUqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744896002; c=relaxed/simple;
	bh=R74eHFU/0VM0qbwM8f66kxjCo3hJufj/0OcqrSIi1L0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VcGXS8i2RAyqKaBgMu7kp01hRUbRfftacKS6yX1aCkeKWiJkkfpDdEKOu0urNQJKN10uLPixMDR4P4+h4QTLjGoQJ/674zPtRk8jZXhuGHFu9cutUiW5xY4GwPIKQhTZ+Ulb3OLgL2oEb8wUohRewgRyNsgXfH2ktd/RSaXz/K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DFWyXApu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744896001; x=1776432001;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R74eHFU/0VM0qbwM8f66kxjCo3hJufj/0OcqrSIi1L0=;
  b=DFWyXApuPTU+5dFPKPI4xUvZ/MICU6tBM8W4V9ZKvc8oU6IVaMqzYkTI
   jXrsUOOLrn9bAQOyjiZXqI8CFV351aJEBxGHhuk0l/Tp15qzQW2GSIp+r
   Opx4+l9upM8qdcn44ydWA/C/CTfy3G/qrFRq5cilik1kKPFoD88dobqlb
   omeubPAD+QlXdketvcqtSAFs6it7mCrhANpcmnLTtOSPJXKc9uTn+apCY
   EXoGR7c+58YLHblCnCXkb7T2saHyiPA+g6J/jcOGZP4thA8y25XmYbq8P
   avXFBsZBktU/nhU8P/PFv2JMN+70fQRPMo42yxsp4r+o8Xyzw5Ct6WJht
   g==;
X-CSE-ConnectionGUID: WMQYCGAUQNqzesXtkRIqnA==
X-CSE-MsgGUID: X3mWUISGSkObRY+lm+qyMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="57852575"
X-IronPort-AV: E=Sophos;i="6.15,219,1739865600"; 
   d="scan'208";a="57852575"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 06:20:00 -0700
X-CSE-ConnectionGUID: 8ZRz2hgfSsOlWB4FrE2wUg==
X-CSE-MsgGUID: 5WcKwC7uQ9StrXfXBcVVxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,219,1739865600"; 
   d="scan'208";a="131708171"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.254.135])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 06:19:56 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: mlevitsk@redhat.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 0/1] KVM: TDX: Decrease TDX VM shutdown time
Date: Thu, 17 Apr 2025 16:19:44 +0300
Message-ID: <20250417131945.109053-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

The version 1 RFC:

	https://lore.kernel.org/all/20250313181629.17764-1-adrian.hunter@intel.com/

listed 3 options and implemented option 2.  Sean replied with code for
option 1, which tested out OK, so here it is plus a commit log.

It depends upon kvm_trylock_all_vcpus(kvm) which is the assumed result
of Maxim's work-in-progress here:

      https://lore.kernel.org/all/20250409014136.2816971-1-mlevitsk@redhat.com/

Note it is assumed that kvm_trylock_all_vcpus(kvm) follows the return value
semantics of mutex_trylock() i.e. 1 means locks have been successfully
acquired, 0 means not succesful.


Sean Christopherson (1):
      KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM

 Documentation/virt/kvm/x86/intel-tdx.rst | 16 ++++++++
 arch/x86/include/uapi/asm/kvm.h          |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 63 ++++++++++++++++++++++----------
 3 files changed, 61 insertions(+), 19 deletions(-)


Regards
Adrian

