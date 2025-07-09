Return-Path: <kvm+bounces-51830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CAB2AFDC7C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 02:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74B3D1BC1F34
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 00:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3021912CDA5;
	Wed,  9 Jul 2025 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQ0ioYdT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE720502BE;
	Wed,  9 Jul 2025 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752021796; cv=none; b=MCg6G+PS/p+3ts5C5YqjlXJT4Xgn7ZA2JdwwNTwGeVZMzFvmeKMuTLZMa3VQIM23giFwCNs86NUHB+rOprO+q4T4YQcRxa9yg8OK81nBW3LFzgdFT/UaW5bB7Bz6ONbYguEmTB2hvcKcOt/THP4B7HffQlS8lsxxIe0dznpe3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752021796; c=relaxed/simple;
	bh=xIJvmUTBnfOZgzXMdSugiNpsj73ZyVWw1UShPw/Rui4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SxJT6BZ67E3i2P1pKnR7KN23nl94pA2T3WPSnSa/Bg08Q68lug2ZNN0GzozpnuV9pXtjoTVUO0ve61ZealKBuF0L5lSae7eiL2paIFWvS4XhUWfdvYx9xPMkgMTtFUmWTLkYwX7Csq7HrsDSOVpvJOk5Jx7mJnCZwKdKnLXS9EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQ0ioYdT; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752021795; x=1783557795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xIJvmUTBnfOZgzXMdSugiNpsj73ZyVWw1UShPw/Rui4=;
  b=HQ0ioYdTeuPLbaIYhuVvvp98jNzTnXsLbebZW4YFTQQpfGiPFDhgY/gt
   MKbD/6ddD7fXku3z2bfaFsTFhXe7TiRnJTBlmVCc4NjlX7lHSV2oIiQdE
   ziLsLWtD8f8Gh1JJZqyw0/kWdejDD8gD7DgTK5a52m8f9D4AeyCXUiBPK
   Hatnab1pu1jJHm5CEy0NVmHNQ/C9uCE4HBIeToS8NTy4obfqsSXLkotzb
   YpVgttOG7eOqtMcciZ3e/KQwVLxJzzBMM0+tgu2ttPu5dVOdz6SNyq19A
   uhkVW5rFPKpOsUMIL82vgo3xJq2SNJub/6RnL5wIl04zXu4d2Tc7SftCF
   Q==;
X-CSE-ConnectionGUID: YkwPi4zIQbGZVot9K4TZxw==
X-CSE-MsgGUID: LM6g1Vz2SHKEdw0glIPmzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="58076068"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="58076068"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 17:43:14 -0700
X-CSE-ConnectionGUID: UgcJDxb5RSuuhZ6codqfOg==
X-CSE-MsgGUID: Yj3NnpNIRA+l/7rybPDGWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161285120"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 17:43:09 -0700
Message-ID: <bb43278f-a636-4876-b75b-d912a233b296@intel.com>
Date: Wed, 9 Jul 2025 08:43:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Kai Huang <kai.huang@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
 Tony Lindgren <tony.lindgren@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
 <20250708080314.43081-3-xiaoyao.li@intel.com> <aG0lK5MiufiTCi9x@google.com>
 <bdd84a04818a40dd1c7f94bb7d47c4a0116d5e5d.camel@intel.com>
 <aG0uyLwxqfKSX72s@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aG0uyLwxqfKSX72s@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/8/2025 10:44 PM, Sean Christopherson wrote:
> On Tue, Jul 08, 2025, Rick P Edgecombe wrote:
>> On Tue, 2025-07-08 at 07:03 -0700, Sean Christopherson wrote:
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index c539c2e6109f..efb7d589b672 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass,
>>>> char *op, u32 field,
>>>>    	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass,
>>>> field, op, val, err);
>>>>    }
>>>>    
>>>> -#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>>>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
>>>
>>> Would it make sense to rename KVM_SUPPORTED_TD_ATTRS to
>>> KVM_SUPPORTED_TDX_ATTRS?
>>> The names from common code lack the TD qualifier, and I think it'd be helpful
>>> for
>>> readers to have have TDX in the name (even though I agree "TD" is more
>>> precise).
>>
>> It's useful to know that these are per-TD attributes and not per-TDX module.
>> Especially for TDX_TD_ATTR_DEBUG. I kind of prefer the KVM naming scheme that is
>> removed in this patch.
> 
> Heh, as does Xiaoyao, and me too.  I thought I was just being nitpicky :-)
> 
> Though in that case, I think I'd prefer KVM_SUPPORTED_TDX_TD_ATTRS.

To me, since the MACRO is only used inside kvm/vmx/tdx.c, it's OK 
without the _TDX_ prefix.

However, doing the rename is simple. So I'm going to rename it in a 
separate patch in the v2 unless being told unnecessary.



