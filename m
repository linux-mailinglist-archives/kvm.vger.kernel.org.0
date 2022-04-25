Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E27750E63B
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbiDYQz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiDYQz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:55:58 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DD6289AC
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:52:52 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ef5380669cso154993717b3.9
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qIcRenMMpWigheKb0Vhi43J2hbMZZgdFaZyphKl4fwg=;
        b=QAibGEGHX61OHsaX/ia5uydAvlJAPScleM38ja91sIfJh+2GOFiWLKuWhJ/QL8W9cW
         JWQq6OB8WYZaaQOy7w9qPe15+IUGZsGdnXtgVE68T3AgUJ6nBdF6Tg1oNYW3JYjg4FE+
         307vHVvGHyxCQpEYazSMJbZHQNu8TEf+VwYAccF+NVG4hyliieqB0k83sqZo7iAmYPu+
         qZAgJExcQkHnfdKf0W8Su2s/Np0ESvzKOKCEpck4McUHbEMoavkHSArEEwrY3qeor6RI
         d/A2Q4qOnxGaTQuBlDWI4eRvKldQ822RgxDx+wY3l62M3H3KsYqghS5cyVbVMyns6nql
         eu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qIcRenMMpWigheKb0Vhi43J2hbMZZgdFaZyphKl4fwg=;
        b=Q+yvuKZgVcdctGC/zKUetIxVgFGthLzHoXclYOP3LJDLFcBbT0tFgkq+qwn8USh5W/
         RLF2Pj5CHI3AB7g+7t3dAWEgDqsOAxoFyfkN8Bm3h+TAieZpu6TkNu4LHGQcKXUqSwbF
         A/XG3XUns5Nzvl3lo2hycArcXrLsQ84iPDyYLXbxKhJfgfyVzrAKqhC4xPEo4rKehQol
         gRTlK+bswgaWSWu8FvEEPi8MRoIrJQwVHlUrK26Wq3sDdn30uSFN8GOjKjbF7uGVBope
         Al0FQ42GTf+eghf5TFNydFKTZ6n4NvkNRBD1ZKQClfR0+zPhwVDkmUzzqbtzZpcqXmoN
         PZ/Q==
X-Gm-Message-State: AOAM531x3Q+bFhVoYKAmcAYt2q5Sr8bKI/vhURolSDNEVnSBCjNIqBkQ
        Te0sAxZ/Jd363ZiE5Y82QX/P6rwoOFZOCAAYSbkRtQ==
X-Google-Smtp-Source: ABdhPJzgqS0ECp62ZhcRLjcwpRBm/c8aGTT8Ey8cBQyQzBfmAP0sXY+4TRuT1kAP4NpRMuQPs9oPLcREIzEnqG1prYc=
X-Received: by 2002:a81:1f03:0:b0:2f4:c6c4:9177 with SMTP id
 f3-20020a811f03000000b002f4c6c49177mr18255228ywf.427.1650905571631; Mon, 25
 Apr 2022 09:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-7-rananta@google.com>
 <CAAeT=FxPwaCGw32Xy7F4aY3CEtAhB29t-KsA=ptLQN8hvtsvrg@mail.gmail.com>
In-Reply-To: <CAAeT=FxPwaCGw32Xy7F4aY3CEtAhB29t-KsA=ptLQN8hvtsvrg@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 25 Apr 2022 09:52:40 -0700
Message-ID: <CAJHc60y4bR4Ni-kyt4PHT40ckDS531Cuf-sxM2ebB2hHfRpOEw@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] Docs: KVM: Add doc for the bitmap firmware registers
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 24, 2022 at 11:31 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add the documentation for the bitmap firmware registers in
> > hypercalls.rst and api.rst. This includes the details for
> > KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
> > KVM_REG_ARM_VENDOR_HYP_BMAP registers.
> >
> > Since the document is growing to carry other hypercall related
> > information, make necessary adjustments to present the document
> > in a generic sense, rather than being PSCI focused.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst            | 16 ++++
> >  Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
> >  2 files changed, 92 insertions(+), 18 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 85c7abc51af5..ac489191d0a9 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
> >
> >    0x6030 0000 0014 <regno:16>
> >
> > +arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
> > +
> > +  0x6030 0000 0016 <regno:16>
> > +
> > +The bitmap feature firmware registers exposes the hypercall services that are
> > +available for userspace to configure. The set bits corresponds to the services
> > +that are available for the guests to access. By default, KVM sets all the
> > +supported bits during VM initialization. The userspace can discover the
> > +available services via KVM_GET_ONE_REG, and write back the bitmap corresponding
> > +to the features that it wishes guests to see via KVM_SET_ONE_REG.
> > +
> > +Note: These registers are immutable once any of the vCPUs of the VM has run at
> > +least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
> > +
> > +(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
> > +
> >  arm64 SVE registers have the following bit patterns::
> >
> >    0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> > diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > index d52c2e83b5b8..6327c504b2fb 100644
> > --- a/Documentation/virt/kvm/arm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> > @@ -1,32 +1,32 @@
> >  .. SPDX-License-Identifier: GPL-2.0
> >
> > -=========================================
> > -Power State Coordination Interface (PSCI)
> > -=========================================
> > +=======================
> > +ARM Hypercall Interface
> > +=======================
> >
> > -KVM implements the PSCI (Power State Coordination Interface)
> > -specification in order to provide services such as CPU on/off, reset
> > -and power-off to the guest.
> > +KVM handles the hypercall services as requested by the guests. New hypercall
> > +services are regularly made available by the ARM specification or by KVM (as
> > +vendor services) if they make sense from a virtualization point of view.
> >
> > -The PSCI specification is regularly updated to provide new features,
> > -and KVM implements these updates if they make sense from a virtualization
> > -point of view.
> > -
> > -This means that a guest booted on two different versions of KVM can
> > -observe two different "firmware" revisions. This could cause issues if
> > -a given guest is tied to a particular PSCI revision (unlikely), or if
> > -a migration causes a different PSCI version to be exposed out of the
> > -blue to an unsuspecting guest.
> > +This means that a guest booted on two different versions of KVM can observe
> > +two different "firmware" revisions. This could cause issues if a given guest
> > +is tied to a particular version of a hypercall service, or if a migration
> > +causes a different version to be exposed out of the blue to an unsuspecting
> > +guest.
> >
> >  In order to remedy this situation, KVM exposes a set of "firmware
> >  pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> >  interface. These registers can be saved/restored by userspace, and set
> > -to a convenient value if required.
> > +to a convenient value as required.
> >
> > -The following register is defined:
> > +The following registers are defined:
> >
> >  * KVM_REG_ARM_PSCI_VERSION:
> >
> > +  KVM implements the PSCI (Power State Coordination Interface)
> > +  specification in order to provide services such as CPU on/off, reset
> > +  and power-off to the guest.
> > +
> >    - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> >      (and thus has already been initialized)
> >    - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> > @@ -74,4 +74,62 @@ The following register is defined:
> >      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> >        The workaround is always active on this vCPU or it is not needed.
> >
> > -.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> > +
> > +Bitmap Feature Firmware Registers
> > +---------------------------------
> > +
> > +Contrary to the above registers, the following registers exposes the hypercall
> > +services in the form of a feature-bitmap to the userspace. This bitmap is
> > +translated to the services that are available to the guest. There is a register
> > +defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
> > +
> > +By default, these registers are set with the upper limit of the features that
> > +are supported. This way userspace can discover all the electable hypercall services
> > +via GET_ONE_REG. The user-space can write-back the desired bitmap back via
> > +SET_ONE_REG. The features for the registers that are untouched, probably because
> > +userspace isn't aware of them, will be exposed as is to the guest.
> > +
> > +Note that KVM would't allow the userspace to configure the registers anymore once
> > +any of the vCPUs has run at least once. Instead, it will return a -EBUSY.
> > +
> > +The psuedo-firmware bitmap register are as follows:
> > +
> > +* KVM_REG_ARM_STD_BMAP:
> > +    Controls the bitmap of the ARM Standard Secure Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
> > +      The bit represents the services offered under v1.0 of ARM True Random
> > +      Number Generator (TRNG) specification, ARM DEN0098.
> > +
> > +* KVM_REG_ARM_STD_HYP_BMAP:
> > +    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
> > +      The bit represents the Paravirtualized Time service as represented by
> > +      ARM DEN0057A.
> > +
> > +* KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
> > +      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
> > +      function-id
>
> Looking at the code,
> the bit also represents ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID.
>
You are right, I missed it here in the doc. I'll fix this.

Regards,
Raghavendra

> Thanks,
> Reiji
>
>
> > +
> > +    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
> > +      The bit represents the Precision Time Protocol KVM service.
> > +
> > +Errors:
> > +
> > +    =======  =============================================================
> > +    -ENOENT   Unknown register accessed.
> > +    -EBUSY    Attempt a 'write' to the register after the VM has started.
> > +    -EINVAL   Invalid bitmap written to the register.
> > +    =======  =============================================================
> > +
> > +.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> > \ No newline at end of file
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
