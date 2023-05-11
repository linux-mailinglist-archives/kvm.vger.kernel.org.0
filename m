Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4134D6FFCE0
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239598AbjEKW4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbjEKW4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:43 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E37D84
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-52c759b7d45so8363641a12.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845800; x=1686437800;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoA6b8k+Exd0U0ufbFopUW0n38kOGMTp9KHmkpW9dzI=;
        b=qrg+w43mXU7clXsw1JU/BRCuLPbsg/FmCcLLiKaJVXDkIYdbMcekVSuDyuLYmDnahG
         aoWFJM7XOuhCoL9Kza4Skgt5TvkioLRCHrWGmsJCBNtkgcaENQ9GsdXaDIdqZiLAeLwE
         8JYpHLXpk4TWQwX1qm+LWGUBkDEIkP/kETgzugtuynF+gpW9D2+BBdXIyyt1tMFH8/4e
         WS5N63t3Uod0yqRKPBD/syA2QiwdQ7vcJptcBKfpkSaiBzoPuheeITqblh0BTHLzfsGw
         rdVmkark3KbyPr0v7lnaeGWa6/jgYm23chkJYafV74+GfOgZx1cgoDYz/y+qowq1DKEH
         fCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845800; x=1686437800;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoA6b8k+Exd0U0ufbFopUW0n38kOGMTp9KHmkpW9dzI=;
        b=LVT0Pf1OUJmWQE+F7Y4gfMaKsYhNEKOqDMg8wamEYwXbul9M0u5T2YitPKo4z0QJrw
         91BKTyW6JdQ3AfM5aC4TVVa03okSD3qN0wH7oFUqRl9G1ZBLhmmF9my6MuI8c1uzmD4p
         uv7BtaCojM29gjzCbIzdUiaSWdBw7h9mbMIrjb97gFk+mMWL36zQRrphihIgupXUYJ9q
         AUBp0VHGPYXjiSHXBrivRx2QBifPdWcS2oJC3GQ7Z2tOgCw70DFI303z4GsEPQMF58xq
         Z5fQH0cknPl6zDiHNbeuF/S3LWDnZeBdtCes0yhoaJ+XeI5nSWuR1lVE0eByRpW9kPPv
         EBpg==
X-Gm-Message-State: AC+VfDzKSU1lzljHTBfA/YQmMo5EngOQaXtdhHezymx8MRzQCp2Dk/up
        wT810506AhdftMhfKD290LCAfg==
X-Google-Smtp-Source: ACHHUZ5OGGMA5JrZRcx4jC9eIvp8g6pxmJp1IrLfjtc8RKi7zlEHsQENCKnr0SrmKfxQMxxPtiUtlQ==
X-Received: by 2002:a17:903:48e:b0:1a9:baa4:8675 with SMTP id jj14-20020a170903048e00b001a9baa48675mr24340818plb.1.1683845800333;
        Thu, 11 May 2023 15:56:40 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902d3cc00b001ac8cd5ecd6sm6457482plb.65.2023.05.11.15.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:39 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:39 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:48:04 PDT (-0700)
Subject:     Re: [PATCH -next v19 06/24] riscv: Disable Vector Instructions for kernel itself
In-Reply-To: <20230509103033.11285-7-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, hankuan.chen@sifive.com,
        andy.chiu@sifive.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, guoren@kernel.org, nsaenzju@redhat.com,
        jszhang@kernel.org, Bjorn Topel <bjorn@rivosinc.com>,
        frederic@kernel.org, abrestic@rivosinc.com,
        heiko.stuebner@vrull.eu, alex@ghiti.fr, masahiroy@kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-6d02bea7-ef2c-4840-96e3-912bfac4ffc4@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:15 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
>
> Disable vector instructions execution for kernel mode at its entrances.
> This helps find illegal uses of vector in the kernel space, which is
> similar to the fpu.
>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
> Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
> Changelog V19:
>  - Add description in commit msg (Heiko's suggestion on v17)
>
>  arch/riscv/kernel/entry.S |  6 +++---
>  arch/riscv/kernel/head.S  | 12 ++++++------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 3fbb100bc9e4..e9ae284a55c1 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -48,10 +48,10 @@ _save_context:
>  	 * Disable user-mode memory access as it should only be set in the
>  	 * actual user copy routines.
>  	 *
> -	 * Disable the FPU to detect illegal usage of floating point in kernel
> -	 * space.
> +	 * Disable the FPU/Vector to detect illegal usage of floating point
> +	 * or vector in kernel space.
>  	 */
> -	li t0, SR_SUM | SR_FS
> +	li t0, SR_SUM | SR_FS_VS
>
>  	REG_L s0, TASK_TI_USER_SP(tp)
>  	csrrc s1, CSR_STATUS, t0
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 3fd6a4bd9c3e..e16bb2185d55 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -140,10 +140,10 @@ secondary_start_sbi:
>  	.option pop
>
>  	/*
> -	 * Disable FPU to detect illegal usage of
> -	 * floating point in kernel space
> +	 * Disable FPU & VECTOR to detect illegal usage of
> +	 * floating point or vector in kernel space
>  	 */
> -	li t0, SR_FS
> +	li t0, SR_FS_VS
>  	csrc CSR_STATUS, t0
>
>  	/* Set trap vector to spin forever to help debug */
> @@ -234,10 +234,10 @@ pmp_done:
>  .option pop
>
>  	/*
> -	 * Disable FPU to detect illegal usage of
> -	 * floating point in kernel space
> +	 * Disable FPU & VECTOR to detect illegal usage of
> +	 * floating point or vector in kernel space
>  	 */
> -	li t0, SR_FS
> +	li t0, SR_FS_VS
>  	csrc CSR_STATUS, t0
>
>  #ifdef CONFIG_RISCV_BOOT_SPINWAIT

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
