Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C5D1CE1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 01:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbfJIXfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 19:35:34 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34594 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732349AbfJIXfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 19:35:34 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so9524495ion.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 16:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xvw6T4GWf9flylZopqibZ1nNzqfMaesuET6Mrfrjnb0=;
        b=asstcLADF1q4tNBnTuDXH+HkRrmMHSX/waaOBEkzwXvh3RscWNGF917N+Xg3AuHdfE
         V7bTH7V5ORnnchA5uH6PoONCI7QWl+27TmL2AA2ZNpWPTPTjNoY09+4vEKORFXejSnCv
         xXubem8WJmI3PLHOlGMI/ktVfPFDZY2iIuTAhWeItUy+E/hLqQft/u9L3Zf9GqgsrcaD
         4QFJ+WN5NuWw+qqdM0AFuRTuOmYCFXLiaWyCqWcSZUstpNPw9YgtmrrYGe3NrDNa1Qmk
         AyTR/+flGnIu6QCKVvJYtqHZw0CzDy/Q6imy1ybk9wr/K8N5N1REfD6a4tCxZ3+7TJvp
         UAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xvw6T4GWf9flylZopqibZ1nNzqfMaesuET6Mrfrjnb0=;
        b=n4fMLoD8q0iqKIuhV1Z51T1U+CNChtKrqx/hT/FCtQCBy4ETl6d7j8ift47B0Uq/oY
         P4xLB3PMfeq1x2b2u2/RO9vpT9/MgeI8vNn8mD4325GBb0zRcmNarn/quPPogrOznqvG
         OTkhaudLHZO0WfdXjkiBbTMijOffOh5UPb9wcPRduSQQ+clQS73YMlKjI4tL4IlenXrh
         mv4D7PbDhIIMXWa46VbcGMHwO1UK3chx84AcQArU43J1h6F/d5WKQP1+1r5yx7lNgN++
         nTzcH2d0Pcw4AFUKvg0geI6zGIcHNN2UHO+o46v6nUrTaP60EXytwfJuTR6dG3yNmQF4
         URtA==
X-Gm-Message-State: APjAAAXzTeGh2mVtYlzqqOfvLWcVEJ5zmWiODXeWHuGOvuCp3ofo9wQd
        7gi5FZU5fAdUQb0Py/70vRHGbFvHqBt1lo3IhXwINA==
X-Google-Smtp-Source: APXvYqwC69wpUrunmg6uOkSX6vcABe8IPTh5VcdvlbdYu50TS71ghL7J0TkFiCTADOY5lpfHVR6tMgUZB33WHCMngUs=
X-Received: by 2002:a6b:d210:: with SMTP id q16mr7054219iob.108.1570664132671;
 Wed, 09 Oct 2019 16:35:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-4-aaronlewis@google.com> <20191009014226.GA27134@local-michael-cet-test>
 <0f94a5e3-49bc-be1a-8994-46124c02109e@redhat.com>
In-Reply-To: <0f94a5e3-49bc-be1a-8994-46124c02109e@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Oct 2019 16:35:21 -0700
Message-ID: <CALMp9eQJZJBXPEWun+AAXkK=4vLaRiFqhgFNdEVU+24-VF7A=Q@mail.gmail.com>
Subject: Re: [Patch 4/6] kvm: svm: Enumerate XSAVES in guest CPUID when it is
 available to the guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 8, 2019 at 11:32 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/10/19 03:42, Yang Weijiang wrote:
> > +     if (guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> > +         boot_cpu_has(X86_FEATURE_XSAVES))
> > +             guest_cpuid_set(vcpu, X86_FEATURE_XSAVES);
> > +
>
> This is incorrect, as it would cause a change in the guest ABI when
> migrating from an XSAVES-enabled processor to one that doesn't have it.
>
> As long as IA32_XSS is 0, XSAVES is indistinguishable from XSAVEC, so
> it's okay if the guest "tries" to run it despite the bit being clear in
> CPUID.

My bad. When Aaron and I were discussing this, I expressed concern
about guest behavior on a future day when (a) AMD supports a non-zero
IA32_XSS, and (b) Linux supports an intercepting non-zero IA32_XSS.
One could argue that if XSAVES isn't enumerated, the guest gets what
it deserves for trying it anyway. Or, one could argue that the
decision to swap guest/host IA32_XSS values on VM-entry/VM-exit
shouldn't be predicated on whether or not the guest CPUID enumerates
XSAVES. I'm going to suggest the latter. How would you feel about
having {vmx,svm}_cpuid_update set a boolean in kvm_vcpu_arch that
indicates whether or not the guest can execute XSAVES, regardless of
what is enumerated in the guest CPUID? The wrmsr(IA32_XSS) in the
VM-entry/VM-exit path would then query that boolean rather than
guest_cpuid_has(XSAVES).
