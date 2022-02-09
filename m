Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37B4AFD45
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 20:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiBITYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 14:24:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiBITYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 14:24:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3184AE00D0E8
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 11:24:25 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k18so5745164wrg.11
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 11:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ruVJG7HncR2N0k4CIyXD71cI4+MqIoBGL55+c9rkl0=;
        b=GpwsqEJGmeJNlJDm+BtsMicSlQhMnINXJWUKxAHh/wcRlEe/gCxWSLkUQXj0IKQOP1
         pARJjQJnmjjYATq0E86iV722i7CmTzZgMxL281ND+XIinpdaNSIRERuFaorO1aVrLRBU
         Udm+lv+WZ/cAKqV1rEJ9sVhJhypZ5rn2/DB8Afuwsubcj97UMPJXrr+gukNVAXAMblV9
         XjVlieT2Wqt9TPcOmmR1WXvcPoWfoHUK7mCUUWDYslCAvkokP1oMKKnr4wQJ5qE7qRf9
         zDMMhKC1pLQzw6RiXNl1+89KMO6DwZ06rGOkPSAzIEDI6kBSkFUN0I9ukaPiGly7TRVJ
         Xl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ruVJG7HncR2N0k4CIyXD71cI4+MqIoBGL55+c9rkl0=;
        b=Ht1UWXzc6IrXAcbdACUdv+ueSw9f+aDk3ZfdC4+9oX9GZ268D2SIPIz318RLqVxIUB
         SiOAB2Ve+yhK1xJ/Z7FGPZyhtpP97lSAlrbSMKk0HXAnwqY8a+lsjk0TK1OPRdfLYY/q
         OJsdtzYDAvBRYfjS4wSeAZ3lvWDI5XWzSIBtae1qu0dx1jjb4pYAS9eqHMsozxl3q+5G
         ywP4gf6g09rObPi0Q0SX6sqcSlacL65dpSgccU10d4NaQXsbNYgBMjIkpoKCwgE/vpIV
         QQMzbuHyug8oqxb2OnRaXfJNcnkpNwIyF0dER60IbNY/yjp1WvBeTaYbgYZmxiRQ/+PF
         qzbw==
X-Gm-Message-State: AOAM532+SuocdvVBIrhU8BCR8ALcbHwmhPhIlnjaU5ZXOHgT31brbIls
        lqR9SkHn2cyJw5de+67rABVQVcRtJy6Hlo/wJuLCOg==
X-Google-Smtp-Source: ABdhPJy2gu0tDC5WhYjHtQF6czHGKSOazQIK8LghHcIk5r+jBxkKau7i12HuAvABjkDaXo4YADzfuQ3fil8BbswFE98=
X-Received: by 2002:adf:f50a:: with SMTP id q10mr3373731wro.252.1644434663498;
 Wed, 09 Feb 2022 11:24:23 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com> <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
In-Reply-To: <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
From:   David Dunn <daviddunn@google.com>
Date:   Wed, 9 Feb 2022 11:24:11 -0800
Message-ID: <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Dave,

In my opinion, the right policy depends on what the host owner and
guest owner are trying to achieve.

If the PMU is being used to locate places where performance could be
improved in the system, there are two sub scenarios:
   - The host and guest are owned by same entity that is optimizing
overall system.  In this case, the guest doesn't need PMU access and
better information is provided by profiling the entire system from the
host.
   - The host and guest are owned by different entities.  In this
case, profiling from the host can identify perf issues in the guest.
But what action can be taken?  The host entity must communicate issues
back to the guest owner through some sort of out-of-band information
channel.  On the other hand, preempting the host PMU to give the guest
a fully functional PMU serves this use case well.

TDX and SGX (outside of debug mode) strongly assume different
entities.  And Intel is doing this to reduce insight of the host into
guest operations.  So in my opinion, preemption makes sense.

There are also scenarios where the host owner is trying to identify
systemwide impacts of guest actions.  For example, detecting memory
bandwidth consumption or split locks.  In this case, host control
without preemption is necessary.

To address these various scenarios, it seems like the host needs to be
able to have policy control on whether it is willing to have the PMU
preempted by the guest.

But I don't see what scenario is well served by the current situation
in KVM.  Currently the guest will either be told it has no PMU (which
is fine) or that it has full control of a PMU.  If the guest is told
it has full control of the PMU, it actually doesn't.  But instead of
losing counters on well defined events (from the guest perspective),
they simply stop counting depending on what the host is doing with the
PMU.

On the other hand, if we flip it around the semantics are more clear.
A guest will be told it has no PMU (which is fine) or that it has full
control of the PMU.  If the guest is told that it has full control of
the PMU, it does.  And the host (which is the thing that granted the
full PMU to the guest) knows that events inside the guest are not
being measured.  This results in all entities seeing something that
can be reasoned about from their perspective.

Thanks,

Dave Dunn

On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:

> > I was referring to gaps in the collection of data that the host perf
> > subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
> > guest. This can potentially be a problem if someone is trying to
> > measure events per unit of time.
>
> Ahh, that makes sense.
>
> Does SGX cause problem for these people?  It can create some of the same
> collection gaps:
>
>         performance monitoring activities are suppressed when entering
>         an opt-out (of performance monitoring) enclave.
