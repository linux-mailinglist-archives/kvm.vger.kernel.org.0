Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3564230AE0F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhBARil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhBARif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:38:35 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D55FC0613D6
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:37:55 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id g10so17542926wrx.1
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=+/N4KgN5C2monjE5twfqaeTpOba08XYKc+5/16GV+SA=;
        b=jFPHDIHoSoM/6p0pc3TfyjxWVOA/WyRLnxnUphvxcbQYPweRT0GBKeytGG3iOROjGU
         /hibUUkX5IPCmuzE1TyFDUQ3zFUFKnEwLCVRklQxBhfgcj80m5wXEcb68+cyHBoofRbZ
         7ZkS+nX+ttr9YaFAr5gBfz81CEBDkK/II5vx9QNirKTJStvbGn0Dzf9WulDEd6B/lA9a
         X+yGwnaj8d4vLi5Xbv3sub5OnRumdu/BNsW8GdVOhfPFD7J9Aole4CGV6ziz7yP8IBkj
         Xcz6RRtQ2euGC25jboYXM33MwCbJFW7/yPBM2h/WeBRSo0CYpqJV428OV+qd3LeDK3x6
         x27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=+/N4KgN5C2monjE5twfqaeTpOba08XYKc+5/16GV+SA=;
        b=j08F2Dtl2bk0gbOzlKgOJmm7EIrmT1yBCcUudK0Y6DbMWbjrFrT2n8wDxLdxD6stL5
         Ww2TZjDuQWp5Yes3ZkpNk7ErYhNlzODym0/6iURM8P5RQW8ZL0ovYkBkznkQbK8jArPQ
         O+dGGySeJSi3xwIqcyh9VBbXYleezAdFlUdy/WZN53Vkfr6wqJTn3q8zdHFrXbCJHGjp
         rAwzW8ivwHhq2BuQBdocUqraMssB4Yyj2USH6WAgzrtzWOM2ePtGgL3Ie4LZsq4mvMWj
         FhG/MMJeKQN8CerT72t2SUDitkiju1YNCZJePIEge7jiUvcPhfyzxKpvL0oq2EOfJfk8
         UhUQ==
X-Gm-Message-State: AOAM531Os9G61Nau1X4Nsru1nJGS73cVPHByDk6/tztbr3VJILVi5LUs
        eetvj9opLIbRr0O7+X1Ug78/jQ==
X-Google-Smtp-Source: ABdhPJzJuYH3FM16GowHSyY9NWbraoztT9aumlPZDlqHl1ixDPQE1vRjYRFS6ktS9KgQmKzrW2MYDQ==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr19731450wrd.118.1612201074212;
        Mon, 01 Feb 2021 09:37:54 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id d30sm30226980wrc.92.2021.02.01.09.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:37:52 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 507551FF7E;
        Mon,  1 Feb 2021 17:37:52 +0000 (GMT)
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-7-f4bug@amsat.org>
 <80af7db7-2311-7cc5-93a0-f0609b0222d0@redhat.com>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v6 06/11] target/arm: Restrict ARMv7 R-profile cpus to
 TCG accel
Date:   Mon, 01 Feb 2021 17:37:22 +0000
In-reply-to: <80af7db7-2311-7cc5-93a0-f0609b0222d0@redhat.com>
Message-ID: <874kivvgcv.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> On 1/31/21 12:50 PM, Philippe Mathieu-Daud=C3=A9 wrote:
>> KVM requires the target cpu to be at least ARMv8 architecture
>> (support on ARMv7 has been dropped in commit 82bf7ae84ce:
>> "target/arm: Remove KVM support for 32-bit Arm hosts").
>>=20
>> Beside, KVM only supports A-profile, thus won't be able to run
>> R-profile cpus.
>>=20
>> Only enable the following ARMv7 R-Profile CPUs when TCG is available:
>>=20
>>   - Cortex-R5
>>   - Cortex-R5F
>>=20
>> The following machine is no more built when TCG is disabled:
>>=20
>>   - xlnx-zcu102          Xilinx ZynqMP ZCU102 board with 4xA53s and 2xR5=
Fs
>>=20
>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
>> ---
>>  default-configs/devices/aarch64-softmmu.mak | 1 -
>>  hw/arm/Kconfig                              | 2 ++
>>  target/arm/Kconfig                          | 4 ++++
>>  3 files changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/default-configs/devices/aarch64-softmmu.mak b/default-confi=
gs/devices/aarch64-softmmu.mak
>> index 958b1e08e40..a4202f56817 100644
>> --- a/default-configs/devices/aarch64-softmmu.mak
>> +++ b/default-configs/devices/aarch64-softmmu.mak
>> @@ -3,6 +3,5 @@
>>  # We support all the 32 bit boards so need all their config
>>  include arm-softmmu.mak
>>=20=20
>> -CONFIG_XLNX_ZYNQMP_ARM=3Dy
>>  CONFIG_XLNX_VERSAL=3Dy
>>  CONFIG_SBSA_REF=3Dy
>> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
>> index 6c4bce4d637..4baf1f97694 100644
>> --- a/hw/arm/Kconfig
>> +++ b/hw/arm/Kconfig
>> @@ -360,8 +360,10 @@ config STM32F405_SOC
>>=20=20
>>  config XLNX_ZYNQMP_ARM
>>      bool
>> +    default y if TCG && ARM
>
> The correct line is:
>
>       "default y if TCG && AARCH64"

Ahh yes, TIL we had some R-profile cores in QEMU ;-)

with the fix:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
