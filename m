Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7A442323E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhJEUob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 16:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbhJEUoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 16:44:24 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79CAC061794
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 13:42:29 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so562481otj.2
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 13:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4l2bOWRPJ6yK+UIOgEy4dzXdCkIt+NVIOvQkMIX8D1U=;
        b=j0Y2nbQb1ryH+EYY5a7eo+rIbnZwMIoBjRzM6kpxuHyuADyrLDnexdH6e6QiyszdKs
         NM15boFo+tVL9iQQPcrxE3t1gYz90fb8Hhc/ISxdTa+IDz4fbUfrDdCGh+iKJOtvlgBD
         xjQkKxm2zRPrWmYQDqr2MD6D+xuT57RF2B1v/KWDBCK4nUQsrZ43Sp4K09N78ppQtgH8
         2a1kvQVU3uOpiZFfx+POTWOIfZs/4fwIWZrRBCP3UNpJP85Zri6ZTuJdJbI9eVllxqOQ
         kj4teIUHDjjhw/+gwcfFR8cx0cPGexxHOsU1UmZy7045z2Q5FRS85sXyPUpREmxFRtOH
         5rdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4l2bOWRPJ6yK+UIOgEy4dzXdCkIt+NVIOvQkMIX8D1U=;
        b=WKmdiE0YTYIiXQuelqBViqOEp84Wqm3Fe+skzgASutJq4H+zglMvF1VdBKr/O/7uMt
         b3Z4s58DUEFF+LPY2P8L1K5Fls1OyOwB5VKatyfMdygCwSjrSAzKGDb7mwL7+Cq05QPd
         cRYcbD0GHPGjtlVMPpBuUoONyJGPS8leBE7DyxV4Ux5dcNqi78KvEwum3v8Qah7vUfo9
         umXtPQib8IJQCVl4aSwuNYwV98HaqSvAzytOXdKMPVJ73jCQt+6iKBp0FsdVYTsbnQ6y
         t8gtoz5D+/ih8CvOxBp7xCGMe9AFIVEMbxJhaLTKep+VROiMrYJNzNLKbecKdj8/zb9M
         BU6g==
X-Gm-Message-State: AOAM5319mNrnpwCi8BKtriCFJaUlswaaHG2CO5NfCBI6iZk+TuozYSYs
        kWass1Ee3uEhnc0WCnaNKTMbZ0cCQihOMP0u8JPVug==
X-Google-Smtp-Source: ABdhPJyjGe9hDWBqjB5xQm9y17zD00pTUQjS8haSSOlDk/JwLMuLepF0zNetwbbKWONNOlfe68iAZfTkM72B6j9vpxo=
X-Received: by 2002:a9d:289:: with SMTP id 9mr2609612otl.172.1633466548951;
 Tue, 05 Oct 2021 13:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <YRvbvqhz6sknDEWe@google.com> <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com> <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com> <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com> <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com> <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com>
In-Reply-To: <YVySdKOWTXqU4y3R@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Oct 2021 13:42:17 -0700
Message-ID: <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 05, 2021, Jim Mattson wrote:
> > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > > >       You also said, "This is quite the complicated mess for
> > > > something I'm guessing no one actually cares about.  At what point do
> > > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > > -- I couldn't agree more.
> > >
> > > ...
> > >
> > > > So, Sean, can you help converge our discussion and settle next step?
> > >
> > > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > > the proverbial rug?
> >
> > Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> > hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> > unreasonable for VM-exit statistics, so maybe I've got a warped
> > perspective. I'm all for pedantic adherence to the specification, but
> > I have to admit that no actual hypervisor is likely to care (or ever
> > will).
>
> It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
> working correctly, both now and in the future.

As far as CPU feature virtualization goes, this one doesn't seem that
complex to me. It's not anywhere near as complex as virtualizing MTF,
for instance, and KVM *claims* to do that! :-)
