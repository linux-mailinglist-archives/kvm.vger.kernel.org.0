Return-Path: <kvm+bounces-45750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29E4AAE762
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1BEF3BB6DB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C543628C020;
	Wed,  7 May 2025 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FoXB5uwl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4345420B7FC
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746637532; cv=none; b=BH0XeTLJrg8gAv5STdrvmpdmQ0UU8f3intBFNlgUXdYRuEB1xd3kEX8TkqoSi4BexW+p5omBiQi03U9kqvQCod3v3AdwUAZegF5CdkjS5tstxh2MDBMYduHkOCsGWWAJzVePQ7k4Xpn0ISHCdE2LgYtoiamyr+218ad36nxzOFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746637532; c=relaxed/simple;
	bh=QjXPtL2Z0FqNpEjJnoeiA6m6hX40d2nW0ON106J55h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWOMyCfT4KwJxm5ql9CF61vo9zvnPaKnEzbjJ25qhy3/D9PyKnuNhjig14xN9mmFVjYOWDpri1NGe6fZVd3EuwvFlR6PXEk2inz/jYhqj4rdKAvP30ibtT6XY1nHg4CeYJrS1ALxhbNykVHQH5/9adztDjhGFVm/UhbmSd3ZuJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FoXB5uwl; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746637530; x=1778173530;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QjXPtL2Z0FqNpEjJnoeiA6m6hX40d2nW0ON106J55h8=;
  b=FoXB5uwly7Avi0+F69gRANnmFkziWwHAiWtGgaHLSk+5dgfApQM30dJO
   8kR1AtUgp81wpUdEZei3y8a3EanRGkAL0YxBhaL0qi/PE5Oh5BVWhmauH
   55nRcTN7+hTSa87kSiuGbAOmwyx+lKI7mkIAcQI9dUc2WxOPyIHEvrXuv
   fH18kUc8Uf7XjAbv6XY1za94W0N9tjuZw44pPCByzMJBi4kPwuGJFqsUy
   t4fxdydNz999OO9HZdFJWSB+yIRWq2QP8YN7/vAseBc0d8+O/S+L+U2Kp
   bY6Iwbb348ntFDbmHVOFy6TB3PUmbUbtWy30iC4YnP8vvJqqrCExI8otd
   A==;
X-CSE-ConnectionGUID: ZbrpKKOLTZ6F2lvs3PkwZQ==
X-CSE-MsgGUID: 732Xb75+RoOpebZ1/o8/sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="47483865"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="47483865"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 10:05:29 -0700
X-CSE-ConnectionGUID: EUj57wh/TIG5s2ri294RQw==
X-CSE-MsgGUID: LstyuS/4R5uY8DhjXubgTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="136037095"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 07 May 2025 10:05:21 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCiCs-0008CH-2V;
	Wed, 07 May 2025 17:05:18 +0000
Date: Thu, 8 May 2025 01:04:31 +0800
From: kernel test robot <lkp@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Anup Patel <anup@brainfault.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sebastian Ott <sebott@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Alexandre Ghiti <alex@ghiti.fr>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH v3 1/4] arm64: KVM: use mutex_trylock_nest_lock when
 locking all vCPUs
Message-ID: <202505080024.CZZ0ssB5-lkp@intel.com>
References: <20250430202311.364641-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430202311.364641-2-mlevitsk@redhat.com>

Hi Maxim,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvmarm/next tip/locking/core linus/master v6.15-rc5 next-20250507]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxim-Levitsky/arm64-KVM-use-mutex_trylock_nest_lock-when-locking-all-vCPUs/20250501-042643
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250430202311.364641-2-mlevitsk%40redhat.com
patch subject: [PATCH v3 1/4] arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250508/202505080024.CZZ0ssB5-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250508/202505080024.CZZ0ssB5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505080024.CZZ0ssB5-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_trylock_all_vcpus':
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:1381:22: error: implicit declaration of function 'mutex_trylock_nest_lock'; did you mean 'mutex_lock_nest_lock'? [-Werror=implicit-function-declaration]
    1381 |                 if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
         |                      ^~~~~~~~~~~~~~~~~~~~~~~
         |                      mutex_lock_nest_lock
   cc1: some warnings being treated as errors


vim +1381 arch/x86/kvm/../../../virt/kvm/kvm_main.c

  1370	
  1371	/*
  1372	 * Try to lock all of the VM's vCPUs.
  1373	 * Assumes that the kvm->lock is held.
  1374	 */
  1375	int kvm_trylock_all_vcpus(struct kvm *kvm)
  1376	{
  1377		struct kvm_vcpu *vcpu;
  1378		unsigned long i, j;
  1379	
  1380		kvm_for_each_vcpu(i, vcpu, kvm)
> 1381			if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
  1382				goto out_unlock;
  1383		return 0;
  1384	
  1385	out_unlock:
  1386		kvm_for_each_vcpu(j, vcpu, kvm) {
  1387			if (i == j)
  1388				break;
  1389			mutex_unlock(&vcpu->mutex);
  1390		}
  1391		return -EINTR;
  1392	}
  1393	EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
  1394	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

