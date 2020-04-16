Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA21ABC00
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 11:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502931AbgDPJBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 05:01:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2503036AbgDPI7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 04:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587027581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=in7H7ONw1I+4eSMhCHSqKuOKU2BfMnrz5BOl84K5Oq8=;
        b=YGYqjG/vQFlkFx9L658Ysw+txbIEqgesZI3d+l+mvQ1TVRigbN1tt3q5KWp8FblmbzZxsw
        V18FjH8zbAgJM9zFKgavXYcfNpFAPm9SpCVRVMKcqBUvYfiaR+v3zVQP+BJvqodQRHRAj3
        eSwQmTuas4WltcFq4rdZJ4LShO+Nw/8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-8Gps4dtQMJmcqyFzR3QqNA-1; Thu, 16 Apr 2020 04:59:39 -0400
X-MC-Unique: 8Gps4dtQMJmcqyFzR3QqNA-1
Received: by mail-wm1-f69.google.com with SMTP id f8so1136173wmh.4
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 01:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=in7H7ONw1I+4eSMhCHSqKuOKU2BfMnrz5BOl84K5Oq8=;
        b=NifUvZIOElgObNP0HZlpznSbPAbQPa2Biq2xj0AK5HzaFm/Z3+2ArSnhSdxNujBwU3
         p6+3AqX9roJBVHsyHxaLkgfcwYvb92F+VGqBpL+k2G6B27sW4YPIGVe6tLRD2B1QuF09
         w86xeIETvHU65LkhHSB6QPduMsHb1JDZrSacRCRBv8L6SH2u8srw4j0L+Dg5x55WKYFK
         JvlO4hDycGGc2l0ABHOVGxQPcnDJ66a9yF2P+qJIw3Hbm89AZYEKS0UubByAOy8gH9Ci
         XG/aQ2AWDDYMzUjf+WcFeaEqHzKEvpxvfch1bSypALSDaAljHc4VMPSP0oZmCsVXsXDB
         2FQQ==
X-Gm-Message-State: AGi0PuaY+7Bs9ITVCNxsXrmBnrBq3N7CCPRrXLrniLjf+TL77yNsDqFi
        YA34DCq6h3j0XypCrsgVwyfQVuahjvJ5xL0ALiS2fRlZeOo/FjZ1KdkLk/Nu+bbhS2rsyAbn7k+
        /nQVtBnrkTrm6
X-Received: by 2002:a1c:147:: with SMTP id 68mr3929434wmb.28.1587027578040;
        Thu, 16 Apr 2020 01:59:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypJwQh54RSSTeHtY2vKDQoaZm78XQsS1ZWxR4YWgXLJfKe2naCDb5se24MGz7TfFPoP3/EgqGA==
X-Received: by 2002:a1c:147:: with SMTP id 68mr3929409wmb.28.1587027577613;
        Thu, 16 Apr 2020 01:59:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:59f3:e385:f957:c478? ([2001:b07:6468:f312:59f3:e385:f957:c478])
        by smtp.gmail.com with ESMTPSA id u3sm17215942wrt.93.2020.04.16.01.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 01:59:37 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Remove non-functional "support" for CR3 target
 values
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200416000739.9012-1-sean.j.christopherson@intel.com>
 <875zdzx5zd.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e94edb29-29b4-750a-ca91-052129f6a29c@redhat.com>
Date:   Thu, 16 Apr 2020 10:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <875zdzx5zd.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 09:08, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
>> Remove all references to cr3_target_value[0-3] and replace the fields
>> in vmcs12 with "dead_space" to preserve the vmcs12 layout.  KVM doesn't
>> support emulating CR3-target values, despite a variety of code that
>> implies otherwise, as KVM unconditionally reports '0' for the number of
>> supported CR3-target values.
>>
>> This technically fixes a bug where KVM would incorrectly allow VMREAD
>> and VMWRITE to nonexistent fields, i.e. cr3_target_value[0-3].  Per
>> Intel's SDM, the number of supported CR3-target values reported in
>> VMX_MISC also enumerates the existence of the associated VMCS fields:
>>
>>   If a future implementation supports more than 4 CR3-target values, they
>>   will be encoded consecutively following the 4 encodings given here.
>>
>> Alternatively, the "bug" could be fixed by actually advertisting support
>> for 4 CR3-target values, but that'd likely just enable kvm-unit-tests
>> given that no one has complained about lack of support for going on ten
>> years, e.g. KVM, Xen and HyperV don't use CR3-target values.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>
>> Krish's patch to allow L1 to disable unrestricted guest got me poking
>> around the related code.  That led me into nested_vmx_exit_handled_cr()
>> and handle_cr().  handle_cr() does WARN_ON_ONCE(enable_unrestricted_guest)
>> in the MOV-to-CR3 path, as KVM should never enable CR3-exiting for L1.
>> But the CR3-target matching nested_vmx_exit_handled_cr() meant that it
>> would be possible to trigger the warn by enabling CR3-exiting in L1 with
>> a valid list of CR3-targets.  I got so far as to write a patch and a unit
>> test, and then I checked MSR_IA32_VMX_MISC under KVM...
>>
>> AFAICT, properly emulating CR3-targets would be a trivial patch.  But, I
>> don't think there would be any meaningful users, e.g. Xen is the one
>> hypervisor (that I am aware of) that runs with EPT disabled for certain
>> use cases, and even Xen doesn't bother with CR3-targets.  On the other
>> hand, the odds of introducing a bug of one form or another seem high.
>>
>> Amusing side note, Xen's only reference to vmcs.CR3_TARGET_VALUE* is in
>> its vmcs_dump_vcpu(), which explains why KVM's dump_vmcs() bothers to spit
>> out the unused CR3-target fields :-).
>>
>>  Documentation/virt/kvm/nested-vmx.rst |  5 +----
>>  arch/x86/kvm/vmx/evmcs.c              |  8 --------
>>  arch/x86/kvm/vmx/nested.c             | 17 -----------------
>>  arch/x86/kvm/vmx/vmcs12.c             |  4 ----
>>  arch/x86/kvm/vmx/vmcs12.h             | 10 ++--------
>>  arch/x86/kvm/vmx/vmx.c                |  9 ---------
>>  6 files changed, 3 insertions(+), 50 deletions(-)
> 
> 
> 'git grep CR3_TARGET_VALUE' tells me we also have stuff in selftests:
> 
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE0:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE1:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE2:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE3:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE0:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE1:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE2:
> tools/testing/selftests/kvm/include/evmcs.h:    case CR3_TARGET_VALUE3:
> tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE0               = 0x00006008,
> tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE1               = 0x0000600a,
> tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE2               = 0x0000600c,
> tools/testing/selftests/kvm/include/x86_64/vmx.h:       CR3_TARGET_VALUE3               = 0x0000600e,
> 
> we should probably clean it up al well.

I don't think so, they are documented fields according to the Microsoft
and Intel specs so they can be kept in the selftests.  The selftests'
"hypervisor" side should not be tied to KVM implementation details.

Paolo

> 
>>
>> diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/nested-vmx.rst
>> index 592b0ab6970b..89851cbb7df9 100644
>> --- a/Documentation/virt/kvm/nested-vmx.rst
>> +++ b/Documentation/virt/kvm/nested-vmx.rst
>> @@ -116,10 +116,7 @@ struct shadow_vmcs is ever changed.
>>  		natural_width cr4_guest_host_mask;
>>  		natural_width cr0_read_shadow;
>>  		natural_width cr4_read_shadow;
>> -		natural_width cr3_target_value0;
>> -		natural_width cr3_target_value1;
>> -		natural_width cr3_target_value2;
>> -		natural_width cr3_target_value3;
>> +		natural_width dead_space[4]; /* Last remnants of cr3_target_value[0-3]. */
>>  		natural_width exit_qualification;
>>  		natural_width guest_linear_address;
>>  		natural_width guest_cr0;
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 303813423c3e..73f3e07c1852 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -160,14 +160,6 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
>>  		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>>  	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr,
>>  		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(CR3_TARGET_VALUE0, cr3_target_value0,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(CR3_TARGET_VALUE1, cr3_target_value1,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(CR3_TARGET_VALUE2, cr3_target_value2,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(CR3_TARGET_VALUE3, cr3_target_value3,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>>  
>>  	/* 32 bit rw */
>>  	EVMCS1_FIELD(TPR_THRESHOLD, tpr_threshold,
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index aca57d8da400..aeb56b515c5c 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1785,10 +1785,6 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>>  	 * vmcs12->vm_exit_msr_store_addr = evmcs->vm_exit_msr_store_addr;
>>  	 * vmcs12->vm_exit_msr_load_addr = evmcs->vm_exit_msr_load_addr;
>>  	 * vmcs12->vm_entry_msr_load_addr = evmcs->vm_entry_msr_load_addr;
>> -	 * vmcs12->cr3_target_value0 = evmcs->cr3_target_value0;
>> -	 * vmcs12->cr3_target_value1 = evmcs->cr3_target_value1;
>> -	 * vmcs12->cr3_target_value2 = evmcs->cr3_target_value2;
>> -	 * vmcs12->cr3_target_value3 = evmcs->cr3_target_value3;
>>  	 * vmcs12->page_fault_error_code_mask =
>>  	 *		evmcs->page_fault_error_code_mask;
>>  	 * vmcs12->page_fault_error_code_match =
>> @@ -1862,10 +1858,6 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>>  	 * evmcs->vm_exit_msr_store_addr = vmcs12->vm_exit_msr_store_addr;
>>  	 * evmcs->vm_exit_msr_load_addr = vmcs12->vm_exit_msr_load_addr;
>>  	 * evmcs->vm_entry_msr_load_addr = vmcs12->vm_entry_msr_load_addr;
>> -	 * evmcs->cr3_target_value0 = vmcs12->cr3_target_value0;
>> -	 * evmcs->cr3_target_value1 = vmcs12->cr3_target_value1;
>> -	 * evmcs->cr3_target_value2 = vmcs12->cr3_target_value2;
>> -	 * evmcs->cr3_target_value3 = vmcs12->cr3_target_value3;
>>  	 * evmcs->tpr_threshold = vmcs12->tpr_threshold;
>>  	 * evmcs->virtual_processor_id = vmcs12->virtual_processor_id;
>>  	 * evmcs->exception_bitmap = vmcs12->exception_bitmap;
>> @@ -5540,15 +5532,6 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
>>  				return true;
>>  			break;
>>  		case 3:
>> -			if ((vmcs12->cr3_target_count >= 1 &&
>> -					vmcs12->cr3_target_value0 == val) ||
>> -				(vmcs12->cr3_target_count >= 2 &&
>> -					vmcs12->cr3_target_value1 == val) ||
>> -				(vmcs12->cr3_target_count >= 3 &&
>> -					vmcs12->cr3_target_value2 == val) ||
>> -				(vmcs12->cr3_target_count >= 4 &&
>> -					vmcs12->cr3_target_value3 == val))
>> -				return false;
>>  			if (nested_cpu_has(vmcs12, CPU_BASED_CR3_LOAD_EXITING))
>>  				return true;
>>  			break;
>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>> index 53dfb401316d..c8e51c004f78 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.c
>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>> @@ -115,10 +115,6 @@ const unsigned short vmcs_field_to_offset_table[] = {
>>  	FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask),
>>  	FIELD(CR0_READ_SHADOW, cr0_read_shadow),
>>  	FIELD(CR4_READ_SHADOW, cr4_read_shadow),
>> -	FIELD(CR3_TARGET_VALUE0, cr3_target_value0),
>> -	FIELD(CR3_TARGET_VALUE1, cr3_target_value1),
>> -	FIELD(CR3_TARGET_VALUE2, cr3_target_value2),
>> -	FIELD(CR3_TARGET_VALUE3, cr3_target_value3),
>>  	FIELD(EXIT_QUALIFICATION, exit_qualification),
>>  	FIELD(GUEST_LINEAR_ADDRESS, guest_linear_address),
>>  	FIELD(GUEST_CR0, guest_cr0),
>> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>> index d0c6df373f67..80232daf00ff 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.h
>> +++ b/arch/x86/kvm/vmx/vmcs12.h
>> @@ -80,10 +80,7 @@ struct __packed vmcs12 {
>>  	natural_width cr4_guest_host_mask;
>>  	natural_width cr0_read_shadow;
>>  	natural_width cr4_read_shadow;
>> -	natural_width cr3_target_value0;
>> -	natural_width cr3_target_value1;
>> -	natural_width cr3_target_value2;
>> -	natural_width cr3_target_value3;
>> +	natural_width dead_space[4]; /* Last remnants of cr3_target_value[0-3]. */
>>  	natural_width exit_qualification;
>>  	natural_width guest_linear_address;
>>  	natural_width guest_cr0;
>> @@ -263,10 +260,7 @@ static inline void vmx_check_vmcs12_offsets(void)
>>  	CHECK_OFFSET(cr4_guest_host_mask, 352);
>>  	CHECK_OFFSET(cr0_read_shadow, 360);
>>  	CHECK_OFFSET(cr4_read_shadow, 368);
>> -	CHECK_OFFSET(cr3_target_value0, 376);
>> -	CHECK_OFFSET(cr3_target_value1, 384);
>> -	CHECK_OFFSET(cr3_target_value2, 392);
>> -	CHECK_OFFSET(cr3_target_value3, 400);
>> +	CHECK_OFFSET(dead_space, 376);
>>  	CHECK_OFFSET(exit_qualification, 408);
>>  	CHECK_OFFSET(guest_linear_address, 416);
>>  	CHECK_OFFSET(guest_cr0, 424);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index aa1b8cf7c915..1ba7722445cc 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5711,7 +5711,6 @@ void dump_vmcs(void)
>>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>>  	unsigned long cr4;
>>  	u64 efer;
>> -	int i, n;
>>  
>>  	if (!dump_invalid_vmcs) {
>>  		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
>> @@ -5848,14 +5847,6 @@ void dump_vmcs(void)
>>  		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
>>  	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
>>  		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
>> -	n = vmcs_read32(CR3_TARGET_COUNT);
>> -	for (i = 0; i + 1 < n; i += 4)
>> -		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
>> -		       i, vmcs_readl(CR3_TARGET_VALUE0 + i * 2),
>> -		       i + 1, vmcs_readl(CR3_TARGET_VALUE0 + i * 2 + 2));
>> -	if (i < n)
>> -		pr_err("CR3 target%u=%016lx\n",
>> -		       i, vmcs_readl(CR3_TARGET_VALUE0 + i * 2));
>>  	if (secondary_exec_control & SECONDARY_EXEC_PAUSE_LOOP_EXITING)
>>  		pr_err("PLE Gap=%08x Window=%08x\n",
>>  		       vmcs_read32(PLE_GAP), vmcs_read32(PLE_WINDOW));
> 

