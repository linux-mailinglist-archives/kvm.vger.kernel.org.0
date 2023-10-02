Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C937B5785
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbjJBP46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbjJBP45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:56:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B85BC9
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 08:56:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d852a6749baso24116785276.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 08:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696262212; x=1696867012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cpsMPjbR1WNgJ/uUktgfbNndpX69oDvkpl70xKylEH8=;
        b=QDU9RwJW0u50FcNZZxExPPEv4dK3Fr1p/MZuwCn1Awwcr6dwkCmF0GzdiDn6X1Ls1a
         9FrOsfkXc/UMWpC7ayqGFvQnaS8UDsjnVVwkOGcf1alqLj78ib1LLFC2o5xA//oQWnbi
         teMNTWoAuEveJJfFz9WD49zQ7krILJAHmJFFwxLp30zoy5rSScSyJe7OUnSsUhAfYm20
         ktMpYDPOWmB+xkNZ7zs4ZiCGEFTthxIijuehMK3QCAMgBiqpUdK+4s2c1Pfj4kLUeMOR
         RvOpZvC46JEkr590M7niku2AG8CEn/Pcp7jf/SzqgpDmgEEjRUtKCy8kmmI4qzwXGyC5
         stiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696262212; x=1696867012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpsMPjbR1WNgJ/uUktgfbNndpX69oDvkpl70xKylEH8=;
        b=SFHGM+bjHso9+i5cmKjwTX7+51snIASNuwY/KmNpTXVguilgK/HwdkfOYL5mCLsPQt
         ldfLUwP6HTED7orfOod2fsXalFPZT7L5H2sXmnfA1ooQkUr54yZNHTe39VrK1AXZs3Jt
         gfhzj7/gdr+Ro5HlWR6hKAkdhq6jhzdVdVrCVLNLfOVmiNlGgGxkcN352gSFk5w5Lg9L
         QiDHEV/FHx6r3b/kikHFhMQ9i/2M6eQAHkShfwgU6f7hy4S/639PZIeDVdDuVK/vaR1d
         l32FCItAFj5Ypb+XTL2Xrul8tiuLCDQg92UpsOEyo3+ZfpO0hq4fFeQq4Cf/hRYfSJoi
         ltYw==
X-Gm-Message-State: AOJu0Yyascn2lAiDrsaCnXwaJscKufI4DCJQXLLzXRJaFeiwSS2m0gWE
        ceOX4EaBuwt1uE2X72secEL25f5ytpo=
X-Google-Smtp-Source: AGHT+IFU0Rp0ypciSYbq9+jHt9tXgKHuu0bXBd5z/jIOuiXJuVh5Iwgc1+UaORfJnN9j0OiqnnlHuGl3o/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abe9:0:b0:d80:19e5:76c8 with SMTP id
 v96-20020a25abe9000000b00d8019e576c8mr178348ybi.12.1696262212083; Mon, 02 Oct
 2023 08:56:52 -0700 (PDT)
Date:   Mon, 2 Oct 2023 08:56:50 -0700
In-Reply-To: <ZRrF38RGllA04R8o@gmail.com>
Mime-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
Message-ID: <ZRroQg6flyGBtZTG@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
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

On Mon, Oct 02, 2023, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Sep 29, 2023 at 03:46:55PM +0000, Sean Christopherson wrote:
> > 
> > > > I will firmly reject anything that takes the PMU away from the host
> > > > entirely through.
> > > 
> > > Why?  What is so wrong with supporting use cases where the platform owner *wants*
> > > to give up host PMU and NMI watchdog functionality?  If disabling host PMU usage
> > > were complex, highly invasive, and/or difficult to maintain, then I can understand
> > > the pushback.  
> > 
> > Because it sucks.
>
> > You're forcing people to choose between no host PMU or a slow guest PMU.

Nowhere did I say that we wouldn't take patches to improve the existing vPMU
support.  But that's largely a moot point because I don't think it's possible to
improve the current approach to the point where it would provide a performant,
functional guest PMU.

> > And that's simply not a sane choice for most people --

It's better than the status quo, which is that no one gets to choose, everyone
gets a slow guest PMU.

> > worse it's not a choice based in technical reality.

The technical reality is that context switching the PMU between host and guest
requires reading and writing far too many MSRs for KVM to be able to context
switch at every VM-Enter and every VM-Exit.  And PMIs skidding past VM-Exit adds
another layer of complexity to deal with.

> > It's a choice out of lazyness, disabling host PMU is not a requirement
> > for pass-through.

The requirement isn't passthrough access, the requirements are that the guest's
PMU has accuracy that is on par with bare metal, and that exposing a PMU to the
guest doesn't have a meaningful impact on guest performance.

> Not just a choice of laziness, but it will clearly be forced upon users
> by external entities:
> 
>    "Pass ownership of the PMU to the guest and have no host PMU, or you
>     won't have sane guest PMU support at all. If you disagree, please open
>     a support ticket, which we'll ignore."

We don't have sane guest PMU support today.  In the 12+ years since commit
f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests"), KVM has
never provided anything remotely close to a sane vPMU.  It *mostly* works if host
perf is quiesced, but that "good enough" approach doesn't suffice for any form of
PMU usage that requires a high level of accuracy and precision.

> The host OS shouldn't offer facilities that severely limit its own capabilities,
> when there's a better solution. We don't give the FPU to apps exclusively either,
> it would be insanely stupid for a platform to do that.

The FPU can be effeciently context switched, guest state remains resident in
hardware so long as the vCPU task is scheduled in (ignoring infrequrent FPU usage
from IRQ context), and guest usage of the FPU doesn't require trap-and-emulate
behavior in KVM.

As David said, ceding the hardware PMU for all of kvm_arch_vcpu_ioctl_run()
(module the vCPU task being scheduled out) is likely a viable alternative.

 : But it does mean that when entering the KVM run loop, the host perf system 
 : needs to context switch away the host PMU state and allow KVM to load the guest
 : PMU state.  And much like the FPU situation, the portion of the host kernel
 : that runs between the context switch to the KVM thread and VMENTER to the guest
 : cannot use the PMU.

If y'all are willing to let KVM redefined exclude_guest to be KVM's outer run
loop, then I'm all for exploring that option.  But that idea got shot down over
a year ago[*].  Or at least, that was my reading of things.  Maybe it was just a
misunderstanding because we didn't do a good job of defining the behavior.

I am completely ok with either approach, but I am not ok with being nak'd on both.
Because unless there's a magical third option lurking, those two options are the
only ways for KVM to provide a vPMU that meets the requirements for slice-of-hardware
use cases.

[*] https://lore.kernel.org/all/YgPCm1WIt9dHuoEo@hirez.programming.kicks-ass.net
