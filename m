Return-Path: <kvm+bounces-5579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6511A8233AA
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC3B8B22E1E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0956B1C691;
	Wed,  3 Jan 2024 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QHl9L7y7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B901C688
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40d76fefd6bso43490255e9.2
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303837; x=1704908637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V8US0ACJb4Hw/yRgDiojK+LPOeoUlnaAFyhJhDgbvbA=;
        b=QHl9L7y7l65QqSKmCzB1NsHTObzWha2AB3Pz1SqOgZBeyB2Du+lv2iYCV+emF8W1Di
         xkFNrNHS53rEgIL4VK46VSooMemymisjQT4YLFdwL+EHwW4DlfoNwLEQigu+FdfgTodi
         Rw7bEUJGV9LkMlcYq9WWP1zUErRLMDyV+crFDNg70Q/ax6VYGuQkovGzvHJfxOpOOY3+
         Vu43qzMlmbZ5X+GyUwpu1SaELotD0giPao766Mm+Rr5HeeejGfBzR8EzCkZ+VtSKsrZ0
         dHqvkup/dFvZGAsQL+QspHM8TPghi9cyXY/j4+f4wrXT0vPUPAf3lhjBYxlb2f9Te7Ct
         QslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303837; x=1704908637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8US0ACJb4Hw/yRgDiojK+LPOeoUlnaAFyhJhDgbvbA=;
        b=pP1JWYE3w4AvypVZYMpSFwgVrlETUx6djkjw/3wUIes41ejiPOGsTSt3/QsDwZEaFp
         mQVmXtJIYv0hJcnPOtJbylulyLDzlBuHT47NYsfg5UG1bhQ6QVPOT0aEQehD+wqOKkbT
         u+MD1qNRZk1wWd9Wy38tddan3stiDWaZE0Wbv4qayfZBlYi+GMHH29WEqkEdFml9Qlqz
         yBfR/zwAfXZ+J6TyIIz06UhwmOKris6QxFLGW6xP5VjA4pn5PHZloWKdy1RPQAITw+8o
         lpY2xhwnpx+bQF1SEIKtU2iXJQKByrVG6CBzPKKKtYW+9ipjLwKWzJxKzNsmL+BPdvhp
         kJtg==
X-Gm-Message-State: AOJu0Yym6Fy93f1cKpOVqGV7JW08tE/gxGx/5D5NWH7SJpVwibN3/dUI
	nHNE3QWtibvdnHMHtZUHlm/q78LqpZdaUg==
X-Google-Smtp-Source: AGHT+IG5G9mQ4BJ4FXQ/6LVXB48S3IsiORpTQTFyaxnxAOVk8KcHF9cASuMfoLN6MOOl0hYkw6H46w==
X-Received: by 2002:a05:600c:3501:b0:40d:5a99:3bb6 with SMTP id h1-20020a05600c350100b0040d5a993bb6mr3579336wmq.41.1704303836866;
        Wed, 03 Jan 2024 09:43:56 -0800 (PST)
Received: from [192.168.69.100] (tre93-h02-176-184-7-144.dsl.sta.abo.bbox.fr. [176.184.7.144])
        by smtp.gmail.com with ESMTPSA id p7-20020adfe607000000b00336843ae919sm30885254wrm.49.2024.01.03.09.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 09:43:56 -0800 (PST)
Message-ID: <6826da51-3b97-4ecf-8517-9e5b5243e91f@linaro.org>
Date: Wed, 3 Jan 2024 18:43:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/43] qtest: bump pxe-test timeout to 10 minutes
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
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
 Alistair Francis <alistair.francis@wdc.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-11-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-11-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 3/1/24 18:33, Alex Bennée wrote:
> From: Daniel P. Berrangé <berrange@redhat.com>
> 
> The pxe-test uses the boot_sector_test() function, and that already
> uses a timeout of 600 seconds. So adjust the timeout on the meson
> side accordingly.

IIRC few years ago you said tests running on CI ('Tier-1') should
respect a time limit. IMO 10min seems too much for CI, should this
test be skipped there?

> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> [thuth: Bump timeout to 600s and adjust commit description]
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20231215070357.10888-7-thuth@redhat.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   tests/qtest/meson.build | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
> index 7a4160df046..ec93d5a384f 100644
> --- a/tests/qtest/meson.build
> +++ b/tests/qtest/meson.build
> @@ -4,6 +4,7 @@ slow_qtests = {
>     'npcm7xx_pwm-test': 300,
>     'qom-test' : 900,
>     'test-hmp' : 240,
> +  'pxe-test': 600,
>   }
>   
>   qtests_generic = [


