Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29837B5A27
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbjJBSTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbjJBSS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:18:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1493FAD
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 11:18:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8153284d6eso37286276.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696270732; x=1696875532; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IiAsR0Ba9+p25e+G6xW6VNHUT7Mv8K0srKGN2fQeRBE=;
        b=CnVuIaX3D2J3q8zR3Ebf44tsagA0ZszhHVk1mp6tb2+h+oA2V44bf+lYlFAEnNr2VA
         2aOh8dL9tBtLIqStpvOOHAVQV6k8KM/FExG4rQxR+VHMJ6+57yTPZNnww8lZAbQd4n85
         9JisomqPvYp7Y5ngWyfBtdFlWjRT19ZjmrxdXJVWjM5Kc1S9VQnUQtnV30I7ng5oIjin
         xqK2RqbOytqOmki9nWMZn21ITd6fUZ89cv2JmkxJrTilYNStX4qGYLLp2qrQBHDwpFiU
         t4WWZ+8q2E1kzkGzvxT53PiI+BngZqb4mOCWR0pms2khCfrneRZC6m0DQj9DqZefgS18
         jWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696270732; x=1696875532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IiAsR0Ba9+p25e+G6xW6VNHUT7Mv8K0srKGN2fQeRBE=;
        b=SswLN91VcKazrE/ATe9dc5vaE1ZVAi3Kp3EQvMNaiTe9kQh7d+0NjlIPioszYUZjXB
         BmPQkIDJE8Q+n9ProsU+DpkdKj8ZYCP1ej9+J4g1CWSG/RnwiYKdrj/f1sSfW6vP+dyB
         5eFyk45EMK07Ew4svHrOULQqyjSB25ZqXKiJEx42Drg4ol7sZxXG7PwDOa+rfHm4E5h3
         VjNT/I+F/ocol+5OITfL6dfQDXUN5Xq3d5l4TpbNjXORqxQyzat8qLZrlYmPp73Agfgb
         Gry6Y1zCtUNh0P6kzdkr6iPSR8j/9dgMNdVwSv18EfaP2bmtjn20HKQKTvmcGdEgCe3F
         Bqig==
X-Gm-Message-State: AOJu0YxvoqXbZ02fW1nMQByJ1DgEA3CrKYFTFV0UaiwZkW8oGfwI/FP7
        gy+K1DKxMClY7CWrR7PuuIHk5yIV3XU=
X-Google-Smtp-Source: AGHT+IEgvFF9yJCrECX3HLAx/OWKfbYCCREDqciGbhtnUEZXPkLAdYNj04uJpbW0b6R/TeGRCwN5vMEpoHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad1e:0:b0:d7e:752f:baee with SMTP id
 y30-20020a25ad1e000000b00d7e752fbaeemr170399ybi.10.1696270732253; Mon, 02 Oct
 2023 11:18:52 -0700 (PDT)
Date:   Mon, 2 Oct 2023 11:18:50 -0700
In-Reply-To: <a8479764-34a1-334f-3865-c01325d772d9@oracle.com>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <a8479764-34a1-334f-3865-c01325d772d9@oracle.com>
Message-ID: <ZRsJiuKdXtWos_Xh@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+PeterZ

Thomas and Peter,

We're trying to address an issue where KVM's paravirt kvmclock drifts from the
host's TSC-based monotonic raw clock because of historical reasons (at least, AFAICT),
even when the TSC is constant.  Due to some dubious KVM behavior, KVM may sometimes
re-sync kvmclock against the host's monotonic raw clock, which causes non-trivial
jumps in time from the guest's perspective.

Linux-as-a-guest demotes all paravirt clock sources when the TSC is constant and
nonstop, and so the goofy KVM behavior isn't likely to affect the guest's clocksource,
but the guest's sched_clock() implementation keeps using the paravirt clock.

Irrespective of if/how we fix the KVM host-side mess, using a paravirt clock for
the scheduler when using a constant, nonstop TSC for the clocksource seems at best
inefficient, and at worst unnecessarily complex and risky.

Is there any reason not to prefer native_sched_clock() over whatever paravirt
clock is present when the TSC is the preferred clocksource?  Assuming the desirable
thing to do is to use native_sched_clock() in this scenario, do we need a separate
rating system, or can we simply tie the sched clock selection to the clocksource
selection, e.g. override the paravirt stuff if the TSC clock has higher priority
and is chosen?

Some more details below (and in the rest of the thread).

Thanks!

On Mon, Oct 02, 2023, Dongli Zhang wrote:
> Hi Sean and David,
> 
> On 10/2/23 09:37, Sean Christopherson wrote:
> > However, why does any of this matter if the host has a constant TSC?  If that's
> > the case, a sane setup will expose a constant TSC to the guest and the guest will
> > use the TSC instead of kvmclock for the guest clocksource.
> > 
> > Dongli, is this for long-lived "legacy" guests that were created on hosts without
> > a constant TSC?  If not, then why is kvmclock being used?  Or heaven forbid, are
> > you running on hardware without a constant TSC? :-)
> 
> This is for test guests, and the host has all of below:
> 
> tsc, rdtscp, constant_tsc, nonstop_tsc, tsc_deadline_timer, tsc_adjust
> 
> A clocksource is used for two things.
> 
> 
> 1. current_clocksource. Yes, I agree we should always use tsc on modern hardware.
> 
> Do we need to update the documentation to always suggest TSC when it is
> constant, as I believe many users still prefer pv clock than tsc?
> 
> Thanks to tsc ratio scaling, the live migration will not impact tsc.
> 
> >From the source code, the rating of kvm-clock is still higher than tsc.
> 
> BTW., how about to decrease the rating if guest detects constant tsc?
> 
> 166 struct clocksource kvm_clock = {
> 167         .name   = "kvm-clock",
> 168         .read   = kvm_clock_get_cycles,
> 169         .rating = 400,
> 170         .mask   = CLOCKSOURCE_MASK(64),
> 171         .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
> 172         .enable = kvm_cs_enable,
> 173 };
> 
> 1196 static struct clocksource clocksource_tsc = {
> 1197         .name                   = "tsc",
> 1198         .rating                 = 300,
> 1199         .read                   = read_tsc,

That's already done in kvmclock_init().

	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
	    !check_tsc_unstable())
		kvm_clock.rating = 299;

See also: https://lore.kernel.org/all/ZOjF2DMBgW%2FzVvL3@google.com

> 2. The sched_clock.
> 
> The scheduling is impacted if there is big drift.

...

> Unfortunately, the "no-kvmclock" kernel parameter disables all pv clock
> operations (not only sched_clock), e.g., after line 300.

...
 
> Should I introduce a new param to disable no-kvm-sched-clock only, or to
> introduce a new param to allow the selection of sched_clock?

I don't think we want a KVM-specific knob, because every flavor of paravirt guest
would need to do the same thing.  And unless there's a good reason to use a
paravirt clock, this really shouldn't be something the guest admin needs to opt
into using.
