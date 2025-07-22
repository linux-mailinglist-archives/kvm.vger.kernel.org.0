Return-Path: <kvm+bounces-53170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1461DB0E499
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 22:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C46EC1C20EA6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 20:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59A7285071;
	Tue, 22 Jul 2025 20:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Tkfe1/Hm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952AE284671
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215193; cv=none; b=TvBf+kbzd93GdKhdKvZsT4qgWH5K/T3eSp0wXidmGBztJuwGUn0foKQ2fIFAojAB6rhECSR8LevnAQvYrvECr1+GZzNTEKxnFt3lBrD23Qv+4+LhQaXoCxVK5G98uBOhyTfEiXc62QNsZcP/X/5pd5oL8ZowvsKD+D5y2AI46u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215193; c=relaxed/simple;
	bh=QVaZGXJtdV2GzW1jASWnFjuxxTycI6lAHoUrlC82W1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gVv7+/l3jOmOn2PCbpBeECYTsdKbXLSvOsbYkEEqrjGn3AFIL8rJRt3k3b3g0SJdSWmi/L4IPMOWHxe1DTA/RcnJG59UttkJVaKowdpsS/ZHfKHWEeDhzNJsqnHwxEa0h1q7n+wq2RwpJCJquUheVuMORdSnJC4f3Pbi8r+9vJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Tkfe1/Hm; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-748feca4a61so3289238b3a.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 13:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753215190; x=1753819990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yhLALA9B3rULq7Vw42aLBvPtSaoo7MaonmbLRVdlFf8=;
        b=Tkfe1/HmyxYW8Bmo6BS55wksZp3aapco2RGbblsjna+68vp0R0CwheW94HhnSatPeV
         3vEgTO4Dwo7kY97MedfdbfOLNX7QoRowZHPjpadQwqLIlvQGOJf4/6eTcehcikQ733lu
         1XbVlroqj1JnAES2h+bfI1P0690na5tjyLzoLssZYgzZRGnyFXYcqiSsLY8FNuYdOlzX
         X+19J8BBSbvSSMSh8swwGTtexReKbyZJLdH4B6ToUzG6MdeENTJTtRcWTpfmTWtJBLtZ
         UtHfy9FP7PRbATZ6BkbA0j1Wazj5sVoWMU9JQojTSPCr03FysgXOXy2PdIib8JNsGYOZ
         DSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753215190; x=1753819990;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhLALA9B3rULq7Vw42aLBvPtSaoo7MaonmbLRVdlFf8=;
        b=dzM/2aLkb+JtCb3FQW7vVxVSgLqbwzwPXdquBjkbpK/vuHt7Pj9DFuTcRgZpRRd6Fb
         FLsqDLlGo/+WqZItrxgSjmkvMZ/JE9ctq/AjC5saRNj03v03madYfI9IOt6Qkx8BEDYp
         +7DF5LdOUYWMlLlMi5D/mMmUlRAKG3UMj5WvBphiC7yreAR/QfrOJTBrOfuwFINwkkeE
         h8X8U/BKF8Z/y6cv38BCJbit4Yv08GmvAA04onQPqI/HPn5BhmtRjYqofOGmG5Dr+ocU
         shAp5cZtLz1/yHylCIP0D5cTa29J8jJqeDAX/bHSMMeG5VrHgTpSrTWVXabmEfq5XlhW
         rEfg==
X-Forwarded-Encrypted: i=1; AJvYcCXpWbOJhdNJIkvw1casnR+rWC7JegMyd5YYoKyiEBR4ztz6UfSAk+0+3dGsuXGA4I+dvkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPHTVX0cCYu4o46vh1kqYX3FHqiXHImqRqZH/cJkiJemWDr3hO
	IbG+sgCZ6F9rU7V+IQ9PpdGhdfLMGpMHPWVyN2bBzht7NJDjZpmkUWQkFw1VBRwOz44=
X-Gm-Gg: ASbGncs6jVgps7GSMfZHa1lJsohDmFDWKIOK6nVe54kVz15M5MoFIHKAGARRqeH/AwB
	oTvQZMhrR47Z8RhySawvhZWStro704BD+WOE9dzdca8awUoNRPuABcIBIPzBFfGfwkMt1H4ebQv
	DWTCpJY7Gn8SHARfA1VK2vQP/FTA3OPF6V9xQfMxvv7Sa/y+mQtIGOz90aGTKaVtQ7pHLRgTw1K
	8dp5jDIWvAvqb10sHGN07XaeUq2AdkgcFxQIrcd5sCSezOgQMlzZwifa0It3xSPpoiehBdgwjUJ
	dpOLldBMX6PFLMtHtrBBOt8ZyOhFilZkm3JY0oT64L3N4s1Q5qtAz6MnRJGPNV1hzvVVp3h0+3R
	AbiL3H7VZ+cHWr/nveWu8uBForhgChwaeZjO959r2XM5d1bxQH6xnLnj8x19ZORWbr+JTLTWDJR
	oKruUmbioynsnvlsdU7LnKkNck3NDEjoWLk4o43a0DttQfdTSrVRjOqZA=
X-Google-Smtp-Source: AGHT+IHYPk53nUChKVapkUHv3H9H6FTfDsjozDyj6Fty2m+Mis+ubcSsO3JOGJKE76bJMrILGMXHgQ==
X-Received: by 2002:a05:6a20:3c89:b0:234:8b24:1088 with SMTP id adf61e73a8af0-23d48fe0481mr291696637.3.1753215189831;
        Tue, 22 Jul 2025 13:13:09 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ffbce6esm7519095a12.72.2025.07.22.13.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 13:13:09 -0700 (PDT)
Message-ID: <834dd439-34dd-4cc7-a1cb-ffe3b95ec460@grsecurity.net>
Date: Tue, 22 Jul 2025 22:13:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
 <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
 <aH9yuVcUJQc4_-vP@redhat.com>
 <c2d2a3e9-e317-4049-9b6d-b6b3027ddd6d@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <c2d2a3e9-e317-4049-9b6d-b6b3027ddd6d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22.07.25 14:21, Xiaoyao Li wrote:
> On 7/22/2025 7:15 PM, Daniel P. Berrangé wrote:
>> [...]
>>
>> Usually CSPs don't have full control over what their customers
>> are running as a guest. If their customers are running mainstream
>> modern guest OS, CONFIG_STRICT_KERNEL_RWX is pretty likely to be
>> set, so presumably migration between Intel & AMD will not work
>> and this isn't making it worse ?
> 
> If breaking some usecase is not a concern, then I'm fine with no compat
> property.

Well, there's still the chicken bit `-accel kvm,hypercall-patching=on`
one could make use of if (and really only if) that's really needed. But
I'd rather have the guest see a proper exception emulation of trying to
execute an unsupported instruction than seeing a bogus #PF.

Thanks,
Mathias

