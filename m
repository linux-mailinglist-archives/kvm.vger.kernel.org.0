Return-Path: <kvm+bounces-6082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FAC82AFAF
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72246287078
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8281D171C9;
	Thu, 11 Jan 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FHVbTzxx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BE7171B8
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 13:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-557dcb0f870so4258179a12.2
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 05:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704979861; x=1705584661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ApFCZe++K6mdEosZ5Zb18U8fI6FgBHYQCdfmSUN0e0A=;
        b=FHVbTzxxw/3HMY1nZ7MqU0UIR3nvIenaO5ZgDxGOrvcLlx4WJ2DEWbszrnNg+ihmzi
         u3F0ACt3pIXJOK4cooKrlLFztGqjfs6UuJKasecFCgcztehLEGJHYGSSFrevLcCHtN/P
         swI+NrKOGsw6so5ZeMf9i12QRcxT8xUwWABLQhYOLfxpxzqodL3cvdgPIfp+PGuQ0ugA
         /BjZ+w0POi5ogKVGggPKKJKcjSdfd6gQlTEp34e2w5noGxy5exx8RnIWKt6J+KHlq++f
         68O5tVbjoQ5kHF+EllIIuJQghvgc2c4vP/hxfdH5E0pBwm9G55avAfFFeApbFqXAR56/
         C7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704979861; x=1705584661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApFCZe++K6mdEosZ5Zb18U8fI6FgBHYQCdfmSUN0e0A=;
        b=E3Ik5nqhuFjHQFiM+yDqYmBogLZxelczeGHNdfPAZXvHLlx5vzna93T1PF8D+Qz2tF
         nA4KFtG5GT0PTYz5hCv2zA0Odxf/PQCl1qLUZ8AylOdfYLkh7mAacK2EL9MrJQUnY3Ei
         LFSmGJtDjeTr7cr611orBs6kWiJUPG9f6wqU+NeOleTUUT4ExdmDMPtl8MuqkZBoWsK0
         /OsQFFdaG70uGcaxwhm4W1eAY9DEivQKCrdmiaXC9beJRcXDkvXXfAcwF9EJgk9PntNv
         7Zi3isfvTSIrClEmIVKAGa7aiZSJTs1tLftVT2wOEG72NcauFXXGDBvSm01ezWQeK+Kh
         1TDA==
X-Gm-Message-State: AOJu0Yy/NQ5sg9kdxG8sQkUhHG4u+7ohB2yr39kRWs0WN6ruzzCMt2Wl
	Jb5ijTpipvVlfJbpIrkl20eNImDCjGTx1Q==
X-Google-Smtp-Source: AGHT+IGYBUsAOKsLaP5iAzdHj6bGoHc74gul6QIY/5Uc9BDjtowkPwGrU9YvGcitLnOVH9KFRdeKqw==
X-Received: by 2002:a17:907:8022:b0:a2c:7293:d724 with SMTP id ft34-20020a170907802200b00a2c7293d724mr275807ejc.44.1704979860745;
        Thu, 11 Jan 2024 05:31:00 -0800 (PST)
Received: from [192.168.69.100] (vau06-h02-176-184-43-236.dsl.sta.abo.bbox.fr. [176.184.43.236])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709061c4a00b00a2b9bbd6d73sm572899ejg.214.2024.01.11.05.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 05:31:00 -0800 (PST)
Message-ID: <f8cd806a-4e87-4e19-b898-acd675f9daa6@linaro.org>
Date: Thu, 11 Jan 2024 14:30:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/43] tests/avocado: use snapshot=on in kvm_xen_guest
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
 <20240103173349.398526-3-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 18:33, Alex Bennée wrote:
> This ensures the rootfs is never permanently changed as we don't need
> persistence between tests anyway.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   tests/avocado/kvm_xen_guest.py | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


