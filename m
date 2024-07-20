Return-Path: <kvm+bounces-22017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E15EC9382E3
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 23:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EA6AB21AD1
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 21:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9926F148FF0;
	Sat, 20 Jul 2024 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heEcpuJp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4B14882D
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 21:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721509855; cv=none; b=DTr4h1UXnKQuTFBR4i72+ShR+CoVC+mVowjJDrN0igYdZcrXsKBafYKgoUrlznWjnWJX9N2Bsr78Ezk588wQ0WYmUqZZMf7mxidfDmObbv5yjcbitnQAV457FAPBkS8oCS55kjd7V3eEHp94LUEmxWNNg7RQ0LWaRLEcYjps9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721509855; c=relaxed/simple;
	bh=E87CfM8eRzmTD/oUeY572x2PdHXss++0ht79jRwSYyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ch3HgmMZqLW9kAlR0MCOURRuFsCQpzk+c0LuN90tTS11cM2xkBfRNnGxOax9M3pbYpSXPJI35FeKL3XrtPXXnJda24KDHINofJ2FuDj7ekYzJ2BQ6tW7L2LbynIdqfTXm3/UIM6MuIFBJt+AOlKU6dHVor5oB5p7eJLwOpMA/MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heEcpuJp; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721509852; x=1753045852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E87CfM8eRzmTD/oUeY572x2PdHXss++0ht79jRwSYyk=;
  b=heEcpuJpt0v5JdF1pSRSg27qh+514DjazkW4+WPcDJO5Dm0BkS4SMClR
   3qReD+P8/ZzSZN5OlQtEhf13rLKdkuFCVcX+OraZstINmzcgQyDQyrvQJ
   eCl9HlNMmIp0Fi7/Kiru3HWrZRzo5qUSiNUvoampD7zCrij1xQ6bKSXAf
   pCRyXmgWNAfI8emDcbf6jGYernwP9MHnEc1HEvTddoHi2R5mvvAnAnhqP
   c4YI6nqlXwM1pmw/94dq9eVBtB6whGSS3HYyQ3XO/VfiH4dDpHIki/Fqe
   d68MTJs9/2rh6h4i998FI2JahlNuV/UVydOXnbBkGlPMwLMq+QVChPqJR
   Q==;
X-CSE-ConnectionGUID: havSdeoSQ96/bEMKkyQApA==
X-CSE-MsgGUID: uBLU9BQkT9244we68xu6ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11139"; a="22921386"
X-IronPort-AV: E=Sophos;i="6.09,224,1716274800"; 
   d="scan'208";a="22921386"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2024 14:10:52 -0700
X-CSE-ConnectionGUID: 0E/9Ui6DQvKeQFtq3KGC9g==
X-CSE-MsgGUID: z/hnWvf+QkyPo7StBD7xMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,224,1716274800"; 
   d="scan'208";a="51427078"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Jul 2024 14:10:50 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sVHLr-000jeE-39;
	Sat, 20 Jul 2024 21:10:47 +0000
Date: Sun, 21 Jul 2024 05:10:07 +0800
From: kernel test robot <lkp@intel.com>
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, pdurrant@amazon.co.uk, dwmw@amazon.co.uk,
	nh-open-source@amazon.com, Ilias Stamatis <ilstam@amazon.com>
Subject: Re: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
Message-ID: <202407210447.D2HLgqLd-lkp@intel.com>
References: <20240718193543.624039-4-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718193543.624039-4-ilstam@amazon.com>

Hi Ilias,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on next-20240719]
[cannot apply to mst-vhost/linux-next linus/master kvm/linux-next v6.10]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ilias-Stamatis/KVM-Fix-coalesced_mmio_has_room/20240719-034316
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240718193543.624039-4-ilstam%40amazon.com
patch subject: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
config: riscv-randconfig-r121-20240719 (https://download.01.org/0day-ci/archive/20240721/202407210447.D2HLgqLd-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce: (https://download.01.org/0day-ci/archive/20240721/202407210447.D2HLgqLd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407210447.D2HLgqLd-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/riscv/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __poll_t [usertype] mask @@     got int @@
   arch/riscv/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse:     expected restricted __poll_t [usertype] mask
   arch/riscv/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse:     got int

vim +241 arch/riscv/kvm/../../../virt/kvm/coalesced_mmio.c

   231	
   232	static __poll_t coalesced_mmio_buffer_poll(struct file *file, struct poll_table_struct *wait)
   233	{
   234		struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
   235		__poll_t mask = 0;
   236	
   237		poll_wait(file, &dev->wait_queue, wait);
   238	
   239		spin_lock(&dev->ring_lock);
   240		if (dev->ring && (READ_ONCE(dev->ring->first) != READ_ONCE(dev->ring->last)))
 > 241			mask = POLLIN | POLLRDNORM;
   242		spin_unlock(&dev->ring_lock);
   243	
   244		return mask;
   245	}
   246	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

