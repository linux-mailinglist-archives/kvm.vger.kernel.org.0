Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CB39CC6D
	for <lists+kvm@lfdr.de>; Sun,  6 Jun 2021 05:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFFDWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 23:22:42 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:32534 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhFFDWl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Jun 2021 23:22:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UbPzmBp_1622949648;
Received: from 192.168.43.193(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UbPzmBp_1622949648)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Jun 2021 11:20:48 +0800
Subject: Re: [kvm-unit-tests PATCH V2] x86: Add a test to check effective
 permissions
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
References: <YLkh3bQ106M9nV3k@google.com>
 <20210603225851.26621-1-jiangshanlai@gmail.com> <YLqdt11W6R4FgoIY@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <6c87d221-8b6c-56a7-e8d1-31ad8a8379e3@linux.alibaba.com>
Date:   Sun, 6 Jun 2021 11:20:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YLqdt11W6R4FgoIY@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/6/5 05:40, Sean Christopherson wrote:
> On Fri, Jun 04, 2021, Lai Jiangshan wrote:
>> @@ -326,6 +335,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
>>   {
>>       pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
>>       pool->pt_pool_current += PAGE_SIZE;
>> +    memset(va(ret), 0, PAGE_SIZE);
> 
> Should this go in a separate patch?  This seems like a bug fix.

I don't think we need to separate the patch. It is a patch for the testing
repository in which there is no real bug.

I prefer to add the test in a single patch with everything the test needs.

> 
>>       return ret;
>>   }
>>   
>> +static int check_effective_sp_permissions(ac_pool_t *pool)
>> +{
>> +	unsigned long ptr1 = 0x123480000000;
>> +	unsigned long ptr2 = ptr1 + 2 * 1024 * 1024;
>> +	unsigned long ptr3 = ptr1 + 1 * 1024 * 1024 * 1024;
>> +	unsigned long ptr4 = ptr3 + 2 * 1024 * 1024;
> 
> I belatedly remembered we have SZ_2M and SZ_1G, I think we can use those here
> instead of open coding the math.
> 

Will do.

Thanks
Lai
