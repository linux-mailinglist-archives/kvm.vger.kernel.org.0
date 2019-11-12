Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAFF994F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 20:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKLTEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 14:04:33 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:32812 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKLTEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 14:04:33 -0500
Received: by mail-vk1-f193.google.com with SMTP id p68so4729470vkd.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 11:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+7zIg5cEThmDcaujogc6+rrD0RbqAivM/uWdl2rcHs=;
        b=wMwB9APPgUrmaxieaZ1t/1Z2QkjcMaJHNxaifaV7/lh/ArbM3KpHBEJbAEyxUA1C2+
         kXAV4qj8sMrdaZyTR5cQQ1rsaFkCo8qE0gFIG4QjtZ7PhpJP6NX+HElJ3lXFynthRJKf
         hz2tUS+At15uQJR3eL5D48+/8kcijo/f1cFjbDMSP56GfYfUrCU0ye82sBaYJvTO/weO
         xDKNDxGKNPZhpyjvfC15rVRQBghdRTz//hEU3ij30B8+hj6Ns4az9Drw40viPYCWmlcT
         Nq6IiQW2GPNrxIjY+kdUz0uhL3yPmmD2dsLuRiAIDffH2fwhfRacRh2lfyABbl0rVJVC
         xzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+7zIg5cEThmDcaujogc6+rrD0RbqAivM/uWdl2rcHs=;
        b=Ysxw1+pwV00IUOGlXhdgRa1AxfWHpRzJsCa78swzj5lHz7a12y5kaAVTFdkL8mdrkE
         99EkSpw444J8qTWjKJhqv4BCLL0vA2W/lixAy+BRvXhwttEHrXfj2DKDkhQPgQq5BFtL
         Y8sOQTX3CpalXeR+TwB7MHep9EsMeaeqRlevEhX8N7mxggXwNKilfSlswmFUxZ9W8IfL
         8JUS4XjCjlZH3ew6XE9lz2pGXyEUxzA0jW/XPi1phNExxn2hf2NMoe7CQzdCRzUwnDMe
         tLey7eplX2hP3veJ3s8+Xay47gt2/FTzi8bVzpGUi7+wkBFNvH6Cbx1QO8jvY/4pswVz
         hHPw==
X-Gm-Message-State: APjAAAWnr+n+ltNAC2DyCYFH5NFT7shdbJHaaPmbAMRYRW1GyES1GDZ0
        oA0pGJfQeq58etRZ7Buj4PvjU1Xx13S7eKG5YT4E
X-Google-Smtp-Source: APXvYqzyi9uzQ+//HV3vM6s8tFeiT35ZC6IRIHcfcyyLqAyl1vGq5hgvvIYRtPP/Li1yFH3ZsNEPTinzQa2cMxk4aZg=
X-Received: by 2002:a1f:24c6:: with SMTP id k189mr22406643vkk.32.1573585471733;
 Tue, 12 Nov 2019 11:04:31 -0800 (PST)
MIME-Version: 1.0
References: <20191107010844.101059-1-morbo@google.com> <20191107010844.101059-3-morbo@google.com>
 <18785109-ffd0-b536-bb63-e1a2b6cf5c97@redhat.com>
In-Reply-To: <18785109-ffd0-b536-bb63-e1a2b6cf5c97@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 12 Nov 2019 11:04:20 -0800
Message-ID: <CAGG=3QVsWrDNb6nkLAzP4yANS5WFd6WeqmctoSqKHrX1h6Cn2g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Makefile: add "cxx-option" for C++ builds
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 9:52 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 07/11/2019 02.08, Bill Wendling wrote:
> > The C++ compiler may not support all of the same flags as the C
> > compiler. Add a separate test for these flags.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  Makefile | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 4c716da..9cb47e6 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
> >
> >  cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> > +cxx-option = $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev/null \
> > +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >
> >  COMMON_CFLAGS += -g $(autodepend-flags)
> >  COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> > @@ -62,8 +64,6 @@ fno_pic := $(call cc-option, -fno-pic, "")
> >  no_pie := $(call cc-option, -no-pie, "")
> >  wclobbered := $(call cc-option, -Wclobbered, "")
> >  wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
> > -wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
> > -wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
> >
> >  COMMON_CFLAGS += $(fomit_frame_pointer)
> >  COMMON_CFLAGS += $(fno_stack_protector)
> > @@ -75,11 +75,19 @@ COMMON_CFLAGS += $(wclobbered)
> >  COMMON_CFLAGS += $(wunused_but_set_parameter)
> >
> >  CFLAGS += $(COMMON_CFLAGS)
> > +CXXFLAGS += $(COMMON_CFLAGS)
> > +
> > +wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
> > +wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
> >  CFLAGS += $(wmissing_parameter_type)
> >  CFLAGS += $(wold_style_declaration)
> >  CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> >
> > -CXXFLAGS += $(COMMON_CFLAGS)
> > +# Clang's C++ compiler doesn't support some of the flags its C compiler does.
> > +wmissing_parameter_type := $(call cxx-option, -Wmissing-parameter-type, "")
> > +wold_style_declaration := $(call cxx-option, -Wold-style-declaration, "")
> > +CXXFLAGS += $(wmissing_parameter_type)
> > +CXXFLAGS += $(wold_style_declaration)
>
> As mentioned in my mail to the previous version of this patch: I think
> both options are not valid with g++ as well, so I think this patch
> should simply be dropped.
>
I agree. Thank you for the review!

-bw
