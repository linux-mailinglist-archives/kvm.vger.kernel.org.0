Return-Path: <kvm+bounces-34640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1761A03142
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B2251886348
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CFD1DF741;
	Mon,  6 Jan 2025 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LKeDUIsT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FA870811
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736194758; cv=none; b=qMJYRfAr1tGloKYLEMFPyT+6gm5jurysU1DzCzSv7RlnFANPqPxGWpZi1qI/2kPApLXtnjn1irPWfxziZ/ZZtOLn+tP+Hc0X2S6enUC/MMte9iEcJQo48D0JXP3+WnBzmMNy3AV9Us7LuVgML2MqiJg9/9HIEPaeL5SQAXiXxEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736194758; c=relaxed/simple;
	bh=M7fH3j7Cp8+Bx4ooqSEnVvpi3MR62uMBv0pz4A1YeRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QStbi2UCdAhYGdetvoEhfpvGdqECKWqzKbf8Zcxo2+fUwsfO4QonTzB5S43bHq0qvfkc6EivR3Gh1LudZs4FKOvsmob1vFyk87RoKgeAgKDzjj5YnmmLgwSC8U6j8QsxHd8Dye5qEjrpuIXCe6MgrMAAkqMHgoERPWhGKEVaWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LKeDUIsT; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2efded08c79so16903895a91.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1736194756; x=1736799556; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9p8hjeIMnEMUpmW04h0W7NoiD5E5c5Q5zI/Al9/E30=;
        b=LKeDUIsTljc6o7YmZBph6xkNXBmVTTgIwj9/ezJMGLtrBG5maeTplObpNDZdN+xmHs
         vHUNS7NIacSx6idQ8PjnttOw1aLjuZhavMWvXjKYlZgi+9qI1PK3lLlVyht54oQvipV0
         zESwiwWSfdVEXp1F8yvxGl8Eo88M9SK0Yh1n50V75OuuTedgVqBxvTh3040TRUnWtTI+
         hXd0/wyiE7pcVv20Cqpzyt4LNJfylsB2xMiM78cuEVlNj+pJ76cZz1yuesQYAqA4DJWv
         t4Ak83Ia1m25Mpfz+0fL4Ja7ExabMc7DhtZ6HgNG79fThOiXf7eau5PxqoZIrK3QRX54
         Ffew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736194756; x=1736799556;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9p8hjeIMnEMUpmW04h0W7NoiD5E5c5Q5zI/Al9/E30=;
        b=jrKrOF58+DiS0j9BFWO9WfrYaAQr1eFqYS1+BvKzEV7Em+bHpM0lpSOJhiAP4iZftF
         Ga0RbbzjGF8w6gWv4iClFeWjd1e8VZ6ckRtvsJftiS/b3UL09xvT6UG1vWQsfqOGr7OM
         KAg2UngiKR1svuJgknVIntz6ZFUIVS3vXLGONXHaqs0NbATLN8CDYrsgxnsmNRIc03nd
         iWxDli9pGlZfdFy991lL/HH9QVqvUzEWmh25Txya7L+qMIAjPodcQorXTDNzBHGEcI2s
         PTUeMCH94QhMmRYVNJN/YdeEaWQLpXsY4P2unB+KVBpXqf9kYjV4b+7f0oHbluu2WtUw
         Iw7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXaQxw7B0MD2HQsHqTwPoVlSR+gsU29lGoB3cQnbcsLu4O+Q2DpFy2bk/mEhl57PiwFU6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBvDZlxQnpAIrZ/eOrg1Be2RW9gX/1UZziw4U0+h3raO7F/Fab
	3ni6lw9pJcukwYTTPzPPiZPs5z+AjIs4+/Cg6v0gEasNEc4jkvArBU5tRvFRHEM=
X-Gm-Gg: ASbGncta06MqfHqb5Qugoo6UiKYe91QjLnyU/nkZpn23BWcDBhOzJvAXec4nsscwqMU
	+8ouusonlvS9fytdI40z6xL86/Z1/nTgV1xis/GGhICG1v3s1dviOrt0px+y3Ltl7uFi+N/9IZi
	yR7ISiW3l1RA4S+PG5EGODZgKruqGhlXjpR9wqwiQo+OxU981A2mRx85doFqb1UILxIUOukcB8t
	aWHaX9H4DQh3C4lc9rlI2qQmJhmpLVzDnLX+eZb4GNw7/8yXk4Y9GhNIKV8VYcyX//JkM4kJ+1i
	O8TYIb10u78FPLyeSsk4DQ1Gmif1pETQbv8=
X-Google-Smtp-Source: AGHT+IEdi1WeRPTrXeJrhazkx/sBhP2RZVeyTSKqrV/o+q5vpCxn6bBHpDXsADAKiAGaa0ShcqYeAQ==
X-Received: by 2002:a17:90b:51c2:b0:2ee:ab29:1a57 with SMTP id 98e67ed59e1d1-2f452def211mr85711065a91.2.1736194756055;
        Mon, 06 Jan 2025 12:19:16 -0800 (PST)
Received: from ?IPV6:2804:7f0:bdcd:fb00:6501:2693:db52:c621? ([2804:7f0:bdcd:fb00:6501:2693:db52:c621])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ee26b125sm39870772a91.43.2025.01.06.12.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 12:19:15 -0800 (PST)
Message-ID: <69e79cef-214d-4795-b3ce-032529c9f7d6@ventanamicro.com>
Date: Mon, 6 Jan 2025 17:19:04 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] cpus: Restrict CPU_FOREACH_SAFE() to user
 emulation
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Cameron Esfahani <dirty@apple.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Alexander Graf <agraf@csgraf.de>, Paul Durrant <paul@xen.org>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 xen-devel@lists.xenproject.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-s390x@nongnu.org,
 Riku Voipio <riku.voipio@iki.fi>, Anthony PERARD <anthony@xenproject.org>,
 Alistair Francis <alistair.francis@wdc.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 "Edgar E . Iglesias" <edgar.iglesias@amd.com>, Zhao Liu
 <zhao1.liu@intel.com>, Phil Dennis-Jordan <phil@philjordan.eu>,
 David Woodhouse <dwmw2@infradead.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>
References: <20250106200258.37008-1-philmd@linaro.org>
 <20250106200258.37008-2-philmd@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20250106200258.37008-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Perhaps add in the commit msg something like "it's only being used in
bsd-user and linux-user code"

On 1/6/25 5:02 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   include/hw/core/cpu.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index c3ca0babcb3..48d90f50a71 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -594,8 +594,11 @@ extern CPUTailQ cpus_queue;
>   #define first_cpu        QTAILQ_FIRST_RCU(&cpus_queue)
>   #define CPU_NEXT(cpu)    QTAILQ_NEXT_RCU(cpu, node)
>   #define CPU_FOREACH(cpu) QTAILQ_FOREACH_RCU(cpu, &cpus_queue, node)
> +
> +#if defined(CONFIG_USER_ONLY)
>   #define CPU_FOREACH_SAFE(cpu, next_cpu) \
>       QTAILQ_FOREACH_SAFE_RCU(cpu, &cpus_queue, node, next_cpu)
> +#endif
>   
>   extern __thread CPUState *current_cpu;
>   


