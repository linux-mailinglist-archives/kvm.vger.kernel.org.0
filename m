Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC2B6D9E4D
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbjDFRQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 13:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDFRQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 13:16:38 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17661BF1
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:16:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i7-20020a626d07000000b005d29737db06so17988539pfc.15
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680801397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EimPnRlK2Hgu9kq2pa4Ciunr9Zl8OZ58JUS2PAOUmOo=;
        b=AQKPq5FSdL6ZpDmqGeKGvn/TXWGW1Yvkde8GBDaGWtj9yGrnJxz3hxP19pI1JcaWoZ
         XE6L+0xFZI85VKPEgCiMCuchutBfRZkei9odX8mRk3rhcMecXWMobQOqxKnF6o97Mk3O
         3BhosB8K1w/kGhALaTOsPo9L0swxZmbn8765T3O9XFgvzNH+TQkOI8E2ysU7G9OKZMKS
         dO6TujdzGpSqHpCIdie8uf9ecJ4NPTDUxkNM5LgTe+Tcy8tzLbGGjTIPRXy0Yj2hAFUk
         JgyntvMzNsp78de5wFlrn1S5HkAj7aOKwcUZ7IkTHIiR63RfG/sYoWMmA1UVSmjvbY2R
         Oe4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680801397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EimPnRlK2Hgu9kq2pa4Ciunr9Zl8OZ58JUS2PAOUmOo=;
        b=f610Qdz91Gv2lT5cT/4rZRFYefJwpLCNVTnV0AH6lyKM2FXLLV5Mk+mCdOONc2jqF2
         +avC4E9gUkXu6ijocxdqFryFeqxafMgnL46JNa0O+FLL4zhBDI0VsCd6hBFm5hkfdv9J
         xhUpykn9siwnTeGOj7s9prTxtNDVx00JxGv8ZGlwCfWtzz4DTa84hmXLHnJ4Ilbl+Sqz
         tLGYZgU57nKn9WgJdC7oZxxSKwTam2dfl5QrOlUh66VK04v22tGFyDeXwzeWnIIzEh2c
         ZqoAiQIMr8EELKjnkgAZJuotmc6I6iMuq/e9kki4JbE2haT1hJKbDZZmaTBWPDJraBJ1
         AX2w==
X-Gm-Message-State: AAQBX9fwEy0Osh0vIuOtYa6O3bSUHqOmVWrtGxSAtyr36YQRmzrYl88O
        cMjuCkuQ4+VY6Rn1QLB+ntCKk4Tu/ks=
X-Google-Smtp-Source: AKy350bPZOngZbzUoabhXuz0gUjw1HBNJCPpztQlccvTqUCW6TS0uHlu2SXjW3fNe2A8Ms5puKeDXJlVVC4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5887:0:b0:513:9235:55e3 with SMTP id
 d7-20020a655887000000b00513923555e3mr3411455pgu.5.1680801397331; Thu, 06 Apr
 2023 10:16:37 -0700 (PDT)
Date:   Thu, 6 Apr 2023 10:16:35 -0700
In-Reply-To: <8b2fe89b-718c-074a-e566-41106dff016c@redhat.com>
Mime-Version: 1.0
References: <20230329123814.76051-1-thuth@redhat.com> <168073550254.619716.10085104611122942655.b4-ty@google.com>
 <8b2fe89b-718c-074a-e566-41106dff016c@redhat.com>
Message-ID: <ZC7+c42p2IRWtHfT@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/flat.lds: Silence warnings about empty
 loadable segments
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Thomas Huth wrote:
> On 06/04/2023 01.01, Sean Christopherson wrote:
> > On Wed, 29 Mar 2023 14:38:14 +0200, Thomas Huth wrote:
> > > Recent versions of objcopy (e.g. from Fedora 37) complain:
> > > 
> > >   objcopy: x86/vmx.elf: warning: empty loadable segment detected at
> > >    vaddr=0x400000, is this intentional?
> > > 
> > > Seems like we can silence these warnings by properly specifying
> > > program headers in the linker script.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 next, thanks!
> 
> Thanks for picking it up!
> 
> > On the topic of annoying warnings, this one is also quite annoying:
> > 
> >    ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
> >    ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > 
> > I thought "-z noexecstack" would make it go away, but either I'm wrong or I'm not
> > getting the flag set in the right place.
> 
> I never saw that warning here before, but I'm currently also still using an
> older version of GCC and binutils here since my development machine is still
> using RHEL 8 ...
> 
> Anyway, does this happen for the normal builds, or for the efi builds?

Normal builds with gcc 12.  I figured out what I got wrong, the "-z noexecstack"
needs to be passed to the linker, not the compiler/assembler.  This does the trick,
I'll post an official patch later today:

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 365e199f..c57d418a 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,7 @@ else
 # We want to keep intermediate file: %.elf and %.o
 .PRECIOUS: %.elf %.o
 
-%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
+%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS) -z noexecstack
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
        $(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
                $(filter %.o, $^) $(FLATLIBS)

> I can see a .note.GNU-stack entry in x86/efi/elf_x86_64_efi.lds ... maybe we
> need something similar in x86/flat.lds ?

I believe that just telling the linker that those sections don't need relocation
info.  I suspect it's unnecessary copy+paste from UEFI sources.

The linker warning from setjmp64.o (and cstart64.o) is yelling about _not_ having
.note.GNU-stack, which is a magic section that tells the linker that the binary
doesn't need an executable stack.  If I'm reading the NOTE correctly, it's saying
that the ability to have an executable stack is soon going away.
