Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CF573EEB0
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 00:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjFZWeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 18:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjFZWeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 18:34:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7313AE5B
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 15:34:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c11d081de8dso3588572276.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687818851; x=1690410851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Vg4hZm9fpFWiBqixG4Q+f/nHkPQNxqem1yZABI6YEs=;
        b=RIhCNi128w53AsG94gTZ/h7xROjZCN90D5HF+zj6H+mf+tA9uJXzK2gwkVi1+EczUw
         oUhB8sO1YNtH/9Jeg4uefzw7BlrESpAnfXFuChHqiBmudCaqmKnQGCYz4sF8vwUzj4Du
         yfiP/vpIVM+R1H5cU9owGm2ns/rcJIl54qr2vnpafOqlUiXF2q+XgNg4sieRH2Gzwk02
         MSWutXvjPQPJ62sgqKkw621yLOwVbZJtCxCdlkhmQASoOzPzi8FhemFVvuZFJHbsLit/
         5aJuEJv8CebqDMZ8NZ0c2wiDtLloVCC6mrxMRzU5FEG5O8VfzrWvv/Y++EOt/hcJWP1q
         BIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687818851; x=1690410851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Vg4hZm9fpFWiBqixG4Q+f/nHkPQNxqem1yZABI6YEs=;
        b=isj0Zk+aqyaJL+ISM9sKnjnyN0rZZOEFpH1GzhhOi2MIKHd1LJxB4Fo1BKWhkOn6Y7
         k5nFT0ndLSG+Ur18FSxYOregqy3Ge6oOBfZ9Of+9oWyoRBgJTvqU2BJIzRkqZPOFK+4J
         uO355Iyhudh3U7ZTP12jqYDaLBqP1WxyaiVIsdqr8uj/8oDq66VMRZR4oxuXW6qrwulf
         nhMyk/1dLzDnuSa8EPXRJYMvc4E4cfSFWyeJyEMkr2tNCo1A1sRYz5dU45DgtgaIZ+VA
         VBncreZXcTWUQr5naD6tqjQfsZJpDyv65Cauw0+eOZ/bXH0RNCwuWmXVnxZ5awcvTtv5
         4Z6g==
X-Gm-Message-State: AC+VfDytUq2RmHLZQWVlqusIeJxNRmHmuc4NPSplEZjoVuL+O+FJg+1R
        HayChIeYrcnBDl4UsAsBQerDZ9MuOCU=
X-Google-Smtp-Source: ACHHUZ6By2nwy1N4OsGA0iP40C8/7BpgMrb+W8CG/njrH1qS7qUc13yLXXj+AhZqSxHnuO5I0vzWbc1VeaQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e701:0:b0:c00:3434:f639 with SMTP id
 e1-20020a25e701000000b00c003434f639mr4728541ybh.1.1687818851762; Mon, 26 Jun
 2023 15:34:11 -0700 (PDT)
Date:   Mon, 26 Jun 2023 15:34:10 -0700
In-Reply-To: <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Mime-Version: 1.0
References: <20230623125416.481755-1-thuth@redhat.com> <20230623125416.481755-3-thuth@redhat.com>
 <ZJWrKtnflTrskPkX@google.com> <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Message-ID: <ZJoSYnZGYrAj11RN@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Nico =?iso-8859-1?Q?B=F6hr?=" <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023, Thomas Huth wrote:
> On 23/06/2023 16.24, Sean Christopherson wrote:
> > On Fri, Jun 23, 2023, Thomas Huth wrote:
> > > Newer versions of ld (from binutils 2.40) complain on s390x and x86:
> > > 
> > >   ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
> > >                executable stack
> > >   ld: NOTE: This behaviour is deprecated and will be removed in a
> > >             future version of the linker
> > > 
> > > We can silence these warnings by using "-z noexecstack" for linking
> > > (which should not have any real influence on the kvm-unit-tests since
> > > the information from the ELF header is not used here anyway, so it's
> > > just cosmetics).
> > > 
> > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > ---
> > >   Makefile | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 0e5d85a1..20f7137c 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> > >   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
> > > -LDFLAGS += -nostdlib
> > > +LDFLAGS += -nostdlib -z noexecstack
> > 
> > Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].
> 
> Oops, sorry, I did not notice that patch in my overcrowded mailboxes (or
> forgot about it during KVM forum...) :-/

Heh, you gave a Reviewed-by[*], so either its the latter, or you've got a clone
running around :-)

[*] https://lore.kernel.org/all/916aac4f-97b8-70c2-de39-87438eb4aea4@redhat.com

> > Paolo, want me to redo the pull request to drop the x86-specific patch?
> 
> I can also respin my patch on top of your series later ... the problem
> currently also only seems to happen on x86 and s390x, on ppc64 and aarch64,
> the linker does not complain ... so maybe it's even better to do it
> per-architecture only anyway? Opinions?

I don't think it makes sense to do this per-arch, other architectures likely aren't
problematic purely because of linker specific behavior, e.g. see

https://patches.linaro.org/project/binutils/patch/1506025575-1559-1-git-send-email-jim.wilson@linaro.org
