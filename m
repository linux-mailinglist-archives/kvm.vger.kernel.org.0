Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA301B574C
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDWIgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:36:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38458 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWIgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 04:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587630995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRD8O5iG7EfvWKOKXBFAGi4rL5dnL8/PwE9Z+SSrmik=;
        b=UNXaARgsAwlkChUkaBg2SwLLczO7hBCPHxSlV6iWsDGGT2IBaNOYpKppcpVR44dQgbZRWR
        xezg7qOtwOwMX23lRQvS4M1sokOPXRcn1ueVSjNoK86BdMci4AI0Ajqyn6mXE+F8ea0jXZ
        5lKiXfFEPVE9CUN9dzOmNC4aDNLZggs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-T83WYf6gM-qF5dSeN7hoNw-1; Thu, 23 Apr 2020 04:36:33 -0400
X-MC-Unique: T83WYf6gM-qF5dSeN7hoNw-1
Received: by mail-wr1-f71.google.com with SMTP id i10so2500083wrq.8
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 01:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRD8O5iG7EfvWKOKXBFAGi4rL5dnL8/PwE9Z+SSrmik=;
        b=mLqTDlq8Vc9TqarwufHS5nBjn/zRNpUiY+wtRqBBgzJZxU6XEl7Q7V8Y6tEmivFfas
         +0O0WP+HOXY9J9FRkcj3c65Qx8/ZdGiz7Tu4cc/ZKQzjr+F7DacQazh+M/VPSsZxwQwK
         RjPtVy8AtCLqrqcc7aNZD/Qa3aZPcw+dGGZdODVX+z7+2X1sqaZvrtufiHyFWyOv9Adz
         Q7fmEgQjeICATiYNXNaNT+ySXbV69XRHudI2nLW221q1MjWR/FotJLqo13dGuaPLY7hO
         2XjW/IkRVhNK+xWR4FYelwJvfuwSb8ff2RLmbtavX4dC5feiL1g8cEDkL/upoVkUzFWE
         xTyA==
X-Gm-Message-State: AGi0PuZ+w3Pw6x+Rz1XBWwm5vs5Uj/XDn7ID3Du8PKFJ36K1rkTb9w35
        kWbgVzg2P2CgOeTVqp7vSXSxBBH7lj3AVvUv03v7cnih3j1wRl52CpWHD1mguT19zsWPNp8T/tn
        v7tIjcZbUYVrw
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr2725574wml.166.1587630991696;
        Thu, 23 Apr 2020 01:36:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypLsKgGadTcNDt29kt4RwW1MeBi8hDzTQTTl+RYFiTtzryLE6OQChnefkxwejcELjdlw+X5njA==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr2725541wml.166.1587630991255;
        Thu, 23 Apr 2020 01:36:31 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id h188sm2861902wme.8.2020.04.23.01.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 01:36:30 -0700 (PDT)
Subject: Re: [PATCH v3 10/19] target/arm: Restrict ARMv4 cpus to TCG accel
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-11-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <6849be34-8e45-98f8-7424-0fdb9466e9bd@redhat.com>
Date:   Thu, 23 Apr 2020 10:36:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-11-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 5:06 PM, Philippe Mathieu-Daudé wrote:
> KVM requires a cpu based on (at least) the ARMv7 architecture.
> 
> Only enable the following ARMv4 CPUs when TCG is available:
> 
>    - StrongARM (SA1100/1110)
>    - OMAP1510 (TI925T)
> 

I missed to explain, the point of this Kconfig granularity is on a KVM 
only build, the TCG-only CPUs can't be default-selected, so most of 
their devices are not pulled in.

Instead at the end the KVM-only binary only contains the devices 
required to run the Cortex-A machines.

> diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
> index 8b89d8c4c0..0652396296 100644
> --- a/default-configs/arm-softmmu.mak
> +++ b/default-configs/arm-softmmu.mak
> @@ -17,8 +17,6 @@ CONFIG_INTEGRATOR=y
>   CONFIG_FSL_IMX31=y
>   CONFIG_MUSICPAL=y
>   CONFIG_MUSCA=y
> -CONFIG_CHEETAH=y
> -CONFIG_SX1=y
>   CONFIG_NSERIES=y
>   CONFIG_STELLARIS=y
>   CONFIG_REALVIEW=y
[...]
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index e3d7e7694a..7fc0cff776 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -28,6 +28,7 @@ config ARM_VIRT
>   
>   config CHEETAH
>       bool
> +    select ARM_V4
>       select OMAP
>       select TSC210X
>   
> @@ -242,6 +243,7 @@ config COLLIE
>   
>   config SX1
>       bool
> +    select ARM_V4
>       select OMAP
>   
>   config VERSATILE
> diff --git a/target/arm/Kconfig b/target/arm/Kconfig
> index e68c71a6ff..0d496d318a 100644
> --- a/target/arm/Kconfig
> +++ b/target/arm/Kconfig
> @@ -1,2 +1,6 @@
> +config ARM_V4
> +    depends on TCG
> +    bool
> +
>   config ARM_V7M
>       bool

