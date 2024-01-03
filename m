Return-Path: <kvm+bounces-5577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDF682339E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 934841C23A93
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C19D1C2A3;
	Wed,  3 Jan 2024 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fXm6JoDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C431C293
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d5a41143fso67918675e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303636; x=1704908436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dIHFlhhFim1PtGeG0Zm6sx8pmWIRl7Sld9fdmoYExt4=;
        b=fXm6JoDrZOm487gXyHEYuGfafuiaY5/gQEC0TKIx4uM5I8pQD2BFTi4/aFdRB5VjcP
         +SGLRvV71c5rQq+IFc9Q19B+rWdT1Qi3PsWapzWo5uKmM2O+STlUtTR9MIp7enooYvpe
         /edBoPs4hNxM98yFk/EwjsX9gCe6X4CxtpxRZ7MZvvk8btfwv8ZQYyTBJmfEAYGjdmi9
         gMexc/3eM3VZjR2WaFsCXsVdNPsWgjGS6uuqmeo4L16f3/AP/io7jhlN3dYplBzbQZi9
         1CRVguTqI4HJbHlexPKokncVB9Uf7RugTJiS6xYjM09DQGe61nfj+QkcQXEmU0aT5+rJ
         NxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303636; x=1704908436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIHFlhhFim1PtGeG0Zm6sx8pmWIRl7Sld9fdmoYExt4=;
        b=Cd+rE+4g4DzGoy03JWBXLgEhZE8pHCxxHXGvR7XwVqrr4fPY2kbVP02PuXuax1LPw3
         AiXRoPVmAL7HXY7uPlx3ncakJwfwOv2V8fASd9ID66NbEiBuwZoEwW5msS9blm0JvkJs
         kRxnBZ9WQkVhxnLwrh+aeMXNF5Mey2bKlSyf50XaIGbDo5qGv5Dsdspc3zz2WbIxHvd/
         r3yHF6VjRr8Cg8dpkT8AH09BOQLa+OMM9hlZUf61BaVUPBeF4uNdbpF1fucaGVJQc9eE
         pc+SUrMoBOxMN9jAtB+8pNvtFKkyoAp37hGrpZ0wE7qAtest6SWwqq0UNRZiwiPXcCQI
         mH2Q==
X-Gm-Message-State: AOJu0YwGQjwiy37jZEvRulj2AxK/BPXIRYzcnnG3Mw9/kZbbzGPjJOB+
	MrJfnyUHwbYnK+fDjEM57fi7vknxogiFYQ==
X-Google-Smtp-Source: AGHT+IHw8JLMQzv6qvy0MGZez2fPXn9kO2VaZ99bo/3mKuKZa50Y5vQTqY/gwP/E+CV4Edxm+vZCgA==
X-Received: by 2002:a05:600c:2284:b0:40d:88b8:1bda with SMTP id 4-20020a05600c228400b0040d88b81bdamr2621257wmf.116.1704303636291;
        Wed, 03 Jan 2024 09:40:36 -0800 (PST)
Received: from [192.168.69.100] (tre93-h02-176-184-7-144.dsl.sta.abo.bbox.fr. [176.184.7.144])
        by smtp.gmail.com with ESMTPSA id k39-20020a05600c1ca700b0040d8af75e19sm2963165wms.24.2024.01.03.09.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 09:40:35 -0800 (PST)
Message-ID: <084d127e-1d77-4c45-b8e9-fe3d867e7755@linaro.org>
Date: Wed, 3 Jan 2024 18:40:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/43] qtest: bump npcm7xx_pwn-test timeout to 5
 minutes
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Song Gao <gaosong@loongson.cn>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 David Hildenbrand <david@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Bin Meng <bin.meng@windriver.com>,
 Laurent Vivier <lvivier@redhat.com>, Michael Rolnik <mrolnik@gmail.com>,
 Alexandre Iooss <erdnaxe@crans.org>, David Woodhouse <dwmw2@infradead.org>,
 Laurent Vivier <laurent@vivier.eu>, Paolo Bonzini <pbonzini@redhat.com>,
 Brian Cain <bcain@quicinc.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Thomas Huth <thuth@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, John Snow <jsnow@redhat.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-riscv@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-9-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-9-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 18:33, Alex Bennée wrote:
> From: Daniel P. Berrangé <berrange@redhat.com>
> 
> The npcm7xx_pwn-test takes 3 & 1/2 minutes in a --enable-debug build.
> Bumping to 5 minutes will give more headroom.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Message-ID: <20230717182859.707658-5-berrange@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20231215070357.10888-5-thuth@redhat.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   tests/qtest/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
> index 000ac54b7d6..84cec0a847d 100644
> --- a/tests/qtest/meson.build
> +++ b/tests/qtest/meson.build
> @@ -1,7 +1,7 @@
>   slow_qtests = {
>     'bios-tables-test' : 120,
>     'migration-test' : 480,
> -  'npcm7xx_pwm-test': 150,
> +  'npcm7xx_pwm-test': 300,

The tests seem parallelizable, maybe this file could be split?

>     'qom-test' : 900,
>     'test-hmp' : 120,
>   }


