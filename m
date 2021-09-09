Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A0A4043B7
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbhIICsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 22:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhIICsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 22:48:53 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2533C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 19:47:44 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x27so684667lfu.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 19:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZuJyqgIQ3oQtgMoTdVtSIrlc/hlmnNYpLQyvIq2xfg=;
        b=VZXmr2CtnEu1xnlQB4sj2Toq9NyQnwr3mAwinwc9e8osCTTaXFE+U4Fud4LA4LQwHL
         tKIq+ogy26qQ/8sq5IHh1IZf4M4UAzkPAVyKYHJor1xFMGUQVY8Gu3C67tp1bAAGmALc
         1vk19c5020uz/heFydrcvHLZ7iJAhJqPZCCH9/lxWmAtmgqVSUAsGQzpDbEXNU/rp8Eo
         ftURTDAMe4WoRh6lSolAyHoT2Uz9IwQvq4w1ttJUdRzg234sqSsL8cps/95yAkAPqClc
         M/+o+mVAN9ae1EQE0dH6Jjidt6164K1TboKNNsnUWx9A4aZu6ESEx2imAPJDnA6rVaUp
         QZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZuJyqgIQ3oQtgMoTdVtSIrlc/hlmnNYpLQyvIq2xfg=;
        b=OG84sUxZ68LmydQy6tR4VaNt1qSJQ83rf9RvNjlGYT5PD6QetLQM/Kh04M008dTE4k
         kpDGA6P4f6ElEjlluAAHcrY9EHd9ygZqHUM76fjVbySti8xPqzs/IwokL+tvxozOiixk
         xvOy2KEPOrPLKpFWZlwD/iXDI4gAlMMg6hT5HovWAN1GVUkg29lRXCNK64yHJoWi0HyY
         Da3S3MLr3wkxR8iw8STgiryPxKxBZhMiF0fXgTUAknymmN5zAAIUib/bjwtLuJJmdM/V
         HphuaBoFhlhNlMIowfdA+vRn5ig/ABfiGyTeCpR909IPYVnKlvYFqv9njn/9iEtdm3ab
         3L8w==
X-Gm-Message-State: AOAM531xoAFF6XrSP7IjivlR9gfIUNnbmigtltwaA7WCj1P8gusT3Rkg
        bZhOYqPgb0aqFx338LOBTjtU1xRCswK5BAgArKD0dQ==
X-Google-Smtp-Source: ABdhPJwf+kTCeI6PWF0qQnERCUUUEE8rZRrAMp2Rah12EYfVEJ+5BQho5Hay73HyIRWt9EKzJwn1d+yIQ9o2ln5e0jc=
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr626886lfg.150.1631155662626;
 Wed, 08 Sep 2021 19:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-3-rananta@google.com>
In-Reply-To: <20210909013818.1191270-3-rananta@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 8 Sep 2021 22:47:31 -0400
Message-ID: <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Wed, Sep 8, 2021 at 9:38 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into selftests to make use of all the standard
> register definitions in consistence with the kernel.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
>  1 file changed, 1278 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

This belongs in tools/arch/arm64/include/asm/sysreg.h, I believe.
