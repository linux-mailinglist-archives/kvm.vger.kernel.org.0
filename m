Return-Path: <kvm+bounces-6084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB70982B01E
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ADB8B24AC0
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883043B187;
	Thu, 11 Jan 2024 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aJcBS6oh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197D429CFA
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a28f66dc7ffso1157281366b.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704981673; x=1705586473; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h2RpPuGEzbLXO/q/GxO4Zqvt8tldWX4SahttPk2YlGY=;
        b=aJcBS6ohLAs0N/TKwMacwXvi0QQRqcPVVUDDOM3h0kdYCCWJLizqN/O4Q6PrGsFsTM
         0UF345g101nvCkCy3wZh9IsJBFsCTWuH+uXdCdR/Itjexjs4h9y4RKRLRL83s2bHHQkl
         zOPRXjq4yXqAlbMPSOinXyaE83B3GQaBWfQdFdMeYFKncRinU1iQwf/E5cTQ/jsDaf6M
         hoLUNaJAR/TXRG2NxUt55WQz313naVrKXpE5DGWoqZK87KPWlR573QwArAbxeHgF/Qy/
         t2HqrzdE4+SbP30UCrPJWCIL5D6/f8fD44bPF9xWNwsXi0Ikm1D4X50afCXBwrWoRZFR
         PNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704981673; x=1705586473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2RpPuGEzbLXO/q/GxO4Zqvt8tldWX4SahttPk2YlGY=;
        b=IcW/yzANX90FxZcfX2LffqAlN1H5JROWmUmATTQQfWei+EvgKZUQ0utGJwBPPTiYHV
         3huKJMUzw506T6OWjsJXqeoNDB7+AxvzEs5h5jcFwo+oW/AzjPGUdT1CNdAd1pLBi4h+
         MwQXgda1rpdZAmEhS2Xyw0LTfKGCkVHfnBAgTpGamdEGEWIkaJWNSao9OTPFQKR+Ikdj
         mByhUQ63hPmGrzH7+B8GfSS0VBgXaPkziHWSHOsTNBP12Ef/MPF3nT75sXah8COZj1oH
         WcRhEv2fA9nbf46DauPgXHy6TajhApqv6LXoAPyTRNG+s7xhOscxUaGaHJl+6Vy0KQ9Y
         gCvA==
X-Gm-Message-State: AOJu0YwMDpi1EqjLFn9yhpVIX3jJjh9ADnpAkwkG1U6cUcoBaaY5mMB4
	Nn+GkwzoNYb53sgKJdPIjamVPwtwSLb2Fg==
X-Google-Smtp-Source: AGHT+IGcWANbw87s/pDAASQo0NAdJFu8b2B5QcVIq5BEGgMbk6bZ7fUKghDc+/ZCqix/Dq8gHhpb/g==
X-Received: by 2002:a17:907:9488:b0:a28:f6a2:ca7c with SMTP id dm8-20020a170907948800b00a28f6a2ca7cmr1065105ejc.17.1704981673304;
        Thu, 11 Jan 2024 06:01:13 -0800 (PST)
Received: from [192.168.69.100] (vau06-h02-176-184-43-236.dsl.sta.abo.bbox.fr. [176.184.43.236])
        by smtp.gmail.com with ESMTPSA id x17-20020a170906711100b00a2c5ec21e0esm575137ejj.85.2024.01.11.06.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 06:01:12 -0800 (PST)
Message-ID: <00b95fa5-b289-4476-b1eb-e97bc6f9986b@linaro.org>
Date: Thu, 11 Jan 2024 15:01:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 42/43] docs/devel: lift example and plugin API sections
 up
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
 Alistair Francis <alistair.francis@wdc.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-43-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-43-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 18:33, Alex Bennée wrote:
> This makes them a bit more visible in the TCG emulation menu rather
> than hiding them away bellow the ToC limit.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   docs/devel/tcg-plugins.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


