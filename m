Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C88239A250
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFCNit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:38:49 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:41875 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhFCNis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 09:38:48 -0400
Received: by mail-ot1-f43.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so5732274oth.8
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SSOZn7NeOxtNAr4b0FWuz+EfX/KEGNf2pixj/JYi27A=;
        b=b2ZiPMTMK0z2jIOFY2UNLrgwmt+7m8+y8A0XTLvoF9Z8GLkdoO4vh+/OkwfbxSPOa9
         E+VjhvpG2v0CzpGPM+fdgsMfJOxK5Oiix3ApM55K0ZBCiD8LbTACd1XYnwgDVRhll0XT
         m0UNRuKzJrIHCM1kVtG3vd+9/LMRZJmMAPnyjX2s2+JRUQWawHqxIkTEWxZn8cBzlWKw
         dyYTaRwg6biI8J70RfcYIX0vqQ5VipfmLXwJ8ymiUxSM0bW6iE4lgfFaUmtd888BIc83
         1bvMyhJZXdTr3nnBko1jytmqVKuMNm5N3jiREZuptB+HJ9yM8jb9TWlfxl6hagWc6rGb
         rAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SSOZn7NeOxtNAr4b0FWuz+EfX/KEGNf2pixj/JYi27A=;
        b=KjkF/xc7917NGR5uGH7VaEK1vUjrp7G63WX4cLclUBIzU0jiAARR9K0G4ZKCE1CCgc
         MKidgNkApQOgHTB218j/CtpFQLusivQz9d1JGETW67PmEBd99HyehT79OKhUTrHPAJMK
         2f+TIr46HYlAX95yXXnzcFnsxM0+SsaH1Yp0KsSFzZ9RrIAD1dJDYrCDy1ue6UI9zUEj
         cdNBvaBYrpz0V52fiG3A8Aw8Oi7w/wdgD9DO4XpT7r9pHOY0py4DAskytD8C8RHPOWUa
         v04AMHOxf6fRdA5s+XkK1Xag1IwdcPCSgV7CDuAmVMt9KwWcy1xV5YlIB2ZumkHiOomW
         dolA==
X-Gm-Message-State: AOAM531Q1V0BWV1biyW9UGL7aTMbNXWbt1zUfbjy46TtASOVxvRSexU6
        PN/rJOjuuUcKOtXPVazCQX5y2io3+15JJtBDO1jL0g==
X-Google-Smtp-Source: ABdhPJyyRDeU6xsWT9ff4ufDNsEg24ZcRpZFsQAYVpwmpMHnLCT8tvYOzrcQqm8NpZv/XYnKbtEH+GzQCJG5rno+WkQ=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr30221203oth.56.1622727351073;
 Thu, 03 Jun 2021 06:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210525051204.1480610-1-tao3.xu@intel.com> <871r9k36ds.fsf@vitty.brq.redhat.com>
 <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
In-Reply-To: <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Jun 2021 06:35:40 -0700
Message-ID: <CALMp9eSVK_ZszVS83H6vPN1ZY3BqHwK0OKAn_Bj4mUBJBqO4Bw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, Tao Xu <tao3.xu@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 2, 2021 at 6:25 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 6/2/2021 6:31 PM, Vitaly Kuznetsov wrote:
> > Tao Xu <tao3.xu@intel.com> writes:
> >
> >> There are some cases that malicious virtual machines can cause CPU stuck
> >> (event windows don't open up), e.g., infinite loop in microcode when
> >> nested #AC (CVE-2015-5307). No event window obviously means no events,
> >> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
> >> hardware CPU can't be used by host or other VM.
> >>
> >> To resolve those cases, it can enable a notify VM exit if no event
> >> window occur in VMX non-root mode for a specified amount of time
> >> (notify window). Since CPU is first observed the risk of not causing
> >> forward progress, after notify window time in a units of crystal clock,
> >> Notify VM exit will happen. Notify VM exit can happen incident to delivery
> >> of a vectored event.
> >>
> >> Expose a module param for configuring notify window, which is in unit of
> >> crystal clock cycle.
> >> - A negative value (e.g. -1) is to disable this feature.
> >> - Make the default as 0. It is safe because an internal threshold is added
> >> to notify window to ensure all the normal instructions being coverd.
> >> - User can set it to a large value when they want to give more cycles to
> >> wait for some reasons, e.g., silicon wrongly kill some normal instruction
> >> due to internal threshold is too small.
> >>
> >> Notify VM exit is defined in latest Intel Architecture Instruction Set
> >> Extensions Programming Reference, chapter 9.2.
> >>
> >> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> >> ---
> >>
> >> Changelog:
> >> v2:
> >>       Default set notify window to 0, less than 0 to disable.
> >>       Add more description in commit message.
> >
> > Sorry if this was already discussed, but in case of nested
> > virtualization and when L1 also enables
> > SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
> > during L2 execution to L1 instead of crashing the whole L1?
> >
>
> yes. If we expose it to nested, it should reflect the Notify VM exit to
> L1 when L1 enables it.
>
> But regarding nested, there are more things need to be discussed. e.g.,
> 1) It has dependence between L0 and L1, for security consideration. When
> L0 enables it, it shouldn't be turned off during L2 VM is running.
>     a. Don't expose to L1 but enable for L1 when L2 VM is running.
>     b. expose it to L1 and force it enabled.
>
> 2) When expose it to L1, vmcs02.notify_window needs to be
> min(L0.notify_window, L1.nofity_window)

I don't think this can be a simple 'min', since L1's clock may run at
a different frequency from L0's clock.
