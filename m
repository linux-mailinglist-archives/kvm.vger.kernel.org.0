Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C5E31A654
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 21:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBLU5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 15:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhBLU5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 15:57:13 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEC6C061574
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 12:56:32 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id e4so462669ote.5
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 12:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0yF7LNMu/ANL+8GIP6hIh/1kIEX8WnMfa1JaTdNU7o=;
        b=QsZKKzoaHLGO9BY0axyjkyrS6yMskCvvpv9PM3TN+IT5akm5wd0Bq1n2aVEGEAv4Kh
         HRqOoko4B/QI3nP2jPZNDVWcBKZcapO0OleB1cLv5mpgALIxJ8JkZcezVs+V3UmAfc4Z
         Qshe0pl8Hb3BuOAScbxLBta8lELt5KdjB8BmX1jmF0NO6WhYZS5MOnJdBcz/pY5HVP8A
         SboKS8ZQcvu9o6r/SfHXT94juDcn7Of3Fo2ZCUcNpzr5gPY7OiyD8Gsxo5OEdCVmr9I2
         LKGGEVUKBE9myZpx/qOXYDa8B0EmQZDPRIdlu/mP0yzOolIRkgx+tB/8HaU5j1lXRE+n
         Yz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0yF7LNMu/ANL+8GIP6hIh/1kIEX8WnMfa1JaTdNU7o=;
        b=rCX3caoj2z2i6ceg76FdcEYFH0Bu1+9H2agcvIfiqMhFtrAwmki8AqUeWft6/if94N
         1lUQw7K4vIJ6F7N++QQD+QVLNdD4F1vYv7+OkaVwIBVQShihuasId8x7eXCpDoBZfqvV
         M/OzPiZ+a7NX8Wnci16se+XZFO+lK8vsN8cWCIwkBoiBd6GYOfedp6B6deM4/3sF2GKJ
         xCObmMX1JfBC3U9LW9MoyMYHDJB9o+5Bgmz+v0OBOHfI2rCTuPgbbi+gFGrxm1qLIpYY
         pvGkX+n4i2r2s06Gall9pxjcwe2YOoE6EUkPwKHvy8gtlnsmeLAcPwRHmBRIRQr4N/yd
         iUnA==
X-Gm-Message-State: AOAM530sPaeoNfJFCbgrXa1QL4g6kHsYliFVi7r001lmqCIwdAoGgHx9
        WggiVYiNl9bizP0Kc2kyKmm/37FK1MzCcgOx6d+kQo7Swvg=
X-Google-Smtp-Source: ABdhPJxFbREQKFQyKHV6Hpw0xVkzla/yDyCu7tAjoc4/cMZkLVPp/l7GVqZmHurn5y8hRsxzAidAcBQ+G7Q/5ow/TGg=
X-Received: by 2002:a05:6830:543:: with SMTP id l3mr3479618otb.241.1613163392113;
 Fri, 12 Feb 2021 12:56:32 -0800 (PST)
MIME-Version: 1.0
References: <20210211212241.3958897-1-bsd@redhat.com> <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
 <jpgo8gpbath.fsf@linux.bootlegged.copy> <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
 <jpg35y1f9x8.fsf@linux.bootlegged.copy> <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
 <jpgy2ft6sn5.fsf@linux.bootlegged.copy> <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
 <jpglfbtyrn2.fsf@linux.bootlegged.copy>
In-Reply-To: <jpglfbtyrn2.fsf@linux.bootlegged.copy>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Feb 2021 12:56:21 -0800
Message-ID: <CALMp9eSQW9OuFGXwJYmtGH9Of8xEwHUx-e-OBcxSFVKTFNF1dw@mail.gmail.com>
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
To:     Bandan Das <bsd@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Huang2, Wei" <wei.huang2@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 12:10 PM Bandan Das <bsd@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
> ...
> > On>> >> > I know I was the one to complain about the #GP, but...
> >> >> >
> >> >> > As a general rule, kvm cannot always guarantee a #UD for an
> >> >> > instruction that is hidden from the guest. Consider, for example,
> >> >> > popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
> >> >> > I'm pretty sure that Paolo has brought this up in the past when I've
> >> >> > made similar complaints.
> >> >>
> >> >> Ofcourse, even for vm instructions failures, the fixup table always jumps
> >> >> to a ud2. I was just trying to address the concern because it is possible
> >> >> to inject the correct exception via decoding the instruction.
> >> >
> >> > But kvm doesn't intercept #GP, except when enable_vmware_backdoor is
> >> > set, does it? I don't think it's worth intercepting #GP just to get
> >> > this #UD right.
> >>
> >> I prefer following the spec wherever we can.
> >
> > One has to wonder why userspace is even trying to execute a privileged
> > instruction not enumerated by CPUID, unless it's just trying to expose
> > virtualization inconsistencies. Perhaps this could be controlled by a
> > new module parameter: "pedantic."
> >
> Yeah, fair point.
>
> >> Otoh, if kvm can't guarantee injecting the right exception,
> >> we should change kvm-unit-tests to just check for exceptions and not a specific
> >> exception that adheres to the spec. This one's fine though, as long as we don't add
> >> a CPL > 0 invpcid test, the other patch that was posted fixes it.
> >
> > KVM *can* guarantee the correct exception, but it requires
> > intercepting all #GPs. That's probably not a big deal, but it is a
> > non-zero cost. Is it the right tradeoff to make?
>
> Not all, we intercept GPs only under a specific condition - just as we
> do for vmware_backdoor and for the recent amd errata. IMO, I think it's the right
> tradeoff to make to get guest exceptions right.

It sounds like I need to get you in my corner to help put a stop to
all of the incorrect #UDs that kvm is going to be raising in lieu of
#PF when narrow physical address width emulation is enabled!
