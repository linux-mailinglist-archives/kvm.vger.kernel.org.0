Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C187BE886
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377493AbjJIRnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 13:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377427AbjJIRnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 13:43:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D59494
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 10:43:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d86766bba9fso6605888276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 10:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696873425; x=1697478225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ymQW1hU5KSRzFFrnXvWvbt7y6O9V4+IynB4heEg3lo=;
        b=e9VunNJlgalq31091voI+9oLPQ6aeyVlsfYRpvltQmNxqyA6WMoua2LcAxcuqnes9t
         lQjt5DKhdX2RIwQgliibtLT3yhwEMS5DJxaHbm8K+b8/MElEF+5jccSrdysOZ7WOgl65
         K43rOPhzTfC1xK1oTKz8tKZi9Wfo2ouIxUlzNURx6fsGb57LYX/N0St7xJYwBJFLCV6V
         VaE5CNdW9nHRpvN8v0NhKvc9Cq7oTE/869jVFwpwHYt0Loh/VT+4pNAxzz4BMkm/HYS9
         CpCqPs8LiR9XxCDqaUkkeTIhdnl9g6nabnQ6JCUy4/x0GCyhjoFfCNJPu/+DkEcYr8Ba
         thhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696873425; x=1697478225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ymQW1hU5KSRzFFrnXvWvbt7y6O9V4+IynB4heEg3lo=;
        b=nyfcRvgfKvZfHEnH8TNzCfo+vAfukDnCd5aJDQ3KspsiOnxo0ojGUaw2mXPC1drHgP
         FaLf79FzqTm2OJT8UN7h1ztYKmXa1PzVURDgF3yPDj4IF6s242yImKQok9yxammmg3eQ
         ax2oc5BJ5/wRf9+5YXpzFkU07a0fXYSQb7nVOwIJvHv/TvqJ4IAqCcpHt83D2vu60xRL
         GVdzKMDQU+g7RDp7LaGMvydHu6HkC+1swR6pXv1+gmodfczKCEjCsyaQVaYBypyxM0sg
         PZ9z8EkQipiME09cj8TTo6c/l7/9vncUYzHtwONx41UYCyJf/lHttUDL4/yZPM3RJRnU
         k71g==
X-Gm-Message-State: AOJu0YxcLDATeIUSQCzz2zZgALVdkMHzCHgofrDrm/QpMgfGJnmGIrs/
        6WS8Jjn8ThJNF1GlZ06YzW0XQGk8o8I=
X-Google-Smtp-Source: AGHT+IGEmaOt2mh4KqFW8J8GXYKlV0xk6lT0+epcV6SYF2UB9CpR6D/6Os1YBzFC4/6x25fxaRK99HgOCUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4197:0:b0:d78:f45:d7bd with SMTP id
 o145-20020a254197000000b00d780f45d7bdmr254742yba.4.1696873425494; Mon, 09 Oct
 2023 10:43:45 -0700 (PDT)
Date:   Mon, 9 Oct 2023 10:43:43 -0700
In-Reply-To: <20231006205415.3501535-1-kuba@kernel.org>
Mime-Version: 1.0
References: <20231006205415.3501535-1-kuba@kernel.org>
Message-ID: <ZSQ7z8gqIemJQXI6@google.com>
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
From:   Sean Christopherson <seanjc@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 06, 2023, Jakub Kicinski wrote:
> Setting WERROR for random subsystems make life really hard
> for subsystems which want to build-test their stuff with W=1.
> WERROR for the entire kernel now exists and can be used
> instead. W=1 people probably know how to deal with the global
> W=1 already, tracking all per-subsystem WERRORs is too much...

I assume s/W=1/WERROR=y in this line?

> Link: https://lore.kernel.org/all/0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/process/maintainer-kvm-x86.rst |  2 +-
>  arch/x86/kvm/Kconfig                         | 14 --------------
>  arch/x86/kvm/Makefile                        |  1 -
>  3 files changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
> index 9183bd449762..cd70c0351108 100644
> --- a/Documentation/process/maintainer-kvm-x86.rst
> +++ b/Documentation/process/maintainer-kvm-x86.rst
> @@ -243,7 +243,7 @@ context and disambiguate the reference.
>  Testing
>  -------
>  At a bare minimum, *all* patches in a series must build cleanly for KVM_INTEL=m
> -KVM_AMD=m, and KVM_WERROR=y.  Building every possible combination of Kconfigs
> +KVM_AMD=m, and WERROR=y.  Building every possible combination of Kconfigs
>  isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOCKING, and
>  X86_64 are particularly interesting knobs to turn.
>  
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ed90f148140d..12929324ac3e 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -63,20 +63,6 @@ config KVM
>  
>  	  If unsure, say N.
>  
> -config KVM_WERROR
> -	bool "Compile KVM with -Werror"
> -	# KASAN may cause the build to fail due to larger frames
> -	default y if X86_64 && !KASAN

Hrm, I am loath to give up KVM's targeted -Werror as it allows for more aggresive
enabling, e.g. enabling CONFIG_WERROR for i386 builds with other defaults doesn't
work because of CONFIG_FRAME_WARN=1024.  That in turns means making WERROR=y a
requirement in maintainer-kvm-x86.rst is likely unreasonable.

And arguably KVM_WERROR is doing its job by flagging the linked W=1 error.  The
problem there lies more in my build testing, which I'll go fix by adding a W=1
configuration or three.  As the changelog notes, I highly doubt W=1 builds work
with WERROR, whereas keeping KVM x86 warning-free even with W=1 is feasible.

> -	# We use the dependency on !COMPILE_TEST to not be enabled
> -	# blindly in allmodconfig or allyesconfig configurations
> -	depends on KVM
> -	depends on (X86_64 && !KASAN) || !COMPILE_TEST

On a related topic, this is comically stale as WERROR is on by default for both
allmodconfig and allyesconfig, which work because they trigger 64-bit builds.
And KASAN on x86 is 64-bit only.

Rather than yank out KVM_WERROR entirely, what if we make default=n and trim the
depends down to "KVM && EXPERT && !KASAN"?  E.g.

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8452ed0228cb..c2466304aa6a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -65,13 +65,12 @@ config KVM
 
 config KVM_WERROR
        bool "Compile KVM with -Werror"
-       # KASAN may cause the build to fail due to larger frames
-       default y if X86_64 && !KASAN
-       # We use the dependency on !COMPILE_TEST to not be enabled
-       # blindly in allmodconfig or allyesconfig configurations
-       depends on KVM
-       depends on (X86_64 && !KASAN) || !COMPILE_TEST
-       depends on EXPERT
+       # Disallow KVM's -Werror if KASAN=y, e.g. to guard against randomized
+       # configs from selecting KVM_WERROR=y.  KASAN builds generates warnings
+       # for the default FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires
+       # special tuning.  Building KVM with -Werror and KASAN is still doable
+       * via enabling the kernel-wide WERROR=y.
+       depends on KVM && EXPERT && !KASAN
        help
          Add -Werror to the build flags for KVM.
