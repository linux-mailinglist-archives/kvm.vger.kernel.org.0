Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A85FBA91
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJKSkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJKSj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:39:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BB2F3B4
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:39:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so14031539pjo.4
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea9qZNFwtOKDQuiP1cJBVQfsviCBPySbujLQPkw4M74=;
        b=lOF46sEelHHvZU/GJZ0rus+VozS3K4qZ7SAhsSeDQ5JpwPrypGYgmRopfnK9nUNw9V
         iK6FwhdcGb0oLdvakg7e5WJLXo0LN9Y2zZTsjD60z0HdhhI6Uw/Y+lWxew/v7XdCzqqq
         WWYDf4tuxP6lg02qVPh9Qnw5jyOLweb1/vmc1b1t1VJbs4GqSurE9/Yhv6QymxPr68Pr
         rweByVK/komUnZk6O/acPHdleJ56AIlkzAPRC59y8efyAcfUSPThX0rNDtHeZP636T3w
         xKyTEMz5RcI/S7FLrNW6Hl23OO8LiwYY4zoSoKxhLpyFNX8zinCuQ6upVoAb2xlGKsXb
         JfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea9qZNFwtOKDQuiP1cJBVQfsviCBPySbujLQPkw4M74=;
        b=o9FRKvA+QObSmw6ETpcEhK2nZcwLQ9TQ/5LQQSXbo3hiuXZpCoIZhl0SQhydchW+hn
         oIOrWaw47U6fbsheZ1QIWgwfnnWh07j4sGljEQUYfAsI+FbdhfKUvbRFcaetqbveY3t5
         us83N2w1l+mi+RsXknap4QI2dqDF06y/tL9hYkNDq/raXkYshpLZQWx22nnokBIbeT1r
         fnqXlfhw7Ad9jN8SOZtmigyPQ4bKOPoR9E6d5suNwOHiLmPYT3c81yNnOUwMh3jfov4O
         VCAhtMzptZkOsJB1+mMQPvk0XBE08l1gkK8wu8VLLQC/DSEF2aEcXND5JxGyvuy9t4ig
         adUQ==
X-Gm-Message-State: ACrzQf0bwKSiAggx1fg6hV7/dZgNmh979wwD0SbHUoyx8z6noNh6emkO
        exBjAAD2ypphR8xwHvn790fUvA==
X-Google-Smtp-Source: AMsMyM4DPLtReLLwyfmWXXagv6pxil1JnMHJ2faFvaF0g7U82tCFxow4TYHKRJHWr31Z4GHygH/INQ==
X-Received: by 2002:a17:902:ce0d:b0:178:bd1e:e8da with SMTP id k13-20020a170902ce0d00b00178bd1ee8damr25971346plg.103.1665513592849;
        Tue, 11 Oct 2022 11:39:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y66-20020a626445000000b00562f431f3d2sm7189028pfb.83.2022.10.11.11.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 11:39:52 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:39:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0W4dImhloev7Iaq@google.com>
References: <Y0CO+5m8hJyok/oG@google.com>
 <gsntfsfu2pt1.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntfsfu2pt1.fsf@coltonlewis-kvm.c.googlers.com>
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

On Tue, Oct 11, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Sep 12, 2022, Colton Lewis wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/test_util.h
> > > b/tools/testing/selftests/kvm/include/test_util.h
> > > index 99e0dcdc923f..2dd286bcf46f 100644
> > > --- a/tools/testing/selftests/kvm/include/test_util.h
> > > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t
> > > size)
> > >   	return (void *)align_up((unsigned long)x, size);
> > >   }
> 
> > > +void guest_random(uint32_t *seed);
> 
> > This is a weird and unintuitive API.  The in/out param exposes the gory
> > details of the pseudo-RNG to the caller, and makes it cumbersome to use,
> > e.g. to create a 64-bit number or to consume the result in a conditional.
> 
> To explain my reasoning:
> 
> It's simple because there is exactly one way to use it and it's short so
> anyone can understand how the function works at a glance. It's similar
> to the API used by other thread-safe RNGs like rand_r and random_r. They
> also use in/out parameters. That's the only way to buy thread
> safety. Callers would also have to manage their own state in your
> example with an in/out parameter if they want thread safety.
> 
> I disagree the details are gory. You put in a number and get a new
> number.

Regardless of whether or not the details are gory, having to be aware of those
details unnecessarily impedes understanding the code.  The vast, vast majority of
folks that read this code won't care about how PRNGs work.  Even if the reader is
familiar with PRNGs, those details aren't at all relevant to understanding what
the guest code does.  The reader only needs to know "oh, this is randomizing the
address".  How the randomization works is completely irrelevant for that level of
understanding.

> It's common knowledge PRNGs work this way.

For people that are familiar with PRNGs, yes, but there will undoubtedly be people
that read this code and have practically zero experience with PRNGs.

> I understand you are thinking about ease of future extensions, but this
> strikes me as premature abstraction. Additional APIs can always be added
> later for the fancy stuff without modifying the callers that don't need it.
> 
> I agree returning the value could make it easier to use as part of
> expressions, but is it that important?

Yes, because in pretty much every use case, the random number is going to be
immediately consumed.  Readability and robustness aside, returning the value cuts
the amount of code need to generate and consume a random number in half.

> > It's also not inherently guest-specific, or even KVM specific.  We
> > should consider
> > landing this in common selftests code so that others can use it and even
> > expand on
> > it.  E.g. in a previous life, I worked with a tool that implemented all
> > sorts of
> > random number magic that provided APIs to get random bools with 1->99
> > probabilty,
> > random numbers along Guassian curves, bounded numbers, etc.
> 
> 
> People who need random numbers outside the guest should use stdlib.h. No
> need to reimplement a full random library. The point of this
> implementation was to do the simplest thing that could provide random
> numbers to the guest.

Ah, right.
