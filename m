Return-Path: <kvm+bounces-2558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAF47FB20E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB4741C20A6B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B26DDCC;
	Tue, 28 Nov 2023 06:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ERmBQKHB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A901BB
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:46:53 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40b397793aaso22581245e9.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701154012; x=1701758812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h0PjY0WHoOlgCesy1ZAomc2Q7r4AO6iN2dgUweHV9zw=;
        b=ERmBQKHBkt1Ub5RqNPlAoCDwtF/2PFH89G1XrDH71bDht4EeZGm11mzMaRyVvGgCie
         sbYHwgVHoPKishgnCaTvC8dYEjukva8kPxS5LRNgf6J7NlRyDQdCxQd1xRCBNefkiePf
         9KVzD6vbp+K1sPybRRKVmdOiZjfY1a6xbB4BEGtdnuF+Zx4Q9WzAcymVrpwVTcNbQZxg
         474CGK7JIwUIXDaCtGEFMa4ZZ9KhxLhNELbUL2sNziffs0p4J+p1bqiEiPlwVKul0VYS
         YSoYjiw7mD0BT7Cn0OzSFamiUJpMQv/E8YzVnUmkmZrqTE7SDWH447DYvskVJ7FRhmCq
         bL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701154012; x=1701758812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0PjY0WHoOlgCesy1ZAomc2Q7r4AO6iN2dgUweHV9zw=;
        b=hudIMMut+kEaScYCLHFeHPQ9C+JaEzioe7zBBeD+6yLesLZqJMaSdelcX7NpyIPIZS
         BV3cs7s7tGCaGZ/oXAvAeAk+63FcbaIH7i23/t+5UyX6tJYdgPq3UejBVzP5FV6hbZod
         OZPIfweT+/5eldl2Rc6IkQ+eMxa+hrzYgGhT+dR+eXeoAi5HnVU04ANhDMENLHvi2Z3a
         orvhoeRyAMIlZYETqk6H1o0xa/UG//hrMo3PptFyJqIrY3wbRwEYYMAHDg9Jk+NoHIv2
         z+pAiDf/eSgSFbhjq9Fj54x4PKZ5KcynHtIQLVzEAt/dwq83xx60J8LcY+npLBxjM6/N
         a54w==
X-Gm-Message-State: AOJu0YyV8eYfrlt4DcbVlQohu6ZeYdpw3BL28L0A3VYF0LD/VU4IFmYe
	rvdlXBLZuMqHUZbtVsJN2iEuWhVBizxca9IahsQ=
X-Google-Smtp-Source: AGHT+IGuLVjmN8UvCrWJLck2yUrDdplonq/4r15+/Y46RZpo7v1qql8cKLQSQIv6tFsOmEt8uy1Yow==
X-Received: by 2002:a05:600c:4f86:b0:40b:305c:9c84 with SMTP id n6-20020a05600c4f8600b0040b305c9c84mr12036325wmq.12.1701154012110;
        Mon, 27 Nov 2023 22:46:52 -0800 (PST)
Received: from [192.168.69.100] (crb44-h02-176-184-13-61.dsl.sta.abo.bbox.fr. [176.184.13.61])
        by smtp.gmail.com with ESMTPSA id j8-20020adfe508000000b00318147fd2d3sm14027125wrm.41.2023.11.27.22.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 22:46:51 -0800 (PST)
Message-ID: <f9b24c09-547d-4590-9b73-9c5918ee022c@linaro.org>
Date: Tue, 28 Nov 2023 07:46:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 08/16] target/arm/kvm: Have kvm_arm_pmu_init take
 a ARMCPU argument
Content-Language: en-US
To: Gavin Shan <gshan@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-9-philmd@linaro.org>
 <802e9dcd-68d2-4c38-95e8-fe99d46b911f@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <802e9dcd-68d2-4c38-95e8-fe99d46b911f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/11/23 05:20, Gavin Shan wrote:
> Hi Phil,
> 
> On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
>> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
>> take a ARMCPU* argument. Use the CPU() QOM cast macro When
>> calling the generic vCPU API from "sysemu/kvm.h".
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/arm/kvm_arm.h | 4 ++--
>>   hw/arm/virt.c        | 2 +-
>>   target/arm/kvm.c     | 6 +++---
>>   3 files changed, 6 insertions(+), 6 deletions(-)
>>
> 
> One nit below, but I guess it doesn't matter.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index 0e12a008ab..fde1c45609 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -200,8 +200,8 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, 
>> bool *fixed_ipa);
>>   int kvm_arm_vgic_probe(void);
>> +void kvm_arm_pmu_init(ARMCPU *cpu);
>>   void kvm_arm_pmu_set_irq(CPUState *cs, int irq);
>> -void kvm_arm_pmu_init(CPUState *cs);
> 
> Why the order of the declaration is changed? I guess the reason would be
> kvm_arm_pmu_init() is called prior to kvm_arm_pmu_set_irq().

Yes, exactly. Not worth mentioning IMHO.

Thanks!

Phil.


