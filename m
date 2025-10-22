Return-Path: <kvm+bounces-60854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E1EBFE2F5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 22:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5CB23A5F9A
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 20:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7DD2FAC16;
	Wed, 22 Oct 2025 20:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMNd2+9P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAF279DCA;
	Wed, 22 Oct 2025 20:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761165324; cv=none; b=hqKAVOLztHZ0ii2ewtWISWHz1sKIhghXT7IKnsQjb0FGepzYyj5is0DU1hZ+y2nagUO09Hcd8TcUYcqCHa28MLFeb4jN0vd/Bx3jn6fuSzGJMT40nbySuz1QHXEsSb/1xyUFyChSPZNxHLo//JBN4woWwPZBEm6aSt5WwfPxwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761165324; c=relaxed/simple;
	bh=UVYE2m+dfTC8L+h8OkbpueMO00XTqC0cIJ5IUlC3jFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSYtsPjtOYzIYg2LdvZMUFVkmPAu7h9lR98sRQeuKh/vqygcpzpqbpFTcrAo+o3fsHMtnOMOjlRkLo3S7YwcKSFFiBHvKDWSGSPOpXFFmwizFcAOH4t7IYpIniGyU0vjK03k4qUEZtvAE4VSMAfhgH88lsUVUro82zeow+mCmpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMNd2+9P; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761165321; x=1792701321;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UVYE2m+dfTC8L+h8OkbpueMO00XTqC0cIJ5IUlC3jFI=;
  b=bMNd2+9PjXWCl1gCSE8ydNU/bdOgcd/BnMIzy8E28Sx4ZcH+QOdPdfEf
   2qUjRwVS2fbzDFcUVglXvatC2Ol2tfo8MFaDiVvkNtITx5pn1GzvnBXk9
   NXcgkx3vKTLHowOWKZ4A3ConbD34Oh7iYAwzY8QfoZATkxSZjp4xOvGq9
   49MKLsF5VZlfg6SIRGagDnyr3rEmqpEQt0te1GnDsvnnzW3PVNVMhxoXo
   vIMPFhm3qY1etMWBDKHFygfop0hJsMuSjEDL1wYC3Kzz7AGaNwcmgdI9p
   SoKFv8jG++exP48XBvx2nqoA4zzEVw7KqRv8msnZumVDUlnYLGAHAVJpi
   g==;
X-CSE-ConnectionGUID: 826GThlNQimTRcRSbtwVxw==
X-CSE-MsgGUID: PSqgL3AnSNGXi0f3qERBaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63420807"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="63420807"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 13:35:21 -0700
X-CSE-ConnectionGUID: kwvg8BHhTeq3LPk10Ou7sg==
X-CSE-MsgGUID: hXOMDYU6RfmVGxNjnZQgDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="214906268"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 22 Oct 2025 13:35:17 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBfYB-000CiH-1x;
	Wed, 22 Oct 2025 20:35:15 +0000
Date: Thu, 23 Oct 2025 04:34:39 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Min Mina Chou <minachou@andestech.com>, anup@brainfault.org,
	atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, tim609@andestech.com,
	minachou@andestech.com, ben717@andestech.com, az70021@gmail.com
Subject: Re: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
Message-ID: <202510230412.vKIvCmwU-lkp@intel.com>
References: <20251021083105.4029305-1-minachou@andestech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021083105.4029305-1-minachou@andestech.com>

Hi Hui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next mst-vhost/linux-next linus/master v6.18-rc2 next-20251022]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Min-Mina-Chou/RISC-V-KVM-flush-VS-stage-TLB-after-VCPU-migration-to-prevent-stale-entries/20251021-163357
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251021083105.4029305-1-minachou%40andestech.com
patch subject: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration to prevent stale entries
config: riscv-randconfig-r072-20251023 (https://download.01.org/0day-ci/archive/20251023/202510230412.vKIvCmwU-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251023/202510230412.vKIvCmwU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510230412.vKIvCmwU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/riscv/kvm/vmid.c:126:6: warning: no previous prototype for 'kvm_riscv_local_tlb_sanitize' [-Wmissing-prototypes]
     126 | void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_riscv_local_tlb_sanitize +126 arch/riscv/kvm/vmid.c

   125	
 > 126	void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

