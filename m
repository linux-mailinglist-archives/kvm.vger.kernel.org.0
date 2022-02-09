Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730CF4AFF53
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 22:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiBIVlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 16:41:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiBIVlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 16:41:08 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD92DD94E67
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 13:41:05 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id o9-20020a9d7189000000b0059ee49b4f0fso2486286otj.2
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 13:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aHgHlx+I4QHtl3iX+6OuSr5CkYEtvnBUXLfXjTOaODE=;
        b=aFLE3Sjwg9KjXg+ImFrILwTfJ8PL3XrJ4Z9i/cP4F+YFLmiLfYSp+6ZJegH1P6cHcz
         vYJNw0Vna35dmxSydTmDg8r/FChAUI1cCoWELakZrbcmMgsUgqFr5YZPCM9B0L9L7602
         Lybx5sq5KuYHnnFWdEiLbLuFNRS6N+xIoS72LpbXPx6Du4VTm4Sc5EteVlcRhG1y3y9Q
         69ar3KOkGOpKpG7FBF60e3xliDh5xpVrjEgPUwh5LqlAhlH4l6rNUkjT1ESkaFgF8QeC
         PyyDQFReN4T3EuAhZQpWljlNiUOLINnmcmNzQFm8V1K/wyknMkykuqJk7GyfN1Bm+mf6
         zpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aHgHlx+I4QHtl3iX+6OuSr5CkYEtvnBUXLfXjTOaODE=;
        b=6CoUKlrmm0kUTpmGdBAEsecl3rFBL1hGUU+lAJFmtpjyH0sLRDepuwL3pbQ+jrKDTu
         oO1VNU+PQYU90JfoWPpTJHVLWQO0kiSxVHzccjOH9Ls7U8Ibecfxt9E5RIgkjeL2At0Z
         DQOJz8qPOSNFo+0wBMpQB7DxyrQC7vH/76YlV2lRXxYJXwAvkaUKAQfcKFw3Rrmy7nr4
         DwTDKLOT3tiaHxF0sRzM9nVjAAVVBNcQpYKVunQHhXmx2kaAKABxk4wLbVDHpV9Ao8eG
         7pFMfigdXZWh85wAdW935d2ZYBlqmK1WbzoIPt/Az67GeYdx8zRUpfrboA+Cue9xOSHa
         Ly8w==
X-Gm-Message-State: AOAM531KdSATCj61I11rA75AO7Wizkj70nDGG8bUJ3jh79np3Rr8wboG
        nurVzQ0stmy8dtLYzOGtkV1QUs0+/bMWMzIyuvUoDA==
X-Google-Smtp-Source: ABdhPJyhcF730ksvNR2DpRX8vO6wF3Lmwu+B55F3OSAatSrYKYz+vfnugJ21Spp70ny8Akdj/QYtOH3Zu0KRER4fzz8=
X-Received: by 2002:a9d:4e03:: with SMTP id p3mr1825652otf.299.1644442864980;
 Wed, 09 Feb 2022 13:41:04 -0800 (PST)
MIME-Version: 1.0
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com> <20220202105158.7072-1-ravi.bangoria@amd.com>
 <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
 <3c97e081-ae46-d92d-fe8f-58642d6b773e@amd.com> <CALMp9eS72bhP=hGJRzTwGxG9XrijEnGKnJ-pqtHxYG-5Shs+2g@mail.gmail.com>
 <9b890769-e769-83ed-c953-d25930b067ba@amd.com> <CALMp9eQ9K+CXHVZ1zSyw78n-agM2+NQ1xJ4niO-YxSkQCLcK-A@mail.gmail.com>
 <e58ca80c-b54c-48b3-fb0b-3e9497c877b7@gmail.com>
In-Reply-To: <e58ca80c-b54c-48b3-fb0b-3e9497c877b7@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Feb 2022 13:40:53 -0800
Message-ID: <CALMp9eRuBwj9Sg60jg2ucWd-XoAcE_kXP5ULFgpkSHg88sOJZQ@mail.gmail.com>
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h M00-0Fh
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Ravi Bangoria <ravi.bangoria@amd.com>, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 2:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 4/2/2022 9:01 pm, Jim Mattson wrote:
> > On Fri, Feb 4, 2022 at 1:33 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
> >>
> >>
> >>
> >> On 03-Feb-22 11:25 PM, Jim Mattson wrote:
> >>> On Wed, Feb 2, 2022 at 9:18 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
> >>>>
> >>>> Hi Jim,
> >>>>
> >>>> On 03-Feb-22 9:39 AM, Jim Mattson wrote:
> >>>>> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
> >>>>>>
> >>>>>> Perf counter may overcount for a list of Retire Based Events. Implement
> >>>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
> >>>>>> Revision Guide[1]:
> >>>>>>
> >>>>>>    To count the non-FP affected PMC events correctly:
> >>>>>>      o Use Core::X86::Msr::PERF_CTL2 to count the events, and
> >>>>>>      o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
> >>>>>>      o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
> >>>>>>
> >>>>>> Note that the specified workaround applies only to counting events and
> >>>>>> not to sampling events. Thus sampling event will continue functioning
> >>>>>> as is.
> >>>>>>
> >>>>>> Although the issue exists on all previous Zen revisions, the workaround
> >>>>>> is different and thus not included in this patch.
> >>>>>>
> >>>>>> This patch needs Like's patch[2] to make it work on kvm guest.
> >>>>>
> >>>>> IIUC, this patch along with Like's patch actually breaks PMU
> >>>>> virtualization for a kvm guest.
> >>>>>
> >>>>> Suppose I have some code which counts event 0xC2 [Retired Branch
> >>>>> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
> >>>>> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
> >>>>> percentage of my branch instructions are taken. On hardware that
> >>>>> suffers from erratum 1292, both counters may overcount, but if the
> >>>>> inaccuracy is small, then my final result may still be fairly close to
> >>>>> reality.
> >>>>>
> >>>>> With these patches, if I run that same code in a kvm guest, it looks
> >>>>> like one of those events will be counted on PMC2 and the other won't
> >>>>> be counted at all. So, when I calculate the percentage of branch
> >>>>> instructions taken, I either get 0 or infinity.
> >>>>
> >>>> Events get multiplexed internally. See below quick test I ran inside
> >>>> guest. My host is running with my+Like's patch and guest is running
> >>>> with only my patch.
> >>>
> >>> Your guest may be multiplexing the counters. The guest I posited does not.
> >>
> >> It would be helpful if you can provide an example.
> >
> > Perf on any current Linux distro (i.e. without your fix).
>
> The patch for errata #1292 (like most hw issues or vulnerabilities) should be
> applied to both the host and guest.

As I'm sure you are aware, guests are often not patched. For example,
we have a lot of Debian-9 guests running on Milan, despite the fact
that it has to be booted with "nopcid" due to a bug introduced on
4.9-stable. We submitted the fix and notified Debian about a year ago,
but they have not seen fit to cut a new kernel. Do you think they will
cut a new kernel for this patch?

> For non-patched guests on a patched host, the KVM-created perf_events
> will be true for is_sampling_event() due to get_sample_period().
>
> I think we (KVM) have a congenital defect in distinguishing whether guest
> counters are used in counting mode or sampling mode, which is just
> a different use of pure software.

I have no idea what you are saying. However, when kvm sees a guest
counter used in sampling mode, it will just request a PERF_TYPE_RAW
perf event with the INT bit set in 'config.' If it sees a guest
counter used in counting mode, it will either request a PERF_TYPE_RAW
perf event or a PERF_TYPE_HARDWARE perf event, depending on whether or
not it finds the requested event in amd_event_mapping[].

> >
> >>> I hope that you are not saying that kvm's *thread-pinned* perf events
> >>> are not being multiplexed at the host level, because that completely
> >>> breaks PMU virtualization.
> >>
> >> IIUC, multiplexing happens inside the guest.
> >
> > I'm not sure that multiplexing is the answer. Extrapolation may
> > introduce greater imprecision than the erratum.
>
> If you run the same test on the patched host, the PMC2 will be
> used in a multiplexing way. This is no different.
>
> >
> > If you count something like "instructions retired" three ways:
> > 1) Unfixed counter
> > 2) PMC2 with the fix
> > 3) Multiplexed on PMC2 with the fix
> >
> > Is (3) always more accurate than (1)?

Since Ravi has gone dark, I will answer my own question.

For better reproducibility, I simplified his program to:

int main() { return 0;}

On an unpatched Milan host, I get instructions retired between 21911
and 21915. I get branch instructions retired between 5565 and 5566. It
does not matter if I count them separately or at the same time.

After applying v3 of Ravi's patch, if I try to count these events at
the same time, I get 36869 instructions retired and 4962 branch
instructions on the first run. On subsequent runs, perf refuses to
count both at the same time. I get branch instructions retired between
5565 and 5567, but no instructions retired. Instead, perf tells me:

Some events weren't counted. Try disabling the NMI watchdog:
echo 0 > /proc/sys/kernel/nmi_watchdog
perf stat ...
echo 1 > /proc/sys/kernel/nmi_watchdog

If I just count one thing at a time (on the patched kernel), I get
between 21911 and 21916 instructions retired, and I get between 5565
and 5566 branch instructions retired.

I don't know under what circumstances the unfixed counters overcount
or by how much. However, for this simple test case, the fixed PMC2
yields the same results as any unfixed counter. Ravi's patch, however
makes counting two of these events simultaneously either (a)
impossible, or (b) highly inaccurate (from 10% under to 68% over).

> The loss of accuracy is due to a reduction in the number of trustworthy counters,
> not to these two workaround patches. Any multiplexing (whatever on the host or
> the guest) will result in a loss of accuracy. Right ?

Yes, that's my point. Fixing one inaccuracy by using a mechanism that
introduces another inaccuracy only makes sense if the inaccuracy you
are fixing is worse than the inaccuracy you are introducing. That does
not appear to be the case here, but I am not privy to all of the
details of this erratum.
