Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBC56D4EA6
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjDCRJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 13:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjDCRJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 13:09:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AA32D44
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 10:09:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso29244101ybi.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 10:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680541761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=shJmjgs7yW7SKigD/CMBzE7xyt1W4x0eK4szCIOZ3e8=;
        b=IqMu1LVme6JpD0PbqBKuY26AjQLRZuC+FxnAFXGaTOl+ZUKsLfiEnZ/Usr0qOcNIau
         9vwSkAsz/BFdoSI5Xuu0v2xpTpd/Km/pbjjejH0NnpaGhMQwcKKIiYClb1FpJSi4NkM5
         fCNPKhvqeaAG8ngNXYVOj6QQPBX8G2XNN83i+pmVG8UrVtVFKnn8P+TcR6BgPGbeC3Dc
         pAw+V9c0pQzXs9E7raCCHvyAI7Iq/2vUYRhfUCZz1u3xdSJa9CrSAdDC6whCp90xLjfc
         6EEPFcdwHMrCUbwEPDiRKsKTDj4LTe8DYWR+JS1/RzHcK7a2uOxpgUTLNr6gfsDdLb8b
         wWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680541761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shJmjgs7yW7SKigD/CMBzE7xyt1W4x0eK4szCIOZ3e8=;
        b=Tmyi2qCBdWCCs4jkR2/Kd27rEKSfE5TLCGB/JNqTceIdPYsiJ7t1ncD/owOFZqHlM2
         5xI1fXV2QmwwzNeHJqLa0NO480c1ATFNpc96DMSZh9AWz8Viz7joS/LtDhttWnqpCJlw
         /4PbVnKwEXK/u6OvbWCAxNGu94MGKIEfhynSuqcsLCNh4C1Gw5xrgfLY5/Vqh0Vr5MWv
         oBu2B7PjInTlXUUOXT5gbvoaeenGaoKQoTgCJE1Q04s3JYCPzqDfT6U1pyyUWGC24zk5
         AJM2sWbrHR2zCN7jRXrEF8u2MuiX4Zn+aXK+wh7IwbjJhedl5IPo0+iRAoBKVNhHES5x
         f2hQ==
X-Gm-Message-State: AAQBX9dDI3o/7+MZmZrqqDDjyCP6IS2OZp3hguARekzSgd1XNyiHRcDR
        ZZXWl97PFR5ceUGi9kjhun+oXYmlD9s=
X-Google-Smtp-Source: AKy350bzaH36BYgQI4MudTK+12v25OOFOhENFk+mtv93aHhWOyABHtvXJMgUPTQYgCO/n8+rdjkeYLkXOJA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:70a:b0:b6e:361a:c86 with SMTP id
 k10-20020a056902070a00b00b6e361a0c86mr19553906ybt.3.1680541761599; Mon, 03
 Apr 2023 10:09:21 -0700 (PDT)
Date:   Mon, 3 Apr 2023 10:09:20 -0700
In-Reply-To: <3255e2f7-432c-32a7-9e28-0752516a5377@grsecurity.net>
Mime-Version: 1.0
References: <20230331135709.132713-1-minipli@grsecurity.net>
 <20230331135709.132713-3-minipli@grsecurity.net> <ZCcIYMYeDpE8nYm/@google.com>
 <3255e2f7-432c-32a7-9e28-0752516a5377@grsecurity.net>
Message-ID: <ZCsIQHls8u4Kqn3d@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86/access: CR0.WP toggling write
 to r/o data test
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
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

On Mon, Apr 03, 2023, Mathias Krause wrote:
> On 31.03.23 18:20, Sean Christopherson wrote:
> > On Fri, Mar 31, 2023, Mathias Krause wrote:
> >> +	 * the access test and toggle EFER.NX to flush and rebuild the current
> >> +	 * MMU context based on that value.
> >> +	 */
> >> +
> >> +	set_cr0_wp(1);
> >> +	set_efer_nx(1);
> >> +	set_efer_nx(0);
> > 
> > Rather than copy+paste and end up with a superfluous for-loop, through the guts
> > of the test into a separate inner function, e.g.
> > 
> >   static int __check_toggle_cr0_wp(ac_test_t *at, bool cr0_wp_initially_set)
> > 
> > and then use @cr0_wp_initially_set to set/clear AC_CPU_CR0_WP_MASK.  And for the
> > printf(), check "at.flags & AC_CPU_CR0_WP_MASK" to determine whether the access
> > was expected to fault or succeed.  That should make it easy to test all the
> > combinations.
> 
> Well, I thought of a helper function too and folding the value of CR0.WP
> into the error message. But looking at other tests I got the impression,
> it's more important to make the test conditions more obvious than it is
> to write compact code. 

LOL, you're looking for reasoning/logic where there is none.  The sad truth is
that the vast majority of tests were "written" by copy+paste+tweak.

> This not only makes it easier to see what gets tested but also shows what the
> test was intended to do. If, instead, the error message is based on the value
> of AC_CPU_CR0_WP_MASK, one not only has to check what value it was set to but
> also look up what its meaning really is, like if set, does it mean CR0.WP=0
> or 1?

I generally agree with having self-documenting code and/or assertions, but that
only works to a certain point in tests, especially for tests that are verifying
architectural behavior.  Oftentimes I know what KUT code is doing, but it takes
far too much digging to understand what is actually expected to happen and why.
The architectural behavior cases are especially problematic because there are so
many details that aren't really captured in the test itself.

IMO, given how KUT is structured and what it is testing, documenting the exact
testscase is the role of the error message.  E.g. if the error message explicitly
states the test case, then it documents the code _and_ provides a helpful message
to allow users to quickly triage failures.  Of course, the vast majority of error
messages in KUT are awful IMO, and are a constant source of frustration, but one
can dream :-)
