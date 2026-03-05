Return-Path: <kvm+bounces-72776-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BzkGWrhqGnzyAAAu9opvQ
	(envelope-from <kvm+bounces-72776-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:50:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD3D20A013
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03B813021E49
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AC81E0E14;
	Thu,  5 Mar 2026 01:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwgsrYrY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA91643B
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772675426; cv=none; b=l82aZWpryAWvcp4nEppkUW6YLj0FM3EKHnlVbl8Cjw7Uk/Q47Bqy3Nj9Dk33TUUEEAhRjXjdhEzr2A94AQ0TLt8awj35qDJfyCftsQKc1SD/se1fgM6e+J6fbqN9fALhrSe0lpTHxtqfYluk2TYneDcfBBD24zFKdvv7ocnI2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772675426; c=relaxed/simple;
	bh=6XenjEFbgCsNbNahIN0nRsl0RREHKOxIJncSB/bYAxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGRM/eimwVhAMJ4tORCX5qZMaAH+RsMcHFvuCroF/UHbpsCLF5oU6Ff/9icbE7ORXScIiQ7vjPs7aEhgR4h8QOvSZ3NuZFDsl05krnHc2lFqBBXLZgIyLiEv/gNjj2i/aNUh2F1Kcqweg8MN5nEdAEYH1wy+cvd1bKFoiiA+mPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jwgsrYrY; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772675424; x=1804211424;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6XenjEFbgCsNbNahIN0nRsl0RREHKOxIJncSB/bYAxY=;
  b=jwgsrYrYj1FjG6wByafw3SVAzs/uUDNdpjxOMpxCzqFxk4+VIL5TPOpL
   fLkP1bV2IMqgYsx/Y7Jk1oG5T8wAucn96o7c7REbVq1wJVD0ZsDvKVJ9f
   lLoZVsjTNQhRr3TTdNCOrZqlwyQ/twdXCHkKW4r1jRnig1Kao2BO1l5Yr
   hCYK2Pd6T4OYvmosjLtsrExH7yI0KoD1/ihbnbyAbokvq3/XD678jwTJk
   0tKXccAvyfabiEmrY0YwfWxtONc53veUmdn9zyhyac/h9oecVcogD2n8j
   QmK7HR0STGHQ1SUQYefR4dSoRLD3Zl7tG5oQXYNqRtyfl9wUWsCr5S+E1
   g==;
X-CSE-ConnectionGUID: XDyRYKDBQ62EsMQsGo1WpQ==
X-CSE-MsgGUID: Th8AT1wBRGGzouJCUitvHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73665459"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="73665459"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:50:18 -0800
X-CSE-ConnectionGUID: gz0vQlFtQh6SUHmpLGvffw==
X-CSE-MsgGUID: awafH/+BQKKQXvHD8LnX8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="223487856"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 04 Mar 2026 17:50:03 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxxqh-000000004yn-1aHW;
	Thu, 05 Mar 2026 01:49:59 +0000
Date: Thu, 5 Mar 2026 09:49:53 +0800
From: kernel test robot <lkp@intel.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>,
	"seanjc@google.com" <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	John Levon <john.levon@nutanix.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Thanos Makatos <thanos.makatos@nutanix.com>
Subject: Re: [PATCH] KVM: optionally post write on ioeventfd write
Message-ID: <202603050920.Lmf80GaE-lkp@intel.com>
References: <20260302122826.2572-1-thanos.makatos@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302122826.2572-1-thanos.makatos@nutanix.com>
X-Rspamd-Queue-Id: BCD3D20A013
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72776-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,git-scm.com:url,intel.com:dkim,intel.com:email,intel.com:mid,01.org:url]
X-Rspamd-Action: no action

Hi Thanos,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v7.0-rc2 next-20260304]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thanos-Makatos/KVM-optionally-post-write-on-ioeventfd-write/20260302-204031
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260302122826.2572-1-thanos.makatos%40nutanix.com
patch subject: [PATCH] KVM: optionally post write on ioeventfd write
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20260305/202603050920.Lmf80GaE-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603050920.Lmf80GaE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603050920.Lmf80GaE-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kvm_host.h:40,
                    from arch/x86/events/intel/core.c:17:
>> include/uapi/linux/kvm.h:669:1: error: static assertion failed: "bad size"
     669 | _Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
         | ^~~~~~~~~~~~~~


vim +669 include/uapi/linux/kvm.h

   659	
   660	struct kvm_ioeventfd {
   661		__u64 datamatch;
   662		__u64 addr;        /* legal pio/mmio address */
   663		__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
   664		__s32 fd;
   665		__u32 flags;
   666		void __user *post_addr; /* address to write to if POST_WRITE is set */
   667		__u8  pad[24];
   668	};
 > 669	_Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
   670	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

