Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4661E0F3E
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390764AbgEYNRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 09:17:16 -0400
Received: from ns3.fnarfbargle.com ([103.4.19.87]:41782 "EHLO
        ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388756AbgEYNRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 09:17:15 -0400
Received: from srv.home ([10.8.0.1] ident=heh26892)
        by ns3.fnarfbargle.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <lists2009@fnarfbargle.com>)
        id 1jdCxN-0006QU-H9; Mon, 25 May 2020 21:15:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fnarfbargle.com; s=mail;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From; bh=4U8An0HALsmMu0HGqoo6lm0Z9yYwIliPK+bPmq9Ia5k=;
        b=uqkuks1V7KAIbBU5oYwVySfiYgVyNQjwQaROBmvLUZZAuJlHYFvLN0UPpQxu+I/2TihwTCrT1ePuDE7vdVAYVTyfBEf7JIAuFstPek97YkHd0rs7HrUL9cw+mBJpqOEptGGyJjCKMOt1SjH4c9C20MKbFfx2rY/Er7quR5wmc8k=;
From:   Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: KVM broken after suspend in most recent kernels.
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1f7a85cc-38a6-2a2e-cbe3-a5b9970b7b92@fnarfbargle.com>
 <f726be8c-c7ef-bf6a-f31e-394969d35045@fnarfbargle.com>
 <1f7b1c9a8d9cbb6f82e97f8ba7a13ce5b773e16f.camel@redhat.com>
Message-ID: <a45bc9d7-ad0b-2ff0-edcc-5283f591bc10@fnarfbargle.com>
Date:   Mon, 25 May 2020 21:15:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1f7b1c9a8d9cbb6f82e97f8ba7a13ce5b773e16f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25/5/20 7:46 pm, Maxim Levitsky wrote:
> On Sun, 2020-05-24 at 18:43 +0800, Brad Campbell wrote:
>>
>> On 24/5/20 12:50 pm, Brad Campbell wrote:
>>> G'day all.
>>>
>>> Machine is a Macbook Pro Retina ~ 2014. Kernels are always vanilla kernel and compiled on the machine. No additional patches.
>>>
>>> vendor_id    : GenuineIntel
>>> cpu family    : 6
>>> model        : 69
>>> model name    : Intel(R) Core(TM) i5-4278U CPU @ 2.60GHz
>>> stepping    : 1
>>> microcode    : 0x25
>>> cpu MHz        : 2795.034
>>> cache size    : 3072 KB
>>> physical id    : 0
>>> siblings    : 4
>>> core id        : 1
>>> cpu cores    : 2
>>> apicid        : 3
>>> initial apicid    : 3
>>> fpu        : yes
>>> fpu_exception    : yes
>>> cpuid level    : 13
>>> wp        : yes
>>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm ida arat pln pts md_clear flush_l1d
>>> vmx flags    : vnmi preemption_timer invvpid ept_x_only ept_ad ept_1gb flexpriority tsc_offset vtpr mtf vapic ept vpid unrestricted_guest ple
>>> bugs        : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit
>>> bogomips    : 5199.87
>>> clflush size    : 64
>>> cache_alignment    : 64
>>> address sizes    : 39 bits physical, 48 bits virtual
>>>
>>>
>>> KVM worked fine in kernels somewhere prior to 5.4-5.5.
>>>
>>> KVM works fine in later kernels up to and including 5.7.0-rc6 after a clean boot. It does not work after a suspend.
>>>
>>> I can't actually bisect this because there is a bug in earlier kernels that breaks the suspend method used which requires manual patching to work around.
>>>
>>> This is using qemu version 5.0.0, but also happens with 4.2.0.
>>>
>>> In kernels earlier than 5.7 it results in either an immediate hard lock, or a GPF that results in progressive system freeze until a hard reboot is required (won't flush to disk so no logs get recorded and I have no serial or netconsole ability). In 5.7-rc6 it results in the following trace and thankfully no further issues (so I can get the logs and report it).
>>>
>>> I can and will perform any required testing and debugging, but this machine suspends with pm-utils s2both, and that is broken between about 5.4 & 5.6 due to swapfile locking issues, which makes actual bisection very, very difficult as it *requires* a suspend/resume to trigger the bug.
>>>
>>> [  227.715173] ------------[ cut here ]------------
>>> [  227.715176] VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x4
>>> [  227.715194] WARNING: CPU: 0 PID: 5502 at arch/x86/kvm/vmx/vmx.c:2239 hardware_enable+0x167/0x180 [kvm_intel]
>>> [  227.715195] Modules linked in: brcmfmac xhci_pci xhci_hcd cmac bnep iptable_nat xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd bridge stp llc appletouch brcmutil snd_hda_codec_hdmi sha256_ssse3 snd_hda_codec_cirrus snd_hda_codec_generic sha256_generic libsha256 x86_pkg_temp_thermal coretemp btusb kvm_intel btrtl kvm btbcm btintel irqbypass bluetooth cfg80211 snd_hda_intel ecdh_generic ecc snd_intel_dspcfg bcm5974 rfkill snd_hda_codec snd_hwdep snd_hda_core snd_pcm_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi i915 snd_seq snd_seq_device snd_timer i2c_algo_bit iosf_mbi drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops snd drm intel_gtt agpgart evdev apple_bl video soundcore hid_apple usb_storage hid_generic usbhid hid dm_crypt dm_mod i2c_i801 i2c_core sg usbcore usb_common [last unloaded: xhci_hcd]
>>> [  227.715221] CPU: 0 PID: 5502 Comm: qemu Not tainted 5.7.0-rc6+ #15
>>> [  227.715222] Hardware name: Apple Inc. MacBookPro11,1/Mac-189A3D4F975D5FFC, BIOS 159.0.0.0.0 02/05/2020
>>> [  227.715225] RIP: 0010:hardware_enable+0x167/0x180 [kvm_intel]
>>> [  227.715227] Code: 01 00 01 b9 3a 00 00 00 0f 32 31 c9 48 c1 e2 20 be ef be ad de 48 c7 c7 68 fd bb c0 48 09 c2 85 c9 48 0f 44 f2 e8 43 78 4f dc <0f> 0b eb 8a 48 8b 15 ce 89 06 dd e9 c7 fe ff ff 66 0f 1f 84 00 00
>>> [  227.715228] RSP: 0018:ffff97091d873df8 EFLAGS: 00010092
>>> [  227.715229] RAX: 000000000000002d RBX: 0000000000000046 RCX: 0000000000000007
>>> [  227.715230] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff97091f2187a0
>>> [  227.715231] RBP: ffff97091d873e10 R08: 0000000000000008 R09: 0000000000000495
>>> [  227.715232] R10: 0000000000000010 R11: ffff97091d873c6d R12: 0000000000000000
>>> [  227.715233] R13: 0000000000000286 R14: ffffb5d08015e010 R15: 0000000000000000
>>> [  227.715234] FS:  00007f1468fd33c0(0000) GS:ffff97091f200000(0000) knlGS:0000000000000000
>>> [  227.715235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  227.715236] CR2: 0000563b54c7201d CR3: 000000043f43f001 CR4: 00000000001626f0
>>> [  227.715237] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [  227.715238] DR3: 0000000000000080 DR6: 00000000ffff0ff0 DR7: 0000000020000400
>>> [  227.715238] Call Trace:
>>> [  227.715251]  kvm_arch_hardware_enable+0x65/0x230 [kvm]
>>> [  227.715257]  hardware_enable_nolock+0x2f/0x60 [kvm]
>>> [  227.715262]  ? __kvm_write_guest_page+0x60/0x60 [kvm]
>>> [  227.715266]  on_each_cpu+0x34/0x40
>>> [  227.715271]  kvm_dev_ioctl+0x63a/0x6c0 [kvm]
>>> [  227.715275]  ? do_sys_openat2+0x1a7/0x2d0
>>> [  227.715277]  ksys_ioctl+0x70/0xb0
>>> [  227.715279]  ? vtime_user_exit+0x1b/0x60
>>> [  227.715280]  __x64_sys_ioctl+0x15/0x20
>>> [  227.715282]  do_syscall_64+0x4f/0x190
>>> [  227.715284]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [  227.715285] RIP: 0033:0x7f146ba30427
>>> [  227.715287] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8 64 89 01 48
>>> [  227.715288] RSP: 002b:00007fff63e4e898 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>> [  227.715290] RAX: ffffffffffffffda RBX: 000000000000ae01 RCX: 00007f146ba30427
>>> [  227.715292] RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 000000000000000c
>>> [  227.715293] RBP: 0000000000000000 R08: 0000563b55030de0 R09: 0000000000000001
>>> [  227.715294] R10: 0000563b54da1010 R11: 0000000000000246 R12: 0000563b55081d60
>>> [  227.715295] R13: 000000000000000c R14: 0000000000000000 R15: 00007fff63e4ea80
>>> [  227.715297] ---[ end trace 0ce5d8cb29fff4bc ]---
>>> [  227.715299] kvm: enabling virtualization on CPU0 failed
>>>
>>
>> Found a bisect method that was viable.
>>
>> 21bd3467a58ea51ccc0b1d9bcb86dadf1640a002 is the first bad commit
>> commit 21bd3467a58ea51ccc0b1d9bcb86dadf1640a002
>> Author: Sean Christopherson <sean.j.christopherson@intel.com>
>> Date:   Fri Dec 20 20:45:08 2019 -0800
>>
>>       KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR
>>           Remove KVM's code to initialize IA32_FEAT_CTL MSR when KVM is loaded now
>>       that the MSR is initialized during boot on all CPUs that support VMX,
>>       i.e. on all CPUs that can possibly load kvm_intel.
>>           Note, don't WARN if IA32_FEAT_CTL is unlocked, even though the MSR is
>>       unconditionally locked by init_ia32_feat_ctl().  KVM isn't tied directly
>>       to a CPU vendor detection, whereas init_ia32_feat_ctl() is invoked if
>>       and only if the CPU vendor is recognized and known to support VMX.  As a
>>       result, vmx_disabled_by_bios() may be reached without going through
>>       init_ia32_feat_ctl() and thus without locking IA32_FEAT_CTL.  This quirk
>>       will be eliminated in a future patch.
>>           Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>       Signed-off-by: Borislav Petkov <bp@suse.de>
>>       Reviewed-by: Jim Mattson <jmattson@google.com>
>>       Link: https://lkml.kernel.org/r/20191221044513.21680-15-sean.j.christopherson@intel.com
>>
>> V5.5 was good. V5.6 was bad.
>> On v5.6 it causes the machine to instantly hardlock.
>> On v5.7 it drops the aforementioned WARNING in the log.
>>
>> Basically:
>> Clean boot. Run test qemu. echo mem > /sys/power/state. Hit key to wake up machine. Run test qemu.
>>
>> Good works. Bad hardlocks instantly.
>>
>> git bisect start
>> # bad: [7111951b8d4973bda27ff663f2cf18b663d15b48] Linux 5.6
>> git bisect bad 7111951b8d4973bda27ff663f2cf18b663d15b48
>> # good: [d5226fa6dbae0569ee43ecfc08bdcd6770fc4755] Linux 5.5
>> git bisect good d5226fa6dbae0569ee43ecfc08bdcd6770fc4755
>> # bad: [9f68e3655aae6d49d6ba05dd263f99f33c2567af] Merge tag 'drm-next-2020-01-30' of git://anongit.freedesktop.org/drm/drm
>> git bisect bad 9f68e3655aae6d49d6ba05dd263f99f33c2567af
>> # bad: [fb95aae6e67c4e319a24b3eea32032d4246a5335] Merge tag 'sound-5.6-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
>> git bisect bad fb95aae6e67c4e319a24b3eea32032d4246a5335
>> # good: [f76e4c167ea2212e23c15ee7e601a865e822c291] net: phy: add default ARCH_BCM_IPROC for MDIO_BCM_IPROC
>> git bisect good f76e4c167ea2212e23c15ee7e601a865e822c291
>> # good: [c677124e631d97130e4ff7db6e10acdfb7a82321] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect good c677124e631d97130e4ff7db6e10acdfb7a82321
>> # good: [90fb04f890bcb7384b4d4c216dc2640b0a870df3] Merge tag 'asoc-v5.6' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus
>> git bisect good 90fb04f890bcb7384b4d4c216dc2640b0a870df3
>> # good: [684cf266eb04911825a6de10dadd188cf801d063] crypto: ccree - fix typo in comment
>> git bisect good 684cf266eb04911825a6de10dadd188cf801d063
>> # good: [4e19443da1941050b346f8fc4c368aa68413bc88] btrfs: free block groups after free'ing fs trees
>> git bisect good 4e19443da1941050b346f8fc4c368aa68413bc88
>> # bad: [b5f7ab6b1c4ed967fb76258f79251193cb1ad41d] Merge tag 'fs-dedupe-last-block-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
>> git bisect bad b5f7ab6b1c4ed967fb76258f79251193cb1ad41d
>> # good: [f6170f0afbe23ad82b4a1195168949c31e3a2527] Merge branch 'x86-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect good f6170f0afbe23ad82b4a1195168949c31e3a2527
>> # bad: [a4d0b2fdbcf75ef6654713c83c316ea3a661ddc3] KVM: VMX: Use VMX feature flag to query BIOS enabling
>> git bisect bad a4d0b2fdbcf75ef6654713c83c316ea3a661ddc3
>> # good: [501444905fcb4166589fda99497c273ac5efc65e] x86/centaur: Use common IA32_FEAT_CTL MSR initialization
>> git bisect good 501444905fcb4166589fda99497c273ac5efc65e
>> # good: [b47ce1fed42eeb9ac8c07fcda6c795884826723d] x86/cpu: Detect VMX features on Intel, Centaur and Zhaoxin CPUs
>> git bisect good b47ce1fed42eeb9ac8c07fcda6c795884826723d
>> # good: [167a4894c113ebe6a1f8b24fa6f9fca849c77f8a] x86/cpu: Set synthetic VMX cpufeatures during init_ia32_feat_ctl()
>> git bisect good 167a4894c113ebe6a1f8b24fa6f9fca849c77f8a
>> # bad: [21bd3467a58ea51ccc0b1d9bcb86dadf1640a002] KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR
>> git bisect bad 21bd3467a58ea51ccc0b1d9bcb86dadf1640a002
>> # good: [85c17291e2eb4903bf73e5d3f588f41dbcc6f115] x86/cpufeatures: Add flag to track whether MSR IA32_FEAT_CTL is configured
>> git bisect good 85c17291e2eb4903bf73e5d3f588f41dbcc6f115
>> # first bad commit: [21bd3467a58ea51ccc0b1d9bcb86dadf1640a002] KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR
>>
>> Regards,
>> Brad
>>
> 
> When you mean that KVM is broken after suspend, you mean that you can't start new VMs after suspend,
> or do VMs that were running before suspend break?
> I see the later on my machine. I have AMD system though, so most likely this is another bug.
> 
> Looking at the commit, I suspect that we indeed should set the IA32_FEAT_CTL after resume from ram,
> since suspend to ram might count as a complete CPU reset.
> 

One of those "I should have clarified that" moments immediately after I pressed send.
I've not tried suspending with a VM running. It's "can't start new VMs after suspend".

I just rebooted into 5.7-rc6 to see what happens if I suspend with a VM running and bad things happened :

[   66.293951] ------------[ cut here ]------------
[   66.293955] kernel BUG at arch/x86/kvm/x86.c:387!
[   66.293958] invalid opcode: 0000 [#1] SMP
[   66.293961] CPU: 0 PID: 4580 Comm: qemu Tainted: G        W         5.7.0-rc6+ #15
[   66.293963] Hardware name: Apple Inc. MacBookPro11,1/Mac-189A3D4F975D5FFC, BIOS 159.0.0.0.0 02/05/2020
[   66.293978] RIP: 0010:kvm_spurious_fault+0xe/0x10 [kvm]
[   66.293980] Code: 77 09 83 c7 01 89 3d b1 5e 04 00 c3 55 48 89 e5 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 80 3d b9 67 04 00 00 74 01 c3 55 48 89 e5 <0f> 0b 55 89 ff 48 89 e5 53 49 89 f8 48 83 ec 08 48 8b 1d 8b 6b 04
[   66.293982] RSP: 0018:ffffa15f038e7c80 EFLAGS: 00010246
[   66.293984] RAX: 00005ea4c0000000 RBX: ffffa15eb4b00000 RCX: ffffa15f1f200000
[   66.293985] RDX: ffffa15eb49b6000 RSI: 00000003f49b6000 RDI: ffffa15eb49b6000
[   66.293986] RBP: ffffa15f038e7c80 R08: ffffa15ebcab4838 R09: 0000000000000003
[   66.293987] R10: 000000000000000e R11: ffffa15ebcab4800 R12: 0000000000000000
[   66.293989] R13: 00000000ffffffff R14: ffffa15eb4b00000 R15: ffffa15eb4b00060
[   66.293990] FS:  00007f9b07c17700(0000) GS:ffffa15f1f200000(0000) knlGS:0000000000000000
[   66.293992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.293993] CR2: 000055f5cbb6c700 CR3: 00000003f4890006 CR4: 00000000001606f0
[   66.293994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.293995] DR3: 0000000000000080 DR6: 00000000ffff0ff0 DR7: 0000000020000400
[   66.293996] Call Trace:
[   66.294002]  vmx_vcpu_load_vmcs+0x1a6/0x220 [kvm_intel]
[   66.294006]  vmx_vcpu_load+0x1d/0x100 [kvm_intel]
[   66.294015]  ? kvm_ioapic_set_irq+0x61/0x80 [kvm]
[   66.294023]  ? kvm_set_ioapic_irq+0x19/0x20 [kvm]
[   66.294031]  ? kvm_set_irq+0x99/0xd0 [kvm]
[   66.294040]  ? kvm_hv_set_sint+0x30/0x30 [kvm]
[   66.294049]  kvm_arch_vcpu_load+0x4d/0x210 [kvm]
[   66.294055]  vcpu_load+0x2e/0x40 [kvm]
[   66.294065]  kvm_arch_vcpu_ioctl_run+0x20/0x18c0 [kvm]
[   66.294069]  ? do_futex+0x26e/0xa20
[   66.294078]  ? kvm_vm_ioctl_irq_line+0x22/0x30 [kvm]
[   66.294081]  ? _copy_to_user+0x26/0x30
[   66.294088]  kvm_vcpu_ioctl+0x213/0x520 [kvm]
[   66.294091]  ? finish_task_switch+0xd4/0x280
[   66.294094]  ksys_ioctl+0x70/0xb0
[   66.294096]  ? vtime_user_exit+0x1b/0x60
[   66.294098]  __x64_sys_ioctl+0x15/0x20
[   66.294100]  do_syscall_64+0x4f/0x190
[   66.294103]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   66.294104] RIP: 0033:0x7f9b1016b427
[   66.294106] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8 64 89 01 48
[   66.294108] RSP: 002b:00007f9b07c16538 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   66.294109] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f9b1016b427
[   66.294110] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000e
[   66.294112] RBP: 0000000000000000 R08: 000055f8df44c290 R09: 0000000000000001
[   66.294113] R10: 0000000000000001 R11: 0000000000000246 R12: 000055f8e1b371e0
[   66.294114] R13: 000055f8df417080 R14: 00007f9b110ff000 R15: 0000000000000000
[   66.294115] Modules linked in: cmac bnep iptable_nat xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd bridge stp llc appletouch snd_hda_codec_hdmi brcmfmac brcmutil snd_hda_codec_cirrus snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep btusb snd_hda_core btrtl btbcm snd_pcm_oss btintel sha256_ssse3 snd_pcm x86_pkg_temp_thermal i915 bluetooth coretemp snd_seq_midi snd_seq_midi_event kvm_intel sha256_generic libsha256 i2c_algo_bit iosf_mbi snd_rawmidi kvm ecdh_generic cfg80211 ecc drm_kms_helper snd_seq irqbypass snd_seq_device rfkill bcm5974 snd_timer syscopyarea sysfillrect sysimgblt fb_sys_fops snd drm intel_gtt agpgart soundcore video apple_bl evdev hid_apple usb_storage hid_generic usbhid hid dm_crypt dm_mod i2c_i801 i2c_core sg xhci_pci xhci_hcd usbcore usb_common
[   66.294147] ---[ end trace 80d4b7ff7263ea90 ]---
[   66.294156] RIP: 0010:kvm_spurious_fault+0xe/0x10 [kvm]
[   66.294158] Code: 77 09 83 c7 01 89 3d b1 5e 04 00 c3 55 48 89 e5 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 80 3d b9 67 04 00 00 74 01 c3 55 48 89 e5 <0f> 0b 55 89 ff 48 89 e5 53 49 89 f8 48 83 ec 08 48 8b 1d 8b 6b 04
[   66.294159] RSP: 0018:ffffa15f038e7c80 EFLAGS: 00010246
[   66.294160] RAX: 00005ea4c0000000 RBX: ffffa15eb4b00000 RCX: ffffa15f1f200000
[   66.294161] RDX: ffffa15eb49b6000 RSI: 00000003f49b6000 RDI: ffffa15eb49b6000
[   66.294162] RBP: ffffa15f038e7c80 R08: ffffa15ebcab4838 R09: 0000000000000003
[   66.294164] R10: 000000000000000e R11: ffffa15ebcab4800 R12: 0000000000000000
[   66.294165] R13: 00000000ffffffff R14: ffffa15eb4b00000 R15: ffffa15eb4b00060
[   66.294166] FS:  00007f9b07c17700(0000) GS:ffffa15f1f200000(0000) knlGS:0000000000000000
[   66.294167] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.294168] CR2: 000055f5cbb6c700 CR3: 00000003f4890006 CR4: 00000000001606f0
[   66.294170] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.294171] DR3: 0000000000000080 DR6: 00000000ffff0ff0 DR7: 0000000020000400

It prepared to suspend, then immediately woke back up and left that in the log.

I don't do that as a rule (or even an exception) so I'd never really tested it. I always shut down the VM before sleeping.

Regards,
Brad
