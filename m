Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E92DB42C
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 20:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbgLOTBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 14:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbgLOTAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 14:00:47 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD74C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 11:00:07 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i9so20940637wrc.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 11:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aT1PJnajciJE2dqCzWg1aHs1GZklEjKsUm8z46pbejA=;
        b=QhXRaJPhkgfnd4SaaKWQHSeaEei8xLWzw26Hp1K18TR9ajmV5Ej+vX/MFZphop4cfv
         giQ55k5XtkD+5gvJkKcNKxtW5mnrM7Jjrli8W4iAr3poOwDBYYFwRYHYG00WUoWuIYm6
         DJOVV8x9fy/okGU+sRDOcFfYgd6rBLjm31R7PStE+q6v0DNV3H4AVXp/UCcIqrDZhQNa
         5CL8sE5Dtuh8iO3fpV8zmUmZMDF9FKQNVhmBDtRsvtmuRpcibDygXoL1ZjijMeCEWWjh
         rCQvln2NZYCE1DFYJEbMGTa2/FnD7Mk+tBhnJGsiBxe674LnTo6gRPe1FebOAZl5sRXM
         FfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aT1PJnajciJE2dqCzWg1aHs1GZklEjKsUm8z46pbejA=;
        b=YZ2TldLB+hT9jq1dJGMyDoignqdhjkjAdt8f9vhLsJG00ulyjIQ52XUuKVZUUWcPDJ
         q+tg/dhxbBDYo69vJ9dY5T1YSWNnjyNlthN04gODsrnxAE2aQZSy4DzViwacvzWYGEDF
         2kOxJmIh96gDq76kh+Q5lk02dtwx/3neJ8rpjD4/Y4eB2U4A2c5CapF9KChMOjxzN4KR
         3tLU4z5awXyvb4O2HpSEGd0yiktdAA6gZ+cbqoDlTvujDnxhr+sUc1iMk/naRr7a8EQO
         kHwJ2RwfK2Fkw1EqEg0ajJZ78UX6UjYWaA+sdLIfVb6W+v+Kc6pbkyxCiF+PJ6prt5yT
         FTow==
X-Gm-Message-State: AOAM530URHg/LkDD6c7lHP/N8zBStLp2NRT1E1He0xpCLmyOiyva19iu
        nOqp8wNP3ff7wiJzZRuzf+FXBkrp2O8y5g==
X-Google-Smtp-Source: ABdhPJy6HQrXfvvj6hsfog09rPzxtPJZNP7hh1tKQMxkQQLMl4O/dCQKEgV1zkhWR3+b6xZ27H22xw==
X-Received: by 2002:adf:b343:: with SMTP id k3mr34730670wrd.202.1608058803884;
        Tue, 15 Dec 2020 11:00:03 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id d191sm37510180wmd.24.2020.12.15.11.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 11:00:02 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 00/16] target/mips: Boring code reordering + add
 "translate.h"
To:     qemu-devel@nongnu.org, no-reply@patchew.org
Cc:     aleksandar.rikalo@syrmia.com, kvm@vger.kernel.org,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com, laurent@vivier.eu,
        pbonzini@redhat.com, aurelien@aurel32.net
References: <160804228706.20355.2388937911912422319@600e7e483b3a>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <e7d7154a-c9d9-5d91-9601-3e7d2c36c383@amsat.org>
Date:   Tue, 15 Dec 2020 20:00:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160804228706.20355.2388937911912422319@600e7e483b3a>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 3:24 PM, no-reply@patchew.org wrote:
> Patchew URL: https://patchew.org/QEMU/20201214183739.500368-1-f4bug@amsat.org/
> 
> 
> === OUTPUT BEGIN ===
> 1/16 Checking commit 02da9907b334 (target/mips: Inline cpu_state_reset() in mips_cpu_reset())
> 2/16 Checking commit a129631d782b (target/mips: Extract FPU helpers to 'fpu_helper.h')
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #42: 
> new file mode 100644
> 
> total: 0 errors, 1 warnings, 193 lines checked
> 
> Patch 2/16 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 3/16 Checking commit 8a5a0b7f9c26 (target/mips: Add !CONFIG_USER_ONLY comment after #endif)
> 4/16 Checking commit d10b7c71feb1 (target/mips: Remove consecutive CONFIG_USER_ONLY ifdefs)
> 5/16 Checking commit 051e87cd7a13 (target/mips: Extract common helpers from helper.c to common_helper.c)
> ERROR: space prohibited after that '&' (ctx:WxW)
> #41: FILE: target/mips/cpu.c:53:
> +    cu = (v >> CP0St_CU0) & 0xf;
>                            ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #42: FILE: target/mips/cpu.c:54:
> +    mx = (v >> CP0St_MX) & 0x1;
>                           ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #43: FILE: target/mips/cpu.c:55:
> +    ksu = (v >> CP0St_KSU) & 0x3;
>                             ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #70: FILE: target/mips/cpu.c:82:
> +        uint32_t ksux = (1 << CP0St_KX) & val;
>                                          ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #78: FILE: target/mips/cpu.c:90:
> +        mask &= ~(((1 << CP0St_SR) | (1 << CP0St_NMI)) & val);
>                                                         ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #105: FILE: target/mips/cpu.c:117:
> +        mask &= ~((1 << CP0Ca_WP) & val);
>                                    ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #110: FILE: target/mips/cpu.c:122:
> +    if ((old ^ env->CP0_Cause) & (1 << CP0Ca_DC)) {
>                                 ^
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #120: FILE: target/mips/cpu.c:132:
> +        if ((old ^ env->CP0_Cause) & (1 << (CP0Ca_IP + i))) {
>                                     ^
> 
> total: 8 errors, 0 warnings, 433 lines checked
> 
> Patch 5/16 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.

All pre-existing issues (code moved).
