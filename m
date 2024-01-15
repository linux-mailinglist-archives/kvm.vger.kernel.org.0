Return-Path: <kvm+bounces-6262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C920682DCCF
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 781EB2830C6
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818F717BDA;
	Mon, 15 Jan 2024 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ljK4u4OE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F14917BAF
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-555144cd330so10935721a12.2
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705334210; x=1705939010; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tjUTYBPkXCa7XWbbKGG7vPNvPFoPanfB3aOFNe3Yut4=;
        b=ljK4u4OEihvcZtXVOdjN1YEqO+rTcQngk4807byE4iiJmo+ZmIhGveimBBUciUT0qZ
         ldjhh9BxrOxTx1dzwreEyDfoBzh3LiQRYK88nD6LJzPwFRn5k7JeRnh+3W7zh5l465+x
         JDAv9TSbas/2d6QhsUIQsRRwtVIAW5l0whEg8uEb2LwhSV7uIJJI5ChTQEzy0YribhR5
         EhJwAy1WxOTP6e2IjowGgYG/Q9VXLndAwvgD2hLMEnTphGPKtonGSGSvA9XkhBAgaJgK
         SFa4+TZ6bnYPP1K3pUgCFzeeB0/MxsktNAoRKWGSLA2da8u0EvuJfotVVzMfi1DOeHiz
         qYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705334210; x=1705939010;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjUTYBPkXCa7XWbbKGG7vPNvPFoPanfB3aOFNe3Yut4=;
        b=PsJY6DK/OGzwGgqFydatT/P1wHaf8nv9iYqPZlAodHrerhK81wwtct/x4ebJk7WH64
         QSw7KgZAmcwjqdK5ospw2tYCJC787ThNnWQIw/GKqAeU1OE+uuBA5MEOCV8psbZdcLFN
         02ZUvhXeq0SRlGy4Clx/ldFPPTt/JFF8S0xn7e7lzB6SI19Ysx8S19HpxBOKy5+gqsPt
         RACVAMtzc9PZ4J8YRV9vWN7O2M/qE3OBHBuig912vSgmdFIsYwqsWF39VWxRtMV09sVF
         P1QNYzMqlakFWg7Wc1E6RrVHjyDg5L+BKHvmwWEqEpTHC71ipZvKILyP9AcHoZ26o9qS
         vlnw==
X-Gm-Message-State: AOJu0YythMgwxxweBV3rDH/SZu8xmwTpLUEeab/2LQGU7SatJLHtVYIb
	B3f4gBUCxEKxheUxvdXW0dKfqz88ApTtGA==
X-Google-Smtp-Source: AGHT+IGsBQi506iCN/EypiMhdRtPrpz7QX4dvGNrnRHaLGW9vy/fghBvzgHOu5YJwCvgL7dkcuGZCA==
X-Received: by 2002:a05:6402:7d6:b0:553:83ca:60be with SMTP id u22-20020a05640207d600b0055383ca60bemr2985978edy.4.1705334209869;
        Mon, 15 Jan 2024 07:56:49 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h12-20020a0564020e8c00b00557aa8d72c9sm5549635eda.25.2024.01.15.07.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 07:56:49 -0800 (PST)
Date: Mon, 15 Jan 2024 16:56:48 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 14/15] RISC-V: KVM: Allow Zfa extension for Guest/VM
Message-ID: <20240115-572f0e469dc54dd3c42a5313@orel>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
 <20231128145357.413321-15-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128145357.413321-15-apatel@ventanamicro.com>

On Tue, Nov 28, 2023 at 08:23:56PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zfa extension for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

