Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08BDF589E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbfKHUg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 15:36:26 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:41217 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732137AbfKHUg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 15:36:26 -0500
Received: by mail-vk1-f196.google.com with SMTP id 70so1807736vkz.8
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 12:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4Nu560WS+1GAW6kjcbw6ZBwBu1lQ+a0G5yup76lzYQ=;
        b=fCxp3ZP03clcSXfNTJVDIpJ7qvIJQPtUiHqgpsvKOF1tybqUHku+f56se/bnm2FZj8
         hZVIUc17nVnKTqpSLbYdSjIKOVhH3WpTHm7um+PdwLZOFiB+OlQ8WG9SvXCQ445FHMlN
         Xb3AZ0nsxsS4xb29PaYb0ZID1+d31MjdqW9EfGHcY2OWi0hW6uad2Qr1MYdKIyh/QvUW
         fjrmvdA2jkfLliJBlBkdMkRL/brDOdsCG0j8bTY/xEkWzPgTaNLq7GderuROzgfnA68V
         z9q8amhrz8FAw8NpcifDFTrMDafM/OO61KeqowOQ9c2IBonDF0+HnATMTlKRvvSh1KYP
         vh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4Nu560WS+1GAW6kjcbw6ZBwBu1lQ+a0G5yup76lzYQ=;
        b=I5vfZd+QjNULG6M31BeLPkPIkqy9jVy52pxPi9TNN7BdlmkHBlU3SbGOZdgM8mnNzE
         LUUHZ7bT0pQ0R2Sha3ttcwi7g5VaBgIyZGoQ6EC1BSfnRJX5KuZDx6Wl9qaIskZENnwQ
         s9/OD8tgO9nEAQ2F/UKknHnABpk0MbAAAH+53EH5C5STabpUUa9qVhevw94SG+FbVX+0
         CKiAHY8IHMtVoYwRX0tNLm3V83lcCrJ8e/XMLn7DkPq+XcN5rkRuSr3lt9UQmwyBEaNa
         m2t8ZUNue8x7W0a8tW82r7Ik4CrOtWd8Vm5eYVaw4Bc/wOnRcGrLG5YQvyto4U/RUphr
         gcUw==
X-Gm-Message-State: APjAAAWwte3VEMUkm6wf9iFwqdNmJvsZEpfo5NGsaWXdFXQJ77mzYOqL
        OJyVxaGkP8A66sNE7hVSaNVOnaTUc6S1h+fn6GSp
X-Google-Smtp-Source: APXvYqx8U1zj0r2YkU8vnzpztHnzEgrIOYlMgpwUjI3bn0aDnBI71lbh2dO0oR0m3XHcdKJJX6PtFfBFQEnQCmHqVTI=
X-Received: by 2002:a1f:24c6:: with SMTP id k189mr8903038vkk.32.1573245385085;
 Fri, 08 Nov 2019 12:36:25 -0800 (PST)
MIME-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-4-morbo@google.com> <e4c7494f-1ca5-fe6e-7238-08307fa3bccb@redhat.com>
In-Reply-To: <e4c7494f-1ca5-fe6e-7238-08307fa3bccb@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Fri, 8 Nov 2019 12:36:13 -0800
Message-ID: <CAGG=3QXgCseTiZ-5qeUqwE6L4E8DxNr8nbthacgH-BAQCn6e3g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/6] Makefile: use "-Werror" in cc-option
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I sent out another set of patches for the -Werror, because I didn't
see the ones I posted on the list and thought they got lost.


On Fri, Nov 8, 2019 at 12:43 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 30/10/2019 22.04, Bill Wendling wrote:
> > The "cc-option" macro should use "-Werror" to determine if a flag is
> > supported. Otherwise the test may not return a nonzero result. Also
> > conditionalize some of the warning flags which aren't supported by
> > clang.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >   Makefile | 16 ++++++++++------
> >   1 file changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 32414dc..6201c45 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -46,13 +46,13 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
> >   # cc-option
> >   # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> >
> > -cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
> > +cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >
> >   COMMON_CFLAGS += -g $(autodepend-flags)
> > -COMMON_CFLAGS += -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wuninitialized
> > -COMMON_CFLAGS += -Wignored-qualifiers -Wunused-but-set-parameter
> > -COMMON_CFLAGS += -Werror
> > +COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> > +COMMON_CFLAGS += -Wignored-qualifiers -Werror
> > +
> >   frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
> >   fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> >   fnostack_protector := $(call cc-option, -fno-stack-protector, "")
> > @@ -60,16 +60,20 @@ fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
> >   wno_frame_address := $(call cc-option, -Wno-frame-address, "")
> >   fno_pic := $(call cc-option, -fno-pic, "")
> >   no_pie := $(call cc-option, -no-pie, "")
> > +wclobbered := $(call cc-option, -Wclobbered, "")
> > +wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
> > +
> >   COMMON_CFLAGS += $(fomit_frame_pointer)
> >   COMMON_CFLAGS += $(fno_stack_protector)
> >   COMMON_CFLAGS += $(fno_stack_protector_all)
> >   COMMON_CFLAGS += $(wno_frame_address)
> >   COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
> >   COMMON_CFLAGS += $(fno_pic) $(no_pie)
> > +COMMON_CFLAGS += $(wclobbered)
> > +COMMON_CFLAGS += $(wunused_but_set_parameter)
>
> Looks good to me up to this point here...
>
> >   CFLAGS += $(COMMON_CFLAGS)
> > -CFLAGS += -Wmissing-parameter-type -Wold-style-declaration -Woverride-init
> > -CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
> > +CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>
> ... but I think this hunk rather belongs to the next patch instead?
>
>   Thomas
>
