Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F555A7B1E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 08:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfIDGET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 02:04:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:58605 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfIDGES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 02:04:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 23:04:17 -0700
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="334095759"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 03 Sep 2019 23:04:16 -0700
Subject: Re: [PATCH] doc: kvm: fix return description of KVM_SET_MSRS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190902101214.77833-1-xiaoyao.li@intel.com>
 <20190903163332.GF10768@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2354b729-eed6-df82-64bb-4643beccdc80@intel.com>
Date:   Wed, 4 Sep 2019 14:04:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903163332.GF10768@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/2019 12:33 AM, Sean Christopherson wrote:
> On Mon, Sep 02, 2019 at 06:12:14PM +0800, Xiaoyao Li wrote:
> 
> It may seem silly, but a proper changelog would be helpful even here,
> e.g. to explain how and when a positive return value can diverge from the
> number of MSRs specific in struct kvm_msrs.
> 
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   Documentation/virt/kvm/api.txt | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
>> index 2d067767b617..a2efc19e0f4e 100644
>> --- a/Documentation/virt/kvm/api.txt
>> +++ b/Documentation/virt/kvm/api.txt
>> @@ -586,7 +586,7 @@ Capability: basic
>>   Architectures: x86
>>   Type: vcpu ioctl
>>   Parameters: struct kvm_msrs (in)
>> -Returns: 0 on success, -1 on error
>> +Returns: number of msrs successfully set, -1 on error
> 
> Similar to the changelong comment, it'd be helpful to elaborate on the
> positive return value, e.g.:
> 
>    Returns: number of msrs successfully set (see below), -1 on error
> 
> and then something in the free form text explaining how the ioctl stops
> processing MSRs if setting an MSR fails.
>

Do it in v2, thanks!

>>   Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
>>   data structures.
>> -- 
>> 2.19.1
>>
