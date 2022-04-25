Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1136550D97D
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 08:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiDYGev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 02:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiDYGeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 02:34:44 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F61636C
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 23:31:40 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k29-20020a056830243d00b006040caa0988so10151010ots.6
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 23:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfmyfBKzr6y+Q24t6trNowD3E0gJMVwVzasVksSwT9A=;
        b=g1J19A6tvdiHnzaz59fgMij9aZVTn8m3adN+kXCf4Aat3HaVedlp7O6IjlM5BEH5Sx
         i4lN+BFSmaacazfTvoSAXhCAnhX+ejpdMxmoakYdY+n1dDjC+rALHpHa16sGfv7GKGK7
         +BTiG+QBQGPqfayMcGVSYor11VwoJyiwtjgzCTjo8uMx+3DPuAoX9suuKHIdmjLWZogy
         ifnFSW2HuChlJxr0giFbktyL/h3NWutHsAXMPUbVImJFidktEGn6B5LfvH2mnlaavDhy
         Om0aaDjWkKM27IWrRnBTJxLldCQlTgdvaYta2iq2yhveZBpQFbCitZkIm3ce3Fo88hbf
         Y+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfmyfBKzr6y+Q24t6trNowD3E0gJMVwVzasVksSwT9A=;
        b=cx8NlcVer+Wg4Q3rGSIKNKQcDJPDyQ8y87KUITNduSc7DozSr5785Q4F4fOJmMvFpC
         g9rXqGA65+VxdD5cN4s7rdjp10VonSx2nSiphH3OirArS5k6g7unzOzCgCuvmeq1ma1Y
         IvS7xO+JchhFsVtYypxiUuyXsaFkZ+eigSxCVZZdlZLe1c4XYYNvyaeknnOcBcS8nPHW
         82Wr647juXx2bcVKO4QSWHgGabh9BQi3fvEkQhIsQRHmtv2C53Eyu79Z6XpnOLEAQKG1
         V6eB6gj/OBV2go5c6vJJ4MLJYSdMAdFQbSssSPnJxMZKKr6doiGmEu35MF+yt6nrc6ZY
         ZkTw==
X-Gm-Message-State: AOAM532DbeExuXfDh3sNXIdsjtpIO9KW+xCwhJKYXWihfgfCyII30OM5
        wBN+GRmqORPrIyVaGuigakQI+/tBJECCjRR5lHPyBA==
X-Google-Smtp-Source: ABdhPJwj2NO3QNUFQKAjUp7XjBssKGRRqRlhP7iJIG885KNHfLtVxA6nIWkL22SiO9d1MKJZ0CkuVis2TN+l+vuQ6D0=
X-Received: by 2002:a05:6830:18d:b0:605:4cfb:19cd with SMTP id
 q13-20020a056830018d00b006054cfb19cdmr5780150ota.177.1650868299671; Sun, 24
 Apr 2022 23:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-7-rananta@google.com>
In-Reply-To: <20220423000328.2103733-7-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 24 Apr 2022 23:31:23 -0700
Message-ID: <CAAeT=FxPwaCGw32Xy7F4aY3CEtAhB29t-KsA=ptLQN8hvtsvrg@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] Docs: KVM: Add doc for the bitmap firmware registers
To:     Raghavendra Rao Ananta <rananta@google.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add the documentation for the bitmap firmware registers in
> hypercalls.rst and api.rst. This includes the details for
> KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
> KVM_REG_ARM_VENDOR_HYP_BMAP registers.
>
> Since the document is growing to carry other hypercall related
> information, make necessary adjustments to present the document
> in a generic sense, rather than being PSCI focused.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  Documentation/virt/kvm/api.rst            | 16 ++++
>  Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
>  2 files changed, 92 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85c7abc51af5..ac489191d0a9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
>
>    0x6030 0000 0014 <regno:16>
>
> +arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
> +
> +  0x6030 0000 0016 <regno:16>
> +
> +The bitmap feature firmware registers exposes the hypercall services that are
> +available for userspace to configure. The set bits corresponds to the services
> +that are available for the guests to access. By default, KVM sets all the
> +supported bits during VM initialization. The userspace can discover the
> +available services via KVM_GET_ONE_REG, and write back the bitmap corresponding
> +to the features that it wishes guests to see via KVM_SET_ONE_REG.
> +
> +Note: These registers are immutable once any of the vCPUs of the VM has run at
> +least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
> +
> +(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
> +
>  arm64 SVE registers have the following bit patterns::
>
>    0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index d52c2e83b5b8..6327c504b2fb 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -1,32 +1,32 @@
>  .. SPDX-License-Identifier: GPL-2.0
>
> -=========================================
> -Power State Coordination Interface (PSCI)
> -=========================================
> +=======================
> +ARM Hypercall Interface
> +=======================
>
> -KVM implements the PSCI (Power State Coordination Interface)
> -specification in order to provide services such as CPU on/off, reset
> -and power-off to the guest.
> +KVM handles the hypercall services as requested by the guests. New hypercall
> +services are regularly made available by the ARM specification or by KVM (as
> +vendor services) if they make sense from a virtualization point of view.
>
> -The PSCI specification is regularly updated to provide new features,
> -and KVM implements these updates if they make sense from a virtualization
> -point of view.
> -
> -This means that a guest booted on two different versions of KVM can
> -observe two different "firmware" revisions. This could cause issues if
> -a given guest is tied to a particular PSCI revision (unlikely), or if
> -a migration causes a different PSCI version to be exposed out of the
> -blue to an unsuspecting guest.
> +This means that a guest booted on two different versions of KVM can observe
> +two different "firmware" revisions. This could cause issues if a given guest
> +is tied to a particular version of a hypercall service, or if a migration
> +causes a different version to be exposed out of the blue to an unsuspecting
> +guest.
>
>  In order to remedy this situation, KVM exposes a set of "firmware
>  pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>  interface. These registers can be saved/restored by userspace, and set
> -to a convenient value if required.
> +to a convenient value as required.
>
> -The following register is defined:
> +The following registers are defined:
>
>  * KVM_REG_ARM_PSCI_VERSION:
>
> +  KVM implements the PSCI (Power State Coordination Interface)
> +  specification in order to provide services such as CPU on/off, reset
> +  and power-off to the guest.
> +
>    - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
>      (and thus has already been initialized)
>    - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> @@ -74,4 +74,62 @@ The following register is defined:
>      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>        The workaround is always active on this vCPU or it is not needed.
>
> -.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> +
> +Bitmap Feature Firmware Registers
> +---------------------------------
> +
> +Contrary to the above registers, the following registers exposes the hypercall
> +services in the form of a feature-bitmap to the userspace. This bitmap is
> +translated to the services that are available to the guest. There is a register
> +defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
> +
> +By default, these registers are set with the upper limit of the features that
> +are supported. This way userspace can discover all the electable hypercall services
> +via GET_ONE_REG. The user-space can write-back the desired bitmap back via
> +SET_ONE_REG. The features for the registers that are untouched, probably because
> +userspace isn't aware of them, will be exposed as is to the guest.
> +
> +Note that KVM would't allow the userspace to configure the registers anymore once
> +any of the vCPUs has run at least once. Instead, it will return a -EBUSY.
> +
> +The psuedo-firmware bitmap register are as follows:
> +
> +* KVM_REG_ARM_STD_BMAP:
> +    Controls the bitmap of the ARM Standard Secure Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
> +      The bit represents the services offered under v1.0 of ARM True Random
> +      Number Generator (TRNG) specification, ARM DEN0098.
> +
> +* KVM_REG_ARM_STD_HYP_BMAP:
> +    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
> +      The bit represents the Paravirtualized Time service as represented by
> +      ARM DEN0057A.
> +
> +* KVM_REG_ARM_VENDOR_HYP_BMAP:
> +    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
> +      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
> +      function-id

Looking at the code,
the bit also represents ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID.

Thanks,
Reiji


> +
> +    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
> +      The bit represents the Precision Time Protocol KVM service.
> +
> +Errors:
> +
> +    =======  =============================================================
> +    -ENOENT   Unknown register accessed.
> +    -EBUSY    Attempt a 'write' to the register after the VM has started.
> +    -EINVAL   Invalid bitmap written to the register.
> +    =======  =============================================================
> +
> +.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> \ No newline at end of file
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>
