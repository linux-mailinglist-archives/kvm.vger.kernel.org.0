Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C5A617314
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKBX4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiKBX4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:56:22 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F362713
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:56:22 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-37063f855e5so1469327b3.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hbEcN1ifRG0CLzWvNQBxXgvfGWN0lKUpPYRl5gmu4FU=;
        b=JztyOTKcpKoSooxqm6kzxpGVcQaUNpEPtBGjMGlx+txcfMnZIHPW4Vr/YTVo4vNCJv
         TqwggrFPie8wgyV9N/oVdcAour3FqyikMEHcphFyTjEg5EE8LaGqf55kDpFe9658rOUp
         kSpaEkxPonYF7/4/fUbPnoBu7coRsiiCVv4nASChho/qS+KKYlxi/aloQCJ0mm7kC4kW
         uBhEvFlY9NSm1ILJy3nW8JruaBS2JoDujoqROcWTeBz6lZk4IUVAJ44F2jCoQ1eZTesI
         V/19jIpiecZ2xKxMVSnMKA/DVETclR7075qc7X5dMjajebkoR8nAgsFypDzwW96h9id7
         LAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbEcN1ifRG0CLzWvNQBxXgvfGWN0lKUpPYRl5gmu4FU=;
        b=ojRPqsYymfBK707LVJbQcl6l+uHDH92eR2oSgJw0EURAUEcCOGW6kHv34DgqV5DrMI
         Nc2Ix0Mufca0xr9uzAR+i0Isvy4NI+qaLXpjpr+tcvxK8iP3Eo7wsOzHOaZF8jknteoI
         dycuWP3F59CA9ZVs3s1rn7RyEKVJKETKUtuDvkub2GgUJk2NAFSTexzJkiInojTzX+gg
         SesfeBI5sf0an3OVGzq6gh71BhTrGMTMIoFJ0FT88j23DlLvV+T2Pag2vuVVXwymDIYI
         YA+cad9d4PoBffaB8CtugkFUCjrX5gQZmGsRSMh3d9Rxl2hvZKD0f+VsnSuq8OU+fr8t
         baNQ==
X-Gm-Message-State: ACrzQf2js4IsqgVh3Z/66p3dIBBwfdkmkwZhY6bpYJTmOfogbFD+Doc0
        54xTAWLAs+2Jdfsh8HDIUNx4IfvRS/MdUU132py47A==
X-Google-Smtp-Source: AMsMyM4arCSKEYjf7qDPMDZ68LREMOfC2nyuDJ4TOc39/x6JfKweB4Lw4nYUBWmDRnz4WQPd7gdO3QFFkbEUKiFMlto=
X-Received: by 2002:a81:16c2:0:b0:36f:f574:4a49 with SMTP id
 185-20020a8116c2000000b0036ff5744a49mr25907159yww.111.1667433381299; Wed, 02
 Nov 2022 16:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221102160007.1279193-1-coltonlewis@google.com> <Y2L/cWBjAtGheXNw@google.com>
In-Reply-To: <Y2L/cWBjAtGheXNw@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 2 Nov 2022 16:55:55 -0700
Message-ID: <CALzav=cJZn1y8xoQ7bAgraewWOn9oDZnQdmxp-cZfeNh-VgtKw@mail.gmail.com>
Subject: Re: [PATCH v9 0/4] randomize memory access of dirty_log_perf_test
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        ricarkol@google.com
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

On Wed, Nov 2, 2022 at 4:38 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 02, 2022, Colton Lewis wrote:
> > Add the ability to randomize parts of dirty_log_perf_test,
> > specifically the order pages are accessed and whether pages are read
> > or written.
>
> David, or anyone else that's intimately familiar with dirty_log_perf_test, can
> you look over the changes in patches 3 and 4?  They look good to me, but that
> doesn't mean a whole lot :-)

Sure, will do.
