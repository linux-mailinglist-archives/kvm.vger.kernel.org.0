Return-Path: <kvm+bounces-70285-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +J+VGPvzg2n6wAMAu9opvQ
	(envelope-from <kvm+bounces-70285-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:35:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D7DEDAF1
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27979300F9C9
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B27296BBB;
	Thu,  5 Feb 2026 01:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGyDLVV9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE52147E5;
	Thu,  5 Feb 2026 01:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255346; cv=none; b=WXWDVJaQ4sSkUT4Yz42x5+K4R/VBQ46vVaTPtpaWiSWKekSuK6m55plF+9MpVNdzu/LARd34n+9FgfIfpMsQ5JEwzo3b53HVn4m4HG76Idb/IVYdhmDRQostup7+kLFxIzBQY2gna0mQJTKnH2NHBruPVBps2njSnGGd+u1JNAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255346; c=relaxed/simple;
	bh=7y69/7oVm8fcZvGstxxXkgTMSUDexLLNTbsHiC0HFLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpwryd73MU66NFiP96gde8pHrOxydq7Hi2dia65ZSqtmus3+Gl6cP0JXVYDfQ7lRedrvv81GcfPX01rGTe0Ldt1HKi0gtI/a0fNERtQjGnGZA6GbzzRZkE800VweyXTvjagLM2kZVSsEGGTvUOfMH3UvZgex1fp9MNcTk12VPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGyDLVV9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770255346; x=1801791346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7y69/7oVm8fcZvGstxxXkgTMSUDexLLNTbsHiC0HFLs=;
  b=LGyDLVV9oZ1FZWcjdtjOWKajIfSKkisH8HPUuPANs39K0O6KgzKsXilW
   TSrHb/yvZMuTmIzSQ4I1ofksKNjxB1W7JhaTMN47LeWnhcak9IXQCuRrQ
   GVpNZ7HRR/BwR09pC+nn/MTpHnFLS2G6TjG63nCth9r29uW0Nve+BMeOl
   TjZ74Bemgd4VoOjIRE65TTxGjLMg5fJP3JaRZTtxz1b3zmpPU3EplJSz3
   x9CIeof4eVTOSHGhJiKHMEPcwmQM838vUG9uHG1Auw0UR4wyDId5HcrLf
   CARRglc68Sh+tQizzyLOUJm4xJg0h7gVFTuFyonxHTq04G3ongysvb1aY
   g==;
X-CSE-ConnectionGUID: 9oqa5/hlRV+5vmN2wEVd2A==
X-CSE-MsgGUID: /0QJoxwZRVyVgsYXJg5uyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82081517"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="82081517"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 17:35:45 -0800
X-CSE-ConnectionGUID: l/EYLV0+Rs+fGZGcjWMvzw==
X-CSE-MsgGUID: 88yOA7UYQ5aagbOc9Gej2Q==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 04 Feb 2026 17:35:42 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnoHU-00000000jIa-2Xnb;
	Thu, 05 Feb 2026 01:35:40 +0000
Date: Thu, 5 Feb 2026 09:35:00 +0800
From: kernel test robot <lkp@intel.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/32] KVM: nVMX: Enable guest deadline and its shadow
 VMCS field
Message-ID: <202602050942.H2SZSmRE-lkp@intel.com>
References: <dbb1e23b41e503692b3f825ebb80e0ccc6870684.1770116051.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbb1e23b41e503692b3f825ebb80e0ccc6870684.1770116051.git.isaku.yamahata@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70285-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B3D7DEDAF1
X-Rspamd-Action: no action

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/isaku-yamahata-intel-com/KVM-VMX-Detect-APIC-timer-virtualization-bit/20260204-023229
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/dbb1e23b41e503692b3f825ebb80e0ccc6870684.1770116051.git.isaku.yamahata%40intel.com
patch subject: [PATCH 15/32] KVM: nVMX: Enable guest deadline and its shadow VMCS field
config: i386-randconfig-r112-20260204 (https://download.01.org/0day-ci/archive/20260205/202602050942.H2SZSmRE-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602050942.H2SZSmRE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602050942.H2SZSmRE-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/vmx/vmcs12.c:17:9: sparse: sparse: cast truncates bits from constant value (20002 becomes 2)
   arch/x86/kvm/vmx/vmcs12.c:18:9: sparse: sparse: cast truncates bits from constant value (20082 becomes 82)
   arch/x86/kvm/vmx/vmcs12.c:19:9: sparse: sparse: cast truncates bits from constant value (20102 becomes 102)
   arch/x86/kvm/vmx/vmcs12.c:20:9: sparse: sparse: cast truncates bits from constant value (20182 becomes 182)
   arch/x86/kvm/vmx/vmcs12.c:21:9: sparse: sparse: cast truncates bits from constant value (20202 becomes 202)
   arch/x86/kvm/vmx/vmcs12.c:22:9: sparse: sparse: cast truncates bits from constant value (20282 becomes 282)
   arch/x86/kvm/vmx/vmcs12.c:23:9: sparse: sparse: cast truncates bits from constant value (20302 becomes 302)
   arch/x86/kvm/vmx/vmcs12.c:24:9: sparse: sparse: cast truncates bits from constant value (20382 becomes 382)
   arch/x86/kvm/vmx/vmcs12.c:25:9: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/vmcs12.c:26:9: sparse: sparse: cast truncates bits from constant value (20482 becomes 482)
   arch/x86/kvm/vmx/vmcs12.c:28:9: sparse: sparse: cast truncates bits from constant value (30003 becomes 3)
   arch/x86/kvm/vmx/vmcs12.c:29:9: sparse: sparse: cast truncates bits from constant value (30083 becomes 83)
   arch/x86/kvm/vmx/vmcs12.c:30:9: sparse: sparse: cast truncates bits from constant value (30103 becomes 103)
   arch/x86/kvm/vmx/vmcs12.c:31:9: sparse: sparse: cast truncates bits from constant value (30183 becomes 183)
   arch/x86/kvm/vmx/vmcs12.c:32:9: sparse: sparse: cast truncates bits from constant value (30203 becomes 203)
   arch/x86/kvm/vmx/vmcs12.c:33:9: sparse: sparse: cast truncates bits from constant value (30283 becomes 283)
   arch/x86/kvm/vmx/vmcs12.c:34:9: sparse: sparse: cast truncates bits from constant value (30303 becomes 303)
   arch/x86/kvm/vmx/vmcs12.c:35:9: sparse: sparse: cast truncates bits from constant value (80008 becomes 8)
   arch/x86/kvm/vmx/vmcs12.c:35:9: sparse: sparse: cast truncates bits from constant value (80048 becomes 48)
   arch/x86/kvm/vmx/vmcs12.c:36:9: sparse: sparse: cast truncates bits from constant value (80088 becomes 88)
   arch/x86/kvm/vmx/vmcs12.c:36:9: sparse: sparse: cast truncates bits from constant value (800c8 becomes c8)
   arch/x86/kvm/vmx/vmcs12.c:37:9: sparse: sparse: cast truncates bits from constant value (80108 becomes 108)
   arch/x86/kvm/vmx/vmcs12.c:37:9: sparse: sparse: cast truncates bits from constant value (80148 becomes 148)
   arch/x86/kvm/vmx/vmcs12.c:38:9: sparse: sparse: cast truncates bits from constant value (80188 becomes 188)
   arch/x86/kvm/vmx/vmcs12.c:38:9: sparse: sparse: cast truncates bits from constant value (801c8 becomes 1c8)
   arch/x86/kvm/vmx/vmcs12.c:39:9: sparse: sparse: cast truncates bits from constant value (80208 becomes 208)
   arch/x86/kvm/vmx/vmcs12.c:39:9: sparse: sparse: cast truncates bits from constant value (80248 becomes 248)
   arch/x86/kvm/vmx/vmcs12.c:40:9: sparse: sparse: cast truncates bits from constant value (80288 becomes 288)
   arch/x86/kvm/vmx/vmcs12.c:40:9: sparse: sparse: cast truncates bits from constant value (802c8 becomes 2c8)
   arch/x86/kvm/vmx/vmcs12.c:41:9: sparse: sparse: cast truncates bits from constant value (80388 becomes 388)
   arch/x86/kvm/vmx/vmcs12.c:41:9: sparse: sparse: cast truncates bits from constant value (803c8 becomes 3c8)
   arch/x86/kvm/vmx/vmcs12.c:42:9: sparse: sparse: cast truncates bits from constant value (80408 becomes 408)
   arch/x86/kvm/vmx/vmcs12.c:42:9: sparse: sparse: cast truncates bits from constant value (80448 becomes 448)
   arch/x86/kvm/vmx/vmcs12.c:43:9: sparse: sparse: cast truncates bits from constant value (80c88 becomes c88)
   arch/x86/kvm/vmx/vmcs12.c:43:9: sparse: sparse: cast truncates bits from constant value (80cc8 becomes cc8)
   arch/x86/kvm/vmx/vmcs12.c:44:9: sparse: sparse: cast truncates bits from constant value (80d08 becomes d08)
   arch/x86/kvm/vmx/vmcs12.c:44:9: sparse: sparse: cast truncates bits from constant value (80d48 becomes d48)
   arch/x86/kvm/vmx/vmcs12.c:45:9: sparse: sparse: cast truncates bits from constant value (80488 becomes 488)
   arch/x86/kvm/vmx/vmcs12.c:45:9: sparse: sparse: cast truncates bits from constant value (804c8 becomes 4c8)
   arch/x86/kvm/vmx/vmcs12.c:46:9: sparse: sparse: cast truncates bits from constant value (80508 becomes 508)
   arch/x86/kvm/vmx/vmcs12.c:46:9: sparse: sparse: cast truncates bits from constant value (80548 becomes 548)
   arch/x86/kvm/vmx/vmcs12.c:47:9: sparse: sparse: cast truncates bits from constant value (80588 becomes 588)
   arch/x86/kvm/vmx/vmcs12.c:47:9: sparse: sparse: cast truncates bits from constant value (805c8 becomes 5c8)
   arch/x86/kvm/vmx/vmcs12.c:48:9: sparse: sparse: cast truncates bits from constant value (80608 becomes 608)
   arch/x86/kvm/vmx/vmcs12.c:48:9: sparse: sparse: cast truncates bits from constant value (80648 becomes 648)
   arch/x86/kvm/vmx/vmcs12.c:49:9: sparse: sparse: cast truncates bits from constant value (80688 becomes 688)
   arch/x86/kvm/vmx/vmcs12.c:49:9: sparse: sparse: cast truncates bits from constant value (806c8 becomes 6c8)
   arch/x86/kvm/vmx/vmcs12.c:50:9: sparse: sparse: cast truncates bits from constant value (80708 becomes 708)
   arch/x86/kvm/vmx/vmcs12.c:50:9: sparse: sparse: cast truncates bits from constant value (80748 becomes 748)
   arch/x86/kvm/vmx/vmcs12.c:51:9: sparse: sparse: cast truncates bits from constant value (80788 becomes 788)
   arch/x86/kvm/vmx/vmcs12.c:51:9: sparse: sparse: cast truncates bits from constant value (807c8 becomes 7c8)
   arch/x86/kvm/vmx/vmcs12.c:52:9: sparse: sparse: cast truncates bits from constant value (80808 becomes 808)
   arch/x86/kvm/vmx/vmcs12.c:52:9: sparse: sparse: cast truncates bits from constant value (80848 becomes 848)
   arch/x86/kvm/vmx/vmcs12.c:53:9: sparse: sparse: cast truncates bits from constant value (80888 becomes 888)
   arch/x86/kvm/vmx/vmcs12.c:53:9: sparse: sparse: cast truncates bits from constant value (808c8 becomes 8c8)
   arch/x86/kvm/vmx/vmcs12.c:54:9: sparse: sparse: cast truncates bits from constant value (80908 becomes 908)
   arch/x86/kvm/vmx/vmcs12.c:54:9: sparse: sparse: cast truncates bits from constant value (80948 becomes 948)
   arch/x86/kvm/vmx/vmcs12.c:55:9: sparse: sparse: cast truncates bits from constant value (80988 becomes 988)
   arch/x86/kvm/vmx/vmcs12.c:55:9: sparse: sparse: cast truncates bits from constant value (809c8 becomes 9c8)
   arch/x86/kvm/vmx/vmcs12.c:56:9: sparse: sparse: cast truncates bits from constant value (80a08 becomes a08)
   arch/x86/kvm/vmx/vmcs12.c:56:9: sparse: sparse: cast truncates bits from constant value (80a48 becomes a48)
   arch/x86/kvm/vmx/vmcs12.c:57:9: sparse: sparse: cast truncates bits from constant value (80b08 becomes b08)
   arch/x86/kvm/vmx/vmcs12.c:57:9: sparse: sparse: cast truncates bits from constant value (80b48 becomes b48)
   arch/x86/kvm/vmx/vmcs12.c:58:9: sparse: sparse: cast truncates bits from constant value (80b88 becomes b88)
   arch/x86/kvm/vmx/vmcs12.c:58:9: sparse: sparse: cast truncates bits from constant value (80bc8 becomes bc8)
   arch/x86/kvm/vmx/vmcs12.c:59:9: sparse: sparse: cast truncates bits from constant value (90009 becomes 9)
   arch/x86/kvm/vmx/vmcs12.c:59:9: sparse: sparse: cast truncates bits from constant value (90049 becomes 49)
   arch/x86/kvm/vmx/vmcs12.c:60:9: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/vmcs12.c:60:9: sparse: sparse: cast truncates bits from constant value (a004a becomes 4a)
   arch/x86/kvm/vmx/vmcs12.c:61:9: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/vmcs12.c:61:9: sparse: sparse: cast truncates bits from constant value (a00ca becomes ca)
   arch/x86/kvm/vmx/vmcs12.c:62:9: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/vmcs12.c:62:9: sparse: sparse: cast truncates bits from constant value (a014a becomes 14a)
   arch/x86/kvm/vmx/vmcs12.c:63:9: sparse: sparse: cast truncates bits from constant value (a018a becomes 18a)
   arch/x86/kvm/vmx/vmcs12.c:63:9: sparse: sparse: cast truncates bits from constant value (a01ca becomes 1ca)
   arch/x86/kvm/vmx/vmcs12.c:64:9: sparse: sparse: cast truncates bits from constant value (a020a becomes 20a)
   arch/x86/kvm/vmx/vmcs12.c:64:9: sparse: sparse: cast truncates bits from constant value (a024a becomes 24a)
   arch/x86/kvm/vmx/vmcs12.c:65:9: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/vmcs12.c:65:9: sparse: sparse: cast truncates bits from constant value (a02ca becomes 2ca)
   arch/x86/kvm/vmx/vmcs12.c:66:9: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/vmcs12.c:66:9: sparse: sparse: cast truncates bits from constant value (a034a becomes 34a)
   arch/x86/kvm/vmx/vmcs12.c:67:9: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/vmcs12.c:67:9: sparse: sparse: cast truncates bits from constant value (a03ca becomes 3ca)
   arch/x86/kvm/vmx/vmcs12.c:68:9: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/vmcs12.c:68:9: sparse: sparse: cast truncates bits from constant value (a044a becomes 44a)
   arch/x86/kvm/vmx/vmcs12.c:69:9: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/vmcs12.c:69:9: sparse: sparse: cast truncates bits from constant value (a04ca becomes 4ca)
   arch/x86/kvm/vmx/vmcs12.c:70:9: sparse: sparse: cast truncates bits from constant value (b000b becomes b)
   arch/x86/kvm/vmx/vmcs12.c:70:9: sparse: sparse: cast truncates bits from constant value (b004b becomes 4b)
   arch/x86/kvm/vmx/vmcs12.c:71:9: sparse: sparse: cast truncates bits from constant value (b008b becomes 8b)
   arch/x86/kvm/vmx/vmcs12.c:71:9: sparse: sparse: cast truncates bits from constant value (b00cb becomes cb)
   arch/x86/kvm/vmx/vmcs12.c:72:9: sparse: sparse: cast truncates bits from constant value (b010b becomes 10b)
   arch/x86/kvm/vmx/vmcs12.c:72:9: sparse: sparse: cast truncates bits from constant value (b014b becomes 14b)
>> arch/x86/kvm/vmx/vmcs12.c:73:9: sparse: sparse: cast truncates bits from constant value (a0c0a becomes c0a)
>> arch/x86/kvm/vmx/vmcs12.c:73:9: sparse: sparse: cast truncates bits from constant value (a0c4a becomes c4a)
   arch/x86/kvm/vmx/vmcs12.c:74:9: sparse: sparse: cast truncates bits from constant value (81388 becomes 1388)
>> arch/x86/kvm/vmx/vmcs12.c:74:9: sparse: sparse: cast truncates bits from constant value (813c8 becomes 13c8)
   arch/x86/kvm/vmx/vmcs12.c:75:9: sparse: sparse: cast truncates bits from constant value (100010 becomes 10)
   arch/x86/kvm/vmx/vmcs12.c:76:9: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/vmcs12.c:77:9: sparse: sparse: cast truncates bits from constant value (100110 becomes 110)
   arch/x86/kvm/vmx/vmcs12.c:78:9: sparse: sparse: cast truncates bits from constant value (100190 becomes 190)
   arch/x86/kvm/vmx/vmcs12.c:79:9: sparse: sparse: cast truncates bits from constant value (100210 becomes 210)
   arch/x86/kvm/vmx/vmcs12.c:80:9: sparse: sparse: cast truncates bits from constant value (100290 becomes 290)
   arch/x86/kvm/vmx/vmcs12.c:81:9: sparse: sparse: cast truncates bits from constant value (100310 becomes 310)
   arch/x86/kvm/vmx/vmcs12.c:82:9: sparse: sparse: cast truncates bits from constant value (100390 becomes 390)
   arch/x86/kvm/vmx/vmcs12.c:83:9: sparse: sparse: cast truncates bits from constant value (100410 becomes 410)
   arch/x86/kvm/vmx/vmcs12.c:84:9: sparse: sparse: cast truncates bits from constant value (100490 becomes 490)
   arch/x86/kvm/vmx/vmcs12.c:85:9: sparse: sparse: cast truncates bits from constant value (100510 becomes 510)
   arch/x86/kvm/vmx/vmcs12.c:86:9: sparse: sparse: cast truncates bits from constant value (100590 becomes 590)
   arch/x86/kvm/vmx/vmcs12.c:87:9: sparse: sparse: cast truncates bits from constant value (100610 becomes 610)
   arch/x86/kvm/vmx/vmcs12.c:88:9: sparse: sparse: cast truncates bits from constant value (100690 becomes 690)
   arch/x86/kvm/vmx/vmcs12.c:89:9: sparse: sparse: cast truncates bits from constant value (100710 becomes 710)
   arch/x86/kvm/vmx/vmcs12.c:90:9: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/vmcs12.c:91:9: sparse: sparse: cast truncates bits from constant value (110011 becomes 11)
   arch/x86/kvm/vmx/vmcs12.c:92:9: sparse: sparse: cast truncates bits from constant value (110091 becomes 91)
   arch/x86/kvm/vmx/vmcs12.c:93:9: sparse: sparse: cast truncates bits from constant value (110111 becomes 111)
   arch/x86/kvm/vmx/vmcs12.c:94:9: sparse: sparse: cast truncates bits from constant value (110191 becomes 191)
   arch/x86/kvm/vmx/vmcs12.c:95:9: sparse: sparse: cast truncates bits from constant value (110211 becomes 211)
   arch/x86/kvm/vmx/vmcs12.c:96:9: sparse: sparse: cast truncates bits from constant value (110291 becomes 291)
   arch/x86/kvm/vmx/vmcs12.c:97:9: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/vmcs12.c:98:9: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/vmcs12.c:99:9: sparse: sparse: cast truncates bits from constant value (120012 becomes 12)
   arch/x86/kvm/vmx/vmcs12.c:100:9: sparse: sparse: cast truncates bits from constant value (120092 becomes 92)
   arch/x86/kvm/vmx/vmcs12.c:101:9: sparse: sparse: cast truncates bits from constant value (120112 becomes 112)
   arch/x86/kvm/vmx/vmcs12.c:102:9: sparse: sparse: cast truncates bits from constant value (120192 becomes 192)
   arch/x86/kvm/vmx/vmcs12.c:103:9: sparse: sparse: cast truncates bits from constant value (120212 becomes 212)
   arch/x86/kvm/vmx/vmcs12.c:104:9: sparse: sparse: cast truncates bits from constant value (120292 becomes 292)
   arch/x86/kvm/vmx/vmcs12.c:105:9: sparse: sparse: cast truncates bits from constant value (120312 becomes 312)
   arch/x86/kvm/vmx/vmcs12.c:106:9: sparse: sparse: cast truncates bits from constant value (120392 becomes 392)
   arch/x86/kvm/vmx/vmcs12.c:107:9: sparse: sparse: cast truncates bits from constant value (120412 becomes 412)
   arch/x86/kvm/vmx/vmcs12.c:108:9: sparse: sparse: cast truncates bits from constant value (120492 becomes 492)
   arch/x86/kvm/vmx/vmcs12.c:109:9: sparse: sparse: cast truncates bits from constant value (120512 becomes 512)
   arch/x86/kvm/vmx/vmcs12.c:110:9: sparse: sparse: cast truncates bits from constant value (120592 becomes 592)
   arch/x86/kvm/vmx/vmcs12.c:111:9: sparse: sparse: cast truncates bits from constant value (120612 becomes 612)
   arch/x86/kvm/vmx/vmcs12.c:112:9: sparse: sparse: cast truncates bits from constant value (120692 becomes 692)
   arch/x86/kvm/vmx/vmcs12.c:113:9: sparse: sparse: cast truncates bits from constant value (120712 becomes 712)
   arch/x86/kvm/vmx/vmcs12.c:114:9: sparse: sparse: cast truncates bits from constant value (120792 becomes 792)
   arch/x86/kvm/vmx/vmcs12.c:115:9: sparse: sparse: cast truncates bits from constant value (120812 becomes 812)
   arch/x86/kvm/vmx/vmcs12.c:116:9: sparse: sparse: cast truncates bits from constant value (120892 becomes 892)
   arch/x86/kvm/vmx/vmcs12.c:117:9: sparse: sparse: cast truncates bits from constant value (120912 becomes 912)
   arch/x86/kvm/vmx/vmcs12.c:118:9: sparse: sparse: cast truncates bits from constant value (120992 becomes 992)
   arch/x86/kvm/vmx/vmcs12.c:119:9: sparse: sparse: cast truncates bits from constant value (120a92 becomes a92)
   arch/x86/kvm/vmx/vmcs12.c:120:9: sparse: sparse: cast truncates bits from constant value (130013 becomes 13)
   arch/x86/kvm/vmx/vmcs12.c:121:9: sparse: sparse: cast truncates bits from constant value (120b92 becomes b92)
   arch/x86/kvm/vmx/vmcs12.c:122:9: sparse: sparse: cast truncates bits from constant value (180018 becomes 18)
   arch/x86/kvm/vmx/vmcs12.c:123:9: sparse: sparse: cast truncates bits from constant value (180098 becomes 98)
   arch/x86/kvm/vmx/vmcs12.c:124:9: sparse: sparse: cast truncates bits from constant value (180118 becomes 118)
   arch/x86/kvm/vmx/vmcs12.c:125:9: sparse: sparse: cast truncates bits from constant value (180198 becomes 198)
   arch/x86/kvm/vmx/vmcs12.c:126:9: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/vmcs12.c:127:9: sparse: sparse: cast truncates bits from constant value (190299 becomes 299)
   arch/x86/kvm/vmx/vmcs12.c:128:9: sparse: sparse: cast truncates bits from constant value (1a001a becomes 1a)
   arch/x86/kvm/vmx/vmcs12.c:129:9: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/vmcs12.c:130:9: sparse: sparse: cast truncates bits from constant value (1a011a becomes 11a)
   arch/x86/kvm/vmx/vmcs12.c:131:9: sparse: sparse: cast truncates bits from constant value (1a019a becomes 19a)
   arch/x86/kvm/vmx/vmcs12.c:132:9: sparse: sparse: cast truncates bits from constant value (1a021a becomes 21a)
   arch/x86/kvm/vmx/vmcs12.c:133:9: sparse: sparse: cast truncates bits from constant value (1a029a becomes 29a)
   arch/x86/kvm/vmx/vmcs12.c:134:9: sparse: sparse: cast truncates bits from constant value (1a031a becomes 31a)
   arch/x86/kvm/vmx/vmcs12.c:135:9: sparse: sparse: cast truncates bits from constant value (1a039a becomes 39a)
   arch/x86/kvm/vmx/vmcs12.c:136:9: sparse: sparse: cast truncates bits from constant value (1a041a becomes 41a)
   arch/x86/kvm/vmx/vmcs12.c:137:9: sparse: sparse: cast truncates bits from constant value (1a049a becomes 49a)
   arch/x86/kvm/vmx/vmcs12.c:138:9: sparse: sparse: cast truncates bits from constant value (1a051a becomes 51a)
   arch/x86/kvm/vmx/vmcs12.c:139:9: sparse: sparse: cast truncates bits from constant value (1a059a becomes 59a)
   arch/x86/kvm/vmx/vmcs12.c:140:9: sparse: sparse: cast truncates bits from constant value (1a061a becomes 61a)
   arch/x86/kvm/vmx/vmcs12.c:141:9: sparse: sparse: cast truncates bits from constant value (1a069a becomes 69a)
   arch/x86/kvm/vmx/vmcs12.c:142:9: sparse: sparse: cast truncates bits from constant value (1a071a becomes 71a)
   arch/x86/kvm/vmx/vmcs12.c:143:9: sparse: sparse: cast truncates bits from constant value (1a079a becomes 79a)
   arch/x86/kvm/vmx/vmcs12.c:144:9: sparse: sparse: cast truncates bits from constant value (1a081a becomes 81a)
   arch/x86/kvm/vmx/vmcs12.c:145:9: sparse: sparse: cast truncates bits from constant value (1a089a becomes 89a)
   arch/x86/kvm/vmx/vmcs12.c:146:9: sparse: sparse: cast truncates bits from constant value (1a091a becomes 91a)
   arch/x86/kvm/vmx/vmcs12.c:147:9: sparse: sparse: cast truncates bits from constant value (1a099a becomes 99a)
   arch/x86/kvm/vmx/vmcs12.c:148:9: sparse: sparse: cast truncates bits from constant value (1a0a1a becomes a1a)
   arch/x86/kvm/vmx/vmcs12.c:149:9: sparse: sparse: cast truncates bits from constant value (1a0a9a becomes a9a)
   arch/x86/kvm/vmx/vmcs12.c:150:9: sparse: sparse: cast truncates bits from constant value (1a0b1a becomes b1a)
   arch/x86/kvm/vmx/vmcs12.c:151:9: sparse: sparse: cast truncates bits from constant value (1b001b becomes 1b)
   arch/x86/kvm/vmx/vmcs12.c:152:9: sparse: sparse: cast truncates bits from constant value (1b009b becomes 9b)
   arch/x86/kvm/vmx/vmcs12.c:153:9: sparse: sparse: cast truncates bits from constant value (1b011b becomes 11b)
   arch/x86/kvm/vmx/vmcs12.c:154:9: sparse: sparse: cast truncates bits from constant value (1b019b becomes 19b)
   arch/x86/kvm/vmx/vmcs12.c:155:9: sparse: sparse: cast truncates bits from constant value (1b021b becomes 21b)
   arch/x86/kvm/vmx/vmcs12.c:156:9: sparse: sparse: cast truncates bits from constant value (1b029b becomes 29b)
   arch/x86/kvm/vmx/vmcs12.c:157:9: sparse: sparse: cast truncates bits from constant value (1b031b becomes 31b)
   arch/x86/kvm/vmx/vmcs12.c:158:9: sparse: sparse: cast truncates bits from constant value (1b039b becomes 39b)
   arch/x86/kvm/vmx/vmcs12.c:159:9: sparse: sparse: cast truncates bits from constant value (1b041b becomes 41b)
   arch/x86/kvm/vmx/vmcs12.c:160:9: sparse: sparse: cast truncates bits from constant value (1b049b becomes 49b)
   arch/x86/kvm/vmx/vmcs12.c:161:9: sparse: sparse: cast truncates bits from constant value (1b051b becomes 51b)
   arch/x86/kvm/vmx/vmcs12.c:162:9: sparse: sparse: cast truncates bits from constant value (1b059b becomes 59b)
   arch/x86/kvm/vmx/vmcs12.c:163:9: sparse: sparse: cast truncates bits from constant value (1b061b becomes 61b)
   arch/x86/kvm/vmx/vmcs12.c:164:9: sparse: sparse: cast truncates bits from constant value (1b069b becomes 69b)
   arch/x86/kvm/vmx/vmcs12.c:165:9: sparse: sparse: cast truncates bits from constant value (1b071b becomes 71b)

vim +73 arch/x86/kvm/vmx/vmcs12.c

     7	
     8	#define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
     9	#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
    10	#define FIELD64(number, name)						\
    11		FIELD(number, name),						\
    12		[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
    13	
    14	const unsigned short vmcs12_field_offsets[] = {
    15		FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
    16		FIELD(POSTED_INTR_NV, posted_intr_nv),
    17		FIELD(GUEST_ES_SELECTOR, guest_es_selector),
    18		FIELD(GUEST_CS_SELECTOR, guest_cs_selector),
    19		FIELD(GUEST_SS_SELECTOR, guest_ss_selector),
    20		FIELD(GUEST_DS_SELECTOR, guest_ds_selector),
    21		FIELD(GUEST_FS_SELECTOR, guest_fs_selector),
    22		FIELD(GUEST_GS_SELECTOR, guest_gs_selector),
    23		FIELD(GUEST_LDTR_SELECTOR, guest_ldtr_selector),
    24		FIELD(GUEST_TR_SELECTOR, guest_tr_selector),
    25		FIELD(GUEST_INTR_STATUS, guest_intr_status),
    26		FIELD(GUEST_PML_INDEX, guest_pml_index),
    27		FIELD(GUEST_APIC_TIMER_VECTOR, virtual_timer_vector),
    28		FIELD(HOST_ES_SELECTOR, host_es_selector),
    29		FIELD(HOST_CS_SELECTOR, host_cs_selector),
    30		FIELD(HOST_SS_SELECTOR, host_ss_selector),
    31		FIELD(HOST_DS_SELECTOR, host_ds_selector),
    32		FIELD(HOST_FS_SELECTOR, host_fs_selector),
    33		FIELD(HOST_GS_SELECTOR, host_gs_selector),
    34		FIELD(HOST_TR_SELECTOR, host_tr_selector),
    35		FIELD64(IO_BITMAP_A, io_bitmap_a),
    36		FIELD64(IO_BITMAP_B, io_bitmap_b),
    37		FIELD64(MSR_BITMAP, msr_bitmap),
    38		FIELD64(VM_EXIT_MSR_STORE_ADDR, vm_exit_msr_store_addr),
    39		FIELD64(VM_EXIT_MSR_LOAD_ADDR, vm_exit_msr_load_addr),
    40		FIELD64(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr),
    41		FIELD64(PML_ADDRESS, pml_address),
    42		FIELD64(TSC_OFFSET, tsc_offset),
    43		FIELD64(TSC_MULTIPLIER, tsc_multiplier),
    44		FIELD64(TERTIARY_VM_EXEC_CONTROL, tertiary_vm_exec_control),
    45		FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
    46		FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
    47		FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
    48		FIELD64(VM_FUNCTION_CONTROL, vm_function_control),
    49		FIELD64(EPT_POINTER, ept_pointer),
    50		FIELD64(EOI_EXIT_BITMAP0, eoi_exit_bitmap0),
    51		FIELD64(EOI_EXIT_BITMAP1, eoi_exit_bitmap1),
    52		FIELD64(EOI_EXIT_BITMAP2, eoi_exit_bitmap2),
    53		FIELD64(EOI_EXIT_BITMAP3, eoi_exit_bitmap3),
    54		FIELD64(EPTP_LIST_ADDRESS, eptp_list_address),
    55		FIELD64(VMREAD_BITMAP, vmread_bitmap),
    56		FIELD64(VMWRITE_BITMAP, vmwrite_bitmap),
    57		FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
    58		FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
    59		FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
    60		FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
    61		FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
    62		FIELD64(GUEST_IA32_PAT, guest_ia32_pat),
    63		FIELD64(GUEST_IA32_EFER, guest_ia32_efer),
    64		FIELD64(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl),
    65		FIELD64(GUEST_PDPTR0, guest_pdptr0),
    66		FIELD64(GUEST_PDPTR1, guest_pdptr1),
    67		FIELD64(GUEST_PDPTR2, guest_pdptr2),
    68		FIELD64(GUEST_PDPTR3, guest_pdptr3),
    69		FIELD64(GUEST_BNDCFGS, guest_bndcfgs),
    70		FIELD64(HOST_IA32_PAT, host_ia32_pat),
    71		FIELD64(HOST_IA32_EFER, host_ia32_efer),
    72		FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
  > 73		FIELD64(GUEST_DEADLINE_PHY, guest_deadline),
  > 74		FIELD64(GUEST_DEADLINE_VIR, guest_deadline_shadow),

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

