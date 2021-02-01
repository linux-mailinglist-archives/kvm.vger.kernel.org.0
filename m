Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602C630AD7A
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhBARLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBARLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:11:21 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE78C061573
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:10:40 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s7so14435068wru.5
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=uc51KV1Uicp82jgNC73/pa7OUeOjHlnVfQCmC5M7wRM=;
        b=AxN1fu/MP4e8N+10JbV8io2tXAuQ0uwtPU+n/khscslUV+PzRiuoGomGh75465kPpn
         WO+OeXDiufWq2NZE4pqKZd+1Hk/RNorETOnYrgmUIVsFnTlsmDc+PBt0p8tpZaf2KEVn
         FMu/MlS7/Isv2XPSxTucCwyG70jqpAfZvpBjCXih0YKSNypBEcIP4F49Sdc8nBEbY2o1
         JIJ7G1ZuSlWTH8unbCeAp3UCi22o86V2FNzogwfYQR9MKVAV2P7jwKwp/tw1u49ADTM1
         cDJp8hkc8hp5c4cLV3AqIjhiAKukLVuzO9RhiIjPzmfd5Hl2UUqrSh95BuBi4LPXZPsm
         1HOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=uc51KV1Uicp82jgNC73/pa7OUeOjHlnVfQCmC5M7wRM=;
        b=Nh4mpZ75G7boe7hnyx12SLENBGScqhhqm8QvkRxST7NcvFSAeYYIq0jLqPCBnlXJ3f
         3c/fEWl9c+Qhvq3Q9IATYLAPRDwc03VJcl/1/ypj5dH5PT/JAfYDr6IiiTcqp4AZfrmL
         6vuZKuDbR3zlTemnCYX4tV1RYaTH0VsGQqR0otVZQMH4vl6qt3217KdVn2VhaUqS6ocz
         /e2nxJNyVrOYzLf4Aw5XI2SXL2sTgIFgMekwqywcjDtn2LStSJWXr3w7+8fZUlVbqxeG
         aICb5RTmw5wWXk8FJMeYzrbC3YesmuM5g4C1psR2EgBk/uAQHgT0jSOWmLww42yX2rVi
         SumA==
X-Gm-Message-State: AOAM533EyV87JYjqwo9eM3+mJNI9nk4yhilL62j580i96vGe9Bo1w4MW
        Gqt+RfUh2VCqH9b5Hk3F/9FzvQ==
X-Google-Smtp-Source: ABdhPJzW0+5MPR4jZiFi/k5fj29Kk9W5ktozhM0fVqMoMlvDmbMHtFjP7vlFdt6lAq20MKY5goBEDA==
X-Received: by 2002:a05:6000:188c:: with SMTP id a12mr19830466wri.105.1612199439664;
        Mon, 01 Feb 2021 09:10:39 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a16sm27138510wrr.89.2021.02.01.09.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:10:38 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9B4981FF7E;
        Mon,  1 Feb 2021 17:10:37 +0000 (GMT)
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-4-f4bug@amsat.org>
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
Subject: Re: [PATCH v6 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
Date:   Mon, 01 Feb 2021 17:10:30 +0000
In-reply-to: <20210131115022.242570-4-f4bug@amsat.org>
Message-ID: <87czxjvhma.fsf@linaro.org>
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
> Only enable the following ARMv4 CPUs when TCG is available:
>
>   - StrongARM (SA1100/1110)
>   - OMAP1510 (TI925T)
>
> The following machines are no more built when TCG is disabled:
>
>   - cheetah              Palm Tungsten|E aka. Cheetah PDA (OMAP310)
>   - sx1                  Siemens SX1 (OMAP310) V2
>   - sx1-v1               Siemens SX1 (OMAP310) V1
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
