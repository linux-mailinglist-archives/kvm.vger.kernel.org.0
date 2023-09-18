Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B247A496E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbjIRMSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241914AbjIRMSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:18:43 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38734A4;
        Mon, 18 Sep 2023 05:18:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-307d20548adso4282772f8f.0;
        Mon, 18 Sep 2023 05:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695039515; x=1695644315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T80nEvkOeLlppUGL8zv8Rxb4RO6K+nXNXjfSXcaGysA=;
        b=fr1mPuUe24MwjmJtrPwE9XRy8sSmTtb6ZOZb7EG4fqmncliEUgkLPpYaK/Wa2f+mJm
         7NyDT74lHU6CXvXZOc9jxsdfvLB+J2vMIyt0SnVcYY5/3WLVgeXxHzV2+7toytlcYktq
         JXTbvUAjuLuYRdQ53/ObYBTc3yAbKxON6BJ9QJ9JgAFZ6XwpBgTXoIPVXHIbEYNzysQl
         g6mN70RJ1i8vA7p80PPFCZOnNmmEZWk0TgoT+DgPBpT9KWIu/0uqRUo/zH5MbOALL3zU
         E1C7u7/D/RTg407ZNAn0Ra2nkGcPISJaQ1faj4rxHmQMp1P0yX0VSoLkreDwaUjbUaXz
         KiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695039515; x=1695644315;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T80nEvkOeLlppUGL8zv8Rxb4RO6K+nXNXjfSXcaGysA=;
        b=ObwZ4lvqwkDnA7XnssTWM7BtVBeU/K9ytMxaBoibx28AulOozmtUTXINi4t8pvM9Zm
         K+AEMJZsD8JnkfvGhwL8ydJMWpYAnAuybd6ChHoKSk3C34pq7eWsqw8zYv92K0oRxxk8
         6FQ3xMvAvEkeYbSZNB4lCxZOq84rSBlrC+GyxwmUFRYs6EBHQji65wNg6/LMzEuIMium
         d3xzkhoBNhBEO33T/FEMll+KkEHdaUoqBfs85JBfVmG8ht5V50qJ9kv0gqsXfNMF3xz+
         +uxrUef7rpu89d+xxhskvhtkaVb7rCnF0a8w0jDXFWLJB1NtRNrEMEADjU+ODPGhK15Q
         MTwg==
X-Gm-Message-State: AOJu0YwqVjzcOho7qBceoZYKzc8lmz+OIuSk6K96n/PW8xNOARj98139
        C+DWkVssuwS/ZA+lQmtVPIg=
X-Google-Smtp-Source: AGHT+IFrvY0Te7vnWUFoz/gMqeAKMwFIf69rThDuREvKoZwKVgGImIv+7b8rkyPHW4XH8ihzbM2NAw==
X-Received: by 2002:a5d:5256:0:b0:31f:d2dc:df26 with SMTP id k22-20020a5d5256000000b0031fd2dcdf26mr8319493wrc.28.1695039515500;
        Mon, 18 Sep 2023 05:18:35 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id z8-20020a056000110800b0031f9bdb79dasm12461580wrw.61.2023.09.18.05.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:18:34 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c91c5ec9-a917-6d20-1401-c11e27d16f90@xen.org>
Date:   Mon, 18 Sep 2023 13:18:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 09/12] KVM: selftests / xen: set
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-10-paul@xen.org>
 <74077fcadd5ddc9dba742987e1419fc13713cd7a.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <74077fcadd5ddc9dba742987e1419fc13713cd7a.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 12:59, David Woodhouse wrote:
> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> If the capability (KVM_XEN_HVM_CONFIG_EVTCHN_SEND) is present then set
>> the guest's vCPU id to match the chosen vcpu_info offset.
> 
> I think from KVM's point of view, the vcpu_id is still zero. As is the
> vcpu_idx. What you're setting is the *Xen* vcpu_id.

Ok. I'll clarify the terminology; and I'll need to set it before the 
shinfo as noted on another thread.

> 
> I like that it's *different* to the vcpu_id; we should definitely be
> testing that case.

How so?

> I don't quite know why the code was using
> vcpu_info[1] in the shinfo before when we were explicitly setting the
> address from userspace; I suppose it didn't matter.
> 

Yes, I think it was entirely arbitrary.

>> Also make some cosmetic fixes to the code for clarity.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> ---
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>>
>> v2:
>>   - New in this version.
>> ---
>>   .../selftests/kvm/x86_64/xen_shinfo_test.c    | 19 +++++++++++++++----
>>   1 file changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
>> index 05898ad9f4d9..49d0c91ee078 100644
>> --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
>> @@ -38,6 +38,8 @@
>>   #define VCPU_INFO_VADDR        (SHINFO_REGION_GVA + 0x40)
>>   #define RUNSTATE_VADDR (SHINFO_REGION_GVA + PAGE_SIZE + PAGE_SIZE - 15)
>>   
>> +#define VCPU_ID                1 /* Must correspond to offset of VCPU_INFO_[V]ADDR */
>>
> 
> As well as being a bit clearer in the commit comment as noted above,
> let's call this XEN_VCPU_ID ?
>

Ok.


> With that cleaned up,
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 

Thanks,

   Paul

