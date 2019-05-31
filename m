Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41054315C4
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 21:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfEaT7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 15:59:38 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41532 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfEaT7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 15:59:38 -0400
Received: by mail-ed1-f66.google.com with SMTP id x25so4018791eds.8
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 12:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SkRaYCGnq1C8VvlqaJ8i8zblsitHZj5v7WamNGN6H8=;
        b=u+WzyLtECMcbvjVI27nPUY/f1sNnnGQ4v95OEd2FRD+2RIN3aj6jzGAF/2PTtZkWbl
         IsTT3rCeorqDEpWXIuiNbgTjlGHWnHUr/D/sOZSUHeY0xjsMN9HKVI7kH6G0gclx6jkl
         B82MHaosoGQikbSAqSxEEk2TDrSJO/hPcw3taZ9jfyFUJ4ANImCDvahXr9qfh8f2T5BE
         FHCu+ECupVFYxp5GFBf5w0hdhwEUn3OgrWM+Py/pRkyzEODGAZgWcZ81VdDKzxCOPVfN
         6nLxbxuIKeaZTg+ce2C7SPKFLQaUE7po1agK96jvrVl4UCS91D4hCsJWwk8pQ0eJ7d9+
         0WLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3SkRaYCGnq1C8VvlqaJ8i8zblsitHZj5v7WamNGN6H8=;
        b=MHiwnkxngy4MQsepRXfmIuAG/beICdtkdIKGFNLdoVBlGSgYi7IvaJzOesv8POpNCt
         LOw4a+zq/5ABUZfVBeDpeb6GaOTmtNkfI6qBmW9XRcEDCtB8R5tGHnVTGDOE6Ekz2S73
         jCSFAEqA0Jhb49WiEqUtyEuZqGvXwXVYjl1G2lgtebQvL8mJ0xVgur4GWl0gHgc9qx5l
         zZWDGN3dQkkbCwNDX7V6e5ydGYNhP23odMQWhXjkpKA/rPBoz1PMO576T4buymbrhqYs
         B25cZinSKQZSLp7Sbot0qjZdKWKEkzTELhLNSm7mpDVjjdsiDhPI/69Al7HaRJ1gfqdO
         rByg==
X-Gm-Message-State: APjAAAXvrYNtG+NcD7d/yzqiKY36PIfXuuYVex0wjzw7gc5MmSiCYlkR
        jXewyYNsrx7CPB/+67tqs2rMaOw/q3URnOJzVTGE5Q==
X-Google-Smtp-Source: APXvYqwCViODZUf7+K8dCeviTHiMP+R9s9zcehJqctp1p3kVpVxvg6odZUTsjoHWEEexh9KnE9DVXLpFwc9HMKyIdjU=
X-Received: by 2002:a17:906:2922:: with SMTP id v2mr10871610ejd.115.1559332775551;
 Fri, 31 May 2019 12:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
 <5CEE3AC4.3020904@intel.com> <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com>
 <5CF07D37.9090805@intel.com>
In-Reply-To: <5CF07D37.9090805@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Fri, 31 May 2019 12:59:24 -0700
Message-ID: <CAOyeoRXWQaVYZSVL_LTTdAwJOEr+eCzhp1=_JcOX3i6_CJiD_g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 30, 2019 at 5:57 PM Wei Wang <wei.w.wang@intel.com> wrote:
>
> On 05/30/2019 01:11 AM, Eric Hankland wrote:
> > On Wed, May 29, 2019 at 12:49 AM Wei Wang <wei.w.wang@intel.com> wrote:
> >> On 05/29/2019 02:14 AM, Eric Hankland wrote:
> >>> On Mon, May 27, 2019 at 6:56 PM Wei Wang <wei.w.wang@intel.com> wrote:
> >>>> On 05/23/2019 06:23 AM, Eric Hankland wrote:
> >>>>> - Add a VCPU ioctl that can control which events the guest can monitor.
> >>>>>
> >>>>> Signed-off-by: ehankland <ehankland@google.com>
> >>>>> ---
> >>>>> Some events can provide a guest with information about other guests or the
> >>>>> host (e.g. L3 cache stats); providing the capability to restrict access
> >>>>> to a "safe" set of events would limit the potential for the PMU to be used
> >>>>> in any side channel attacks. This change introduces a new vcpu ioctl that
> >>>>> sets an event whitelist. If the guest attempts to program a counter for
> >>>>> any unwhitelisted event, the kernel counter won't be created, so any
> >>>>> RDPMC/RDMSR will show 0 instances of that event.
> >>>> The general idea sounds good to me :)
> >>>>
> >>>> For the implementation, I would have the following suggestions:
> >>>>
> >>>> 1) Instead of using a whitelist, it would be better to use a blacklist to
> >>>> forbid the guest from counting any core level information. So by default,
> >>>> kvm maintains a list of those core level events, which are not supported to
> >>>> the guest.
> >>>>
> >>>> The userspace ioctl removes the related events from the blacklist to
> >>>> make them usable by the guest.
> >>>>
> >>>> 2) Use vm ioctl, instead of vcpu ioctl. The blacklist-ed events can be
> >>>> VM wide
> >>>> (unnecessary to make each CPU to maintain the same copy).
> >>>> Accordingly, put the pmu event blacklist into kvm->arch.
> >>>>
> >>>> 3) Returning 1 when the guest tries to set the evetlsel msr to count an
> >>>> event which is on the blacklist.
> >>>>
> >>>> Best,
> >>>> Wei
> >>> Thanks for the feedback. I have a couple concerns with a KVM
> >>> maintained blacklist. First, I'm worried it will be difficult to keep
> >>> such a list up to date and accurate (both coming up with the initial
> >>> list since there are so many events, and updating it whenever any new
> >>> events are published or vulnerabilities are discovered).
> >> Not sure about "so many" above. I think there should be much
> >> fewer events that may need to be blacklisted.
> >>
> >> For example the event table 19-3 from SDM 19.2 shows hundreds of
> >> events, how many of them would you think that need to be blacklisted?
> >>
> >>> Second, users
> >>> may want to differentiate between whole-socket and sub-socket VMs
> >>> (some events may be fine for the whole-socket case) - keeping a single
> >>> blacklist wouldn't allow for this.
> >> Why wouldn't?
> >> In any case (e.g. the whole socket dedicated to the single VM) we
> >> want to unlock the blacklisted events, we can have the userspace
> >> (e.g. qemu command line options "+event1, +event2") do ioctl to
> >> have KVM do that.
> >>
> >> Btw, for the L3 cache stats event example, I'm not sure if that could
> >> be an issue if we have "AnyThread=0". I'll double confirm with
> >> someone.
> >>
> >> Best,
> >> Wei
> >> Not sure about "so many" above. I think there should be much
> >> fewer events that may need to be blacklisted.
> > I think you're right that there are not as many events that seem like
> > they could leak info as events that seem like they won't, but I think
> > the work to validate that they definitely don't could be expensive;
> > with a whitelist it's easy to start with a smaller set and
> > incrementally add to it without having to evaluate all the events
> > right away.
>
> Before going that whitelist/blacklist direction, do you have an event
> example that couldn't be solved by setting "AnyThread=0"?
>
> If no, I think we could simply gate guest's setting of "AnyThread=0".
>
> Best,
> Wei

With anythread=0, I'm not aware of any events that directly give info
about other VMs, but monitoring events related to shared resources
(e.g. LLC References and LLC Misses) could indirectly give you info
about how heavily other users are using that resource.

I tried returning 1 when the guest tries to write the eventsel msr for
a disallowed event - the behavior on modern guest kernels looks
reasonable (warns once about an unchecked MSR access error), but it
looks like guests using older kernels (older than 2016) might panic
due to the gpfault (not to mention I'm not sure about the behavior on
non-linux kernels). So I'm hesitant to return 1 - what do you think?

I also looked into moving from a vcpu ioctl to a vm ioctl - I can send
out a version of the patch with this change once we settle on the
other issues. It will involve some extra locking every time the
counters are programmed to ensure the whitelist or blacklist isn't
removed during access.

Eric
