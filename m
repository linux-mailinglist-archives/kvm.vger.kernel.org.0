Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3D4FFC00
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiDMREh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbiDMREb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 13:04:31 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E1674FA
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:02:08 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p65so4856688ybp.9
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yd7U9Ti5RDg8NJvME8HI4I8ItMkX9qmr1z2pf1IvYK8=;
        b=ewxTAo1Qxsd5Ttb0O86NkxjzsCqY01zIpBDm2cwF6BqdFEGon1NsnDPdf682lfbOa9
         Shw2OpMrmSKooJl5WijgnYp33iEwsr20SAiQIrfsZjy0wJsgzKLugwH65+GOrV+knXDI
         YT2tG5uoU9WZUy5YcBjkbcLtJYnXmvsIyf9yF5A7Td9FOLGNGy7G2ZFUvAqilgOBVGmE
         A7uVZqdOms/O/YK9ifqhJ9rCAAOsIuIQy54vWIG9TFj24ufGOhIe7QyWiOB9vLocsjUo
         FqxxsaFY6BuZ3B43l/MjCcOMumvMep4s/a6U2Mn/fp3OhkrkefL71H2LuR0a4ANnGF3D
         GnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yd7U9Ti5RDg8NJvME8HI4I8ItMkX9qmr1z2pf1IvYK8=;
        b=dOyzftz71ccpWJ752+qPi+7Qaz+B47Oaza6CRGfe4FPMJoVKT37EJJIGF90k/VK4FS
         W5yoB8r1Vx4mOp5rTu2jKevNI7zlllmJW7DLdgaVzC0oVnrYWl58Kb6BW9LL9WQR5Smq
         UrPzSuSYS+g6NJQfiqIVx4k+28RCqvUeIN40mBxxdksEv8GNBX3fgac+UySVVrXKWE9z
         PYHTH37gPyvUJb3gsSARxzwNIo67FXcb31RH3cDYiCp+V1qT5utTnaHc7PPdDGsIAoLX
         2qrWocfWqwQuekPenwQ6292qupJcF8tj0HaZwsR8z4bEmVTZhRU1pxYkCJIWqzpI2bbf
         r2dQ==
X-Gm-Message-State: AOAM533RgvRFjze4y+Dpw8aTJoFeAOX1BzOaRQssI5A3G5H0xdPJ9KkA
        5T5FudWHRzFSzkiLJQQmPsnHEox4H9rXypEEos1Y9w==
X-Google-Smtp-Source: ABdhPJxdvNBdxrvRM8ACW9KEOZDUovcWoMkKQluaavSot9hEcA4WNXQ4PgMeFjkiHodhkVrU2iGiruZZGD+RbyPxoCE=
X-Received: by 2002:a25:b9c8:0:b0:633:7725:779 with SMTP id
 y8-20020a25b9c8000000b0063377250779mr29609038ybj.280.1649869327532; Wed, 13
 Apr 2022 10:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com> <20220407011605.1966778-7-rananta@google.com>
 <5dac0a4e-735f-40e3-5073-b548a2ba9855@redhat.com>
In-Reply-To: <5dac0a4e-735f-40e3-5073-b548a2ba9855@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 13 Apr 2022 10:01:56 -0700
Message-ID: <CAJHc60yjozXARv8tR1vTG6nPsjkYvOiNpY0s7Tc65jpCfu+vkw@mail.gmail.com>
Subject: Re: [PATCH v5 06/10] Docs: KVM: Add doc for the bitmap firmware registers
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 11:40 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:16 AM, Raghavendra Rao Ananta wrote:
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
> >   Documentation/virt/kvm/api.rst            | 17 ++++
> >   Documentation/virt/kvm/arm/hypercalls.rst | 95 ++++++++++++++++++-----
> >   2 files changed, 94 insertions(+), 18 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index d13fa6600467..e0107b157965 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2542,6 +2542,23 @@ arm64 firmware pseudo-registers have the following bit pattern::
> >
> >     0x6030 0000 0014 <regno:16>
> >
> > +arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
> > +
> > +  0x6030 0000 0016 <regno:16>
> > +
> > +The bitmap feature firmware registers exposes the hypercall services that are
> > +available for userspace to configure. The set bits corresponds to the services
> > +that are available for the guests to access. By default, KVM sets all the
> > +supported bits during VM initialization. The userspace can discover the
> > +available services via KVM_GET_ONE_REG, and write-back the bitmap corresponding
> > +to the features that it wishes guests to see via KVM_SET_ONE_REG.
> > +
> > +Note: These registers are immutable once any of the vCPUs of the VM has run at
> > +least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
> > +If there's no change in the value that's being written, 0 (success) is returned.
> > +
> > +(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
> > +
> >   arm64 SVE registers have the following bit patterns::
> >
> >     0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> > diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > index d52c2e83b5b8..ccda9fc2d253 100644
> > --- a/Documentation/virt/kvm/arm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> > @@ -1,32 +1,32 @@
> >   .. SPDX-License-Identifier: GPL-2.0
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
> >   In order to remedy this situation, KVM exposes a set of "firmware
> >   pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> >   interface. These registers can be saved/restored by userspace, and set
> > -to a convenient value if required.
> > +to a convenient value as required.
> >
> > -The following register is defined:
> > +The following registers are defined:
> >
> >   * KVM_REG_ARM_PSCI_VERSION:
> >
> > +  KVM implements the PSCI (Power State Coordination Interface)
> > +  specification in order to provide services such as CPU on/off, reset
> > +  and power-off to the guest.
> > +
> >     - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> >       (and thus has already been initialized)
> >     - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> > @@ -74,4 +74,63 @@ The following register is defined:
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> >         The workaround is always active on this vCPU or it is not needed.
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
> > +any of the vCPUs has run at least once. Instead, it will return a -EBUSY. However,
> > +if there's no change in the incoming value, it simply returns a success.
> > +
>
> It would be better to replace "a success" with "zero", to be consistent
> with "-EBUSY". The suggestion may be invalid if the code needs changes
> based on Marc's suggestions.
>
Yes, I agree. Mentioning 'zero' makes more sense. However, I would be
scraping off this logic and return -EBUSY for all the writes after the
VM has started.

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
> >
>
> Thanks,
> Gavin
>
Regards,
Raghavendra
