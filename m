Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C972EF0C1
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbhAHKgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 05:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbhAHKgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 05:36:09 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6DC0612F9
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 02:35:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n26so13880800eju.6
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 02:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rIkyMw46PHgBF6q3fnsb9totx5EdQT6p6Pt/NidcJGw=;
        b=TgAnAp0olUK3niT2aiPTjGy9oIaTiyXPIST+AkXJxfEHYOhofnGzNggKAu+7RN1HLj
         bxsylWpaFt/xV8gwXrSYMIygVeN1EMdmCtsJerazyA6/eOC1zN8lepzf8nCkQkRuwCgQ
         Jj9mE5ym3ZKhT1kO8YPvMk8F0AIFfyuQbLf87rsXP48DDjRddYN+V6O88sJEbR0zfBiz
         664c0XMdXX8pOsYDagjoPR4ZQYalZGnORAl/Mgs7wnrL3y0OMNvGlsPdjWqQLkzCp2Db
         fHjOiQoObrv08hricV5nd1VSoJe3dCj9c9UztttazxB0EScN8FuHbSqXex5KFG7ipaTx
         JYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rIkyMw46PHgBF6q3fnsb9totx5EdQT6p6Pt/NidcJGw=;
        b=JL/Nu3iMYQFp60nlGtkuD6+8TOLCt7IFGe6bRvvY+YyKoc/XJAcja3wsEJyOfUyT8u
         BlC1MINWnD84vCqcT5C+7z1SeYVwcwKgsnxjJw5HM5P7c+lXq5BhhdgmHK1MelwqoKSQ
         gD7XSh/P61iQu2v09Emn3LMtYJTarN3ic5/h+bziooQFWg/uiMPfXBsLwtNs2GKrHA32
         M4wKO6Ew3q16zRnwNhKIYrDPu0uW0y7kxJbPghvRwNhHsTyq+1a4CN608fzua18LLIqp
         l4EF3LYsXKRuDNdeSSUSokBrJ8i25V6W34WTzqDqP2NjO+pHE4i24QiGlj3TA0OV8CF7
         1fkg==
X-Gm-Message-State: AOAM533utuQovAmfnaHYCp5fSgq1deqTQ+DpL2IlyBQt+iaRqebgzwL+
        MN0TGY48oO6SXhU+ZWYN/aZNuUegrE5nknrjySZf4g==
X-Google-Smtp-Source: ABdhPJwNeqDHR8Vw/jQ1m1utg9NjAfhdr0YmkxZXdHVGF/kVuB/ddQZ9+1qyrCgWmdCr4d2lpDNh/bt995E2SfE+o04=
X-Received: by 2002:a17:906:1151:: with SMTP id i17mr2307267eja.250.1610102127258;
 Fri, 08 Jan 2021 02:35:27 -0800 (PST)
MIME-Version: 1.0
References: <20210107222253.20382-1-f4bug@amsat.org>
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 8 Jan 2021 10:35:16 +0000
Message-ID: <CAFEAcA-6SD7304G=tXUYWZMYekZ=+ZXaMc26faTNnHFxw9MWqg@mail.gmail.com>
Subject: Re: [PULL 00/66] MIPS patches for 2021-01-07
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Libvirt <libvir-list@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 at 22:25, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org> =
wrote:
>
> The following changes since commit 470dd6bd360782f5137f7e3376af6a44658eb1=
d3:
>
>   Merge remote-tracking branch 'remotes/stsquad/tags/pull-testing-060121-=
4' into staging (2021-01-06 22:18:36 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/philmd/qemu.git tags/mips-20210107
>
> for you to fetch changes up to f97d339d612b86d8d336a11f01719a10893d6707:
>
>   docs/system: Remove deprecated 'fulong2e' machine alias (2021-01-07 22:=
57:49 +0100)
>
> ----------------------------------------------------------------
> MIPS patches queue
>
> - Simplify CPU/ISA definitions
> - Various maintenance code movements in translate.c
> - Convert part of the MSA ASE instructions to decodetree
> - Convert some instructions removed from Release 6 to decodetree
> - Remove deprecated 'fulong2e' machine alias

Hi; this failed to build on some of my hosts:

[1/4674] Generating 'libqemu-mipsel-softmmu.fa.p/decode-mips64r6.c.inc'.
FAILED: libqemu-mipsel-softmmu.fa.p/decode-mips64r6.c.inc
/usr/bin/python3 /home/petmay01/qemu-for-merges/scripts/decodetree.py
../../target/mips/mips64r6.decode --static-deco
de=3Ddecode_mips64r6 -o libqemu-mipsel-softmmu.fa.p/decode-mips64r6.c.inc
Traceback (most recent call last):
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
1397, in <module>
    main()
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
1308, in main
    parse_file(f, toppat)
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
994, in parse_file
    for line in f:
  File "/usr/lib/python3.6/encodings/ascii.py", line 26, in decode
    return codecs.ascii_decode(input, self.errors)[0]
UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position
80: ordinal not in range(128)
[2/4674] Generating 'libqemu-mipsel-softmmu.fa.p/decode-msa64.c.inc'.
FAILED: libqemu-mipsel-softmmu.fa.p/decode-msa64.c.inc
/usr/bin/python3 /home/petmay01/qemu-for-merges/scripts/decodetree.py
../../target/mips/msa64.decode --static-decode=3D
decode_msa64 -o libqemu-mipsel-softmmu.fa.p/decode-msa64.c.inc
Traceback (most recent call last):
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
1397, in <module>
    main()
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
1308, in main
    parse_file(f, toppat)
  File "/home/petmay01/qemu-for-merges/scripts/decodetree.py", line
994, in parse_file
    for line in f:
  File "/usr/lib/python3.6/encodings/ascii.py", line 26, in decode
    return codecs.ascii_decode(input, self.errors)[0]
UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position
93: ordinal not in range(128)

etc.

Looks like decodetree fails to cope with non-ASCII characters in
its input file -- probably this depends on the host locale settings:
I think these hosts run in the 'C' locale.

thanks
-- PMM
