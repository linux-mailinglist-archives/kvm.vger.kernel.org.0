Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44A4467795
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 13:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357558AbhLCMpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 07:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhLCMph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 07:45:37 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D81BC06174A
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 04:42:13 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so2120279wmd.1
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 04:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVxUZTA48fwXv3Wn0ogrdcDO6KHcU9G34XXI6zScy3k=;
        b=pSqANDTUS3mKwQ6erhSvkVg4ZEzzkjyx+o3qZM3kCJr6TXy6uSTMHytzkn8bhUEvx4
         XQwRoPPkfjinuY/islUOD3oiw2SyCV3KkYZ+oHW6fvNXE/ezyPRJi5iYF2Kua5YH4t2L
         ixSc5TBrsBBPoqlTPlP1vseZmWtoHoUeMLbrkq08K9yYzmaS3H4xKb80J3g9ClxIBtFX
         WUEW8RKqBFUyPDqwP5a7t9VQt1BH2RCRpYkY5MqroIarMhYnV6Iswzx31MuIQhGYWAA6
         H9IRXX2re7Smr0pYsZ0bhFWOX7CkJ8QzQUFiHGuaoWj3hn4ftpGEv8bxV9WI+YX3vTiz
         57EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVxUZTA48fwXv3Wn0ogrdcDO6KHcU9G34XXI6zScy3k=;
        b=dVnBm3xrqayfJo4GnOcbA2n8sxG52MI5U5ALvlSjCK1HHVUNt25b2aVkM1YYFly4zt
         893jncqrFhbc58C8vpzO5p7VTosPeULqDQ0nGSmBlPpqTuml40FjjFCoqbVAzhthJHk2
         I9lC8NxNK3GCqlTebbBKJ67DQnf09Wq2VGGZPx2GxnoPXUGrNHsojRh/a62W3gRVV/UK
         b7cNJBWpsm6YipKcVomStTnvWhuHuN2ba69eSiMvuyogcIdZ1fDYqqyV+cLybB5yvBeX
         Fftq+PpX7Sh/i5T7fKvmtzObgu/YgIzL+mPpNNUFG6+e51OSAlrIIWH2VA96l/03XLy6
         IxpA==
X-Gm-Message-State: AOAM533NIIKZn8urkyur1HQ0Y5T5v9yjp80LsR1gxarDVBiN9J8WxsPe
        ZJxjpL9eXXctq1nzCoiMWYgZZrqTFMfdO2jRar8VDiMGyaI=
X-Google-Smtp-Source: ABdhPJy4KJ4UCDPG+oIVWlnscWS/tdV/WYUTDmpki1SQxXs5uGRrTAY9O/eZUHIboP0pxfWDG141mtM0NwWazl+Dk1A=
X-Received: by 2002:a7b:c194:: with SMTP id y20mr15092030wmi.61.1638535331744;
 Fri, 03 Dec 2021 04:42:11 -0800 (PST)
MIME-Version: 1.0
References: <20211202235823.1926970-1-atishp@atishpatra.org>
In-Reply-To: <20211202235823.1926970-1-atishp@atishpatra.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 18:11:59 +0530
Message-ID: <CAAhSdy3jvmSUBjVm+YP3PBqRt50UUmq9ci68f7gZdOfXCoBQjA@mail.gmail.com>
Subject: Re: [PATCH v3] MAINTAINERS: Update Atish's email address
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

On Fri, Dec 3, 2021 at 5:29 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> I am no longer employed by western digital. Update my email address to
> personal one and add entries to .mailmap as well.
>
> Signed-off-by: Atish Patra <atishp@atishpatra.org>

I have queued this for 5.17

Thanks,
Anup

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index 6277bb27b4bf..23f6b0a60adf 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -50,6 +50,7 @@ Archit Taneja <archit@ti.com>
>  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
>  Arnaud Patard <arnaud.patard@rtp-net.org>
>  Arnd Bergmann <arnd@arndb.de>
> +Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com> <atishp@rivosinc.com>
>  Axel Dyks <xl@xlsigned.net>
>  Axel Lin <axel.lin@gmail.com>
>  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5250298d2817..6c2a34da0314 100644
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
