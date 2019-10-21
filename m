Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC67DF1BC
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfJUPiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:38:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21148 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726289AbfJUPiu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Oct 2019 11:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571672328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DeZrMklvY0obd2kz3n0ZRLLo/RYEOu7oHD8Rknu9yxg=;
        b=XBxMMGKk78mSTW7h2ypP3G0yRr2meQGgMeXzWOgJACrWsgYT39golQ/vShI0ksRgD67zJ9
        akwKaRtjK3Ha8PIi3n+DeeJN9e7xH9V/ozJA5iGyYONw00nVxmryFvHKnnXlZJHSloSVfI
        0xgqsm1m9JkNlY5yH2dwhyPq8UeVA2Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-IG91zgrLMua1eF0SB7UKlg-1; Mon, 21 Oct 2019 11:38:47 -0400
Received: by mail-wr1-f71.google.com with SMTP id e14so7457755wrm.21
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AQTMdI/I7SlO9MIlj7t9UzPW7umuOzRq0S3Eic66nGs=;
        b=aYbsNrxprL6XFGojvfdE4tk4APMXR+Efvzilz9POaQzcxPG/uTHFtH8y+D1d8ewYGW
         xnG/NWJKIjAurZ0Y603q7qrFmvBfI54GBfb0CEl7ponAH1Ly+I7hMJbDZlkMAvVX+azw
         HE/cPa7KsKYxd3d+AU3cjAVOv2+zt8BS3lLpXeNQXiUuvjy9Xxrl9E6A6CT1tuq5rXje
         CZDl487+IPo2UNvJslQ/414zDiAUv+gKBWi624NVEmICq8SGs5FGmmWYJwhUgjmovbWT
         wTxdLda8l0XGn4OXygpIrZb62Cfe4plvOoodi6uWBIu88qbIfEw/NDQD+IY/IO30FtGK
         +AtA==
X-Gm-Message-State: APjAAAW53SUtRFYRIjX5F4o92wai9scxZS3pHXBfKMvW6I7x3FbyEqkm
        3Eo+qO0X54iqnQzT4+9BrF/GddgmbwwCpAIC1opLdMsDXEmfgUaAXvSo1K44FO+1ix0gRIq07vL
        rijhi1z/uFjkd
X-Received: by 2002:a5d:4705:: with SMTP id y5mr8890152wrq.364.1571672326005;
        Mon, 21 Oct 2019 08:38:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx85DNPg7lOQl9s+J0SF5w2+mNPuVl/d7TYKOf57njJ1HTzarUuWepe4sr0cXWkU3NiP4yswQ==
X-Received: by 2002:a5d:4705:: with SMTP id y5mr8890135wrq.364.1571672325700;
        Mon, 21 Oct 2019 08:38:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id g5sm13173283wmg.12.2019.10.21.08.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:38:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: realmode: explicitly copy
 structure to avoid memcpy
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        alexandru.elisei@arm.com
Cc:     jmattson@google.com
References: <20191012235859.238387-1-morbo@google.com>
 <20191012235859.238387-2-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b22978fc-19f6-bcc4-d7e0-ff753566507d@redhat.com>
Date:   Mon, 21 Oct 2019 17:38:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012235859.238387-2-morbo@google.com>
Content-Language: en-US
X-MC-Unique: IG91zgrLMua1eF0SB7UKlg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/19 01:58, Bill Wendling wrote:
> Clang prefers to use a "mempcy" (or equivalent) to copy the "regs"
> structure. This doesn't work in 16-bit mode, as it will end up copying
> over half the number of bytes. GCC performs a field-by-field copy of the
> structure, so force clang to do the same thing.

Do you mean that:

1) the compiler is compiling a "call memcpy", where the bytes "rep
movsl" are interpreted as "rep movsw"

2) the compiler's integrated assembler is including the bytes for "rep
movsl", but in 16-bit mode they are "rep movsw"

3) something else

The -m16 or -no-integrated-as flags perhaps can help?

Paolo

> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/realmode.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 303d093..cf45fd6 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -117,6 +117,19 @@ struct regs {
>  =09u32 eip, eflags;
>  };
> =20
> +#define COPY_REG(name, dst, src) (dst).name =3D (src).name
> +#define COPY_REGS(dst, src)=09=09=09=09\
> +=09COPY_REG(eax, dst, src);=09=09=09\
> +=09COPY_REG(ebx, dst, src);=09=09=09\
> +=09COPY_REG(ecx, dst, src);=09=09=09\
> +=09COPY_REG(edx, dst, src);=09=09=09\
> +=09COPY_REG(esi, dst, src);=09=09=09\
> +=09COPY_REG(edi, dst, src);=09=09=09\
> +=09COPY_REG(esp, dst, src);=09=09=09\
> +=09COPY_REG(ebp, dst, src);=09=09=09\
> +=09COPY_REG(eip, dst, src);=09=09=09\
> +=09COPY_REG(eflags, dst, src)
> +
>  struct table_descr {
>  =09u16 limit;
>  =09void *base;
> @@ -148,11 +161,11 @@ static void exec_in_big_real_mode(struct insn_desc =
*insn)
>  =09extern u8 test_insn[], test_insn_end[];
> =20
>  =09for (i =3D 0; i < insn->len; ++i)
> -=09    test_insn[i] =3D ((u8 *)(unsigned long)insn->ptr)[i];
> +=09=09test_insn[i] =3D ((u8 *)(unsigned long)insn->ptr)[i];
>  =09for (; i < test_insn_end - test_insn; ++i)
>  =09=09test_insn[i] =3D 0x90; // nop
> =20
> -=09save =3D inregs;
> +=09COPY_REGS(save, inregs);
>  =09asm volatile(
>  =09=09"lgdtl %[gdt_descr] \n\t"
>  =09=09"mov %%cr0, %[tmp] \n\t"
> @@ -196,7 +209,7 @@ static void exec_in_big_real_mode(struct insn_desc *i=
nsn)
>  =09=09: [gdt_descr]"m"(gdt_descr), [bigseg]"r"((short)16)
>  =09=09: "cc", "memory"
>  =09=09);
> -=09outregs =3D save;
> +=09COPY_REGS(outregs, save);
>  }
> =20
>  #define R_AX 1
>=20

