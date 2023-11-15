Return-Path: <kvm+bounces-1847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6761E7ECD5B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 20:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B5E91C20971
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 19:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1A4433B4;
	Wed, 15 Nov 2023 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GhEzt9FB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB93D4F;
	Wed, 15 Nov 2023 11:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700076965; x=1731612965;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I7CizqM7NHJrb9+NwK27mDv9+sdcm9wG+0USwvgv+NI=;
  b=GhEzt9FB3ZLW4dSYbSkPwea9H9JejPBFP4KSxbKaiznHmPdkBbHULI8M
   65bS9r9PC0yNd6VWzaH7orFJt+Pdj4Ys4/D3fu7CvWxJkHzgslGxL6Hrj
   O8cgDBFHUwne2M78MoHFBRczeYuKYCvUtb+keogEwIoGxCBis2io8PDpL
   A5Gb5siBTDbVbYp8tlzMWUq79I1f7mdkCUFbMGf8aGuVoATBSo0/nU75l
   V14SRNA2KtDkc15TH1fOPecX9WJkLjY/nKh0lV6ASvqM/OPKujL98AQgw
   nP3vyzjyiy+tQ6fo2Y/cmA7O1TkH1Ri9YbgZQP1ib7EhCLSoQdoLMmgHH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="12492193"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="12492193"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 11:36:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="758587268"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="758587268"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 15 Nov 2023 11:35:57 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r3Lg3-0000l6-0C;
	Wed, 15 Nov 2023 19:35:55 +0000
Date: Thu, 16 Nov 2023 03:35:37 +0800
From: kernel test robot <lkp@intel.com>
To: Tianrui Zhao <zhaotianrui@loongson.cn>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Mark Brown <broonie@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
	Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: Re: [PATCH v1 1/2] LoongArch: KVM: Add lsx support
Message-ID: <202311160322.46CT0b8t-lkp@intel.com>
References: <20231115091921.85516-2-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115091921.85516-2-zhaotianrui@loongson.cn>

Hi Tianrui,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.7-rc1 next-20231115]
[cannot apply to mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-lsx-support/20231115-173658
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20231115091921.85516-2-zhaotianrui%40loongson.cn
patch subject: [PATCH v1 1/2] LoongArch: KVM: Add lsx support
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20231116/202311160322.46CT0b8t-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231116/202311160322.46CT0b8t-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311160322.46CT0b8t-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/kvm/switch.S: Assembler messages:
>> arch/loongarch/kvm/switch.S:68: Error: no match insn: la.pcrel	,1f
   arch/loongarch/kvm/switch.S:259:  Info: macro invoked from here
>> arch/loongarch/kvm/switch.S:69: Error: no match insn: alsl.d	,$r13,,3
   arch/loongarch/kvm/switch.S:259:  Info: macro invoked from here
>> arch/loongarch/kvm/switch.S:70: Error: no match insn: jr	
   arch/loongarch/kvm/switch.S:259:  Info: macro invoked from here


vim +68 arch/loongarch/kvm/switch.S

39fdf4be72f2b8 Tianrui Zhao 2023-10-02   43  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   44  /*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   45   * Prepare switch to guest, save host regs and restore guest regs.
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   46   * a2: kvm_vcpu_arch, don't touch it until 'ertn'
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   47   * t0, t1: temp register
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   48   */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   49  .macro kvm_switch_to_guest
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   50  	/* Set host ECFG.VS=0, all exceptions share one exception entry */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   51  	csrrd		t0, LOONGARCH_CSR_ECFG
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   52  	bstrins.w	t0, zero, CSR_ECFG_VS_SHIFT_END, CSR_ECFG_VS_SHIFT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   53  	csrwr		t0, LOONGARCH_CSR_ECFG
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   54  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   55  	/* Load up the new EENTRY */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   56  	ld.d	t0, a2, KVM_ARCH_GEENTRY
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   57  	csrwr	t0, LOONGARCH_CSR_EENTRY
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   58  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   59  	/* Set Guest ERA */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   60  	ld.d	t0, a2, KVM_ARCH_GPC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   61  	csrwr	t0, LOONGARCH_CSR_ERA
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   62  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   63  	/* Save host PGDL */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   64  	csrrd	t0, LOONGARCH_CSR_PGDL
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   65  	st.d	t0, a2, KVM_ARCH_HPGD
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   66  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   67  	/* Switch to kvm */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  @68  	ld.d	t1, a2, KVM_VCPU_KVM - KVM_VCPU_ARCH
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  @69  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  @70  	/* Load guest PGDL */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   71  	li.w    t0, KVM_GPGD
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   72  	ldx.d   t0, t1, t0
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   73  	csrwr	t0, LOONGARCH_CSR_PGDL
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   74  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   75  	/* Mix GID and RID */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   76  	csrrd		t1, LOONGARCH_CSR_GSTAT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   77  	bstrpick.w	t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   78  	csrrd		t0, LOONGARCH_CSR_GTLBC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   79  	bstrins.w	t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   80  	csrwr		t0, LOONGARCH_CSR_GTLBC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   81  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   82  	/*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   83  	 * Enable intr in root mode with future ertn so that host interrupt
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   84  	 * can be responsed during VM runs
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   85  	 * Guest CRMD comes from separate GCSR_CRMD register
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   86  	 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   87  	ori	t0, zero, CSR_PRMD_PIE
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   88  	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   89  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   90  	/* Set PVM bit to setup ertn to guest context */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   91  	ori	t0, zero, CSR_GSTAT_PVM
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   92  	csrxchg	t0, t0,   LOONGARCH_CSR_GSTAT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   93  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   94  	/* Load Guest GPRs */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   95  	kvm_restore_guest_gprs a2
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   96  	/* Load KVM_ARCH register */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   97  	ld.d	a2, a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   98  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02   99  	ertn /* Switch to guest: GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  100  .endm
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  101  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  102  	/*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  103  	 * Exception entry for general exception from guest mode
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  104  	 *  - IRQ is disabled
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  105  	 *  - kernel privilege in root mode
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  106  	 *  - page mode keep unchanged from previous PRMD in root mode
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  107  	 *  - Fixme: tlb exception cannot happen since registers relative with TLB
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  108  	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  109  	 *  -        will fix with hw page walk enabled in future
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  110  	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  111  	 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  112  	.text
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  113  	.cfi_sections	.debug_frame
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  114  SYM_CODE_START(kvm_exc_entry)
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  115  	csrwr	a2,   KVM_TEMP_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  116  	csrrd	a2,   KVM_VCPU_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  117  	addi.d	a2,   a2, KVM_VCPU_ARCH
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  118  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  119  	/* After save GPRs, free to use any GPR */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  120  	kvm_save_guest_gprs a2
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  121  	/* Save guest A2 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  122  	csrrd	t0,	KVM_TEMP_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  123  	st.d	t0,	a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  124  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  125  	/* A2 is kvm_vcpu_arch, A1 is free to use */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  126  	csrrd	s1,   KVM_VCPU_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  127  	ld.d	s0,   s1, KVM_VCPU_RUN
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  128  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  129  	csrrd	t0,   LOONGARCH_CSR_ESTAT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  130  	st.d	t0,   a2, KVM_ARCH_HESTAT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  131  	csrrd	t0,   LOONGARCH_CSR_ERA
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  132  	st.d	t0,   a2, KVM_ARCH_GPC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  133  	csrrd	t0,   LOONGARCH_CSR_BADV
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  134  	st.d	t0,   a2, KVM_ARCH_HBADV
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  135  	csrrd	t0,   LOONGARCH_CSR_BADI
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  136  	st.d	t0,   a2, KVM_ARCH_HBADI
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  137  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  138  	/* Restore host ECFG.VS */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  139  	csrrd	t0, LOONGARCH_CSR_ECFG
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  140  	ld.d	t1, a2, KVM_ARCH_HECFG
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  141  	or	t0, t0, t1
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  142  	csrwr	t0, LOONGARCH_CSR_ECFG
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  143  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  144  	/* Restore host EENTRY */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  145  	ld.d	t0, a2, KVM_ARCH_HEENTRY
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  146  	csrwr	t0, LOONGARCH_CSR_EENTRY
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  147  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  148  	/* Restore host pgd table */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  149  	ld.d    t0, a2, KVM_ARCH_HPGD
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  150  	csrwr   t0, LOONGARCH_CSR_PGDL
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  151  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  152  	/*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  153  	 * Disable PGM bit to enter root mode by default with next ertn
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  154  	 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  155  	ori	t0, zero, CSR_GSTAT_PVM
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  156  	csrxchg	zero, t0, LOONGARCH_CSR_GSTAT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  157  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  158  	/*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  159  	 * Clear GTLBC.TGID field
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  160  	 *       0: for root  tlb update in future tlb instr
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  161  	 *  others: for guest tlb update like gpa to hpa in future tlb instr
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  162  	 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  163  	csrrd	t0, LOONGARCH_CSR_GTLBC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  164  	bstrins.w	t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  165  	csrwr	t0, LOONGARCH_CSR_GTLBC
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  166  	ld.d	tp, a2, KVM_ARCH_HTP
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  167  	ld.d	sp, a2, KVM_ARCH_HSP
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  168  	/* restore per cpu register */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  169  	ld.d	u0, a2, KVM_ARCH_HPERCPU
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  170  	addi.d	sp, sp, -PT_SIZE
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  171  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  172  	/* Prepare handle exception */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  173  	or	a0, s0, zero
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  174  	or	a1, s1, zero
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  175  	ld.d	t8, a2, KVM_ARCH_HANDLE_EXIT
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  176  	jirl	ra, t8, 0
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  177  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  178  	or	a2, s1, zero
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  179  	addi.d	a2, a2, KVM_VCPU_ARCH
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  180  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  181  	/* Resume host when ret <= 0 */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  182  	blez	a0, ret_to_host
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  183  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  184  	/*
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  185           * Return to guest
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  186           * Save per cpu register again, maybe switched to another cpu
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  187           */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  188  	st.d	u0, a2, KVM_ARCH_HPERCPU
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  189  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  190  	/* Save kvm_vcpu to kscratch */
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  191  	csrwr	s1, KVM_VCPU_KS
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  192  	kvm_switch_to_guest
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  193  
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  194  ret_to_host:
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  195  	ld.d    a2, a2, KVM_ARCH_HSP
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  196  	addi.d  a2, a2, -PT_SIZE
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  197  	kvm_restore_host_gpr    a2
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  198  	jr      ra
39fdf4be72f2b8 Tianrui Zhao 2023-10-02  199  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

