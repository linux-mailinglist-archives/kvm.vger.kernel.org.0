Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86072355D
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjFFCiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjFFCh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:37:58 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F88A116;
        Mon,  5 Jun 2023 19:37:56 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Axe_IDnH5kzlcAAA--.1365S3;
        Tue, 06 Jun 2023 10:37:55 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxReQAnH5kg6UBAA--.7521S3;
        Tue, 06 Jun 2023 10:37:52 +0800 (CST)
Message-ID: <1102ca21-fdc7-cb06-d241-79b2e3627144@loongson.cn>
Date:   Tue, 6 Jun 2023 10:37:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 29/31] LoongArch: KVM: Enable kvm config and add the
 makefile
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-30-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-30-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxReQAnH5kg6UBAA--.7521S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZFWfJryrurWrtF1DGw4xZrc_yoWrWF4kpr
        yxCr95Gr4xWFn3J393t34kWrs0kF97KFW3W3W3Za48Cr9rZ34kur18tr9rZFyDA395JrW0
        gF1rGa1aga1UJwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64
        vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4U
        JVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
        j09a9UUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:52, Tianrui Zhao 写道:
> Enable LoongArch kvm config and add the makefile to support build kvm
> module.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/Kbuild                      |  1 +
>  arch/loongarch/Kconfig                     |  2 ++
>  arch/loongarch/configs/loongson3_defconfig |  2 ++
>  arch/loongarch/kvm/Kconfig                 | 38 ++++++++++++++++++++++
>  arch/loongarch/kvm/Makefile                | 22 +++++++++++++
>  5 files changed, 65 insertions(+)
>  create mode 100644 arch/loongarch/kvm/Kconfig
>  create mode 100644 arch/loongarch/kvm/Makefile
> 
> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> index b01f5cdb27e0..40be8a1696f9 100644
> --- a/arch/loongarch/Kbuild
> +++ b/arch/loongarch/Kbuild
> @@ -2,6 +2,7 @@ obj-y += kernel/
>  obj-y += mm/
>  obj-y += net/
>  obj-y += vdso/
> +obj-y += kvm/
>  
>  # for cleaning
>  subdir- += boot
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index d38b066fc931..16ddf4f6f9bd 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -113,6 +113,7 @@ config LOONGARCH
>  	select HAVE_KPROBES
>  	select HAVE_KPROBES_ON_FTRACE
>  	select HAVE_KRETPROBES
> +	select HAVE_KVM
>  	select HAVE_MOD_ARCH_SPECIFIC
>  	select HAVE_NMI
>  	select HAVE_PCI
> @@ -604,3 +605,4 @@ source "drivers/acpi/Kconfig"
>  endmenu
>  
>  source "drivers/firmware/Kconfig"
> +source "arch/loongarch/kvm/Kconfig"
> diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
> index 6cd26dd3c134..3c0cbe6ad08f 100644
> --- a/arch/loongarch/configs/loongson3_defconfig
> +++ b/arch/loongarch/configs/loongson3_defconfig
> @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
>  CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
>  CONFIG_EFI_CAPSULE_LOADER=m
>  CONFIG_EFI_TEST=m
> +CONFIG_VIRTUALIZATION=y
> +CONFIG_KVM=m
>  CONFIG_MODULES=y
>  CONFIG_MODULE_FORCE_LOAD=y
>  CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> new file mode 100644
> index 000000000000..8a999b4c0232
> --- /dev/null
> +++ b/arch/loongarch/kvm/Kconfig
> @@ -0,0 +1,38 @@
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
> +config KVM
> +	tristate "Kernel-based Virtual Machine (KVM) support"
> +	depends on HAVE_KVM
> +	select MMU_NOTIFIER
> +	select ANON_INODES
> +	select PREEMPT_NOTIFIERS
> +	select KVM_MMIO
> +	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +	select HAVE_KVM_VCPU_ASYNC_IOCTL
> +	select HAVE_KVM_EVENTFD
> +	select SRCU
> +	help
> +	  Support hosting virtualized guest machines using hardware
> +	  virtualization extensions. You will need a fairly processor
> +	  equipped with virtualization extensions.
> +
> +	  If unsure, say N.
> +
> +endif # VIRTUALIZATION
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> new file mode 100644
> index 000000000000..2335e873a6ef
> --- /dev/null
> +++ b/arch/loongarch/kvm/Makefile
> @@ -0,0 +1,22 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for LOONGARCH KVM support
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

