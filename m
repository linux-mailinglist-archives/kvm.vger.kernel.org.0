Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081B179CC44
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 11:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjILJsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 05:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjILJsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 05:48:00 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4827912E;
        Tue, 12 Sep 2023 02:47:56 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8Dx_7vKMwBltHklAA--.13967S3;
        Tue, 12 Sep 2023 17:47:54 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxnd7HMwBlLJkAAA--.2825S3;
        Tue, 12 Sep 2023 17:47:53 +0800 (CST)
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the
 makefile
To:     WANG Xuerui <kernel@xen0n.name>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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
 <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <f4fd2d6c-400b-1f26-7872-d9a286c03a8f@loongson.cn>
Date:   Tue, 12 Sep 2023 17:47:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Dxnd7HMwBlLJkAAA--.2825S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxuw1kuFWDWr1fAFykCF4rZwc_yoW7tFWUpF
        s7AFWDGrW8GFn3JrWDt34kWFWjyr97Ka17WF1fXFyUCrZrZryjgr1jqryq9FyUJw4rJry0
        qr1rWFnFvF4UJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
        6F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
        WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8XTm3UUUU
        U==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/8 上午4:10, WANG Xuerui 写道:
>
> On 8/31/23 16:30, Tianrui Zhao wrote:
>> Enable LoongArch kvm config and add the makefile to support build kvm
>> module.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Link: 
>> https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/Kbuild                      |  1 +
>>   arch/loongarch/Kconfig                     |  3 ++
>>   arch/loongarch/configs/loongson3_defconfig |  2 +
>>   arch/loongarch/kvm/Kconfig                 | 45 ++++++++++++++++++++++
>>   arch/loongarch/kvm/Makefile                | 22 +++++++++++
>>   5 files changed, 73 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/Kconfig
>>   create mode 100644 arch/loongarch/kvm/Makefile
>>
>> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
>> index b01f5cdb27..40be8a1696 100644
>> --- a/arch/loongarch/Kbuild
>> +++ b/arch/loongarch/Kbuild
>> @@ -2,6 +2,7 @@ obj-y += kernel/
>>   obj-y += mm/
>>   obj-y += net/
>>   obj-y += vdso/
>> +obj-y += kvm/
> Do we want to keep the list alphabetically sorted here?
It could be resorted by alphabetical.
>>     # for cleaning
>>   subdir- += boot
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index ecf282dee5..7f2f7ccc76 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -123,6 +123,7 @@ config LOONGARCH
>>       select HAVE_KPROBES
>>       select HAVE_KPROBES_ON_FTRACE
>>       select HAVE_KRETPROBES
>> +    select HAVE_KVM
>>       select HAVE_MOD_ARCH_SPECIFIC
>>       select HAVE_NMI
>>       select HAVE_PCI
>> @@ -650,3 +651,5 @@ source "kernel/power/Kconfig"
>>   source "drivers/acpi/Kconfig"
>>     endmenu
>> +
>> +source "arch/loongarch/kvm/Kconfig"
>> diff --git a/arch/loongarch/configs/loongson3_defconfig 
>> b/arch/loongarch/configs/loongson3_defconfig
>> index d64849b4cb..7acb4ae7af 100644
>> --- a/arch/loongarch/configs/loongson3_defconfig
>> +++ b/arch/loongarch/configs/loongson3_defconfig
>> @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
>>   CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
>>   CONFIG_EFI_CAPSULE_LOADER=m
>>   CONFIG_EFI_TEST=m
>> +CONFIG_VIRTUALIZATION=y
>> +CONFIG_KVM=m
>>   CONFIG_MODULES=y
>>   CONFIG_MODULE_FORCE_LOAD=y
>>   CONFIG_MODULE_UNLOAD=y
>> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
>> new file mode 100644
>> index 0000000000..bf7d6e7cde
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/Kconfig
>> @@ -0,0 +1,45 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# KVM configuration
>> +#
>> +
>> +source "virt/kvm/Kconfig"
>> +
>> +menuconfig VIRTUALIZATION
>> +    bool "Virtualization"
>> +    help
>> +      Say Y here to get to see options for using your Linux host to run
>> +      other operating systems inside virtual machines (guests).
>> +      This option alone does not add any kernel code.
>> +
>> +      If you say N, all options in this submenu will be skipped and
>> +      disabled.
>> +
>> +if VIRTUALIZATION
>> +
>> +config AS_HAS_LVZ_EXTENSION
>> +    def_bool $(as-instr,hvcl 0)
>> +
>> +config KVM
>> +    tristate "Kernel-based Virtual Machine (KVM) support"
>> +    depends on HAVE_KVM
>> +    depends on AS_HAS_LVZ_EXTENSION
>> +    select MMU_NOTIFIER
>> +    select ANON_INODES
>> +    select PREEMPT_NOTIFIERS
>> +    select KVM_MMIO
>> +    select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>> +    select KVM_GENERIC_HARDWARE_ENABLING
>> +    select KVM_XFER_TO_GUEST_WORK
>> +    select HAVE_KVM_DIRTY_RING_ACQ_REL
>> +    select HAVE_KVM_VCPU_ASYNC_IOCTL
>> +    select HAVE_KVM_EVENTFD
>> +    select SRCU
> Make the list of selects also alphabetically sorted?
It also could be resorted by alphabetical.
>> +    help
>> +      Support hosting virtualized guest machines using hardware
>> +      virtualization extensions. You will need a fairly processor
>> +      equipped with virtualization extensions.
>
> The word "fairly" seems extraneous here, and can be simply dropped.
Thanks, I will remove this "fairly" word.
>
> (I suppose you forgot to delete it after tweaking the original 
> sentence, that came from arch/x86/kvm: "You will need a fairly recent 
> processor ..." -- all LoongArch processors are recent!)
>
>> +
>> +      If unsure, say N.
>> +
>> +endif # VIRTUALIZATION
>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>> new file mode 100644
>> index 0000000000..2335e873a6
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/Makefile
>> @@ -0,0 +1,22 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for LOONGARCH KVM support
> "LoongArch" -- you may want to check the entire patch series for such 
> ALL-CAPS references to LoongArch in natural language paragraphs, they 
> all want to be spelled "LoongArch".
Thanks, I will fix it.
>> +#
>> +
>> +ccflags-y += -I $(srctree)/$(src)
>> +
>> +include $(srctree)/virt/kvm/Makefile.kvm
>> +
>> +obj-$(CONFIG_KVM) += kvm.o
>> +
>> +kvm-y += main.o
>> +kvm-y += vm.o
>> +kvm-y += vmid.o
>> +kvm-y += tlb.o
>> +kvm-y += mmu.o
>> +kvm-y += vcpu.o
>> +kvm-y += exit.o
>> +kvm-y += interrupt.o
>> +kvm-y += timer.o
>> +kvm-y += switch.o
>> +kvm-y += csr_ops.o
> I'd suggest sorting this list too to better avoid editing conflicts in 
> the future.
I will also resort them by alphabetical.

Thanks
Tianrui Zhao

