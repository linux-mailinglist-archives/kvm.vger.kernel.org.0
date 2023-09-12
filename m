Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E816379CFCE
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjILLZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbjILLYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:24:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F1B1724
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:24:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c3bd829b86so14936455ad.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694517873; x=1695122673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMSVWfDKGB85VIlcU/SXoOrl8HpXYWQvEmj0v+X5nMk=;
        b=ItYtg9GXIBZcIo62dgNKBA1KmsM/wcbZmZxaO8faSUk3JWRMPxi/4ahbXJiB2+5PgD
         3Ov6qXATuhWRJZyzji0CvEVCh/DBvmVFSI+VtCGFZ00INWoLCp81d9AQenh8LEkNS/YG
         Y0fxhNxAP2POBIBVYpToMDCwtezF3x6U6MWQ6JlGaKoSVyo59Q9t1bk8z8PO/k0dou2+
         PJAoHS61I27YOAlJK4hfgYCPhovD5a2/+vwk81dJiZIIVz6pniRqbBybP2bp05gUFthe
         h76erj/t+P9bke4NAMoPQ/FFf0pubUfaisUf6tJns2CAHb1lWy3AcaQf698R04RawB9z
         X7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694517873; x=1695122673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMSVWfDKGB85VIlcU/SXoOrl8HpXYWQvEmj0v+X5nMk=;
        b=Dciw4/mXgXNg/zY4f4z6tKEuXKuSJuQlILwQ7VvvSlcp9W/a8N9rFOjwQZg50EUzDv
         0wRzHIbH9adKu7OIb+tj6cZLyI7yLrehtDI+2dibBEZfZSp+WzZMvthSdyHl2ilbuSvj
         zKqpYrfs7/emVGGnM0u0GObwe+IdT1Vav36RgEekT4IulS3L4sm84Ewvs3hetbZaJYxs
         vO0hI5c4bLSo0ib1yiGs76sa5Dz0UWKGG64RncHklWeKcWO+y4jSLXg6F+4ROgwUy8p7
         jPrNFrDUqktVBkscQjQ+5PYpYJpb+GGQQ3kkaWYtBDSDX27E+0pPVt0auFLkg0Sqxidf
         H1Yg==
X-Gm-Message-State: AOJu0Yy3kj1QTF232KoJoGnnMsBs+Y5pixFWUWW1HOrhTYAxQY6E6PH9
        rsEwBrmyZOMC1jLhsumxsh0=
X-Google-Smtp-Source: AGHT+IHRQ+XP2QSWJyOSUQyWow6rQ87ODoPQvoTbSEbYMPJhjNZJP92wrhZ3Sji4NXU5czl93lMMog==
X-Received: by 2002:a17:90a:9f06:b0:26d:ae3:f6a7 with SMTP id n6-20020a17090a9f0600b0026d0ae3f6a7mr10268903pjp.21.1694517873419;
        Tue, 12 Sep 2023 04:24:33 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a1a0f00b002680b2d2ab6sm9767038pjk.19.2023.09.12.04.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 04:24:32 -0700 (PDT)
Message-ID: <d0cf6ba0-94af-2ffc-b086-b90572e5ce98@gmail.com>
Date:   Tue, 12 Sep 2023 19:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 7/9] KVM: x86/pmu: Add fixed counter enumeration for pmu
 v5
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com,
        kan.liang@intel.com, dapeng1.mi@linux.intel.com,
        kvm@vger.kernel.org
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-8-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901072809.640175-8-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/2023 3:28 pm, Xiong Zhang wrote:
> With Arch PMU v5, CPUID.0AH.ECX is a bit mask which enumerates the
> supported Fixed Counters. If bit 'i' is set, it implies that Fixed
> Counter 'i' is supported.
> 
> This commit adds CPUID.0AH.ECX emulation for vPMU version 5, KVM
> supports Fixed Counter enumeration starting from 0 by default,
> user can modify it through SET_CPUID2 ioctl.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 95dc5e8847e0..2bffed010c9e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1028,7 +1028,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   
>   		entry->eax = eax.full;
>   		entry->ebx = kvm_pmu_cap.events_mask;
> -		entry->ecx = 0;
> +		if (kvm_pmu_cap.version < 5)
> +			entry->ecx = 0;
> +		else
> +			entry->ecx = (1ULL << kvm_pmu_cap.num_counters_fixed) - 1;

If there are partial fixed counters on the host (e.g. L1 host for L2 VM) that 
are filtered out,
L1 KVM should not expose unsupported fixed counters in this way.

>   		entry->edx = edx.full;
>   		break;
>   	}
