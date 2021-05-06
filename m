Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33400375813
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhEFQA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbhEFQA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:00:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60DC06138A
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 08:59:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id di13so6788011edb.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjP2tVL8/5fMTkJrtwgNcBDcwQmnwEx/OAkZcrhoFzw=;
        b=iYjiLvZXn8FAfX8V7OtJx1T2eMni4SkjZFTpMgVdft9/9vTih/6KIUqaLSUVKVH2lB
         rdX96HR+vI+jPQTu0Bg8k4top/RzfLhFCp51C3D3vZwJ3Lx2gN6PMhXB7HNfXmwj2/MS
         kI5J/U4wGxqiwnePvRvhxDFK7DGjKaKGCQPGY1RxoiMLUcXBImS5YkpyXi+nD4wRRMIG
         Vd3pxC2/58fTEwi4VMe/tmPN/gEMKkjjO98VLjjlTuAj5j/qH8TyyuQoeRW6QPM2hpq0
         9h2avyy3pdpoxpVeIAZiywio5CJDgbn931Rl8r2vY2aO2dFJJLuDU5a50WV5oGdB6EFF
         G12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjP2tVL8/5fMTkJrtwgNcBDcwQmnwEx/OAkZcrhoFzw=;
        b=RXOqZ2O/Reafot2OnhvUrSXXYXD0Ixiy3p5TMhM31SK+lKAaieRHXMMLMVXK+M81Fb
         hAf9BBaHh/4lkujSmUI627uKJgGPvAbdRmnhqNGDlty+TVgGLEk1K5PIT5lF2ZLde7e3
         0rG/4EY3xuG8Q/Tljy0OPWgHlKttG28Bj2Si4ka9XqbaezOBDiayZr9Zr6+fYoxpjy/o
         edTU7gTyJRE3QifUiYIJ+WuHvJPTh4F8B8GFT3hYCIV3zLlBd4RzmmruP2en4qDTA8Ep
         Pns7w+WhDms5QLd5U7dZgVwn/crIogRhW7N3dT6inirxVbyLwdD+JCLKg8DpvlPOxkRd
         64lg==
X-Gm-Message-State: AOAM533oTDA1qiETlZpYksxiUjuuIB+1ApE1WY12pTJj1d0IKSx9gA7S
        jfymFshjuci5zELh5SjEyP1gI7YG79AE+PCWGVYpCI0KeJw=
X-Google-Smtp-Source: ABdhPJy7C/ySonWlnTvVnDYUsB0oud7vURVnI7Vhk6vQ1/ROaTRg0RP3rpzkpDP4ZNY7nR3YGOvpTTaFjaMy9fc6+wM=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr6095158edx.52.1620316795885;
 Thu, 06 May 2021 08:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210506133758.1749233-1-philmd@redhat.com> <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
 <39f12704-af5c-2e4f-d872-a860d9a870d7@redhat.com> <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
In-Reply-To: <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 6 May 2021 16:58:47 +0100
Message-ID: <CAFEAcA-V1DWhsFYuh-y5F2_PbO50KFoCm-XPrcMEYN1V2WHDfA@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Warner Losh <imp@bsdimp.com>
Cc:     Eric Blake <eblake@redhat.com>, kvm-devel <kvm@vger.kernel.org>,
        Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 May 2021 at 15:57, Warner Losh <imp@bsdimp.com> wrote:
> malloc, on the other hand, involves taking out a number of mutexes
> and similar things to obtain the memory, which may not necessarily
> be safe in all the contexts system calls can be called from. System
> calls are, typically, async safe and can be called from signal handlers.
> alloca() is async safe, while malloc() is not. So changing the calls
> from alloca to malloc makes calls to system calls in signal handlers
> unsafe and potentially introducing buggy behavior as a result.

malloc() should definitely be fine in this context. The syscall
emulation is called after the cpu_loop() in bsd-user has called
cpu_exec(). cpu_exec() calls into the JIT, which will malloc
all over the place if it needs to in the course of JITting things.

This code should never be being called from a (host) signal handler.
In upstream the signal handling code for bsd-user appears to
be missing entirely. For linux-user when we take a host signal
we merely arrange for the guest to take a guest signal, we
don't try to execute guest code directly from the host handler.

(There are some pretty hairy races in emulated signal handling:
we did a big overhaul of the linux-user code in that area a
while back. If your bsd-user code doesn't have the 'safe_syscall'
stuff it probably needs it. But that's more about races between
"guest code wants to execute a syscall" and "incoming signal"
where we could fail to exit EINTR from an emulated syscall if
the signal arrives in a bad window.)

thanks
-- PMM
