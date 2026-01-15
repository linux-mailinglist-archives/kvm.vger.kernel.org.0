Return-Path: <kvm+bounces-68192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 09CBCD25AC0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B296302402F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB93E2C11F3;
	Thu, 15 Jan 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHb5fqTH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A513F86334;
	Thu, 15 Jan 2026 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493480; cv=none; b=AS+N7F6PWy6EX7MKWGCMPZfTVHfIqdH45TD0uNHWu5uaF4OPuiQjYBUBlXIPcQthqWkuShDKqgKFwHZJK9NyhQb6IJ1FpUu+KezfOEx9/hNuCupFuLkuQ1xjhYUGrivDnpILjLtqrI+WdiVBQuVrjI4lGa6BBzEnUUzJ2Cfnb5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493480; c=relaxed/simple;
	bh=gFIoEC1f1qlzIUpk/6FrkLxr7vkPH7lbau/8uT3TPbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZsV9j2H1k1hJypPqXJMrIy/eInuhWNS5jNQ94jmfXoxeCzcZ3B0d9iIXMWG2f1kyS5HrRZPlwirDIOTW/JbZDYLfn4WRGOQ6XF8SFNcjQfQaCSubsTmOAOfVM8YO0te64jVOp/6cGIG3DS9vSxWKz1yvnkT+IaPDlFAXibxmGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHb5fqTH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768493479; x=1800029479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gFIoEC1f1qlzIUpk/6FrkLxr7vkPH7lbau/8uT3TPbk=;
  b=nHb5fqTHh6JL/ZYed6nZR6QQsdekrk8T40lmZgrgAquJRx56luF4UQAc
   MdKNp9AbOB1ZPRtaP7p5K37Hc7gvxy5fXSgQQ+Rih3VrqcbbsvwgzTsU+
   GS6IfdFpevEBhzFiM5xtvG+oPTUnETqoW/1hc0nk4+XaPpeICyfu3V3lz
   wnmlkeggoP/x/0+P2UeKwcmblesuDmnOHyNbdFIXOnvjmFdDVTTckWYl5
   0OIRS+5bupyuPGdwJ6C9PTVBgiktKWJNYTGkjLp9Ms4MIzgLLQLu0GBvs
   RLBkhSAjJk07ZhkZU6dwRM6l31i892F07K1KEbe72gXnZRb4JHMm1667u
   A==;
X-CSE-ConnectionGUID: gysOvICmSs2nZqiUDOqK+w==
X-CSE-MsgGUID: RMVgVblfQzuoASGrxQ+AMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69701547"
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="69701547"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 08:11:19 -0800
X-CSE-ConnectionGUID: T0RnRcTxRsGGrhE5Yp0D6g==
X-CSE-MsgGUID: 0Lh0zAVbQ2yEnGpU34emxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="205020917"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 15 Jan 2026 08:11:14 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgPwF-00000000IBQ-0m18;
	Thu, 15 Jan 2026 16:11:11 +0000
Date: Fri, 16 Jan 2026 00:10:12 +0800
From: kernel test robot <lkp@intel.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 1/5] x86/paravirt: Replace io_delay() hook with a bool
Message-ID: <202601152321.kJ6D4yKM-lkp@intel.com>
References: <20260115084849.31502-2-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115084849.31502-2-jgross@suse.com>

Hi Juergen,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/master]
[also build test ERROR on next-20260115]
[cannot apply to kvm/queue kvm/next tip/x86/core kvm/linux-next tip/auto-latest linus/master v6.19-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-Replace-io_delay-hook-with-a-bool/20260115-165320
base:   tip/master
patch link:    https://lore.kernel.org/r/20260115084849.31502-2-jgross%40suse.com
patch subject: [PATCH v3 1/5] x86/paravirt: Replace io_delay() hook with a bool
config: x86_64-randconfig-006-20260115 (https://download.01.org/0day-ci/archive/20260115/202601152321.kJ6D4yKM-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260115/202601152321.kJ6D4yKM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601152321.kJ6D4yKM-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/tboot.c: In function 'tboot_shutdown':
>> arch/x86/kernel/tboot.c:255:17: error: implicit declaration of function 'halt' [-Werror=implicit-function-declaration]
     255 |                 halt();
         |                 ^~~~
   cc1: some warnings being treated as errors


vim +/halt +255 arch/x86/kernel/tboot.c

58c41d28259c24 H. Peter Anvin 2009-08-14  225  
3162534069597e Joseph Cihula  2009-06-30  226  void tboot_shutdown(u32 shutdown_type)
3162534069597e Joseph Cihula  2009-06-30  227  {
3162534069597e Joseph Cihula  2009-06-30  228  	void (*shutdown)(void);
3162534069597e Joseph Cihula  2009-06-30  229  
3162534069597e Joseph Cihula  2009-06-30  230  	if (!tboot_enabled())
3162534069597e Joseph Cihula  2009-06-30  231  		return;
3162534069597e Joseph Cihula  2009-06-30  232  
11520e5e7c1855 Linus Torvalds 2012-12-15  233  	/*
11520e5e7c1855 Linus Torvalds 2012-12-15  234  	 * if we're being called before the 1:1 mapping is set up then just
11520e5e7c1855 Linus Torvalds 2012-12-15  235  	 * return and let the normal shutdown happen; this should only be
11520e5e7c1855 Linus Torvalds 2012-12-15  236  	 * due to very early panic()
11520e5e7c1855 Linus Torvalds 2012-12-15  237  	 */
11520e5e7c1855 Linus Torvalds 2012-12-15  238  	if (!tboot_pg_dir)
11520e5e7c1855 Linus Torvalds 2012-12-15  239  		return;
11520e5e7c1855 Linus Torvalds 2012-12-15  240  
3162534069597e Joseph Cihula  2009-06-30  241  	/* if this is S3 then set regions to MAC */
3162534069597e Joseph Cihula  2009-06-30  242  	if (shutdown_type == TB_SHUTDOWN_S3)
58c41d28259c24 H. Peter Anvin 2009-08-14  243  		if (tboot_setup_sleep())
58c41d28259c24 H. Peter Anvin 2009-08-14  244  			return;
3162534069597e Joseph Cihula  2009-06-30  245  
3162534069597e Joseph Cihula  2009-06-30  246  	tboot->shutdown_type = shutdown_type;
3162534069597e Joseph Cihula  2009-06-30  247  
3162534069597e Joseph Cihula  2009-06-30  248  	switch_to_tboot_pt();
3162534069597e Joseph Cihula  2009-06-30  249  
3162534069597e Joseph Cihula  2009-06-30  250  	shutdown = (void(*)(void))(unsigned long)tboot->shutdown_entry;
3162534069597e Joseph Cihula  2009-06-30  251  	shutdown();
3162534069597e Joseph Cihula  2009-06-30  252  
3162534069597e Joseph Cihula  2009-06-30  253  	/* should not reach here */
3162534069597e Joseph Cihula  2009-06-30  254  	while (1)
3162534069597e Joseph Cihula  2009-06-30 @255  		halt();
3162534069597e Joseph Cihula  2009-06-30  256  }
3162534069597e Joseph Cihula  2009-06-30  257  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

