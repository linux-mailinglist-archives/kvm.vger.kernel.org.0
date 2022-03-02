Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F34CAC4E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244127AbiCBRmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244109AbiCBRme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:42:34 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE7FC9A3F
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:41:50 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id j7-20020a4ad6c7000000b0031c690e4123so2710038oot.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=18WzOkKWXdpshgP9mS61XFS+PCRVdMqsqOkLSI2n+2s=;
        b=myMdGpKXtoibn0rIaQd2nutJOppA6bdKTzAB5zH5P2SWzPj+q79iI3M77fJaEmcokf
         Qz1Sr2JF7Mj4KvVQN2ZWPDj2S9xyOmEh5XqL6YOTWSl1Vap8ad2tH/zn+/jLWjgW5H6H
         TSgY6+NXMDKUaHuVlosTki6x0RN2D3F1/3cvHPQftA5pQtRyAVJTvf85hYL9D06gfGQU
         cKF5rjCUtNjP/0w7f545s6a/9+5prtPfCkAE7HZDhqqjNIBuH3/G33YXamTf8rghuckN
         UUyauv5ddP8dqklbGE1TefY58YwltE7jU8YbVJAdLTZQAQ8t0Bh5b7MZuq4DmJm6MQPG
         esdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=18WzOkKWXdpshgP9mS61XFS+PCRVdMqsqOkLSI2n+2s=;
        b=rzFkv5QErAqQyAmqlYblUkhVfbiyMcWcOlbyYlVWx+Ecp+Mc2kAWdzAI8On43RKwny
         nlKNBEa/mijDCxO2mY0XQuRnylw2yzs62u97fvycJNt1osnxE7VKQnsl8v6+UnHbiUTX
         xhck55Br4zKQ6RS3KLtX1fkaHVqNpF5IiWIWk6E1DVNJihBgB/scGSOHhsvEJq+LQpTZ
         T9SgSex/Wod/gF6GoaDBoFFVaKHSTWt99V8Jr7wAVPKlEq65eCD1FPCNOmXGz1DMfT8k
         tKmefFte+awoBkXkqaeSPxGQsiPNoWo5VFM6+WKQ83f+ci1uk43qj5I4aMmWtEQ/xvCD
         kInQ==
X-Gm-Message-State: AOAM5307f34ywPWllsiqN/9+OP+3fpbXlK3KiJbn8bg7okaBPO85iu76
        ZiQvFP5CnajdGPJjUtEf85XovTiXoHMjgZhWJOf1RPS0rMc=
X-Google-Smtp-Source: ABdhPJxt/kQkje6kRh2Pn68EdFRkrY7AzSX2cPJnQDASFYQ2kNs7+f8w8anSKRPaebdILdItjUqmnczKJO44jQeQung=
X-Received: by 2002:a05:6870:a68c:b0:d9:9e79:ef35 with SMTP id
 i12-20020a056870a68c00b000d99e79ef35mr769415oam.66.1646242910122; Wed, 02 Mar
 2022 09:41:50 -0800 (PST)
MIME-Version: 1.0
References: <20220302112634.15024-1-likexu@tencent.com> <20220302112634.15024-2-likexu@tencent.com>
In-Reply-To: <20220302112634.15024-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Mar 2022 09:41:39 -0800
Message-ID: <CALMp9eQvBHcB-gB8aPcUSzS2tO5UC9pL2OZF9u5Qbqr3y+AbTg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH RESEND 2/2] x86/pmu: Fix a comment about
 full-width counter writes support
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 3:26 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <like.xu@linux.intel.com>
>
> From: Like Xu <like.xu@linux.intel.com>
>
> Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).
>
> Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
