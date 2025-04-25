Return-Path: <kvm+bounces-44276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C489A9C277
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBCA77B4261
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863C8233D88;
	Fri, 25 Apr 2025 08:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RlxGoVAw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6361FCFFB;
	Fri, 25 Apr 2025 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571281; cv=none; b=cC9kgehReWtoAT/+mM8f3+uCa6ix6J1edGP3m5A9I8gSJGTFC2PN9JvZ2nnEoYI/Nrk5LgbTWsLR2lzzP3AjSlY9nGhQqKQUNPVe34vr0oSZX+GnFnqfh3amd8ar7ozmQ6AzLJ6iD7JzmPOrzgg/i/iujvGaDMRnh2l3wC8sEYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571281; c=relaxed/simple;
	bh=F2vi5KexJNi7KPdLu9XG0CKaalY3GtPE37eWYSQEnbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eH5/pGTjRto7e/2gTTvCs5LgX3GB5RD5sviFuiX6nldBjqHjnYa3oTbKJvQBVwoYMakqxbFWKRCf0kBiv9Us/VtVJPRXkapQtrw1tXVQzoVdAfJs89VeIpkBsvV+JZHlCFInwOiGqQHJdH3KKWC2QdYcjXjui1GKGldnPw1A8xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RlxGoVAw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745571280; x=1777107280;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F2vi5KexJNi7KPdLu9XG0CKaalY3GtPE37eWYSQEnbU=;
  b=RlxGoVAwcPu1fkC5q/6XQfVyhm+Zk0JUEb+Ug3CKeoY0vVrz2ttVktBJ
   uP9i3KApPO6OGymGc8JBEnDq/LtX6kST5NkDUsatkSf/vwYpKMNTyeKvI
   H+9gZc5WjeVYtfy8rEU/qYMUqTIpUtXOWwXyZSvJAJIyDsTaM5VMCXTwa
   m5df/sXJsfP0SV1rGfQIKOSsnH76k6wFm52yUYqh7SXWbHMYv12+8+d2t
   4XQyCuca9O5f+teRjg4uP8yVMnT+366ScS77z91egppiCmFWScV68m+s1
   Gj5bJkWOmbli2SJQ106XT4L7p5i/6YX3TPmJ4mOqK4szyzXu8bJ1wVOMl
   g==;
X-CSE-ConnectionGUID: ROEbPY8BRyOFzY6ReqiYEA==
X-CSE-MsgGUID: Y1ajyeb8TlmFgMgTcqXBSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="47349941"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="47349941"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:58:14 -0700
X-CSE-ConnectionGUID: k98pxzmIT9iFOAmFRzLZOw==
X-CSE-MsgGUID: LeE0oQiPSoSG65uZFSsA6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133764269"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.113.29])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:58:09 -0700
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
Subject: [PATCH V3 0/1] KVM: TDX: Decrease TDX VM shutdown time
Date: Fri, 25 Apr 2025 10:57:55 +0300
Message-ID: <20250425075756.14545-1-adrian.hunter@intel.com>
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

