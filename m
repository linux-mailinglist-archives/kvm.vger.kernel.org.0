Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E878C52CBE3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 08:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiESGZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 02:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbiESGZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 02:25:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEE995A1E;
        Wed, 18 May 2022 23:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652941526; x=1684477526;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=B/9YWpvo5Bm8F0JN75mKjZURG8vCI71tfnXV4sudZqw=;
  b=Jpith/pCYfY3kKGxdEORsmgfcOnB+40XssZvBOmn/qycOuufVXA9urZu
   ihPWx6WV9yKVasGV5QBQh/anBsvnFEi3ETnKOUSGxj89AVCJ9pA3pYQWB
   KlbEGSeHBPqxrJaUFewv7W9OkJ9QEOI8mmjphvoLsOO2s/jSp1WQnOtm2
   Xr0TkjOOHYUBRFh4F7+RtMvmcr/Pg9gqVsSLxb1PQqV26ajOiQMHKtHuk
   ptWiT2KBQ6Fz4AmZHxVojNHpWEO7ZWrlsJVHEJLJCLYnKERX869C5or9W
   ibTGq3fHmXZJMwPLJBuRQbPkYAbVZ6rSGIi7IC3EntWhBuiKHOCi42J5/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="358450422"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="358450422"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 23:25:25 -0700
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="598343905"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.255.31.60]) ([10.255.31.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 23:25:22 -0700
Message-ID: <e274336a-fd97-6b63-f1ac-c31ffdf4b13a@intel.com>
Date:   Thu, 19 May 2022 14:25:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v6 1/3] KVM: X86: Save&restore the triple fault request
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <20220421072958.16375-2-chenyi.qiang@intel.com> <YoU+LgHbeiYNbDJ8@google.com>
Content-Language: en-US
In-Reply-To: <YoU+LgHbeiYNbDJ8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Sean for your review!

On 5/19/2022 2:42 AM, Sean Christopherson wrote:
> Nits on the shortlog...
> 
> Please don't capitalize x86, spell out "and" instead of using an ampersand (though
> I think it can be omitted entirely), and since there are plenty of chars left, call
> out that this is adding/extending KVM's ABI, e.g. it's not obvious from the shortlog
> where/when the save+restore happens.
> 
>    KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault
> 

Will fix it.

> On Thu, Apr 21, 2022, Chenyi Qiang wrote:
>> For the triple fault sythesized by KVM, e.g. the RSM path or
>> nested_vmx_abort(), if KVM exits to userspace before the request is
>> serviced, userspace could migrate the VM and lose the triple fault.
>>
>> Add the support to save and restore the triple fault event from
>> userspace. Introduce a new event KVM_VCPUEVENT_VALID_TRIPLE_FAULT in
>> get/set_vcpu_events to track the triple fault request.
>>
>> Note that in the set_vcpu_events path, userspace is able to set/clear
>> the triple fault request through triple_fault_pending field.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   Documentation/virt/kvm/api.rst  |  7 +++++++
>>   arch/x86/include/uapi/asm/kvm.h |  4 +++-
>>   arch/x86/kvm/x86.c              | 15 +++++++++++++--
>>   3 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 72183ae628f7..e09ce3cb49c5 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -1150,6 +1150,9 @@ The following bits are defined in the flags field:
>>     fields contain a valid state. This bit will be set whenever
>>     KVM_CAP_EXCEPTION_PAYLOAD is enabled.
>>   
>> +- KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
>> +  triple_fault_pending field contains a valid state.
>> +
>>   ARM64:
>>   ^^^^^^
>>   
>> @@ -1245,6 +1248,10 @@ can be set in the flags field to signal that the
>>   exception_has_payload, exception_payload, and exception.pending fields
>>   contain a valid state and shall be written into the VCPU.
>>   
>> +KVM_VCPUEVENT_VALID_TRIPLE_FAULT can be set in flags field to signal that
>> +the triple_fault_pending field contains a valid state and shall be written
>> +into the VCPU.
>> +
>>   ARM64:
>>   ^^^^^^
>>   
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 21614807a2cb..fd083f6337af 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>>   #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>>   #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>>   #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
>> +#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
>>   
>>   /* Interrupt shadow states */
>>   #define KVM_X86_SHADOW_INT_MOV_SS	0x01
>> @@ -359,7 +360,8 @@ struct kvm_vcpu_events {
>>   		__u8 smm_inside_nmi;
>>   		__u8 latched_init;
>>   	} smi;
>> -	__u8 reserved[27];
>> +	__u8 triple_fault_pending;
> 
> What about writing this as
> 
> 	struct {
> 		__u8 pending;
> 	} triple_fault;
> 
> to match the other events?  It's kinda silly, but I find it easier to visually
> identify the various events that are handled by kvm_vcpu_events.
> 

Sure, will change in this format.

>> +	__u8 reserved[26];
>>   	__u8 exception_has_payload;
>>   	__u64 exception_payload;
>>   };
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ab336f7c82e4..c8b9b0bc42aa 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4911,9 +4911,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>>   		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
>>   	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
>>   
>> +	events->triple_fault_pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>> +
>>   	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
>>   			 | KVM_VCPUEVENT_VALID_SHADOW
>> -			 | KVM_VCPUEVENT_VALID_SMM);
>> +			 | KVM_VCPUEVENT_VALID_SMM
>> +			 | KVM_VCPUEVENT_VALID_TRIPLE_FAULT);
> 
> Does setting KVM_VCPUEVENT_VALID_TRIPLE_FAULT need to be guarded with a capability,
> a la KVM_CAP_EXCEPTION_PAYLOAD, so that migrating from a new KVM to an old KVM doesn't
> fail?  Seems rather pointless since the VM is likely hosed either way...
> 

Indeed, at least adding a capability makes it more compatible. Will add 
it in next version.

>>   	if (vcpu->kvm->arch.exception_payload_enabled)
>>   		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
