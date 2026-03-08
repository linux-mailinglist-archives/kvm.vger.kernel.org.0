Return-Path: <kvm+bounces-73241-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YF4vA7J2rWkC3QEAu9opvQ
	(envelope-from <kvm+bounces-73241-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:16:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 82575230608
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 143DE301DC39
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 13:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E511F3D56;
	Sun,  8 Mar 2026 13:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e72xK18h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E4382F29;
	Sun,  8 Mar 2026 13:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772975740; cv=none; b=IF4Q6c7DPc/6gVVsXy63vY7Us+ezOrNA0qJeEDJG8PAdECkl0+X7mSlGGMO+bQ46fYmwssyPJfP9DCyw2nQvN8UWpIh9us2wZO3RtHqlEHuHG1c0ud21MpKHdXVzduFh08W4fSCDfEzkazuxsakv4jTYZIuRAu6Y6ks1YxdmLPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772975740; c=relaxed/simple;
	bh=Noz2yNrHvJsj/QSS3Rm04Lmfig7379E6JfL6LHpvVs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4kthXQ4I4sXV2Ez5SGlek6x9NLDMifhPyg8jwi+P44rlkllgLUd7GCDfXZbf8m+dGXOXW5nddskeFLRvLbSpfDVG/pGatrD4uJNqw7eNlPVW02u/Pb+VjOD/7fWrDoX165qwMV2bubUyfeTYn45ZM3/Zu6gcoIeRuOa3amMQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e72xK18h; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772975736; x=1804511736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Noz2yNrHvJsj/QSS3Rm04Lmfig7379E6JfL6LHpvVs4=;
  b=e72xK18h9TlWP63tS03LUexJgny53vYw8urloU7dqRAzUjJGLkezjOjj
   EimKEQCow8Eu87AT8R3q0Xo9ct0X8D8ZTZmXAF25KuWeMeW3eV8RjswJa
   k9t7di7tzkQamIn9HNyYczAsxFE7+UXf2tnS/hNQlZ1DgGxQZy4EUfJKn
   idvtK16ZKfP3eFQGS3nqxHJ9uzVcP+Faqx7XR8VoRxG+NWHR/Oo/3+Bdv
   3ZBWLKqPiP0GYf6DdxPk296EvkFlDpnmJZBnQYURmfS1fcs/slIoKmSze
   b3IsDHHgwdyuG6D5n214Aa1Mvsdho4qrGzS1g/5mzFHxt6rviNs8dmbfh
   w==;
X-CSE-ConnectionGUID: oAp6bO1BR224vuxkTV0cYA==
X-CSE-MsgGUID: vaENKugcRHqu5KouCBu2bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="73919660"
X-IronPort-AV: E=Sophos;i="6.23,108,1770624000"; 
   d="scan'208";a="73919660"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 06:15:36 -0700
X-CSE-ConnectionGUID: L7JQtB5zTTG7ChH3nJt9fQ==
X-CSE-MsgGUID: WMLsvv9FTrSCACcXr/dWWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,108,1770624000"; 
   d="scan'208";a="249973166"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Mar 2026 06:15:32 -0700
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzDyj-0000000037u-1ijU;
	Sun, 08 Mar 2026 13:15:29 +0000
Date: Sun, 8 Mar 2026 21:15:08 +0800
From: kernel test robot <lkp@intel.com>
To: Douglas Freimuth <freimuth@linux.ibm.com>, borntraeger@linux.ibm.com,
	imbrenda@linux.ibm.com, frankja@linux.ibm.com, david@kernel.org,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	svens@linux.ibm.com, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	mjrosato@linux.ibm.com, freimuth@linux.ibm.com
Subject: Re: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
Message-ID: <202603082108.iY5mWhWR-lkp@intel.com>
References: <20260308030438.88580-2-freimuth@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308030438.88580-2-freimuth@linux.ibm.com>
X-Rspamd-Queue-Id: 82575230608
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73241-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.958];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[git-scm.com:url,intel.com:dkim,intel.com:email,intel.com:mid,req.id:url,01.org:url]
X-Rspamd-Action: no action

Hi Douglas,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.0-rc2]
[also build test WARNING on linus/master next-20260306]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Douglas-Freimuth/Add-map-unmap-ioctl-and-clean-mappings-post-guest/20260308-110653
base:   v7.0-rc2
patch link:    https://lore.kernel.org/r/20260308030438.88580-2-freimuth%40linux.ibm.com
patch subject: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20260308/202603082108.iY5mWhWR-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260308/202603082108.iY5mWhWR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603082108.iY5mWhWR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/s390/kvm/interrupt.c:2478:16: warning: unused variable 'flags' [-Wunused-variable]
    2478 |         unsigned long flags;
         |                       ^~~~~
>> arch/s390/kvm/interrupt.c:2578:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    2578 |                 if (kvm_s390_pv_is_protected(dev->kvm)) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/s390/kvm/interrupt.c:2602:9: note: uninitialized use occurs here
    2602 |         return ret;
         |                ^~~
   arch/s390/kvm/interrupt.c:2578:3: note: remove the 'if' if its condition is always false
    2578 |                 if (kvm_s390_pv_is_protected(dev->kvm)) {
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2579 |                         mutex_unlock(&dev->kvm->lock);
         |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2580 |                         break;
         |                         ~~~~~~
    2581 |                 }
         |                 ~
   arch/s390/kvm/interrupt.c:2561:9: note: initialize the variable 'ret' to silence this warning
    2561 |         int ret, idx;
         |                ^
         |                 = 0
   2 warnings generated.


vim +2578 arch/s390/kvm/interrupt.c

  2554	
  2555	static int modify_io_adapter(struct kvm_device *dev,
  2556				     struct kvm_device_attr *attr)
  2557	{
  2558		struct kvm_s390_io_adapter_req req;
  2559		struct s390_io_adapter *adapter;
  2560		__u64 host_addr;
  2561		int ret, idx;
  2562	
  2563		if (copy_from_user(&req, (void __user *)attr->addr, sizeof(req)))
  2564			return -EFAULT;
  2565	
  2566		adapter = get_io_adapter(dev->kvm, req.id);
  2567		if (!adapter)
  2568			return -EINVAL;
  2569		switch (req.type) {
  2570		case KVM_S390_IO_ADAPTER_MASK:
  2571			ret = kvm_s390_mask_adapter(dev->kvm, req.id, req.mask);
  2572			if (ret > 0)
  2573				ret = 0;
  2574			break;
  2575		case KVM_S390_IO_ADAPTER_MAP:
  2576		case KVM_S390_IO_ADAPTER_UNMAP:
  2577			mutex_lock(&dev->kvm->lock);
> 2578			if (kvm_s390_pv_is_protected(dev->kvm)) {
  2579				mutex_unlock(&dev->kvm->lock);
  2580				break;
  2581			}
  2582			mutex_unlock(&dev->kvm->lock);
  2583			idx = srcu_read_lock(&dev->kvm->srcu);
  2584			host_addr = gpa_to_hva(dev->kvm, req.addr);
  2585			if (kvm_is_error_hva(host_addr)) {
  2586				srcu_read_unlock(&dev->kvm->srcu, idx);
  2587				return -EFAULT;
  2588				}
  2589			srcu_read_unlock(&dev->kvm->srcu, idx);
  2590			if (req.type == KVM_S390_IO_ADAPTER_MAP) {
  2591				dev->kvm->stat.io_390_adapter_map++;
  2592				ret = kvm_s390_adapter_map(dev->kvm, req.id, host_addr);
  2593			} else {
  2594				dev->kvm->stat.io_390_adapter_unmap++;
  2595				ret = kvm_s390_adapter_unmap(dev->kvm, req.id, host_addr);
  2596			}
  2597			break;
  2598		default:
  2599			ret = -EINVAL;
  2600		}
  2601	
  2602		return ret;
  2603	}
  2604	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

