Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A96069E93B
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 22:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBUVEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 16:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjBUVEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 16:04:38 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62477211CE;
        Tue, 21 Feb 2023 13:04:36 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 5EF15123EB3E;
        Tue, 21 Feb 2023 22:04:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1677013470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n28t+E/zsRch9sqsWc1BHYuL8WoSmgCVYrF30WLVYb4=;
        b=MKFrQZKJL8ZLgiAnersYOYTjnK2mguewyPOdPtKRnvRkZrpJW/xegt7MB6ViyC3+iDNBjn
        n9kgpxgMm+eIuMdrv1EfQUgNcG7F0pnkSkBCi6sDX/I2d7Khw/XXosDzoNVgrjBYgBKLOi
        4VVqOjbyFF9VI/oEu0KW6s3hMBmb+xw=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 22:04:29 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <538080af-b876-6462-c591-be66dceb4b8d@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
 <538080af-b876-6462-c591-be66dceb4b8d@bytedance.com>
Message-ID: <056c22523573943347906d0235708d2a@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.02.2023 21:04, Usama Arif wrote:
> On 21/02/2023 19:10, David Woodhouse wrote:
>> On Tue, 2023-02-21 at 13:14 +0100, Oleksandr Natalenko wrote:
>>> 
>>> With this in place:
>>> 
>>> ```
>>>          early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(0);
>>>          initial_gs = per_cpu_offset(0);
>>>          smpboot_control = 0;
>>> ```
>>> 
>>> the resume does not work.
>> 
>> Yeah, I think it's always running on CPU0 after the other CPUs are
>> taken down anyway.
>> 
>> We definitely *do* need to clear smpboot_control because we absolutely
>> want it using the temp_stack we explicitly put into initial_stack, not
>> finding its own idle thread.
>> 
>> The problem was that it was never being restored to STARTUP_SECONDARY
>> in the parallel modes, because that's a one-time setup in
>> native_smp_prepare_cpus(). So we can just restore it in
>> arch_thaw_secondary_cpus_begin() too, by working this into patch 6 of
>> the series.
>> 
>> (Usama, I think my tree is fairly out of date now so I'll let you do
>> that? Thanks!).
> 
> Sounds good! Will send out the next revision with below diff, 
> checkpatch
> fixes and rebased to 6.2 (testing it now). The below fix looks good! 
> Oleksandr, would you mind testing out suspend/resume with the below 
> diff on your AMD machine just to make sure it fixes the issue before I 
> send out the next revision with it. Thanks!

Right, so I applied the whole series + this fix, and the suspend/resume 
works. Thanks!

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

There's another open question pending though: why would this series 
cause booting up one CPU only on an older AMD CPU. But I'd expect 
Piotr's fellow to chime in occasionally.

>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 50621793671d..3db77a257ae2 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1571,6 +1571,17 @@ void __init native_smp_prepare_cpus(unsigned 
>> int max_cpus)
>>     void arch_thaw_secondary_cpus_begin(void)
>>   {
>> +	/*
>> +	 * On suspend, smpboot_control will have been zeroed to allow the
>> +	 * boot CPU to use explicitly passed values including a temporary
>> +	 * stack. Since native_smp_prepare_cpus() won't be called again,
>> +	 * restore the appropriate value for the parallel startup modes.
>> +	 */
>> +	if (do_parallel_bringup) {
>> +		smpboot_control = STARTUP_SECONDARY |
>> +			(x2apic_mode ? STARTUP_APICID_CPUID_0B : STARTUP_APICID_CPUID_01);
>> +	}
>> +
>>   	set_cache_aps_delayed_init(true);
>>   }
>> 

-- 
   Oleksandr Natalenko (post-factum)
