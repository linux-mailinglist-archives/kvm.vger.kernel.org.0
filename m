Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57B58328E
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 20:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiG0S6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 14:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiG0S5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 14:57:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720D26E2F2
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 11:00:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v18so3566174plo.8
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 11:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HXAfNrA46sN6xwJ1e0HKdG0mgjkrw0iVXvg38vFIU5U=;
        b=W1Ed+ceUK8QwNF0Debm3Bt+7fjjd4y8F8JukQN39SHzkAaAeq1ZagInfPgjAHd1/wr
         6UlZ3EDhjLKgV2wxEpPSktDZQzjnAsHmHDcNGoTpjAAnDbvdhHvW+YTvOdKP5guxpo4V
         RbCzpqc4k3ndor4ncIgmt2OMNZNIz5jG7Qxtc88Dz7fXKrrxo166uT3GxI1lgDfrr9sH
         IldIaHUzg6ws5fCXMBqYfFtUTSQJ6JNmGDe4Y2PSzRzwX+cQjCmQcucE2tZ34hSK69cr
         gF4nAW00MaHzBTqRn6HBlm8w/3Lys88ha7n3F1Fr4p2lP09/ijhmKw42m+FIeJgT/tkW
         0qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HXAfNrA46sN6xwJ1e0HKdG0mgjkrw0iVXvg38vFIU5U=;
        b=8NpCF1ybHNmrin6sqOWRO+5LZzi2TNvGUKUUay3Rjoi2Haa4aUz6Wqz5ERfG6KcNyY
         G56ygSdrde08ZUprC+byb2F4m/F1OQirMVldKMsvGfL+H9HMNBpY232Z7oalI89lflhK
         CjBiiTcrEbfItsFHeYM5KITp8dG9nMWDMAksA7ZqH/Gv/Smaj01k/O4PXej2Qhu7wg3L
         g53vq6M865832FyBRP7MiyaYb4SUjpHXDrX4lxEEZk8TD/PSFn9HsrII5bs/7QH1eBcJ
         Z0lr9j/nPg4jWenSurq3uxSOFqPURvmmr95sgvt67CHbGascoLfQ//Pk9m7s8/B/aRqL
         tG8g==
X-Gm-Message-State: AJIora+jMeC6X/K4t+HPf+8kU9MBJaNNOMT3IVKlFqI6mSIjKjG0mQV3
        w0flFtVNH1CzuWstwwjB34uhKg==
X-Google-Smtp-Source: AGRyM1sZILl4bct0Hm+NsnVWPHFcwfisoxfBQ7sScXuZcdjFt3QY2VEJm3IT6AhOFbuLCTRBfiKgMw==
X-Received: by 2002:a17:90b:380e:b0:1f2:5514:960c with SMTP id mq14-20020a17090b380e00b001f25514960cmr5826370pjb.14.1658944848598;
        Wed, 27 Jul 2022 11:00:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g12-20020a17090a290c00b001f3076970besm2044149pjd.26.2022.07.27.11.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 11:00:36 -0700 (PDT)
Date:   Wed, 27 Jul 2022 18:00:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86: add and use *_BIT constants for CR0,
 CR4, EFLAGS
Message-ID: <YuF9QA3v5lQLvDVM@google.com>
References: <20220726151232.92584-1-pbonzini@redhat.com>
 <YuAlHgkpBZS0QJ5e@google.com>
 <162240da-39c5-bed2-166c-58d34bcd4130@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162240da-39c5-bed2-166c-58d34bcd4130@redhat.com>
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

On Wed, Jul 27, 2022, Paolo Bonzini wrote:
> On 7/26/22 19:32, Sean Christopherson wrote:
> > On Tue, Jul 26, 2022, Paolo Bonzini wrote:
> > > The "BIT" macro cannot be used in top-level assembly statements
> > > (it can be used in functions through the "i" constraint).  To
> > > avoid having to hard-code EFLAGS.AC being bit 18, define the
> > > constants for CR0, CR4 and EFLAGS bits in terms of new macros
> > > for just the bit number.
> > > 
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > 
> > ...
> > 
> > > diff --git a/x86/smap.c b/x86/smap.c
> > > index 0994c29..3f63ee1 100644
> > > --- a/x86/smap.c
> > > +++ b/x86/smap.c
> > > @@ -39,7 +39,7 @@ asm ("pf_tss:\n"
> > >   #endif
> > >   	"add $"S", %"R "sp\n"
> > >   #ifdef __x86_64__
> > > -	"orl $" xstr(X86_EFLAGS_AC) ", 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
> > 
> > I don't understand, this compiles cleanly on both gcc and clang, and generates the
> > correct code.  What am I missing?
> 
> I saw a failure on older binutils where 1UL is not accepted by the
> assembler.

Mostly out of curiosity, how old?  I thought I was running some ancient crud in some
of my VMs, but even they play nice with this.

> An alternative is to have some kind of __ASSEMBLY__ symbol as in Linux.

I've no objection to this approach, but can you reword the changelog to call out
that it's only older binutils that's problematic?  I was truly confused by the
"cannot be used" blurb.

And a nit, add spaces around the shift (largely because they're needed around the
string), e.g.

  "orl $(1 << " xstr(X86_EFLAGS_AC_BIT) "), 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry

I'm indifferent about the lack of spaces for the existing multiplication, I just
found the shift a little hard to read.
