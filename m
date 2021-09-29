Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F41B41CA26
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345927AbhI2Qck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345919AbhI2Qck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:32:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A8C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:30:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w29so5287021wra.8
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mc0p2V+4e9u0RQdTnp/cg9+KLmU6XIVOX4G50p95VSs=;
        b=AHsw5ohw7cEyeZRk5M2LIESvfthqLQpOeaemC3ssnjLnNF2T+tZ2Nk1icpQT0i06gs
         aPe9dgYb2mJHB9AmPl1geiQ4UFLANQmd1EV1qraL1fTFFRtt3UQ9KuKGDsAvA+z5ViBV
         jetn3OUC8ZLVLzm5pf43mSHCE5T8dS725wShk3mfZh3pQtiOvoh2wKS0Dai/S0yJsm03
         a9z5uzFRURoDvyTKj7839yO8I2Smeb770xgabGzogTaPbaQ2TOaXUCmo2WJErHuJVwt2
         jcIjXTTw4Hbze2bUJmvZuSoT1S7V8u5yNY+92EyRO77zs88ft61Xce7RJmEzPAQ+TPIN
         KMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mc0p2V+4e9u0RQdTnp/cg9+KLmU6XIVOX4G50p95VSs=;
        b=chKNeOMMCOU9HpAL/7rzndz87ZN1dTB6pvEmSkYyESPOygCXuA4bLK6HGZ4G2yt6/i
         dzo7yngmJc03yy33aNyy5rDuvpeqDFiA+flhY9/tEk/sdkR3dtH3OTirEdbSPVBC53WA
         Zg6PM9G53qExOziPyS5d4PU3+pk4ZYHhY6M8g2t9fzrTaVCYYh4HHPg8ryGinz3FOm49
         KcDkWrudFfOrJFcX2T+ox/VvlmjEFqVP8jNRbDuaEll/aYHZYs3cADZk6ltj/Jg1D3s5
         /n8jeKxw+EIoNQH/c54Jze0Gi03A5LYzyl1DQR7mShpYZ5jjMkzj4YGq3+8i3UKcyJzp
         Lh5A==
X-Gm-Message-State: AOAM53071+Q/zFb49qt9zj6wMAvZ43Wta42V3vwx05v3gecilfyzjNsA
        gCpD6pXexWcqDwbA403uT1k=
X-Google-Smtp-Source: ABdhPJxOtAvhG6zGp6bfZip6tzCd5iX6n4VLqiZyj/4qKmlM8VfW3QKvNaclWZIou608tMYA81dTeA==
X-Received: by 2002:a5d:4a41:: with SMTP id v1mr962025wrs.324.1632933057570;
        Wed, 29 Sep 2021 09:30:57 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id v20sm367260wra.73.2021.09.29.09.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:30:57 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <af9fd393-3373-883d-0118-b0fa0ffcb03f@amsat.org>
Date:   Wed, 29 Sep 2021 18:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] target/i386: Include 'hw/i386/apic.h' locally
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210929162540.2520208-1-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20210929162540.2520208-1-f4bug@amsat.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/21 18:25, Philippe Mathieu-Daudé wrote:
> Instead of including a sysemu-specific header in "cpu.h"
> (which is shared with user-mode emulations), include it
> locally when required.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/i386/cpu.h                    | 4 ----
>  hw/i386/kvmvapic.c                   | 1 +
>  hw/i386/x86.c                        | 1 +
>  target/i386/cpu-dump.c               | 1 +
>  target/i386/cpu-sysemu.c             | 1 +
>  target/i386/cpu.c                    | 1 +
>  target/i386/gdbstub.c                | 4 ++++
>  target/i386/hax/hax-all.c            | 1 +
>  target/i386/helper.c                 | 1 +
>  target/i386/hvf/hvf.c                | 1 +
>  target/i386/hvf/x86_emu.c            | 1 +
>  target/i386/nvmm/nvmm-all.c          | 1 +
>  target/i386/tcg/seg_helper.c         | 4 ++++
>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>  target/i386/tcg/sysemu/seg_helper.c  | 1 +
>  target/i386/whpx/whpx-all.c          | 1 +
>  16 files changed, 21 insertions(+), 4 deletions(-)

> diff --git a/target/i386/tcg/seg_helper.c b/target/i386/tcg/seg_helper.c
> index baa905a0cd6..76b4ad918a7 100644
> --- a/target/i386/tcg/seg_helper.c
> +++ b/target/i386/tcg/seg_helper.c
> @@ -28,6 +28,10 @@
>  #include "helper-tcg.h"
>  #include "seg_helper.h"
>  
> +#ifndef CONFIG_USER_ONLY
> +#include "hw/i386/apic.h"
> +#endif
> +

Self-NAck (incorrectly rebased on top of commit 0792e6c88d4
("target/i386: Move x86_cpu_exec_interrupt() under sysemu/ folder").

> diff --git a/target/i386/tcg/sysemu/seg_helper.c b/target/i386/tcg/sysemu/seg_helper.c
> index bf3444c26b0..34f2c65d47f 100644
> --- a/target/i386/tcg/sysemu/seg_helper.c
> +++ b/target/i386/tcg/sysemu/seg_helper.c
> @@ -24,6 +24,7 @@
>  #include "exec/cpu_ldst.h"
>  #include "tcg/helper-tcg.h"
>  #include "../seg_helper.h"
> +#include "hw/i386/apic.h"
