Return-Path: <kvm+bounces-64993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D03C9732F
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 53BB34E1619
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BF830BB8F;
	Mon,  1 Dec 2025 12:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OMeJrqfW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709362556E;
	Mon,  1 Dec 2025 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764591537; cv=none; b=VboCXOCoqhk5zJDwFEYJQP+5iaquicB8W1lNYgQ3aUOBKQaDiL3SXON/A3QZzEBfTBVonMeZ+3Qrco9kn7ISAopIoapd8msjqs8niohdsQ1byAB2HO4Wneb4sQwLCdKolRkrAgtVheDGwb6/1bvwBE1QFbAWPEMCB8iF+nOZklg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764591537; c=relaxed/simple;
	bh=36GWoyOiBWKUseEdU0FZPUtWqcXD22lEp7PWmJNpUQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFGQM9Mu6oupLQ8+829cjtNCot4JefdfJB2kHPu689M3F1muCno7qr3VsIne5+RnBPP93fNX3Whyw63INT+sglefNM5xbfWwFNOk/z2kWERz63dl5HvHvZ9SYLmhUtLvXPGOoasHUwI/v09ugv+fvOsIwARBc8GK7BoULPkjfvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OMeJrqfW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764591535; x=1796127535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=36GWoyOiBWKUseEdU0FZPUtWqcXD22lEp7PWmJNpUQw=;
  b=OMeJrqfW+OETXdx2pQcEjKAqpmmOmMkYPp8EJPxnL0jeYaE6lDM8jnsI
   ubWcxUSlVLgsLWue034A5uVjLSHyygFdgEUc/YFV8XPvA/eBEdNA8/mIB
   SwBnQ+WrVn7MKI3m4lybQqqfUtPPp2G7opIRqLGFbyRryI5Ki4s+yH9AE
   5hLKs3yGHlJB2GvoLO1xbmrjgsnc+3gaOpSEjjLXMKhH3gVNCogW1Zpyl
   eqQSrgdWSjO7ZWjqWRel7xyTCi1AhxQJd0J7QrGtaChAKZ3CinPyoNc15
   //0M3yxo/IpLErooZHV5t5j72GsE408zuf8IsYJFaM1iVDtL8mEqVXV43
   g==;
X-CSE-ConnectionGUID: X/LOOWkgSc+V9AQnLGLV+Q==
X-CSE-MsgGUID: UWXqufeiRMKLXwxCSKM7aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="54082125"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="54082125"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 04:18:54 -0800
X-CSE-ConnectionGUID: UTJe9RRyRDud+yaZrLBE5g==
X-CSE-MsgGUID: aVH4haoiRmyqIqR0NXHY5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="198265338"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 01 Dec 2025 04:18:52 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQ2ri-000000008kP-1AbL;
	Mon, 01 Dec 2025 12:18:50 +0000
Date: Mon, 1 Dec 2025 20:18:44 +0800
From: kernel test robot <lkp@intel.com>
To: Song Gao <gaosong@loongson.cn>, maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] LongArch: KVM: Add DINTC device support
Message-ID: <202512011848.uhe7LBBn-lkp@intel.com>
References: <20251128091125.2720148-3-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128091125.2720148-3-gaosong@loongson.cn>

Hi Song,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20251128]
[also build test WARNING on v6.18]
[cannot apply to kvm/queue kvm/next tip/irq/core mst-vhost/linux-next linus/master kvm/linux-next v6.18-rc7 v6.18-rc6 v6.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Gao/LongArch-KVM-Add-some-maccros-for-AVEC/20251128-173944
base:   next-20251128
patch link:    https://lore.kernel.org/r/20251128091125.2720148-3-gaosong%40loongson.cn
patch subject: [PATCH v2 2/4] LongArch: KVM: Add DINTC device support
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20251201/202512011848.uhe7LBBn-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251201/202512011848.uhe7LBBn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512011848.uhe7LBBn-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kvm/intc/dintc.c:93:14: warning: unused variable 'kvm' [-Wunused-variable]
      93 |         struct kvm *kvm;
         |                     ^~~
>> arch/loongarch/kvm/intc/dintc.c:94:26: warning: unused variable 'dintc' [-Wunused-variable]
      94 |         struct loongarch_dintc *dintc;
         |                                 ^~~~~
   2 warnings generated.


vim +/kvm +93 arch/loongarch/kvm/intc/dintc.c

    90	
    91	static void kvm_dintc_destroy(struct kvm_device *dev)
    92	{
  > 93		struct kvm *kvm;
  > 94		struct loongarch_dintc *dintc;
    95	
    96		if (!dev || !dev->kvm || !dev->kvm->arch.dintc)
    97			return;
    98	
    99		kfree(dev->kvm->arch.dintc);
   100	}
   101	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

