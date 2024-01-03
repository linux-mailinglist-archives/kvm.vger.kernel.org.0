Return-Path: <kvm+bounces-5586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9F78233D3
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04901F24416
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F661C6A5;
	Wed,  3 Jan 2024 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I1ko1hjw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425251C69C
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3374d309eebso638289f8f.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704304214; x=1704909014; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5F2VXYkjrYII2wHzAQk4L5HsWOBoBNWS2pQ57+FVJgY=;
        b=I1ko1hjwJI47gLhXaqyzmFqTK1hpkS1yH7PY36sFGq925vT58OTX97yhI4GpDZNhLq
         YTZvlAxXaZjGPnsM6keTTU/2KOwMcePYXYEUxFw3pUVq7L2AFSRzh3FS/Oqvbb49YupQ
         eFP0r0drjUkI5vgbP03qiVp4s2lhRgsPq4sqJ/2fhfc4QBKXF+DOxHkcxNFH+V3WAl0l
         dNJh+eTKu3h7/g8oPkf3rbCLeRm20XEMa6AacaX37YcFQgru9h6OcQ8Uto/x2UM4A2da
         pYIXXFnHkwgDQpDiQma2v881nd48L1jOch/JHW1a9k68CUzTBscWWQuW+xDN3IuS4KmU
         VMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704304214; x=1704909014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5F2VXYkjrYII2wHzAQk4L5HsWOBoBNWS2pQ57+FVJgY=;
        b=VvC3bwzY7tQZD9fwR+xlK3yniXFmviviJWRK1bWuvlsB9WisXj1yz9nsIllrPlA7Xw
         aFBsMOZfW/fK7R85TH+fghrLkZWFZd+TyYszeCgBmfFitGEodZg+pXFJB5ZnQhru9jZl
         SqiMpzVSFUmD4It6s7t0IdnqQXnhl7FfXN1zISygn1aEj5DRa4JJPvtadUMI84N/zA7j
         c/RVmuFfB/avVklXTmD8kqKIOIwleKg2IXSWCyNX8EOEV/U7FWWISx1++hn73A2nW6l3
         /MtnKuwYVjW8mcMyLISUhLVN2SYBp6yuMSLhuB9tZBvYmkFVeWvfStN5zrT6Rl7x08fU
         1Fbw==
X-Gm-Message-State: AOJu0Yx8QqV6X8m3iBvfDV2O6HrDdwY+fjVBGFrDY6VBSMWA1iQFowWH
	sZMmj/6pIEqlZcGAs87TLWS+YLGqgroPIg==
X-Google-Smtp-Source: AGHT+IHOec9oNkIrnlY9NK6/rK0VGc1b4NubPs5VB1Dj8nGfMZLG0FwRX19cqc26uA170W2Jd13kLQ==
X-Received: by 2002:a5d:6910:0:b0:336:6dd7:4a13 with SMTP id t16-20020a5d6910000000b003366dd74a13mr10911726wru.121.1704304214537;
        Wed, 03 Jan 2024 09:50:14 -0800 (PST)
Received: from [192.168.69.100] (tre93-h02-176-184-7-144.dsl.sta.abo.bbox.fr. [176.184.7.144])
        by smtp.gmail.com with ESMTPSA id c9-20020a056000104900b003368849129dsm30420818wrx.15.2024.01.03.09.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 09:50:14 -0800 (PST)
Message-ID: <1a923274-8a4a-4811-a836-9a0866e2c852@linaro.org>
Date: Wed, 3 Jan 2024 18:50:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/43] gdbstub: Use GDBFeature for GDBRegisterState
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
 Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-31-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240103173349.398526-31-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 18:33, Alex Bennée wrote:
> From: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> Simplify GDBRegisterState by replacing num_regs and xml members with
> one member that points to GDBFeature.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20231213-gdb-v17-5-777047380591@daynix.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   gdbstub/gdbstub.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

