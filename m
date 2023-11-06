Return-Path: <kvm+bounces-813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C56D57E2B6F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FB48281829
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B752C86F;
	Mon,  6 Nov 2023 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="CVf3bS1o"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D832C863
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:47:35 +0000 (UTC)
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792CD49
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 09:47:34 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-5842a94feb2so2716837eaf.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 09:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1699292853; x=1699897653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FK4uYtCWASAh5nxvSUgk2a3NS0yQI0Q/PF/dmiOH8ms=;
        b=CVf3bS1oPIgRR9WwVZ5J8LnqOWTeY9j54x6syDdFN6J7Cru0+B7H9amudVbyYleG4k
         teHmCqSCTSPctdUlV7FP0yNGEfKUbDknSvX26GlO6Gx+EXvsNQlU1IlFjLCcyI0361i5
         W+QkDA9hUKl7YIGyJAP7VNTu6/4alkzSnWiFBWh8zYrfSfGrlY3GTqUgGQ5s1C0pf5ar
         FfIQlTGbUDLH5RHEtNQs3zfYugzPXGmhvLY1mDJ9Hze+J/YMw3higmwmJaGSRhGbwo2l
         Y0Wt8xoQt//zEWgeVsAeB7uTIBU1bCClq+FUI7K6pLGC8STcdvnxjKQui8IQFsKdggpW
         o8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699292853; x=1699897653;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FK4uYtCWASAh5nxvSUgk2a3NS0yQI0Q/PF/dmiOH8ms=;
        b=FPmU7hTY4FFPtdVqenwH5C6u/4fDwu4jnzj/I/SQQjxBXs3g1SM18UHgf05YVYdawm
         RfZ0nG9s8UyqWeHelOgVN7PWUGh5yzbIXBHHsMolA9fCrI+YSSHJmpcfm/qByu2fXY/r
         szKcNfiba7RARFYaqnoRmHB73CdXdJ469w/Zhf13kfDYVEwcHJDXDM0LcF0WfbMVot5r
         XsQ8WRMB28iN2vAO9h9NXUJKXgw//n3CfZlIIDMPv3oLSRIn44Sm90lRy568CpmLCsCW
         kOtSsl4rfgzi1VUZKPGxT3uclTBQr41IaEUZ2dsG8dB6RX5onlvXlOhy6MUD34s3GSUR
         Awtg==
X-Gm-Message-State: AOJu0YzxA2t31VxrieFv6oD5tlXMSreeDKQ83agKyArE7melr2tEHbcK
	NZS/1Tt6Mx12BH8CLu7f6OZXGA==
X-Google-Smtp-Source: AGHT+IFGSnSfFc6b5MBPxmnaVZPt275KPab3iutOmg8Iu0JyM8F+e9ss29YnSmuuK35tariXtn+E0g==
X-Received: by 2002:a05:6870:6b09:b0:1f0:cef:6a45 with SMTP id mt9-20020a0568706b0900b001f00cef6a45mr411591oab.56.1699292851972;
        Mon, 06 Nov 2023 09:47:31 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id ec29-20020a0568708c1d00b001e9ce1b5e8fsm1473031oab.15.2023.11.06.09.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 09:47:31 -0800 (PST)
Date: Mon, 06 Nov 2023 09:47:31 -0800 (PST)
X-Google-Original-Date: Mon, 06 Nov 2023 09:40:42 PST (-0800)
Subject:     Re: [PATCH v2 5/5] riscv: kvm: use ".L" local labels in assembly when applicable
In-Reply-To: <20231024132655.730417-6-cleger@rivosinc.com>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com, cleger@rivosinc.com,
  linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
  kvm-riscv@lists.infradead.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: cleger@rivosinc.com
Message-ID: <mhng-467ba655-d75b-4197-b3cb-4b3f97ff0d26@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 24 Oct 2023 06:26:55 PDT (-0700), cleger@rivosinc.com wrote:
> For the sake of coherency, use local labels in assembly when
> applicable. This also avoid kprobes being confused when applying a
> kprobe since the size of function is computed by checking where the
> next visible symbol is located. This might end up in computing some
> function size to be way shorter than expected and thus failing to apply
> kprobes to the specified offset.
>
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_switch.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 8b18473780ac..0c26189aa01c 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -45,7 +45,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
>  	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
>  	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -	la	t4, __kvm_switch_return
> +	la	t4, .Lkvm_switch_return
>  	REG_L	t5, (KVM_ARCH_GUEST_SEPC)(a0)
>
>  	/* Save Host and Restore Guest SSTATUS */
> @@ -113,7 +113,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>
>  	/* Back to Host */
>  	.align 2
> -__kvm_switch_return:
> +.Lkvm_switch_return:
>  	/* Swap Guest A0 with SSCRATCH */
>  	csrrw	a0, CSR_SSCRATCH, a0

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

