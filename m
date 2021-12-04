Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318BB4681B3
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 02:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354272AbhLDBHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 20:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbhLDBHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 20:07:52 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A19C061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 17:04:27 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p13so4490970pfw.2
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 17:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XE1lgBHY1qjRhoYofuOFOoV/YwT3xICq/rIHwhXBdqc=;
        b=LQswGke5VHeD+dcHpM0HR1sTjV718lOri+p9ap3AWxvHaVYqT3z0Qu5HKofsfSmI6l
         re4YXfADVjvD47PWcqLWzd/yxEe9v87Lqm9Ie4gQbwot+W6VZc+TV59LgVIfQ9t+L8yV
         V8tA4cGG/dgdNmqCvZiMRffTla8nA09bIk846uLw+nNCMY749ZArqdo2Ot4ZUavI4Vam
         7YCqJ//Y7DVs2hxwO/YlvS3ywEuKJ2llxcS2qaYYwXH8ruPRmIQ+y3BpaAdW8ze11Xsc
         loXwvufLKFrlSb8aWi3kxF0P7fr+n0RS92KO/MpIbI6mBH5lePdPan91H+TAndcmn7i7
         KG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XE1lgBHY1qjRhoYofuOFOoV/YwT3xICq/rIHwhXBdqc=;
        b=WMeK0MYXnsJA9R1TI6DyfkJSw8s+HcePaRlRCN7gaxN7BNk8CVz0dyzBLc7p6uj186
         CU6MmCLq6x/FN3lNwqeEI128Ll9WmXd5yYMbkkHGV25MqgLv1Ui8gp35dhJEE9Isd1q9
         aDtEm7mE6xdQZoaTBuj63UGfX6zQYSayTe3T5jpKYIL/qTbANcsx6Vvh1uWtgoSPsVRU
         HCqFwR2AeSXFK3Ss9eQbFzHzO07aSxqQFazfrDhbZIjoyUEUajq2Ex6UZ20wx0A3CKwQ
         D0or8H7wEBl+gQll6zI033CJtqt+FhVcDYY471Xj8asTZluwKKGLlYQLE6VJjVRP3wDs
         nSjw==
X-Gm-Message-State: AOAM530Tvu980uXU/iVmiAmf5D0QD7yetwxwmf7GhhYsPi/i0YRQhaPq
        Y2DVyeWn9iCs/7sjdfQzafhF0dqik2u2m8zBvIvhAg==
X-Google-Smtp-Source: ABdhPJxAmeyiI93S2DwlX8TZyZoxgW2fHpUKvj4k/QXSw5lXDVt0PSll4BikwnO6GpDsx5uU7xiFtMjjJYepa2ojll4=
X-Received: by 2002:a63:c042:: with SMTP id z2mr951044pgi.491.1638579867102;
 Fri, 03 Dec 2021 17:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com> <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
In-Reply-To: <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 3 Dec 2021 17:04:11 -0800
Message-ID: <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
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

On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> >>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> >>> expose the value for the guest as it is.  Since KVM doesn't support
> >>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> >>> exopse 0x0 (PMU is not implemented) instead.
> >> s/exopse/expose
> >>>
> >>> Change cpuid_feature_cap_perfmon_field() to update the field value
> >>> to 0x0 when it is 0xf.
> >> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >> guest should not use it as a PMUv3?
> >
> >> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >> guest should not use it as a PMUv3?
> >
> > For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > Arm ARM says:
> >   "IMPLEMENTATION DEFINED form of performance monitors supported,
> >    PMUv3 not supported."
> >
> > Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > be exposed to guests (And this patch series doesn't allow userspace
> > to set the fields to 0xf for guests).
> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
> init request if the host pmu is implementation defined?

KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
kvm_reset_vcpu() if the host PMU is implementation defined.

The AA64DFR0 and DFR0 registers for a vCPU without KVM_ARM_VCPU_PMU_V3
indicates IMPLEMENTATION DEFINED PMU support, which is not correct.

Thanks,
Reiji
