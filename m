Return-Path: <kvm+bounces-48979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF4AAD5092
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 11:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C96A83A7A8B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFC225F998;
	Wed, 11 Jun 2025 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmXCf9dP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B532AD2C;
	Wed, 11 Jun 2025 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749635535; cv=none; b=Yeqidr59r2zgPtGZNKckWBz2j3j/v0hUilCD5gtb54M/ERab4alHGtw7D98+ZmlkMVk7/m4FysWYS9bbSRCRfK9wFly4z53k2+Dxp3s9g3x+fms8ONinNJUVjY1uCINgfMZfQQgkxCr20WPsK9ApFdpdQab6007bpF36lQsipDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749635535; c=relaxed/simple;
	bh=fmPcNr5AAY+k0xHn5ajYpTwRMOitZ2SEYpt3CxdEDgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N6xsxvIZp2jq1gFOcRaJjytQOMUmMvEOwQJin/ciXI+i3i45nFUqGsk9EP5BsybnUeg4uOK18WLP2ll78pUeSQjsxocAuu0RJRdtiml1wjoEOEXmR2lYQkhiGJcVt5zXf9iTrZr59ZruSz0UsUvwrOYFNVlCpQkHrtnvfr5+cAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmXCf9dP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749635533; x=1781171533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fmPcNr5AAY+k0xHn5ajYpTwRMOitZ2SEYpt3CxdEDgw=;
  b=nmXCf9dPJjfnzkAIN+xFQlfYLD1t6wAy0D8x96GpiVJRNGoiLP6bruIs
   Pa14M6rNfjZ3hrKQLDcZufTvB+pGejorL2XcnMA8epaIr26yBPe07TIza
   BdPGzLD3+ydrF7yVODbOdah94UqdsB1l0uDEE7BnSN/VnDXDEZmZ1ScNI
   5RxQpXI8ZOaG+iWl2UR/dNRZmYk36yPvjlNTNUd4RlG2Y/bwUPGq0tpXi
   PZYt5cf2w6gn4DjaUbqXRMLEJyBNaOnIHeHEw15MICFKMQ70Zm+hWZsiP
   9h5fsmjN7M0hpjad5iX5144ovYX+A6oEyOnN/wBv5RXjTDdJ05c1wfX7S
   A==;
X-CSE-ConnectionGUID: coYnner1ShKvEUlRG/yZvQ==
X-CSE-MsgGUID: BxFYoPS8S1Sd+iXm48exzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51872623"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51872623"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:52:13 -0700
X-CSE-ConnectionGUID: iTGG/IBiQ92WWewtDjNs2A==
X-CSE-MsgGUID: Ct6i9CPwQZGIRrDsZDR1bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="184350709"
Received: from opintica-mobl1 (HELO localhost.localdomain) ([10.245.245.146])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:52:08 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
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
Subject: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Date: Wed, 11 Jun 2025 12:51:57 +0300
Message-ID: <20250611095158.19398-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Changes in V4:

	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
	Use KVM_BUG_ON() instead of WARN_ON().
	Correct kvm_trylock_all_vcpus() return value.

Changes in V3:
	Refer:
            https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com

	Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
	trigger on the error path from __tdx_td_init()

	Put cpus_read_lock() handling back into tdx_mmu_release_hkid()

	Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
	tdx_vm_ioctl() deal with kvm->lock


The version 1 RFC:

	https://lore.kernel.org/all/20250313181629.17764-1-adrian.hunter@intel.com/

listed 3 options and implemented option 2.  Sean replied with code for
option 1, which tested out OK, so here it is plus a commit log.

It depends upon kvm_trylock_all_vcpus(kvm) which is now upstream:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e4a454ced74c0ac97c8bd32f086ee3ad74528780


Sean Christopherson (1):
      KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM

 Documentation/virt/kvm/x86/intel-tdx.rst | 16 +++++++++++++++
 arch/x86/include/uapi/asm/kvm.h          |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 34 ++++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 8 deletions(-)


Regards
Adrian

