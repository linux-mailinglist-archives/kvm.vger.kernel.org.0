Return-Path: <kvm+bounces-34756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D390BA05580
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D2971887FE1
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645681DFE0A;
	Wed,  8 Jan 2025 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3D74tm5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF191ACECC;
	Wed,  8 Jan 2025 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736325407; cv=none; b=LQn/wm32uWiRXfELovLxot+vuTQcAtFIQRZdJCD1HdTE6/vjTpFPrj9gZHuCoNZodrljdmsOEo6VS8jDu47WwP6+nGi1MzdN3i7RZKbRRQU/tjCQPORzvGy49TwdqngoaWYGYlrAWkA/v7Y9HsGTRsENWfZrmbInquHCCfunxE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736325407; c=relaxed/simple;
	bh=ppwSquoPBMt0mFVLcF4X+BM+cS6CBGNTiWIvdb6F32o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZTyhCZj4GzUKunhVuJOghZubR5pjqADg+irBlGiDkFCaEccuVlwX9F26+IOAA9iLIHKZSl+20jsrq9og3UYto5z7K1BvaiB8hoU4fpwWdspblR4YwuFR3rRmKCUtycy2eUydent/CCe/KOwqVTNJy5O/ASVxVuvtfIchocd0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3D74tm5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736325405; x=1767861405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ppwSquoPBMt0mFVLcF4X+BM+cS6CBGNTiWIvdb6F32o=;
  b=T3D74tm5QP11mPpzEZT3LY8otVakNU8QjlIDjbx4cF4ZPtnWJPPdrxSP
   aHG7i4960eTleB4+Bb0lJz5ASWL9nzdqUQI9vq+7GJz4OVlFJWJzzF2gv
   fO2Ovtzw963SAObsv3Vnmbmsaesm1AH7J4oG09038o/ggaly9c7tZ4ZNU
   aZgRIi8sBdm0SIWiCWogXVR7xyS39J4rc0vYzZRoNtwElVXuZaCH4361R
   SvwGzIDpDNUor2WYzNoLuAvuyPJ8BPmKIOuyCzoz6ieg6oYb3sl6J034+
   0a/4t9NhM81bwRhXs+TcV/BQnKrKDB+0/oFzJEzOEznf8xWaMiQmPk/iO
   Q==;
X-CSE-ConnectionGUID: Mnd1P0YnSy21si+pAY0Wjg==
X-CSE-MsgGUID: kd51lqOQQ0O3UfIpr8ZuQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47114971"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="47114971"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 00:36:43 -0800
X-CSE-ConnectionGUID: 2wLHOkeyQuuNC8Wjr+BocA==
X-CSE-MsgGUID: TMrDP3FDT3OseqODoG1T1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="108010364"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 08 Jan 2025 00:36:40 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVRYL-000Fnz-2f;
	Wed, 08 Jan 2025 08:36:37 +0000
Date: Wed, 8 Jan 2025 16:36:08 +0800
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
Message-ID: <202501081616.nFwj9jxx-lkp@intel.com>
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
config: loongarch-randconfig-002-20250108 (https://download.01.org/0day-ci/archive/20250108/202501081616.nFwj9jxx-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250108/202501081616.nFwj9jxx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501081616.nFwj9jxx-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:897:12: warning: 'last_suspend' defined but not used [-Wunused-variable]
     897 | static u64 last_suspend;
         |            ^~~~~~~~~~~~


vim +/last_suspend +897 arch/loongarch/kvm/../../../virt/kvm/kvm_main.c

   896	
 > 897	static u64 last_suspend;
   898	static u64 total_suspend_ns;
   899	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

