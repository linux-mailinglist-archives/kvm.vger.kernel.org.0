Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526C4466001
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 09:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356337AbhLBI4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 03:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbhLBIz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 03:55:57 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB2DC0617A2
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 00:50:41 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so1757585wme.0
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 00:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=es9/Tr6MB1CFpBQoW+wl/y/nUnYLARczzVgZp7MOScI=;
        b=trU/HvMQ7/qXEGbT8w2fuzq/IzVhjJo+jv5NUg97R9B4KBq+JW0d+bzZ1KJjEAK6ZM
         ax5M3PsJWAjI2vzfu2sMLO7qV3P7qSDDAnL6vv1rwo5uyk70CxUE8yApTF8fNO+oz4AY
         C23hGwNotMUxbk8vGAWP2Vt/C9uakdv/pllQwixjZ2MmtQ8tLGPkYOhcipT1zc2UZYX5
         tKBp/C1S/izliKNLO9oHECStzQONlfh5uNBKeGqQYQK18XBOfAJJfJNOo9VmEAnPE9iD
         nWHDSSVC2V9hDPoUdLi26pGumLWISp1H08yXOuPpQAu8w2W8DddVx3y/uTxUQGsBO4ZJ
         w4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=es9/Tr6MB1CFpBQoW+wl/y/nUnYLARczzVgZp7MOScI=;
        b=N0bCG4nT9foEypv2mLtZ3DP5wobKCqFPkxUmjP4632XDJZY3dK8yk66M3YWzk/1lkK
         +iOw4tSg8it0bYUH6jIk25+do1/xaztkWO1rjq+ZHyMOb9Kash9Ccgk/kXUNXWFSzMTm
         25mrNtOJ/yuf2/ulFZpHlQbrLToTb9Ity9NxMAZoqwWPCPYBUGwmyTbN/RtNwrAd5ZCs
         lTkeEEIKF6hpqtGyyTFquBa6zDzQXGU+QfGnVkmkRn0BTxmyggTgV/ipXrrFFjtPWgmT
         00370HxI0gwxfDtL5sUHrxeOGl2EPvUu4oO9xujfSVozjvRZRv6MtY7JeVaNFNmWXmQV
         UWsA==
X-Gm-Message-State: AOAM533218zgEFYtf2DEOTDdg7Xz6SZ9d8GCloabwWo8C4afxbDcSsY7
        xEget2Zg0yv+6kz7JapY19kLHiXmPLRMYLaguybQl02l86iUc2Vm
X-Google-Smtp-Source: ABdhPJxJlghneRv8O/VzzShZ0fGp35zLfia3JcnzpVsZAO4FM0BD2ejTpkwZZafmtDg20KSSZI+Y6E7Ul+5Cdpiffks=
X-Received: by 2002:a7b:c256:: with SMTP id b22mr4687630wmj.176.1638435039573;
 Thu, 02 Dec 2021 00:50:39 -0800 (PST)
MIME-Version: 1.0
References: <20211126193111.559874-1-atishp@atishpatra.org>
In-Reply-To: <20211126193111.559874-1-atishp@atishpatra.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Dec 2021 14:20:28 +0530
Message-ID: <CAAhSdy0bKWCBT+b1w1Z5YO+Vq8xYgyYQoR8yvPK2SuK=VXwWXw@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update Atish's email address
To:     Atish Patra <atishp@atishpatra.org>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 1:01 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> I am no longer employed by western digital. Update my email address to
> personal one and add entries to .mailmap as well.
>
> Signed-off-by: Atish Patra <atishp@atishpatra.org>
> ---
>  .mailmap    | 3 +++
>  MAINTAINERS | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index 14314e3c5d5e..5878de9783e4 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -50,6 +50,9 @@ Archit Taneja <archit@ti.com>
>  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
>  Arnaud Patard <arnaud.patard@rtp-net.org>
>  Arnd Bergmann <arnd@arndb.de>
> +Atish Patra <atish.patra@wdc.com>
> +Atish Patra <atishp@atishpatra.org>
> +Atish Patra <atishp@rivosinc.com>

I think you just need one-line entry to map WDC email (OLD) to
Personal/Rivos email (NEW)

Something like:
Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com>

Regards,
Anup

>  Axel Dyks <xl@xlsigned.net>
>  Axel Lin <axel.lin@gmail.com>
>  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a2345ce8521..b22af4edcd08 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10434,7 +10434,7 @@ F:      arch/powerpc/kvm/
>
>  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
>  M:     Anup Patel <anup.patel@wdc.com>
> -R:     Atish Patra <atish.patra@wdc.com>
> +R:     Atish Patra <atishp@atishpatra.org>
>  L:     kvm@vger.kernel.org
>  L:     kvm-riscv@lists.infradead.org
>  L:     linux-riscv@lists.infradead.org
> --
> 2.33.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
