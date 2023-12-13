Return-Path: <kvm+bounces-4289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44739810A21
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00B4C281E47
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BF2FC00;
	Wed, 13 Dec 2023 06:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hwx4i2gL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9AEEB
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:43 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2cb21afa6c1so76773251fa.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702448202; x=1703053002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71L6UE8bKw9xAm3N5o4/wivq75A3TGoxxbYsqvN4Hr0=;
        b=hwx4i2gLSl4bcvr9DhAI5+kNX6LiOF78YQbCipRICgjWAFcaCaKRchlaqR7KnEx3Bb
         KQq4SL9I9NGxYDfARVmPKv4QrKlL8GzEpIHEB987BqMTKUm0G0IyTxj7SDfAHuYZFVsp
         CDXFZptk515kIOSCkeCdZFQiiKcTjuzW6aMfWjMGGOYrTV1vICIQTDL0jXipdTgv/6eR
         pF15RsJYq3Sup4kb8ZIMafr4BEnmPq7vYZH3HDUnyqVWbgenvw/Ee7dY+tRy46BKCzTy
         7BIUhEUODWOKvbz3Nm+7/C3/k5BOchSZgOy+cDgvzz/PxP7/5Wr4YvvSQhtpf2F3SY4u
         g39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702448202; x=1703053002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71L6UE8bKw9xAm3N5o4/wivq75A3TGoxxbYsqvN4Hr0=;
        b=BQu4dF1Ak43nxIkaRz9tGxljBslYmvGXDS5xwJltNGXnl/lhor3FHkwBOhg2brx64c
         Vp7XtiZm5Bz6XVHnckLaKKj9FdQbmEBXwxZCK6GLAfbvsRTUPie9mgYhLb1sPXzWVBaY
         zUD1GTzN9W+Zv8WPNAkAPK5r7P8SbPEpKetusAsgacx5fI9uohumWMnNShKxEudsNwyj
         jRZ/VzzwkUDmk7q/LZo2L1ubwJNrj9Yejhy6bTBDQgkRFPjssvywZf9Xa3JUXLLlGsDi
         7xdLM1zO0lcD0NB3FvO/S4m6lzDOq9VAc6kkSFeRbvcmGy38YsKtqXvf3KQqv8Krcdwd
         V7cA==
X-Gm-Message-State: AOJu0Yxnt04xGfljX0E3hmU+B/QnEftpKif29sxZDCAltBwoQLOyWzj6
	5gn3CDFmglxalu4LRukkfIrYocpao7iczZrC3dSN3A==
X-Google-Smtp-Source: AGHT+IG/SLo7IZipsDDy7zRrZC+GgAuTAGWON0Bsoqj4uYyJv+RSVk/6F7C6tK2fz6ryDtVCQEYyyNn3PWzHDXcwocU=
X-Received: by 2002:a05:651c:1145:b0:2cc:1ee4:a930 with SMTP id
 h5-20020a05651c114500b002cc1ee4a930mr3971199ljo.106.1702448201538; Tue, 12
 Dec 2023 22:16:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024132655.730417-1-cleger@rivosinc.com> <20231024132655.730417-6-cleger@rivosinc.com>
In-Reply-To: <20231024132655.730417-6-cleger@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 13 Dec 2023 11:46:30 +0530
Message-ID: <CAK9=C2UTww1AcF+U+7MBiT5c7PVtQrQQN=tNszjse+AgJd6xCQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] riscv: kvm: use ".L" local labels in assembly when applicable
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Andrew Jones <ajones@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 6:58=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> For the sake of coherency, use local labels in assembly when
> applicable. This also avoid kprobes being confused when applying a
> kprobe since the size of function is computed by checking where the
> next visible symbol is located. This might end up in computing some
> function size to be way shorter than expected and thus failing to apply
> kprobes to the specified offset.
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Queued this patch for Linux-6.8

Thanks,
Anup


> ---
>  arch/riscv/kvm/vcpu_switch.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 8b18473780ac..0c26189aa01c 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -45,7 +45,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_L   t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
>         REG_L   t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
>         REG_L   t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -       la      t4, __kvm_switch_return
> +       la      t4, .Lkvm_switch_return
>         REG_L   t5, (KVM_ARCH_GUEST_SEPC)(a0)
>
>         /* Save Host and Restore Guest SSTATUS */
> @@ -113,7 +113,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>
>         /* Back to Host */
>         .align 2
> -__kvm_switch_return:
> +.Lkvm_switch_return:
>         /* Swap Guest A0 with SSCRATCH */
>         csrrw   a0, CSR_SSCRATCH, a0
>
> --
> 2.42.0
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

