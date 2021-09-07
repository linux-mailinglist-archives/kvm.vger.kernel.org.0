Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA342402EBA
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 21:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbhIGTGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 15:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhIGTGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 15:06:33 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFF2C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 12:05:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id p15so230102ljn.3
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBt2QcT+qejgfLCsR6+AgaDfNkL4tTkfr0k4a7ndIe0=;
        b=pvtitd0K3fv5rwIpgkNW0Ifn/b1Tb8c/Rk+jSr83PySBqWDbSk1YxerhqAO2s1Ii1i
         p6wDa7rk8+6wEWQiP8rFp1bAY/4yVy4CxYsnmh+HmbFN03vtcz8wwB6bfXxe2upsr3Ib
         o0GDhypkB6k54A9jrThT1BhXVAwUkGCTxL+wSU71aKdAKdxwAroMuxTp1JTyfBSoamm3
         7h4zdUhypvFkcIaYtLV8q6b1VcAcLXd5sAN1TRF+pF6DD2uuUIOK9XT9yd3S6shEK/u3
         vEo1puywFmjduBLq9zAbP0mAI7/cgCvUAasLLT7zkWrN9valKtlSvHyec8g6bzzDvEmt
         OjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBt2QcT+qejgfLCsR6+AgaDfNkL4tTkfr0k4a7ndIe0=;
        b=pFksfLyBGUNn9xuH0EfpiV7oUAwXnUTzptNaGme7C8BC92cRuwzfvDQAapWOrKvQaI
         W7jW+fnb4FDw42T+WfenAIOEB2xCRgjx9WUQPWs9aRoUBcm76uTKSpWwsd6dg3r4jBhm
         Wjd/fPYfSJyKil9I9oJ9wZVc0mC18nwrh3GmqErbG4uY2dMJb6/NVctdthCv+kn1o5M2
         mTRv/BV8IRZeQfkFGVopmOFngj6UJMwdf0+cy6v1oXUTKVXO13KiUDIrP2Qy7ucT/Xxr
         /InQffn8rkaF7LX3Wojq0i5/3zQ86z8qLItdo4WxsPsTGkgr43CBCV1fINhuTeIgEPci
         bwbA==
X-Gm-Message-State: AOAM532iMHmlPbCz8I3qRiEwonL2t+uRvb5LdL7rhNsESdY3lDKh83xq
        gq0fHnxQNUWn1dWb/C0hFZ/84p/SnfUV7zHdaBZQkQ==
X-Google-Smtp-Source: ABdhPJw0lcNxyeV+WtmpbYLM6yuzl0K5oPwjGar/B0vlVqgp759KpQqNFxSh4fZpMp20d0uB/pwWLXRAV/ASUAQqois=
X-Received: by 2002:a2e:a40c:: with SMTP id p12mr16620609ljn.479.1631041524250;
 Tue, 07 Sep 2021 12:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com> <20210907180957.609966-3-ricarkol@google.com>
In-Reply-To: <20210907180957.609966-3-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 14:05:13 -0500
Message-ID: <CAOQ_QsgYm9GX=7k0kg8w_4SSP2ioovrJ_BG8jg9y3jjj8TC2vQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 7, 2021 at 1:10 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Oliver Upton <oupton@google.com>
