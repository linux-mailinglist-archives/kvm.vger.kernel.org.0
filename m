Return-Path: <kvm+bounces-37159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A46A26545
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE16F1885F85
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC5B20F09A;
	Mon,  3 Feb 2025 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxmc/mCG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EA31E7C20;
	Mon,  3 Feb 2025 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738616849; cv=none; b=NYDt/SqND6QkqyBfMIfLZhuZSwEfz3wowtb0QrVWEEih82JOgArFnghocHc8lHC7vY420DztsIrWsN6FWSSRAOgwDzr1Vc2tud2EWD55qkF549d1VWdonbA46wnRrXKfhpiS+Ruvd/CoFPV7ZUy3RD62y9XT0abOtScYyfeZVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738616849; c=relaxed/simple;
	bh=I6E+KMf+GC7gcZDiOUy+LrrXr+s80/o+Eqd493BSBcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duN4NlzfLgP8BoE0+2IYpLPB79QPa3LbUWTDdfkz3QDSIXa0risq1PF9uq3FtcDEAWFLMY00LV2IJCHLrtsPaVE4wJmDgdQW7sjKQir3l+NJ8TWGOtCmiE+3Gv/3Xkwt3zFi1Z/fcGnyibMcb+36DbBw+7xxhQWHxw/FxA6nqi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxmc/mCG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738616847; x=1770152847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I6E+KMf+GC7gcZDiOUy+LrrXr+s80/o+Eqd493BSBcw=;
  b=hxmc/mCGZI2jT6oeRYFAWd2YcKB/dKOXYzTJC7VSW38lZZdcLRhJzk4/
   CyqPShPzaOr1vsdjDxnqInc2MMw6Drw+KI0DkGOFKqo5q7cb7ClREmtT3
   sppVIKideOa/s3/g/TV9PfnnEo7E/vH2PRW/p/JbFjjVB6hXf8WXhyCsO
   d8gFsD++4IpqCrXiHHcNDpQCQVBmvR3CY9itN1ORTUx2La5eudD4BKbSa
   evM/sMBFocyy5FB+CBAe6ZpxKX2K5ofaZlhD39S5bdQZIEQ9g5rdMRkTs
   tT01xuoUZMBnPQ34QTGmYU2YJ2yzVRGB2fiZq4cYo5egvT9UCygquUloF
   g==;
X-CSE-ConnectionGUID: yR3X3FeKRqurGuxM0uc4rw==
X-CSE-MsgGUID: zmH6HdExSqmjp1xcJJwtBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="50538727"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="50538727"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2025 13:07:26 -0800
X-CSE-ConnectionGUID: u7ApK2OGQ0CWTyIheuKY8Q==
X-CSE-MsgGUID: nAhNm/7wQ16zDiTFT72Ydg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,256,1732608000"; 
   d="scan'208";a="110171999"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 03 Feb 2025 13:07:24 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tf3f8-000rX1-0I;
	Mon, 03 Feb 2025 21:07:22 +0000
Date: Tue, 4 Feb 2025 05:06:32 +0800
From: kernel test robot <lkp@intel.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
Message-ID: <202502040421.WqVoesZI-lkp@intel.com>
References: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>

Hi Naveen,

kernel test robot noticed the following build errors:

[auto build test ERROR on eb723766b1030a23c38adf2348b7c3d1409d11f0]

url:    https://github.com/intel-lab-lkp/linux/commits/Naveen-N-Rao-AMD/KVM-SVM-Increase-X2AVIC-limit-to-4096-vcpus/20250203-144127
base:   eb723766b1030a23c38adf2348b7c3d1409d11f0
patch link:    https://lore.kernel.org/r/b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen%40kernel.org
patch subject: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
config: x86_64-randconfig-008-20250203 (https://download.01.org/0day-ci/archive/20250204/202502040421.WqVoesZI-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250204/202502040421.WqVoesZI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502040421.WqVoesZI-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/svm/avic.c:20:
   In file included from include/linux/kvm_host.h:16:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> arch/x86/kvm/svm/avic.c:88:66: error: expected ')'
      88 | static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
         |                                                                  ^
   arch/x86/include/asm/apic.h:258:23: note: expanded from macro 'x2apic_mode'
     258 | #define x2apic_mode             (0)
         |                                  ^
   arch/x86/kvm/svm/avic.c:88:66: note: to match this '('
   arch/x86/include/asm/apic.h:258:22: note: expanded from macro 'x2apic_mode'
     258 | #define x2apic_mode             (0)
         |                                 ^
   arch/x86/kvm/svm/avic.c:88:66: warning: omitting the parameter name in a function definition is a C23 extension [-Wc23-extensions]
      88 | static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
         |                                                                  ^
   arch/x86/include/asm/apic.h:258:23: note: expanded from macro 'x2apic_mode'
     258 | #define x2apic_mode             (0)
         |                                  ^
   2 warnings and 1 error generated.


vim +88 arch/x86/kvm/svm/avic.c

    87	
  > 88	static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
    89	{
    90		u32 avic_max_physical_id = x2apic_mode ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
    91	
    92		/*
    93		 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
    94		 * represents the max APIC ID for this vm, rather than the max vcpus.
    95		 */
    96		return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
    97	}
    98	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

