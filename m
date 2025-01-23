Return-Path: <kvm+bounces-36321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5C0A19DCE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 05:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEB123AD355
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 04:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938B01ADC7F;
	Thu, 23 Jan 2025 04:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqWXUQrb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19181ADC6E
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 04:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737608123; cv=none; b=TdIa52VkfbpjJwDKrz0jqfT2FG28NXFX9iS50lpzE0cJ0lHDeciUIzgabgaoyK0kvHKKEPVq1xN3Z65Q0nTIlc90UJJ7No9SvnMj8lC6hVbItzGIrGgfFegIqaDiLrVlgF9+eb6/azHPCiDR1nQVg6EKdXR650aQl/kNKbbM/cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737608123; c=relaxed/simple;
	bh=VyA4uoNfosH/DwJ21QQIVISCOKFxWhYI5osXNJ7Bz+k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dW95Mh/JJ7K/U8Aob6PK3fDHE8/kaTr49eibUf1FyDvo3JOQYoXzxCVv3dqZYo1hPXSWKSCQNJyR1acDbitBenB244fXUEtLX7fUa+UnM74rma1P0A5HkWgyCjMF1v+OT9oLBTI92/UbhmCmG6mR3dj+C8Is/mFmP2cvfqDVi6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqWXUQrb; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737608122; x=1769144122;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VyA4uoNfosH/DwJ21QQIVISCOKFxWhYI5osXNJ7Bz+k=;
  b=UqWXUQrbD1kd2vsHeUiiI9dKL/nFVpwsmKw3zBl+6rLkUfhv9FIwWtuZ
   x5hP6TW8Q1PftrsxI/axpqTJIxNt3VNtT73Or2cDxbF06JzCJAbziEc63
   A6Zly4vrhQiHpqqsSv3pPGhQtMb+/vJ7BLMGG2ga682OeG10NeAAsSIt9
   H5tnwMmja6v4ieCu9/RmADcthFNSSqkKEhkZS+d/EJlnEI6dBGg2UlGm0
   +L2eQjJ0/WcG3C6k71IYcjMeE1aSupfHT49QGuZ/sdSQkKlbhyFyAhXU9
   grvtZ2XnP7pQ+GWcJlP+glAtruNkYz6oKdmkqAP9CORy5VAL5AmDK0gqE
   A==;
X-CSE-ConnectionGUID: D3aNw3YaS0qm7XT8iSXmSg==
X-CSE-MsgGUID: AzcgTbS2QBak7hkEUQijMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="38240182"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="38240182"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 20:55:22 -0800
X-CSE-ConnectionGUID: f5MiJtl4RpGXD7KKl3an5w==
X-CSE-MsgGUID: 5B6Gq2DNQN2LyDjwo50JTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="112341016"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 22 Jan 2025 20:55:19 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tapFN-000agV-1j;
	Thu, 23 Jan 2025 04:55:17 +0000
Date: Thu, 23 Jan 2025 12:54:30 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
Message-ID: <202501231202.viiY8Abl-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   46bf7963a06a56a6c411329d06642836450d19a7
commit: 45c7c4a6fbf00d0ca3f033f30c39e6c12c517381 [39/125] KVM: VMX: Refactor VMX module init/exit functions
config: i386-buildonly-randconfig-002-20250123 (https://download.01.org/0day-ci/archive/20250123/202501231202.viiY8Abl-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250123/202501231202.viiY8Abl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501231202.viiY8Abl-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit (section: .exit.text)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

