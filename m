Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F3402AD5
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhIGOfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 10:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhIGOfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 10:35:20 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E26FC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 07:34:13 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id k13so19981459lfv.2
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 07:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZ01/kVjxN4qO85F71R96OvGPb6wIX4duLA904XRBt0=;
        b=sUtQ7iAwFIzvOQDRef2wZa27h8+hDyTaxtEx6mARLtFnIRrPuxoUB+6w/M2nVqWpgx
         3S+ciEJ8lUgYCEjN09Uwt7xfsur7rUUsHKtkHaFeS8UaXudk5cpVyCQDI3xqhty5k665
         DVg7jaq3i3tqVXi+tCdWo804axaXHCQhM7wqf2aWC/6nMcpXsBufmKX3J/gL8JmtqCcC
         6Hq3Qxl/hv0+oJ4GLjRcFzim1QbJdfVwOGWaLnYJ0c5Y3nTJxxhdQE4Kqh7Vyjbo1DaV
         1Ea6QbV54HLRL9YpQpXP/dUNDXFN4/soZDxGveC7jnSb+4LlYb8uf6tA/Hbpz0Lf0nn2
         4Mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZ01/kVjxN4qO85F71R96OvGPb6wIX4duLA904XRBt0=;
        b=flNQ6Np57RT+E7WmfUKzerw5gjw+cueqpWrQaNDiRjtTcm48oDcbu3l7UGBu/YXBft
         Ap5Zr3qzIDBf2JOwzaB3k1EFSr8QhflSI543HC1p3YmbVDf4+gmetW/iErRENfgOYwsK
         pXdZofjkfcHkNZichXazbIme9zuTJiRdr3Tj8EXz+oSZoY61zcRPNORnY4S9TuhoCNt7
         AdVtunHBFtWs6GpyxdUr8oIrAlgafsxitsYBQBMsakDOvo9kQXUPD70kLSfAHxPANW/S
         Zn3ZjBB3UH1lX8/ZtLXRgE8zXFWMrA8WRYivBEzFilb9yIoDslX1+T0Jk7Dbne67kYAg
         RLeA==
X-Gm-Message-State: AOAM531oTa2hg/YxK8WoUJHE7/VA6oNFS2DRj6i5cl6QFVB0SZHcv7H4
        cybLammVQ+qhMc2Is64wbRzezXe2aVuMXmnxe0hj0ES68tWdkw==
X-Google-Smtp-Source: ABdhPJwuWNsB+X+8RleNTkUfobN0mJu2O1t+/HKXko5CgQZkOu4qHxK+7UF3rIDIOg4c0OeKfNIwiesKok3fCDh56ig=
X-Received: by 2002:ac2:51a2:: with SMTP id f2mr13179229lfk.685.1631025251259;
 Tue, 07 Sep 2021 07:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com> <20210903231154.25091-2-ricarkol@google.com>
In-Reply-To: <20210903231154.25091-2-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 09:34:00 -0500
Message-ID: <CAOQ_QsgBu07UmC7zZ-n07dqkg0Xp-AH=a8bmdF7nzt=ZO2j0=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch independent
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

On Fri, Sep 3, 2021 at 6:12 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need know
> what kind of exit they generate on a specific arch.  More specifically,
> there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
> host to know that the exit is ucall related, as get_ucall() already
> makes that check.
>
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)

Reviewed-by: Oliver Upton <oupton@google.com>
