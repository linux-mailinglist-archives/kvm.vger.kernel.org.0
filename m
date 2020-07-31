Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD692348D7
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgGaQAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 12:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732481AbgGaQAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 12:00:32 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E606C061574
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:00:32 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so16273937pgf.0
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kzyn08iYOJC9RiZ2WEaANmy9s/jDSBtmNDRF5zNa9yA=;
        b=DwGsFOAFJU99lO/Ci3zPbYrpc1m0cV4DLP/iSy8NZNu36uB3pl/naDzGk8dZn48cAA
         qm5sG2p2gCvufXL8exk+YsmrHk1H0fS4oQsv3BBHwt5+RVq41NeoqpDu/znrgn4nEwUI
         7/iWY0cDqsfqu77kFfNztqj1ui1EG2T6VFmRlQ5xym34WKtdSAycuBaN+RNwsJWQGmGU
         ir6c0UEiwbkmm4sEt0P7aBei8hpuayjBRedkfyFmBvCTzSgIZOTcBsH4uDFaCuBMqYSp
         HP+2vL7qV2QwOhHrAXOKmZi7M+PykEGazQiVGMap2ar0nqWlL/OK0Na2425DaN548hfh
         drNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kzyn08iYOJC9RiZ2WEaANmy9s/jDSBtmNDRF5zNa9yA=;
        b=C5P6d92DadLPKH/wIM+CSoAMEGKxE+/n+b4QppW22EVWLvTM2JxKuPJw+A0gBuNX0T
         SaIe4h2vuVHsOaiHGsPJptIUlGfPPTQbNkKD4aosnkBbp19ts9brxjR3h3CcXc6SX74L
         4cXnMD6aX4st0MW2zZO7KJE+Gm3fIoXkDnq3+3H6qRraLFwSoaiWSVDDrGQ330A3fPta
         r7XjE0RdTNFLyZECQ3ycdO8S9Ehb3nH6bQFdmPfbsdchgjwbmCNARQNlxpQ85OlYuy3m
         Jd5SAcZ27g4xcAR0EcgKHiiBZzihoeYrarNU6lYn7BOPhyLWdtiyASnDKxDan1M17csM
         qnSg==
X-Gm-Message-State: AOAM532RnIn3KGYlPx9qeHtFZuDTJY8Rvr5GSb7qMUTqYt4KW6pJjuoD
        SXKMdYzdeuOP5lxON0l6Kt4qYPNlIug=
X-Google-Smtp-Source: ABdhPJxSVKLOoY0TEa0AUpcxXcd635liWUpbDFNG40Jsb2CuSNqKHoEqz2v4ZexW6m2vgef6YhnF/Q==
X-Received: by 2002:a62:8f4b:: with SMTP id n72mr4277658pfd.5.1596211231504;
        Fri, 31 Jul 2020 09:00:31 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:25da:dbcf:1e8c:d224? ([2601:647:4700:9b2:25da:dbcf:1e8c:d224])
        by smtp.gmail.com with ESMTPSA id b21sm10316523pfp.172.2020.07.31.09.00.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 09:00:30 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH kvm-unit-tests] fw_cfg: avoid index out of bounds
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200730215809.1970-1-pbonzini@redhat.com>
Date:   Fri, 31 Jul 2020 09:00:29 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B357AE3F-2ACB-41F0-B6C1-D9A3F6604F4F@gmail.com>
References: <20200730215809.1970-1-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> On Jul 30, 2020, at 2:58 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> clang compilation fails with
>=20
> lib/x86/fwcfg.c:32:3: error: array index 17 is past the end of the =
array (which contains 16 elements) [-Werror,-Warray-bounds]
>                fw_override[FW_CFG_MAX_RAM] =3D atol(str) * 1024 * =
1024;
>=20
> The reason is that FW_CFG_MAX_RAM does not exist in the fw-cfg spec =
and was
> added for bare metal support.  Fix the size of the array and rename =
FW_CFG_MAX_ENTRY
> to FW_CFG_NUM_ENTRIES, so that it is clear that it must be one plus =
the
> highest valid entry.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> lib/x86/fwcfg.c | 6 +++---
> lib/x86/fwcfg.h | 5 ++++-
> 2 files changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> index c2aaf5a..1734afb 100644
> --- a/lib/x86/fwcfg.c
> +++ b/lib/x86/fwcfg.c
> @@ -4,7 +4,7 @@
>=20
> static struct spinlock lock;
>=20
> -static long fw_override[FW_CFG_MAX_ENTRY];
> +static long fw_override[FW_CFG_NUM_ENTRIES];
> static bool fw_override_done;
>=20
> bool no_test_device;
> @@ -15,7 +15,7 @@ static void read_cfg_override(void)
> 	int i;
>=20
> 	/* Initialize to negative value that would be considered as =
invalid */
> -	for (i =3D 0; i < FW_CFG_MAX_ENTRY; i++)
> +	for (i =3D 0; i < FW_CFG_NUM_ENTRIES; i++)
> 		fw_override[i] =3D -1;
>=20
> 	if ((str =3D getenv("NR_CPUS")))
> @@ -44,7 +44,7 @@ static uint64_t fwcfg_get_u(uint16_t index, int =
bytes)
>     if (!fw_override_done)
>         read_cfg_override();
>=20
> -    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >=3D 0)
> +    if (index < FW_CFG_NUM_ENTRIES && fw_override[index] >=3D 0)
> 	    return fw_override[index];
>=20
>     spin_lock(&lock);
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index 64d4c6e..ac4257e 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -20,9 +20,12 @@
> #define FW_CFG_NUMA             0x0d
> #define FW_CFG_BOOT_MENU        0x0e
> #define FW_CFG_MAX_CPUS         0x0f
> -#define FW_CFG_MAX_ENTRY        0x10
> +
> +/* Dummy entries used when running on bare metal */
> #define FW_CFG_MAX_RAM		0x11
>=20
> +#define FW_CFG_NUM_ENTRIES      (FW_CFG_MAX_RAM + 1)
> +
> #define FW_CFG_WRITE_CHANNEL    0x4000
> #define FW_CFG_ARCH_LOCAL       0x8000
> #define FW_CFG_ENTRY_MASK       ~(FW_CFG_WRITE_CHANNEL | =
FW_CFG_ARCH_LOCAL)
> =E2=80=94=20
> 2.26.2

For the record: I did send a patch more than two weeks ago to fix this
problem (that I created).

