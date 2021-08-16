Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2E3ED939
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhHPOwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhHPOv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 10:51:57 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10485C06179A
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:40:52 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r17-20020a0568302371b0290504f3f418fbso21144661oth.12
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpoj5iCTMpBtuveund1Jovu3PUExq8PlBdpO9R73f80=;
        b=YVYuCy9LxytZmlRmWxD/FobguJ0iwY+LPvBBS+sVoR605xB721guWfr3Y7SwfZgPKe
         em4hMCJu9FaulSQ9YuFrSe6QYIsAD9W6r+2HPkwcHAJwzyd1fqfqx5n+Y9N2mdJTHTPo
         GLZq5z6NMPAaktOqhSYPvaGJ4EoXMY7Hwx4F55zuDij0a2t9VEOPKv1IJAvNdyihn0gT
         u+bxgpI2GzlUSUz1wYPsfQfEynXGAo+pfm8vBV6lTnaki8tEHapEXf9zjoNHHDWa4hks
         1SprL91FYtafVyyRDoiOI+L266dPSQLBEVe5xJPa53od8G/OYO/z2558IRRjN+xSxdqq
         +B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpoj5iCTMpBtuveund1Jovu3PUExq8PlBdpO9R73f80=;
        b=p1/SK66mLGp0yzal83Xb7xIKVDtof7vmaPWvearUoG84bDIN7jBm3OdHcRImxk0+zE
         xb4Z0KveQVOaO3ckRTZtjRT7fVgLEQD/uxboxjOpNOjDV/UTdkmOK+OPtHviG43um4MJ
         jOXevv9tk9SgsqlzcJiYwHaaXysFOG/e52V6jjCmVB3BN6WTzBxoK+LDpTQbybTmyO0K
         Q6YpElvMOAeIW36Ib0NDoQuvwo/JedPBzF6BABP5lYU06dcT83jKlqdHRGWnPljCeIq4
         Sb325rsKR2WjP8/yUgW0zTJzajneMXe8Za956jp5hIxFZzP4R1IMSsBLMLDZGx7VcD19
         ppZQ==
X-Gm-Message-State: AOAM532Mu7xaa7SfbN3ipVhcUw/cgyg6b0o2JOJIUB3mdEl3lEfqLEwI
        lno9PXh/rsALd+A/3YWIV7qSMxFggu1CPd/Mt1BgpQ==
X-Google-Smtp-Source: ABdhPJxyKKgzhxJN7pyMLbR5MMwZdXIxe+IQZCEbPee8J8SnbX4cYeXlosNYMavu3g8MiSG0lqTaJXvU/pZhp+Zooa0=
X-Received: by 2002:a9d:309:: with SMTP id 9mr11338581otv.365.1629124851313;
 Mon, 16 Aug 2021 07:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-16-tabba@google.com>
 <20210812095938.GM5912@willie-the-truck>
In-Reply-To: <20210812095938.GM5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 16 Aug 2021 16:40:15 +0200
Message-ID: <CA+EHjTz8ct68cZEHU_x_oTNGJw=sffy9HcgQiNPVbwFy5M7dGA@mail.gmail.com>
Subject: Re: [PATCH v3 15/15] KVM: arm64: Restrict protected VM capabilities
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Aug 12, 2021 at 11:59 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:46PM +0100, Fuad Tabba wrote:
> > Restrict protected VM capabilities based on the
> > fixed-configuration for protected VMs.
> >
> > No functional change intended in current KVM-supported modes
> > (nVHE, VHE).
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_fixed_config.h | 10 ++++
> >  arch/arm64/kvm/arm.c                      | 63 ++++++++++++++++++++++-
> >  arch/arm64/kvm/pkvm.c                     | 30 +++++++++++
> >  3 files changed, 102 insertions(+), 1 deletion(-)
>
> This patch looks good to me, but I'd be inclined to add this to the user-ABI
> series given that it's really all user-facing and, without a functional
> kvm_vm_is_protected(), isn't serving much purpose.

Sure.
/fuad

> Cheers,
>
> Will
