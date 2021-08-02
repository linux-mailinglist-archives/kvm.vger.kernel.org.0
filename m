Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9783DE2FA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 01:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhHBXVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 19:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbhHBXVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 19:21:12 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47652C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 16:20:59 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so4794890ooa.11
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 16:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8w12PAoOyshnfIeVIcs6vDqrBfUWg6+XWC9UUPVK5I=;
        b=DE6TuOOTJKOB46FXyy3y251nKg45Bt9pEx8UQg07uP/cFW7fTC4ajRa1NTQr2H1BDe
         cGkiZGwq12sHJi1drqeIvvluClxJ3HTUZxt7WG1/NzX23rKeB86ynXjx23fuUovrnP07
         PjloaN/LVb9MaO9OlwvBPeQ5BCT01sczoLkLhPY+l4pCaCA4b+a3XlJhHXlf86hxJGuX
         Cg3oleLwjCClzLV4Q6B/IwL4J9ufPFoZrhPzkh9I2Dud/DYcn9icZy8TW8LLNMft133F
         qc/Qyyf7O5C5qMi4676YL9CIMuGa55xxHFqjSuZF5zZXvcxBMPAfjBMf9WJWPNMoWjNJ
         0sUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8w12PAoOyshnfIeVIcs6vDqrBfUWg6+XWC9UUPVK5I=;
        b=EOBZpvm+MVZ1Z807ULOXYl4HQGe8MRKBopikCMeLj3ON9yDueK0i04IX7jkepc7f4x
         tPIipI5zyOp6arWLOT347sPNCajUAlXqOBGygqykdzEkMTGTZG26IShtpGBhYG2yzZGj
         K4IGaRGK92elQVQsZoA/G/kpYmRZpHDdVzNMjd4Et9S5bAyykFS0WZCS+LjExnq+Z8rt
         AFZesbr5DNcuklR3324QYtK3mj3pRs4doAbDRz+sADgCRf6vDYeZFvmh0q+uCervCrDr
         2fDr4e9d1/bQY3EawzlFCCIM9YiUXY+42d9+ISaZn7B35m+W4IdPfoVX7/GUr8bCWErI
         vWnQ==
X-Gm-Message-State: AOAM531qYgltsXjyLXBe4WfLA8nMtzaRzTdvSQX/dtRFTHApx2STrV5J
        4Dt7FjR9cgILnr8uPpL/IkcmDtRgrlSifDZoYzWljg==
X-Google-Smtp-Source: ABdhPJyyzKoOb4sEpymCIairtAk/22nVG/z2m+zeKOd/Bm5zGzIHlcevrsG4YLI4b7YmYsuWYaawEkCZcbQq5JbSvIM=
X-Received: by 2002:a4a:b105:: with SMTP id a5mr12463723ooo.81.1627946458293;
 Mon, 02 Aug 2021 16:20:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com> <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
 <YQgeoOpaHGBDW49Z@google.com> <68082174-4137-db39-362c-975931688453@redhat.com>
 <c0f5ae5d-da93-8877-ce00-ee87b0b3650c@oracle.com>
In-Reply-To: <c0f5ae5d-da93-8877-ce00-ee87b0b3650c@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Aug 2021 16:20:46 -0700
Message-ID: <CALMp9eQvEA8DDq03ny-EZpr0zjSMBmdiXCEdeaYe8qbvUknbGA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 2, 2021 at 3:21 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 8/2/21 9:39 AM, Paolo Bonzini wrote:
> > On 02/08/21 18:34, Sean Christopherson wrote:
> >> On Mon, Aug 02, 2021, Paolo Bonzini wrote:
> >>> On 21/06/21 22:43, Krish Sadhukhan wrote:
> >>>> With this patch KVM entry and exit tracepoints will
> >>>> show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
> >>>> nested guest.
> >>>
> >>> What about adding a "(nested)" suffix for L2, and nothing for L1?
> >>
> >> That'd work too, though it would be nice to get vmcx12 printed as
> >> well so that
> >> it would be possible to determine which L2 is running without having
> >> to cross-
> >> reference other tracepoints.
> >
> > Yes, it would be nice but it would also clutter the output a bit.
> > It's like what we have already in kvm_inj_exception:
> >
> >         TP_printk("%s (0x%x)",
> >                   __print_symbolic(__entry->exception,
> > kvm_trace_sym_exc),
> >                   /* FIXME: don't print error_code if not present */
> >                   __entry->has_error ? __entry->error_code : 0)
> >
> > It could be done with a trace-cmd plugin, but that creates other
> > issues since
> > it essentially forces the tracepoints to have a stable API.
> >
> > Paolo
>
>
> Also, the vmcs/vmcb address is vCPU-specific, so if L2 runs on 10 vCPUs,
> traces will show 10 different addresses for the same L2 and it's not
> convenient on a cloud host where hundreds of L1s and L2s run.

The vmcx02 address is vCPU-specific. However, Sean asked for the
vmcx12 address, which is a GPA that is common across all vCPUs.
