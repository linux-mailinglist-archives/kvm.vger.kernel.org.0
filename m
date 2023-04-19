Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8F96E75EC
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDSJCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 05:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbjDSJCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 05:02:09 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5587F268A;
        Wed, 19 Apr 2023 02:02:00 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8BxttgHrj9kPt0eAA--.53054S3;
        Wed, 19 Apr 2023 17:01:59 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxdbwDrj9k29YuAA--.54148S3;
        Wed, 19 Apr 2023 17:01:55 +0800 (CST)
Subject: Re: [PATCH v7 29/30] LoongArch: KVM: Enable kvm config and add the
 makefile
To:     Huacai Chen <chenhuacai@kernel.org>
References: <20230417095950.875228-1-zhaotianrui@loongson.cn>
 <20230417095950.875228-30-zhaotianrui@loongson.cn>
 <CAAhV-H5nxRLzLn65OEnPQJi6CQtFhQOYNZjEE9ZoouM8Ug5hOw@mail.gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <d27a853f-5972-56c2-fdb7-aad7e6be9a8c@loongson.cn>
Date:   Wed, 19 Apr 2023 17:01:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5nxRLzLn65OEnPQJi6CQtFhQOYNZjEE9ZoouM8Ug5hOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxdbwDrj9k29YuAA--.54148S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxWFW7uFyrAr47uFWxXFyUGFg_yoWrCw4kpF
        WxZr1kGr4xWFn3JrZ3t34kWrsIyrn7Kr17uF1aqa4UCF9rZrykur18tryDWFyDJws5JrW0
        gF1rGF1aga15Ja7anT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8XTm3UUUUU==
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月19日 10:10, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Mon, Apr 17, 2023 at 6:00 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Enable loongarch kvm config and add the makefile to support build kvm
>> module.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/Kbuild                      |  1 +
>>   arch/loongarch/Kconfig                     |  2 ++
>>   arch/loongarch/configs/loongson3_defconfig |  2 ++
>>   arch/loongarch/kvm/Kconfig                 | 38 ++++++++++++++++++++++
>>   arch/loongarch/kvm/Makefile                | 22 +++++++++++++
>>   5 files changed, 65 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/Kconfig
>>   create mode 100644 arch/loongarch/kvm/Makefile
>>
>> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
>> index b01f5cdb27e0..40be8a1696f9 100644
>> --- a/arch/loongarch/Kbuild
>> +++ b/arch/loongarch/Kbuild
>> @@ -2,6 +2,7 @@ obj-y += kernel/
>>   obj-y += mm/
>>   obj-y += net/
>>   obj-y += vdso/
>> +obj-y += kvm/
>>
>>   # for cleaning
>>   subdir- += boot
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index 7fd51257e0ed..f9beeb2e0cc9 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -148,6 +148,7 @@ config LOONGARCH
>>          select USE_PERCPU_NUMA_NODE_ID
>>          select USER_STACKTRACE_SUPPORT
>>          select ZONE_DMA32
>> +       select HAVE_KVM
> Use alpha-betical order, please.
>
> Huacai
Thanks, I will move it to the suitable place.

Thanks
Tianrui Zhao
>>   config 32BIT
>>          bool
>> @@ -588,3 +589,4 @@ source "drivers/acpi/Kconfig"
>>   endmenu
>>
>>   source "drivers/firmware/Kconfig"
>> +source "arch/loongarch/kvm/Kconfig"
>> diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
>> index e18213f01cc4..c99520374aef 100644
>> --- a/arch/loongarch/configs/loongson3_defconfig
>> +++ b/arch/loongarch/configs/loongson3_defconfig
>> @@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
>>   CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
>>   CONFIG_EFI_CAPSULE_LOADER=m
>>   CONFIG_EFI_TEST=m
>> +CONFIG_VIRTUALIZATION=y
>> +CONFIG_KVM=m
>>   CONFIG_MODULES=y
>>   CONFIG_MODULE_FORCE_LOAD=y
>>   CONFIG_MODULE_UNLOAD=y
>> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
>> new file mode 100644
>> index 000000000000..8a999b4c0232
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/Kconfig
>> @@ -0,0 +1,38 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# KVM configuration
>> +#
>> +
>> +source "virt/kvm/Kconfig"
>> +
>> +menuconfig VIRTUALIZATION
>> +       bool "Virtualization"
>> +       help
>> +         Say Y here to get to see options for using your Linux host to run
>> +         other operating systems inside virtual machines (guests).
>> +         This option alone does not add any kernel code.
>> +
>> +         If you say N, all options in this submenu will be skipped and
>> +         disabled.
>> +
>> +if VIRTUALIZATION
>> +
>> +config KVM
>> +       tristate "Kernel-based Virtual Machine (KVM) support"
>> +       depends on HAVE_KVM
>> +       select MMU_NOTIFIER
>> +       select ANON_INODES
>> +       select PREEMPT_NOTIFIERS
>> +       select KVM_MMIO
>> +       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>> +       select HAVE_KVM_VCPU_ASYNC_IOCTL
>> +       select HAVE_KVM_EVENTFD
>> +       select SRCU
>> +       help
>> +         Support hosting virtualized guest machines using hardware
>> +         virtualization extensions. You will need a fairly processor
>> +         equipped with virtualization extensions.
>> +
>> +         If unsure, say N.
>> +
>> +endif # VIRTUALIZATION
>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>> new file mode 100644
>> index 000000000000..2335e873a6ef
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/Makefile
>> @@ -0,0 +1,22 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for LOONGARCH KVM support
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
>> --
>> 2.31.1
>>

