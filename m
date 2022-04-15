Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C12502ED0
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 20:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbiDOSry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 14:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346947AbiDOSrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 14:47:52 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621214EF77
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:45:23 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-ddfa38f1c1so8722693fac.11
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5Uzp0RLa089q2P6LXUgB4v6/9r0Kd94Pa7ruaUq9mY=;
        b=AUpk/W/9OfA2b1qWd66tJgJGcVj7rCoTFcEsjtv9RpkPdnj3TfFwtJDdtjAevR1iHe
         5kK5VlIR8bTKBSfGyW5Fejy2l7zyVj/MQvvz//yzkwLZm7ZfIkFpfNiGXGHK21GV6Ycs
         IxTLzagGQjc7LnwPPBCQmkudYK31yMzA8AYGho9LKchivBxtMOewYstscT2pWA/yrgho
         oruwg06p76gKwqX/jkAkrnaxNzJ7NvaXOx27kvPrxAwx0jr7Q2jEE8hwZAiBzL4HoXlD
         tgTGP6yO8RmdJPnWxBJELmn/U3ZIaLhzDrAfFBMqYLdZcJH0N2bwJZqMpA1FDiD7q//p
         Gl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5Uzp0RLa089q2P6LXUgB4v6/9r0Kd94Pa7ruaUq9mY=;
        b=4zTXoO+TJavdKUPs59wt4p22EiiCr+spX2RNrAfLUMLDDrkgCUr84uuSIGe4/MtNKk
         sEprVtdtyCC/+Q3JlpM5vGvX2UAW+xGtmI4U/TJek5a61iZ/yfcbS/JOza3/4VXRW3bC
         ohBGTiuHTSxNq1tHLTgqEufhpMATPnr1FqYbSJqRxVV3XcfEeUY/jkwREPnY1gAFMJdM
         H7dO20ZB3Hp2MzU6qYZUzF8gbwUKa2pNzc1XmrkQIx6knecTAeUurauPYNePtC7OrEXs
         Lag7HLYZIJJ2dNLbIyNnoLeSANnhVLMo66gN4C1Vj7bgUCczGgvMnAYCzaKOEJusXmWO
         n/5Q==
X-Gm-Message-State: AOAM532ybhlJ4CO9QMhq+iC5AuTLd7oVd8zmuHGnkHNhBHm6mTuRnJV6
        J834HryM0vqefscR/cw/z/5CJ6fsNniDX6MCrJVzMw==
X-Google-Smtp-Source: ABdhPJwnz8rObz2OK/mD2zX7+J1kAV3Efl78kgSVqr6fbfbMgv668+kxopj6GNBU9pfCER6Z2ut2YPaVSpEurnSgFGo=
X-Received: by 2002:a05:6870:b616:b0:e2:f8bb:5eb with SMTP id
 cm22-20020a056870b61600b000e2f8bb05ebmr1916201oab.218.1650048322492; Fri, 15
 Apr 2022 11:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220224105451.5035-1-varad.gautam@suse.com> <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com> <Yk/nid+BndbMBYCx@suse.de> <YlmkBLz4udVfdpeQ@google.com>
 <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com> <Ylm51s5c2t60G5sy@google.com>
In-Reply-To: <Ylm51s5c2t60G5sy@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 15 Apr 2022 11:45:11 -0700
Message-ID: <CAA03e5FVTizMzWeO2CDS_d7ym6eoaqn1tAOe+2C=OUOPLoHz3Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string IO
 for IOIO #VC
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 11:30 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Marc Orr wrote:
> > On Fri, Apr 15, 2022 at 9:57 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Apr 08, 2022, Joerg Roedel wrote:
> > > > On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> > > > > On Thu, Feb 24, 2022, Varad Gautam wrote:
> > > > > > Using Linux's IOIO #VC processing logic.
> > > > >
> > > > > How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> > > > > is probably less work in the long run.
> > > >
> > > > The problem is that SEV-ES support will silently break if someone adds
> > > > it unnoticed and without testing changes on SEV-ES.
> > >
> > > But IMO that is extremely unlikely to happen.  objdump + grep shows that the only
> > > string I/O in KUT comes from the explicit asm in emulator.c and amd_sev.c.  And
> > > the existence of amd_sev.c's version suggests that emulator.c isn't supported.
> > > I.e. this is being added purely for an SEV specific test, which is silly.
> > >
> > > And it's not like we're getting validation coverage of the exit_info, that also
> > > comes from software in vc_ioio_exitinfo().
> > >
> > > Burying this in the #VC handler makes it so much harder to understand what is
> > > actually be tested, and will make it difficult to test the more interesting edge
> > > cases.  E.g. I'd really like to see a test that requests string I/O emulation for
> > > a buffer that's beyond the allowed size, straddles multiple pages, walks into
> > > non-existent memory, etc.., and doing those with a direct #VMGEXIT will be a lot
> > > easier to write and read then bouncing through the #VC handler.
> >
> > For the record, I like the current approach of implementing a #VC
> > handler within kvm-unit-tests itself for the string IO.
> >
> > Rationale:
> > - Makes writing string IO tests easy.
>
> (a) that's debatable, (b) it's a moot point because we can and should add a helper
> to do the dirty work.  E.g.
>
>   static void sev_es_do_string_io(..., int port, int size, int count, void *data);
>
> I say it's debatable because it's not like this is the most pleasant code to read:
>
>         asm volatile("cld \n\t"
>                      "movw %0, %%dx \n\t"
>                      "rep outsb \n\t"
>                      : : "i"((short)TESTDEV_IO_PORT),
>                        "S"(st1), "c"(sizeof(st1) - 1));

Yeah, if we have a helper that resolves most of my concerns. (More on
this below.)

> > - We get some level of testing of the #VC handler in the guest kernel
> > in the sense that this #VC handler is based on that one. So if we find
> > an issue in this handler we know we probably need to fix that same
> > issue in the guest kernel #VC handler.
> > - I don't follow the argument that having a direct #VMGEXIT in the
> > test itself makes the test easerit to write and read. It's going to
> > add a lot of extra code to the test that makes it hard to parse the
> > actual string IO operations and expectations IMHO.
>
> I strongly disagree.  This
>
>         static char st1[] = "abcdefghijklmnop";
>
>         static void test_stringio(void)
>         {
>                 unsigned char r = 0;
>                 asm volatile("cld \n\t"
>                         "movw %0, %%dx \n\t"
>                         "rep outsb \n\t"
>                         : : "i"((short)TESTDEV_IO_PORT),
>                         "S"(st1), "c"(sizeof(st1) - 1));
>                 asm volatile("inb %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
>                 report(r == st1[sizeof(st1) - 2], "outsb up"); /* last char */
>
>                 asm volatile("std \n\t"
>                         "movw %0, %%dx \n\t"
>                         "rep outsb \n\t"
>                         : : "i"((short)TESTDEV_IO_PORT),
>                         "S"(st1 + sizeof(st1) - 2), "c"(sizeof(st1) - 1));
>                 asm volatile("cld \n\t" : : );
>                 asm volatile("in %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
>                 report(r == st1[0], "outsb down");
>         }
>
> is not easy to write or read.

Agreed. But having to also "Bring Your Own #VC Handler" makes it even
harder. Which is my point.

If we have helpers to load a #VC handler, then that resolves most of
my concerns. Though, I still think having a default #VC handler for
string IO is better than not having one. (More on that below.)

> I'm envisioning SEV-ES string I/O tests will be things like:
>
>         sev_es_outsb(..., TESTDEV_IO_PORT, sizeof(st1) - 1, st1);
>
>         sev_es_outsb_backwards(..., TESTDEV_IO_PORT, sizeof(st1) - 1,
>                                st1 + sizeof(st1) - 2));
>
> where sev_es_outsb() is a wrapper to sev_es_do_string_io() or whatever and fills
> in all the appropriate SEV-ES IOIO_* constants.
>
> Yes, we can and probably should add wrappers for the raw string I/O tests too.
> But, no matter what, somehwere there has to be a helper to translate raw string
> I/O into SEV-ES string I/O.  I don't see why doing that in the #VC handler is any
> easier than doing it in a helper.

Hmmm... yeah, if this patch really does get vetoed then rather than
throw it away maybe we can convert it to be loaded with a helper now.

Note: I hear your arguments, but I still don't agree with throwing
away this patch. At least not based on the arguments made in this
email thread. I think having a default #VC handler to handle string IO
is better than not having one. Individual tests can always override
it. From reading the other email thread on the decoder, I get the
sense that the real reason you're opposed to this patch is because
you're opposed to pulling in the Linux decoder. I don't follow that
patch as well as this one. So that may or may not be a valid reason to
nuke this patch. I'll leave that for others to discuss.

> > - I agree that writing test cases to straddle multiple pages, walk
> > into non-existent memory, etc. is an excellent idea. But I don't
> > follow how exposing the test itself to the #VC exit makes this easier.
>
> The #VC handler does things like:
>
>         ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
>
> to explicitly not mess up the _guest_ kernel.  The proposed #VC handler literally
> cannot generate:
>
>   - a string I/O request larger than 2032 bytes
>   - does not reside inside the GHCB's internal buffer
>   - spans multiple pages
>   - points at illegal memory
>
> And so on an so forth.  And if we add helpers to allow that, then what value does
> the #VC handler provide since adding a wrapper to follow the Linux guest approach
> would be trivial?

Fair point. But having the #VC handler doesn't prevent tests from
pivoting to their own handler when needed.
