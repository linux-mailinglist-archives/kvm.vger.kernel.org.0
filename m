Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACE87272F9
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjFGX3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjFGX26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:28:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E03D212E
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:28:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-568ab5c813eso130676027b3.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180534; x=1688772534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X00Y0MbHB0g1SUbGMkZR+sXMq7kcBl70hBJO92BwPM8=;
        b=u1xRVHlmrBFWIVHlqPHClZdUg9ouqpwEQhS+/u6zbP00mRZiy3LomvMdp81w2wr8wg
         SWD1MWb1nw07SoEvMI9tcz/m4BdZnhMkh1MKJNYLu1z5TZp/VXkWlZB4+H93GEoqCo5s
         B52EQ4gtpdmCRzUwY8yhSAl435Sx53Rib2EYWxxU8aMGlso32BBwaQOEqjyuBgqbVrBh
         uA36TeW+4ZUKGL9ux1fz9wZtMOt7BlU0MdRWzAFPtakM5Ar3EkIgSWKSjZe65BH34zcD
         3ohRrev++oo+Y2vvnxpFquANhNAJGPkTJbbjNxGZer3dv1VjaieqHkzbIA384T+Wiz5G
         O9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180534; x=1688772534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X00Y0MbHB0g1SUbGMkZR+sXMq7kcBl70hBJO92BwPM8=;
        b=eLMcasDqrC20BhbM+3nLxICnFr/fxSzFooQ1qPQclZUEjxxfNJ1CRObObyqNV8Ndwa
         KWUQlloPkDA9TI2KMDYxddstE+hqCUJa3fcFaa5bN2lyzjfrJJXjPX7eatdRmmnfYSCT
         5T/r7qX+A5tsbY/FFtMZPpMKQluv4WX5MInqVkkIpYoQZQk8z0mrHVBT5yPGWOtWdbEI
         V8tJpgH9CzRV+/2NxT7dzDhw/3auYe65RA1/x7AwpZFR7MfamGA9nwRMG+gDVvgTEFse
         keHJqrg2MIMdKmlZH3MCMhMYBeBqVRAMmf0rfzaivVwXoo0FqD1hc4XhfHYSkAB37k1l
         /aNA==
X-Gm-Message-State: AC+VfDwVvjsLkbKWqb/FLTw24YVBQl1OybxJGb8vyKWzgtueL3hhP2i3
        EiIG5JF+s8dq4jK9maWNMHEcBaYSSdc=
X-Google-Smtp-Source: ACHHUZ7znmd7aeXsuH34ZTHH19gg1+n+chjL1y+QqZdYSKo68+TMZeHtJUGjyT5DCc2yMSHr0MXcDbjkWhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a702:0:b0:565:bf4b:de20 with SMTP id
 e2-20020a81a702000000b00565bf4bde20mr3696786ywh.2.1686180534435; Wed, 07 Jun
 2023 16:28:54 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:25:56 -0700
In-Reply-To: <20230607215114.1586228-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607215114.1586228-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617898831.1602737.13287714543268080917.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] runtime: x86: Require vPMU for x86/pmu tests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 07 Jun 2023 14:51:12 -0700, Sean Christopherson wrote:
> Fix a bug in runtime.bash that makes it not play nice with testcases that have
> multiple dependencies, and make x86's PMU tests depend on KVM enabling a vPMU.
> 
> Sean Christopherson (2):
>   runtime: Convert "check" from string to array so that iterating works
>   x86/pmu: Make PMU testcases dependent on vPMU being enabled in KVM
> 
> [...]

Applied to kvm-x86 next.  I'm OOO the rest of this week, thus the super quick
application.  I won't send a pull request until next week, so there's still
plenty of time to object in case I've done something odd with runtime.bash in
particular.

[1/2] runtime: Convert "check" from string to array so that iterating works
      https://github.com/kvm-x86/kvm-unit-tests/commit/e1b27810b555
[2/2] x86/pmu: Make PMU testcases dependent on vPMU being enabled in KVM
      https://github.com/kvm-x86/kvm-unit-tests/commit/dbbfaf80b8ff

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
