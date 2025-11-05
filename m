Return-Path: <kvm+bounces-62049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D54C3524D
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 11:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B61264F1F01
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 10:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC312DF3F9;
	Wed,  5 Nov 2025 10:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TC1KMqpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFE4304BC6
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762339276; cv=none; b=jBMb5UeMs8xsX0/KXFlTdyCJqE0z1yD1wpPJX3YFp+YUQU2hbi+FebdX38dGWSXfX6rV6vJcM+KNQbaMqqqpV7boCR4Oa3JGB2YwvfpxmiYjEWsghZGQhQINgLsUWbtYG1N4NAYAWCCYjWIUGQ8xJfSCXjB2iU7eFvWJr6dUEr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762339276; c=relaxed/simple;
	bh=MtaTT7G+w232s+YcuGdOjHmBECOjrYSrE1Pg/WoVVeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqDeowyr06najhyZmiisR4A2j3uxmqN38GWT0CpgnmMDx6+CcnzYd9m9XBmkSTTba6zcmSLi4vj/gfzhRuAUtoxb26Kfe7NuECMdQBc+onoyzWgiDGAd2lQJFnv79LJNgT30PBcpTzEdtd9O12VafSYh1jVWaF1qIO227hIzv0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TC1KMqpJ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762339275; x=1793875275;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MtaTT7G+w232s+YcuGdOjHmBECOjrYSrE1Pg/WoVVeo=;
  b=TC1KMqpJrx0ZCMsdYflVjs8xYB0sY/vkjLfwIEGwlWDS6PeBOCLgUi0Q
   tSpHINyCJTzF4DkEPv4ojXDLpa0U/OPnM96r3rUTSQ4jd3tfHLXqdNMYm
   NDtWfu4jocJMEHuo2ElTHjF3hq+J5y9u0gdZf+fNBHN6sO0ZxIFmccWiR
   ZHaizKQnLe2gtD7fDD8CGHcHXrnR8w8FjS7cGs/i74apcyvGSnsT0bGlh
   /qMlpVBOqwYg1cY/q4imb64XKMmiePq+p54oWqyJLVud64ynjz1WEdkEE
   CqYGVBEaJsJE9OadLZNK44QAM//yx5XHx+fl6jcy7qn4K9uYw+GIebY2K
   Q==;
X-CSE-ConnectionGUID: UXFmuuCKS52JmlrgSN+pjg==
X-CSE-MsgGUID: d+g1HGHoTP+JastDRrJduQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="75898975"
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="75898975"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:41:11 -0800
X-CSE-ConnectionGUID: IJ+dJT4rRLCDWLd4YAd2SA==
X-CSE-MsgGUID: sAX2I0HSQcmsiZrk85Tqtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="187581204"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:41:06 -0800
Message-ID: <bd53ca4a-7415-48b2-b1da-373957cd4025@intel.com>
Date: Wed, 5 Nov 2025 18:41:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/20] i386/machine: Add vmstate for cet-ss and cet-ibt
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-16-zhao1.liu@intel.com>
 <445462e9-22e5-4e8b-999e-7be468731752@intel.com> <aQOMjlHnjgwdYfFX@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aQOMjlHnjgwdYfFX@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2025 12:04 AM, Zhao Liu wrote:
>>> +static const VMStateDescription vmstate_cet = {
>>> +    .name = "cpu/cet",
>>> +    .version_id = 1,
>>> +    .minimum_version_id = 1,
>>> +    .needed = cet_needed,
>>> +    .fields = (VMStateField[]) {
>>> +        VMSTATE_UINT64(env.u_cet, X86CPU),
>>> +        VMSTATE_UINT64(env.s_cet, X86CPU),
>>> +        VMSTATE_END_OF_LIST()
>>> +    },
>>> +    .subsections = (const VMStateDescription * const []) {
>>> +        &vmstate_ss,
> here:       ^^^^^^^^^^^^^
> 
>>> +        NULL,
>>> +    },
>>> +};
>>> +
>>>    const VMStateDescription vmstate_x86_cpu = {
>>>        .name = "cpu",
>>>        .version_id = 12,
>>> @@ -1817,6 +1869,7 @@ const VMStateDescription vmstate_x86_cpu = {
>>>    #endif
>>>            &vmstate_arch_lbr,
>>>            &vmstate_triple_fault,
>>> +        &vmstate_cet,
>> missing &vmstate_ss
> I made vmstate_ss as a subsection in vmstate_cet

Sorry for missing it.

btw, can we rename vmstate_ss to vmstate_cet_ss?

