Return-Path: <kvm+bounces-68162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B721D22EA6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 08:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6EC5830188FE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 07:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C0D32C336;
	Thu, 15 Jan 2026 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTxlO4XO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA9218592;
	Thu, 15 Jan 2026 07:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768463252; cv=none; b=BMcZ7OByR+FbRIVjXBqCj3BhAA5QJvnLlLS5nPsR8eA0nIWIGhEBG1CAn2JxjaJt/cUjmTYEtjoHgXBItuXBWB4c3/dbtkS8WTikpA06uHMVaAYwm2CAgfQulc46d2486dNjVx5VAZ5h+uyQ308Dk+AU7qeVcnZwsMnIqjDSSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768463252; c=relaxed/simple;
	bh=S3Wzl5l6bWty/668N7Go2Z+OkYAZypVTcK9mU5Tcjng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0m965GFmchVilk+VwWosqNCyVlSBPyxqoCDS0NjePhnDhLGDD/ckiFaxO41NszBPQRyEshC8EMrrm8GU6qek1Bfj7o3i66MroMK82K/P/8n3tYttDi+LsyTgTsSENUYLdtGv48fUkDVNiN1fEUsHB4bhidKpkW1vuOBs4VpG0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTxlO4XO; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768463251; x=1799999251;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S3Wzl5l6bWty/668N7Go2Z+OkYAZypVTcK9mU5Tcjng=;
  b=XTxlO4XOnkKu0IBwojD4ni0KhN0qmKWCBgdOJtfoGq3JrOVz+rr3eZ27
   w/+s8TXM5pM69bjGPr7v0kwpK65ln2+T/KCB2Tpu9iBDfGuFah4yOe3qE
   TBIudUY1Xmlzhqnq+ChcSQ49z6iK65x3/h9hOq2ZzAhsy1YEcZOhRGztd
   EJH8e7LdnI2+ou7DqTyYJcu91rNhRCnPBxRwiKqaUBag3VetNbxgo8Egr
   K/sbc6IwPDkwdGid9Pkaao0S65eo+eZQj3vIQIEE6CmJg18fqQZUTwznv
   2RIoriALGvQC4ZkhEuRb4JazS6I0vFriPG4ME1ZGJXG80BcHBvoy7+wJE
   Q==;
X-CSE-ConnectionGUID: iYb/0e+rRVi7WTIgWsaDLQ==
X-CSE-MsgGUID: 871KKwdqSAi7+A6fjDQKSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="57320971"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="57320971"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 23:47:31 -0800
X-CSE-ConnectionGUID: ZWG3pRi+Qyeee/hc3F33sw==
X-CSE-MsgGUID: jZvx5enlRg2I2NKIkzLHSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="205174135"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 23:47:27 -0800
Message-ID: <af8bbddc-fcf5-460b-9a6f-1418a0748f37@intel.com>
Date: Thu, 15 Jan 2026 15:47:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for
 MAPGPA
To: Sagi Shahar <sagis@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 Vishal Annapurve <vannapurve@google.com>
References: <20260114003015.1386066-1-sagis@google.com>
 <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
 <aWe8zESCJ0ZeAOT3@google.com>
 <CAAhR5DE=ypkYwqEGEJBZs5A2N9OCVaL_9Jxi5YN5X7rNpKSZTw@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAAhR5DE=ypkYwqEGEJBZs5A2N9OCVaL_9Jxi5YN5X7rNpKSZTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/15/2026 9:21 AM, Sagi Shahar wrote:
> On Wed, Jan 14, 2026 at 9:57 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Jan 14, 2026, Xiaoyao Li wrote:
>>> On 1/14/2026 8:30 AM, Sagi Shahar wrote:
>>>> From: Vishal Annapurve <vannapurve@google.com>
>>>>
>>>> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
>>>> of userspace exits until the complete range is handled.
>>>>
>>>> In some cases userspace VMM might decide to break the MAPGPA operation
>>>> and continue it later. For example: in the case of intrahost migration
>>>> userspace might decide to continue the MAPGPA operation after the
>>>> migrration is completed
>>
>> migration
>>
>>>> Allow userspace to signal to TDX guests that the MAPGPA operation should
>>>> be retried the next time the guest is scheduled.
>>
>> To Xiaoyao's point, changes like this either need new uAPI, or a detailed
>> explanation in the changelog of why such uAPI isn't deemed necessary.
>>
>>>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>>>> Co-developed-by: Sagi Shahar <sagis@google.com>
>>>> Signed-off-by: Sagi Shahar <sagis@google.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/tdx.c | 8 +++++++-
>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index 2d7a4d52ccfb..3244064b1a04 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>>>>      struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>>      if (vcpu->run->hypercall.ret) {
>>>> -           tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>>>> +           if (vcpu->run->hypercall.ret == -EBUSY)
>>>> +                   tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>>>> +           else if (vcpu->run->hypercall.ret == -EINVAL)
>>>> +                   tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>>>> +           else
>>>> +                   return -EINVAL;
>>>
>>> It's incorrect to return -EINVAL here.
>>
>> It's not incorrect, just potentially a breaking change.
>>
>>> The -EINVAL will eventually be
>>> returned to userspace for the VCPU_RUN ioctl. It certainly breaks userspace.
>>
>> It _might_ break userspace.  It certainly changes KVM's ABI, but if no userspace
>> actually utilizes the existing ABI, then userspace hasn't been broken.
>>
>> And unless I'm missing something, QEMU _still_ doesn't set hypercall.ret.  E.g.
>> see this code in __tdx_map_gpa().
>>
>>          /*
>>           * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
>>           * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
>>           * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
>>           * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
>>           */
>>          tdx->vcpu.run->hypercall.ret = 0;
>>
>> AFAICT, QEMU kills the VM if anything goes wrong.
>>
>> So while I initially had the exact same reaction of "this is a breaking change
>> and needs to be opt-in", we might actually be able to get away with just making
>> the change (assuming no other VMMs care, or are willing to change themselves).
> 
> Is there a better source of truth for whether QEMU uses hypercall.ret
> or just point to this comment in the commit message.

No version of QEMU touches hypercall.ret, from the source code.

I suggest not mentioning the comment, because it only tells QEMU expects 
vcpu->run->hypercall.ret to be 0 on KVM_EXIT_HYPERCALL. What matters is 
QEMU never sets vcpu->run->hypercall.ret to a non-zero value after 
handling KVM_EXIT_HYPERCALL. I think you can just describe the fact that 
QEMU never set vcpu->run->hypercall.ret to a non-zero value in the 
commit message.


