Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA98E21A832
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 21:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgGITxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 15:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGITuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 15:50:55 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11126C08C5CE
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 12:50:55 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c139so3010917qkg.12
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 12:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jBhiNdJcKWpDIzUtXlvuF+3cyZgX7DpFBBALLEpqqcI=;
        b=fXZg2ZbhLJFFCCYqF4ZSseLLp6ZerePMTDWKvhEaTTUG5r+0DGuVQTFoOP8tb0qHb4
         dqKXWN4HmZbbeLhJ333fFkXQ61wZ0cjFfPaOaYXOH4f2GhjGxoYunvWeRvEalalfEx8x
         5UDB7arIjU/KeYFGsYUxBltjP2CDzR3plB8pM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jBhiNdJcKWpDIzUtXlvuF+3cyZgX7DpFBBALLEpqqcI=;
        b=HE+oPR0PCvmPsQBMKRIDw25jWwiGJl8XvhSuS0XlFg2CfCko2orH5jwI9un6hEY+TE
         2RrlCxI6DBc5QwfR6oohBlE2+i2W3UAvPlvs9T1mjSZAXOXRyc2kw9LWAf0/7vAXTlex
         N+jnNGbNgSqapw/VDxV0CvW1abF5gaesB7G2sQZeqnOLS1VQnf4Ojjdr0FaCFX55d2NS
         RUgKjGo0xZZAqOTamBtwx7HNmXZt8dhgj/mjoEL0/n7nOTkzxmgpfborJNppowOxVkBL
         V7B41LIWpPwIbAsHch+fooIjYPH1lWm6Gzk8eixUcSMz4JwoAKsSLMaiCYqBLJ3H0SZe
         X1+A==
X-Gm-Message-State: AOAM531ym4N/CtKNsStCLTJZOfMd3d3hLOe8NegmUroZUPFzRAeRAhJu
        7AfCqQV4h1gigRsly8HmTXTceAA9d1k=
X-Google-Smtp-Source: ABdhPJwrke0N2QY+w4nIJcT1j/Gx/yrmrZ4QBQsjW60FdT9Byg1dFCg9XXJU00AsgKYYQFQ4GW7RGA==
X-Received: by 2002:a05:620a:571:: with SMTP id p17mr50684735qkp.482.1594324253938;
        Thu, 09 Jul 2020 12:50:53 -0700 (PDT)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com. [209.85.219.42])
        by smtp.gmail.com with ESMTPSA id i57sm5233993qte.75.2020.07.09.12.50.53
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 12:50:53 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id h18so1529398qvl.3
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 12:50:53 -0700 (PDT)
X-Received: by 2002:a67:ec0f:: with SMTP id d15mr38876582vso.121.1594323788853;
 Thu, 09 Jul 2020 12:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200708194715.4073300-1-abhishekbh@google.com> <87y2ntotah.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87y2ntotah.fsf@nanos.tec.linutronix.de>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 9 Jul 2020 12:42:57 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
Message-ID: <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
Subject: Re: [PATCH v5] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Jul 9, 2020 at 3:51 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Abhishek Bhardwaj <abhishekbh@google.com> writes:
> > This change adds a new kernel configuration that sets the l1d cache
> > flush setting at compile time rather than at run time.
> >
> > The reasons for this change are as follows -
> >
> >  - Kernel command line arguments are getting unwieldy. These parameters
> >  are not a scalable way to set the kernel config. They're intended as a
> >  super limited way for the bootloader to pass info to the kernel and
> >  also as a way for end users who are not compiling the kernel themselves
> >  to tweak the kernel behavior.
> >
> >  - Also, if a user wants this setting from the start. It's a definite
> >  smell that it deserves to be a compile time thing rather than adding
> >  extra code plus whatever miniscule time at runtime to pass an
> >  extra argument.
> >
> >  - Finally, it doesn't preclude the runtime / kernel command line way.
> >  Users are free to use those as well.
>
> TBH, I don't see why this is a good idea.
>
>  1) I'm not following your argumentation that the command line option is
>     a poor Kconfig replacement. The L1TF mode is a boot time (module
>     load time) decision and the command line parameter is there to
>     override the carefully chosen and sensible default behaviour.

When you say that the default behavior is carefully chosen and
sensible, are you saying that (in your opinion) there would never be a
good reason for someone distributing a kernel to others to change the
default?  Certainly I agree that having the kernel command line
parameter is nice to allow someone to override whatever the person
building the kernel chose, but IMO it's not a good way to change the
default built-in to the kernel.

The current plan (as I understand it) is that we'd like to ship
Chromebook kernels with this option changed from the default that's
there now.  In your opinion, is that a sane thing to do?


>  2) You can add the desired mode to the compiled in (partial) kernel
>     command line today.

This might be easier on x86 than it is on ARM.  ARM (and ARM64)
kernels only have two modes: kernel provides cmdline and bootloader
provides cmdline.  There are out-of-mainline ANDROID patches to
address this but nothing in mainline.

The patch we're discussing now is x86-only so it's not such a huge
deal, but the fact that combining the kernel and bootloader
commandline never landed in mainline for arm/arm64 means that this
isn't a super common/expected thing to do.


>  3) Boot loaders are well capable of handling large kernel command lines
>     and the extra time spend for reading the parameter does not matter
>     at all.

Long command lines can still be a bit of a chore for humans to deal
with.  Many times I've needed to look at "/proc/cmdline" and make
sense of it.  The longer the command line is and the more cruft
stuffed into it the more of a chore it is.  Yes, this is just one
thing to put in the command line, but if 10 different drivers all have
their "one thing" to put there it gets really long.  If 100 different
drivers all want their one config option there it gets really really
long.  IMO the command line should be a last resort place to put
things and should just contain:

1. Legacy things that _have_ to be in the command line because they've
always been there.

2. Things that the bootloader/BIOS needs to communicate to the kernel
and has no better way to communicate.

3. Cases where the person running the kernel needs to override a
default set by the person compiling the kernel.


>  4) It's just a tiny part of the whole speculation maze. If we go there
>     for L1TF then we open the flood gates for a gazillion other config
>     options.

It seems like the only options that we'd need CONFIG option for would
be the ones where it would be sane to change the default compiled into
the kernel.  Hopefully that's not too many things?


>  5) It's completely useless for distro kernels.
>
>  6) The implementation is horrible. We have proper choice selectors
>     which allow to add parseable information instead of random numbers
>     and a help text.

If my other arguments make sense and Abhishek could just fix #6, would
that work?


Obviously, like many design choices, the above is all subjective.
It's really your call and if these arguments don't convince you it
sounds like the way forward is just to use "CONFIG_CMDLINE" and take
advantage of the fact that on x86 this will get merged with the
bootloader's command line.


-Doug
