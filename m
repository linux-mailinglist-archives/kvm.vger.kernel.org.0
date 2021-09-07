Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8A340293C
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbhIGMys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 08:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhIGMyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 08:54:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5330CC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 05:53:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d6so13646986wrc.11
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4cDtvvJiDONxbktDTeL+URNXfqhs06YOh0Wb0vKpXuE=;
        b=gTVzdRInjX/dnmGg73hvgZhaP3j9eU6oGyZskECjKsUwR7c3DWRJE9mEnEnxleavw6
         1cn8lg6CTY985kb4nComyKckxvjXFL2WxeqpVzpe29I3msh8fQFx7BD6y6hHXpxHnVYP
         wurcE/GA+ZupuCLpbFfjp9K5p0+h4a2dk95VT8Ya28D7zV035oKH1QdeeGvQJExM2as9
         WJcvH4mcWpf0fRKBheCGBAbfzqCuJeLfy99mQLuXs5a5TXrjS81anxQFHF/+exdvxdTi
         XUxHswQ/eEzyuAPLVdWT9NGTGmeVqWSKVysXnViop5DaRa3cgdnz6M9o3BXUwKThjO5z
         p+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4cDtvvJiDONxbktDTeL+URNXfqhs06YOh0Wb0vKpXuE=;
        b=ThAn1RIjeuOnyzLqAtqBHiQHuAn3BB3zBwihxy0+XQ3mnsbp9UtHdAh5ripn0vMfRl
         PwI4kpZM/EGlQBryB/edrd0E7AlWG+gM2rCx9mFIFJsfOVImcczLYmlAgV6jgDECTd3l
         UVrfemOlr2juJZMiGuLlQ1eFSYHVE7rHyJs1mzMKxRKEI5ZVqyZLjkWm8BiUK33QrVfU
         jleVQj1h05TddvATl+B4t9Kc884r5wg/1DkZxDjzCp+kvLUiA/wxqaizuTTrHHAPjlWv
         5H+CXllftWcXA4i7tvhgJuXMJOeP4pdKsQr2/cFb4AEDfw4MlbuZx5ZZgZIil0aWskmA
         R9WA==
X-Gm-Message-State: AOAM530ocHi4u4TGAOMIhyGyrpd9NpNYabzsren8C3ULB5DRKdxFHGFU
        weWrO2wuy+gSSYDgYs7Sp6sG8RBgvyAydUnEY5y6/w==
X-Google-Smtp-Source: ABdhPJxrLmDLa+HjRoX8Rv60uwocrI+Qc6d7xcHSWB8bchkHtGLPk+nY6fi0MnnqybP7bULCaOkzltqGHJO4o0kGo9M=
X-Received: by 2002:adf:fb91:: with SMTP id a17mr18038543wrr.376.1631019219992;
 Tue, 07 Sep 2021 05:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 7 Sep 2021 13:52:51 +0100
Message-ID: <CAFEAcA_09YHF3LhxcLVoxd=yvO5g4dUsjkwDo5bdVNFNcaOXuQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] target/arm: Reduced-IPA space and highmem=off fixes
To:     Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>
> With the availability of a fruity range of arm64 systems, it becomes
> obvious that QEMU doesn't deal very well with limited IPA ranges when
> used as a front-end for KVM.
>
> This short series aims at making usable on such systems:
> - the first patch makes the creation of a scratch VM IPA-limit aware
> - the second one actually removes the highmem devices from the
> computed IPA range when highmem=off
> - the last one addresses an imprecision in the documentation for the
> highmem option
>
> This has been tested on an M1-based Mac-mini running Linux v5.14-rc6.
>
> Marc Zyngier (3):
>   hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE when creating
>     scratch VM
>   hw/arm/virt: Honor highmem setting when computing highest_gpa
>   docs/system/arm/virt: Fix documentation for the 'highmem' option

I've applied patch 1 to target-arm.next; thanks.

-- PMM
