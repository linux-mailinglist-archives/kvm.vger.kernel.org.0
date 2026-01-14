Return-Path: <kvm+bounces-68008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A72D1D962
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 12F18302E375
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691063876DF;
	Wed, 14 Jan 2026 09:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="egMgXUT0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720283803CF;
	Wed, 14 Jan 2026 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768383133; cv=none; b=d8O1LL+B6Or+nBzpFd55bT2eTO12li7f17uK8SdnQBbThxr6P7iS42wLGai4LMtNm9qYIvgdP8ejus5vcZ6kVr85r0m74HNXeFTnU52Ir5ADfpHeJFZy6Yay+lwJF3Us0s8B1GFzWKSdXalPC9FMJzY1QON7ZjfeITirHZBXbqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768383133; c=relaxed/simple;
	bh=KHc7CZfKFe7jROH1FXxAbzwyF0WYtKG7/MBs2Jo20CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffmm/dKLVZllup1APqa4nbTJl/OUojDlz/JwOLdX2Wh3mVdjyZs5U7zl7MWW7GlfHxHrLLrrDl2WbC5rVPxhYHurjr5IdWQwcHGxtWI8KI4rkCCiYl8T2Xw80v+eAS+XMkmtTUCKTRoMQFUITGkoV57b2RG2SeSvMzWh3DJlY8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=egMgXUT0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768383132; x=1799919132;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KHc7CZfKFe7jROH1FXxAbzwyF0WYtKG7/MBs2Jo20CY=;
  b=egMgXUT0XW4PX1ZF7jUzm8AwpBcrJuHWBRFnLPP35XrhlDN+TOn4AnCe
   yJI5UNA1VaVMwr8ZqL8g4672+LlAxIE8TN3N61M1ucyZomDwT7upFjzUl
   4DF4LmWFL7OL/UTSjsXfqw4wAaz2x3Oaqffq9Xuh3DGL80zVwzAXs+cuq
   LqMSwgtJm0UoUMs6PJvuG6/WIR69nPSsvLW+5jBA0svcypnAUGMKGom9g
   E0nKm17t+10a+brz51CTbtOJvjMyWzkFTWThGVHUQZcaPODbe6w3xhKFQ
   0o0H7I8iypzcHEwsn5vQ1sQo9DA9BEV0/2AFO/cz62bQuoqSpIAMguoKE
   Q==;
X-CSE-ConnectionGUID: vckgPsHVSYibWnILqJ5cRw==
X-CSE-MsgGUID: Jm9RDBPvTbavNzfnbzdvTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69598120"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="69598120"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:32:12 -0800
X-CSE-ConnectionGUID: V3MTrGxtTVyUdSbccfAaNA==
X-CSE-MsgGUID: wPZS+suPQoim7fiyduv70w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="235345915"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:32:09 -0800
Message-ID: <09739da1-66a0-454c-910c-e01156b434bf@linux.intel.com>
Date: Wed, 14 Jan 2026 17:32:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for
 MAPGPA
To: Sagi Shahar <sagis@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 Vishal Annapurve <vannapurve@google.com>
References: <20260114003015.1386066-1-sagis@google.com>
 <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/14/2026 10:59 AM, Xiaoyao Li wrote:
> On 1/14/2026 8:30 AM, Sagi Shahar wrote:
>> From: Vishal Annapurve <vannapurve@google.com>
>>
>> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
>> of userspace exits until the complete range is handled.
>>
>> In some cases userspace VMM might decide to break the MAPGPA operation
>> and continue it later. For example: in the case of intrahost migration
>> userspace might decide to continue the MAPGPA operation after the
>> migrration is completed.
>>
>> Allow userspace to signal to TDX guests that the MAPGPA operation should
>> be retried the next time the guest is scheduled.

How does the guest differentiate it from a retry due to pending events?
Will the guest retry immediately after returning back to the guest in this case?


>>
>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> Co-developed-by: Sagi Shahar <sagis@google.com>
>> Signed-off-by: Sagi Shahar <sagis@google.com>
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 2d7a4d52ccfb..3244064b1a04 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>>       struct vcpu_tdx *tdx = to_tdx(vcpu);
>>         if (vcpu->run->hypercall.ret) {
>> -        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +        if (vcpu->run->hypercall.ret == -EBUSY)
>> +            tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>> +        else if (vcpu->run->hypercall.ret == -EINVAL)
>> +            tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +        else
>> +            return -EINVAL;
> 
> It's incorrect to return -EINVAL here. The -EINVAL will eventually be returned to userspace for the VCPU_RUN ioctl. It certainly breaks userspace. So it needs to be
> 
>     if (vcpu->run->hypercall.ret == -EBUSY)
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>     else
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> 
> But I'm not sure if such change breaks the userspace ABI that if needs to be opted-in.
> 


