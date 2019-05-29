Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28DC2E2EB
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 19:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE2RMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 13:12:13 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44259 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfE2RMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 13:12:13 -0400
Received: by mail-ed1-f68.google.com with SMTP id b8so4823046edm.11
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 10:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtZZ2mauCSyv5FIfi7408NboHJJId3G3Hf0s1vyrqGw=;
        b=eGDWJ39iOdOntTvkvhZiKKpZL9AQLAIKs6vpVsHcTKkwqUnNwzQw62hBfGXmb+SdiS
         14SiapDyFWOZcySaVYui2GNfXxjkehfn+X1bGglg6DoOHmEbpGJOeSZ6x2FI6pATAZkw
         bQw1CpUHb9SH/+QIq6b0Gfh1PMgb5tIyZx0zLVnnFy1lYEpCDyrFrLzjsKrepfLLZEHP
         44QqqYoL35GgLIyiWHy+EyQIwvrQ/SGT32gCDnXOlkCY4GVeW49+XmJnQsYKKkzJnNGJ
         /rsNUKfEbAn6QF0vhlRrS1OC8WvVB1r5t/EN6kzEybXipHqL71AnTOhk38sri5DFvHWW
         dALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtZZ2mauCSyv5FIfi7408NboHJJId3G3Hf0s1vyrqGw=;
        b=UCn6IDa38tb2ByXW84JGdt4JKzlDdnbo8ue7eR8aQL4GY33TYtgRTs4c0EC6js5HVj
         yFkjHRxjczF97S2yY2bhCKzHjj4Ns5NPnPhn6UBDt5oVxHRun84wcS7reIYD/ENJsu9G
         XvJXEQlFL736HkokApaCgrvIO0uNVXBV9EsNXgBp22vl/jTAthAidc1Zez2mkcEaNdYp
         MjpD3s0Tac+YgC6O6LmO+Ke8N51Il7c5ehs9rQGYURXfcmE+SlkSINyTxZvcyAsw0x9t
         pTflR+CN7upJYdwl83pGM2SCXeHAedUauwjYlnoCZf1sD3S+Rp4JkUWn/TWP0nKX5+hF
         ysrQ==
X-Gm-Message-State: APjAAAVZDdHRf5no7+adJ/Dhso1xY3XDi8Ecp8PvMIytPlx8NV64w5tn
        zV9qvwjBOtv49JDHvnMGyIWkXHrSekWvAGypDO3/jw==
X-Google-Smtp-Source: APXvYqzyfGTZk7TLlL39ec2bvtZDUiRpFGbM4jyR3wu/qNp+hnKEkK1mNO6dpV45vCsYtQf6MWFz9Jr/jKh69txeXHU=
X-Received: by 2002:a17:906:b6cb:: with SMTP id ec11mr5916187ejb.215.1559149930839;
 Wed, 29 May 2019 10:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
 <5CEE3AC4.3020904@intel.com>
In-Reply-To: <5CEE3AC4.3020904@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Wed, 29 May 2019 10:11:59 -0700
Message-ID: <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 12:49 AM Wei Wang <wei.w.wang@intel.com> wrote:
>
> On 05/29/2019 02:14 AM, Eric Hankland wrote:
> > On Mon, May 27, 2019 at 6:56 PM Wei Wang <wei.w.wang@intel.com> wrote:
> >> On 05/23/2019 06:23 AM, Eric Hankland wrote:
> >>> - Add a VCPU ioctl that can control which events the guest can monitor.
> >>>
> >>> Signed-off-by: ehankland <ehankland@google.com>
> >>> ---
> >>> Some events can provide a guest with information about other guests or the
> >>> host (e.g. L3 cache stats); providing the capability to restrict access
> >>> to a "safe" set of events would limit the potential for the PMU to be used
> >>> in any side channel attacks. This change introduces a new vcpu ioctl that
> >>> sets an event whitelist. If the guest attempts to program a counter for
> >>> any unwhitelisted event, the kernel counter won't be created, so any
> >>> RDPMC/RDMSR will show 0 instances of that event.
> >> The general idea sounds good to me :)
> >>
> >> For the implementation, I would have the following suggestions:
> >>
> >> 1) Instead of using a whitelist, it would be better to use a blacklist to
> >> forbid the guest from counting any core level information. So by default,
> >> kvm maintains a list of those core level events, which are not supported to
> >> the guest.
> >>
> >> The userspace ioctl removes the related events from the blacklist to
> >> make them usable by the guest.
> >>
> >> 2) Use vm ioctl, instead of vcpu ioctl. The blacklist-ed events can be
> >> VM wide
> >> (unnecessary to make each CPU to maintain the same copy).
> >> Accordingly, put the pmu event blacklist into kvm->arch.
> >>
> >> 3) Returning 1 when the guest tries to set the evetlsel msr to count an
> >> event which is on the blacklist.
> >>
> >> Best,
> >> Wei
> > Thanks for the feedback. I have a couple concerns with a KVM
> > maintained blacklist. First, I'm worried it will be difficult to keep
> > such a list up to date and accurate (both coming up with the initial
> > list since there are so many events, and updating it whenever any new
> > events are published or vulnerabilities are discovered).
>
> Not sure about "so many" above. I think there should be much
> fewer events that may need to be blacklisted.
>
> For example the event table 19-3 from SDM 19.2 shows hundreds of
> events, how many of them would you think that need to be blacklisted?
>
> > Second, users
> > may want to differentiate between whole-socket and sub-socket VMs
> > (some events may be fine for the whole-socket case) - keeping a single
> > blacklist wouldn't allow for this.
>
> Why wouldn't?
> In any case (e.g. the whole socket dedicated to the single VM) we
> want to unlock the blacklisted events, we can have the userspace
> (e.g. qemu command line options "+event1, +event2") do ioctl to
> have KVM do that.
>
> Btw, for the L3 cache stats event example, I'm not sure if that could
> be an issue if we have "AnyThread=0". I'll double confirm with
> someone.
>
> Best,
> Wei

> Not sure about "so many" above. I think there should be much
> fewer events that may need to be blacklisted.

I think you're right that there are not as many events that seem like
they could leak info as events that seem like they won't, but I think
the work to validate that they definitely don't could be expensive;
with a whitelist it's easy to start with a smaller set and
incrementally add to it without having to evaluate all the events
right away.

> > (some events may be fine for the whole-socket case) - keeping a single
> > blacklist wouldn't allow for this.
>
> Why wouldn't?

Ah I think I misunderstood your proposal (as an ioctl that would just
enable a hardcoded blacklist). Now that I understand, my main
objection is just the above (coupled with the trouble of needing to
maintain the "default" blacklist).

Eric
