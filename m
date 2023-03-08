Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D711D6B137C
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 22:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCHVDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 16:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHVD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 16:03:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336866133E
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 13:03:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so27278pfo.20
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 13:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678309406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Unb4mYU/ETLgbkphMr+iaF50zbN6Gp37Myvvi84/SoU=;
        b=nN8bxL3sc4kaXPU6Wk4bXqG/L37ZioZfoHB4lwfdJOYJCVGgqz1Nukq7L+n1ulbc0U
         rNdeBZ1Nt9BQDzp1bvzFGe36WE/SpGCC5ONdjEGVhAm+2WhGffwFX43oKsLoffYWPVUg
         9RiDYhVGt8rATKbrq9UR2hRSfrSx63zLcGekvj9loq2wTC1ePJARvzDsBFS4YjH0xgxA
         8vnRyMzz573QUOClIk/i58UL8Vy/4OFsJh3m5yoZfioQ1gn68J2g6IqOMMABENICPbgA
         hHCZrxsduZ6LHtU5XkWyUzS6AMT+8Uo83jgmDyWRF4Ll/ZQYkK6z17XD9z0QYap9Gfod
         pyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678309406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Unb4mYU/ETLgbkphMr+iaF50zbN6Gp37Myvvi84/SoU=;
        b=WajX+nyQyGKq3fS0VNfX/jeHGRdpDWbnNJUptr9rowfe3QBxxAUiiXLzv6Sbce0gzN
         nvayVhL0/JFyY26zVWI9Tto+Cr7vVeBsZXpElmiTw9yfM+YC73rnCZ9ukQVHmVeMzdSb
         0gIfdE7+zNiYVOaIh+jvAMKZj3xqc0684i76BZFcLicO9SmX07FNiNByuiJsOSOIdlOE
         UMXc0U15ogqKQhCFGqJXJEkesYcwYbsY4/nfiPRqF8QgX1Bk3zLzH99FIKq4MLQZ+ssH
         JjhTa7lWbbsLkr6WhyUtbwaCs8RqjvhKWDNf59kM+ue9zAy6WZp+WMCdmuLFFgpf7FCY
         3Rqw==
X-Gm-Message-State: AO0yUKULblbLQ5QFYiU0Vo+xVqyus4kZwONt/SLwjQZ8LSf1uejRr7Lh
        SLh0fIIcdlCULIXnbw9hJmlWfK++1KY=
X-Google-Smtp-Source: AK7set/GEf63AR3hInsLioAl66aMvuPGc4y1bcRPkVco4xJN4LcyHq/zLs9MtWRlp9fyr1Wx88hyB62cILM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1298:b0:234:87a7:f180 with SMTP id
 fw24-20020a17090b129800b0023487a7f180mr7303067pjb.0.1678309406733; Wed, 08
 Mar 2023 13:03:26 -0800 (PST)
Date:   Wed, 8 Mar 2023 13:03:25 -0800
In-Reply-To: <d1cdbb7aed99f325355a28dbed02346f4c4d7b16.camel@intel.com>
Mime-Version: 1.0
References: <20230301105438.599196-1-kai.huang@intel.com> <ZAA1+EMTIkBJvdZF@gao-cwp>
 <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
 <ZAdxNgv0M6P63odE@google.com> <d1cdbb7aed99f325355a28dbed02346f4c4d7b16.camel@intel.com>
Message-ID: <ZAj2gZY2tkXjJF6C@google.com>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023, Huang, Kai wrote:
> On Tue, 2023-03-07 at 09:17 -0800, Sean Christopherson wrote:
> > On Thu, Mar 02, 2023, Huang, Kai wrote:
> > > On Thu, 2023-03-02 at 13:36 +0800, Gao, Chao wrote:
> > > > On Wed, Mar 01, 2023 at 11:54:38PM +1300, Kai Huang wrote:
> > > > > Make setup_vmcs_config() preemption disabled so it always performs on
> > > > > the same local cpu.
> > > > > 
> > > > > During module loading time, KVM intends to call setup_vmcs_config() to
> > > > > set up the global VMCS configurations on _one_ cpu in hardware_setup(),
> > 
> > That may have been the very original intention, but I don't think it has been the
> > true intention for a very long time.
> 
> Wondering what's the current intention?

I don't think there's a deliberate "intention" beyond "does it work?".  Like many
of the historical bits of KVM x86, I think this is a case of the original authors
_wanting_ to provide certain behavior, but not actually ensuring that behavior in
code.

> > > > > Change the existing setup_vmcs_config() to __setup_vmcs_config() and
> > > > > call the latter directly in the compatibility check code path.  Change
> > > > > setup_vmcs_config() to call __setup_vmcs_config() with preemption
> > > > > disabled so __setup_vmcs_config() is always done on the same cpu.
> > > > 
> > > > Maybe you can simply disable preemption in hardware_setup() although I
> > > > don't have a strong preference.
> > > > 
> > > > nested_vmx_setup_ctls_msrs() also reads some MSRs and sets up part of
> > > > vmcs_conf, should it be called on the same CPU as setup_vmcs_config()?
> > > 
> > > Yes I think so.  I missed this :)
> > > 
> > > Not sure whether there are other similar places too even outside of
> > > hardware_setup().
> > > 
> > > But compatibility check only checks things calculated via setup_vmcs_config()
> > > and nested_vmx_setup_ctls_msrs(), so I think it's fair to only put
> > > hardware_setup() inside preemption disabled.
> > 
> > Disabling preemption across hardware_setup() isn't feasible as there are a number
> > of allocations that might sleep.  But disabling preemption isn't necessary to
> > ensure setup runs on one CPU, that only requires disabling _migration_.  So _if_
> > we want to handle this in the kernel, we could simply do:
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 541982de5762..9126fdf02649 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9470,7 +9470,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >         int r;
> >  
> >         mutex_lock(&vendor_module_lock);
> > +       migrate_disable();
> >         r = __kvm_x86_vendor_init(ops);
> > +       migrate_enable();
> >         mutex_unlock(&vendor_module_lock);
> >  
> >         return r;
> > 
> > 
> > But I'm not convinced we should handle this in the kernel.  Many of the checks,
> > especially in SVM, query boot_cpu_has(), not this_cpu_has(), i.e. to truly perform
> > setup on a single CPU, all of those would need to be converted to this_cpu_has().
> > 
> > Some of those boot_cpu_has() calls should be changed regardless of whether or not
> > migration is disabled, e.g. kvm_is_svm_supported() is arguably straight up buggy
> > due to cpu_has_svm() checking the boot CPU (I'll fix that by adding a patch after
> > open coding cpu_has_svm() into kvm_is_svm_supported()[*]).
> > 
> > But things like kvm_timer_init() should NOT be blindlgly converted to this_cpu_has(),
> > because the teardown path needs to mirror the setup path, e.g. if KVM ended up
> > running on frankenstein hardware where not all CPUs have a constant TSC, KVM could
> > leave a callback dangling and hose the kernel.  Obviously such hardware wouldn't
> > correctly run VMs, but crashing the kernel is a touch worse than KVM not working
> > correctly.
> > 
> > I'm not totally against converting to this_cpu_has() for the setup, as it would be
> > more intuitive in a lot of ways.  But, I don't think pinning the task actually
> > hardens KVM in a meaningful way.  If there are any divergences between CPUs, then
> > either KVM will notice before running VMs, e.g. the VMCS sanity checks, or KVM will
> > never notice, e.g. the myriad runtime paths that check boot_cpu_has() (or variants
> > thereof) without sanity checking across CPUs.  And if userspace _really_ wants to
> > have guarantees about how setup is performed, e.g. for repeatable, deterministic
> > behavior, then userspace should force loading of KVM to be done on CPU0.
> 
> My intention is never for userspace, but simply/purely from compatibility
> check's point of view (see below).  Also, I don't think userspace wants to
> guarantee anything  -- it just wants to load the KVM module.

That very much depends on the use case.  For personal usage of KVM, it's extremely
unlikely that userspace is doing anything remotely sophisticated.  But for a more
"formal" deployment, userspace absolutely has its hands all over the system, e.g.
scheduling VMs across systems, monitoring the health of the system, etc.  Whether
or not userspaces actually do tightly control loading KVM is another matter...

> It's even arguable that it may be an acceptable behaviour to fail to run any
> VM even loading module was successful.
> 
> > 
> > So my vote is to leave things as-is (modulo the cpu_has_svm() mess).  But maybe add
> > documentation to explain the caveats about loading KVM, and how userspace can
> > mitigate those caveats?
> 
> I made this patch because I have some other patches to move VMXON support out of
> KVM in order to support TDX, but so far those patches are not included in that
> series (and I'd like to leave it out if we really don't need it).

Me too. :-)

> In the patch to move VMXON out of KVM, I changed to use per-cpu variable to
> cache the MSR_IA32_VMX_BASIC value and setup the VMXON region when one CPU is
> becoming online.  And setup_vmcs_config() is changed to use __this_cpu_read() to
> read the per-cpu MSR value instead of reading from hardware.  Obviously w/o
> preempt_disable() or similar __this_cpu_read() can report kernel bug:
> 
>         printk(KERN_ERR "BUG: using %s%s() in preemptible [%08x] code: %s/%d\n",
>                 what1, what2, preempt_count() - 1, current->comm, current->pid);
> 
> That being said, I am fine to keep existing code, even w/o documenting.  We can
> discuss more how to handle when we really want to move VMXON out of KVM (i.e.
> supporting TDX IO?).
> 
> Or we can just fix compatibility check part?  For instance, move
> setup_vmcs_config() and nested_vmx_setup_ctls_msrs() together in
> hardware_setup() and call preempt_disable() around them?

Eh, the compatibility checks we really care about run in IRQ context, i.e. they're
guaranteed to have a stable CPU.  Splitting the _setup_ for the compatibility
checks across multiple CPUs isn't a problem because KVM will still get the right
"answer", i.e. any divergence will be detected (barring _very_ flaky hardware that
might get false negatives anyways).

Don't get me wrong, I agree it's ugly, but I don't want to go halfway.  I either
want to guard the whole thing, or nothing, and I can't convince myself that
guarding everything is worthwhile since userspace can (and IMO should) do a better
job.
