Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE31A7099
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 03:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403827AbgDNBkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 21:40:41 -0400
Received: from mail.loongson.cn ([114.242.206.163]:33882 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728252AbgDNBkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 21:40:41 -0400
Received: from [10.20.42.25] (unknown [10.20.42.25])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxr9qKFJVeT5knAA--.11S3;
        Tue, 14 Apr 2020 09:40:27 +0800 (CST)
Subject: Re: [PATCH 0/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
 <20200413161842.57ad8be4@flygoat-x1e>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        aleksandar.qemu.devel@gmail.com
From:   maobibo <maobibo@loongson.cn>
Message-ID: <bbbeb507-5692-5969-c320-57d04823edc7@loongson.cn>
Date:   Tue, 14 Apr 2020 09:40:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200413161842.57ad8be4@flygoat-x1e>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxr9qKFJVeT5knAA--.11S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF47AFy3tF1fXr13Jr43Jrb_yoW7Zr47pa
        17C3W3Kr4kGr97Cw1fJw18Wr1aqr95JFyUJwsrt340gF98XF1qvr4IyFWFya47Cr9Yg340
        qFyFqr1DWa17C3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9mb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
        0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY
        04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s
        026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
        JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
        v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xva
        j40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
        1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07beAp5UUUUU=
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04/13/2020 04:18 PM, Jiaxun Yang wrote:
> On Mon, 13 Apr 2020 15:30:09 +0800
> Huacai Chen <chenhc@lemote.com> wrote:
> 
>> We are preparing to add KVM support for Loongson-3. VZ extension is
>> fully supported in Loongson-3A R4+, and we will not care about old
>> CPUs (at least now). We already have a full functional Linux kernel
>> (based on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their git
>> repositories are here:
>>
>> QEMU: https://github.com/chenhuacai/qemu
>> Kernel: https://github.com/chenhuacai/linux
>>
>> Of course these two repositories need to be rework and not suitable
>> for upstream (especially the commits need to be splitted). We show
>> them here is just to tell others what we have done, and how
>> KVM/Loongson will look like.
>>
>> Our plan is make the KVM host side be upstream first, and after that,
>> we will make the KVM guest side and QEMU emulator be upstream.
> 
> + Aleksandar as QEMU/MIPS mainatiner
> 
> I was involved in KVM/Loongson development a bit and also intend to
> help with mainline these works.
> 
> After dealing with basic LS7A PCH kernel support, I'm going to
> cooperate with Huacai and anyone who interested in to deal with
> following stuff:
> 
> - Basic QEMU/TCG support for Loongson64 instructions.
> 	Well, it seems unrelated with KVM, but that would make
> 	development easier with cross ISA emulation. I'm not going to
> 	implement all the features like Loongson's page table fast walk
> 	extension and binary translation extension but I'll ensure any
> 	binary compiled with march=loongson3a can run flawlessly on
> 	TCG.
> 
> - Design of Loongson-VIRT QEMU machine
> 	It is nearly impossible to bring a real Loongson system into
> 	QEMU. Both RS780E and LS7A PCH have tons of unreasonable design
> 	that would make the emulation extremely complex, Loongson
> 	company's KVM implementation[1] has already proofed that,
> 	thay're now in the hell. So we all agreed that we should build
> 	a machine from draft. I think we should reuse existing infra as
> 	far as possible to reduce our work load. I'm planing to use
> 	pci-host-cam-generic together with VIRTIO PCI devices and a
> 	a strip down version of loongson,liointc-1.0a to build a pure
> 	PCI based system. But if any one have better idea please just
> 	tell us, I'm still considering how to implement SMP-IPI and ACPI
> 	stuff.
It is a good job to add kvm virtualization support on loongson64 platform. I agree that we should define common virt machine hardware system, however the compiled kernel binary should be the same with host system, else it will bring out trouble for customers to differentiate them between guest system and host system.

For pci host bridge emulation, I suggest that gpex pcie host bridge should be used, since it supports pcie hotplug and arm/riscv uses this pcie host bridge.

For virtual interrupt controller, it should support MSI/MSIX interrupt, irqchip in kernel, IRQFD, vhost/vfio etc. I have no idea how to define virtual interrupt controller now.


regards
bibo,mao

> 
> - BIOS in VM
> 	This has a lower priority. But BIOS is required to make a
> 	emulated machine looks like a real machine. Loongson have their
> 	open-sourced PMON and close-sourced UEFI(Based on tianocore).
> 	I'd really with Loongson or Lemote will open-source their UEFI
> 	but PMON is also a option.
> 
> Any kind of feedback is appreciated.
> 
> Thanks.
> 
> Wish you good health :-)
> 
> 
> [1]: http://cgit.loongnix.org/cgit/linux-3.10/ &
> http://cgit.loongnix.org/cgit/qemu-2.7.0/
> 
> Btw: I think Cc qemu-devel for the whole series is a little bit
> disturb, probably we should only Cc qemu-devel for the cover letter.
> 
>>
>> Mike Rapoport(1):
>>  mips: define pud_index() regardless of page table folding
>>
>> Xing Li(2):
>>  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
>>  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
>>
>> Huacai Chen(12):
>>  KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
>>  KVM: MIPS: Add EVENTFD support which is needed by VHOST
>>  KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
>>  KVM: MIPS: Introduce and use cpu_guest_has_ldpte
>>  KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
>>  KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
>>  KVM: MIPS: Add more types of virtual interrupts
>>  KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
>>  KVM: MIPS: Add CPUCFG emulation for Loongson-3
>>  KVM: MIPS: Add CONFIG6 and DIAG registers emulation
>>  KVM: MIPS: Add more MMIO load/store instructions emulation
>>  KVM: MIPS: Enable KVM support for Loongson-3
>>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> ---
>>  arch/mips/Kconfig                    |   1 +
>>  arch/mips/include/asm/cpu-features.h |   3 +
>>  arch/mips/include/asm/kvm_host.h     |  50 +++-
>>  arch/mips/include/asm/mipsregs.h     |   7 +
>>  arch/mips/include/asm/pgtable-64.h   |   4 +-
>>  arch/mips/include/uapi/asm/inst.h    |  11 +
>>  arch/mips/kernel/cpu-probe.c         |   2 +
>>  arch/mips/kvm/Kconfig                |   1 +
>>  arch/mips/kvm/Makefile               |   5 +-
>>  arch/mips/kvm/emulate.c              | 461
>> ++++++++++++++++++++++++++++++++++- arch/mips/kvm/entry.c
>>    |  19 +- arch/mips/kvm/interrupt.c            |  93 +------
>>  arch/mips/kvm/interrupt.h            |  14 +-
>>  arch/mips/kvm/loongson_ipi.c         | 215 ++++++++++++++++
>>  arch/mips/kvm/mips.c                 |  49 +++-
>>  arch/mips/kvm/tlb.c                  |  39 +++
>>  arch/mips/kvm/trap_emul.c            |   3 +
>>  arch/mips/kvm/vz.c                   | 204 +++++++++++-----
>>  18 files changed, 1013 insertions(+), 168 deletions(-)
>>  create mode 100644 arch/mips/kvm/loongson_ipi.c
>> --
>> 2.7.0

