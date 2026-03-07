Return-Path: <kvm+bounces-73219-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKkiEEuQq2lHeQEAu9opvQ
	(envelope-from <kvm+bounces-73219-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:41:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9256A229A78
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BCFD309BE9D
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB0C2F1FE3;
	Sat,  7 Mar 2026 02:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cibbdFCA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C63D28B7EA;
	Sat,  7 Mar 2026 02:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772851236; cv=none; b=jebgTyEhwm2FJalC8CepjupDdgi0gfNBrAWEKRnu6lBTlPsx3/QpdAvsJPWqSzDrMDEZbhvL2XAdVpa0CARi4IIanKnBLFN0VPUdZSX4Qt3J0diq2Rqn/y5rh2/V/6VoLf4sMBT63NCMmMGj0GvU/d5SLkfAyfyNjCJ4NNCASeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772851236; c=relaxed/simple;
	bh=c4HYzQN0vXYjWHgpJTlJgGV9/4D6aRi70EbJEvmAYGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTe78ToI+TPIZINoD1s0XiTKNK4MzquBTZ31pVpJwgXmoPhVssblK0b+HWNX4rbHcCy33ngZRtmjaHJ0DvPKLZPK4xHSaX1TNqiJzMUqBd+mHVWjeg1a7Ift/a66nCYD4QY+uvVBwMMkPPWcBsYUMagYNlKXdJnmYyFqxCOqt80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cibbdFCA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772851235; x=1804387235;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c4HYzQN0vXYjWHgpJTlJgGV9/4D6aRi70EbJEvmAYGw=;
  b=cibbdFCAKxh/ppMbXretMtzlhFF2W//x0k8W4+I7GZhg1SlT/f3d+6ev
   NUF/FI+T24FzceB2RY5euP+fZoOu8BIa0P5vwXeh+BJlzSKspMJXjn6Kl
   32mtUrVOuHhtmaiyxvFAQC4AOeLyQkqPj8Mgj2IKPNMaBH6EkUfUeUmoU
   YkGVbRXNochHk8XJ2C3mk7EROJ8vNRgoQsrcQ+njmDrv/W7JVdWSDqwQ8
   WQ7itDqHmTUQNI8Bswt0RB4GWpn9vFyKeCk0PwW/AnImUDeiU+6fLqvO2
   iHzqSkBpHNBHNjgHYS3JpaGTLkaiNsYAKObXdy73UhKdyssdhaJan/eAN
   Q==;
X-CSE-ConnectionGUID: vdMduCHHTaKNvGBcvGgBQQ==
X-CSE-MsgGUID: IKsedVizSeybSaQKE8IsiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84597598"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="84597598"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 18:40:35 -0800
X-CSE-ConnectionGUID: P49Gc/fIRhOduYL+i83w+A==
X-CSE-MsgGUID: 9R+cPpZeTGuRq94Bj/HJaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="215810667"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Mar 2026 18:40:31 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyhae-000000001cD-0Wkz;
	Sat, 07 Mar 2026 02:40:28 +0000
Date: Sat, 7 Mar 2026 10:39:46 +0800
From: kernel test robot <lkp@intel.com>
To: Sairaj Kodilkar <sarunkod@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, suravee.suthikulpanit@amd.com,
	vasant.hegde@amd.com, nikunj.dadhania@amd.com,
	Manali.Shukla@amd.com, Sairaj Kodilkar <sarunkod@amd.com>
Subject: Re: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
Message-ID: <202603071055.Wi43mREW-lkp@intel.com>
References: <20260306102047.29760-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306102047.29760-1-sarunkod@amd.com>
X-Rspamd-Queue-Id: 9256A229A78
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73219-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.963];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid,01.org:url]
X-Rspamd-Action: no action

Hi Sairaj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next tip/master linus/master v7.0-rc2 next-20260306]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sairaj-Kodilkar/KVM-x86-Add-support-for-cmpxchg16b-emulation/20260306-182915
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260306102047.29760-1-sarunkod%40amd.com
patch subject: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
config: i386-randconfig-005-20260307 (https://download.01.org/0day-ci/archive/20260307/202603071055.Wi43mREW-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603071055.Wi43mREW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603071055.Wi43mREW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/emulate.c:24:
   arch/x86/kvm/kvm_emulate.h:271:17: error: unknown type name '__uint128_t'
     271 |                 __uint128_t val128;
         |                 ^~~~~~~~~~~
   arch/x86/kvm/emulate.c: In function '__handle_cmpxchg16b':
   arch/x86/kvm/emulate.c:2215:9: error: unknown type name '__uint128_t'; did you mean '__int128__'?
    2215 |         __uint128_t old128 = ctxt->dst.val128;
         |         ^~~~~~~~~~~
         |         __int128__
>> arch/x86/kvm/emulate.c:2222:28: warning: right shift count >= width of type [-Wshift-count-overflow]
    2222 |             ((u64) (old128 >> 64) != (u64) reg_read(ctxt, VCPU_REGS_RDX))) {
         |                            ^~
   arch/x86/kvm/emulate.c:2224:65: warning: right shift count >= width of type [-Wshift-count-overflow]
    2224 |                 *reg_write(ctxt, VCPU_REGS_RDX) = (u64) (old128 >> 64);
         |                                                                 ^~
   arch/x86/kvm/emulate.c:2228:27: error: '__uint128_t' undeclared (first use in this function); did you mean '__int128__'?
    2228 |                         ((__uint128_t) reg_read(ctxt, VCPU_REGS_RCX) << 64) |
         |                           ^~~~~~~~~~~
         |                           __int128__
   arch/x86/kvm/emulate.c:2228:27: note: each undeclared identifier is reported only once for each function it appears in
   arch/x86/kvm/emulate.c:2228:39: error: expected ')' before 'reg_read'
    2228 |                         ((__uint128_t) reg_read(ctxt, VCPU_REGS_RCX) << 64) |
         |                         ~             ^~~~~~~~~
         |                                       )


vim +2222 arch/x86/kvm/emulate.c

  2212	
  2213	static int __handle_cmpxchg16b(struct x86_emulate_ctxt *ctxt)
  2214	{
  2215		__uint128_t old128 = ctxt->dst.val128;
  2216	
  2217		/* Use of the REX.W prefix promotes operation to 128 bits */
  2218		if (!(ctxt->rex_bits & REX_W))
  2219			return X86EMUL_UNHANDLEABLE;
  2220	
  2221		if (((u64) (old128 >> 0) != (u64) reg_read(ctxt, VCPU_REGS_RAX)) ||
> 2222		    ((u64) (old128 >> 64) != (u64) reg_read(ctxt, VCPU_REGS_RDX))) {
  2223			*reg_write(ctxt, VCPU_REGS_RAX) = (u64) (old128 >> 0);
  2224			*reg_write(ctxt, VCPU_REGS_RDX) = (u64) (old128 >> 64);
  2225			ctxt->eflags &= ~X86_EFLAGS_ZF;
  2226		} else {
  2227			ctxt->dst.val128 =
  2228				((__uint128_t) reg_read(ctxt, VCPU_REGS_RCX) << 64) |
  2229				(u64) reg_read(ctxt, VCPU_REGS_RBX);
  2230	
  2231			ctxt->eflags |= X86_EFLAGS_ZF;
  2232		}
  2233		return X86EMUL_CONTINUE;
  2234	}
  2235	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

