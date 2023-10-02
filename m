Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABF47B566F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 17:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbjJBPXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbjJBPXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:23:33 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53CCB3
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 08:23:30 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-41958410e5cso496991cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 08:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696260210; x=1696865010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcmjJranJU9dHmKZgwi11TJfqlRgTzZNCx/vVbaZ/W0=;
        b=WRCQdQGHTZRwMsM/W5bx9E3lku+poVB/wDA58277PG8jQwqVtE0Cbu/XEumKa0Lps6
         0J5eKYADoXN+vUWAvYxnXH9dSe4nG6LkHrwJvH4g3dvbUs3ntyk3j+7bD4m1363WSjQw
         tzMSSbs1cPT9kNtswcAg70HcFBcDugUv3awR6lRzA1Zhb372xG22TwZLTPG5LvpbV0re
         DAJjmCby8mqQN5R4wfdRZOZYSA+zRRKPX5sAawG09qginICkco9KeCzdWAlF7AF55pHp
         QFxwtSRlUXbXAEweNyj5a1aqSq8g307bIk0fcPIk9FLhafs5QkCgVVDF2jPq3ny0zh5f
         DkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696260210; x=1696865010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WcmjJranJU9dHmKZgwi11TJfqlRgTzZNCx/vVbaZ/W0=;
        b=XLi7jjAUWETpwVlrKywavCvnnUt3dDCbEFWtCJrwhk7iudPhRLEwz8fG8oaZS0T6M5
         tSkR+WMus/QL1kK/3QNtMjLMaylqQObSydfgncB9taBXUOARjS+ZqxqXSCeD/Ux5gw7x
         K9qAV/CMUapZ5Lk75N7nIyZ4dFM3LwD4y3j1MU7AgD8Cvm+4GB5MAJRRTtuSf1mb3sT5
         8wZke8D3S0LD6opjjCIsM3PXG0ltHZ70+TxpKpTRWrTYOcPweN8V4pk2M7Ytxu1kgcuY
         zaO7CrotMhbQ/DQJsaU4M6T9geR/4LfGDiUHKuk5H7s/34jQLhNogLEwJE7WVaIf9c/H
         Q+Tw==
X-Gm-Message-State: AOJu0Ywgt4E5zickAhNHJs7fuQBMk0wwy+hRln7A0aWFujyWlmSlU20G
        GB7qjl1KpjqMejaDLQuimZTf1uokmyrdlpQkJl1U/A==
X-Google-Smtp-Source: AGHT+IFlu305KhvyXysTo++Jl9EAskcrzabqiwpzs9CTrnnArCGgWBa6iqE4HiqMPpkfLFQwSSpfqxOPoWFQEhD18O0=
X-Received: by 2002:a05:622a:94:b0:417:9238:5a30 with SMTP id
 o20-20020a05622a009400b0041792385a30mr354168qtw.29.1696260209711; Mon, 02 Oct
 2023 08:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com>
In-Reply-To: <ZRrF38RGllA04R8o@gmail.com>
From:   David Dunn <daviddunn@google.com>
Date:   Mon, 2 Oct 2023 08:23:17 -0700
Message-ID: <CABOYuvYNZd63mNjAsZUckguYbcq4KDvy1Q9Zwzh1DgFfiFb=HQ@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
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
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 2, 2023 at 6:30=E2=80=AFAM Ingo Molnar <mingo@kernel.org> wrote=
:
>
>
> The host OS shouldn't offer facilities that severely limit its own capabi=
lities,
> when there's a better solution. We don't give the FPU to apps exclusively=
 either,
> it would be insanely stupid for a platform to do that.
>

If you think of the guest VM as a usermode application (which it
effectively is), the analogous situation is that there is no way to
tell the usermode application which portions of the FPU state might be
used by the kernel without context switching.  Although the kernel can
and does use FPU state, it doesn't zero out a portion of that state
whenever the kernel needs to use the FPU.

Today there is no way for a guest to dynamically adjust which PMU
state is valid or invalid.  And this changes based on usage by other
commands run on the host.  As observed by perf subsystem running in
the guest kernel, this looks like counters that simply zero out and
stop counting at random.

I think the request here is that there be a way for KVM to be able to
tell the guest kernel (running the perf subsystem) that it has a
functional HW PMU.  And for that to be true.  This doesn't mean taking
away the use of the PMU any more than exposing the FPU to usermode
applications means taking away the FPU from the kernel.  But it does
mean that when entering the KVM run loop, the host perf system needs
to context switch away the host PMU state and allow KVM to load the
guest PMU state.  And much like the FPU situation, the portion of the
host kernel that runs between the context switch to the KVM thread and
VMENTER to the guest cannot use the PMU.

This obviously should be a policy set by the host owner.  They are
deliberately giving up the ability to profile that small portion of
the host (KVM VCPU thread cannot be profiled) in return to providing a
full set of perf functionality to the guest kernel.

Dave Dunn
