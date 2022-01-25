Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7649BF76
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiAYXRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiAYXRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:17:22 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8EEC06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:17:21 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id y15so51415253lfa.9
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YtUJOIVUVyr4f1l6cRqLxBgKFqFPTA4iWINRxQYFF4=;
        b=pmlStOsQ9OHYg3MMBurxouxuhOyLGaDskUW38lmmVIEb2KwMM6WBWnd6wVLpOMgV5Y
         EQSHpTO+gYwfENYMytSs9mvV4720JAz0lyON7JPnjkjwbX9K+5dcROLrzrkZx5bAwlE7
         EUMDzdJHBbufppt8gDrT/7PefoeaHO12a8OZ1PITr9F8iirRmDL1lLOxFhlz6OKCeIQg
         PWma1o8UrS6JQxZAme25nrsyIaeNOOsmFoLi0PRu7tCLa/tekgwwlit9UcpLlnb2xWKQ
         +XxHjHmygumkL3QQG5Dprw/VD2xhq2iM1DZLaVZoRhkT/AqtGmwXJ8pLFVWVjTrxfv7e
         ggLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YtUJOIVUVyr4f1l6cRqLxBgKFqFPTA4iWINRxQYFF4=;
        b=XyS1I4r+VwB3AzKDguq+VQU8/pG2AZ6roYhLfNrVDs4M6eoGoj02Z4E/2XhUuwLEPC
         ZbSs0XOM7PFeBZahwDs+AMLx95SQjz6Dmkl90+oLkPJL9o7z8Q/Wl2eOaVWS8s+FUq5o
         K41hBZTcsLk1e/KWtD72yGaAixzQb5wx/2Hz7uYJugHcMwsp7mFMt5eIqofoZzz6Tqum
         M6W995EzLJmMeTvrhNf/YbZxD933RAgRWZraGzeTpEpeMyu2/V+CstJaIho8zNPCaAjT
         XwQn3/VeeHwX9WDBplDQJ5mYDmyD9/ti0CWeFFtH2Ly8m3OCS+AjinMD66vG73x7GcA/
         zD/Q==
X-Gm-Message-State: AOAM533AHcNEU1s+bfLUx69sL+RCJaQpysgFl+0LVu5F9inJ5wONIxxq
        uznxaU3fzhxx0dpmCh5regBc/vcj0aJkJtbHkUxI1BDhzyA=
X-Google-Smtp-Source: ABdhPJwN6hJGl42AS8tyiP5I8VCLlWrgRA4oULFojR1qhPOy7TC0RxMF/ghHxpHRzynyg8/QiJB3VuSpoQjsgJrSDoE=
X-Received: by 2002:a05:6512:110a:: with SMTP id l10mr18637634lfg.235.1643152639776;
 Tue, 25 Jan 2022 15:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20220125230518.1697048-1-dmatlack@google.com>
In-Reply-To: <20220125230518.1697048-1-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 25 Jan 2022 15:16:53 -0800
Message-ID: <CALzav=f9EongPybjOpm8Lv_vHnBpk8DF3DUCkxz7NpxMR5vx4g@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: x86/mmu: Clean up {Host,MMU}-writable
 documentation and validation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 25, 2022 at 3:05 PM David Matlack <dmatlack@google.com> wrote:
>
> This series cleans up some documentation and WARNings related to
> MMU-writable and Host-writable bits based on suggestions from Sean on
> another patch [1].
>
> [1] https://lore.kernel.org/kvm/YeH5QlwgGcpStZyp@google.com/
>
> David Matlack (5):
>   KVM: x86/mmu: Move SPTE writable invariant checks to a helper function
>   KVM: x86/mmu: Check SPTE writable invariants when setting leaf SPTEs
>   KVM: x86/mmu: Move is_writable_pte() to spte.h
>   KVM: x86/mmu: Rename DEFAULT_SPTE_MMU_WRITEABLE to
>     DEFAULT_SPTE_MMU_WRITABLE
>   KVM: x86/mmu: Consolidate comments about {Host,MMU}-writable

The email threading on this series got a bit messed up (at least on
lore). I had a misspelling in the signed-off-by tag in patch 4 that
was caught by git-send-email after sending the cover letter and
patches 1-3. So I fixed it and sent patch 4 and 5 separately.

I can resend the series again if anyone prefers.

>
>  arch/x86/kvm/mmu.h         |  38 -------------
>  arch/x86/kvm/mmu/mmu.c     |  11 ++--
>  arch/x86/kvm/mmu/spte.c    |  13 +----
>  arch/x86/kvm/mmu/spte.h    | 113 +++++++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/tdp_mmu.c |   3 +
>  5 files changed, 93 insertions(+), 85 deletions(-)
>
>
> base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>
