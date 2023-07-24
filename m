Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598D3760159
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 23:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjGXVl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 17:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjGXVlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 17:41:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3A3D8
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 14:41:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d13e11bb9ecso886469276.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 14:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690234883; x=1690839683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=36znb1AgwXW7YPa8eTrHAJute7NJ/NQXlr4adS1nJ34=;
        b=efsYJR9IR9Gs/SpQ/phcv2041HFN9J9ks0Atuke0PXmiIx3vpIOp+GhslFLn7GUXJA
         iyAyNNHAo+VEpo6ofhtnQS+P/sDwE41gGvypw7Vem8cLFwRSCb8Ja+fpFb2RpoQbHamg
         9phY5xroECemVhCXdFKUJTqAP0rVw5W7gkuJyHCjJyxjJlH3EsJAR6f44fp/jLl8ZI/b
         X2IuMD6SuCnnO1rlmNptGUTrfpGzofbUXWr7ZLW/yfvctKKZKBlNHmxGnJDl8Skc5wAO
         74LpsDitUiXVrrvG4Vm2vhGtCXlS6nkZYr8FAC7B97uvNmKX9BujsC+roWxYJ0th9lAm
         mVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690234883; x=1690839683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36znb1AgwXW7YPa8eTrHAJute7NJ/NQXlr4adS1nJ34=;
        b=jSSgtrwxb6mGOu9/ltE5oqOUlJd2SHuelDVvrdN5Nf61gYYE37kXX8zwjwLCABHUyX
         3ZmYUoBqQ7CrQhXYMl5YKZT0MWiUyiZeBdVn9fJk4xqtgZBFBBrZ4Qpw3E+4vuqIIp1S
         CVUQDtzo+ImSkvA1b+AlvrxuP6Xo8DyhSmqPqu9s5hG+K45TSVBKMEO41QPqRfZUJ0hT
         eBvCRgUucE0uaJqyr/+ZIfitrnJg8rjTiXVn2Lfeg6wgzPMXWEWMxQksxrEqKRcV1zhd
         EVEIAgmYESyxdOlhXzT4dgYWJl4kWnXe8IMoBQMmksAazeW0AHu0aQ+XuAiYvzCtz/Nq
         Fhpw==
X-Gm-Message-State: ABy/qLYtRo78I4Aryigoq3LxpyUpQjZsoekYabR4qr5bE1tKi8e5zDRT
        KUZ5/PaL1a0fuRdrxFg8Fn38t8zEi2Q=
X-Google-Smtp-Source: APBJJlEW1UfjxVevO5/Hz66FWzQCqpO1qe3uLktWl4O1jS2k4hKJk2bK4icxgLsda09AouKDrgdfZWXwKo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1610:b0:d0c:77a8:1f6d with SMTP id
 bw16-20020a056902161000b00d0c77a81f6dmr39083ybb.10.1690234883445; Mon, 24 Jul
 2023 14:41:23 -0700 (PDT)
Date:   Mon, 24 Jul 2023 14:41:21 -0700
In-Reply-To: <20230724211949.GG3745454@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com> <20230721201859.2307736-6-seanjc@google.com>
 <20230724211949.GG3745454@hirez.programming.kicks-ass.net>
Message-ID: <ZL7wAXyF5A8i5He7@google.com>
Subject: Re: [PATCH v4 05/19] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023, Peter Zijlstra wrote:
> On Fri, Jul 21, 2023 at 01:18:45PM -0700, Sean Christopherson wrote:
> > Assert that IRQs are disabled when turning off virtualization in an
> > emergency.  KVM enables hardware via on_each_cpu(), i.e. could re-enable
> > hardware if a pending IPI were delivered after disabling virtualization.
> > 
> > Remove a misleading comment from emergency_reboot_disable_virtualization()
> > about "just" needing to guarantee the CPU is stable (see above).
> > 
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kernel/reboot.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 48ad2d1ff83d..4cad7183b89e 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -532,7 +532,6 @@ static inline void nmi_shootdown_cpus_on_restart(void);
> >  
> >  static void emergency_reboot_disable_virtualization(void)
> >  {
> > -	/* Just make sure we won't change CPUs while doing this */
> >  	local_irq_disable();
> >  
> >  	/*
> > @@ -821,6 +820,13 @@ void cpu_emergency_disable_virtualization(void)
> >  {
> >  	cpu_emergency_virt_cb *callback;
> >  
> > +	/*
> > +	 * IRQs must be disabled as KVM enables virtualization in hardware via
> > +	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
> > +	 * virtualization stays disabled.
> > +	 */
> > +	lockdep_assert_irqs_disabled();
> > +
> >  	rcu_read_lock();
> >  	callback = rcu_dereference(cpu_emergency_virt_callback);
> >  	if (callback)
> 
> Strictly speaking you don't need rcu_read_lock() when IRQs are already
> disabled, but since this is non-performance critical code, it might be
> best to keep it super obvious. IOW, carry on.

Ha!  IIRC, I even had a patch to drop the explicit rcu_read_lock(), but decided
I didn't want to tie the use of cpu_emergency_virt_callback to KVM's behavior of
enabling virtualization via IPIs.
