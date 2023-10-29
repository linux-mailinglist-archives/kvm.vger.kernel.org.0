Return-Path: <kvm+bounces-29-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CC27DADB8
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 19:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2111F218A7
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 18:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098D6FC09;
	Sun, 29 Oct 2023 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MsCjNf9F"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E29443
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 18:41:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2522AB;
	Sun, 29 Oct 2023 11:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698604915; x=1730140915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4FFufjLNr4846R4FP5r0jinRPlFp0S9jNHqTPJGf77o=;
  b=MsCjNf9FhlCpe3rlkwHWC7qDIIuxNyTKG+2Aq6O5AEAw7Q5tUUbJCaal
   E68pphrY7TN4TF2uY/hzxAiLN90Gpo5sipOM9wMPSZejuTUd8OpV/9HHZ
   N/DKFF8+CT3/wKgbiXvsLYs0rij4btkLCeBZPm8qL0Pf2cAOsQI/Wahfc
   UwlAoDS4AoDH7COhJ46sUVpjsNpICo2uFz0RFMi2BFDiw7sQfTxJi5M/e
   rH7M7MVi/IHVetRiHTUGCVhvzRpGSdxgH3q/gM2kD3sKrVcrkmy32CwN1
   ejlZvh3naQdpYjmZAM60KYnJVWAH0NSAl8sPgU16cvwfmQvptAntYQoGF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="387789248"
X-IronPort-AV: E=Sophos;i="6.03,261,1694761200"; 
   d="scan'208";a="387789248"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2023 11:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="760079543"
X-IronPort-AV: E=Sophos;i="6.03,261,1694761200"; 
   d="scan'208";a="760079543"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 29 Oct 2023 11:41:51 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qxAjN-000Ckl-0U;
	Sun, 29 Oct 2023 18:41:49 +0000
Date: Mon, 30 Oct 2023 02:41:48 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Jos=E9?= Pekkarinen <jose.pekkarinen@foxhound.fi>,
	seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	skhan@linuxfoundation.org
Cc: oe-kbuild-all@lists.linux.dev,
	=?iso-8859-1?Q?Jos=E9?= Pekkarinen <jose.pekkarinen@foxhound.fi>,
	x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] KVM: x86: cleanup unused variables
Message-ID: <202310300228.s4py0SQf-lkp@intel.com>
References: <20231029093859.138442-1-jose.pekkarinen@foxhound.fi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231029093859.138442-1-jose.pekkarinen@foxhound.fi>

Hi José,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.6-rc7 next-20231027]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jos-Pekkarinen/KVM-x86-cleanup-unused-variables/20231029-174855
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20231029093859.138442-1-jose.pekkarinen%40foxhound.fi
patch subject: [PATCH] KVM: x86: cleanup unused variables
config: i386-buildonly-randconfig-006-20231030 (https://download.01.org/0day-ci/archive/20231030/202310300228.s4py0SQf-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231030/202310300228.s4py0SQf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310300228.s4py0SQf-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/emulate.c: In function 'decode_modrm':
>> arch/x86/kvm/emulate.c:950:9: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
     950 |         rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));                 \
         |         ^~
   arch/x86/kvm/emulate.c:1225:45: note: in expansion of macro 'insn_fetch'
    1225 |                                 modrm_ea += insn_fetch(u16, ctxt);
         |                                             ^~~~~~~~~~
   arch/x86/kvm/emulate.c:950:9: note: each undeclared identifier is reported only once for each function it appears in
     950 |         rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));                 \
         |         ^~
   arch/x86/kvm/emulate.c:1225:45: note: in expansion of macro 'insn_fetch'
    1225 |                                 modrm_ea += insn_fetch(u16, ctxt);
         |                                             ^~~~~~~~~~
   arch/x86/kvm/emulate.c: In function 'decode_abs':
>> arch/x86/kvm/emulate.c:950:9: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
     950 |         rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));                 \
         |         ^~
   arch/x86/kvm/emulate.c:1317:35: note: in expansion of macro 'insn_fetch'
    1317 |                 op->addr.mem.ea = insn_fetch(u16, ctxt);
         |                                   ^~~~~~~~~~
   arch/x86/kvm/emulate.c: In function 'decode_imm':
>> arch/x86/kvm/emulate.c:950:9: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
     950 |         rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));                 \
         |         ^~
   arch/x86/kvm/emulate.c:4560:27: note: in expansion of macro 'insn_fetch'
    4560 |                 op->val = insn_fetch(s8, ctxt);
         |                           ^~~~~~~~~~


vim +950 arch/x86/kvm/emulate.c

6226686954c4cc drivers/kvm/x86_emulate.c Avi Kivity       2007-11-20  945  
67cbc90db5c0f0 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-05-15  946  /* Fetch next part of the instruction being emulated. */
e85a10852c26d7 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-07-30  947  #define insn_fetch(_type, _ctxt)					\
9506d57de3bc82 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06  948  ({	_type _x;							\
9506d57de3bc82 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06  949  									\
9506d57de3bc82 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06 @950  	rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));			\
67cbc90db5c0f0 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-05-15  951  	if (rc != X86EMUL_CONTINUE)					\
67cbc90db5c0f0 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-05-15  952  		goto done;						\
9506d57de3bc82 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06  953  	ctxt->_eip += sizeof(_type);					\
8616abc2537933 arch/x86/kvm/emulate.c    Nick Desaulniers 2017-06-27  954  	memcpy(&_x, ctxt->fetch.ptr, sizeof(_type));			\
17052f16a51af6 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06  955  	ctxt->fetch.ptr += sizeof(_type);				\
9506d57de3bc82 arch/x86/kvm/emulate.c    Paolo Bonzini    2014-05-06  956  	_x;								\
67cbc90db5c0f0 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-05-15  957  })
67cbc90db5c0f0 arch/x86/kvm/emulate.c    Takuya Yoshikawa 2011-05-15  958  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

