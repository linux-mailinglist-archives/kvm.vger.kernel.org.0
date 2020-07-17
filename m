Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417E92241BE
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgGQRZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 13:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQRZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 13:25:59 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA83C0619D2
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 10:25:59 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 95so7408358otw.10
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 10:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fA/qgfiMlIm6DaorpA1k/f2IvyM46KgPHDRmF2JATYU=;
        b=iuthQu6LH99OsV+mQbxcja9ScSRaZvsR5qiIt+DsYophAQaNm8NC6wlZi+yHb2iNJl
         eVtHP21CqgNla77GmrOUfa4p+gI83t5uNHjiPDa9WF1dk3ifmRaIsNHl+kWdnTYi0GfG
         cno/9YebyzAxYJhLZ8RuA6dKl2b2JUycwnks0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fA/qgfiMlIm6DaorpA1k/f2IvyM46KgPHDRmF2JATYU=;
        b=JEPLsaDtgTo2T4zLZkfMC0E+G6+hUTkElMk9AfvLvP/gotgNqVPT9yXhWF6YB+N0sG
         AU9DnZVACQWESEEBtYVtByzCHkvPiqyRXOONHoI8ZWDJdKg7ueRodAnjXbJsEjC9X3WY
         hOhITwzlofYK3l0KlEoLxVavwhmK9iLiEsIPn3ZGzicCypWWvDLAieAuVIFAVjSFEIsb
         a1PC7PplaKm0sL2zJCcerwvTkQlmOLj0HyHLWUmnVYBp+URKjJH03mZahmqn9xSBzzx1
         VndnknJMvDNcgmLw1aMLOOVA76cskIOtpv1CbBXSx5ub2M/jIY+IE9hIJldrL6JuM0s2
         A5AA==
X-Gm-Message-State: AOAM531uqMbq72DjqThR83pdvcaaDMxRW7GbuSZvRVqJv9/yedwl5ytC
        X6kvO6tplRodsHrv17+Y/ZP74eCbGiE=
X-Google-Smtp-Source: ABdhPJwZprVV6FIy3IxAm5r49yDXgVJCusZrsFQcoOwk498Cnc5O5W/4rwdBszJv1xD585R3ddtmFg==
X-Received: by 2002:a05:6830:1e55:: with SMTP id e21mr10234491otj.318.1595006758343;
        Fri, 17 Jul 2020 10:25:58 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id e193sm1953637oib.0.2020.07.17.10.25.58
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 10:25:58 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 5so7372123oty.11
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 10:25:58 -0700 (PDT)
X-Received: by 2002:ab0:150c:: with SMTP id o12mr8307356uae.90.1595006404233;
 Fri, 17 Jul 2020 10:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200708194715.4073300-1-abhishekbh@google.com>
 <87y2ntotah.fsf@nanos.tec.linutronix.de> <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
 <874kq6ru08.fsf@nanos.tec.linutronix.de>
In-Reply-To: <874kq6ru08.fsf@nanos.tec.linutronix.de>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 17 Jul 2020 10:19:52 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WPhaZC87Yb5LOYZ3s7_NWS2yhyaA6RXZQYojfAGvX84g@mail.gmail.com>
Message-ID: <CAD=FV=WPhaZC87Yb5LOYZ3s7_NWS2yhyaA6RXZQYojfAGvX84g@mail.gmail.com>
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

On Fri, Jul 17, 2020 at 9:22 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Doug,
>
> Doug Anderson <dianders@chromium.org> writes:
> > On Thu, Jul 9, 2020 at 3:51 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> TBH, I don't see why this is a good idea.
> >>
> >>  1) I'm not following your argumentation that the command line option is
> >>     a poor Kconfig replacement. The L1TF mode is a boot time (module
> >>     load time) decision and the command line parameter is there to
> >>     override the carefully chosen and sensible default behaviour.
> >
> > When you say that the default behavior is carefully chosen and
> > sensible, are you saying that (in your opinion) there would never be a
> > good reason for someone distributing a kernel to others to change the
> > default?  Certainly I agree that having the kernel command line
> > parameter is nice to allow someone to override whatever the person
> > building the kernel chose, but IMO it's not a good way to change the
> > default built-in to the kernel.
>
> The problem is that you have to be careful about what you stick into
> Kconfig. It's L1TF on x86 today and tomorrow it's MDS and whatever and
> then you do the same thing on the other architectures as well. And we
> still need the command line options so that generic builds can be
> customized at boot time.
>
> > The current plan (as I understand it) is that we'd like to ship
> > Chromebook kernels with this option changed from the default that's
> > there now.  In your opinion, is that a sane thing to do?
>
> If it's sane for you folks, then feel free to do so. Distros & al patch
> the kernel do death anyway, but that does not mean that mainline has to
> have everything these people chose to do.

Sure, we could carry a local patch.  ...but Chrome OS tries not to be
like all other distros.  We try very hard (and keep trying harder each
year) to _not_ carry local patches.  Sure, we fail sometimes, but we
will still try.  In general it seems like the upstream Linux community
pushes distros and other Linux users to be upstream first so it's a
little discouraging to hear the advice of "just carry a local patch".

In this case, though, I should close the loop.  Abhishek can correct
me if I'm wrong, but I think the answer here was that it _wasn't_ sane
for us to change this option via KConfig or even via kernel command
line.  I believe that Abhishek found that it was better to (in
userspace) look at the sysfs nodes and configure things how he wanted
it at runtime.


> >>  2) You can add the desired mode to the compiled in (partial) kernel
> >>     command line today.
> >
> > This might be easier on x86 than it is on ARM.  ARM (and ARM64)
> > kernels only have two modes: kernel provides cmdline and bootloader
> > provides cmdline.  There are out-of-mainline ANDROID patches to
> > address this but nothing in mainline.
> >
> > The patch we're discussing now is x86-only so it's not such a huge
> > deal, but the fact that combining the kernel and bootloader
> > commandline never landed in mainline for arm/arm64 means that this
> > isn't a super common/expected thing to do.
>
> Did you try to get that merged for arm/arm64?

Yes, years ago.  References:

https://lore.kernel.org/r/1326492948-26160-1-git-send-email-dianders@chromium.org
https://lore.kernel.org/r/1328223508-1228-1-git-send-email-dianders@chromium.org

I didn't keep poking it because I got advice (not on the mailing list)
that it was better to add a KConfig option rather than extending the
command line.  ;-)  At the time it seemed a reasonable argument to me
so I didn't keep pushing that patch.


> >>  3) Boot loaders are well capable of handling large kernel command lines
> >>     and the extra time spend for reading the parameter does not matter
> >>     at all.
> >
> > Long command lines can still be a bit of a chore for humans to deal
> > with.  Many times I've needed to look at "/proc/cmdline" and make
> > sense of it.  The longer the command line is and the more cruft
> > stuffed into it the more of a chore it is.  Yes, this is just one
> > thing to put in the command line, but if 10 different drivers all have
> > their "one thing" to put there it gets really long.  If 100 different
> > drivers all want their one config option there it gets really really
> > long.
>
> This will not go away when you want to support a gazillion of systems
> which need tweaks left and right due to creative hardware/BIOS with a
> generic kernel. And come on, parsing a long command line is not rocket
> science and it's not something you do every two minutes.

It's funny.  Your argument is the same as mine but the opposite.  I
say: "but so much crap will be in the command line and it will be
crazy" and you say "but so much crap will be in the KConfig and it
will be crazy".  ;-)  I guess it depends on where you want to dump
your trash.


> > IMO the command line should be a last resort place to put
> > things and should just contain:
> >
> > 1. Legacy things that _have_ to be in the command line because they've
> > always been there.
> >
> > 2. Things that the bootloader/BIOS needs to communicate to the kernel
> > and has no better way to communicate.
> >
> > 3. Cases where the person running the kernel needs to override a
> > default set by the person compiling the kernel.
>
> Which is the case for a lot of things and it's widely used exactly for
> that reason.

Right.  To be clear, I definitely wasn't suggesting the option be
_removed_ from the command line.


> >>  4) It's just a tiny part of the whole speculation maze. If we go there
> >>     for L1TF then we open the flood gates for a gazillion other config
> >>     options.
> >
> > It seems like the only options that we'd need CONFIG option for would
> > be the ones where it would be sane to change the default compiled into
> > the kernel.  Hopefully that's not too many things?
>
> That's what _you_ need. But accepting this we set a precedence and how
> do I argue that L1TF makes sense, but other things not? This stuff is
> horrible enough already, no need to add more ifdefs and options and
> whatever to it.

Again, I think it gets into a matter of opinion.  I'm also objecting
to setting a precedence, but in the opposite direction.  Today in
Chrome OS we don't need to use the command line extending for this
type of thing at all and (IMO) it's really nice.  Your config options
are in one place, not mixed halfway between the command line and the
KConfig.  Allowing this one config option to be configured in the
command line opens the flood gates for having two places to look for
the base config.  ;-)

In any case, it doesn't sound like I'm going to convince you.  Also,
since Abhishek has found another way to move forward it sounds like
the right thing is to consider his patch abandoned anyway.


> > Obviously, like many design choices, the above is all subjective.
> > It's really your call and if these arguments don't convince you it
> > sounds like the way forward is just to use "CONFIG_CMDLINE" and take
> > advantage of the fact that on x86 this will get merged with the
> > bootloader's command line.
>
> I rather see the support for command line merging extended to arm/arm64
> because that's of general usefulness beyond the problem at hand.

I have no objections to someone upstreaming those patches, for sure.
Maybe one day the Android team will do it since they seem to have been
carrying it as a local patch forever.  If nothing else, it gives us
more flexibility.


-Doug
