Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585474935C5
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352167AbiASHrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352161AbiASHra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:47:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BF1C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 23:47:30 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r5so1816505pfl.2
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 23:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbiJb2UVtirrAHsd/tlBtET4SjB9SQTlHXui+2izr3s=;
        b=bP8mpKrUKYYcA4KRpX/Iab6PVeCaEBou0Rle0wK4u0oCxHKHJNxK3XOy8B6lcxgvXY
         FOco+CP1Zd+i3br6c9kACIwlpelrznWTBYQUgGtAv7CIL5/Vnzro9VaR+3UOWqaq8BVB
         xO6cf+i5UOhU4GoneriU5p5ARzP2ioFnBe4GfgF/C+JvyNABeyjbtY0rfzzo/ABYY++3
         iJR1Xxp98BG1ihJUwNmD+zPbT8XFXRlCn6TXC5AqGaP9hKk35oUB0BaIZ9HYjhj8NlBp
         FAWsGfVPMfQ2g6v6WkTOQ8wNCoRN/d9yFYycIOipiN0vhIS7vAg3sF7aPCVLXrVqbIL7
         RxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbiJb2UVtirrAHsd/tlBtET4SjB9SQTlHXui+2izr3s=;
        b=8GYaqTS+l+GMlHkz5KDgC61qQReqU8xqNYdqX4SFwczLga44EZhkmuzXc10f6gxROT
         zS1uBKbv8/yxnf6zUfuXFmkTrHzivPyw7AsKY3mgb9etXXXnTP+Kpn1h+JEfmM1BYImx
         epfj6g2BcRgHE4nxGZ1wLbWz7yfIK2NC1lkwCEXz+SsjdvEblQkclV76Y58MVkGeVLwl
         i6NPg3G+E3xQiY5D3Ao3b5a28JaD+J9ntiGVxfeGEkn9nwlyHp9ZH1kUhva9dW/DeGVe
         iSdFscMY+lXBincl9QE/w3BMUJ1qUjspYZjrBuykjIlvzxU4Qs4ikS3DVGY7BOATFUaJ
         rH1A==
X-Gm-Message-State: AOAM53171TOnmt7aKmBylH3R7sDOvcPy246u9yEcK/Jb0bk9Umu8bQLJ
        7LTYgobO3DEDLCQbndwe0hmPm3kYjYsbCmfsRi0Y4w==
X-Google-Smtp-Source: ABdhPJynjuL5EJyIFAzAyBjd8DX1zCihK90pwXV5JoP1UY92TV4OnkyTmudcqtrcfRqYDdlvxWABUiftzGEKe/ZrgUE=
X-Received: by 2002:a63:7d42:: with SMTP id m2mr26257918pgn.491.1642578450084;
 Tue, 18 Jan 2022 23:47:30 -0800 (PST)
MIME-Version: 1.0
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com> <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
 <YedWUJNnQK3HFrWC@google.com>
In-Reply-To: <YedWUJNnQK3HFrWC@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 Jan 2022 23:47:13 -0800
Message-ID: <CAAeT=FyJAG1dEFLvrQ4UXrwUqBUhY0AKkjzFpyi74zCJZUEYVg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Sean Christopherson <seanjc@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 4:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> > The restriction, with which KVM doesn't need to worry about the changes
> > in the registers after KVM_RUN, could potentially protect or be useful
> > to protect KVM and simplify future changes/maintenance of the KVM codes
> > that consumes the values.
>
> That sort of protection is definitely welcome, the previously mentioned CPUID mess
> on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
> hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
> Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
> all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
> e.g. if there are side effects that are visible in other registers, than an update
> can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
> modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
> inconsitent.

Thank you for your comments !
I think I understand your concern, and that's a great point.
That's not the case for those pseudo registers though at least for now :)
BTW, is this concern specific to hooking KVM_RUN ? (Wouldn't it be the
same for the option with "if kvm->created_vcpus > 0" ?)


> If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
> a relatively common pattern in KVM, and provides a clear boundary to userpace
> regarding what is/isn't allowed.

Yes, I agree that would be better in general.  For (pseudo) registers,
I would think preventing modification if kvm->created_vcpus > 0 might
not be a very good option for KVM/ARM though considering usage of
KVM_GET_REG_LIST and KVM_{G,S}ET_ONE_REG.

Thanks,
Reiji
