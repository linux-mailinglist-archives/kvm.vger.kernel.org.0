Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5647A45CBFF
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 19:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242086AbhKXSZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 13:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236629AbhKXSZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 13:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637778155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eA81Z7xGs8LCf8jSsFcx8Ft2QCQQsGCmMWnjLeVDns4=;
        b=DFGmtkPEbPed8CJweYwjqOC0p2XPrOFRrQ9VWPNOmIMu0+3jqa44CFcUnD5tOmH/PXwvCw
        8edUPeUdWNwx2RSmZ0ckhtiyMUedznOdqtGG0BOofKQmJM62X50NJ1hrERK56kLi9zxIr8
        NIwLxgZKGXnMAOgDZfsTYg3kWZabfos=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-24-YacocsqGNYO6WJpvciRdRg-1; Wed, 24 Nov 2021 13:22:34 -0500
X-MC-Unique: YacocsqGNYO6WJpvciRdRg-1
Received: by mail-wm1-f69.google.com with SMTP id g81-20020a1c9d54000000b003330e488323so2037724wme.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 10:22:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eA81Z7xGs8LCf8jSsFcx8Ft2QCQQsGCmMWnjLeVDns4=;
        b=HG/yLCuuWKvCAkGxv5Mc3yYbiVmfYTZ7ZBbn/dx0HtBU+J+riTlXS4wOFUrLZ86IZY
         Cag6HROH6qTCrnNhGPOiN8KZsLM+O6KsRltJrCfVtTybL+6moP8hiLmmmyoLSrYAMoQJ
         kCAUYH2C6rx2zgW4I6HMpanTRKFWppgTjjQNf7Cz72r33XgxhrrtkWW/GMCeEm+MWoOg
         sKb8GhcUN4Eh5Pl3ig8oA6A3Zk5HWoawAatxjO8BX9fV2goo+u4IQi7wdxGnGQWmsNpF
         YlChn6w2hBmaq/X0LSZX78a+lY1QzhsukWY9VuUop0sbCOQo/NKXM0ZZihFAlAwkIyzJ
         KF5g==
X-Gm-Message-State: AOAM531iqH0Q4qUZpJzJY2V839Ota08vM+aURdP/5ui2HtPHg3inXuZo
        jFna864RVAAtLMUyiXNgftYJvklhbs/GKS36VHKWUYvxBteWy6JGaf3ahumdF5o+/jEcZIH+zd4
        dU3TWjfUBvi7Z
X-Received: by 2002:a7b:c119:: with SMTP id w25mr17906462wmi.70.1637778152925;
        Wed, 24 Nov 2021 10:22:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxN2CJF7kM7+lRzXWcKKC+12rHg/JZvqdShXjKpY5mfJsfOUi67s26vQ83CDPz0UOfRi7hWwg==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr17906413wmi.70.1637778152615;
        Wed, 24 Nov 2021 10:22:32 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k13sm522706wri.6.2021.11.24.10.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 10:22:32 -0800 (PST)
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
 <d3fd9d6c-c96c-d7a0-b78d-af36430dbf3f@redhat.com>
 <CAAeT=FyzvGaksi+-WidHObrGYcqs4vR73ChCGpo8AFuin6UbYw@mail.gmail.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <c377f63b-89e8-351f-2c95-c98deb51ecda@redhat.com>
Date:   Wed, 24 Nov 2021 19:22:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FyzvGaksi+-WidHObrGYcqs4vR73ChCGpo8AFuin6UbYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/19/21 5:47 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 18, 2021 at 12:36 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> This patch lays the groundwork to make ID registers writable.
>>>
>>> Introduce struct id_reg_info for an ID register to manage the
>>> register specific control of its value for the guest, and provide set
>>> of functions commonly used for ID registers to make them writable.
>>>
>>> The id_reg_info is used to do register specific initialization,
>>> validation of the ID register and etc.  Not all ID registers must
>>> have the id_reg_info. ID registers that don't have the id_reg_info
>>> are handled in a common way that is applied to all ID registers.
>>>
>>> At present, changing an ID register from userspace is allowed only
>>> if the ID register has the id_reg_info, but that will be changed
>>> by the following patches.
>>>
>>> No ID register has the structure yet and the following patches
>>> will add the id_reg_info for some ID registers.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/include/asm/sysreg.h |   1 +
>>>  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
>>>  2 files changed, 218 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>>> index 16b3f1a1d468..597609f26331 100644
>>> --- a/arch/arm64/include/asm/sysreg.h
>>> +++ b/arch/arm64/include/asm/sysreg.h
>>> @@ -1197,6 +1197,7 @@
>>>  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
>>>
>>>  #define ARM64_FEATURE_FIELD_BITS     4
>>> +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
>>>
>>>  /* Create a mask for the feature bits of the specified feature. */
>>>  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 5608d3410660..1552cd5581b7 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>>>               return read_zero(vcpu, p);
>>>  }
>>>
>>> +/*
>>> + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
>>> + * ftr_check_types of id_reg_info.
>>> + */
>>> +enum feature_check_type {
>>> +     FCT_LOWER_SAFE = 0,
>>> +     FCT_HIGHER_SAFE,
>>> +     FCT_HIGHER_OR_ZERO_SAFE,
>>> +     FCT_EXACT,
>>> +     FCT_EXACT_OR_ZERO_SAFE,
>>> +     FCT_IGNORE,     /* Don't check (any value is fine) */
>> Maybe you can remove the _SAFE suffix (EXACT does not have it).
> 
> I am inclined to keep 'SAFE' (otherwise, I am likely to forget
> if lower is safe or not).
> 
>> s/EXACT/EQUAL ?
> 
> I will fix that FCT_EXACT to FCT_EQUAL_SAFE.
> 
>>> +};
>>> +
>>> +static int arm64_check_feature_one(enum feature_check_type type, int val,
>>> +                                int limit)
>>> +{
>>> +     bool is_safe = false;
>>> +
>>> +     if (val == limit)
>>> +             return 0;
>> even if the type is unexpected?
> 
> I will remove it.
then you need to modify the handling of FCT_EXACT*.
> 
>>> +
>>> +     switch (type) {
>>> +     case FCT_LOWER_SAFE:
>>> +             is_safe = (val <= limit);
>>> +             break;
>>> +     case FCT_HIGHER_OR_ZERO_SAFE:
>>> +             if (val == 0) {
>>> +                     is_safe = true;
>>> +                     break;
>>> +             }
>>> +             fallthrough;
>>> +     case FCT_HIGHER_SAFE:
>>> +             is_safe = (val >= limit);
>>> +             break;
>>> +     case FCT_EXACT:
>>> +             break;
>>> +     case FCT_EXACT_OR_ZERO_SAFE:
>>> +             is_safe = (val == 0);
>>> +             break;
>>> +     case FCT_IGNORE:
>>> +             is_safe = true;
>>> +             break;
>>> +     default:
>>> +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
>>> +             break;
>>> +     }
>>> +
>>> +     return is_safe ? 0 : -1;
>>> +}
>>> +
>>> +#define      FCT_TYPE_MASK           0x7
>>> +#define      FCT_TYPE_SHIFT          1
>>> +#define      FCT_SIGN_MASK           0x1
>>> +#define      FCT_SIGN_SHIFT          0
>>> +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
>>> +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
>>> +
>>> +#define      MAKE_FCT(shift, type, sign)                             \
>>> +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
>>> +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
>>> +
>>> +/* For signed field */
>>> +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
>>> +/* For unigned field */
>>> +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
>>> +
>>> +/*
>>> + * @val and @lim are both a value of the ID register. The function checks
>>> + * if all features indicated in @val can be supported for guests on the host,
>>> + * which supports features indicated in @lim. @check_types indicates how> + * features in the ID register needs to be checked.
>>> + * See comments for id_reg_info's ftr_check_types field for more detail.
>> What about RES0 fields which may exist? add a comment to reassure about
>> the fact they are properly handled if there are?
> 
> Any fields including RES0 should be checked based on check_types.
> I will explicitly state that in the comment.
> 
>>> + */
>>> +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
>>> +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
>>> +             bool is_sign = FCT_SIGN(ftr_check);
>>> +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
>>> +             int fval, flim, ret;
>>> +
>>> +             fval = cpuid_feature_extract_field(val, i, is_sign);
>>> +             flim = cpuid_feature_extract_field(lim, i, is_sign);
>>> +
>>> +             ret = arm64_check_feature_one(fctype, fval, flim);
>>> +             if (ret)
>>> +                     return -E2BIG;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>> +struct id_reg_info {
>>> +     u32     sys_reg;        /* Register ID */
>> use struct kernel-doc comments instead?
>>> +
>>> +     /*
>>> +      * Limit value of the register for a vcpu. The value is the sanitized
>>> +      * system value with bits cleared for unsupported features for the
>>> +      * guest.
>>> +      */
>>> +     u64     vcpu_limit_val;
>>> +
>>> +     /*
>>> +      * The ftr_check_types is comprised of a set of 4 bits fields.
>> nit: s/bits field/bit field here and below
> 
> I will fix them.
> 
>>> +      * Each 4 bits field is for a feature indicated by the same bits
>>> +      * field of the ID register and indicates how the feature support
>>> +      * for guests needs to be checked.
>>> +      * The bit 0 indicates that the corresponding ID register field
>>> +      * is signed(1) or unsigned(0).
>>> +      * The bits [3:1] hold feature_check_type for the field.
>>> +      * If all zero, all features in the ID register are treated as unsigned
>>> +      * fields and checked based on Principles of the ID scheme for fields
>>> +      * in ID registers (FCT_LOWER_SAFE of feature_check_type).
>> values set by the guest are checked against host ID field values
>> according to FCT_LOWER_SAFE test? You do not actually explicitly explain
>> what the check is about although this may be obvious for you?
> 
> How about this ?
> 
>         /*
>          * The ftr_check_types is comprised of a set of 4 bit fields.
>          * Each 4 bit field is for a feature indicated by the same bit field
>          * of the ID register and indicates how the field needs to be checked
>          * (by arm64_check_feature_one) against the host's ID field when
>          * userspace tries to set the register.
>          * The bit 0 indicates that the corresponding ID register field is
>          * signed(1) or unsigned(0). The bits [3:1] hold feature_check_type
>          * for the field (FCT_LOWER_SAFE == 0, etc).
>          * e.g. for ID_AA64PFR0_EL1.SVE(bits [35:32]), bits[35:32] of
>          * ftr_check_types for the register should be 0. It means the SVE
>          * field is treated as an unsigned field, and userspace can set the
>          * field to a equal or lower value than the host's ID field value.
>          */
yep sounds clearer to me.
> 
>>> +      */
>>> +     u64     ftr_check_types;
>>> +
>>> +     /* Initialization function of the id_reg_info */
>>> +     void (*init)(struct id_reg_info *id_reg);
>>> +
>>> +     /* Register specific validation function */
>> validation callback? it does not register anything. We have check
>> customization means already in ftr_check_types so it is difficult to
>> guess at that point why this cb is needed, all the more so it applies
>> after the ftr_checks.
> 
> I am going to add the following comment. Does it look clear enough for you ?
> 
>         /*
>          * This is an optional ID register specific validation function.
>          * When userspace tries to set the ID register, arm64_check_features()
>          * will check if the requested value indicates any features that cannot
>          * be supported by KVM on the host.  But, some ID register fields need
>          * a special checking and this function can be used for such fields.
>          * e.g. KVM_CREATE_DEVICE must be used to configure GICv3 for a guest.
>          * ID_AA64PFR0_EL1.GIC shouldn't be set to 1 unless GICv3 is configured.
>          * The validation function for ID_AA64PFR0_EL1 could be used to check
>          * the field is consistent with GICv3 configuration.
>          */
> 
>>> +     int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
>>> +                     u64 val);
>>> +
>>> +     /* Return the reset value of the register for the vCPU */
>>> +     u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
>>> +                          const struct id_reg_info *id_reg);
>>> +};
>>> +
>>> +static void id_reg_info_init(struct id_reg_info *id_reg)
>>> +{
>>> +     id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
>>> +     if (id_reg->init)
>>> +             id_reg->init(id_reg);
>>> +}
>>> +
>>> +/*
>>> + * An ID register that needs special handling to control the value for the
>>> + * guest must have its own id_reg_info in id_reg_info_table.
>>> + * (i.e. the reset value is different from the host's sanitized value,
>>> + * the value is affected by opt-in features, some fields needs specific
>> s/needs/need
> 
> I will fix it.
> 
> Thank you for your review !
> 
> Regards
> Reiji
> 

Thanks

Eric

