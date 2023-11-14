Return-Path: <kvm+bounces-1624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 963407EA8E9
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 04:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5EE41C20A0E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 03:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C999D8488;
	Tue, 14 Nov 2023 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TsGs7LhJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E987E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 03:08:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7333C1A1
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 19:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699931323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7x45WdPmpvw0PcEuc4+yK1/4uClaBNHsZQ2i2OvfpE=;
	b=TsGs7LhJulx/cU5NYHnPzU6Bm0L4A3QgygttTrlHqYeB31LzaxJsRlGJ3GdrM9GZJojDeX
	R8Wp7a0O0AKT9oiJBxFk/pQv7mnsC5azjEQE6zhaCB6A4eJdZbDs93Rja3bVLv9zjXN0CN
	XQsw+fHQED2kUPr0Y7/0jujhPRjDWbo=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-wTXUTjveO5mgMf__OwppjQ-1; Mon, 13 Nov 2023 22:08:42 -0500
X-MC-Unique: wTXUTjveO5mgMf__OwppjQ-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b56a26c64dso920006b6e.0
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 19:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699931321; x=1700536121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7x45WdPmpvw0PcEuc4+yK1/4uClaBNHsZQ2i2OvfpE=;
        b=Tp3SXuI/gEw53dVqcNm5iAw03IpU7pqfaQS5II77ontbgWEantFulIJ/w/I4LI8yrq
         uxjMr0itDRZM0+kCjV8oLhoqf4AOpJKYgMDPotG4YikATrN7KxMDjqJoPhYWZWm2Pp8x
         UF1jnnNA7WD8ZoEd5rVdj8WXh+iWi3I32Jy6r6TqqbFqrPsBDKUmejv5o+HiVguySxCT
         ljs+8UTY7DV56ddzmYhI7g7K3kfKDJB3f7widaDKyheA8iEqGfiIaB+fVO+NBYdYAN0d
         oM1Kl/OWUprJXz4NG2BpG/STF9TEYoZzxYOlpqqIiRd+3KsSlNTpbNOCQjEnqIPfvdMY
         G4zg==
X-Gm-Message-State: AOJu0YzqTa7BV3NYeCu0RNpez6HsVa0A7VVYfDSk3hIUMdQ2XU+4tbGs
	dAEIsAh37cGmsBEv7UIIshTtaZZeSQQfFVpy7z7NVnyEsCuOWP/Ak+TyxRysZZcX7r8f0jUwYwF
	n1uckki6hSj6a
X-Received: by 2002:a05:6808:f8f:b0:3b2:db33:e301 with SMTP id o15-20020a0568080f8f00b003b2db33e301mr1241669oiw.0.1699931321369;
        Mon, 13 Nov 2023 19:08:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFulG7DjXfxFgcPpwgR1kQryaWW1aceQmnP+c2sLz9WmLZsKs+hXebP6+Ez09n0PX8uTNnW4g==
X-Received: by 2002:a05:6808:f8f:b0:3b2:db33:e301 with SMTP id o15-20020a0568080f8f00b003b2db33e301mr1241657oiw.0.1699931321114;
        Mon, 13 Nov 2023 19:08:41 -0800 (PST)
Received: from [10.66.60.14] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y64-20020a638a43000000b005bd980cca56sm4751815pgd.29.2023.11.13.19.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 19:08:40 -0800 (PST)
Message-ID: <00f7b062-e967-f1ed-bf2e-f0b86be60287@redhat.com>
Date: Tue, 14 Nov 2023 11:08:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 1/2] arm: pmu: Declare pmu_stats as
 volatile
Content-Language: en-US
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
 maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com
Cc: jarichte@redhat.com
References: <20231113174316.341630-1-eric.auger@redhat.com>
 <20231113174316.341630-2-eric.auger@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231113174316.341630-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/14/23 01:42, Eric Auger wrote:
> Declare pmu_stats as volatile in order to prevent the compiler
> from caching previously read values. This actually fixes
> pmu-overflow-interrupt failures on some HW.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a91a7b1f..86199577 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -328,7 +328,7 @@ asm volatile(
>   	: "x9", "x10", "cc");
>   }
>   
> -static struct pmu_stats pmu_stats;
> +static volatile struct pmu_stats pmu_stats;
>   
>   static void irq_handler(struct pt_regs *regs)
>   {

-- 
Shaoqin


