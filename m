Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601496B05F4
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 12:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCHL1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 06:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjCHL1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 06:27:36 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7356E8C80D
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 03:27:08 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bw19so14994101wrb.13
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 03:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678274827;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xGsHd+caIhy+o/7MHpOCMmfE0nVqpXcNQURttklH9DM=;
        b=RdY5GhIfWj5FnKL5h0MTeHpAe6DHoh9G2ogllkQklvM8m0Ms3Ya94kgKaQCBTZ5ztT
         Qy8ur845Gc40OhTbruolPCMewKSZJv8gof64zQxvWRCufFcHhWVN5aPDZa3avFFr9UU5
         ymhfh7/WAa0AmJiDOOK66GfCveI3Ls0vzJexzqC91VLEkYZlZDcRlVFOMhYpZZ3LtHNb
         XJsHs0+IhZMPlPn8Y01WhDdhKwZ+hrMjQvm0ukh5RJcjMV/Wm37q3y2C0+gA/aEK2qoW
         Vr/cUMbahEvbDhExHfZcFqMV8W064ehTtqPqF31c11MRMrDOoQXjvXWKYLJGtSpcFZG4
         NECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678274827;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xGsHd+caIhy+o/7MHpOCMmfE0nVqpXcNQURttklH9DM=;
        b=rVPoZJ1gf7SHigMRqPfNjWReMJBIudvfqFpEUnH0tRKIfWdcCzlBvZ0STXwl62a7pw
         YT1a+tBcgqy0+j1rMdKOph5XgZ4gSm+ipZ1ItlrcXFoAoATqsFJX2UO75fBUDi0g/KaM
         vOrp+aRv2s6984sk/TUzizsq01s3JrBrwx+N14oXiaOBE5DToZ5uUVGUWEsONPyC4/gf
         XrUphBtlSLR2i8L/V8jy0DfgCmeonyXRoiOt9Ahfycf/j3qe9yomwswQ3zmLdtLgu2HF
         +LRoMUnObXet7GTth4oU0Tbf1/SD7F2YolXmnLFFg46S2NsSAcvUw0tQnqWbBu47r16W
         +L+A==
X-Gm-Message-State: AO0yUKX6dayL6rzPUzwsABNDmG3a3S+Zuz29550vL9nePgRo/KenIejx
        N3ROrE+qknp3sByA+pcRoKOf6g==
X-Google-Smtp-Source: AK7set/1oY+bIpBndW8g4VVVbLA8HSuIl6wHrl3WL1xEowqjGfgy/C2pPZzXN+BPAXQCqMjTlx0XLQ==
X-Received: by 2002:a05:6000:1803:b0:2c5:4aea:d121 with SMTP id m3-20020a056000180300b002c54aead121mr13012246wrh.15.1678274826886;
        Wed, 08 Mar 2023 03:27:06 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:52ca:aea8:eb67:a912? ([2a02:6b6a:b566:0:52ca:aea8:eb67:a912])
        by smtp.gmail.com with ESMTPSA id u8-20020a5d4688000000b002c5544b3a69sm15197758wrq.89.2023.03.08.03.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 03:27:06 -0800 (PST)
Message-ID: <a6eb52fe-6441-62b3-964c-d1e661fe37f0@bytedance.com>
Date:   Wed, 8 Mar 2023 11:27:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
Cc:     "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
 <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
 <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
 <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
 <3bfbbd92-b2ed-8189-7b57-0533f6c87ae7@amd.com>
 <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
 <39f23da7-1e77-4535-21a6-00f77a382ae5@amd.com>
 <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/03/2023 09:04, David Woodhouse wrote:
> On Tue, 2023-03-07 at 16:55 -0600, Tom Lendacky wrote:
>> On 3/7/23 16:27, David Woodhouse wrote:
>>> On Tue, 2023-03-07 at 16:22 -0600, Tom Lendacky wrote:
>>>>
>>>> I did some Qemu/KVM testing. One thing I noticed is that on AMD, CPUID 0xB
>>>> EAX will be non-zero only if SMT is enabled. So just booting some guests
>>>> without CPU topology never did parallel booting ("smpboot: Disabling
>>>> parallel bringup because CPUID 0xb looks untrustworthy"). I would imagine
>>>> a bare-metal system that has diabled SMT will not do parallel booting, too
>>>> (but I haven't had time to test that).
>>>
>>> Interesting, thanks. Should I change to checking for *both* EAX and EBX
>>> being zero? That's what I did first, after reading only the Intel SDM.
>>> But I changed to only EAX because the AMD doc only says that EAX will
>>> be zero for unsupported leaves.
>>
>>   From a baremetal perspective, I think that works. Rome was the first
>> generation to support x2apic, and the PPR for Rome states that 0's are
>> returned in all 4 registers for undefined function numbers.
>>
>> For virtualization, at least Qemu/KVM, that also looks to be a safe test.
> 
> At Sean's suggestion, I've switched it to use the existing
> check_extended_topology_leaf() which checks for EBX being non-zero, and
> CH being 1 (SMT_TYPE).
> 
> I also made it work even if the kernel isn't using x2apic mode (is that
> even possible, or does SEV-ES require the MSR-based access anyway?)
> 
> It just looked odd handling SEV-ES in the CPUID 0x0B path but not the
> CPUID 0x01 case, and I certainly didn't want to implement the asm side
> for handling CPUID 0x01 via the GHCB protocol. And this way I can pull
> the check for CC_ATTR_GUEST_STATE_ENCRYPT up above. Which I've kept for
> now for the reason described in the comment, but I won't die on that
> hill.
> 
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-v14
> 
> Looks like this:
> 
> /*
>   * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
>   * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
>   * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
>   * hard.
>   */
> static bool prepare_parallel_bringup(void)
> {
> 	bool has_sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) &&
> 		static_branch_unlikely(&sev_es_enable_key);
> 
> 	if (IS_ENABLED(CONFIG_X86_32))
> 		return false;
> 
> 	/*
> 	 * Encrypted guests other than SEV-ES (in the future) will need to
> 	 * implement an early way of finding the APIC ID, since they will
> 	 * presumably block direct CPUID too. Be kind to our future selves
> 	 * by warning here instead of just letting them break. Parallel
> 	 * startup doesn't have to be in the first round of enabling patches
> 	 * for any such technology.
> 	 */
> 	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) || !has_sev_es) {
> 		pr_info("Disabling parallel bringup due to guest memory encryption\n");
> 		return false;

I believe this is still going to enable parallel bringup for TDX? 
Looking at include/linux/cc_platform.h, it looks like 
CC_ATTR_GUEST_STATE_ENCRYPT is only set for SEV-ES and TDX guest with 
x2apic will go on in this function and enable parallel bringup if leaf 
0xB is ok. I guess if the apic ID is OK for the TDX guest, then its 
fine, but just wanted to check if anyone has tested this on TDX guest?


> 	}
> 
> 	if (x2apic_mode || has_sev_es) {
> 		if (boot_cpu_data.cpuid_level < 0x0b)
> 			return false;
> 
> 		if (check_extended_topology_leaf(0x0b) != 0) {
> 			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
> 			return false;
> 		}
> 
> 		if (has_sev_es) {
> 			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
> 			smpboot_control = STARTUP_APICID_SEV_ES;
> 		} else {
> 			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> 			smpboot_control = STARTUP_APICID_CPUID_0B;
> 		}
> 	} else {
> 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
> 		if (boot_cpu_data.cpuid_level < 0x01)
> 			return false;
> 
> 		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
> 		smpboot_control = STARTUP_APICID_CPUID_01;
> 	}
> 
> 	cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
> 				  native_cpu_kick, NULL);
> 	return true;
> }
> 
