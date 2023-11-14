Return-Path: <kvm+bounces-1625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA3F7EA8EE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 04:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30803280FFC
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 03:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7706A8F7D;
	Tue, 14 Nov 2023 03:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJ9s3Ici"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116C8C01
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 03:09:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4BBD52
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 19:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699931348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hp9NampF300W3gHTU5Rkf8ZhuXrSkcBWcS+u5FtpskU=;
	b=IJ9s3Icimr2iwMwjAiAqvIvXIt/iM21b2zS1BpdEwia4KqxW54y30loCNsb6LrjHezp3Rc
	plVGSIW1YYp6sUNBsdyU0DZUPqPr6MQPLzL5vVuE/2Y18y2y999pIV0DJxzbf3bLoMpfle
	4RHqnbLB/99+dJgGfCS5Q7HcAbVhj6A=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-Ah2SzYdxNRSacVwjBVZlnQ-1; Mon, 13 Nov 2023 22:09:07 -0500
X-MC-Unique: Ah2SzYdxNRSacVwjBVZlnQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5b99eba29ccso292033a12.0
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 19:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699931346; x=1700536146;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hp9NampF300W3gHTU5Rkf8ZhuXrSkcBWcS+u5FtpskU=;
        b=IYw4JgLf2paRkcvinVR96fnLL7Qx5JOLnFP6ck9gCyIZBnd8z1PA8Ruk2U7o570E1n
         moPWkyZDiNr1kOk1KMbfM+AR6s38v0Oh0r5wd3K7N8lu/Rh66IJWER8bo4DVURUUK+Q1
         wj4fm5UTb2USgkT8rE/Ru0DkYk/VkYRqozLzHa7FbAv5sxbxVFE0AcR50WpCJzTJJ4B7
         EikUbkdw4adSXRaRNBDaho19RZhOAmqDH2Llvkd4GIsXQdCg+gUXNq+01jFZgjkI19Aj
         Az6Rp1Ko7zp2DaBpqYP4aLyKEAmP9p8Z/ZwH0yvSaoawTDM6URZIiHfYa4mH7PFw8Wlt
         ZjVw==
X-Gm-Message-State: AOJu0YyuqxBhwsLt1lMt10yhyJdnWtE4r1Cfva1sVF1DSRlSg+yzPMGU
	bM4WXyGXHq4IJpQThfduf2PoKswdM/lIII22hJHfP0D9KHQw8Ze93LN428PxrQ6gFrEdaGhF3jL
	ksNd3JtNYIXNG
X-Received: by 2002:a17:902:d2c9:b0:1cc:2bc4:5157 with SMTP id n9-20020a170902d2c900b001cc2bc45157mr1308374plc.1.1699931346028;
        Mon, 13 Nov 2023 19:09:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjhLJ78Ag8ckdH6Gu8vstIBdIUeQdCT8yovhIJcWQSkQvlL97nftM1exog97M5/7oEVtIkJw==
X-Received: by 2002:a17:902:d2c9:b0:1cc:2bc4:5157 with SMTP id n9-20020a170902d2c900b001cc2bc45157mr1308358plc.1.1699931345660;
        Mon, 13 Nov 2023 19:09:05 -0800 (PST)
Received: from [10.66.60.14] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902e98400b001b9c5e07bc3sm4746920plb.238.2023.11.13.19.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 19:09:05 -0800 (PST)
Message-ID: <a82f0e42-9d47-fa3b-302d-2a30c38198b2@redhat.com>
Date: Tue, 14 Nov 2023 11:09:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 2/2] arm: pmu-overflow-interrupt:
 Increase count values
Content-Language: en-US
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
 maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com
Cc: jarichte@redhat.com
References: <20231113174316.341630-1-eric.auger@redhat.com>
 <20231113174316.341630-3-eric.auger@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231113174316.341630-3-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/14/23 01:42, Eric Auger wrote:
> On some hardware, some pmu-overflow-interrupt failures can be observed.
> Although the even counter overflows, the interrupt is not seen as
> expected. This happens in the subtest after "promote to 64-b" comment.
> After analysis, the PMU overflow interrupt actually hits, ie.
> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
> as expected. However the PMCR.E is reset by the handle_exit path, at
> kvm_pmu_handle_pmcr() before the next guest entry and
> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
> There, since the enable bit has been reset, kvm_pmu_update_state() does
> not inject the interrupt into the guest.
> 
> This does not seem to be a KVM bug but rather an unfortunate
> scenario where the test disables the PMCR.E too closely to the
> advent of the overflow interrupt.
> 
> Since it looks like a benign and inlikely case, let's resize the number
> of iterations to prevent the PMCR enable bit from being resetted
> immediately at the same time as the actual overflow event.
> 
> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
> used in this test.
> 
> An alternative would be to let the PMU enabled and wait for the
> interrupt but those extra executions might disturb the counting.
> 
> Reported-by: Jan Richter <jarichte@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - Only increase mem_access_loop iterations
> ---
>   arm/pmu.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 86199577..4b388899 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -66,6 +66,7 @@
>   #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>   #define COUNT 250
>   #define MARGIN 100
> +#define COUNT_INT 1000
>   /*
>    * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
>    * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
> @@ -978,7 +979,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>   
>   	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>   
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>   	report(expect_interrupts(0), "no overflow interrupt after preset");
>   
>   	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> @@ -1002,7 +1003,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>   	write_sysreg(ALL_SET_32, pmintenset_el1);
>   	isb();
>   
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>   
>   	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>   	isb();
> @@ -1010,7 +1011,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>   	for (i = 0; i < 100; i++)
>   		write_sysreg(0x3, pmswinc_el0);
>   
> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
>   	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
>   	report(expect_interrupts(0x3),
>   		"overflow interrupts expected on #0 and #1");
> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>   	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>   	write_regn_el0(pmevcntr, 0, pre_overflow);
>   	isb();
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>   	report(expect_interrupts(0x1), "expect overflow interrupt");
>   
>   	/* overflow on odd counter */
> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>   	write_regn_el0(pmevcntr, 0, pre_overflow);
>   	write_regn_el0(pmevcntr, 1, all_set);
>   	isb();
> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>   	if (overflow_at_64bits) {
>   		report(expect_interrupts(0x1),
>   		       "expect overflow interrupt on even counter");

-- 
Shaoqin


