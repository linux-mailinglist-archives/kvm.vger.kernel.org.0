Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CFA4686AF
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344790AbhLDRnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 12:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbhLDRnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 12:43:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F59FC0613F8
        for <kvm@vger.kernel.org>; Sat,  4 Dec 2021 09:40:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p18so4274194plf.13
        for <kvm@vger.kernel.org>; Sat, 04 Dec 2021 09:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nAML//PJUUZoaUHQ1962i3snmMVvfIzEeG+c390MWrw=;
        b=YKzSumkwYSJVf9OzGVbWTtFymqaakJiJZkTQrt5sEWnXwiD7jim8POQZHJVunxLPb9
         A53M8zWKaIEoibqBNjdrElSIDwbQ6V6pjywTVBQrFvMRHmeYkaiMRSrIX8jaVS2m8vkG
         rTovtpjuBwoC2SmW09dCrCHM/idCkyhFqKQW/T21PHHnpEB/H4B55Nuu1mQSBhQI9C8i
         VWw6oHjXgyuew6BLR5lHex5arHglka3fT5Ic1bJczb8nefaJrWUFQv4WV/JGn7WNz/+b
         hUNs2fzpbTmYQWcGyNAy+Rez+8fhYeqWiAU33QJGb0fqyPIj02ypbxDHDX1MZihHa2e8
         54Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nAML//PJUUZoaUHQ1962i3snmMVvfIzEeG+c390MWrw=;
        b=gBOai/Cbt17yKH1jxepEjNQJoBmo4Lt5f/tSo3MSwP/jAaCkiX74mP5qczLNhJIjo/
         KRAfF0Fx01iQq/4VYiYdfoKdOZIsagbJykQhFMlrgLMkd9Lxk6m4kaUmbPv5mqj319I/
         1s7CH2xv/jZraLVJQ+Q59vW+LxQW+T4iPB/bRNsdeyYsLkjeiZSn2PAlXh51cv9VWT+u
         HFGtduZ4uGB7Qfmdfm9a7AaKACaYFWP8HCXgilwBmD8F7KHRx1DEJHTa/fPTzu+3crY5
         Dx67MDC1YCrM3IHFebN2M21apQk1Ay5JZyOmLrbwEnZHQSRZsMLpQPQv2tLkXn2Jo0Tn
         nd9w==
X-Gm-Message-State: AOAM5308dvZeuCjbu3qll3VylZB8gexuIRpOPWVYb3q19MJkMaHYZJoK
        XW0aWqMCzVJZpU8UfCXdsp+8SO2wuweEMDWo4L+wrg==
X-Google-Smtp-Source: ABdhPJySXkYEx4y6c/qY5zQLq1N0SKWwbAw86C1KE+EUAdCgGivHvW6bJ2rH009gUore2EP+VCxR+ox75gwVxHMMhAA=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr23805796pjb.110.1638639615375;
 Sat, 04 Dec 2021 09:40:15 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com> <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com> <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
 <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
In-Reply-To: <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 4 Dec 2021 09:39:59 -0800
Message-ID: <CAAeT=Fy7JuCQKgy-ZaS9wPe6h93_WRMYmhihovYDjyg2a+BqNw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Eric Auger <eauger@redhat.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Sat, Dec 4, 2021 at 6:14 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 12/4/21 2:04 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> >>> Hi Eric,
> >>>
> >>> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> >>>>
> >>>> Hi Reiji,
> >>>>
> >>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> >>>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> >>>>> expose the value for the guest as it is.  Since KVM doesn't support
> >>>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> >>>>> exopse 0x0 (PMU is not implemented) instead.
> >>>> s/exopse/expose
> >>>>>
> >>>>> Change cpuid_feature_cap_perfmon_field() to update the field value
> >>>>> to 0x0 when it is 0xf.
> >>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >>>> guest should not use it as a PMUv3?
> >>>
> >>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >>>> guest should not use it as a PMUv3?
> >>>
> >>> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> >>> Arm ARM says:
> >>>   "IMPLEMENTATION DEFINED form of performance monitors supported,
> >>>    PMUv3 not supported."
> >>>
> >>> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> >>> be exposed to guests (And this patch series doesn't allow userspace
> >>> to set the fields to 0xf for guests).
> >> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
> >> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
> >> init request if the host pmu is implementation defined?
> >
> > KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
> > kvm_reset_vcpu() if the host PMU is implementation defined.
>
> OK. This was not obvsious to me.
>
>                 if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
>                         ret = -EINVAL;
>                         goto out;
>                 }
>
> kvm_perf_init
> +       if (perf_num_counters() > 0)
> +               static_branch_enable(&kvm_arm_pmu_available);
>
> But I believe you ;-), sorry for the noise

Thank you for the review !

I didn't find the code above in v5.16-rc3, which is the base code of
this series.  So, I'm not sure where the code came from (any kvmarm
repository branch ??).

What I see in v5.16-rc3 is:
----
int kvm_perf_init(void)
{
        return perf_register_guest_info_callbacks(&kvm_guest_cbs);
}

void kvm_host_pmu_init(struct arm_pmu *pmu)
{
        if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
            !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
                static_branch_enable(&kvm_arm_pmu_available);
}
----

And I don't find any other code that enables kvm_arm_pmu_available.

Looking at the KVM's PMUV3 support code for guests in v5.16-rc3,
if KVM allows userspace to configure KVM_ARM_VCPU_PMU_V3 even with
ID_AA64DFR0_PMUVER_IMP_DEF on the host (, which I don't think it does),
I think we should fix that to not allow that.
(I'm not sure how KVM's PMUV3 support code is implemented in the
code that you are looking at though)

Thanks,
Reiji
