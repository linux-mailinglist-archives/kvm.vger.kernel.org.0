Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C553B9236
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhGAN1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbhGAN1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:27:23 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0453AC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 06:24:53 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u11so7284043oiv.1
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jUbeSTVKF0eUVIxWOIFcB+k8q041q6JOmxNQFfd2nRM=;
        b=ve5mzz3EVO7csAUwWqbABT4cpkH0EFBLclPV5PKkCEWgc73uj9gJqNeWpwcGNNeQus
         M+P39JbVjU1UNyPKEzXRThlj/2T2/6b8hJqbKH4eu2Hyk3NZOcKakDwYtDpTZ+tIZPYC
         XIayF62YAfk77CPjsmyH5rDCHdfoCpItxhGVs8Xx4kw1d39o7VwDYBVY2z7kRx/73sJi
         CoYXQewAF/PMrG1sGbfxwvXsOmClfIXoCSaWTvHJt2x/YQ6IdoWfx79BT5BGpERIEDn7
         LVEdzviRyzOdxS4zWqwnDdrLULbz94/uFD510jFVNsBvycxJ79mdNtNPf2/tSSPpn4bN
         HZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUbeSTVKF0eUVIxWOIFcB+k8q041q6JOmxNQFfd2nRM=;
        b=C7m+mjM2yLczExvo4TXu3OGhuVqGy7jmVjXKlT+RNb3L3aKt6e0GFy8XBMzSVPmm+j
         l0Mv+59X3BAaetv8q5pXF+kLp1Xz543skwUEw7JFCg043AUSM57IHv4j2ZglMpz8alYY
         wKcRXzc6wdstBRJYPX/rb0KGHB+Md7O6p7D9IR5qx+kAqqscufcX/NkzrBfCm8T1ropG
         fqRbyfBxt640xLNH2ggDMYMUhbWCBU+T4ijwTg5kje7QTZrLvAHxyfQ4D6DV3MEEECkG
         tXEuAdf+33VOlQnuRSuAmKSU+Xpjde0kgCh483zYWa8OHWmOJhINfd8TVUCtmtq42HXT
         8ZUg==
X-Gm-Message-State: AOAM532gM4DoHcF9/F54w+tA6Jsv07CaUxy4Ux2AXOvkZjhKNObX7IbB
        kUGreQ2PB3VVqo25E9kfgp7TTHoxyjU9wPBzBrCOLw==
X-Google-Smtp-Source: ABdhPJz/fEAi1Npbkk/8h0gLjtrPsO9U1jtbHI69/yfBMeX5BV7f0u+BJgIQAi4kuMbjo5qGtIwZ/ER3pvIx+Rntwio=
X-Received: by 2002:a54:408b:: with SMTP id i11mr1266746oii.67.1625145892215;
 Thu, 01 Jul 2021 06:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-2-tabba@google.com>
 <20210701125558.GB9757@willie-the-truck>
In-Reply-To: <20210701125558.GB9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 14:24:16 +0100
Message-ID: <CA+EHjTwWggSopafNcftkPbhfD+aPC7UOtLJjSxm9Td4M9Az-5w@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in comments
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

On Thu, Jul 1, 2021 at 1:56 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:38PM +0100, Fuad Tabba wrote:
> > Editing this file later, and my editor always cleans up trailing
> > whitespace. Removing it earler for clearer future patches.
>
> s/earler/earlier/

Will fix this.

> Although the commit message is probably better as:
>
>   "Remove trailing whitespace from comment in trap_dbgauthstatus_el1()."

Will change the commit message.

Thanks,
/fuad

> Will
