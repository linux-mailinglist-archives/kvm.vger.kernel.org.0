Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCB52578A
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359009AbiELWFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348898AbiELWFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:05:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB02802E1
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:05:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so9079385pju.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r4f4Qz7xX8gRZBfTk40SjTw373QQSQu10XV6WGcrATQ=;
        b=P/5NZTVtqOELXari+dFJFBDdMEidgOYlAeBAgRiya2oGPZGdLR07NHy/XtzkHUiMxG
         vLsrdGiLaIDQlNSosniZDsH5/CrNk2gkOyijCZtJ/Od4X+TZTYU8hd13FbKj1p0oNxHy
         ntzExQAgJv1x9pbcdehns34MSpO4PFMJfPN7Pd/v08nXlu/jGp7x++ryYpT7dUpmdFQ0
         DKAEIslfTQ/oBuDA2NWZ72rDXGAnjrsbpeZlRhACFqXIsI9Jk4/sENLyX6UQogk0SqZN
         r+MT4H3iRFPuwOEz/bkAiWtKJQH0Y9mRa2q7s2TGue0x90PCiRsXr1pCCdFYtsRaA38V
         f/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r4f4Qz7xX8gRZBfTk40SjTw373QQSQu10XV6WGcrATQ=;
        b=JWhghva9bB2u4OPyQ14RQL89mqtb/Hrx1PJYNSV97FX7xEX5KqlCreyfKNDzx0li0+
         oFM5yaky4EWsuye39/lxb3wysTbMc/MmjqTisRkdEWGzaD1T9Z79x7gZ0IVIt4e7c8wz
         2EBArh89wxIiUQ9Z2T5byY9BHcTr5XkGnCcX1YVQTRazmLjzmXjbCMPzbdntcuY7RtAB
         M29sBe9d4S2/qS3QWiJFqVGHx/siwUBqlIMmSLkKlCpgt9kmeFVqCbykpU15a+RdXrLx
         vmpbFcAD9VAsfHEAyFXBFZT+ocSK/0+EdQbKRtLbfjgl3DfcbocOD/RJGqN382b8t8wJ
         8lAQ==
X-Gm-Message-State: AOAM531JZEQimsSO8adyOk+HQ6apZ0l42fzr7OVKdjAzmKjhWQ0/MjYG
        Ig9+iQg0OdRurAEZF52yZ7ZfIRBTq4F67g==
X-Google-Smtp-Source: ABdhPJzqeF/if9LP6yi22NFH7hZXG1e3pVolv5AAdrIUqsaFM/UZGySRXkrJXn67yMp/8u4xv38+KA==
X-Received: by 2002:a17:90b:1c0e:b0:1dc:45b6:6392 with SMTP id oc14-20020a17090b1c0e00b001dc45b66392mr1555378pjb.236.1652393136636;
        Thu, 12 May 2022 15:05:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b24-20020a6567d8000000b003c14af50643sm174909pgs.91.2022.05.12.15.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 15:05:36 -0700 (PDT)
Date:   Thu, 12 May 2022 22:05:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] kvm-unit-tests: Build changes for illumos.
Message-ID: <Yn2ErGvi4XKJuQjI@google.com>
References: <20220512204459.2692060-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512204459.2692060-1-cross@oxidecomputer.com>
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

On Thu, May 12, 2022, Dan Cross wrote:
> We have begun using kvm-unit-tests to test Bhyve under
> illumos.  We started by cross-compiling the tests on Linux
> and transfering the binary artifacts to illumos machines,
> but it proved more convenient to build them directly on
> illumos.
> 
> This change modifies the build infrastructure to allow
> building on illumos; I have also tested it on Linux.  The
> required changes were pretty minimal: the most invasive
> was switching from using the C compiler as a linker driver
> to simply invoking the linker directly in two places.
> This allows us to easily use gold instead of the Solaris
> linker.

Can you please split this into two patches?  One for the $(CC) => $(LD) change,
and one for the getopt thing.  The switch to $(LD) in particular could be valuable
irrespective of using a non-Linux OS.

> Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> ---
>  configure           | 5 +++--
>  x86/Makefile.common | 6 +++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
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

Presumably whatever "enhanced" features are being used are supported by illumos,
so rather than check the OS, why not improve the probing?

>      echo "Enhanced getopt is not available, add it to your PATH?"
>      exit 1
>  fi
