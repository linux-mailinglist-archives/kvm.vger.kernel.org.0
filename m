Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D32850F161
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 08:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbiDZGq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 02:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiDZGqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 02:46:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6835912B477
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 23:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650955389;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOoGOtj/W1wvBxHc1Y0tgQWbtJb3t+WPI08hhY3wXtI=;
        b=hsx8KIBG97tOAz9JZKDlkixZbZdHLWUPKvompbYzW+hJiZ8ccHFyFlM0FxG1UeCmTqRPKz
        U6mg15dApRYmolkuocf39PO95AjeZ1FUkiVxbr2rRtWANULYQXVneSZyaih7tuhNxhm+It
        fmFdEgQUMVb1msDR8N6YVknQxTe/QaI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-YFnuGdayOjawGy93ZkDpPQ-1; Tue, 26 Apr 2022 02:43:06 -0400
X-MC-Unique: YFnuGdayOjawGy93ZkDpPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB585811E80;
        Tue, 26 Apr 2022 06:43:05 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B3EE40CF91F;
        Tue, 26 Apr 2022 06:42:58 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 6/9] Docs: KVM: Add doc for the bitmap firmware
 registers
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-7-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <eeb76837-34dd-f229-d814-5ad777e66ad8@redhat.com>
Date:   Tue, 26 Apr 2022 14:42:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220423000328.2103733-7-rananta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
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
>   Documentation/virt/kvm/api.rst            | 16 ++++
>   Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
>   2 files changed, 92 insertions(+), 18 deletions(-)
> 

With Reiji's comment fixed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85c7abc51af5..ac489191d0a9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
>   
>     0x6030 0000 0014 <regno:16>
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
>   arm64 SVE registers have the following bit patterns::
>   
>     0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index d52c2e83b5b8..6327c504b2fb 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -1,32 +1,32 @@
>   .. SPDX-License-Identifier: GPL-2.0
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
>   In order to remedy this situation, KVM exposes a set of "firmware
>   pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>   interface. These registers can be saved/restored by userspace, and set
> -to a convenient value if required.
> +to a convenient value as required.
>   
> -The following register is defined:
> +The following registers are defined:
>   
>   * KVM_REG_ARM_PSCI_VERSION:
>   
> +  KVM implements the PSCI (Power State Coordination Interface)
> +  specification in order to provide services such as CPU on/off, reset
> +  and power-off to the guest.
> +
>     - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
>       (and thus has already been initialized)
>     - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> @@ -74,4 +74,62 @@ The following register is defined:
>       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>         The workaround is always active on this vCPU or it is not needed.
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
> 

