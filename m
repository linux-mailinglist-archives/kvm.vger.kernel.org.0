Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7479804F
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 03:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjIHBkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 21:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjIHBkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 21:40:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3CF1BD9;
        Thu,  7 Sep 2023 18:40:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A80C433C8;
        Fri,  8 Sep 2023 01:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694137229;
        bh=xxUJ4Zbe95SAzpB+WBTM98lJIPJcPTRSy6vNlAfrF3g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZJA+ENEOYiwenCrF8/5wdFQ2/maSyUWZxam3E0xSwi0MZWXQALrj0PKL9+/tJ+dm8
         jlu3OWaOtU0ttfoTEYeR8kUpbV7LZQCafBE+grN1UovqChc4AY8trrc0qQ20ylAKM8
         qDuj8o4V5EOiizMtg7uU05/hbdKSe099yT/pImdQL+BybGIFT9rL8mLMatBGkDu6YH
         yMs0o+jTJLs4SOz4epUKvGOBAaTifLnSGcdZLkoUSwJ5pa0zl33s5S5NhjdtUV2Ifb
         Y4cpPTFTonqSCfJlF/tM4Awjv9pRZ4yar+YYwvFXBX9GxnuubT885k4XioXqZ3WPda
         NULivPNdERnVA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-501cef42bc9so2590852e87.0;
        Thu, 07 Sep 2023 18:40:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YzBp0s5WUhtvwFXsFFoajfY9MemnV4Eo3DG+b0sA/Qh8enBxcH5
        1nV3jDjlE+36JggGf1OAlvMtIFU0fLCp+YF8dYo=
X-Google-Smtp-Source: AGHT+IE0y1K+boYk2dLLdJ4ZbSDeD28Jji7PpL3yDaKlNddJw3VAlmFfQJnyncZGxyekqD3nfmhlar9p/B082vXV2ZE=
X-Received: by 2002:a05:6512:3988:b0:500:8ecb:509 with SMTP id
 j8-20020a056512398800b005008ecb0509mr954931lfu.15.1694137227691; Thu, 07 Sep
 2023 18:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-29-zhaotianrui@loongson.cn> <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
In-Reply-To: <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 8 Sep 2023 09:40:16 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5WHOysfEutSg1oopx5s8SDnYd8zn8C+TY6mqVbFr22sQ@mail.gmail.com>
Message-ID: <CAAhV-H5WHOysfEutSg1oopx5s8SDnYd8zn8C+TY6mqVbFr22sQ@mail.gmail.com>
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the makefile
To:     WANG Xuerui <kernel@xen0n.name>
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 8, 2023 at 4:10=E2=80=AFAM WANG Xuerui <kernel@xen0n.name> wrot=
e:
>
>
> On 8/31/23 16:30, Tianrui Zhao wrote:
> > Enable LoongArch kvm config and add the makefile to support build kvm
> > module.
> >
> > Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@i=
ntel.com/
> > Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> > ---
> >   arch/loongarch/Kbuild                      |  1 +
> >   arch/loongarch/Kconfig                     |  3 ++
> >   arch/loongarch/configs/loongson3_defconfig |  2 +
> >   arch/loongarch/kvm/Kconfig                 | 45 +++++++++++++++++++++=
+
> >   arch/loongarch/kvm/Makefile                | 22 +++++++++++
> >   5 files changed, 73 insertions(+)
> >   create mode 100644 arch/loongarch/kvm/Kconfig
> >   create mode 100644 arch/loongarch/kvm/Makefile
> >
> > diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> > index b01f5cdb27..40be8a1696 100644
> > --- a/arch/loongarch/Kbuild
> > +++ b/arch/loongarch/Kbuild
> > @@ -2,6 +2,7 @@ obj-y +=3D kernel/
> >   obj-y +=3D mm/
> >   obj-y +=3D net/
> >   obj-y +=3D vdso/
> > +obj-y +=3D kvm/
> Do we want to keep the list alphabetically sorted here?
kvm directory can be at last, but I'm afraid that it should be

ifdef CONFIG_KVM
obj-y +=3D kvm/
endif

If such a guard is unnecessary, then I agree to use alphabetical order.

Huacai

> >
> >   # for cleaning
> >   subdir- +=3D boot
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index ecf282dee5..7f2f7ccc76 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -123,6 +123,7 @@ config LOONGARCH
> >       select HAVE_KPROBES
> >       select HAVE_KPROBES_ON_FTRACE
> >       select HAVE_KRETPROBES
> > +     select HAVE_KVM
> >       select HAVE_MOD_ARCH_SPECIFIC
> >       select HAVE_NMI
> >       select HAVE_PCI
> > @@ -650,3 +651,5 @@ source "kernel/power/Kconfig"
> >   source "drivers/acpi/Kconfig"
> >
> >   endmenu
> > +
> > +source "arch/loongarch/kvm/Kconfig"
> > diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarc=
h/configs/loongson3_defconfig
> > index d64849b4cb..7acb4ae7af 100644
> > --- a/arch/loongarch/configs/loongson3_defconfig
> > +++ b/arch/loongarch/configs/loongson3_defconfig
> > @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=3Dy
> >   CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=3Dy
> >   CONFIG_EFI_CAPSULE_LOADER=3Dm
> >   CONFIG_EFI_TEST=3Dm
> > +CONFIG_VIRTUALIZATION=3Dy
> > +CONFIG_KVM=3Dm
> >   CONFIG_MODULES=3Dy
> >   CONFIG_MODULE_FORCE_LOAD=3Dy
> >   CONFIG_MODULE_UNLOAD=3Dy
> > diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> > new file mode 100644
> > index 0000000000..bf7d6e7cde
> > --- /dev/null
> > +++ b/arch/loongarch/kvm/Kconfig
> > @@ -0,0 +1,45 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# KVM configuration
> > +#
> > +
> > +source "virt/kvm/Kconfig"
> > +
> > +menuconfig VIRTUALIZATION
> > +     bool "Virtualization"
> > +     help
> > +       Say Y here to get to see options for using your Linux host to r=
un
> > +       other operating systems inside virtual machines (guests).
> > +       This option alone does not add any kernel code.
> > +
> > +       If you say N, all options in this submenu will be skipped and
> > +       disabled.
> > +
> > +if VIRTUALIZATION
> > +
> > +config AS_HAS_LVZ_EXTENSION
> > +     def_bool $(as-instr,hvcl 0)
> > +
> > +config KVM
> > +     tristate "Kernel-based Virtual Machine (KVM) support"
> > +     depends on HAVE_KVM
> > +     depends on AS_HAS_LVZ_EXTENSION
> > +     select MMU_NOTIFIER
> > +     select ANON_INODES
> > +     select PREEMPT_NOTIFIERS
> > +     select KVM_MMIO
> > +     select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > +     select KVM_GENERIC_HARDWARE_ENABLING
> > +     select KVM_XFER_TO_GUEST_WORK
> > +     select HAVE_KVM_DIRTY_RING_ACQ_REL
> > +     select HAVE_KVM_VCPU_ASYNC_IOCTL
> > +     select HAVE_KVM_EVENTFD
> > +     select SRCU
> Make the list of selects also alphabetically sorted?
> > +     help
> > +       Support hosting virtualized guest machines using hardware
> > +       virtualization extensions. You will need a fairly processor
> > +       equipped with virtualization extensions.
>
> The word "fairly" seems extraneous here, and can be simply dropped.
>
> (I suppose you forgot to delete it after tweaking the original sentence,
> that came from arch/x86/kvm: "You will need a fairly recent processor
> ..." -- all LoongArch processors are recent!)
>
> > +
> > +       If unsure, say N.
> > +
> > +endif # VIRTUALIZATION
> > diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> > new file mode 100644
> > index 0000000000..2335e873a6
> > --- /dev/null
> > +++ b/arch/loongarch/kvm/Makefile
> > @@ -0,0 +1,22 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Makefile for LOONGARCH KVM support
> "LoongArch" -- you may want to check the entire patch series for such
> ALL-CAPS references to LoongArch in natural language paragraphs, they
> all want to be spelled "LoongArch".
> > +#
> > +
> > +ccflags-y +=3D -I $(srctree)/$(src)
> > +
> > +include $(srctree)/virt/kvm/Makefile.kvm
> > +
> > +obj-$(CONFIG_KVM) +=3D kvm.o
> > +
> > +kvm-y +=3D main.o
> > +kvm-y +=3D vm.o
> > +kvm-y +=3D vmid.o
> > +kvm-y +=3D tlb.o
> > +kvm-y +=3D mmu.o
> > +kvm-y +=3D vcpu.o
> > +kvm-y +=3D exit.o
> > +kvm-y +=3D interrupt.o
> > +kvm-y +=3D timer.o
> > +kvm-y +=3D switch.o
> > +kvm-y +=3D csr_ops.o
> I'd suggest sorting this list too to better avoid editing conflicts in
> the future.
>
> --
> WANG "xen0n" Xuerui
>
> Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/
>
>
