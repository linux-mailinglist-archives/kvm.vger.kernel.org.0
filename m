Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B636797D29
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 22:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbjIGUKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 16:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjIGUKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 16:10:44 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E92FE47;
        Thu,  7 Sep 2023 13:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1694117437; bh=y3aQ4fqeZArk/RTTUb2yngK8cSBmJKP7RwqbJ7/mNwg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LeQJTeD6V4CfDsPR14MtBIVpof7ociEm34u6REeTGdrHPqftgnf125302/GmAjpaA
         MDK69Dk5Ujmh4Zl5VmqBF43XwXiveeUeSuMI39WW8+OvWBNgjCLBvt6UfstpGNMOAH
         8wT/JnYhOdPeJp/HZKlHTZX0gid/qkeNCUg5NU+M=
Received: from [192.168.9.172] (unknown [101.88.25.36])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 3781A6011C;
        Fri,  8 Sep 2023 04:10:37 +0800 (CST)
Message-ID: <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
Date:   Fri, 8 Sep 2023 04:10:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the
 makefile
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-29-zhaotianrui@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230831083020.2187109-29-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/31/23 16:30, Tianrui Zhao wrote:
> Enable LoongArch kvm config and add the makefile to support build kvm
> module.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/Kbuild                      |  1 +
>   arch/loongarch/Kconfig                     |  3 ++
>   arch/loongarch/configs/loongson3_defconfig |  2 +
>   arch/loongarch/kvm/Kconfig                 | 45 ++++++++++++++++++++++
>   arch/loongarch/kvm/Makefile                | 22 +++++++++++
>   5 files changed, 73 insertions(+)
>   create mode 100644 arch/loongarch/kvm/Kconfig
>   create mode 100644 arch/loongarch/kvm/Makefile
>
> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> index b01f5cdb27..40be8a1696 100644
> --- a/arch/loongarch/Kbuild
> +++ b/arch/loongarch/Kbuild
> @@ -2,6 +2,7 @@ obj-y += kernel/
>   obj-y += mm/
>   obj-y += net/
>   obj-y += vdso/
> +obj-y += kvm/
Do we want to keep the list alphabetically sorted here?
>   
>   # for cleaning
>   subdir- += boot
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index ecf282dee5..7f2f7ccc76 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -123,6 +123,7 @@ config LOONGARCH
>   	select HAVE_KPROBES
>   	select HAVE_KPROBES_ON_FTRACE
>   	select HAVE_KRETPROBES
> +	select HAVE_KVM
>   	select HAVE_MOD_ARCH_SPECIFIC
>   	select HAVE_NMI
>   	select HAVE_PCI
> @@ -650,3 +651,5 @@ source "kernel/power/Kconfig"
>   source "drivers/acpi/Kconfig"
>   
>   endmenu
> +
> +source "arch/loongarch/kvm/Kconfig"
> diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
> index d64849b4cb..7acb4ae7af 100644
> --- a/arch/loongarch/configs/loongson3_defconfig
> +++ b/arch/loongarch/configs/loongson3_defconfig
> @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
>   CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
>   CONFIG_EFI_CAPSULE_LOADER=m
>   CONFIG_EFI_TEST=m
> +CONFIG_VIRTUALIZATION=y
> +CONFIG_KVM=m
>   CONFIG_MODULES=y
>   CONFIG_MODULE_FORCE_LOAD=y
>   CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> new file mode 100644
> index 0000000000..bf7d6e7cde
> --- /dev/null
> +++ b/arch/loongarch/kvm/Kconfig
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# KVM configuration
> +#
> +
> +source "virt/kvm/Kconfig"
> +
> +menuconfig VIRTUALIZATION
> +	bool "Virtualization"
> +	help
> +	  Say Y here to get to see options for using your Linux host to run
> +	  other operating systems inside virtual machines (guests).
> +	  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and
> +	  disabled.
> +
> +if VIRTUALIZATION
> +
> +config AS_HAS_LVZ_EXTENSION
> +	def_bool $(as-instr,hvcl 0)
> +
> +config KVM
> +	tristate "Kernel-based Virtual Machine (KVM) support"
> +	depends on HAVE_KVM
> +	depends on AS_HAS_LVZ_EXTENSION
> +	select MMU_NOTIFIER
> +	select ANON_INODES
> +	select PREEMPT_NOTIFIERS
> +	select KVM_MMIO
> +	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +	select KVM_GENERIC_HARDWARE_ENABLING
> +	select KVM_XFER_TO_GUEST_WORK
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
> +	select HAVE_KVM_VCPU_ASYNC_IOCTL
> +	select HAVE_KVM_EVENTFD
> +	select SRCU
Make the list of selects also alphabetically sorted?
> +	help
> +	  Support hosting virtualized guest machines using hardware
> +	  virtualization extensions. You will need a fairly processor
> +	  equipped with virtualization extensions.

The word "fairly" seems extraneous here, and can be simply dropped.

(I suppose you forgot to delete it after tweaking the original sentence, 
that came from arch/x86/kvm: "You will need a fairly recent processor 
..." -- all LoongArch processors are recent!)

> +
> +	  If unsure, say N.
> +
> +endif # VIRTUALIZATION
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> new file mode 100644
> index 0000000000..2335e873a6
> --- /dev/null
> +++ b/arch/loongarch/kvm/Makefile
> @@ -0,0 +1,22 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for LOONGARCH KVM support
"LoongArch" -- you may want to check the entire patch series for such 
ALL-CAPS references to LoongArch in natural language paragraphs, they 
all want to be spelled "LoongArch".
> +#
> +
> +ccflags-y += -I $(srctree)/$(src)
> +
> +include $(srctree)/virt/kvm/Makefile.kvm
> +
> +obj-$(CONFIG_KVM) += kvm.o
> +
> +kvm-y += main.o
> +kvm-y += vm.o
> +kvm-y += vmid.o
> +kvm-y += tlb.o
> +kvm-y += mmu.o
> +kvm-y += vcpu.o
> +kvm-y += exit.o
> +kvm-y += interrupt.o
> +kvm-y += timer.o
> +kvm-y += switch.o
> +kvm-y += csr_ops.o
I'd suggest sorting this list too to better avoid editing conflicts in 
the future.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

