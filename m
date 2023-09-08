Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC3679805B
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 03:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjIHBuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjIHBt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 21:49:59 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEDC319BD;
        Thu,  7 Sep 2023 18:49:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Dx_+vAffpkrNkhAA--.744S3;
        Fri, 08 Sep 2023 09:49:52 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDCO8ffpksrJxAA--.56714S3;
        Fri, 08 Sep 2023 09:49:48 +0800 (CST)
Message-ID: <61b34ee0-8205-43e0-becf-a4f6c8ff876a@loongson.cn>
Date:   Fri, 8 Sep 2023 09:49:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the
 makefile
Content-Language: en-US
To:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-29-zhaotianrui@loongson.cn>
 <925522e9-9be6-2545-4c4e-1608eaab523a@xen0n.name>
 <CAAhV-H5WHOysfEutSg1oopx5s8SDnYd8zn8C+TY6mqVbFr22sQ@mail.gmail.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <CAAhV-H5WHOysfEutSg1oopx5s8SDnYd8zn8C+TY6mqVbFr22sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxDCO8ffpksrJxAA--.56714S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AF1xArWrKFWUWryUur4ftFc_yoWxXFyUpr
        Z7CF1DGr48Wr4xA393ta4kWrs0qr97Kry7WF1agFyUCr9Fvr97ur18tryDuFyUJ3yrJrWI
        9r95G3Wa9F45J3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2pVbDU
        UUU
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/9/8 09:40, Huacai Chen 写道:
> On Fri, Sep 8, 2023 at 4:10 AM WANG Xuerui <kernel@xen0n.name> wrote:
>>
>>
>> On 8/31/23 16:30, Tianrui Zhao wrote:
>>> Enable LoongArch kvm config and add the makefile to support build kvm
>>> module.
>>>
>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
>>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>>> ---
>>>   arch/loongarch/Kbuild                      |  1 +
>>>   arch/loongarch/Kconfig                     |  3 ++
>>>   arch/loongarch/configs/loongson3_defconfig |  2 +
>>>   arch/loongarch/kvm/Kconfig                 | 45 ++++++++++++++++++++++
>>>   arch/loongarch/kvm/Makefile                | 22 +++++++++++
>>>   5 files changed, 73 insertions(+)
>>>   create mode 100644 arch/loongarch/kvm/Kconfig
>>>   create mode 100644 arch/loongarch/kvm/Makefile
>>>
>>> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
>>> index b01f5cdb27..40be8a1696 100644
>>> --- a/arch/loongarch/Kbuild
>>> +++ b/arch/loongarch/Kbuild
>>> @@ -2,6 +2,7 @@ obj-y += kernel/
>>>   obj-y += mm/
>>>   obj-y += net/
>>>   obj-y += vdso/
>>> +obj-y += kvm/
>> Do we want to keep the list alphabetically sorted here?
> kvm directory can be at last, but I'm afraid that it should be
> 
> ifdef CONFIG_KVM
> obj-y += kvm/
> endif
Agree, how about this like other architectures.
obj-$(CONFIG_KVM) += kvm/
> 
> If such a guard is unnecessary, then I agree to use alphabetical order.
Is there any document about "alphabetical order"? I check Kbuild in other
directories, it is not sorted by alphabetical order.

$ cat  arch/riscv/Kbuild 
obj-y += kernel/ mm/ net/
obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
obj-y += errata/
obj-$(CONFIG_KVM) += kvm/
obj-$(CONFIG_ARCH_HAS_KEXEC_PURGATORY) += purgatory/
# for cleaning
subdir- += boot

$ cat arch/arm64/Kbuild 
obj-y                   += kernel/ mm/ net/
obj-$(CONFIG_KVM)       += kvm/
obj-$(CONFIG_XEN)       += xen/
obj-$(subst m,y,$(CONFIG_HYPERV))       += hyperv/
obj-$(CONFIG_CRYPTO)    += crypto/

# for cleaning
subdir- += boot


Regards
Bibo Mao
> 
> Huacai
> 
>>>
>>>   # for cleaning
>>>   subdir- += boot
>>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>>> index ecf282dee5..7f2f7ccc76 100644
>>> --- a/arch/loongarch/Kconfig
>>> +++ b/arch/loongarch/Kconfig
>>> @@ -123,6 +123,7 @@ config LOONGARCH
>>>       select HAVE_KPROBES
>>>       select HAVE_KPROBES_ON_FTRACE
>>>       select HAVE_KRETPROBES
>>> +     select HAVE_KVM
>>>       select HAVE_MOD_ARCH_SPECIFIC
>>>       select HAVE_NMI
>>>       select HAVE_PCI
>>> @@ -650,3 +651,5 @@ source "kernel/power/Kconfig"
>>>   source "drivers/acpi/Kconfig"
>>>
>>>   endmenu
>>> +
>>> +source "arch/loongarch/kvm/Kconfig"
>>> diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
>>> index d64849b4cb..7acb4ae7af 100644
>>> --- a/arch/loongarch/configs/loongson3_defconfig
>>> +++ b/arch/loongarch/configs/loongson3_defconfig
>>> @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
>>>   CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
>>>   CONFIG_EFI_CAPSULE_LOADER=m
>>>   CONFIG_EFI_TEST=m
>>> +CONFIG_VIRTUALIZATION=y
>>> +CONFIG_KVM=m
>>>   CONFIG_MODULES=y
>>>   CONFIG_MODULE_FORCE_LOAD=y
>>>   CONFIG_MODULE_UNLOAD=y
>>> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
>>> new file mode 100644
>>> index 0000000000..bf7d6e7cde
>>> --- /dev/null
>>> +++ b/arch/loongarch/kvm/Kconfig
>>> @@ -0,0 +1,45 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +#
>>> +# KVM configuration
>>> +#
>>> +
>>> +source "virt/kvm/Kconfig"
>>> +
>>> +menuconfig VIRTUALIZATION
>>> +     bool "Virtualization"
>>> +     help
>>> +       Say Y here to get to see options for using your Linux host to run
>>> +       other operating systems inside virtual machines (guests).
>>> +       This option alone does not add any kernel code.
>>> +
>>> +       If you say N, all options in this submenu will be skipped and
>>> +       disabled.
>>> +
>>> +if VIRTUALIZATION
>>> +
>>> +config AS_HAS_LVZ_EXTENSION
>>> +     def_bool $(as-instr,hvcl 0)
>>> +
>>> +config KVM
>>> +     tristate "Kernel-based Virtual Machine (KVM) support"
>>> +     depends on HAVE_KVM
>>> +     depends on AS_HAS_LVZ_EXTENSION
>>> +     select MMU_NOTIFIER
>>> +     select ANON_INODES
>>> +     select PREEMPT_NOTIFIERS
>>> +     select KVM_MMIO
>>> +     select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>> +     select KVM_GENERIC_HARDWARE_ENABLING
>>> +     select KVM_XFER_TO_GUEST_WORK
>>> +     select HAVE_KVM_DIRTY_RING_ACQ_REL
>>> +     select HAVE_KVM_VCPU_ASYNC_IOCTL
>>> +     select HAVE_KVM_EVENTFD
>>> +     select SRCU
>> Make the list of selects also alphabetically sorted?
>>> +     help
>>> +       Support hosting virtualized guest machines using hardware
>>> +       virtualization extensions. You will need a fairly processor
>>> +       equipped with virtualization extensions.
>>
>> The word "fairly" seems extraneous here, and can be simply dropped.
>>
>> (I suppose you forgot to delete it after tweaking the original sentence,
>> that came from arch/x86/kvm: "You will need a fairly recent processor
>> ..." -- all LoongArch processors are recent!)
>>
>>> +
>>> +       If unsure, say N.
>>> +
>>> +endif # VIRTUALIZATION
>>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>>> new file mode 100644
>>> index 0000000000..2335e873a6
>>> --- /dev/null
>>> +++ b/arch/loongarch/kvm/Makefile
>>> @@ -0,0 +1,22 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +#
>>> +# Makefile for LOONGARCH KVM support
>> "LoongArch" -- you may want to check the entire patch series for such
>> ALL-CAPS references to LoongArch in natural language paragraphs, they
>> all want to be spelled "LoongArch".
>>> +#
>>> +
>>> +ccflags-y += -I $(srctree)/$(src)
>>> +
>>> +include $(srctree)/virt/kvm/Makefile.kvm
>>> +
>>> +obj-$(CONFIG_KVM) += kvm.o
>>> +
>>> +kvm-y += main.o
>>> +kvm-y += vm.o
>>> +kvm-y += vmid.o
>>> +kvm-y += tlb.o
>>> +kvm-y += mmu.o
>>> +kvm-y += vcpu.o
>>> +kvm-y += exit.o
>>> +kvm-y += interrupt.o
>>> +kvm-y += timer.o
>>> +kvm-y += switch.o
>>> +kvm-y += csr_ops.o
>> I'd suggest sorting this list too to better avoid editing conflicts in
>> the future.
>>
>> --
>> WANG "xen0n" Xuerui
>>
>> Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/
>>
>>

