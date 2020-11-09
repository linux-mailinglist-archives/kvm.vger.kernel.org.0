Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12DA2AC194
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgKIQ6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 11:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbgKIQ6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 11:58:15 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52BDC0613CF
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 08:58:14 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so13286455ejy.6
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 08:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOt/gT3X6afDbABIuluTudyxpyVUaGa90v//OVlTKZA=;
        b=uDYVGUhzWefT4TCmJ1X1gwr1wSyM/3n7eY7ykMduUug+kyduqLkpf/9Yon7Nbnd4lK
         1BoJ8DNHSeQvM6IFTKbw68+VeGF+G2yfjjy2uWIn2la7ff4J23nc5OIGxrI0yOi+5mQq
         hfWyXmXpj22SKJ3/yGIrmvaWm/9o4gZ12pZk5E7FRdizLp1fu802xCfuqyZLiWlVJ0x5
         iPlr0AwIz9auKdgMIcdTe1KZGBOaFpYjVyhGZlCWUDSK75qmitA5224603XsawK1JGIj
         J26txQ0slcCKSmCQ2rcJz8mIo7hGKeKjboBeMDQBsJNxpRWOd5owxUHwQVEoXIQH0BDi
         8yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOt/gT3X6afDbABIuluTudyxpyVUaGa90v//OVlTKZA=;
        b=qribXk3qXVV3VosHqtEywLtSr5lxHv6kVRXqmfigQdKP2EKvoXnzwwE6VODRcCMkMm
         sRgo18tw1OK10/g0VXPChYZH8+ghkI0xcGg3cCdH0LipsGaqb8nPoUyulu7W0QsZPdGq
         r6+Np9akQ0SkIYppzakGOr8f6hyxTfPtWUKrI9LGqAE2B9M/7LLytE79Af6HGFN7phDc
         8bQKcJqiNPilUovY4wkjLweYeRdh0vq4XnySBsBiULLacuI7jm2SWYq+XulXNlbev8F+
         6HIQ2cdPZ3m7XEj2ZPSxoYUnUvrDK6HBaULmwIs4Xs6hK5aZdz5C3qggx34GD/FwNoFe
         D75g==
X-Gm-Message-State: AOAM533cHiTCUw8dKByj52Q9hOMfnIqTv1NYWgHXF4wBW+q2ZTDLWzW5
        TtJj8EnXlelTy7z28Q65KEbzN7X7T9AVJ3gosSXh5A==
X-Google-Smtp-Source: ABdhPJxZ3gGhf8hr4A2p5sdoBteBD0JPFvxaOIyyfPM/ggIzmDFWbeXEKf5aXDQxuKta9Rhe7Qee+0XyD/DP/Q2LY3k=
X-Received: by 2002:a17:906:80ca:: with SMTP id a10mr15333647ejx.351.1604941093417;
 Mon, 09 Nov 2020 08:58:13 -0800 (PST)
MIME-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com> <20201012194716.3950330-5-aaronlewis@google.com>
In-Reply-To: <20201012194716.3950330-5-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 9 Nov 2020 08:58:02 -0800
Message-ID: <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 12:47 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add a selftest to test that when the ioctl KVM_X86_SET_MSR_FILTER is
> called with an MSR list, those MSRs exit to userspace.
>
> This test uses 3 MSRs to test this:
>   1. MSR_IA32_XSS, an MSR the kernel knows about.
>   2. MSR_IA32_FLUSH_CMD, an MSR the kernel does not know about.
>   3. MSR_NON_EXISTENT, an MSR invented in this test for the purposes of
>      passing a fake MSR from the guest to userspace.  KVM just acts as a
>      pass through.
>
> Userspace is also able to inject a #GP.  This is demonstrated when
> MSR_IA32_XSS and MSR_IA32_FLUSH_CMD are misused in the test.  When this
> happens a #GP is initiated in userspace to be thrown in the guest which is
> handled gracefully by the exception handling framework introduced earlier
> in this series.
>
> Tests for the generic instruction emulator were also added.  For this to
> work the module parameter kvm.force_emulation_prefix=1 has to be enabled.
> If it isn't enabled the tests will be skipped.
>
> A test was also added to ensure the MSR permission bitmap is being set
> correctly by executing reads and writes of MSR_FS_BASE and MSR_GS_BASE
> in the guest while alternating which MSR userspace should intercept.  If
> the permission bitmap is being set correctly only one of the MSRs should
> be coming through at a time, and the guest should be able to read and
> write the other one directly.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
>  .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
>  4 files changed, 564 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
>

It looks like the rest of this patchset has been accepted upstream.
Is this one okay to be taken too?
