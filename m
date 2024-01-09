Return-Path: <kvm+bounces-5869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39869827E99
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0F651F24721
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435A0947A;
	Tue,  9 Jan 2024 06:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QpS8pW3B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7194A9461;
	Tue,  9 Jan 2024 06:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704780089; x=1736316089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sA9jOFAl/Yz2nJon6qcwL0ATsst7m3Ms+tSbOB128dU=;
  b=QpS8pW3BA+BsIT2qERHYr+RDKrHvmf1Qm/r2WLWWbG33FEYclLKrg1Q4
   YOHiV3VZkiGBKojFGwvLEbwsFNyn0M5DTOQF+yYfBgSxvW6UJsxd7+Hj9
   Q7ipt+v1rwfsAKaXkSGIoeP6gp0/Yj2eOHuV+GvadqoO+6G7DrvWUmngJ
   kiaMGmzxZcZlO+YumebcppRGTnTgBRt9S5Y2JvsOFHCmlRZ8klKt44/5W
   ts1wBAYGWM/SG+rRlH0wOr3ka4sxQMMo88Y7HtLUXGxFz4iAx4vxi4zGA
   yTtxMJaQm/NLnuW5EDjiaSISMim1/0RVME3iDpepIbbZFSu2HsA10k/y3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="4840339"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="4840339"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 22:01:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="900635538"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="900635538"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2024 22:01:19 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rN5Ap-0005WA-1K;
	Tue, 09 Jan 2024 06:01:15 +0000
Date: Tue, 9 Jan 2024 14:00:24 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH 5/5] LoongArch: Add pv ipi support on LoongArch system
Message-ID: <202401091354.GtBERgQJ-lkp@intel.com>
References: <20240103071615.3422264-6-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103071615.3422264-6-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 610a9b8f49fbcf1100716370d3b5f6f884a2835a]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-hypercall-instruction-emulation-support/20240103-151946
base:   610a9b8f49fbcf1100716370d3b5f6f884a2835a
patch link:    https://lore.kernel.org/r/20240103071615.3422264-6-maobibo%40loongson.cn
patch subject: [PATCH 5/5] LoongArch: Add pv ipi support on LoongArch system
config: loongarch-randconfig-r061-20240109 (https://download.01.org/0day-ci/archive/20240109/202401091354.GtBERgQJ-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401091354.GtBERgQJ-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> arch/loongarch/kvm/exit.c:681:5-8: Unneeded variable: "ret". Return "  0" on line 701
--
>> arch/loongarch/kvm/exit.c:720:2-3: Unneeded semicolon

vim +681 arch/loongarch/kvm/exit.c

   678	
   679	static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu, int sgi)
   680	{
 > 681		int ret = 0;
   682		u64 ipi_bitmap;
   683		unsigned int min, cpu;
   684		struct kvm_vcpu *dest;
   685	
   686		ipi_bitmap = vcpu->arch.gprs[LOONGARCH_GPR_A1];
   687		min = vcpu->arch.gprs[LOONGARCH_GPR_A2];
   688	
   689		if (ipi_bitmap) {
   690			cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
   691			while (cpu < BITS_PER_LONG) {
   692				if ((cpu + min) < KVM_MAX_VCPUS) {
   693					dest = kvm_get_vcpu_by_id(vcpu->kvm, cpu + min);
   694					kvm_queue_irq(dest, sgi);
   695					kvm_vcpu_kick(dest);
   696				}
   697				cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG, cpu + 1);
   698			}
   699		}
   700	
 > 701		return ret;
   702	}
   703	
   704	/*
   705	 * hypcall emulation always return to guest, Caller should check retval.
   706	 */
   707	static void kvm_handle_pv_hcall(struct kvm_vcpu *vcpu)
   708	{
   709		unsigned long func = vcpu->arch.gprs[LOONGARCH_GPR_A0];
   710		long ret;
   711	
   712		switch (func) {
   713		case KVM_HC_FUNC_IPI:
   714			kvm_pv_send_ipi(vcpu, INT_SWI0);
   715			ret = KVM_HC_STATUS_SUCCESS;
   716			break;
   717		default:
   718			ret = KVM_HC_INVALID_CODE;
   719			break;
 > 720		};
   721	
   722		vcpu->arch.gprs[LOONGARCH_GPR_A0] = ret;
   723	}
   724	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

