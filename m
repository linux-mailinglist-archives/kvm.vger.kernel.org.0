Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC46D8DE0
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjDFDJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbjDFDId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:08:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BCAA261
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 20:08:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54c01480e3cso23515207b3.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 20:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680750496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YXwPO3COJugDpcH5uHXjJUSYvlyyN4boQH0VNgkoDVE=;
        b=VUSllZJokxU+J/9IF5pahvqVy2lLsZD8c1FqSjy880xPSy7PLsVmL7hNgujCtzVD/9
         8THEct2GMutRtI8j1oLsJn+npJh2cB2ONHhwyU8JVHm+bK7AymAUbCcpRyzhIvYqFDlT
         B6ppDFghpiqctva1PRzAnYCuYjZPy97XBrRZ+KU2clstaawqvz4L6YD3zK0xSQL4deWH
         CQ9YuPX7G7rpki/4p75EOxT1TI7QbgeqJkwa6K7xccYHZWbVRPmnxmmNPWC/QbfpvK6s
         kMbkeWUnJilymgQC+8PaZhcppTQAEbPvdPQJdHF1F9bGxe/sCMyu0M9zZQkFMCY++y1q
         nwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680750496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXwPO3COJugDpcH5uHXjJUSYvlyyN4boQH0VNgkoDVE=;
        b=4k9OBgjybjltlE1ENuqJL2+BNKwXH0uowA/3//+500j13S/SWGygRrlFsnvbq+13Ch
         5Z776rmWfY7NatyHWqcA2OfLagT1lrkqBJXz0lQZnZkQv+PJOK9q+xuZIXrR7/Ab+HQR
         oi6Dy0tVstIUxcB1zCWonbJKTDs4gY1sARWfjYYyzDnBWz6r3Oy3uxSXyS6LB3rvxTQJ
         sMuhTUmB9DhcqaW6ppwcb027KrY9DrjdnggoL3+2glmZoPqjeHW2FQMGHo5g2+n3ElPd
         RoVMwErF7C5yp1EZT9skaOwFxAxHmi8NHBUC6TTpD0CS+IAs/krLbgUwxhj7e7P2tFaq
         11qA==
X-Gm-Message-State: AAQBX9cmCw+IH4dR2XbBvikEeT8JHUdRySevPmLMeAIfmvFdgZZJS0ST
        DrHQDffYPUCSdUZNSryqewvfEYbUEBk=
X-Google-Smtp-Source: AKy350aSM2AObDoRvgxmc7h58tZisvk9/DwCMWtBBlJNfF1AR1CkqA5WR7Ql4MORiuThxkqLDXhMC/iHktg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d107:0:b0:546:5b84:b558 with SMTP id
 w7-20020a81d107000000b005465b84b558mr4844875ywi.10.1680750496507; Wed, 05 Apr
 2023 20:08:16 -0700 (PDT)
Date:   Wed, 5 Apr 2023 20:08:15 -0700
In-Reply-To: <ZByPWH5ayCT25vbN@google.com>
Mime-Version: 1.0
References: <20221226075412.61167-1-likexu@tencent.com> <c5da9a9c-b411-5a44-4255-eb49399cf4c0@gmail.com>
 <1ac1507d-ab5d-4001-886a-f7b055fdad39@redhat.com> <ZByPWH5ayCT25vbN@google.com>
Message-ID: <ZC43nyPWuZ6MdTjz@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix force_emulation_prefix
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Sean Christopherson wrote:
> On Thu, Mar 23, 2023, Thomas Huth wrote:
> > On 14/02/2023 07.47, Like Xu wrote:
> > > CC more KUT maintainers, could anyone pick up these two minor x86 tests ?
> > 
> > Your patches never made it to my inbox - I guess they got stuck in a mail
> > filter on the way ... Paolo, Sean, did you get them?
> 
> Yeah, I have them.  I'll prep a pull request, there are many KUT x86 patches
> floating around that need to get merged.  Will likely take me a few days though.

Gah, forgot about this series.  I'll plan on doing another pull request next week,
there are more outstanding KUT patches besides this one.  And I'm finally diving
into KVM PMU stuff tomorrow, too.
