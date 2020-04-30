Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418B11C024F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 18:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgD3QVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 12:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726503AbgD3QVT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 12:21:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174F7C035494;
        Thu, 30 Apr 2020 09:21:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s8so2977731pgq.1;
        Thu, 30 Apr 2020 09:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a323AGlCBAcV4I3yzJO9rWfR0NR+Luy46FyJfFLhDgE=;
        b=cx7cmehXNqgLPEZLbpOw69S2u6g71w27MIwcCDFZymrLm62nuXeDKmpvGqXF3wYVFD
         I7o2k5ud+msFQzJJjKOiQ0/qQPHEluvX8093PGlddLQTgDgwq2TRbmNDWZ8LsI2nmODX
         48uua4H4CSh9jwRER8wSa/Tiyw6euJzC9YYK5KYbGicqtMHEhSYwxdi4AXStY3HnlKDJ
         BqaXx20TRuUc35ue7gWz7nIBWhxXnK0iH2sLt0nprou9SVUdp2T3Hxkzb/6OojTWSk9S
         BSiUvDOGwlPlCnLXyFxj8kzk570gv0B1yZbFMscioLP3vSt9n3FpZkIWy4G+BvkEt9OS
         wBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a323AGlCBAcV4I3yzJO9rWfR0NR+Luy46FyJfFLhDgE=;
        b=egCiPR/J2qglhsVl/x9eBOt9srSwavLx1BYP3AOe9PZW3nk8LaAqn2UcRrJd8MaUOw
         oeazfklKcp+2Bq/6zKWDQ8JCkFYtot+2r8TG9aE84lrUvRybYzIXFiBQ/N8B6uxFHkVG
         UZhvYBNxGKB0zJMeNkBauXt93krszuu8MJvMzm1ifdo+t3Nsk1Bp3mOxYeiL2I1WkKci
         k3d2b1Kpxk000M6X2naMio233nYwO3tNNChqgsWrMyDdbA5uh553GDXg9TT0l4u1Xo5g
         2nSAnkl1m/dVlYyGQaYEAzJy97yXb2CWWF78G/eOW7eC1yNCcLoMgdge0/j2HqTZeoxW
         MMqA==
X-Gm-Message-State: AGi0PuZWc0M1FHSMgm+TdudcXic0I0IKpuHbCDWwsB3ktDtUnnwfezRj
        rl/lPQICALcC0PpXe9ChOQ==
X-Google-Smtp-Source: APiQypLUx6sR10Id2bERGEEQO/4aP8IYMJa8+s8q0ium2i2zz1n7SkAjLhpH/JaWMR1ixvInbfRZYw==
X-Received: by 2002:a63:d13:: with SMTP id c19mr3833293pgl.180.1588263678458;
        Thu, 30 Apr 2020 09:21:18 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:d32:dd79:2591:468a:ee81:9c85])
        by smtp.gmail.com with ESMTPSA id u3sm211520pfn.217.2020.04.30.09.21.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Apr 2020 09:21:16 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Thu, 30 Apr 2020 21:51:09 +0530
To:     Qian Cai <cai@lca.pw>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Subject: Re: [PATCH] kvm: Fix false positive RCU usage warning
Message-ID: <20200430162109.GA18365@madhuparna-HP-Notebook>
References: <20200428155249.19990-1-madhuparnabhowmik10@gmail.com>
 <014AD5C4-1E88-4694-8637-C07D34A93F58@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014AD5C4-1E88-4694-8637-C07D34A93F58@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 04:20:29PM -0400, Qian Cai wrote:
> 
> 
> > On Apr 28, 2020, at 11:52 AM, madhuparnabhowmik10@gmail.com wrote:
> > 
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > Fix the following false positive warnings:
> > 
> > [ 9403.765413][T61744] =============================
> > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > [ 9403.838945][T61744] -----------------------------
> > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > 
> > and
> > 
> > [ 9405.859252][T61751] =============================
> > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > [ 9405.880867][T61755] -----------------------------
> > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > [ 9405.911942][T61751] -----------------------------
> > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > 
> > Since srcu read lock is held, these are false positive warnings.
> > Therefore, pass condition srcu_read_lock_held() to
> > list_for_each_entry_rcu().
> 
> You forgot to add KVM maintainer (adding Paolo now). On the other hand, there could be more places need to audit in x86 KVM. Not sure you want to add them together to one patch or doing separately for each file. For example,
>
Thank you for adding him.
I am looking into these other warnings.
I will send a seperate patch for them.

Regards,
Madhuparna

> [29179.937976][T75781] WARNING: suspicious RCU usage
> [29179.942789][T75781] 5.7.0-rc3-next-20200429 #1 Tainted: G           O L   
> [29179.949752][T75781] -----------------------------
> [29179.954498][T75781] arch/x86/kvm/../../../virt/kvm/eventfd.c:472 RCU-list traversed in non-reader section!!
> [29179.964768][T75781] 
> [29179.964768][T75781] other info that might help us debug this:
> [29179.964768][T75781] 
> [29179.974958][T75781] 
> [29179.974958][T75781] rcu_scheduler_active = 2, debug_locks = 1
> [29179.982961][T75781] 3 locks held by qemu-kvm/75781:
> [29179.988145][T75781]  #0: ffff95b3755300d0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0xbd/0x860 [kvm]
> [29179.998450][T75781]  #1: ffffa45946cd7e10 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x94e/0x2e50 [kvm]
> [29180.009264][T75781]  #2: ffffa45946cd8b98 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x92/0x290 [kvm]
> [29180.020471][T75781] 
> [29180.020471][T75781] stack backtrace:
> [29180.026318][T75781] CPU: 16 PID: 75781 Comm: qemu-kvm Tainted: G           O L    5.7.0-rc3-next-20200429 #1
> [29180.036480][T75781] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
> [29180.045765][T75781] Call Trace:
> [29180.048942][T75781]  dump_stack+0xab/0x100
> [29180.053132][T75781]  lockdep_rcu_suspicious+0xea/0xf3
> [29180.058802][T75781]  kvm_notify_acked_gsi+0x10d/0x120 [kvm]
> [29180.065386][T75781]  kvm_notify_acked_irq+0xe5/0x290 [kvm]
> [29180.071529][T75781]  pic_clear_isr+0xa1/0xc0 [kvm]
> [29180.077118][T75781]  pic_ioport_write+0x335/0x5e0 [kvm]
> [29180.082453][T75781]  ? do_raw_spin_lock+0x115/0x1b0
> [29180.088205][T75781]  picdev_write+0x7d/0x130 [kvm]
> [29180.093677][T75781]  picdev_master_write+0x3a/0x50 [kvm]
> [29180.099730][T75781]  __kvm_io_bus_write+0x147/0x180 [kvm]
> [29180.105700][T75781]  kvm_io_bus_write+0xfc/0x1b0 [kvm]
> [29180.111701][T75781]  kernel_pio+0xeb/0x110 [kvm]
> [29180.116991][T75781]  emulator_pio_out+0x14f/0x400 [kvm]
> [29180.122342][T75781]  ? __lock_acquire+0x5c2/0x23f0
> [29180.127229][T75781]  ? __svm_vcpu_run+0x95/0x110 [kvm_amd]
> [29180.133481][T75781]  kvm_fast_pio+0x12f/0x200 [kvm]
> [29180.138733][T75781]  io_interception+0xba/0xe0 [kvm_amd]
> [29180.144164][T75781]  ? svm_sync_dirty_debug_regs+0x170/0x170 [kvm_amd]
> [29180.150843][T75781]  handle_exit+0x403/0x9f0 [kvm_amd]
> [29180.156652][T75781]  ? kvm_arch_vcpu_ioctl_run+0x286/0xb50 [kvm]
> [29180.163648][T75781]  vcpu_enter_guest+0xa08/0x2e50 [kvm]
> [29180.169007][T75781]  ? lock_acquire+0xcd/0x450
> [29180.174364][T75781]  ? kvm_skip_emulated_instruction+0x67/0x80 [kvm]
> [29180.181422][T75781]  kvm_arch_vcpu_ioctl_run+0x286/0xb50 [kvm]
> [29180.188256][T75781]  kvm_vcpu_ioctl+0x2d4/0x860 [kvm]
> [29180.193391][T75781]  ? __fget_light+0xa3/0x170
> [29180.197879][T75781]  ksys_ioctl+0x227/0xb90
> [29180.202159][T75781]  ? find_held_lock+0x35/0xa0
> [29180.206777][T75781]  __x64_sys_ioctl+0x4c/0x5d
> [29180.211443][T75781]  do_syscall_64+0x91/0xb10
> [29180.215840][T75781]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [29180.221307][T75781]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> [29180.227100][T75781] RIP: 0033:0x7f2f5a90487b
> [29180.231414][T75781] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> [29180.251241][T75781] RSP: 002b:00007f2f4b7fd678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [29180.259660][T75781] RAX: ffffffffffffffda RBX: 00007f2f5fc31001 RCX: 00007f2f5a90487b
> [29180.267730][T75781] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000011
> [29180.275619][T75781] RBP: 0000000000000001 R08: 000055c707b6fad0 R09: 00000000000000ff
> [29180.283533][T75781] R10: 0000000000000001 R11: 0000000000000246 R12: 000055c707b58100
> [29180.291622][T75781] R13: 0000000000000000 R14: 00007f2f5fc30000 R15: 000055c70a1b4c60
> 
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > ---
> > arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > index ddc1ec3bdacd..1ad79c7aa05b 100644
> > --- a/arch/x86/kvm/mmu/page_track.c
> > +++ b/arch/x86/kvm/mmu/page_track.c
> > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > 		return;
> > 
> > 	idx = srcu_read_lock(&head->track_srcu);
> > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > +				srcu_read_lock_held(&head->track_srcu))
> > 		if (n->track_write)
> > 			n->track_write(vcpu, gpa, new, bytes, n);
> > 	srcu_read_unlock(&head->track_srcu, idx);
> > @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > 		return;
> > 
> > 	idx = srcu_read_lock(&head->track_srcu);
> > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > +				srcu_read_lock_held(&head->track_srcu))
> > 		if (n->track_flush_slot)
> > 			n->track_flush_slot(kvm, slot, n);
> > 	srcu_read_unlock(&head->track_srcu, idx);
> > -- 
> > 2.17.1
> > 
> 
