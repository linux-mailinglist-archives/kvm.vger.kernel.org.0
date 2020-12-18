Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC102DE9CD
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 20:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLRTd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 14:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgLRTd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 14:33:57 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA81C0617A7
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 11:33:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g24so3506507edw.9
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 11:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DyaXUffdTz42kgwCrZZre5sNuoftYYW8HJaP5FHPOHY=;
        b=jJNDZN58yN+Ep6ObClpCXB4IaefdbTbIfsQ0LwKLwjB2cFmjp2XmewFtNIt0GLeEFA
         dsaErWCAfH+T4LBtWzTOsjhNar6PGZjN48TeMfUhYdIST1yf3nBrNT1PKqT6SP849lWL
         8mfR7wWziGm02QWZnYWAPONAsltRNnVn5n6DTpjO+GXUqgCO23ry4r3aDIik4fHlPxOE
         TVHdC9nYs+QwJ0UvKpKspy1uFd3VOVOx8C0zwtm8Ym+8JUpvgVlOZ1NohHomq22G1D99
         mcXoW2V+woual+Y3H49DGUTKi35WE8eADumQtpQSGYHwht1ZhMYxGUDrDjwMBCafureF
         FW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyaXUffdTz42kgwCrZZre5sNuoftYYW8HJaP5FHPOHY=;
        b=h5RAWDJ1I09lF3Yr/vq/9An9gRqJbQPnjRt/No30pJdi+a+p8iYC/3LWLVcxSP75YH
         Icyb+GZ2lgC9bqd0YJOscmG+6W2fWfGiVRZa+Plg7zm8EQ/JJK6wANJWvn+uNms052DI
         lyQFtOpTySR4KoaHzip/KLYNY4mCdzFBnxQQ7zXvtxE005tkPIKvruW2F25R0cmPFn2U
         NJmj+7+B2p4weh5dRqbtIuUm8zDnIuzrgCMNGMTPL+Cq1oH5Nb1gyx+NNgzbcxA7JuKp
         6e9YUu6/lkh/TA6Drrd7fmnSaSU/JVCUJhKR2Kov2Ko4+tSq0mBLyfN484Josm8PXE3U
         egsQ==
X-Gm-Message-State: AOAM531N0nRZHz4BHLMlq62KN/Q6oC8LiZWd8mNmA+VNcKywVWqzrgmM
        99uFulrqitumK2hpjUJsUZ3krQRS5Kg=
X-Google-Smtp-Source: ABdhPJyUy95yc99x0YKxbY2/7hfVlujh8RZ4coSWzIiJK5H75ATJE+UP/47rPeUaU/MkhAPQYeAyfQ==
X-Received: by 2002:a50:e0ce:: with SMTP id j14mr6100497edl.18.1608319995886;
        Fri, 18 Dec 2020 11:33:15 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id dd12sm25513890edb.6.2020.12.18.11.33.15
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 11:33:15 -0800 (PST)
Date:   Fri, 18 Dec 2020 20:33:10 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20201218203310.5025c17e.zkaspar82@gmail.com>
In-Reply-To: <20201201073537.6749e2d7.zkaspar82@gmail.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
        <20201201073537.6749e2d7.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Dec 2020 07:35:37 +0100
Zdenek Kaspar <zkaspar82@gmail.com> wrote:

> On Thu, 19 Nov 2020 04:05:26 +0100
> Zdenek Kaspar <zkaspar82@gmail.com> wrote:
> 
> > Hi,
> > 
> > in my initial report
> > (https://marc.info/?l=kvm&m=160502183220080&w=2 - now fixed by
> > c887c9b9ca62c051d339b1c7b796edf2724029ed) I saw degraded
> > performance going back somewhere between v5.8 - v5.9-rc1.
> > 
> > OpenBSD 6.8 (GENERIC.MP) guest performance (time ./test-build.sh)
> > good: 0m13.54s real     0m10.51s user     0m10.96s system
> > bad : 6m20.07s real    11m42.93s user     0m13.57s system
> > 
> > bisected to first bad commit:
> > 6b82ef2c9cf18a48726e4bb359aa9014632f6466
> > 
> > git bisect log:
> > # bad: [e47c4aee5bde03e7018f4fde45ba21028a8f8438] KVM: x86/mmu:
> > Rename page_header() to to_shadow_page() # good:
> > [01c3b2b5cdae39af8dfcf6e40fdf484ae0e812c5] KVM: SVM: Rename
> > svm_nested_virtualize_tpr() to nested_svm_virtualize_tpr() git
> > bisect start 'e47c4aee5bde' '01c3b2b5cdae' # bad:
> > [ebdb292dac7993425c8e31e2c21c9978e914a676] KVM: x86/mmu: Batch zap
> > MMU pages when shrinking the slab git bisect bad
> > ebdb292dac7993425c8e31e2c21c9978e914a676 # good:
> > [fb58a9c345f645f1774dcf6a36fda169253008ae] KVM: x86/mmu: Optimize
> > MMU page cache lookup for fully direct MMUs git bisect good
> > fb58a9c345f645f1774dcf6a36fda169253008ae # bad:
> > [6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap
> > MMU pages when recycling oldest pages git bisect bad
> > 6b82ef2c9cf18a48726e4bb359aa9014632f6466 # good:
> > [f95eec9bed76d42194c23153cb1cc8f186bf91cb] KVM: x86/mmu: Don't put
> > invalid SPs back on the list of active pages git bisect good
> > f95eec9bed76d42194c23153cb1cc8f186bf91cb # first bad commit:
> > [6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap
> > MMU pages when recycling oldest pages
> > 
> > Host machine is old Intel Core2 without EPT (TDP).
> > 
> > TIA, Z.
> 
> Hi, with v5.10-rc6:
> get_mmio_spte: detect reserved bits on spte, addr 0xfe00d000, dump
> hierarchy: ------ spte 0x8000030e level 3.
> ------ spte 0xaf82027 level 2.
> ------ spte 0x2038001ffe00d407 level 1.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 355 at kvm_mmu_page_fault.cold+0x42/0x4f [kvm]
> ...
> CPU: 1 PID: 355 Comm: qemu-build Not tainted 5.10.0-rc6-amd64 #1
> Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426
> 01/13/2010 RIP: 0010:kvm_mmu_page_fault.cold+0x42/0x4f [kvm]
> Code: e2 ec 44 8b 04 24 8b 5c 24 0c 44 89 c5 89 da 83 eb 01 48 c7 c7
> 20 b2 65 c0 48 63 c3 48 8b 74 c4 30 e8 dd 74 e2 ec 39 dd 7e e3 <0f>
> 0b 41 b8 ea ff ff ff e9 27 99 ff ff 0f 0b 48 8b 54 24 10 48 83 RSP:
> 0018:ffffb67400653d30 EFLAGS: 00010202 RAX: 0000000000000027 RBX:
> 0000000000000000 RCX: ffffa271ff2976f8 RDX: 00000000ffffffd8 RSI:
> 0000000000000027 RDI: ffffa271ff2976f0 RBP: 0000000000000001 R08:
> ffffffffadd02ae8 R09: 0000000000000003 R10: 00000000ffffe000 R11:
> 3fffffffffffffff R12: 00000000fe00d000 R13: 0000000000000000 R14:
> 0000000000000000 R15: 0000000000000001 FS:  00007fc10ae3d640(0000)
> GS:ffffa271ff280000(0000) knlGS:0000000000000000 CS:  0010 DS: 0000
> ES: 0000 CR0: 0000000080050033 CR2: 0000000000000000 CR3:
> 0000000002dc2000 CR4: 00000000000026e0 Call Trace:
> kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm] ? do_futex+0x7c4/0xb80
>  kvm_vcpu_ioctl+0x203/0x520 [kvm]
>  ? set_next_entity+0x5b/0x80
>  ? __switch_to_asm+0x32/0x60
>  ? finish_task_switch+0x70/0x260
>  __x64_sys_ioctl+0x338/0x720
>  ? __x64_sys_futex+0x120/0x190
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fc10c389f6b
> Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0
> 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48>
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48 RSP:
> 002b:00007fc10ae3c628 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fc10c389f6b
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000012
> RBP: 000055ad3767baf0 R08: 000055ad36be4850 R09: 00000000000000ff
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 000055ad371d9800 R14: 0000000000000001 R15: 0000000000000002
> ---[ end trace c5f7ae690f5abcc4 ]---
> 
> without: kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level
> PT I can run guest again, but with degraded performance as before.
> 
> Z.

With: KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte() series
I can run guest again and performance is slightly better:

v5.8:        0m13.54s real     0m10.51s user     0m10.96s system
v5.9:        6m20.07s real    11m42.93s user     0m13.57s system
v5.10+fixes: 5m50.77s real    10m38.29s user     0m15.96s system

perf top from host when guest (openbsd) is compiling:
  26.85%  [kernel]                  [k] queued_spin_lock_slowpath
   8.49%  [kvm]                     [k] mmu_page_zap_pte
   7.47%  [kvm]                     [k] __kvm_mmu_prepare_zap_page
   3.61%  [kernel]                  [k] clear_page_rep
   2.43%  [kernel]                  [k] page_counter_uncharge
   2.30%  [kvm]                     [k] paging64_page_fault
   2.03%  [kvm_intel]               [k] vmx_vcpu_run
   2.02%  [kvm]                     [k] kvm_vcpu_gfn_to_memslot
   1.95%  [kernel]                  [k] internal_get_user_pages_fast
   1.64%  [kvm]                     [k] kvm_mmu_get_page
   1.55%  [kernel]                  [k] page_counter_try_charge
   1.33%  [kernel]                  [k] propagate_protected_usage
   1.29%  [kvm]                     [k] kvm_arch_vcpu_ioctl_run
   1.13%  [kernel]                  [k] get_page_from_freelist
   1.01%  [kvm]                     [k] paging64_walk_addr_generic
   0.83%  [kernel]                  [k] ___slab_alloc.constprop.0
   0.83%  [kernel]                  [k] kmem_cache_free
   0.82%  [kvm]                     [k] __pte_list_remove
   0.77%  [kernel]                  [k] try_grab_compound_head
   0.76%  [kvm_intel]               [k] 0x000000000001cfa0
   0.74%  [kvm]                     [k] pte_list_add

HTH, Z.
