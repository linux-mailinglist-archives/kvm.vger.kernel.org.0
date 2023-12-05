Return-Path: <kvm+bounces-3569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E71568055BF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A02A7281A98
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7135D8EB;
	Tue,  5 Dec 2023 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJcBDR0V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB60120
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 05:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701782566; x=1733318566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AHTG5//HsS+ik+KHalxVDEMMIBv5EzNnWR91SRis9eY=;
  b=ZJcBDR0VboxTykzPfWplpbfpPt1oy4GsB0Z028AW3/XlXCsDefc+pokX
   9pSwZaSjCB5sJMJeSKnIejoJjiwjWdGJY9rjTeINovkham+ehAp+ECzqF
   uEfWCugTuXSkK4wWYNNbxabhOJCRZ4fa3TrbGNwBosqov2gnjIfzi1EuD
   WbR52IWM+WKF/9Q6UdXsGxFhsU4uNgLusE8XHF73WTlsGv6H6yJhAfGUD
   dX8aKGs3NGYyOM93VRdBpaMyDDNPk4Pm51rfU22o0oNjN8XMrCIuODyON
   /f/R6pWVGuhdpysyZ29E0bOZecb4E+jRalEFFUAIy8xy4YkJIwpJVMFkA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="975419"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="975419"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 05:22:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="799972189"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="799972189"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 05 Dec 2023 05:22:43 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rAVNn-00092Q-1M;
	Tue, 05 Dec 2023 13:22:39 +0000
Date: Tue, 5 Dec 2023 21:22:10 +0800
From: kernel test robot <lkp@intel.com>
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, anup@brainfault.org,
	atishp@atishpatra.org, palmer@dabbelt.com, ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: Re: [PATCH 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
Message-ID: <202312052128.oBSS3Uus-lkp@intel.com>
References: <20231204182905.2163676-4-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204182905.2163676-4-dbarboza@ventanamicro.com>

Hi Daniel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next linus/master v6.7-rc4 next-20231205]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Henrique-Barboza/RISC-V-KVM-set-vlenb-in-kvm_riscv_vcpu_alloc_vector_context/20231205-023109
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20231204182905.2163676-4-dbarboza%40ventanamicro.com
patch subject: [PATCH 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20231205/202312052128.oBSS3Uus-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231205/202312052128.oBSS3Uus-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312052128.oBSS3Uus-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/riscv/kvm/vcpu_onereg.c: In function 'num_vector_regs':
>> arch/riscv/kvm/vcpu_onereg.c:991:39: warning: unused variable 'cntx' [-Wunused-variable]
     991 |         const struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
         |                                       ^~~~


vim +/cntx +991 arch/riscv/kvm/vcpu_onereg.c

   988	
   989	static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
   990	{
 > 991		const struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
   992	
   993		if (!riscv_isa_extension_available(vcpu->arch.isa, v))
   994			return 0;
   995	
   996		/* vstart, vl, vtype, vcsr, vlenb; */
   997		return 5;
   998	}
   999	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

