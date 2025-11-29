Return-Path: <kvm+bounces-64958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5445FC9470F
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 20:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7123A7ACF
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 19:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698FA261B9C;
	Sat, 29 Nov 2025 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M6fS7Y1j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EA202979;
	Sat, 29 Nov 2025 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764444994; cv=none; b=pwLLyoRWmJGcc0UmSy40rJnJvX7O2lyOtezYKEx8Mz3rTvKQenH99gzfKAEwLWc4X/b46PMec6sJzvxuJj+7fSsWdR/Eq2tXu8otFpbJR8nbX4R81atEqG5PL9q0D1AdxqIPFB+GLpGnyCEVG7O8tIjyNKpye8SkUkKzB3AKLc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764444994; c=relaxed/simple;
	bh=n+c33eLmKpvzexuKf5CMuWcYJjwQ9elpT0g++XC2a+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exK/6KAqLbpXdrS3Lj5hASKeZbvP5OsY+kb3cXBVXJTgQknCut55gQ/l42j+u19rSAsSFpjzO4eHMaQ6Ibxz7ArCsQQwpYPHfCOtnltwz6rXERtv6vLDh8phfhbnInsxtpuZ/Fuz/YLk0tcjIh1faq2cxnbfRqAHWYRuCvui4jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M6fS7Y1j; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764444992; x=1795980992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n+c33eLmKpvzexuKf5CMuWcYJjwQ9elpT0g++XC2a+0=;
  b=M6fS7Y1jN06762AwIk90hh1vVC7+i2lAQ0teP6bcx7hy2H2gnGWSlhvA
   4ZSpicHt/2iMAco7BJGY62IEah+qr0TOJ+XzT0yUiUqkdYIOPS9+M+uOU
   t4gIdJ5RH1xQEML+O1Mzw+UpTAVbb+hCNo+kUyLD+P7AuxNKf8FVoMztY
   odpEPoSk1KHI/+xzZg8ipkZSUenokE1m+HM2GZ3Swcoba/x/uCQe+66xM
   Gajr0TnY48Lje9V0y5Y/f9pmg16bqHqSH0lzwt/pPkyPnmn6B9xRgdZgR
   RDT2T0XjBlgOSxWNInbVPKBXiGsJI9bVFdsG6CR6chIY50sJDFAjyfOhL
   w==;
X-CSE-ConnectionGUID: T/NIcfR9TJKWj9vy+kK3qw==
X-CSE-MsgGUID: 9tbfY79tR+Wfo6MePMsT5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11628"; a="66324902"
X-IronPort-AV: E=Sophos;i="6.20,237,1758610800"; 
   d="scan'208";a="66324902"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2025 11:36:31 -0800
X-CSE-ConnectionGUID: X2Kc27BdQt26CZYuNXjZ+A==
X-CSE-MsgGUID: E5oHsCPqSSmFLDlysbtEJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,237,1758610800"; 
   d="scan'208";a="198181574"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 29 Nov 2025 11:36:28 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vPQk5-000000007W1-2WuL;
	Sat, 29 Nov 2025 19:36:25 +0000
Date: Sun, 30 Nov 2025 03:35:37 +0800
From: kernel test robot <lkp@intel.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v5 4/9] x86/vmscape: Move mitigation selection to a
 switch()
Message-ID: <202511300322.KCG4AuJ9-lkp@intel.com>
References: <20251126-vmscape-bhb-v5-4-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-4-02d66e423b00@linux.intel.com>

Hi Pawan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6a23ae0a96a600d1d12557add110e0bb6e32730c]

url:    https://github.com/intel-lab-lkp/linux/commits/Pawan-Gupta/x86-bhi-x86-vmscape-Move-LFENCE-out-of-clear_bhb_loop/20251127-061843
base:   6a23ae0a96a600d1d12557add110e0bb6e32730c
patch link:    https://lore.kernel.org/r/20251126-vmscape-bhb-v5-4-02d66e423b00%40linux.intel.com
patch subject: [PATCH v5 4/9] x86/vmscape: Move mitigation selection to a switch()
config: x86_64-randconfig-122-20251129 (https://download.01.org/0day-ci/archive/20251130/202511300322.KCG4AuJ9-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251130/202511300322.KCG4AuJ9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511300322.KCG4AuJ9-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kernel/cpu/bugs.c:3260:9: sparse: sparse: statement expected after case label

vim +3260 arch/x86/kernel/cpu/bugs.c

556c1ad666ad90 Pawan Gupta  2025-08-14  3231  
556c1ad666ad90 Pawan Gupta  2025-08-14  3232  static void __init vmscape_select_mitigation(void)
556c1ad666ad90 Pawan Gupta  2025-08-14  3233  {
0091dd36e9ee51 Pawan Gupta  2025-11-26  3234  	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
556c1ad666ad90 Pawan Gupta  2025-08-14  3235  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
556c1ad666ad90 Pawan Gupta  2025-08-14  3236  		return;
556c1ad666ad90 Pawan Gupta  2025-08-14  3237  	}
556c1ad666ad90 Pawan Gupta  2025-08-14  3238  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3239  	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
0091dd36e9ee51 Pawan Gupta  2025-11-26  3240  	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
0091dd36e9ee51 Pawan Gupta  2025-11-26  3241  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3242  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3243  	switch (vmscape_mitigation) {
0091dd36e9ee51 Pawan Gupta  2025-11-26  3244  	case VMSCAPE_MITIGATION_NONE:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3245  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3246  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3247  	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3248  		if (!boot_cpu_has(X86_FEATURE_IBPB))
0091dd36e9ee51 Pawan Gupta  2025-11-26  3249  			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3250  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3251  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3252  	case VMSCAPE_MITIGATION_AUTO:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3253  		if (boot_cpu_has(X86_FEATURE_IBPB))
556c1ad666ad90 Pawan Gupta  2025-08-14  3254  			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
5799d5d8a6c877 David Kaplan 2025-09-12  3255  		else
5799d5d8a6c877 David Kaplan 2025-09-12  3256  			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3257  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3258  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3259  	default:
5799d5d8a6c877 David Kaplan 2025-09-12 @3260  	}
556c1ad666ad90 Pawan Gupta  2025-08-14  3261  }
556c1ad666ad90 Pawan Gupta  2025-08-14  3262  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

