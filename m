Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49B02DA19F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 21:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502973AbgLNUdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 15:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730664AbgLNUdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 15:33:17 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF8C0613D3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 12:32:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b73so18577377edf.13
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 12:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dL+FX27CWyxfNf4jnRkDrpoSvi4kN+gTOTXY6v/WGZQ=;
        b=d+70UQQK/FEZRFZ4aziyun4uSX+TiC6SLwNxk8yUPoYb9iKvPcNTL+NVTFsIJHtQtH
         MMiJr0wYvYjEcfrEJ4SUkphD2x8h+T170+OoCETDedJrdehdbKWLFUwAQa4+J3/NDQZu
         HLzAfPNNWiebzE26zll4Opdalrt2WZyM8J/NBBAKLqcKL1HxwLHU4sT4kkgIFBfmxSCk
         e3H3PwIhEfoNAymiV0vR5anral/1ljwNdDFGMuNvUNqRDJzo0YEtgQBNWQYUJt/cGuH5
         PRz5//Z1iqDKwAuvqSN9JHPyXkYNik131NRc9GPzyJj9OF+5ezawsldM2CXg1qRT3kAl
         SYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dL+FX27CWyxfNf4jnRkDrpoSvi4kN+gTOTXY6v/WGZQ=;
        b=Mttwws64MMLmR39muhNC6AYT5qo4RT0H0ijLPoonY8S2aVnL2xnjoyCGRSukFZLfUJ
         WzOHRcS4BcHKbdrZNlOKkWSPiLNFnDSIJjbacFPq1udu1D49zQrQGcCDOpTpH3DZt/7H
         UJ7OvtSEfFGBEJcNaIg2sDNvBbIW1TZl3r4S/eRf1/980Y+923kiTRHKUH8UVOEgINok
         NqCivtpWzShwXiV9DCv2KTWQJyoHZA1C0REsw2uPq5vpMCuEGwwebNoZ9Zoh3GvXV6vu
         VQwy0i8uuoDdG1gudQXcA3k6kiSu32r0OPtND0J1BAHeoRoOLxaF/0z/9qWeFCVyGMnu
         VQqw==
X-Gm-Message-State: AOAM530RnPEl+MWwIBaP7A+j5WTC8/bAtf/6MF7kGHPIQj1/H8raA46S
        /cCcJV6lTBVosXfx/pAG9vrtMTCESlm2jEq/KHPdJBGGzGQ=
X-Google-Smtp-Source: ABdhPJx2mkqZe7+/+KxctWS4qfpsXWuGuqgYUad4xPvBbhJHCxRUWKv3FIkgQHhzSsNIqvC2g1QwKAY8fN1sdBUJjig=
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr11781440edv.100.1607977956133;
 Mon, 14 Dec 2020 12:32:36 -0800 (PST)
MIME-Version: 1.0
References: <20201213201946.236123-1-f4bug@amsat.org>
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 14 Dec 2020 20:32:25 +0000
Message-ID: <CAFEAcA-88QL4o6V2k8c+rQspYHWtpzwBFTtY-288h1LSNd3cuA@mail.gmail.com>
Subject: Re: [PULL 00/26] MIPS patches for 2020-12-13
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 13 Dec 2020 at 20:22, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>=
 wrote:
>
> The following changes since commit ad717e6da3852b5729217d7938eecdb81c5461=
14:
>
>   Merge remote-tracking branch 'remotes/kevin/tags/for-upstream' into sta=
ging (2020-12-12 00:20:46 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/philmd/qemu.git tags/mips-20201213
>
> for you to fetch changes up to 3533ee301c46620fd5699cb97f2d4bd194fe0c24:
>
>   target/mips: Use FloatRoundMode enum for FCR31 modes conversion (2020-1=
2-13 20:27:11 +0100)
>
> ----------------------------------------------------------------
> MIPS patches queue
>
> . Allow executing MSA instructions on Loongson-3A4000
> . Update Huacai Chen email address
> . Various cleanups:
>   - unused headers removal
>   - use definitions instead of magic values
>   - remove dead code
>   - avoid calling unused code
> . Various code movements
>
> CI jobs results:
>   https://gitlab.com/philmd/qemu/-/pipelines/229120169
>   https://cirrus-ci.com/build/4857731557359616



Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/6.0
for any user-visible changes.

-- PMM
