Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F60758322
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjGRQ66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjGRQ6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:58:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED61FE1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:57:21 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fbf09a9139so9568897e87.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689699343; x=1692291343;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JIndIIsHZdBsI82FGjgzN3aCzq+aMlyvKWLxj8Qz9aY=;
        b=VpfD2xPGeXFrsUMOAFJrtVhv3f8Z4MZm+RaTMwv/z5vZScyldkBj2GVf/WaYsoW2pE
         /bgiT+HYhcwyL9cXsqG+mLf3HK6QDpBzj0fTR42+nQYKuOOknGenF2kMWY+pBJ9FtWOR
         ABc7beAtrkMBlykXcwniKtnS34psSo9tgz/Ed2EC4maPoF7Jl1XUJQVxRyBfbi4KqTWm
         i040rAkjbcN6gFgsY8q76yYw0ykmGxPMwmmXLojHyhyxQxODbEng/S2D4F1bI0zQyC+w
         cfqgbRLbFZu43RFERcW6WEI6hTByCarCIqk8zw/K5xOWVcUAmTPRlb5jx801Cq9L/89G
         KB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689699343; x=1692291343;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JIndIIsHZdBsI82FGjgzN3aCzq+aMlyvKWLxj8Qz9aY=;
        b=iiRwRRtvakDAMdNP5EIzd6Y/b7xVATArCh1REVX9glU0+f2cAfNUVQP5dTgT0/7NTC
         OGr7YFihpDkEq9ZyLZoeT1eA9m7PY14k/A5yDcqdHQiukMcbhmwWLCjyGISiwjGpE70E
         42DvLRWHCnGy5fzRoL+O4sryOLS1MYtWLPoWlJ99Mno1Ir4VFj4deY0nfXYFclOQ5hoq
         gFY5Pn1h2g168BsEwMEH2vN7+QsPJXnvWrMsfyOO6B95akp7dUk3BBwNLJCk/cosLY6q
         w5sD5epWNHPTXDHD3jeOL+vYZ93T5I6hNlSyqVizeBV/CDTcc5H8PpmBARdyE8yqMwvI
         XtcA==
X-Gm-Message-State: ABy/qLaTbdKlrcvmVcH1eD7Ymk8m46wQkKPoxKFve7kTo5ANJUrvxBbK
        ZIBr9ZnBaDal0ilQjt7FwTiikce+QwMXLgVgQwxrSk6pmwQItkBB
X-Google-Smtp-Source: APBJJlE2uBeZwHdgwglSOep4/2Gj6tnEJTFOcNjZ6zIc3XLIKjD4I3fOhnp1lMuSNDsRNLskn1riZiAySK+ngZ9ZOTM=
X-Received: by 2002:ac2:5450:0:b0:4fb:8afa:4dc9 with SMTP id
 d16-20020ac25450000000b004fb8afa4dc9mr10304140lfn.49.1689699343057; Tue, 18
 Jul 2023 09:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230717201547.359923764@linuxfoundation.org> <CA+G9fYujXH8J99m8ZKoijGhWJAS+r1SPqd8y+gB-B9DVjsgAzA@mail.gmail.com>
In-Reply-To: <CA+G9fYujXH8J99m8ZKoijGhWJAS+r1SPqd8y+gB-B9DVjsgAzA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jul 2023 22:25:30 +0530
Message-ID: <CA+G9fYuxBPbDbgyr+oo_5OJwwYO7c53zEXfJKA9doT7XJAFA-w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        conor@kernel.org, Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jul 2023 at 20:07, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 18 Jul 2023 at 02:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.39 release.
> > There are 589 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> As you know LKFT runs latest kselftests from stable 6.4 on
> stable rc 6.1 branches and found two test failures on this
> round of stable rc review 6.1.39-rc3 compared with 6.1.37.
>
> Test regressions:
>
> * bcm2711-rpi-4-b, kselftest-kvm
>   - kvm_get-reg-list
>
> * x86, kselftest-kvm
>   - kvm_vmx_pmu_caps_test

These two test failures are not kernel regressions.
However, these are due to latest kselftests on older kernels.

- Naresh
