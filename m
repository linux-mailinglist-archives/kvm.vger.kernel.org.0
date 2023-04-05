Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68786D7E38
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbjDEN6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 09:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDEN6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 09:58:07 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A8C4C19
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 06:57:49 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j1-20020a05600c1c0100b003f04da00d07so2143550wms.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680703067;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NetuLM1YNy+KIDJo2AuRwk1MQSAg78qWWaqODIp3uM=;
        b=STRahmuuUI8KQBpKkK6/PybRdBaAfHp1W+GWkva9949DvsniQ47A/YBs4/K6otGmIQ
         A7oHq5QZml8oDY9OkaJYXNIDicXknAlahrTy0t885QBs0Lt5BGqY/X1A5hzP+3cG4jyG
         hqExCPaaG4YfjYDF2Lvk4KZCMdUASYLq+3mofYtWUXbekaC+KANqj/gZ2+SaWy51z2Gx
         IK4y7wRVW/r+5NSnoD08WImnjxGuzAjZRzafDn3YXT4lhfyMCg0hk6YePHsX9rGEZ0yO
         5bbeqBjbAXiB4zUJZFVItGQ8ztZK7Dl/a/IVEwL731YIWMclVzlyNQOD4tFezaYuIqhf
         O8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680703067;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7NetuLM1YNy+KIDJo2AuRwk1MQSAg78qWWaqODIp3uM=;
        b=JQXD8xtWRXz9Xj5buZiDnR4TWaYlNuYCJOdsmqX3WF3MDFDCjoXx8JVK8yTXSSxY+3
         D2opC2VZhaOkvjPp7cR2ZaZP5PtH14JqrpOZ67cUJ3BnCZSIGCZvkbRYhuHB4QMOMjuI
         jnfxCx9gtA2ZO+BtM/ZIUBQ3WeI+vqu9stbS5tKPPpbVv+pkKpwv6VF9xNFacjl4650Q
         h9thTKVzrr31uVju/dDzxwSqE5AI+Q7VHFhKpZzRvPMhpr3PEX8WXT9Lcv13n0JFj6Sr
         vnaJDg9V894VXQh3MXiDJhHoYDlTiyXF7kVj5jOCiKcKOa9ce8wEhK9ZvM8k49riiUwb
         QMYg==
X-Gm-Message-State: AAQBX9d+37Jy76iooDuNLOBmgpd28DRQhyskMSq8QaaLi2JenOBet8IX
        yC95z+xHqbJwcfzR5hJfJRngzs9w+Awl4RWYcok=
X-Google-Smtp-Source: AKy350amvRA+LsVe3Qrc1qOw8K7TS5SLWtfzWAgqhDokCIDVgX46fW59a21dzTrAyh+jdrLxrPgnHA==
X-Received: by 2002:a1c:e916:0:b0:3f0:4f83:22f4 with SMTP id q22-20020a1ce916000000b003f04f8322f4mr4568690wmc.20.1680703067664;
        Wed, 05 Apr 2023 06:57:47 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t12-20020a7bc3cc000000b003ee42696acesm2281079wmj.16.2023.04.05.06.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 06:57:47 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E0D531FFB7;
        Wed,  5 Apr 2023 14:57:46 +0100 (BST)
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-10-philmd@linaro.org>
User-agent: mu4e 1.10.0; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Reinoud Zandijk <reinoud@netbsd.org>
Subject: Re: [PATCH 09/14] accel: Allocate NVMM vCPU using g_try_FOO()
Date:   Wed, 05 Apr 2023 14:55:41 +0100
In-reply-to: <20230405101811.76663-10-philmd@linaro.org>
Message-ID: <874jpul9d1.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> g_malloc0() can not fail. Use g_try_malloc0() instead.
>
> https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#g=
lib-Memory-Allocation.description
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/nvmm/nvmm-all.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
> index 3c7bdd560f..45fd318d23 100644
> --- a/target/i386/nvmm/nvmm-all.c
> +++ b/target/i386/nvmm/nvmm-all.c
> @@ -942,7 +942,7 @@ nvmm_init_vcpu(CPUState *cpu)
>          }
>      }
>=20=20
> -    qcpu =3D g_malloc0(sizeof(*qcpu));
> +    qcpu =3D g_try_malloc0(sizeof(*qcpu));
>      if (qcpu =3D=3D NULL) {
>          error_report("NVMM: Failed to allocate VCPU context.");
>          return -ENOMEM;

Why - if we fail to allocate the vCPU context its game over anyway any
established QEMU practice is its ok to assert fail on a malloc when
there isn't enough memory. IOW keep the g_malloc0 and remove the error
handling case.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
