Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751B54661D1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357072AbhLBLAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:00:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356693AbhLBLAk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:00:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638442635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2VcVFQrB5DiBW+WXhArOQYyBQnCLPGn334r2cU2z28=;
        b=KtToVVO3GJ+iE/K/cpWwEBpqq1DtbnBOGMCuXrCu8ukgIBRsQeEGmxBUGqJ1/3s+zACfxB
        Z0VExgTeq/PSBIkyGGI3qRXFtkttn175rLGKy9UqpH8JywRgJ+CmtHmk03ZuEn2OHLIBkX
        LILjnuG/D2EbSOUE0AuR1cdXn108uz4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-5VZFunW4MUy6qnRPYN8oSw-1; Thu, 02 Dec 2021 05:57:14 -0500
X-MC-Unique: 5VZFunW4MUy6qnRPYN8oSw-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so4914403wro.18
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 02:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2VcVFQrB5DiBW+WXhArOQYyBQnCLPGn334r2cU2z28=;
        b=5emQIvKbSVkkD9KkBvMn7bJ87RIAnpHAMtpTcrj/ojWBCOSuGh4VjWQlyJpSfYoDmT
         v/PHJUkbzGkY2ZWe9oDGfkmffjgBYlohCiBXUgej3mSym3u/GWVsJt7x4Rplu5Nxzdwp
         UGk2S1PEDJ/vRw4BHfeU1Jb5I2ZLQ2kwGDoDdDMSTxvF77hzKTZaiyhItGFB2EPPY0Yj
         QAWuUdJPJ+x9JfOcfSr7QiUXDCg5sIDipI4CDa6aHeGQC3gWd7gEHRZbK49xsInqD1S8
         wizX4u/8FIQ/FyxkBTl0h9adCERK5Sw4Z/ILOm5N6j4IeuwhjPjb7dLmT6RtaO2NhWWg
         zlkA==
X-Gm-Message-State: AOAM530Lu/NwiSb0httUHO04HDbiRJXgBUBlfCbaB61EsSaXTDM1hLoP
        kVm24h9yTU8qTEcG+zIeJmElJDT/m+SH9LfFtuxdMJDtDUi9OYseHkJKplIvpr73BSHpc0rFiLG
        h/MJOak4Gl6Vy
X-Received: by 2002:adf:aac5:: with SMTP id i5mr13864059wrc.67.1638442633662;
        Thu, 02 Dec 2021 02:57:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyX44La4y5VA1cgP3RPzlda8vKuQzx3m3QaQe/i+Qj0upafaYqtzXJF52EratMa3sVUXhqR4g==
X-Received: by 2002:adf:aac5:: with SMTP id i5mr13864039wrc.67.1638442633487;
        Thu, 02 Dec 2021 02:57:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ay21sm1902044wmb.7.2021.12.02.02.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:57:12 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
Date:   Thu, 2 Dec 2021 11:57:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
>>> expose the value for the guest as it is.  Since KVM doesn't support
>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
>>> exopse 0x0 (PMU is not implemented) instead.
>> s/exopse/expose
>>>
>>> Change cpuid_feature_cap_perfmon_field() to update the field value
>>> to 0x0 when it is 0xf.
>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>> guest should not use it as a PMUv3?
> 
>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>> guest should not use it as a PMUv3?
> 
> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> Arm ARM says:
>   "IMPLEMENTATION DEFINED form of performance monitors supported,
>    PMUv3 not supported."
> 
> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> be exposed to guests (And this patch series doesn't allow userspace
> to set the fields to 0xf for guests).
What I don't get is why this isn't detected before (in kvm_reset_vcpu).
if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
init request if the host pmu is implementation defined?

Thanks

Eric
> 
> Thanks,
> Reiji
> 
>>
>> Eric
>>>
>>> Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/include/asm/cpufeature.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>> index ef6be92b1921..fd7ad8193827 100644
>>> --- a/arch/arm64/include/asm/cpufeature.h
>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>> @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
>>>
>>>       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
>>>       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
>>> -             val = 0;
>>> +             return (features & ~mask);
>>>
>>>       if (val > cap) {
>>>               features &= ~mask;
>>>
>>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

