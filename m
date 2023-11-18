Return-Path: <kvm+bounces-1989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0361A7EFFB8
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67AFDB209A0
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27060134B5;
	Sat, 18 Nov 2023 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="I7QBCAXr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C22F9
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:01:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-2802e5ae23bso2528171a91.2
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700312501; x=1700917301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/xSKH5MjnKUt8pNxHwpsPk44beT81H//Elcee/6O4g=;
        b=I7QBCAXr35YmgmF2hG9SrE46jijo2T57/iW3/WQL+IHy3qL7S4EcEuuY4efFEQl8uL
         ghCWTPlOcYCUpknoqy9Uf58fJrncQA4+L5DgcKvFu+M6K72lgL8wO14KNsM8N0mA50/Z
         R4qCs6+JVRZmWMpeJZ6om3BroxX/4s116UM8mOpq6WlbMyGCUYCsmS9H+2PWv/zQb3y0
         dC8Kg9tr7psuGhuRmUV/L3HicH5Nt6wtQxILgfGV4DQe/JxKNLDrQCP80NnP35Hrx+qW
         JCgzzuD4/zZ4lqKhqwY3EFKD/py1XsGeic96QoYzwWevvixZv94gid+b82UzqYpY7WnS
         ke1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700312501; x=1700917301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/xSKH5MjnKUt8pNxHwpsPk44beT81H//Elcee/6O4g=;
        b=IwQdDendm9J/ZSChriT9hgzqOcpt5pQhzGJ8/p6c1ha0EhM+IkJJk2IJkkTAPsi09w
         QDy6ISf8PgsDKNtygShhM52/c7/122qzFoWcYFjTefS+N8Ba2Z52el5R1nrUOcN8+tvo
         0101UE/zHhlOxMTGtW6awBY1qCevCBMc4wvWUUr0Z6YYnQTLXMQ9GRfCi1dKmAsRdpiC
         /ZHnRzXw1Sig4YWcygAWkNoO4ZEY5DNXYPuEGXqkCZRNtUsXBJv/E2UsI69rwjzgfEaJ
         Tx4x+kt4JqYiQeNmz6R0ecU+lZKaJoJBlPVcTydY8NjeYUu8ptp1qFVkQkF/RVH9TIwj
         NYEQ==
X-Gm-Message-State: AOJu0Ywbv7HayGz1ebxuUaR94p0YPK8Oni7OJwrLwWK9rty89CWXtFoV
	OC/T1m5XKcUmBcrjqs4cTvnDUEZo8s8HiFBcSLlXzw==
X-Google-Smtp-Source: AGHT+IEnaBcGNGlyAlBomiJMfszQAIg9g8qffeteFaFXoLic3Oj8CckTcDKafTLn6ZCVjiqV1NaD5QH2DVmCcSiSchk=
X-Received: by 2002:a17:90b:1a8a:b0:27d:f711:112e with SMTP id
 ng10-20020a17090b1a8a00b0027df711112emr2847602pjb.45.1700312500630; Sat, 18
 Nov 2023 05:01:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-6-apatel@ventanamicro.com> <20231025-2e789d3351d686df825e65f6@orel>
In-Reply-To: <20231025-2e789d3351d686df825e65f6@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 18 Nov 2023 18:31:29 +0530
Message-ID: <CAK9=C2WjbCLbWqzNrftJSLSkPcaZJhpjKHQAyGtW5seHg_O8ig@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 5/6] riscv: Use AIA in-kernel irqchip whenever
 KVM RISC-V supports
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 7:09=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, Sep 18, 2023 at 06:27:29PM +0530, Anup Patel wrote:
> > The KVM RISC-V kernel module supports AIA in-kernel irqchip when
> > underlying host has AIA support. We detect and use AIA in-kernel
> > irqchip whenever possible otherwise we fallback to PLIC emulated
> > in user-space.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  Makefile                     |   1 +
> >  riscv/aia.c                  | 227 +++++++++++++++++++++++++++++++++++
> >  riscv/include/kvm/fdt-arch.h |   8 +-
> >  riscv/include/kvm/kvm-arch.h |   2 +
> >  riscv/irq.c                  |   3 +
> >  5 files changed, 240 insertions(+), 1 deletion(-)
> >  create mode 100644 riscv/aia.c
> >
> > diff --git a/Makefile b/Makefile
> > index e711670..acd5ffd 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -220,6 +220,7 @@ ifeq ($(ARCH),riscv)
> >       OBJS            +=3D riscv/kvm-cpu.o
> >       OBJS            +=3D riscv/pci.o
> >       OBJS            +=3D riscv/plic.o
> > +     OBJS            +=3D riscv/aia.o
> >       ifeq ($(RISCV_XLEN),32)
> >               CFLAGS  +=3D -mabi=3Dilp32d -march=3Drv32gc
> >       endif
> > diff --git a/riscv/aia.c b/riscv/aia.c
> > new file mode 100644
> > index 0000000..8c85b3f
> > --- /dev/null
> > +++ b/riscv/aia.c
> > @@ -0,0 +1,227 @@
> > +#include "kvm/devices.h"
> > +#include "kvm/fdt.h"
> > +#include "kvm/ioeventfd.h"
> > +#include "kvm/ioport.h"
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/irq.h"
> > +#include "kvm/util.h"
> > +
> > +static int aia_fd =3D -1;
> > +
> > +static u32 aia_mode =3D KVM_DEV_RISCV_AIA_MODE_EMUL;
> > +static struct kvm_device_attr aia_mode_attr =3D {
> > +     .group  =3D KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +     .attr   =3D KVM_DEV_RISCV_AIA_CONFIG_MODE,
> > +};
> > +
> > +static u32 aia_nr_ids =3D 0;
> > +static struct kvm_device_attr aia_nr_ids_attr =3D {
> > +     .group  =3D KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +     .attr   =3D KVM_DEV_RISCV_AIA_CONFIG_IDS,
> > +};
> > +
> > +static u32 aia_nr_sources =3D 0;
> > +static struct kvm_device_attr aia_nr_sources_attr =3D {
> > +     .group  =3D KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +     .attr   =3D KVM_DEV_RISCV_AIA_CONFIG_SRCS,
> > +};
> > +
> > +static u32 aia_hart_bits =3D 0;
> > +static struct kvm_device_attr aia_hart_bits_attr =3D {
> > +     .group  =3D KVM_DEV_RISCV_AIA_GRP_CONFIG,
> > +     .attr   =3D KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
> > +};
> > +
> > +static u32 aia_nr_harts =3D 0;
> > +
> > +#define IRQCHIP_AIA_NR                       0
> > +
> > +#define AIA_IMSIC_BASE                       RISCV_IRQCHIP
> > +#define AIA_IMSIC_ADDR(__hart)               \
> > +     (AIA_IMSIC_BASE + (__hart) * KVM_DEV_RISCV_IMSIC_SIZE)
> > +#define AIA_IMSIC_SIZE                       \
> > +     (aia_nr_harts * KVM_DEV_RISCV_IMSIC_SIZE)
> > +#define AIA_APLIC_ADDR(__nr_harts)   \
> > +     (AIA_IMSIC_BASE + (__nr_harts) * KVM_DEV_RISCV_IMSIC_SIZE)
>
> AIA_APLIC_ADDR() probably doesn't need to take nr_harts since it's
> always called with aia_nr_harts. So it could just be defined as
>
>  #define AIA_APLIC_ADDR (AIA_IMSIC_BASE + AIA_IMSIC_SIZE)

Okay, I will update.

>
> > +
> > +static void aia__generate_fdt_node(void *fdt, struct kvm *kvm)
> > +{
> > +     u32 i;
> > +     char name[64];
> > +     u32 reg_cells[4], *irq_cells;
> > +
> > +     irq_cells =3D calloc(aia_nr_harts * 2, sizeof(u32));
> > +     if (!irq_cells)
> > +             die("Failed to alloc irq_cells");
> > +
> > +     sprintf(name, "imsics@%08x", (u32)AIA_IMSIC_BASE);
> > +     _FDT(fdt_begin_node(fdt, name));
> > +     _FDT(fdt_property_string(fdt, "compatible", "riscv,imsics"));
> > +     reg_cells[0] =3D 0;
> > +     reg_cells[1] =3D cpu_to_fdt32(AIA_IMSIC_BASE);
> > +     reg_cells[2] =3D 0;
> > +     reg_cells[3] =3D cpu_to_fdt32(AIA_IMSIC_SIZE);
> > +     _FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
> > +     _FDT(fdt_property_cell(fdt, "#interrupt-cells", 0));
> > +     _FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
> > +     _FDT(fdt_property(fdt, "msi-controller", NULL, 0));
> > +     _FDT(fdt_property_cell(fdt, "riscv,num-ids", aia_nr_ids));
> > +     _FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_IMSIC));
> > +     for (i =3D 0; i < aia_nr_harts; i++) {
> > +             irq_cells[2*i + 0] =3D cpu_to_fdt32(PHANDLE_CPU_INTC_BASE=
 + i);
> > +             irq_cells[2*i + 1] =3D cpu_to_fdt32(9);
> > +     }
> > +     _FDT(fdt_property(fdt, "interrupts-extended", irq_cells,
> > +                       sizeof(u32) * aia_nr_harts * 2));
> > +     _FDT(fdt_end_node(fdt));
> > +
> > +     free(irq_cells);
> > +
> > +     /* Skip APLIC node if we have no interrupt sources */
> > +     if (!aia_nr_sources)
> > +             return;
> > +
> > +     sprintf(name, "aplic@%08x", (u32)AIA_APLIC_ADDR(aia_nr_harts));
> > +     _FDT(fdt_begin_node(fdt, name));
> > +     _FDT(fdt_property_string(fdt, "compatible", "riscv,aplic"));
> > +     reg_cells[0] =3D 0;
> > +     reg_cells[1] =3D cpu_to_fdt32(AIA_APLIC_ADDR(aia_nr_harts));
> > +     reg_cells[2] =3D 0;
> > +     reg_cells[3] =3D cpu_to_fdt32(KVM_DEV_RISCV_APLIC_SIZE);
> > +     _FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
> > +     _FDT(fdt_property_cell(fdt, "#interrupt-cells", 2));
> > +     _FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
> > +     _FDT(fdt_property_cell(fdt, "riscv,num-sources", aia_nr_sources))=
;
> > +     _FDT(fdt_property_cell(fdt, "phandle", PHANDLE_AIA_APLIC));
> > +     _FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_AIA_IMSIC));
> > +     _FDT(fdt_end_node(fdt));
> > +}
> > +
> > +static int aia__irq_routing_init(struct kvm *kvm)
> > +{
> > +     int r;
> > +     int irqlines =3D aia_nr_sources + 1;
> > +
> > +     /* Skip this if we have no interrupt sources */
> > +     if (!aia_nr_sources)
> > +             return 0;
> > +
> > +     /*
> > +      * This describes the default routing that the kernel uses withou=
t
> > +      * any routing explicitly set up via KVM_SET_GSI_ROUTING. So we
> > +      * don't need to commit these setting right now. The first actual
> > +      * user (MSI routing) will engage these mappings then.
> > +      */
> > +     for (next_gsi =3D 0; next_gsi < irqlines; next_gsi++) {
> > +             r =3D irq__allocate_routing_entry();
> > +             if (r)
> > +                     return r;
> > +
> > +             irq_routing->entries[irq_routing->nr++] =3D
> > +                     (struct kvm_irq_routing_entry) {
> > +                             .gsi =3D next_gsi,
> > +                             .type =3D KVM_IRQ_ROUTING_IRQCHIP,
> > +                             .u.irqchip.irqchip =3D IRQCHIP_AIA_NR,
> > +                             .u.irqchip.pin =3D next_gsi,
> > +             };
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int aia__init(struct kvm *kvm)
> > +{
> > +     int i, ret;
> > +     u64 aia_addr =3D 0;
> > +     struct kvm_device_attr aia_addr_attr =3D {
> > +             .group  =3D KVM_DEV_RISCV_AIA_GRP_ADDR,
> > +             .addr   =3D (u64)(unsigned long)&aia_addr,
> > +     };
> > +     struct kvm_device_attr aia_init_attr =3D {
> > +             .group  =3D KVM_DEV_RISCV_AIA_GRP_CTRL,
> > +             .attr   =3D KVM_DEV_RISCV_AIA_CTRL_INIT,
> > +     };
> > +
> > +     /* Setup global device attribute variables */
> > +     aia_mode_attr.addr =3D (u64)(unsigned long)&aia_mode;
> > +     aia_nr_ids_attr.addr =3D (u64)(unsigned long)&aia_nr_ids;
> > +     aia_nr_sources_attr.addr =3D (u64)(unsigned long)&aia_nr_sources;
> > +     aia_hart_bits_attr.addr =3D (u64)(unsigned long)&aia_hart_bits;
> > +
> > +     /* Do nothing if AIA device not created */
> > +     if (aia_fd < 0)
> > +             return 0;
> > +
> > +     /* Set/Get AIA device config parameters */
> > +     ret =3D ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_mode_attr);
> > +     if (ret)
> > +             return ret;
> > +     ret =3D ioctl(aia_fd, KVM_GET_DEVICE_ATTR, &aia_nr_ids_attr);
> > +     if (ret)
> > +             return ret;
> > +     aia_nr_sources =3D irq__get_nr_allocated_lines();
> > +     ret =3D ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
> > +     if (ret)
> > +             return ret;
> > +     aia_hart_bits =3D fls_long(kvm->nrcpus);
> > +     ret =3D ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* Save number of HARTs for FDT generation */
> > +     aia_nr_harts =3D kvm->nrcpus;
> > +
> > +     /* Set AIA device addresses */
> > +     aia_addr =3D AIA_APLIC_ADDR(aia_nr_harts);
> > +     aia_addr_attr.attr =3D KVM_DEV_RISCV_AIA_ADDR_APLIC;
> > +     ret =3D ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr);
> > +     if (ret)
> > +             return ret;
> > +     for (i =3D 0; i < kvm->nrcpus; i++) {
> > +             aia_addr =3D AIA_IMSIC_ADDR(i);
> > +             aia_addr_attr.attr =3D KVM_DEV_RISCV_AIA_ADDR_IMSIC(i);
> > +             ret =3D ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_addr_attr=
);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     /* Setup default IRQ routing */
> > +     aia__irq_routing_init(kvm);
> > +
> > +     /* Initialize the AIA device */
> > +     ret =3D ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_init_attr);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* Mark IRQFD as ready */
> > +     riscv_irqchip_irqfd_ready =3D true;
> > +
> > +     return 0;
> > +}
> > +late_init(aia__init);
> > +
> > +void aia__create(struct kvm *kvm)
> > +{
> > +     int err;
> > +     struct kvm_create_device aia_device =3D {
> > +             .type =3D KVM_DEV_TYPE_RISCV_AIA,
> > +             .flags =3D 0,
> > +     };
> > +
> > +     if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
> > +             return;
> > +
> > +     err =3D ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
> > +     if (err)
> > +             return;
> > +     aia_fd =3D aia_device.fd;
> > +
> > +     riscv_irqchip =3D IRQCHIP_AIA;
> > +     riscv_irqchip_inkernel =3D true;
> > +     riscv_irqchip_trigger =3D NULL;
> > +     riscv_irqchip_generate_fdt_node =3D aia__generate_fdt_node;
> > +     riscv_irqchip_phandle =3D PHANDLE_AIA_APLIC;
> > +     riscv_irqchip_msi_phandle =3D PHANDLE_AIA_IMSIC;
> > +     riscv_irqchip_line_sensing =3D true;
> > +}
> > diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.=
h
> > index f7548e8..d88b832 100644
> > --- a/riscv/include/kvm/fdt-arch.h
> > +++ b/riscv/include/kvm/fdt-arch.h
> > @@ -1,7 +1,13 @@
> >  #ifndef KVM__KVM_FDT_H
> >  #define KVM__KVM_FDT_H
> >
> > -enum phandles {PHANDLE_RESERVED =3D 0, PHANDLE_PLIC, PHANDLES_MAX};
> > +enum phandles {
> > +     PHANDLE_RESERVED =3D 0,
> > +     PHANDLE_PLIC,
> > +     PHANDLE_AIA_APLIC,
> > +     PHANDLE_AIA_IMSIC,
> > +     PHANDLES_MAX
> > +};
> >
> >  #define PHANDLE_CPU_INTC_BASE        PHANDLES_MAX
> >
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.=
h
> > index 1a8af6a..9f2159f 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -100,6 +100,8 @@ extern u32 riscv_irqchip_msi_phandle;
> >  extern bool riscv_irqchip_line_sensing;
> >  extern bool riscv_irqchip_irqfd_ready;
> >
> > +void aia__create(struct kvm *kvm);
> > +
>
> nit: I'd remove the blank line between *__create functions.

Okay, I will update.

>
> >  void plic__create(struct kvm *kvm);
> >
> >  void pci__generate_fdt_nodes(void *fdt);
> > diff --git a/riscv/irq.c b/riscv/irq.c
> > index e6c0939..be3e7ac 100644
> > --- a/riscv/irq.c
> > +++ b/riscv/irq.c
> > @@ -135,6 +135,9 @@ void riscv__generate_irq_prop(void *fdt, u8 irq, en=
um irq_type irq_type)
> >
> >  void riscv__irqchip_create(struct kvm *kvm)
> >  {
> > +     /* Try AIA in-kernel irqchip. */
> > +     aia__create(kvm);
> > +
> >       /* Try PLIC irqchip */
> >       plic__create(kvm);
>
> I realize plic__create() just returns if aia__create() successful set up
> the irqchip, but structuring this like
>
>  ret =3D aia__create(kvm);
>  if (!ret)
>     ret =3D plic__create(kvm);
>  if (!ret)
>     die(...);
>
> Might be a little easier to for future readers of the code to grok on
> first read.

Okay, I will update it so that it is obvious to readers that __create()
functions are tried one after another until one suceeds.

>
>
> Either way,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> Thanks,
> drew

Regards,
Anup

