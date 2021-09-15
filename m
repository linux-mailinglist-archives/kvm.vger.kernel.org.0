Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7A40BEFC
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 06:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhIOEqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 00:46:13 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:46898
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231233AbhIOEqM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 00:46:12 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C04983F22C
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 04:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631681086;
        bh=MbzpjLrynmNnGGEVA2ar4tS3Ki3515NvGxk+PBG17cc=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=FQdWYomUiZ/Wur0CYjDe4RnI+tMwjTMsJop39GL7jrclb6Sx/0pePfnebP2vpm7sB
         1xOS0fS2v18nUn5KiBq9+xqp9X21CnUay19xYc6bFR/bs7pYSlyLpQx0T5ynRpNgoj
         DZ+7a+bNoqOKerr/oCAyRcaEUVnGRuEqkXQ/rnKh56eKMpUplV5csz2QQL2DL+eAqB
         mq2oyssGfn1RGldX94aS+og5jCNDoRXOu3tg77GGv1hHhuXOSDacBU4GTaIOPynYvj
         6NwjIGs1lXCjY3ixRnVhHAgPKVyiCt9fzT7CVlaSKcaym/dhVK/WxtFhiL6m3bDUP9
         eC4bvhFFzWhXg==
Received: by mail-pg1-f200.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso918708pgi.21
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 21:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MbzpjLrynmNnGGEVA2ar4tS3Ki3515NvGxk+PBG17cc=;
        b=dIRJGLtisrV+Myl11AEozvzCeDQjJcN7IUcZo8Og/Tmoq05Ws1F/YDCAGm1lKnnz4S
         dKleLRgqH+o1PHkqXBV/QpgVYE2zPnrHYuEoqUz4TThU5vfcH+LIsTgQdTOigu8vaMax
         9mDi3phr1u2gc28YqSN4oFJqrowA8vqKdyuXwM2N2Z4ly4fO6XONU88Hc+J1FWIehMPZ
         OHAOM+3oRA68CIgItsKd/j+xPH4o/2R86hm3cWINM5yxIQVAd1cnsUevNq1QHusoVN14
         TQGbffQuDqhpRhK1hkDkXMQooPssNLu/8uhcNgPkFDwwOHsBs85ITMwcIhoNeiLMCvMY
         WhdQ==
X-Gm-Message-State: AOAM5334RCxtKMTghDs4SkoFYClOx0vMltQh7RLDogdiHnKuTSYYQEtt
        MaNVJ/oKIsBlzArAe4xzR5zbfc3GjFcj7f6BQbQB5p9KshqSgo8/gux0BQ2bPqfQjhsMMOm1Sbr
        BjcFBOTvRSrFOBnrdEfDWb41+DSNnfw==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr8351790pfc.70.1631681084955;
        Tue, 14 Sep 2021 21:44:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQFWQbXkZtkFgzcqsyddeStQZaLwwznOOohNk2cCAQycs8X9RpCT1uGeP4OMEHt6SztcvPAw==
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id l6-20020a056a0016c6b029032de1909dd0mr8351770pfc.70.1631681084539;
        Tue, 14 Sep 2021 21:44:44 -0700 (PDT)
Received: from [192.168.1.107] (125-237-197-94-fibre.sparkbb.co.nz. [125.237.197.94])
        by smtp.gmail.com with ESMTPSA id m9sm7968086pfh.94.2021.09.14.21.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 21:44:44 -0700 (PDT)
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
 <20210914104301.48270518.alex.williamson@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Message-ID: <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
Date:   Wed, 15 Sep 2021 16:44:38 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914104301.48270518.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Adding Nathan Langford to CC, Nathan is the affected user, and has direct access

to the system. 

On 15/09/21 4:43 am, Alex Williamson wrote:
> On Mon, 13 Sep 2021 18:31:02 +1200
> Matthew Ruffell <matthew.ruffell@canonical.com> wrote:
> 
>> Dear PCI, KVM and VFIO Subsystem Maintainers,
>>
>>
>>
>> I have a user which can reliably reproduce a host lockup when passing 2x GPUs to
>>
>> a KVM guest via vfio-pci, where the two GPUs each share the same PCI switch. If
>>
>> the user passes through multiple GPUs, and selects them such that no GPU shares
>>
>> the same PCI switch as any other GPU, the system is stable.
> 
> For discussion, an abridged lspci tree where all the endpoints are
> functions per GPU card:
> 
>  +-[0000:80]-+-02.0-[82-85]----00.0-[83-85]--+-08.0-[84]--+-00.0
>  |           |                               |            +-00.1
>  |           |                               |            +-00.2
>  |           |                               |            \-00.3
>  |           |                               \-10.0-[85]--+-00.0
>  |           |                                            +-00.1
>  |           |                                            +-00.2
>  |           |                                            \-00.3
>  |           +-03.0-[86-89]----00.0-[87-89]--+-08.0-[88]--+-00.0
>  |           |                               |            +-00.1
>  |           |                               |            +-00.2
>  |           |                               |            \-00.3
>  |           |                               \-10.0-[89]--+-00.0
>  |           |                                            +-00.1
>  |           |                                            +-00.2
>  |           |                                            \-00.3
>  \-[0000:00]-+-02.0-[02-05]----00.0-[03-05]--+-08.0-[04]--+-00.0
>              |                               |            +-00.1
>              |                               |            +-00.2
>              |                               |            \-00.3
>              |                               \-10.0-[05]--+-00.0
>              |                                            +-00.1
>              |                                            +-00.2
>              |                                            \-00.3
>              +-03.0-[06-09]----00.0-[07-09]--+-08.0-[08]--+-00.0
>                                              |            +-00.1
>                                              |            +-00.2
>                                              |            \-00.3
>                                              \-10.0-[09]--+-00.0
>                                                           +-00.1
>                                                           +-00.2
>                                                           \-00.3
> 
> When you say the system is stable when no GPU shares the same PCI
> switch as any other GPU, is that per VM or one GPU per switch remains
> entirely unused?

We have only been testing with one running VM in different configurations.



Configuration with no issue: 

GPUs (by PCI device ID): 04, 08, 84, 88 (none sharing the same PCIe switch)



Configuration where the issue occurs: 

GPUs 04, 08, 84, 88, 89 (88 and 89 sharing a PCIe switch)

> 
> FWIW, I have access to a system with an NVIDIA K1 and M60, both use
> this same switch on-card and I've not experienced any issues assigning
> all the GPUs to a single VM.  Topo:
> 
>  +-[0000:40]-+-02.0-[42-47]----00.0-[43-47]--+-08.0-[44]----00.0
>  |                                           +-09.0-[45]----00.0
>  |                                           +-10.0-[46]----00.0
>  |                                           \-11.0-[47]----00.0
>  \-[0000:00]-+-03.0-[04-07]----00.0-[05-07]--+-08.0-[06]----00.0
>                                              \-10.0-[07]----00.0
> 
>>
>> System Information:
>>
>> - SuperMicro X9DRG-O(T)F
>>
>> - 8x Nvidia GeForce RTX 2080 Ti GPUs
>>
>> - Ubuntu 20.04 LTS
>>
>> - 5.14.0 mainline kernel
>>
>> - libvirt 6.0.0-0ubuntu8.10
>>
>> - qemu 4.2-3ubuntu6.16
>>
>>
>>
>> Kernel command line:
>>
>> Command line: BOOT_IMAGE=/vmlinuz-5.14-051400-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro intel_iommu=on hugepagesz=1G hugepages=240 kvm.report_ignored_msrs=0 kvm.ignore_msrs=1 vfio-pci.ids=10de:1e04,10de:10f7,10de:1ad6,10de:1ad7 console=ttyS1,115200n8 ignore_loglevel crashkernel=512M
>>
>>
>>
>> lspci -vvv ran as root under kernel 5.14.0 is available in the pastebin below,
>>
>> and also attached to this message.
>>
>> https://paste.ubuntu.com/p/TVNvvXC7Z9/
> 
> 
> On my system, the upstream ports of the switch have MSI interrupts
> enabled, in your listing only the downstream ports enable MSI.  Is
> there anything in dmesg that might indicate an issue configuring
> interrupts on the upstream port?
> 

Full dmesg output is available in the pastebin below:

https://paste.ubuntu.com/p/XTdRXFvvSV/

The only issues I found in dmesg are:

[   11.711225] pci 0000:00:05.0: disabled boot interrupts on device [8086:0e28]
[   11.863785] pci 0000:80:05.0: disabled boot interrupts on device [8086:0e28]

But these seem to point to the VTd/Memory Map/Misc peripheral devices and are unrelated.
> 
>> lspci -tv ran as root available in the pastebin below:
>>
>> https://paste.ubuntu.com/p/52Y69PbjZg/
>>
>>
>>
>> The symptoms are:
>>
>>
>>
>> When multiple GPUs are passed through to a KVM guest via pci-vfio, and if a
>>
>> pair of GPUs are passed through which share the same PCI switch, if you start
>>
>> the VM, panic the VM / force restart the VM, and keep looping, eventually the
>>
>> host will have the following kernel oops:
> 
> 
> You say "eventually" here, does that suggest the frequency is not 100%?
> 
> It seems like all the actions you list have a bus reset in common.
> Does a clean reboot of the VM also trigger it, or killing the VM?
> 

The lockup is extremely intermittent in normal use (sometimes months between 

occurrences) but we have been able to reproduce it much more frequently by 

this loop of starting the VM, crashing the kernel in VM, resetting the VM from 

the host, and repeating. The lockup still doesn’t happen every time though. Here

is some data on the number of VM crash/reset cycles between host lockups: 



Config: GPUs 04, 05, 84, 88, 89

VM crash/reset cycles between host lockups: 15, 50, 60, 64, 7, 42, 8, 8, 78, 60, 32

Note: all lockups occurred after a message of “irq 31: nobody cared” 

corresponding to the PCIe switch shared by GPUs 88, 89.



Config: GPUs 04, 08, 84, 88

Results: No lockups after 722 VM crash/reset cycles



We have been able to cause the host lockups by just executing a reboot from

within the VM, rather than crashing the VM, but most testing hasn’t been done 

this way. As an anecdote from seeing this occur in production, we believe 

rebooting the VM can cause the issue.


>> irq 31: nobody cared (try booting with the "irqpoll" option)
>>
>> CPU: 23 PID: 0 Comm: swapper/23 Kdump: loaded Not tainted 5.14-051400-generic #202108310811-Ubuntu
>>
>> Hardware name: Supermicro X9DRG-O(T)F/X9DRG-O(T)F, BIOS 3.3  11/27/2018
>>
>> Call Trace:
>>
>>  <IRQ>
>>
>>  dump_stack_lvl+0x4a/0x5f
>>
>>  dump_stack+0x10/0x12
>>
>>  __report_bad_irq+0x3a/0xaf
>>
>>  note_interrupt.cold+0xb/0x60
>>
>>  handle_irq_event_percpu+0x72/0x80
>>
>>  handle_irq_event+0x3b/0x60
>>
>>  handle_fasteoi_irq+0x9c/0x150
>>
>>  __common_interrupt+0x4b/0xb0
>>
>>  common_interrupt+0x4a/0xa0
>>
>>  asm_common_interrupt+0x1e/0x40
>>
>> RIP: 0010:__do_softirq+0x73/0x2ae
>>
>> Code: 7b 61 4c 00 01 00 00 89 75 a8 c7 45 ac 0a 00 00 00 48 89 45 c0 48 89 45 b0 65 66 c7 05 54 c7 62 4c 00 00 fb 66 0f 1f 44 00 00 <bb> ff ff ff ff 49 c7 c7 c0 60 80 b4 41 0f bc de 83 c3 01 89 5d d4
>>
>> RSP: 0018:ffffba440cc04f80 EFLAGS: 00000286
>>
>> RAX: ffff93c5a0929880 RBX: 0000000000000000 RCX: 00000000000006e0
>>
>> RDX: 0000000000000001 RSI: 0000000004200042 RDI: ffff93c5a1104980
>>
>> RBP: ffffba440cc04fd8 R08: 0000000000000000 R09: 000000f47ad6e537
>>
>> R10: 000000f47a99de21 R11: 000000f47a99dc37 R12: ffffba440c68be08
>>
>> R13: 0000000000000001 R14: 0000000000000200 R15: 0000000000000000
>>
>>  irq_exit_rcu+0x8d/0xa0
>>
>>  sysvec_apic_timer_interrupt+0x7c/0x90
>>
>>  </IRQ>
>>
>>  asm_sysvec_apic_timer_interrupt+0x12/0x20
>>
>> RIP: 0010:tick_nohz_idle_enter+0x47/0x50
>>
>> Code: 30 4b 4d 48 83 bb b0 00 00 00 00 75 20 80 4b 4c 01 e8 5d 0c ff ff 80 4b 4c 04 48 89 43 78 e8 50 e8 f8 ff fb 66 0f 1f 44 00 00 <5b> 5d c3 0f 0b eb dc 66 90 0f 1f 44 00 00 55 48 89 e5 53 48 c7 c3
>>
>> RSP: 0018:ffffba440c68beb0 EFLAGS: 00000213
>>
>> RAX: 000000f5424040a4 RBX: ffff93e51fadf680 RCX: 000000000000001f
>>
>> RDX: 0000000000000000 RSI: 000000002f684d00 RDI: ffe8b4bb6b90380b
>>
>> RBP: ffffba440c68beb8 R08: 000000f5424040a4 R09: 0000000000000001
>>
>> R10: ffffffffb4875460 R11: 0000000000000017 R12: 0000000000000093
>>
>> R13: ffff93c5a0929880 R14: 0000000000000000 R15: 0000000000000000
>>
>>  do_idle+0x47/0x260
>>
>>  ? do_idle+0x197/0x260
>>
>>  cpu_startup_entry+0x20/0x30
>>
>>  start_secondary+0x127/0x160
>>
>>  secondary_startup_64_no_verify+0xc2/0xcb
>>
>> handlers:
>>
>> [<00000000b16da31d>] vfio_intx_handler
>>
>> Disabling IRQ #31
> 
> Hmm, we have the vfio-pci INTx handler installed, but possibly another
> device is pulling the line or we're somehow out of sync with our own
> device, ie. we either think it's already masked or it's not indicating
> INTx status.
> 
>> The IRQs which this occurs on are: 25, 27, 106, 31, 29. These represent the
>>
>> PEX 8747 PCIe switches present in the system:
> 
> Some of those are the upstream port IRQ shared with a downstream
> endpoint, but the lspci doesn't show that conclusively for all of
> those.  

The lspci -vvv output previously attached was executed while a VM was running 

with GPUs 04,08,84,88,89. We can see what you mean about IRQ 25 shared with PCIe 

switch 02:00 and GPU 05:00.0, IRQ 27 with switch 06:00 and GPU 09:00.0, IRQ 29 

with switch 82:00 and GPU 85:00.0, and IRQ 31 only on switch 86:00. We just 

started a VM with all 8 GPUs and now none of the upstream switch ports and GPUs 

share IRQs.

As an aside, we have seen the host lockups occur in IRQs 25, 27, 29, 31, which 

are all for the upstream switch ports, but also IRQs 103, 106, 109, 112, which 

correspond to the GPU audio device functions. There are only four IRQs for eight

GPUS because GPUs sharing a PCIe switch will have their audio device functions 

both share an IRQ. This is different to what was shown in the previously 

attached lspci -vvv output because, since by default, the audio devices on the 

GPUs don’t use MSI. Recently, we set “options snd-hda-intel enable_msi=1” in 

/etc/modprobe.d/ within the VM to force the audio device to use MSI, which had

the side effect of audio devices no longer sharing IRQs. We don't know if the

host lockups related to the audio devices are related to the PCIe switch lockup

problem.

> Perhaps a test we can run is to set DisINTx on all the upstream
> root ports to eliminate this known IRQ line sharing between devices.
> Something like this should set the correct bit for all the 8747
> upstream ports:
> 
> # setpci -d 10b5: -s 00.0 4.w=400:400
> 
> lspci for each should then show:
> 
> Control: ... DisINTx+
> 
> vs DisINTx-
> 
> I'm still curious why it's not using MSI, but maybe this will hint
> which device has the issue.

Thanks. We have ran the setpci command, and can see DisINTx+ has been set. MSI

is still disabled, interestingly enough. We will run the reproducer script to

loop the VM to see if it reproduces.

> ...
>>
>> [    3.271530] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
>>
>> [    3.282572] DMAR-IR: Copied IR table for dmar0 from previous kernel
>>
>> [   13.291319] DMAR-IR: Copied IR table for dmar1 from previous kernel
>>
>>
>>
>> The crashkernel then hard locks, and the system must be manually rebooted. Note
>>
>> that it took ten seconds to copy the IR table for dmar1, which is most unusual.
>>
>> If we do a sysrq-trigger, there is no ten second delay, and the very next
>>
>> message is:
>>
>>
>>
>> DMAR-IR: Enabled IRQ remapping in x2apic mode
>>
>>
>>
>> Which leads us to believe that we are getting stuck in the crashkernel copying
>>
>> the IR table and re-enabling the IRQ that was disabled from "nobody cared"
>>
>> and globally enabling IRQ remapping.
> 
> 
> Curious, yes.  I don't have any insights there.  Maybe something about
> the IRQ being constantly asserted interferes with installing the new
> remapper table.
> 
> 
>> Things we have tried:
>>
>>
>>
>> We have tried adding vfio-pci.nointxmask=1 to the kernel command line, but we
>>
>> cannot start a VM where the GPUs shares the same PCI switch, instead we get a 
>>
>> libvirt error:
>>
>>
>>
>> Fails to start: vfio 0000:05:00.0: Failed to set up TRIGGER eventfd signaling for interrupt INTX-0: VFIO_DEVICE_SET_IRQS failure: Device or resource busy
> 
> 
> Yup, chances of being able to enable all the assignable endpoints with
> shared interrupts is pretty slim.  It's also curious that your oops
> above doesn't list any IRQ handler corresponding to the upstream port.
> Theoretically that means you'd at least avoid conflicts between
> endpoints and the switch.  It might be possible to get a limited config
> working by unbinding drivers from conflicting devices.
> 

I also thought it was curious that the oops didn't list a handler for the

upstream port. Perhaps this is why the IRQs are being ignored, because a handler

for the upstream port isn't being set?
 
>> Starting a VM with GPUs all from different PCI switches works just fine.
> 
> 
> This must be a clue, but I'm not sure how it fits yet.
> 
>  
>> We tried adding "options snd-hda-intel enable_msi=1" to /etc/modprobe.d/snd-hda-intel.conf,
>>
>> and while it did enable MSI for all PCI devices under each GPU, MSI is still
>>
>> disabled on each of the PLX PCI switches, and the issue still reproduces when
>>
>> GPUs share PCI switches.
>>
>>
>>
>> We have ruled out ACS issues, as each PLX PCI switch and Nvidia GPU are 
>>
>> allocated their own isolated IOMMU group:
>>
>>
>>
>> https://paste.ubuntu.com/p/9VRt2zrqRR/
>>
>>
>>
>> Looking at the initial kernel oops, we seem to hit __report_bad_irq(), which
>>
>> means that we have ignored 99,900 of these interrupts coming from the PCI switch,
>>
>> and that the vfio_intx_handler() doesn't process them, likely because the PCI
>>
>> switch itself is not passed through to the VM, only the VGA PCI devices are.
> 
> 
> Assigning switch ports doesn't really make any sense, all the bridge
> features would be emulated in the guest and the host needs to handle
> various error conditions first.  Seems we need to figure out which
> device is actually signaling the interrupt and how it relates to
> multiple devices assigned from the same switch, and maybe if it's
> related to a bus reset operation.  Thanks,

Would tracing the pci subsystem be helpful? We will enable dyndbg on

dyndbg='file drivers/pci/* +p'

and see if we can catch bus resets.

> 
> Alex
> 

Thanks,
Matthew
