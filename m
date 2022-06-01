Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0653AB90
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 19:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355397AbiFARJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 13:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244187AbiFARJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 13:09:27 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB7F91568
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 10:09:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a2so3823771lfc.2
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 10:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6GeLD3Qu1S7z4F36g18rOSIz4Q2miMJ86WBcXOYQMM4=;
        b=Zqs9ZYZWKj5P5kxJ62Enznt2Mwc1eKtKjnrY39qzE9bQqEi1Gy4yFGE+y+lic8N78a
         scqAwiqCUOuaKVRJYNasj0bqZdE0GYX6MhzB17qujvWO0HvmNDZV898IrZkkERTLLG32
         l/go1EU12T6KtvyaUTNsD/2EKnaHwf7IXzTlYySuDPCf1j9YXhmVbV4h21VKhKkiviMs
         fPyhzL4dWZexBRPTFFalgRjIeTOS58PH9taK9N2Vfbb873+wFWmBje0oUtT11ZFIv7iJ
         TMVeNDJsRWpCgfnC3hT8z4ji16v841FMLjtHpIgpJQCn+F+s0t1GlkT0PxIiFsanqKGS
         zNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6GeLD3Qu1S7z4F36g18rOSIz4Q2miMJ86WBcXOYQMM4=;
        b=FyTpWHyGklw4GnegZZ18Hs7ExKSrT+khyX57v+qedhF81OBI/VVGnK7Kb5pEb2GCD1
         eVVhbVVsmeYLSKT0GyDIkz0lx6rHmCPXkskm4ftqurijFyarKPbZoA+q4NvW4gctlUIJ
         OL0asy9F32zxYhBdigZH/JUv8a0VT5XnzjSJpaSW0HzDfUpQQm1tDt2jr3z3BuP4rTeS
         WUU41zkPBCSsjJlOwMpIgxp4JwOOlEStGbfXeKPAZkWq5gHP9mv7utF5KhKgD5RaCw7J
         dURD6x3hnc1ZVOarlU99W6Gchs5UhQjY9sj80rP7Ib5p5UibYWwc+dOws9J5putF5V4a
         Szsw==
X-Gm-Message-State: AOAM530Ed9YBBwtxy4gSk4Yf6gR+JDdSyB0w8brLOK65S5szwTdkDy6I
        bV5nCJsT2iSNLBTT+mOzJFmqW24oQzOceCssK3gjZQ==
X-Google-Smtp-Source: ABdhPJxf/hNUC4I0K6xCV9xSGcVmcOYHD5OTEa5lGs+NWrQ4cJrtiLHVNeHVmNJrEdKxx9ArgR5GZNERAWmwcQs8hZA=
X-Received: by 2002:a05:6512:2a98:b0:477:cb45:7884 with SMTP id
 dt24-20020a0565122a9800b00477cb457884mr311749lfb.388.1654103364053; Wed, 01
 Jun 2022 10:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220526071156.yemqpnwey42nw7ue@gator> <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-2-cross@oxidecomputer.com> <686aae9b-6877-7d7a-3fd4-cddb21642322@redhat.com>
In-Reply-To: <686aae9b-6877-7d7a-3fd4-cddb21642322@redhat.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Wed, 1 Jun 2022 13:09:13 -0400
Message-ID: <CAA9fzEE3tdJuNwNDzbcoUQ39He7hKf2X=u-RAvq8fSHwD=3JZA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 1, 2022 at 3:03 AM Thomas Huth <thuth@redhat.com> wrote:
> On 26/05/2022 19.39, Dan Cross wrote:
> > Change x86/Makefile.common to invoke the linker directly instead
> > of using the C compiler as a linker driver.
> >
> > This supports building on illumos, allowing the user to use
> > gold instead of the Solaris linker.  Tested on Linux and illumos.
> >
> > Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> > ---
> >   x86/Makefile.common | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/x86/Makefile.common b/x86/Makefile.common
> > index b903988..0a0f7b9 100644
> > --- a/x86/Makefile.common
> > +++ b/x86/Makefile.common
> > @@ -62,7 +62,7 @@ else
> >   .PRECIOUS: %.elf %.o
> >
> >   %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
> > -     $(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
> > +     $(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
> >               $(filter %.o, $^) $(FLATLIBS)
> >       @chmod a-x $@
>
>
>   Hi,
>
> something seems to be missing here - this is failing our 32-bit
> CI job:
>
>   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/2531237708
>
> ld -T /builds/thuth/kvm-unit-tests/x86/flat.lds -nostdlib -o x86/taskswitch2.elf \
>         x86/taskswitch2.o x86/cstart.o lib/libcflat.a
> ld: i386 architecture of input file `x86/taskswitch.o' is incompatible with i386:x86-64 output
> ld: i386 architecture of input file `x86/cstart.o' is incompatible with i386:x86-64 output
> ld: i386 architecture of input file `lib/libcflat.a(argv.o)' is incompatible with i386:x86-64 output
> ld: i386 architecture of input file `lib/libcflat.a(printf.o)' is incompatible with i386:x86-64 output
> ...
>
> You can find the job definition in the .gitlab-ci.yml file (it's
> basically just about running "configure" with --arch=i386).

Thanks. I think the easiest way to fix this is to plumb an
argument through to the linker that expands to `-m elf_i386`
on 32-bit, and possibly, `-m elf_x86_64` on 64-bit. The
architecture specific Makefiles set the `ldarch` variable,
and that doesn't seem used anywhere, but I see that's set
to match the string accepted by the linker scripts/objcopy,
not something acceptable to `-m`. However, one can add
something to `LDARGS`, but I see that that's set to include
the contents of CFLAGS, which means it includes flags
that are not directly consumable  by the linker itself.

I think the simplest way forward is to introduce a new
variable in x86/Makefile.i386 and x86/Makefile.x86_64 and
refer to that in x86/Makefile.common; possibly `LDEXTRA`?
I've got an updated patch here that does that, and it seems
to work (building under both illumos and arch locally), but
before I send up another patchset, let me know if that
sounds acceptable?

        - Dan C.
