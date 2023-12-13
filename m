Return-Path: <kvm+bounces-4312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4FB0810D90
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76C60B20C4F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0FA2207B;
	Wed, 13 Dec 2023 09:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dzaQhbem"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC2FA4
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 01:42:46 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-50bffb64178so7845847e87.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 01:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702460564; x=1703065364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K853PDx7iHxwDMRe2s2uwXiHrYbBJ011260FxoeToU8=;
        b=dzaQhbemb+bWejsyz7bA2zfzO9+JLxy59b5XULf8LPBybg2JNRpZGltxO4cqsVbY7S
         o8/f7UCH5yPpiIkOIXa5/Qe4CJs5rpJgEj44C8zTwSW07XxJ+0y9zLYvnFlDoQ9qfOaa
         ofJBD0tawdAltN5G1JJGFY0FTGkBp2mBcwe/wq5RyY82isqfPPIsx4mvtBYnPRnBCHiG
         q+9lDX4N0b+UtKrV7QI2qjgacqA87NIBJlgA6qWaeBNDMv+fs5IoBTo/x4S91ObuM1I3
         JZPYO0iDmQQTrh0qDO1satAWrOoNlMRhXzjPfJwhucA794OtZVFLnV/P695MuBcHjLPZ
         sWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702460564; x=1703065364;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K853PDx7iHxwDMRe2s2uwXiHrYbBJ011260FxoeToU8=;
        b=s5MjEv58IFnOyzz7oszxh2HAX86P29y6GhfrQf78DfiHjjOAAjAPWR364ta+XNOA7t
         kUG5SAkCgz8kuJtppOJVXA4iaEBVu8E0XsAX+07Y6mBQ9MTBZLMq0d/D3HI+kjruqQxe
         rbDiUwXzs8bybkyfXj3dKTSR/rlDobFZO9RuSAA3rC7Kn6bYZCFZXTnk+Ki+nHdJjul8
         MkAoyzBzhGswkEXL3Ctypi9F9VHb6Cv/cG5/5bZxDzLViudW4aGAMSR2TYxt46SjB7hH
         /12QNolftJPy9LQaXChlrT89yAEfISpQpmbyQrBiAaHVuZmo/unUn/sOF8vOWcfB9YnY
         E2Sw==
X-Gm-Message-State: AOJu0YyDOoQPgKnBamgCiofLLt1RwiYWuq8ruSY0X6yuDSYaYN0svUYR
	mLqkGqOCVNuHmSyGtIB4PHG6b3IjdVTZubVw1BfG9g==
X-Google-Smtp-Source: AGHT+IEVEhRhPHOrDnVVCzhBwNeqUb8Stu2A+hAmOs4abuCm4K/3UvB9W5XfQbOz3KvfEYZ8FNI0aA==
X-Received: by 2002:a05:6512:ea3:b0:50b:eec1:2b4 with SMTP id bi35-20020a0565120ea300b0050beec102b4mr4700825lfb.79.1702460564574;
        Wed, 13 Dec 2023 01:42:44 -0800 (PST)
Received: from [192.168.27.175] (234.red-88-28-2.dynamicip.rima-tde.net. [88.28.2.234])
        by smtp.gmail.com with ESMTPSA id w13-20020a5d608d000000b00333357a77c4sm12791087wrt.34.2023.12.13.01.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 01:42:44 -0800 (PST)
Message-ID: <e4443aa8-1b36-41fd-b1a8-6ed7ddb2f130@linaro.org>
Date: Wed, 13 Dec 2023 10:42:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 00/16] target/arm/kvm: Unify kvm_arm_FOO() API
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <CAFEAcA8S7Ug8uFpvDO9FarLpLhTr_236H8gOK=dEOWQZe-3zgg@mail.gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA8S7Ug8uFpvDO9FarLpLhTr_236H8gOK=dEOWQZe-3zgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/12/23 15:36, Peter Maydell wrote:
> On Thu, 23 Nov 2023 at 18:35, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Half of the API takes CPUState, the other ARMCPU...
>>
>> $ git grep -F 'CPUState *' target/arm/kvm_arm.h | wc -l
>>        16
>> $ git grep -F 'ARMCPU *' target/arm/kvm_arm.h | wc -l
>>        14
>>
>> Since this is ARM specific, have it always take ARMCPU, and
>> call the generic KVM API casting with the CPU() macro.
> 
> 
> 
> Applied to target-arm.next for 9.0, thanks.

Thanks Peter, the only change I added from Gavin review is
on top of patch #3:

-- >8 --
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 6fb8a5f67e..3abbef0260 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -148,7 +148,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);

  /**
   * kvm_arm_add_vcpu_properties:
- * @obj: The CPU object to add the properties to
+ * @cpu: The CPU object to add the properties to
   *
   * Add all KVM specific CPU properties to the CPU object. These
   * are the CPU properties with "kvm-" prefixed names.
---


