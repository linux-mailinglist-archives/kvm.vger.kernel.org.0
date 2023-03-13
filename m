Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA8F6B7B69
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjCMPDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCMPDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:03:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405D174DF8
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:02:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ot8-20020a17090b3b4800b0023b3b695ddeso1719268pjb.5
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678719749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+tH8lYD9x2/FqbeqH0oWvF0Gi+WrvY+7IS1lzP+zYs=;
        b=n8D68KLWWq8tQn8XxYjWWU/BDuop/hKc0pOUBZvDtn5d7r4dAs/veh4PJ+rjlj07KL
         cu29BCAB1IDdf0T/RCDxj26joaO6eorfftwZTcLhuLAdKYmNSoMDAXzrzRuitsF+Q9tM
         aMvVJr2hRlNMyDjDdHILz2rhoLym6W+ZIvksjnzhGkcRRncpTyu9IKfZOprFjYA7MCap
         Y26mH24RxFuRoJIW5U1szfekcPe6L0grrOr3I0XWCP2xpUFno3hZ7tVlinQd856NOYb+
         QZOHStb5CXv/OZQ8EMkUdqSzl+f9r1zxSaI7w/skGjuCC0zYVEn1Ctv+NyMXqU7pYHJL
         sq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+tH8lYD9x2/FqbeqH0oWvF0Gi+WrvY+7IS1lzP+zYs=;
        b=W8kT1g5rNpLRcDdzBTKD0DxPSw9vyqsLSVdT4JKYPKVIs5mTM+61IWUYHJuXlfukr5
         86G1gRCDJR7EkreAXs7HtOkK/WrAY5mzzwDKI3urEU3Dm8fUc7IkrdVtMMY6JhdBjRGa
         AZ/oTZZeZXDHNRDNxhFwHxiFZnGA0UZVAoGztRF3sLQHI4bHHea4qdvev4wfZzJ8Njzw
         Gs7vrJkzlWHNjtN7gM4tdTNFsRqzezaTFhsfIq5t+zg5KEIrv/DXvoZnAOSS2/s9aFo6
         JF+7RJtP7/nseSU8N8QOAuuvQA5Lyz+RNBJKWDTbWjq/aTKcjHOWevM4h14YY+whu0qJ
         e7wg==
X-Gm-Message-State: AO0yUKXfFjgYOD14bE8nm3w9qYn3qfSs5vMuDd0VMxoPNm/F6Pmc0rS+
        oq81uSrSKr6ExDOv8Tdhqsl/58oIIUU=
X-Google-Smtp-Source: AK7set9/P9VcoKAyPGBT+s9BFnNAj7bBNTRTadNvzfty2TE+20Q7oBhsWJZF6JCCdROoRlN4cXRBFS5+rP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1d0c:b0:233:eccf:ea10 with SMTP id
 c12-20020a17090a1d0c00b00233eccfea10mr12524574pjd.1.1678719749210; Mon, 13
 Mar 2023 08:02:29 -0700 (PDT)
Date:   Mon, 13 Mar 2023 08:02:27 -0700
In-Reply-To: <87fsaa5kyv.wl-maz@kernel.org>
Mime-Version: 1.0
References: <20230310221414.811690-1-seanjc@google.com> <20230310221414.811690-3-seanjc@google.com>
 <87fsaa5kyv.wl-maz@kernel.org>
Message-ID: <ZA86UINtWH3aw4Mv@google.com>
Subject: Re: [PATCH 2/2] KVM: Don't enable hardware after a restart/shutdown
 is initiated
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 12, 2023, Marc Zyngier wrote:
> On Fri, 10 Mar 2023 22:14:14 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Reject hardware enabling, i.e. VM creation, if a restart/shutdown has
> > been initiated to avoid re-enabling hardware between kvm_reboot() and
> > machine_{halt,power_off,restart}().  The restart case is especially
> > problematic (for x86) as enabling VMX (or clearing GIF in KVM_RUN on
> > SVM) blocks INIT, which results in the restart/reboot hanging as BIOS
> > is unable to wake and rendezvous with APs.
> > 
> > Note, this bug, and the original issue that motivated the addition of
> > kvm_reboot(), is effectively limited to a forced reboot, e.g. `reboot -f`.
> > In a "normal" reboot, userspace will gracefully teardown userspace before
> > triggering the kernel reboot (modulo bugs, errors, etc), i.e. any process
> > that might do ioctl(KVM_CREATE_VM) is long gone.
> > 
> > Fixes: 8e1c18157d87 ("KVM: VMX: Disable VMX when system shutdown")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6cdfbb2c641b..b2bf4c105181 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -5182,7 +5182,20 @@ static void hardware_disable_all(void)
> >  static int hardware_enable_all(void)
> >  {
> >  	atomic_t failed = ATOMIC_INIT(0);
> > -	int r = 0;
> > +	int r;
> > +
> > +	/*
> > +	 * Do not enable hardware virtualization if the system is going down.
> > +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> > +	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
> > +	 * after kvm_reboot() is called.  Note, this relies on system_state
> > +	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
> > +	 * hook instead of registering a dedicated reboot notifier (the latter
> > +	 * runs before system_state is updated).
> > +	 */
> > +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> > +	    system_state == SYSTEM_RESTART)
> > +		return -EBUSY;
> 
> Since we now seem to be relying on system_state for most things, is
> there any use for 'kvm_rebooting' other than the ease of evaluation in
> __svm_vcpu_run?

Sadly, yes.  The x86 implementations of emergency_restart(), __crash_kexec() and
other emergency reboot flows disable virtualization and set 'kvm_rebooting'
without touching system_state.  VMX and SVM rely on 'kvm_rebooting' being set to
avoid triggering (another) BUG() during the emergency.

On my todo list is to better understand whether or not the other architectures
that utilize the generic hardware enabling (ARM, RISC-V, MIPS) truly need to disable
virtualization during a reboot, versus KVM simply being polite.  E.g. on x86, if VMX
is left enabled, reboot may hang depending on how the reboot is performed.   If
other architectures really truly need to disable virtualization, then they likely
need something similar to x86's emergency reboot shenanigans.
