Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87252AE612
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 02:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgKKByN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 20:54:13 -0500
Received: from mga18.intel.com ([134.134.136.126]:59066 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgKKByN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 20:54:13 -0500
IronPort-SDR: Oeo99zLvWi8gpHfgHiBmWZTM/nj0iVYvZjhu5yb8chZUpA9W+8P9N6HVJ8bBGjuprhmX+qMicb
 7wNPzRpEN+Aw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="157859877"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="157859877"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 17:54:12 -0800
IronPort-SDR: ShTzttbpJhhVObE/uPGQ1IIFtcRrMq7lyomvqLLTwyUUcEfjzmRgzv90n2+1Gt8I8DklUw7iH+
 2JS2VnhT6hMw==
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="541585162"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 17:54:10 -0800
Subject: Re: [PATCH 4/5 v4] KVM: VMX: Fill in conforming vmx_x86_ops via macro
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org,
        sean.j.christopherson@intel.com, jmattson@google.com
References: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
 <20201110012312.20820-5-krish.sadhukhan@oracle.com>
 <0ef40499-77b8-587a-138d-9b612ae9ae8c@linux.intel.com>
 <e9819b87-c4e0-d15b-80b8-637ecb74f1c3@oracle.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <159af74f-15d3-9c90-8a39-e24715255144@intel.com>
Date:   Wed, 11 Nov 2020 09:54:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <e9819b87-c4e0-d15b-80b8-637ecb74f1c3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/11 3:02, Krish Sadhukhan wrote:
>
> On 11/9/20 5:49 PM, Like Xu wrote:
>> Hi Krish,
>>
>> On 2020/11/10 9:23, Krish Sadhukhan wrote:
>>> @@ -1192,7 +1192,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state 
>>> *host, u16 fs_sel, u16 gs_sel,
>>>       }
>>>   }
>>>   -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>>> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu)
>>
>> What do you think of renaming it to
>>
>>     void vmx_prepare_switch_for_guest(struct kvm_vcpu *vcpu)；
>
>
> In my opinion, it sounds a bit odd as we usually say, "switch to 
> something". :-)
>
> From that perspective, {svm|vmx}_prepare_switch_to_guest is probably the 
> best name to keep.

Ah, I'm fine with the original one and thank you.

>
>
>>
>> ?
>>
>> Thanks,
>> Like Xu
>>
>>>   {
>>>       struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>       struct vmcs_host_state *host_state;
>>>
>>> @@ -311,7 +311,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int 
>>> cpu,
>>>   int allocate_vpid(void);
>>>   void free_vpid(int vpid);
>>>   void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
>>> -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>>> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu);
>>>   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 
>>> gs_sel,
>>>               unsigned long fs_base, unsigned long gs_base);
>>>   int vmx_get_cpl(struct kvm_vcpu *vcpu);
>>

