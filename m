Return-Path: <kvm+bounces-65907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3EBCBA0F0
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 286973019A6A
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9C130FC18;
	Fri, 12 Dec 2025 23:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UY5uSwZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC8D26980F;
	Fri, 12 Dec 2025 23:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765582723; cv=none; b=JzIeAvPL/oORxVMMpq1lfOFqHga+NjgdzNIxV9Jh8XTUmaat7hiF+axhRGwZWVHTHlc9xxxKuOfDxvU1HxgpcB9LeWDIAsxtPIxClOT2NQk12IC30E++7LDvnirI9hr7xxJ00hBs6CriFQjClyp4jqlgKSls4NK2wixjWMw8Wzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765582723; c=relaxed/simple;
	bh=1TEZNcBwE82RjeHmZcGWakhq+kP2FM6p/Az90EbpiFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dewub5oBy+EOBIRuyhCqscpV9GAvQT94t+hVmlSk/KSeassnHW8BXf5muWAXGbwoyi3VOeJpH0V9O/IZAJHMDObS0JYzbfj6/FQpT0/4QRID3OyiC9uEW9gcgRMO+QMcLoI3Cz0pZg/IHbmi7rt5J9gFCKY0K/HurewIjkg0Vds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UY5uSwZ4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765582722; x=1797118722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1TEZNcBwE82RjeHmZcGWakhq+kP2FM6p/Az90EbpiFw=;
  b=UY5uSwZ4khPyo/ep+M04nph7juPujQUkK/2i+SRfYAKQnOWnAqeUboiH
   TGtiCSmYSvNRCV9PjWgRuv3B7RS+SsZNAfD4TH/Tt+jo+jE5+GCl095ZH
   PENDP1LaAhcDyapnBKJYvUOcM1oisJD3wcBWEPtk188+ta7TWqjcmmKJt
   769V0Vw+OhdUiHJY8ZNAHM0kaPowKjUuxAEcNlYo5N73k6lgAJl0xNBM/
   fYUWFh0GPnjIj50GdAFYX00KdRxdnsWVIF0gs2iwNbCQTfuWXn1ClVKwo
   pfgEEbJmDUTGIb2+LIi8DxeHaIjUGr8+KMAbC+TJKKs+uSTS/cfER8zqx
   A==;
X-CSE-ConnectionGUID: PL2gPPHNQc6CCLpXkMq/iw==
X-CSE-MsgGUID: sLrQiRWOTTuF0u8ASZNovg==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67746451"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="67746451"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 15:38:42 -0800
X-CSE-ConnectionGUID: qTxzGNQNQWGbNO7vLtJ81Q==
X-CSE-MsgGUID: 1RSWUwV3SZqajfMAe1iRTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="201388547"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 12 Dec 2025 15:38:39 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vUCib-000000006lx-1Bt7;
	Fri, 12 Dec 2025 23:38:37 +0000
Date: Sat, 13 Dec 2025 07:38:13 +0800
From: kernel test robot <lkp@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	farrah.chen@intel.com
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
Message-ID: <202512130717.aHH8rXSC-lkp@intel.com>
References: <20251212135051.2155280-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212135051.2155280-1-xiaoyao.li@intel.com>

Hi Xiaoyao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoyao-Li/KVM-x86-Don-t-read-guest-CR3-when-doing-async-pf-while-the-MMU-is-direct/20251212-220612
base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
patch link:    https://lore.kernel.org/r/20251212135051.2155280-1-xiaoyao.li%40intel.com
patch subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
config: i386-buildonly-randconfig-002-20251213 (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512130717.aHH8rXSC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/kvm_host.h:43,
                    from arch/x86/kvm/irq.h:15,
                    from arch/x86/kvm/mmu/mmu.c:19:
   arch/x86/kvm/mmu/mmu.c: In function 'kvm_arch_setup_async_pf':
>> include/linux/kvm_types.h:54:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '18446744073709551615' to '4294967295' [-Woverflow]
      54 | #define INVALID_GPA     (~(gpa_t)0)
         |                         ^
   arch/x86/kvm/mmu/mmu.c:4525:28: note: in expansion of macro 'INVALID_GPA'
    4525 |                 arch.cr3 = INVALID_GPA;
         |                            ^~~~~~~~~~~


vim +54 include/linux/kvm_types.h

d77a39d982431e drivers/kvm/types.h       Hollis Blanchard 2007-12-03  53  
cecafc0a830f7e include/linux/kvm_types.h Yu Zhang         2023-01-05 @54  #define INVALID_GPA	(~(gpa_t)0)
8564d6372a7d8a include/linux/kvm_types.h Steven Price     2019-10-21  55  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

