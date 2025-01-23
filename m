Return-Path: <kvm+bounces-36318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD876A19D08
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 03:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94041188CF5A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 02:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96113D3B3;
	Thu, 23 Jan 2025 02:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUARFwuR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331F935957
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737600733; cv=none; b=ZqzVpTGvAXTa9RQWzVG1GXAZ/4D5RgbXQYTgrFbyLoivbPAv9jd4Ml5DU4CUgGMM3arCQpZc2QYiBWdskJyk4pGLw6JbjI3WToRWZOwZlecGj71ylfVEU5JCCIG12BfaXOeQjbigtjWc23thDFt6tDuzfY5K+15XAUsu2gNZvZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737600733; c=relaxed/simple;
	bh=wDtOq+sejLWGcOoyl110f6ndMPVWly3RIixaIZwijzk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XXUpIeTo03b7bFb6g475bZ1rgAa1dav6najqdnl9pfY3wvEydFV9Zuys1R6XLghQwp0LQ1kGhALer6p4RQNboA1YefvYwnSK3m1IveB9/Hu/yMDVES3LNU/KUEz72HtCwK7OzhCcDfXfD14dTqnt7Rd9tdAX7cdu0wcNpeArncs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUARFwuR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737600733; x=1769136733;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wDtOq+sejLWGcOoyl110f6ndMPVWly3RIixaIZwijzk=;
  b=TUARFwuR7uHjUBIjs76feabEnim6kYHfIpdKOl6KDPlg0SarFFQ1YANW
   82QbIuTitNoQjkmMEaLB3Ejb+b8Aox95aSKzZCie6CnAhK5/BfRbg0WJt
   Ogv8wM71rRmn3YfhoqFP6UTGZO2wSLCqGPWF50Fl5nSfsUM4R2McUIT7A
   98VyWskp0Am3msynRj8bzgzjbme6MN0aGQtcgbNSAmJuKVtVvPIBkgIeP
   iRAUy4XAPr2aX2v9q5vRl31CQr0EYm7n0kGxgOlTQaZvvql5XOW8HvL+/
   ON5PBJGDD+g3Pb7GkW4k4hukjIrTTH/k9Kd3d/rXcA1CiDy2BB+cccdko
   A==;
X-CSE-ConnectionGUID: Xa109GV3TSep8omJwP7AMQ==
X-CSE-MsgGUID: NGNq0ZD+S06pD1Smq68qww==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="41843834"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="41843834"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 18:52:12 -0800
X-CSE-ConnectionGUID: meTZRkCXQP6wIadkX7FzTg==
X-CSE-MsgGUID: CcGxtojXQY6kSwZKE69sWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="112322594"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 22 Jan 2025 18:52:09 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tanKB-000aa9-12;
	Thu, 23 Jan 2025 02:52:07 +0000
Date: Thu, 23 Jan 2025 10:51:48 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [kvm:kvm-coco-queue 39/125] WARNING: modpost:
 arch/x86/kvm/kvm-intel: section mismatch in reference: init_module+0x32
 (section: .init.text) -> vmx_exit (section: .exit.text)
Message-ID: <202501231000.7Uhj46SO-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250123/202501231000.7Uhj46SO-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250123/202501231000.7Uhj46SO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501231000.7Uhj46SO-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: arch/x86/kvm/kvm-intel: section mismatch in reference: init_module+0x32 (section: .init.text) -> vmx_exit (section: .exit.text)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

