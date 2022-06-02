Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3463353C077
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbiFBVqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 17:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbiFBVql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 17:46:41 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A452529A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 14:46:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w21so5840442pfc.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 14:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ePTRBE1BvhIb45RUSl2ATDxdJqmchZJiZllON40higE=;
        b=XmE9FcxJlmzuFIv8/Du74fyZ9R62PetVsApQztTjiaMVanvUB+k4bxZ9+9x0/e2PYK
         kUI++1RdGZCOtj9M9DSaijoyyYY9yoRiyOC83UIHRAj2xetPcKEinp9ZI5k+uGw4PEvs
         L2S7Nzua0edMVDEf3KSEmoQRHzp5i+L8i8ORUyKMdal12qrz/e9v+s3vdeBlBYeRhsun
         YwCwkH0VvKKLAT1eUVUkjbkCbbxZjLqGSiaVC+Fb52DNXM6swhuNBZ+mVJmNiO2GzFwa
         Mmin3BQDqh0LD2NBp/6PkYh5tOkE4RP6FXrZM1qEyYsL4J/0lfs6bIHiJwZDgG2i8BBx
         r9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ePTRBE1BvhIb45RUSl2ATDxdJqmchZJiZllON40higE=;
        b=J6Cqkd34hnv8hkBO0yTPNhlO/ZveMkeV7Bl3+CKkbjRfM3MdfQ3cXB1YGARwp4qzlQ
         0qpYVivbGQqqaSTv7zp4sddelAsd7px8Leq981HlUBAnakNQB17BK1Z6LX+qPKucexqv
         Pz8PMP9DxlqBn4SNeA0lpe79itWIzTdP1Xqh4yvG7gJl31C2xfeS11Q6wVh6nmwhQ3NQ
         GCFWb6Gm2wLblecP6AiYN8mXNVZUHjZAWszYiX+ykqj8pSBMe84IyAywwduo6pdB3LaR
         wMwMgzryc3kOMhb2/CH73BkIkuF8tdnJcPTY/2/P2Hrwl0Mp/d0YCz6omkKvIKLctej9
         dMmQ==
X-Gm-Message-State: AOAM533QuW0PqNFVQU4y60kumbIB508LaV1xhA2pgJVVWXtt16hl4c6j
        fcEScsL5M0eFVGq3Lje4H+PuKA==
X-Google-Smtp-Source: ABdhPJz+HwxEZ6v1PLqbBtd0v+aIXIuY0fsOeRKxJQq9IQMlMa0qK+URsujwxcMY0S2Y1LOF313nfA==
X-Received: by 2002:a63:9308:0:b0:3f2:6aa3:59f7 with SMTP id b8-20020a639308000000b003f26aa359f7mr5985074pge.386.1654206399935;
        Thu, 02 Jun 2022 14:46:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a1709027e0500b0016353696f46sm4016124plm.269.2022.06.02.14.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 14:46:39 -0700 (PDT)
Date:   Thu, 2 Jun 2022 21:46:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     mike tancsa <mike@sentex.net>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>
Subject: Re: Guest migration between different Ryzen CPU generations
Message-ID: <Ypkvu6l5sxyuP6iM@google.com>
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <20220602144200.1228b7bb@redhat.com>
 <489ddcdf-e38f-ea51-6f90-8c17358da61d@sentex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <489ddcdf-e38f-ea51-6f90-8c17358da61d@sentex.net>
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

On Thu, Jun 02, 2022, mike tancsa wrote:
> On 6/2/2022 8:42 AM, Igor Mammedov wrote:
> > On Tue, 31 May 2022 13:00:07 -0400
> > mike tancsa <mike@sentex.net> wrote:
> > 
> > > Hello,
> > > 
> > >       I have been using kvm since the Ubuntu 18 and 20.x LTS series of
> > > kernels and distributions without any issues on a whole range of Guests
> > > up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to
> > > the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs
> > > (3700x).  Migrations back and forth without issue for Ubuntu 20.x
> > > kernels.  The first Ubuntu 22 machine was on identical hardware and all
> > > was good with that too. The second Ubuntu 22 based machine was spun up
> > > with a newer gen Ryzen, a 5800x.  On the initial kernel version that
> > > came with that release back in April, migrations worked as expected
> > > between hardware as well as different kernel versions and qemu / KVM
> > > versions that come default with the distribution. Not sure if migrations
> > > between kernel and KVM versions "accidentally" worked all these years,
> > > but they did.  However, we ran into an issue with the kernel
> > > 5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of
> > > Ubuntu.  Migrations no longer worked to older generation CPUs.  I could
> > > send a guest TO the box and all was fine, but upon sending the guest to
> > > another hypervisor, the sender would see it as successfully migrated,
> > > but the VM would typically just hang, with 100% CPU utilization, or
> > > sometimes crash.  I tried a 5.18 kernel from May 22nd and again the
> > > behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can
> > > migrate back and forth.
> > perhaps you are hitting issue fixed by:
> > https://lore.kernel.org/lkml/CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOhLk9dA@mail.gmail.com/T/
> > 
> Thanks for the response. I am not sure.

I suspect Igor is right.  PKRU/PKU, the offending XSAVE feature in that bug, is
in the "new in 5800" list below, and that bug fix went into v5.17, i.e. should
also be fixed in v5.18.

Unfortunately, there's no Fixes: provided and I'm having a hell of a time trying
to figure out when the bug was actually introduced.  The v5.15 code base is quite
different due to a rather massive FPU rework in v5.16.  That fix definitely would
not apply cleanly, but it doesn't mean that the underlying root cause is different,
e.g. the buggy code could easily have been lurking for multiple kernel versions
before the rework in v5.16.

> That patch is from Feb. Would the bug have been introduced sometime in May to
> the 5.15 kernel than Ubuntu 22 would have tracked ?

Dates don't necessarily mean a whole lot when it comes to stable kernels, e.g.
it's not uncommon for a change to be backported to a stable kernel weeks/months
after it initially landed in the upstream tree.

Is moving to v5.17 or later an option for you?  If not, what was the "original"
Ubuntu 22 kernel version that worked?  Ideally, assuming it's the same FPU/PKU bug,
the fix would be backported to v5.15, but that's likely going to be quite difficult,
especially without knowing exactly which commit introduced the bug.

> Looking at the CPU flags diff between the 5800 and the 3700,
> 
> diff -u 3700x 5800x
> --- 3700x       2022-06-02 14:57:00.331309878 +0000
> +++ 5800x       2022-06-02 14:56:52.403340136 +0000
> @@ -77,6 +77,7 @@
>  hw_pstate
>  ssbd
>  mba
> +ibrs
>  ibpb
>  stibp
>  vmmcall
> @@ -85,6 +86,8 @@
>  avx2
>  smep
>  bmi2
> +erms
> +invpcid
>  cqm
>  rdt_a
>  rdseed
> @@ -122,13 +125,15 @@
>  vgif
>  v_spec_ctrl
>  umip
> +pku
> +ospke
> +vaes
> +vpclmulqdq
>  rdpid
>  overflow_recov
>  succor
>  smca
> -sme
> -sev
> -sev_es
> +fsrm
>  bugs
>  sysret_ss_attrs
>  spectre_v1
