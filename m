Return-Path: <kvm+bounces-3795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D417808084
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:08:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CDEB1C20BA1
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D6514005;
	Thu,  7 Dec 2023 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTnzLhD8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417EBD4B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 22:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701929281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qw4XDLQo4MCt+2ReNaxe2DS0wIgZKbs7S68Q4dp+iCM=;
	b=LTnzLhD8QrNXwcUekx+R9A4pgY6bi4Xv7HdhKv30qoqovzpCWBjCrl1k92c06Fg+UvbTNe
	b+tpSPaNwP8F7TSS8ZQnRab7QbXhtjviH0cWHgOc++kL1sihow47fxDqblABubHhZmbPHo
	mpOrr5lGi9A6a9l5hqWDXAx3QWXhbBc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-NTht9RhCPwyVLUPhwzCQyg-1; Thu, 07 Dec 2023 01:07:59 -0500
X-MC-Unique: NTht9RhCPwyVLUPhwzCQyg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2864977ba2dso180242a91.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 22:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701929278; x=1702534078;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qw4XDLQo4MCt+2ReNaxe2DS0wIgZKbs7S68Q4dp+iCM=;
        b=ILh0Tevb1jUOPRGB4e8+BEYzGPZF2ZnxCCL02pdyka3HVmO9bjtWV2ukPFjFllj6g0
         lNszanfMxybGcu+cB+HcodfCYsX85H3D46d2ZpyS/JvFPpuWgrSWiA3H3Eq1Yja4CWSp
         sf3tKMr5MLfeXbOzHqgHTt1ZbCiBD4CmFN6LQkRyqOCrb9AQ6+Rd7lkz1l79ZwfUeb+r
         KL9BU3KeANu8qAJKdLqMnQTWDFJgPQL3eRZZHLq3uWE219UAqPFatNaqV9RvYzqRlab9
         ePRts0h9e4YGtOlx2hZeH4qb5Vi/CqjjRmLZidgnOcgl0Y3QHiplDFz4WNp4Zz1xzOAg
         h/cw==
X-Gm-Message-State: AOJu0YwBBCcGixGBYC5GfQDScUbQU09c2tF6cx4UL9cBe8KQiwj9Jq7D
	9xA4DSmKDZUtrYXAQo+o8kHIXa4WGb6cd8c1xBrhomsMn0BJM478+owVYMTInjoz2MUUv8dXXnn
	aiIkOtfX0oZG+
X-Received: by 2002:a17:90a:780e:b0:286:6955:6754 with SMTP id w14-20020a17090a780e00b0028669556754mr4112570pjk.0.1701929278700;
        Wed, 06 Dec 2023 22:07:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHakSW07VMFmxpuPT4j8IgOHUboQriYa+3kbDzZXxJKH7XjExkmQUWAyR/F1L+fsE6jaPU0lg==
X-Received: by 2002:a17:90a:780e:b0:286:6955:6754 with SMTP id w14-20020a17090a780e00b0028669556754mr4112560pjk.0.1701929278371;
        Wed, 06 Dec 2023 22:07:58 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090adb0a00b002887e7ca212sm431673pjv.18.2023.12.06.22.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 22:07:57 -0800 (PST)
Message-ID: <6f46b96b-93ac-894b-7dca-fead6829d396@redhat.com>
Date: Thu, 7 Dec 2023 14:07:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20231129030827.2657755-1-shahuang@redhat.com>
 <58b1095a-839d-0838-24df-f4cd532233be@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <58b1095a-839d-0838-24df-f4cd532233be@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/1/23 00:55, Sebastian Ott wrote:
> On Tue, 28 Nov 2023, Shaoqin Huang wrote:
>> +static void kvm_arm_pmu_filter_init(CPUState *cs)
>> +{
>> +    static bool pmu_filter_init = false;
>> +    struct kvm_pmu_event_filter filter;
>> +    struct kvm_device_attr attr = {
>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>> +        .addr       = (uint64_t)&filter,
>> +    };
>> +    KVMState *kvm_state = cs->kvm_state;
>> +    char *tmp;
>> +    char *str, act;
>> +
>> +    if (!kvm_state->kvm_pmu_filter)
>> +        return;
>> +
>> +    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, attr)) {
>> +        error_report("The kernel doesn't support the pmu event 
>> filter!\n");
>> +        abort();
>> +    }
>> +
>> +    /* The filter only needs to be initialized for 1 vcpu. */
>> +    if (!pmu_filter_init)
>> +        pmu_filter_init = true;
> 
> Imho this is missing an else to bail out. Or the shorter version
> 
>      if (pmu_filter_init)
>          return;
> 
>      pmu_filter_init = true;
> 

Yes. This is what I want to do. Thanks for fixing it.

> which could also move above the other tests.
> 
> Sebastian
> 

-- 
Shaoqin


