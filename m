Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9447B252
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbhLTRrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 12:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhLTRrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 12:47:40 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EB1C061574
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 09:47:40 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t18so21606726wrg.11
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 09:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUe9BbLX1V2/2AlEorDn0vS4uwukoM8oE5Rl70mrdio=;
        b=AHKOVJ3vjTHDvGl9mkK5sKiUYRfOgte4nS8O4WPehzpiFzm0nVz2ZSQ1oXP2LN8bzI
         tnoi6a+zObxVdu1OLQ710LDeTFVExsAs54Z30WOBB9EMAYAX6Cgwe55aM90gLXmbSapb
         dmXxlyqVgJlvKVqwQ2jVUPRVy0D+4ZvTpYn94MLoIck3gSg0YyvWpjk0IphNwM36ho0D
         YXsZePZAdXI1S5BPTJESan1omJFceHmzrFwIRoromuBnEmYY1Iy615LGlh4OjtYhgAYC
         NFZ0vlVy2Gc5obQ/ZpQgD1HDIAhGygKU0yC3Bx5/Fiq9AVkiCuj/P56J56tw6G+7QU2F
         JZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUe9BbLX1V2/2AlEorDn0vS4uwukoM8oE5Rl70mrdio=;
        b=5I99gWdEYCX3QT9Ig2wcfFgWIiTrYONa4TZSIQ8OTXKDG75db0xPRPPWxu41lHMB9y
         At3RFJFfkVdpXCcjLYsily6Kyztep+ikI5nhYfat1s/fUqFg6+b5UJmetnOFclPsb9zC
         n8MDxzU4UgnfdTF0COJNbvKV+LDavMui25+DNGguJch05T+fPfNMxhN19IG9xjXu3yUh
         DUWuntsRgz3p7DyZWZmXMurpdssD9/HJcvzbmukpERz3d4vOyggYl2rQM1g7WnTTLqSQ
         cUfRkkCHWCmAOVE8OGuTai9ZKgHo4ZzWCZSSfft3VqzL7HdtF2J+HXIwb4pkwRQQRHqZ
         cw+g==
X-Gm-Message-State: AOAM532jpe9nHGFdFouamzusbXcYsUkvSAveRjpKiyM1bTRC1PcP5xZh
        7sdACaK74Gjm2nWUXAfLRnpBpD8sup0+0A==
X-Google-Smtp-Source: ABdhPJxdSqo2xmFAkTvgctOHSmzLXigddU1L4gexXrhUuMppeu8qHLiC7zdG1cfLuB7nM2d3o5hYvg==
X-Received: by 2002:a5d:634c:: with SMTP id b12mr13064859wrw.388.1640022458551;
        Mon, 20 Dec 2021 09:47:38 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id t17sm40187wmq.15.2021.12.20.09.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 09:47:38 -0800 (PST)
Date:   Mon, 20 Dec 2021 18:47:35 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Core2 oops with v5.16-rc5
Message-ID: <20211220184735.2e505055.zkaspar82@gmail.com>
In-Reply-To: <a0846396-7591-3c0a-a972-542dc41a28c7@redhat.com>
References: <20211218072732.2681bc87.zkaspar82@gmail.com>
        <a0846396-7591-3c0a-a972-542dc41a28c7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Dec 2021 19:38:08 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 12/18/21 07:27, Zdenek Kaspar wrote:
> > Hello, looks like a955cad84cdaffa282b3cf8f5ce69e9e5655e585 is
> > problematic with old Core2, when launching VM (openbsd smp):
> > 
> > Dec 17 22:40:28 merkur kernel: BUG: kernel NULL pointer
> > dereference, address: 0000000000000025 Dec 17 22:40:28 merkur
> > kernel: #PF: supervisor read access in kernel mode Dec 17 22:40:28
> > merkur kernel: #PF: error_code(0x0000) - not-present page Dec 17
> > 22:40:28 merkur kernel: PGD 0 P4D 0 Dec 17 22:40:28 merkur kernel:
> > Oops: 0000 [#1] PREEMPT SMP PTI Dec 17 22:40:28 merkur kernel: CPU:
> > 1 PID: 346 Comm: qemu-build Not tainted 5.16.0-rc5-amd64 #1 Dec 17
> > 22:40:28 merkur kernel: Hardware name:  /DG35EC, BIOS
> > ECG3510M.86A.0118.2010.0113.1426 01/13/2010 Dec 17 22:40:28 merkur
> > kernel: RIP: 0010:direct_page_fault+0x5f5/0x780 [kvm] Dec 17
> > 22:40:28 merkur kernel: Code: 71 80 c5 e3 48 8b 34 24 48 8b 86 a0
> > 02 00 00 48 8b 40 40 48 8b 0d 83 93 1f e4 48 c1 e8 06 48 83 e0 c0
> > 48 8b 4c 01 28 45 31 ed <f6> 41 25 08 48 8b 54 24 10 75 4a 48 8b 06
> > 80 79 20 00 75 0b 8a 49 Dec 17 22:40:28 merkur kernel: RSP:
> > 0018:ffffb9330055f9e0 EFLAGS: 00010246 Dec 17 22:40:28 merkur
> > kernel: RAX: 00000000000c5740 RBX: 0000000000000000 RCX:
> > 0000000000000000 Dec 17 22:40:28 merkur kernel: RDX:
> > 000000000000e6a1 RSI: ffffa38a4a810000 RDI: ffffb933005c5000 Dec 17
> > 22:40:28 merkur kernel: RBP: ffffb9330055fa48 R08: ffffb9330055f838
> > R09: 0000000000000000 Dec 17 22:40:28 merkur kernel: R10:
> > 0000000000000126 R11: 0000000000000003 R12: 0000000000000000 Dec 17
> > 22:40:28 merkur kernel: R13: 0000000000000000 R14: 00000000000fe05b
> > R15: 0000000000000001 Dec 17 22:40:28 merkur kernel: FS:
> > 00007f3bbd196640(0000) GS:ffffa38abf280000(0000)
> > knlGS:0000000000000000 Dec 17 22:40:28 merkur kernel: CS:  0010 DS:
> > 0000 ES: 0000 CR0: 0000000080050033 Dec 17 22:40:28 merkur kernel:
> > CR2: 0000000000000025 CR3: 0000000003c7c000 CR4: 00000000000026e0
> > Dec 17 22:40:28 merkur kernel: Call Trace: Dec 17 22:40:28 merkur
> > kernel:  <TASK> Dec 17 22:40:28 merkur kernel:
> > kvm_mmu_page_fault+0xe8/0x2c0 [kvm] Dec 17 22:40:28 merkur kernel:
> > vmx_handle_exit+0x9/0x40 [kvm_intel] Dec 17 22:40:28 merkur kernel:
> >  vcpu_enter_guest+0x1702/0x24a0 [kvm] Dec 17 22:40:28 merkur
> > kernel:  ? update_load_avg+0x188/0x4e0 Dec 17 22:40:28 merkur
> > kernel:  ? get_mem_cgroup_from_objcg+0x50/0x60 Dec 17 22:40:28
> > merkur kernel:  ? vmx_set_msr+0xa0b/0xc00 [kvm_intel] Dec 17
> > 22:40:28 merkur kernel:  ? kvm_set_msr_common+0x971/0xd10 [kvm] Dec
> > 17 22:40:28 merkur kernel:  ? kvm_arch_vcpu_ioctl+0xc77/0xf00 [kvm]
> > Dec 17 22:40:28 merkur kernel:  ? vmx_vcpu_put+0x10/0x1d0
> > [kvm_intel] Dec 17 22:40:28 merkur kernel:  ?
> > vmx_vcpu_load+0x18/0x30 [kvm_intel] Dec 17 22:40:28 merkur kernel:
> > ? kvm_arch_vcpu_put+0xf6/0x110 [kvm] Dec 17 22:40:28 merkur kernel:
> >  ? vcpu_put+0x1c/0x40 [kvm] Dec 17 22:40:28 merkur kernel:  ?
> > kvm_arch_vcpu_ioctl+0xca1/0xf00 [kvm] Dec 17 22:40:28 merkur
> > kernel:  ? vmx_vcpu_load+0x18/0x30 [kvm_intel] Dec 17 22:40:28
> > merkur kernel:  vcpu_run+0x6f/0x310 [kvm] Dec 17 22:40:28 merkur
> > kernel:  kvm_arch_vcpu_ioctl_run+0x317/0x4c0 [kvm] Dec 17 22:40:28
> > merkur kernel:  kvm_vcpu_ioctl+0x490/0x520 [kvm] Dec 17 22:40:28
> > merkur kernel:  ? wake_up_q+0x41/0x80 Dec 17 22:40:28 merkur
> > kernel:  ? __fget_files+0xd8/0xf0 Dec 17 22:40:28 merkur kernel:
> > __x64_sys_ioctl+0xc10/0xd00 Dec 17 22:40:28 merkur kernel:  ?
> > do_futex+0x118/0x1c0 Dec 17 22:40:28 merkur kernel:  ?
> > __x64_sys_futex+0x125/0x190 Dec 17 22:40:28 merkur kernel:
> > do_syscall_64+0x43/0x90 Dec 17 22:40:28 merkur kernel:
> > entry_SYSCALL_64_after_hwframe+0x44/0xae Dec 17 22:40:28 merkur
> > kernel: RIP: 0033:0x7f3bbe9d559b Dec 17 22:40:28 merkur kernel:
> > Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41
> > 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05
> > <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a5 a8 0c 00 f7 d8 64 89 01 48
> > Dec 17 22:40:28 merkur kernel: RSP: 002b:00007f3bbd1955b8 EFLAGS:
> > 00000246 ORIG_RAX: 0000000000000010 Dec 17 22:40:28 merkur kernel:
> > RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f3bbe9d559b
> > Dec 17 22:40:28 merkur kernel: RDX: 0000000000000000 RSI:
> > 000000000000ae80 RDI: 0000000000000012 Dec 17 22:40:28 merkur
> > kernel: RBP: 000055fd828fa860 R08: 000055fd8104af58 R09:
> > 00007f3b700040b8 Dec 17 22:40:28 merkur kernel: R10:
> > 0000000000000100 R11: 0000000000000246 R12: 0000000000000000 Dec 17
> > 22:40:28 merkur kernel: R13: 000055fd8108eb78 R14: 0000000000000000
> > R15: 00007f3bbd196640 Dec 17 22:40:28 merkur kernel:  </TASK> Dec
> > 17 22:40:28 merkur kernel: Modules linked in: vhost_net vhost
> > vhost_iotlb tun auth_rpcgss nfsv4 dns_resolver nfs lockd grace
> > sunrpc lzo_rle zram zsmalloc cpufreq_powersave i915 kvm_intel video
> > intel_gtt iosf_mbi bridge ttm e1000e i2c_algo_bit iTCO_wdt 8250 kvm
> > 8250_base drm_kms_helper serial_core lpc_ich stp irqbypass mfd_core
> > evdev llc sysimgblt syscopyarea sysfillrect acpi_cpufreq button
> > processor fb_sys_fops drm backlight i2c_core sch_fq_codel ip_tables
> > x_tables ipv6 autofs4 btrfs raid6_pq xor zstd_decompress
> > zstd_compress lzo_decompress lzo_compress libcrc32c crc32c_generic
> > ecb xts dm_crypt dm_mod sd_mod t10_pi hid_generic usbhid hid
> > uhci_hcd ahci libahci ehci_pci ehci_hcd usbcore pata_jmicron
> > sata_sil24 usb_common Dec 17 22:40:28 merkur kernel: CR2:
> > 0000000000000025 Dec 17 22:40:28 merkur kernel: ---[ end trace
> > 1e1aaa4a15aaeb25 ]--- Dec 17 22:40:28 merkur kernel: RIP:
> > 0010:direct_page_fault+0x5f5/0x780 [kvm] Dec 17 22:40:28 merkur
> > kernel: Code: 71 80 c5 e3 48 8b 34 24 48 8b 86 a0 02 00 00 48 8b 40
> > 40 48 8b 0d 83 93 1f e4 48 c1 e8 06 48 83 e0 c0 48 8b 4c 01 28 45
> > 31 ed <f6> 41 25 08 48 8b 54 24 10 75 4a 48 8b 06 80 79 20 00 75 0b
> > 8a 49 Dec 17 22:40:28 merkur kernel: RSP: 0018:ffffb9330055f9e0
> > EFLAGS: 00010246 Dec 17 22:40:28 merkur kernel: RAX:
> > 00000000000c5740 RBX: 0000000000000000 RCX: 0000000000000000 Dec 17
> > 22:40:28 merkur kernel: RDX: 000000000000e6a1 RSI: ffffa38a4a810000
> > RDI: ffffb933005c5000 Dec 17 22:40:28 merkur kernel: RBP:
> > ffffb9330055fa48 R08: ffffb9330055f838 R09: 0000000000000000 Dec 17
> > 22:40:28 merkur kernel: R10: 0000000000000126 R11: 0000000000000003
> > R12: 0000000000000000 Dec 17 22:40:28 merkur kernel: R13:
> > 0000000000000000 R14: 00000000000fe05b R15: 0000000000000001 Dec 17
> > 22:40:28 merkur kernel: FS:  00007f3bbd196640(0000)
> > GS:ffffa38abf280000(0000) knlGS:0000000000000000 Dec 17 22:40:28
> > merkur kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Dec 17 22:40:28 merkur kernel: CR2: 0000000000000025 CR3:
> > 0000000003c7c000 CR4: 00000000000026e0 Dec 17 22:40:28 merkur
> > kernel: note: qemu-build[346] exited with preempt_count 1
> > 
> > model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> > pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe
> > syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> > cpuid aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16
> > xtpr pdcm lahf_lm pti tpr_shadow dtherm vmx flags       :
> > tsc_offset vtpr
> 
> Hi, this will be fixed in the next rc.
> 
> Thanks,
> 
> Paolo

Hi, v5.16-rc6 works fine, thanks!

Z.
