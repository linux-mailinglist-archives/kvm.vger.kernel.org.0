Return-Path: <kvm+bounces-39869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 723BEA4BC6E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 11:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 919A116AAA7
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 10:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA771F2369;
	Mon,  3 Mar 2025 10:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l+YT59F1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F175323F383
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 10:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740998143; cv=none; b=dGtcKEm1CJAl2+lPTSCOSpsmdL5huWDuXiZPd2OKT4Tem3cof9+Usk67LF80yaMttWZiwOYO3M3MlmhlIUXCqyGuLj6vPkFqplcrVKxq/TpgFgrYQoGbyuXi35o7+z3b2EtKfVmxBrdA2Fr7URn9qP7q34UgPiVv8By68gjIw5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740998143; c=relaxed/simple;
	bh=5aq+G0Bzn4VXWg1AnnA5JqplnpGYdJxurhXlZLnqDj8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=T/YTIMK8Ez7jEO67XleWa2F200kSkQjbqRFoDkPfDtK2lA0ZQUdBq53ZaWkkL9BG+DenkqnoHqWsXRtVUz9UEbSyMUD5+FjrYLoMZuah1XAqJGK86cpqK9P1o1jQX6koD+AmqJrFYLCxC+fqwFHZkd9frUmV6fzAqQrQCwg0jMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l+YT59F1; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740998141; x=1772534141;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5aq+G0Bzn4VXWg1AnnA5JqplnpGYdJxurhXlZLnqDj8=;
  b=l+YT59F1dKUB9E1MCnJ9gfBB1vWfEoWz3vB+7Vo32BmhmKnWSyPfaJZH
   UYGJtiSwGZWIF6csdl34d9bd++pUDlFG+Zq10ZW1a1JwrhsK9fY5JJV15
   aTPKEkFaWewytXAflXFJA60oN3bkl1fAqmH4UjaxLGgoR0jmrfmaGq141
   Zl4izp4EF5vAl2983X1srsVEKd71uXDN+aCPSFurNuktgB1N6yBXEqpAI
   ir9Ayg1174ZSKBLVPb9MTs4e3/AGVHlqnunp4OxS0PiLz18Eykpm0M2wl
   HiulO/AXmymTDgR7mUqQkuZa26wLYI69mTY0mGSogeZi+6NZHEcR8AUUm
   A==;
X-CSE-ConnectionGUID: ZyEsocf3RRCht7PDeHmMHg==
X-CSE-MsgGUID: X6YSI3FyTpCLzvDOBnz55w==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="64310933"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="64310933"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 02:35:41 -0800
X-CSE-ConnectionGUID: YmYGwzXLRW6At+ExZRr26Q==
X-CSE-MsgGUID: d5onUBErS6SlSolP+acwMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="141181386"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 03 Mar 2025 02:35:38 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tp395-000ILn-28;
	Mon, 03 Mar 2025 10:35:35 +0000
Date: Mon, 3 Mar 2025 18:35:07 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [kvm:kvm-coco-queue 100/127] ERROR: modpost: "tdx_vcpu_reset"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503031822.wt8JQ1HS-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   9fe4541afcfad987d39790f0a40527af190bf0dd
commit: ca80e4f7d4764a266c7c75c5cc7ec9bf072faef7 [100/127] KVM: TDX: Always block INIT/SIPI
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250303/202503031822.wt8JQ1HS-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250303/202503031822.wt8JQ1HS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503031822.wt8JQ1HS-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_disable_virtualization_cpu" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_create" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_free" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_vcpu_reset" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_prepare_switch_to_guest" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_load" [arch/x86/kvm/kvm-intel.ko] undefined!
WARNING: modpost: suppressed 20 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

