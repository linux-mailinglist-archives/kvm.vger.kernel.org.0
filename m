Return-Path: <kvm+bounces-13539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8EA898691
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E01C1C215F3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 11:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C8184FD3;
	Thu,  4 Apr 2024 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GHw7yOx5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C4784D35
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712231860; cv=none; b=diScfrnuPAcq3V9XiVDJ2ctMZRWokHmlU3tBnSDGsIoQDH7SZ565mGifMLBnqHBiV6UL/oB5a/s66H2HBex++GILpxHB5Npp20MnjnpIit1w44P2MVdSU7wkRz7axsB6d0ZgJKDnRhls03PpVAVOIHllek4RTPFje1klu+tk7ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712231860; c=relaxed/simple;
	bh=r2y5XgIeaVFD9YYVCCQXxvPJe8jenW3QZdB/CzLVRdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0Mo6EN1xl7JjfaP2bA8nHiVuVq1zdMM5sZmBc6uB9cTcMFGV/Ieli8Qe4yAxA1tJqZMmLwOqh/733D27cKZAp+Y1SXbZ7CrjRlk/0o5Q3gxB2fJWzSPpldCcgH2wmBAoNprAnGd/gmdrBiDMuJi4l+uuqK5ZqVVXR6JBWH1YbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GHw7yOx5; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56bdf81706aso1196012a12.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 04:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712231857; x=1712836657; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWw71C7jU1cEwI+5ODGcknLMAR0yYHVr8hihh6Lqglg=;
        b=GHw7yOx5X/R0s614/5Rftzsrr1O3kiprSpaywNMKFkoxb2PHZ5gMMWYTnBDonwIj5u
         W90RiXYhSFTzTc438kzJKNdb/BvBFWI11G/3uXbuC5BoNNl6HieILMP8xPUeJsI8UlaK
         +mbFivmR/knt0tOhbaYVybM8RaXMDjRzBnmOvY4NgbVr3duzsdmHGa044Qtcaly83HYO
         t/4ADBu49c9g/JplcxZDIzQrAXw7dkytaQ3S/V9pvxJ5MCYOQ8waR21dA/74GK1EzAnU
         wxNrZ3aIIwJ6LqfFgNl1LfylufRqSPE4hdF8DEqE5vnhA2t+bwtuRkAd37BKPkM9yNUD
         E/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712231857; x=1712836657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWw71C7jU1cEwI+5ODGcknLMAR0yYHVr8hihh6Lqglg=;
        b=LFyd26eky7XJhLUh60RmmdsZ4l49l5vusokIDOzxU2imIAwPvy2lJG7qCHUbEPFQ4W
         G48hi50O252qeV4QYclnweSNpExvjQ4hcJym6/nI7aXCtt2ZLOM6QHnEmLVgZCpqizT1
         Zg8pEk2Hf+uLDeY1hB6aAdKBDdfDEG+h1IK2wCeCYyeZMmWq/XkVj80snilcxKalUQT6
         tNq44TWPFS1mWjrTqnOj94pY3wphGRJRvb4isAUUiE2S+QXDlCKFpJQNf9v+Y95mTM22
         cyvEj6scj9JMQii+RKirDjFhIdNLC1Amih4eAGAdiJyN+shy2DFa3VnF+Da/TB83jGWZ
         LDxw==
X-Forwarded-Encrypted: i=1; AJvYcCWF37EUHosUT3bqDzq/93k9y4QOpUJabVjSYrfr+nF76Mt9jIy9WaDQ2g2iGJFsapC4GE9Bqn5rsFt2ufKrOYzfllpa
X-Gm-Message-State: AOJu0YxW9hEi9bqsRMXXKTQdXGBq8AGestNo7ke3Pz7GggdrpN7hPLGY
	3DG7YY7mz2S4iyBb6BR7ZVK+s7jw4juqg9ba9wwIqr2JzaoMenu3IHuv9sn5vJs=
X-Google-Smtp-Source: AGHT+IF8SdqZ3HyZZ91FGKimTKayOc7UTusAbOGT6GeUZ2TkAX0/2dzA77WUR8ICDxbEhjc/oE44yQ==
X-Received: by 2002:a17:907:c0d:b0:a50:f172:6994 with SMTP id ga13-20020a1709070c0d00b00a50f1726994mr1816047ejc.73.1712231857594;
        Thu, 04 Apr 2024 04:57:37 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906538f00b00a4e98679e7dsm2355698ejo.87.2024.04.04.04.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 04:57:37 -0700 (PDT)
Date: Thu, 4 Apr 2024 13:57:36 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Ajay Kaher <akaher@vmware.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <amakhalov@vmware.com>, 
	Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v5 08/22] RISC-V: KVM: Fix the initial sample period value
Message-ID: <20240404-1c3dc9b63f80fc451d3a732a@orel>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-9-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403080452.1007601-9-atishp@rivosinc.com>

On Wed, Apr 03, 2024 at 01:04:37AM -0700, Atish Patra wrote:
> The initial sample period value when counter value is not assigned
> should be set to maximum value supported by the counter width.
> Otherwise, it may result in spurious interrupts.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 86391a5061dd..cee1b9ca4ec4 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -39,7 +39,7 @@ static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
>  	u64 sample_period;
>  
>  	if (!pmc->counter_val)
> -		sample_period = counter_val_mask + 1;
> +		sample_period = counter_val_mask;
>  	else
>  		sample_period = (-pmc->counter_val) & counter_val_mask;
>  
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

