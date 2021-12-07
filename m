Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22D46B365
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 08:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhLGHLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 02:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhLGHL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 02:11:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E206BC061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 23:07:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b13so8798033plg.2
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 23:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rn4+v2QcqaALO4pnCHE9/BztptlFZRDNfxFrHECjVow=;
        b=DAo2hH7qiCVrbWqY/8uGgaz7SaaqMfQXZuHeW7/LHckJzCpf9TUGL6n4lH92Sftm2w
         VKqAkhcDniJMQ2MsdtfbnDtQeWYmcKL6qKnvWTZ392bLjBIRsVl9CJIObRGywneCAI/d
         emMK8hOc51w56tWJJ6ZyvEiH28Utm1z64oDE/DvtOhn8BNoOtT+iikpMyW4VxHSukhze
         udWvDdCB5I5CECBv/ZDjSCigB/7lD9/7JVkrYa7IuJU8Czh/fAaAsOdJyishf2u+uAsZ
         0+4U/Frf1n7XuT2Iq6RSuUlmxMsdFryHlYFlfvZ5pQPjOWzhoYzlFzo3O+cTTNrGx9y6
         YkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rn4+v2QcqaALO4pnCHE9/BztptlFZRDNfxFrHECjVow=;
        b=atQHIMyZ3e2G2u4X+/I2z+qSmacRdEmlhSpCx7eq2LwxCCwV+8pvHITJPAcPU47yGB
         W4AcSRGfE4NB0Fqi5u4nCzcmp6G3FL0krrg+gb1NhTSyz0BvTNEABT1S6O8TIvN8zR1+
         LsVkntoGFsGJVLfjY76hJvT0u3KVEY11hvkdU9GmdjMV3YP2LYdtNfgITcLUQuLfmmMX
         dK0bu9xhD2mM6MS02wetVFAo1Qnh5rPmRZrxmghWNwsmXhd/7u9QsjfMZUfA+92gO7T4
         qqNmJtifCINCjR8tvw1uQsHz+agq3WS8cwhUAZsk/OW5u5LM9OhKk0BDiTiCQdq8G5Uh
         FmHQ==
X-Gm-Message-State: AOAM532elS317Iy57BBMkdCVoGI3ziYkGPev4CR9Edt7mFGbXgrmVRW+
        D+vmwoz0a4xKHuImzpBE/8lM3QXmOVMEfWnKwLa87A==
X-Google-Smtp-Source: ABdhPJwEa9nptEMlsMtfQEwTkUlEcsKIH5P7KRVQtqfdruLH1lQNqxc9o7Q3Eo854lDqcKIK3+6Y6Daea8XvsgbvO7A=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr4526813pjb.110.1638860876153;
 Mon, 06 Dec 2021 23:07:56 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com> <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com> <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
 <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com> <CAAeT=Fy7JuCQKgy-ZaS9wPe6h93_WRMYmhihovYDjyg2a+BqNw@mail.gmail.com>
 <Ya3dQeXjUxAG8cCJ@monolith.localdoman> <d914471e-53a4-e8a4-cc79-402940519747@redhat.com>
In-Reply-To: <d914471e-53a4-e8a4-cc79-402940519747@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 6 Dec 2021 23:07:39 -0800
Message-ID: <CAAeT=Fy7BmrL7n7YTgA4sfwsSLiKkWHgNB_UeK29pVjfFJJ_fQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Eric Auger <eauger@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Mon, Dec 6, 2021 at 2:25 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi
>
> On 12/6/21 10:52 AM, Alexandru Elisei wrote:
> > Hi,
> >
> > On Sat, Dec 04, 2021 at 09:39:59AM -0800, Reiji Watanabe wrote:
> >> Hi Eric,
> >>
> >> On Sat, Dec 4, 2021 at 6:14 AM Eric Auger <eauger@redhat.com> wrote:
> >>>
> >>> Hi Reiji,
> >>>
> >>> On 12/4/21 2:04 AM, Reiji Watanabe wrote:
> >>>> Hi Eric,
> >>>>
> >>>> On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
> >>>>>
> >>>>> Hi Reiji,
> >>>>>
> >>>>> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> >>>>>> Hi Eric,
> >>>>>>
> >>>>>> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> >>>>>>>
> >>>>>>> Hi Reiji,
> >>>>>>>
> >>>>>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>>>>>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> >>>>>>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> >>>>>>>> expose the value for the guest as it is.  Since KVM doesn't support
> >>>>>>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> >>>>>>>> exopse 0x0 (PMU is not implemented) instead.
> >>>>>>> s/exopse/expose
> >>>>>>>>
> >>>>>>>> Change cpuid_feature_cap_perfmon_field() to update the field value
> >>>>>>>> to 0x0 when it is 0xf.
> >>>>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >>>>>>> guest should not use it as a PMUv3?
> >>>>>>
> >>>>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >>>>>>> guest should not use it as a PMUv3?
> >>>>>>
> >>>>>> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> >>>>>> Arm ARM says:
> >>>>>>   "IMPLEMENTATION DEFINED form of performance monitors supported,
> >>>>>>    PMUv3 not supported."
> >>>>>>
> >>>>>> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> >>>>>> be exposed to guests (And this patch series doesn't allow userspace
> >>>>>> to set the fields to 0xf for guests).
> >>>>> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
> >>>>> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
> >>>>> init request if the host pmu is implementation defined?
> >>>>
> >>>> KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
> >>>> kvm_reset_vcpu() if the host PMU is implementation defined.
> >>>
> >>> OK. This was not obvsious to me.
> >>>
> >>>                 if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
> >>>                         ret = -EINVAL;
> >>>                         goto out;
> >>>                 }
> >>>
> >>> kvm_perf_init
> >>> +       if (perf_num_counters() > 0)
> >>> +               static_branch_enable(&kvm_arm_pmu_available);
> >>>
> >>> But I believe you ;-), sorry for the noise
> >>
> >> Thank you for the review !
> >>
> >> I didn't find the code above in v5.16-rc3, which is the base code of
> >> this series.  So, I'm not sure where the code came from (any kvmarm
> >> repository branch ??).
> >>
> >> What I see in v5.16-rc3 is:
> >> ----
> >> int kvm_perf_init(void)
> >> {
> >>         return perf_register_guest_info_callbacks(&kvm_guest_cbs);
> >> }
> >>
> >> void kvm_host_pmu_init(struct arm_pmu *pmu)
> >> {
> >>         if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
> >>             !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
> >>                 static_branch_enable(&kvm_arm_pmu_available);
> >> }
> >> ----
> >>
> >> And I don't find any other code that enables kvm_arm_pmu_available.
> >
> > The code was recently changed (in v5.15 I think), I think Eric is looking
> > at an older version.
>
> Yes I was "googling" kvm_arm_pmu_available enablement and I missed the
> kvm_pmu_probe_pmuver() != ID_AA64DFR0_PMUVER_IMP_DEF check addition. So
> except the heterogenous case reported by Alexandru below, we should be
> fine. Sorry for the noise.

Understood. Thank you for the confirmation.

Regards,
Reiji


> >>
> >> Looking at the KVM's PMUV3 support code for guests in v5.16-rc3,
> >> if KVM allows userspace to configure KVM_ARM_VCPU_PMU_V3 even with
> >> ID_AA64DFR0_PMUVER_IMP_DEF on the host (, which I don't think it does),
> >> I think we should fix that to not allow that.
> >
> > I recently started looking into that too. If there's only one PMU, then the
> > guest won't see the value IMP DEF for PMUVer (userspace cannot set the PMU
> > feature because !kvm_arm_support_pmu_v3()).
> >
> > On heterogeneous systems with multiple PMUs, it gets complicated. I don't
> > have any such hardware, but what I think will happen is that KVM will
> > enable the static branch if there is at least one PMU with
> > PMUVer != IMP_DEF, even if there are other PMUs with PMUVer = IMP_DEF. But
> > read_sanitised_ftr_reg() will always return 0 for the
> > PMUVer field because the field is defined as FTR_EXACT with a safe value of
> > 0 in cpufeature.c. So the guest ends up seeing PMUVer = 0.
> >
> > I'm not sure if this is the case because I'm not familiar with the cpu
> > features code, but I planning to investigate further.
> >
> > Thanks,
> > Alex
> >
> >> (I'm not sure how KVM's PMUV3 support code is implemented in the
> >> code that you are looking at though)
> >>
> >> Thanks,
> >> Reiji
> >
>
