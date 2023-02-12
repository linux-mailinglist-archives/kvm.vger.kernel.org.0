Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94686939D0
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBLU1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 15:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBLU1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 15:27:15 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A5CDFD;
        Sun, 12 Feb 2023 12:27:14 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id j6-20020a9d7686000000b0068d4ba9d141so3179431otl.6;
        Sun, 12 Feb 2023 12:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dk5S206pxPvym3xCCjYF+uHuwXiN4CTZexHUkuUVlL0=;
        b=BkvWWjy29hekovMbR05VCnxtmmiqHzgJFxZsZMmz3HAdLWdOy6Te70FO7t83mydCbb
         68NS2nGLRFyLOi1AXKQuUgDkHqsvit1DOJ+qELarkZg3HsXiuc2o/Z9Lz9RAAMcBwA2w
         H4IDjEfvoTG9a7p+L9vYyQUc5ZOlu+Yj/80A39ewbcF3o6tbnfrdbR7bmv4aoU73mmsA
         QvJj7wsQhylsGv/QVdBCAAugVHldYPpBCtKdvGFi/AyOiNEKjGpulCQIYX3GsRP4lsl7
         QBIKugVuQ+V7h6JqjB2cEUlBcfqAcevbw2d3lOYTJRUxR7B4sWeiwkqpvBjQ+0kubh0Z
         +ekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dk5S206pxPvym3xCCjYF+uHuwXiN4CTZexHUkuUVlL0=;
        b=0PNuBpf/MeoXNb8HTrhqCO2ADIMEeeFQ0xIsU+UrAoE8yIWd9sFXLNsjF2XQXfRUrS
         f+TUk+UTpchH2i1EkQ9MadK9I11UvFpzpfZGQBxsJSeGBoIPB8AMdbeVnQkoVPx+3MM6
         xAb78YechKOi0hHLOl89t3WX9ZaZSt/Rpn7UGoj+yPh8tQ0EJ9cLluLKLU+SWfyh0pLb
         wFDh4aV35Etzd7i2sh9b8/c8E10Md1ZhIzFR+J4FQliFWAkBROnu28Zo6hwcna6bRN4W
         bAPOcfPsO8GJERC5JNnUlFaSEWfKUD3A3U/I3CdoTFJAgpPtnGhNobyx8od0taOxWy8c
         JA9g==
X-Gm-Message-State: AO0yUKUKFA0OtoncHiT/kT+RDCxIu5O6WRrbJbvFddc0AK6SDVqTil49
        i7AhO+QbxKJZy98Phku69fk=
X-Google-Smtp-Source: AK7set9bHXANyzTUjtfbv69H15km2KSJHo87Tw2dJtJl7ARqLSH5/3O8ywMnqkzRUNz5akIT3YBN5w==
X-Received: by 2002:a9d:1b4c:0:b0:68b:bb82:a937 with SMTP id l70-20020a9d1b4c000000b0068bbb82a937mr12681699otl.34.1676233633999;
        Sun, 12 Feb 2023 12:27:13 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v17-20020a056830141100b0068be5a28b52sm4434983otp.66.2023.02.12.12.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 12:27:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <89c99d4a-8f0a-4e7e-9f93-2dc9f881ab9f@roeck-us.net>
Date:   Sun, 12 Feb 2023 12:27:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net> <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud> <Y+kcgcncQO/2DNLo@spud> <Y+kqi8bQE+8hLfOF@spud>
 <a059a815-dcb0-c575-b5a4-f9433e268e9b@roeck-us.net> <Y+kt04c1iRlzUNLA@spud>
 <48d2ac96-abdd-23bc-b167-08dc2c1a1dbe@roeck-us.net> <Y+kzy1y3Z3j3Ohs9@spud>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
In-Reply-To: <Y+kzy1y3Z3j3Ohs9@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/23 10:45, Conor Dooley wrote:
...
> 
>> However, I still see that the patch series
>> results in boot hangs with the sifive_u qemu emulation, where
>> the log ends with "Oops - illegal instruction". Is that problem
>> being addressed as well ?
> 
> Hmm, if it died on the last commit in this series, then I am not sure.
> If you meant with riscv/for-next or linux-next that's fixed by a patch
> from Samuel:
> https://patchwork.kernel.org/project/linux-riscv/patch/20230212021534.59121-3-samuel@sholland.org/
> 

It failed after the merge, so it looks like it may have been merge damage.

Anyway, I applied

RISC-V: Don't check text_mutex during stop_machine
riscv: Fix early alternative patching
riscv: Fix Zbb alternative IDs

and the sifive_u emulation no longer crashes. However, I still get

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:71 patch_insn_write+0x222/0x2f6

repeated several times.

I then also tested

riscv: patch: Fixup lockdep warning in stop_machine
riscv: Fix early alternative patching
riscv: Fix Zbb alternative IDs

which works fine (no warning backtrace) for sifive_u, but gives me

WARNING: CPU: 0 PID: 0 at kernel/trace/trace_events.c:433 trace_event_raw_init+0xde/0x642

and a whole lot of

event btrfs_clear_extent_bit has unsafe dereference of argument 1

and similar messages when running the "virt" emulation. That was there before,
but drowned in the noise. Ok, guess I'll need another round of bisect.

Guenter

