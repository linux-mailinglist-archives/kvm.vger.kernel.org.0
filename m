Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4A12E01D4
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 22:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgLUVOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 16:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgLUVOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 16:14:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639A2C0613D3
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 13:13:44 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id dk8so10986531edb.1
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 13:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ku1U0WAbfYlZVdWguKWGSxGwbE5yedXQ2jWawN0ZLLM=;
        b=TnL+m1DmNX5PixB+SfiIM6sGex0i/HloNJ/1L9iBdLQhU5ZvAlrF9u7rSL5NtVvN7H
         qirb++lzWdow1l6OfMwxHGWo7ZYI4I1eOuKuT05JG5ycCKoc+o9wJalb0iOgo7Qrwru1
         ZEOM4y1POsrTgqf8ClORuEgDSlqZu1LG5PIySJv/8gGWiBDAGkpnwf1wLdMzJGiMDl0Y
         sEi9BNZSMyd+9mxwO19uWrtl8opyFg7ye7J/MI/KMMflrNTmE+iM5ShDT79nr+KiAGdV
         bdCpG55988qucBr8fYcodRDKTa8QKT6qjtxObv72+5hNKn2o+EBriLRJxItwibsikBh1
         NBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ku1U0WAbfYlZVdWguKWGSxGwbE5yedXQ2jWawN0ZLLM=;
        b=tgujYGkUYNq1CAhVPNsKJFOY+HQvCBWqCRt7gyouMLtGr+mCs0IxlBsxvqJj4rGeYU
         n9lcn+sgVtj6va4Vmces/NroSWJYOe+CRYx+prWRF2lXvrRtZ6aqIvPUgjQKhtDhqmJ5
         vWMFxiAl0953Jf9uXnO0ASSsd7ZcQMmyqagkY0l6b+6hkzc5SPz8qS5UfRrF//KDgGjQ
         AoFI7pJyGAAt7JPSRjp8AmsChYujXeWftCzvmEFvBq1Wnehh0R6k/kU1AZlvTYVnkPfA
         fowYHu7INVHllALfGknMmY2JAtBs9Jw+axZpS2bvtkXGMiIuPHudt5i8q/jt68i2QMcv
         UoAQ==
X-Gm-Message-State: AOAM5313M8qLGAHBNvJ7jDL3wCvfANcueZiTsmi5WnFrcKS+Rls1pLGX
        pWrjvii3FGhgfpzWjv9qj3Q=
X-Google-Smtp-Source: ABdhPJx/0m4LiS+HHXquCMri0GlROmIvZXTbuH2h2xsPWfnSwuPlDa4R9ZdbWFU+vn51QKqt8t4Z5Q==
X-Received: by 2002:a50:cd8c:: with SMTP id p12mr17416777edi.380.1608585222882;
        Mon, 21 Dec 2020 13:13:42 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id d13sm9417203ejc.44.2020.12.21.13.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 13:13:42 -0800 (PST)
Date:   Mon, 21 Dec 2020 22:13:39 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20201221221339.030684c4.zkaspar82@gmail.com>
In-Reply-To: <X+D6eJn92Vt6v+U1@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
        <20201201073537.6749e2d7.zkaspar82@gmail.com>
        <20201218203310.5025c17e.zkaspar82@gmail.com>
        <X+D6eJn92Vt6v+U1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Dec 2020 11:41:44 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Dec 18, 2020, Zdenek Kaspar wrote:
> > > without: kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting
> > > 5-level PT I can run guest again, but with degraded performance
> > > as before.
> > > 
> > > Z.
> > 
> > With: KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte() series
> 
> Apologies, I completely missed your bug report for the
> get_mmio_spte() bugs.
> 
> > I can run guest again and performance is slightly better:
> > 
> > v5.8:        0m13.54s real     0m10.51s user     0m10.96s system
> > v5.9:        6m20.07s real    11m42.93s user     0m13.57s system
> > v5.10+fixes: 5m50.77s real    10m38.29s user     0m15.96s system
> > 
> > perf top from host when guest (openbsd) is compiling:
> >   26.85%  [kernel]                  [k] queued_spin_lock_slowpath
> >    8.49%  [kvm]                     [k] mmu_page_zap_pte
> >    7.47%  [kvm]                     [k] __kvm_mmu_prepare_zap_page
> >    3.61%  [kernel]                  [k] clear_page_rep
> >    2.43%  [kernel]                  [k] page_counter_uncharge
> >    2.30%  [kvm]                     [k] paging64_page_fault
> >    2.03%  [kvm_intel]               [k] vmx_vcpu_run
> >    2.02%  [kvm]                     [k] kvm_vcpu_gfn_to_memslot
> >    1.95%  [kernel]                  [k] internal_get_user_pages_fast
> >    1.64%  [kvm]                     [k] kvm_mmu_get_page
> >    1.55%  [kernel]                  [k] page_counter_try_charge
> >    1.33%  [kernel]                  [k] propagate_protected_usage
> >    1.29%  [kvm]                     [k] kvm_arch_vcpu_ioctl_run
> >    1.13%  [kernel]                  [k] get_page_from_freelist
> >    1.01%  [kvm]                     [k] paging64_walk_addr_generic
> >    0.83%  [kernel]                  [k] ___slab_alloc.constprop.0
> >    0.83%  [kernel]                  [k] kmem_cache_free
> >    0.82%  [kvm]                     [k] __pte_list_remove
> >    0.77%  [kernel]                  [k] try_grab_compound_head
> >    0.76%  [kvm_intel]               [k] 0x000000000001cfa0
> >    0.74%  [kvm]                     [k] pte_list_add
> 
> Can you try running with this debug hack to understand what is
> causing KVM to zap shadow pages?  The expected behavior is that
> you'll get backtraces for the first five cases where KVM zaps valid
> shadow pages.  Compile tested only.
> 
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5dfe0ede0e81..c5da993ac753 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2404,6 +2404,8 @@ static void kvm_mmu_commit_zap_page(struct kvm
> *kvm, }
>  }
> 
> +static unsigned long zapped_warns;
> +
>  static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
>                                                   unsigned long
> nr_to_zap) {
> @@ -2435,6 +2437,8 @@ static unsigned long
> kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm, goto restart;
>         }
> 
> +       WARN_ON(total_zapped && zapped_warns++ < 5);
> +
>         kvm_mmu_commit_zap_page(kvm, &invalid_list);
> 
>         kvm->stat.mmu_recycled += total_zapped;

[  179.364234] ------------[ cut here ]------------
[  179.364305] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.364347] Modules linked in: vhost_net vhost vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc lzo zram zsmalloc cpufreq_powersave i915 kvm_intel video intel_gtt iosf_mbi kvm i2c_algo_bit drm_kms_helper bridge stp iTCO_wdt e1000e syscopyarea irqbypass sysfillrect 8250 evdev 8250_base serial_core sysimgblt lpc_ich mfd_core llc button acpi_cpufreq fb_sys_fops processor drm i2c_core sch_fq_codel backlight ip_tables x_tables ipv6 autofs4 btrfs blake2b_generic libcrc32c crc32c_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress raid6_pq ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid uhci_hcd ahci libahci pata_jmicron ehci_pci ehci_hcd sata_sil24 usbcore usb_common
[  179.364818] CPU: 0 PID: 369 Comm: qemu-build Not tainted 5.10.2-1-amd64 #1
[  179.364857] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  179.364923] RIP: 0010:kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.364959] Code: 48 83 c4 18 4c 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 05 a0 6b 03 00 48 8d 50 01 48 83 f8 04 48 89 15 91 6b 03 00 77 b9 <0f> 0b eb b5 45 31 f6 eb cd 66 0f 1f 44 00 00 41 57 48 c7 c7 e0 23
[  179.365065] RSP: 0018:ffffab7e8069bb10 EFLAGS: 00010297
[  179.365097] RAX: 0000000000000000 RBX: ffff8fd62c589c78 RCX: 0000000000000000
[  179.365138] RDX: 0000000000000001 RSI: ffffffffffffffff RDI: 00003ba800a00478
[  179.365179] RBP: ffffab7e8073da78 R08: ffff8fd608d06800 R09: 000000000000000a
[  179.365218] R10: ffff8fd608d06800 R11: 000000000000000a R12: ffffab7e80735000
[  179.365257] R13: 0000000000000015 R14: 0000000000000015 R15: ffffab7e8069bb18
[  179.365299] FS:  00007f22e4b6a640(0000) GS:ffff8fd67f200000(0000) knlGS:0000000000000000
[  179.365343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.365376] CR2: 0000098452a94c00 CR3: 000000000a3c0000 CR4: 00000000000026f0
[  179.365415] Call Trace:
[  179.365443]  paging64_page_fault+0x244/0x8e0 [kvm]
[  179.365482]  ? kvm_mmu_pte_write+0x161/0x410 [kvm]
[  179.365521]  ? write_emulate+0x36/0x50 [kvm]
[  179.365558]  ? kvm_fetch_guest_virt+0x7c/0xb0 [kvm]
[  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
[  179.365628]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[  179.365655]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[  179.365683]  ? vmx_vcpu_enter_exit+0x5c/0x90 [kvm_intel]
[  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
[  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
[  179.365801]  ? tick_sched_timer+0x69/0xf0
[  179.365823]  ? tick_nohz_handler+0xf0/0xf0
[  179.365848]  ? timerqueue_add+0x96/0xb0
[  179.365870]  ? __hrtimer_run_queues+0x151/0x1b0
[  179.365895]  ? recalibrate_cpu_khz+0x10/0x10
[  179.365918]  ? ktime_get+0x33/0x90
[  179.365938]  __x64_sys_ioctl+0x338/0x720
[  179.365963]  ? fire_user_return_notifiers+0x3c/0x60
[  179.365992]  do_syscall_64+0x33/0x40
[  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  179.366041] RIP: 0033:0x7f22e60cef6b
[  179.366061] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[  179.366167] RSP: 002b:00007f22e4b69608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  179.366210] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f22e60cef6b
[  179.366248] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
[  179.366287] RBP: 000055a81d11cf70 R08: 000055a81ac42ad8 R09: 00000000000000ff
[  179.366326] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  179.366365] R13: 00007f22e6c35001 R14: 0000000000000064 R15: 0000000000000000
[  179.366405] ---[ end trace 63d1ba11f1bc6180 ]---
[  179.367537] ------------[ cut here ]------------
[  179.367583] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.367625] Modules linked in: vhost_net vhost vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc lzo zram zsmalloc cpufreq_powersave i915 kvm_intel video intel_gtt iosf_mbi kvm i2c_algo_bit drm_kms_helper bridge stp iTCO_wdt e1000e syscopyarea irqbypass sysfillrect 8250 evdev 8250_base serial_core sysimgblt lpc_ich mfd_core llc button acpi_cpufreq fb_sys_fops processor drm i2c_core sch_fq_codel backlight ip_tables x_tables ipv6 autofs4 btrfs blake2b_generic libcrc32c crc32c_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress raid6_pq ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid uhci_hcd ahci libahci pata_jmicron ehci_pci ehci_hcd sata_sil24 usbcore usb_common
[  179.375035] CPU: 0 PID: 369 Comm: qemu-build Tainted: G        W         5.10.2-1-amd64 #1
[  179.377470] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  179.379948] RIP: 0010:kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.382436] Code: 48 83 c4 18 4c 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 05 a0 6b 03 00 48 8d 50 01 48 83 f8 04 48 89 15 91 6b 03 00 77 b9 <0f> 0b eb b5 45 31 f6 eb cd 66 0f 1f 44 00 00 41 57 48 c7 c7 e0 23
[  179.387680] RSP: 0018:ffffab7e8069bb10 EFLAGS: 00010293
[  179.390307] RAX: 0000000000000001 RBX: ffff8fd62c589c78 RCX: 0000000000000000
[  179.392890] RDX: 0000000000000002 RSI: ffffffffffffffff RDI: 00003ba800a00478
[  179.395420] RBP: ffffab7e8073da78 R08: ffff8fd608d06800 R09: 000000000000000a
[  179.397901] R10: ffff8fd608d06800 R11: 000000000000000a R12: ffffab7e80735000
[  179.400339] R13: 0000000000000015 R14: 0000000000000015 R15: ffffab7e8069bb18
[  179.402715] FS:  00007f22e4b6a640(0000) GS:ffff8fd67f200000(0000) knlGS:0000000000000000
[  179.405097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.407466] CR2: 000009837e65c200 CR3: 000000000a3c0000 CR4: 00000000000026f0
[  179.409839] Call Trace:
[  179.412140]  paging64_page_fault+0x244/0x8e0 [kvm]
[  179.414377]  ? kvm_mmu_pte_write+0x161/0x410 [kvm]
[  179.416608]  ? write_emulate+0x36/0x50 [kvm]
[  179.418821]  ? kvm_fetch_guest_virt+0x7c/0xb0 [kvm]
[  179.421031]  kvm_mmu_page_fault+0x376/0x550 [kvm]
[  179.423220]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[  179.425402]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[  179.427556]  ? vmx_vcpu_enter_exit+0x5c/0x90 [kvm_intel]
[  179.429707]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
[  179.431838]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
[  179.433944]  ? tick_sched_timer+0x69/0xf0
[  179.436029]  ? tick_nohz_handler+0xf0/0xf0
[  179.438108]  ? timerqueue_add+0x96/0xb0
[  179.440185]  ? __hrtimer_run_queues+0x151/0x1b0
[  179.442263]  ? recalibrate_cpu_khz+0x10/0x10
[  179.444339]  ? ktime_get+0x33/0x90
[  179.446406]  __x64_sys_ioctl+0x338/0x720
[  179.448470]  ? fire_user_return_notifiers+0x3c/0x60
[  179.450558]  do_syscall_64+0x33/0x40
[  179.452639]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  179.454728] RIP: 0033:0x7f22e60cef6b
[  179.456812] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[  179.461281] RSP: 002b:00007f22e4b69608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  179.463572] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f22e60cef6b
[  179.465875] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
[  179.468185] RBP: 000055a81d11cf70 R08: 000055a81ac42ad8 R09: 00000000000000ff
[  179.470499] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  179.472829] R13: 00007f22e6c35001 R14: 0000000000000064 R15: 0000000000000000
[  179.475154] ---[ end trace 63d1ba11f1bc6181 ]---
[  179.478464] ------------[ cut here ]------------
[  179.480804] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.483160] Modules linked in: vhost_net vhost vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc lzo zram zsmalloc cpufreq_powersave i915 kvm_intel video intel_gtt iosf_mbi kvm i2c_algo_bit drm_kms_helper bridge stp iTCO_wdt e1000e syscopyarea irqbypass sysfillrect 8250 evdev 8250_base serial_core sysimgblt lpc_ich mfd_core llc button acpi_cpufreq fb_sys_fops processor drm i2c_core sch_fq_codel backlight ip_tables x_tables ipv6 autofs4 btrfs blake2b_generic libcrc32c crc32c_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress raid6_pq ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid uhci_hcd ahci libahci pata_jmicron ehci_pci ehci_hcd sata_sil24 usbcore usb_common
[  179.495262] CPU: 0 PID: 369 Comm: qemu-build Tainted: G        W         5.10.2-1-amd64 #1
[  179.497745] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  179.500251] RIP: 0010:kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.502761] Code: 48 83 c4 18 4c 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 05 a0 6b 03 00 48 8d 50 01 48 83 f8 04 48 89 15 91 6b 03 00 77 b9 <0f> 0b eb b5 45 31 f6 eb cd 66 0f 1f 44 00 00 41 57 48 c7 c7 e0 23
[  179.508004] RSP: 0018:ffffab7e8069bb10 EFLAGS: 00010293
[  179.510628] RAX: 0000000000000002 RBX: ffff8fd62c589c78 RCX: 0000000000000000
[  179.513214] RDX: 0000000000000003 RSI: ffffffffffffffff RDI: 00003ba800a00478
[  179.515747] RBP: ffffab7e8073da78 R08: ffff8fd608d06800 R09: 000000000000000a
[  179.518229] R10: ffff8fd608d06800 R11: 000000000000000a R12: ffffab7e80735000
[  179.520670] R13: 0000000000000015 R14: 0000000000000015 R15: ffffab7e8069bb18
[  179.523049] FS:  00007f22e4b6a640(0000) GS:ffff8fd67f200000(0000) knlGS:0000000000000000
[  179.525431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.527799] CR2: 000009844140de00 CR3: 000000000a3c0000 CR4: 00000000000026f0
[  179.530172] Call Trace:
[  179.532471]  paging64_page_fault+0x244/0x8e0 [kvm]
[  179.534709]  ? kvm_fetch_guest_virt+0x7c/0xb0 [kvm]
[  179.536946]  kvm_mmu_page_fault+0x376/0x550 [kvm]
[  179.539160]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[  179.541366]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[  179.543544]  ? vmx_vcpu_enter_exit+0x5c/0x90 [kvm_intel]
[  179.545720]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
[  179.547890]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
[  179.550033]  ? tick_sched_timer+0x69/0xf0
[  179.552153]  ? tick_nohz_handler+0xf0/0xf0
[  179.554250]  ? timerqueue_add+0x96/0xb0
[  179.556329]  ? __hrtimer_run_queues+0x151/0x1b0
[  179.558407]  ? recalibrate_cpu_khz+0x10/0x10
[  179.560486]  ? ktime_get+0x33/0x90
[  179.562557]  __x64_sys_ioctl+0x338/0x720
[  179.564628]  ? fire_user_return_notifiers+0x3c/0x60
[  179.566702]  do_syscall_64+0x33/0x40
[  179.568772]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  179.570867] RIP: 0033:0x7f22e60cef6b
[  179.572957] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[  179.577419] RSP: 002b:00007f22e4b69608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  179.579699] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f22e60cef6b
[  179.582000] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
[  179.584312] RBP: 000055a81d11cf70 R08: 000055a81ac42ad8 R09: 00000000000000ff
[  179.586632] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  179.588955] R13: 00007f22e6c35001 R14: 0000000000000064 R15: 0000000000000000
[  179.591283] ---[ end trace 63d1ba11f1bc6182 ]---
[  179.595542] ------------[ cut here ]------------
[  179.597890] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.600253] Modules linked in: vhost_net vhost vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc lzo zram zsmalloc cpufreq_powersave i915 kvm_intel video intel_gtt iosf_mbi kvm i2c_algo_bit drm_kms_helper bridge stp iTCO_wdt e1000e syscopyarea irqbypass sysfillrect 8250 evdev 8250_base serial_core sysimgblt lpc_ich mfd_core llc button acpi_cpufreq fb_sys_fops processor drm i2c_core sch_fq_codel backlight ip_tables x_tables ipv6 autofs4 btrfs blake2b_generic libcrc32c crc32c_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress raid6_pq ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid uhci_hcd ahci libahci pata_jmicron ehci_pci ehci_hcd sata_sil24 usbcore usb_common
[  179.612747] CPU: 0 PID: 369 Comm: qemu-build Tainted: G        W         5.10.2-1-amd64 #1
[  179.615250] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  179.617769] RIP: 0010:kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.620283] Code: 48 83 c4 18 4c 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 05 a0 6b 03 00 48 8d 50 01 48 83 f8 04 48 89 15 91 6b 03 00 77 b9 <0f> 0b eb b5 45 31 f6 eb cd 66 0f 1f 44 00 00 41 57 48 c7 c7 e0 23
[  179.625553] RSP: 0018:ffffab7e8069bb10 EFLAGS: 00010297
[  179.628194] RAX: 0000000000000003 RBX: ffff8fd62c589c78 RCX: 0000000000000000
[  179.630866] RDX: 0000000000000004 RSI: ffffffffffffffff RDI: 00003ba800a00478
[  179.633522] RBP: ffffab7e8073da78 R08: ffff8fd608d06800 R09: 000000000000000a
[  179.636131] R10: ffff8fd608d06800 R11: 000000000000000a R12: ffffab7e80735000
[  179.638696] R13: 0000000000000015 R14: 0000000000000015 R15: ffffab7e8069bb18
[  179.641201] FS:  00007f22e4b6a640(0000) GS:ffff8fd67f200000(0000) knlGS:0000000000000000
[  179.643671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.646085] CR2: 00000983af128a00 CR3: 000000000a3c0000 CR4: 00000000000026f0
[  179.648504] Call Trace:
[  179.650901]  paging64_page_fault+0x244/0x8e0 [kvm]
[  179.653291]  ? kvm_mmu_pte_write+0x161/0x410 [kvm]
[  179.655605]  ? write_emulate+0x36/0x50 [kvm]
[  179.657838]  ? kvm_fetch_guest_virt+0x7c/0xb0 [kvm]
[  179.660073]  kvm_mmu_page_fault+0x376/0x550 [kvm]
[  179.662286]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[  179.664491]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[  179.666668]  ? vmx_vcpu_enter_exit+0x5c/0x90 [kvm_intel]
[  179.668842]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
[  179.671013]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
[  179.673155]  ? tick_sched_timer+0x69/0xf0
[  179.675276]  ? tick_nohz_handler+0xf0/0xf0
[  179.677373]  ? timerqueue_add+0x96/0xb0
[  179.679455]  ? __hrtimer_run_queues+0x151/0x1b0
[  179.681534]  ? recalibrate_cpu_khz+0x10/0x10
[  179.683611]  ? ktime_get+0x33/0x90
[  179.685676]  __x64_sys_ioctl+0x338/0x720
[  179.687741]  ? fire_user_return_notifiers+0x3c/0x60
[  179.689829]  do_syscall_64+0x33/0x40
[  179.691909]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  179.693999] RIP: 0033:0x7f22e60cef6b
[  179.696081] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[  179.700547] RSP: 002b:00007f22e4b69608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  179.702836] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f22e60cef6b
[  179.705138] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
[  179.707447] RBP: 000055a81d11cf70 R08: 000055a81ac42ad8 R09: 00000000000000ff
[  179.709767] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  179.712099] R13: 00007f22e6c35001 R14: 0000000000000064 R15: 0000000000000000
[  179.714422] ---[ end trace 63d1ba11f1bc6183 ]---
[  179.720536] ------------[ cut here ]------------
[  179.722911] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.725273] Modules linked in: vhost_net vhost vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc nfs_ssc lzo zram zsmalloc cpufreq_powersave i915 kvm_intel video intel_gtt iosf_mbi kvm i2c_algo_bit drm_kms_helper bridge stp iTCO_wdt e1000e syscopyarea irqbypass sysfillrect 8250 evdev 8250_base serial_core sysimgblt lpc_ich mfd_core llc button acpi_cpufreq fb_sys_fops processor drm i2c_core sch_fq_codel backlight ip_tables x_tables ipv6 autofs4 btrfs blake2b_generic libcrc32c crc32c_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress raid6_pq ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid uhci_hcd ahci libahci pata_jmicron ehci_pci ehci_hcd sata_sil24 usbcore usb_common
[  179.737395] CPU: 0 PID: 369 Comm: qemu-build Tainted: G        W         5.10.2-1-amd64 #1
[  179.739880] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  179.742391] RIP: 0010:kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
[  179.744905] Code: 48 83 c4 18 4c 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 05 a0 6b 03 00 48 8d 50 01 48 83 f8 04 48 89 15 91 6b 03 00 77 b9 <0f> 0b eb b5 45 31 f6 eb cd 66 0f 1f 44 00 00 41 57 48 c7 c7 e0 23
[  179.750149] RSP: 0018:ffffab7e8069bb10 EFLAGS: 00010246
[  179.752776] RAX: 0000000000000004 RBX: ffff8fd62c589c78 RCX: 0000000000000000
[  179.755366] RDX: 0000000000000005 RSI: ffffffffffffffff RDI: 00003ba800a00478
[  179.757901] RBP: ffffab7e8073da78 R08: ffff8fd608d06800 R09: 000000000000000a
[  179.760388] R10: ffff8fd608d06800 R11: 000000000000000a R12: ffffab7e80735000
[  179.762832] R13: 0000000000000015 R14: 0000000000000015 R15: ffffab7e8069bb18
[  179.765216] FS:  00007f22e4b6a640(0000) GS:ffff8fd67f200000(0000) knlGS:ffffffff820e7ff0
[  179.767602] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.769976] CR2: 000009844cfd4620 CR3: 000000000a3c0000 CR4: 00000000000026f0
[  179.772351] Call Trace:
[  179.774657]  paging64_page_fault+0x244/0x8e0 [kvm]
[  179.776900]  ? kvm_fetch_guest_virt+0x7c/0xb0 [kvm]
[  179.779139]  kvm_mmu_page_fault+0x376/0x550 [kvm]
[  179.781357]  ? vmx_vmexit+0x1d/0x40 [kvm_intel]
[  179.783566]  ? vmx_vmexit+0x11/0x40 [kvm_intel]
[  179.785748]  ? vmx_vcpu_enter_exit+0x5c/0x90 [kvm_intel]
[  179.787928]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
[  179.790105]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
[  179.792254]  ? tick_sched_timer+0x69/0xf0
[  179.794377]  ? tick_nohz_handler+0xf0/0xf0
[  179.796478]  ? timerqueue_add+0x96/0xb0
[  179.798560]  ? __hrtimer_run_queues+0x151/0x1b0
[  179.800642]  ? recalibrate_cpu_khz+0x10/0x10
[  179.802724]  ? ktime_get+0x33/0x90
[  179.804800]  __x64_sys_ioctl+0x338/0x720
[  179.806872]  ? fire_user_return_notifiers+0x3c/0x60
[  179.808951]  do_syscall_64+0x33/0x40
[  179.811025]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  179.813123] RIP: 0033:0x7f22e60cef6b
[  179.815220] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[  179.819687] RSP: 002b:00007f22e4b69608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  179.821972] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f22e60cef6b
[  179.824277] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
[  179.826590] RBP: 000055a81d11cf70 R08: 000055a81ac42ad8 R09: 00000000000000ff
[  179.828911] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  179.831236] R13: 00007f22e6c35001 R14: 0000000000000064 R15: 0000000000000000
[  179.833563] ---[ end trace 63d1ba11f1bc6184 ]---
