Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2B149450B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345520AbiATAsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345135AbiATAsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:48:01 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431DEC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:48:01 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id g205so7071976oif.5
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65W4ISOreiMaubAQGfbFxUxUhxYaKcf9cKVcpuO6a1c=;
        b=quv0otCaNprBJ5jmxSX7G2Te+yOMnPVlYTkSJ6BE28qqz4H1ecU3wLddhz7RJs4VjH
         OfAI2HaErZAOTOAyD1uwUvZWD6h4Xto++u1iNXzETxk6P4xYEyzb0lYuY0u/GvsnXGOz
         q84llNadcN6jgBgifaSOL8niAgm5sUMZHhdi5S94XlXwYFnB5ngNa8X0dzowPOsiW+o8
         LYX5uydN2bsWvCeAlslUK5GNFXiu5aCEgFhsMsyPdG25lVq3DIr3bNOd/N5VYeLlejTb
         LkUKZKxgNaI0kc6vp5h3oxKjb30ivGWL9HRGrFaQYrohFmVYmAKnfoZ3bmAykgHNyCeu
         YN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65W4ISOreiMaubAQGfbFxUxUhxYaKcf9cKVcpuO6a1c=;
        b=s/AntqxSXvAj3UoouyQClnUt3Y7ZDeoacZ2sNOHrxWmVlBZBR5qoSNR8nngO7csdT5
         oB1CREGQVVCydW2frs0guGyFoARpTpxOIuNDgEXazqOx/RsGSiFXkGE3np/gPyp3icR2
         4KSCwexFq7Or5YsyHZETXXSsJRgKUo9Vx807vuf4rycdBPUQVYzIKvo/10exQwUuNmSl
         g2P9DrDi09FrelgzkmYtHlb8aP7rXVBzrxNmxFwp6LgzyV1DtaGhi5eyqV4fCLBFuVgg
         1PBpEntzGPLp5i6qL4opRzo7r8VedqFfq4PAa5jut6S18qmvjmJugBI7sCzkB1uzmPlj
         VL2g==
X-Gm-Message-State: AOAM530vXjEuJ7uN7kZ2oTAyZ7ZNquTywOPVAiIkTeuaqC2Kq23PpodE
        AJHasUGWPSqOs5s14r49XU3OQsBu30D0lMCqvcIT5A==
X-Google-Smtp-Source: ABdhPJzk7z54PFEORH9fNtFlCKfBLKLIakFOu27fEJeTN2u8LjhM/wr+tAJZ0tt38ealUz2INDqwkAIIGukF8ZWKxs8=
X-Received: by 2002:a05:6808:14ce:: with SMTP id f14mr5643354oiw.76.1642639680390;
 Wed, 19 Jan 2022 16:48:00 -0800 (PST)
MIME-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com> <20220120002923.668708-8-seanjc@google.com>
In-Reply-To: <20220120002923.668708-8-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Jan 2022 16:47:49 -0800
Message-ID: <CALMp9eSq4M3fDXGeqmnfxRHWm_7CuJmgqxHSQ+H1Sj_hs7J94A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86/debug: Explicitly write DR6 in the
 H/W watchpoint + DR6.BS sub-test
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 4:30 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Explicitly set DR6.BS for the sub-test that verifies DR6.BS isn't cleared
> when a data breakpoint (a.k.a. H/W watchpoint) #DB occurs.  Relying on
> the single-step #DB tests to leave DR6 is all kinds of mean.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
