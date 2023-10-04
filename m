Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC557B8E42
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjJDUn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 16:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjJDUn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 16:43:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2111DC0
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 13:43:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f67676065so3755507b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 13:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696452232; x=1697057032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wlxMyVNfjSoRd0rBi0mcIrA81XFNXKxdXgwPCPKKi+c=;
        b=H3oNnDSb1ptmSWlR1eGP4UzY4jKXo+IhvD8pqUNFPMBByPe825qdI2i05focHY1HCk
         9YNkeCO6VtciiEAzWZ+peisMwXCu3jUWThy8DExH6SWBzRMp8SBXFI36LDjvJL04Ux6P
         efXOsdwcfN4WhgeLvvZVmBqMGZFHqrp5cu2YlWn9lh3b3GxfRxvRHRNucaD9AcyhqvrC
         F2zzubenazDDfJfdi3sPi4NtFZQdYFEYvMKjPNAN5T+uGqOXgeyu5ssEH8/mssUPEftM
         O78pk3a8gXvcrKmrwX9KAetSYBk3JknJakBY55EAXzHBhIG9jc1bPX9unQxSvsfQmdQ6
         WfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696452232; x=1697057032;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wlxMyVNfjSoRd0rBi0mcIrA81XFNXKxdXgwPCPKKi+c=;
        b=uqajYofZrrz2A0dXluRMjQ8RymEVEeWOKTQ3sKqAoI6NbNG+3RQlyVhNASV9qGsCMQ
         eoa0Uuqq7MUVaLScbvdV1fGyzcnRNYo/GDD1HDHCachsqMLG4t6m+QgeMaxnFVFTVPMR
         /tyADSxv5HWLm+kX1RHsSwPP3hpbNbAbYidfb49lSLruSTciX9qcZOb3ShftIIRt15TZ
         etvdaNDQnlIkTFliURqtx/7PHHBgPmfIeS7ANdqMZYN1lSvewqDksPGo1pU16a0912tb
         Pn/CH/v1LO35t7FYmp6+Gc6xn87AuZjh9AP7nfH+XU9PNHrbRMn3+N3YfOoI1vGDAvfV
         PPhg==
X-Gm-Message-State: AOJu0YwneI8czfs97IwENGwesAEU20qXlhuR3fz/ZPUHcXWH2tzqNWa9
        UdFIfa/b8+S6iInn2E6Sze6NRxlrfxE=
X-Google-Smtp-Source: AGHT+IG2BxIFzc18lhT+t5otGKsS7OX2vGezvKCEpmxGtv1UbKYti1bZa4/a2NuIvrXiOGhPcEgq5gnEBhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a909:0:b0:59b:e97e:f7e3 with SMTP id
 g9-20020a81a909000000b0059be97ef7e3mr63909ywh.2.1696452232294; Wed, 04 Oct
 2023 13:43:52 -0700 (PDT)
Date:   Wed, 4 Oct 2023 13:43:50 -0700
In-Reply-To: <CAL715WLbAnnGUiTdHPO0L7v2FHGa5qmTnWJDi8k9qVkGry5GGQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <CAL715WLbAnnGUiTdHPO0L7v2FHGa5qmTnWJDi8k9qVkGry5GGQ@mail.gmail.com>
Message-ID: <ZR3Ohk50rSofAnSL@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
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
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023, Mingwei Zhang wrote:
> On Mon, Oct 2, 2023 at 5:56=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > The "when" is what's important.   If KVM took a literal interpretation =
of
> > "exclude guest" for pass-through MSRs, then KVM would context switch al=
l those
> > MSRs twice for every VM-Exit=3D>VM-Enter roundtrip, even when the VM-Ex=
it isn't a
> > reschedule IRQ to schedule in a different task (or vCPU).  The overhead=
 to save
> > all the host/guest MSRs and load all of the guest/host MSRs *twice* for=
 every
> > VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely ha=
ndled in
> > <1500 cycles, and "fastpath" exits are something like half that.  Switc=
hing all
> > the MSRs is likely 1000+ cycles, if not double that.
>=20
> Hi Sean,
>=20
> Sorry, I have no intention to interrupt the conversation, but this is
> slightly confusing to me.
>=20
> I remember when doing AMX, we added gigantic 8KB memory in the FPU
> context switch. That works well in Linux today. Why can't we do the
> same for PMU? Assuming we context switch all counters, selectors and
> global stuff there?

That's what we (Google folks) are proposing.  However, there are significan=
t
side effects if KVM context switches PMU outside of vcpu_run(), whereas the=
 FPU
doesn't suffer the same problems.

Keeping the guest FPU resident for the duration of vcpu_run() is, in terms =
of
functionality, completely transparent to the rest of the kernel.  From the =
kernel's
perspective, the guest FPU is just a variation of a userspace FPU, and the =
kernel
is already designed to save/restore userspace/guest FPU state when the kern=
el wants
to use the FPU for whatever reason.  And crucially, kernel FPU usage is exp=
licit
and contained, e.g. see kernel_fpu_{begin,end}(), and comes with mechanisms=
 for
KVM to detect when the guest FPU needs to be reloaded (see TIF_NEED_FPU_LOA=
D).

The PMU is a completely different story.  PMU usage, a.k.a. perf, by design=
 is
"always running".  KVM can't transparently stop host usage of the PMU, as d=
isabling
host PMU usage stops perf events from counting/profiling whatever it is the=
y're
supposed to profile.

Today, KVM minimizes the "downtime" of host PMU usage by context switching =
PMU
state at VM-Enter and VM-Exit, or at least as close as possible, e.g. for L=
BRs
and Intel PT.

What we are proposing would *significantly* increase the downtime, to the p=
oint
where it would almost be unbounded in some paths, e.g. if KVM faults in a p=
age,
gup() could go swap in memory from disk, install PTEs, and so on and so for=
th.
If the host is trying to profile something related to swap or memory manage=
ment,
they're out of luck.
