Return-Path: <kvm+bounces-39623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 182FFA48862
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21FDD16E7D9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474A923AE7B;
	Thu, 27 Feb 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjJoSFjD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C81234979;
	Thu, 27 Feb 2025 18:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740682683; cv=none; b=gCHgoJTRq6I8qV3si2BPEYDpA7L9Y6dGmvGQBlsspJBe29mUlZq07akAupQM6O/270FGmBQyX2bRkWexvbDaZr1N8VypV79YCqDd//7h+vroLKeuCKOWHE5aTHnTM3aCcjPbb/yn9uE0EpnBOdpBr6E8gmGwxSkwh2EOxLx9ZgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740682683; c=relaxed/simple;
	bh=YDxplo6/yUUqQJnXZQYQKrL+F9KSK94+hXUMdYhYX2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxhZ7aVonHXS9d/8AJcBUTwnx14GqpBOJ5qfMqzz3EBI3NSQ+/w2nOYcXW27eHYzKCqpfqmFc7e/sPeN4z7WsHo0iCMjYe+jo8ib5UjORHtohj0qOI7dttyuzkY6jvQAR21VKZM0E/pXwhWx6C+/+u2M6gGgbIez1T0gXdOH9+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjJoSFjD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740682681; x=1772218681;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YDxplo6/yUUqQJnXZQYQKrL+F9KSK94+hXUMdYhYX2Y=;
  b=gjJoSFjDWyikuO34WrzsXL5ri0pXLBMb38GEINcOHZzkJv17gkpHeFTf
   gNEIDwu5gHhtkpouA9zhZduzLftIc0YCfaFOOXpJMlhlQ90Kwj5C20Aer
   LzNM91q5P6y3+hYdI2+KenkXq+gtXXVqQxOxKvfmFuyA7BtgIF9fGQ3m8
   vxKo2U6d8Vs74Wk1DFV0xoSQABf3YM0Hp1+lWk/KACSk//OtYTWyBqPe3
   LKwJKjddm+85HNzXGHf+v+OF2G3/8ifuA1J0Yj+955jjbExn6MfbGLT4o
   aDZIn9kLB+A1/0bS+F/vMGK4nws/wu1ITBMHm8qRLuNr07zG7LFa3fIuH
   w==;
X-CSE-ConnectionGUID: RkKvEYk2TmOOKrFQf+fM5g==
X-CSE-MsgGUID: T9q2nSu4Sx2ZiO51qdzDEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="53002988"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="53002988"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 10:58:00 -0800
X-CSE-ConnectionGUID: pduxVrnNRw6rr4V5IP2CaA==
X-CSE-MsgGUID: wIOTKHxhR626VhQaKeWzUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="122128314"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 27 Feb 2025 10:57:56 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tnj50-000Du0-0o;
	Thu, 27 Feb 2025 18:57:54 +0000
Date: Fri, 28 Feb 2025 02:57:20 +0800
From: kernel test robot <lkp@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
	amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
Message-ID: <202502280218.Jdd4jjlZ-lkp@intel.com>
References: <20250224131522.77104-5-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224131522.77104-5-vaibhav@linux.ibm.com>

Hi Vaibhav,

kernel test robot noticed the following build warnings:

[auto build test WARNING on powerpc/fixes]
[also build test WARNING on kvm/queue kvm/next powerpc/topic/ppc-kvm linus/master v6.14-rc4 next-20250227]
[cannot apply to powerpc/next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vaibhav-Jain/powerpc-Document-APIv2-KVM-hcall-spec-for-Hostwide-counters/20250224-211903
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git fixes
patch link:    https://lore.kernel.org/r/20250224131522.77104-5-vaibhav%40linux.ibm.com
patch subject: [PATCH v4 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
config: powerpc-kismet-CONFIG_KVM_BOOK3S_HV_PMU-CONFIG_KVM_BOOK3S_64_HV-0-0 (https://download.01.org/0day-ci/archive/20250228/202502280218.Jdd4jjlZ-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250228/202502280218.Jdd4jjlZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502280218.Jdd4jjlZ-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for KVM_BOOK3S_HV_PMU when selected by KVM_BOOK3S_64_HV
   WARNING: unmet direct dependencies detected for KVM_BOOK3S_HV_PMU
     Depends on [n]: VIRTUALIZATION [=y] && KVM_BOOK3S_64_HV [=y] && HV_PERF_CTRS [=n]
     Selected by [y]:
     - KVM_BOOK3S_64_HV [=y] && VIRTUALIZATION [=y] && KVM_BOOK3S_64 [=y] && PPC_POWERNV [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

