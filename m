Return-Path: <kvm+bounces-47835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF895AC5E34
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 02:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FFA94C08E5
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 00:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B41613A3F7;
	Wed, 28 May 2025 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JkIPGz9b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520CB1367;
	Wed, 28 May 2025 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748392138; cv=none; b=ZheBHDnlHTgTad/A1hJWFstt2h4fG9mmpVKfIhvoBrysDukzuRbH70n4P5zyykOhVb50IDZf08uplQSdGHnibktbkN287AwN6DgBgKOhLYE+FrxGB7ZAUnamaveVmiKzTOiwAUWfkIy+b3ippVI5kRDYUsdVc73KbCrFAZlNxpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748392138; c=relaxed/simple;
	bh=2O/eZ+PVqKQBD9BOUwMNiGwOsrD5/Jy7inCLCeOdak4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKde3buE+HyZwmZEaYnFhVnK1dInaE2BdEm86kn+RShMidqWPPI6lQZPgt3fbUN74FE10NLvvKEB6eLNNNQ2860oM+LydeaNf8oGVGs6lHQTUDa2Tv8MsZLupDdNDhLHK5jFJ+GfGnwhtW5tE8UsyyOtu1vHzN0mSEjY8aEPQuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JkIPGz9b; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748392136; x=1779928136;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2O/eZ+PVqKQBD9BOUwMNiGwOsrD5/Jy7inCLCeOdak4=;
  b=JkIPGz9bTPfmcyRiWJiodS/Z1w+yTJQmLN+Whb1HCGn8aK7CBBdUtKY5
   GXg4DOPDeMrOE5Rfe9e7cTb+o+1+MdnYoYfzPZMnB57Y7lhUjQXc7XPCO
   r+Vp1xsw8a2cfn5luWvtgT5ecKfGaQLa9RzVKzIPID17UK3D7dXz3Sg27
   xHIl5+D10Jw+ZEURvb8/sCC8jdUTjSEPauHuEbcADc8deMqWMJT9VabV9
   08wtaEV/u0lqkgPA8QUoL4lXjfwRnTMmsljetwM1hLkvTBS66c5Y9PmS2
   uep3uVrAgCzb7biHADSOAVX7Uge4ZYruMtDRJLIRe6YWdlDSIIdcjrC5b
   w==;
X-CSE-ConnectionGUID: HBVKAv5RThec4eAfKYtZFQ==
X-CSE-MsgGUID: /ot979yaSgm09pTZ06asGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="60654368"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="60654368"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 17:28:55 -0700
X-CSE-ConnectionGUID: 7P55cVC7S6qpcgjZkfLlHA==
X-CSE-MsgGUID: 9Dp6lqIESwG0hpuXqum9lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="148072599"
Received: from unknown (HELO [10.238.3.95]) ([10.238.3.95])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 17:28:53 -0700
Message-ID: <63dab0c1-b4b4-4da2-8366-59faaa42cc8e@linux.intel.com>
Date: Wed, 28 May 2025 08:28:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
To: "Huang, Kai" <kai.huang@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "eadavis@qq.com" <eadavis@qq.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
 <x86@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
 <c281170eeeda8974eb0e0f755b55c998ba01b7a2.camel@intel.com>
 <18b805fbe1de59f45b0d61667933f5301cea4f86.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <18b805fbe1de59f45b0d61667933f5301cea4f86.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/28/2025 5:48 AM, Huang, Kai wrote:
> On Tue, 2025-05-27 at 17:53 +0000, Edgecombe, Rick P wrote:
>> On Tue, 2025-05-27 at 16:44 +0800, Edward Adam Davis wrote:
>>> is_td() and is_td_vcpu() run in no instrumentation, so use __always_inline
>>> to replace inline.
>>>
>>> [1]
>>> vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
>>>          call to is_td_vcpu.isra.0() leaves .noinstr.text section
>>>
>>> Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
>>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
>>> ---
>>> V1 -> V2: using __always_inline to replace noinstr
>> Argh, for some reason the original report was sent just to Paolo and so I didn't
>> see this until now:
>> https://lore.kernel.org/oe-kbuild-all/202505071640.fUgzT6SF-lkp@intel.com/
>>
>> You (or Paolo) might want to add that link for [1]. Fix looks good.
>>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Also,
>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
Also,

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>



