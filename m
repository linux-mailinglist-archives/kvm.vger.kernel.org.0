Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE9A4AFBF6
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 19:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbiBISv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 13:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241344AbiBISu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 13:50:59 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160AC050CCC
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 10:47:39 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id g15-20020a9d6b0f000000b005a062b0dc12so2170407otp.4
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 10:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k7inhu8PhMJK6yGxgiDvgZaOGdJa0rrk9ukESAEO+Jo=;
        b=oMBnkAtbT2pyt87Qd+fh7ucVAOoZ03oqSs3/0kWtRhsWcb/tRHhTPKH2SMhVaiz4EC
         nhpkIVwjaOl6FfTH/GasB2aGxssA6hfaiuHLEUkr4HckBGvY8Ipd2XYKEu8AKm/rWLVM
         XCEJqZi4Ex/VQkRDsJCrJxP4vjp5UKrVTSxD+DRvRiwDuAgtfDA72GtJKVIfolZEkoaV
         iWqFXkB+oBNa/El48FhJCRBdLvHrLaRMI8Jt1H4HYasV+oGfyRRArMg+UUK3tzw/UVwK
         lYPOWzIXFkGJiRBMwcc4ZQeXJyJhVIhR4PvIVv9TDKwjqKF1P9qHHB/llsE0ZNV52pA7
         KXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k7inhu8PhMJK6yGxgiDvgZaOGdJa0rrk9ukESAEO+Jo=;
        b=34XJStV69nPX1wJO4KjJfvhinjjy1ONoSDODz1i9VlyCx7ZgBWX4AenC6TYsK2z2eg
         8VPAqRRniTtMxYrI1wYZi23Xgl4T7s5rL6mHmxo/tzwzSfJGkxptBShEpfzDwxwaFNXT
         4xDKS517P5th9lKfZbdx8PUVFQoJoUHqwvdi6SpHdlRoxXJ0nKHdtRfxBhms0K1rG2Lc
         en9EQYWbcIFt275Ha8y32mDsI2jdCJgvAFE50wum9VfWIAfmBnzsgM+zOO1NX41Pvysh
         t6Ns5B/wG7ohlf/0ecrHllcxOiVxrtXKgjmkprrxocEIqeQlcWhENWC+OcrYjJdBMQHb
         SVnA==
X-Gm-Message-State: AOAM531a0nEC3BwZyjzfD4P0hMOg8KVvQ+BpVMk2jWJmQbezsetheDKc
        ki2gkXxvfWNRtt0a5gFc6L2aCUq+04Bvd7Up7QVeTA==
X-Google-Smtp-Source: ABdhPJxegeSwNRY/UzyVE3AOL7f4B2uatLSpPxfgyc7Lzsn5m1x7AZM7n0VXFCKbmLY3hSN9+3M3ZbZFH7gt2+xbxHY=
X-Received: by 2002:a9d:4e03:: with SMTP id p3mr1530696otf.299.1644432458616;
 Wed, 09 Feb 2022 10:47:38 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
In-Reply-To: <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Feb 2022 10:47:27 -0800
Message-ID: <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 7:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/9/22 05:21, Peter Zijlstra wrote:
> > On Wed, Feb 02, 2022 at 02:35:45PM -0800, Jim Mattson wrote:
> >> 3) TDX is going to pull the rug out from under us anyway. When the TDX
> >> module usurps control of the PMU, any active host counters are going
> >> to stop counting. We are going to need a way of telling the host perf
> >> subsystem what's happening, or other host perf clients are going to
> >> get bogus data.
> > That's not acceptible behaviour. I'm all for unilaterally killing any
> > guest that does this.
>
> I'm not sure where the "bogus data" comes or to what that refers
> specifically.  But, the host does have some level of control:

I was referring to gaps in the collection of data that the host perf
subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
guest. This can potentially be a problem if someone is trying to
measure events per unit of time.

> > The host VMM controls whether a guest TD can use the performance
> > monitoring ISA using the TD=E2=80=99s ATTRIBUTES.PERFMON bit...
>
> So, worst-case, we don't need to threaten to kill guests.  The host can
> just deny access in the first place.
>
> I'm not too picky about what the PMU does, but the TDX behavior didn't
> seem *that* onerous to me.  The gory details are all in "On-TD
> Performance Monitoring" here:
>
> > https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-=
module-1.0-public-spec-v0.931.pdf
>
> My read on it is that TDX host _can_ cede the PMU to TDX guests if it
> wants.  I assume the context-switching model Jim mentioned is along the
> lines of what TDX is already doing on host<->guest transitions.

Right. If ATTRIBUTES.PERFMON is set, then "perfmon state is
context-switched by the Intel TDX module across TD entry and exit
transitions." Furthermore, the VMM has no access to guest perfmon
state.

If you're saying that setting this bit is unacceptable, then perhaps
the TDX folks need to redesign their in-guest PMU support.
