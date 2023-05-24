Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC870EA6E
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 02:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbjEXAtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 20:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEXAtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 20:49:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D24B5
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:00 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d247a023aso134464b3a.2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 17:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1684889339; x=1687481339;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dp6b6qpXLo/rFQA8s6ahM6DqwTPLqjamQPaZIhADAjA=;
        b=URl8uA+bSGSybCrhjFclHgZOt6EC/1LxDU/Rk7ox81s+nh0+YhJOdKZ5ZbQL2aDInL
         5QJdQHlk6F43CcdF6+8CglkmZTVfZ0M+lSKRP6Nux4AUbkRa1UzaoTfagFbt+W2QN2NT
         OOnImte4yGViztPe4v/WB9cMHwGUaMdb1MfxqCroVVcwrWE8HVlxF0Gzx1Spa7HwqjOZ
         ddP45WQ2wKiSRVSSbX3FXAP9i/AUubXtI2PeP656MkqLbacnCAExyFz35GMWY8uJEVBi
         Hi8EGSIBcFX+cLoxC4oO1dhbEaIdKTdJQVqwpuYdMk9XdbMhAKbYwiZPmkDTNOaXIJnB
         UDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684889339; x=1687481339;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dp6b6qpXLo/rFQA8s6ahM6DqwTPLqjamQPaZIhADAjA=;
        b=F8FzS2nNgaHnNkMYP3YULwOCkW4YpsHScvf49T5CTFtfNXJJoDqOO7AilcHpxs9ucv
         uGDJMaOj0dYSFqTll+kQerUt7sQ4sjUXmhtYORetYPU3RtReth+6QmQdPjwb6UOQwFj0
         LYLZYZuwnXvfwJh5V6L0kZd3T2NJh8FvwHkiqsip7O5BwMAt0aRazu/wTaPfAnAvet41
         Qmdj5f7UmTlv+qF3CT0IAiHfeaiKmOjmF6QrmX0booECEDb+9sxX3lCZ9Sq9xhssT+s8
         GcEp9ZVXAIt81yUK0EgHzOdmZGjAXUCYYKeTGj7fBaG2oXGLkwtNCEQdW8dYl3Z+ydEY
         tTRA==
X-Gm-Message-State: AC+VfDxGIIqdgjOvJToOaoA/Fp+DeZ+si0TsboXR2SYT7fvgAQU6u0ny
        daizfnuAUvaiheN6OgEnITfA2w==
X-Google-Smtp-Source: ACHHUZ4lorfrMhpgOfVECnAIZqBlitQ4EC4P7SnjzcWdlV4otb5oENm9aUBrEzeFWzAAKtm03sRgKQ==
X-Received: by 2002:a05:6a00:14cb:b0:64c:ecf7:f492 with SMTP id w11-20020a056a0014cb00b0064cecf7f492mr1215212pfu.4.1684889339259;
        Tue, 23 May 2023 17:48:59 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id u21-20020aa78395000000b0064f39c6474fsm1910643pfm.56.2023.05.23.17.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 17:48:58 -0700 (PDT)
Date:   Tue, 23 May 2023 17:48:58 -0700 (PDT)
X-Google-Original-Date: Tue, 23 May 2023 17:26:06 PDT (-0700)
Subject:     Re: [PATCH -next v20 03/26] riscv: hwprobe: Add support for probing V in RISCV_HWPROBE_KEY_IMA_EXT_0
In-Reply-To: <20230518161949.11203-4-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        andy.chiu@sifive.com, corbet@lwn.net,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu,
        Conor Dooley <conor.dooley@microchip.com>,
        Evan Green <evan@rivosinc.com>, ajones@ventanamicro.com,
        abrestic@rivosinc.com, coelacanthus@outlook.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-3514bc07-d24f-474b-994f-b2b03253e103@palmer-ri-x1c9a>
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

On Thu, 18 May 2023 09:19:26 PDT (-0700), andy.chiu@sifive.com wrote:
> Probing kernel support for Vector extension is available now. This only
> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
> Changelog v20:
>  - Fix a typo in document, and remove duplicated probes (Heiko)
>  - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
>    Evan)
> ---
>  Documentation/riscv/hwprobe.rst       | 3 +++
>  arch/riscv/include/uapi/asm/hwprobe.h | 1 +
>  arch/riscv/kernel/sys_riscv.c         | 4 ++++
>  3 files changed, 8 insertions(+)
>
> diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
> index 9f0dd62dcb5d..7431d9d01c73 100644
> --- a/Documentation/riscv/hwprobe.rst
> +++ b/Documentation/riscv/hwprobe.rst
> @@ -64,6 +64,9 @@ The following keys are defined:
>    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>      by version 2.2 of the RISC-V ISA manual.
>
> +  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as defined by
> +    version 1.0 of the RISC-V Vector extension manual.
> +
>  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>    information about the selected set of processors.
>
> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
> index 8d745a4ad8a2..7c6fdcf7ced5 100644
> --- a/arch/riscv/include/uapi/asm/hwprobe.h
> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> @@ -25,6 +25,7 @@ struct riscv_hwprobe {
>  #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
>  #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
>  #define		RISCV_HWPROBE_IMA_C		(1 << 1)
> +#define		RISCV_HWPROBE_IMA_V		(1 << 2)
>  #define RISCV_HWPROBE_KEY_CPUPERF_0	5
>  #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
>  #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
> diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
> index 5db29683ebee..88357a848797 100644
> --- a/arch/riscv/kernel/sys_riscv.c
> +++ b/arch/riscv/kernel/sys_riscv.c
> @@ -10,6 +10,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/hwprobe.h>
>  #include <asm/sbi.h>
> +#include <asm/vector.h>
>  #include <asm/switch_to.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
>  		if (riscv_isa_extension_available(NULL, c))
>  			pair->value |= RISCV_HWPROBE_IMA_C;
>
> +		if (has_vector())
> +			pair->value |= RISCV_HWPROBE_IMA_V;
> +
>  		break;
>
>  	case RISCV_HWPROBE_KEY_CPUPERF_0:

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
