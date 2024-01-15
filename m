Return-Path: <kvm+bounces-6257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 204B182DCB5
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B57EAB21CD0
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0399E17BB6;
	Mon, 15 Jan 2024 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="S8Brntid"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5F117984
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-553ba2f0c8fso9858572a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705334156; x=1705938956; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+xTwuofjQl5aKgUIjY8NZTzaNnDkG+zx3D4vMfYK3I=;
        b=S8BrntidVKo14kOA6mzTlmJSqPiPIs5A0F1ViOWyzF1Draa43ZKtj+AmaBrzwvcJ7M
         /hb6URHhRqcN8N9RS68Iy0fcma1GFu3FMqD1/xFf/WL5py1VjrScP/7m7oDoDYYcWMog
         0FVVDHewu+Yo3tBk5IRiwGFjpAx7YIW4ZC40VvU1tH/In/iwd1AL2J457wVjUiv0E9Qt
         toONLYdN4zmB6TKQY3lKjY80+6Yqnutryy5fyuCTndHYnyAQlaNfDcgTFWt1xjJDmwIn
         sD4pc1wplQ7/pyt7tcdAqFP1YJDpeHHjSmgB2b3Q9KLp40Zpe5UR0vCoy1usR7wtc2iW
         qKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705334156; x=1705938956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+xTwuofjQl5aKgUIjY8NZTzaNnDkG+zx3D4vMfYK3I=;
        b=Fl4y4u7z/KSwZofidxsie+RSmWBv1nz3sXnpId0mplq+WdCxal3NzkrZd12ATY6RfC
         lxERFIO4ap3OMPOIh16OxTE0iO0CmRh1WIyOaSR8Uve4RfoRNlfhYavFXzyYLAti98cW
         Wm90Q2RMG5l/so0ygm5qDNOU2sWkt0OvYn6zpAV8F0FzjV1E8UL7DRr80CiryCiKiYLr
         CdNbcUQk4+Ibe+BIIW2AQCGyr4loFPvYGdf/PEpUzm21JNKAl5ZqkMvrsPsqqi9AVK4E
         bhXO8HrqUsXlBUrY/pRItpWcO7mBXZ2HEpjSGVgecze3BpRXV7XLV/stV2B4IpB7L4sE
         aD2A==
X-Gm-Message-State: AOJu0YwxR6hhU3BNVqdPf4hEAEnk4ZtokYSXsnrtKeUmBWl6coZpK8Dr
	J6s/kenuvcXFS0E5BlHrkEhLoh+MCt9Thg==
X-Google-Smtp-Source: AGHT+IFoM24h3CeGlI4z1Wf7BKBwwl23upM286tKeBN01c44mvVDI4K8ywmNnWZGwLdbFaiQlu6pcA==
X-Received: by 2002:a05:6402:b52:b0:559:79a4:f104 with SMTP id bx18-20020a0564020b5200b0055979a4f104mr47138edb.74.1705334156089;
        Mon, 15 Jan 2024 07:55:56 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id bo13-20020a0564020b2d00b0055627eeb8b9sm5581547edb.32.2024.01.15.07.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 07:55:55 -0800 (PST)
Date: Mon, 15 Jan 2024 16:55:54 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 09/15] KVM: riscv: selftests: Add Zfh[min] extensions to
 get-reg-list test
Message-ID: <20240115-8c3ba83f0b3036bfef72b786@orel>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
 <20231128145357.413321-10-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128145357.413321-10-apatel@ventanamicro.com>

On Tue, Nov 28, 2023 at 08:23:51PM +0530, Anup Patel wrote:
> The KVM RISC-V allows Zfh[min] extensions for Guest/VM so let us
> add these extensions to get-reg-list test.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

