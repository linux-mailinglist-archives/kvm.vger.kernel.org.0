Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7A4B2C6E
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349177AbiBKSJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:09:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBKSJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:09:05 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6259CE9
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:09:03 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so11185160ooq.10
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 10:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ezZKO/sKq+udK33lTp4upgqqXdLXoYIeBL3uXEwM8c=;
        b=jB6g23e56s6dlqAXLs7ZEmhT9fEgfh3KilZ2gYZFLE65prmgzUU8dBD29sSysYRq+D
         GW6fDxC9rgaZjkWi2Y95CbiiK87nu+2uFUOTUfdJ+iPDVqUcpfqVyu+XZkM3rOM0MXUm
         qBwUHSvY8zVLycV3H+FyQJ5vyyzGZLFy3V4sZGXfUPy4puPy7XYfRdBskcyXdu8wI4dg
         TL4ScxcQDo9XV2BxdgzdEvWAMIfn1GEhHrv7v2qK2OcFS3f/VRHiwb/jtt7FtPxYpeqL
         OQW9zCqltpG0LEX4pWnJpP45+guJuWrYnJcwTHgA/0cqvjkQqGSpwSXKWuqd7GQINsvO
         9j8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ezZKO/sKq+udK33lTp4upgqqXdLXoYIeBL3uXEwM8c=;
        b=YrKTVfNRlsKI+I1X5RLut8LAcMF9iESYaOucnuzxQECwuJ5n34IXWMewuApcbTKKoQ
         TddDMPFp9pEgp216wJ+ifuIhtprKJuouYcbOTPvACF6aEu2z8f1/K+3eJxvaktZRtxc2
         lneSI/DjK+lkell+BEgY0cUqwmhC0L2psTYdnALbzdMEtUN5aIFAg+ar2qZcSmCk01kr
         F/UlTTwb57F5Ti+6cd8r3cCHt6E3snZT2DTCguKuc4vvKea/rh0jc5kFvpSwfU/gC1M0
         atrz6x44gw9pOu0VBGXoULrYGscG89OM8cPueNOF8Dv1updzgYoFAc1gyviq9+CMbhbV
         eHgw==
X-Gm-Message-State: AOAM530oZXtx7BANXORC5RIlyCQCkgHZt4cwTei83t9B46Xe1CkXL7H7
        C0cTcHIseRqBoiwZ1jw+kkn8Khf+qbYt6XeQP4Bxgg==
X-Google-Smtp-Source: ABdhPJzDrQu5cX510rTOl/VIAVY5rNtKtn3RwhoxPtItyUuUtGU7Po7ow1yWOe7wNOGNq6HZrcnnns2k184OCBimA2g=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr529381oan.139.1644602942929;
 Fri, 11 Feb 2022 10:09:02 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com> <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com> <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
 <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com>
In-Reply-To: <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 11 Feb 2022 10:08:51 -0800
Message-ID: <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
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

On Fri, Feb 11, 2022 at 6:11 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 2/10/2022 2:55 PM, David Dunn wrote:
> > Kan,
> >
> > On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >
> >> No, we don't, at least for Linux. Because the host own everything. It
> >> doesn't need the MSR to tell which one is in use. We track it in an SW way.
> >>
> >> For the new request from the guest to own a counter, I guess maybe it is
> >> worth implementing it. But yes, the existing/legacy guest never check
> >> the MSR.
> >
> > This is the expectation of all software that uses the PMU in every
> > guest.  It isn't just the Linux perf system.
> >
> > The KVM vPMU model we have today results in the PMU utilizing software
> > simply not working properly in a guest.  The only case that can
> > consistently "work" today is not giving the guest a PMU at all.
> >
> > And that's why you are hearing requests to gift the entire PMU to the
> > guest while it is running. All existing PMU software knows about the
> > various constraints on exactly how each MSR must be used to get sane
> > data.  And by gifting the entire PMU it allows that software to work
> > properly.  But that has to be controlled by policy at host level such
> > that the owner of the host knows that they are not going to have PMU
> > visibility into guests that have control of PMU.
> >
>
> I think here is how a guest event works today with KVM and perf subsystem.
>      - Guest create an event A
>      - The guest kernel assigns a guest counter M to event A, and config
> the related MSRs of the guest counter M.
>      - KVM intercepts the MSR access and create a host event B. (The
> host event B is based on the settings of the guest counter M. As I said,
> at least for Linux, some SW config impacts the counter assignment. KVM
> never knows it. Event B can only be a similar event to A.)
>      - Linux perf subsystem assigns a physical counter N to a host event
> B according to event B's constraint. (N may not be the same as M,
> because A and B may have different event constraints)
>
> As you can see, even the entire PMU is given to the guest, we still
> cannot guarantee that the physical counter M can be assigned to the
> guest event A.

All we know about the guest is that it has programmed virtual counter
M. It seems obvious to me that we can satisfy that request by giving
it physical counter M. If, for whatever reason, we give it physical
counter N isntead, and M and N are not completely fungible, then we
have failed.

> How to fix it? The only thing I can imagine is "passthrough". Let KVM
> directly assign the counter M to guest. So, to me, this policy sounds
> like let KVM replace the perf to control the whole PMU resources, and we
> will handover them to our guest then. Is it what we want?

We want PMU virtualization to work. There are at least two ways of doing that:
1) Cede the entire PMU to the guest while it's running.
2) Introduce a new "ultimate" priority level in the host perf
subsystem. Only KVM can request events at the ultimate priority, and
these requests supersede any other requests.

Other solutions are welcome.

> Thanks,
> Kan
