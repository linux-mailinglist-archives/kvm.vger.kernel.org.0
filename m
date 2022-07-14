Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D91574522
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 08:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiGNGhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 02:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGNGhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 02:37:46 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9219FC9
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 23:37:42 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id f10so319384uam.0
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 23:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DoVVtteCv4PUdu2G1ggr00c8VWMSSFxt1TEptKxuTW0=;
        b=Yg7QG1MA5dRaGXwsjWXPgTpypAjgPETFU7n6Jm4ywkPPo+Wa4E2b9TFyWSvmxA22Ae
         l1HqtI2r1ZNVtT3iNHNDC3NB1koFzAsjug1KCmJeh6SJLwqRsaRP44IaCJqs+yyal8G8
         0TgwJCktxgm1BscDmwHnWfLFwzOj8DC/Wiqj86/dcy6DRQOfr6C1llH8MHZuKdlokBwe
         ssIzCowpwUoZntN+LJlVhe1cYIPyUcIuMDNPhXQ+9M+GZ3RJNWEyArUG5N2c4mM3ZzC4
         eP+PxiQjaVdxl0FisOInGcR9VreKxlvU1aKZMsXGP8lxWx/sUvUjfwKtW539PlRiKiAQ
         RRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DoVVtteCv4PUdu2G1ggr00c8VWMSSFxt1TEptKxuTW0=;
        b=dAUzxn2EhlOazXSseBC+LrAKwJwrvscxQjLJU70Z4EF8fg2LZUQ/0QZ4KkXZMSh/ip
         CKmWxxM3KrcT3s63Cu2Wj311tlN+SXlZK0v9479z1PdE5DOiIRfhR+NzuWUFVMElp4kQ
         5VHhoFyra72TxULWcgJumUb4Km4PGC+3WliNjIa8lMLexE6dIFqjMbExda/JIiP+uRfe
         zmOe59GMhntKMrl4A3byMglTgPeTTj6rpdZjCZplZoHxJgXJWme4vN2TTS0O7FcbH6JK
         7HKZmq02wG/jMbDRBX8+RCwPp+oqa5Y1fNIJm4Kc+EpEeIgeU/OlItECXKZrOIsDAMz+
         WQIg==
X-Gm-Message-State: AJIora/YfAt6tRQI84Vem4/ZHZwrebtGfs+Js3j4isLpfklNJFP3LOea
        +PTrsoq5gP7WdbXmSFluthdqJo9LE9IsXJ79gePdCy3k9X3wjA==
X-Google-Smtp-Source: AGRyM1s39uG0oWTCljT/mPbeadx0K3bCVGNfETvY7O8txNbSc94KoOZxiE3kiHQYjB/J8zgxbRy/Ec0mR83I7hT0oq0=
X-Received: by 2002:ab0:63cf:0:b0:382:90bb:5c29 with SMTP id
 i15-20020ab063cf000000b0038290bb5c29mr2879964uap.51.1657780660825; Wed, 13
 Jul 2022 23:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-16-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-16-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Jul 2022 23:37:25 -0700
Message-ID: <CAAeT=FzgBpwcf7oEGeCLCHO+XadP+i7vyPFWx6VJxmiWC94-7g@mail.gmail.com>
Subject: Re: [PATCH 15/19] KVM: arm64: vgic-v2: Add helper for legacy
 dist/cpuif base address setting
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> We carry a legacy interface to set the base addresses for GICv2.
> As this is currently plumbed into the same handling code as
> the modern interface, it limits the evolution we can make there.
>
> Add a helper dedicated to this handling, with a view of maybe
> removing this in the future.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c                  | 11 ++-------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
>  include/kvm/arm_vgic.h                |  1 +
>  3 files changed, 35 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 83a7f61354d3..bf39570c0aef 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>                                         struct kvm_arm_device_addr *dev_addr)
>  {
> -       unsigned long dev_id, type;
> -
> -       dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
> -               KVM_ARM_DEVICE_ID_SHIFT;
> -       type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
> -               KVM_ARM_DEVICE_TYPE_SHIFT;
> -
> -       switch (dev_id) {
> +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
>         case KVM_ARM_DEVICE_VGIC_V2:
>                 if (!vgic_present)
>                         return -ENXIO;
> -               return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
> +               return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
>         default:
>                 return -ENODEV;
>         }
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index fbbd0338c782..0dfd277b9058 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
>                 return 0;
>  }
>
> +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
> +{
> +       struct vgic_dist *vgic = &kvm->arch.vgic;
> +       int r;
> +
> +       mutex_lock(&kvm->lock);
> +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {

Shouldn't this be KVM_ARM_DEVICE_TYPE_MASK (not KVM_ARM_DEVICE_ID_MASK) ?

Thank you,
Reiji


> +       case KVM_VGIC_V2_ADDR_TYPE_DIST:
> +               r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
> +               if (!r)
> +                       r = vgic_check_iorange(kvm, vgic->vgic_dist_base, dev_addr->addr,
> +                                              SZ_4K, KVM_VGIC_V2_DIST_SIZE);
> +               if (!r)
> +                       vgic->vgic_dist_base = dev_addr->addr;
> +               break;
> +       case KVM_VGIC_V2_ADDR_TYPE_CPU:
> +               r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
> +               if (!r)
> +                       r = vgic_check_iorange(kvm, vgic->vgic_cpu_base, dev_addr->addr,
> +                                              SZ_4K, KVM_VGIC_V2_CPU_SIZE);
> +               if (!r)
> +                       vgic->vgic_cpu_base = dev_addr->addr;
> +               break;
> +       default:
> +               r = -ENODEV;
> +       }
> +
> +       mutex_unlock(&kvm->lock);
> +
> +       return r;
> +}
> +
>  /**
>   * kvm_vgic_addr - set or get vgic VM base addresses
>   * @kvm:   pointer to the vm struct
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 2d8f2e90edc2..f79cce67563e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -365,6 +365,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
>  extern struct static_key_false vgic_v3_cpuif_trap;
>
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
>  void kvm_vgic_early_init(struct kvm *kvm);
>  int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
>  int kvm_vgic_create(struct kvm *kvm, u32 type);
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
