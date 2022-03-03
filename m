Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21804CC334
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiCCQvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCCQu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:50:59 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A14E19D61E
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:50:12 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 5so7594574lfz.9
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OnP9YZiY8LZiBvuJs+7fQgruVzN1W1DRlosAbZ20eCM=;
        b=e2OOw78cj76HlttC7akVmIp8IrXroOyLB/efbDVeKuJIH1CQABYQAInwumnT0KjIuA
         JHcDWJ8j3Enc82Pgu5wVatU6ZlZmE/fHZctXhmdBEx6492kYgvCXMc5Sxv5pPGmBC7qV
         JBpkIg4KPxxdgXMqrKRaffpH5T3SZvKEb5ueUX9F3FuLkVM9si2oOFN0Odlmf0Su0kLT
         aep4o8rxfMQw8h+Cf8dT4lhSS46m5KUnnpGbop5k+UlvO+/5xS1I7hXGMTJxhJU3DWFE
         BVZrot854eRE6SdzW4WVUD/WAquytdHmQB5EhX89dsVPrUEzv3R9ZitRPZjweC8dSX0J
         BBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OnP9YZiY8LZiBvuJs+7fQgruVzN1W1DRlosAbZ20eCM=;
        b=l/Y5l0SF28Bx980IZgDpxX8YBgtdwwmKr3JeKP/mnlWfk8+PA65+SgseL6CS3S/tsl
         7/hxHDBPNmMIzoWy6mUkaJNSN7mb+0NOSm8hPcC9RAXO9IMW10FsNkUXun/f2IFAQLdD
         A5+wdx92ZR9tolY+Bdh2QxepxRoK+Dt9tygek5HcFgJU4kYC+yR/niwoRY+W72YQAE/i
         jTqAlrOMrsrwmnXOLZFNExdaXqx/8Szd35nwvYPWsqV81B61SreP3+kBeanctmIpq3hE
         J/SPPCQEBc8IKhwoRhTwilt73h0B+V4XR/OE5o4R0YSYFbEgwCcHDntuyKkyN1RBJtJw
         xIpQ==
X-Gm-Message-State: AOAM532BzMnMqMwmWnkLNRwedmoJSy6CCNzlwTjuM1xYxj+4VU6jwrhU
        jSz5jHMhmxixMiOCMY8AnsXtZKlQjd68La6FCeNcng==
X-Google-Smtp-Source: ABdhPJwns0ZI2bNJKx15VKsAw6Tlz5PjF540BG6Jo4StjaTjubs3HgdHvB6x3CQO3gqU6j/KJqlsfiJfCHCoe5HUPlk=
X-Received: by 2002:a05:6512:2291:b0:443:ab97:7e49 with SMTP id
 f17-20020a056512229100b00443ab977e49mr21840598lfu.402.1646326208673; Thu, 03
 Mar 2022 08:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20220303160442.1815411-1-pgonda@google.com> <YiDsEgxUDZL+XY9R@google.com>
In-Reply-To: <YiDsEgxUDZL+XY9R@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 3 Mar 2022 09:49:57 -0700
Message-ID: <CAMkAt6rwiL_G1w66_rseKSFOTSV4zX8gnb1EOoQNv5TH=ToHGw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Fix missing kvm_cache_regs.h include in svm.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 3, 2022 at 9:26 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 03, 2022, Peter Gonda wrote:
> > Adds include for is_guest_mode() in svm.h.
>
> Write changelogs as "commands", not descriptions.  And a little extra verbosity
> wouldn't hurt, e.g.
>
>   Include kvm_cache_regs.h to pick up the definition of is_guest_mode(),
>   which is referenced by nested_svm_virtualize_tpr().
>
> Though you'll probably need a different changelog (see below).

Thanks Will do.

>
> > Just compile tested.
>
> This belongs in the ignored part, not the changelog proper.

Ack.

>
> > Fixes: 883b0a91f41ab ("KVM: SVM: Move Nested SVM Implementation to nested.c")
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/x86/kvm/svm/svm.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index e45b5645d5e0..396d60e36b82 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -22,6 +22,8 @@
> >  #include <asm/svm.h>
> >  #include <asm/sev-common.h>
> >
> > +#include "kvm_cache_regs.h"
>
> Ha, we've already got a lovely workaround for exactly this problem.  This patch
> should drop the include from svm_onhyperv.c, there's nothing in that file that
> needs kvm_cache_regs.h (I verified by deleting use of is_guest_mode()), it's
> included purely because of this bug in svm.h.

Ah good catch. I assume I should add kvm_cache_regs.h to
arch/x86/kvm/svm/nested.c too since it uses is_guest_mode().

>
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
> index 98aa981c04ec..8cdc62c74a96 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.c
> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
> @@ -4,7 +4,6 @@
>   */
>
>  #include <linux/kvm_host.h>
> -#include "kvm_cache_regs.h"
>
>  #include <asm/mshyperv.h>
>
>
