Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04B6D8A29
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391237AbfJPHs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:48:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:7172 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbfJPHs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 03:48:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 00:48:27 -0700
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="186076888"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Oct 2019 00:48:26 -0700
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
 <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
 <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <11318bab-a377-bb8c-b881-76331c92f11e@intel.com>
Date:   Wed, 16 Oct 2019 15:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 3:35 PM, Paolo Bonzini wrote:
> On 16/10/19 03:52, Xiaoyao Li wrote:
>>>
>>> user_fpu could be made percpu too...  That would save a bit of memory
>>> for each vCPU.  I'm holding on Xiaoyao's patch because a lot of the code
>>> he's touching would go away then.
>>
>> Sorry, I don't get clear your attitude.
>> Do you mean the generic common function is not so better that I'd better
>> to implement the percpu solution?
> 
> I wanted some time to give further thought to the percpu user_fpu idea.
>   But kvm_load_guest_fpu and kvm_put_guest_fpu are not part of vcpu_load,
> so it would not be so easy.  I'll just apply your patch now.

Got it, thanks.

BTW, could you have a look at the series I sent yesterday to refactor 
the vcpu creation flow, which is inspired partly by this issue. Any 
comment and suggestion is welcomed since I don't want to waste time on 
wrong direction.

