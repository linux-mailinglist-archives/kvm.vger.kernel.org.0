Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A6730ADB1
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhBARYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBARYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61CBC0613ED
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:23:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c12so17475933wrc.7
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=ucsvOyKHI+j26d1+CCymR51CUFNgYRXthquyKWI9Qpo=;
        b=QJtyUOJLHrWfcXzoFmh9ZJaP2+QypJrswtnJF+QFICsC/koCEHML57IN3oHC0W4/PC
         UPCsE3NDEUbOQe14tOF5VQIGHJpS75kjFcujixlCIOPYlOa0fvUqT8mS/EPJqfmaqi2o
         jky/rKVM6XtIR+2qY3jo16QA2ATZpZANEad/pYX9t7BIQxFU6yfCddgXAQEQQeKXwWx6
         06U2isp8ecUdy6P/wiKMTOl9/tEjciI71QDO+7Hm1GTfx8YW9HgAqDndLLF7Qp5cKPu6
         Ij2mhffUsuPrhl7WCzVwQ+OqgHOiP4bpaXvEyduraJOJlcwDSHfFFZCPsWCbVhSzEzxp
         cQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=ucsvOyKHI+j26d1+CCymR51CUFNgYRXthquyKWI9Qpo=;
        b=DY4D497bPYKCO+vQy2HjoB9WTr0ywg/1FDNritnf+qUIC1ZBvIXuhMkeiQ93zfB2VG
         /nWMvI7gVsl/ITF7wtzsUY09JFiJi6k/42O/F/jhQ+1yV+tEjtiDD2dnfKhoRX8eAeaq
         02wsBt2SuOXzEAHbwjARJ1CEqp8vlf71fHbk69xyuOWdHp3vZVrHTCLO+/jlMFg9XRnA
         jR8H3bvNPAgXPLyBhDynbGEULl2zEAylZFebWDoMRfTL1N+uJp8dcx8dZtZ8zfpDJOwY
         rPAJrX53zEZ/v4OP8SLW15zcQ2JKSqH/hu1DkcSGVU8sH705aw+eDTc5kixo1ytRKFIu
         5CTQ==
X-Gm-Message-State: AOAM531I04YaKDJHhi1C0nzVUHYPDrtbvH9ubOdMEjdA/Go/6hw10fS7
        wwv/jisaF2uEFHMc59KPdriqxw==
X-Google-Smtp-Source: ABdhPJwjXhuymWPBu9w7pMkUStNsTqsql1I38VMvdViw3X/SZ+v0JHnQDqk2NLIEDLRdRpn/ybKk8g==
X-Received: by 2002:adf:f512:: with SMTP id q18mr19318659wro.55.1612200211410;
        Mon, 01 Feb 2021 09:23:31 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id l1sm27127413wrp.40.2021.02.01.09.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:23:29 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2C6931FF7E;
        Mon,  1 Feb 2021 17:23:29 +0000 (GMT)
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-6-f4bug@amsat.org>
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
Subject: Re: [PATCH v6 05/11] target/arm: Restrict ARMv6 cpus to TCG accel
Date:   Mon, 01 Feb 2021 17:18:59 +0000
In-reply-to: <20210131115022.242570-6-f4bug@amsat.org>
Message-ID: <87a6snvh0u.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org> writes:

> KVM requires the target cpu to be at least ARMv8 architecture
> (support on ARMv7 has been dropped in commit 82bf7ae84ce:
> "target/arm: Remove KVM support for 32-bit Arm hosts").
>
> Only enable the following ARMv6 CPUs when TCG is available:
>
>   - ARM1136
>   - ARM1176
>   - ARM11MPCore
>   - Cortex-M0
>
> The following machines are no more built when TCG is disabled:
>
>   - kzm                  ARM KZM Emulation Baseboard (ARM1136)
>   - microbit             BBC micro:bit (Cortex-M0)
>   - n800                 Nokia N800 tablet aka. RX-34 (OMAP2420)
>   - n810                 Nokia N810 tablet aka. RX-44 (OMAP2420)
>   - realview-eb-mpcore   ARM RealView Emulation Baseboard (ARM11MPCore)
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 2 --
>  hw/arm/realview.c                       | 2 +-
>  tests/qtest/cdrom-test.c                | 2 +-
>  hw/arm/Kconfig                          | 6 ++++++
>  target/arm/Kconfig                      | 4 ++++
>  5 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/de=
vices/arm-softmmu.mak
> index 0aad35da0c4..175530595ce 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -10,9 +10,7 @@ CONFIG_ARM_VIRT=3Dy
>  CONFIG_CUBIEBOARD=3Dy
>  CONFIG_EXYNOS4=3Dy
>  CONFIG_HIGHBANK=3Dy
> -CONFIG_FSL_IMX31=3Dy
>  CONFIG_MUSCA=3Dy
> -CONFIG_NSERIES=3Dy
>  CONFIG_STELLARIS=3Dy
>  CONFIG_REALVIEW=3Dy
>  CONFIG_VEXPRESS=3Dy
> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
> index 2dcf0a4c23e..0606d22da14 100644
> --- a/hw/arm/realview.c
> +++ b/hw/arm/realview.c
> @@ -463,8 +463,8 @@ static void realview_machine_init(void)
>  {
>      if (tcg_builtin()) {
>          type_register_static(&realview_eb_type);
> +        type_register_static(&realview_eb_mpcore_type);
>      }
> -    type_register_static(&realview_eb_mpcore_type);
>      type_register_static(&realview_pb_a8_type);
>      type_register_static(&realview_pbx_a9_type);
>  }

This confuses me - are we even able to run a realview image under KVM?
Surely the whole of realview should be TCG only?

The rest looks fine to me though:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
