Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2152D1F22
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgLHAkl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 7 Dec 2020 19:40:41 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46321 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgLHAkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:40:41 -0500
Received: by mail-oi1-f196.google.com with SMTP id k2so17610844oic.13
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:40:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZU97K43zH8wKph27lvxide//f/pdlo67LflrXUbD6qc=;
        b=E6PLUbGiif2dwUkhA2hRpLxYruYhU4cbebRMauND53tNAt5NLLOz0DYwExGtDn31Dx
         kdgT8uNGoeOQ97rWyDLCLjIALV9M+6X0wefi2x9yJI2CBzLPz+UnmgBmjF0CzDCq85Ay
         4maPQlmUongRdJOU/Gk9KNR9Ox+N+N7lckPD22NrYdxTT90R2DmweTlhhOMPcVSplkav
         C4KZYyAvFTYaA7nw1rxpAGhVjhJYsyjz2hmjVPC/9va7G9yt5Gwmqd1BdljthEuO0WCo
         27j8/ag+k9lgWLAK6U/U2D10JrQC1kvsQ2UTc+Siqaj19DoxKfVCEozsxuGTGB6rqhyU
         OfjQ==
X-Gm-Message-State: AOAM5325QFN7r/rstf6NPPIIHPswdTmSUCHSgUOaWVp77h5sqPMNxFGd
        //yfg5o1NW/JmJYFzRgL4B2sTuV5DLwVvxzZ81k=
X-Google-Smtp-Source: ABdhPJwxMbRNLHPWrqhtnT+KlPLf5OQKn376srQQ4W9M2lNVi9btamGPT5Tkk2mvb/ryHjn8e6Z4rhgWZR6I7ozDsHE=
X-Received: by 2002:aca:ea46:: with SMTP id i67mr991531oih.175.1607388000708;
 Mon, 07 Dec 2020 16:40:00 -0800 (PST)
MIME-Version: 1.0
References: <20201208003702.4088927-1-f4bug@amsat.org>
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Tue, 8 Dec 2020 01:39:49 +0100
Message-ID: <CAAdtpL69-8DEYb2832fcZosNjMogPGt1a9HNT7NdLVvnbKZBFQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] target/mips: Convert MSA ASE to decodetree
To:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 8, 2020 at 1:37 AM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>
> Finally, we use decodetree with the MIPS target.
>
> Starting easy with the MSA ASE. 2700+ lines extracted
> from helper.h and translate.c, now built as an new
> object: mod-msa_translate.o.
>
> While the diff stat is positive by 86 lines, we actually
> (re)moved code, but added (C) notices.
>
> The most interesting patches are the 2 last ones.
>
> Please review,

I forgot to mention, only 4/17 patches miss review!
- 11, 14, 16, 17

>
> Phil.
