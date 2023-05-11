Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7471F6FFCDC
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbjEKW4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjEKW4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE6E59DA
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-643465067d1so6897339b3a.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845795; x=1686437795;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MA1nswhDybe/fzweVUsYHGyIgEVjExjicpJMHqrU66E=;
        b=NIVna15OVrvGXBv6dEhCTFGd32wBt2X7OtlAKwkKBbn399+G2TJW7noXJCJYBs5eYg
         BHSwa+Tql6RDR7ui0va7rZbQ6B2YgURvGhe9VrjJOeMiH8DfKc93hnzDLOySuLTo47jV
         pPg1I7xOOQz5HWKiC4rxTYV7kAX4+YBikhNXvjHjOxJ3s5hjf18Pxau2jbIgwDjbgP6l
         AZROf/paCxflYrGboRuAfdTz8tddgNgnN3g+m76zV+L9Be5ubMM7U2q+RFFydkBCRF/+
         S2QK1kuVI2M1VbZ0DgnfTn7FxYA2NqYDoxpwX3vumSnF3KC72Y+rL5UO4Mf1qJihVpBa
         4w2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845795; x=1686437795;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MA1nswhDybe/fzweVUsYHGyIgEVjExjicpJMHqrU66E=;
        b=kN38lBNPAQ2kODUlc7I2zqZtDMVKRWP5nI37TL/iQ7wX/uNKp/ggwtdgLZOob1e7pz
         Na9ViQuG6jZEzBjVs8DMIl3qeiWn5llGAGJeXhtHzMnuIdrlGCQhRfRDnqpnk36QNTb6
         REljGUHXEjvbmc/9d+4d53tvbzFaDMWn/1/V0lbTdG42p/Pp90xdcPqwY40/A3jXlrKy
         GCEGD3H2p7vjiEcPN3YnQWo+MmKPqrkCV/qhCMS35Sa7JzgKHDOcVBUV/DHqUaMQaqov
         gYSJzz3qoxo2I5Tp1I8NdJTGTmpmSZuvUgQ7NSfs48pUAdjqXNJbWRat5E6YWA/DTZd1
         wwaA==
X-Gm-Message-State: AC+VfDxUyjNMhr/pfGP5GzDC+FSb++TKNk9AtKpv3+KEPa6V60VX1bga
        JDFo7NSJMHwWGZsVYTZRI/6EkA==
X-Google-Smtp-Source: ACHHUZ40Y3W6oug6oNeWAtZ+sD6wlkkIGjUUG0QYhcZI220ckWSrNtffjMK1bDVkVTbQjHiktnAR0A==
X-Received: by 2002:a05:6a21:3284:b0:100:9a80:2e90 with SMTP id yt4-20020a056a21328400b001009a802e90mr19820400pzb.59.1683845794654;
        Thu, 11 May 2023 15:56:34 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id r185-20020a632bc2000000b00528af015a8dsm5452388pgr.14.2023.05.11.15.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:34 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:34 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:38:26 PDT (-0700)
Subject:     Re: [PATCH -next v19 01/24] riscv: Rename __switch_to_aux() -> fpu
In-Reply-To: <20230509103033.11285-2-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        ren_guo@c-sky.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu, guoren@kernel.org,
        Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-b8482399-b363-402b-b095-ce1b1dc1fe71@palmer-ri-x1c9a>
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

On Tue, 09 May 2023 03:30:10 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>
> The name of __switch_to_aux() is not clear and rename it with the
> determine function: __switch_to_fpu(). Next we could add other regs'
> switch.
>
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  arch/riscv/include/asm/switch_to.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
> index 60f8ca01d36e..4b96b13dee27 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -46,7 +46,7 @@ static inline void fstate_restore(struct task_struct *task,
>  	}
>  }
>
> -static inline void __switch_to_aux(struct task_struct *prev,
> +static inline void __switch_to_fpu(struct task_struct *prev,
>  				   struct task_struct *next)
>  {
>  	struct pt_regs *regs;
> @@ -66,7 +66,7 @@ static __always_inline bool has_fpu(void)
>  static __always_inline bool has_fpu(void) { return false; }
>  #define fstate_save(task, regs) do { } while (0)
>  #define fstate_restore(task, regs) do { } while (0)
> -#define __switch_to_aux(__prev, __next) do { } while (0)
> +#define __switch_to_fpu(__prev, __next) do { } while (0)
>  #endif
>
>  extern struct task_struct *__switch_to(struct task_struct *,
> @@ -77,7 +77,7 @@ do {							\
>  	struct task_struct *__prev = (prev);		\
>  	struct task_struct *__next = (next);		\
>  	if (has_fpu())					\
> -		__switch_to_aux(__prev, __next);	\
> +		__switch_to_fpu(__prev, __next);	\
>  	((last) = __switch_to(__prev, __next));		\
>  } while (0)

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
