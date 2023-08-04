Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC41770476
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjHDPZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 11:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjHDPZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 11:25:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EC0526B
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 08:24:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5840614b13cso36700777b3.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 08:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691162672; x=1691767472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg+BPfk9QstTM+/p+EMBw3OytkWAvvbhRYFkqlerfdw=;
        b=n8O41gfu0v8W3Eo0JNgpUADRtyfkwSv2JplJqPHR8pfshQ3/lNiyvEHDZ1M2gV+CKd
         AT8V18SmMFs4xeCBD45H10gP850OyNngFsYdk4BCA17OWpQ4Xmjfn+YVLzbudoU5mqPr
         4CLDRP+lgE7NusnuHvbOYP/4/UEagjQKuExHROxxHFQSPiWhAvRoovsslgMeUQhHIZXK
         ylPiGNGzo1v+2NNdTACGEeAOBOyFZRQ7JccOlLZRzsvttedfouepFxueVp5dFacC50Ci
         GZfB6ZYOvJgCH67Mna0H6U+l6IXtZZWoERfhoIKehmTCXBhdfd6gzbIdMd+1vupS1xi3
         BIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691162672; x=1691767472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg+BPfk9QstTM+/p+EMBw3OytkWAvvbhRYFkqlerfdw=;
        b=QXY9AAozuOxVL7qJ2AWNAaHTMrtkP1q44FTxnIEu2pb/ElttMRxakuBEr0Jc3YNwrV
         xYWPCgEF/9/g+H0WEjd2Sn/T6cgxqPTnxy2Jgjbkfn0LiUal8wnLdfxGTL5kbroH+nuE
         dDrUcE6XHYEVS3EUFeHncgnNKE08zUl7J6x9gxZh1mM94Dif95zvJ9AgihFRLFth142m
         AZE2mAS707HYUdaXtv5eCOHeFBcpNCSO5Q1fB4hoG6HLHpZ8MCz9M/FceoZrSj4P7rUI
         wWkViXlT77OuAMLRSmRwQqfLB65aGS/h94FY8PfY0Dnx5jEzNW7Mz+WBT6XL7wkt4K6g
         Z9wA==
X-Gm-Message-State: AOJu0Yw4v6iNErcJHEubolsIPOUm/UoRjosYRuCa4fDvvswAx1jPRzMb
        LGBCckUQYm8Zz6ag1zRmGi+cddxTS2o=
X-Google-Smtp-Source: AGHT+IGBENvHbIPWalo9e1vUP6I9SbYdENJwDfmlXtBN8bF3yYa+DFLhCVVTARap930KJujspRp4+arkHrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c05:b0:576:e268:903d with SMTP id
 cl5-20020a05690c0c0500b00576e268903dmr79ywb.2.1691162671930; Fri, 04 Aug 2023
 08:24:31 -0700 (PDT)
Date:   Fri, 4 Aug 2023 08:24:30 -0700
In-Reply-To: <20230804004226.1984505-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com>
Message-ID: <ZM0YLh1kOXY7OwTc@google.com>
Subject: Re: [PATCH 0/4] KVM: selftests: ioctl() macro cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org
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

+KVM (good job me)

On Thu, Aug 03, 2023, Sean Christopherson wrote:
> Do some minor housekeeping on the ioctl() macros, and then teach them
> to detect and report when an ioctl() unexpectedly fails because KVM has
> killed and/or bugged the VM.
> 
> Note, I'm 50/50 on whether or not the ARM patch is worthwhile, though I
> spent a stupid amount of time on it (don't ask), so darn it I'm at least
> posting it.
> 
> Oh, and the To: will probably show up funky, but I'd like to take this
> through kvm-x86/selftests, not the ARM tree.
> 
> Thanks!
> 
> Sean Christopherson (4):
>   KVM: selftests: Drop the single-underscore ioctl() helpers
>   KVM: selftests: Add helper macros for ioctl()s that return file
>     descriptors
>   KVM: selftests: Use asserting kvm_ioctl() macros when getting ARM page
>     sizes
>   KVM: selftests: Add logic to detect if ioctl() failed because VM was
>     killed
> 
>  .../selftests/kvm/include/kvm_util_base.h     | 101 ++++++++++++------
>  .../selftests/kvm/lib/aarch64/processor.c     |  18 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +--
>  3 files changed, 84 insertions(+), 52 deletions(-)
> 
> 
> base-commit: 240f736891887939571854bd6d734b6c9291f22e
> -- 
> 2.41.0.585.gd2178a4bd4-goog
> 
