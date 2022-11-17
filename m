Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83B162E2B4
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbiKQRQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239818AbiKQRQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:16:27 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BE37819A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 09:16:25 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f201so2618735yba.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 09:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dvROi9Bi2weo8CBth+KOy5I6EKM9vJwM0tHPScY1AQU=;
        b=Ra82+JorxrQxZ3X0xc4Fy4gceDf+HOX2Id/vyZvALKefwLJx2JFmJ1y3wpPx0N3YLV
         /dqf2L+snaaeyNSmlQPH6eQbHkxTNIu+6BStcsG8ixAEfbf4GJytx/luzBCmka/6im90
         C959gl+5Hxa5Jg4/wGoKsigdQ1/hQhr/K9cIA+eD8/kxLEYDELxdfhvh5DkeqSZJ8Cpt
         vnTar2aHT6y8Yd3YNEsauC4WavXA6ba7aAeFksJSj+ALQOtAzTEiEMShIsoYAnTn5TjD
         nEkpxjHP5rynfUr8gg+I9d4Q2x8eDcT477GodQt0fXnjOxBDQCGTmnV289PgYCAkPTMw
         EW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dvROi9Bi2weo8CBth+KOy5I6EKM9vJwM0tHPScY1AQU=;
        b=pFR7kUxhXHSLne8PCaejk8dX6lCQ/uvMwTsHAd0/sSRvIJITsEGPNwGdzLhQfdLtAw
         DMMQSmSyEfy/uflHLDXZBiLyqxS8C+lsGED4Y8km8nr82Et13Xr2t934UOqM96d9LblJ
         iTW7NXsA0zP6yus2MtvPjrdLLO7aNEb1HiWKr8cjTmEDDXinPf4+jEN+InCsARsV8WW3
         PPXsSbM1aC26SKtR2N7KlNRwpJduZYtORatW9Cz9Wf3XI7Xemuv4bLN0lMpOafkHAgPW
         j8aLEYq2dNj4jQM2ayLNpSh9fxih9ZkP01MasMVTR2VnExQ22Jxu/RWeIWp4d0Bjm1PE
         kF3w==
X-Gm-Message-State: ANoB5pmlGPcCCcgGkBfLGSvIm92QfPWHDKlxHGpeaPhM1LD8pUPXCAF7
        QZjhxwbJ/1cMOvMvzBXRBvv3Xv/AIV5nCx305KhFkw==
X-Google-Smtp-Source: AA0mqf4sxFmbzEadJwNlIwQGFePzrEoH16ZvqVIxpH33I2N/r3rvB1khBF51e5wPywlbApiKVk+eICS7QFfTRojEIOU=
X-Received: by 2002:a25:ae12:0:b0:6d0:704:f19f with SMTP id
 a18-20020a25ae12000000b006d00704f19fmr3155458ybj.191.1668705384985; Thu, 17
 Nov 2022 09:16:24 -0800 (PST)
MIME-Version: 1.0
References: <20221103204421.1146958-1-dmatlack@google.com> <Y2l247/1GzVm4mJH@google.com>
 <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com> <Y3ZjzZdI6Ej6XwW4@google.com>
 <323bc39e-5762-e8ae-6e05-0bc184bc7b81@redhat.com> <Y3ZpfU3pWBNyqfoL@google.com>
In-Reply-To: <Y3ZpfU3pWBNyqfoL@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 17 Nov 2022 09:15:58 -0800
Message-ID: <CALzav=eJ5ShR5d1hPNWZHcCyn8iHx7tYo9RC=wCMhnNEBnyyNw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge Pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 9:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Nov 17, 2022, Paolo Bonzini wrote:
> > On 11/17/22 17:39, Sean Christopherson wrote:
> > > Right, what I'm saying is that this approach is still sub-optimal because it does
> > > all that work will holding mmu_lock for write.
> > >
> > > > Also, David's test used a 10-second halving time for the recovery thread.
> > > > With the 1 hour time the effect would Perhaps the 1 hour time used by
> > > > default by KVM is overly conservative, but 1% over 10 seconds is certainly a
> > > > lot larger an effect, than 1% over 1 hour.
> > >
> > > It's not the CPU usage I'm thinking of, it's the unnecessary blockage of MMU
> > > operations on other tasks/vCPUs.  Given that this is related to dirty logging,
> > > odds are very good that there will be a variety of operations in flight, e.g.
> > > KVM_GET_DIRTY_LOG.  If the recovery ratio is aggressive, and/or there are a lot
> > > of pages to recover, the recovery thread could hold mmu_lock until a reched is
> > > needed.
> >
> > If you need that, you need to configure your kernel to be preemptible, at
> > least voluntarily.  That's in general a good idea for KVM, given its
> > rwlock-happiness.
>
> IMO, it's not that simple.  We always "need" better live migration performance,
> but we don't need/want preemption in general.
>
> > And the patch is not making it worse, is it?  Yes, you have to look up the
> > memslot, but the work to do that should be less than what you save by not
> > zapping the page.
>
> Yes, my objection  is that we're adding a heuristic to guess at userspace's
> intentions (it's probably a good guess, but still) and the resulting behavior isn't
> optimal.  Giving userspace an explicit knob seems straightforward and would address
> both of those issues, why not go that route?

In this case KVM knows that zapping dirty-tracked pages is completely
useless, regardless of what userspace is doing, so there's no
guessing.

A userspace knob requires userspace guess at KVM's implementation
details. e.g. KVM could theoretically support faulting in read
accesses and execute accesses as write-protected huge pages during
dirty logging. Or KVM might supporting 2MiB+ dirty logging. In both
cases a binary userspace knob might not be the best fit.

I agree that, even with this patch, KVM is still suboptimal because it
is holding the MMU lock to do all these checks. But this patch should
at least be a step in the right direction for reducing customer
hiccups during live migration.

Also as for the CPU usage, I did a terrible job of explaining the
impact. It's a 1% increase over the current usage, but the current
usage is extremely low even with my way overly aggressive settings.
Specifically, the CPU usage of the NX recovery worker increased from
0.73 CPU-seconds to 0.74 CPU-seconds over a 2.5 minute runtime.
