Return-Path: <kvm+bounces-50065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D52AE1B0B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61195188A713
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A918128B4E3;
	Fri, 20 Jun 2025 12:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTY8Vg82"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8E27FD70;
	Fri, 20 Jun 2025 12:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750422905; cv=none; b=RVLgmQMLkfUScpIXHWruBGabi4X3MT1hQgpCwP7Du45BCV+lSiKoPIBazPhtSRJgisfL6NzInml9RkPiSDv7odT/thXIFGSIEPQBrLznk73fPWwKM8cypkJIflzJ6bZbN44zBbDzE18JzSmRxjYatbMhIHOAK1NQmGAm9+gcqio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750422905; c=relaxed/simple;
	bh=9IwHx1ycZVunLvTXSX8sEoPbE6sQNp/e9ufqlAuaOfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kD1gEXw18ahefTmJmTBTmj23WTB7J+W6JSTZPhIB+Ws29pLPrDyANsmWKoivB6cBV7Ek1I2PYsh5AijhKB2v3xoGFoQaGPd4CMr3b0/h5P84g3XXhGcTlvb3aW6RhdLVn3hveur8uUlssYYa1USRVFvRNblEyGPvxrfmTcRRK10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTY8Vg82; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750422903; x=1781958903;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9IwHx1ycZVunLvTXSX8sEoPbE6sQNp/e9ufqlAuaOfE=;
  b=WTY8Vg82IGuO5E0c3ER3OIvQdiDAtKMxSHkWGWRLTbOV1uLwBiZp6Eyc
   VPbJAsRGDpRI0TZRmfKvGtnOEw8f6ZFTApadcqlcUFR91lQeKnrlAXD6V
   9/GPIzY9kngWNmrpNpdb6umPItkJhQD33ezLRtuRYNnv+fotn7OyFej+a
   vmKIPLhFmxlcrDDZn0bmvRaG9uyHH2zDz4c1aqZFJfGNOplyUNUAEH6fk
   8sw0ao3GmRJcIU98vCBZYmcO8KWvunCURINvye1DpaAx7bpiLwL3uTZgI
   QkTAoj20e5egzf9B3h6IlOxWkt8nV4289xFgs80qa19yg2k6koLa2uznA
   Q==;
X-CSE-ConnectionGUID: n+377PdsQ5+JxD25d+YvaQ==
X-CSE-MsgGUID: DJVkDuSUSROJWnsp5A1Rrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="70120723"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="70120723"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 05:35:02 -0700
X-CSE-ConnectionGUID: bITupucfQ1uya1BhorC9oQ==
X-CSE-MsgGUID: V3erBMLwS9+9Q2LFfNo8yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="151436682"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 05:34:57 -0700
Message-ID: <f633077e-a28a-4c6e-81b3-7a36044f8bae@intel.com>
Date: Fri, 20 Jun 2025 20:34:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
 kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, "Huang, Kai"
 <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
 reinette.chatre@intel.com, "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>, Yan Zhao
 <yan.y.zhao@intel.com>, mikko.ylinen@linux.intel.com,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Yao, Jiewen" <jiewen.yao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <20250619180159.187358-4-pbonzini@redhat.com>
 <cc443335-442d-4ed0-aa01-a6bf5c27b39c@intel.com>
 <CABgObfaeYdKeYQb+6j6j6u5ytasgb=t2z03cQvkG2c+owfOCgg@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfaeYdKeYQb+6j6j6u5ytasgb=t2z03cQvkG2c+owfOCgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/2025 8:03 PM, Paolo Bonzini wrote:
> Il ven 20 giu 2025, 03:21 Xiaoyao Li <xiaoyao.li@intel.com> ha scritto:
>>
>>>                tdx->vp_enter_args.r11 = 0;
>>> +             tdx->vp_enter_args.r12 = 0;
>>>                tdx->vp_enter_args.r13 = 0;
>>>                tdx->vp_enter_args.r14 = 0;
>>> +             return 1;
>>
>> Though it looks OK to return all-0 for r12 == 0 and undefined case of
>> r12 > 1, I prefer returning TDVMCALL_STATUS_INVALID_OPERAND for
>> undefined case.
> 
> 
>  From the GHCI I wasn't sure that TDVMCALL_STATUS_INVALID_OPERAND is a
> valid result at all.

It's part of the new GHCI change, which currently is still in draft 
state. (Sorry for not informing you)

The proposed GHCI update defines VMCALL_OPERAND_INVALID for the case of 
input R12 value is not supported. So for VMM that doesn't implement the 
enumeration for the optional leafs when r12 = 1 can return this status 
code. As well, VMM can return this status code for the case of input R12 
 >= 2, to avoid the VMM introduces its own defined behavior.

> Paolo
> 
>>
>> So please make above "case 0:", and make the "default:" return
>> TDVMCALL_STATUS_INVALID_OPERAND
>>
>>>        }
>>> -     return 1;
>>>    }
>>>
>>>    static int tdx_complete_simple(struct kvm_vcpu *vcpu)
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 6708bc88ae69..fb3b4cd8d662 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -461,6 +461,11 @@ struct kvm_run {
>>>                                        __u64 gpa;
>>>                                        __u64 size;
>>>                                } get_quote;
>>> +                             struct {
>>> +                                     __u64 ret;
>>> +                                     __u64 leaf;
>>> +                                     __u64 r11, r12, r13, r14;
>>> +                             } get_tdvmcall_info;
>>>                        };
>>>                } tdx;
>>>                /* Fix the size of the union. */
>>
> 
> 


