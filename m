Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E953C402EBD
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 21:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345211AbhIGTHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhIGTHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 15:07:35 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1643FC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 12:06:29 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x27so1554lfu.5
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 12:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+hlDwUFiTVxWGKpSU6MU8j+cu8U8TUReyBLxU0Tfmk=;
        b=D3GWVUAsTVbjoxvrtwleyMkvybOGrJteUI1wvNoq8RqFLISE3GOIPZXCWVsKqFsBoo
         +bYNN9SqyzIe8uObqPJdKTv4OhDniNZNtqY0gXWJ+Xmo9qNLxrU0+lQcTFxPRdc397bn
         9JUd0ty7PDiR9XxZLQ0iBg+jWxYEdHhYLHN/NoSFttvyFP5KHW/qn9nyd7L0Gg4LhVSb
         waSPRE8D4hMkiAam6KJN8Vch6JHUthjmNpPG+MpvLt1GOQEb7ll2rC7/AYrr49fwnfhB
         keSH+j+e0RQF/gaJnaDDQ0w0iexQyTDQIqGy0jJWB7gNuqEPbylw2NbO8iAYmq/yeE9+
         c+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+hlDwUFiTVxWGKpSU6MU8j+cu8U8TUReyBLxU0Tfmk=;
        b=c3evvF5VOXpdlQ3/JsKT+Z1PhIJr27u2Xf5NOtoDcGMnjb2pdvLjEaixiTM13ip8Xn
         W5JmumzQu56M2vspH46X4W/laqUh5U+kChhcv8Lo9N938RXCFcCz/tLkQHXu/otbzVCN
         Lewu/n81PIOS8v+nC698PklagA4Bdq9qm5hUs7bHjz+Liu+6gDDyXTHTpMaLQrUhQp+s
         JrWB5YFDBPqGLml3O/pL5hiCfIzU4VcKDLDMtu99ESXNwwykIJYxpujD5/7Jwfd9mUAt
         nZ3C1CyseeVFluipe34NScl3MFd9QV8bT71FCSckJmPSQvS7TPc07BUIEIRTRwlA6IRv
         +5IQ==
X-Gm-Message-State: AOAM533kUDnUQS2OWFZEEWG5mujU7vDig83Hae9QwVnHVrNPZ9/TMLSX
        vwQ+AalwSKFpVSdW1agC4MW2ePeuo/3F1rcAfWhY0fPrxZKpfw==
X-Google-Smtp-Source: ABdhPJxFH6TtOzvVoSUHVh1aaUptpkScIjaFBYjZjLBHoUXGtoXqRsTik7vATNsE0IDRxSFVL5PXNZ2s3Z6IPiHesMU=
X-Received: by 2002:a19:7406:: with SMTP id v6mr13841838lfe.669.1631041587078;
 Tue, 07 Sep 2021 12:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com> <20210907180957.609966-2-ricarkol@google.com>
In-Reply-To: <20210907180957.609966-2-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 14:06:16 -0500
Message-ID: <CAOQ_QsjEu2GQTnvuA+8hZ+w1rVU6g36TKzSUASroYxqS=-4GsQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: make memslot_perf_test arch independent
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
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need to know
> details like what kind of exit they generate on a specific arch.  More
> specifically, there is no need to check whether an exit is KVM_EXIT_IO
> in x86 for the host to know that the exit is ucall related, as
> get_ucall() already makes that check.
>
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>

Reviewed-by: Oliver Upton <oupton@google.com>
