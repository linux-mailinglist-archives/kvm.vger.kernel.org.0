Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505134881B2
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 06:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiAHFkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jan 2022 00:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiAHFkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jan 2022 00:40:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1606C06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 21:40:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso7096250pjo.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 21:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJGRReZsely/8omZ1Cspk9Kwrszz0O8ZKezfcROunTY=;
        b=jfIypL6kon4NpoXquOIEiUAQ5GvGVBebhTdvi+HtoQMlxRX/HgIUTklFUprfOVJ8rl
         fTn4KAxnr7iy56uqs6vMefiorygA2Af6KvzanccF++ZbClvc8c/iREpj5bzoU8pibKgY
         EWVPV3bVQGsyHkRfYoQlUOwHM37IQySaWCnDuMNZtgymuGpIL8M15d4MWEt4ziP8uKhv
         J4Ee06355x701dKcP/jb7BwEI+qn1aQZFmRvZQXHGE1E7Czkt5h7YZzuuFUb0m4VSi7p
         sSmInW+KEZ1baHhP5HNXPZ1Ucn7F5YPQy0S3bk1sNqlYNasvm2+6a/8lm/nImHkOM0MY
         5buQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJGRReZsely/8omZ1Cspk9Kwrszz0O8ZKezfcROunTY=;
        b=I3azFRE4IDdfoJj2Hqn9y/nmlsPFM7+MoxiU8FJ2HQpirjPSMIz8LDm59qRUSrRg/q
         sJDKBYHvXi/B4/A/4nwV7O7dIBexK8E6NdPPd92P5u79doNSJqqE0y2E5pFcoIban1WS
         M/U/ewXt4RpMVQpNYE63xm2T2S6vkmnZKtd2E4y++f/DfwDtHhEM/V53xLnaESX+xAJi
         D6+LvBuNNj8u0JcCbdE6oikCxXKjJHHOqfAa/YiOhlOF8Zvo4ndm8yv9SxKx9J4FOGhX
         YHBSPj40/PKiVC1B0ZZRtlEC0ucJsp18FUaDi18ecMTFIILl2WFh/S3lykPYA1zCTqoz
         cYBg==
X-Gm-Message-State: AOAM531SslBYqqj173na2fd0MnQa+cSEUHWhsDVfV6Hj5P6eJM4ner5V
        12QHqfS9PP8mwhxM0/AeY4bvNWzRQf1JDD3ML4URBg==
X-Google-Smtp-Source: ABdhPJwsnQF5jMBswjsnV13um4yHGQ74rkeXISFQukMgOjL9wb1avu8wU0g8cenUjnhbK6t0WyOy6jf3BIBex/1xpyk=
X-Received: by 2002:a17:90b:3b49:: with SMTP id ot9mr19372117pjb.110.1641620430125;
 Fri, 07 Jan 2022 21:40:30 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-4-rananta@google.com>
In-Reply-To: <20220104194918.373612-4-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 7 Jan 2022 21:40:14 -0800
Message-ID: <CAAeT=FxCCD+H1z8+gfyBZNeibfAUqUenZZe56Vj_3fCghJjy=Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
> to indicate the support for psuedo-firmware bitmap extension.
> Each of these registers holds a feature-set exposed to the guest
> in the form of a bitmap. If supported, a simple 'read' of the
> capability should return the number of psuedo-firmware registers
> supported. User-space can utilize this to discover the registers.
> It can further explore or modify the features using the classical
> GET/SET_ONE_REG interface.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
>  include/uapi/linux/kvm.h       |  1 +
>  2 files changed, 22 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aeeb071c7688..646176537f2c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
>  This is intended to support intra-host migration of VMs between userspace VMMs,
>  upgrading the VMM process without interrupting the guest.
>
> +7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP

IMHO, instead of including its format of the register in the name,
including its purpose/function in the name might be better.
e.g. KVM_CAP_ARM_HVC_FEATURE_REG ?
(Feature fields don't necessarily have to be in a bitmap format
 if they don't fit well although I'm not sure if we have such fields.)

> +--------------------------------
> +
> +:Architectures: arm64
> +:Parameters: None
> +:Returns: Number of psuedo-firmware registers supported

Looking at patch-4, the return value of this would be the number of
pseudo-firmware *bitmap* registers supported.
BTW, "4.68 KVM_SET_ONE_REG" in the doc uses the word "arm64 firmware
pseudo-registers".  It would be nicer to use the same term.

> +
> +This capability indicates that KVM for arm64 supports the psuedo-firmware
> +register bitmap extension. Each of these registers represent the features
> +supported by a particular type in the form of a bitmap. By default, these
> +registers are set with the upper limit of the features that are supported.
> +
> +The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
> +interfaces. The user-space is expected to read the number of these registers
> +available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
> +configuration via GET_ONE_REG for each register, and then write back the
> +desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
> +
> +Note that KVM doesn't allow the user-space to modify these registers after
> +the VM (any of the vCPUs) has started running.

Since even if KVM_RUN fails, and the VM hasn't started yet,
it will get immutable. So, "after any of the vCPUs run KVM_RUN."
might be more clear ?

Thanks,
Reiji



> +
>  8. Other capabilities.
>  ======================
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1daa45268de2..209b43dbbc3c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> +#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
