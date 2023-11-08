Return-Path: <kvm+bounces-1217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 168EB7E5B1E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3555C1C20B01
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F7D31A90;
	Wed,  8 Nov 2023 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4U1javw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C01F1FD6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:24:32 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88788C6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699460672; x=1730996672;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=iHeMu8spblZXK1/cv94fbR6I+30LMnpTJ0TRGgahjYA=;
  b=V4U1javw+P/NIbNoMZ6p5qslktSRrn4KEjz3sX3JSIN7Mky0Gk/Gx1NA
   MCO+Eyd+rwJ8F995pNn7O+436Om7kCbmEx92iS6UdYdcKdSKAawIKkpx2
   KdPBF67rJ/fnYHQNHesFG9X/Dkk+lPPLxuOsX5faYQYvDfP9gRYbZQxVq
   2K1blxd8lRCNFm9SwRFiZsNBIp8+XT7NJrmMLRnXpI18ymBgyHQbu0XN8
   TX5T9V1hT6J1cbBF/scFm5plEGLpgRPhJMgzeMUTlLep1NOr+ypYLocoK
   J3ZphZ2o3swStVkihpllol34odytbAnP+6iJJm0XwRKM9BJl4skfBDESz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="11357278"
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="11357278"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 08:24:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,286,1694761200"; 
   d="scan'208";a="4233795"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Nov 2023 08:24:31 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r0lLv-00081A-2q;
	Wed, 08 Nov 2023 16:24:27 +0000
Date: Thu, 9 Nov 2023 00:24:08 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:guestmemfd 59/59]
 arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5517:14: error:
 'KVM_TRACE_ENABLE' undeclared; did you mean 'KVM_PV_ENABLE'?
Message-ID: <202311082321.AnOtleNK-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git guestmemfd
head:   cd689ddd5c93ea177b28029d57c13e18b160875b
commit: cd689ddd5c93ea177b28029d57c13e18b160875b [59/59] KVM: remove deprecated UAPIs
config: loongarch-randconfig-002-20231108 (https://download.01.org/0day-ci/archive/20231108/202311082321.AnOtleNK-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231108/202311082321.AnOtleNK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311082321.AnOtleNK-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_dev_ioctl':
>> arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5517:14: error: 'KVM_TRACE_ENABLE' undeclared (first use in this function); did you mean 'KVM_PV_ENABLE'?
    5517 |         case KVM_TRACE_ENABLE:
         |              ^~~~~~~~~~~~~~~~
         |              KVM_PV_ENABLE
   arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5517:14: note: each undeclared identifier is reported only once for each function it appears in
>> arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5518:14: error: 'KVM_TRACE_PAUSE' undeclared (first use in this function)
    5518 |         case KVM_TRACE_PAUSE:
         |              ^~~~~~~~~~~~~~~
>> arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5519:14: error: 'KVM_TRACE_DISABLE' undeclared (first use in this function); did you mean 'KVM_PV_DISABLE'?
    5519 |         case KVM_TRACE_DISABLE:
         |              ^~~~~~~~~~~~~~~~~
         |              KVM_PV_DISABLE


vim +5517 arch/loongarch/kvm/../../../virt/kvm/kvm_main.c

f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5488  
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5489  static long kvm_dev_ioctl(struct file *filp,
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5490  			  unsigned int ioctl, unsigned long arg)
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5491  {
f15ba52bfabc3b virt/kvm/kvm_main.c    Thomas Huth     2023-02-08  5492  	int r = -EINVAL;
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5493  
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5494  	switch (ioctl) {
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5495  	case KVM_GET_API_VERSION:
f0fe510864a452 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5496  		if (arg)
f0fe510864a452 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5497  			goto out;
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5498  		r = KVM_API_VERSION;
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5499  		break;
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5500  	case KVM_CREATE_VM:
e08b96371625aa virt/kvm/kvm_main.c    Carsten Otte    2012-01-04  5501  		r = kvm_dev_ioctl_create_vm(arg);
f17abe9a44425f drivers/kvm/kvm_main.c Avi Kivity      2007-02-21  5502  		break;
018d00d2fef27f drivers/kvm/kvm_main.c Zhang Xiantao   2007-11-15  5503  	case KVM_CHECK_EXTENSION:
784aa3d7fb6f72 virt/kvm/kvm_main.c    Alexander Graf  2014-07-14  5504  		r = kvm_vm_ioctl_check_extension_generic(NULL, arg);
85f455f7ddbed4 drivers/kvm/kvm_main.c Eddie Dong      2007-07-06  5505  		break;
07c45a366d89f8 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5506  	case KVM_GET_VCPU_MMAP_SIZE:
07c45a366d89f8 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5507  		if (arg)
07c45a366d89f8 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5508  			goto out;
adb1ff46754a87 virt/kvm/kvm_main.c    Avi Kivity      2008-01-24  5509  		r = PAGE_SIZE;     /* struct kvm_run */
adb1ff46754a87 virt/kvm/kvm_main.c    Avi Kivity      2008-01-24  5510  #ifdef CONFIG_X86
adb1ff46754a87 virt/kvm/kvm_main.c    Avi Kivity      2008-01-24  5511  		r += PAGE_SIZE;    /* pio data page */
5f94c1741bdc7a virt/kvm/kvm_main.c    Laurent Vivier  2008-05-30  5512  #endif
4b4357e02523ec virt/kvm/kvm_main.c    Paolo Bonzini   2017-03-31  5513  #ifdef CONFIG_KVM_MMIO
5f94c1741bdc7a virt/kvm/kvm_main.c    Laurent Vivier  2008-05-30  5514  		r += PAGE_SIZE;    /* coalesced mmio ring page */
adb1ff46754a87 virt/kvm/kvm_main.c    Avi Kivity      2008-01-24  5515  #endif
07c45a366d89f8 drivers/kvm/kvm_main.c Avi Kivity      2007-03-07  5516  		break;
d4c9ff2d1b78e3 virt/kvm/kvm_main.c    Feng(Eric  Liu  2008-04-10 @5517) 	case KVM_TRACE_ENABLE:
d4c9ff2d1b78e3 virt/kvm/kvm_main.c    Feng(Eric  Liu  2008-04-10 @5518) 	case KVM_TRACE_PAUSE:
d4c9ff2d1b78e3 virt/kvm/kvm_main.c    Feng(Eric  Liu  2008-04-10 @5519) 	case KVM_TRACE_DISABLE:
2023a29cbe3413 virt/kvm/kvm_main.c    Marcelo Tosatti 2009-06-18  5520  		r = -EOPNOTSUPP;
d4c9ff2d1b78e3 virt/kvm/kvm_main.c    Feng(Eric  Liu  2008-04-10  5521) 		break;
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5522  	default:
043405e10001fe drivers/kvm/kvm_main.c Carsten Otte    2007-10-10  5523  		return kvm_arch_dev_ioctl(filp, ioctl, arg);
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5524  	}
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5525  out:
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5526  	return r;
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5527  }
6aa8b732ca01c3 drivers/kvm/kvm_main.c Avi Kivity      2006-12-10  5528  

:::::: The code at line 5517 was first introduced by commit
:::::: d4c9ff2d1b78e385471b3f4d80c0596909926ef7 KVM: Add kvm trace userspace interface

:::::: TO: Feng(Eric) Liu <eric.e.liu@intel.com>
:::::: CC: Avi Kivity <avi@qumranet.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

