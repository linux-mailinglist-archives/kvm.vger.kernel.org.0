Return-Path: <kvm+bounces-33374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 906459EA524
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 03:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4961638F8
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD3319D897;
	Tue, 10 Dec 2024 02:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQRIW98A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87785233129;
	Tue, 10 Dec 2024 02:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798052; cv=none; b=TdldIH8KOUam/NP+o7akWhBKUJrbI79rpwV8ojYM6nZPC4lt1mBjM+R2Xtecby53ldmhOvyXSpsNtTq9GIPO8i2hbrXt2EQw+nzy5OXDwi6AuXTkcN5fhgGj3Y9mKfkwkHpt2y/0QxqdYW8R3+B5/kNb9R+R/4mP2MhUw3ZF1Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798052; c=relaxed/simple;
	bh=GZudqfN3knEgEEj8Ks3O0UILklj2xj6a778uboW+VFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X10QcB6XzdjW2ItbfzFsxIDr5MHwzl6Z311IIHCWVotWsLoAzgiWSAysv8giTn0bnri30L4DnytqyZ/kkf0NVTV9zNSioglp6/cmNcWCwol6OpIWybrpB6CUxCCcN7vqfH9vG7TCHlbrWR+7JQm8mcNlRSHwRhWkcDVpwC0lYaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQRIW98A; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733798050; x=1765334050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GZudqfN3knEgEEj8Ks3O0UILklj2xj6a778uboW+VFQ=;
  b=kQRIW98AGLQxqk4CTrSVmlwK9uI8qD+OlrjlKwe4m0CROmHkGddykyXd
   /fRqD8sIQlT4NJbDzHFB+vodYAwizugvSg7QXrxk5GQqu9HJjGkBWKCa8
   pkuLbAP3B4YQkTqAvcLBP2h73uFt0RTqcWZuSEnkUipLJl2aFMGzuGWiW
   ZIAbytwuZcVQ0uE721HWbyDu5/WziF4I/SAFew+LtMwwv2PRV1vbI6Vsp
   xhTfK0V01YXgAm4Cu98TagshRKSpslwsgcGAK+ihw+QZ50H/jxtHWzfvt
   hhlqzg29kY6Fpr852WWccTfF4A+4+VLX3F4lGiXJF91yilOlts75oLr0o
   A==;
X-CSE-ConnectionGUID: P6zjQhPTRBilVGLarp5vXQ==
X-CSE-MsgGUID: y0MCWSNlSK+Jj9eCmAOMvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="21710090"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="21710090"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:34:09 -0800
X-CSE-ConnectionGUID: zBqnRLwORRuZtOwqMgXRew==
X-CSE-MsgGUID: 076kzeA7S+ie0pH465iD1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="96053429"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:34:07 -0800
Message-ID: <db6e522a-1b2c-47ab-8e33-b2e3d9b81c4f@linux.intel.com>
Date: Tue, 10 Dec 2024 10:34:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-3-binbin.wu@linux.intel.com>
 <Z1bUbfl8vfVvA0zW@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1bUbfl8vfVvA0zW@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/9/2024 7:28 PM, Chao Gao wrote:
[...]
>>
>> #define VMX_EXIT_REASONS \
>> 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
>> @@ -155,7 +156,8 @@
>> 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
>> 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
>> 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
>> -	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
>> +	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
>> +	{ EXIT_REASON_TDCALL,                "TDCALL" }
> Side topic:
> Strictly speaking, TDCALL vm-exit handling can happen for normal VMs.
Oh, yes. TDX CPU architectural specification, TDCALL in VMX non-root mode
causes VM exit with exit reason TDCALL. So, normal VM could exit with TDCALL.

> so, KVM may
> need to handle it by injecting #UD. Of course, it is not necessary for this series.
Currently, the handling of TDCALL for VMX VMs will return to userspace
with KVM_EXIT_INTERNAL_ERROR + KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON.
Since it's not an expected VM Exit reason for normal VMs, maybe it doesn't
worth a dedicated handler?

