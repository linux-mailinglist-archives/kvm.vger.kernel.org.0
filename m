Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A11D859F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 03:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732405AbfJPBwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 21:52:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:21397 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbfJPBwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 21:52:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 18:52:42 -0700
X-IronPort-AV: E=Sophos;i="5.67,302,1566889200"; 
   d="scan'208";a="186007667"
Received: from unknown (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 15 Oct 2019 18:52:40 -0700
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
Date:   Wed, 16 Oct 2019 09:52:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/2019 5:28 PM, Paolo Bonzini wrote:
> On 14/10/19 18:58, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
>>> and SVM. Make them common functions.
>>>
>>> No functional change intended.
>> Would it rather make sense to move this code to
>> kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?
>>
> 
> user_fpu could be made percpu too...  That would save a bit of memory
> for each vCPU.  I'm holding on Xiaoyao's patch because a lot of the code
> he's touching would go away then.

Sorry, I don't get clear your attitude.
Do you mean the generic common function is not so better that I'd better 
to implement the percpu solution?

> Paolo
> 
