Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2B84B38A3
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 00:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiBLXbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 18:31:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiBLXbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 18:31:39 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2A5FF22
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:31:35 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso14942054ooi.1
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1JvWh818HSwyByKURfrR7CWWqjhqS9rtqWKqKohtLUk=;
        b=RXcSaFQPcpSmfaYbe4neY2ZS+2/rGm+c2h5VDDOLsSrZexZjmS9qDQLN6l10AxEL2a
         J+76Z7pvQk5A3oNz7HVY4t/S/9jF6TxcWlsvMNcq67JzwErPb1OTosgrxzRTLski4+Gc
         FYSNG9wfXbR/HNdCAut36GV5Bcls6Jh7dU23oKe59IAAOavePC++/SUXp7IAR1p9PMDi
         KQ0vKglEAbysPz6cRvOzPJRY0hfhvlrd8DooX5XFo1IiHhYJBQ4QKcKC+6CugfR/o584
         2W1H10oI8Qw59w+cKjkT8mv7YbEvebU6rPsBLwLkCjT7JuMwx6nzSKMMzMDHBnBW3QxN
         LFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1JvWh818HSwyByKURfrR7CWWqjhqS9rtqWKqKohtLUk=;
        b=OiwnXTh9PgdVFMYBlI1c43M8ZHKlxEHckds8mLtvYtigLj8i/4ECVDMhGHm7B34Wo6
         0jEBAIk8JgO94+Uqaj5GOJk+oc5OXRfzphJ3H0QO+zfwcFYslkvMWnYQfIb9qJwt8FNq
         V+3hA2ngPddYSvebvJeOzbRM7uVTW8aoy6DIwnpAhB6m3bi+2TZdcyaQn+LjRwn+QgCy
         HkcdrGhq+N0ZGCN9WhpqKrj6OoZZUFSRC2rIqLaqyxccSPeosXGtbFOkKGS9FX7pPv8J
         WXb/gXobdqJDEakOMcwEz3pvAYKx7uPWW/E/8NGi5fIWtdGsym12K7sYO4KTSMtCJIuo
         3Y3A==
X-Gm-Message-State: AOAM530BdkM7bi2j3kIGCZWf7jO6tt8eA4Kq3h0SIUOBTjcLMO/QkwND
        gMsNtp05rWRlOimeh0zkF3hZINvFJHAhc/kt70zr6Q==
X-Google-Smtp-Source: ABdhPJxH3r+FDefxhFe0oLgR4sC2K0ey7KUoa9KcfZhKjI7MgUxNQS7rWeqGxuKO1cJ+X/k4VxOKeTN72nxoWPtW6cc=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr2067111oan.139.1644708694863;
 Sat, 12 Feb 2022 15:31:34 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com> <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com> <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
 <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com> <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
 <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com>
In-Reply-To: <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 12 Feb 2022 15:31:23 -0800
Message-ID: <CALMp9eQiaXtF3S0QZ=2_SWavFnv6zFHqf_zFXBrxXb9pVYh0nQ@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022 at 1:47 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 2/11/2022 1:08 PM, Jim Mattson wrote:
> > On Fri, Feb 11, 2022 at 6:11 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>
> >>
> >>
> >> On 2/10/2022 2:55 PM, David Dunn wrote:
> >>> Kan,
> >>>
> >>> On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>>
> >>>> No, we don't, at least for Linux. Because the host own everything. It
> >>>> doesn't need the MSR to tell which one is in use. We track it in an SW way.
> >>>>
> >>>> For the new request from the guest to own a counter, I guess maybe it is
> >>>> worth implementing it. But yes, the existing/legacy guest never check
> >>>> the MSR.
> >>>
> >>> This is the expectation of all software that uses the PMU in every
> >>> guest.  It isn't just the Linux perf system.
> >>>
> >>> The KVM vPMU model we have today results in the PMU utilizing software
> >>> simply not working properly in a guest.  The only case that can
> >>> consistently "work" today is not giving the guest a PMU at all.
> >>>
> >>> And that's why you are hearing requests to gift the entire PMU to the
> >>> guest while it is running. All existing PMU software knows about the
> >>> various constraints on exactly how each MSR must be used to get sane
> >>> data.  And by gifting the entire PMU it allows that software to work
> >>> properly.  But that has to be controlled by policy at host level such
> >>> that the owner of the host knows that they are not going to have PMU
> >>> visibility into guests that have control of PMU.
> >>>
> >>
> >> I think here is how a guest event works today with KVM and perf subsystem.
> >>       - Guest create an event A
> >>       - The guest kernel assigns a guest counter M to event A, and config
> >> the related MSRs of the guest counter M.
> >>       - KVM intercepts the MSR access and create a host event B. (The
> >> host event B is based on the settings of the guest counter M. As I said,
> >> at least for Linux, some SW config impacts the counter assignment. KVM
> >> never knows it. Event B can only be a similar event to A.)
> >>       - Linux perf subsystem assigns a physical counter N to a host event
> >> B according to event B's constraint. (N may not be the same as M,
> >> because A and B may have different event constraints)
> >>
> >> As you can see, even the entire PMU is given to the guest, we still
> >> cannot guarantee that the physical counter M can be assigned to the
> >> guest event A.
> >
> > All we know about the guest is that it has programmed virtual counter
> > M. It seems obvious to me that we can satisfy that request by giving
> > it physical counter M. If, for whatever reason, we give it physical
> > counter N isntead, and M and N are not completely fungible, then we
> > have failed.
> >
> >> How to fix it? The only thing I can imagine is "passthrough". Let KVM
> >> directly assign the counter M to guest. So, to me, this policy sounds
> >> like let KVM replace the perf to control the whole PMU resources, and we
> >> will handover them to our guest then. Is it what we want?
> >
> > We want PMU virtualization to work. There are at least two ways of doing that:
> > 1) Cede the entire PMU to the guest while it's running.
>
> So the guest will take over the control of the entire PMUs while it's
> running. I know someone wants to do system-wide monitoring. This case
> will be failed.

We have system-wide monitoring for fleet efficiency, but since there's
nothing we can do about the efficiency of the guest (and those cycles
are paid for by the customer, anyway), I don't think our efficiency
experts lose any important insights if guest cycles are a blind spot.

> I'm not sure whether you can fully trust the guest. If malware runs in
> the guest, I don't know whether it will harm the entire system. I'm not
> a security expert, but it sounds dangerous.
> Hope the administrators know what they are doing when choosing this policy.

Virtual machines are inherently dangerous. :-)

Despite our concerns about PMU side-channels, Intel is constantly
reminding us that no such attacks are yet known. We would probably
restrict some events to guests that occupy an entire socket, just to
be safe.

Note that on the flip side, TDX and SEV are all about catering to
guests that don't trust the host. Those customers probably don't want
the host to be able to use the PMU to snoop on guest activity.

> > 2) Introduce a new "ultimate" priority level in the host perf
> > subsystem. Only KVM can request events at the ultimate priority, and
> > these requests supersede any other requests.
>
> The "ultimate" priority level doesn't help in the above case. The
> counter M may not bring the precise which guest requests. I remember you
> called it "broken".

Ideally, ultimate priority also comes with the ability to request
specific counters.

> KVM can fails the case, but KVM cannot notify the guest. The guest still
> see wrong result.
>
> >
> > Other solutions are welcome.
>
> I don't have a perfect solution to achieve all your requirements. Based
> on my understanding, the guest has to be compromised by either
> tolerating some errors or dropping some features (e.g., some special
> events). With that, we may consider the above "ultimate" priority level
> policy. The default policy would be the same as the current
> implementation, where the host perf treats all the users, including the
> guest, equally. The administrators can set the "ultimate" priority level
> policy, which may let the KVM/guest pin/own some regular counters via
> perf subsystem. That's just my personal opinion for your reference.

I disagree. The guest does not have to be compromised. For a proof of
concept, see VMware ESXi. Probably Microsoft Hyper-V as well, though I
haven't checked.
