Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7330A8AF
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhBAN2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhBAN2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 08:28:02 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02F5C061573
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 05:27:21 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a16so1230109wmm.0
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 05:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=HvbujE8LcPvc9pJFpBsNbteFOd26LsYh1R79wWODdwA=;
        b=yx7wl7/3pHhKcCps6BCS5gbPOEJEvHMjJmYUm7OxhchS8sSHyEWSTQSjotaSa7JYgy
         OegARIt3whM25MhKWtwUe99XRCL0ESLw4RCo9aCfuAJxavxBZcRdDba1gq+Ml1Clixe+
         WXHxUuvY+qx4Sx4G4YmRB36q0iRImFsuq/ThINH9oqQjPEd8xLeyMKFyP8UNyksFSYig
         ZpbgGb0uruTgFWncTtFMRqQOfYjSbKmVG5es8tqk+IpCoTcdI3prJXS9IRA7HGEupCQ8
         x3zwVm9TNocUH16LKntF2Qs00NL+DF2xPrGDxnkGa9mJf52wrRFfoYsF/3sqAzmy5O9B
         HeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=HvbujE8LcPvc9pJFpBsNbteFOd26LsYh1R79wWODdwA=;
        b=diYTq5/0WBuk0O9vaskaM+7scb1+go2pTiriDZKVgOXHJVKS3SNcCYjqNJrXtnSatO
         L10NIzWO7DybyyDJKeVURAO1yEwDx5j3JCx1NErSbaUWXPXMkh6Ful18Ne38nIEueP/C
         q6OGj7kBJrTEgNb1MsO2S+i2XYylVbJF24IR+cIQxtaFY0aCJva7yHHpYJhmXk90kDEy
         8MSPdUZzqa2KmZFwXsD4f4YVcw//sGU9a3GdOoIWCYMY69NkeSVL6Du3pQto2WgUI6Rz
         7a2nlaj4u2X2sIElEMwYPsBmtQaPIwQzHprUahWGDupFMSS0SZuOJs4EGDL7XB/yCZWg
         b1bA==
X-Gm-Message-State: AOAM5309+YLGY0rPNfgtpbRj1p5+Xz/C5Pj+AzgUspOPOdZAgpFSaJFe
        DSXBFI1xrRqLZ6oxkOe17KbAyg==
X-Google-Smtp-Source: ABdhPJwpqBRa6a900It37e+ctecbYvLmcWJl80FIae8Wt9+OzUCRf7zSx49a67t4g/so8/kMlEZBtA==
X-Received: by 2002:a1c:ac86:: with SMTP id v128mr14906303wme.76.1612186038751;
        Mon, 01 Feb 2021 05:27:18 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id n193sm21453367wmb.0.2021.02.01.05.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 05:27:17 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E65CC1FF7E;
        Mon,  1 Feb 2021 13:27:16 +0000 (GMT)
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-3-f4bug@amsat.org>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v6 02/11] exec: Restrict TCG specific headers
Date:   Mon, 01 Feb 2021 13:24:26 +0000
In-reply-to: <20210131115022.242570-3-f4bug@amsat.org>
Message-ID: <87wnvrvryj.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org> writes:

> Fixes when building with --disable-tcg on ARM:
>
>   In file included from target/arm/helper.c:16:
>   include/exec/helper-proto.h:42:10: fatal error: tcg-runtime.h: No such =
file or directory
>      42 | #include "tcg-runtime.h"
>         |          ^~~~~~~~~~~~~~~

I think the problem here is that we have stuff in helper.c which is
needed by non-TCG builds.

>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> ---
>  include/exec/helper-proto.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/exec/helper-proto.h b/include/exec/helper-proto.h
> index 659f9298e8f..740bff3bb4d 100644
> --- a/include/exec/helper-proto.h
> +++ b/include/exec/helper-proto.h
> @@ -39,8 +39,10 @@ dh_ctype(ret) HELPER(name) (dh_ctype(t1), dh_ctype(t2)=
, dh_ctype(t3), \
>=20=20
>  #include "helper.h"
>  #include "trace/generated-helpers.h"
> +#ifdef CONFIG_TCG
>  #include "tcg-runtime.h"
>  #include "plugin-helpers.h"
> +#endif /* CONFIG_TCG */

If we are including helper-proto.h then we are defining helpers which
are (should be) TCG only.

>=20=20
>  #undef IN_HELPER_PROTO


--=20
Alex Benn=C3=A9e
