Return-Path: <kvm+bounces-25426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9664E9654D1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 416671F24016
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 01:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7F65FBB7;
	Fri, 30 Aug 2024 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XKkHpXyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E033450F2;
	Fri, 30 Aug 2024 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724982229; cv=none; b=RN18FaZ5KJCTHl+l/e893NACpA5ej7U60/jW+PQ/4jFUD+CZzS9Fa+T5cvmHsLswwFQnw898Cf139fvifZZ80a4Vv0WUoITAOPnnwT32r6+O5ZPqwdWRa/umrqGZWXxVi6y33d2yRMtxlouMgFdJMD0w1Ge0seKVikeagiuGB0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724982229; c=relaxed/simple;
	bh=V433bZhtMYb7+G7RMOW1g6PFqCsMDcv+wSGMB9hyQOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeCIb7zfoWhdttGId0D2wcT6lsUhPWfpQ650DW3GICz2WrYY0omtRGH5NG3ray/tznKpUC9LgEJ/eDN3w9rfUCTMiaIQhuwbTd0QdiavTbsSiaIVLfR34+DDYEmR5mSNV8zxZbgfwTEd1jpnfAAnamVYc71AXW5BWEkJgFvpfXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XKkHpXyz; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724982227; x=1756518227;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V433bZhtMYb7+G7RMOW1g6PFqCsMDcv+wSGMB9hyQOw=;
  b=XKkHpXyzQ7hFVb0ScaKZU5lqlN9CB7ohU2LHkxkYTPagtCp8IF+BliqN
   4zTXzEs7g1o7Jtdk+8b54pvgkK14rv2oZObechQx5SxqY9MdfdYaWp1yA
   wFvmMUpiRnWKUT/dE+HUmmrkHDYOf5zRsNLA23ajNP9gCuI2u2PleqrtT
   uQXM6dwn1T34F5WHtouLi+iT9rGJTlXqoOfbf6GwimvTkGeMbJYkszl8M
   xHpIM7zAWckfCk3HA5XrS5u4jL333GDKaEkLNb8/a/iOo7BhpkgHWE4RK
   AmKQlOi2JzGY9av99bDIqx5ARIAVXNerg5cD2SGXv7KerMgOdMlKKui2s
   A==;
X-CSE-ConnectionGUID: 4k4tCR8MRvCngOYfaVB76A==
X-CSE-MsgGUID: n5+glQgDSGW4OvuK+XQ4sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23777589"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="23777589"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 18:43:47 -0700
X-CSE-ConnectionGUID: dCqQGFnESNKp68znt/3Prg==
X-CSE-MsgGUID: gRT5k2GJSb2eWIen8o8oQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63605389"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 29 Aug 2024 18:43:44 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sjqft-0000s2-2n;
	Fri, 30 Aug 2024 01:43:41 +0000
Date: Fri, 30 Aug 2024 09:43:12 +0800
From: kernel test robot <lkp@intel.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	maz@kernel.org, arnd@linaro.org,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 1/3] ampere/arm64: Add a fixup handler for alignment
 faults in aarch64 code
Message-ID: <202408300927.4oarShZN-lkp@intel.com>
References: <20240827130829.43632-2-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827130829.43632-2-alex.bennee@linaro.org>

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on pci/next pci/for-linus arnd-asm-generic/master akpm-mm/mm-everything kvmarm/next soc/for-next linus/master arm/for-next arm/fixes v6.11-rc5 next-20240829]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Benn-e/ampere-arm64-Add-a-fixup-handler-for-alignment-faults-in-aarch64-code/20240827-211409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20240827130829.43632-2-alex.bennee%40linaro.org
patch subject: [PATCH 1/3] ampere/arm64: Add a fixup handler for alignment faults in aarch64 code
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20240830/202408300927.4oarShZN-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240830/202408300927.4oarShZN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408300927.4oarShZN-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/mm/fault_neon.c:17:5: warning: no previous prototype for '__arm64_get_vn_dt' [-Wmissing-prototypes]
      17 | u64 __arm64_get_vn_dt(int n, int t) {
         |     ^~~~~~~~~~~~~~~~~
>> arch/arm64/mm/fault_neon.c:41:6: warning: no previous prototype for '__arm64_set_vn_dt' [-Wmissing-prototypes]
      41 | void __arm64_set_vn_dt(int n, int t, u64 val) {
         |      ^~~~~~~~~~~~~~~~~


vim +/__arm64_get_vn_dt +17 arch/arm64/mm/fault_neon.c

    16	
  > 17	u64 __arm64_get_vn_dt(int n, int t) {
    18		u64 res;
    19	
    20		switch (n) {
    21	#define V(n)						\
    22		case n:						\
    23			asm("cbnz %w1, 1f\n\t"			\
    24			    "mov %0, v"#n".d[0]\n\t"		\
    25			    "b 2f\n\t"				\
    26			    "1: mov %0, v"#n".d[1]\n\t"		\
    27			    "2:" : "=r" (res) : "r" (t));	\
    28			break
    29		V( 0); V( 1); V( 2); V( 3); V( 4); V( 5); V( 6); V( 7);
    30		V( 8); V( 9); V(10); V(11); V(12); V(13); V(14); V(15);
    31		V(16); V(17); V(18); V(19); V(20); V(21); V(22); V(23);
    32		V(24); V(25); V(26); V(27); V(28); V(29); V(30); V(31);
    33	#undef V
    34		default:
    35			res = 0;
    36			break;
    37		}
    38		return res;
    39	}
    40	
  > 41	void __arm64_set_vn_dt(int n, int t, u64 val) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

