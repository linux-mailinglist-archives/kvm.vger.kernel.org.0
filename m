Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7760BF86
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 02:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiJYA0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 20:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiJYA0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 20:26:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF892E8BA8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 15:49:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so4855401pjc.3
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 15:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/AWa3qlX0TZZmcVUUsn3Tb8nUf6k5e1FIAVrnZTCmYI=;
        b=J0IpUn6FI/kYOKxdB1ZGL+PJTD5AOM1AZTb72Ij/wH6e4vpnchSBDYvJK2oThonntk
         tWYhuiv/TwhsKB+SCLiZHPW7d9sG8ejR1aVrtJkwsmonTQwnYrNJma3TYzCXSb7mfj5k
         b3vJFV0tQiVIQXyFF6lBACeIKj/P4pYxTqQwP9jjymZTfbmzo+G5cEYThwLLqHPxjHYy
         OtwXRvC9qmg2I6v7qgzHGKXw90/gDACetu2ZTiOWf0gGBPlonNYluuGQjt7T6lZpzPzN
         8zaRpQLCFBHCBMD+oUChMMwshuIOihx790dnjiNWtlFdT34DmF5kqNhTzpGTHdKvFZQZ
         yDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AWa3qlX0TZZmcVUUsn3Tb8nUf6k5e1FIAVrnZTCmYI=;
        b=mQf3ZH0Vg6rdgxzKYQvPeqLKk93mTGwlPfjgcUA86BHzcLVvil7fQ5xp8xBDOrmLqF
         gTPY8tSb67OSgwwvK7cfAlP0Wzfq56QHsrckyqrZLIcq2+yqPTSdwctj31BpjU110gON
         byauWSsorMqtFm5xPAf5Mcw8bcbyIonfOVrKDy6e95YrfaScFumkaF8GHQ4pvPw/8lI8
         sfM+pefEeXIiLO3sfAMNjankszs3vW9P6To3QjyWJhn43gi5/Y3bWZP7MzOZju6Ak+Y5
         lHJ8PUoNm7Tds1RPqU7617h3mgaMUKWJcJREKhYFYMlZcsjrhAEJsLnjEOWSz0unEZRR
         PI5w==
X-Gm-Message-State: ACrzQf3LzSGCLtvJhYRmcvkbsmyHnPCS32RcrmZuKA3qZiqLCMvrWEPW
        GfoX/0OKcz1UbPtWpSLfxTb1QQ==
X-Google-Smtp-Source: AMsMyM7tO+B7mOI6gUYi2pZl6vuHPGs9heJSVfVERzKu/2r7KbO5Y8ncGGRoCKgXTy9PPUahCHjIAA==
X-Received: by 2002:a17:902:c1c6:b0:186:994f:6e57 with SMTP id c6-20020a170902c1c600b00186994f6e57mr11400751plc.17.1666651778037;
        Mon, 24 Oct 2022 15:49:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b0056bdc3f5b29sm274262pfk.186.2022.10.24.15.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 15:49:37 -0700 (PDT)
Date:   Mon, 24 Oct 2022 22:49:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
Message-ID: <Y1cWfiKayXy5xvji@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-2-mlevitsk@redhat.com>
 <Y1GNE9YdEuGPkadi@google.com>
 <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> On Thu, 2022-10-20 at 18:01 +0000, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > Tests that need interrupt shadow can't rely on irq_enable function anyway,
> > > as its comment states,  and it is useful to know for sure that interrupts
> > > are enabled after the call to this function.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  lib/x86/processor.h       | 9 ++++-----
> > >  x86/apic.c                | 1 -
> > >  x86/ioapic.c              | 1 -
> > >  x86/svm_tests.c           | 9 ---------
> > >  x86/tscdeadline_latency.c | 1 -
> > >  x86/vmx_tests.c           | 7 -------
> > >  6 files changed, 4 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > > index 03242206..9db07346 100644
> > > --- a/lib/x86/processor.h
> > > +++ b/lib/x86/processor.h
> > > @@ -720,13 +720,12 @@ static inline void irq_disable(void)
> > >         asm volatile("cli");
> > >  }
> > >  
> > > -/* Note that irq_enable() does not ensure an interrupt shadow due
> > > - * to the vagaries of compiler optimizations.  If you need the
> > > - * shadow, use a single asm with "sti" and the instruction after it.
> > > - */
> > >  static inline void irq_enable(void)
> > >  {
> > > -       asm volatile("sti");
> > > +       asm volatile(
> > > +                       "sti \n\t"
> > 
> > Formatting is odd.  Doesn't really matter, but I think this can simply be:
> > 
> > static inline void sti_nop(void)
> > {
> >         asm volatile("sti; nop");
> 
> "\n\t" is what gcc manual recommends for separating the assembly lines as you
> know from the gcc manual:
> https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html "You may place multiple
> assembler instructions together in a single asm string, separated by  the
> characters normally used in assembly code for the system. A combination that
> works in  most places is a newline to break the line, plus a tab character to
> move to the instruction  field (written as ‘\n\t’). Some assemblers allow
> semicolons as a line separator.  However, note that some assembler dialects
> use semicolons to start a comment"
> 
> Looks like gnu assembler does use semicolon for new statements and hash for comments 
> but some assemblers do semicolon for comments.
> 
> I usually use just "\n", but the safest is "\n\t".

I'm pretty sure we can ignore GCC's warning here and maximize readability.  There
are already plenty of asm blobs that use a semicolon.
