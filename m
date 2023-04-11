Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16B6DD448
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 09:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjDKHdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 03:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDKHdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 03:33:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD4E48
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 00:32:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o18so6517564wro.12
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 00:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681198377; x=1683790377;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jitfQHxNKlLLWjbKOA7rm6DntsIwrUYmpjynRS/uek=;
        b=Ct+oFjKklmde7aWgn06ia69rf49YnWZ5M6ykhxeu4X6WUpPuMrODVAHPNIuX1H7GlC
         1CHX8VSM+DLPkXFjEfWlqljq2oVeLy6+ut5+UEt55FT5/fJbVCLFnlZvPjZdbpeP7yCx
         hkDCOkc/PMX9a1fsZc/vSL2rNJDaZGJQ7ZC8f0EuE36yoSfH+d6DoLPeJWvhNoB+NUjI
         7bNkOkJpF9OKaOxk6jgtqC6Ns+LklMkpsaWrJn/o25QezZ3q9Pxjjt2mryDY+veyd41o
         bmthG3SdS7j1XXy+U6UI3XAVA7n8YHRDfF6sMUj1tu72hYv1BzeMT1NTBNxH451ZU7rX
         20oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681198377; x=1683790377;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0jitfQHxNKlLLWjbKOA7rm6DntsIwrUYmpjynRS/uek=;
        b=cvo6XQqC5DqSz27PMtIJ7pFl+jeracaDpb+om12ATP27Tf4BGUqciqUZIucuiMkObZ
         4iFAGYMm9YgivvwKnM5aVNmoWmCo+ApznfjMfCfLIlgsmeXCyCgvrQfm8firmN0+YMMR
         zscQWAs3viKhT7svSCAZnlV3SsqxCro3wj1bsQPtsHnCRcyQdeYaFSc+prdqmBQQlbcc
         NpLGoYQEVzuMxpMQ9//rqyiHQLiVZRP4KoK8Ys1vqFLsf+JAd/S94wTZzEn5eep57wcY
         8DSZN5dwOJZM2h+0ej6hefT3DhixuupTzELgMiBaD8Ha/QOrS1Fo6h1GMBAz0Sm1Vt6N
         VwEg==
X-Gm-Message-State: AAQBX9esp57Jn3G9leefw/fRPgXiQEcEuZr9AWzWKHLRvhXT9n8NzgAP
        y9ronbBJHb8O7ux4NO8++0ySVGMTIfkXy+Mqlx8=
X-Google-Smtp-Source: AKy350aKUv8+aZ99dOPFkzti9Bxtt87xAGxcyArg8Py/ULurTqNc3kASqY0ick0rH8FfulhwnoEUJQ==
X-Received: by 2002:adf:f448:0:b0:2ef:bbd7:63ab with SMTP id f8-20020adff448000000b002efbbd763abmr7669076wrp.31.1681198377062;
        Tue, 11 Apr 2023 00:32:57 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id f6-20020adff986000000b002e52dfb9256sm6682692wrr.41.2023.04.11.00.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 00:32:56 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 5AFE01FFB7;
        Tue, 11 Apr 2023 08:32:56 +0100 (BST)
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-5-philmd@linaro.org>
User-agent: mu4e 1.10.0; emacs 29.0.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        qemu-riscv@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 04/10] hw/intc/arm_gic: Rename 'first_cpu' argument
Date:   Tue, 11 Apr 2023 08:31:27 +0100
In-reply-to: <20230405160454.97436-5-philmd@linaro.org>
Message-ID: <87r0sqrhzr.fsf@linaro.org>
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

> "hw/core/cpu.h" defines 'first_cpu' as QTAILQ_FIRST_RCU(&cpus).
>
> arm_gic_common_reset_irq_state() calls its second argument
> 'first_cpu', producing a build failure when "hw/core/cpu.h"
> is included:
>
>   hw/intc/arm_gic_common.c:238:68: warning: omitting the parameter name i=
n a function definition is a C2x extension [-Wc2x-extensions]
>     static inline void arm_gic_common_reset_irq_state(GICState *s, int fi=
rst_cpu,
>                                                                        ^
>   include/hw/core/cpu.h:451:26: note: expanded from macro 'first_cpu'
>     #define first_cpu        QTAILQ_FIRST_RCU(&cpus)
>                              ^
>
> KISS, rename the function argument.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  hw/intc/arm_gic_common.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/hw/intc/arm_gic_common.c b/hw/intc/arm_gic_common.c
> index 9702197856..889327a8cf 100644
> --- a/hw/intc/arm_gic_common.c
> +++ b/hw/intc/arm_gic_common.c
> @@ -235,12 +235,13 @@ static void arm_gic_common_realize(DeviceState *dev=
, Error **errp)
>      }
>  }
>=20=20
> -static inline void arm_gic_common_reset_irq_state(GICState *s, int first=
_cpu,
> +static inline void arm_gic_common_reset_irq_state(GICState *s,
> +                                                  int
> first_cpu_index,

I'd have gone for a shorter name like cidx maybe, naming things is hard.

Anyway:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>


>                                                    int resetprio)
>  {
>      int i, j;
>=20=20
> -    for (i =3D first_cpu; i < first_cpu + s->num_cpu; i++) {
> +    for (i =3D first_cpu_index; i < first_cpu_index + s->num_cpu; i++) {
>          if (s->revision =3D=3D REV_11MPCORE) {
>              s->priority_mask[i] =3D 0xf0;
>          } else {


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
