Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118A511C3A6
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfLLC7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:59:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:28489 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbfLLC7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 21:59:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 18:59:05 -0800
X-IronPort-AV: E=Sophos;i="5.69,304,1571727600"; 
   d="scan'208";a="207921632"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 11 Dec 2019 18:59:02 -0800
Subject: Re: [PATCH 0/6] Fix various comment errors
To:     linmiaohe <linmiaohe@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <88f5931859484959bd80a48edbbe1104@huawei.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <fce8ec66-ba21-1705-8fa7-a9614e7e88ad@intel.com>
Date:   Thu, 12 Dec 2019 10:59:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <88f5931859484959bd80a48edbbe1104@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/12/2019 10:08 AM, linmiaohe wrote:
> Sean Christopherson wrote:
>> On Wed, Dec 11, 2019 at 02:26:19PM +0800, linmiaohe wrote:
>>> From: Miaohe Lin <linmiaohe@huawei.com>
>>>
>>> Miaohe Lin (6):
>>>    KVM: Fix some wrong function names in comment
>>>    KVM: Fix some out-dated function names in comment
>>>    KVM: Fix some comment typos and missing parentheses
>>>    KVM: Fix some grammar mistakes
>>>    KVM: hyperv: Fix some typos in vcpu unimpl info
>>>    KVM: Fix some writing mistakes
>>
>> Regarding the patch organizing, I'd probably group the comment changes based on what files they touch as opposed to what type of comment issue they're fixing.
>>
>> E.g. three patches for the comments
>>
>>    KVM: VMX: Fix comment blah blah blah
>>    KVM: x86: Fix comment blah blah blah
>>    KVM: Fix comment blah blah blah
>>
>> and one patch for the print typo in hyperv
>>
>>    KVM: hyperv: Fix some typos in vcpu unimpl info
>>
>> For KVM, the splits don't matter _that_ much since they more or less all get routed through the maintainers/reviewers, but it is nice when patches can be contained to specific subsystems/areas as it allows people to easily skip over patches that aren't relevant to them.
>>
> 
> Many thanks for your advice and patient explanation. I feel sorry for my poor patch organizing.
> I would reorganize my patches. Thanks again.
>   

Could you please use the "In-Reply-To" tag when you reply a mail next 
time? Otherwise every replying mail from you is listed as a separate 
one, but not folded into the initial thread in my mail client.


