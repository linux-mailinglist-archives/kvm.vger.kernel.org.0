Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE66325B2
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 15:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiKUOYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 09:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiKUOYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 09:24:34 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1266C769F
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 06:23:41 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id k2so6882998qvo.1
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 06:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2J1cgZnf+hEAYJW0tGMwAKWSUEmTIr7fF82Fb35eHbY=;
        b=Lh2f76/8990pibuviVeiDXMSV0EgGS4n8a3z9jHzZUSJhb5CMDjyASTqpxIGkyxret
         vTGsee6bxdqHQCVQCCiVzA/tyXaMfqsucH4uTQ5EijBCVVYwHEL+PsoLtIzmXgu6DJUg
         YTYLS0QpSe16a2ZWKGASPQMlUWpxn/BaCkzno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2J1cgZnf+hEAYJW0tGMwAKWSUEmTIr7fF82Fb35eHbY=;
        b=xlPdHJbgqwsbOmFBQGINWb04wk/o8cnEv1Uxt2o250xFOdLrVhCo1Q5SdHeiYW+T9t
         jzGbYMk70tfqSkrRikhlwmF7w0XT5bsIz0aQhOhxprVjHNBOuibKZ6Ssx32WRtIoNBv2
         djQI9zi/HbG1C2QWk7vtKze3RurQybZy5Ug8SFUOABh7GSlvvXpUb75S9Q7zqYUGYtZ6
         QtFgv3vT2MMCoxmez0mV/Gg0NNSnA+RCCbPlmQCJKjPXFl1HGO3FEesHOgoCZY/cP9jo
         MCV0UcyJYe8nzyDhbkBONxz5GFsQfdGPvScUlCx5gLSARLAg7NTNSlhH9JBlcukJJ2XA
         nC2w==
X-Gm-Message-State: ANoB5plrjtDXcXoQHeslZfFEq0c1w5vuG8eJ7aHcTduUYqMpyI3gXi13
        PWSeH5Oz1/Qn528SponyB4KxMg==
X-Google-Smtp-Source: AA0mqf52GkgLat58I8j4V8x3YHX81aBjPkquPBqqIjLFfKOQOIZumzYocNG2t0XkVoIn9jOPef0Ylg==
X-Received: by 2002:a05:6214:368a:b0:4bb:6b58:2c96 with SMTP id nl10-20020a056214368a00b004bb6b582c96mr17830235qvb.127.1669040620750;
        Mon, 21 Nov 2022 06:23:40 -0800 (PST)
Received: from [192.168.2.110] (107-142-220-210.lightspeed.wlfrct.sbcglobal.net. [107.142.220.210])
        by smtp.gmail.com with ESMTPSA id e8-20020ac84908000000b003a4f14378d1sm6729083qtq.33.2022.11.21.06.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 06:23:39 -0800 (PST)
Message-ID: <98067697-4205-4061-1cbb-a666f7021692@digitalocean.com>
Date:   Mon, 21 Nov 2022 09:23:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To:     Greg Kurz <groug@kaod.org>, Dongli Zhang <dongli.zhang@oracle.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <20221119122901.2469-3-dongli.zhang@oracle.com>
 <20221121120311.2731a912@bahia>
Content-Language: en-US
From:   Liang Yan <lyan@digitalocean.com>
Subject: Re: [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is
 disabled
In-Reply-To: <20221121120311.2731a912@bahia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/21/22 06:03, Greg Kurz wrote:
> On Sat, 19 Nov 2022 04:29:00 -0800
> Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
>> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
>> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
>> could disable the pmu virtualization in an AMD environment.
>>
>> We still see below at VM kernel side ...
>>
>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>
>> ... although we expect something like below.
>>
>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>
>> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
>> pmu virtualization is supported.
>>
>> We disable KVM_CAP_PMU_CAPABILITY if the 'pmu' is disabled in the vcpu
>> properties.
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>   target/i386/kvm/kvm.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 8fec0bc5b5..0b1226ff7f 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -137,6 +137,8 @@ static int has_triple_fault_event;
>>   
>>   static bool has_msr_mcg_ext_ctl;
>>   
>> +static int has_pmu_cap;
>> +
>>   static struct kvm_cpuid2 *cpuid_cache;
>>   static struct kvm_cpuid2 *hv_cpuid_cache;
>>   static struct kvm_msr_list *kvm_feature_msrs;
>> @@ -1725,6 +1727,19 @@ static void kvm_init_nested_state(CPUX86State *env)
>>   
>>   void kvm_arch_pre_create_vcpu(CPUState *cs)
>>   {
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    int ret;
>> +
>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>> +        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                KVM_PMU_CAP_DISABLE);
> It doesn't seem conceptually correct to configure VM level stuff out of
> a vCPU property, which could theoretically be different for each vCPU,
> even if this isn't the case with the current code base.
>
> Maybe consider controlling PMU with a machine property and this
> could be done in kvm_arch_init() like other VM level stuff ?
>

There is already a 'pmu' property for x86_cpu with variable 'enable_pmu' 
as we see the above code. It is mainly used by Intel CPU and set to off 
by default since qemu 1.5.

And, this property is spread to AMD CPU too.

I think you may need setup a machine property to disable it from current 
machine model. Otherwise, it will break the Live Migration scenario.


>> +        if (ret < 0) {
>> +            error_report("kvm: Failed to disable pmu cap: %s",
>> +                         strerror(-ret));
>> +        }
>> +
>> +        has_pmu_cap = 0;
>> +    }
>>   }
>>   
>>   int kvm_arch_init_vcpu(CPUState *cs)
>> @@ -2517,6 +2532,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>           }
>>       }
>>   
>> +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>> +
>>       ret = kvm_get_supported_msrs(s);
>>       if (ret < 0) {
>>           return ret;
>
