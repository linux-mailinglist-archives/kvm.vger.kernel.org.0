Return-Path: <kvm+bounces-65952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFDECBC237
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 01:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 69C4D3002D41
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 00:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285372E7160;
	Mon, 15 Dec 2025 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnAUT1ZF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C755A2E5D32
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 00:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765757756; cv=none; b=UBWBS1IPxCmVqIJekJjS93QKTmZ3mDgf0ApYb7gMoCTGtVZn3QXP9fuY8sVfdXrBz3HckftJBjrZYwVTK39BoEfe/Ig+d+p+ASJovlKetvj7Dr8+kbPNLq1bbeiiFQ8K1FGKguaHOj17KGTYo5mie7xwkO45u0SjYtMzADe1zWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765757756; c=relaxed/simple;
	bh=6vO9OPJFXH8fJHuAE5U1pt8kHsXsUM50SQnjRnDfTjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rxlm4p2q8lfgRskfFuzN05QbEicZ+ORneeoMONVZuCuAUl+k0tawiEen7q8vBFd4sx2y3DBZ0FCTazfvHS2AjJyKjlGSxjhCcUs9DH4E9GpzRwISaLHm/kHMzD+G53vMaj/XkoNuHbx9chkfj0TiYqwDzdEIkfZZJYx9TPDjf9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnAUT1ZF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765757755; x=1797293755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6vO9OPJFXH8fJHuAE5U1pt8kHsXsUM50SQnjRnDfTjc=;
  b=BnAUT1ZFNwBEfTmcgs2Xdv1nSWTe+EFBkN0c6nSUKdCX4yevSlFNvXWk
   FeQvNsTuaHLQ4u3sOvHRTr9ISdZubLUCrb4oEYebjtmRMoWTSSs3sEtpc
   AuptQIWMZda8xyLqkWNB5/n/MBKKtWwEqo360126BlsGSnZwTJTTHpuUC
   Jvla9Gg0SR7Fmp6BSYbe8oG2sQ/NTStvICn/Xvmf+xOF4g83xEs0Y6Yv8
   Isd+poUoVPefmzEHXxzaDDr/NUdCOUWr9jQOdpfGi81X/uX/w4uYRjcZX
   aDrC6ETuepxkE+Iwp2CkKqctGGrSZi5s4cg7rVa2XSFsV9arxR42SP9wt
   g==;
X-CSE-ConnectionGUID: +09zFFgKS5uoHcJLTAa4xA==
X-CSE-MsgGUID: T9RCd8lCQl6NMbuomZcmig==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="85253707"
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="85253707"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 16:15:54 -0800
X-CSE-ConnectionGUID: g0FLMlKmS8O7naC0yBHObg==
X-CSE-MsgGUID: cDHUDq0hQO6apXALujtp6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="202093788"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 14 Dec 2025 16:15:50 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vUwFg-000000002Vs-2YCT;
	Mon, 15 Dec 2025 00:15:48 +0000
Date: Mon, 15 Dec 2025 01:15:42 +0100
From: kernel test robot <lkp@intel.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 31/32] Documentation: KVM: Introduce documentation for
 VGICv5
Message-ID: <202512150153.QbgdGdcn-lkp@intel.com>
References: <20251212152215.675767-32-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212152215.675767-32-sascha.bischoff@arm.com>

Hi Sascha,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc1 next-20251212]
[cannot apply to kvmarm/next arm64/for-next/core kvm/queue kvm/next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sascha-Bischoff/KVM-arm64-Account-for-RES1-bits-in-DECLARE_FEAT_MAP-and-co/20251212-233140
base:   linus/master
patch link:    https://lore.kernel.org/r/20251212152215.675767-32-sascha.bischoff%40arm.com
patch subject: [PATCH 31/32] Documentation: KVM: Introduce documentation for VGICv5
reproduce: (https://download.01.org/0day-ci/archive/20251215/202512150153.QbgdGdcn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512150153.QbgdGdcn-lkp@intel.com/

All warnings (new ones prefixed by >>):

   ERROR: Cannot find file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/mutex.h
   WARNING: No kernel-doc for file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/fwctl.h
   WARNING: No kernel-doc for file ./include/linux/fwctl.h
>> Documentation/virt/kvm/devices/arm-vgic-v5.rst: WARNING: document isn't included in any toctree [toc.not_included]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

