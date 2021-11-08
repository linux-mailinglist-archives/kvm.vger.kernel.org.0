Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F65C447CB3
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbhKHJ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 04:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhKHJ0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 04:26:39 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A29CC061570;
        Mon,  8 Nov 2021 01:23:54 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c4so3635298pfj.2;
        Mon, 08 Nov 2021 01:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=M9QtOUiRH9vGn9JlY9L0b4ZKJFAh4WstfvB9KBBN+fA=;
        b=OWg3UPKUQSADaPaAB3JTpCysMMbE/xEhd79GtSmk3fKq7H3nbMb1u0qxjZ9owargqg
         ap94rmiLdFYtOdNEvQKvK15Pf3yNdlGakzapcYjMXU2VWz2IM0Yyy2c+7s0+IPTQm72d
         IarPUqEXB7skd49WdPVJD0ZaxXx5d6+l0XlDpoAxaQMYWK1WkYhlpkbATnaHlYg02WOg
         DUJFSEaYLJthLr2esggrD0Mpfjk4dusmPVIkv4GXNvKplx36QT5PGK/bhAkR/cQaLBeS
         emezVQi5mC9LFX3iG5ehB0DW6QoVj/BTbnbOMOcVJ96E2UhK5NGy1EaiDZjEe1pTc2n8
         jE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=M9QtOUiRH9vGn9JlY9L0b4ZKJFAh4WstfvB9KBBN+fA=;
        b=vytMH2ohD5eZEShBBN0KEANMjrFVgnizCqj87ZKpNI4zT93X3kZVmkxR4qMcd7WwXU
         eaa24citp42D5QL9LDJv8IcPzuI7oywXyizJTbbXt1Gj5OO3qbuLs41pJQx6+NJOORee
         0c9SIjbhKxLEfkPkdELdL0cyQhlsseVJbQkN33LHld6f40zeeDykhBAS+k1zQwcIuivJ
         zO8LGBlxwZ+tmeHG6r9CAp4GlvpKX0tu33vsymexeiNCOkBhbnQH7BbiYswBXfaDH8hG
         SU/XBie8tmV7XPwVkWd+hwqCoMVZnGCUCX1htXSIxcNuhKcHCFu5khDqIELwDdKUMgG0
         iPsQ==
X-Gm-Message-State: AOAM533tKvyUIV5dVzMIOqr8KTj9c51/y67uLz7Gf5c0KS5sozkeGJA1
        y7UDYOndiT+38kedgiOO3sbA5GFa01Y=
X-Google-Smtp-Source: ABdhPJxMWO8bsh+OEB2y/BjE0SHgl8xub/+FvUW6CEyf8bzhbPN9bzB2IY34iQKqLK7IAIYqRMcxyQ==
X-Received: by 2002:a63:6c87:: with SMTP id h129mr42393143pgc.73.1636363434432;
        Mon, 08 Nov 2021 01:23:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a15sm15754300pfv.90.2021.11.08.01.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 01:23:53 -0800 (PST)
Message-ID: <b9ab37c0-bf07-1c59-f44a-bf2cea746415@gmail.com>
Date:   Mon, 8 Nov 2021 17:23:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-2-likexu@tencent.com> <YYVODdVEc/deNP8p@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 1/3] KVM: x86: Copy kvm_pmu_ops by value to eliminate
 layer of indirection
In-Reply-To: <YYVODdVEc/deNP8p@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/2021 11:30 pm, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Like Xu wrote:
>> Replace the kvm_pmu_ops pointer in common x86 with an instance of the
>> struct to save one pointer dereference when invoking functions. Copy the
>> struct by value to set the ops during kvm_init().
>>
>> Using kvm_x86_ops.hardware_enable to track whether or not the
>> ops have been initialized, i.e. a vendor KVM module has been loaded.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c        | 41 +++++++++++++++++++++------------------
>>   arch/x86/kvm/pmu.h        |  4 +++-
>>   arch/x86/kvm/vmx/nested.c |  2 +-
>>   arch/x86/kvm/x86.c        |  3 +++
>>   4 files changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 0772bad9165c..0db1887137d9 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -47,6 +47,9 @@
>>    *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
>>    */
>>   
>> +struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
>> +EXPORT_SYMBOL_GPL(kvm_pmu_ops);
>> +
> 
> ...
> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index b4ee5e9f9e20..1e793e44b5ff 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4796,7 +4796,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>>   		return;
>>   
>>   	vmx = to_vmx(vcpu);
>> -	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
>> +	if (kvm_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
> 
> I would much prefer we export kvm_pmu_is_valid_msr() and go through that for nVMX
> than export all of kvm_pmu_ops for this one case.

Applied. Is it an abuse to export a function for only one case ?

> 
>>   		vmx->nested.msrs.entry_ctls_high |=
>>   				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>>   		vmx->nested.msrs.exit_ctls_high |=
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ac83d873d65b..72d286595012 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11317,6 +11317,9 @@ int kvm_arch_hardware_setup(void *opaque)
>>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>>   	kvm_ops_static_call_update();
>>   
>> +	if (kvm_x86_ops.hardware_enable)
> 
> Huh?  Did you intend this to be?
> 
> 	if (kvm_x86_ops.pmu_ops)
> 
> Either way, I don't see the point, VMX and SVM unconditionally provide the ops.

Let me drop it.

> 
> I would also say land this memcpy() above kvm_ops_static_call_update(), then the
> enabling patch can do the static call updates in kvm_ops_static_call_update()
> instead of adding another helper.

Both applied.

> 
>> +		memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
> 
> As part of this change, the pmu_ops should be moved to kvm_x86_init_ops and tagged
> as __initdata.  That'll save those precious few bytes, and more importantly make
> the original ops unreachable, i.e. make it harder to sneak in post-init modification
> bugs.

Applied. Opportunistically,

-struct kvm_pmu_ops [amd|intel]_pmu_ops = {
+struct kvm_pmu_ops [amd|intel]_pmu_ops __initdata = {

> 
>> +
>>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>   		supported_xss = 0;
>>   
>> -- 
>> 2.33.0
>>
> 
