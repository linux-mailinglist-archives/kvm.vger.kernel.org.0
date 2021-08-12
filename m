Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A763EA9B5
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhHLRpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhHLRpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 13:45:04 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF71C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:44:38 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id c5so254793ybn.5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+aiqTYSe5wEB+/XcJy9dxj2CSTkGf/RX6WDL9mPIf8=;
        b=I0bkPe4B0G1RjKMlB8HUOpivnGU0rpG9nHq77E7HElMUnCVb43Jz5byttgPEzfXskF
         HbDeEBUnLOy3rG9XwawEA9k6jU3kYe4Yjcdx4sK1Rx3KNs5ji4ej4x1HXJt+uTSOdKSQ
         tAym/UZ6iVAWpf5NsUKT8m4fv46JcrfV+A4/3HtpO6kh0E98kgCrdrrXggCMI7BS6NUA
         ZL5xTgirQ6o14kIuBDuholPNQiAG0feg5XIaegqOygUFe89oLZyNIb55J41ccH55DQRl
         IBCLjDN3pkLLwczUhaa6IZ2HOCzAKktp/lf5224HsARkMHUR4hOj6xCivP2LwPV1mIXo
         Byyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+aiqTYSe5wEB+/XcJy9dxj2CSTkGf/RX6WDL9mPIf8=;
        b=ud9ALOi5uHznUltOJa1VlaTs81FpKTMtzKXvAjOjz6E/Wqflhqjj5szLygJErgaFL7
         NE2PL0Dn+0Ngeidr9aJ//JQjkZGQRjpOx9jX0KVw1dAMslYWbGSatUnltFvup2cGmrAU
         xvfipQvBOQeMdhvdvXuWq+XtdR3Qf1LTmIqlWL1SplGZ1qN4wYXa/0OqIgsYJ+XJStuZ
         ZtPVMNwV3olZIoZ1PGCMNuoAzcje3oDjWl3ooy0Xb3PD4cQ7mXxQuPiaYWgcxXalzjBf
         wRFxSe1IhOPD6WExAel2asPW805ZT72q+efEvng4QbVZrKQLAND4aTDCQmTgr8oVzJVf
         +Eaw==
X-Gm-Message-State: AOAM532BdpECbe9mS8R8cBBlQ0IPBN7F+RdQ7XYuOfEkkoxlnRJDiixP
        iQjiHZ4YJLJte3nwuzPucQPmvBW95GWZiv1nhZ6IFw==
X-Google-Smtp-Source: ABdhPJxxPQ5rgi+YtVzjr69olpucyooJhOWpAMt9MsyLTfemdp7mVsRkqIeY5F5W/k7Zsd5NwXDMT4eW4sh5fcjo/UA=
X-Received: by 2002:a25:ad48:: with SMTP id l8mr5732786ybe.92.1628790277482;
 Thu, 12 Aug 2021 10:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com> <20210803044607.599629-4-mizhang@google.com>
 <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
 <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
 <CAL715WLO9+CpNa4ZQX4J2OdyqOBsX0+g0M4bNe+A+6FVxB2OxA@mail.gmail.com>
 <YRMKPd2ZarXCX6vm@t490s> <CAL715WJWPzBqmjeTJ6mZa=dUaF5+MdqaCrk5CEzvcz1X99cm0g@mail.gmail.com>
 <YRPMxLdL5vsZRyux@t490s>
In-Reply-To: <YRPMxLdL5vsZRyux@t490s>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 12 Aug 2021 10:44:26 -0700
Message-ID: <CAL715WK+uSx3MjRH7NcMsBELz9-2jmWhJs0c3+_atto0iv8UOg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Peter Xu <peterx@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,


On Wed, Aug 11, 2021 at 6:12 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Aug 10, 2021 at 06:06:51PM -0700, Mingwei Zhang wrote:
> > Regarding the pursuit for accuracy, I think there might be several
> > reasons. One of the most critical reasons that I know is that we need
> > to ensure dirty logging works correctly, i.e., when dirty logging is
> > enabled, all huge pages (both 2MB and 1GB) _are_ gone. Hope that
> > clarifies a little bit?
>
> It's just for statistics, right?  I mean dirty log should be working even
> without this change.

That's true. What I meant was that the accurate stats might be able to
help verifying a property of dirty logging as a side benefit. Sorry
for the confusion.

>
> But I didn't read closely last night, so we want to have "how many huge pages
> we're mapping", not "how many we've mapped in the history".  Yes that makes
> sense to be accurate.  I should have looked more carefully, sorry.
>
> PS: it turns out atomic is not that expensive as I thought even on a 200 core
> system, which takes 7ns (but for sure it's still expensive than normal memory
> ops, and bus locking); I thought it'll be bigger as on a 40 core system I got
> 15ns which is 2x of my laptop of 8 cores, but it didn't really grow but shrink.

Thanks for the information about atomic access!
>
> Thanks,
>
> --
> Peter Xu
>
