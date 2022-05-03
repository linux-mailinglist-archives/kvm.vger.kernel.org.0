Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CC6518FB8
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 23:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiECVLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 17:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiECVLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 17:11:08 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E18F255A8
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 14:07:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b19so24894184wrh.11
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 14:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4386nhCG8b+OYpfR8xWqlkN6rFfWgvDtKxlbU3KWMfE=;
        b=mFUcF+RPp8YNmGJTHiZJMK1AIqvcAmga4fcNAokT0YKBB6UL1fo9Sk5gItbWuUCIJD
         WGmNgWks4bDcua6yWSB0Gqedha0xDSig9blf+K2SwCRNjNS5CaZ7cSzuC4tf1qj4llUx
         JkV/2ZJ5nWgUj/xR3vYtEIiHnpmxqTvSLj1Fcrz0YTr9Kl9ct9Rz/+AmItCEvvI1au1u
         NVaS0cpxYJbwaNucLWpQpIKNBwga2MACBNTAqcwrceBso91v6hqCxMr+etsw1LhvYT0i
         ygoM+XVLtqncIC3oaoudyBLf0ubD7VDckK2ow61yjL/d94D8dRQVxtkeMquh2Vqz8PPA
         QfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4386nhCG8b+OYpfR8xWqlkN6rFfWgvDtKxlbU3KWMfE=;
        b=DnLjM5z9WfuL06RUDIof0TO6BROtRZU22xMwD1uttxhEoASkWrh19HaPOOX2yQ58xb
         veR7XrfXJc/BEsWu0DtcJu5jxnM1lgOVygiMhk+rTPhoQSSWfbOJf0yAJMCInR3lsBnk
         P9IXe7SId6uvwWMwjyiMnDArQhbqYujMaCAfDjMv7gAQugeVXIKuTfDWexqiIA23Ck/D
         vlYgGX4jrKmPpRUBAXbHqAapcP8ecSgn2gHXB4oZ9yRUmvvpO+D2MB5+8tRFHxwbBmyZ
         JKbVoIk8EQ81m5VyNIGq4YnN8bu8v2LtqTr15S2kjxI+xhZYtuSeff4lhl4PNqupuNxx
         bKCw==
X-Gm-Message-State: AOAM531E1i/VU+SSxNFM/IGIrAD96gWkEmm0Fx0ePMumiazq4VvqLu6w
        OcKzf7V0PNP9J459CNBLLsTAC1W73U3tsQ==
X-Google-Smtp-Source: ABdhPJyiOBksz/t4LZWz3uCWqzmXo5VCunfUfXr66Ld9bANFQzKvQuDTFenzVwxF7LtZTj5JOe35uQ==
X-Received: by 2002:a5d:5547:0:b0:20c:7a44:d8e7 with SMTP id g7-20020a5d5547000000b0020c7a44d8e7mr2526224wrw.349.1651612051635;
        Tue, 03 May 2022 14:07:31 -0700 (PDT)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id y16-20020adfc7d0000000b0020adc114136sm13101822wrg.0.2022.05.03.14.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 14:07:30 -0700 (PDT)
Date:   Tue, 3 May 2022 23:07:27 +0200
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Core2 and v5.18-rc5 troubles
Message-ID: <20220503230727.54476050.zkaspar82@gmail.com>
In-Reply-To: <YnFWT+OdBAOPpZfi@google.com>
References: <20220502022959.18aafe13.zkaspar82@gmail.com>
        <20220502190010.7ff820e3.zkaspar82@gmail.com>
        <YnFWT+OdBAOPpZfi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 May 2022 16:20:31 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, May 02, 2022, Zdenek Kaspar wrote:
> > On Mon, 2 May 2022 02:29:59 +0200
> > Zdenek Kaspar <zkaspar82@gmail.com> wrote:
> > 
> > > Hi, when I noticed fix for pre-EPYC and older Intel hardware I
> > > checked v5.18-rc5 on my old Core2 machine and something else
> > > fails here.
> > > 
> > > When I kill -9 the first qemu attempt (see dmesg-1), then next
> > > attempt is OK, after successful VM shutdown another attempt fails
> > > again (see dmesg-2). After that it takes some time and machine
> > > needs reset (see dmesg-3).
> > > 
> > > HTH, Z.
> > 
> > Oh crap, I had auto-applied mglru patch, sorry...
> > Now starting qemu does this:
> > 
> > 20 root      20   0   0.0m R 100.0   0.0   0:28.33
> > kworker/1:0+rcu_gp looks like:  94.36%  [kernel]
> > [k] delay_tsc kill -9 "qemu process" and noticed several D state
> > processes: 107 ?        D      0:04 [kworker/u8:7+events_unbound]
> >     108 ?        D      0:03 [kworker/u8:8+events_unbound]
> >     632 ?        Ds     0:00 /usr/lib/systemd/systemd-journald
> > 
> > machine is trashed, here's dmesg info:
> > 
> > [  172.349282] BUG: kernel NULL pointer dereference, address:
> > 000000000000000b [  172.349324] #PF: supervisor write access in
> > kernel mode [  172.349345] #PF: error_code(0x0002) - not-present
> > page [  172.349363] PGD 0 P4D 0 
> > [  172.349375] Oops: 0002 [#1] PREEMPT SMP PTI
> > [  172.349393] CPU: 0 PID: 626 Comm: qemu-build Not tainted
> > 5.18.0-rc5-2-amd64 #1 [  172.349420] Hardware name:  /DG35EC, BIOS
> > ECG3510M.86A.0118.2010.0113.1426 01/13/2010 [  172.349446] RIP:
> > 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm] [  172.349496] Code: ac
> > 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08
> > 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a
> > 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44
> 
> ...
> 
> > [  172.349772] Call Trace:
> > [  172.349785]  <TASK>
> > [  172.349795]  kvm_set_memslot+0x3a8/0x5e0 [kvm]
> 
> My kernel build doesn't match exactly, but it's pretty close, and
> this call points to the kvm_activate_memslot() call in the
> kvm_prepare_memory_region() error path.
> 
> 	r = kvm_prepare_memory_region(kvm, old, new, change);
> 	if (r) {
> 		/*
> 		 * For DELETE/MOVE, revert the above INVALID change.
> No
> 		 * modifications required since the original slot was
> preserved
> 		 * in the inactive slots.  Changing the active
> memslots also
> 		 * release slots_arch_lock.
> 		 */
> 		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> { kvm_activate_memslot(kvm, invalid_slot, old);
> 			kfree(invalid_slot);
> 		} else {
> 			mutex_unlock(&kvm->slots_arch_lock);
> 		}
> 		return r;
> 	}
> 
> What I can't figure out is how that can result in a NULL pointer
> dereference.  The the faulting instruction is
> 
> 	mov rcx, [rdx + 8]
> 
> which appears to be
> 
> 	WRITE_ONCE(*pprev, next);
> 
> in __hlist_del() from hlist_del().
> 
> 	if (!hlist_unhashed(n)) {
> 		__hlist_del(n);
> 		INIT_HLIST_NODE(n);
> 	}
> 
> which comes from 
> 
> 	hash_del(&old->id_node[idx]);
> 
> so the fault on 0xb means the pointer is '3'.  "old" is zero
> allocated, and idx comes from slots->node_idx, which is effectively a
> constant '0' or '1'.
> 
> I can't see any way for "old" to be '3.  Even more confusing is that
> that would imply kvm_prepare_memory_region() failed on a DELETE
> action, which should be impossible.
> 
> I've tried hitting every edge case of this flow I can think of and
> haven't been able to reproduce the behavior, e.g. triggering the new
> error path introduced by commit 86931ff7207b ("KVM: x86/mmu: Do not
> create SPTEs for GFNs that exceed host.MAXPHYADDR") is handled
> cleanly.  Furthermore, AFAIK QEMU doesn't MOVE slots, so that path
> seems highly unlikely.
> 
> The other relevant datapoint is that fsnotify() hits a very similar
> NULL pointer shortly after KVM's explosion, that one directly on
> address '3'.  That suggests there's data corruption of some form
> going on, and KVM just happens to be the first to be encounter a bad
> pointer.
> 
> Have you tried bisecting?  And/or can you provide your kernel config?
>  Maybe there's a debug/sanitizer option that's causing problems.
> 
> > [  172.349837]  kvm_set_memory_region+0x22/0x40 [kvm]
> > [  172.349879]  kvm_vm_ioctl+0x44d/0x500 [kvm]
> > [  172.349920]  ? __fget_files+0x8d/0xa0
> > [  172.349940]  __x64_sys_ioctl+0xbf3/0xce0
> > [  172.349957]  ? do_user_addr_fault+0x280/0x3c0
> > [  172.349977]  ? asm_exc_page_fault+0x5/0x20
> > [  172.349995]  do_syscall_64+0x31/0x50
> > [  172.350011]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [  172.350032] RIP: 0033:0x7fdf1a8cee6f
> > [  172.350046] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04
> > 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10
> > 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48
> > 2b 04 25 28 00 [  172.350105] RSP: 002b:00007fdf1900df70 EFLAGS:
> > 00000246 ORIG_RAX: 0000000000000010 [  172.350131] RAX:
> > ffffffffffffffda RBX: 000000004020ae46 RCX: 00007fdf1a8cee6f [
> > 172.350156] RDX: 00007fdf1900e110 RSI: 000000004020ae46 RDI:
> > 000000000000000d [  172.350180] RBP: 000055d7a44e7280 R08:
> > 0000000000000000 R09: 0000000000000000 [  172.350204] R10:
> > 00000000000c0000 R11: 0000000000000246 R12: 00007fdf1900e110 [
> > 172.350228] R13: 000000003ff40000 R14: 000055d7a4418ee0 R15:
> > 00000000000c0000 [  172.350254]  </TASK> [  172.350262] Modules
> > linked in: vhost_net vhost vhost_iotlb tun nfsd ksmbd cifs_arc4 xfs
> > nhpoly1305_sse2 nhpoly1305 chacha_generic chacha_x86_64 libchacha
> > adiantum libpoly1305 algif_skcipher af_alg auth_rpcgss nfsv4
> > dns_resolver nfs lockd grace sunrpc lzo_rle zram zsmalloc
> > cpufreq_powersave i915 kvm_intel video 8250 drm_buddy intel_gtt
> > iosf_mbi kvm 8250_base ttm bridge serial_core i2c_algo_bit
> > drm_dp_helper e1000e drm_kms_helper iTCO_wdt irqbypass lpc_ich
> > sysimgblt syscopyarea mfd_core stp sysfillrect acpi_cpufreq evdev
> > fb_sys_fops processor button llc drm sch_fq_codel backlight
> > i2c_core ip_tables x_tables ipv6 autofs4 btrfs raid6_pq xor
> > zstd_decompress zstd_compress lzo_decompress lzo_compress libcrc32c
> > crc32c_generic xts ecb hid_generic usbhid hid dm_crypt dm_mod
> > sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 uhci_hcd
> > ehci_pci ahci ehci_hcd libahci usbcore pata_jmicron sata_sil24
> > usb_common [  172.350624] CR2: 000000000000000b [  172.352202] ---[
> > end trace 0000000000000000 ]--- [  172.353793] RIP:
> > 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm] [  172.355383] Code: ac
> > 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08
> > 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a
> > 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44 [
> > 172.358667] RSP: 0018:ffffb0740064fd78 EFLAGS: 00010206 [
> > 172.360335] RAX: ffff9e9b41240e00 RBX: ffffb07401271000 RCX:
> > ffffb07401271388 [  172.362025] RDX: 0000000000000003 RSI:
> > ffff9e9b41240e00 RDI: ffffb07401271000 [  172.363723] RBP:
> > 0000000000000000 R08: 000000000016000e R09: 000000000016000d [
> > 172.365430] R10: ffffd73680764d00 R11: ffff9e9bbf226a78 R12:
> > 0000000000000000 [  172.367147] R13: ffffb07401271480 R14:
> > ffff9e9b41240e00 R15: 0000000000000000 [  172.368856] FS:
> > 00007fdf1900f640(0000) GS:ffff9e9bbf200000(0000)
> > knlGS:0000000000000000 [  172.370574] CS:  0010 DS: 0000 ES: 0000
> > CR0: 0000000080050033 [  172.372295] CR2: 000000000000000b CR3:
> > 0000000003626000 CR4: 00000000000026f0 [  172.672682] BUG: kernel
> > NULL pointer dereference, address: 0000000000000003 [  172.674427]
> > #PF: supervisor read access in kernel mode [  172.676176] #PF:
> > error_code(0x0000) - not-present page [  172.677931] PGD 0 P4D 0 [
> > 172.679677] Oops: 0000 [#2] PREEMPT SMP PTI [  172.681421] CPU: 1
> > PID: 200 Comm: systemd-journal Tainted: G      D
> > 5.18.0-rc5-2-amd64 #1 [  172.683186] Hardware name:  /DG35EC, BIOS
> > ECG3510M.86A.0118.2010.0113.1426 01/13/2010 [  172.684955] RIP:
> > 0010:fsnotify+0x5b5/0x980 [  172.686722] Code: 40 a8 10 74 13 48 8b
> > 74 24 30 48 85 f6 74 09 4c 8b 6e 08 0b 16 0b 4e 40 f7 d1 23 4c 24
> > 08 85 d1 0f 84 7f 02 00 00 49 8b 4d 00 <4c> 8b 19 4d 85 db 74 53 4c
> > 89 ef 44 89 fe 48 8b 14 24 8b 4c 24 0c [  172.690438] RSP:
> > 0018:ffffb074001afd28 EFLAGS: 00010202 [  172.692310] RAX:
> > 0000000000000008 RBX: 0000000000000000 RCX: 0000000000000003 [
> > 172.694141] RDX: 0000000008002fc6 RSI: ffff9e9b420acd70 RDI:
> > ffff9e9b41297e00 [  172.695920] RBP: ffff9e9b41297e00 R08:
> > ffff9e9b4117e800 R09: ffff9e9b46068ed8 [  172.697702] R10:
> > 0000000000000000 R11: ffffffffa81914b0 R12: 0000000000000000 [
> > 172.699486] R13: ffff9e9b41297e00 R14: ffff9e9b46068ed8 R15:
> > 0000000008000002 [  172.701267] FS:  00007ff7ff68ee80(0000)
> > GS:ffff9e9bbf280000(0000) knlGS:0000000000000000 [  172.703050] CS:
> >  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [  172.704829] CR2:
> > 0000000000000003 CR3: 0000000003ca8000 CR4: 00000000000026e0 [
> > 172.706618] Call Trace: [  172.708396]  <TASK> [  172.710149]
> > __fsnotify_parent+0x1f9/0x240 [  172.711896]  ?
> > shmem_setattr+0x172/0x1b0 [  172.713628]  notify_change+0x3f0/0x410
> > [  172.715363]  do_sys_ftruncate+0x121/0x1e0 [  172.717103]
> > do_syscall_64+0x31/0x50 [  172.718838]
> > entry_SYSCALL_64_after_hwframe+0x44/0xae [  172.720580] RIP:
> > 0033:0x7ff80008932b [  172.722315] Code: 77 05 c3 0f 1f 40 00 48 8b
> > 15 69 fa 0e 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00
> > f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f
> > 40 00 48 8b 15 39 fa 0e 00 f7 d8 [  172.726019] RSP:
> > 002b:00007ffc04a998b8 EFLAGS: 00000206 ORIG_RAX: 000000000000004d [
> >  172.727913] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
> > 00007ff80008932b [  172.729821] RDX: 00005633275d43f0 RSI:
> > 0000000000080000 RDI: 0000000000000013 [  172.731736] RBP:
> > 00007ffc04a99950 R08: 0000000000000001 R09: 00005633275de0ac [
> > 172.733658] R10: 0000000000000010 R11: 0000000000000206 R12:
> > 00005633275ce270 [  172.735522] R13: 00007ffc04a998f8 R14:
> > 00007ffc04a99900 R15: 0000000000000000 [  172.737335]  </TASK> [
> > 172.739122] Modules linked in: vhost_net vhost vhost_iotlb tun nfsd
> > ksmbd cifs_arc4 xfs nhpoly1305_sse2 nhpoly1305 chacha_generic
> > chacha_x86_64 libchacha adiantum libpoly1305 algif_skcipher af_alg
> > auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc lzo_rle zram
> > zsmalloc cpufreq_powersave i915 kvm_intel video 8250 drm_buddy
> > intel_gtt iosf_mbi kvm 8250_base ttm bridge serial_core
> > i2c_algo_bit drm_dp_helper e1000e drm_kms_helper iTCO_wdt irqbypass
> > lpc_ich sysimgblt syscopyarea mfd_core stp sysfillrect acpi_cpufreq
> > evdev fb_sys_fops processor button llc drm sch_fq_codel backlight
> > i2c_core ip_tables x_tables ipv6 autofs4 btrfs raid6_pq xor
> > zstd_decompress zstd_compress lzo_decompress lzo_compress libcrc32c
> > crc32c_generic xts ecb hid_generic usbhid hid dm_crypt dm_mod
> > sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 uhci_hcd
> > ehci_pci ahci ehci_hcd libahci usbcore pata_jmicron sata_sil24
> > usb_common [  172.750745] CR2: 0000000000000003 [  172.752725] ---[
> > end trace 0000000000000000 ]--- [  172.754640] RIP:
> > 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm] [  172.756555] Code: ac
> > 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08
> > 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a
> > 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44 [
> > 172.760417] RSP: 0018:ffffb0740064fd78 EFLAGS: 00010206 [
> > 172.762329] RAX: ffff9e9b41240e00 RBX: ffffb07401271000 RCX:
> > ffffb07401271388 [  172.764240] RDX: 0000000000000003 RSI:
> > ffff9e9b41240e00 RDI: ffffb07401271000 [  172.766173] RBP:
> > 0000000000000000 R08: 000000000016000e R09: 000000000016000d [
> > 172.768099] R10: ffffd73680764d00 R11: ffff9e9bbf226a78 R12:
> > 0000000000000000 [  172.769975] R13: ffffb07401271480 R14:
> > ffff9e9b41240e00 R15: 0000000000000000 [  172.771790] FS:
> > 00007ff7ff68ee80(0000) GS:ffff9e9bbf200000(0000)
> > knlGS:0000000000000000 [  172.773618] CS:  0010 DS: 0000 ES: 0000
> > CR0: 0000000080050033 [  172.775443] CR2: 000000000000000b CR3:
> > 0000000003ca8000 CR4: 00000000000026f0
> > 

Bisect is later on my TODO if needed... I build this kernel now on
debian/sid (saw some compiler/binutils updates) and added KASAN as
Maciej pointed out.

[    0.000000] Linux version 5.18.0-rc5-KASAN-amd64 (root@build) (gcc (Debian 11.3.0-1) 11.3.0, GNU ld (GNU Binutils for Debian) 2.38) #1 SMP PREEMPT_DYNAMIC Tue May 3 22:04:25 CEST 2022

...

[  229.423151] ==================================================================
[  229.423284] BUG: KASAN: slab-out-of-bounds in fpu_copy_uabi_to_guest_fpstate+0x86/0x130
[  229.423402] Read of size 8 at addr ffff888011e33a00 by task qemu-build/681

[  229.423506] CPU: 1 PID: 681 Comm: qemu-build Not tainted 5.18.0-rc5-KASAN-amd64 #1
[  229.423606] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
[  229.423705] Call Trace:
[  229.423734]  <TASK>
[  229.423758]  dump_stack_lvl+0x34/0x45
[  229.423811]  print_report.cold+0x45/0x575
[  229.423869]  ? _raw_read_unlock_irqrestore+0x40/0x40
[  229.423938]  ? fpu_copy_uabi_to_guest_fpstate+0x86/0x130
[  229.424010]  kasan_report+0x9b/0xd0
[  229.424059]  ? fpu_copy_uabi_to_guest_fpstate+0x86/0x130
[  229.424130]  fpu_copy_uabi_to_guest_fpstate+0x86/0x130
[  229.424200]  kvm_arch_vcpu_ioctl+0x72a/0x1c50 [kvm]
[  229.424366]  ? __stack_depot_save+0x339/0x4a0
[  229.424427]  ? kvm_arch_vcpu_put+0x240/0x240 [kvm]
[  229.424585]  ? kvm_vcpu_ioctl+0x1e2/0x7b0 [kvm]
[  229.424731]  ? kasan_save_stack+0x2e/0x40
[  229.424786]  ? kasan_save_stack+0x1e/0x40
[  229.424839]  ? kasan_set_track+0x21/0x30
[  229.424891]  ? kasan_set_free_info+0x20/0x40
[  229.424949]  ? __kasan_slab_free+0xfb/0x130
[  229.425005]  ? kfree+0x7e/0x210
[  229.425047]  ? kvm_vcpu_ioctl+0x1e2/0x7b0 [kvm]
[  229.425193]  ? __x64_sys_ioctl+0x5de/0xc90
[  229.425249]  ? do_syscall_64+0x31/0x50
[  229.425300]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  229.425372]  ? __update_load_avg_cfs_rq+0x1de/0x570
[  229.425441]  ? vmx_vcpu_pi_load+0x76/0x300 [kvm_intel]
[  229.425535]  ? _raw_spin_lock+0x6c/0xb0
[  229.425588]  ? cgroup_rstat_updated+0x5c/0x170
[  229.425650]  ? nested_vmx_hardware_unsetup+0x30/0x30 [kvm_intel]
[  229.425755]  ? newidle_balance.constprop.0+0x425/0x650
[  229.425825]  ? __cgroup_account_cputime+0x48/0x70
[  229.425890]  ? _raw_spin_lock_irqsave+0x72/0xc0
[  229.425951]  ? vmx_vcpu_load_vmcs+0xc7/0x350 [kvm_intel]
[  229.426047]  ? run_rebalance_domains+0xa0/0xa0
[  229.426106]  ? vmx_vcpu_pi_put+0x2f/0x50 [kvm_intel]
[  229.426198]  ? vmx_vcpu_put+0x6a/0x340 [kvm_intel]
[  229.426284]  ? vmentry_l1d_flush_set+0x160/0x160 [kvm_intel]
[  229.426383]  ? vmx_get_rflags+0x3c/0x120 [kvm_intel]
[  229.426471]  ? kasan_set_track+0x21/0x30
[  229.426524]  ? mutex_lock_killable+0x70/0xb0
[  229.426582]  ? kvm_vcpu_ioctl+0x47f/0x7b0 [kvm]
[  229.429784]  kvm_vcpu_ioctl+0x47f/0x7b0 [kvm]
[  229.432961]  ? gfn_to_page_many_atomic+0x120/0x120 [kvm]
[  229.436141]  ? schedule+0x98/0xf0
[  229.439201]  ? futex_wait_queue+0xf1/0x130
[  229.442249]  ? futex_unqueue+0x13/0x70
[  229.445254]  ? futex_wait+0x20a/0x360
[  229.448252]  ? file_update_time+0x1b2/0x240
[  229.451195]  ? futex_wait_setup+0x120/0x120
[  229.454068]  ? fpu__restore_sig+0x60/0x90
[  229.456909]  ? restore_sigcontext+0x290/0x2f0
[  229.459732]  ? __rcu_read_unlock+0x43/0x60
[  229.462513]  ? __fget_light+0x151/0x200
[  229.465243]  __x64_sys_ioctl+0x5de/0xc90
[  229.467960]  ? vfs_fileattr_set+0x490/0x490
[  229.470673]  ? memset+0x20/0x40
[  229.473394]  ? __rseq_handle_notify_resume+0x375/0x510
[  229.476167]  ? __x64_sys_get_robust_list+0xd0/0xd0
[  229.478961]  ? restore_altstack+0x9b/0xd0
[  229.481715]  ? devm_memremap_release+0x30/0x30
[  229.484430]  ? __blkcg_punt_bio_submit+0xd0/0xd0
[  229.487105]  ? __do_sys_rt_sigreturn+0x11e/0x130
[  229.489745]  ? mem_cgroup_handle_over_high+0x26/0x330
[  229.492358]  ? signal_fault+0x70/0x70
[  229.494914]  do_syscall_64+0x31/0x50
[  229.497417]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  229.499971] RIP: 0033:0x7fdf4dcfde6f
[  229.502517] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
[  229.508178] RSP: 002b:00007fdf07dfe420 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  229.511083] RAX: ffffffffffffffda RBX: 000000005000aea5 RCX: 00007fdf4dcfde6f
[  229.514004] RDX: 00007fdf00001000 RSI: 000000005000aea5 RDI: 0000000000000012
[  229.516921] RBP: 0000559520640610 R08: 00007fdf00001000 R09: 0000000000000000
[  229.519832] R10: 0000000000000040 R11: 0000000000000246 R12: 00007fdf00001000
[  229.522740] R13: 00007fdf00001000 R14: 00005595206407e8 R15: 0000000000000001
[  229.525655]  </TASK>

[  229.531379] Allocated by task 0:
[  229.534232] (stack is not available)

[  229.539979] The buggy address belongs to the object at ffff888011e33800
                which belongs to the cache kmalloc-512 of size 512
[  229.545944] The buggy address is located 0 bytes to the right of
                512-byte region [ffff888011e33800, ffff888011e33a00)

[  229.555017] The buggy address belongs to the physical page:
[  229.558100] page:0000000089cd4adb refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e30
[  229.561285] head:0000000089cd4adb order:2 compound_mapcount:0 compound_pincount:0
[  229.564478] flags: 0x4000000000010200(slab|head|zone=1)
[  229.567674] raw: 4000000000010200 dead000000000100 dead000000000122 ffff888001041c80
[  229.570926] raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
[  229.574199] page dumped because: kasan: bad access detected

[  229.580696] Memory state around the buggy address:
[  229.583963]  ffff888011e33900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  229.587297]  ffff888011e33980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  229.590588] >ffff888011e33a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  229.593889]                    ^
[  229.597175]  ffff888011e33a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  229.600550]  ffff888011e33b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  229.603882] ==================================================================
[  229.610775] Disabling lock debugging due to kernel taint

At least now it looks better - only once there's KASAN info when VM is
launched for the first time, VM seems fine and after shutdown and
re-launch nothing weird happens.

HTH, Z.
