Return-Path: <kvm+bounces-1987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFE37EFFB5
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E18D1F230FB
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 12:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A70B134AA;
	Sat, 18 Nov 2023 12:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hKfzRLVH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5CF9
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 04:59:22 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cf52e5e07eso1717055ad.0
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 04:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700312362; x=1700917162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vIju6hTP2sQy0rulEHEFaZbKoxsktOc4We8XfOFk8U=;
        b=hKfzRLVHCKLEPWQjLr+ZH4D9ppmTMyc38oUGuHH65xBfB7L3FAAtNvSZIkF9JERUYD
         3tIRtwecJa1y+HsZqZjJgRRsxaB5zbK0VUmW9xikoA+qTUwspGk3LzI3jQeAiAbcy1DE
         r6hx/8OvT8R0C5/oNdMVGQqGQdkr1xH9yvJayGGzfcZxY2AeuAKtsO67umKjn4UK6qad
         fn761EvGfN9XttapSDH+MwobFueD5Jq0+8Oq5Jp/67IZ2htc+ZFUTOUv4FXlX6bXkcG8
         yF0xUieL/+az2sVlMnSDmZ5Vd8J/q97KAVplkeSuvNgoV16Rfv9LLb83SHxwYrC34+Rl
         z2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700312362; x=1700917162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vIju6hTP2sQy0rulEHEFaZbKoxsktOc4We8XfOFk8U=;
        b=R94xyRd9GA7M/8G9EUMQ0wW0WOTi/zZItIXEVofu85QGPKawYhn6df0QGOzyk6am2m
         v0+F9E7x8XGS3U0P8FKpJv+SnycgDD+ADVYGWfMMO38waZbifujBq9YLsJe21cINN3A6
         pFsbyuDdk4KG1V3It/jmlottztJEdoNgjLrewJaicxkmtkid0cPS2jxKaC8tbd1goc+g
         th/ll/naN3EzFMJLdNkCKR6IOA59+ASicTQfeZ4P/NyO/j9aUp2WfECbcfiy+bmQ1V1j
         2QRdD3RhSmSOQaWtQkiu0goSc5Pbxf0NwV4NELMTeFf0SV77O78hSE/mX5vbpFXebDN2
         6xDQ==
X-Gm-Message-State: AOJu0YxefITzdytiVsXUi1FP8j/o653btSGZ2bqL1HESZFl0gVr11x5g
	n1Itea5jLKLMxdlWDy1/I2MemWzMlCzTyRm/il0dGg==
X-Google-Smtp-Source: AGHT+IE/sHPrYG6zdUzcUKC+Phe6Ugy1gH92eCaRq5UM0wUAKcJ39xEHuUGHEBOvbJfevK1Nc4ZtNcsVfKQko3uy6xY=
X-Received: by 2002:a17:90a:c915:b0:283:9d7e:89aa with SMTP id
 v21-20020a17090ac91500b002839d7e89aamr5588043pjt.17.1700312361280; Sat, 18
 Nov 2023 04:59:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <20230918125730.1371985-4-apatel@ventanamicro.com> <20231025-1c73a19ce66883899105b508@orel>
In-Reply-To: <20231025-1c73a19ce66883899105b508@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 18 Nov 2023 18:29:10 +0530
Message-ID: <CAK9=C2VR6pzeXhYHR5J36aZRE86K-q42nghVSpXVozYc6+JCfA@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 3/6] riscv: Make irqchip support pluggable
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 6:40=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, Sep 18, 2023 at 06:27:27PM +0530, Anup Patel wrote:
> > We will be having different types of irqchip:
> > 1) PLIC emulated by user-space
> > 2) AIA APLIC and IMSIC provided by in-kernel KVM module
> >
> > To support above, we de-couple PLIC specific code from generic
> > RISC-V code (such as FDT generation) so that we can easily add
> > other types of irqchip.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/fdt.c                  | 14 ++++++--
> >  riscv/include/kvm/kvm-arch.h | 25 ++++++++++++---
> >  riscv/irq.c                  | 62 ++++++++++++++++++++++++++++++++++--
> >  riscv/kvm.c                  |  2 ++
> >  riscv/pci.c                  | 32 +++++++++++++------
> >  riscv/plic.c                 | 61 +++++++++++++++++------------------
> >  6 files changed, 147 insertions(+), 49 deletions(-)
> >
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 2724c6e..9af71b5 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -209,19 +209,26 @@ static int setup_fdt(struct kvm *kvm)
> >       /* CPUs */
> >       generate_cpu_nodes(fdt, kvm);
> >
> > +     /* IRQCHIP */
> > +     if (!riscv_irqchip_generate_fdt_node)
> > +             die("No way to generate IRQCHIP FDT node\n");
> > +     riscv_irqchip_generate_fdt_node(fdt, kvm);
> > +
> >       /* Simple Bus */
> >       _FDT(fdt_begin_node(fdt, "smb"));
> >       _FDT(fdt_property_string(fdt, "compatible", "simple-bus"));
> >       _FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
> >       _FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
> > -     _FDT(fdt_property_cell(fdt, "interrupt-parent", PHANDLE_PLIC));
> > +     _FDT(fdt_property_cell(fdt, "interrupt-parent",
> > +                            riscv_irqchip_phandle));
> >       _FDT(fdt_property(fdt, "ranges", NULL, 0));
> >
> >       /* Virtio MMIO devices */
> >       dev_hdr =3D device__first_dev(DEVICE_BUS_MMIO);
> >       while (dev_hdr) {
> >               generate_mmio_fdt_nodes =3D dev_hdr->data;
> > -             generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_=
prop);
> > +             generate_mmio_fdt_nodes(fdt, dev_hdr,
> > +                                     riscv__generate_irq_prop);
> >               dev_hdr =3D device__next_dev(dev_hdr);
> >       }
> >
> > @@ -229,7 +236,8 @@ static int setup_fdt(struct kvm *kvm)
> >       dev_hdr =3D device__first_dev(DEVICE_BUS_IOPORT);
> >       while (dev_hdr) {
> >               generate_mmio_fdt_nodes =3D dev_hdr->data;
> > -             generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_=
prop);
> > +             generate_mmio_fdt_nodes(fdt, dev_hdr,
> > +                                     riscv__generate_irq_prop);
> >               dev_hdr =3D device__next_dev(dev_hdr);
> >       }
>
> nit: I'd let the above lines run long, but I know you prefer wrapping
>      at 80.
>
> >
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.=
h
> > index 660355b..cd37fc6 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -10,8 +10,8 @@
> >
> >  #define RISCV_IOPORT         0x00000000ULL
> >  #define RISCV_IOPORT_SIZE    SZ_64K
> > -#define RISCV_PLIC           0x0c000000ULL
> > -#define RISCV_PLIC_SIZE              SZ_64M
> > +#define RISCV_IRQCHIP                0x08000000ULL
> > +#define RISCV_IRQCHIP_SIZE           SZ_128M
>
> I checked the applied patch and the SZ_128M is over indented.
>
> >  #define RISCV_MMIO           0x10000000ULL
> >  #define RISCV_MMIO_SIZE              SZ_512M
> >  #define RISCV_PCI            0x30000000ULL
> > @@ -84,10 +84,27 @@ static inline bool riscv_addr_in_ioport_region(u64 =
phys_addr)
> >
> >  enum irq_type;
> >
> > -void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type=
);
> > +enum irqchip_type {
> > +     IRQCHIP_UNKNOWN =3D 0,
> > +     IRQCHIP_PLIC,
> > +     IRQCHIP_AIA
> > +};
> > +
> > +extern enum irqchip_type riscv_irqchip;
> > +extern bool riscv_irqchip_inkernel;
> > +extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
> > +                                  int level, bool edge);
> > +extern void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *=
kvm);
> > +extern u32 riscv_irqchip_phandle;
> > +extern u32 riscv_irqchip_msi_phandle;
> > +extern bool riscv_irqchip_line_sensing;
> >
> > -void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
> > +void plic__create(struct kvm *kvm);
> >
> >  void pci__generate_fdt_nodes(void *fdt);
> >
> > +void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_typ=
e);
> > +
> > +void riscv__irqchip_create(struct kvm *kvm);
> > +
> >  #endif /* KVM__KVM_ARCH_H */
> > diff --git a/riscv/irq.c b/riscv/irq.c
> > index 78a582d..b608a2f 100644
> > --- a/riscv/irq.c
> > +++ b/riscv/irq.c
> > @@ -1,13 +1,71 @@
> >  #include "kvm/kvm.h"
> >  #include "kvm/kvm-cpu.h"
> >  #include "kvm/irq.h"
> > +#include "kvm/fdt.h"
> > +#include "kvm/virtio.h"
> > +
> > +enum irqchip_type riscv_irqchip =3D IRQCHIP_UNKNOWN;
> > +bool riscv_irqchip_inkernel =3D false;
> > +void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq, int level, boo=
l edge)
> > +                             =3D NULL;
> > +void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm) =
=3D NULL;
> > +u32 riscv_irqchip_phandle =3D PHANDLE_RESERVED;
> > +u32 riscv_irqchip_msi_phandle =3D PHANDLE_RESERVED;
> > +bool riscv_irqchip_line_sensing =3D false;
>
> nit: no need to init BSS symbols with zeros.

Okay, I will update.

>
> >
> >  void kvm__irq_line(struct kvm *kvm, int irq, int level)
> >  {
> > -     plic__irq_trig(kvm, irq, level, false);
> > +     struct kvm_irq_level irq_level;
> > +
> > +     if (riscv_irqchip_inkernel) {
> > +             irq_level.irq =3D irq;
> > +             irq_level.level =3D !!level;
> > +             if (ioctl(kvm->vm_fd, KVM_IRQ_LINE, &irq_level) < 0)
> > +                     pr_warning("%s: Could not KVM_IRQ_LINE for irq %d=
\n",
> > +                                __func__, irq);
> > +     } else {
> > +             if (riscv_irqchip_trigger)
> > +                     riscv_irqchip_trigger(kvm, irq, level, false);
> > +             else
> > +                     pr_warning("%s: Can't change level for irq %d\n",
> > +                                __func__, irq);
> > +     }
> >  }
> >
> >  void kvm__irq_trigger(struct kvm *kvm, int irq)
> >  {
> > -     plic__irq_trig(kvm, irq, 1, true);
> > +     if (riscv_irqchip_inkernel) {
> > +             kvm__irq_line(kvm, irq, VIRTIO_IRQ_HIGH);
> > +             kvm__irq_line(kvm, irq, VIRTIO_IRQ_LOW);
> > +     } else {
> > +             if (riscv_irqchip_trigger)
> > +                     riscv_irqchip_trigger(kvm, irq, 1, true);
> > +             else
> > +                     pr_warning("%s: Can't trigger irq %d\n",
> > +                                __func__, irq);
> > +     }
> > +}
> > +
> > +void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_typ=
e)
> > +{
> > +     u32 prop[2], size;
> > +
> > +     prop[0] =3D cpu_to_fdt32(irq);
> > +     size =3D sizeof(u32);
> > +     if (riscv_irqchip_line_sensing) {
> > +             prop[1] =3D cpu_to_fdt32(irq_type);
> > +             size +=3D sizeof(u32);
> > +     }
> > +
> > +     _FDT(fdt_property(fdt, "interrupts", prop, size));
> > +}
> > +
> > +void riscv__irqchip_create(struct kvm *kvm)
> > +{
> > +     /* Try PLIC irqchip */
> > +     plic__create(kvm);
> > +
> > +     /* Fail if irqchip unknown */
> > +     if (riscv_irqchip =3D=3D IRQCHIP_UNKNOWN)
> > +             die("No IRQCHIP found\n");
> >  }
> > diff --git a/riscv/kvm.c b/riscv/kvm.c
> > index 8daad94..1d49479 100644
> > --- a/riscv/kvm.c
> > +++ b/riscv/kvm.c
> > @@ -96,6 +96,8 @@ void kvm__arch_init(struct kvm *kvm)
> >
> >       madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> >               MADV_HUGEPAGE);
> > +
> > +     riscv__irqchip_create(kvm);
> >  }
> >
> >  #define FDT_ALIGN    SZ_4M
> > diff --git a/riscv/pci.c b/riscv/pci.c
> > index 604fd20..61dee06 100644
> > --- a/riscv/pci.c
> > +++ b/riscv/pci.c
> > @@ -7,20 +7,21 @@
> >
> >  /*
> >   * An entry in the interrupt-map table looks like:
> > - * <pci unit address> <pci interrupt pin> <plic phandle> <plic interru=
pt>
> > + * <pci unit address> <pci interrupt pin> <irqchip phandle> <irqchip l=
ine>
> >   */
> >
> >  struct of_interrupt_map_entry {
> >       struct of_pci_irq_mask          pci_irq_mask;
> > -     u32                             plic_phandle;
> > -     u32                             plic_irq;
> > +     u32                             irqchip_phandle;
> > +     u32                             irqchip_line;
> > +     u32                             irqchip_sense;
> >  } __attribute__((packed));
> >
> >  void pci__generate_fdt_nodes(void *fdt)
> >  {
> >       struct device_header *dev_hdr;
> >       struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
> > -     unsigned nentries =3D 0;
> > +     unsigned nentries =3D 0, nsize;
> >       /* Bus range */
> >       u32 bus_range[] =3D { cpu_to_fdt32(0), cpu_to_fdt32(1), };
> >       /* Configuration Space */
> > @@ -48,6 +49,11 @@ void pci__generate_fdt_nodes(void *fdt)
> >               },
> >       };
> >
> > +     /* Find size of each interrupt map entery */
> > +     nsize =3D sizeof(struct of_interrupt_map_entry);
> > +     if (!riscv_irqchip_line_sensing)
> > +             nsize -=3D sizeof(u32);
> > +
> >       /* Boilerplate PCI properties */
> >       _FDT(fdt_begin_node(fdt, "pci"));
> >       _FDT(fdt_property_string(fdt, "device_type", "pci"));
> > @@ -64,12 +70,13 @@ void pci__generate_fdt_nodes(void *fdt)
> >       /* Generate the interrupt map ... */
> >       dev_hdr =3D device__first_dev(DEVICE_BUS_PCI);
> >       while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
> > -             struct of_interrupt_map_entry *entry =3D &irq_map[nentrie=
s];
> > +             struct of_interrupt_map_entry *entry;
> >               struct pci_device_header *pci_hdr =3D dev_hdr->data;
> >               u8 dev_num =3D dev_hdr->dev_num;
> >               u8 pin =3D pci_hdr->irq_pin;
> >               u8 irq =3D pci_hdr->irq_line;
> >
> > +             entry =3D ((void *)irq_map) + (nsize * nentries);
>
> nit: The outer () of both terms are superfluous.

Okay, I will update.

>
> >               *entry =3D (struct of_interrupt_map_entry) {
> >                       .pci_irq_mask =3D {
> >                               .pci_addr =3D {
> > @@ -79,16 +86,18 @@ void pci__generate_fdt_nodes(void *fdt)
> >                               },
> >                               .pci_pin        =3D cpu_to_fdt32(pin),
> >                       },
> > -                     .plic_phandle   =3D cpu_to_fdt32(PHANDLE_PLIC),
> > -                     .plic_irq       =3D cpu_to_fdt32(irq),
> > +                     .irqchip_phandle        =3D cpu_to_fdt32(riscv_ir=
qchip_phandle),
> > +                     .irqchip_line           =3D cpu_to_fdt32(irq),
> >               };
> >
> > +             if (riscv_irqchip_line_sensing)
> > +                     entry->irqchip_sense =3D cpu_to_fdt32(IRQ_TYPE_LE=
VEL_HIGH);
> > +
> >               nentries++;
> >               dev_hdr =3D device__next_dev(dev_hdr);
> >       }
> >
> > -     _FDT(fdt_property(fdt, "interrupt-map", irq_map,
> > -                       sizeof(struct of_interrupt_map_entry) * nentrie=
s));
> > +     _FDT(fdt_property(fdt, "interrupt-map", irq_map, nsize * nentries=
));
> >
> >       /* ... and the corresponding mask. */
> >       if (nentries) {
> > @@ -105,5 +114,10 @@ void pci__generate_fdt_nodes(void *fdt)
> >                                 sizeof(irq_mask)));
> >       }
> >
> > +     /* Set MSI parent if available */
> > +     if (riscv_irqchip_msi_phandle !=3D PHANDLE_RESERVED)
> > +             _FDT(fdt_property_cell(fdt, "msi-parent",
> > +                                    riscv_irqchip_msi_phandle));
> > +
> >       _FDT(fdt_end_node(fdt));
> >  }
> > diff --git a/riscv/plic.c b/riscv/plic.c
> > index 6242286..ab7c574 100644
> > --- a/riscv/plic.c
> > +++ b/riscv/plic.c
> > @@ -118,7 +118,6 @@ struct plic_context {
> >  struct plic_state {
> >       bool ready;
> >       struct kvm *kvm;
> > -     struct device_header dev_hdr;
> >
> >       /* Static Configuration */
> >       u32 num_irq;
> > @@ -204,7 +203,7 @@ static u32 __plic_context_irq_claim(struct plic_sta=
te *s,
> >       return best_irq;
> >  }
> >
> > -void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
> > +static void plic__irq_trig(struct kvm *kvm, int irq, int level, bool e=
dge)
> >  {
> >       bool irq_marked =3D false;
> >       u8 i, irq_prio, irq_word;
> > @@ -425,7 +424,7 @@ static void plic__mmio_callback(struct kvm_cpu *vcp=
u,
> >               die("plic: invalid len=3D%d", len);
> >
> >       addr &=3D ~0x3;
> > -     addr -=3D RISCV_PLIC;
> > +     addr -=3D RISCV_IRQCHIP;
> >
> >       if (is_write) {
> >               if (PRIORITY_BASE <=3D addr && addr < ENABLE_BASE) {
> > @@ -464,34 +463,23 @@ static void plic__mmio_callback(struct kvm_cpu *v=
cpu,
> >       }
> >  }
> >
> > -void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type=
)
> > -{
> > -     u32 irq_prop[] =3D {
> > -             cpu_to_fdt32(irq)
> > -     };
> > -
> > -     _FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)))=
;
> > -}
> > -
> > -static void plic__generate_fdt_node(void *fdt,
> > -                                 struct device_header *dev_hdr,
> > -                                 void (*generate_irq_prop)(void *fdt,
> > -                                                           u8 irq,
> > -                                                           enum irq_ty=
pe))
> > +static void plic__generate_fdt_node(void *fdt, struct kvm *kvm)
> >  {
> >       u32 i;
> > +     char name[64];
> >       u32 reg_cells[4], *irq_cells;
> >
> >       reg_cells[0] =3D 0;
> > -     reg_cells[1] =3D cpu_to_fdt32(RISCV_PLIC);
> > +     reg_cells[1] =3D cpu_to_fdt32(RISCV_IRQCHIP);
> >       reg_cells[2] =3D 0;
> > -     reg_cells[3] =3D cpu_to_fdt32(RISCV_PLIC_SIZE);
> > +     reg_cells[3] =3D cpu_to_fdt32(RISCV_IRQCHIP_SIZE);
> >
> >       irq_cells =3D calloc(plic.num_context * 2, sizeof(u32));
> >       if (!irq_cells)
> >               die("Failed to alloc irq_cells");
> >
> > -     _FDT(fdt_begin_node(fdt, "interrupt-controller@0c000000"));
> > +     sprintf(name, "interrupt-controller@%08x", (u32)RISCV_IRQCHIP);
> > +     _FDT(fdt_begin_node(fdt, name));
> >       _FDT(fdt_property_string(fdt, "compatible", "riscv,plic0"));
> >       _FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
> >       _FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
> > @@ -518,12 +506,10 @@ static int plic__init(struct kvm *kvm)
> >       int ret;
> >       struct plic_context *c;
> >
> > -     plic.kvm =3D kvm;
> > -     plic.dev_hdr =3D (struct device_header) {
> > -             .bus_type       =3D DEVICE_BUS_MMIO,
> > -             .data           =3D plic__generate_fdt_node,
> > -     };
> > +     if (riscv_irqchip !=3D IRQCHIP_PLIC)
> > +             return 0;
> >
> > +     plic.kvm =3D kvm;
> >       plic.num_irq =3D MAX_DEVICES;
> >       plic.num_irq_word =3D plic.num_irq / 32;
> >       if ((plic.num_irq_word * 32) < plic.num_irq)
> > @@ -544,15 +530,11 @@ static int plic__init(struct kvm *kvm)
> >
> >       mutex_init(&plic.irq_lock);
> >
> > -     ret =3D kvm__register_mmio(kvm, RISCV_PLIC, RISCV_PLIC_SIZE,
> > +     ret =3D kvm__register_mmio(kvm, RISCV_IRQCHIP, RISCV_IRQCHIP_SIZE=
,
> >                                false, plic__mmio_callback, &plic);
> >       if (ret)
> >               return ret;
> >
> > -     ret =3D device__register(&plic.dev_hdr);
> > -     if (ret)
> > -             return ret;
> > -
>
> Dropping this device__register() made me scratch my head a bit. I think
> it's not necessary to enumerate the irqchip in the device list and its
> fdt node is now generated by riscv_irqchip_generate_fdt_node(), but it'd
> be a lot easier for me if the commit message explained why this is OK.

Okay, I will update the commit description.

>
> >       plic.ready =3D true;
> >
> >       return 0;
> > @@ -562,10 +544,27 @@ dev_init(plic__init);
> >
> >  static int plic__exit(struct kvm *kvm)
> >  {
> > +     if (riscv_irqchip !=3D IRQCHIP_PLIC)
> > +             return 0;
> > +
> >       plic.ready =3D false;
> > -     kvm__deregister_mmio(kvm, RISCV_PLIC);
> > +     kvm__deregister_mmio(kvm, RISCV_IRQCHIP);
> >       free(plic.contexts);
> >
> >       return 0;
> >  }
> >  dev_exit(plic__exit);
> > +
> > +void plic__create(struct kvm *kvm)
> > +{
> > +     if (riscv_irqchip !=3D IRQCHIP_UNKNOWN)
> > +             return;
> > +
> > +     riscv_irqchip =3D IRQCHIP_PLIC;
> > +     riscv_irqchip_inkernel =3D false;
> > +     riscv_irqchip_trigger =3D plic__irq_trig;
> > +     riscv_irqchip_generate_fdt_node =3D plic__generate_fdt_node;
> > +     riscv_irqchip_phandle =3D PHANDLE_PLIC;
> > +     riscv_irqchip_msi_phandle =3D PHANDLE_RESERVED;
> > +     riscv_irqchip_line_sensing =3D false;
> > +}
> > --
> > 2.34.1
> >
>
> Besides the nits, the whitespace issue, and request for another sentence
> in the commit message,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> Thanks,
> drew

Regards,
Anup

