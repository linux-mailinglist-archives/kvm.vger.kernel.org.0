Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13ECB6C14F0
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjCTOiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjCTOiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:38:02 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3822C28858
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:37:40 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i6so13343651ybu.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1679323060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amDbW1BLySAM0EY7Ja2fhoyzX2ieMe5SoE9LP8DNLh0=;
        b=0nrOzwTGsPqjEEZXvSv1aT610770rqbrGipToGYi/G79sdbrQ+2V1AOCtKf0LQfx0y
         TfFDUYFprNHmkMNq4TZyJnpWYa5Ra3/5Tk/dbs2rcZ7esPm93urnulpnEmfmZw852z0I
         vvRADbGeEMx0Lstp+mAJxFtCV9YxuE4blIG7A8E63aXXsGKl3vYaysYpX9SnNf5kuTuC
         1Xn06ksjxiX7rnmbp4HTQVisis8ynieLzMmu7ZTZ3X5+lpcNabOlV8Jtwhb4YJNUHxhU
         DyQC++SHyRyvBf6rc1mwltwayoHF14Pp17mUVMXUgf8gPyvEqt/RZYtPY7G3sPWWvwK+
         xQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679323060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amDbW1BLySAM0EY7Ja2fhoyzX2ieMe5SoE9LP8DNLh0=;
        b=6u/IbgLOdAwxPS3dRmxg1N1p14USkvq7CLcbWpn5amWoQupJSyEhPiOmGGvz/lK7np
         dxBvuMXlCy2Jk3yDrqFF4pE2Ea/hsMSITIXhfA2ueljRDf/FpmnugCexRSoDz2a7AJPl
         9xVOoKGRVHJJIQgSLzjlCGuNme9VIQnvevwsYGXDOwZG0F42Jp4NUfouJ6CFAze7m7Jj
         WPFtpdGKyJgn5CskA7S2Wht8BTyHf6jgI20h+y/iGpNpI1ooU5UZMHLA4zjRQakQS2D8
         Z/5La52UuoHLkrRV3fWItf0+Ld622fIVNeoj0mUFsw5zFwrFwIsGeg9o4Xp5VH0iAgSI
         OOHw==
X-Gm-Message-State: AO0yUKVz7LwXFYn2oJv/ol6aR69dg1rIaMXT+tsEpu4QzCbnoEmQoCN4
        Q+YNA6VClk8YsX3L+VM6bSzXt11Pnr4AnPdTF0F8Sg==
X-Google-Smtp-Source: AK7set8FN/Iyhw+ttqOjMI4HV6TLE0O+8V2nvc7qALBbTqoDJzP19BCDyY3wNBKJ91O1jwh5CsY/bM4q9PqFLjVb9+E=
X-Received: by 2002:a05:6902:154f:b0:acd:7374:f154 with SMTP id
 r15-20020a056902154f00b00acd7374f154mr5806880ybu.7.1679323059719; Mon, 20 Mar
 2023 07:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230315171238.300572-1-rkanwal@rivosinc.com> <ZBSOjLC/V6iWHGmA@monolith.localdoman>
In-Reply-To: <ZBSOjLC/V6iWHGmA@monolith.localdoman>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Mon, 20 Mar 2023 14:37:28 +0000
Message-ID: <CAECbVCuz_oaLxZVTDNGMDsetMfqzjNUdfL3G1B1LbvAJG=5fhw@mail.gmail.com>
Subject: Re: [PATCH v2 kvmtool] Add virtio-transport option and deprecate
 force-pci and virtio-legacy.
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     atishp@rivosinc.com, apatel@ventanamicro.com, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 4:00=E2=80=AFPM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Wed, Mar 15, 2023 at 05:12:38PM +0000, Rajnesh Kanwal wrote:
> > This is a follow-up patch for [0] which proposed the --force-pci option
> > for riscv. As per the discussion it was concluded to add virtio-tranpor=
t
> > option taking in four options (pci, pci-legacy, mmio, mmio-legacy).
> >
> > With this change force-pci and virtio-legacy are both deprecated and
> > arm's default transport changes from MMIO to PCI as agreed in [0].
> > This is also true for riscv.
> >
> > Nothing changes for other architectures.
> >
> > [0]: https://lore.kernel.org/all/20230118172007.408667-1-rkanwal@rivosi=
nc.com/
> >
> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> >
>
> The changes between patch versions should come after the triple dash, not
> before it, that way it won't show up in git log when the patch gets merge=
d.
>
> > V2:
> >     - Removed VIRTIO_DEFAULT_TRANS macro.
> >     - Replaced `[]` with `()` in cmdline arguments notes.
> >     - Fixed virtio_tranport_parser -> virtio_transport_parser
> >
> > v1: https://lore.kernel.org/all/20230306120329.535320-1-rkanwal@rivosin=
c.com/
> >
> > ---
> >  arm/include/arm-common/kvm-arch.h        |  5 ----
> >  arm/include/arm-common/kvm-config-arch.h |  8 +++----
> >  builtin-run.c                            | 11 +++++++--
> >  include/kvm/kvm-config.h                 |  2 +-
> >  include/kvm/kvm.h                        |  6 -----
> >  include/kvm/virtio.h                     |  2 ++
> >  riscv/include/kvm/kvm-arch.h             |  3 ---
> >  virtio/9p.c                              |  2 +-
> >  virtio/balloon.c                         |  2 +-
> >  virtio/blk.c                             |  2 +-
> >  virtio/console.c                         |  2 +-
> >  virtio/core.c                            | 30 ++++++++++++++++++++++++
> >  virtio/net.c                             |  4 ++--
> >  virtio/rng.c                             |  2 +-
> >  virtio/scsi.c                            |  2 +-
> >  virtio/vsock.c                           |  2 +-
> >  16 files changed, 55 insertions(+), 30 deletions(-)
> >
> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common=
/kvm-arch.h
> > index b2ae373..60eec02 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -80,11 +80,6 @@
> >
> >  #define KVM_VM_TYPE          0
> >
> > -#define VIRTIO_DEFAULT_TRANS(kvm)                                    \
> > -     ((kvm)->cfg.arch.virtio_trans_pci ?                             \
> > -      ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :  \
> > -      ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
> > -
> >  #define VIRTIO_RING_ENDIAN   (VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
> >
> >  #define ARCH_HAS_PCI_EXP     1
> > diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm=
-common/kvm-config-arch.h
> > index 9949bfe..87f5035 100644
> > --- a/arm/include/arm-common/kvm-config-arch.h
> > +++ b/arm/include/arm-common/kvm-config-arch.h
> > @@ -7,7 +7,6 @@ struct kvm_config_arch {
> >       const char      *dump_dtb_filename;
> >       const char      *vcpu_affinity;
> >       unsigned int    force_cntfrq;
> > -     bool            virtio_trans_pci;
> >       bool            aarch32_guest;
> >       bool            has_pmuv3;
> >       bool            mte_disabled;
> > @@ -28,9 +27,10 @@ int irqchip_parser(const struct option *opt, const c=
har *arg, int unset);
> >                    "Specify Generic Timer frequency in guest DT to "   =
       \
> >                    "work around buggy secure firmware *Firmware should =
be "   \
> >                    "updated to program CNTFRQ correctly*"),            =
       \
> > -     OPT_BOOLEAN('\0', "force-pci", &(cfg)->virtio_trans_pci,         =
       \
> > -                 "Force virtio devices to use PCI as their default "  =
       \
> > -                 "transport"),                                        =
       \
> > +     OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, '\0',                =
       \
> > +                        "Force virtio devices to use PCI as their defa=
ult "  \
> > +                        "transport (Deprecated: Use --virtio-transport=
 "     \
> > +                        "option instead)", virtio_transport_parser, kv=
m),    \
> >          OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,                =
               \
> >                    "[gicv2|gicv2m|gicv3|gicv3-its]",                   =
       \
> >                    "Type of interrupt controller to emulate in the gues=
t",    \
> > diff --git a/builtin-run.c b/builtin-run.c
> > index bb7e6e8..f2f179d 100644
> > --- a/builtin-run.c
> > +++ b/builtin-run.c
> > @@ -200,8 +200,15 @@ static int mem_parser(const struct option *opt, co=
nst char *arg, int unset)
> >                       " rootfs"),                                     \
> >       OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",   \
> >                       "Hugetlbfs path"),                              \
> > -     OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,       \
> > -                 "Use legacy virtio transport"),                     \
> > +     OPT_CALLBACK_NOOPT('\0', "virtio-legacy",                       \
> > +                        &(cfg)->virtio_transport, '\0',              \
> > +                        "Use legacy virtio transport (Deprecated:"   \
> > +                        " Use --virtio-transport option instead)",   \
> > +                        virtio_transport_parser, NULL),              \
> > +     OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
> > +                  "[pci|pci-legacy|mmio|mmio-legacy]",               \
>
> While that is true for arm/arm64/riscv, those options are not available f=
or
> other architectures and attempting to set virtio-transport to mmio or
> mmio-legacy will result in an error:
>
>   Error: virtio-transport: unknown type "mmio"
>
> That's when attempting to run lkvm on x86. You can solve that by doing wh=
at
> --mem does, something like:
>
> diff --git a/builtin-run.c b/builtin-run.c
> index f2f179dcb495..a32e186587c5 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -162,6 +162,12 @@ static int mem_parser(const struct option *opt, cons=
t char *arg, int unset)
>         " in megabytes (M)"
>  #endif
>
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV=
)
> +#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy|mmio|mmio-legacy=
]"
> +#else
> +#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy]"
> +#endif
> +
>  #define BUILD_OPTIONS(name, cfg, kvm)                                  \
>         struct option name[] =3D {                                       =
 \
>         OPT_GROUP("Basic options:"),                                    \
> @@ -206,7 +212,7 @@ static int mem_parser(const struct option *opt, const=
 char *arg, int unset)
>                            " Use --virtio-transport option instead)",   \
>                            virtio_transport_parser, NULL),              \
>         OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
> -                    "[pci|pci-legacy|mmio|mmio-legacy]",               \
> +                    VIRTIO_TRANS_OPT_HELP_SHORT,                       \
>                      "Type of virtio transport",                        \
>                      virtio_transport_parser, NULL),                    \
>

Thanks for the suggestions. I have fixed this in v3.
https://lore.kernel.org/all/20230320143224.404220-1-rkanwal@rivosinc.com/T/=
#u

Apologies for multiple patches. I accidently forgot to add the version numb=
er.

Thanks
Rajnesh

> Otherwise, looks good.
>
> Thanks,
> Alex
>
> > +                  "Type of virtio transport",                        \
> > +                  virtio_transport_parser, NULL),                    \
> >                                                                       \
> >       OPT_GROUP("Kernel options:"),                                   \
> >       OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",    \
> > diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> > index 368e6c7..592b035 100644
> > --- a/include/kvm/kvm-config.h
> > +++ b/include/kvm/kvm-config.h
> > @@ -64,7 +64,7 @@ struct kvm_config {
> >       bool no_dhcp;
> >       bool ioport_debug;
> >       bool mmio_debug;
> > -     bool virtio_legacy;
> > +     int virtio_transport;
> >  };
> >
> >  #endif
> > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > index 3872dc6..eb23e2f 100644
> > --- a/include/kvm/kvm.h
> > +++ b/include/kvm/kvm.h
> > @@ -45,12 +45,6 @@ struct kvm_cpu;
> >  typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *da=
ta,
> >                               u32 len, u8 is_write, void *ptr);
> >
> > -/* Archs can override this in kvm-arch.h */
> > -#ifndef VIRTIO_DEFAULT_TRANS
> > -#define VIRTIO_DEFAULT_TRANS(kvm) \
> > -     ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
> > -#endif
> > -
> >  enum {
> >       KVM_VMSTATE_RUNNING,
> >       KVM_VMSTATE_PAUSED,
> > diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> > index 94bddef..0e8c7a6 100644
> > --- a/include/kvm/virtio.h
> > +++ b/include/kvm/virtio.h
> > @@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, str=
uct virtio_device *vdev,
> >  void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
> >                         void *dev, u8 status);
> >
> > +int virtio_transport_parser(const struct option *opt, const char *arg,=
 int unset);
> > +
> >  #endif /* KVM__VIRTIO_H */
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.=
h
> > index 1e130f5..4106099 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -46,9 +46,6 @@
> >
> >  #define KVM_VM_TYPE          0
> >
> > -#define VIRTIO_DEFAULT_TRANS(kvm) \
> > -     ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
> > -
> >  #define VIRTIO_RING_ENDIAN   VIRTIO_ENDIAN_LE
> >
> >  #define ARCH_HAS_PCI_EXP     1
> > diff --git a/virtio/9p.c b/virtio/9p.c
> > index 19b66df..b809bcd 100644
> > --- a/virtio/9p.c
> > +++ b/virtio/9p.c
> > @@ -1552,7 +1552,7 @@ int virtio_9p__init(struct kvm *kvm)
> >
> >       list_for_each_entry(p9dev, &devs, list) {
> >               r =3D virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virti=
o_ops,
> > -                             VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_=
VIRTIO_9P,
> > +                             kvm->cfg.virtio_transport, PCI_DEVICE_ID_=
VIRTIO_9P,
> >                               VIRTIO_ID_9P, PCI_CLASS_9P);
> >               if (r < 0)
> >                       return r;
> > diff --git a/virtio/balloon.c b/virtio/balloon.c
> > index 3a73432..01d1982 100644
> > --- a/virtio/balloon.c
> > +++ b/virtio/balloon.c
> > @@ -279,7 +279,7 @@ int virtio_bln__init(struct kvm *kvm)
> >       memset(&bdev.config, 0, sizeof(struct virtio_balloon_config));
> >
> >       r =3D virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
> > -                     VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_B=
LN,
> > +                     kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_B=
LN,
> >                       VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
> >       if (r < 0)
> >               return r;
> > diff --git a/virtio/blk.c b/virtio/blk.c
> > index 2d06391..f3c34f3 100644
> > --- a/virtio/blk.c
> > +++ b/virtio/blk.c
> > @@ -329,7 +329,7 @@ static int virtio_blk__init_one(struct kvm *kvm, st=
ruct disk_image *disk)
> >       list_add_tail(&bdev->list, &bdevs);
> >
> >       r =3D virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
> > -                     VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_B=
LK,
> > +                     kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_B=
LK,
> >                       VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
> >       if (r < 0)
> >               return r;
> > diff --git a/virtio/console.c b/virtio/console.c
> > index d29319c..11a22a9 100644
> > --- a/virtio/console.c
> > +++ b/virtio/console.c
> > @@ -229,7 +229,7 @@ int virtio_console__init(struct kvm *kvm)
> >               return 0;
> >
> >       r =3D virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
> > -                     VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_C=
ONSOLE,
> > +                     kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_C=
ONSOLE,
> >                       VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
> >       if (r < 0)
> >               return r;
> > diff --git a/virtio/core.c b/virtio/core.c
> > index ea0e5b6..568243a 100644
> > --- a/virtio/core.c
> > +++ b/virtio/core.c
> > @@ -21,6 +21,36 @@ const char* virtio_trans_name(enum virtio_trans tran=
s)
> >       return "unknown";
> >  }
> >
> > +int virtio_transport_parser(const struct option *opt, const char *arg,=
 int unset)
> > +{
> > +     enum virtio_trans *type =3D opt->value;
> > +     struct kvm *kvm;
> > +
> > +     if (!strcmp(opt->long_name, "virtio-transport")) {
> > +             if (!strcmp(arg, "pci")) {
> > +                     *type =3D VIRTIO_PCI;
> > +             } else if (!strcmp(arg, "pci-legacy")) {
> > +                     *type =3D VIRTIO_PCI_LEGACY;
> > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RIS=
CV)
> > +             } else if (!strcmp(arg, "mmio")) {
> > +                     *type =3D VIRTIO_MMIO;
> > +             } else if (!strcmp(arg, "mmio-legacy")) {
> > +                     *type =3D VIRTIO_MMIO_LEGACY;
> > +#endif
> > +             } else {
> > +                     pr_err("virtio-transport: unknown type \"%s\"\n",=
 arg);
> > +                     return -1;
> > +             }
> > +     } else if (!strcmp(opt->long_name, "virtio-legacy")) {
> > +             *type =3D VIRTIO_PCI_LEGACY;
> > +     } else if (!strcmp(opt->long_name, "force-pci")) {
> > +             kvm =3D opt->ptr;
> > +             kvm->cfg.virtio_transport =3D VIRTIO_PCI;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
> >  {
> >       u16 idx =3D virtio_guest_to_host_u16(queue, queue->vring.used->id=
x);
> > diff --git a/virtio/net.c b/virtio/net.c
> > index a5e0cea..8749ebf 100644
> > --- a/virtio/net.c
> > +++ b/virtio/net.c
> > @@ -928,10 +928,10 @@ done:
> >
> >  static int virtio_net__init_one(struct virtio_net_params *params)
> >  {
> > -     int i, r;
> > +     enum virtio_trans trans =3D params->kvm->cfg.virtio_transport;
> >       struct net_dev *ndev;
> >       struct virtio_ops *ops;
> > -     enum virtio_trans trans =3D VIRTIO_DEFAULT_TRANS(params->kvm);
> > +     int i, r;
> >
> >       ndev =3D calloc(1, sizeof(struct net_dev));
> >       if (ndev =3D=3D NULL)
> > diff --git a/virtio/rng.c b/virtio/rng.c
> > index 63ab8fc..8f85d5e 100644
> > --- a/virtio/rng.c
> > +++ b/virtio/rng.c
> > @@ -173,7 +173,7 @@ int virtio_rng__init(struct kvm *kvm)
> >       }
> >
> >       r =3D virtio_init(kvm, rdev, &rdev->vdev, &rng_dev_virtio_ops,
> > -                     VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_R=
NG,
> > +                     kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_R=
NG,
> >                       VIRTIO_ID_RNG, PCI_CLASS_RNG);
> >       if (r < 0)
> >               goto cleanup;
> > diff --git a/virtio/scsi.c b/virtio/scsi.c
> > index 0286b86..893dfe6 100644
> > --- a/virtio/scsi.c
> > +++ b/virtio/scsi.c
> > @@ -264,7 +264,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, st=
ruct disk_image *disk)
> >       list_add_tail(&sdev->list, &sdevs);
> >
> >       r =3D virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
> > -                     VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_S=
CSI,
> > +                     kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_S=
CSI,
> >                       VIRTIO_ID_SCSI, PCI_CLASS_BLK);
> >       if (r < 0)
> >               return r;
> > diff --git a/virtio/vsock.c b/virtio/vsock.c
> > index 18b45f3..a108e63 100644
> > --- a/virtio/vsock.c
> > +++ b/virtio/vsock.c
> > @@ -285,7 +285,7 @@ static int virtio_vsock_init_one(struct kvm *kvm, u=
64 guest_cid)
> >       list_add_tail(&vdev->list, &vdevs);
> >
> >       r =3D virtio_init(kvm, vdev, &vdev->vdev, &vsock_dev_virtio_ops,
> > -                 VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_VSOCK=
,
> > +                 kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_VSOCK=
,
> >                   VIRTIO_ID_VSOCK, PCI_CLASS_VSOCK);
> >       if (r < 0)
> >           return r;
> > --
> > 2.25.1
> >
