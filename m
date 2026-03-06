Return-Path: <kvm+bounces-73081-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLyWC/zzqmkjZAEAu9opvQ
	(envelope-from <kvm+bounces-73081-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:34:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1850F223DFB
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 59F26302BB89
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4E93E3DBF;
	Fri,  6 Mar 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ey9OpQ7P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420ED3E1224;
	Fri,  6 Mar 2026 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811055; cv=none; b=tnntzsd7ZvFyJ9aB25U+8+3AFpBzCCYq3T4su7NOCQ9UpjqLFJGdI+FKN4TU5RxzNrQAWKKnMGYY9hnFG51eTyd2qYLiRWCmH6cqsULS31v8LS/w4wNapplu7Qj6eibUF6ywGhWvz8L+DfMTvMNhF+VkxKqjfnyK7myyfWxrtQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811055; c=relaxed/simple;
	bh=pS85FMUXM+m1iYZbfu+YdDCHT7M2SukoVn9UY6huvRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqO4a3NEawvqAlZwCE57cvkT3k9oWlfjdrmZKjD0j4wA0rr+nEyHqICr2nCwU+sbKfjoZlxtjS49D2+Z2lrY4Gs3xfYC0RqlSKgehz0Xs0lWXrGUs6uJEicnoLPd84iYHCV+lCoDuFn7xwbKKsFb3MPVHAKx4iOwCYgnbDwvkwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ey9OpQ7P; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772811054; x=1804347054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=pS85FMUXM+m1iYZbfu+YdDCHT7M2SukoVn9UY6huvRQ=;
  b=Ey9OpQ7PSJ+HAdpDstp9NxJTrO7gQiraiFLOagodpGAj846aWeFYaeOU
   Rtov/oHAt8DZZg9iuzcOKdzD0pBe0L5jrweOfJ8KHZ+m6rWkuaagZMikr
   JUUcniInexKlfRDd4rEjJjTTM05jyIGeHaV15r22DmUCzQmCw58hIDw9z
   IUD7l1jhZ776v/dazE8gLYOlzSIGnSJe4dxGSqBwPs4Eq6q4Pi9Xv2V18
   wEQRRuhKiRLDuJjEPQ5cQE24q+lKrgHEasI0UPoyRRt9jZqXHgQ2ro2w6
   UWE47a1LEFkpZx6yxb3y1QxOke3uiW0ivpGofE5KXJ1pVJRqHqfP+K+84
   g==;
X-CSE-ConnectionGUID: YaJa0AVXSRGQla8iCJBHSQ==
X-CSE-MsgGUID: 9+XIUr2jTX6JRXZZw1iHbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84246796"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="84246796"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 07:30:53 -0800
X-CSE-ConnectionGUID: BIph+os+QGuT30IHdWN/rg==
X-CSE-MsgGUID: ULDluUX6QKCkfp9vYStVpw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 06 Mar 2026 07:30:50 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyX8a-000000000zN-2hk5;
	Fri, 06 Mar 2026 15:30:48 +0000
Date: Fri, 6 Mar 2026 23:30:07 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
Message-ID: <202603062311.YDLuRUqh-lkp@intel.com>
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260306041125.45643-1-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: 1850F223DFB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73081-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.971];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,git-scm.com:url,intel.com:dkim,intel.com:email,intel.com:mid,01.org:url]
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
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20260306/202603062311.YDLuRUqh-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c32caeec8158d634bb71ab8911a6031248b9fc47)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603062311.YDLuRUqh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603062311.YDLuRUqh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/powerpc/kvm/book3s_64_mmu.c:253:42: warning: format specifies type 'unsigned long' but the argument has type 'hva_t' (aka 'unsigned long long') [-Wformat]
     253 |                         "KVM: Can't copy data from 0x%lx!\n", ptegp);
         |                                                      ~~~      ^~~~~
         |                                                      %llx
   include/linux/printk.h:705:17: note: expanded from macro 'printk_ratelimited'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.
--
>> arch/powerpc/kvm/book3s_32_mmu.c:211:42: warning: format specifies type 'unsigned long' but the argument has type 'hva_t' (aka 'unsigned long long') [-Wformat]
     211 |                         "KVM: Can't copy data from 0x%lx!\n", ptegp);
         |                                                      ~~~      ^~~~~
         |                                                      %llx
   include/linux/printk.h:705:17: note: expanded from macro 'printk_ratelimited'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.


vim +253 arch/powerpc/kvm/book3s_64_mmu.c

a4a0f2524acc2c6 Paul Mackerras       2013-09-20  190  
e71b2a39afff245 Alexander Graf       2009-10-30  191  static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
93b159b466bdc97 Paul Mackerras       2013-09-20  192  				      struct kvmppc_pte *gpte, bool data,
93b159b466bdc97 Paul Mackerras       2013-09-20  193  				      bool iswrite)
e71b2a39afff245 Alexander Graf       2009-10-30  194  {
e71b2a39afff245 Alexander Graf       2009-10-30  195  	struct kvmppc_slb *slbe;
e71b2a39afff245 Alexander Graf       2009-10-30  196  	hva_t ptegp;
e71b2a39afff245 Alexander Graf       2009-10-30  197  	u64 pteg[16];
e71b2a39afff245 Alexander Graf       2009-10-30  198  	u64 avpn = 0;
b352ddae7b2ccd2 Cédric Le Goater     2021-08-19  199  	u64 r;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  200  	u64 v_val, v_mask;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  201  	u64 eaddr_mask;
e71b2a39afff245 Alexander Graf       2009-10-30  202  	int i;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  203  	u8 pp, key = 0;
e71b2a39afff245 Alexander Graf       2009-10-30  204  	bool found = false;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  205  	bool second = false;
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  206  	int pgsize;
e8508940a88691a Alexander Graf       2010-07-29  207  	ulong mp_ea = vcpu->arch.magic_page_ea;
e8508940a88691a Alexander Graf       2010-07-29  208  
e8508940a88691a Alexander Graf       2010-07-29  209  	/* Magic page override */
e8508940a88691a Alexander Graf       2010-07-29  210  	if (unlikely(mp_ea) &&
e8508940a88691a Alexander Graf       2010-07-29  211  	    unlikely((eaddr & ~0xfffULL) == (mp_ea & ~0xfffULL)) &&
5deb8e7ad8ac7e3 Alexander Graf       2014-04-24  212  	    !(kvmppc_get_msr(vcpu) & MSR_PR)) {
e8508940a88691a Alexander Graf       2010-07-29  213  		gpte->eaddr = eaddr;
e8508940a88691a Alexander Graf       2010-07-29  214  		gpte->vpage = kvmppc_mmu_book3s_64_ea_to_vp(vcpu, eaddr, data);
e8508940a88691a Alexander Graf       2010-07-29  215  		gpte->raddr = vcpu->arch.magic_page_pa | (gpte->raddr & 0xfff);
e8508940a88691a Alexander Graf       2010-07-29  216  		gpte->raddr &= KVM_PAM;
e8508940a88691a Alexander Graf       2010-07-29  217  		gpte->may_execute = true;
e8508940a88691a Alexander Graf       2010-07-29  218  		gpte->may_read = true;
e8508940a88691a Alexander Graf       2010-07-29  219  		gpte->may_write = true;
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  220  		gpte->page_size = MMU_PAGE_4K;
6c7d47c33ed323f Alexey Kardashevskiy 2017-11-22  221  		gpte->wimg = HPTE_R_M;
e8508940a88691a Alexander Graf       2010-07-29  222  
e8508940a88691a Alexander Graf       2010-07-29  223  		return 0;
e8508940a88691a Alexander Graf       2010-07-29  224  	}
e71b2a39afff245 Alexander Graf       2009-10-30  225  
c4befc58a0cc5a8 Paul Mackerras       2011-06-29  226  	slbe = kvmppc_mmu_book3s_64_find_slbe(vcpu, eaddr);
e71b2a39afff245 Alexander Graf       2009-10-30  227  	if (!slbe)
e71b2a39afff245 Alexander Graf       2009-10-30  228  		goto no_seg_found;
e71b2a39afff245 Alexander Graf       2009-10-30  229  
0f296829b5a59d5 Paul Mackerras       2013-06-22  230  	avpn = kvmppc_mmu_book3s_64_get_avpn(slbe, eaddr);
7e48c101e0c53e6 Paul Mackerras       2013-08-06  231  	v_val = avpn & HPTE_V_AVPN;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  232  
0f296829b5a59d5 Paul Mackerras       2013-06-22  233  	if (slbe->tb)
7e48c101e0c53e6 Paul Mackerras       2013-08-06  234  		v_val |= SLB_VSID_B_1T;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  235  	if (slbe->large)
7e48c101e0c53e6 Paul Mackerras       2013-08-06  236  		v_val |= HPTE_V_LARGE;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  237  	v_val |= HPTE_V_VALID;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  238  
7e48c101e0c53e6 Paul Mackerras       2013-08-06  239  	v_mask = SLB_VSID_B | HPTE_V_AVPN | HPTE_V_LARGE | HPTE_V_VALID |
7e48c101e0c53e6 Paul Mackerras       2013-08-06  240  		HPTE_V_SECONDARY;
0f296829b5a59d5 Paul Mackerras       2013-06-22  241  
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  242  	pgsize = slbe->large ? MMU_PAGE_16M : MMU_PAGE_4K;
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  243  
9308ab8e2da933d Paul Mackerras       2013-09-20  244  	mutex_lock(&vcpu->kvm->arch.hpt_mutex);
9308ab8e2da933d Paul Mackerras       2013-09-20  245  
e71b2a39afff245 Alexander Graf       2009-10-30  246  do_second:
3ff955024d186c5 Paul Mackerras       2013-09-20  247  	ptegp = kvmppc_mmu_book3s_64_get_pteg(vcpu, slbe, eaddr, second);
e71b2a39afff245 Alexander Graf       2009-10-30  248  	if (kvm_is_error_hva(ptegp))
e71b2a39afff245 Alexander Graf       2009-10-30  249  		goto no_page_found;
e71b2a39afff245 Alexander Graf       2009-10-30  250  
e71b2a39afff245 Alexander Graf       2009-10-30  251  	if(copy_from_user(pteg, (void __user *)ptegp, sizeof(pteg))) {
4da934dc6515afa Vipin K Parashar     2017-02-16  252  		printk_ratelimited(KERN_ERR
4da934dc6515afa Vipin K Parashar     2017-02-16 @253  			"KVM: Can't copy data from 0x%lx!\n", ptegp);
e71b2a39afff245 Alexander Graf       2009-10-30  254  		goto no_page_found;
e71b2a39afff245 Alexander Graf       2009-10-30  255  	}
e71b2a39afff245 Alexander Graf       2009-10-30  256  
5deb8e7ad8ac7e3 Alexander Graf       2014-04-24  257  	if ((kvmppc_get_msr(vcpu) & MSR_PR) && slbe->Kp)
e71b2a39afff245 Alexander Graf       2009-10-30  258  		key = 4;
5deb8e7ad8ac7e3 Alexander Graf       2014-04-24  259  	else if (!(kvmppc_get_msr(vcpu) & MSR_PR) && slbe->Ks)
e71b2a39afff245 Alexander Graf       2009-10-30  260  		key = 4;
e71b2a39afff245 Alexander Graf       2009-10-30  261  
e71b2a39afff245 Alexander Graf       2009-10-30  262  	for (i=0; i<16; i+=2) {
4e509af9f83debe Alexander Graf       2014-04-24  263  		u64 pte0 = be64_to_cpu(pteg[i]);
4e509af9f83debe Alexander Graf       2014-04-24  264  		u64 pte1 = be64_to_cpu(pteg[i + 1]);
4e509af9f83debe Alexander Graf       2014-04-24  265  
7e48c101e0c53e6 Paul Mackerras       2013-08-06  266  		/* Check all relevant fields of 1st dword */
4e509af9f83debe Alexander Graf       2014-04-24  267  		if ((pte0 & v_mask) == v_val) {
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  268  			/* If large page bit is set, check pgsize encoding */
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  269  			if (slbe->large &&
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  270  			    (vcpu->arch.hflags & BOOK3S_HFLAG_MULTI_PGSIZE)) {
4e509af9f83debe Alexander Graf       2014-04-24  271  				pgsize = decode_pagesize(slbe, pte1);
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  272  				if (pgsize < 0)
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  273  					continue;
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  274  			}
7e48c101e0c53e6 Paul Mackerras       2013-08-06  275  			found = true;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  276  			break;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  277  		}
7e48c101e0c53e6 Paul Mackerras       2013-08-06  278  	}
e71b2a39afff245 Alexander Graf       2009-10-30  279  
7e48c101e0c53e6 Paul Mackerras       2013-08-06  280  	if (!found) {
7e48c101e0c53e6 Paul Mackerras       2013-08-06  281  		if (second)
7e48c101e0c53e6 Paul Mackerras       2013-08-06  282  			goto no_page_found;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  283  		v_val |= HPTE_V_SECONDARY;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  284  		second = true;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  285  		goto do_second;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  286  	}
e71b2a39afff245 Alexander Graf       2009-10-30  287  
4e509af9f83debe Alexander Graf       2014-04-24  288  	r = be64_to_cpu(pteg[i+1]);
7e48c101e0c53e6 Paul Mackerras       2013-08-06  289  	pp = (r & HPTE_R_PP) | key;
03a9c90334d611c Paul Mackerras       2013-09-20  290  	if (r & HPTE_R_PP0)
03a9c90334d611c Paul Mackerras       2013-09-20  291  		pp |= 8;
e71b2a39afff245 Alexander Graf       2009-10-30  292  
e71b2a39afff245 Alexander Graf       2009-10-30  293  	gpte->eaddr = eaddr;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  294  	gpte->vpage = kvmppc_mmu_book3s_64_ea_to_vp(vcpu, eaddr, data);
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  295  
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  296  	eaddr_mask = (1ull << mmu_pagesize(pgsize)) - 1;
7e48c101e0c53e6 Paul Mackerras       2013-08-06  297  	gpte->raddr = (r & HPTE_R_RPN & ~eaddr_mask) | (eaddr & eaddr_mask);
a4a0f2524acc2c6 Paul Mackerras       2013-09-20  298  	gpte->page_size = pgsize;
e71b2a39afff245 Alexander Graf       2009-10-30  299  	gpte->may_execute = ((r & HPTE_R_N) ? false : true);
f3383cf80e417e8 Alexander Graf       2014-05-12  300  	if (unlikely(vcpu->arch.disable_kernel_nx) &&
f3383cf80e417e8 Alexander Graf       2014-05-12  301  	    !(kvmppc_get_msr(vcpu) & MSR_PR))
f3383cf80e417e8 Alexander Graf       2014-05-12  302  		gpte->may_execute = true;
e71b2a39afff245 Alexander Graf       2009-10-30  303  	gpte->may_read = false;
e71b2a39afff245 Alexander Graf       2009-10-30  304  	gpte->may_write = false;
96df2267695199b Alexey Kardashevskiy 2017-03-24  305  	gpte->wimg = r & HPTE_R_WIMG;
e71b2a39afff245 Alexander Graf       2009-10-30  306  
e71b2a39afff245 Alexander Graf       2009-10-30  307  	switch (pp) {
e71b2a39afff245 Alexander Graf       2009-10-30  308  	case 0:
e71b2a39afff245 Alexander Graf       2009-10-30  309  	case 1:
e71b2a39afff245 Alexander Graf       2009-10-30  310  	case 2:
e71b2a39afff245 Alexander Graf       2009-10-30  311  	case 6:
e71b2a39afff245 Alexander Graf       2009-10-30  312  		gpte->may_write = true;
8fc6ba0a205e9ad Joe Perches          2020-03-10  313  		fallthrough;
e71b2a39afff245 Alexander Graf       2009-10-30  314  	case 3:
e71b2a39afff245 Alexander Graf       2009-10-30  315  	case 5:
e71b2a39afff245 Alexander Graf       2009-10-30  316  	case 7:
03a9c90334d611c Paul Mackerras       2013-09-20  317  	case 10:
e71b2a39afff245 Alexander Graf       2009-10-30  318  		gpte->may_read = true;
e71b2a39afff245 Alexander Graf       2009-10-30  319  		break;
e71b2a39afff245 Alexander Graf       2009-10-30  320  	}
e71b2a39afff245 Alexander Graf       2009-10-30  321  
e71b2a39afff245 Alexander Graf       2009-10-30  322  	dprintk("KVM MMU: Translated 0x%lx [0x%llx] -> 0x%llx "
af7b4d104b36e78 Alexander Graf       2010-04-20  323  		"-> 0x%lx\n",
e71b2a39afff245 Alexander Graf       2009-10-30  324  		eaddr, avpn, gpte->vpage, gpte->raddr);
e71b2a39afff245 Alexander Graf       2009-10-30  325  
e71b2a39afff245 Alexander Graf       2009-10-30  326  	/* Update PTE R and C bits, so the guest's swapper knows we used the
e71b2a39afff245 Alexander Graf       2009-10-30  327  	 * page */
9308ab8e2da933d Paul Mackerras       2013-09-20  328  	if (gpte->may_read && !(r & HPTE_R_R)) {
9308ab8e2da933d Paul Mackerras       2013-09-20  329  		/*
9308ab8e2da933d Paul Mackerras       2013-09-20  330  		 * Set the accessed flag.
9308ab8e2da933d Paul Mackerras       2013-09-20  331  		 * We have to write this back with a single byte write
9308ab8e2da933d Paul Mackerras       2013-09-20  332  		 * because another vcpu may be accessing this on
9308ab8e2da933d Paul Mackerras       2013-09-20  333  		 * non-PAPR platforms such as mac99, and this is
9308ab8e2da933d Paul Mackerras       2013-09-20  334  		 * what real hardware does.
9308ab8e2da933d Paul Mackerras       2013-09-20  335  		 */
740f834eb2505e1 Alexander Graf       2014-04-24  336                  char __user *addr = (char __user *) (ptegp + (i + 1) * sizeof(u64));
7e48c101e0c53e6 Paul Mackerras       2013-08-06  337  		r |= HPTE_R_R;
9308ab8e2da933d Paul Mackerras       2013-09-20  338  		put_user(r >> 8, addr + 6);
e71b2a39afff245 Alexander Graf       2009-10-30  339  	}
93b159b466bdc97 Paul Mackerras       2013-09-20  340  	if (iswrite && gpte->may_write && !(r & HPTE_R_C)) {
93b159b466bdc97 Paul Mackerras       2013-09-20  341  		/* Set the dirty flag */
9308ab8e2da933d Paul Mackerras       2013-09-20  342  		/* Use a single byte write */
740f834eb2505e1 Alexander Graf       2014-04-24  343                  char __user *addr = (char __user *) (ptegp + (i + 1) * sizeof(u64));
7e48c101e0c53e6 Paul Mackerras       2013-08-06  344  		r |= HPTE_R_C;
9308ab8e2da933d Paul Mackerras       2013-09-20  345  		put_user(r, addr + 7);
e71b2a39afff245 Alexander Graf       2009-10-30  346  	}
e71b2a39afff245 Alexander Graf       2009-10-30  347  
9308ab8e2da933d Paul Mackerras       2013-09-20  348  	mutex_unlock(&vcpu->kvm->arch.hpt_mutex);
e71b2a39afff245 Alexander Graf       2009-10-30  349  
93b159b466bdc97 Paul Mackerras       2013-09-20  350  	if (!gpte->may_read || (iswrite && !gpte->may_write))
6ed1485f65f0eb1 Paul Mackerras       2013-06-22  351  		return -EPERM;
e71b2a39afff245 Alexander Graf       2009-10-30  352  	return 0;
e71b2a39afff245 Alexander Graf       2009-10-30  353  
e71b2a39afff245 Alexander Graf       2009-10-30  354  no_page_found:
9308ab8e2da933d Paul Mackerras       2013-09-20  355  	mutex_unlock(&vcpu->kvm->arch.hpt_mutex);
e71b2a39afff245 Alexander Graf       2009-10-30  356  	return -ENOENT;
e71b2a39afff245 Alexander Graf       2009-10-30  357  
e71b2a39afff245 Alexander Graf       2009-10-30  358  no_seg_found:
e71b2a39afff245 Alexander Graf       2009-10-30  359  	dprintk("KVM MMU: Trigger segment fault\n");
e71b2a39afff245 Alexander Graf       2009-10-30  360  	return -EINVAL;
e71b2a39afff245 Alexander Graf       2009-10-30  361  }
e71b2a39afff245 Alexander Graf       2009-10-30  362  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

