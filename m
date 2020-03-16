Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE4B18739D
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgCPTuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:50:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36052 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732366AbgCPTuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:50:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id i13so10547353pfe.3
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIIXamngHKCNeGNFCvKp7fJI5aol/285BJCeJ13G1Aw=;
        b=DYbnMOE1p6fNHBWyNshe1JqLgxkUEJKp7IhCGmrY8cQDYCWT97FIzU4UlcQoTOEmNc
         g+gaRYp8IijbJOjjbBqgwoTfujYM9FpLbAmI3COsf696qM2MxpfS8VYjReiUHhSsA29u
         v3qm/j5bnDmx3amXZBrIAGvx1FczjljWwZivI9824aK4zXP2kucEEUzIdHrNjK42dj3w
         Vk9JhkgmJWv4i+/b2eVBzlzykm68EUFFpqn0dyvH0cxzsPIvQaYJX5lfO5ClPUxFJAGE
         d+YMrfFyFmX3wmnJPLu0yhGNIYVIU759uwfv4pvbaTmlwdTeKQPxE9xwovTsSJk1kZEH
         RucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIIXamngHKCNeGNFCvKp7fJI5aol/285BJCeJ13G1Aw=;
        b=kwIa/433INy9x2wmNzj9T5AWn3/rwoVbD7wAz+LWyGbEoQ9apMqPmvoTSBqI6icWTt
         SKNIZOniUvIZOA7zNqDsfKmGeFVmzr3T+aGAQ44/658WrrbMiyIxz5tHlNDWEMNJRbAx
         4jOdKUiTts+rEbIiJoQfZo5zfA8hPbUIK3sEf5GnUdpaY28x5Ln0pCxEaiXOUvq5ZsfE
         wz+0hzf6tYIHmXeRu6v8FUDFAyb0uJVad2bti0oGqQSVz538XEv2qSxzZq5716CECUTa
         vGLqK8TO00aEiCLT1g7/Ci/Cfx7cMtnx0ocS4rBqdZsuMsXd/FKFhIHjHV0sVWMEv2q+
         5JJg==
X-Gm-Message-State: ANhLgQ1EenO+9S0q3YUu/PGeGXUjq7K+URhR60dAefaTazOF6QNQorIU
        xSLAqJkUIWCdd5AXu0Vss4zPVg==
X-Google-Smtp-Source: ADFU+vt0yq9wHnOPkKK1VlQnOJyORm9Djm7DBt1D1EXniKGL7V6557Qng/hrzuvzNfQpAtJaK3s2IA==
X-Received: by 2002:a63:58e:: with SMTP id 136mr1382048pgf.306.1584388203071;
        Mon, 16 Mar 2020 12:50:03 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id md20sm564159pjb.15.2020.03.16.12.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:50:02 -0700 (PDT)
Subject: Re: [PATCH v3 10/19] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-11-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <b5c047f3-ab3e-825d-35c8-b24c8efc616e@linaro.org>
Date:   Mon, 16 Mar 2020 12:50:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-11-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +static const ARMCPUInfo arm_v4_cpus[] = {
> +    { .name = "ti925t",      .initfn = ti925t_initfn },
> +    { .name = "sa1100",      .initfn = sa1100_initfn },
> +    { .name = "sa1110",      .initfn = sa1110_initfn },
> +    { .name = NULL }
> +};
> +
> +static void arm_v4_cpu_register_types(void)
> +{
> +    const ARMCPUInfo *info = arm_v4_cpus;
> +
> +    while (info->name) {
> +        arm_cpu_register(info);
> +        info++;
> +    }
> +}

I much prefer ARRAY_SIZE() to sentinels.
I know the existing code make much use of them,
but we don't need to replicate that here.


r~
