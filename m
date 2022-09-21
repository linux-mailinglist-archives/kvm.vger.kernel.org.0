Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CE5C6413
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiIURzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIURzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:55:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2082357573
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:55:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so15109730pjm.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6zseYLWfMQl699NSYlSkulwSYga25k2VOd8kmGGDZqA=;
        b=HF1GO28QnOsgPyjvlZwBtrm8nRj4a37NZoVS5Xs0nafeLYz+REY6KzOMOqDMAc6b80
         dG6jVcE6eQEy5LLzzS2cWLwJkcassxeNo4cZPl5DUBJOj/T0/NtYkygSddZwMxt+ZYlT
         POUtRHieTNX1aRGfes8sNIWUztwqlANp9phuRT/KPG+LfmT4VFuPHLToJtlx8W5Dr3m6
         cAFui5GQyLeZf2ewtNQLjaBQBmSFgn+lQamAp2KtpFI0x0Tr50LCAgL839BhOcMb1Rs3
         1ttPdFRElrOpKnKxF05T/ZsA4xD/4kfEIlCq7eqiTQbFx/mDTMwrbOF2TxB25WQcjwRL
         X02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6zseYLWfMQl699NSYlSkulwSYga25k2VOd8kmGGDZqA=;
        b=CrYptpF4sFHU+1bSaS3ZQrOAN1EI/tu/5zs81hgtBWr7IaGNwhnn8xm1+jNRA7qrH3
         HV8WVPXXEj61V092CYc/zOY+136/URENWujtxfbTvFX4cjERGelJqfIaOu2QuHoOq6O9
         2RZefkf6FW9A/2GNh7kK+E28uclwOP3fMBjjCTe+4SYgKdr+a1zsLruXQ+tDt3lEeFKW
         hhEqi5iIJ5ztE9nXJZr9HY3j4O+JedGaCqZXxr2j4JvlHzFoTlweeT2kB6tlBNubx5JG
         TOIkCyFJGAvLxqBYa5gL8PufX7Lrk8eKxHruizgpfOZr2SICwNVJITjq7H3u5cCnpvw7
         Kc0Q==
X-Gm-Message-State: ACrzQf3gRv1G1jqj3b3dbwjfy3ZSyP1nE7D2SWFP8yiqzQ5I2Vr2I/V2
        AozVLbxnsGosr/3r1sJFmrkSmw==
X-Google-Smtp-Source: AMsMyM7JRMOlfWKYd/bO5/MnMIvgz5EQcEWb9H8mLgiVoQ7Y7kgRGUJn9FoE0EMYZb98seiF60t5vw==
X-Received: by 2002:a17:90a:e7c5:b0:200:ab1a:f32 with SMTP id kb5-20020a17090ae7c500b00200ab1a0f32mr10602649pjb.100.1663782918084;
        Wed, 21 Sep 2022 10:55:18 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l25-20020a635b59000000b0043395af24f6sm2221034pgm.25.2022.09.21.10.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:55:17 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:55:13 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: selftests: Explicitly set variables based on
 options in dirty_log_perf_test
Message-ID: <YytQAbu+uWOZChsT@google.com>
References: <20220826184500.1940077-1-vipinsh@google.com>
 <20220826184500.1940077-2-vipinsh@google.com>
 <CAHVum0e0piX9zS6BuqzzeCu1M=2fdOjdov18aA-AEOm=+bd2mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0e0piX9zS6BuqzzeCu1M=2fdOjdov18aA-AEOm=+bd2mg@mail.gmail.com>
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

On Fri, Aug 26, 2022 at 02:12:49PM -0700, Vipin Sharma wrote:
> On Fri, Aug 26, 2022 at 11:45 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > Variable set via -g are also indirectly set by -e option by omitting
> > break statement. Set them explicitly so that movement of switch-case
> > statements does not unintentionally break features.
> >
> > No functional change intended.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_perf_test.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index f99e39a672d3..a03db7f9f4c0 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -411,6 +411,8 @@ int main(int argc, char *argv[])
> >                 case 'e':
> >                         /* 'e' is for evil. */
> >                         run_vcpus_while_disabling_dirty_logging = true;
> > +                       dirty_log_manual_caps = 0;
> > +                       break;
> 
> @Sean, I hope you intentionally didn't write a break between -e and -g
> when you created the patch and it is not just a missed thing :)

I'm pretty sure the missing break here is by accident. If it was on
purpose I would expect Sean (especially) to have called it out the
subtle change in the commit message and probably add a comment here.
Also I can't think of any reason why
run_vcpus_while_disabling_dirty_logging=true would require
dirty_log_manual_caps=0.

Can you change this patch to just add a break and add a fixes tag to the
commit message?

Fixes: cfe12e64b065 ("KVM: selftests: Add an option to run vCPUs while disabling dirty logging")


> 
> 
> >                 case 'g':
> >                         dirty_log_manual_caps = 0;
> >                         break;
> > --
> > 2.37.2.672.g94769d06f0-goog
> >
