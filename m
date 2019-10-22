Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE2FDF9F4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfJVA51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:57:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:11591 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbfJVA50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:57:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:57:26 -0700
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="191296939"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 21 Oct 2019 17:57:24 -0700
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
 <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
 <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
 <11318bab-a377-bb8c-b881-76331c92f11e@intel.com>
 <10300339-e4cb-57b0-ac2f-474604551df0@redhat.com>
 <20191017160508.GA20903@linux.intel.com>
 <c2e40175-4d17-f2c5-4d92-94cedd5ff49c@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <93bb79d0-287b-c7e9-59a2-1e30d1f5500b@intel.com>
Date:   Tue, 22 Oct 2019 08:57:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c2e40175-4d17-f2c5-4d92-94cedd5ff49c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/2019 9:09 PM, Paolo Bonzini wrote:
> On 17/10/19 18:05, Sean Christopherson wrote:
>> On Wed, Oct 16, 2019 at 11:41:05AM +0200, Paolo Bonzini wrote:
>>> On 16/10/19 09:48, Xiaoyao Li wrote:
>>>> BTW, could you have a look at the series I sent yesterday to refactor
>>>> the vcpu creation flow, which is inspired partly by this issue. Any
>>>> comment and suggestion is welcomed since I don't want to waste time on
>>>> wrong direction.
>>>
>>> Yes, that's the series from which I'll take your patch.
>>
>> Can you hold off on taking that patch?  I'm pretty sure we can do more
>> cleanup in that area, with less code.
>>
> 
> Should I hold off on the whole "Refactor vcpu creation flow of x86 arch"
> series then?
> 
Yes, please just leave them aside.
If could, you can have an eye on my "v3 Minor cleanup and refactor about 
vmcs"

Thanks,
-Xiaoyao
