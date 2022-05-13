Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180855264F7
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356999AbiEMOnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 10:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382136AbiEMOmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 10:42:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDF822EA4C
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 07:35:02 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q18so8095941pln.12
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 07:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MvsvqfjQTJodFpEYql1m1Q9HWzmmYLUmdxcXEn4EqlA=;
        b=foBC2puCtR85Z2LHtOOKo+rff0b3pJluNHmHcciAwowvGpNE5L8Wz70b3yyYMfhL8H
         nkOdsvDMtejJiKRlDb8ChggNLuZH2PuV/jNc85v+v6cNgaWPYoBh2FJWqNGb6kNslzeR
         RBxqrIkaotI9p9tkXcWaGkinp828tPjJtnpsZqJXj7m/rfta7pNLbHuevd8xNUW5/rYM
         OLqr2iSRhzLm1J0FA3P1H3V16zcNz3OEyhDfPVn2CCHLUo02UWfVgVzXl/RjlWV/7+55
         wjUXcJPPnr3ScoXaBgz54HMGJeIGyIFnYNGH3b8oXskewIxGAxUvOgTOo75GBd9u09ZL
         vgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MvsvqfjQTJodFpEYql1m1Q9HWzmmYLUmdxcXEn4EqlA=;
        b=olk6hnzL6Iosc5wDZ3gBco1wuXqnUB45YzMtQoI62LXkGVgqXOZD1gYckAwnO717EE
         a0ul+T3h+0NZEYDRwDik55bwDI7e8ndxdJ/DTAWUs2hfhY9jtSA6U2A18nfckswaSFyV
         Y+pRitwRx1zDe8kXgZhaiBqLaLsiPEAle90Ek5S92syxBy4QgcNtZGNsVy3ZpauMrvnL
         gAeWmeABSH03Ml46yksJVWzYwvEBe0eAIJj4uv+U/p/+wW2DRNAGADpjzFPOjErp4Q7Q
         AMbr4zEBb7IGJXVu2atujMrxJ1l78uB7dl1tZXesmtxUGglsvTwZ7tiHk6vH6xJKNrXf
         fSeA==
X-Gm-Message-State: AOAM530Fdua8EY0QZtfnuqaDwoKb5ugA2SrqhNzTQfLFqDRdOl1JEbNT
        Y9+891r5W6r5RyCJKJdJk/bMVg==
X-Google-Smtp-Source: ABdhPJyN5omltk7Q0f27pLHFxY+zPxAW3Yvoy5skUIdb8VSodqdRfmS4V/cjvDor28TYrfZti8gCdQ==
X-Received: by 2002:a17:90a:e7cb:b0:1dc:6602:7178 with SMTP id kb11-20020a17090ae7cb00b001dc66027178mr16457403pjb.175.1652452501799;
        Fri, 13 May 2022 07:35:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i1-20020a6561a1000000b003c14af5063fsm1680563pgv.87.2022.05.13.07.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 07:35:01 -0700 (PDT)
Date:   Fri, 13 May 2022 14:34:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Message-ID: <Yn5skgiL8SenOHWy@google.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513010740.8544-3-cross@oxidecomputer.com>
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

Adding the official KUT maintainers, they undoubtedly know more about the getopt
stuff than me.

On Fri, May 13, 2022, Dan Cross wrote:
> This change modifies the `configure` script to run under illumos

Nit, use imperative mood.  KUT follows the kernel's rules/guidelines for the most
part.  From Linux's Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.


E.g.

  Exempt illumos, which reports itself as SunOS, from the `getopt -T` check
  for enhanced getopt.   blah blah blah... 

> by not probing for, `getopt -T` (illumos `getopt` supports the
> required functionality, but exits with a different return status
> when invoked with `-T`).
> 
> Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> ---
>  configure | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/configure b/configure
> index 86c3095..7193811 100755
> --- a/configure
> +++ b/configure
> @@ -15,6 +15,7 @@ objdump=objdump
>  ar=ar
>  addr2line=addr2line
>  arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +os=$(uname -s)
>  host=$arch
>  cross_prefix=
>  endian=""
> @@ -317,9 +318,9 @@ EOF
>    rm -f lib-test.{o,S}
>  fi
>  
> -# require enhanced getopt
> +# require enhanced getopt everywhere except illumos
>  getopt -T > /dev/null
> -if [ $? -ne 4 ]; then
> +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then

What does illumos return for `getopt -T`?  Unless it's a direct collision with
the "old" getopt, why not check for illumos' return?  The SunOS check could be
kept (or not).  E.g. IMO this is much more self-documenting (though does $? get
clobbered by the check?  I'm terrible at shell scripts...).

if [ $? -ne 4 ] && [ "$os" != "SunOS" || $? -ne 666 ]; then

  Test if your getopt(1) is this enhanced version or an old version. This
  generates no output, and sets the error status to 4. Other implementations of
  getopt(1), and this version if the environment variable GETOPT_COMPATIBLE is
  set, will return '--' and error status 0.

>      echo "Enhanced getopt is not available, add it to your PATH?"
>      exit 1
>  fi
> -- 
> 2.31.1
> 
