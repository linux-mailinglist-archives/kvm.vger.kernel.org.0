Return-Path: <kvm+bounces-71009-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKB4HzEzjmkxAwEAu9opvQ
	(envelope-from <kvm+bounces-71009-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:08:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2658B130DF4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4010A305145D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 20:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC5A3081B8;
	Thu, 12 Feb 2026 20:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lsxd9BZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4D229DB6A;
	Thu, 12 Feb 2026 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770926809; cv=none; b=Z7LY0QYTTa5Zo9ZkRI5xiZudSp3mRKL+gqBW8Koe7snOhHRODEUSVQvCU7z67nUyet6wMe25JWLeEH5/UzBgLgeCfIxWH848aI4ZEk26sygpZNGdt/gTTxK0tqR75ULe7oEaJp4t5ZqswDyxrQerFRi+5DeXZJSObBrHr8dsGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770926809; c=relaxed/simple;
	bh=KvR6yJtJg3M/klyQgTMwpht6W37h/fXEStbRmD8w9is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozLgY6GJ9rVP97Wwb1+xpxNvk/Tcf4h2v7UdfJRrvz6OzfijH0IDgUi2cQ6UrKUJJFtAJZSpmvlWUY4y2ZI9XCAUEKSQgmcyX5zaSabXvNn5RaB6HwsEPamo/fW6VRA8wHIf/x/80nL8QKPoYujZ8KxhvKYWNZZNZ+4zw5TcHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lsxd9BZ4; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770926807; x=1802462807;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KvR6yJtJg3M/klyQgTMwpht6W37h/fXEStbRmD8w9is=;
  b=Lsxd9BZ4Fc/5DAgxBiA6TxbHNVzEmDzRsRdEKLCA9qAgpCltSwwUratK
   1XLhj53z3iEFY3AktZHV97mQV8PoVaSlA+mC31qb4RR+bG9U0zX1GVALY
   TyX5Ir3gKISNbXa2hLH4bigV4+jvYait4T8WnX8j96/sTl/TtJiLxbjMW
   DGJENoOjmw22iZP4vsndArs0R7shnQW2wSPARDUqvuDyF0CUJ4JVy7QUR
   gj+aI3on3MGRlmUZCIBniXoAWxpJreav/A/r9mWvGnk0yQErmijQYZaFT
   j6NN6+QCA4PzT0Oz+kckCb8586sivux9L5xjnn/q1jxamRPZlH3Mv7tc0
   A==;
X-CSE-ConnectionGUID: DpsNQUOsQH65uEDVCojFXg==
X-CSE-MsgGUID: 2zTL10hbSjKjpquJoeGHlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="71140783"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="71140783"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 12:06:47 -0800
X-CSE-ConnectionGUID: Rov6hAAqQq+nR3GUtAAQcA==
X-CSE-MsgGUID: HXV0mj9dRei6p2BogmA2Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="211484023"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 12 Feb 2026 12:06:45 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqcxX-00000000ssu-1rcB;
	Thu, 12 Feb 2026 20:06:43 +0000
Date: Fri, 13 Feb 2026 04:05:56 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
Message-ID: <202602130416.oIONAEUp-lkp@intel.com>
References: <20260212105211.1555876-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212105211.1555876-2-pbonzini@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71009-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[git-scm.com:url,intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,01.org:url]
X-Rspamd-Queue-Id: 2658B130DF4
X-Rspamd-Action: no action

Hi Paolo,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvms390/next next-20260212]
[cannot apply to powerpc/topic/ppc-kvm kvmarm/next linus/master kvm/linux-next v6.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-remove-CONFIG_KVM_GENERIC_MMU_NOTIFIER/20260212-185546
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260212105211.1555876-2-pbonzini%40redhat.com
patch subject: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20260213/202602130416.oIONAEUp-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602130416.oIONAEUp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602130416.oIONAEUp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/../../../virt/kvm/kvm_main.c:900:9: error: call to undeclared function 'mmu_notifier_register'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     900 |         return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
         |                ^
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:900:9: note: did you mean 'mmu_notifier_release'?
   include/linux/mmu_notifier.h:598:20: note: 'mmu_notifier_release' declared here
     598 | static inline void mmu_notifier_release(struct mm_struct *mm)
         |                    ^
>> arch/riscv/kvm/../../../virt/kvm/kvm_main.c:1220:3: error: call to undeclared function 'mmu_notifier_unregister'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1220 |                 mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
         |                 ^
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:1220:3: note: did you mean 'preempt_notifier_unregister'?
   include/linux/preempt.h:357:6: note: 'preempt_notifier_unregister' declared here
     357 | void preempt_notifier_unregister(struct preempt_notifier *notifier);
         |      ^
   arch/riscv/kvm/../../../virt/kvm/kvm_main.c:1283:2: error: call to undeclared function 'mmu_notifier_unregister'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1283 |         mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
         |         ^
   3 errors generated.


vim +/mmu_notifier_register +900 arch/riscv/kvm/../../../virt/kvm/kvm_main.c

4c07b0a4b6df45 Avi Kivity 2009-12-20  896  
4c07b0a4b6df45 Avi Kivity 2009-12-20  897  static int kvm_init_mmu_notifier(struct kvm *kvm)
4c07b0a4b6df45 Avi Kivity 2009-12-20  898  {
4c07b0a4b6df45 Avi Kivity 2009-12-20  899  	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
4c07b0a4b6df45 Avi Kivity 2009-12-20 @900  	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
4c07b0a4b6df45 Avi Kivity 2009-12-20  901  }
4c07b0a4b6df45 Avi Kivity 2009-12-20  902  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

