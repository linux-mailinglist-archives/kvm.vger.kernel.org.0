Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7710F782F59
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjHURZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjHURZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:25:02 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A829100
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:25:00 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bc63e0d8cdso31840691fa.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692638699; x=1693243499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L11mwPudUpyxcxi4xDsZZIa+yZ3u5tdBmcOcdJ6MPhM=;
        b=AWmPiMiw2cXqjSKAKABNL5ueILy2C1/4nX/Y2Y1P+MSQ3BZEU7yOaRhp9ukU2LSg4d
         QpQaMctjbu3lezcOzg3MKuAUder+Q0mJFpvUigZcOR0ViTuYOiEWwvYtYv94HpPuGPkO
         acZGkP+9eKcgYSB/brbt2ZJHIzopF1Ef6yILWhH4FIId8+nI70A8VQNTXsYl13KikUiN
         R2TRJdR1JFn8Cp60ImADFO0DkNmaD1lidW30vIA7kDGNSsyohUkG0tW5saGotcbgm67d
         BPu7S5dkdpoEjZoIthT0YA0XVK8c9IrbmmKzEo5DOuwle6H+XRh4/Y6oRkyksWok83Cy
         minw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692638699; x=1693243499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L11mwPudUpyxcxi4xDsZZIa+yZ3u5tdBmcOcdJ6MPhM=;
        b=JGK4tJ24ozQ+2nB7XYPQyy7LAdcGu/unb07NGMsEGlsLX+I6U+WHwTHwyYBvMkuuJw
         JgqCnHAQ1Ab48IHz55iG6Bnkmg+jjI9P3l3DKc+iXKA3b//5wBvsSz6cQxURe5JGi0GN
         5ffc5utKiAWaebz80ARPOUkYi7Apvl7B1DLoKk2AuAWAw0sjhbco1GX20zL2w2qBnwDr
         Bj5+My2JiwLnCBODK7UKGEfyd380FpK92ibUi2JshaNo/5s5NLoCniV3OTH2RFC2ZObO
         Ur4SZUFn7zXadF3o4k85aeXplWUtEvitZYiOkG6evFcIGnnQOyiGgvzI0emy5VCHOvHh
         PsPw==
X-Gm-Message-State: AOJu0YzKAOLh7kcsvW2kZev1uUZhpPCkDSRs7cqstqFZPM1J+LrLNInj
        6lgA1tXN3htFCCGbBQKU7rfSJAkUCld16oBjLAuOmA==
X-Google-Smtp-Source: AGHT+IHbI3VDjhtHox28Y/I58gcolObd5U2Lri41fIc+znSsgOL0TspSi/TN48KfvpCB57G6B6UMyjhuA6OWzmLw8bs=
X-Received: by 2002:a2e:860d:0:b0:2b7:1005:931b with SMTP id
 a13-20020a2e860d000000b002b71005931bmr5565528lji.0.1692638698511; Mon, 21 Aug
 2023 10:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com> <878raex8g0.fsf@redhat.com>
 <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
 <874jkyqe13.fsf@redhat.com> <86sf8hg45k.wl-maz@kernel.org>
In-Reply-To: <86sf8hg45k.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 21 Aug 2023 10:24:46 -0700
Message-ID: <CAAdAUtjG-9Ttdk3_T+OV6ea3p_r9q0yrE1XJUpdB0PwSJsN6VA@mail.gmail.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Aug 17, 2023 at 7:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 17 Aug 2023 09:16:56 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > On Mon, Aug 14 2023, Jing Zhang <jingzhangos@google.com> wrote:
> >
> > > Maybe it'd be better to leave this to whenever we do need to add othe=
r
> > > range support?
> >
> > My point is: How does userspace figure out if the kernel that is runnin=
g
> > supports ranges other than id regs? If this is just an insurance agains=
t
> > changes that might arrive or not, we can live with the awkward "just tr=
y
> > it out" approach; if we think it's likely that we'll need to extend it,
> > we need to add the mechanism for userspace to find out about it now, or
> > it would need to probe for presence of the mechanism...
>
> Agreed. Nothing like the present to address this sort of things. it
> really doesn't cost much, and I'd rather have it right now.
>
> Here's a vague attempt at an advertising mechanism. If people are OK
> with it, I can stash that on top of Jing's series.
>
> Thanks,
>
>         M.
>
> From bcfd87e85954e24ac4a905a3486c9040cdfc6d0b Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 17 Aug 2023 14:48:16 +0100
> Subject: [PATCH] KVM: arm64: Add KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
>
> While the Feature ID range is well defined and pretty large, it
> isn't inconceivable that the architecture will eventually grow
> some other ranges that will need to similarly be described to
> userspace.
>
> Add a new capability (KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES)
> that returns a bitmap of the valid ranges, which can subsequently
> be retrieved, one at a time by setting the index of the set bit
> as the range identifier.
>
> Obviously, we only support a value of 0 for now.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/api.rst    | 37 ++++++++++++++++++++-----------
>  arch/arm64/include/uapi/asm/kvm.h | 13 +++++++----
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/sys_regs.c         |  5 +++--
>  include/uapi/linux/kvm.h          |  1 +
>  5 files changed, 40 insertions(+), 19 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 92a9b20f970e..0e6ce02cac3b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6071,7 +6071,7 @@ applied.
>  4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
>  -------------------------------------------
>
> -:Capability: none
> +:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
>  :Architectures: arm64
>  :Type: vm ioctl
>  :Parameters: struct reg_mask_range (in/out)
> @@ -6082,20 +6082,31 @@ applied.
>
>          #define ARM64_FEATURE_ID_SPACE_SIZE    (3 * 8 * 8)
>
> -        struct reg_mask_range {
> -                __u64 addr;             /* Pointer to mask array */
> -                __u64 reserved[7];
> -        };
> +       struct reg_mask_range {
> +               __u64 addr;             /* Pointer to mask array */
> +               __u32 range;            /* Requested range */
> +               __u32 reserved[13];
> +       };
>
> -This ioctl would copy the writable masks for feature ID registers to use=
rspace.
> -The Feature ID space is defined as the System register space in AArch64 =
with
> +This ioctl copies the writable masks for Feature ID registers to userspa=
ce.
> +The Feature ID space is defined as the AArch64 System Register space wit=
h
>  op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=3D{0-=
7}.
> -To get the index in the mask array pointed by ``addr`` for a specified f=
eature
> -ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, c=
rm, op2)``.
> -This allows the userspace to know upfront whether it can actually tweak =
the
> -contents of a feature ID register or not.
> -The ``reserved[7]`` is reserved for future use to add other register spa=
ce. For
> -feature ID registers, it should be 0, otherwise, KVM may return error.
> +
> +The mask array pointed to by ``addr`` is indexed by the macro
> +``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``, allowing usersp=
ace
> +to know what bits can be changed for the system register described by ``=
op0,
> +op1, crn, crm, op2``.
> +
> +The ``range`` field describes the requested range of registers. The vali=
d
> +ranges can be retrieved by checking the return value of
> +KVM_CAP_CHECK_EXTENSION_VM for the KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANG=
ES
> +capability, which will return a bitmask of the supported ranges. Each bi=
t
> +set in the return value represents a possible value for the ``range``
> +field.  At the time of writing, only bit 0 is returned set by the
> +capability, meaning that only the value 0 is value for ``range``.
> +
> +The ``reserved[13]`` array is reserved for future use and should be 0, o=
r
> +KVM may return an error.
>
>  5. The kvm_run structure
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 7a21bbb8a0f7..5148b4c22549 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -505,8 +505,9 @@ struct kvm_smccc_filter {
>  #define KVM_HYPERCALL_EXIT_SMC         (1U << 0)
>  #define KVM_HYPERCALL_EXIT_16BIT       (1U << 1)
>
> -/* Get feature ID registers userspace writable mask. */
>  /*
> + * Get feature ID registers userspace writable mask.
> + *
>   * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
>   * Feature Register 2"):
>   *
> @@ -514,8 +515,11 @@ struct kvm_smccc_filter {
>   * AArch64 with op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-=
7},
>   * op2=3D=3D{0-7}."
>   *
> - * This covers all R/O registers that indicate anything useful feature
> - * wise, including the ID registers.
> + * This covers all currently known R/O registers that indicate
> + * anything useful feature wise, including the ID registers.
> + *
> + * If we ever need to introduce a new range, it will be described as
> + * such in the range field.
>   */
>  #define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)            \
>         ({                                                              \
> @@ -528,7 +532,8 @@ struct kvm_smccc_filter {
>
>  struct reg_mask_range {
>         __u64 addr;             /* Pointer to mask array */
> -       __u64 reserved[7];
> +       __u32 range;            /* Requested range */
> +       __u32 reserved[13];
>  };
>
>  #endif
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e08894692829..6ea4d8b0e744 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -316,6 +316,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>         case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
>                 r =3D kvm_supported_block_sizes();
>                 break;
> +       case KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES:
> +               r =3D BIT(0);
> +               break;
>         default:
>                 r =3D 0;
>         }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 59c590fff4f2..6eadd0fa2c53 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3600,8 +3600,9 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm =
*kvm, struct reg_mask_range *
>         const void *zero_page =3D page_to_virt(ZERO_PAGE(0));
>         u64 __user *masks =3D (u64 __user *)range->addr;
>
> -       /* Only feature id range is supported, reserved[7] must be zero. =
*/
> -       if (memcmp(range->reserved, zero_page, sizeof(range->reserved)))
> +       /* Only feature id range is supported, reserved[13] must be zero.=
 */
> +       if (range->range ||
> +           memcmp(range->reserved, zero_page, sizeof(range->reserved)))
>                 return -EINVAL;
>
>         /* Wipe the whole thing first */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 424b6d00440b..f5100055a1a6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1192,6 +1192,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_COUNTER_OFFSET 227
>  #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
>  #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
> +#define KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES 230
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
>
> --
> Without deviation from the norm, progress is not possible.

Looks good to me.

Thanks,
Jing
