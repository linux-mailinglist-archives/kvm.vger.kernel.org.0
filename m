Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC34DF400
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfJURRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 13:17:50 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40531 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJURRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 13:17:49 -0400
Received: by mail-il1-f195.google.com with SMTP id d83so4261793ilk.7
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHKfeAwGleWUvW3TH8Rpk+gmKcgnSAmay+S+L34gSYQ=;
        b=Rjr7n/z3ClaaaFMlgVVUGM701m0nseu/P77vEQi2S8PpUUq0ABnPNpqutNp9LbLYF/
         TwpyhJD3749gmHLEHQcGw6t0GAD2XII7XVoZpyyto5hyPhUPmDnjOre03sGxEDRqNamz
         uqFll2rufr7NhZBRenGDbigbhJe8u43nwa2e0r2sRh7DTFQVm4sVW6biTl/AKiuuIYLg
         6FLyRm164DOT7mcSTyP7IYdajFhHY8sDFtCUC73nS3exi7TOpX8+cuG2kktGH01nJtqu
         7PP0OCsHwwEyKnpGjKeR3w4i/Bk1FZB16saBTelZeEBlGgkB7AHMwvanW9Iqc6RzlPxJ
         C0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHKfeAwGleWUvW3TH8Rpk+gmKcgnSAmay+S+L34gSYQ=;
        b=VmCkDJd53PFmfzFqCmQkz932IhW5xIMi3N993Kb7iw2DYpZFbIhv7X+FE/fuPDO6Yu
         GMPoqSXZw8CEZEtpibqc2ca5kBydLJvuR2whbjoUKEFSEuj9JZdbk6c1SenhasxQrZOh
         3M9aLGsf353j404h0zqpQK23ZpcZRWVvO7JUnw97QU/bKCuZI7/APXF7Mggo5E9fEqHi
         oXUVIDBJ28JJx2uiuTW+lD+tGOwRCmrKLeL/XHx54nRrfQsM2ZhD0LyEpUPCnieaeFp4
         ZtrPwwwu4He4bN2+bQG0aN5zDtl1QpB4EB4evLIB0GQAwTHue1scC33eAjsGAuElL1in
         lxUg==
X-Gm-Message-State: APjAAAX/EL5janW6uRya92Fs/Qgt9d21/xN0TT4u398rAVreLX2URF7i
        EnzjgE9XwDgEcyAiO67/kPgWe+ykW5+blQmsgWIFxUwP
X-Google-Smtp-Source: APXvYqyzm/YbIIJIlN5CZ05RaC3XR/qKrUb0q7pJCbCTNUo6UN5fMiI+bgn8UrkhErKGf+gGHOxDoeKdSpAxmBR5erk=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr27296229ilq.296.1571678268885;
 Mon, 21 Oct 2019 10:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191021170733.16876-1-pbonzini@redhat.com>
In-Reply-To: <20191021170733.16876-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Oct 2019 10:17:37 -0700
Message-ID: <CALMp9eQCDksL2uRG4OZOG2Bhyvjp2GMxuxxnr+gjbp1JCWQG8g@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] x86: realmode: use ARRAY_SIZE in test_long_jmp
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 10:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Make the code a little bit more robust and self-explanatory.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/realmode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/realmode.c b/x86/realmode.c
> index a1df515..5dbc2aa 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -606,7 +606,7 @@ static void test_long_jmp(void)
>         u32 esp[16];
>
>         inregs = (struct regs){ 0 };
> -       inregs.esp = (u32)(esp+16);
> +       inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];
>         MK_INSN(long_jmp, "call 1f\n\t"
>                           "jmp 2f\n\t"
>                           "1: jmp $0, $test_function\n\t"
> --
> 2.21.0
Definitely an improvement.

Reviewed-by: Jim Mattson <jmattson@google.com>
