Return-Path: <kvm+bounces-59286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06157BB03E1
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 13:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 203007A67C0
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 11:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61C02E283E;
	Wed,  1 Oct 2025 11:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LBKrq1Gc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097862522BE;
	Wed,  1 Oct 2025 11:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759319457; cv=none; b=QQTM6r6a7yyYJ3OLG12Z2t2KykT3DfZbChyeJlqT1RKLxTjny1qm6eF5OaViUkgRDM7mc/xGZUjozSOP3qe4raiOewZLtrGiuCkeJv81nT5N9kZTARLbLn2/TaxwN9hUBZywQsVEzagug74VZrsrbbWknzKNqR9xLPrA5StnJP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759319457; c=relaxed/simple;
	bh=UUMgyh1khVMAvCaYjTZGs4C0yTwafGUhOSzbw+S1OlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p92rQQI47wMK6bSRncYDnixVtoIjlSmAzFU7C1yB/Co7pg7PmsoZBrs0jmUaYW11Mj1xdjX5BW52g6J7i//H4h+CVDItkNbTm0X8JBN+sWkP3jYaJkT47PdYv1CtT4awujUsv2PnhmvgI4LoQob3suZyHRdIjxWeHCoU3GLuCBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LBKrq1Gc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759319456; x=1790855456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UUMgyh1khVMAvCaYjTZGs4C0yTwafGUhOSzbw+S1OlM=;
  b=LBKrq1GcrfHQRdxDPp2doNE2IqsPjuYdxAZg2R+Edm12DKLh/+7HmaKp
   /1w7QEDVtIz2u09vmmPhb8UP75B6aZ8q40gx5zXYHefQSBLsLcJRNosIt
   EYPzCngZ3Kq6kdZq4VTCX59SVFb/01tnYhDCVfDrCEJh5W8+rLSrm9krK
   2t1hUfC8GfxjLCC8QKTxjQAfrlQlRVqS7O43dwTz2jlKX5t9LgSsF7mNz
   tpGoFZwvO1LpcCo51BO81dDzGWBYOAwqiZsXwpRhsGzFqvtkHl2quzdfB
   XGYKwC6k0nM3hTFWvkv57aLDwVv3ATl6908WM/G5XZdkUiyVO+GbSySdR
   g==;
X-CSE-ConnectionGUID: g4PjAqOmSAGdGJhfEtTgWA==
X-CSE-MsgGUID: Y/KMYMQqT06Tb9SukATZnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="65443970"
X-IronPort-AV: E=Sophos;i="6.18,306,1751266800"; 
   d="scan'208";a="65443970"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 04:50:55 -0700
X-CSE-ConnectionGUID: usEHt5hORTqkcXV+hJVCiA==
X-CSE-MsgGUID: oJ6f0FRMQWy3rQi94VIwEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,306,1751266800"; 
   d="scan'208";a="215893106"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 01 Oct 2025 04:50:53 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3vMB-0002xH-01;
	Wed, 01 Oct 2025 11:50:51 +0000
Date: Wed, 1 Oct 2025 19:50:32 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold
 slots lock
Message-ID: <202510011941.dJGxEiZE-lkp@intel.com>
References: <20250930172850.598938-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930172850.598938-1-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a6ad54137af92535cfe32e19e5f3bc1bb7dbd383]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-selftests-Add-parallel-KVM_GET_DIRTY_LOG-to-dirty_log_perf_test/20251001-013306
base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
patch link:    https://lore.kernel.org/r/20250930172850.598938-1-jthoughton%40google.com
patch subject: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold slots lock
config: x86_64-buildonly-randconfig-005-20251001 (https://download.01.org/0day-ci/archive/20251001/202510011941.dJGxEiZE-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251001/202510011941.dJGxEiZE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510011941.dJGxEiZE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: arch/x86/kvm/../../../virt/kvm/kvm_main.c:2220 function parameter 'protect' not described in 'kvm_get_dirty_log_protect'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

