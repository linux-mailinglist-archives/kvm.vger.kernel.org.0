Return-Path: <kvm+bounces-60001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7B4BD7DF4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2B64A351082
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 07:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A9330E82B;
	Tue, 14 Oct 2025 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFPB8zw/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B6C30E825;
	Tue, 14 Oct 2025 07:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426697; cv=none; b=qmaXRUAQPR0tN7zwH9zhlUC17beNaZH94dLi+7IuyGFKCbcU2sLcTj2YPuC/K/P+FArvdLKBcXLdFW+ny3D2rl87Z/08jfL3E9x4uGxXOaYi3Zje10ssW5jeFAirw2giZnk0nuZnhtD8wz6EO1JOBuFoEHnIMLqYN7mqwxYmxEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426697; c=relaxed/simple;
	bh=CZp0lbQNhLiQFl87ZwYMZVvAm4voMmM69OP6B4llGtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDVdt0ABN29zSA0zsHLnjuzIw5QUuqo9HHIh3orLt2K+HNB7Mzz2E6upQAsIjg7/hwIN6ghwGy94W1NlWJL47vnChH1agPKDzZd/2DY9TfCGRR/rnBRHYLrf1hBpS8/OOJioZenGM79O2Z2IwU4b7fHV5Yyy6wrWOBzGN9Fmrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFPB8zw/; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760426694; x=1791962694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CZp0lbQNhLiQFl87ZwYMZVvAm4voMmM69OP6B4llGtg=;
  b=jFPB8zw/wTrGG3FAS6mK8qP2EEaS3ljm6jN2WMLIdPfQ7guguRplPRT6
   N8RFL67LGm0gDYxSp3q95u5Wfrj/swzOXv//ktr9MtIgzVImTSqJ4V6D4
   3P3jg+Cp3nQSOf/MKKCd9gor+Tra3Qt8BNqpJhwHmb3hdxdDM6B575yko
   GLf4y8g2ZhNsfvJfs8is+V0xtp39X5E7XrkOCJAS4C3EcoT4NIP5gNNc6
   N47Z0qh3trsMC9LfZsshQxcAKIXWBb55LMYaX97ekyGfecfzzgn5SN+Mm
   H4HQgnUBXi9mtrMAu8UlE6jHC8MdGp8T+Vtj9JqlcCG4AdT0F9NOQsYEE
   w==;
X-CSE-ConnectionGUID: sInZHrKYQRG600vd5/jiiw==
X-CSE-MsgGUID: pE5xQIaVSiKKMklAPGpCzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62675651"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="62675651"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 00:24:52 -0700
X-CSE-ConnectionGUID: Q3qE+95qS+ilJ3jJ2tTHUQ==
X-CSE-MsgGUID: kkSzHRp2TByN1oWW0oOGvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="205506982"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 14 Oct 2025 00:24:49 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8ZOo-0002Vb-38;
	Tue, 14 Oct 2025 07:24:46 +0000
Date: Tue, 14 Oct 2025 15:24:37 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
Message-ID: <202510141438.OMSBOz6R-lkp@intel.com>
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>

Hi Brendan,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6b36119b94d0b2bb8cea9d512017efafd461d6ac]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/KVM-x86-Unify-L1TF-flushing-under-per-CPU-variable/20251013-235118
base:   6b36119b94d0b2bb8cea9d512017efafd461d6ac
patch link:    https://lore.kernel.org/r/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a%40google.com
patch subject: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251014/202510141438.OMSBOz6R-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251014/202510141438.OMSBOz6R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510141438.OMSBOz6R-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/coco/tdx/tdx.c:471:12: error: conflicting types for 'read_msr'; have 'int(struct pt_regs *, struct ve_info *)'
     471 | static int read_msr(struct pt_regs *regs, struct ve_info *ve)
         |            ^~~~~~~~
   In file included from arch/x86/include/asm/idtentry.h:15,
                    from arch/x86/include/asm/traps.h:9,
                    from arch/x86/coco/tdx/tdx.c:20:
   arch/x86/include/asm/kvm_host.h:2320:29: note: previous definition of 'read_msr' with type 'long unsigned int(long unsigned int)'
    2320 | static inline unsigned long read_msr(unsigned long msr)
         |                             ^~~~~~~~


vim +471 arch/x86/coco/tdx/tdx.c

9f98a4f4e7216d Vishal Annapurve   2025-02-28  470  
cdd85786f4b3b9 Kirill A. Shutemov 2022-06-14 @471  static int read_msr(struct pt_regs *regs, struct ve_info *ve)
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  472  {
8a8544bde858e5 Kai Huang          2023-08-15  473  	struct tdx_module_args args = {
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  474  		.r10 = TDX_HYPERCALL_STANDARD,
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  475  		.r11 = hcall_func(EXIT_REASON_MSR_READ),
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  476  		.r12 = regs->cx,
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  477  	};
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  478  
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  479  	/*
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  480  	 * Emulate the MSR read via hypercall. More info about ABI
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  481  	 * can be found in TDX Guest-Host-Communication Interface
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  482  	 * (GHCI), section titled "TDG.VP.VMCALL<Instruction.RDMSR>".
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  483  	 */
c641cfb5c157b6 Kai Huang          2023-08-15  484  	if (__tdx_hypercall(&args))
cdd85786f4b3b9 Kirill A. Shutemov 2022-06-14  485  		return -EIO;
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  486  
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  487  	regs->ax = lower_32_bits(args.r11);
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  488  	regs->dx = upper_32_bits(args.r11);
cdd85786f4b3b9 Kirill A. Shutemov 2022-06-14  489  	return ve_instr_len(ve);
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  490  }
ae87f609cd5282 Kirill A. Shutemov 2022-04-06  491  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

