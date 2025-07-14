Return-Path: <kvm+bounces-52340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEE9B042A0
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 17:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30D5D3B9D97
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCAD25BEF0;
	Mon, 14 Jul 2025 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DMoNOnfC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85212E630;
	Mon, 14 Jul 2025 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505603; cv=none; b=WIslCaqRiK94oX8t4vtwTlT5e0Zl0r4BQnkuTzivW26YdZ0QFJlXN1b08MxQx2bU1rRabweBtwS1ppT8tXUujNz79CnW851PWYnYAXstcJUW76u/DW9WnIpZzDrpKjHEGMYGiOr/+Awc2/R6ChE4KLSnM1VvpmXBd4ahyjobutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505603; c=relaxed/simple;
	bh=i4jwoQP0/RIhlR6TJLl5Ajz5CQOFMYIW0zuR6sjVikM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4sO4noI/8Qx8po47heU39L42q2ZJa0IE3Knc2o3nxa/913dxHFeh6d8WPey0j6Hez+km/iSqzUVOuCTUYKp9Y2XbXXIn6wUcxWKsKKTwYciJwPGvOBEF9QiQBJPA0VYBYxhWQNpPKp8pkcol0aoVepBQt9nAeOYrC/wCWKlTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DMoNOnfC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752505601; x=1784041601;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i4jwoQP0/RIhlR6TJLl5Ajz5CQOFMYIW0zuR6sjVikM=;
  b=DMoNOnfCf5KwUBU6u9T8W9eYLm++39Ks1W//b3iA33UoDINnp4ieOTnn
   SBCjYbEPp+AZdki/wHrA9+tLbbC7bBnnUUjM+4Le8Y1l9jV/2fxt9HXWc
   TeWVMTrXUP5pgXA2969iF2ENvXARmmhFBjZq9Kt7PcIHvArgcXfLnpo/N
   7IUnzBUdreXwPvbh2UHgwluZsosgCymGSh2+xNwEIV4+fxV2H4HOP+H8e
   wsFCNvC1VBKexAjHSbv+c9mcetdy+gjAGv9LNWrL9IdzuZQu2ikRV/ssW
   IEPYM5cfzBlXhdBtMj6ZFtX1gCdR99HSOGxqNGqtjj7bVGyzsnSB1yagA
   A==;
X-CSE-ConnectionGUID: igbzh/BSSO+ZLHNRixbC+g==
X-CSE-MsgGUID: 4IbZvekgSXyJwYJMXvVLqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72148166"
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="72148166"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 08:06:41 -0700
X-CSE-ConnectionGUID: jD/NGjtxQfmbeS4epycsAA==
X-CSE-MsgGUID: GWcYVzotSNOmpy4dCaijWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="157049798"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 08:06:37 -0700
Message-ID: <5a8a4804-ee15-42dd-90e0-360000ef661a@intel.com>
Date: Mon, 14 Jul 2025 23:06:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Yan Y Zhao
 <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
References: <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com>
 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com>
 <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
 <aHGYvrdX4biqKYih@google.com>
 <a29d4a7f319f95a45f775270c75ccf136645fad4.camel@intel.com>
 <3ef581f1-1ff1-4b99-b216-b316f6415318@intel.com>
 <aHUMcdJ9Khh2Yeox@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aHUMcdJ9Khh2Yeox@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/14/2025 9:56 PM, Sean Christopherson wrote:
> On Mon, Jul 14, 2025, Xiaoyao Li wrote:
>> On 7/12/2025 7:17 AM, Edgecombe, Rick P wrote:
>>> On Fri, 2025-07-11 at 16:05 -0700, Sean Christopherson wrote:
>>>>> Zero the reserved area in struct kvm_tdx_capabilities so that fields added
>>>>> in
>>>>> the reserved area won't disturb any userspace that previously had garbage
>>>>> there.
>>>>
>>>> It's not only about disturbing userspace, it's also about actually being able
>>>> to repurpose the reserved fields in the future without needing *another* flag
>>>> to tell userspace that it's ok to read the previously-reserved fields.  I care
>>>> about this much more than I care about userspace using reserved fields as
>>>> scratch space.
>>>
>>> If, before calling KVM_TDX_CAPABILITIES, userspace zeros the new field that it
>>> knows about, but isn't sure if the kernel does, it's the same no?
> 
> Heh, yeah, this crossed my mind about 5 minutes after I logged off :-)
> 
>>> Did you see that the way KVM_TDX_CAPABILITIES is implemented today is a little
>>> weird? It actually copies the whole struct kvm_tdx_capabilities from userspace
>>> and then sets some fields (not reserved) and then copies it back. So userspace
>>> can zero any fields it wants to know about before calling KVM_TDX_CAPABILITIES.
>>> Then it could know the same things as if the kernel zeroed it.
>>>
>>> I was actually wondering if we want to change the kernel to zero reserved, if it
>>> might make more sense to just copy caps->cpuid.nent field from userspace, and
>>> then populate the whole thing starting from a zero'd buffer in the kernel.
>>
>> +1 to zero the whole buffer of *caps in the kernel.
> 
> Ya, I almost suggested that, but assumed there was a reason for copying the entire
> structure.
> 
>> current code seems to have issue on the caps->kernel_tdvmcallinfo_1_r11/kernel_tdvmcallinfo_1_r12/user_tdvmcallinfo_1_r12,
>> as KVM cannot guarantee zero'ed value are returned to userspace.
> 
> This?  (untested)

Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f4d4fd5cc6e8..42cb328d8a7d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2270,25 +2270,26 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>          const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
>          struct kvm_tdx_capabilities __user *user_caps;
>          struct kvm_tdx_capabilities *caps = NULL;
> +       u32 nr_user_entries;
>          int ret = 0;
>   
>          /* flags is reserved for future use */
>          if (cmd->flags)
>                  return -EINVAL;
>   
> -       caps = kmalloc(sizeof(*caps) +
> +       caps = kzalloc(sizeof(*caps) +
>                         sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid_config,
>                         GFP_KERNEL);
>          if (!caps)
>                  return -ENOMEM;
>   
>          user_caps = u64_to_user_ptr(cmd->data);
> -       if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> +       if (get_user(nr_user_entries, &user_caps->cpuid.nent)) {
>                  ret = -EFAULT;
>                  goto out;
>          }
>   
> -       if (caps->cpuid.nent < td_conf->num_cpuid_config) {
> +       if (nr_user_entries < td_conf->num_cpuid_config) {
>                  ret = -E2BIG;
>                  goto out;
>          }


