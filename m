Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF9C7D2F77
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjJWKIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 06:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjJWKIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 06:08:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D9DA
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:08:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9bf941607d4so93414866b.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 03:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698055707; x=1698660507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1aEOfuIyiwkOnqlQnKYH2Ng5EBPcZk7vfkvoKG6EFyM=;
        b=tthll7qrPLWYb5bp/TNK3iB1mja4LCgJTBjBgfF6PXf8JkoVIovDMpL0tjv2Hezvsa
         28AIKGn9YfDrpJTl102HX+LF2CzQq6xkqoGdwPoA6d5blR6r9bYjJrdFWmnILYpEJl1/
         Vp91LzOD01OPQp+rp5sNNwSX7+YLddGWuUT8SUzyX/9J0N9SHCy2M4S8XBLh4Ky5rzCg
         hS0lQhGa0jnGnkmOPB/HJc5xx+qdlW+Qpn6O5wdekf+FIotGmm76sbnpY34nZGgixLfs
         aoI4SNadY2peAP7linbc7aoh4tIW2uJ5f1v9syTmC7TkkE/iB0s6dk//Ih3AF3y1qC/d
         Yixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055707; x=1698660507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1aEOfuIyiwkOnqlQnKYH2Ng5EBPcZk7vfkvoKG6EFyM=;
        b=VY8Rp7K/nEfMhFCP+wc3HftiAocT7obJ7e3Jgk8nR6C2DP0cXi73UILHzkX0zrwDEn
         8fh3JFHDOimvT0+JvX5l1FQLNnWmnO/C1MoLLnFVtSYWKudYC4UCIPa7zSTN15hhpDtH
         cwPLD8/2E+9764NOOHWnrNnal+rjz6DSdkceQTg3ScsQ8bGW/5TijGwu9sACBA0j/WbV
         qIoSzvXQtd/HMC841pRNVjr5Kk2vaImbinSJfVSnu4t13f0JzLYHyA0g5QJ/ocZ88Io8
         qt3TnOuBb93fCtSI/SdZJps7eiE1SZsgQ7QB2F6jxn6OaO4bXt2rMka1elVi88Z14awk
         vitg==
X-Gm-Message-State: AOJu0YwqZMkTxyeTGeeZfe6nOCupEMXobfk8nrEiK7s4Vh5Gq6fiFpYN
        ei1CxUK+AKk6CrNUeKuQP/k9k5oSUdYvlqn7vgZbbw==
X-Google-Smtp-Source: AGHT+IF0AGitdQJUS/4bR8okkah9gJ8ur6YNsJ9+3rz+vlExwWE6UKBsdxQZQMbHsSgKlRITPAhqDQ==
X-Received: by 2002:adf:a30e:0:b0:32d:c312:49af with SMTP id c14-20020adfa30e000000b0032dc31249afmr5895229wrb.6.1698055686818;
        Mon, 23 Oct 2023 03:08:06 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:17bb:4fd9:531:a7cc? ([2a01:e0a:999:a3a0:17bb:4fd9:531:a7cc])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d628d000000b0032daf848f68sm7437719wru.59.2023.10.23.03.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 03:08:06 -0700 (PDT)
Message-ID: <435519d9-e569-4714-b50b-f46ac281478e@rivosinc.com>
Date:   Mon, 23 Oct 2023 12:08:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-3-cleger@rivosinc.com>
 <20231023-136cad6e15a2c5c27b6176af@orel>
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20231023-136cad6e15a2c5c27b6176af@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/10/2023 11:59, Andrew Jones wrote:
> On Wed, Oct 04, 2023 at 04:30:51PM +0200, Clément Léger wrote:
> ...
>> diff --git a/arch/riscv/lib/memmove.S b/arch/riscv/lib/memmove.S
>> index 1930b388c3a0..5130033e3e02 100644
>> --- a/arch/riscv/lib/memmove.S
>> +++ b/arch/riscv/lib/memmove.S
>> @@ -7,7 +7,6 @@
>>  #include <asm/asm.h>
>>  
>>  SYM_FUNC_START(__memmove)
>> -SYM_FUNC_START_WEAK(memmove)
>>  	/*
>>  	 * Returns
>>  	 *   a0 - dest
>> @@ -314,5 +313,6 @@ SYM_FUNC_START_WEAK(memmove)
>>  
>>  SYM_FUNC_END(memmove)
> 
> Should this one above be removed?

Hugh :/ yeah, thanks for catching this.

> 
>>  SYM_FUNC_END(__memmove)
>> +SYM_FUNC_ALIAS_WEAK(memmove, __memmove)
>>  SYM_FUNC_ALIAS(__pi_memmove, __memmove)
>>  SYM_FUNC_ALIAS(__pi___memmove, __memmove)
>> diff --git a/arch/riscv/lib/memset.S b/arch/riscv/lib/memset.S
>> index 34c5360c6705..35f358e70bdb 100644
>> --- a/arch/riscv/lib/memset.S
>> +++ b/arch/riscv/lib/memset.S
>> @@ -8,8 +8,7 @@
>>  #include <asm/asm.h>
>>  
>>  /* void *memset(void *, int, size_t) */
>> -ENTRY(__memset)
>> -WEAK(memset)
>> +SYM_FUNC_START(__memset)
>>  	move t0, a0  /* Preserve return value */
>>  
>>  	/* Defer to byte-oriented fill for small sizes */
>> @@ -110,4 +109,5 @@ WEAK(memset)
>>  	bltu t0, a3, 5b
>>  6:
>>  	ret
>> -END(__memset)
>> +SYM_FUNC_END(__memset)
>> +SYM_FUNC_ALIAS_WEAK(memset, __memset)
>> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
>> index 09b47ebacf2e..3ab438f30d13 100644
>> --- a/arch/riscv/lib/uaccess.S
>> +++ b/arch/riscv/lib/uaccess.S
>> @@ -10,8 +10,7 @@
>>  	_asm_extable	100b, \lbl
>>  	.endm
>>  
>> -ENTRY(__asm_copy_to_user)
>> -ENTRY(__asm_copy_from_user)
>> +SYM_FUNC_START(__asm_copy_to_user)
>>  
>>  	/* Enable access to user memory */
>>  	li t6, SR_SUM
>> @@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
>>  	csrc CSR_STATUS, t6
>>  	sub a0, t5, a0
>>  	ret
>> -ENDPROC(__asm_copy_to_user)
>> -ENDPROC(__asm_copy_from_user)
>> +SYM_FUNC_END(__asm_copy_to_user)
>>  EXPORT_SYMBOL(__asm_copy_to_user)
>> +SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)
> 
> IIUC, we'll only have debug information for __asm_copy_to_user. I'm not
> sure what that means for debugging. Is it possible to generate something
> confusing?

I'll check that with GDB to be sure we don't have anything fancy here.

> 
>>  EXPORT_SYMBOL(__asm_copy_from_user)
>>  
>>  
>> -ENTRY(__clear_user)
>> +SYM_FUNC_START(__clear_user)
>>  
>>  	/* Enable access to user memory */
>>  	li t6, SR_SUM
>> @@ -233,5 +232,5 @@ ENTRY(__clear_user)
>>  	csrc CSR_STATUS, t6
>>  	sub a0, a3, a0
>>  	ret
>> -ENDPROC(__clear_user)
>> +SYM_FUNC_END(__clear_user)
>>  EXPORT_SYMBOL(__clear_user)
>> diff --git a/arch/riscv/purgatory/entry.S b/arch/riscv/purgatory/entry.S
>> index 0194f4554130..7befa276fb01 100644
>> --- a/arch/riscv/purgatory/entry.S
>> +++ b/arch/riscv/purgatory/entry.S
>> @@ -7,15 +7,11 @@
>>   * Author: Li Zhengyu (lizhengyu3@huawei.com)
>>   *
>>   */
>> -
>> -.macro	size, sym:req
>> -	.size \sym, . - \sym
>> -.endm
>> +#include <linux/linkage.h>
>>  
>>  .text
>>  
>> -.globl purgatory_start
>> -purgatory_start:
>> +SYM_CODE_START(purgatory_start)
>>  
>>  	lla	sp, .Lstack
>>  	mv	s0, a0	/* The hartid of the current hart */
>> @@ -28,8 +24,7 @@ purgatory_start:
>>  	mv	a1, s1
>>  	ld	a2, riscv_kernel_entry
>>  	jr	a2
>> -
>> -size purgatory_start
>> +SYM_CODE_END(purgatory_start)
>>  
>>  .align 4
>>  	.rept	256
>> @@ -39,9 +34,8 @@ size purgatory_start
>>  
>>  .data
>>  
>> -.globl riscv_kernel_entry
>> -riscv_kernel_entry:
>> +SYM_DATA_START(riscv_kernel_entry)
>>  	.quad	0
>> -size riscv_kernel_entry
>> +SYM_DATA_END(riscv_kernel_entry)
> 
> I think we could also use the shorthand version for this one-liner.
> 
> SYM_DATA(riscv_kernel_entry, quad 0)

Oh yes, nice catch.

Thanks,

Clément

> 
> Thanks,
> drew
