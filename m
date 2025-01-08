Return-Path: <kvm+bounces-34747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 859F3A05451
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828E1166369
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000D91AAA1E;
	Wed,  8 Jan 2025 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJO9fysL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FFF19DFA7;
	Wed,  8 Jan 2025 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736320568; cv=none; b=HuiSGqpA12gRNPUMRDN5aGyjYiZ4K8oYQAa7zuRC3KaWXkkOf+sTR90b0P/kMKBLr0Eu9jd4oIGLWBdSt3i+Y27XDBb0AmKVedJi25f+AAmxzvvsuL9Yo06I/aRSE8mippGLhDLf8OT1/H7Wfvmw16yOCOmwmoWgSTuaHaOHB14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736320568; c=relaxed/simple;
	bh=c9T875ncUpZ6czw5ekRUJMfTxujR/cwO7+BRgh310Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKFBfKxxpTgBa326gfJmKF0/CIYpL44obMEnauvOGu5IxmGKI+yXBoKbspftg7RV4kcUZvd5BuSEpXzE3bGsLthLnyLVTIZeoQ5kehAk+TWHjXUSQe6PLcn/dvfEi5sxkT4blBcEGLrte8IIOymcPWpDmra34TI4MakWNAWEUTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJO9fysL; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736320566; x=1767856566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c9T875ncUpZ6czw5ekRUJMfTxujR/cwO7+BRgh310Zs=;
  b=JJO9fysLfuGL8UXWWw8XO0JF5rUYwYReNQExDUn6Xk8F9d0xxfw1Gxfz
   4S251aDvYT4lxP2sxEXyjLTt9hsd1N7/d0/XJf1pT6mWGL8q5FOCmFKmF
   VRj5ziOVTAuqxrzPBtv8rx/7/JhE1uc1Ewr9W8t84Hz9CQQ4gE8Rq+ATR
   nwb1iiWJGfHcc3ryUt0/ReDzFs1LaatYFfJ0zz6ok+BA5h5wLVqMe4dkz
   SpSZAaJRgGekofU1X9LRHFSMAW9Mkk0vadm5gZng3cW0Xn0bnEusZsNwX
   24RezH9CSCZfT+9LzvbHEY8rdUQMuQYXdXeQswVYFkW8y7rxAtYz2scFi
   g==;
X-CSE-ConnectionGUID: tiSh55OzRK+vvVx5QgzQrw==
X-CSE-MsgGUID: hKSd5Y2PRK2c7vWQgrO/QQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36649081"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="36649081"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 23:16:03 -0800
X-CSE-ConnectionGUID: Cu2e8+KERYivh65/qlfFVA==
X-CSE-MsgGUID: uLNKOvLDSESPyDTfCHI+9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="102924538"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 07 Jan 2025 23:15:59 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVQIH-000FkB-1X;
	Wed, 08 Jan 2025 07:15:57 +0000
Date: Wed, 8 Jan 2025 15:15:30 +0800
From: kernel test robot <lkp@intel.com>
To: Suleiman Souhlal <suleiman@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org,
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
Message-ID: <202501081504.AE4wDCL9-lkp@intel.com>
References: <20250107042202.2554063-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107042202.2554063-2-suleiman@google.com>

Hi Suleiman,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next linus/master v6.13-rc6 next-20250107]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Suleiman-Souhlal/kvm-Introduce-kvm_total_suspend_ns/20250107-122819
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250107042202.2554063-2-suleiman%40google.com
patch subject: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
config: s390-randconfig-001-20250108 (https://download.01.org/0day-ci/archive/20250108/202501081504.AE4wDCL9-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250108/202501081504.AE4wDCL9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501081504.AE4wDCL9-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:897:12: warning: 'last_suspend' defined but not used [-Wunused-variable]
     897 | static u64 last_suspend;
         |            ^~~~~~~~~~~~


vim +/last_suspend +897 arch/s390/kvm/../../../virt/kvm/kvm_main.c

   896	
 > 897	static u64 last_suspend;
   898	static u64 total_suspend_ns;
   899	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

