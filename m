Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BD5518990
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiECQYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239343AbiECQYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 12:24:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9311D0CF
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 09:20:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d25so2274522pfo.10
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 09:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zMlVmOD8v87YhQTWLz1JEO+FkcC/kzpw1ZUlAX3IBB4=;
        b=B0Wm+hRzfeHknzrl2fgVwuPVLbQQhs5kTGiYAvnE8TXnbv9sMNNxs6gyQFnW8XGrdh
         XxwV2trFnVqf0SJcWQKybZxdvMe2LT6naIE2HUyaDn+8NzeAS42fpN/HaFh2qBeFS6gN
         PZ5xONXAOvMyr7dskAnfQ+iM9q5WRbJHXD3V43Gv0AKs8tKYgO6rRPCgb4JaXeATOEyF
         lgFjg7/WqSyRGoJjzIAWHOxL/aVApy2hBXv9dL/LnZrQQSotHR9kOUzNtV5I5cle1/U5
         DO9cXx/i6AQEV5ovGFXGhUKhu6eYxn/TylaJcOhnbjGktkDdCKmgqPGQnnXkf7KtHfch
         85WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zMlVmOD8v87YhQTWLz1JEO+FkcC/kzpw1ZUlAX3IBB4=;
        b=JcDvuiJoOonDg68VYzmcB/6dFPOAIZpIE2XfYs+UtBd+AlewOKENb5MLVrVM8PG0m8
         iM0Jax6w5vow/psWedmlfzaKs73QaeIzwsTAg53O8dAYhoqdihzwm9oyE4kHVsWfxxQ8
         TSr9PpRwrK922uZa5/QkC8SEbngNHLuT4WVcReUyEKP96tgM0qjuhSfpeAE5VVdpGHBt
         dRRyLFqvq3OJmdHTCq+CQzU7GZqw+6E87+T59gzjqXnBXr0MDn68l6SXp7GAQ7iHsQ6M
         ddzXM8dEzp5uc3cWZONAyIJlczE8EAGTifcCOyqYJ/JCzOvNAUQ//rqp8jHBolhIXOB5
         rLog==
X-Gm-Message-State: AOAM532JtS0fWQrjVPlkGvlASYzeeh5rTijJnyZbu91de2S+160Xftly
        NoXLzSrYKZCBQpU9XpTqRug0G+0JWcEYAQ==
X-Google-Smtp-Source: ABdhPJy8IjE3j0FquGQQZ+LP7+swhjT+nyDwrGk1kJJoy7kHImprWokAv7pOAK6wb9bl/6eGf3BGNg==
X-Received: by 2002:a63:6c42:0:b0:3ab:7c9c:1faf with SMTP id h63-20020a636c42000000b003ab7c9c1fafmr14764529pgc.518.1651594836245;
        Tue, 03 May 2022 09:20:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a1709027c9000b0015e8d4eb26bsm6536984pll.181.2022.05.03.09.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:20:35 -0700 (PDT)
Date:   Tue, 3 May 2022 16:20:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Core2 and v5.18-rc5 troubles
Message-ID: <YnFWT+OdBAOPpZfi@google.com>
References: <20220502022959.18aafe13.zkaspar82@gmail.com>
 <20220502190010.7ff820e3.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502190010.7ff820e3.zkaspar82@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022, Zdenek Kaspar wrote:
> On Mon, 2 May 2022 02:29:59 +0200
> Zdenek Kaspar <zkaspar82@gmail.com> wrote:
> 
> > Hi, when I noticed fix for pre-EPYC and older Intel hardware I checked
> > v5.18-rc5 on my old Core2 machine and something else fails here.
> > 
> > When I kill -9 the first qemu attempt (see dmesg-1), then next
> > attempt is OK, after successful VM shutdown another attempt fails
> > again (see dmesg-2). After that it takes some time and machine needs
> > reset (see dmesg-3).
> > 
> > HTH, Z.
> 
> Oh crap, I had auto-applied mglru patch, sorry...
> Now starting qemu does this:
> 
> 20 root      20   0   0.0m R 100.0   0.0   0:28.33 kworker/1:0+rcu_gp
> looks like:  94.36%  [kernel]                  [k] delay_tsc
> kill -9 "qemu process" and noticed several D state processes:
>     107 ?        D      0:04 [kworker/u8:7+events_unbound]
>     108 ?        D      0:03 [kworker/u8:8+events_unbound]
>     632 ?        Ds     0:00 /usr/lib/systemd/systemd-journald
> 
> machine is trashed, here's dmesg info:
> 
> [  172.349282] BUG: kernel NULL pointer dereference, address: 000000000000000b
> [  172.349324] #PF: supervisor write access in kernel mode
> [  172.349345] #PF: error_code(0x0002) - not-present page
> [  172.349363] PGD 0 P4D 0 
> [  172.349375] Oops: 0002 [#1] PREEMPT SMP PTI
> [  172.349393] CPU: 0 PID: 626 Comm: qemu-build Not tainted 5.18.0-rc5-2-amd64 #1
> [  172.349420] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
> [  172.349446] RIP: 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm]
> [  172.349496] Code: ac 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44

...

> [  172.349772] Call Trace:
> [  172.349785]  <TASK>
> [  172.349795]  kvm_set_memslot+0x3a8/0x5e0 [kvm]

My kernel build doesn't match exactly, but it's pretty close, and this call points
to the kvm_activate_memslot() call in the kvm_prepare_memory_region() error path.

	r = kvm_prepare_memory_region(kvm, old, new, change);
	if (r) {
		/*
		 * For DELETE/MOVE, revert the above INVALID change.  No
		 * modifications required since the original slot was preserved
		 * in the inactive slots.  Changing the active memslots also
		 * release slots_arch_lock.
		 */
		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
			kvm_activate_memslot(kvm, invalid_slot, old);
			kfree(invalid_slot);
		} else {
			mutex_unlock(&kvm->slots_arch_lock);
		}
		return r;
	}

What I can't figure out is how that can result in a NULL pointer dereference.  The
the faulting instruction is

	mov rcx, [rdx + 8]

which appears to be

	WRITE_ONCE(*pprev, next);

in __hlist_del() from hlist_del().

	if (!hlist_unhashed(n)) {
		__hlist_del(n);
		INIT_HLIST_NODE(n);
	}

which comes from 

	hash_del(&old->id_node[idx]);

so the fault on 0xb means the pointer is '3'.  "old" is zero allocated, and idx
comes from slots->node_idx, which is effectively a constant '0' or '1'.

I can't see any way for "old" to be '3.  Even more confusing is that that would
imply kvm_prepare_memory_region() failed on a DELETE action, which should be
impossible.

I've tried hitting every edge case of this flow I can think of and haven't been
able to reproduce the behavior, e.g. triggering the new error path introduced by
commit 86931ff7207b ("KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
host.MAXPHYADDR") is handled cleanly.  Furthermore, AFAIK QEMU doesn't MOVE slots,
so that path seems highly unlikely.

The other relevant datapoint is that fsnotify() hits a very similar NULL pointer
shortly after KVM's explosion, that one directly on address '3'.  That suggests
there's data corruption of some form going on, and KVM just happens to be the first
to be encounter a bad pointer.

Have you tried bisecting?  And/or can you provide your kernel config?  Maybe there's
a debug/sanitizer option that's causing problems.

> [  172.349837]  kvm_set_memory_region+0x22/0x40 [kvm]
> [  172.349879]  kvm_vm_ioctl+0x44d/0x500 [kvm]
> [  172.349920]  ? __fget_files+0x8d/0xa0
> [  172.349940]  __x64_sys_ioctl+0xbf3/0xce0
> [  172.349957]  ? do_user_addr_fault+0x280/0x3c0
> [  172.349977]  ? asm_exc_page_fault+0x5/0x20
> [  172.349995]  do_syscall_64+0x31/0x50
> [  172.350011]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  172.350032] RIP: 0033:0x7fdf1a8cee6f
> [  172.350046] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
> [  172.350105] RSP: 002b:00007fdf1900df70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  172.350131] RAX: ffffffffffffffda RBX: 000000004020ae46 RCX: 00007fdf1a8cee6f
> [  172.350156] RDX: 00007fdf1900e110 RSI: 000000004020ae46 RDI: 000000000000000d
> [  172.350180] RBP: 000055d7a44e7280 R08: 0000000000000000 R09: 0000000000000000
> [  172.350204] R10: 00000000000c0000 R11: 0000000000000246 R12: 00007fdf1900e110
> [  172.350228] R13: 000000003ff40000 R14: 000055d7a4418ee0 R15: 00000000000c0000
> [  172.350254]  </TASK>
> [  172.350262] Modules linked in: vhost_net vhost vhost_iotlb tun nfsd ksmbd cifs_arc4 xfs nhpoly1305_sse2 nhpoly1305 chacha_generic chacha_x86_64 libchacha adiantum libpoly1305 algif_skcipher af_alg auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc lzo_rle zram zsmalloc cpufreq_powersave i915 kvm_intel video 8250 drm_buddy intel_gtt iosf_mbi kvm 8250_base ttm bridge serial_core i2c_algo_bit drm_dp_helper e1000e drm_kms_helper iTCO_wdt irqbypass lpc_ich sysimgblt syscopyarea mfd_core stp sysfillrect acpi_cpufreq evdev fb_sys_fops processor button llc drm sch_fq_codel backlight i2c_core ip_tables x_tables ipv6 autofs4 btrfs raid6_pq xor zstd_decompress zstd_compress lzo_decompress lzo_compress libcrc32c crc32c_generic xts ecb hid_generic usbhid hid dm_crypt dm_mod sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 uhci_hcd ehci_pci ahci ehci_hcd libahci usbcore pata_jmicron sata_sil24 usb_common
> [  172.350624] CR2: 000000000000000b
> [  172.352202] ---[ end trace 0000000000000000 ]---
> [  172.353793] RIP: 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm]
> [  172.355383] Code: ac 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44
> [  172.358667] RSP: 0018:ffffb0740064fd78 EFLAGS: 00010206
> [  172.360335] RAX: ffff9e9b41240e00 RBX: ffffb07401271000 RCX: ffffb07401271388
> [  172.362025] RDX: 0000000000000003 RSI: ffff9e9b41240e00 RDI: ffffb07401271000
> [  172.363723] RBP: 0000000000000000 R08: 000000000016000e R09: 000000000016000d
> [  172.365430] R10: ffffd73680764d00 R11: ffff9e9bbf226a78 R12: 0000000000000000
> [  172.367147] R13: ffffb07401271480 R14: ffff9e9b41240e00 R15: 0000000000000000
> [  172.368856] FS:  00007fdf1900f640(0000) GS:ffff9e9bbf200000(0000) knlGS:0000000000000000
> [  172.370574] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  172.372295] CR2: 000000000000000b CR3: 0000000003626000 CR4: 00000000000026f0
> [  172.672682] BUG: kernel NULL pointer dereference, address: 0000000000000003
> [  172.674427] #PF: supervisor read access in kernel mode
> [  172.676176] #PF: error_code(0x0000) - not-present page
> [  172.677931] PGD 0 P4D 0 
> [  172.679677] Oops: 0000 [#2] PREEMPT SMP PTI
> [  172.681421] CPU: 1 PID: 200 Comm: systemd-journal Tainted: G      D           5.18.0-rc5-2-amd64 #1
> [  172.683186] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
> [  172.684955] RIP: 0010:fsnotify+0x5b5/0x980
> [  172.686722] Code: 40 a8 10 74 13 48 8b 74 24 30 48 85 f6 74 09 4c 8b 6e 08 0b 16 0b 4e 40 f7 d1 23 4c 24 08 85 d1 0f 84 7f 02 00 00 49 8b 4d 00 <4c> 8b 19 4d 85 db 74 53 4c 89 ef 44 89 fe 48 8b 14 24 8b 4c 24 0c
> [  172.690438] RSP: 0018:ffffb074001afd28 EFLAGS: 00010202
> [  172.692310] RAX: 0000000000000008 RBX: 0000000000000000 RCX: 0000000000000003
> [  172.694141] RDX: 0000000008002fc6 RSI: ffff9e9b420acd70 RDI: ffff9e9b41297e00
> [  172.695920] RBP: ffff9e9b41297e00 R08: ffff9e9b4117e800 R09: ffff9e9b46068ed8
> [  172.697702] R10: 0000000000000000 R11: ffffffffa81914b0 R12: 0000000000000000
> [  172.699486] R13: ffff9e9b41297e00 R14: ffff9e9b46068ed8 R15: 0000000008000002
> [  172.701267] FS:  00007ff7ff68ee80(0000) GS:ffff9e9bbf280000(0000) knlGS:0000000000000000
> [  172.703050] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  172.704829] CR2: 0000000000000003 CR3: 0000000003ca8000 CR4: 00000000000026e0
> [  172.706618] Call Trace:
> [  172.708396]  <TASK>
> [  172.710149]  __fsnotify_parent+0x1f9/0x240
> [  172.711896]  ? shmem_setattr+0x172/0x1b0
> [  172.713628]  notify_change+0x3f0/0x410
> [  172.715363]  do_sys_ftruncate+0x121/0x1e0
> [  172.717103]  do_syscall_64+0x31/0x50
> [  172.718838]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  172.720580] RIP: 0033:0x7ff80008932b
> [  172.722315] Code: 77 05 c3 0f 1f 40 00 48 8b 15 69 fa 0e 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 39 fa 0e 00 f7 d8
> [  172.726019] RSP: 002b:00007ffc04a998b8 EFLAGS: 00000206 ORIG_RAX: 000000000000004d
> [  172.727913] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ff80008932b
> [  172.729821] RDX: 00005633275d43f0 RSI: 0000000000080000 RDI: 0000000000000013
> [  172.731736] RBP: 00007ffc04a99950 R08: 0000000000000001 R09: 00005633275de0ac
> [  172.733658] R10: 0000000000000010 R11: 0000000000000206 R12: 00005633275ce270
> [  172.735522] R13: 00007ffc04a998f8 R14: 00007ffc04a99900 R15: 0000000000000000
> [  172.737335]  </TASK>
> [  172.739122] Modules linked in: vhost_net vhost vhost_iotlb tun nfsd ksmbd cifs_arc4 xfs nhpoly1305_sse2 nhpoly1305 chacha_generic chacha_x86_64 libchacha adiantum libpoly1305 algif_skcipher af_alg auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc lzo_rle zram zsmalloc cpufreq_powersave i915 kvm_intel video 8250 drm_buddy intel_gtt iosf_mbi kvm 8250_base ttm bridge serial_core i2c_algo_bit drm_dp_helper e1000e drm_kms_helper iTCO_wdt irqbypass lpc_ich sysimgblt syscopyarea mfd_core stp sysfillrect acpi_cpufreq evdev fb_sys_fops processor button llc drm sch_fq_codel backlight i2c_core ip_tables x_tables ipv6 autofs4 btrfs raid6_pq xor zstd_decompress zstd_compress lzo_decompress lzo_compress libcrc32c crc32c_generic xts ecb hid_generic usbhid hid dm_crypt dm_mod sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 uhci_hcd ehci_pci ahci ehci_hcd libahci usbcore pata_jmicron sata_sil24 usb_common
> [  172.750745] CR2: 0000000000000003
> [  172.752725] ---[ end trace 0000000000000000 ]---
> [  172.754640] RIP: 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm]
> [  172.756555] Code: ac 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44
> [  172.760417] RSP: 0018:ffffb0740064fd78 EFLAGS: 00010206
> [  172.762329] RAX: ffff9e9b41240e00 RBX: ffffb07401271000 RCX: ffffb07401271388
> [  172.764240] RDX: 0000000000000003 RSI: ffff9e9b41240e00 RDI: ffffb07401271000
> [  172.766173] RBP: 0000000000000000 R08: 000000000016000e R09: 000000000016000d
> [  172.768099] R10: ffffd73680764d00 R11: ffff9e9bbf226a78 R12: 0000000000000000
> [  172.769975] R13: ffffb07401271480 R14: ffff9e9b41240e00 R15: 0000000000000000
> [  172.771790] FS:  00007ff7ff68ee80(0000) GS:ffff9e9bbf200000(0000) knlGS:0000000000000000
> [  172.773618] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  172.775443] CR2: 000000000000000b CR3: 0000000003ca8000 CR4: 00000000000026f0
> 
