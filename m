Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474EC4C542E
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 07:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiBZGY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 01:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiBZGY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 01:24:58 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F00E1B60A0;
        Fri, 25 Feb 2022 22:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645856664; x=1677392664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6NDN5CC3sNkLdFtMgBQbVidTFFoFtWsoQ71OsAZXaLI=;
  b=GyVwX/2hVpl6scABRGwUbZZxYY+Q5oXOlrnO0SPYF9CPLTLK4MjhRukC
   22wdrO1cbZnbEIhw1FwNS6dU2Gw5aFjmMjLTIc6P827SjFSjHBrSwH/i6
   efygnyAj9HIkI7Txu8Q6cSYzvMTSXRC5dcL1TRQ5ZED4p4TEraCBndMMf
   Oxhqci5tWAtBJuC7x8rGyM8tGnN2oTQFAPB43D7oJ/dCqBJaJVVIp7zuE
   0A9MKdE+a13DKC4il3khGJtKkhAVUz+vw1F5krIZugJaXRl7Z8ZTUjgma
   8N2FZ+TgF+l5jQGbWit0kb2pHSvtRlqjYrkaR1FCM3Il3dpWkDGbdTkwW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10269"; a="240041289"
X-IronPort-AV: E=Sophos;i="5.90,138,1643702400"; 
   d="scan'208";a="240041289"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 22:24:23 -0800
X-IronPort-AV: E=Sophos;i="5.90,138,1643702400"; 
   d="scan'208";a="509505376"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.136]) ([10.255.28.136])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 22:24:21 -0800
Message-ID: <71736b9d-9ed4-ea02-e702-74cae0340d66@intel.com>
Date:   Sat, 26 Feb 2022 14:24:19 +0800
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eS6cBDuax8O=woSdkNH2e2Y2EodE-7EfUTFfzBvCWCmcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/26/2022 12:53 PM, Jim Mattson wrote:
> On Fri, Feb 25, 2022 at 8:25 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Feb 25, 2022 at 8:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>
>>> On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
>>>> On 2/25/22 16:12, Xiaoyao Li wrote:
>>>>>>>>
>>>>>>>
>>>>>>> I don't like the idea of making things up without notifying userspace
>>>>>>> that this is fictional. How is my customer running nested VMs supposed
>>>>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
>>>>>>> notify window was exceeded? If this information isn't reported to
>>>>>>> userspace, I have no way of getting the information to the customer.
>>>>>>
>>>>>> Then, maybe a dedicated software define VM exit for it instead of
>>>>>> reusing triple fault?
>>>>>>
>>>>>
>>>>> Second thought, we can even just return Notify VM exit to L1 to tell
>>>>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed
>>>>> to L1.
>>>>
>>>> That might cause NULL pointer dereferences or other nasty occurrences.
>>>
>>> IMO, a well written VMM (in L1) should handle it correctly.
>>>
>>> L0 KVM reports no Notify VM Exit support to L1, so L1 runs without
>>> setting Notify VM exit. If a L2 causes notify_vm_exit with
>>> invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no
>>> support of Notify VM Exit from VMX MSR capability. Following L1 handler
>>> is possible:
>>>
>>> a)      if (notify_vm_exit available & notify_vm_exit enabled) {
>>>                  handle in b)
>>>          } else {
>>>                  report unexpected vm exit reason to userspace;
>>>          }
>>>
>>> b)      similar handler like we implement in KVM:
>>>          if (!vm_context_invalid)
>>>                  re-enter guest;
>>>          else
>>>                  report to userspace;
>>>
>>> c)      no Notify VM Exit related code (e.g. old KVM), it's treated as
>>> unsupported exit reason
>>>
>>> As long as it belongs to any case above, I think L1 can handle it
>>> correctly. Any nasty occurrence should be caused by incorrect handler in
>>> L1 VMM, in my opinion.
>>
>> Please test some common hypervisors (e.g. ESXi and Hyper-V).
> 
> I took a look at KVM in Linux v4.9 (one of our more popular guests),
> and it will not handle this case well:
> 
>          if (exit_reason < kvm_vmx_max_exit_handlers
>              && kvm_vmx_exit_handlers[exit_reason])
>                  return kvm_vmx_exit_handlers[exit_reason](vcpu);
>          else {
>                  WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
>                  kvm_queue_exception(vcpu, UD_VECTOR);
>                  return 1;
>          }
> 
> At least there's an L1 kernel log message for the first unexpected
> NOTIFY VM-exit, but after that, there is silence. Just a completely
> inexplicable #UD in L2, assuming that L2 is resumable at this point.

At least there is a message to tell L1 a notify VM exit is triggered in 
L2. Yes, the inexplicable #UD won't be hit unless L2 triggers Notify VM 
exit with invalid_context, which is malicious to L0 and L1.

If we use triple_fault (i.e., shutdown), then no info to tell L1 that 
it's caused by Notify VM exit with invalid context. Triple fault needs 
to be extended and L1 kernel needs to be enlightened. It doesn't help 
old guest kernel.

If we use Machine Check, it's somewhat same inexplicable to L2 unless 
it's enlightened. But it doesn't help old guest kernel.

Anyway, for Notify VM exit with invalid context from L2, I don't see a 
good solution to tell L1 VMM it's a "Notify VM exit with invalid context 
from L2" and keep all kinds of L1 VMM happy, especially for those with 
old kernel versions.


