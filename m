Return-Path: <kvm+bounces-69539-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UB8NM8JEe2l+DAIAu9opvQ
	(envelope-from <kvm+bounces-69539-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:30:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC05AFA09
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 747723003BE7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED4538757A;
	Thu, 29 Jan 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cztTyR8w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D46933D4F4
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686204; cv=none; b=aYHr+7zZ/1uyY/5VtFTlYk3oU8/NWdWCZK641znEKewJJnNEHxEnQonv1IJHU53cHFsgwm0cV9o476EzVIv62pNT3y+BLE7GYEEIk0p3ePRrCUFygX1quHjYKnCU7Jx9oPsMXYMzh2TQwbmO4mXol9EnljNxFuyz/gevCKA4BU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686204; c=relaxed/simple;
	bh=UB4juRatoxAjJ3voumXxgnDhy7jKWgsXK0C2/0Q1LLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuzX47gxVrmHV2fI9BZ/WbMJ8mjfGrAx6G9CDb0tKifjSKgWe5ipRZ2u23iavNgs96m+sYI49LDs0RF3pmUl+RFWFXFAJ8gKSBJ8KRcLTRlAghjuyyxMplkxGAc9FDOoGnQb1YTRp1mMUV3r5T9HQWyru492qJcsh+PjM3L0+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cztTyR8w; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769686201; x=1801222201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UB4juRatoxAjJ3voumXxgnDhy7jKWgsXK0C2/0Q1LLs=;
  b=cztTyR8wVfTcfO+ZrBtfBdIjhutvvVV8SE8ncfjn0t+Cb2PICLJzwWdc
   iSM5hqZTZtIAycQ7OQnegR5DpPoA28lv/z26AThnDVkb0/D2tv8wZl6h3
   xVJTESF8yF0qmAWr7uuACrDNqrec4EV3pPViKu2UXXq9PSVlP9mE9Z0P5
   DuGgE2Fntv8mcaXBRy/R7VIn2hlnDCq1XMGrcWLdYjlLZHeYmnM65Cz0D
   9hCTz4s1/TJTmPQvcDbkoS0fTvkG0zy6fk/xV9CKyEU32T9OirLOYTe3v
   meOjgD8Xbt1aBQaU3DWElj0vX0n/XlPu3N8HfhwLQePoO+nkDvqaKvhPL
   Q==;
X-CSE-ConnectionGUID: UZtMJdoPRyyUXrYcfVG32Q==
X-CSE-MsgGUID: fIOK5njxT1KrVMHkO0BfLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="58505805"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="58505805"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 03:29:59 -0800
X-CSE-ConnectionGUID: gqT750vBQPmTIOB1ggzl9A==
X-CSE-MsgGUID: l72yiMe7TB2WVPr+qRi90w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="213050661"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 29 Jan 2026 03:29:56 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vlQDi-000000002Hd-1NJf;
	Thu, 29 Jan 2026 11:29:54 +0000
Date: Thu, 29 Jan 2026 12:29:21 +0100
From: kernel test robot <lkp@intel.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v4 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Message-ID: <202601291246.oaOq5gRj-lkp@intel.com>
References: <20260128175919.3828384-36-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128175919.3828384-36-sascha.bischoff@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69539-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,01.org:url,intel.com:email,intel.com:dkim,intel.com:mid,git-scm.com:url]
X-Rspamd-Queue-Id: 0FC05AFA09
X-Rspamd-Action: no action

Hi Sascha,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on kvm/queue kvm/next]
[cannot apply to kvmarm/next linus/master kvm/linux-next v6.16-rc1 next-20260128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sascha-Bischoff/KVM-arm64-Account-for-RES1-bits-in-DECLARE_FEAT_MAP-and-co/20260129-022450
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20260128175919.3828384-36-sascha.bischoff%40arm.com
patch subject: [PATCH v4 35/36] KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260129/202601291246.oaOq5gRj-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260129/202601291246.oaOq5gRj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601291246.oaOq5gRj-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arm64/vgic_v5.c:171:11: warning: unused variable 'other' [-Wunused-variable]
     171 |         uint32_t other;
         |                  ^~~~~
   1 warning generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

