Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7558F79C7
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKKRXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:23:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbfKKRXC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 12:23:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573492981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEhtdn0ducEBktqMJPHx+gxE4ZPzNIL4ZrcEG/r2e04=;
        b=DssIW8dtmjmZJb4UQ0+5K/8wDEm2YxMB+yKgqyKcE49rMe/bG9II+RzB/aynEAoJ4gHSC9
        suhPH3vhpj/0x9tKF4Neoa9OZmOO7vKvbfFv4QGCYOUbAibG3rb6kco2rWaQXkbHlBeoKF
        1z7uacmPBJO+e2TqMdciiExM4qFZEdc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-swZPPgxEPwmoQA3zUT6awA-1; Mon, 11 Nov 2019 12:23:00 -0500
Received: by mail-wr1-f70.google.com with SMTP id q6so6873480wrv.11
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 09:23:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=nEOIBNMxOOtSZX6/l/nKquHk+EOlBFfmyVDwDPZC6jE=;
        b=oZNF78Kd2ZO6zNnVWGxCpKkuv5GFNhG8vuT8ubKsy8LtSVO4OhldqRY2HMSxwhalgc
         rus/DnpnmIFEYwPXCnTyVghHf5WZm6IHGyq3XbjVgSqOCmW1yg/vlznzpUmt9e97IHKi
         LG01nbpaWO648NZbYsY6YP/TVUym6JrtIh8tjAIKzgLa6KJwKOfbo6o0XNn6PJrevEBz
         /uO34R6m0SCVKroevnKHNVG1IdxEoa2pPgHWnO+03zIDaq7Yz1Iwv7+Unbe0DAJRSYlz
         fSwvohyoeWAkQ5xudjfMqhjfEnhL28mx7VzrM0V1E2Cjyc8TCR7kr2xRzIIhcudrV5H8
         pcXg==
X-Gm-Message-State: APjAAAWHRieqSihCaVm4j8NFPXwMNXVBQZ+CZl+kv6RRTWUyqsGEh6k3
        k/WC5W4ajNwzxDiK/AxHupGNdL2dJiUYbuMEG508hm6jizyhJrb3GmbV/GqDwlvBVqbtx+P3imC
        qpKqWj89XI0cn
X-Received: by 2002:adf:8b01:: with SMTP id n1mr10873895wra.227.1573492979068;
        Mon, 11 Nov 2019 09:22:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQoV8+pBRF8GAdIW9Yuq23ZqdPgT0Q1VEbPFcK9HYRpLTRWv+nP5hCRciUDpTYuZpwuu8wWw==
X-Received: by 2002:adf:8b01:: with SMTP id n1mr10873884wra.227.1573492978858;
        Mon, 11 Nov 2019 09:22:58 -0800 (PST)
Received: from [192.168.3.122] (p5B0C62A5.dip0.t-ipconnect.de. [91.12.98.165])
        by smtp.gmail.com with ESMTPSA id c144sm120002wmd.1.2019.11.11.09.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 09:22:58 -0800 (PST)
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: Add CR save area
Date:   Mon, 11 Nov 2019 18:22:57 +0100
Message-Id: <C799E856-1F4B-4052-8D33-3FD1EE2EA570@redhat.com>
References: <20191111153345.22505-3-frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
In-Reply-To: <20191111153345.22505-3-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
X-Mailer: iPhone Mail (17A878)
X-MC-Unique: swZPPgxEPwmoQA3zUT6awA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 11.11.2019 um 16:34 schrieb Janosch Frank <frankja@linux.ibm.com>:
>=20
> =EF=BB=BFIf we run with DAT enabled and do a reset, we need to save the C=
Rs to
> backup our ASCEs on a diag308 for example.
>=20

Looks good

Reviewed-by: David Hildenbrand <david@redhat.com>

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> lib/s390x/asm-offsets.c  |  2 +-
> lib/s390x/asm/arch_def.h |  4 ++--
> lib/s390x/interrupt.c    |  4 ++--
> lib/s390x/smp.c          |  2 +-
> s390x/cstart64.S         | 10 +++++-----
> 5 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 6e2d259..4b213f8 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -57,7 +57,7 @@ int main(void)
>    OFFSET(GEN_LC_SW_INT_GRS, lowcore, sw_int_grs);
>    OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>    OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
> -    OFFSET(GEN_LC_SW_INT_CR0, lowcore, sw_int_cr0);
> +    OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>    OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>    OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>    OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 96cca2e..07d4e5e 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -78,8 +78,8 @@ struct lowcore {
>    uint64_t    sw_int_fprs[16];        /* 0x0280 */
>    uint32_t    sw_int_fpc;            /* 0x0300 */
>    uint8_t        pad_0x0304[0x0308 - 0x0304];    /* 0x0304 */
> -    uint64_t    sw_int_cr0;            /* 0x0308 */
> -    uint8_t        pad_0x0310[0x11b0 - 0x0310];    /* 0x0310 */
> +    uint64_t    sw_int_crs[16];            /* 0x0308 */
> +    uint8_t        pad_0x0310[0x11b0 - 0x0388];    /* 0x0388 */
>    uint64_t    mcck_ext_sa_addr;        /* 0x11b0 */
>    uint8_t        pad_0x11b8[0x1200 - 0x11b8];    /* 0x11b8 */
>    uint64_t    fprs_sa[16];            /* 0x1200 */
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 5cade23..c9e2dc6 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -124,13 +124,13 @@ void handle_ext_int(void)
>    }
>=20
>    if (lc->ext_int_code =3D=3D EXT_IRQ_SERVICE_SIG) {
> -        lc->sw_int_cr0 &=3D ~(1UL << 9);
> +        lc->sw_int_crs[0] &=3D ~(1UL << 9);
>        sclp_handle_ext();
>    } else {
>        ext_int_expected =3D false;
>    }
>=20
> -    if (!(lc->sw_int_cr0 & CR0_EXTM_MASK))
> +    if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
>        lc->ext_old_psw.mask &=3D ~PSW_MASK_EXT;
> }
>=20
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 7602886..f57f420 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -189,7 +189,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>    cpu->lowcore->sw_int_grs[15] =3D (uint64_t)cpu->stack + (PAGE_SIZE * 4=
);
>    lc->restart_new_psw.mask =3D 0x0000000180000000UL;
>    lc->restart_new_psw.addr =3D (uint64_t)smp_cpu_setup_state;
> -    lc->sw_int_cr0 =3D 0x0000000000040000UL;
> +    lc->sw_int_crs[0] =3D 0x0000000000040000UL;
>=20
>    /* Start processing */
>    rc =3D sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 043e34a..4be20fc 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -92,8 +92,8 @@ memsetxc:
>    .macro SAVE_REGS
>    /* save grs 0-15 */
>    stmg    %r0, %r15, GEN_LC_SW_INT_GRS
> -    /* save cr0 */
> -    stctg    %c0, %c0, GEN_LC_SW_INT_CR0
> +    /* save crs 0-15 */
> +    stctg    %c0, %c15, GEN_LC_SW_INT_CRS
>    /* load a cr0 that has the AFP control bit which enables all FPRs */
>    larl    %r1, initial_cr0
>    lctlg    %c0, %c0, 0(%r1)
> @@ -112,8 +112,8 @@ memsetxc:
>    ld    \i, \i * 8(%r1)
>    .endr
>    lfpc    GEN_LC_SW_INT_FPC
> -    /* restore cr0 */
> -    lctlg    %c0, %c0, GEN_LC_SW_INT_CR0
> +    /* restore crs 0-15 */
> +    lctlg    %c0, %c15, GEN_LC_SW_INT_CRS
>    /* restore grs 0-15 */
>    lmg    %r0, %r15, GEN_LC_SW_INT_GRS
>    .endm
> @@ -150,7 +150,7 @@ diag308_load_reset:
> smp_cpu_setup_state:
>    xgr    %r1, %r1
>    lmg     %r0, %r15, GEN_LC_SW_INT_GRS
> -    lctlg   %c0, %c0, GEN_LC_SW_INT_CR0
> +    lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
>    br    %r14
>=20
> pgm_int:
> --=20
> 2.20.1
>=20

