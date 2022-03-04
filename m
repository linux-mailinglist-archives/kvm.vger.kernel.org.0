Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C7A4CDD19
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiCDTCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCDTCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:02:35 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4F41DCCE9
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:01:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso8760807pjo.5
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 11:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aWtPp9gHavbCe/72TWGgyPSN8olgIQaG6jqiqoJFlvo=;
        b=T6cZTeQpCWywuAIUeZSbXRXspUMqzhtz/6tGTT/oMw4QxfOPTtToFpWO+keRiJvHqF
         8JSl2KEqr7eM0ff447jt4in3NZLFaKYH+way7DVAbtyykbxIOezHLNgL/07Lq4W38S8x
         7QJOvo7D+dtfY62vdxaeSa5832NDBy1wcRtoSpTKpMpnrvIGDHb4yEZa485WSraY1Mis
         K9sDj747pso9N9WHul3YQ6TO3HWakI6UTzZIX/3EStFZOurxJzKWzOy9Mogkf/7RTzKA
         CLgt0ljFTI8ZuzSSnwmhygmATrSeHYYPBA+6opn5ARig/FsZtyz9oAR2SZmJcDYjHsW8
         1qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aWtPp9gHavbCe/72TWGgyPSN8olgIQaG6jqiqoJFlvo=;
        b=dR6QNkfQWbKIDLGWWwnap50ShXEt/xYFisNNnpAs8deTzlcVU5zVaiCs5Q3aMgY4u4
         NawFEON505vkz8OKZ87ATY1gKiOHE5Af4umL7kYrBInpe1Fl7ymP2mj8GyMZ2t54cwLL
         xkjKwHIaCRO/YJRP3NLQbMhQthGpti3G9Db482GA1omhlJxYC4RvumJiixyOr+Cuj70+
         gM1VIl08XOQaPn/h6bE6xdV3H2QyX1oWNiqp9p1uxvVGEgMen71DSF5mizpDBYCAv1e2
         4CLAGGhG0L8gz5vfbRG6YrZKW3H3vA3A0RGkh9wL6+3BgO2m7W55tF3bra71hTCFcSlF
         m2EA==
X-Gm-Message-State: AOAM531iluuoJGe1+vZ7vZ7Xf+gcczN5PPxPo/iLugpSH2DaXELRKKWP
        d0V4N+YnLhvoSnC4Drb5LECnOw==
X-Google-Smtp-Source: ABdhPJwIYIZYgdYmZztlZdIGYIS82jCeVXSf1N3R2HJLRYsb6Fdyu/sqywudX8SMQNietyqX8pg5fQ==
X-Received: by 2002:a17:90b:350c:b0:1bf:1dc5:1c3d with SMTP id ls12-20020a17090b350c00b001bf1dc51c3dmr7361081pjb.53.1646420504531;
        Fri, 04 Mar 2022 11:01:44 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090a170200b001bf2d530d64sm2136862pjd.2.2022.03.04.11.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:01:43 -0800 (PST)
Date:   Fri, 4 Mar 2022 11:01:40 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <YiJiFD2ROBHnVSyU@google.com>
References: <20220302172144.2734258-1-ricarkol@google.com>
 <20220302172144.2734258-3-ricarkol@google.com>
 <Yh/XgYAbqCYguegJ@google.com>
 <Yh/gyN7Xu54SpWBx@google.com>
 <87h78etasf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h78etasf.wl-maz@kernel.org>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 07:52:00AM +0000, Marc Zyngier wrote:
> On Wed, 02 Mar 2022 21:25:28 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Hi Oliver,
> > 
> > On Wed, Mar 02, 2022 at 08:45:53PM +0000, Oliver Upton wrote:
> > > Hi Ricardo,
> > > 
> > > On Wed, Mar 02, 2022 at 09:21:43AM -0800, Ricardo Koller wrote:
> > > > Add an arch_timer edge-cases selftest. For now, just add some basic
> > > > sanity checks, and some stress conditions (like waiting for the timers
> > > > while re-scheduling the vcpu). The next commit will add the actual edge
> > > > case tests.
> > > > 
> > > > This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> > > > interrupts for suspended vCPU".
> > > > 
> > > 
> > > Testing timer correctness is extremely challenging to do without
> > > inherent flakiness. I have some concerns about the expectations that a
> > > timer IRQ should fire in a given amount of time, as it is possible to
> > > flake for any number of benign reasons (such as high CPU load in the
> > > host).
> > > 
> > > While the architecture may suggest that the timer should fire as soon as
> > > CVAL is met:
> > > 
> > >   TimerConditionMet = (((Counter[63:0] – Offset[63:0])[63:0] - CompareValue[63:0]) >= 0)
> > > 
> > > However, the architecture is extremely imprecise as to when an interrupt
> > > should be taken:
> > > 
> > >   In the absence of a specific requirement to take an interrupt, the
> > >   architecture only requires that unmasked pending interrupts are taken
> > >   in finite time. [DDI0487G.b D1.13.4 "Prioritization and recognition of
> > >   interrupts"]
> > > 
> > > It seems to me that the only thing we can positively assert is that a
> > > timer interrupt should never be taken early. Now -- I agree that there
> > > is value in testing that the interrupt be taken in bounded time, but its
> > > hard to pick a good value for it.
> > 
> > Yes, a timer that never fires passes the test, but it's not very useful.
> > 
> > I saw delay issues immediately after testing with QEMU. I've been played
> > with values and found that 1ms is enough for all of my runs (QEMU
> > included) to pass (10000 iterations concurrently on all my 64 cpus). I
> > just checked in the fast model and 1ms seems to be enough as well
> > (although I didn't check for so long).
> > 
> > 	/* 1ms sounds a bit excessive, but QEMU-TCG is slow. */
> > 	#define TEST_MARGIN_US			1000ULL
> 
> I'm not sure that's even realistic. I can arbitrary delay those by
> oversubscribing the system.
> 
> > 
> > > 
> > > Perhaps documenting the possibility of flakes in the test is warranted,
> > > along with some knobs to adjust these values for any particularly bad
> > > implementation.
> > 
> > What about having a cmdline arg to enable those tests?
> 
> How is that handled in kvm-unit-tests? I'd rather avoid special
> arguments, as they will never be set. All tests should run by default.

There's this latency test that checks that the latency for a 10ms timer
is not delayed by more than 10ms (after the first 10ms):

	report(test_cval_10msec(info), "latency within 10 ms");

Just to be safe I will just remove the checks for timers firing before
some margin (not even with a special argument).

Thanks,
Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
