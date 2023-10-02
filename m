Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147FE7B59D4
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbjJBR6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbjJBR6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:58:16 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBE6B7
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 10:58:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-307d58b3efbso78000f8f.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 10:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696269492; x=1696874292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsBpR+o2VwUZxmif29P7D+FDUn0WQ42c0teYZCGcpHk=;
        b=aDYUJgJgDyBCMTu7yRPA/xHPWsaxLj9d9D8k6/wvCgSsyXJWbtDxKqEk+X2aEmCcVu
         i7JNjUb91JFcafW3at8R1jkILUrdWrTYcoZ15JWoO9I9qhwU75e1k1LrPxuCmZy64wwZ
         lQ9lqtYao7b514yPHwqELkjBh5+4OpRyoC7rdba9xonqgR8Zs8pwhMTYtfGP3fbR1Lnx
         4vvCpx0Bh71UyaUzuCdMm8eKzyR9kpUQpdtnfFXm0DkX0Dnmf739cbBpar44q6a8VQZy
         KmTfWXUXIYCaUc+OGnBR4bVSiuVPSKeHPGJbnkRQhR/YrAPo9kIslgW7PTcSC+eYb10h
         UbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696269492; x=1696874292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsBpR+o2VwUZxmif29P7D+FDUn0WQ42c0teYZCGcpHk=;
        b=oMNf5Rh41TETDVjFNnKpTw2wPU/ZKnMZTEcRbV4jHk3MHA8Z+yGP9mpVrhw4lfYNYl
         eLztpUzBX7pw/MJTrjFPZWGegrnliYB3sw5EYgPMuYGl7MUwTDYPRTGPL5/EbFEhNTs+
         45T1UjL7ckzJsQ/eNonPEAZI4dfCbYSqnONUclMYIkHaizciz+o/TvoFXf31gXzU3Rih
         VvuxPKzXq2Qd2FYO13iXIjytpxmke5AxIaRqYY2ojfSEcRtKtP7hQsnZEbWJJprHObHC
         MvPDbx/1Lj/ieIHoksk/WqlJRBeB43mbOyqx561e+5ZHiiFjCcWQ8skWbEuh2mUB4UR/
         CJMg==
X-Gm-Message-State: AOJu0Yy9dKUdWoFPUrQ9t5tHYxG17GQzcGwT6AnUCOAc9mkd8dquhITh
        lsFLDm5mnp/j/uSNytwdh0S7v1/+5Qv9epAIJhhKgA==
X-Google-Smtp-Source: AGHT+IEIl2jwbvsKAVgfWByX2B6a1DMXQKna6Ty6GhZkAl/pYppvt1et6/EXVwdZiiblx9aKr8y9mVuVofDpXf6T/0Q=
X-Received: by 2002:a5d:500b:0:b0:321:5d87:5f7c with SMTP id
 e11-20020a5d500b000000b003215d875f7cmr10813550wrt.30.1696269491834; Mon, 02
 Oct 2023 10:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 2 Oct 2023 10:57:57 -0700
Message-ID: <CAKwvOd=dK-OmLPOA3b0Bv-csNjSkGjnXybwT08BuXC72Wf35mA@mail.gmail.com>
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        alex.williamson@redhat.com, trix@redhat.com,
        shubham.rohila@amd.com, kvm@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 2, 2023 at 10:53=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building with clang, there is a warning (or error with
> CONFIG_WERROR=3Dy) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
>
>   drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the=
 left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses=
]
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^            ~
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to ev=
aluate the bitwise operator first
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |              (                        )
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand si=
de expression to silence this warning
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |             (           )
>   1 error generated.
>
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support"=
)
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/vfio/cdx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vd=
ev, u32 flags,
>         struct vfio_device_feature_bus_master ops;
>         int ret;
>
> -       if (!vdev->flags & BME_SUPPORT)
> +       if (!(vdev->flags & BME_SUPPORT))
>                 return -ENOTTY;
>
>         ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
>
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,
~Nick Desaulniers
