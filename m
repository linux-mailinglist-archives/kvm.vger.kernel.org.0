Return-Path: <kvm+bounces-73057-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKw0F3rbqmkZXwEAu9opvQ
	(envelope-from <kvm+bounces-73057-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 14:49:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC1B2221A0
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 14:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1822730010EC
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 13:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7797F3A5E90;
	Fri,  6 Mar 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbLRZ9Fb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839323451D9;
	Fri,  6 Mar 2026 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772804929; cv=none; b=PngPiaCj2C0ad3KcooLB8Y7168Ch+nW7h3+5of/J0dUyHkZOjIqhiHZkM/2k8vnprWVMuBwQbHgooxjLEikhaKBTLuIZxxB0FVSdIOINHc41W2b1qHAGBn/TKJ2DrALnBH1LTw6fTpZKPN3VZ7F2T29Gh7B6x06jin6aVE6eFps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772804929; c=relaxed/simple;
	bh=k80F3Ripebd/0qFB3GTXtfwlExRbRIzPR1/khiB8fVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPIe2eI5BMgaz8H5ZKDizO9/gWwyVakrrjy1pZwheZwUkrqCfBapUNTyMhY1Cc0gguCmxmligwufgHQd77lXvOMYM4o+mLlf5qnEnibKC7fRh9RQJ9BLa0+qwtWOvOUGlfzd8Um+mNY1fF1gN3sKz4M4KI6AyOQgGxWH9bae5zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbLRZ9Fb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772804925; x=1804340925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k80F3Ripebd/0qFB3GTXtfwlExRbRIzPR1/khiB8fVE=;
  b=YbLRZ9Fboddgvd66t5SZV2VEwXkLAsxFDSmXJC91YnNGaao93ntKf1u/
   A7nQAuEnvTsm0ig93BfF2QHdsQd/3G2Pd9Gg/e5dW6p1u+DuNhURoXRZ5
   3CaOQK7CtmyJXo3EDnusSMOMBjtdT0Vf5RWWyGilfS/W3gf5uRXEGMhwv
   t4XZHdtrXybUEMbVYGXNOjRJNuIQxmdYzzJD8UW8wJupYCIGSJ311q4V5
   uz++Ht+qYXeXnE3rxUDwkNnGTepNoJ5xnDaBEEwd8lYwPr7T3WKmvXrNR
   gml2kjTmjAkh4B17fMs/F69swv6IySWE6StCK8ozmYZOYyvHlabzsXCui
   w==;
X-CSE-ConnectionGUID: sHdHGu+USKOLtfAg5tuY0Q==
X-CSE-MsgGUID: 2bd3AJSrQWOl1gI+3aLWhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73611150"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="73611150"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 05:48:45 -0800
X-CSE-ConnectionGUID: 0cUYmoDHRvWJHqVTZbd9rA==
X-CSE-MsgGUID: V33xEdV7Qq2esLxJwYY/9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219145982"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2026 05:48:43 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyVXk-000000000tp-2xFw;
	Fri, 06 Mar 2026 13:48:40 +0000
Date: Fri, 6 Mar 2026 21:48:15 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
Message-ID: <202603062132.hgMBAT4f-lkp@intel.com>
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306041125.45643-1-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: 1CC1B2221A0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73057-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid,01.org:url]
X-Rspamd-Action: no action

Hi Anshuman,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next kvm/linux-next linus/master v7.0-rc2 next-20260305]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/KVM-Change-g-h-va_t-as-u64/20260306-123029
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260306041125.45643-1-anshuman.khandual%40arm.com
patch subject: [PATCH] KVM: Change [g|h]va_t as u64
config: i386-buildonly-randconfig-002-20260306 (https://download.01.org/0day-ci/archive/20260306/202603062132.hgMBAT4f-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603062132.hgMBAT4f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603062132.hgMBAT4f-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/xen.c: In function 'kvm_xen_write_hypercall_page':
>> arch/x86/kvm/xen.c:1350:36: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    1350 |                 page = memdup_user((u8 __user *)blob_addr, PAGE_SIZE);
         |                                    ^
   arch/x86/kvm/xen.c: In function 'kvm_xen_schedop_poll':
>> arch/x86/kvm/xen.c:1525:39: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1525 |         if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
         |                                       ^
--
   In file included from arch/x86/include/asm/bug.h:193,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/asm-generic/bitops/generic-non-atomic.h:7,
                    from include/linux/bitops.h:28,
                    from include/linux/log2.h:12,
                    from arch/x86/include/asm/div64.h:8,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from arch/x86/kvm/vmx/vmx.c:17:
   arch/x86/kvm/vmx/vmx.c: In function 'invvpid_error':
>> arch/x86/kvm/vmx/vmx.c:573:25: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     574 |                         ext, vpid, gva);
         |                                    ~~~
         |                                    |
         |                                    gva_t {aka long long unsigned int}
   include/asm-generic/bug.h:133:31: note: in definition of macro '__WARN_printf'
     133 |                 __warn_printk(arg);                                     \
         |                               ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:185:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     185 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:531:9: note: in expansion of macro 'WARN_ONCE'
     531 |         WARN_ONCE(1, fmt);              \
         |         ^~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:573:9: note: in expansion of macro 'vmx_insn_failed'
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |         ^~~~~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:573:68: note: format string is defined here
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |                                                                  ~~^
         |                                                                    |
         |                                                                    long unsigned int
         |                                                                  %llx
   In file included from include/asm-generic/bug.h:31:
>> include/linux/kern_levels.h:5:25: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:705:17: note: in expansion of macro 'printk'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                 ^~~~~~
   include/linux/printk.h:721:9: note: in expansion of macro 'printk_ratelimited'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:12:25: note: in expansion of macro 'KERN_SOH'
      12 | #define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:721:28: note: in expansion of macro 'KERN_WARNING'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                            ^~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:532:9: note: in expansion of macro 'pr_warn_ratelimited'
     532 |         pr_warn_ratelimited(fmt);       \
         |         ^~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:573:9: note: in expansion of macro 'vmx_insn_failed'
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |         ^~~~~~~~~~~~~~~


vim +1350 arch/x86/kvm/xen.c

3e3246158808d46 David Woodhouse     2021-02-02  1275  
23200b7a30de315 Joao Martins        2018-06-13  1276  int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
23200b7a30de315 Joao Martins        2018-06-13  1277  {
23200b7a30de315 Joao Martins        2018-06-13  1278  	struct kvm *kvm = vcpu->kvm;
23200b7a30de315 Joao Martins        2018-06-13  1279  	u32 page_num = data & ~PAGE_MASK;
23200b7a30de315 Joao Martins        2018-06-13  1280  	u64 page_addr = data & PAGE_MASK;
a3833b81b05d0ae David Woodhouse     2020-12-03  1281  	bool lm = is_long_mode(vcpu);
18b99e4d6db65ff Paul Durrant        2024-02-15  1282  	int r = 0;
a3833b81b05d0ae David Woodhouse     2020-12-03  1283  
18b99e4d6db65ff Paul Durrant        2024-02-15  1284  	mutex_lock(&kvm->arch.xen.xen_lock);
18b99e4d6db65ff Paul Durrant        2024-02-15  1285  	if (kvm->arch.xen.long_mode != lm) {
18b99e4d6db65ff Paul Durrant        2024-02-15  1286  		kvm->arch.xen.long_mode = lm;
18b99e4d6db65ff Paul Durrant        2024-02-15  1287  
18b99e4d6db65ff Paul Durrant        2024-02-15  1288  		/*
18b99e4d6db65ff Paul Durrant        2024-02-15  1289  		 * Re-initialize shared_info to put the wallclock in the
18b99e4d6db65ff Paul Durrant        2024-02-15  1290  		 * correct place.
18b99e4d6db65ff Paul Durrant        2024-02-15  1291  		 */
18b99e4d6db65ff Paul Durrant        2024-02-15  1292  		if (kvm->arch.xen.shinfo_cache.active &&
18b99e4d6db65ff Paul Durrant        2024-02-15  1293  		    kvm_xen_shared_info_init(kvm))
18b99e4d6db65ff Paul Durrant        2024-02-15  1294  			r = 1;
18b99e4d6db65ff Paul Durrant        2024-02-15  1295  	}
18b99e4d6db65ff Paul Durrant        2024-02-15  1296  	mutex_unlock(&kvm->arch.xen.xen_lock);
18b99e4d6db65ff Paul Durrant        2024-02-15  1297  
18b99e4d6db65ff Paul Durrant        2024-02-15  1298  	if (r)
18b99e4d6db65ff Paul Durrant        2024-02-15  1299  		return r;
23200b7a30de315 Joao Martins        2018-06-13  1300  
23200b7a30de315 Joao Martins        2018-06-13  1301  	/*
23200b7a30de315 Joao Martins        2018-06-13  1302  	 * If Xen hypercall intercept is enabled, fill the hypercall
23200b7a30de315 Joao Martins        2018-06-13  1303  	 * page with VMCALL/VMMCALL instructions since that's what
23200b7a30de315 Joao Martins        2018-06-13  1304  	 * we catch. Else the VMM has provided the hypercall pages
23200b7a30de315 Joao Martins        2018-06-13  1305  	 * with instructions of its own choosing, so use those.
23200b7a30de315 Joao Martins        2018-06-13  1306  	 */
23200b7a30de315 Joao Martins        2018-06-13  1307  	if (kvm_xen_hypercall_enabled(kvm)) {
23200b7a30de315 Joao Martins        2018-06-13  1308  		u8 instructions[32];
23200b7a30de315 Joao Martins        2018-06-13  1309  		int i;
23200b7a30de315 Joao Martins        2018-06-13  1310  
23200b7a30de315 Joao Martins        2018-06-13  1311  		if (page_num)
23200b7a30de315 Joao Martins        2018-06-13  1312  			return 1;
23200b7a30de315 Joao Martins        2018-06-13  1313  
23200b7a30de315 Joao Martins        2018-06-13  1314  		/* mov imm32, %eax */
23200b7a30de315 Joao Martins        2018-06-13  1315  		instructions[0] = 0xb8;
23200b7a30de315 Joao Martins        2018-06-13  1316  
23200b7a30de315 Joao Martins        2018-06-13  1317  		/* vmcall / vmmcall */
896046474f8d2ea Wei Wang            2024-05-07  1318  		kvm_x86_call(patch_hypercall)(vcpu, instructions + 5);
23200b7a30de315 Joao Martins        2018-06-13  1319  
23200b7a30de315 Joao Martins        2018-06-13  1320  		/* ret */
23200b7a30de315 Joao Martins        2018-06-13  1321  		instructions[8] = 0xc3;
23200b7a30de315 Joao Martins        2018-06-13  1322  
23200b7a30de315 Joao Martins        2018-06-13  1323  		/* int3 to pad */
23200b7a30de315 Joao Martins        2018-06-13  1324  		memset(instructions + 9, 0xcc, sizeof(instructions) - 9);
23200b7a30de315 Joao Martins        2018-06-13  1325  
23200b7a30de315 Joao Martins        2018-06-13  1326  		for (i = 0; i < PAGE_SIZE / sizeof(instructions); i++) {
23200b7a30de315 Joao Martins        2018-06-13  1327  			*(u32 *)&instructions[1] = i;
23200b7a30de315 Joao Martins        2018-06-13  1328  			if (kvm_vcpu_write_guest(vcpu,
23200b7a30de315 Joao Martins        2018-06-13  1329  						 page_addr + (i * sizeof(instructions)),
23200b7a30de315 Joao Martins        2018-06-13  1330  						 instructions, sizeof(instructions)))
23200b7a30de315 Joao Martins        2018-06-13  1331  				return 1;
23200b7a30de315 Joao Martins        2018-06-13  1332  		}
23200b7a30de315 Joao Martins        2018-06-13  1333  	} else {
448841f0b7b50f1 Sean Christopherson 2021-02-08  1334  		/*
448841f0b7b50f1 Sean Christopherson 2021-02-08  1335  		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
448841f0b7b50f1 Sean Christopherson 2021-02-08  1336  		 * false for a 32-bit kernel, i.e. when hva_t is only 4 bytes.
448841f0b7b50f1 Sean Christopherson 2021-02-08  1337  		 */
26e228ec1695011 Sean Christopherson 2025-02-14  1338  		hva_t blob_addr = lm ? kvm->arch.xen.hvm_config.blob_addr_64
26e228ec1695011 Sean Christopherson 2025-02-14  1339  				     : kvm->arch.xen.hvm_config.blob_addr_32;
26e228ec1695011 Sean Christopherson 2025-02-14  1340  		u8 blob_size = lm ? kvm->arch.xen.hvm_config.blob_size_64
26e228ec1695011 Sean Christopherson 2025-02-14  1341  				  : kvm->arch.xen.hvm_config.blob_size_32;
23200b7a30de315 Joao Martins        2018-06-13  1342  		u8 *page;
385407a69d51408 Michal Luczaj       2022-12-26  1343  		int ret;
23200b7a30de315 Joao Martins        2018-06-13  1344  
23200b7a30de315 Joao Martins        2018-06-13  1345  		if (page_num >= blob_size)
23200b7a30de315 Joao Martins        2018-06-13  1346  			return 1;
23200b7a30de315 Joao Martins        2018-06-13  1347  
23200b7a30de315 Joao Martins        2018-06-13  1348  		blob_addr += page_num * PAGE_SIZE;
23200b7a30de315 Joao Martins        2018-06-13  1349  
23200b7a30de315 Joao Martins        2018-06-13 @1350  		page = memdup_user((u8 __user *)blob_addr, PAGE_SIZE);
23200b7a30de315 Joao Martins        2018-06-13  1351  		if (IS_ERR(page))
23200b7a30de315 Joao Martins        2018-06-13  1352  			return PTR_ERR(page);
23200b7a30de315 Joao Martins        2018-06-13  1353  
385407a69d51408 Michal Luczaj       2022-12-26  1354  		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
23200b7a30de315 Joao Martins        2018-06-13  1355  		kfree(page);
385407a69d51408 Michal Luczaj       2022-12-26  1356  		if (ret)
23200b7a30de315 Joao Martins        2018-06-13  1357  			return 1;
23200b7a30de315 Joao Martins        2018-06-13  1358  	}
23200b7a30de315 Joao Martins        2018-06-13  1359  	return 0;
23200b7a30de315 Joao Martins        2018-06-13  1360  }
23200b7a30de315 Joao Martins        2018-06-13  1361  
78e9878cb376969 David Woodhouse     2021-02-02  1362  int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
78e9878cb376969 David Woodhouse     2021-02-02  1363  {
661a20fab7d156c David Woodhouse     2022-03-03  1364  	/* Only some feature flags need to be *enabled* by userspace */
661a20fab7d156c David Woodhouse     2022-03-03  1365  	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
6d7228352609085 Paul Durrant        2023-11-02  1366  		KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
6d7228352609085 Paul Durrant        2023-11-02  1367  		KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
6d7228352609085 Paul Durrant        2023-11-02  1368  	u32 old_flags;
661a20fab7d156c David Woodhouse     2022-03-03  1369  
661a20fab7d156c David Woodhouse     2022-03-03  1370  	if (xhc->flags & ~permitted_flags)
78e9878cb376969 David Woodhouse     2021-02-02  1371  		return -EINVAL;
78e9878cb376969 David Woodhouse     2021-02-02  1372  
78e9878cb376969 David Woodhouse     2021-02-02  1373  	/*
78e9878cb376969 David Woodhouse     2021-02-02  1374  	 * With hypercall interception the kernel generates its own
78e9878cb376969 David Woodhouse     2021-02-02  1375  	 * hypercall page so it must not be provided.
78e9878cb376969 David Woodhouse     2021-02-02  1376  	 */
78e9878cb376969 David Woodhouse     2021-02-02  1377  	if ((xhc->flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
78e9878cb376969 David Woodhouse     2021-02-02  1378  	    (xhc->blob_addr_32 || xhc->blob_addr_64 ||
78e9878cb376969 David Woodhouse     2021-02-02  1379  	     xhc->blob_size_32 || xhc->blob_size_64))
78e9878cb376969 David Woodhouse     2021-02-02  1380  		return -EINVAL;
78e9878cb376969 David Woodhouse     2021-02-02  1381  
5c17848134ab1ff Sean Christopherson 2025-02-14  1382  	/*
5c17848134ab1ff Sean Christopherson 2025-02-14  1383  	 * Restrict the MSR to the range that is unofficially reserved for
5c17848134ab1ff Sean Christopherson 2025-02-14  1384  	 * synthetic, virtualization-defined MSRs, e.g. to prevent confusing
5c17848134ab1ff Sean Christopherson 2025-02-14  1385  	 * KVM by colliding with a real MSR that requires special handling.
5c17848134ab1ff Sean Christopherson 2025-02-14  1386  	 */
5c17848134ab1ff Sean Christopherson 2025-02-14  1387  	if (xhc->msr &&
5c17848134ab1ff Sean Christopherson 2025-02-14  1388  	    (xhc->msr < KVM_XEN_MSR_MIN_INDEX || xhc->msr > KVM_XEN_MSR_MAX_INDEX))
5c17848134ab1ff Sean Christopherson 2025-02-14  1389  		return -EINVAL;
5c17848134ab1ff Sean Christopherson 2025-02-14  1390  
310bc39546a435c David Woodhouse     2023-01-11  1391  	mutex_lock(&kvm->arch.xen.xen_lock);
7d6bbebb7bb0294 David Woodhouse     2021-02-02  1392  
26e228ec1695011 Sean Christopherson 2025-02-14  1393  	if (xhc->msr && !kvm->arch.xen.hvm_config.msr)
7d6bbebb7bb0294 David Woodhouse     2021-02-02  1394  		static_branch_inc(&kvm_xen_enabled.key);
26e228ec1695011 Sean Christopherson 2025-02-14  1395  	else if (!xhc->msr && kvm->arch.xen.hvm_config.msr)
7d6bbebb7bb0294 David Woodhouse     2021-02-02  1396  		static_branch_slow_dec_deferred(&kvm_xen_enabled);
7d6bbebb7bb0294 David Woodhouse     2021-02-02  1397  
26e228ec1695011 Sean Christopherson 2025-02-14  1398  	old_flags = kvm->arch.xen.hvm_config.flags;
26e228ec1695011 Sean Christopherson 2025-02-14  1399  	memcpy(&kvm->arch.xen.hvm_config, xhc, sizeof(*xhc));
7d6bbebb7bb0294 David Woodhouse     2021-02-02  1400  
310bc39546a435c David Woodhouse     2023-01-11  1401  	mutex_unlock(&kvm->arch.xen.xen_lock);
6d7228352609085 Paul Durrant        2023-11-02  1402  
6d7228352609085 Paul Durrant        2023-11-02  1403  	if ((old_flags ^ xhc->flags) & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE)
6d7228352609085 Paul Durrant        2023-11-02  1404  		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
6d7228352609085 Paul Durrant        2023-11-02  1405  
78e9878cb376969 David Woodhouse     2021-02-02  1406  	return 0;
78e9878cb376969 David Woodhouse     2021-02-02  1407  }
78e9878cb376969 David Woodhouse     2021-02-02  1408  
23200b7a30de315 Joao Martins        2018-06-13  1409  static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
23200b7a30de315 Joao Martins        2018-06-13  1410  {
23200b7a30de315 Joao Martins        2018-06-13  1411  	kvm_rax_write(vcpu, result);
23200b7a30de315 Joao Martins        2018-06-13  1412  	return kvm_skip_emulated_instruction(vcpu);
23200b7a30de315 Joao Martins        2018-06-13  1413  }
23200b7a30de315 Joao Martins        2018-06-13  1414  
23200b7a30de315 Joao Martins        2018-06-13  1415  static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
23200b7a30de315 Joao Martins        2018-06-13  1416  {
23200b7a30de315 Joao Martins        2018-06-13  1417  	struct kvm_run *run = vcpu->run;
23200b7a30de315 Joao Martins        2018-06-13  1418  
23200b7a30de315 Joao Martins        2018-06-13  1419  	if (unlikely(!kvm_is_linear_rip(vcpu, vcpu->arch.xen.hypercall_rip)))
23200b7a30de315 Joao Martins        2018-06-13  1420  		return 1;
23200b7a30de315 Joao Martins        2018-06-13  1421  
23200b7a30de315 Joao Martins        2018-06-13  1422  	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
23200b7a30de315 Joao Martins        2018-06-13  1423  }
23200b7a30de315 Joao Martins        2018-06-13  1424  
4ea9439fd537313 David Woodhouse     2022-11-12  1425  static inline int max_evtchn_port(struct kvm *kvm)
4ea9439fd537313 David Woodhouse     2022-11-12  1426  {
4ea9439fd537313 David Woodhouse     2022-11-12  1427  	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
4ea9439fd537313 David Woodhouse     2022-11-12  1428  		return EVTCHN_2L_NR_CHANNELS;
4ea9439fd537313 David Woodhouse     2022-11-12  1429  	else
4ea9439fd537313 David Woodhouse     2022-11-12  1430  		return COMPAT_EVTCHN_2L_NR_CHANNELS;
4ea9439fd537313 David Woodhouse     2022-11-12  1431  }
4ea9439fd537313 David Woodhouse     2022-11-12  1432  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1433  static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1434  			       evtchn_port_t *ports)
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1435  {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1436  	struct kvm *kvm = vcpu->kvm;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1437  	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1438  	unsigned long *pending_bits;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1439  	unsigned long flags;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1440  	bool ret = true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1441  	int idx, i;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1442  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1443  	idx = srcu_read_lock(&kvm->srcu);
4265df667bbdc71 Peng Hao            2022-11-08  1444  	read_lock_irqsave(&gpc->lock, flags);
58f5ee5fedd981e Sean Christopherson 2022-10-13  1445  	if (!kvm_gpc_check(gpc, PAGE_SIZE))
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1446  		goto out_rcu;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1447  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1448  	ret = false;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1449  	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1450  		struct shared_info *shinfo = gpc->khva;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1451  		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1452  	} else {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1453  		struct compat_shared_info *shinfo = gpc->khva;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1454  		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1455  	}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1456  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1457  	for (i = 0; i < nr_ports; i++) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1458  		if (test_bit(ports[i], pending_bits)) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1459  			ret = true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1460  			break;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1461  		}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1462  	}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1463  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1464   out_rcu:
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1465  	read_unlock_irqrestore(&gpc->lock, flags);
4265df667bbdc71 Peng Hao            2022-11-08  1466  	srcu_read_unlock(&kvm->srcu, idx);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1467  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1468  	return ret;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1469  }
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1470  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1471  static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1472  				 u64 param, u64 *r)
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1473  {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1474  	struct sched_poll sched_poll;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1475  	evtchn_port_t port, *ports;
92c58965e9656dc David Woodhouse     2022-12-26  1476  	struct x86_exception e;
92c58965e9656dc David Woodhouse     2022-12-26  1477  	int i;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1478  
214b0a88c46d5f3 Metin Kaya          2022-03-21  1479  	if (!lapic_in_kernel(vcpu) ||
26e228ec1695011 Sean Christopherson 2025-02-14  1480  	    !(vcpu->kvm->arch.xen.hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SEND))
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1481  		return false;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1482  
214b0a88c46d5f3 Metin Kaya          2022-03-21  1483  	if (IS_ENABLED(CONFIG_64BIT) && !longmode) {
214b0a88c46d5f3 Metin Kaya          2022-03-21  1484  		struct compat_sched_poll sp32;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1485  
214b0a88c46d5f3 Metin Kaya          2022-03-21  1486  		/* Sanity check that the compat struct definition is correct */
214b0a88c46d5f3 Metin Kaya          2022-03-21  1487  		BUILD_BUG_ON(sizeof(sp32) != 16);
214b0a88c46d5f3 Metin Kaya          2022-03-21  1488  
92c58965e9656dc David Woodhouse     2022-12-26  1489  		if (kvm_read_guest_virt(vcpu, param, &sp32, sizeof(sp32), &e)) {
214b0a88c46d5f3 Metin Kaya          2022-03-21  1490  			*r = -EFAULT;
214b0a88c46d5f3 Metin Kaya          2022-03-21  1491  			return true;
214b0a88c46d5f3 Metin Kaya          2022-03-21  1492  		}
214b0a88c46d5f3 Metin Kaya          2022-03-21  1493  
214b0a88c46d5f3 Metin Kaya          2022-03-21  1494  		/*
214b0a88c46d5f3 Metin Kaya          2022-03-21  1495  		 * This is a 32-bit pointer to an array of evtchn_port_t which
214b0a88c46d5f3 Metin Kaya          2022-03-21  1496  		 * are uint32_t, so once it's converted no further compat
214b0a88c46d5f3 Metin Kaya          2022-03-21  1497  		 * handling is needed.
214b0a88c46d5f3 Metin Kaya          2022-03-21  1498  		 */
214b0a88c46d5f3 Metin Kaya          2022-03-21  1499  		sched_poll.ports = (void *)(unsigned long)(sp32.ports);
214b0a88c46d5f3 Metin Kaya          2022-03-21  1500  		sched_poll.nr_ports = sp32.nr_ports;
214b0a88c46d5f3 Metin Kaya          2022-03-21  1501  		sched_poll.timeout = sp32.timeout;
214b0a88c46d5f3 Metin Kaya          2022-03-21  1502  	} else {
92c58965e9656dc David Woodhouse     2022-12-26  1503  		if (kvm_read_guest_virt(vcpu, param, &sched_poll,
92c58965e9656dc David Woodhouse     2022-12-26  1504  					sizeof(sched_poll), &e)) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1505  			*r = -EFAULT;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1506  			return true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1507  		}
214b0a88c46d5f3 Metin Kaya          2022-03-21  1508  	}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1509  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1510  	if (unlikely(sched_poll.nr_ports > 1)) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1511  		/* Xen (unofficially) limits number of pollers to 128 */
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1512  		if (sched_poll.nr_ports > 128) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1513  			*r = -EINVAL;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1514  			return true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1515  		}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1516  
bf4afc53b77aeaa Linus Torvalds      2026-02-21  1517  		ports = kmalloc_objs(*ports, sched_poll.nr_ports);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1518  		if (!ports) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1519  			*r = -ENOMEM;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1520  			return true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1521  		}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1522  	} else
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1523  		ports = &port;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1524  
92c58965e9656dc David Woodhouse     2022-12-26 @1525  	if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
92c58965e9656dc David Woodhouse     2022-12-26  1526  				sched_poll.nr_ports * sizeof(*ports), &e)) {
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1527  		*r = -EFAULT;
5a53249d149f48b Manuel Andreas      2025-07-23  1528  		goto out;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1529  	}
92c58965e9656dc David Woodhouse     2022-12-26  1530  
92c58965e9656dc David Woodhouse     2022-12-26  1531  	for (i = 0; i < sched_poll.nr_ports; i++) {
4ea9439fd537313 David Woodhouse     2022-11-12  1532  		if (ports[i] >= max_evtchn_port(vcpu->kvm)) {
4ea9439fd537313 David Woodhouse     2022-11-12  1533  			*r = -EINVAL;
4ea9439fd537313 David Woodhouse     2022-11-12  1534  			goto out;
4ea9439fd537313 David Woodhouse     2022-11-12  1535  		}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1536  	}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1537  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1538  	if (sched_poll.nr_ports == 1)
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1539  		vcpu->arch.xen.poll_evtchn = port;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1540  	else
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1541  		vcpu->arch.xen.poll_evtchn = -1;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1542  
79f772b9e8004c5 Sean Christopherson 2022-06-14  1543  	set_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1544  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1545  	if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports)) {
c9e5f3fa9039611 Jim Mattson         2025-01-13  1546  		kvm_set_mp_state(vcpu, KVM_MP_STATE_HALTED);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1547  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1548  		if (sched_poll.timeout)
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1549  			mod_timer(&vcpu->arch.xen.poll_timer,
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1550  				  jiffies + nsecs_to_jiffies(sched_poll.timeout));
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1551  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1552  		kvm_vcpu_halt(vcpu);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1553  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1554  		if (sched_poll.timeout)
8fa7292fee5c524 Thomas Gleixner     2025-04-05  1555  			timer_delete(&vcpu->arch.xen.poll_timer);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1556  
c9e5f3fa9039611 Jim Mattson         2025-01-13  1557  		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1558  	}
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1559  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1560  	vcpu->arch.xen.poll_evtchn = 0;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1561  	*r = 0;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1562  out:
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1563  	/* Really, this is only needed in case of timeout */
79f772b9e8004c5 Sean Christopherson 2022-06-14  1564  	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1565  
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1566  	if (unlikely(sched_poll.nr_ports > 1))
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1567  		kfree(ports);
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1568  	return true;
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1569  }
1a65105a5aba9f7 Boris Ostrovsky     2022-03-03  1570  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

