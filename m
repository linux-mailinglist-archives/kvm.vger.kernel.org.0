Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C56D23B55D
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 09:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgHDHIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 03:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgHDHIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 03:08:13 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B74C06174A
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 00:08:12 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c4so4313726otf.12
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 00:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeDUTRUrE1gk7vCCSRrRZwx8cho+e+eBqdVW5IdKYew=;
        b=cWKSbXHJBoZqVh+ZMJcDDl39cl8sYoOXbvBotGoMvJFnwiRcc89ROGxr9dgsvZIvVR
         LqeQP3VMnEe09lvc/bO7QyIjTVO/fUTv1sBakFYRNI3d0PlX9CUoMvdhgmIVWBesZZtD
         xIYCoF27YMTMKXdHEPqxc/xGzC8IjgNUJjTm2abpTDo/zCL3ra+X+cf7ISb0hPUdCrZA
         se0orMKBR1hLtrKcx0n00/uGM1+BJ82PTke+Qn5siznl3IPWkTyI9f4pTJOKoMoukvmy
         JohcG0Sgb6PegQYDPCpKaIcRT8bNDllst/kkYd8RtHV/5oyAk8+htKKSSttJRp3W8u2f
         OIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeDUTRUrE1gk7vCCSRrRZwx8cho+e+eBqdVW5IdKYew=;
        b=kskmn7P2oyP5ct4sYgP+c0dgBifXkSeGwowWd2lG2KACtH3nr6tjEOrTQ41K4nBFbA
         RqvJg70Gd1oR4OT8+G/POyR+kq3Yfx4rRItL9SYucs3uD3xTJdsrBq0en6f3tGREkyuM
         XvTgFztsW2hH1eZLvlbtCVazHg3cD2n7bBpagq4rEyD+m/JUXifuvXFlhl0oWI+vdSLj
         INnjazERex8v4fLObK9aujHryCSRW8OeZWyp5j+nDwSuzOCm5lOXzrr3EGGGj0FsCILF
         bmUxz7Nqe6bMURHddG9cj8XpqiOlNHsD6IFpKMQA3v4eMuUWxTuvpiNfTSlTQAoqlKNW
         bTjw==
X-Gm-Message-State: AOAM531hE6DAQ8TUTGskUuI+gIaKjXbjtnlY7GCtcP3XibH6nSFFu17l
        cF6+CmMzrhBJtDi2npgvE4tUhHRYZIfAGqCcgdIarA==
X-Google-Smtp-Source: ABdhPJzE5GE1URw8Iz6ERFrCy7/PaMhvhFMHPYcNOyr2Ldht3Ud9jdr/JfDLEOur9HFQcnDTv8YZT3knmFc3Tcj0Y0o=
X-Received: by 2002:a9d:c44:: with SMTP id 62mr1897628otr.185.1596524892032;
 Tue, 04 Aug 2020 00:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <1596441715-14959-1-git-send-email-wanpengli@tencent.com>
 <87wo2fq4up.fsf@vitty.brq.redhat.com> <aa3131be-5421-5a06-c582-232d6b34fe38@redhat.com>
In-Reply-To: <aa3131be-5421-5a06-c582-232d6b34fe38@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 4 Aug 2020 15:08:01 +0800
Message-ID: <CANRm+Cx99z11opDAg0+6d=+aToa8BuhdkfYxxQEPkv38=PsYYA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: tscdeadline timer testing when apic
 is hw disabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Aug 2020 at 20:56, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/08/20 14:41, Vitaly Kuznetsov wrote:
> >> -    report(tdt_count == 1, "tsc deadline timer");
> >> -    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
> >> +    if (apic_enabled) {
> >> +        report(tdt_count == 1, "tsc deadline timer");
> >> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
> >> +    } else
> >> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");
> > I'd suggest we also check that the timer didn't fire, e.g.
> >
> > report(tdt_count == 0, "tsc deadline timer didn't fire");

Agreed.

> >
> > as a bonus, we'd get another reason to use braces for both branches of
> > the 'if' (which is a good thing regardless).
> >
>
> Agreed, and KVM also needs to return 0 if the APIC is hardware-disabled
> I think?

Just sent out a patch to do it.

    Wanpeng
