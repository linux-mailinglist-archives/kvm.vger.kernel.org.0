Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD477296A5
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbjFIKSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 06:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbjFIKRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 06:17:31 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF724C1C
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 03:09:14 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-5523bd97c64so1708491eaf.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 03:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1686305353; x=1688897353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzSK7hABA28xCfv4pKGg0lBnF68yq9uktgRx5iEmiaI=;
        b=SnjQiblhpKdUrkFmokq90JQhRukoXq5b8J65xXVJT9EIrcP/WR3hM6uzBoAdAPmaR+
         3fQp23XvUy7d9X/SQQuG2rTO/QvUD1wJXI7KDWJ2VKJDeQLf+6fi8iH4QVW+bIU077fU
         IGcDNeMIM5dt1wtSEHAEi6nL3rDKqVcHE2Rhnok+EDQfNuL2kAEF43y1yU/7Gx5y24cv
         gwk8IsL+MKxcaEQIvlvHk2aGIrhi9BmaaLoDVjD+hU9fnTLkykF6r0TUD9n8Ftk/ReM1
         vX2baJvN2ZfSLdEv40zycMQoM9odk9M7DrKLraUWbA40Xnwi/iaSU5qSjWDqJ3FyLQBc
         Dopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686305353; x=1688897353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzSK7hABA28xCfv4pKGg0lBnF68yq9uktgRx5iEmiaI=;
        b=QnS+mpyxUjvEjfOUJte9wt1FT5UYBl+px/VVcnBJ9yv9HPen1DijVnB3Xs24FfuDUC
         Hji6iENLP6Hl88zMNXpvbabP/R6tDHu5gBrUviSugm8TTFz0xo7JZWuqxNCHmcHZP4q+
         a+gErgthLrT6xYDIZciGfS6ZoLcbs+W4zNZ5skyPvT1XSfPZpR9Tta+0RXGxU7bqTVTB
         XE9A6Xf1uMTUViWGygNldyHlEO5T6IsRUVjTgphbnkiYCYrtDS8wMC11PiUuMJse62qF
         ubw8YfOoIwAzQB4I8gKB0jmTlNPHpvcB9TW7Png8C97X3bRHRbJUbdhDrJ39O01HL7KU
         uYkQ==
X-Gm-Message-State: AC+VfDy0TvWhHMwQKOgzP4XKrD+UTo/yTL17gBSp5Znaue0VyrXyz448
        xplHZvFZweAraCfZ9UCXSBVIKOL0xGI7KFZcCnZo+g==
X-Google-Smtp-Source: ACHHUZ6ewDIbcR4/py85q2j6sKSdum5U5/Vdc7cWMVzwmXLvBSTRSLiaS7LXPrZs5BLOaL/cUyMRgLfEvjshvfKWg50=
X-Received: by 2002:aca:db83:0:b0:39a:7233:3340 with SMTP id
 s125-20020acadb83000000b0039a72333340mr2527082oig.23.1686305353377; Fri, 09
 Jun 2023 03:09:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230526062509.31682-1-yongxuan.wang@sifive.com>
 <20230526062509.31682-5-yongxuan.wang@sifive.com> <a715b6d1-d28a-1e04-34c5-5d6c1fb2696e@ventanamicro.com>
In-Reply-To: <a715b6d1-d28a-1e04-34c5-5d6c1fb2696e@ventanamicro.com>
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date:   Fri, 9 Jun 2023 18:09:03 +0800
Message-ID: <CAMWQL2hQkzCxMdvHXw8Yy8HSceEkHaMga5i1Z-79c-Eq6QGftg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] target/riscv: Create an KVM AIA irqchip
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, jim.shu@sifive.com,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi  Daniel,

Thanks for your suggestions! I'll fix it in patch v4.

Regards,
Yong-Xuan

On Tue, Jun 6, 2023 at 9:45=E2=80=AFPM Daniel Henrique Barboza
<dbarboza@ventanamicro.com> wrote:
>
>
>
> On 5/26/23 03:25, Yong-Xuan Wang wrote:
> > implement a function to create an KVM AIA chip
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > Reviewed-by: Jim Shu <jim.shu@sifive.com>
> > ---
> >   target/riscv/kvm.c       | 83 +++++++++++++++++++++++++++++++++++++++=
+
> >   target/riscv/kvm_riscv.h |  3 ++
> >   2 files changed, 86 insertions(+)
> >
> > diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> > index eb469e8ca5..ead121154f 100644
> > --- a/target/riscv/kvm.c
> > +++ b/target/riscv/kvm.c
> > @@ -34,6 +34,7 @@
> >   #include "exec/address-spaces.h"
> >   #include "hw/boards.h"
> >   #include "hw/irq.h"
> > +#include "hw/intc/riscv_imsic.h"
> >   #include "qemu/log.h"
> >   #include "hw/loader.h"
> >   #include "kvm_riscv.h"
> > @@ -548,3 +549,85 @@ bool kvm_arch_cpu_check_are_resettable(void)
> >   void kvm_arch_accel_class_init(ObjectClass *oc)
> >   {
> >   }
> > +
> > +void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int sock=
et,
> > +                          uint64_t aia_irq_num, uint64_t hart_count,
> > +                          uint64_t aplic_base, uint64_t imsic_base)
> > +{
> > +    int ret;
> > +    int aia_fd =3D -1;
> > +    uint64_t aia_mode;
> > +    uint64_t aia_nr_ids;
> > +    uint64_t aia_hart_bits =3D find_last_bit(&hart_count, BITS_PER_LON=
G) + 1;
> > +
> > +    if (!msimode) {
> > +        error_report("Currently KVM AIA only supports aplic_imsic mode=
");
> > +        exit(1);
> > +    }
> > +
> > +    aia_fd =3D kvm_create_device(kvm_state, KVM_DEV_TYPE_RISCV_AIA, fa=
lse);
> > +
> > +    if (aia_fd < 0) {
> > +        error_report("Unable to create in-kernel irqchip");
> > +        exit(1);
> > +    }
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +                            KVM_DEV_RISCV_AIA_CONFIG_MODE,
> > +                            &aia_mode, false, NULL);
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +                            KVM_DEV_RISCV_AIA_CONFIG_IDS,
> > +                            &aia_nr_ids, false, NULL);
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +                            KVM_DEV_RISCV_AIA_CONFIG_SRCS,
> > +                            &aia_irq_num, true, NULL);
> > +    if (ret < 0) {
> > +        error_report("KVM AIA: fail to set number input irq lines");
> > +        exit(1);
> > +    }
>
> I see that you didn't check 'ret' for the first 2 calls of kvm_device_acc=
ess().
> Is it intentional?
>
> Since you're setting customized error messages for every step I think it'=
s worth
> also handling the case where we fail to set aia_mode and aia_nr_ids.
>
>
> Thanks,
>
>
> Daniel
>
>
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +                            KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
> > +                            &aia_hart_bits, true, NULL);
> > +    if (ret < 0) {
> > +        error_report("KVM AIA: fail to set number of harts");
> > +        exit(1);
> > +    }
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
> > +                            KVM_DEV_RISCV_AIA_ADDR_APLIC,
> > +                            &aplic_base, true, NULL);
> > +    if (ret < 0) {
> > +        error_report("KVM AIA: fail to set the base address of APLIC")=
;
> > +        exit(1);
> > +    }
> > +
> > +    for (int i =3D 0; i < hart_count; i++) {
> > +        uint64_t imsic_addr =3D imsic_base + i * IMSIC_HART_SIZE(0);
> > +        ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
> > +                                KVM_DEV_RISCV_AIA_ADDR_IMSIC(i),
> > +                                &imsic_addr, true, NULL);
> > +        if (ret < 0) {
> > +            error_report("KVM AIA: fail to set the base address of IMS=
ICs");
> > +            exit(1);
> > +        }
> > +    }
> > +
> > +    if (kvm_has_gsi_routing()) {
> > +        for (uint64_t idx =3D 0; idx < aia_irq_num + 1; ++idx) {
> > +            kvm_irqchip_add_irq_route(kvm_state, idx, socket, idx);
> > +        }
> > +        kvm_gsi_routing_allowed =3D true;
> > +        kvm_irqchip_commit_routes(kvm_state);
> > +    }
> > +
> > +    ret =3D kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CTRL,
> > +                            KVM_DEV_RISCV_AIA_CTRL_INIT,
> > +                            NULL, true, NULL);
> > +    if (ret < 0) {
> > +        error_report("KVM AIA: initialized fail");
> > +        exit(1);
> > +    }
> > +}
> > diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
> > index 606968a4b7..6067adff51 100644
> > --- a/target/riscv/kvm_riscv.h
> > +++ b/target/riscv/kvm_riscv.h
> > @@ -21,6 +21,9 @@
> >
> >   void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> >   void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
> > +void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int sock=
et,
> > +                          uint64_t aia_irq_num, uint64_t hart_count,
> > +                          uint64_t aplic_base, uint64_t imsic_base);
> >
> >   #define KVM_DEV_RISCV_AIA_GRP_CONFIG            0
> >   #define KVM_DEV_RISCV_AIA_CONFIG_MODE           0
