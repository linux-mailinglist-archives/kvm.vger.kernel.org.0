Return-Path: <kvm+bounces-65953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDEDCBC41B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 03:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73835300DA6D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 02:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89511315D3B;
	Mon, 15 Dec 2025 02:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WtYEHLeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4929B314A77;
	Mon, 15 Dec 2025 02:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765765815; cv=none; b=bqnr5KbSS2lVWvcDvbnr8wKF40Y5BA3ok3uDp1JkiBKDA4FqUavQkDX49sZAv7+MTh+aqoz6sChhKyOYcR0tYNZBxb0qJ7wsD4uDoxBpYEuoLIe0CPWvQjCa4MnAEJbkFZyetGpTG+hP/sS6sYFumubZA04nxaPbz1tzUe7818s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765765815; c=relaxed/simple;
	bh=a/CCxhq3Xgkr3G3px6ZQDNvxIrCYv8DahE0lYrnzGUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UeLsnqjAr536T46y/4A4jyiHD4ky65/b5VzHcpGzSdIBay0+wZ4NAnaVtjtJP5NsHBxcgMGaBaHoYYtprsC8uUOAiUIXNlNnER4zXZCc5NIlHhqC3HvNmM+UeQO5L1c7o+WTdXFIxI1udZQ7ZKCSRZopyelQks7EtLmu/YwGypE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WtYEHLeJ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765765813; x=1797301813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a/CCxhq3Xgkr3G3px6ZQDNvxIrCYv8DahE0lYrnzGUI=;
  b=WtYEHLeJCxvYBKyWsUoIZ5enws0sPWxyGPbZ5S2+y/CrZvQM18vA6r71
   1H/TTNF7iBRr039k3BLW4ouxz4uxHqrGXJM98Dn+/OFNkhefGSjAZkOw/
   USI5NSR1kEr0HRVn86yfO8El5RwCP8RHFxET9HtMNvoA5epdYweibd8VY
   U5+qtxWMIl8nwyWyIMJ11Pkii+BE/TXs7EaLu+AHFUgtuWo5WcE26tcLG
   sw436Z/JZ+evBFZWlLySig/ffIkR0kflbrWllNKrXZFh744hyFTiZ3FfQ
   ykZRPO/JgMGXu2LfaF8OZaoAsQH+vcFdyFKYchTqQzL0du7O9uUOGmPDi
   Q==;
X-CSE-ConnectionGUID: H7KfnU+ySRqJIa2bfzp0rg==
X-CSE-MsgGUID: +6uBZDKIRSKA7DIWl/wMmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="71292755"
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="71292755"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 18:30:12 -0800
X-CSE-ConnectionGUID: OFNhsBfFS8qZj9RgaUi8Xg==
X-CSE-MsgGUID: ITL3jXxaQ0K8etdXMhNqvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="197888515"
Received: from unknown (HELO [10.238.0.255]) ([10.238.0.255])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 18:30:10 -0800
Message-ID: <2df1a0c0-31a6-45c9-a92e-abdbfddbd9b6@intel.com>
Date: Mon, 15 Dec 2025 10:30:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
To: Sean Christopherson <seanjc@google.com>, kernel test robot <lkp@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, oe-kbuild-all@lists.linux.dev,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, farrah.chen@intel.com
References: <20251212135051.2155280-1-xiaoyao.li@intel.com>
 <202512130717.aHH8rXSC-lkp@intel.com> <aTy7AG2y1OwIXfqs@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aTy7AG2y1OwIXfqs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/2025 9:01 AM, Sean Christopherson wrote:
> On Sat, Dec 13, 2025, kernel test robot wrote:
>> Hi Xiaoyao,
>>
>> kernel test robot noticed the following build warnings:
>>
>> [auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoyao-Li/KVM-x86-Don-t-read-guest-CR3-when-doing-async-pf-while-the-MMU-is-direct/20251212-220612
>> base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
>> patch link:    https://lore.kernel.org/r/20251212135051.2155280-1-xiaoyao.li%40intel.com
>> patch subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
>> config: i386-buildonly-randconfig-002-20251213 (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/config)
>> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202512130717.aHH8rXSC-lkp@intel.com/
>>
>> All warnings (new ones prefixed by >>):
>>
>>     In file included from include/linux/kvm_host.h:43,
>>                      from arch/x86/kvm/irq.h:15,
>>                      from arch/x86/kvm/mmu/mmu.c:19:
>>     arch/x86/kvm/mmu/mmu.c: In function 'kvm_arch_setup_async_pf':
>>>> include/linux/kvm_types.h:54:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '18446744073709551615' to '4294967295' [-Woverflow]
>>        54 | #define INVALID_GPA     (~(gpa_t)0)
>>           |                         ^
>>     arch/x86/kvm/mmu/mmu.c:4525:28: note: in expansion of macro 'INVALID_GPA'
>>      4525 |                 arch.cr3 = INVALID_GPA;
>>           |                            ^~~~~~~~~~~
> 
> Well that's just annoying.  Can we kill 32-bit yet?  Anyways, just ignore this
> (unless it causes my KVM_WERROR=1 builds to fail, in which case I'll just add an
> explicit cast, but I think we can just ignore it).

If your KVM_WERROR=1 builds contain 32-bit config, I think it will fail. 
I think we do need to add the explicit cast.

You will handle it when applying, right? Thus no need for a v3.

