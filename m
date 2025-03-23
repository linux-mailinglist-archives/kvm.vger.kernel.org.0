Return-Path: <kvm+bounces-41775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E46A6D0E8
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17615188E544
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E791198845;
	Sun, 23 Mar 2025 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SvQdw8XL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B7B28E7
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759425; cv=none; b=dXRCRWKJ3GqDQPv808iaE+3jwQL8JZi+fXU8KpZ943CgBnT7gMSfX0JhXC+DWzPVYS9na/vh4JNZHw4yXNp/ZG9P/sIErJqQ6CtQATGpoZgZfdf3jGuuCgijUGWZWKoZK74F7oQqCDl14+naw3KdIiYIhiWAKXet/Lqfl/Zzzlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759425; c=relaxed/simple;
	bh=fv9+ppix7Jo8UgQAiMvX31FZWJr3TBpz1qyZFpaWeZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/YsNxSI3g4hLWRv3xbAboRr+sFjDyc3JkTgEqwJd4jk/wKB5p7V5C22JTywtOVtT8F16EOebN7hOs86ILJ2/ynYUb/NrChgYNAdzzGQj3/NVOW33sA/oqeEp+y2zfI8vPVW3UU/7fze1iVmmF6aMvPqH+CQ6hYkI4uAQHahw7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SvQdw8XL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224341bbc1dso66400905ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759423; x=1743364223; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p4xRAN0m6ZdO4gtnL2+ABu6HfCfeJ4P1/qPsWE+BDIw=;
        b=SvQdw8XLJc0gApXaBdVaKWPhA0aHe9tS2vLI9YkwFtA4sK+Q5HtwetD7qDreBXewH9
         RM5tKIrEcKEDy8TK/9Rk3lItimwkfV5ykOsrXrLhpZe840wTpIOdIhxElj1nYbspICMf
         XQA5THExFVkBLY2NcamhnMTry8WCYDxqYpMibc9NoJjY8TyGxJZhGfhzRWVWSZgSctJQ
         4zcpexiTDcSlbbJny2p3TkGVu4K1/wFWM6BDsCFXd4lkNkesVOjX0wukvGq+QuxgF1K9
         fC08fQqCiVnfTGTWluWaJOMPZi0zO1Z+HHqkDwd/zGCJ9d8QWywfweqDL4GcyCuNKr44
         BAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759423; x=1743364223;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4xRAN0m6ZdO4gtnL2+ABu6HfCfeJ4P1/qPsWE+BDIw=;
        b=JZT2w7nUrcOmILtycYb5mVuGcHpuT4pu4/O2pgFEFkf8rUKazB3XJnjFUYbg+wjF9N
         RSoy3MGeFZKusvTnzZ8m/rVhw57nwiJKkt6IxOYzcp3BWmO934Tt4oxtTMy/Hk23Tq/a
         SLa6Rv5586qMPrkrHTDa+zzJCn1QQuv7+xhv7JCDroByjNmjTXbPSwIHp/JZ+LYRPU/P
         yQE32jdUJy1zP0f1qGMRe7KftlmUT0Yto4xomnzUoMz/uF1BsiLlZzNKrHOqQPNoIQ4d
         z/x8mDJLaNEVh8yr73ZTBVvfnUW3bNXnWZo546VIjEaxysIBAvLvXq/TUtLaFjAEcOIO
         1EmA==
X-Gm-Message-State: AOJu0YwmsfYlYszN7WKk2oTUbaEDUGJDiLrt6JUJ783kM32ZQQTMZY3O
	yJBPqPRy+c0KDOeBFCtOm96uKUa/Vgk72Qp6a7MHcQ44dZwmnrRWQkaSDw6aNL0=
X-Gm-Gg: ASbGnctjO0JEhdwCPh48dNPFAyIm5TwU3EX4N9zezNdLSN+waT6KJxdvn+G6rJJtWob
	DyoMdXv50Tqhi9wIFQCqqatXjJd2MnGxSMX+eHgowdL3h/tVkxo1sNbdv9jjYUDZmkbCkSUlkRK
	bcRLrGd6yp01LE8eyfwjzrojh+TcOoNK/YE9GZ2OPwLnAdGvyt8ljyawNDMH7MT9dxT35yYDiBF
	py9iHXfZwOuO7dzjo3qbLv5nZvq+DYZkepcCdviRJq7bUECUmvf2O8IYmCon87UZXdRXbbd4npz
	LPN70q44m4Tq6A8Qv62qoJphTyCCJwpTXlXrIjZZwRrBRY+MjQ8Mdw/0g0XwYvRQMpM6/jITefw
	Tbx9I8OaFm8v8F8TlYW8=
X-Google-Smtp-Source: AGHT+IEoiDtt6a1ykboyilBoUshUC/k+wEAxCTAGIoHLpjWxBrvqlCRFeDRuXaIruzZ+uU3zM2Vntg==
X-Received: by 2002:a17:902:dad0:b0:223:f408:c3cf with SMTP id d9443c01a7336-22780d80033mr180962705ad.21.1742759423505;
        Sun, 23 Mar 2025 12:50:23 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811da32fsm54954315ad.182.2025.03.23.12.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:50:23 -0700 (PDT)
Message-ID: <2a7a2a78-02cc-4954-85cf-b72f37678f36@linaro.org>
Date: Sun, 23 Mar 2025 12:50:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 28/30] hw/arm/xlnx-zynqmp: prepare compilation unit to
 be common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-29-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-29-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:30, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/arm/xlnx-zynqmp.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
> index d6022ff2d3d..ec2b3a41eda 100644
> --- a/hw/arm/xlnx-zynqmp.c
> +++ b/hw/arm/xlnx-zynqmp.c
> @@ -22,9 +22,7 @@
>   #include "hw/intc/arm_gic_common.h"
>   #include "hw/misc/unimp.h"
>   #include "hw/boards.h"
> -#include "system/kvm.h"
>   #include "system/system.h"
> -#include "kvm_arm.h"
>   #include "target/arm/cpu-qom.h"
>   #include "target/arm/gtimer.h"
>   

Is a better description that these headers are unused?

Anyway,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

