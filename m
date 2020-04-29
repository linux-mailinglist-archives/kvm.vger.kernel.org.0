Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357D61BE87A
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 22:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgD2UUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 16:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgD2UUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 16:20:33 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ED3C035493
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 13:20:33 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb4so1853174qvb.7
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 13:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/23J5CKDV/ipNHmolXue3R/OfIDiPvGpq+jfAvjfA5w=;
        b=T3FVr+bEt2VdzBPMrzXS/XIBxyIAVSo4cc5hilgAj6z9UGWVPy1IuxFPnoT9gd0kVR
         8j66U0ETtEaBNKqmVbLPTSoEAYnVqJkUHq7EfZK7BQwuHLGoug0Vdon9V2qaYFQStqAf
         CHXthQOZBq9OkumERtJVuwIGOLluR/p+aF7IPzIH18TaatoKoKyNLgAgiIeo4GlAqK7C
         rBWRIsUEGMdQNFxhtCrIrQkglZ16dH7U3dRq5ABqKKDVEEgoDfL28Up7BPkw5Jkx/tXT
         2u5FXuxBKNZHuJZ5mhQ4mCevIAKWqr4DB7Yjpllf0yY4CwIYW6wrafJ1V+YKeYn35lbC
         0jOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/23J5CKDV/ipNHmolXue3R/OfIDiPvGpq+jfAvjfA5w=;
        b=rr1IJgHHLSqlerLPhuvvHgdnNE97coKbeZ9Mv4NjF6LZ7Slm1NOjGXx3fHTy098AvW
         joKmq0+PfK9MCnZGEreD/Xeyrd7hM8t6GoXAPzujZil8ZgcxTYBS5OOwkrs29mI/Wr+w
         3DfExb0yshRgYSqKcqsRXhad+o8aJvbw6f6Llr2gte2hrJLq6Jhcs/2qh7Bz6FGo1kts
         npkeLrvKEEC15bngqEoyChKCfhZC+Fe59GSZpl6LZ38ABvd0IgyZPnVlNHme10sN8bfA
         nQgstVAbE0OhTD/OGs6LsyxIIVF5sQGn+5A6idvEUqJTTLPAHzuItyvmkhXmX1FFgLun
         9q2g==
X-Gm-Message-State: AGi0PuZ/pKZVVKhlcgAQxJPv/SskQ1KU3SI/cOpNE+y8dJ5kkLjx7PSr
        VShfs3HYLE93Q+Jeqyr6hlkcXQ==
X-Google-Smtp-Source: APiQypKkMahvKj397sz1q0I94z5LXn5ICNCS326/RH9ZD8NjE6V34eIR2HY3CUeHtvPO8iqWEXzn6A==
X-Received: by 2002:a05:6214:6af:: with SMTP id s15mr35100420qvz.215.1588191632179;
        Wed, 29 Apr 2020 13:20:32 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id d23sm174920qkj.26.2020.04.29.13.20.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:20:31 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] kvm: Fix false positive RCU usage warning
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200428155249.19990-1-madhuparnabhowmik10@gmail.com>
Date:   Wed, 29 Apr 2020 16:20:29 -0400
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        wanpengli@tencent.com, jmattson@google.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Amol Grover <frextrite@gmail.com>, x86 <x86@kernel.org>,
        kvm@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <014AD5C4-1E88-4694-8637-C07D34A93F58@lca.pw>
References: <20200428155249.19990-1-madhuparnabhowmik10@gmail.com>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 28, 2020, at 11:52 AM, madhuparnabhowmik10@gmail.com wrote:
>=20
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>=20
> Fix the following false positive warnings:
>=20
> [ 9403.765413][T61744] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 9403.786541][T61744] WARNING: suspicious RCU usage
> [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G           =
  L
> [ 9403.838945][T61744] -----------------------------
> [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list =
traversed in non-reader section!!
>=20
> and
>=20
> [ 9405.859252][T61751] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 9405.859258][T61751] WARNING: suspicious RCU usage
> [ 9405.880867][T61755] -----------------------------
> [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G           =
  L
> [ 9405.911942][T61751] -----------------------------
> [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list =
traversed in non-reader section!!
>=20
> Since srcu read lock is held, these are false positive warnings.
> Therefore, pass condition srcu_read_lock_held() to
> list_for_each_entry_rcu().

You forgot to add KVM maintainer (adding Paolo now). On the other hand, =
there could be more places need to audit in x86 KVM. Not sure you want =
to add them together to one patch or doing separately for each file. For =
example,

[29179.937976][T75781] WARNING: suspicious RCU usage
[29179.942789][T75781] 5.7.0-rc3-next-20200429 #1 Tainted: G           O =
L  =20
[29179.949752][T75781] -----------------------------
[29179.954498][T75781] arch/x86/kvm/../../../virt/kvm/eventfd.c:472 =
RCU-list traversed in non-reader section!!
[29179.964768][T75781]=20
[29179.964768][T75781] other info that might help us debug this:
[29179.964768][T75781]=20
[29179.974958][T75781]=20
[29179.974958][T75781] rcu_scheduler_active =3D 2, debug_locks =3D 1
[29179.982961][T75781] 3 locks held by qemu-kvm/75781:
[29179.988145][T75781]  #0: ffff95b3755300d0 (&vcpu->mutex){+.+.}-{3:3}, =
at: kvm_vcpu_ioctl+0xbd/0x860 [kvm]
[29179.998450][T75781]  #1: ffffa45946cd7e10 (&kvm->srcu){....}-{0:0}, =
at: vcpu_enter_guest+0x94e/0x2e50 [kvm]
[29180.009264][T75781]  #2: ffffa45946cd8b98 =
(&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x92/0x290 [kvm]
[29180.020471][T75781]=20
[29180.020471][T75781] stack backtrace:
[29180.026318][T75781] CPU: 16 PID: 75781 Comm: qemu-kvm Tainted: G      =
     O L    5.7.0-rc3-next-20200429 #1
[29180.036480][T75781] Hardware name: HPE ProLiant DL385 Gen10/ProLiant =
DL385 Gen10, BIOS A40 03/09/2018
[29180.045765][T75781] Call Trace:
[29180.048942][T75781]  dump_stack+0xab/0x100
[29180.053132][T75781]  lockdep_rcu_suspicious+0xea/0xf3
[29180.058802][T75781]  kvm_notify_acked_gsi+0x10d/0x120 [kvm]
[29180.065386][T75781]  kvm_notify_acked_irq+0xe5/0x290 [kvm]
[29180.071529][T75781]  pic_clear_isr+0xa1/0xc0 [kvm]
[29180.077118][T75781]  pic_ioport_write+0x335/0x5e0 [kvm]
[29180.082453][T75781]  ? do_raw_spin_lock+0x115/0x1b0
[29180.088205][T75781]  picdev_write+0x7d/0x130 [kvm]
[29180.093677][T75781]  picdev_master_write+0x3a/0x50 [kvm]
[29180.099730][T75781]  __kvm_io_bus_write+0x147/0x180 [kvm]
[29180.105700][T75781]  kvm_io_bus_write+0xfc/0x1b0 [kvm]
[29180.111701][T75781]  kernel_pio+0xeb/0x110 [kvm]
[29180.116991][T75781]  emulator_pio_out+0x14f/0x400 [kvm]
[29180.122342][T75781]  ? __lock_acquire+0x5c2/0x23f0
[29180.127229][T75781]  ? __svm_vcpu_run+0x95/0x110 [kvm_amd]
[29180.133481][T75781]  kvm_fast_pio+0x12f/0x200 [kvm]
[29180.138733][T75781]  io_interception+0xba/0xe0 [kvm_amd]
[29180.144164][T75781]  ? svm_sync_dirty_debug_regs+0x170/0x170 =
[kvm_amd]
[29180.150843][T75781]  handle_exit+0x403/0x9f0 [kvm_amd]
[29180.156652][T75781]  ? kvm_arch_vcpu_ioctl_run+0x286/0xb50 [kvm]
[29180.163648][T75781]  vcpu_enter_guest+0xa08/0x2e50 [kvm]
[29180.169007][T75781]  ? lock_acquire+0xcd/0x450
[29180.174364][T75781]  ? kvm_skip_emulated_instruction+0x67/0x80 [kvm]
[29180.181422][T75781]  kvm_arch_vcpu_ioctl_run+0x286/0xb50 [kvm]
[29180.188256][T75781]  kvm_vcpu_ioctl+0x2d4/0x860 [kvm]
[29180.193391][T75781]  ? __fget_light+0xa3/0x170
[29180.197879][T75781]  ksys_ioctl+0x227/0xb90
[29180.202159][T75781]  ? find_held_lock+0x35/0xa0
[29180.206777][T75781]  __x64_sys_ioctl+0x4c/0x5d
[29180.211443][T75781]  do_syscall_64+0x91/0xb10
[29180.215840][T75781]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[29180.221307][T75781]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
[29180.227100][T75781] RIP: 0033:0x7f2f5a90487b
[29180.231414][T75781] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 =
00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 =
00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 =
89 01 48
[29180.251241][T75781] RSP: 002b:00007f2f4b7fd678 EFLAGS: 00000246 =
ORIG_RAX: 0000000000000010
[29180.259660][T75781] RAX: ffffffffffffffda RBX: 00007f2f5fc31001 RCX: =
00007f2f5a90487b
[29180.267730][T75781] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: =
0000000000000011
[29180.275619][T75781] RBP: 0000000000000001 R08: 000055c707b6fad0 R09: =
00000000000000ff
[29180.283533][T75781] R10: 0000000000000001 R11: 0000000000000246 R12: =
000055c707b58100
[29180.291622][T75781] R13: 0000000000000000 R14: 00007f2f5fc30000 R15: =
000055c70a1b4c60

>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
> arch/x86/kvm/mmu/page_track.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/page_track.c =
b/arch/x86/kvm/mmu/page_track.c
> index ddc1ec3bdacd..1ad79c7aa05b 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, =
gpa_t gpa, const u8 *new,
> 		return;
>=20
> 	idx =3D srcu_read_lock(&head->track_srcu);
> -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> +				srcu_read_lock_held(&head->track_srcu))
> 		if (n->track_write)
> 			n->track_write(vcpu, gpa, new, bytes, n);
> 	srcu_read_unlock(&head->track_srcu, idx);
> @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, =
struct kvm_memory_slot *slot)
> 		return;
>=20
> 	idx =3D srcu_read_lock(&head->track_srcu);
> -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> +				srcu_read_lock_held(&head->track_srcu))
> 		if (n->track_flush_slot)
> 			n->track_flush_slot(kvm, slot, n);
> 	srcu_read_unlock(&head->track_srcu, idx);
> --=20
> 2.17.1
>=20

