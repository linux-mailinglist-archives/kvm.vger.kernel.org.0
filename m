Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911A636122
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiKWOI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiKWOIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:08:38 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2238C43AED
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 06:05:44 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5so13127434wmo.1
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 06:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4XFjg7hPI4EDh3tUnDKgxdWTR6Yu1qfDF/Gc8jiLyo=;
        b=G7Z1Yij7wVZ5qlkecg1K8SbU2jXjeQvUzcZ2wsgHCW4Rkr+2UD4o0E00nXYxbSNWlE
         mrGIo44YAP4RnncAbMBi4HWh1fmz0OpWtwADWNRKfd/iGfu8cXmdHK/DxewDj/rPet2L
         FIouBrAGTRaDS0Vv5KDTrakTWlsnCu/lw0RAYznEcwGAf/n10EAlk+yXcvS73LIe+e1G
         Gk4SUKgFUcL2624hMAxoSKfxKcFjz9pTuYYvLK93XxjC1OCqZyw5CJgSisZLpQ9IX4cA
         Qf828tkib8GS8KrNkko/24JxK3qg9aspek5qc2Ypb0yvD506UFOHAqnveeWTysEgwPBQ
         xGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/4XFjg7hPI4EDh3tUnDKgxdWTR6Yu1qfDF/Gc8jiLyo=;
        b=XTDq+D1+U33JnFdj/a8yPoOZ+vz7PRKG0ZPSQl8PdJmWMVi0JsWoJlbtX4AHNSVyTb
         FtFyoH5hxeWNnuaqdCaBX3lYs7w16NwYl4EeQO94kSti+LNmaT+qrjY39zHzefbJQQB1
         qryQ9zOv2ZHZsjiH9jH2R9bwNk/nfu0BvFwmpTwlQdkSggppt5EwnZCvtp86YiyKBh41
         lfObhuW+WQeSDfkL0zYvcFwSBeCozXVT9Hpnce2gED1pCqclbdevAM62+H1jKAvL/MBK
         HhKrX/J6yctdULNL4eCEVyZDvjds6OkXoF1blgyuijEDdt9BWKjdYMtl69r8w42qCBcH
         MBZA==
X-Gm-Message-State: ANoB5pkfEwvV9DjOoJ+YWw/FO1+FfVfXQBkGRKk5KntpCDW2D9wYd+jB
        pyAaoEMJ3RVCgBm+GXYxHxn3BQ==
X-Google-Smtp-Source: AA0mqf7T91Iwj0Ec7Cs5NgvZDG1d2wjOGaWK0lFpnIo2v9zNPh2gU6temCyBUDNbm8IhLnnldvLwcA==
X-Received: by 2002:a05:600c:4f54:b0:3d0:2d56:eb55 with SMTP id m20-20020a05600c4f5400b003d02d56eb55mr5386161wmq.176.1669212342452;
        Wed, 23 Nov 2022 06:05:42 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id b3-20020a5d4d83000000b00236576c8eddsm16664253wru.12.2022.11.23.06.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:05:41 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9DE431FFB7;
        Wed, 23 Nov 2022 14:05:40 +0000 (GMT)
References: <20221123121712.72817-1-mads@ynddal.dk>
User-agent: mu4e 1.9.3; emacs 28.2.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Mads Ynddal <mads@ynddal.dk>
Cc:     kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-devel@nongnu.org
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
Date:   Wed, 23 Nov 2022 14:05:00 +0000
In-reply-to: <20221123121712.72817-1-mads@ynddal.dk>
Message-ID: <87k03lbwaz.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Mads Ynddal <mads@ynddal.dk> writes:

> From: Mads Ynddal <m.ynddal@samsung.com>
>
> Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
> check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
> code, and replace it with a property of AccelOpsClass.
>
> Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>

Nice. Looks good to me but I'll have a proper look when I go through my
gdbstub/next queue. I don't think this is critical for 7.2.

> ---
>  accel/kvm/kvm-accel-ops.c  |  1 +
>  cpu.c                      | 10 +++++++---
>  include/sysemu/accel-ops.h |  1 +
>  3 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
> index fbf4fe3497..6ebf9a644f 100644
> --- a/accel/kvm/kvm-accel-ops.c
> +++ b/accel/kvm/kvm-accel-ops.c
> @@ -99,6 +99,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, v=
oid *data)
>      ops->synchronize_pre_loadvm =3D kvm_cpu_synchronize_pre_loadvm;
>=20=20
>  #ifdef KVM_CAP_SET_GUEST_DEBUG
> +    ops->update_guest_debug =3D kvm_update_guest_debug;
>      ops->supports_guest_debug =3D kvm_supports_guest_debug;
>      ops->insert_breakpoint =3D kvm_insert_breakpoint;
>      ops->remove_breakpoint =3D kvm_remove_breakpoint;
> diff --git a/cpu.c b/cpu.c
> index 2a09b05205..ef433a79e3 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -31,8 +31,8 @@
>  #include "hw/core/sysemu-cpu-ops.h"
>  #include "exec/address-spaces.h"
>  #endif
> +#include "sysemu/cpus.h"
>  #include "sysemu/tcg.h"
> -#include "sysemu/kvm.h"
>  #include "sysemu/replay.h"
>  #include "exec/cpu-common.h"
>  #include "exec/exec-all.h"
> @@ -378,10 +378,14 @@ void cpu_breakpoint_remove_all(CPUState *cpu, int m=
ask)
>  void cpu_single_step(CPUState *cpu, int enabled)
>  {
>      if (cpu->singlestep_enabled !=3D enabled) {
> +        const AccelOpsClass *ops =3D cpus_get_accel();
> +
>          cpu->singlestep_enabled =3D enabled;
> -        if (kvm_enabled()) {
> -            kvm_update_guest_debug(cpu, 0);
> +
> +        if (ops->update_guest_debug) {
> +            ops->update_guest_debug(cpu, 0);
>          }
> +
>          trace_breakpoint_singlestep(cpu->cpu_index, enabled);
>      }
>  }
> diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
> index 8cc7996def..0a47a2f00c 100644
> --- a/include/sysemu/accel-ops.h
> +++ b/include/sysemu/accel-ops.h
> @@ -48,6 +48,7 @@ struct AccelOpsClass {
>=20=20
>      /* gdbstub hooks */
>      bool (*supports_guest_debug)(void);
> +    int (*update_guest_debug)(CPUState *cpu, unsigned long flags);
>      int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwadd=
r len);
>      int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwadd=
r len);
>      void (*remove_all_breakpoints)(CPUState *cpu);


--=20
Alex Benn=C3=A9e
