Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F14C5FDE0E
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJMQQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 12:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJMQQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 12:16:24 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E01CC800
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 09:16:23 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j7so2610313ybb.8
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qOz5gqcnlHDEZkXiVErZxdx4YYXVd9tq2kjrtldkenA=;
        b=EKDYOGFANVfMhQEliXeDmCFrRIcpdu777quurbSRfzR0i87LBqQedN0nRP27GM3tHV
         ldkaEasamworGZbdWgEy4zrQa5XRVxDkj8m+ZiZjAblfbn2eMAtmTl1Ivcx+nTfd+Wh6
         GPbucSQL/OeHlLu0at9AvgNmMwDBUqviZeDyunQFuu4WBxokfEyZOn3fF3k7nSN0ssuY
         uvHeswkkxBqHbPVUGXzxu80EHHSYHFTzWYFAeAtIW+qFP5hVZ0XV03fOQI9Y/5sFoNgN
         nkjuIYpaTjipcMoSGUIf/vNmQz4buFcMsf2+p7Vqv2Wz0btumE5kWXcnADc2nGs2pBz4
         jT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOz5gqcnlHDEZkXiVErZxdx4YYXVd9tq2kjrtldkenA=;
        b=vcWUSilDQ3dkxffsVmmodeIxW1YbnpGuq6euNFE4S+YFtz7vK3F5pnA9bXEldP2ExM
         2RQvq4O0aPyklkExwce/jZgkWDGFj5bT4lEVP4yaX+Qe47jNvan1svKcIM5bp2Rd9UKS
         Hfx4Mml6glzzJ2AIbK9LCOwpoyjrXjT2TG61dPkbcl2dfxxCebJXnv19Lj+ENUgBqDe3
         vTS4s5schJ22NJlS4GLu8OYV7jv9kIVaDM/zTwmmy/zFoGP03RfKuljTO4Y2m300TxIa
         XnXFfV66x05FwBjPLTKdSDseW6nZvHk79sp0mapMC6VENj5dJ5NV+uS+V3wKhxt+NXr9
         FZQQ==
X-Gm-Message-State: ACrzQf2uJMOtHi9OfA2/ZOxkA9hX9e4FRpqYwvvLUANvEOoAE+/MG5fo
        q7ti/sqjKOiJ5BfR2VKpia58bQSoYYzTbQ9Gznhw9A==
X-Google-Smtp-Source: AMsMyM6UOyePpvRJzw80oQCJEYpH2I+A4Les6+OKGV/UwI7KTgOU3/Xrq/NNweV+l80PO1gjalqCUJXtZ+9qLH7hhZ8=
X-Received: by 2002:a25:264a:0:b0:6c0:3e00:f5b0 with SMTP id
 m71-20020a25264a000000b006c03e00f5b0mr694489ybm.305.1665677782432; Thu, 13
 Oct 2022 09:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221012165729.3505266-1-dmatlack@google.com> <20221012165729.3505266-2-dmatlack@google.com>
 <Y0cTuKbeWoGSXPFT@google.com>
In-Reply-To: <Y0cTuKbeWoGSXPFT@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Oct 2022 09:15:55 -0700
Message-ID: <CALzav=dZFgpMe0hm0DsWG2orGkP2NW8ET21LByuSGXPkHnu0jw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Oct 12, 2022 at 12:21 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Oct 12, 2022, David Matlack wrote:
> > Rename the perf_test_util.[ch] files to memstress.[ch]. Symbols are
> > renamed in the following commit to reduce the amount of churn here in
>
> Heh, "following commit" is now stale.  This is why I encourage using ambiguous
> phrases, e.g. "in a future commit".
>
> This should also be phrased as a command, not a statement of truth.  E.g. in the
> extremely unlikely scenario that symbols are never renamed, this statement is
> wrong, whereas something like
>
>   Defer renaming symbols to a future patch to reduce the amount of churn
>   here in the hopes of playing nice with git's file rename detection.
>
> states only what is done in the context of this patch while still calling out
> that the intent is to rename symbols in the (near) future.
>
> To be 100% clear, I'm not saying don't describe future changes, there's a _lot_
> of value in knowing that a patch is prep work for the future.  I'm saying don't
> explicitly predict the future, because occassionally the prediction will be wrong
> and the changelog ends up confusing archaeologists.

That makes a lot of sense -- will do in the future. Thanks!

>
> > hopes of playiing nice with git's file rename detection.
>
> s/playiing/playing
>
> > The name "memstress" was chosen to better describe the functionality
> > proveded by this library, which is to create and run a VM that
> > reads/writes to guest memory on all vCPUs in parallel.
> >
> > "memstress" also contains the same number of chracters as "perf_test",
> > making it a drop-in replacement in symbols, e.g. function names, without
> > impacting line lengths. Also the lack of underscore between "mem" and
> > "stress" makes it clear "memstress" is a noun.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Changelog nits aside,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
