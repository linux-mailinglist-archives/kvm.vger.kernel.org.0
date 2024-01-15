Return-Path: <kvm+bounces-6260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C7482DCC7
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2931F2293B
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC5917BA7;
	Mon, 15 Jan 2024 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LP0YHGQm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593CB18627
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40e69b3149fso31287115e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705334186; x=1705938986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSX8YdFzGW82k1HdFW0Ew9PXwzmjRfEttmlS+50xEwQ=;
        b=LP0YHGQm8PcxkRd7m63lrnURJ2YZI8XrNrBvgfr22uzg4bLj7SUxOIMM1xxFdwow+Y
         iA5Emi0tISf8e37sPu4Ur8CVBKXZan9P/1LyNZ2dFpX+IQQt2uuSHCs9mqLopISBd/xY
         E4pgA10T9Q5QcZ5zZk6o0v7UQytSHZte6gfdCQDjNh9ANvH7p8CGssccSDmKUM7pZv+/
         S6Bx89+3Ks9960fuHFti8PR8e1y11le3s5m5cpJLk/dS2j7XYJ/rMijadOhupEMYMBpC
         vGKrhvRHJQlgf+tgocD1ozmYpn6K5WEuUwV4RctJV0oJE1BXJjXrl1X4LwtM785xTBZ6
         3UHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705334186; x=1705938986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSX8YdFzGW82k1HdFW0Ew9PXwzmjRfEttmlS+50xEwQ=;
        b=mS2Kenxua07FNfbjQwSiC652qdTYaFbcP2wMLHXI837JZKEgfDLnR11ygc5TGYSoaZ
         +RQtsim45NleGxIYIAsp8DHvj938bruYYjCwzMQ1gh19kgxKtWPyOKnF3uw5S49l3u+r
         dEPL5vXEplX1w06st59KL8GS3o5l1g6zdEVkWI/xS4FD9UkIpmFQh4vHTCkm3c8gNg2z
         17/My/lTyB//D4IsWJpYBrb5pEBheHAq6BtYgEuSK+1qIYnT5oLrw89wW+ogy9JUxNe4
         rxLkM/QaUiYMM5XUX6FR8wKwyVC5WrRrzerhxjplHBWFCg281Ye98k77p5ZgwMc0OaUX
         RBxQ==
X-Gm-Message-State: AOJu0YyTb8nXYK6Bww0hXZWHC6RJdJiQujOCAlzx0ibOVStaIr7SD0an
	2CanMAtbz2C1ElX2608znXVZ4JN8IOHVkQ==
X-Google-Smtp-Source: AGHT+IEruJdVb7p+/kL6fqf0kR36CRwMRTN2BNXTkrz1F06Va6YdQFwiI8onEGvjOtajrh0pa0AUQQ==
X-Received: by 2002:a05:600c:5246:b0:40d:ecd9:bb99 with SMTP id fc6-20020a05600c524600b0040decd9bb99mr3395375wmb.124.1705334186521;
        Mon, 15 Jan 2024 07:56:26 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m23-20020a17090607d700b00a233efe6aa7sm5410163ejc.51.2024.01.15.07.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 07:56:26 -0800 (PST)
Date: Mon, 15 Jan 2024 16:56:25 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 12/15] RISC-V: KVM: Allow Zvfh[min] extensions for
 Guest/VM
Message-ID: <20240115-51aee57d7e62ee212cc86f31@orel>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
 <20231128145357.413321-13-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128145357.413321-13-apatel@ventanamicro.com>

On Tue, Nov 28, 2023 at 08:23:54PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zvfh[min] extensions for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 2 ++
>  arch/riscv/kvm/vcpu_onereg.c      | 4 ++++
>  2 files changed, 6 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

