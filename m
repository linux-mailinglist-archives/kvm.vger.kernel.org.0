Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473124C63A6
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 08:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiB1HLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 02:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiB1HLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 02:11:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72F673D7;
        Sun, 27 Feb 2022 23:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646032235; x=1677568235;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y3vWJXmXIxLoqN+LR4JyPDGHfXzsrgmgo7NHZTRsoHs=;
  b=cBuXZMRxf4NjsVNjoSJKpL2ZYVz+ioLipzZ4i12f3DbUOtYZkcKqr3h4
   fV4sV06ycBF42zMwRN+z4m45NMx3w7VgS+aVUmn0gjIy82Cp20QpCavEi
   8OMJKZI5sKIKhIy6O2Pm0HW/uz/1ffy7O901nJKTwuBerLzYvlEzpu5L4
   TQbDaY5hEhVLr6vLUGrbdUp6LEOF2Wstnb5L24mGo013hFg68rB42eGHZ
   Ba0KU4l4wK11RlILN85R5fsnqSDERBLNZ/mxhX0PO40oFR+mtVnLNJxY2
   sKhK3uLDUzqz7rtw6MjiysRwv0X/5UB5Fd82RXmCmpDQStD1GC5mMqfxK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="277475029"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="277475029"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 23:10:35 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="534337928"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.39]) ([10.255.29.39])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 23:10:32 -0800
Message-ID: <4b2ddc09-f68d-1cc3-3d10-f7651d811fc3@intel.com>
Date:   Mon, 28 Feb 2022 15:10:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
 <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
 <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
 <bcc83b3d-31fe-949a-6bbf-4615bb982f0c@intel.com>
 <CALMp9eT1NRudtVqPuHU8Y8LpFYWZsAB_MnE2BAbg5NY0jR823w@mail.gmail.com>
 <CALMp9eS6cBDuax8O=woSdkNH2e2Y2EodE-7EfUTFfzBvCWCmcg@mail.gmail.com>
 <71736b9d-9ed4-ea02-e702-74cae0340d66@intel.com>
 <CALMp9eRwKHa0zdUFtSEBVCwV=MHJ-FmvW1uERxCt+_+Zz4z8fg@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eRwKHa0zdUFtSEBVCwV=MHJ-FmvW1uERxCt+_+Zz4z8fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/26/2022 10:24 PM, Jim Mattson wrote:
> On Fri, Feb 25, 2022 at 10:24 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 2/26/2022 12:53 PM, Jim Mattson wrote:
>>> On Fri, Feb 25, 2022 at 8:25 PM Jim Mattson <jmattson@google.com> wrote:
>>>>
>>>> On Fri, Feb 25, 2022 at 8:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>>
>>>>> On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
>>>>>> On 2/25/22 16:12, Xiaoyao Li wrote:
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I don't like the idea of making things up without notifying userspace
>>>>>>>>> that this is fictional. How is my customer running nested VMs supposed
>>>>>>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
>>>>>>>>> notify window was exceeded? If this information isn't reported to
>>>>>>>>> userspace, I have no way of getting the information to the customer.
>>>>>>>>
>>>>>>>> Then, maybe a dedicated software define VM exit for it instead of
>>>>>>>> reusing triple fault?
>>>>>>>>
>>>>>>>
>>>>>>> Second thought, we can even just return Notify VM exit to L1 to tell
>>>>>>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed
>>>>>>> to L1.
>>>>>>
>>>>>> That might cause NULL pointer dereferences or other nasty occurrences.
>>>>>
>>>>> IMO, a well written VMM (in L1) should handle it correctly.
>>>>>
>>>>> L0 KVM reports no Notify VM Exit support to L1, so L1 runs without
>>>>> setting Notify VM exit. If a L2 causes notify_vm_exit with
>>>>> invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no
>>>>> support of Notify VM Exit from VMX MSR capability. Following L1 handler
>>>>> is possible:
>>>>>
>>>>> a)      if (notify_vm_exit available & notify_vm_exit enabled) {
>>>>>                   handle in b)
>>>>>           } else {
>>>>>                   report unexpected vm exit reason to userspace;
>>>>>           }
>>>>>
>>>>> b)      similar handler like we implement in KVM:
>>>>>           if (!vm_context_invalid)
>>>>>                   re-enter guest;
>>>>>           else
>>>>>                   report to userspace;
>>>>>
>>>>> c)      no Notify VM Exit related code (e.g. old KVM), it's treated as
>>>>> unsupported exit reason
>>>>>
>>>>> As long as it belongs to any case above, I think L1 can handle it
>>>>> correctly. Any nasty occurrence should be caused by incorrect handler in
>>>>> L1 VMM, in my opinion.
>>>>
>>>> Please test some common hypervisors (e.g. ESXi and Hyper-V).
>>>
>>> I took a look at KVM in Linux v4.9 (one of our more popular guests),
>>> and it will not handle this case well:
>>>
>>>           if (exit_reason < kvm_vmx_max_exit_handlers
>>>               && kvm_vmx_exit_handlers[exit_reason])
>>>                   return kvm_vmx_exit_handlers[exit_reason](vcpu);
>>>           else {
>>>                   WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
>>>                   kvm_queue_exception(vcpu, UD_VECTOR);
>>>                   return 1;
>>>           }
>>>
>>> At least there's an L1 kernel log message for the first unexpected
>>> NOTIFY VM-exit, but after that, there is silence. Just a completely
>>> inexplicable #UD in L2, assuming that L2 is resumable at this point.
>>
>> At least there is a message to tell L1 a notify VM exit is triggered in
>> L2. Yes, the inexplicable #UD won't be hit unless L2 triggers Notify VM
>> exit with invalid_context, which is malicious to L0 and L1.
> 
> There is only an L1 kernel log message *the first time*. That's not
> good enough. And this is just one of the myriad of possible L1
> hypervisors.
> 
>> If we use triple_fault (i.e., shutdown), then no info to tell L1 that
>> it's caused by Notify VM exit with invalid context. Triple fault needs
>> to be extended and L1 kernel needs to be enlightened. It doesn't help
>> old guest kernel.
>>
>> If we use Machine Check, it's somewhat same inexplicable to L2 unless
>> it's enlightened. But it doesn't help old guest kernel.
>>
>> Anyway, for Notify VM exit with invalid context from L2, I don't see a
>> good solution to tell L1 VMM it's a "Notify VM exit with invalid context
>> from L2" and keep all kinds of L1 VMM happy, especially for those with
>> old kernel versions.
> 
> I agree that there is no way to make every conceivable L1 happy.
> That's why the information needs to be surfaced to the L0 userspace. I
> contend that any time L0 kvm violates the architectural specification
> in its emulation of L1 or L2, the L0 userspace *must* be informed.

We can make the design to exit to userspace on notify vm exit 
unconditionally with exit_qualification passed, then userspace can take 
the same action like what this patch does in KVM that

  - re-enter guest when context_invalid is false;
  - stop running the guest if context_invalid is true; (userspace can 
definitely re-enter the guest in this case, but it needs to take the 
fall on this)

Then, for nested case, L0 needs to enable it transparently for L2 if 
this feature is enabled for L1 guest (the reason as we all agreed that 
cannot allow L1 to escape just by creating a L2). Then what should KVM 
do when notify vm exit from L2?

  - Exit to L0 userspace on L2's notify vm exit. L0 userspace takes the 
same action:
	- re-enter if context-invalid is false;
	- kill L1 if context-invalid is true; (I don't know if there is any 
interface for L0 userspace to kill L2). Then it opens the potential door 
for malicious user to kill L1 by creating a L2 to trigger fatal notify 
vm exit. If you guys accept it, we can implement in this way.


in conclusion, we have below solution:

1. Take this patch as is. The drawback is L1 VMM receives a triple_fault 
from L2 when L2 triggers notify vm exit with invalid context. Neither of 
L1 VMM, L1 userspace, nor L2 kernel know it's caused due to notify vm 
exit. There is only kernel log in L0, which seems not accessible for L1 
user or L2 guest.

2. a) Inject notify vm exit back to L1 if L2 triggers notify vm exit 
with invalid context. The drawback is, old L1 hypervisor is not 
enlightened of it and maybe misbehave on it.

    b) Inject a synthesized SHUTDOWN exit to L1, with additional info to 
tell it's caused by fatal notify vm exit from L2. It has the same 
drawback that old hypervisor has no idea of it and maybe misbehave on it.

3. Exit to L0 usersapce unconditionally no matter it's caused from L1 or 
L2. Then it may open the door for L1 user to kill L1.

Do you have any better solution other than above? If no, we need to pick 
one from above though it cannot make everyone happy.

thanks,
-Xiaoyao
