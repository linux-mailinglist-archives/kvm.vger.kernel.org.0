Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D8761FC79
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiKGSBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiKGSAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:00:48 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041FA2B24B
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:56:52 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id w14so17394427wru.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 09:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:user-agent:message-id:date:references:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=T3PdXGFokMYHAAkilazNlYlaLTfFeBTny4nmc/XZVPA=;
        b=FY+QQ2oVQBn/h5WRmwrQ8ViPJMhpmfdXcqi0vbGJ7WFh3tGoRAQoi/nHcspbWFNR0A
         PKQeyeDw4mXPwCcwGN372L85lrk11rioa5/7ceojMnG1dpg2WETS8oY0bOVEC+QL8Btk
         8XgRFX8mgqa0SZfsdazJwthY1uq1I0IWc0BWZo8HR+ccUnR7VyZTYi2QCM+DCsumhSjT
         vq7Pg3RgICwmwKW1Eb1MQhjC6YrUs/1nJZ5bLbIoh//dnZxm6y9O6YOa7qkseonvz0qg
         vxXBmLH1lXeiLyu0lHLoPf8VGJ3pyoHszBGKLsnqejccRqrdxMV5cVpe6Sxjn91mAW5u
         WvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:date:references:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T3PdXGFokMYHAAkilazNlYlaLTfFeBTny4nmc/XZVPA=;
        b=fY0DoAL5/+zRE8659e5qThycTQw9bLBdPIr469EahBasFLKIgKcwpwuL+3CX1nDUmL
         GE74JkLbc+/njvtGEN9EZ1A6NIseSQXZREIWnkyg4DMWOGw46DOKwrMmD0vFWAKqEbHN
         FHM+s3VqqUcNZRrqZ/EcMam0ADYtRSw6YL8kfSZGI1kTTAfeVnxhOCZtLhqv3mpLfIc0
         4DDnAhqX0nfR2RBZgjSohocaychNkuLKsYfyMi3P6YbcYJryMtHRyFV5kZtO73G8sz2A
         5GMDgGwO5k7xotTwRb38tZQDxeUBsv7LbyvKU0UhFKZRNtRmeZgkC1W90ZumnkRVz3qn
         IxPA==
X-Gm-Message-State: ACrzQf31idszmG44ENi/ePVfDCnuOW2pSB9PBa3CaKisPqLPR+ZkZia9
        cDUJShs76Y9ZP4ybymfYHTnejw==
X-Google-Smtp-Source: AMsMyM5L4/wnYoqPY7Lfe0ZxjSlXO8kmalMHRqh/UMafMsHtZVAmgq/s4+7IjonnmIgORkq9EHznsg==
X-Received: by 2002:a05:6000:1841:b0:236:70dc:1a6f with SMTP id c1-20020a056000184100b0023670dc1a6fmr32784664wri.464.1667843810520;
        Mon, 07 Nov 2022 09:56:50 -0800 (PST)
Received: from localhost ([95.148.15.66])
        by smtp.gmail.com with ESMTPSA id v4-20020a5d4a44000000b002365254ea42sm8079706wrs.1.2022.11.07.09.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:56:49 -0800 (PST)
From:   Punit Agrawal <punit.agrawal@bytedance.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, fam.zheng@bytedance.com,
        liangma@liangbit.com, punit.agrawal@bytedance.com
Subject: Re: [v2 1/6] KVM: arm64: Document PV-lock interface
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
        <20221104062105.4119003-2-usama.arif@bytedance.com>
Date:   Mon, 07 Nov 2022 17:56:49 +0000
Message-ID: <87k0463axq.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Usama,

Usama Arif <usama.arif@bytedance.com> writes:

> Introduce a paravirtualization interface for KVM/arm64 to obtain whether
> the VCPU is currently running or not.
>
> The PV lock structure of the guest is allocated by user space.
>
> A hypercall interface is provided for the guest to interrogate the
> location of the shared memory structures.
>
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  Documentation/virt/kvm/arm/index.rst    |  1 +
>  Documentation/virt/kvm/arm/pvlock.rst   | 52 +++++++++++++++++++++++++
>  Documentation/virt/kvm/devices/vcpu.rst | 25 ++++++++++++
>  3 files changed, 78 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
>
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index e84848432158..b8499dc00a6a 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,4 +10,5 @@ ARM
>     hyp-abi
>     hypercalls
>     pvtime
> +   pvlock
>     ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> new file mode 100644
> index 000000000000..d3c391b16d36
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -0,0 +1,52 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized lock support for arm64
> +======================================
> +
> +KVM/arm64 provides a hypervisor service call for paravirtualized guests to
> +determine whether a VCPU is currently running or not.
> +
> +A new SMCCC compatible hypercall is defined:
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:   0xC6000002
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID
> +
> +    ============= ========    ==========================================
> +    Function ID:  (uint32)    0xC6000002
> +    Return value: (int64)     IPA of the pv lock data structure for this
> +                              VCPU. On failure:
> +                              NOT_SUPPORTED (-1)
> +    ============= ========    ==========================================
> +
> +The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
> +memory with inner and outer write back caching attributes, in the inner
> +shareable domain.
> +
> +PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
> +
> +PV lock state
> +-------------
> +
> +The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
> +
> ++-----------+-------------+-------------+---------------------------------+
> +| Field     | Byte Length | Byte Offset | Description                     |
> ++===========+=============+=============+=================================+
> +| preempted |      8      |      0      | Indicate if the VCPU that owns  |
> +|           |             |             | this struct is running or not.  |
> +|           |             |             | Non-zero values mean the VCPU   |
> +|           |             |             | has been preempted. Zero means  |
> +|           |             |             | the VCPU is not preempted.      |
> ++-----------+-------------+-------------+---------------------------------+
> +
> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
> +a VCPU. When the VCPU is scheduled out, the preempted field will be updated
> +to 0 by the hypervisor.

The text above doesn't match the description in the table. Please update
the texts to align them with the code.

[...]

