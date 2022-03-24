Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0FA4E66E9
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 17:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351645AbiCXQYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 12:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351642AbiCXQYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 12:24:49 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2A01EAF6
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 09:23:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g19so4338661pfc.9
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uXjHZDJVvGjT9+tCQuhnhtKNhXNwmcy0iq/6HwiZK08=;
        b=ZSK5ZkdzYQDO0cEAHxpJYlN22xojbHSf/blD76rCVVBf26r5iLwhmhQ2dUo6YqE43e
         vk3cwoLvlxJNd9AIZN6lnHRtasNyl4F8MVf0uaK46a1XJlptageUEWmXuY2htaHZ/ZyZ
         jHIbSbcQiv1r9Fx4Ua1OnnGyawuUTUV48LY0R2g2DTmwJzl0s94TOsOhdEk0rT5hJD+N
         8/6W0EUwyl+hJp+XqZUZYw41Ei9ysNeHTsEc4xZvYyLjakrHk69yoE0Eg9KJB/WLPhPu
         kvId6q+HK203qegslvPkiYKzAYvh3C4WOoZQAHdZQwkXZoZU7hd5AMIqmKnRfmv/bfgt
         GTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uXjHZDJVvGjT9+tCQuhnhtKNhXNwmcy0iq/6HwiZK08=;
        b=0Oe3bnSD/ZWaHwH/aHGRSeEl2KZ4NBRBKgaCcDMJM0O3L2wx3ZrLJMoaGxNBrXbeuO
         BaJCu/iEIH7lRp2eTBQJecV/t3Fk5XIYmXML0iCovOtrKRswqDnjShHM9xeQBK6CHAfI
         n4nWBDAeuXOqhE4nY8Bbd63L/79HojtHLs3mBghULUV3E3ly5deCv2PHQAmHCc5r+75Y
         wsTNH40z2EnWSPEWVSeGLl4ySYmpGhkmgsGQ72NLTXpelnUxLtzMhEUnfAFD8SCsf7RC
         76OtIZp2Zk0mRD4Cy6kFEsbrsQfwANi8yKsMTH8QIDkXZqQl4qfIs2S5XHmGZcg/BxRC
         Tzuw==
X-Gm-Message-State: AOAM533u+HoRibICxkdJQP0Fx8kzZ+yx2oMq9cO6k5B46Dm9b5SAppmv
        UyUUbY4TO6/z4bS8jTcGcKOwUA==
X-Google-Smtp-Source: ABdhPJwD+IBhf3QMsnVdq71Xhv26Nh25rsYZwWkB1ESJwYqDhPQZN905r3P2Z4pzcGIGI9cn0VNaYw==
X-Received: by 2002:a05:6a00:2484:b0:4fa:997e:3290 with SMTP id c4-20020a056a00248400b004fa997e3290mr5859221pfv.37.1648138994270;
        Thu, 24 Mar 2022 09:23:14 -0700 (PDT)
Received: from [192.168.86.237] (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
        by smtp.gmail.com with ESMTPSA id w12-20020a056a0014cc00b004f790cdbf9dsm4276831pfu.183.2022.03.24.09.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 09:23:13 -0700 (PDT)
Message-ID: <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
Date:   Thu, 24 Mar 2022 09:23:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com> <YjtzZI8Lw2uzjm90@google.com>
From:   Reiji Watanabe <reijiw@google.com>
In-Reply-To: <YjtzZI8Lw2uzjm90@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 3/23/22 12:22 PM, Oliver Upton wrote:
> Hi Reiji,
> 
> On Thu, Mar 10, 2022 at 08:47:48PM -0800, Reiji Watanabe wrote:
>> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
>> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
>> Use the saved ones when ID registers are read by the guest or
>> userspace (via KVM_GET_ONE_REG).
>>
>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 12 ++++++
>>   arch/arm64/kvm/arm.c              |  1 +
>>   arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
>>   3 files changed, 63 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2869259e10c0..c041e5afe3d2 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -101,6 +101,13 @@ struct kvm_s2_mmu {
>>   struct kvm_arch_memory_slot {
>>   };
>>   
>> +/*
>> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
>> + * where 0<=crm<8, 0<=op2<8.
> 
> Doesn't the Feature ID register scheme only apply to CRm={1-7},
> op2={0-7}? I believe CRm=0, op2={1-4,7} are in fact UNDEFINED, not RAZ
> like the other ranges. Furthermore, the registers that are defined in
> that range do not go through the read_id_reg() plumbing.


Will fix this.


> 
>> + */
>> +#define KVM_ARM_ID_REG_MAX_NUM	64
>> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
>> +
>>   struct kvm_arch {
>>   	struct kvm_s2_mmu mmu;
>>   
>> @@ -137,6 +144,9 @@ struct kvm_arch {
>>   	/* Memory Tagging Extension enabled for the guest */
>>   	bool mte_enabled;
>>   	bool ran_once;
>> +
>> +	/* ID registers for the guest. */
>> +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> 
> This is a decently large array. Should we embed it in kvm_arch or
> allocate at init?


What is the reason why you think you might want to allocate it at init ?

  
> [...]
> 
>> +
>> +/*
>> + * Set the guest's ID registers that are defined in sys_reg_descs[]
>> + * with ID_SANITISED() to the host's sanitized value.
>> + */
>> +void set_default_id_regs(struct kvm *kvm)
> 
> nit, more relevant if you take the above suggestion: maybe call it
> kvm_init_id_regs()?
> 
>> +{
>> +	int i;
>> +	u32 id;
>> +	const struct sys_reg_desc *rd;
>> +	u64 val;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> 
> You could avoid walking the entire system register table, since we
> already know the start and end values for the Feature ID register range.> 
> maybe:
> 
>    #define FEATURE_ID_RANGE_START	SYS_ID_PFR0_EL1
>    #define FEATURE_ID_RANGE_END		sys_reg(3, 0, 0, 7, 7)
> 
>    u32 sys_reg;
> 
>    for (sys_reg = FEATURE_ID_RANGE_START; sys_reg <= FEATURE_ID_RANGE_END; sys_reg++)
> 
> But, it depends on if this check is necessary:
>
>> +		rd = &sys_reg_descs[i];
>> +		if (rd->access != access_id_reg)
>> +			/* Not ID register, or hidden/reserved ID register */
>> +			continue;
> 
> Which itself is dependent on whether KVM is going to sparsely or
> verbosely define its feature filtering tables per the other thread. So
> really only bother with this if that is the direction you're going.

Even just going through for ID register ranges, we should do the check
to skip hidden/reserved ID registers (not to call read_sanitised_ftr_reg).

Yes, it's certainly possible to avoid walking the entire system register,
and I will fix it.  The reason why I didn't care it so much was just
because the code (walking the entire system register) will be removed by
the following patches:)

Thanks,
Reiji
