Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61EA5EA897
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiIZOiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiIZOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:37:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1196B4D24F
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 05:56:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hy2so13834734ejc.8
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 05:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rz3mlN4KbQjImCM3wC+X2Jb9p/lxfW4IHRyyTjdAQXE=;
        b=MMoyS0pHXmUTBqpuFERSTIQXL+fMgIz3LnDzhbqDMbLxfuuuggs/e3Ywr/g/uqfVms
         ShdH1N0tM2D7xliAYRg3PFqEKUKByrlFEoVdfWdiAaGMTSsr3DqOgYfPi5J2EgNy3SQZ
         EgT/u2TC6/7H2CQEMfphl/bSVKpiXS7CfMcQx7XH1fYYVUgesA8q8i0FO+AQkzBVUbxu
         HZSJIToH96Ua/xfWc/QXLBt5nK0BSOUNKAvbrcQRFJOxhLUXy5SOxzAicIqNmYe6Kc75
         7aViVYLkQt72HVq9GNqxF7+yH94vHfSo2NWeCJVsubtDG8hxsT0lKZU7Shu2+EVGkgvF
         2b6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rz3mlN4KbQjImCM3wC+X2Jb9p/lxfW4IHRyyTjdAQXE=;
        b=EkXnqklvqX14uM/OvqT70pJcFm39wcVA8rq/Hb2/ZYmNrI5rpOwf7zg19c1YZhvHQP
         Yp02tzxa/wPahcnNlXjVD4Jn44oY7udJquJ1hE6k/aEpRAR07OysipS5IuE7e1YjeaTm
         jCEUcpNInySGHwf3al4Ro0wEc0Ls9l9crOQ6mxSZiDitR5+NrbrAsnF8Fo9Wg+ROT2Tb
         fkZ/8n+Cw4HaU/64II+I6NEGpZLuwVrmpNMO6ByToBshGTBlZRstjBAiyjJZbplhnAPW
         qkBqx4DVpz4c8bpv/sKn5wbiW5fKbOvGZ4cVAJ7160XYnod9vvplhznQ9Y1ySFrDaCJZ
         3BwA==
X-Gm-Message-State: ACrzQf1xNU1X8DMfb1es0Tv4+dEGc/LJIN75mxMwt0GuKgNtQ5nLYamQ
        kliKpMrcsGlb99d9KUj1yGl+M5SU5G8eDrv1nr3roA==
X-Google-Smtp-Source: AMsMyM6rAl/HCo4G1FcZNnsCazKAx7CoRu+Sy0E+RdwAgd/vxPaeIqwqU/A20MFL9vXBDGJ+QRoVpwqBURqiBDt+YCE=
X-Received: by 2002:a17:906:8a6b:b0:780:ab37:b63 with SMTP id
 hy11-20020a1709068a6b00b00780ab370b63mr17676870ejc.365.1664196993426; Mon, 26
 Sep 2022 05:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-2-mjrosato@linux.ibm.com> <597a2761-f718-4a2c-c012-a0d25bf3c7fb@redhat.com>
In-Reply-To: <597a2761-f718-4a2c-c012-a0d25bf3c7fb@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 26 Sep 2022 13:56:22 +0100
Message-ID: <CAFEAcA-8zWssi4TVF5TvHet9gxNkRvNreW6-hmTR0DgOu53Msw@mail.gmail.com>
Subject: Re: [PATCH v8 1/8] linux-headers: update to 6.0-rc3
To:     Thomas Huth <thuth@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        richard.henderson@linaro.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Sept 2022 at 13:53, Thomas Huth <thuth@redhat.com> wrote:
>
> On 02/09/2022 19.27, Matthew Rosato wrote:
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> ...
> > diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> > index bf6e96011d..46de10a809 100644
> > --- a/linux-headers/asm-x86/kvm.h
> > +++ b/linux-headers/asm-x86/kvm.h
> > @@ -198,13 +198,13 @@ struct kvm_msrs {
> >       __u32 nmsrs; /* number of msrs in entries */
> >       __u32 pad;
> >
> > -     struct kvm_msr_entry entries[0];
> > +     struct kvm_msr_entry entries[];
> >   };
>
> Yuck, this fails to compile with Clang:
>
>   https://gitlab.com/thuth/qemu/-/jobs/3084427423#L2206
>
>   ../target/i386/kvm/kvm.c:470:25: error: field 'info' with variable sized
> type 'struct kvm_msrs' not at the end of a struct or class is a GNU
> extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>          struct kvm_msrs info;
>                          ^
>
> Anybody any ideas how to fix this best? Simply disable the compiler warning
> in QEMU?

There's already a patchset on list that does that:
https://patchew.org/QEMU/20220915091035.3897-1-chenyi.qiang@intel.com/

thanks
-- PMM
