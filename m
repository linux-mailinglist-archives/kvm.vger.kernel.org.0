Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0E66A755
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 01:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjANACs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 19:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjANACn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 19:02:43 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBFC4D716;
        Fri, 13 Jan 2023 16:02:42 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id fd15so10501847qtb.9;
        Fri, 13 Jan 2023 16:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XZS1/EJ3nWdw1Ttl5TgpBjQXEutllULk/2RM1DIsr+0=;
        b=SYEo/mwCSVusd5/YDPi6VoxK9wyM6Q/ESZRmB6HHmG34bVwYDAKzxHBPfBi9fk0qYS
         ee8tf3jirgx+IcH0ADYgHqDPM1r/mYtneru1ojQoGmpqSzHqk39bRfNce/Ak/5jjzBY4
         fxc9ZgFNesxkY3+w52rP0dXNUfo1OFOfmh3JBIiQkJjjfKsN0nVMHJfgGNgejMI1yl+c
         dxR2RtfxEjHfW6DVafbo3/yNGzexc6/H0X2MBpOAckmfiEiaDLaOfNC56yQJIBCsrbcX
         mj2aCHgG1OJYBEuUaSnzukUogZFgEytyNXvYeyGfPvurJHzirLsSewvIVnJTr50MENJ2
         0FPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XZS1/EJ3nWdw1Ttl5TgpBjQXEutllULk/2RM1DIsr+0=;
        b=buA3uvOIM8FoO1I0dXZwtTJJ5i+TjDcmB3fWrKiZ+/9xFWewEEf2uL4dX/EF1VRliF
         xsqADhsSpp+y9ylTpAwTDuONoHLx7LmSK+giAphYS4aBwhv2mv5T1vldwc+MorxoYoI2
         m61tAambWIHe4WbTrk4OQnfxb7V+0mteHBj6ns2OtXKG53G8MOK1O8rgQirA8e2Cdvwl
         fZaU5yZXkpnTi1XImsZLInJ1ugRBjptle3kJaVNqU3vFVlSbefa86WQ55n3GTrQmmS6Z
         A5tipRu+1tvU/LHr8UaQM24j1lgzcDtcIX346HVK51Jia9YlYghnCC/8Jwk1tmKjq3WQ
         tHeQ==
X-Gm-Message-State: AFqh2kqZOGUiL4ZSNvG+5AEUvXrGA68YrpNBSsIwHWEPLpPTlReprdoP
        L25YNgB1mu3l3smiVfZqc0I=
X-Google-Smtp-Source: AMrXdXsvTQZrnmVs9sgr1aLqlmSiuoVNGWpG3Y8039YBRu0zDA3dcrEfCk+G5V9IkkaczVlYvxMGbA==
X-Received: by 2002:a05:622a:4f0a:b0:3b0:a99f:a2db with SMTP id ei10-20020a05622a4f0a00b003b0a99fa2dbmr13719399qtb.15.1673654561132;
        Fri, 13 Jan 2023 16:02:41 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id em8-20020a05622a438800b003a82ca4e81csm5141563qtb.80.2023.01.13.16.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 16:02:39 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8F91327C0054;
        Fri, 13 Jan 2023 19:02:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 13 Jan 2023 19:02:38 -0500
X-ME-Sender: <xms:HvHBY7EdVAHRilV62PO7Rxfkfsl1Mq32mGBnDED0M59072XZtJ2f7g>
    <xme:HvHBY4XGn0jXaPcfDHdNX7KtE7YHFKChVAzGV5jPjXKgkr1rPa9qLmbKuwe93j2Rp
    LSv1GcapNQj5VFWVw>
X-ME-Received: <xmr:HvHBY9JcX8gz5OD7bwTaxcY2y94d6ag55boyl9TDTt-fipfMZVQKRHlpwuM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleelgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeeggfevheefgfehhedttefftddujeduhffgkeekhefghfdttdeifefgtddt
    leefueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhinhhfrhgruggvrggurdhorh
    hgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsgho
    qhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqd
    dujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihm
    vgdrnhgrmhgv
X-ME-Proxy: <xmx:HvHBY5GdevDysvA-BxXh3qzFziMiCWgcLz8ZZlEvEoR8h2tS68UwZw>
    <xmx:HvHBYxUhtcm4uG9m5VuaF-Fm0H7lBmJGfFopJyuOEn1-EQLfi1DFtQ>
    <xmx:HvHBY0OQGtSAD5ir4uT3DLybSJL2Qs6f_6bDK6ZnHw2loSD2J7074Q>
    <xmx:HvHBY8M50cwTd_zUdcNE79E0AMG66AK_LO4i3CXXjCtFzxFwQafA4w>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 19:02:37 -0500 (EST)
Date:   Fri, 13 Jan 2023 16:02:30 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
Message-ID: <Y8HxFtm/Tv0f0Vxl@boqun-archlinux>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
 <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
 <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y8EF24o932lcshKs@boqun-archlinux>
 <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
 <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 10:33:33AM +0000, David Woodhouse wrote:
> On Fri, 2023-01-13 at 10:20 +0100, Paolo Bonzini wrote:
> > On 1/13/23 08:18, Boqun Feng wrote:
> > > On Thu, Jan 12, 2023 at 07:20:48AM -0800, Paul E. McKenney wrote:
> > > > On Thu, Jan 12, 2023 at 08:24:16AM +0000, David Woodhouse wrote:
> > > > > On Wed, 2023-01-11 at 13:30 -0500, Paolo Bonzini wrote:
> > > > > > 
> > > > > > +- ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
> > > > > > +  for kvm->lock, vcpu->mutex and kvm->slots_lock.  These locks _cannot_
> > > > > > +  be taken inside a kvm->srcu read-side critical section; that is, the
> > > > > > +  following is broken::
> > > > > > +
> > > > > > +      srcu_read_lock(&kvm->srcu);
> > > > > > +      mutex_lock(&kvm->slots_lock);
> > > > > > +
> > > > > 
> > > > > "Don't tell me. Tell lockdep!"
> > > > > 
> > > > > Did we conclude in
> > > > > https://lore.kernel.org/kvm/122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org/
> > > > > that lockdep *could* be clever enough to catch a violation of this rule
> > > > > by itself?
> > > > > 
> > > > > The general case of the rule would be that 'if mutex A is taken in a
> > > > > read-section for SCRU B, then any synchronize_srcu(B) while mutex A is
> > > > > held shall be verboten'. And vice versa.
> > > > > 
> > > > > If we can make lockdep catch it automatically, yay!
> > > > 
> > > > Unfortunately, lockdep needs to see a writer to complain, and that patch
> > > > just adds a reader.  And adding that writer would make lockdep complain
> > > > about things that are perfectly fine.  It should be possible to make
> > > > lockdep catch this sort of thing, but from what I can see, doing so
> > > > requires modifications to lockdep itself.
> > > > 
> > > 
> > > Please see if the follow patchset works:
> > > 
> > >         https://lore.kernel.org/lkml/20230113065955.815667-1-boqun.feng@gmail.com
> > > 
> > > "I have been called. I must answer. Always." ;-)
> 
> Amazing! Thank you, Boqun!
> 

Thank you for trying it out ;-)

> > It's missing an important testcase; if it passes (does not warn), then 
> > it should work:
> 
> I think it does.
> 
> I started with kvm/master from
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=master so that
> lockdep didn't find other things to complain about first. I then:
> 
>  • Dropped the last two commits, putting us back to using kvm->lock and
>    removing the dummy mutex lock that would have told lockdep that it's
>    a (different) problem.
> 
>  • I then added Boqun's three commits
> 
>  • Reverted a79b53aa so that the srcu_synchronize() deadlock returns
> 
>  • Couldn't reproduce with xen_shinfo_test, so added Michal's test from
>    https://lore.kernel.org/kvm/15599980-bd2e-b6c2-1479-e1eef02da0b5@rbox.co/
> 
> The resulting tree is at
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/kvm-srcu-lockdep
> 
> 
> Now when I run tools/testing/selftests/kvm/x86_64/deadlocks_test I do
> see lockdep complain about it (shown below; I have a cosmetic
> nit/request to make). If I restore the evtchn_reset fix then it also
> complains about kvm_xen_set_evtchn() vs. kvm_xen_kvm_set_attr(), and if
> I restore the xen_lock fix from the tip of kvm/master then Michal's
> deadlock_test passes and there are no complaints.
> 
> So everything seems to be working as it should... *except* for the fact
> that I don't quite understand why xen_shinfo_test didn't trigger the
> warning. Michal, I guess you already worked that out when you came up
> with your deadlock-test instead... is there something we should add to
> xen_shinfo_test that would mean it *would* have triggered? I even tried
> this:
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1173,6 +1173,16 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>         if (init_srcu_struct(&kvm->irq_srcu))
>                 goto out_err_no_irq_srcu;
>  
> +#ifdef CONFIG_LOCKDEP
> +       /*
> +        * Ensure lockdep knows that it's not permitted to lock kvm->lock
> +        * from a SRCU read section on kvm->srcu.
> +        */
> +       mutex_lock(&kvm->lock);
> +       synchronize_srcu(&kvm->srcu);
> +       mutex_unlock(&kvm->lock);
> +#endif
> +
>         refcount_set(&kvm->users_count, 1);
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>                 for (j = 0; j < 2; j++) {
> 
> 
> 
> 
> > [  845.474169] ======================================================
> > [  845.474170] WARNING: possible circular locking dependency detected
> > [  845.474172] 6.2.0-rc3+ #1025 Tainted: G            E     
> > [  845.474175] ------------------------------------------------------
> > [  845.474176] deadlocks_test/22767 is trying to acquire lock:
> > [  845.474178] ffffc9000ba4b868 (&kvm->srcu){.+.+}-{0:0}, at: __synchronize_srcu+0x5/0x170
> > [  845.474192] 
> >                but task is already holding lock:
> > [  845.474194] ffffc9000ba423c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_vm_ioctl_set_msr_filter+0x188/0x220 [kvm]
> > [  845.474319] 
> >                which lock already depends on the new lock.
> 
> So the above part is good, and clearly tells me it was synchronize_srcu()
> 
> > [  845.474320] 
> >                the existing dependency chain (in reverse order) is:
> > [  845.474322] 
> >                -> #1 (&kvm->lock){+.+.}-{3:3}:
> > [  845.474327]        __lock_acquire+0x4b4/0x940
> > [  845.474333]        lock_acquire.part.0+0xa8/0x210
> > [  845.474337]        __mutex_lock+0x94/0x920
> > [  845.474344]        kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
> > [  845.474437]        kvm_xen_inject_timer_irqs+0x79/0xa0 [kvm]
> > [  845.474529]        vcpu_run+0x20c/0x450 [kvm]
> > [  845.474618]        kvm_arch_vcpu_ioctl_run+0x1df/0x670 [kvm]
> > [  845.474707]        kvm_vcpu_ioctl+0x279/0x700 [kvm]
> > [  845.474783]        __x64_sys_ioctl+0x8a/0xc0
> > [  845.474787]        do_syscall_64+0x3b/0x90
> > [  845.474796]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [  845.474804] 
> >                -> #0 (&kvm->srcu){.+.+}-{0:0}:
> > [  845.474809]        check_prev_add+0x8f/0xc20
> > [  845.474812]        validate_chain+0x3ba/0x450
> > [  845.474814]        __lock_acquire+0x4b4/0x940
> > [  845.474817]        lock_sync+0x99/0x110
> > [  845.474820]        __synchronize_srcu+0x4d/0x170
> > [  845.474824]        kvm_vm_ioctl_set_msr_filter+0x1a5/0x220 [kvm]
> . [  845.474907]        kvm_arch_vm_ioctl+0x8df/0xd50 [kvm]
> > [  845.474997]        kvm_vm_ioctl+0x5ca/0x800 [kvm]
> > [  845.475075]        __x64_sys_ioctl+0x8a/0xc0
> > [  845.475079]        do_syscall_64+0x3b/0x90
> > [  845.475084]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [  845.475089] 
> >                other info that might help us debug this:
> >
> > [  845.475091]  Possible unsafe locking scenario:
> >
> > [  845.475092]        CPU0                    CPU1
> > [  845.475093]        ----                    ----
> > [  845.475095]   lock(&kvm->lock);
> > [  845.475098]                                lock(&kvm->srcu);
> > [  845.475101]                                lock(&kvm->lock);
> > [  845.475103]   lock(&kvm->srcu);
> > [  845.475106] 
> >                 *** DEADLOCK ***
> 
> But is there any chance the above could say 'synchronize_srcu' and
> 'read_lock_srcu' in the appropriate places?
> 

That requires some non-trivial rework of locking scenario printing, it's
in my TODO list...

That said, we can do some improvement on "CPU0", since when we print, we
have all the information for these two locks. I've done a POC at:

	https://lore.kernel.org/lkml/20230113235722.1226525-1-boqun.feng@gmail.com	

, which should improve the print a little. For example, the above
scenario will not be shown as:

	[..]        CPU0                    CPU1
	[..]        ----                    ----
	[..]   lock(&kvm->lock);
	[..]                                lock(&kvm->srcu);
	[..]                                lock(&kvm->lock);
	[..]   sync(&kvm->srcu);
	[..] 

Regards,
Boqun

> > [  845.475108] 1 lock held by deadlocks_test/22767:
> > [  845.475110]  #0: ffffc9000ba423c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_vm_ioctl_set_msr_filter+0x188/0x220 [kvm]
> > [  845.475200] 
> >                stack backtrace:
> > [  845.475202] CPU: 10 PID: 22767 Comm: deadlocks_test Tainted: G            E      6.2.0-rc3+ #1025
> > [  845.475206] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5C610.86B.01.01.0008.021120151325 02/11/2015
> > [  845.475208] Call Trace:
> > [  845.475210]  <TASK>
> > [  845.475214]  dump_stack_lvl+0x56/0x73
> > [  845.475221]  check_noncircular+0x102/0x120
> > [  845.475229]  ? check_noncircular+0x7f/0x120
> > [  845.475236]  check_prev_add+0x8f/0xc20
> > [  845.475239]  ? add_chain_cache+0x10b/0x2d0
> > [  845.475244]  validate_chain+0x3ba/0x450
> > [  845.475249]  __lock_acquire+0x4b4/0x940
> > [  845.475253]  ? __synchronize_srcu+0x5/0x170
> > [  845.475258]  lock_sync+0x99/0x110
> > [  845.475261]  ? __synchronize_srcu+0x5/0x170
> > [  845.475265]  __synchronize_srcu+0x4d/0x170
> ? [  845.475269]  ? mark_held_locks+0x49/0x80
> > [  845.475272]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
> > [  845.475278]  ? __pfx_read_tsc+0x10/0x10
> > [  845.475286]  ? ktime_get_mono_fast_ns+0x3d/0x90
> > [  845.475292]  kvm_vm_ioctl_set_msr_filter+0x1a5/0x220 [kvm]
> > [  845.475380]  kvm_arch_vm_ioctl+0x8df/0xd50 [kvm]
> > [  845.475472]  ? __lock_acquire+0x4b4/0x940
> > [  845.475485]  kvm_vm_ioctl+0x5ca/0x800 [kvm]
> > [  845.475566]  ? lockdep_unregister_key+0x76/0x110
> > [  845.475575]  __x64_sys_ioctl+0x8a/0xc0
> > [  845.475579]  do_syscall_64+0x3b/0x90
> > [  845.475586]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [  845.475591] RIP: 0033:0x7f79de23fd1b
> > [  845.475595] Code: 73 01 c3 48 8b 0d 05 a1 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 a0 1b 00 f7 d8 64 89 01 48
> > [  845.475598] RSP: 002b:00007f79ddff7c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [  845.475602] RAX: ffffffffffffffda RBX: 00007f79ddff8640 RCX: 00007f79de23fd1b
> > [  845.475605] RDX: 00007f79ddff7ca0 RSI: 000000004188aec6 RDI: 0000000000000004
> > [  845.475607] RBP: 00007f79ddff85c0 R08: 0000000000000000 R09: 00007fffceb1ff2f
> > [  845.475609] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f79ddff7ca0
> > [  845.475611] R13: 0000000001c322a0 R14: 00007f79de2a05f0 R15: 0000000000000000
> > [  845.475617]  </TASK>
> 
> 


