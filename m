Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C897743D2B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjF3OGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjF3OGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:06:45 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB163AA7
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 07:06:43 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6b73b839025so1580726a34.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 07:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688134003; x=1690726003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9IR4FIVUbAv+x8yfcnJjVElayhZLnA0Y9DaA2XuSX8=;
        b=m2zg4DDXilmM+V9jm8lzd/ncoAbMWPPCHrerUtMptn5iTh4Smci08XG7uluUw6oTmW
         kGB3iHVE6h1iJIChk95u0I1Eb28hfbkI2zFjRMPJ7XljMY4cqlACaset8IfIgOKh2+XT
         78LuEWlcRlY4mORC/6Vkx0ivaId5PbN3vindW96Qp3XsItMPOZbjBsgf/vkh88rOWWEP
         wkx/dwCG+yJt0BV4HnH/MLiEIdXaPGizIIOsPwZSCnait25lMOS8Q4IcfLQJScEkJw2v
         MGK0jYxp7c8BiDjVsbUUwGrUuTdB7hodi0UTGsr4YTG8uCJJZmSL3HKHQ3QcJ9W6nqph
         PsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688134003; x=1690726003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9IR4FIVUbAv+x8yfcnJjVElayhZLnA0Y9DaA2XuSX8=;
        b=M6RWg14kNyCqRO4kzA8SJxqo297Kl1oJdg5VD6S6Pfqcdu16i6Rkrsb27CpC5JimN0
         ZBx2lLexvR7HGqD4Q77/hwSrpvII0fBIWbb1PQc5ZaF+MeI/2D9lixGTOytniZOomxBs
         wuQpXk3OcAtXFCiLrKw/Agl6lXFtEDZDu72OEeJsu2RPAu8ep1tG+iYJohfqzKu3galu
         MIBwEv2/DRBlo8nU8foL2eX6LuS0YjT+89cC0FI1Unc9KItCmlNc4tkU4pxPcZV4koMX
         oqf6sHK4RKX5jVqWZmWUD69V3Q7bhmd+ZTUZZR00gwOidMQ18CjK/X2QS5dowuygvOgY
         tMMg==
X-Gm-Message-State: AC+VfDwpC5mQWQK8OmHdmYGt6iq+CPeETlc1Vk1OaBCxpyIAS7wvSMqK
        2wHmh3n7UZ5sYFMCPv3RH8R5dWU4W+4=
X-Google-Smtp-Source: ACHHUZ5otIPUORl1HFPr4bENxruL3BKBpdJEsf8c5fp9mYGeqKNtR22Y1X5M7uapsmfFx33MCjeFBg==
X-Received: by 2002:a05:6830:1be6:b0:6b7:38c0:7420 with SMTP id k6-20020a0568301be600b006b738c07420mr3110506otb.9.1688134002500;
        Fri, 30 Jun 2023 07:06:42 -0700 (PDT)
Received: from [192.168.68.107] (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id y1-20020a056830108100b006b71d22be29sm1061386oto.18.2023.06.30.07.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 07:06:42 -0700 (PDT)
Message-ID: <c8fbc10e-0fd7-eeb7-973c-4526201ee7a9@gmail.com>
Date:   Fri, 30 Jun 2023 11:06:38 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 3/6] target/ppc: Move CPU QOM definitions to cpu-qom.h
Content-Language: en-US
To:     Greg Kurz <groug@kaod.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-4-philmd@linaro.org> <20230628170531.09d2e648@bahia>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20230628170531.09d2e648@bahia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Phil,

On 6/28/23 12:05, Greg Kurz wrote:
> On Tue, 27 Jun 2023 13:51:21 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/ppc/cpu-qom.h | 5 +++++
>>   target/ppc/cpu.h     | 6 ------
>>   2 files changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
>> index 9666f54f65..c2bff349cc 100644
>> --- a/target/ppc/cpu-qom.h
>> +++ b/target/ppc/cpu-qom.h
>> @@ -31,6 +31,11 @@
>>   
>>   OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
>>   
>> +#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
>> +#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
>> +#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
>> +#define cpu_list ppc_cpu_list
>> +
>>   ObjectClass *ppc_cpu_class_by_name(const char *name);
>>   
>>   typedef struct CPUArchState CPUPPCState;
>> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
>> index af12c93ebc..e91e1774e5 100644
>> --- a/target/ppc/cpu.h
>> +++ b/target/ppc/cpu.h
>> @@ -1468,12 +1468,6 @@ static inline uint64_t ppc_dump_gpr(CPUPPCState *env, int gprn)
>>   int ppc_dcr_read(ppc_dcr_t *dcr_env, int dcrn, uint32_t *valp);
>>   int ppc_dcr_write(ppc_dcr_t *dcr_env, int dcrn, uint32_t val);
>>   
>> -#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
>> -#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
>> -#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
>> -
> 
> These seem appropriate to be moved to "cpu-qom.h".
> 
>> -#define cpu_list ppc_cpu_list
> 
> This one is much older according to git blame :
> 
> c913706581460 target/ppc/cpu.h (Igor Mammedov                 2017-08-30 1469) #define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
> c913706581460 target/ppc/cpu.h (Igor Mammedov                 2017-08-30 1470) #define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
> 0dacec874fa3b target/ppc/cpu.h (Igor Mammedov                 2018-02-07 1471) #define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
> c913706581460 target/ppc/cpu.h (Igor Mammedov                 2017-08-30 1472)
> c732abe222795 target-ppc/cpu.h (Jocelyn Mayer                 2007-10-12 1473) #define cpu_list ppc_cpu_list
> 
> It is some plumbing used for `-cpu help`, not exactly QOM stuff.
> Maybe keep it in "cpu.h" as all other targets do ?

Greg has a point:

$ git grep '#define cpu_list'
target/alpha/cpu.h:#define cpu_list alpha_cpu_list
target/arm/cpu.h:#define cpu_list arm_cpu_list
target/avr/cpu.h:#define cpu_list avr_cpu_list
target/cris/cpu.h:#define cpu_list cris_cpu_list
target/hexagon/cpu.h:#define cpu_list hexagon_cpu_list
target/i386/cpu.h:#define cpu_list x86_cpu_list
target/loongarch/cpu.h:#define cpu_list loongarch_cpu_list
target/m68k/cpu.h:#define cpu_list m68k_cpu_list
target/mips/cpu.h:#define cpu_list mips_cpu_list
target/openrisc/cpu.h:#define cpu_list cpu_openrisc_list
target/ppc/cpu.h:#define cpu_list ppc_cpu_list
target/riscv/cpu.h:#define cpu_list riscv_cpu_list
target/rx/cpu.h:#define cpu_list rx_cpu_list
target/s390x/cpu.h:#define cpu_list s390_cpu_list
target/sh4/cpu.h:#define cpu_list sh4_cpu_list
target/sparc/cpu.h:#define cpu_list sparc_cpu_list
target/tricore/cpu.h:#define cpu_list tricore_cpu_list
target/xtensa/cpu.h:#define cpu_list xtensa_cpu_list

I'm not against moving this define to cpu-qom.h per se but I believe that, for the sake
of consistency, this change should be done in a single swoop across all archs.

For now, if you agree with keeping the 'cpu_list' define in cpu.h, I'll queue this up
and amend it in-tree.


Thanks,

Daniel

> 
>> -
>>   /* MMU modes definitions */
>>   #define MMU_USER_IDX 0
>>   static inline int cpu_mmu_index(CPUPPCState *env, bool ifetch)
> 
> 
> 
