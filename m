Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD39C375BA8
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhEFTXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhEFTXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 15:23:35 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1102C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 12:22:36 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s8so6771536wrw.10
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=OcGko0AZpfeOMrm5jT5N9J347dkqKIUp28FiXKFtwdk=;
        b=fELVnzK2+xFRsnRGPh//ft7E2TmxIFR18SqhN97yrkYySqfxwRVM7nMPS1kmx9/BX/
         d8lCU2LfQu25BYAvEswZgx22e/LoyRz6+EIYTY4eU4ShXsZS/nYDa5+gP/KWIDKszo/c
         M0WLyrc3i91S1+Dy53iMsyCIuA2sDNPcVDcPjPC7qyxyKhKP25ltlUClufgWfb8yGrCk
         nuYBeT2/NCmJpSWDs9bpLugSq6FqorqXdwEsuh+hTexVA3ScBlU6LaLTbyHaC3qGg09f
         eP09zF4EfJaaw1dnt1Ubroq5jzpysEQSFMaOeh6uqcEe9kqH31NAzOmISGT8QpyI/XLS
         P2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=OcGko0AZpfeOMrm5jT5N9J347dkqKIUp28FiXKFtwdk=;
        b=ow0LF83YXTiUzXzkpCFc7P+rV4lLMjAvYGQ4aqBF41G1oeAZazxhFNHcd1FAlUDCMF
         Uf4lS9NzChsMNCe6LllIwPHJ5UXusUVadAFLC7D7J6EDr8U5sK9VwGd+OLF6P8STUeQw
         K1GXq87TnXro5AytSkPRiHMi1MXACRexZnrNkmSlCdHWFVWkaUae4213dHOdHgeXh13I
         c0J8ThoFxe1+KOPGhdeYq9NEvy5fOObnHcXAw2QwIwKYF0NDEbgTWVGOs83LPrIqZSx7
         pAX0rsHUXGDJA1I/aLsjAtL9q7T7UrDa5VYCR/ZGIp2HZu8RvD2c4O7IGX9uoZ2jiDFF
         KqcA==
X-Gm-Message-State: AOAM532eyXvFnoUrbl8bm0y87i3D8BmcmEmUgAtKIdtwy7bf9TM5GxN+
        48HSLy+bj9bH/mikWW7MSbQ0vmTHHNSkyg==
X-Google-Smtp-Source: ABdhPJz7hohkJdA1qQSV8cIlvzUqbOP6alUWSu9tndMQ8CfhwlXE/7/aWSvUceGtoPB3tbC5F9TWzw==
X-Received: by 2002:a5d:6648:: with SMTP id f8mr7554311wrw.396.1620328955527;
        Thu, 06 May 2021 12:22:35 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id t7sm5572382wrw.60.2021.05.06.12.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 12:22:34 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 811051FF7E;
        Thu,  6 May 2021 20:22:33 +0100 (BST)
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-8-philmd@redhat.com>
User-agent: mu4e 1.5.13; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 7/9] gdbstub: Replace alloca() + memset(0) by g_new0()
Date:   Thu, 06 May 2021 20:22:01 +0100
In-reply-to: <20210506133758.1749233-8-philmd@redhat.com>
Message-ID: <87v97vmzuu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> The ALLOCA(3) man-page mentions its "use is discouraged".
>
> Replace the alloca() and memset(0) calls by g_new0().
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Please see:

  Subject: [ALT PATCH] gdbstub: Replace GdbCmdContext with plain g_array()
  Date: Thu,  6 May 2021 17:07:41 +0100
  Message-Id: <20210506160741.9841-1-alex.bennee@linaro.org>

which also includes elements of 6/9 which can be kept split off.

> ---
>  gdbstub.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/gdbstub.c b/gdbstub.c
> index 7cee2fb0f1f..666053bf590 100644
> --- a/gdbstub.c
> +++ b/gdbstub.c
> @@ -1487,14 +1487,13 @@ static int process_string_cmd(void *user_ctx, con=
st char *data,
>          if (cmd->schema) {
>              int schema_len =3D strlen(cmd->schema);
>              int max_num_params =3D schema_len / 2;
> +            g_autofree GdbCmdVariant *params =3D NULL;
>=20=20
>              if (schema_len % 2) {
>                  return -2;
>              }
>=20=20
> -            gdb_ctx.params =3D (GdbCmdVariant *)alloca(sizeof(*gdb_ctx.p=
arams)
> -                                                     * max_num_params);
> -            memset(gdb_ctx.params, 0, sizeof(*gdb_ctx.params) * max_num_=
params);
> +            gdb_ctx.params =3D params =3D g_new0(GdbCmdVariant, max_num_=
params);
>=20=20
>              if (cmd_parse_params(&data[strlen(cmd->cmd)], cmd->schema,
>                                   gdb_ctx.params, &gdb_ctx.num_params)) {


--=20
Alex Benn=C3=A9e
