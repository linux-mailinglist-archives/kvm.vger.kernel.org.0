Return-Path: <kvm+bounces-5580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 418178233B9
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79564286E32
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC1F1C2A8;
	Wed,  3 Jan 2024 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VchLirR/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CABC1C295
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d89446895so4473205e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704304042; x=1704908842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aZn5H3BibQIjCm6XCuZSPBoWZOto2pSlAUY4r4Wn5U8=;
        b=VchLirR/3B0j1JfakaB7lANj/asH96UxOL1kXb2MJ4x1I8VPLddy5AG92S77XnJgrb
         fLhaSqTQQqPPiaEIhUED5JA20hj074JWisyfvt5rv5aeV3+IkvCsgpgjVFrzTlWIwvFX
         aYDf9InMzUYZETVtUpYpXqzgU4fb55DqHCLHyKAHNlJmDffyonPOa6Y62f8HMjrH2cWX
         WKty3rg+GCVpB37B67sjz1rAwFkD5tG21O6eeqp95fRdqdRKDwsjLcOHS2089hTqbWc3
         haj1QPSIOeU7MtpBuNdFxXVhur466+xZ/KtpqBsz/a62c/1lOlUcpes5KCZ9ZUBOZczF
         PlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704304042; x=1704908842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZn5H3BibQIjCm6XCuZSPBoWZOto2pSlAUY4r4Wn5U8=;
        b=tyQvXw21KzLSv5xx8mv9JNET83Dmw02mj+FtncbXK+2Ulg3vu8LswLhyv50kz9QIwH
         nvE/dKI1Uo4wQGNZw5G7F3W8djdDnERuIoK/6SPMZ5UMDQLfj4H0eq2ApO4HsTQoCi9Q
         516cg9RkC9P8LinXJQGHRZby5J8BXE7rBP9kUxo9yY7aMS+hk5T/Bbhned2YhemrxIPx
         C5iFRwp8PcipuVvJQceXUtSI/hImG/iI1Wa+pqbJFazlWeFzGArVwMTjLu6Yfm+opvgn
         nlkHqme9TapqRnwXkF6MuRV096iuIGZ/6EFbmtMBMcd1FLqRqsd8+e/QYD1ptI5jzu0z
         NcBQ==
X-Gm-Message-State: AOJu0YwQF0UzgyQKzxNSFBegTdsCvahvFxqV12s5a9GvgT8nVUtKauoC
	C0oaRXOmRVsRajihrNKrYGZK8Jlg88IPPg==
X-Google-Smtp-Source: AGHT+IEWSmwKYOBNA3zud+Rn8MIOuM7s/OmpOblX5Yr8XMRSMzRdlO4xFHDFR+JcT+JP+VwaTeY4Dw==
X-Received: by 2002:a05:600c:4b27:b0:40d:81bd:9d12 with SMTP id i39-20020a05600c4b2700b0040d81bd9d12mr743994wmp.147.1704304042639;
        Wed, 03 Jan 2024 09:47:22 -0800 (PST)
Received: from [192.168.69.100] (tre93-h02-176-184-7-144.dsl.sta.abo.bbox.fr. [176.184.7.144])
        by smtp.gmail.com with ESMTPSA id t16-20020a05600c199000b0040d5fcaefcesm2946862wmq.19.2024.01.03.09.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 09:47:21 -0800 (PST)
Message-ID: <f0fb7562-9af1-4448-b33a-ededd8072aef@linaro.org>
Date: Wed, 3 Jan 2024 18:47:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 39/43] contrib/plugins: fix imatch
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
 <20240103173349.398526-40-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-40-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 18:33, Alex Bennée wrote:
> We can't directly save the ephemeral imatch from argv as that memory
> will get recycled.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   contrib/plugins/execlog.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
> index 82dc2f584e2..f262e5555eb 100644
> --- a/contrib/plugins/execlog.c
> +++ b/contrib/plugins/execlog.c
> @@ -199,7 +199,7 @@ static void parse_insn_match(char *match)

Could 'match' become const?

>       if (!imatches) {
>           imatches = g_ptr_array_new();
>       }
> -    g_ptr_array_add(imatches, match);
> +    g_ptr_array_add(imatches, g_strdup(match));
>   }
>   
>   static void parse_vaddr_match(char *match)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


