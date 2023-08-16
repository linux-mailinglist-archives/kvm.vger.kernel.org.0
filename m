Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79C877D8F5
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbjHPDUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241543AbjHPDU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:20:26 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB442682;
        Tue, 15 Aug 2023 20:20:24 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-56ce156bd37so4321812eaf.3;
        Tue, 15 Aug 2023 20:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692156024; x=1692760824;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmX+B7J+wmAurtUlUbZbOqhkBn25gXv9vA1g9p4CbPA=;
        b=MW1+Gm5lqAPzUQyo7ltqasF+300upvYWD88MF2EabmJRL5vy2k/dhIOy4Cwiqwt9Uv
         hClwdqNoYkVvXEni/7FdAamE90NWPj5r5HosFgI7bzfDQUHkArH8yBhBOSb9bRQBm1E+
         XTxF3HLG79XM+qVqycSPst3WtFcxCX6CohDfxIc4fXco0U6EXazeKz6t7MVHyK5PiY4Z
         IC06wDNxccFaBWQ9wUxZTPikB1f0TOderj8CZVcjSZJUE8D5N4doDV47UVbwRyvxlLng
         KDFH7HADIATLCDKwqLJO0JsYtuFFnApvN8F80W6TVgxaM9Fx8l01dDiP2heFfEp0pbJP
         qn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692156024; x=1692760824;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmX+B7J+wmAurtUlUbZbOqhkBn25gXv9vA1g9p4CbPA=;
        b=Hb2boo14CXrOFKrGWG2WdJBICNfMkiOs7U1gd9y/l5veU3OQeBl7aVd9zBuxxyx8e6
         XlwKiJyfIXK7nSAD8P19wGTngfOOofNcfPGJeUQlBCniARj2MxnqVJ8NmE8BkLJNlokf
         wlKRx0kDzQp+p4XVSNUyhlrzuAdlesXlzGwZ4XpNuKrIsulINtTtMCJpSW0pl/QGDKeb
         tLu5qTuWL0Ll6/0beZ0fxKeB5yxz4KOODg0US2AFTors5xTztJnFnNVbbP15WRrQ77wq
         DLd/odYt3FVw1u7KImsk1FlPisfu2uLLn8ekLGg/5X4OiUVJ61yfZPGgIXVbs0zclUju
         UYVg==
X-Gm-Message-State: AOJu0Yw3El2b9wyctT2NIOkEldLNQ1qU5TpbTS354VKVWXdQKuMRGjhm
        DsnyvGa9n1J9p4bwH690mM+KpaEKFPAOwQ==
X-Google-Smtp-Source: AGHT+IHP8Nvbnx53Vi5Az6VTu9OuSy4vtl+Dd/TGFW9dktKQelTl2wk80eGIK6eAd/XQysOa6ji9jA==
X-Received: by 2002:a05:6358:52d2:b0:139:be3d:d2fa with SMTP id z18-20020a05635852d200b00139be3dd2famr1102039rwz.30.1692156023940;
        Tue, 15 Aug 2023 20:20:23 -0700 (PDT)
Received: from localhost.localdomain ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001bdbe6c86a9sm9128572plc.225.2023.08.15.20.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:20:23 -0700 (PDT)
Subject: Re: [PATCH v3 2/6] KVM: PPC: Rename accessor generator macros
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, mikey@neuling.org,
        paulus@ozlabs.org, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
        amachhiw@linux.vnet.ibm.com
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-3-jniethe5@gmail.com>
 <CUS4J2YPYFAO.3P4R24H4KFJ83@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <efa0e456-1b7e-f12e-c720-076e962c7ca2@gmail.com>
Date:   Wed, 16 Aug 2023 13:20:18 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CUS4J2YPYFAO.3P4R24H4KFJ83@wheely>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/8/23 6:27 pm, Nicholas Piggin wrote:
> On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
>> More "wrapper" style accessor generating macros will be introduced for
>> the nestedv2 guest support. Rename the existing macros with more
>> descriptive names now so there is a consistent naming convention.
>>
>> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
> 
>> ---
>> v3:
>>    - New to series
>> ---
>>   arch/powerpc/include/asm/kvm_ppc.h | 60 +++++++++++++++---------------
>>   1 file changed, 30 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
>> index d16d80ad2ae4..b66084a81dd0 100644
>> --- a/arch/powerpc/include/asm/kvm_ppc.h
>> +++ b/arch/powerpc/include/asm/kvm_ppc.h
>> @@ -927,19 +927,19 @@ static inline bool kvmppc_shared_big_endian(struct kvm_vcpu *vcpu)
>>   #endif
>>   }
>>   
>> -#define SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
>> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)		\
>>   static inline ulong kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
>>   {									\
>>   	return mfspr(bookehv_spr);					\
>>   }									\
>>   
>> -#define SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
>> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)		\
>>   static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, ulong val)	\
>>   {									\
>>   	mtspr(bookehv_spr, val);						\
>>   }									\
>>   
>> -#define SHARED_WRAPPER_GET(reg, size)					\
>> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)			\
>>   static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
>>   {									\
>>   	if (kvmppc_shared_big_endian(vcpu))				\
>> @@ -948,7 +948,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
>>   	       return le##size##_to_cpu(vcpu->arch.shared->reg);	\
>>   }									\
>>   
>> -#define SHARED_WRAPPER_SET(reg, size)					\
>> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)			\
>>   static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
>>   {									\
>>   	if (kvmppc_shared_big_endian(vcpu))				\
>> @@ -957,36 +957,36 @@ static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
>>   	       vcpu->arch.shared->reg = cpu_to_le##size(val);		\
>>   }									\
>>   
>> -#define SHARED_WRAPPER(reg, size)					\
>> -	SHARED_WRAPPER_GET(reg, size)					\
>> -	SHARED_WRAPPER_SET(reg, size)					\
>> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)					\
>> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)					\
>> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)					\
>>   
>> -#define SPRNG_WRAPPER(reg, bookehv_spr)					\
>> -	SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
>> -	SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
>> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)					\
>> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)				\
>> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)				\
>>   
>>   #ifdef CONFIG_KVM_BOOKE_HV
>>   
>> -#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
>> -	SPRNG_WRAPPER(reg, bookehv_spr)					\
>> +#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
>> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)			\
>>   
>>   #else
>>   
>> -#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
>> -	SHARED_WRAPPER(reg, size)					\
>> +#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
>> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)			\
> 
> Not the greatest name I've ever seen :D Hard to be concice and
> consistent though, this is an odd one.

Yes, it is a bit wordy.

> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks.

> 
>>   
>>   #endif
>>   
>> -SHARED_WRAPPER(critical, 64)
>> -SHARED_SPRNG_WRAPPER(sprg0, 64, SPRN_GSPRG0)
>> -SHARED_SPRNG_WRAPPER(sprg1, 64, SPRN_GSPRG1)
>> -SHARED_SPRNG_WRAPPER(sprg2, 64, SPRN_GSPRG2)
>> -SHARED_SPRNG_WRAPPER(sprg3, 64, SPRN_GSPRG3)
>> -SHARED_SPRNG_WRAPPER(srr0, 64, SPRN_GSRR0)
>> -SHARED_SPRNG_WRAPPER(srr1, 64, SPRN_GSRR1)
>> -SHARED_SPRNG_WRAPPER(dar, 64, SPRN_GDEAR)
>> -SHARED_SPRNG_WRAPPER(esr, 64, SPRN_GESR)
>> -SHARED_WRAPPER_GET(msr, 64)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(critical, 64)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg0, 64, SPRN_GSPRG0)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg1, 64, SPRN_GSPRG1)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg2, 64, SPRN_GSPRG2)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg3, 64, SPRN_GSPRG3)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr0, 64, SPRN_GSRR0)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr1, 64, SPRN_GSRR1)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(dar, 64, SPRN_GDEAR)
>> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(esr, 64, SPRN_GESR)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(msr, 64)
>>   static inline void kvmppc_set_msr_fast(struct kvm_vcpu *vcpu, u64 val)
>>   {
>>   	if (kvmppc_shared_big_endian(vcpu))
>> @@ -994,12 +994,12 @@ static inline void kvmppc_set_msr_fast(struct kvm_vcpu *vcpu, u64 val)
>>   	else
>>   	       vcpu->arch.shared->msr = cpu_to_le64(val);
>>   }
>> -SHARED_WRAPPER(dsisr, 32)
>> -SHARED_WRAPPER(int_pending, 32)
>> -SHARED_WRAPPER(sprg4, 64)
>> -SHARED_WRAPPER(sprg5, 64)
>> -SHARED_WRAPPER(sprg6, 64)
>> -SHARED_WRAPPER(sprg7, 64)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(dsisr, 32)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(int_pending, 32)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg4, 64)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg5, 64)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg6, 64)
>> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg7, 64)
>>   
>>   static inline u32 kvmppc_get_sr(struct kvm_vcpu *vcpu, int nr)
>>   {
> 
