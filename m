Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8F03E4EB9
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 23:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhHIVuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhHIVuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 17:50:21 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B69C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 14:50:00 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so2705770otq.2
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 14:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6lFWU9kEs8Duz3Qg+FWy3/e8wqjXbR0QLyXUPO6V1Cc=;
        b=V+cJP3sRChCECwUX2o9rH1D4X4ebBprSyPlS7FnKPA8m+8z+5UyrAfX8DIjf/bFGH6
         Jwckq3Wl505pTQX6VkmS1rCtIUtztxN+lkyKR49DsfGtm7OsoVHx3aX52g4Atj73o1Q5
         KCQ+YaPHPAVQy7kZpUBPWnIka0FAHFST8zgoXkT9exGJ/VFhuUuLmMLQt8aXsMh/HPgx
         vPLTOJW3fHlXHG1cuT3tQKRYr9rQ49maE+EKY1m6ZrR9LUjJrmTgTlPy9JzCT1I7umRn
         QfewxzTxHHHVvblLKjp0jnl4Dx5xsxXHO8zFQ0jeDe9AJhIbNK5q/LdODlu9IuRetFG9
         sbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6lFWU9kEs8Duz3Qg+FWy3/e8wqjXbR0QLyXUPO6V1Cc=;
        b=Vwm1EqlhFjvErjW3hHOwDkpaVLXv3T9vjZjIozzJN9lu5SQtaOxvymyZxBtvpZ+40N
         HOiFPmSTOGlR0yfQ6CkVZrJTiQyZ7RY9yyAlwqN9Np8bw79Kib25hV7IjtlYXFXZ4H+n
         TMADKxkY4Gpr4UU5u1MSXGeQ+AYpfHrf+fIID2ZbCHHd9X4mQDYvalJsAzoFvMVi4m4W
         tIMaxSzHlAl/NkS5oj3qlidw9fO8+YieT8h58CiqFbQ35pDHtkI+X/mQaobrV5JVZAno
         N8XAjZ1+8OmBUHrog5rT+9tpPit2+gnaE8UKR/1bWZGLCH8EC8HAo5IVxpU6rnlNwlTX
         2WlQ==
X-Gm-Message-State: AOAM532yo2atUArmrkx9FtnZ36mh+KXOY6UtrPuvWJiJ6NPtRmTpqJPk
        O+GUwkAwyhpf3WLexfYc9UUKAis3XdUk92hqlAdwnQ==
X-Google-Smtp-Source: ABdhPJypJo0ED8L4D6wXXyqgHozZ8CZMHZC1NwUp2nBQL5+CtqP/9WDutwZDhI5dtQxQhpSm9h87R4SvFwgmUdyvnSs=
X-Received: by 2002:a05:6830:108d:: with SMTP id y13mr15967673oto.295.1628545799270;
 Mon, 09 Aug 2021 14:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210808192658.2923641-1-wei.huang2@amd.com> <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com> <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com> <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com> <YRFKABg2MOJxcq+y@google.com>
In-Reply-To: <YRFKABg2MOJxcq+y@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Aug 2021 14:49:47 -0700
Message-ID: <CALMp9eRfuntBFz=gnsvEuTXAXZorWJFAPq0ZdwZePxxQYGzdQA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP level
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 9, 2021 at 8:30 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 09, 2021, Yu Zhang wrote:
> > On Sun, Aug 08, 2021 at 11:33:44PM -0500, Wei Huang wrote:
> > >
> > > On 8/8/21 11:27 PM, Yu Zhang wrote:
> > > > On Sun, Aug 08, 2021 at 11:11:40PM -0500, Wei Huang wrote:
> > > > >
> > > > >
> > > > > On 8/8/21 10:58 PM, Yu Zhang wrote:
> > > > > > On Sun, Aug 08, 2021 at 02:26:56PM -0500, Wei Huang wrote:
> > > > > > > AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.
> > > > > >
> > > > > > Sorry, but why? NPT is not indexed by HVA.
> > > > >
> > > > > NPT is not indexed by HVA - it is always indexed by GPA. What I meant is NPT
> > > > > page table level has to be the same as the host OS page table: if 5-level
> > > > > page table is enabled in host OS (CR4.LA57=1), guest NPT has to 5-level too.
> > > >
> > > > I know what you meant. But may I ask why?
> > >
> > > I don't have a good answer for it. From what I know, VMCB doesn't have a
> > > field to indicate guest page table level. As a result, hardware relies on
> > > host CR4 to infer NPT level.
> >
> > I guess you mean not even in the N_CR3 field of VMCB?
>
> Correct, nCR3 is a basically a pure representation of a regular CR3.
>
> > Then it's not a broken design - it's a limitation of SVM. :)
>
> That's just a polite way of saying it's a broken design ;-)

Doesn't this break legacy type 2 hypervisors that don't know anything
about 5-level NPT and don't have any control over whether or not the
host uses 5-level paging?

> Joking aside, NPT opted for a semblance of backwards compatibility at the cost of
> having to carry all the baggage that comes with a legacy design.  Keeping the core
> functionality from IA32 paging presumably miminizes design and hardware costs, and
> required minimal enabling in hypervisors.  The downside is that it's less flexible
> than EPT and has a few warts, e.g. shadowing NPT is gross because the host can't
> easily mirror L1's desired paging mode.
