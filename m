Return-Path: <kvm+bounces-40773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D31A5C4C2
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D88DE7ABC87
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD6325E81F;
	Tue, 11 Mar 2025 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KBu2Y8PX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BFE25E446
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705564; cv=none; b=ikhnPr+7796h/l0mQntcjn6VyldglvNgodbQkaoNeBK63gcL0EbBSYsLXCvh0qXKHsYaCSL4WmE7DKcpc8zYFMv3WGV3YAigo6lt5f9TbLwvsBx1RKqJpwgmKBt2xW5TeH4j4OKSq+qaLIkPpY5T/hLl4RoNekK9b+us7dquRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705564; c=relaxed/simple;
	bh=Uy3l+zrd5W08VU9TBVRDNEoQWdoHvcTdO2Ej8cKAKDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XI8iemwnT+dYyaQ0UW5/U702ssiIsKfP+AvA/fQ1cKgVek9C3V8FVsNekC80tsA4zLCtazPw7CjiMktZNr0Biy6hqzpEN0qZX7EN27zBDNSXQRZgXvtKx1Itg155HHjJJ/ALm2h3uBQUuFjkj63S86+DJHHHemi2jleKi4cIn6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KBu2Y8PX; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3911748893aso3411830f8f.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741705560; x=1742310360; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4xeRGjEFsgqkoiQZNkXJzWrqF+c0kZU5Qa9D4av9Nk=;
        b=KBu2Y8PX8eiooHzfhn+gMpUGk4gH4hzhLBPaZ0HgWBX/UDoJiNlNLPQJK8d2WEWN8I
         oXpfLdlumyiqGRRUy9hhTuDAmTlJ0lQC2BcV1f2o4sttTUMGGV/HBaiKT/lZqGQhm3BG
         nxDq+QxCFksx+vMXc32zaSjLxYsqdMeC4hc3H8wfPk5/6oNOlaQKSwauXkTyZTnICT7U
         PV+8M/t/jcWSBjoKid/lszaV4FkFcDWbk7U2TxhS/H3Ab6pA6ZsPm8KqNnpdltc7k9tE
         Mazc9d41G+DqcfGhCrCEif18+dTSkvszGuV/yIU0nNQBdO/T3WrFOFiMlIaGOrb2hRKH
         0nFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741705560; x=1742310360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4xeRGjEFsgqkoiQZNkXJzWrqF+c0kZU5Qa9D4av9Nk=;
        b=pu+a1i3d8+YWUcyxsX33eGY9LTfjPEHIt4ksv+sinXjFxLDjfzoCGkbexU0dUhSy3E
         xyHVuTaAbmF4/5WYGTUIr+knY6FDTmSNUUxscQjm4SEx6TS9tcs9YQMev1uQLXU4HP6i
         PfABy6sEQUTizGu1RIGdJ2uyR/TXYFlTPjp4CU98BvNZQsWmjIDboVKoUhL0GVf43xvU
         uIof28BbZVKb48wBM/tChXHjH1dtyFZ4Dd5+gDnUbiz2hWeESbbHiWyT2eT2JTRMcyJx
         mAmMPKbwTjkD+5DWDfJiBySMxluLxDhgIR/c5XCEG7CmRLJWcGWvmIfotEIfqyiLSk57
         1QAA==
X-Forwarded-Encrypted: i=1; AJvYcCUZfxjmNKmqbfTeOdoh6UKBFphtpoDjtOt9o2C5cd3N2MAh2+nXqt6kyYweYAWTkuTTPKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLZTE8P3CCfsgj2Xz40dgc+Z9NZcGAVPo1PxQqMY9mt7sNF673
	Kv3ryklzpIv4FEZOqt5gTwc+iEUpuWpIfTiZts/L1B7jY2HqgYAl/CrLop7NMy0=
X-Gm-Gg: ASbGncsikfpb+pGKUbUNsUXqMRvJ7ePNaaEbP17ad3V82r+kbBpxtBLzOoLT3QdKZkD
	HOnSFn6Ah2k2GtRYYWDE1rGufW/SVlCb1AyI56ALiWA8fV8yXYelM9a5o71AnQip03rqOc0GSxs
	rzstUGAwNiFg149w5Z7tWSvXp2ABXXbCvrWu74C5waFmeBjUoMgLZVhOejRMLGZ8liIgPtUbPHt
	Y3+fpt9sXnMQq3SmAQNjNn5joobmF/ux6yHYMGjOo6/uMcgDamC6LP5C8mnXimvHjX/AwzbNqGu
	J2DZzT9LpQaZUEeZPQdmi4EtmAIE7gYT0aX/0w9rkU4PH+61GS/tPVCGGFWawhbZIwZkjap0r/e
	SKQFJYkYaq7vD
X-Google-Smtp-Source: AGHT+IHNa12kI+fH6zt93B5q2a+mSQlQFSOW0J7tJkApAruJh0mlb9pffNZtz++Hv9gwk+saVPYaZA==
X-Received: by 2002:a5d:64ce:0:b0:391:3bba:7f18 with SMTP id ffacd0b85a97d-3913bba8128mr7841333f8f.12.1741705560054;
        Tue, 11 Mar 2025 08:06:00 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfddcsm18698919f8f.35.2025.03.11.08.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:05:59 -0700 (PDT)
Message-ID: <f957fbdb-c7c3-4a31-a76a-144ff31ea158@linaro.org>
Date: Tue, 11 Mar 2025 16:05:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] hw/hyperv/hyperv.h: header cleanup
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <20250307215623.524987-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250307215623.524987-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 22:56, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/hw/hyperv/hyperv.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
> index d717b4e13d4..63a8b65278f 100644
> --- a/include/hw/hyperv/hyperv.h
> +++ b/include/hw/hyperv/hyperv.h
> @@ -10,7 +10,8 @@
>   #ifndef HW_HYPERV_HYPERV_H
>   #define HW_HYPERV_HYPERV_H
>   
> -#include "cpu-qom.h"
> +#include "exec/hwaddr.h"
> +#include "hw/core/cpu.h"

I don't see where "hw/core/cpu.h" is used.

>   #include "hw/hyperv/hyperv-proto.h"
>   
>   typedef struct HvSintRoute HvSintRoute;


