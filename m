Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023B446939B
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 11:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbhLFK3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 05:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233542AbhLFK3W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 05:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638786354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQBIuWIxFEih3GHJKslMDt8rUDQ5DdbYFHC9uX/EZOI=;
        b=NeTs5N4jcR7fxwn3vdrj+0KA0F1AVNiF9zY/O3dd8lAD6kZyGOsTl8uOXHXKjwZ1+slrCV
        TPAZDBVMVuhpGl6oE4Pl0ucmRb4h59s4xf4Ess6iXcsNcriafdbCjNWZp74zKtLXF7pv46
        V7oOLHBSiUD6ggjNjGKh6XlIha+TUCM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-X6kYd62kPO6gzpvbZqvFyQ-1; Mon, 06 Dec 2021 05:25:53 -0500
X-MC-Unique: X6kYd62kPO6gzpvbZqvFyQ-1
Received: by mail-wr1-f70.google.com with SMTP id d7-20020a5d6447000000b00186a113463dso1869308wrw.10
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 02:25:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQBIuWIxFEih3GHJKslMDt8rUDQ5DdbYFHC9uX/EZOI=;
        b=npaWGu/UT0CQCNDfrtKcXTwByw7JLJXlgqxQz+LkMYzD7UFbXorZSzDHYtQofTMohv
         n1ZBj13fwis/K1sAqEiHkCx2opmbt/vRvKBmq17PDcJ4chJyoCWOoVzaZiT7dyCnz3MC
         8vo8MghY7LA4/Yk2G/Y84Efv+mA8jKQr7bdR8RRz+t1t6C5b83REOncX32fWGk1qoqHX
         G42cIcOUCJy3SF/042P7Z0qLdXMzGe3ZUX2cvHyu8lJG2ZLLomFtbZFe50tWfA1BiqqK
         qlqcTJTjN2rIoTAOvjUVa/MxWdwnGa+GjRLfdi2qhCg2Xg9gwp3IPIgFyyL6zYhGZteW
         2ViQ==
X-Gm-Message-State: AOAM530XI9DoL6LSQfkHvjNrXn91BAyanic4Kf6YF2G3CrAhdUWRCW5h
        dtH4JnS+UMNMAEC9SptZYlrBv5GEPQrgOvrgk3MumaBokCdVfE4AmIJFAuRwyFe1IgkxnNoMD5m
        8jVtuBAzEfu7J
X-Received: by 2002:a1c:1dd6:: with SMTP id d205mr23576807wmd.77.1638786351785;
        Mon, 06 Dec 2021 02:25:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlq/xEQf7MKCqzhG0dI+QtNXPhH0rBZ34S9sVaRqNzASvWIfN5C7xLtZxIJ/7QJ+PfzGBoCA==
X-Received: by 2002:a1c:1dd6:: with SMTP id d205mr23576792wmd.77.1638786351571;
        Mon, 06 Dec 2021 02:25:51 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g4sm10828174wro.12.2021.12.06.02.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 02:25:51 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
 <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
 <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
 <CAAeT=Fy7JuCQKgy-ZaS9wPe6h93_WRMYmhihovYDjyg2a+BqNw@mail.gmail.com>
 <Ya3dQeXjUxAG8cCJ@monolith.localdoman>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <d914471e-53a4-e8a4-cc79-402940519747@redhat.com>
Date:   Mon, 6 Dec 2021 11:25:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Ya3dQeXjUxAG8cCJ@monolith.localdoman>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

On 12/6/21 10:52 AM, Alexandru Elisei wrote:
> Hi,
> 
> On Sat, Dec 04, 2021 at 09:39:59AM -0800, Reiji Watanabe wrote:
>> Hi Eric,
>>
>> On Sat, Dec 4, 2021 at 6:14 AM Eric Auger <eauger@redhat.com> wrote:
>>>
>>> Hi Reiji,
>>>
>>> On 12/4/21 2:04 AM, Reiji Watanabe wrote:
>>>> Hi Eric,
>>>>
>>>> On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
>>>>>
>>>>> Hi Reiji,
>>>>>
>>>>> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
>>>>>> Hi Eric,
>>>>>>
>>>>>> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>>>>>>
>>>>>>> Hi Reiji,
>>>>>>>
>>>>>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>>>>>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
>>>>>>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
>>>>>>>> expose the value for the guest as it is.  Since KVM doesn't support
>>>>>>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
>>>>>>>> exopse 0x0 (PMU is not implemented) instead.
>>>>>>> s/exopse/expose
>>>>>>>>
>>>>>>>> Change cpuid_feature_cap_perfmon_field() to update the field value
>>>>>>>> to 0x0 when it is 0xf.
>>>>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>>>>>>> guest should not use it as a PMUv3?
>>>>>>
>>>>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>>>>>>> guest should not use it as a PMUv3?
>>>>>>
>>>>>> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
>>>>>> Arm ARM says:
>>>>>>   "IMPLEMENTATION DEFINED form of performance monitors supported,
>>>>>>    PMUv3 not supported."
>>>>>>
>>>>>> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
>>>>>> be exposed to guests (And this patch series doesn't allow userspace
>>>>>> to set the fields to 0xf for guests).
>>>>> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
>>>>> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
>>>>> init request if the host pmu is implementation defined?
>>>>
>>>> KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
>>>> kvm_reset_vcpu() if the host PMU is implementation defined.
>>>
>>> OK. This was not obvsious to me.
>>>
>>>                 if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
>>>                         ret = -EINVAL;
>>>                         goto out;
>>>                 }
>>>
>>> kvm_perf_init
>>> +       if (perf_num_counters() > 0)
>>> +               static_branch_enable(&kvm_arm_pmu_available);
>>>
>>> But I believe you ;-), sorry for the noise
>>
>> Thank you for the review !
>>
>> I didn't find the code above in v5.16-rc3, which is the base code of
>> this series.  So, I'm not sure where the code came from (any kvmarm
>> repository branch ??).
>>
>> What I see in v5.16-rc3 is:
>> ----
>> int kvm_perf_init(void)
>> {
>>         return perf_register_guest_info_callbacks(&kvm_guest_cbs);
>> }
>>
>> void kvm_host_pmu_init(struct arm_pmu *pmu)
>> {
>>         if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
>>             !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
>>                 static_branch_enable(&kvm_arm_pmu_available);
>> }
>> ----
>>
>> And I don't find any other code that enables kvm_arm_pmu_available.
> 
> The code was recently changed (in v5.15 I think), I think Eric is looking
> at an older version.

Yes I was "googling" kvm_arm_pmu_available enablement and I missed the
kvm_pmu_probe_pmuver() != ID_AA64DFR0_PMUVER_IMP_DEF check addition. So
except the heterogenous case reported by Alexandru below, we should be
fine. Sorry for the noise.

Thanks

Eric
> 
>>
>> Looking at the KVM's PMUV3 support code for guests in v5.16-rc3,
>> if KVM allows userspace to configure KVM_ARM_VCPU_PMU_V3 even with
>> ID_AA64DFR0_PMUVER_IMP_DEF on the host (, which I don't think it does),
>> I think we should fix that to not allow that.
> 
> I recently started looking into that too. If there's only one PMU, then the
> guest won't see the value IMP DEF for PMUVer (userspace cannot set the PMU
> feature because !kvm_arm_support_pmu_v3()).
> 
> On heterogeneous systems with multiple PMUs, it gets complicated. I don't
> have any such hardware, but what I think will happen is that KVM will
> enable the static branch if there is at least one PMU with
> PMUVer != IMP_DEF, even if there are other PMUs with PMUVer = IMP_DEF. But
> read_sanitised_ftr_reg() will always return 0 for the
> PMUVer field because the field is defined as FTR_EXACT with a safe value of
> 0 in cpufeature.c. So the guest ends up seeing PMUVer = 0.
> 
> I'm not sure if this is the case because I'm not familiar with the cpu
> features code, but I planning to investigate further.
> 
> Thanks,
> Alex
> 
>> (I'm not sure how KVM's PMUV3 support code is implemented in the
>> code that you are looking at though)
>>
>> Thanks,
>> Reiji
> 

