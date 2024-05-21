Return-Path: <kvm+bounces-17818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69BA8CA576
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EB9CB22417
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E8EA955;
	Tue, 21 May 2024 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8nhCIoG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CAED9;
	Tue, 21 May 2024 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716252613; cv=none; b=N5FxqQDPD+lU2nXlmIEsEFge1+qOVsuqj6PwbzmtkRgM/1aT02f+XqH5B80j53U4DZQbeGxcWuy2IQroo8KbGOwvHorllHdy5U0yXgSCZDH8DwjjvYYv2kJSmx1/qc+k2dASPoz/g9FHbK73yhIx11YC0JHZkIlWjXitQn2i/eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716252613; c=relaxed/simple;
	bh=bmp8fr++SX2ZpALlJv3IjLJSzc2ON4Zni7XoFdvDuDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+3yBssAhsyMUvth0e9yzQ/UZudwbi6A6ZXFimfPwIZIcGmcyYNPrcKmptBFr8kPcBB8uxNYhvzecoAGWGxFzenStD0psXoH0+dfCdErGFNxYH8Mq5GpFl5Dl61FuSUdEndU6v+uU4VWeU4ak2lwi4NtK+R1MRhI0vCdsULvqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8nhCIoG; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716252612; x=1747788612;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bmp8fr++SX2ZpALlJv3IjLJSzc2ON4Zni7XoFdvDuDY=;
  b=g8nhCIoGj53p5WyLh/KnRYXeptfXtd6QimTrfkW3vfDxadNEW0wizKjp
   9BujN8mOjZyi1rGVHOyUHaz8kEHv4N7cBOME6Fasd3ICj66hLalw6VIIv
   FK/Fwe5HrxXERgGEeX3qyZMX8oXUY/vE91WOMERcwxitBno+fCc2KG4S+
   DUTwpopn4Q9wkYOeUPNssdxeqOsce4z04wwdHhyh4AJ8H1ABMV1d5DzUo
   aOybnRX8Kc5uNivCcIHJetvvsZ5axAmGGq0CNZ9MAYf9H3P3ssDNLeOjw
   1jH9tISpQOzP7KF9Hxgq6Tk3Mjnd2bc9TWBGV3h8PgIlYAx+plT7LBs/U
   w==;
X-CSE-ConnectionGUID: g4P7p4nmSXSE8GXx+y4zFQ==
X-CSE-MsgGUID: CqwWUxrlR++jw0wIMLx/mg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12528644"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12528644"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 17:50:11 -0700
X-CSE-ConnectionGUID: qEl6I9APROCpPWpfMZ49fw==
X-CSE-MsgGUID: k0zPN6EnRx2Q9MmHNETa3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32618014"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 17:50:02 -0700
Message-ID: <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com>
Date: Tue, 21 May 2024 08:49:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com>
 <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/17/2024 1:23 AM, Paolo Bonzini wrote:
> On Thu, May 16, 2024 at 10:29 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>
>>
>> On 5/1/2024 4:51 PM, Michael Roth wrote:
>>> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
>>> table to be private or shared using the Page State Change MSR protocol
>>> as defined in the GHCB specification.
>>>
>>> When using gmem, private/shared memory is allocated through separate
>>> pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
>>> KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
>>> backed by private memory or not.
>>>
>>> Forward these page state change requests to userspace so that it can
>>> issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
>>> entries when it is ready to map a private page into a guest.
>>>
>>> Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to deliver these
>>> requests to userspace via KVM_EXIT_HYPERCALL.
>>>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>    arch/x86/include/asm/sev-common.h |  6 ++++
>>>    arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++++++
>>>    2 files changed, 54 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>>> index 1006bfffe07a..6d68db812de1 100644
>>> --- a/arch/x86/include/asm/sev-common.h
>>> +++ b/arch/x86/include/asm/sev-common.h
>>> @@ -101,11 +101,17 @@ enum psc_op {
>>>        /* GHCBData[11:0] */                            \
>>>        GHCB_MSR_PSC_REQ)
>>>
>>> +#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >> 12)
>>> +#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> 52)
>>> +
>>>    #define GHCB_MSR_PSC_RESP           0x015
>>>    #define GHCB_MSR_PSC_RESP_VAL(val)                  \
>>>        /* GHCBData[63:32] */                           \
>>>        (((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
>>>
>>> +/* Set highest bit as a generic error response */
>>> +#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
>>> +
>>>    /* GHCB Hypervisor Feature Request/Response */
>>>    #define GHCB_MSR_HV_FT_REQ          0x080
>>>    #define GHCB_MSR_HV_FT_RESP         0x081
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index e1ac5af4cb74..720775c9d0b8 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
>>>        svm->vmcb->control.ghcb_gpa = value;
>>>    }
>>>
>>> +static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
>>> +{
>>> +     struct vcpu_svm *svm = to_svm(vcpu);
>>> +
>>> +     if (vcpu->run->hypercall.ret)
>> Do we have definition of ret? I didn't find clear documentation about it.
>> According to the code, 0 means succssful. Is there any other error codes
>> need to or can be interpreted?
> They are defined in include/uapi/linux/kvm_para.h
>
> #define KVM_ENOSYS        1000
> #define KVM_EFAULT        EFAULT /* 14 */
> #define KVM_EINVAL        EINVAL /* 22 */
> #define KVM_E2BIG        E2BIG /* 7 */
> #define KVM_EPERM        EPERM /* 1*/
> #define KVM_EOPNOTSUPP        95
>
> Linux however does not expect the hypercall to fail for SEV/SEV-ES; and
> it will terminate the guest if the PSC operation fails for SEV-SNP.  So
> it's best for userspace if the hypercall always succeeds. :)
Thanks for the info.

For TDX, it wants to restrict the size of memory range for conversion in 
one hypercall to avoid a too long latency.
Previously, in TDX QEMU patchset v5, the limitation is in userspace and  
if the size is too big, the status_code will set to TDG_VP_VMCALL_RETRY 
and the failed GPA for guest to retry is updated.
https://lore.kernel.org/all/20240229063726.610065-51-xiaoyao.li@intel.com/

When TDX converts TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE, do you think 
which is more reasonable to set the restriction? In KVM (TDX specific 
code) or userspace?
If userspace is preferred, then the interface needs to  be extended to 
support it.


>
>> For TDX, it may also want to use KVM_HC_MAP_GPA_RANGE hypercall  to
>> userspace via KVM_EXIT_HYPERCALL.
> Yes, definitely.
>
> Paolo
>


