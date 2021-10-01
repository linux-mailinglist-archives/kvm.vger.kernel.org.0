Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD341F2EB
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353938AbhJARUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 13:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhJARUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 13:20:19 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F610C06177D
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 10:18:34 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id g41so41152297lfv.1
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eaKHWjFuwyKvxPTNwNYn3BuRwzDh6/0sQ7VogCTPG8s=;
        b=j2KIPK1abEQDmLX+us5yk2H9k7jh1igya3VQ/oN9xVeP/qTGNtdxRNyctZTVU85ui4
         xJIne31y6CyFJpieB6eP/2bh3PDy2m50SAmRYu/ijUYYq/iLj/yL5d/M3vedeb2FDDBi
         4M4zEQTrzvyjXCojCxFwNvT+AIyJQ+AbJKDcjVtL4fyBBIxqFtpMz+OuKpDXtE/4WDyj
         aj81I2Q052BvWtna4cBQGC+BcoNJcbiQKs+8whfG71t9o3RN64MYTrBs6Wf3/x1Cdjem
         fpYF8ocFQNb/dSQ/fnx2U8zZijmANqJ+ivamgVGDnPWtYQWXmPz/QMBvaFB44GKew4qr
         1ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eaKHWjFuwyKvxPTNwNYn3BuRwzDh6/0sQ7VogCTPG8s=;
        b=U/oVF/iP9aNPAARboH0/YqwXwlXKoeOx+E+gSlEMK324Z+PykkBSQv6l9mqY2QXx75
         Lnvl21lD8sKDAIo/utBRGk1mq91qZchNDSHvXoJ5SQm2lhVntsChViU1g2cHovgPAe26
         09cIefR+RJD8muR7rMCny/6rV9UDn+NJwkUBlP8e5hoT/AZyYz8dvfSvR3bS7zMInX6y
         LGothlwxw7E4qFoKkALXMDInqpID2k643pFaAA3Nu9QfYXhJ7aqxwTfZm5wVCUKiajX0
         1+YBF1/attVQwd7Z5uprWh0aJhHJZPIkUh/9nlpKERbdeJUIiH4RzAoUviHMmkf2KLOs
         hUqw==
X-Gm-Message-State: AOAM531KADvu52CIqWiUTJ60FGSZH3tN+/RJ8XGOUKmNDEH88Zy+0ahK
        EQjXLTO8PRH9ka/mToX7voLX7gZL5TezRMDxgMpH2Q==
X-Google-Smtp-Source: ABdhPJziBYyBg1MdhYdRfe+e6ZE01VBv+2vQ9vu2x8Ts5SH8U70CKxzXlOdmOq32hDBm3FqbdLKCLOzfyMCGxpPbV9g=
X-Received: by 2002:a05:6512:110a:: with SMTP id l10mr6525108lfg.550.1633108712320;
 Fri, 01 Oct 2021 10:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210827153409.GV1721383@nvidia.com> <878rzdt3a3.fsf@intel.com>
In-Reply-To: <878rzdt3a3.fsf@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 1 Oct 2021 10:18:20 -0700
Message-ID: <CAKwvOdkVAKOCH1hfSqNphKco8rLOmyAg0PVGzmpMRu6Svs1hSQ@mail.gmail.com>
Subject: Re: [vfio:next 33/38] drivers/gpu/drm/i915/i915_pci.c:975:2: warning:
 missing field 'override_only' initializer
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 1, 2021 at 4:04 AM Jani Nikula <jani.nikula@linux.intel.com> wrote:
>
> Anyway, we've got
>
> subdir-ccflags-y += $(call cc-disable-warning, missing-field-initializers)
> subdir-ccflags-y += $(call cc-disable-warning, initializer-overrides)
>
> in drivers/gpu/drm/i915/Makefile, so I wonder why they're not respected.

You do have to be super careful with `:=` assignment in Make;
generally folks mean to use `+=` and end up overwriting the existing
KBUILD_CFLAGS.  I'm not sure if that's the issue here, but it's worth
an audit of your Makefiles.
-- 
Thanks,
~Nick Desaulniers
