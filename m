Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FF569703A
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 22:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjBNV7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 16:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBNV7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 16:59:47 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458F1EB57
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 13:59:46 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id cr22so19802873qtb.10
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 13:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G9CGSOp3cnMbqbIfyoqOt2E4VaTIulHyrGeP2LlvMsY=;
        b=ERbDpCpt2Tk4VGox/mEQVipV7nprtmIHi/II9V7O+StTtFAxdKi65RNqDJcFbNVb1X
         9CQJYjwsoLZrgFVz+cKyqcItgaS2yg/xt94wT430K6f4WoEDlHPS6qoY6ybpy6x00JBh
         SdYrx5Rf/RQLfo47T+A2IxYeoz2D6yKkjNahTRQQOqJyGCn4qrG1WOxPEio99ROGwJZK
         H6jCUN7og67rkf4ykYgx7cSGFeMzQa3kIfaAWSdZI4iLICf18nt6ZWr9zwO1zEQDd/1O
         CjRHt4nwDjXPZ1TmIJNvu/1FjNBKa9jkUWpJal1G/dJCSC1KFc0lzY0xCEtcs3HhHJNv
         +R/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9CGSOp3cnMbqbIfyoqOt2E4VaTIulHyrGeP2LlvMsY=;
        b=mIEEM7+BGnhpD+9lhXRXbwmW1RBR+mQX+LXb6RWv/4gHJBPZc83R6Da5iWX1JnsrRx
         xWzuXfntwHmrRiKufdPeQ5sUL1V+HJ567yol1jMSgyONDpXaor9PNADOQ3b2gy5pqBnm
         MyZqv4crDJ0jKjvdtV5JC1NA1njdGi8+tkbsZLmJ5zlzOF9lRqQE9iIpqxzAyqpoFSu8
         1A2Ubon3eQzqM8JLcgDLmLzSMHStE4Sq2mkJsctnUTPWK3aLaiGS4b2dl/R8ZYdtactk
         TGYOrkAZOyUwv1BIpjPCRlr0ryViFO9NbA4HEmpVMN7tBz9/Di0xJTAxfnPsseopQqX1
         /mtw==
X-Gm-Message-State: AO0yUKXubDrQ2Z/esOlp4UcfO202eJqcVIIwPfuod6xVQ3p99hSAMO8z
        odsrs0QN1XCUpxh/iSXEyYwK4a4vhPqhZagXJGzCQw==
X-Google-Smtp-Source: AK7set+Gv3LXwX2MMsG93isRy47g9jzZQtswzEk9WEDLngAXTM0ZyBRQotqzN6+CLBFyCY5T0/n3zT94zcb6C5sRpEU=
X-Received: by 2002:a05:622a:148c:b0:3ba:240b:99ad with SMTP id
 t12-20020a05622a148c00b003ba240b99admr543512qtx.65.1676411985281; Tue, 14 Feb
 2023 13:59:45 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <1a3afa6d-3478-31dd-6f34-52075875c2fa@redhat.com>
 <Y+s5PwV1l60jXal1@linux.dev>
In-Reply-To: <Y+s5PwV1l60jXal1@linux.dev>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Tue, 14 Feb 2023 13:59:34 -0800
Message-ID: <CAOHnOrzXjwJ+WZJhvBQFT3y6iLHMAD54BveVCdhy0zksmUcZhQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Implement Eager Page Splitting for ARM.
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, pbonzini@redhat.com, maz@kernel.org,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
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

On Mon, Feb 13, 2023 at 11:33 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Gavin,
>
> On Tue, Feb 14, 2023 at 04:57:59PM +1100, Gavin Shan wrote:
> > On 2/7/23 3:58 AM, Ricardo Koller wrote:
>
> <snip>
>
> > > Eager Page Splitting fixes the above two issues by eagerly splitting
> > > huge-pages when enabling dirty logging. The goal is to avoid doing it
> > > while faulting on write-protected pages.
>
> </snip>
>
> > I'm not sure why we can't eagerly split the PMD mapping into 512 PTE
> > mapping in the page fault handler?
>
> The entire goal of the series is to avoid page splitting at all on the
> stage-2 abort path. Ideally we want to minimize the time taken to handle
> a fault so we can get back to running the guest. The requirement to
> perform a break-before-make operation to change the mapping granularity
> can, as Ricardo points out, be a bottleneck on contemporary implementations.
>
> There is a clear uplift with the proposed implementation already, and I
> would expect that margin to widen if/when we add support for lockless
> (i.e. RCU-protected) permission relaxation.

There's also the issue of allocating 513 pages on fault when splitting PUDs.

>
> > In the implementation, the newly introduced API
> > kvm_pgtable_stage2_split() calls to kvm_pgtable_stage2_create_unlinked()
> > and then stage2_map_walker(), which is part of kvm_pgtable_stage2_map(),
> > to create the unlinked page tables.
>
> This is deliberate code reuse. Page table construction in the fault path
> is largely similar to that of eager split besides the fact that one is
> working on 'live' page tables whereas the other is not. As such I gave
> the suggestion to Ricardo to reuse what we have today for the sake of
> eager splitting.
>
> --
> Thanks,
> Oliver
