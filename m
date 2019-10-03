Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D5ACAA9C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392337AbfJCRJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 13:09:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36947 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392070AbfJCQd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:57 -0400
Received: by mail-io1-f66.google.com with SMTP id b19so7055073iob.4
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSzWQER5y5opa0aJ4MNu5LXS/KkmMha6dUD+zB4fTwE=;
        b=emQhVB24XLr5BXEivKVZdF/OYgPI4jLyARvsgHmtsfPryC7NNw4xZ7y8+Ly+f+pcqp
         nFm+YJcR9yTQWQAcBQKhMgIm/q9ulHGq1ipujQ4uLrXK7vxiuvcW2LAMpkw273JxLa8Y
         +oLVYO8cHiINBKSMLjUgWBzGqDjJlMKZ5SeylzlD6PlMVAUlgrzWPvvCbe5UFGP/zJWS
         sQKOil7+nwQzPU1iSzRuJq+VXCxZFOH1Y2IwLmpZLpPanu7llPrzsUjnWE70/xCbknHk
         lwDtpoFdsZd3f4abReMXj+VTU7/vIr8dURHwE1kUw2X5aCPFPgVNR87PcNY48iMO6mV+
         yq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSzWQER5y5opa0aJ4MNu5LXS/KkmMha6dUD+zB4fTwE=;
        b=O1d30Idxm3Q0ysh7HZDVp5l7vg6X8mFP5qHfNZT79tuQBrQk0qWuqR2PFVy8FyuQhx
         hxYxpwhftU+62JA6xrLwkkafMVljYDh9K1nk6QcVBR4s907IgZUNpWn7Z3BqU9qgNw8T
         xEf0frauDmTBhRtEFFx/uitw466XoJf5NupFZicVIiBC7NVI6vyZpDMD7yh3oxKBSC1d
         1ciViOt2BXuCxD2tOkqoX9l1I1oZh7lY6p7sAQ1Ez3z/++0mZ+k4hn7ulpSZPSOzVtZ9
         6DQsnnid0H6L2NdNb00+N9Ol+qXUi/7lkEQyQAK95Ljum996j73NQpwo/dtgJyCjXeMo
         /M7A==
X-Gm-Message-State: APjAAAVbjVyWoFFJvh0hzr6Kam8Sy0Y/kVsgezm35qA/GI1MkXDsnbMm
        7LpG2mTk/xT6jETee3yhEea7nGf+QKin+C6rcHzszw==
X-Google-Smtp-Source: APXvYqzo9w6kW4utleP6LQr3HRFZ0WTj8yeWIQzu8zffqECqrqFCwDTHG6oQSKqheElwImm16Xoi+ydgolWeI9o1siE=
X-Received: by 2002:a92:b09:: with SMTP id b9mr7458488ilf.26.1570120436364;
 Thu, 03 Oct 2019 09:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <CALMp9eQ13Lve+9+61qCF1-7mQkeLLnhDufd-geKtz=34+YJdEg@mail.gmail.com> <20191003130145.GA25798@local-michael-cet-test.sh.intel.com>
In-Reply-To: <20191003130145.GA25798@local-michael-cet-test.sh.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Oct 2019 09:33:45 -0700
Message-ID: <CALMp9eQUiLNmF6oF5uEuT-VhRnzp3S9rsnAE0jpK+=38LQBHQA@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] Introduce support for Guest CET feature
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 5:59 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Wed, Oct 02, 2019 at 03:40:20PM -0700, Jim Mattson wrote:
> > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > Control-flow Enforcement Technology (CET) provides protection against
> > > Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> > > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > >
> > > KVM modification is required to support Guest CET feature.
> > > This patch serial implemented CET related CPUID/XSAVES enumeration, MSRs
> > > and VMEntry configuration etc.so that Guest kernel can setup CET
> > > runtime infrastructure based on them. Some MSRs and related feature
> > > flags used in the patches reference the definitions in kernel patch.
> >
> > I am still trying to make my way through the 358 page (!) spec for
> > this feature, but I already have some questions/comments about this
> > series:
> >
> > 1. Does CET "just work" with shadow paging? Shadow paging knows
> > nothing about "shadow-stack pages," and it's not clear to me how
> > shadow-stack pages will interact with dirty tracking.
> > 2. I see non-trivial changes to task switch under CET. Does
> > emulator_do_task_switch need to be updated?
> > 3. What about all of the emulator routines that emulate control
> > transfers (e.g. em_jmp_{far,abs}, em_call_(near_abs,far},
> > em_ret_{far,far_imm,near_imm}, etc)? Don't these have to be modified
> > to work correctly when CR4.CET is set?
> > 4. You don't use the new "enable supervisor shadow stack control" bit
> > in the EPTP. I assume that this is entirely optional, right?
> > 5. I think the easiest way to handle the nested issue (rather than
> > your explicit check for vmxon when setting CR4.CET when the vCPU is in
> > VMX operation) is just to leave CR4.CET out of IA32_VMX_CR4_FIXED1
> > (which is already the case).
> > 6. The function, exception_class(), in x86.c, should be updated to
> > categorize #CP as contributory.
> > 7. The function, x86_exception_has_error_code(), in x86.h, should be
> > updated to include #CP.
> > 8. There appear to be multiple changes to SMM that you haven't
> > implemented (e.g saving/restoring the SSP registers in/from SMRAM.
> >
> > CET is quite complex. Without any tests, I don't see how you can have
> > any confidence in the correctness of this patch series.
> Thanks Jim for the detailed comments.
>
> I missed adding test platform and
> result introduction in cover letter. This serial of patch has passed CET
> test in guest on Intel x86 emulator platform and develop machine.
> Some feature mentioned in the spec. has not been implemented yet. e.g.,
> "supervisor shadow stack control".

What I should have said is that I'd like to see kvm-unit-tests to
exercise the new functionality, even if no one outside Intel can run
them yet.

> CET feature itself is complex, most of the enabling work is
> inside kernel, the role of KVM is to expose CET related CPUID and MSRs
> etc. to guest, and make guest take over control of the MSRs directly so that
> CET can work efficiently for guest. There're QEMU patches for CET too.
>
> I'll review your comments carefully, thank you again!
