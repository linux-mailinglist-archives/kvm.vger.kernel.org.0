Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66F24C832C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 06:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiCAFbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 00:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiCAFbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 00:31:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8AB583B8;
        Mon, 28 Feb 2022 21:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646112626; x=1677648626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bjaW5JFpYRgCZ1ZUrDguTTDWqAsb6zghwNhf4YjYQQo=;
  b=KqtajOJSJ3Lwpp/UtmkvRS00wUf8TmZ3jvlxydnUPDkrZPZPncZHokR5
   2QnUY9qU1uH3DQyFU0hpETIJVuKniskT6j1zq8EeajKiB8k5bdLWHTGSP
   /swwf2QsP/XlRukpMTZGTbJYpROM7otM6UPPnARj5DzJHStMNNTOUtqZI
   kAFK2fof2KeJCS31mPzSQIC2NBvKXBlg5BsAqru1eiSda3a/aygqs4tOW
   n3m/SQ2hVHXiCEGFFhhE3r3PUlhi94thjh2MNcXb9s9pMXXrAQBi46pg8
   xk8A18tnOSyHC4nN+rgVHLL7SQ01ie6qVA6ovkerOncGQ0qPmVoDV7KdR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="240471082"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="240471082"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 21:30:26 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="534757977"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.67]) ([10.255.30.67])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 21:30:23 -0800
Message-ID: <91859fc0-82e0-cb74-e519-68f08c9c796d@intel.com>
Date:   Tue, 1 Mar 2022 13:30:21 +0800
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
 <4b2ddc09-f68d-1cc3-3d10-f7651d811fc3@intel.com>
 <CALMp9eQj4Xr9VAdHw4BfPEskQYptEYYHRrpmFfVU1TCQJmHwug@mail.gmail.com>
 <1cca344e-1c2d-8ebf-87ae-d9298a73306a@intel.com>
 <CALMp9eR_gPSAkSHtgOjAqJDEXF-=8aaoV0nXP3GmZ_J9sTBJFg@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eR_gPSAkSHtgOjAqJDEXF-=8aaoV0nXP3GmZ_J9sTBJFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/2022 12:32 PM, Jim Mattson wrote:
> On Mon, Feb 28, 2022 at 5:41 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 2/28/2022 10:30 PM, Jim Mattson wrote:
>>> On Sun, Feb 27, 2022 at 11:10 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>
>>>> On 2/26/2022 10:24 PM, Jim Mattson wrote:
>>>>> On Fri, Feb 25, 2022 at 10:24 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>>>
>>>>>> On 2/26/2022 12:53 PM, Jim Mattson wrote:
>>>>>>> On Fri, Feb 25, 2022 at 8:25 PM Jim Mattson <jmattson@google.com> wrote:
>>>>>>>>
>>>>>>>> On Fri, Feb 25, 2022 at 8:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>>>>>>
>>>>>>>>> On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
>>>>>>>>>> On 2/25/22 16:12, Xiaoyao Li wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> I don't like the idea of making things up without notifying userspace
>>>>>>>>>>>>> that this is fictional. How is my customer running nested VMs supposed
>>>>>>>>>>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
>>>>>>>>>>>>> notify window was exceeded? If this information isn't reported to
>>>>>>>>>>>>> userspace, I have no way of getting the information to the customer.
>>>>>>>>>>>>
>>>>>>>>>>>> Then, maybe a dedicated software define VM exit for it instead of
>>>>>>>>>>>> reusing triple fault?
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Second thought, we can even just return Notify VM exit to L1 to tell
>>>>>>>>>>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed
>>>>>>>>>>> to L1.
>>>>>>>>>>
>>>>>>>>>> That might cause NULL pointer dereferences or other nasty occurrences.
>>>>>>>>>
>>>>>>>>> IMO, a well written VMM (in L1) should handle it correctly.
>>>>>>>>>
>>>>>>>>> L0 KVM reports no Notify VM Exit support to L1, so L1 runs without
>>>>>>>>> setting Notify VM exit. If a L2 causes notify_vm_exit with
>>>>>>>>> invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no
>>>>>>>>> support of Notify VM Exit from VMX MSR capability. Following L1 handler
>>>>>>>>> is possible:
>>>>>>>>>
>>>>>>>>> a)      if (notify_vm_exit available & notify_vm_exit enabled) {
>>>>>>>>>                     handle in b)
>>>>>>>>>             } else {
>>>>>>>>>                     report unexpected vm exit reason to userspace;
>>>>>>>>>             }
>>>>>>>>>
>>>>>>>>> b)      similar handler like we implement in KVM:
>>>>>>>>>             if (!vm_context_invalid)
>>>>>>>>>                     re-enter guest;
>>>>>>>>>             else
>>>>>>>>>                     report to userspace;
>>>>>>>>>
>>>>>>>>> c)      no Notify VM Exit related code (e.g. old KVM), it's treated as
>>>>>>>>> unsupported exit reason
>>>>>>>>>
>>>>>>>>> As long as it belongs to any case above, I think L1 can handle it
>>>>>>>>> correctly. Any nasty occurrence should be caused by incorrect handler in
>>>>>>>>> L1 VMM, in my opinion.
>>>>>>>>
>>>>>>>> Please test some common hypervisors (e.g. ESXi and Hyper-V).
>>>>>>>
>>>>>>> I took a look at KVM in Linux v4.9 (one of our more popular guests),
>>>>>>> and it will not handle this case well:
>>>>>>>
>>>>>>>             if (exit_reason < kvm_vmx_max_exit_handlers
>>>>>>>                 && kvm_vmx_exit_handlers[exit_reason])
>>>>>>>                     return kvm_vmx_exit_handlers[exit_reason](vcpu);
>>>>>>>             else {
>>>>>>>                     WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
>>>>>>>                     kvm_queue_exception(vcpu, UD_VECTOR);
>>>>>>>                     return 1;
>>>>>>>             }
>>>>>>>
>>>>>>> At least there's an L1 kernel log message for the first unexpected
>>>>>>> NOTIFY VM-exit, but after that, there is silence. Just a completely
>>>>>>> inexplicable #UD in L2, assuming that L2 is resumable at this point.
>>>>>>
>>>>>> At least there is a message to tell L1 a notify VM exit is triggered in
>>>>>> L2. Yes, the inexplicable #UD won't be hit unless L2 triggers Notify VM
>>>>>> exit with invalid_context, which is malicious to L0 and L1.
>>>>>
>>>>> There is only an L1 kernel log message *the first time*. That's not
>>>>> good enough. And this is just one of the myriad of possible L1
>>>>> hypervisors.
>>>>>
>>>>>> If we use triple_fault (i.e., shutdown), then no info to tell L1 that
>>>>>> it's caused by Notify VM exit with invalid context. Triple fault needs
>>>>>> to be extended and L1 kernel needs to be enlightened. It doesn't help
>>>>>> old guest kernel.
>>>>>>
>>>>>> If we use Machine Check, it's somewhat same inexplicable to L2 unless
>>>>>> it's enlightened. But it doesn't help old guest kernel.
>>>>>>
>>>>>> Anyway, for Notify VM exit with invalid context from L2, I don't see a
>>>>>> good solution to tell L1 VMM it's a "Notify VM exit with invalid context
>>>>>> from L2" and keep all kinds of L1 VMM happy, especially for those with
>>>>>> old kernel versions.
>>>>>
>>>>> I agree that there is no way to make every conceivable L1 happy.
>>>>> That's why the information needs to be surfaced to the L0 userspace. I
>>>>> contend that any time L0 kvm violates the architectural specification
>>>>> in its emulation of L1 or L2, the L0 userspace *must* be informed.
>>>>
>>>> We can make the design to exit to userspace on notify vm exit
>>>> unconditionally with exit_qualification passed, then userspace can take
>>>> the same action like what this patch does in KVM that
>>>>
>>>>     - re-enter guest when context_invalid is false;
>>>>     - stop running the guest if context_invalid is true; (userspace can
>>>> definitely re-enter the guest in this case, but it needs to take the
>>>> fall on this)
>>>>
>>>> Then, for nested case, L0 needs to enable it transparently for L2 if
>>>> this feature is enabled for L1 guest (the reason as we all agreed that
>>>> cannot allow L1 to escape just by creating a L2). Then what should KVM
>>>> do when notify vm exit from L2?
>>>>
>>>>     - Exit to L0 userspace on L2's notify vm exit. L0 userspace takes the
>>>> same action:
>>>>           - re-enter if context-invalid is false;
>>>>           - kill L1 if context-invalid is true; (I don't know if there is any
>>>> interface for L0 userspace to kill L2). Then it opens the potential door
>>>> for malicious user to kill L1 by creating a L2 to trigger fatal notify
>>>> vm exit. If you guys accept it, we can implement in this way.
>>>>
>>>>
>>>> in conclusion, we have below solution:
>>>>
>>>> 1. Take this patch as is. The drawback is L1 VMM receives a triple_fault
>>>> from L2 when L2 triggers notify vm exit with invalid context. Neither of
>>>> L1 VMM, L1 userspace, nor L2 kernel know it's caused due to notify vm
>>>> exit. There is only kernel log in L0, which seems not accessible for L1
>>>> user or L2 guest.
>>>
>>> You are correct on that last point, and I feel that I cannot stress it
>>> enough. In a typical environment, the L0 kernel log is only available
>>> to the administrator of the L0 host.
>>>
>>>> 2. a) Inject notify vm exit back to L1 if L2 triggers notify vm exit
>>>> with invalid context. The drawback is, old L1 hypervisor is not
>>>> enlightened of it and maybe misbehave on it.
>>>>
>>>>       b) Inject a synthesized SHUTDOWN exit to L1, with additional info to
>>>> tell it's caused by fatal notify vm exit from L2. It has the same
>>>> drawback that old hypervisor has no idea of it and maybe misbehave on it.
>>>>
>>>> 3. Exit to L0 usersapce unconditionally no matter it's caused from L1 or
>>>> L2. Then it may open the door for L1 user to kill L1.
>>>>
>>>> Do you have any better solution other than above? If no, we need to pick> >> one from above though it cannot make everyone happy.
>>>
>>> Yes, I believe I have a better solution. We obviously need an API for
>>> userspace to synthesize a SHUTDOWN event for a vCPU.
>>
>> Can you elaborate on it? Do you mean userspace to inject a synthesized
>> SHUTDOWN to guest? If so, I have no idea how it will work.
> 
> It can probably be implemented as an extension of KVM_SET_VCPU_EVENTS
> that invokes kvm_make_request(KVM_REQ_TRIPLE_FAULT).

Then, you mean

1. notify vm exit from guest;
2. exit to userspace on notify vm exit;
3. a. if context_invalid, inject SHUTDOWN to vcpu from userspace to 
request KVM_REQ_TRIPLE_FAULT; goto step 4;
    b. if !context_invalid, re-run vcpu; no step 4 and 5;
4. exit to userspace again with KVM_EXIT_SHUTDOWN due to triple fault;
5. userspace stop running the vcpu/VM

Then why not handle it as KVM_EXIT_SHUTDOWN directly in 3.a ? I don't 
get the point of userspace to inject TRIPLE_FAULT to KVM.
