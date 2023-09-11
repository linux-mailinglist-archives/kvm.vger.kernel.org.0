Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8479BA15
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbjIKUs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbjIKJ7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:59:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC2EE67;
        Mon, 11 Sep 2023 02:59:32 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fbd5cd0ceso782915b3a.1;
        Mon, 11 Sep 2023 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694426372; x=1695031172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2TUtc0pSp329hvP10KKMH6JHebPrZxEBsgiEKJrLWh8=;
        b=Par9M4bAT71wLoP3LOxI7TzYC+oMYkf8YihsNCeS9hJINIdUkEBUrgkQqOwEvpaSB8
         PfGeyvn8+P11y2nSIyvOtQhBEMppe8Wj/rIkLJ9s2uKCX6LqWZDK3i0Hnqi460pgYm8s
         Xbk4OFnSoc4qpu0x53Aw9ma9KojDGer2G+40UoqAg1vcD4U9VHlxblWt1ChTW/bKrTTJ
         BrktUoEY3Rftiq/kGPfpiEBDdWv/O/0I5Zn2D9Uf9QMypc3zi8cc2gCgKsNV0erxqpHB
         pKr1HX05LAq9Ac8Cf592BfAYsBLJEnKVbv1kTQfgu89jRwCAP2WcwgzeuH1R8uUEmSiD
         hREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694426372; x=1695031172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TUtc0pSp329hvP10KKMH6JHebPrZxEBsgiEKJrLWh8=;
        b=ve0AXAeruaIHcR2z0PcZj9yse+8Mu4RqP7syT4VBR6WNsX7vmREmbQVaUt4MBL2Ag6
         QGI1j7EXF6+lJ15mg1ZjAyaXUUIUCxoxRY6q60J52aZVpFNVlrVP3ecL53RakIflUyzv
         VKbfpSIalAxJkBHIUE/htxaxwnN8Su9oUCxJUMw1FkxMb8QNG+VlXEnwp8FQF/IFcZPh
         lsJ0Csnf84CMvR1ICXWVf5r13AP/jdOsUptBCYfQ5/XBcVxk6GBi9puQBzHpIQUaFqUS
         UHwHR1bnxlXSN98QA2XwCxnJ93aBIhZgHEMjm6pAol1t79Qdcs6xzOKtSrWfvoRRpoRI
         T2LA==
X-Gm-Message-State: AOJu0YyXRjkyt4ADvZKvkzZan5+SzSthODUhgY4FuukzU8JPvxcQy6/y
        HSrJUaNlB5DYvMX9+qqsPnk=
X-Google-Smtp-Source: AGHT+IGkzN+hUtDsUPe18WTuHFjC/nSGgLEYgTG+Bkgu03Q3BrHKBDYoPaTD2zr9BUI0Xc0Y4p9o1g==
X-Received: by 2002:a05:6a20:1390:b0:14c:512c:60d9 with SMTP id hn16-20020a056a20139000b0014c512c60d9mr8341377pzc.27.1694426372083;
        Mon, 11 Sep 2023 02:59:32 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j13-20020aa78d0d000000b0068bff979c33sm5224230pfe.188.2023.09.11.02.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 02:59:31 -0700 (PDT)
Message-ID: <6c15cbd9-1086-373c-d906-fc1cd0016890@gmail.com>
Date:   Mon, 11 Sep 2023 17:59:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH] KVM: x86: Allow exposure of VMware backdoor Pseudo-PMCs
 when !enable_pmu
Content-Language: en-US
To:     arbel.moshe@oracle.com, liran.alon@oracle.com,
        nikita.leshchenko@oracle.com,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20230822080312.63514-1-likexu@tencent.com>
 <ZOZteOxJvq9v609G@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZOZteOxJvq9v609G@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

Please help confirm if VMware backdoor Pseudo-PMCs [*] are still available
when the KVM module parameter eneble_pmu=0.

	- VMWARE_BACKDOOR_PMC_HOST_TSC;
	- VMWARE_BACKDOOR_PMC_REAL_TIME;
	- VMWARE_BACKDOOR_PMC_APPARENT_TIME;

I'd like to say yes, but safely you have the official right to define it. Thanks.

[*] https://www.vmware.com/files/pdf/techpaper/Timekeeping-In-VirtualMachines.pdf

On 24/8/2023 4:35 am, Sean Christopherson wrote:
> On Tue, Aug 22, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Fix kvm_pmu_rdpmc() logic to allow exposure of VMware backdoor Pseudo-PMCs
>> if pmu is globally disabled.
>>
>> In this usage scenario, once vmware_backdoor is enabled, the VMs can fully
>> utilize all of the vmware_backdoor-related resources, not just part of it,
>> i.e., vcpu should always be able to access the VMware backdoor Pseudo-PMCs
>> via RDPMC. Since the enable_pmu is more concerned with the visibility of
>> hardware pmu resources on the host, fix it to decouple the two knobs.
>>
>> The test case vmware_backdoors from KUT is used for validation.
> 
> Is there a real world need for this?  Per commit 672ff6cff80c ("KVM: x86: Raise
> #GP when guest vCPU do not support PMU"), KVM's behavior is intentional.  If there
> is a real world need, then (a) that justification needs to be provided, (b) this
> needs a Fixes:, and (c) this probably needs to be tagged for stable.
> 
>> Cc: Arbel Moshe <arbel.moshe@oracle.com>
>> Cc: Liran Alon <liran.alon@oracle.com>
>> Cc: Nikita Leshenko <nikita.leshchenko@oracle.com>
> 
> The expectation is that a Cc: in the changelog means the patch email is Cc'd to
> that person, i.e. one of the purposes of Cc: here is to record that people who
> might care about the patch have been made aware of its existence.  stable@ is
> pretty much the only exception to that rule, as "Cc: stable@vger.kernel.org" is
> really just a metadata tag for scripts.
> 
> FWIW, I believe Liran no longer works for Oracle, no idea about the others.
> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index edb89b51b383..c896328b2b5a 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -526,12 +526,12 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>   	struct kvm_pmc *pmc;
>>   	u64 mask = fast_mode ? ~0u : ~0ull;
>>   
>> -	if (!pmu->version)
>> -		return 1;
>> -
>>   	if (is_vmware_backdoor_pmc(idx))
>>   		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
>>   
>> +	if (!pmu->version)
>> +		return 1;
>> +
>>   	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
>>   	if (!pmc)
>>   		return 1;
>>
>> base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
>> -- 
>> 2.41.0
>>
