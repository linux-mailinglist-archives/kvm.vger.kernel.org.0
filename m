Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0A54138B1
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhIURjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:39:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhIURju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632245901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ps7sRkcD6VYl85kI1uxsep0hwsJ0/fdk/o4evC4yU9U=;
        b=dV54fTW5lIp1Pf8+xCJYuE616EchGA/UdQ9pfM4wMapMOzw1MaNr8h+k7SlhX2QaE7FK4l
        fJtNh9n6ut9rKNHhOsV0uNcyToN6Z0oEy2EV0Ho31TwBWAhsEGzGeIQFifiX1oJ7NaQIOg
        jQp/1Y/IjKet0QpSvRkwkG8+2JM2OVs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-4vINjJUGN--YkU5lma6SXQ-1; Tue, 21 Sep 2021 13:38:19 -0400
X-MC-Unique: 4vINjJUGN--YkU5lma6SXQ-1
Received: by mail-ed1-f70.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso19881364edp.13
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ps7sRkcD6VYl85kI1uxsep0hwsJ0/fdk/o4evC4yU9U=;
        b=gTIc2D1LbJCE2XFNeKDTTZFHIt2WYhkb2jYK/HZl4+ynJLojDDMH4Oseh77MB/w+FP
         MZxtcGbkcDqZ9b4cDZrYT/4Bcfa1x4F54QVrhKFGoAGUqUWeCpVJoRXb4w8e6lKdUDck
         AqOTre45gwCxeVGU/oAWbNEd2vPdUtlOtcjvXyyKTi82S7Mwu/t9Q92Au4D/CIXl0dlw
         uem4s9IrfzRBGTVOmAM1eyteJJI7bJTf1VtuX1nwCFc/0dZqq5V2UnOFpUNS73vU+sOt
         x5a0u8gm+4uFpAJOXtJkJS7laeYW+lHdznzVHMsnGw5JDIsSVPwX+rab/qLgHasS3RU0
         U9mg==
X-Gm-Message-State: AOAM530X/K2XZJWgNikf9IXQhVNtoGUdyoGzcJqzeeQyz99JQWONR1HI
        +5UHSA4E/hOE3nsZM/rFe7oMykE9ojFiW/CfZ0fYxZNyv+5oBAfm5hHhQmOa72RWnaXdwL/o8WU
        O51aAZo1sSkiU
X-Received: by 2002:a17:906:dbcb:: with SMTP id yc11mr36471902ejb.111.1632245898683;
        Tue, 21 Sep 2021 10:38:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeGPiiIE6s377p1uYluTAIC8tQvILE4GRsSkZJJoDkyFhMyBtQ6u9q0bUlYbHFk0utlKJ7EQ==
X-Received: by 2002:a17:906:dbcb:: with SMTP id yc11mr36471879ejb.111.1632245898484;
        Tue, 21 Sep 2021 10:38:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qc12sm816874ejb.117.2021.09.21.10.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:38:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in
 steal_time.c
To:     Andrew Jones <drjones@redhat.com>, Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-3-oupton@google.com>
 <20210921071904.5irj3q5yiquoubj2@gator.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b242d9d8-ec1c-bba5-6272-a7a42e2e4011@redhat.com>
Date:   Tue, 21 Sep 2021 19:38:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921071904.5irj3q5yiquoubj2@gator.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 09:19, Andrew Jones wrote:
> On Tue, Sep 21, 2021 at 01:01:20AM +0000, Oliver Upton wrote:
>> Building steal_time.c for arm64 with clang throws the following:
>>
>>>> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>            : "=r" (ret) : "r" (func), "r" (arg) :
>>                                ^
>>>> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>            : "=r" (ret) : "r" (func), "r" (arg) :
>>                                            ^
>>
>> Silence by casting operands to 64 bits.
>>
>> Signed-off-by: Oliver Upton <oupton@google.com>
>> ---
>>   tools/testing/selftests/kvm/steal_time.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>> index ecec30865a74..eb75b31122c5 100644
>> --- a/tools/testing/selftests/kvm/steal_time.c
>> +++ b/tools/testing/selftests/kvm/steal_time.c
>> @@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
>>   		"mov	x1, %2\n"
>>   		"hvc	#0\n"
>>   		"mov	%0, x0\n"
>> -	: "=r" (ret) : "r" (func), "r" (arg) :
>> +	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :
> 
> Actually, I think I'd rather fix this smccc implementation to match the
> spec, which I think should be done like this
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..7da957259ce4 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -118,12 +118,12 @@ struct st_time {
>          uint64_t st_time;
>   };
>   
> -static int64_t smccc(uint32_t func, uint32_t arg)
> +static int64_t smccc(uint32_t func, uint64_t arg)
>   {
>          unsigned long ret;
>   
>          asm volatile(
> -               "mov    x0, %1\n"
> +               "mov    w0, %w1\n"
>                  "mov    x1, %2\n"
>                  "hvc    #0\n"
>                  "mov    %0, x0\n"
> 

Agreed, can you send out a patch?  Thanks,

Paolo

