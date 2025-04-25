Return-Path: <kvm+bounces-44250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E93DA9BF29
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1DAE3A3C02
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C42322E415;
	Fri, 25 Apr 2025 07:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmsjvKXF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA1822A801;
	Fri, 25 Apr 2025 07:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745564749; cv=none; b=SvGHKGUFBFbsj6lm7cdOp9AeeSwjV2z6I2g1DbI9vVBTeIG8bi7gxyizhXxP5+cMgHa4YxLvxGDw2XFMlAgJRNZ+LcfMgsGd/8vg2gugHlzNMCd4XuxcZvGLaWf4GCi+lxLBI9S54Vu991CM0bHJVsfic9HygqEPXF8vpaE3Ht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745564749; c=relaxed/simple;
	bh=N9+UJn6y4cFBdFcoyH2JNE8g1T9WsgLzOAr9war2gvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSmh21CiyZgJTdFewj84vg7EgyG2dSd7XPNLRvAHmIrF3uP62q6jdoDy50bG5FZ1Rt0ioMxUTHGkAdfJQDHCJzSxOFYa01Hp9P2yvyWFc43lXnP6CaLbf3jnD2dhQinkoq0BEZpcdPAg+GS3qDq91qHojVDSg8AvjdvEwDzcfIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmsjvKXF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745564747; x=1777100747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N9+UJn6y4cFBdFcoyH2JNE8g1T9WsgLzOAr9war2gvE=;
  b=QmsjvKXFoSEFZJJhz+1ITEOZQk9MQZaytPsb9wvzGwXt6sT3+A7RNkMz
   pVR2a9IsnE3fi22bYfawLvghK8WtuxmyQasgNtTrjJaHckgK3r7ClgTH8
   S0aOb3R0mhL80wdI0rOAEmY+lYQyBhMkJPw0BgUv1XIuXRbtoVZvzi2da
   8pjqQfOQHj1IkOmsy+LuBn5bgtOVZgLc11QUfYluhJ2m4oTqVxaZ4MqL+
   r8weBJB5TAJcT6ixCuBlURrm4K4VWcYDEgrELkg/+m46aZ/QGjv88IfJI
   X25QJ5CT7X01CUR2aUUCzusLX23ECs97myy7g0Iv/NdJ570P1SuwKAtAp
   Q==;
X-CSE-ConnectionGUID: 7hArsK8SSzWhSc+1J+VBiA==
X-CSE-MsgGUID: 87PfgpVYTCGQ3ZcKPfg8Vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="49877224"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="49877224"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:05:46 -0700
X-CSE-ConnectionGUID: 5XZttJ3MSH6P0E+RUKkd/w==
X-CSE-MsgGUID: wlvduCpeStiokvFAcP1zww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="163789917"
Received: from lkp-server01.sh.intel.com (HELO 050dd05385d1) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 25 Apr 2025 00:05:44 -0700
Received: from kbuild by 050dd05385d1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u8D81-0004uH-0o;
	Fri, 25 Apr 2025 07:05:41 +0000
Date: Fri, 25 Apr 2025 15:05:15 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LoongArch: KVM: Add parameter exception code with
 exception handler
Message-ID: <202504251458.EJKsZMLH-lkp@intel.com>
References: <20250424064625.3928278-2-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424064625.3928278-2-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 9d7a0577c9db35c4cc52db90bc415ea248446472]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-parameter-exception-code-with-exception-handler/20250424-144905
base:   9d7a0577c9db35c4cc52db90bc415ea248446472
patch link:    https://lore.kernel.org/r/20250424064625.3928278-2-maobibo%40loongson.cn
patch subject: [PATCH 1/2] LoongArch: KVM: Add parameter exception code with exception handler
config: loongarch-randconfig-001-20250425 (https://download.01.org/0day-ci/archive/20250425/202504251458.EJKsZMLH-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250425/202504251458.EJKsZMLH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504251458.EJKsZMLH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kvm/exit.c:734: warning: Function parameter or struct member 'ecode' not described in 'kvm_handle_fpu_disabled'


vim +734 arch/loongarch/kvm/exit.c

2737dee1067c2f Bibo Mao     2025-01-13  725  
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  726  /**
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  727   * kvm_handle_fpu_disabled() - Guest used fpu however it is disabled at host
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  728   * @vcpu:	Virtual CPU context.
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  729   *
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  730   * Handle when the guest attempts to use fpu which hasn't been allowed
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  731   * by the root context.
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  732   */
74303fac8d0580 Bibo Mao     2025-04-24  733  static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
37cdfc6dbf0416 Tianrui Zhao 2023-10-02 @734  {
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  735  	struct kvm_run *run = vcpu->run;
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  736  
db1ecca22edf27 Tianrui Zhao 2023-12-19  737  	if (!kvm_guest_has_fpu(&vcpu->arch)) {
db1ecca22edf27 Tianrui Zhao 2023-12-19  738  		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
db1ecca22edf27 Tianrui Zhao 2023-12-19  739  		return RESUME_GUEST;
db1ecca22edf27 Tianrui Zhao 2023-12-19  740  	}
db1ecca22edf27 Tianrui Zhao 2023-12-19  741  
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  742  	/*
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  743  	 * If guest FPU not present, the FPU operation should have been
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  744  	 * treated as a reserved instruction!
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  745  	 * If FPU already in use, we shouldn't get this at all.
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  746  	 */
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  747  	if (WARN_ON(vcpu->arch.aux_inuse & KVM_LARCH_FPU)) {
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  748  		kvm_err("%s internal error\n", __func__);
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  749  		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  750  		return RESUME_HOST;
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  751  	}
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  752  
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  753  	kvm_own_fpu(vcpu);
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  754  
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  755  	return RESUME_GUEST;
37cdfc6dbf0416 Tianrui Zhao 2023-10-02  756  }
71f4fb845874c3 Tianrui Zhao 2023-10-02  757  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

