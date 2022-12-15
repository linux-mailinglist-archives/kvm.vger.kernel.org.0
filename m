Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B5764DC53
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLONgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 08:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLONgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 08:36:35 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A56614B;
        Thu, 15 Dec 2022 05:36:33 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so52226690ejb.13;
        Thu, 15 Dec 2022 05:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jT7HJVIoupmg5Y21QSuOncD3NDSjnYDNv89SW9beZ/U=;
        b=fq7i2oQ4kCQIvyyCM2oJDTi5KBfjXOU5mODFRLAI90+YnBCM1rr1s7NbIi5I6vOy2h
         iH6FFu8de9yxfk5Uji5GsMY3TEzTgJLkUsjLIrA9Hs+ZG0IY93f33EWh4+HjgzZvomBr
         TtwGWWZ2QnFQ/Gp2woOKcVM67pr8OkE9Q07CMuc34US4AfkN0YU9W0+Jbai5L7kpzoxm
         WXIwJ4RnMfvWa6JLFOjiB2LEEDEbQ1xyIEG7gkTB1wD3YIvVzgINSGZMTW+DyCOa2ce9
         tuYyzT279ljDfbVS9LvWAx/dukSBSkCiRqtVAzIA714/V4xC4+f16RB2kWFQlidCaWi+
         P8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jT7HJVIoupmg5Y21QSuOncD3NDSjnYDNv89SW9beZ/U=;
        b=rlh4SxgaU1SvM1kM57Pv0IpvPGMix5fLAJrFb2rcKjl6OBs64ZC6wNAktewg8NGFYE
         dXDbHvQSfSmLV8s705APxdXX+Uq2ppETTfkrvVgKBhZm9bvIJJ7vSVfshj0eue31qIWW
         /3ITgriHD4MkkY5B8pD8rIaMInELUJllg/YahrkwkpicriYXJqhw3vOf6blT0Jnc/Ekg
         tNB3ARPZbBbo8YmFTuwT6Eyl0P5hMcDhP87eObr55t7+8hLrAGwtG735U/fsmVVFgx3r
         M54GwuYrad+UoF954Oa7DyS5Chc75t4Typh/BFZc8ddgoENAmhNjj3RQUxet9evzxw1e
         +g4w==
X-Gm-Message-State: ANoB5pn+eGnsMwDiTpL00cyohDl27Jir9Qe86aXPb/i0RLPFLA8l4NE6
        u5tuWT8kgk/zuBEsc5Pv16JNTNdL9dkhTxQV
X-Google-Smtp-Source: AA0mqf5UqnGI8UrmD8MiKudLAv9QQswJ7jkGOHAc+i4PkeipEyUbgd8djmZl9G7Q8dQDDdx+KvnmjQ==
X-Received: by 2002:a17:907:a782:b0:7c1:6e82:35fc with SMTP id vx2-20020a170907a78200b007c16e8235fcmr25025941ejc.40.1671111392045;
        Thu, 15 Dec 2022 05:36:32 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b5903e595bsm7031780ejh.84.2022.12.15.05.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 05:36:31 -0800 (PST)
Message-ID: <90b640af-1d81-64bf-96f7-24aa44cca2dd@gmail.com>
Date:   Thu, 15 Dec 2022 21:36:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC 1/8] perf/core: Add *group_leader to
 perf_event_create_kernel_counter()
Content-Language: en-US
To:     Ravi Bangoria <ravi.bangoria@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, kvmarm@lists.linux.dev,
        linux-perf-users@vger.kernel.org
References: <20221212125844.41157-1-likexu@tencent.com>
 <20221212125844.41157-2-likexu@tencent.com>
 <4990ef71-734a-10cf-e7dc-51b33b26fd18@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <4990ef71-734a-10cf-e7dc-51b33b26fd18@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/2022 11:52 am, Ravi Bangoria wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 7f04f995c975..f671b1a9a691 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -12674,12 +12674,14 @@ SYSCALL_DEFINE5(perf_event_open,
>>    * @attr: attributes of the counter to create
>>    * @cpu: cpu in which the counter is bound
>>    * @task: task to profile (NULL for percpu)
>> + * @group_leader: event group leader
>>    * @overflow_handler: callback to trigger when we hit the event
>>    * @context: context data could be used in overflow_handler callback
>>    */
>>   struct perf_event *
>>   perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>>   				 struct task_struct *task,
>> +				 struct perf_event *group_leader,
>>   				 perf_overflow_handler_t overflow_handler,
>>   				 void *context)
>>   {
>> @@ -12694,7 +12696,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>>   	if (attr->aux_output)
>>   		return ERR_PTR(-EINVAL);
>>   
>> -	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
>> +	event = perf_event_alloc(attr, cpu, task, group_leader, NULL,
>>   				 overflow_handler, context, -1);
> 
> Grouping involves lot of complexities. Setting group_leader won't be sufficient.
> Please see perf_event_open() syscall code for more detail.
> 
> Thanks,
> Ravi

This is the main reason why the RFC tag is added. More detailed professional 
reviews is encouraged.

AFAI, there does exist a number of code gaps here to support grouped events in 
the kernel,
but there are also opportunities, as there may be other new use cases bringing 
innovation.

I have to confirm this idea with maintainers first, the alternative is to create 
yet another special
perf_event similar to PMC_IDX_FIXED_VLBR, which schedules perf_metrics MSR for 
KVM stuff.

PeterZ, any input ?
