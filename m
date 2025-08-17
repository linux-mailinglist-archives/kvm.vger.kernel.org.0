Return-Path: <kvm+bounces-54840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9286EB2923B
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 10:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C90F3B4952
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 08:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BD2219301;
	Sun, 17 Aug 2025 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bkHQQv9T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0AF1D63D8;
	Sun, 17 Aug 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755419033; cv=none; b=Jlmz4mLjcqumIDXN2n4n0anDhGlH6xX74JZQqDTaYd8EkaeR6COqwvWpYYETzLa5pgedY3v+x4f5wN4ePjDnqifxNU/M8etyjP3t67tHoyReSkYlZWNHKP6fhzRd+teE/MTsTRUR8Z91XtmiFNThbSPOZhlDHAUciL3EC3gN0ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755419033; c=relaxed/simple;
	bh=RZAnz7L85Wfz24qIoBnlsJGnPIYsmf8V4ssxmCvYkzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/Ws3yZSrCojDjbYu2wNyiQD94ugRnKwwN5JhnBBu5rAEvvCAehYLvl+bWRHogduH/PTPH/2Q63yhfp0/WOT+hwhULNBhH8/ZM8gbh0h35NGhbWA64o01lMSXglacljU7J7pdnLQ8om7KY/umWQ/va6Itrk9XyN7ON6sNSVfzow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bkHQQv9T; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755419031; x=1786955031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RZAnz7L85Wfz24qIoBnlsJGnPIYsmf8V4ssxmCvYkzI=;
  b=bkHQQv9TDwJ+27zSaM4af2P/amydVeNWa6x6vOPCnhfl8Vl5VisBXi65
   t0m43CTwWiW6/PC9cxIhtoblMZz2N3mUcqRSha6wyO9x8Qr55rPKFEnhD
   vcvGGwvDPVR3jsJWwlPU+yHijjU4xl731Yo1oYmscLCspY7Fx/4OMzKzT
   4SMMi6tqc400R6qerVIOdmViiodMmtbbf2l6EOf9O9AFtrMVZlrUH8FLR
   2+8tgSzIasQMh/Lk1+zP9A6WIo0NqID1sGPuVdUTJVxDlpTb8EYO5Q3XH
   vTC8xtgBoWbAGcusox+QEkl8GwiQwI34A8JCFTK6PxuZ1eseqS4gx5iM4
   g==;
X-CSE-ConnectionGUID: 1t1xlSIPSAGz7NPc/hAVqQ==
X-CSE-MsgGUID: yhyu9U64TOyqwcNfeXNOKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="69041013"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="69041013"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 01:23:51 -0700
X-CSE-ConnectionGUID: bjJLIwlUSRmjcf8/bTZHlg==
X-CSE-MsgGUID: 7anPUwZpTUSNNe2QAQ62FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="168147451"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 17 Aug 2025 01:23:47 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unYg5-000DQN-0O;
	Sun, 17 Aug 2025 08:23:45 +0000
Date: Sun, 17 Aug 2025 16:22:50 +0800
From: kernel test robot <lkp@intel.com>
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	guoren@linux.alibaba.com, guoren@kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: Re: [PATCH] RISC-V: KVM: Write hgatp register with valid mode bits
Message-ID: <202508171655.76Ifmphq-lkp@intel.com>
References: <20250816073234.77646-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816073234.77646-1-fangyu.yu@linux.alibaba.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next mst-vhost/linux-next linus/master v6.17-rc1 next-20250815]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/fangyu-yu-linux-alibaba-com/RISC-V-KVM-Write-hgatp-register-with-valid-mode-bits/20250816-153513
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250816073234.77646-1-fangyu.yu%40linux.alibaba.com
patch subject: [PATCH] RISC-V: KVM: Write hgatp register with valid mode bits
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20250817/202508171655.76Ifmphq-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250817/202508171655.76Ifmphq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508171655.76Ifmphq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/riscv/kvm/vmid.c:31:24: error: call to undeclared function 'kvm_riscv_gstage_mode'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
                                 ^
>> arch/riscv/kvm/vmid.c:31:48: warning: shift count >= width of type [-Wshift-count-overflow]
           csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
                                                         ^  ~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/csr.h:538:38: note: expanded from macro 'csr_write'
           unsigned long __v = (unsigned long)(val);               \
                                               ^~~
   1 warning and 1 error generated.


vim +31 arch/riscv/kvm/vmid.c

    24	
    25	void __init kvm_riscv_gstage_vmid_detect(void)
    26	{
    27		unsigned long old;
    28	
    29		/* Figure-out number of VMID bits in HW */
    30		old = csr_read(CSR_HGATP);
  > 31		csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
    32		vmid_bits = csr_read(CSR_HGATP);
    33		vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
    34		vmid_bits = fls_long(vmid_bits);
    35		csr_write(CSR_HGATP, old);
    36	
    37		/* We polluted local TLB so flush all guest TLB */
    38		kvm_riscv_local_hfence_gvma_all();
    39	
    40		/* We don't use VMID bits if they are not sufficient */
    41		if ((1UL << vmid_bits) < num_possible_cpus())
    42			vmid_bits = 0;
    43	}
    44	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

