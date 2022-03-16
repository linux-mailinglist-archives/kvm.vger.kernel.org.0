Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3E94DB82A
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 19:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiCPSux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 14:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240709AbiCPSuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 14:50:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284766B089
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:49:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n15so2551281plh.2
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7ERAKcifRzxT6vcVSjDSozSgypW/KEW+vG0ASHCMHY=;
        b=EzwZe3ti/2sTFi0gzWAE+otHNwPAgMXQlTrdW5phcUmxKkHY/mhUFb2IyXF9KVVy/D
         ZZScNEQ30YzZhGoDBcDZwia4z6A8qPXdZYDXWIe1+P7k6dicin06qMrNjt3UBPEGg0xg
         hXRUdafsQ4hecOzsNY8upgcQF/oTX1S+MFQdBAm5vGiFsmlgOef5nXj5Lih8CZJjNAC1
         8z2v38eH+liqupz+geO+Jhdb8o970vpMhLS4UkfDjB26oOyfng2nrCBZgaQQoVM80Uak
         B+d+V2FIZiDq0KBGNEgpnXziZu8VfjqhxX/NJyQgCCDiqwRrqIkL9BtI8MgIhQfcEk6b
         CmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7ERAKcifRzxT6vcVSjDSozSgypW/KEW+vG0ASHCMHY=;
        b=SqPAFyo2kv2vCQ+t3lYKXuhVZWyCdf8e/Dbn6zwEX+rBV2mksh+LWrURUHLEIGvN4j
         zpm5fEZR7E+hIsQ1kMfGcUgBpj6uh2nDYCH63/DnPPIfg7Uadr7pv3Vi5OBcZo2Y6JrE
         WLd1pubgfAPccVLQWvkjr17vv6UmtGpQNlXyBv8PKebwpoRgBtb0vyCCqyblaam+Hjgd
         Da2z4uCE2lSQZsm/oc7I0c0y5XKot+61Q9DAGQd1iJgjC33aTT/JgvxCORaUSRA3bIW2
         q7M88ffbqf3gtkmv4b3udWF0MmPaOYZAcGXOeI6/CMsl3KQoy3d6wkdqmJRGT709zBSY
         X3cw==
X-Gm-Message-State: AOAM531EZeqQkPGn2nIOhSQaTHhwHaJmICWgcHmc8Zza4dWhyEpBIWoD
        iFMw+Hw+WQ83mst6SHY73gAQ9zbgHKiZQqziROne
X-Google-Smtp-Source: ABdhPJxwp/pkpCQtHo7tVh5Dg1xcTc9fNxHdNL+EZXfY9wfYvIVklmRmDUPiJum14n0p7tN0MasdTRHMWSpkdNRp57Q=
X-Received: by 2002:a17:903:32c8:b0:150:1189:c862 with SMTP id
 i8-20020a17090332c800b001501189c862mr878311plr.134.1647456577401; Wed, 16 Mar
 2022 11:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220316060214.2200695-1-morbo@google.com> <20220316074356.n7e5lzrmnal2dcgu@gator>
 <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
In-Reply-To: <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 16 Mar 2022 11:49:26 -0700
Message-ID: <CAGG=3QWOZVtXfyR4Lu8qBS-ASBFeMaLGo1ANXTxi7gPoLbA2Ag@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
To:     Thomas Huth <thuth@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Laurent Vivier <lvivier@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>
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

On Wed, Mar 16, 2022 at 12:53 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 16/03/2022 08.43, Andrew Jones wrote:
> > On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> >> Clang warns about using a bitwise '|' with boolean operands. This seems
> >> to be due to a small typo.
> >>
> >>    lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >>            if (can_assume(LIBFDT_ORDER) |
> >>
> >> Using '||' removes this warnings.
> >>
> >> Signed-off-by: Bill Wendling <morbo@google.com>
> >> ---
> >>   lib/libfdt/fdt_rw.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> >> index 13854253ff86..3320e5559cac 100644
> >> --- a/lib/libfdt/fdt_rw.c
> >> +++ b/lib/libfdt/fdt_rw.c
> >> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
> >>                      return struct_size;
> >>      }
> >>
> >> -    if (can_assume(LIBFDT_ORDER) |
> >> +    if (can_assume(LIBFDT_ORDER) ||
> >>          !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
> >>              /* no further work necessary */
> >>              err = fdt_move(fdt, buf, bufsize);
> >> --
> >> 2.35.1.723.g4982287a31-goog
> >>
> >
> > This is fixed in libfdt upstream with commit 7be250b4 ("libfdt:
> > Correct condition for reordering blocks"), which is in v1.6.1.
> > We can either take this patch as a backport of 7be250b4 or we
> > can rebase all of our libfdt to v1.6.1. Based on the number of
> > fixes in v1.6.1, which appear to be mostly for compiling with
> > later compilers, I'm in favor of rebasing.
>
> +1 for updating to v1.6.1 completely.
>
Also +1. :-) Thank you!

-bw

> > Actually, we can also use this opportunity to [re]visit the
> > idea of changing libfdt to a git submodule. I'd like to hear
> > opinions on that.
>
> I'm always a little bit torn when it comes to this question. Sure, git
> submodules maybe make the update easier ... but they are a real pita when
> you're working with remote machines that might not have direct connection to
> the internet. For example, I'm used to rsync my sources to the non-x86
> machines, and if you forget to update the submodule to the right state
> before the sync, you've just lost. So from my side, it's a preference for
> continuing without submodules (but I won't insist if everybody else wants to
> have them instead).
>
>   Thomas
>
