Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD952E6C12
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 00:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgL1Wzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Dec 2020 17:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbgL1W0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 17:26:31 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76187C0613D6
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 14:25:51 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e2so6251490plt.12
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 14:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LPPX7+eFG3tyTSGve36jHrhtPlkDKhxHBmp1S2kH5ho=;
        b=IPmfLsLhg8QwTsq360DnlZ/77jDqDU0eCbhb6MUdO0bSP0xQ8TOuNE5zjFyRGo5FC5
         qAklkfWKJQENdYdzY4+iL6cKWdZZttSeTPzGtHYDOneDyDA75D/NSCYefg82KSRRmcvZ
         k7584wxsCoTCZioxKoUDcdDnn9wOyXPosljVkIZGpQ8/bHnprwHy8l6eoVv8Zw3vH+Fu
         rU3g+wrq0jhCjaNww0Tx7rDYNmrrWyf2A80ntRJmxOLUZtD59EncwczToKKqUwhlGlHp
         GYSZVj2oHo+xlJIzy0JJAQl0eZB7zR0KzwRIEuQQbwTD4sstD2QNsaH+LJBPRds1FOMz
         5mEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LPPX7+eFG3tyTSGve36jHrhtPlkDKhxHBmp1S2kH5ho=;
        b=VsUy7HROrRFr00L/GykOYK4wF8qkk/3ag1zBfYoQ3gkP2MIXruJ2IuD4TkdbS6zV2N
         SszPRF1gaV6KQQQo3WQDiJL4MQXWydT1Mx31RN096Az2DbhErg1r2dXrZs21VQ0SHrEp
         HqV/atiQuE9M/KQnp/sO0QrNC4Ch9XBTLPAxRkdrAPd3KAwqOP/MJI5ZzLcmEGAOfgFv
         6lAg3+B2gVjDFXeJvVnSKyowmS2Njsx2ZqKfNl3clZdtmKs0H98AO71v02l0UJon+J9e
         vPy72DMj0GA6wqoBIYeUgY7s+l5T88lnf78sz/td7jPBUhncXB1VehM+fCqObwtuWVEj
         0NJg==
X-Gm-Message-State: AOAM530OOp0A+VA1/qNw0Aqn84UTdXu32gYVwolGBXNfNngkArjCMUau
        IdBwElpbuivwrLh2nF0GAxcmDA==
X-Google-Smtp-Source: ABdhPJxbcUJ3cipsbcXcxcQQpynygi48+MTHoEbF5slhgQW0LakTLEWc3PPdmp1+wCE8l4U2HueOpw==
X-Received: by 2002:a17:902:fe07:b029:dc:43e4:fcbf with SMTP id g7-20020a170902fe07b02900dc43e4fcbfmr23478563plj.63.1609194350758;
        Mon, 28 Dec 2020 14:25:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g16sm35404479pfh.187.2020.12.28.14.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 14:25:50 -0800 (PST)
Date:   Mon, 28 Dec 2020 14:25:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <X+pbZ061gTIbM2Ef@google.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223010850.111882-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020, Paolo Bonzini wrote:
> This short series adds a generic stress test to KVM unit tests that runs a
> series of

Unintentional cliffhanger?

> The test could grow a lot more features, including:
> 
> - wrapping the stress test with a VMX or SVM veneer which would forward
>   or inject interrupts periodically
> 
> - test perf events
> 
> - do some work in the MSI handler, so that they have a chance
>   of overlapping
> 
> - use PV EOI
> 
> - play with TPR and self IPIs, similar to Windows DPCs.
> 
> The configuration of the test is set individually for each VCPU on
> the command line, for example:
> 
>    ./x86/run x86/chaos.flat -smp 2 \
>       -append 'invtlb=1,mem=12,hz=100  hz=250,edu=1,edu_hz=53,hlt' -device edu
> 
> runs a continuous INVLPG+write test on 1<<12 pages on CPU 0, interrupted
> by a 100 Hz timer tick; and keeps CPU 1 mostly idle except for 250 timer
> ticks and 53 edu device interrupts per second.

Maybe take the target cpu as part of the command line instead of implicitly
defining it via group position?  The "duplicate" hz=??? is confusing.  E.g.

    ./x86/run x86/chaos.flat -smp 2 \
      -append 'cpu=0,invtlb=1,mem=12,hz=100 cpu=1,hz=250,edu=1,edu_hz=53,hlt' -device edu

> For now, the test runs for an infinite time so it's not included in
> unittests.cfg.  Do you think this is worth including in kvm-unit-tests,

What's the motivation for this type of test?  What class of bugs can it find
that won't be found by existing kvm-unit-tests or simple boot tests?

> and if so are you interested in non-x86 versions of it?  Or should the
> code be as pluggable as possible to make it easier to port it?
